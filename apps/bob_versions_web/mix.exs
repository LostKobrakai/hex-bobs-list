defmodule BobVersionsWeb.MixProject do
  use Mix.Project

  def project do
    [
      app: :bob_versions_web,
      version: "1.0.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.9",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      mod: {BobVersionsWeb.Application, []},
      extra_applications: [:logger, :runtime_tools, :os_mon]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:phoenix, "~> 1.6"},
      {:phoenix_pubsub, "~> 2.0"},
      {:phoenix_ecto, "~> 4.0"},
      {:phoenix_html, "~> 3.0"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:gettext, "~> 0.11"},
      {:bob_versions, in_umbrella: true},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.1"},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"},
      {:phoenix_live_view, "~> 0.17.0"},
      {:phoenix_live_dashboard, "~> 0.6"},
      {:floki, ">= 0.0.0", only: :test},
      {:tzdata, "~> 1.0"},
      {:esbuild, "~> 0.5.0", runtime: Mix.env() == :dev},
      {:dart_sass, "~> 0.5.0", runtime: Mix.env() == :dev},
      {:bulma, "0.9.3", runtime: Mix.env() == :dev}
    ]
  end
end
