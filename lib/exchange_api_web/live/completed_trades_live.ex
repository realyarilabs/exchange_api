defmodule ExchangeApiWeb.CompletedTradesLive do
  @moduledoc false
  use ExchangeApiWeb, :live_view
  alias ExchangeApiWeb.Ticker

  def mount(%{"ticker" => ticker}, _session, socket) do
    if connected?(socket), do: :timer.send_interval(1000, self(), :tick)

    {:ok, tick} = Ticker.get_ticker(ticker)
    trades = Exchange.completed_trades(tick)

    {:ok,
     assign(socket,
       ticker: ticker,
       trades: trades
     )}
  end

  def handle_info(:tick, socket) do
    {:ok, ticker} = Ticker.get_ticker(socket.assigns.ticker)
    trades = Exchange.completed_trades(ticker)

    {:noreply,
     assign(socket,
       trades: trades
     )}
  end
end
