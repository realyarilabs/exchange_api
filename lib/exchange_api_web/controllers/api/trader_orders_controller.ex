defmodule ExchangeApiWeb.Api.TraderOrdersController do
  use ExchangeApiWeb, :controller

  action_fallback ExchangeApiWeb.Api.FallbackController

  def index(conn, %{"trader_id" => trader_id, "ticker" => ticker}) do
    with {:ok, tick} <- get_ticker(ticker) do
      set_http_status(conn, Exchange.open_orders_by_trader(tick, trader_id))
    end
  end

  # this wrong
  def index_completed(conn, %{"trader_id" => trader_id, "ticker" => ticker}) do
    with {:ok, tick} <- get_ticker(ticker) do
      {:ok, orders} = Exchange.completed_trades_by_id(tick, trader_id)
      json(conn, %{data: orders})
    end
  end

  def create(conn, params) do
    ticker = Map.get(params, "ticker") |> String.to_atom()
    exp_time = Map.get(params, "exp_time", nil)

    exp_time =
      if is_integer(exp_time) do
        DateTime.from_unix(exp_time, :millisecond) |> elem(1)
      else
        exp_time
      end

    order_params = %{
      order_id: Map.get(params, "order_id"),
      trader_id: Map.get(params, "trader_id"),
      side: Map.get(params, "side") |> String.to_atom(),
      price: Map.get(params, "price"),
      size: Map.get(params, "size"),
      initial_size: Map.get(params, "initial_size"),
      type: Map.get(params, "type") |> String.to_atom(),
      exp_time: exp_time,
      acknowledged_at: DateTime.utc_now() |> DateTime.to_unix(:nanosecond),
      modified_at: DateTime.utc_now() |> DateTime.to_unix(:nanosecond),
      ticker: Map.get(params, "ticker") |> String.to_atom()
    }

    order_status = Exchange.place_order(order_params, ticker)

    response =
      case order_status do
        :ok -> json(conn, "Order placed.")
        _ -> put_status(conn, :bad_request) |> json("Failed to place order.")
      end

    response
  end

  @spec delete(any, map) :: any
  def delete(conn, %{"trader_orders_id" => id, "ticker" => ticker}) do
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

  def parse_time(timestamp, unit) when is_integer(timestamp) do
    case DateTime.from_unix(timestamp, unit) do
      {:ok, time} -> time
      error -> error
    end
  end

  def parse_time(time, _unit), do: time

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
