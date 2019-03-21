defmodule Dawdle.MixProject do
  use Mix.Project

  @version "0.5.0"

  def project do
    [
      app: :dawdle,
      version: @version,
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      docs: docs(),
      deps: deps(),
      source_url: "https://github.com/hippware/dawdle",
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.html": :test
      ],
      dialyzer: [
        flags: [
          :error_handling,
          :no_behaviours,
          :no_contracts,
          :no_fail_call,
          :no_fun_app,
          :no_improper_lists,
          :no_match,
          :no_missing_calls,
          :no_opaque,
          :no_return,
          :no_undefined_callbacks,
          :no_unused,
          :race_conditions,
          :underspecs,
          :unknown,
          :unmatched_returns,
          :overspecs,
          :specdiffs
        ],
        ignore_warnings: "dialyzer_ignore.exs",
        list_unused_filters: true
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Dawdle.Application, []},
      env: [
        backend: {:system, :module, "DAWDLE_BACKEND", Dawdle.Backend.Local},
        start_listener: {:system, :boolean, "DAWDLE_START_LISTENER", true},
        "Elixir.Dawdle.Backend.SQS": [
          region: {:system, "DAWDLE_SQS_REGION", "us-west-2"},
          delay_queue: {:system, "DAWDLE_SQS_DELAY_QUEUE", "dawdle-delay"},
          message_queue:
            {:system, "DAWDLE_SQS_MESSAGE_QUEUE", "dawdle-messages.fifo"}
        ]
      ]
    ]
  end

  defp deps do
    [
      {:confex, "~> 3.4"},
      {:credo, "~> 1.0", only: [:dev], runtime: false},
      {:dialyxir, "~> 1.0.0-rc.4", only: [:dev], runtime: false},
      {:eventually,
       github: "hippware/eventually", branch: "master", only: :test},
      {:ex_aws, "~> 2.0"},
      {:ex_aws_sqs, "~> 2.0"},
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:excoveralls, "~> 0.10", only: :test},
      {:hackney, "~> 1.7"},
      {:poison, "~> 3.0 or ~> 4.0"},
      {:sweet_xml, "~> 0.6"}
    ]
  end

  defp description do
    """
    Dawdle weaponizes Amazon SQS for use in your Elixir applications. Use it
    when you want to handle something later, or, better yet, when you want
    someone else to handle it.
    """
  end

  defp package do
    [
      maintainers: ["Bernard Duggan", "Phil Toland"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/hippware/dawdle"}
    ]
  end

  defp docs do
    [
      source_ref: "v#\{@version\}",
      main: "readme",
      extras: ["README.md"],
      groups_for_modules: [
        API: [
          Dawdle,
          Dawdle.Client,
          Dawdle.Handler
        ],
        "Backend Implementation": [
          Dawdle.Backend,
          Dawdle.Backend.Local,
          Dawdle.Backend.SQS,
          Dawdle.MessageEncoder,
          Dawdle.MessageEncoder.Term
        ]
      ]
    ]
  end
end
