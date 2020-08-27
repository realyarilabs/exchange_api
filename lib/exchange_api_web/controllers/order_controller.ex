defmodule ExchangeApiWeb.OrderController do
  use ExchangeApiWeb, :controller
  alias ExchangeApiWeb.Ticker

  action_fallback ExchangeApiWeb.FallbackController
  def delete(conn, %{"ticker" => ticker, "order_id" => order_id}) do
    with {:ok, tick} <- Ticker.get_ticker(ticker), :ok <- Exchange.cancel_order(order_id, tick) do
      redirect(conn, to: "/home/ticker/#{ticker}")
    end
  end

  def create(conn, %{"ticker" => ticker, "order" => order_params}) do
    with {:ok, tick} <- Ticker.get_ticker(ticker), :ok <- Exchange.place_order(order_params, tick) do
      render(conn, "new.html")
    end
  end

  def get(conn, %{"ticker" => ticker}) do
    with {:ok, tick} <- Ticker.get_ticker(ticker) do
      render(conn, "new.html", ticker: tick)
    end
  end
end
