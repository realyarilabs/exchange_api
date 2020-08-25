defmodule ExchangeApiWeb.OrderBookLive do
  use ExchangeApiWeb, :live_view
  alias ExchangeApiWeb.Ticker

  def mount(%{"ticker" => ticker}, _session, socket) do
    if connected?(socket), do: :timer.send_interval(1000, self(), :tick)

    {:ok, tick} = Ticker.get_ticker(ticker)
    {:ok, open_orders} = Exchange.open_orders(tick)

    sell_orders = open_orders |> Enum.filter(fn order -> order.side == :sell end)
    buy_orders = open_orders |> Enum.filter(fn order -> order.side == :buy end)

    {:ok,
     assign(socket,
       ticker: ticker,
       sell_orders: sell_orders,
       buy_orders: buy_orders
     )}
  end

  def handle_info(:tick, socket) do
    {:ok, ticker} = Ticker.get_ticker(socket.assigns.ticker)
    {:ok, open_orders} = Exchange.open_orders(ticker)

    sell_orders = open_orders |> Enum.filter(fn order -> order.side == :sell end)
    buy_orders = open_orders |> Enum.filter(fn order -> order.side == :buy end)

    {:noreply,
     assign(socket,
       sell_orders: sell_orders,
       buy_orders: buy_orders
     )}
  end
end
