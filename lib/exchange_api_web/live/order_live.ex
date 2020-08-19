defmodule ExchangeApiWeb.OrderLive do
  use ExchangeApiWeb, :live_view

  def mount(%{"order_id" => order_id}, _session, socket) do
    # if connected?(socket), do: :timer.send_interval(1000, self(), :tick)

    {:ok,
     assign(socket,
       order_id: order_id
     )}
  end
end
