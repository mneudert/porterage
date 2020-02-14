defmodule Porterage.MixProject do
  use Mix.Project

  @url_github "https://github.com/mneudert/porterage"

  def project do
    [
      app: :porterage,
      name: "Porterage",
      version: "0.1.0-dev",
      elixir: "~> 1.7",
      dialyzer: dialyzer(),
      deps: deps(),
      description: "Checks, fetches and delivers configurable data sources",
      docs: docs(),
      elixirc_paths: elixirc_paths(Mix.env()),
      package: package(),
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.travis": :test
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
        :race_conditions,
        :underspecs,
        :unmatched_returns
      ]
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.0", only: :dev, runtime: false},
      {:dialyxir, "~> 1.0.0-rc", only: :dev, runtime: false},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:excoveralls, "~> 0.12", only: :test, runtime: false}
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
      source_ref: "master",
      source_url: @url_github
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/helpers"]
  defp elixirc_paths(_), do: ["lib"]

  defp package do
    %{
      files: ["CHANGELOG.md", "LICENSE", "mix.exs", "README.md", "lib"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => @url_github},
      maintainers: ["Marc Neudert"]
    }
  end
end
