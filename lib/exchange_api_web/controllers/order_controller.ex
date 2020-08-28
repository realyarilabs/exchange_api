defmodule ExchangeApiWeb.OrderController do
  use ExchangeApiWeb, :controller
  alias ExchangeApiWeb.Ticker

  action_fallback ExchangeApiWeb.Api.FallbackController
  def delete(conn, %{"ticker" => ticker, "order_id" => order_id}) do
    with {:ok, tick} <- Ticker.get_ticker(ticker), :ok <- Exchange.cancel_order(order_id, tick) do
      redirect(conn, to: "/home/ticker/#{ticker}")
    end
  end

  def highest_bid_volume(conn, %{"ticker" => ticker}) do
    with {:ok, tick} <- Ticker.get_ticker(ticker),
         {:ok, bid_volume} <- Exchange.highest_bid_volume(tick) do
      json(conn, %{data: bid_volume})
    end
  end

  def lowest_ask_price(conn, %{"ticker" => ticker}) do
    with {:ok, tick} <- Ticker.get_ticker(ticker),
         {:ok, ask_price} <- json_encode_money(Exchange.lowest_ask_price(tick)) do
      json(conn, %{data: ask_price})
    end
  end

  def highest_ask_volume(conn, %{"ticker" => ticker}) do
    with {:ok, tick} <- Ticker.get_ticker(ticker),
         {:ok, ask_volume} <- Exchange.highest_ask_volume(tick) do
      json(conn, %{data: ask_volume})
    end
  end

  # ----- PRIVATE ----- #

  defp json_encode_money(money) do
    {status, %Money{amount: amount, currency: currency}} = money
    {status, %{amount: amount, currency: currency}}
  end
end
