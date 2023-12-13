defmodule Grading.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      GradingWeb.Telemetry,
      Grading.Repo,
      {DNSCluster, query: Application.get_env(:grading, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Grading.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Grading.Finch},
      # Start a worker by calling: Grading.Worker.start_link(arg)
      # {Grading.Worker, arg},
      # Start to serve requests, typically the last entry
      GradingWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Grading.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    GradingWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
