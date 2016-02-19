defmodule SpaceApi.SpaceTest do
  use ExUnit.Case
  alias SpaceApi.Space
  doctest Space

  test "doorstate is_open?" do
    space_default = %Space{} # should be closed by default
    space_closed  = %Space{state: {false, 42, ""}}
    space_opened  = %Space{state: {true, 23, "Linux Install Party"}}

    assert Space.is_open?(space_default) == false
    assert Space.is_open?(space_closed)  == false
    assert Space.is_open?(space_opened)  == true
  end
end
