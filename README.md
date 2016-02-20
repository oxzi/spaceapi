# SpaceApi

**A small Elixir package for parsing the Space API**

## What?

This small piece of code parses the [Space API](http://spaceapi.net/) for you
into a nice format.

## Installation

First, add _SpaceApi_ to your `mix.exs` dependencies:

```elixir
def deps do
  [{:spaceapi, "~> 0.1.1"}]
end
```

and run `$ mix deps.get`. That's it!

## Usage

This example is fetching the Space API-JSON via
[HTTPoison](https://github.com/edgurgel/httpoison) which is *not* shipped
within _SpaceApi_.

```elixir
HTTPoison.start

resp = HTTPoison.get! "https://hsmr.cc/spaceapi.json"
hsmr = SpaceApi.from_string resp.body

"#{hsmr.space} is " <> case SpaceApi.Space.is_open? hsmr do
  true  -> "open ∩( ・ω・)∩"
  false -> "closed ;_;"
end
```

## License

You are free to use this code under the MIT License or under the GPLv3.
