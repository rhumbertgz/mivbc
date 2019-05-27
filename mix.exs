defmodule MIVBC.Mixfile do
  use Mix.Project

  def project do
    [app: :mivbc,
     version: "0.1.2",
     elixir: "~> 1.7",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  def application do
    [applications: [:logger,:httpoison]]
  end

  defp deps do
    [{:httpoison, "~> 1.5.1"},
     {:poison, "~> 4.0.1"}
    ]
  end
end
cf7c31e115fe70c2f18c71d97890cccd
