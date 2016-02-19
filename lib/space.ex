defmodule Space do
  @moduledoc """
  A module to describe the status of a Space API-endpoint. The struct has just
  some elements which could be parsed from every version of the Space API. The
  whole JSON-Respone is stored in _raw_json_.

  * _space_ Name of the space
  * _logo_ URL to the space logo
  * _url_ URL to the space website
  * _location_ Tuple of the latitude and the longitude
  * _state_ Triple of the doorstate (Boolean), the last change timestamp
   (Integer) and an optional message (String)
  * _raw_json_ The response as a map
  """

  defstruct space: "",
            logo: "",
            url:  "",
            location: {0.0, 0.0},
            state: {
              false, # open
              0,     # last change
              ""},   # message
            raw_json: %{}

  @doc """
  Returns the doorstate of a given Space as Boolean.
  """
  @spec is_open?(space: Space) :: true | false
  def is_open?(%Space{state: {door, _, _}}), do: door
end
