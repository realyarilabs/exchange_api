defmodule ExchangeApiWeb.DashboardLive do
  use ExchangeApiWeb, :live_view

  def mount(_params, _session, socket) do
    if connected?(socket), do: :timer.send_interval(1000, self(), :tick)

    {:ok, total_buy_orders_AUXLND} = Exchange.total_buy_orders(:AUXLND)
    {:ok, total_buy_orders_AGUS} = Exchange.total_buy_orders(:AGUS)

    {:ok, assign(socket,
      val: 72,
      time: NaiveDateTime.local_now(),
      total_buy_orders_AUXLND: total_buy_orders_AUXLND,
      total_buy_orders_AGUS: total_buy_orders_AGUS
    )}
  end

  def handle_info(:tick, socket) do
    {:ok, total_buy_orders_AUXLND} = Exchange.total_buy_orders(:AUXLND)
    {:ok, total_buy_orders_AGUS} = Exchange.total_buy_orders(:AGUS)

    {:noreply, assign(socket,
      time: NaiveDateTime.local_now(),
      total_buy_orders_AUXLND: total_buy_orders_AUXLND,
      total_buy_orders_AGUS: total_buy_orders_AGUS
    )}
  end
end
