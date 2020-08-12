defmodule ExchangeApiWeb.OrderController do
  use ExchangeApiWeb, :controller

  def index(conn, _params) do
    orders = Exchange.open_orders(get_ticker())
    json(conn, %{ status: elem(orders, 0), data: elem(orders, 1) })
  end

  def create(conn, %{"side" => side, "size" => size, "price" => price,  "type" => type, "exp_time" => time}) do
    exp = elem(DateTime.from_iso8601(time), 1)
    order_raw = %{
      order_id: 1,
      trader_id: 1,
      side: get_side(side),
      size: size,
      price: price,
      type: get_type(type),
      exp_time: exp
    }
    order_status = Exchange.place_order(order_raw, get_ticker())
    json(conn, %{ status: encode(order_status) })
  end

  def show(conn, %{"id" => id}) do
    orders = Exchange.open_orders_by_trader(get_ticker(), id)
    json(conn, %{ status: elem(orders, 0), data: elem(orders, 1) })
  end

  def delete(conn, %{"id" => id}) do
    Exchange.cancel_order(id, get_ticker())
    json(conn, %{ status: "deleted" })
  end

  # ----- PRIVATE ----- #

  defp get_ticker do
    tickers = Application.get_env(:exchange, Exchange.Application, :tickers)
    ticker = List.first(tickers[:tickers])
    elem(ticker, 0)
  end

  defp get_side(side) do
    case side do
      "sell" -> :sell
      "buy" -> :buy
    end
  end

  defp get_type(type) do
    case type do
      "market" -> :market
      "limit" -> :limit
    end
  end

  def encode(data) do
    case is_tuple(data) do
      true -> %{ elem(data, 0) => elem(data,1) }
      false -> data
    end
  end
end
