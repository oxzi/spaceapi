defmodule SpaceApi.JsonParserTest do
  use ExUnit.Case
  alias SpaceApi.Space
  alias SpaceApi.JsonParser
  doctest SpaceApi.JsonParser

  test "v13 example check" do
    space = """
            {
                "api": "0.13",
                "space": "Slopspace",
                "logo": "http://your-space.org/img/logo.png",
                "url": "http://your-space.org",
                "location": {
                    "address": "Ulmer Strasse 255, 70327 Stuttgart, Germany",
                    "lon": 9.236,
                    "lat": 48.777
                },
                "contact": {
                    "twitter": "@spaceapi"
                },
                "issue_report_channels": [
                    "twitter"
                ],
                "state": {
                    "open": true
                }
            }
            """
            |> Poison.decode!
            |> JsonParser.parse_json

    assert space.space == "Slopspace"
    assert space.logo == "http://your-space.org/img/logo.png"
    assert space.url == "http://your-space.org"
    assert space.location == {48.777, 9.236}
    assert Space.is_open?(space) == true
  end

  test "v12 example check" do
    space = """
            {
              "api": "0.12",
              "address": "hurr durr",
              "lat": 49.2323,
              "logo": "https://hurr.durr/logo.png",
              "open": false,
              "icon": {
                "open": "https://hurr.durr/opn.png",
                "closed": "https://hurr.durr/cls.png" },
              "space": "hurr durr",
              "url": "https://hurr.durr/",
              "lon": 16.232323,
              "lastchange": 1381268042
            }
            """
            |> Poison.decode!
            |> JsonParser.parse_json

    assert space.space == "hurr durr"
    assert space.logo == "https://hurr.durr/logo.png"
    assert space.url == "https://hurr.durr/"
    assert space.location == {49.2323, 16.232323}
    assert Space.is_open?(space) == false
  end
end
