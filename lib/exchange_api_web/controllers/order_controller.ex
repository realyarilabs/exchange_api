defmodule ExchangeApiWeb.OrderController do
  use ExchangeApiWeb, :controller
  alias ExchangeApiWeb.Ticker

  def delete(conn, %{"ticker" => ticker, "order_id" => order_id}) do
    with {:ok, tick} <- Ticker.get_ticker(ticker), :ok <- Exchange.cancel_order(order_id, tick) do
      redirect(conn, to: "/home/ticker/#{ticker}")
    end
  end

  def create(conn, %{"ticker" => ticker, "order" => params}) do
    exp_time = Map.get(params, "exp_time", nil)
    exp_time =
      cond do
        is_integer(exp_time) -> DateTime.from_unix(exp_time, :millisecond) |> elem(1)
        true -> nil
      end
    order_params = %{
      order_id: Map.get(params, "order_id"),
      trader_id: Map.get(params, "trader_id"),
      side: Map.get(params, "side") |> String.to_atom(),
      price: Map.get(params, "price"),
      size: Map.get(params, "size") |> String.to_integer(),
      initial_size: Map.get(params, "initial_size"),
      type: Map.get(params, "type") |> String.to_atom(),
      exp_time: exp_time,
      acknowledged_at: DateTime.utc_now() |> DateTime.to_unix(:nanosecond),
      modified_at: DateTime.utc_now() |> DateTime.to_unix(:nanosecond),
      ticker: ticker |> String.to_atom()
    }
    with {:ok, tick} <- Ticker.get_ticker(ticker), :ok <- Exchange.place_order(order_params, tick) do
      redirect(conn, to: "/home/ticker/#{ticker}")
    end
  end

  def get(conn, %{"ticker" => ticker}) do
    with {:ok, tick} <- Ticker.get_ticker(ticker) do
      render(conn, "new.html", ticker: tick)
    end
  end
end
