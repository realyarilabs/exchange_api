defmodule ExchangeApiWeb.OrderController do
  use ExchangeApiWeb, :controller

  action_fallback ExchangeApiWeb.FallbackController

  def index_open(conn, %{"ticker" => ticker}) do
    with {:ok, tick} <- get_ticker(ticker) do
      {status, data} = Exchange.open_orders(tick)
      json(conn, %{status: status, data: data})
    end
  end

  def index_buy_side(conn, %{"ticker" => ticker}) do
    with {:ok, tick} <- get_ticker(ticker) do
      {status, data} = Exchange.total_buy_orders(tick)
      json(conn, %{status: status, data: data})
    end
  end

  def index_sell_side(conn, %{"ticker" => ticker}) do
    with {:ok, tick} <- get_ticker(ticker) do
      {status, data} = Exchange.total_sell_orders(tick)
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
end
