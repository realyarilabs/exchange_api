defmodule ExchangeApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    IO.inspect("application.ex start", [])

    children = [
      ExchangeApiWeb.Telemetry,
      {Phoenix.PubSub, name: Exchange.PubSub},
      ExchangeApiWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: ExchangeApi.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
