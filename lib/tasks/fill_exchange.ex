defmodule Mix.Tasks.FillExchange do
  use Mix.Task
  @shortdoc "Populate exchange"

  def run(args) do
    Application.ensure_all_started(:hackney)
    switches = [help: :boolean, mode: :boolean, count: :integer, ticker: :string]
    aliases = [h: :help, m: :mode, c: :count, t: :ticker]
    default = [help: false, mode: false, count: 100, ticker: :AUXLND]

    opts =
      OptionParser.parse(args, switches: switches, aliases: aliases)
      |> Tuple.to_list()
      |> Enum.flat_map(fn x -> x end)

    opts = Keyword.merge(default, opts)

    help =
      Enum.find(opts, default[:help], fn {key, _value} ->
        key == :help
      end)
      |> elem(1)

    mode =
      Enum.find(opts, default[:mode], fn {key, _value} ->
        key == :mode
      end)
      |> elem(1)

    count =
      Enum.find(opts, default[:count], fn {key, _value} ->
        key == :count
      end)
      |> elem(1)

    ticker =
      Enum.find(opts, default[:ticker], fn {key, _value} ->
        key == :ticker
      end)
      |> elem(1)
      |> String.to_atom()

    if help do
      show_help()
    else
      place_orders(ticker, mode, count)
    end
  end

  def place_orders(_ticker, true, 0) do
  end

  def place_orders(ticker, true, count) do
    order = Exchange.Utils.random_order(ticker)

    order = %{
      order
      | exp_time: order.exp_time + 10_000_000_000
    }

    url = "http://localhost:4000/ticker/#{ticker}/traders/#{order.trader_id}/orders"

    HTTPoison.post(
      url,
      order |> Poison.encode() |> elem(1),
      [{"Content-Type", "application/json"}]
    )

    place_orders(ticker, true, count - 1)
  end

  def place_orders(ticker, false, _count) do
    order = Exchange.Utils.random_order(ticker)

    order = %{
      order
      | exp_time: order.exp_time + 10_000_000_000
    }

    url = "http://localhost:4000/ticker/AUXLND/traders/#{order.trader_id}/orders"

    HTTPoison.post(
      url,
      order |> Poison.encode() |> elem(1),
      [{"Content-Type", "application/json"}]
    )

    place_orders(ticker, false, 1)
  end

  def show_help() do
    IO.puts("""
    Fill Exchange task:
    This task serves for population an exchange. It creates http requests with random orders and one can use it to insert orders continuously or insert a fixed number of orders.

    --help or -h: show help.
    --mode or -m: runs the task in fixed number mode, default false.
    --count or -c: sets the number of orders to be inserted, default 100.
    --ticker or -t: sets the name of the ticker, default AUXLND.
    """)
  end
end
