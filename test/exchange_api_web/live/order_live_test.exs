defmodule ExchangeApiWeb.OrderLiveTest do
  use ExchangeApiWeb.ConnCase
  import Phoenix.LiveViewTest

  test "connected mount", %{conn: conn} do
    order_params = %{
      order_id: "20",
      trader_id: "1221",
      side: :sell,
      price: 5500,
      size: 2100,
      type: :limit,
    }
    Exchange.place_order(order_params, :AGUS)
    conn = get(conn, "/home/ticker/AGUS/order/20")
    assert html_response(conn, 200) =~ "<h1 class=\"ui dividing header\">Order</h1>"

    {:ok, _view, _html} = live(conn)
  end
end
