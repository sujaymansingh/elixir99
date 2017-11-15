defmodule Elixir99.MixProject do
  use Mix.Project

  def project do
    [
      app: :elixir99,
      version: "0.1.0",
      elixir: "~> 1.6-dev",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:mock, "~> 0.3.1", only: :test},
      {:memoize, "~> 1.2"}
    ]
  end
end
