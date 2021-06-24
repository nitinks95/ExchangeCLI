defmodule Exchange.MixProject do
  use Mix.Project

  def project do
    [
      app: :exchange,
      version: "0.1.0",
      elixir: "~> 1.10",
      escript: [main_module: Exchange],
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      releases: [
        exchange: [
          include_executables_for: [:unix],
          applications: [runtime_tools: :permanent],
          steps: [:assemble, :tar]
        ]
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Exchange.Application, []}
    ]
  end

  defp deps do
    [
      {:websockex, "~> 0.4.2"},
      {:jason, "~> 1.1"}
    ]
  end
end
