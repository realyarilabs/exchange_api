defmodule ExchangeApiWeb.OrderBookLive do
  use ExchangeApiWeb, :live_view
  alias ExchangeApiWeb.Ticker

  def mount(%{"ticker" => ticker}, _session, socket) do
    if connected?(socket), do: :timer.send_interval(1000, self(), :tick)

    {:ok, tick} = Ticker.get_ticker(ticker)
    {:ok, open_orders} = Exchange.open_orders(tick)
    {:ok, last_price_sell} = Exchange.last_price(tick, :sell)
    {:ok, last_price_buy} = Exchange.last_price(tick, :buy)
    {:ok, last_size_sell} = Exchange.last_size(tick, :sell)
    {:ok, last_size_buy} = Exchange.last_size(tick, :buy)

    sell_orders = open_orders |> Enum.filter(fn order -> order.side == :sell end)
    buy_orders = open_orders |> Enum.filter(fn order -> order.side == :buy end)

    {:ok,
     assign(socket,
       ticker: ticker,
       last_price_sell: last_price_sell,
       last_price_buy: last_price_buy,
       last_size_sell: last_size_sell,
       last_size_buy: last_size_buy,
       sell_orders: sell_orders,
       buy_orders: buy_orders
     )}
  end

  def handle_info(:tick, socket) do
    {:ok, ticker} = Ticker.get_ticker(socket.assigns.ticker)
    {:ok, open_orders} = Exchange.open_orders(ticker)
    {:ok, last_price_sell} = Exchange.last_price(ticker, :sell)
    {:ok, last_price_buy} = Exchange.last_price(ticker, :buy)
    {:ok, last_size_sell} = Exchange.last_size(ticker, :sell)
    {:ok, last_size_buy} = Exchange.last_size(ticker, :buy)

    sell_orders = open_orders |> Enum.filter(fn order -> order.side == :sell end)
    buy_orders = open_orders |> Enum.filter(fn order -> order.side == :buy end)

    {:noreply,
     assign(socket,
       last_price_sell: last_price_sell,
       last_price_buy: last_price_buy,
       last_size_sell: last_size_sell,
       last_size_buy: last_size_buy,
       sell_orders: sell_orders,
       buy_orders: buy_orders
     )}
  end
end
