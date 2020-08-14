defmodule ExchangeApiWeb.OrderController do
  use ExchangeApiWeb, :controller

  action_fallback ExchangeApiWeb.FallbackController

  def index_open(conn, %{"ticker" => ticker}) do
    with {:ok, tick} <- get_ticker(ticker) do
      {status, data} = Exchange.open_orders(tick)
      json(conn, %{status: status, data: data})
    end
  end

  def count_buy_side(conn, %{"ticker" => ticker}) do
    with {:ok, tick} <- get_ticker(ticker) do
      {status, data} = Exchange.total_buy_orders(tick)
      json(conn, %{status: status, data: data})
    end
  end

  def count_sell_side(conn, %{"ticker" => ticker}) do
    with {:ok, tick} <- get_ticker(ticker) do
      {status, data} = Exchange.total_sell_orders(tick)
      json(conn, %{status: status, data: data})
    end
  end

  def spread(conn, %{"ticker" => ticker}) do
    with {:ok, tick} <- get_ticker(ticker) do
      json(conn, json_encode_money(Exchange.spread(tick)))
    end
  end

  def highest_bid_price(conn, %{"ticker" => ticker}) do
    with {:ok, tick} <- get_ticker(ticker) do
      json(conn, json_encode_money(Exchange.highest_bid_price(tick)))
    end
  end

  def highest_bid_volume(conn, %{"ticker" => ticker}) do
    with {:ok, tick} <- get_ticker(ticker) do
      {status, data} = Exchange.highest_bid_volume(tick)
      json(conn, %{status: status, data: data})
    end
  end

  def lowest_ask_price(conn, %{"ticker" => ticker}) do
    with {:ok, tick} <- get_ticker(ticker) do
      json(conn, json_encode_money(Exchange.lowest_ask_price(tick)))
    end
  end

  def highest_ask_volume(conn, %{"ticker" => ticker}) do
    with {:ok, tick} <- get_ticker(ticker) do
      {status, data} = Exchange.highest_ask_volume(tick)
      json(conn, %{status: status, data: data})
    end
  end


  # ----- PRIVATE ----- #

  defp get_ticker(ticker) do
    case ticker do
      "AUXLND" -> {:ok, :AUXLND}
      "AGUS" -> {:ok, :AGUS}
      _ -> {:error, "Ticker does not exist"}
    end
  end

  defp json_encode_money(money) do
    {status, %Money{amount: ammount, currency: currency}} = money
    %{status: status, data: %{ ammount: ammount, currency: currency }}
  end
end
