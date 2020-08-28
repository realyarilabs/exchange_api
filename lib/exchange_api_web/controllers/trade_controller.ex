defmodule ExchangeApiWeb.TradeController do
  use ExchangeApiWeb, :controller
  alias ExchangeApiWeb.Ticker

  def get(conn, %{"ticker" => ticker, "trade_id" => trade_id}) do
    with {:ok, tick} <- Ticker.get_ticker(ticker) do
      trade = Exchange.completed_trade_by_trade_id(tick, trade_id)
      render(conn, "show.html", trade: trade, ticker: ticker)
    end
  end
end
