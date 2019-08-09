defmodule Icalendar.MixProject do
  use Mix.Project

  def project do
    [
      app: :icalex,
      version: "0.1.0",
      elixir: "~> 1.8",
      description: description(),
      package: package(),
      aliases: aliases(),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :timex]
    ]
  end

  defp description do
    """
    A complete set of tools to build and parse iCalendar specification
    """
  end

  defp package do
    [ files: ["lib", "mix.exs", "README.md", "LICENSE.md"],
      maintainers: ["Vincent Dupont"],
      licenses: ["MIT"],
      links: %{
        "Changelog": "https://github.com/thestakeholdercompany/icalex/blob/master/CHANGELOG.md",
        "GitHub": "https://github.com/thestakeholdercompany/icalex"
      }]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:elixir_uuid, "~> 1.2", only: [:test]},
      {:timex, "~> 3.6"},
      {:mix_test_watch, "~> 0.8", only: [:test]}
    ]
  end

  defp aliases do
    [
      "test.watch": ["test.watch --stale"]
    ]
  end
end
