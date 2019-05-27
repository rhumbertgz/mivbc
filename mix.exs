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
    [{:httpoison, "~> 1.3.1"},
    {:poison, "~> 3.0"}
    ]
  end
end
