defmodule ExchangeApiWeb.OrderBookLive do
  @moduledoc false
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
    {:ok, spread} = Exchange.spread(tick)
    {:ok, highest_ask_volume} = Exchange.highest_ask_volume(tick)
    {:ok, lowest_ask_price} = Exchange.lowest_ask_price(tick)
    {:ok, highest_bid_volume} = Exchange.highest_bid_volume(tick)
    {:ok, highest_bid_price} = Exchange.highest_bid_price(tick)

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
       buy_orders: buy_orders,
       spread: spread,
       highest_ask_volume: highest_ask_volume,
       lowest_ask_price: lowest_ask_price,
       highest_bid_volume: highest_bid_volume,
       highest_bid_price: highest_bid_price
     )}
  end

  def handle_info(:tick, socket) do
    {:ok, ticker} = Ticker.get_ticker(socket.assigns.ticker)
    {:ok, open_orders} = Exchange.open_orders(ticker)
    {:ok, last_price_sell} = Exchange.last_price(ticker, :sell)
    {:ok, last_price_buy} = Exchange.last_price(ticker, :buy)
    {:ok, last_size_sell} = Exchange.last_size(ticker, :sell)
    {:ok, last_size_buy} = Exchange.last_size(ticker, :buy)
    {:ok, spread} = Exchange.spread(ticker)
    {:ok, highest_ask_volume} = Exchange.highest_ask_volume(ticker)
    {:ok, lowest_ask_price} = Exchange.lowest_ask_price(ticker)
    {:ok, highest_bid_volume} = Exchange.highest_bid_volume(ticker)
    {:ok, highest_bid_price} = Exchange.highest_bid_price(ticker)

    sell_orders = open_orders |> Enum.filter(fn order -> order.side == :sell end)
    buy_orders = open_orders |> Enum.filter(fn order -> order.side == :buy end)

    {:noreply,
     assign(socket,
       last_price_sell: last_price_sell,
       last_price_buy: last_price_buy,
       last_size_sell: last_size_sell,
       last_size_buy: last_size_buy,
       sell_orders: sell_orders,
       buy_orders: buy_orders,
       spread: spread,
       highest_ask_volume: highest_ask_volume,
       lowest_ask_price: lowest_ask_price,
       highest_bid_volume: highest_bid_volume,
       highest_bid_price: highest_bid_price
     )}
  end
end
