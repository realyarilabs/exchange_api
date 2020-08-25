defmodule ExchangeApiWeb.HomeLive do
  use ExchangeApiWeb, :live_view
  alias ExchangeApiWeb.Ticker

  def mount(_params, _session, socket) do
    if connected?(socket), do: :timer.send_interval(1000, self(), :tick)

    {:ok, total_buy_orders} = Exchange.total_buy_orders(:AUXLND)
    {:ok, total_sell_orders} = Exchange.total_sell_orders(:AUXLND)
    {:ok, open_orders} = Exchange.open_orders(:AUXLND)

    {:ok,
     assign(socket,
       ticker: "AUXLND",
       time: NaiveDateTime.local_now(),
       total_buy_orders: total_buy_orders,
       total_sell_orders: total_sell_orders,
       open_orders: open_orders
     )}
  end

  def handle_info(:tick, socket) do
    {:ok, ticker} = Ticker.get_ticker(socket.assigns.ticker)
    {:ok, total_buy_orders} = Exchange.total_buy_orders(ticker)
    {:ok, total_sell_orders} = Exchange.total_sell_orders(:AUXLND)
    {:ok, open_orders} = Exchange.open_orders(ticker)

    {:noreply,
     assign(socket,
       time: NaiveDateTime.local_now(),
       total_buy_orders: total_buy_orders,
       total_sell_orders: total_sell_orders,
       open_orders: open_orders
     )}
  end

  def handle_event("AUXLND", _, socket) do
    {:ok, total_buy_orders} = Exchange.total_buy_orders(:AUXLND)
    {:ok, total_sell_orders} = Exchange.total_sell_orders(:AUXLND)
    {:ok, open_orders} = Exchange.open_orders(:AUXLND)

    {:noreply,
     assign(socket,
       ticker: "AUXLND",
       total_buy_orders: total_buy_orders,
       total_sell_orders: total_sell_orders,
       open_orders: open_orders
     )}
  end

  def handle_event("AGUS", _, socket) do
    {:ok, total_buy_orders} = Exchange.total_buy_orders(:AGUS)
    {:ok, total_sell_orders} = Exchange.total_sell_orders(:AUXLND)
    {:ok, open_orders} = Exchange.open_orders(:AUXLND)

    {:noreply,
     assign(socket,
       ticker: "AGUS",
       total_buy_orders: total_buy_orders,
       total_sell_orders: total_sell_orders,
       open_orders: open_orders
     )}
  end
end
