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

  test "ensure state._3 is always binary" do
    space = """
            {"state": {"lastchange": 1455997959, "open": true, "message": null},
            "api": "0.13", "location": {"lat": 50.8075289, "lon": 8.7677467,
            "address": "[hsmr] Hackspace Marburg, Am Plan 3, 35037 Marburg, Germany"},
            "open": true, "space": "[hsmr] Hackspace Marburg",
            "url": "https://hsmr.cc/", "logo": "https://hsmr.cc/logo.svg", "sensors":
            {"door_locked": [{"location": "upstairs", "value": false}]},
            "issue_report_channels": ["email", "irc"], "contact":
            {"ml": "public@lists.hsmr.cc", "irc": "ircs://irc.hackint.org:9999/#hsmr",
            "email": "mail@hsmr.cc", "phone": "+49 6421 4924981"}}
            """
            |> Poison.decode!
            |> JsonParser.parse_json

    {true, _, message} = space.state
    assert is_binary(message)
  end
end
