defmodule ExchangeApiWeb.TraderOrdersController do
  use ExchangeApiWeb, :controller

  action_fallback ExchangeApiWeb.FallbackController

  def index(conn, %{"trader_id" => trader_id, "ticker" => ticker}) do
    with {:ok, tick} <- get_ticker(ticker) do
      set_http_status(conn, Exchange.open_orders_by_trader(tick, trader_id))
    end
  end

  def index_completed(conn, %{"trader_id" => trader_id, "ticker" => ticker}) do #this wrong
    with {:ok, tick} <- get_ticker(ticker) do
      orders = Exchange.completed_trades_by_id(tick, trader_id)
      json(conn, %{data: orders})
    end
  end

  def create(
        conn,
        %{
          "order_id" => order_id,
          "trader_id" => trader_id,
          "side" => side,
          "size" => size,
          "price" => price,
          "type" => type,
          "ticker" => ticker
        } = params
      ) do
    time = Map.get(params, "exp_time", nil)
    exp = get_time(time)

    with {:ok, side} <- get_side(side),
         {:ok, tick} <- get_ticker(ticker),
         {:ok, type} <- get_type(type) do
      order_raw = %{
        order_id: order_id,
        trader_id: trader_id,
        side: side,
        size: size,
        price: price,
        type: type,
        ticker: tick,
        exp_time: exp
      }

      order_status = Exchange.place_order(order_raw, tick)
      case order_status do
        :ok -> json(conn, "Order placed.")
        _ -> put_status(conn, :bad_request) |> json("Failed to place order.")
      end
    end
  end

  @spec delete(any, map) :: any
  def delete(conn, %{"id" => id, "ticker" => ticker}) do
    with {:ok, tick} <- get_ticker(ticker) do
      order_status = Exchange.cancel_order(id, tick)
      case order_status do
        :ok -> json(conn, "Order cancelled.")
        _ -> put_status(conn, :bad_request) |> json("Failed to cancel order.")
      end
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

  defp get_side(side) do
    case side do
      "sell" -> {:ok, :sell}
      "buy" -> {:ok, :buy}
      true -> {:error, "Side does not exist"}
    end
  end

  defp get_type(type) do
    case type do
      "market" -> {:ok, :market}
      "limit" -> {:ok, :limit}
      true -> {:error, "Type does not exist"}
    end
  end

  defp get_time(time) do
    case time do
      nil -> time
      _ -> parse_time(time)
    end
  end

  def parse_time(time) do
    with {:ok, time, 0} = DateTime.from_iso8601(time) do
      time
    end
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
