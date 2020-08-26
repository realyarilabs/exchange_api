defmodule ExchangeApiWeb.OrderController do
  use ExchangeApiWeb, :controller
  alias ExchangeApiWeb.Ticker

  action_fallback ExchangeApiWeb.FallbackController
  def delete(conn, %{"ticker" => ticker, "order_id" => order_id}) do
    with {:ok, tick} <- Ticker.get_ticker(ticker), :ok <- Exchange.cancel_order(order_id, tick) do
      redirect(conn, to: "/home/ticker/#{ticker}")
    end
  end
end
