defmodule ExchangeApiWeb.OrderController do
  use ExchangeApiWeb, :controller

  action_fallback ExchangeApiWeb.FallbackController

  def index_open(conn, %{"ticker" => ticker}) do
    with {:ok, tick} <- get_ticker(ticker) do
      set_http_status(conn, Exchange.open_orders(tick))
    end
  end

  def count_buy_side(conn, %{"ticker" => ticker}) do
    with {:ok, tick} <- get_ticker(ticker) do
      set_http_status(conn, Exchange.total_buy_orders(tick))
    end
  end

  def count_sell_side(conn, %{"ticker" => ticker}) do
    with {:ok, tick} <- get_ticker(ticker) do
      set_http_status(conn, Exchange.total_sell_orders(tick))
    end
  end

  def spread(conn, %{"ticker" => ticker}) do
    with {:ok, tick} <- get_ticker(ticker) do
      set_http_status(conn, json_encode_money(Exchange.spread(tick)))
    end
  end

  def highest_bid_price(conn, %{"ticker" => ticker}) do
    with {:ok, tick} <- get_ticker(ticker) do
      set_http_status(conn, json_encode_money(Exchange.highest_bid_price(tick)))
    end
  end

  def highest_bid_volume(conn, %{"ticker" => ticker}) do
    with {:ok, tick} <- get_ticker(ticker) do
      set_http_status(conn, Exchange.highest_bid_volume(tick))
    end
  end

  def lowest_ask_price(conn, %{"ticker" => ticker}) do
    with {:ok, tick} <- get_ticker(ticker) do
      set_http_status(conn, json_encode_money(Exchange.lowest_ask_price(tick)))
    end
  end

  def highest_ask_volume(conn, %{"ticker" => ticker}) do
    with {:ok, tick} <- get_ticker(ticker) do
      set_http_status(conn, Exchange.highest_ask_volume(tick))
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

  defp set_http_status(conn, {status, data}) do
    f = fn conn ->
      case status do
        :ok -> conn
        _ -> conn |> put_status(:bad_request)
      end
    end

    conn
    |> f.()
    |> json(%{data: data})
  end
end
