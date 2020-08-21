defmodule ExchangeApiWeb.CompletedTradeLive do
  use ExchangeApiWeb, :live_view
  alias ExchangeApiWeb.Ticker

  def mount(%{"trade_id" => trade_id, "ticker" => ticker}, _session, socket) do
    {:ok, tick} = Ticker.get_ticker(ticker)

    {:ok,
     assign(socket,
     trade_id: trade_id,
     ticker: tick
     )}
  end
end
