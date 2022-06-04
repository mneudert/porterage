defmodule Porterage.MixProject do
  use Mix.Project

  @url_changelog "https://hexdocs.pm/porterage/changelog.html"
  @url_github "https://github.com/mneudert/porterage"
  @version "0.2.0-dev"

  def project do
    [
      app: :porterage,
      name: "Porterage",
      version: @version,
      elixir: "~> 1.9",
      dialyzer: dialyzer(),
      deps: deps(),
      description: "Checks, fetches and delivers configurable data sources",
      docs: docs(),
      elixirc_paths: elixirc_paths(Mix.env()),
      package: package(),
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test
      ],
      test_coverage: [tool: ExCoveralls]
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp dialyzer do
    [
      flags: [
        :error_handling,
        :underspecs,
        :unmatched_returns
      ],
      plt_core_path: "plts",
      plt_local_path: "plts"
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.0", only: :dev, runtime: false},
      {:dialyxir, "~> 1.0", only: :dev, runtime: false},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:excoveralls, "~> 0.14.0", only: :test, runtime: false}
    ]
  end

  defp docs do
    [
      groups_for_modules: [
        Deliverers: [
          Porterage.Deliverer.FileWrite,
          Porterage.Deliverer.MFArgs,
          Porterage.Deliverer.Send
        ],
        Fetchers: [
          Porterage.Fetcher.FileRead,
          Porterage.Fetcher.MFArgs
        ],
        Schedulers: [
          Porterage.Scheduler.MFArgs,
          Porterage.Scheduler.Never,
          Porterage.Scheduler.Once,
          Porterage.Scheduler.Timer
        ],
        Testers: [
          Porterage.Tester.FileStat,
          Porterage.Tester.MFArgs
        ]
      ],
      main: "Porterage",
      extras: [
        "CHANGELOG.md",
        LICENSE: [title: "License"],
        "README.md": [title: "Overview"]
      ],
      formatters: ["html"],
      source_ref: "v#{@version}",
      source_url: @url_github
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/helpers"]
  defp elixirc_paths(_), do: ["lib"]

  defp package do
    [
      files: ["CHANGELOG.md", "LICENSE", "mix.exs", "README.md", "lib"],
      licenses: ["Apache-2.0"],
      links: %{
        "Changelog" => @url_changelog,
        "GitHub" => @url_github
      }
    ]
  end
end
