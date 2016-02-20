defmodule SpaceApi do
  alias SpaceApi.Space
  import SpaceApi.JsonParser, only: [parse_json: 2]
  @moduledoc """
  This module provides access to the _from_string_-function.
  """

  @doc """
  A given string (should contain a valid Space API-JSON) will be converted
  into a Space-structure.
  """
  @spec from_string(str: String, space: Space) :: Space
  def from_string(str, space \\ %Space{}) do
    Poison.decode!(str)
    |> parse_json(space)
  end
end
