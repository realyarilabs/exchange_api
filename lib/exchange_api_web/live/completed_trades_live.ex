defmodule ExchangeApiWeb.CompletedTradesLive do
  use ExchangeApiWeb, :live_view

  def mount(%{"ticker" => ticker}, _session, socket) do
    # if connected?(socket), do: :timer.send_interval(1000, self(), :tick)

    {:ok,
     assign(socket,
       ticker: ticker
     )}
  end
end
