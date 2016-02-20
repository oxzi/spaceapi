defmodule SpaceApi.Mixfile do
  use Mix.Project

  def project do
    [app: :spaceapi,
     version: "0.1.0",
     elixir: "~> 1.2",
     description: "A small Elixir package for parsing the Space API",
     package: package,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def application do
    [applications: [:logger]]
  end

  def package do
    [maintainers: ["Alvar Penning"],
     licenses: ["MIT License", "GNU GPLv3"],
     links: %{"GitHub" => "https://github.com/geistesk/spaceapi"}]
  end

  defp deps do
    [{:poison, "~> 2.1"}]
  end
end
