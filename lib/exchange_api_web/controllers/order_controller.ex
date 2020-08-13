defmodule ExchangeApiWeb.OrderController do
  use ExchangeApiWeb, :controller

  action_fallback ExchangeApiWeb.FallbackController

  def index(conn, %{"ticker_id" => ticker}) do
    with {:ok , tick} <- get_ticker(ticker) do
      {status, data} = Exchange.open_orders(tick)
      json(conn, %{status: status, data: data})
    end
  end


  def create(conn,
              %{"order_id" => order_id,
                "trader_id" => trader_id,
                "side" => side,
                "size" => size,
                "price" => price,
                "type" => type,
                "ticker_id" => ticker} = params) do

    time = Map.get(params, "exp_time", nil)
    exp = get_time(time)

    {side_status, side} = get_side(side)
    {tick_status, tick} = get_ticker(ticker)
    {type_status, type} = get_type(type)
    {status, _value} = is_valid({side_status, side}, {tick_status, tick}, {type_status, type})

    with :ok <- status do
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
      json(conn, %{ status: encode(order_status) })
    end
  end

  def show(conn, %{"id" => id, "ticker_id" => ticker}) do
    with {:ok, tick} <- get_ticker(ticker) do
      orders = Exchange.open_orders_by_trader(tick, id)
      json(conn, %{ status: elem(orders, 0), data: elem(orders, 1) })
    end
  end

  def delete(conn, %{"id" => id, "ticker_id" => ticker}) do
    with {:ok, tick} <- get_ticker(ticker) do
      Exchange.cancel_order(id, tick)
      json(conn, %{ status: "deleted" })
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
      _ -> 0
    end
  end

  defp encode(data) do
    case is_tuple(data) do
      true -> %{ elem(data, 0) => elem(data,1) }
      false -> data
    end
  end

  defp is_valid(side, ticker, type) do
    if elem(side, 0) == :ok do
      if elem(ticker, 0) == :ok do
        if elem(type, 0) == :ok do
          {:ok, " "}
        else
          type
        end
      else
        ticker
      end
    else
      side
    end
  end
end
