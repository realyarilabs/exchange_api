defmodule ExchangeApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      ExchangeApiWeb.Telemetry,
      {Phoenix.PubSub, name: ExchangeApi.PubSub},
      ExchangeApiWeb.Endpoint,
    ]

    opts = [strategy: :one_for_one, name: ExchangeApi.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
