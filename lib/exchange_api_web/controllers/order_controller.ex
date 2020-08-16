defmodule ExchangeApiWeb.OrderController do
  use ExchangeApiWeb, :controller

  action_fallback ExchangeApiWeb.FallbackController

  def index_open(conn, %{"ticker" => ticker}) do
    with {:ok, tick} <- get_ticker(ticker), {:ok, open} <- Exchange.open_orders(tick) do
      json(conn, %{data: open})
    end
  end

  def count_buy_side(conn, %{"ticker" => ticker}) do
    with {:ok, tick} <- get_ticker(ticker), {:ok, total_buy_orders} <- Exchange.total_buy_orders(tick) do
      json(conn, %{data: total_buy_orders})
    end
  end

  def count_sell_side(conn, %{"ticker" => ticker}) do
    with {:ok, tick} <- get_ticker(ticker), {:ok, total_sell_orders} <- Exchange.total_sell_orders(tick) do
      json(conn, %{data: total_sell_orders})
    end
  end

  def spread(conn, %{"ticker" => ticker}) do
    with {:ok, tick} <- get_ticker(ticker), {:ok, spread} <- json_encode_money(Exchange.spread(tick)) do
      json(conn, %{data: spread})
    end
  end

  def highest_bid_price(conn, %{"ticker" => ticker}) do
    with {:ok, tick} <- get_ticker(ticker), {:ok, bid_price} <- json_encode_money(Exchange.highest_bid_price(tick)) do
      json(conn, %{data: bid_price})
    end
  end

  def highest_bid_volume(conn, %{"ticker" => ticker}) do
    with {:ok, tick} <- get_ticker(ticker), {:ok, bid_volume} <- Exchange.highest_bid_volume(tick) do
      json(conn, %{data: bid_volume})
    end
  end

  def lowest_ask_price(conn, %{"ticker" => ticker}) do
    with {:ok, tick} <- get_ticker(ticker), {:ok, ask_price} <- json_encode_money(Exchange.lowest_ask_price(tick)) do
      json(conn, %{data: ask_price})
    end
  end

  def highest_ask_volume(conn, %{"ticker" => ticker}) do
    with {:ok, tick} <- get_ticker(ticker), {:ok, ask_volume} <- Exchange.highest_ask_volume(tick) do
      json(conn, %{data: ask_volume})
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
    %{status: status, data: %{ammount: ammount, currency: currency}}
  end
end
