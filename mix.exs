defmodule BobVersions.Umbrella.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      releases: [
        bob_versions: [
          include_executables_for: [:unix],
          applications: [
            bob_versions: :permanent,
            bob_versions_web: :permanent,
            inets: :permanent
          ],
          version: "1.0.0"
        ]
      ]
    ]
  end

  defp deps do
    []
  end
end
