defmodule ExchangeApiWeb.CompletedTradeLive do
  use ExchangeApiWeb, :live_view
  alias ExchangeApiWeb.Ticker

  def mount(%{"trade_id" => trade_id, "ticker" => ticker}, _session, socket) do
    {:ok, tick} = Ticker.get_ticker(ticker)
    trade = Exchange.completed_trade_by_trade_id(tick, trade_id)

    {:ok,
     assign(socket,
     ticker: tick,
     trade: trade
     )}
  end
end
