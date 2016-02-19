defmodule SpaceApi do
  alias SpaceApi.Space
  import SpaceApi.JsonParser, only: [parse_json: 2]

  def from_string(str, space \\ %Space{}) do
    Poison.decode!(str)
    |> parse_json(space)
  end

end
