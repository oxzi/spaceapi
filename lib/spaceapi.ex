defmodule SpaceApi do
  alias SpaceApi.Space

  def from_string(str, space \\ %Space{}) do
    Poison.decode!(str)
    |> parse_json(space)
  end


  # defstruct space: "",
  #           logo: "",
  #           url:  "",
  #           location: {0.0, 0.0},
  #           state: {
  #             false, # open
  #             0,     # last change
  #             ""},   # message
  #           raw_json: %{}

  def parse_json(json, space \\ %Space{}) do
    space_init = %Space{space | raw_json: json}
    parse(Map.keys(json), json, space_init)
  end

  # all: Recursion ends here
  defp parse([], _, space), do: space

  # v0.13: Space/Logo/URL could be used directly
  defp parse([key | keys], json = %{"api" => "0.13"}, space)
  when key in ["space", "logo", "url"] do
    # TODO: don't override space, override 'key'!
    # parse(keys, json, %Space{space | space: Map.get(json, key)})
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
  # v0.13: Create state from state-object
  defp parse(["state" | keys], json = %{"api" => "0.13"}, space) do
    json_state = Map.get(json, "state", %{})
    state = { Map.get(json_state, "open", false),
              Map.get(json_state, "lastchange", 0),
              Map.get(json_state, "messages", "") }
    parse(keys, json, %Space{space | state: state})
  end
  # v0.13: Just jump over the rest…
  defp parse([_key | keys], json = %{"api" => "0.13"}, space) do
    parse(keys, json, space)
  end

end
