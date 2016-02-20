defmodule SpaceApi.JsonParser do
  alias SpaceApi.Space
  @moduledoc """
  The decoded JSON-String will be transferred into a SpaceApi.Space-struct here.
  There is only one accessible function: _parse_json/2_
  """

  @doc """
  This function takes a JSON-String which was already transfered into a map
  (like from ""Poison.decode!"") and tries to parse it into a Space-struct.
  The second parameter is optional. If you're passing an existing Space-struct,
  this will be the base for the new one.
  Important: At this moment the latest version of the Space API was 13. So if
  you're going to pass newer code an exception will be raised!
  """
  @spec parse_json(json: map, space: Space) :: Space
  def parse_json(json, space \\ %Space{}) do
    version = Map.get(json, "api")
              |> String.to_float
    if version > 0.13, do:
      raise "The version of this Space API-endpoint is newer than this code!"

    space_init = %Space{space | raw_json: json}
    parse(Map.keys(json), json, space_init)
  end

  # all: Recursion ends here
  defp parse([], _, space), do: space

  # all: Space/Logo/URL could be fetched directly
  defp parse([key | keys], json, space)
  when key in ["space", "logo", "url"] do
    parse(keys, json, %{space | String.to_atom(key) => Map.get(json, key)})
  end

  # v0.13: Grep lat, lon from location
  defp parse(["location" | keys], json = %{"api" => "0.13"}, space) do
    case Map.get(json, "location") do
      %{"lat" => lat, "lon" => lon} ->
        parse(keys, json, %Space{space | location: {lat, lon}})
      _ ->
        parse(keys, json, space)
    end
  end

  # <= v0.12: Parse lat, lon separately
  defp parse([key | keys], json, space) when key in ["lat", "lon"] do
    {lat, lon} = space.location
    case key do
      "lat" ->
        parse(keys, json, %Space{space | location: {Map.get(json, key), lon}})
      "lon" ->
        parse(keys, json, %Space{space | location: {lat, Map.get(json, key)}})
    end
  end

  # v0.13: Create state from state-object
  defp parse(["state" | keys], json = %{"api" => "0.13"}, space) do
    json_state = Map.get(json, "state", %{})
    state = { Map.get(json_state, "open", false),
              Map.get(json_state, "lastchange", 0),
              case Map.get(json_state, "message", "") do
                message when is_binary(message) -> message
                _ -> ""
              end }
    parse(keys, json, %Space{space | state: state})
  end

  # <= v0.12: Fill state based on separate open, lastchange fields
  defp parse([key | keys], json, space) when key in ["open", "lastchange"] do
    {open, lastchange, message} = space.state
    case key do
      "open" ->
        parse(keys, json,
          %Space{space | state: {Map.get(json, key), lastchange, message}})
      "lastchange" ->
        parse(keys, json,
          %Space{space | state: {open, Map.get(json, key), message}})
    end
  end

  # all: Just jump over the rest…
  defp parse([_key | keys], json, space), do: parse(keys, json, space)
end
