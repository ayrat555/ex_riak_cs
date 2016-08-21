defmodule ExRiakCS.Mixfile do
  use Mix.Project

  def project do
    [app: :ex_riak_cs,
     version: "0.1.1",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     package: package(),
     description: "Riak CS API wrapper for Elixir.",
     source_url: "https://github.com/ayrat555/ex_riak_cs"
   ]
  end

  def package do
   [
     maintainers: ["Ayrat Badykov"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/ayrat555"}
   ]
  end


  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :httpoison, :timex]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:httpoison, "~> 0.9.0"},
     {:timex, "~> 3.0"},
     {:credo, "~> 0.4", only: [:dev, :test]},
     {:sweet_xml, "~> 0.6.1"},
     {:ex_doc, "~> 0.12", only: :dev}
    ]
  end
end
