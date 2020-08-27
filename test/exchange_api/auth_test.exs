defmodule ExchangeApiWeb.AuthTest do
  use ExchangeApiWeb.ConnCase
  use ExUnit.Case

  setup_all _context do
    user = ExchangeApi.Accounts.get_user!("2c0cf84d-23ca-4e8a-9bba-8138d6a7c020")
    token = user.jwt
    {:ok, %{token: token}}
  end

  describe "Auth protection in Order Controller" do
    test "Unauthorized request on buy side" do
      conn = get(build_conn(), "/ticker/AUXLND/orders/buy_side")
      assert conn.resp_body |> Poison.decode!() == %{"error" => "unauthenticated"}
    end

    test "Authorized request buy side", %{token: token} do
      conn =
        build_conn()
        |> put_req_header(
          "authorization",
          "Bearer " <> token
        )
        |> get("/ticker/AUXLND/orders/buy_side")

      assert conn.resp_body |> Poison.decode!() == %{"data" => 0}
    end

    test "Unauthorized request on sell side" do
      conn = get(build_conn(), "/ticker/AUXLND/orders/sell_side")
      assert conn.resp_body |> Poison.decode!() == %{"error" => "unauthenticated"}
    end

    test "Authorized request sell side", %{token: token} do
      conn =
        build_conn()
        |> put_req_header(
          "authorization",
          "Bearer " <> token
        )
        |> get("/ticker/AUXLND/orders/sell_side")

      assert conn.resp_body |> Poison.decode!() == %{"data" => 0}
    end

    test "Unauthorized request open orders" do
      conn = get(build_conn(), "/ticker/AUXLND/orders/open")
      assert conn.resp_body |> Poison.decode!() == %{"error" => "unauthenticated"}
    end

    test "Authorized request open orders", %{token: token} do
      conn =
        build_conn()
        |> put_req_header(
          "authorization",
          "Bearer " <> token
        )
        |> get("/ticker/AUXLND/orders/open")

      assert conn.resp_body |> Poison.decode!() == %{"data" => []}
    end

    test "Unauthorized request spread" do
      conn = get(build_conn(), "/ticker/AUXLND/orders/spread")
      assert conn.resp_body |> Poison.decode!() == %{"error" => "unauthenticated"}
    end

    test "Authorized request spread", %{token: token} do
      conn =
        build_conn()
        |> put_req_header(
          "authorization",
          "Bearer " <> token
        )
        |> get("/ticker/AUXLND/orders/spread")

      assert conn.resp_body |> Poison.decode!() == %{
               "data" => %{"amount" => 98998, "currency" => "GBP"}
             }
    end

    test "Unauthorized request highest_bid_price" do
      conn = get(build_conn(), "/ticker/AUXLND/orders/highest_bid_price")
      assert conn.resp_body |> Poison.decode!() == %{"error" => "unauthenticated"}
    end

    test "Authorized request highest_bid_price", %{token: token} do
      conn =
        build_conn()
        |> put_req_header(
          "authorization",
          "Bearer " <> token
        )
        |> get("/ticker/AUXLND/orders/highest_bid_price")

      assert conn.resp_body |> Poison.decode!() == %{
               "data" => %{"amount" => 1001, "currency" => "GBP"}
             }
    end

    test "Unauthorized request highest_bid_volume" do
      conn = get(build_conn(), "/ticker/AUXLND/orders/highest_bid_volume")
      assert conn.resp_body |> Poison.decode!() == %{"error" => "unauthenticated"}
    end

    test "Authorized request highest_bid_volume", %{token: token} do
      conn =
        build_conn()
        |> put_req_header(
          "authorization",
          "Bearer " <> token
        )
        |> get("/ticker/AUXLND/orders/highest_bid_volume")

      assert conn.resp_body |> Poison.decode!() == %{"data" => 0}
    end

    test "Unauthorized request lowest_ask_price" do
      conn = get(build_conn(), "/ticker/AUXLND/orders/lowest_ask_price")
      assert conn.resp_body |> Poison.decode!() == %{"error" => "unauthenticated"}
    end

    test "Authorized request lowest_ask_price", %{token: token} do
      conn =
        build_conn()
        |> put_req_header(
          "authorization",
          "Bearer " <> token
        )
        |> get("/ticker/AUXLND/orders/lowest_ask_price")

      assert conn.resp_body |> Poison.decode!() == %{
               "data" => %{"amount" => 99999, "currency" => "GBP"}
             }
    end

    test "Unauthorized request highest_ask_volume" do
      conn = get(build_conn(), "/ticker/AUXLND/orders/highest_ask_volume")
      assert conn.resp_body |> Poison.decode!() == %{"error" => "unauthenticated"}
    end

    test "Authorized request highest_ask_volume", %{token: token} do
      conn =
        build_conn()
        |> put_req_header(
          "authorization",
          "Bearer " <> token
        )
        |> get("/ticker/AUXLND/orders/highest_ask_volume")

      assert conn.resp_body |> Poison.decode!() == %{"data" => 0}
    end
  end

  describe "Auth protection in Trade Controller" do
    test "Unauthorized request get orders" do
      conn = get(build_conn(), "/ticker/AUXLND/traders/dev/orders")
      assert conn.resp_body |> Poison.decode!() == %{"error" => "unauthenticated"}
    end

    test "Authorized request get orders", %{token: token} do
      conn =
        build_conn()
        |> put_req_header(
          "authorization",
          "Bearer " <> token
        )
        |> get("/ticker/AUXLND/traders/dev/orders")

      assert conn.resp_body |> Poison.decode!() == %{"data" => []}
    end

    test "Unauthorized request order placing" do
      order =
        Exchange.Utils.random_order(:AUXLND)
        |> Map.put(:trader_id, "dev")

      json_order = Poison.encode!(order)

      conn =
        build_conn()
        |> put_req_header(
          "content-type",
          "application/json"
        )
        |> post("/ticker/AUXLND/traders/dev/orders", json_order)

      assert conn.resp_body |> Poison.decode!() == %{"error" => "unauthenticated"}
    end

    test "Authorized request order placing", %{token: token} do
      order =
        Exchange.Utils.random_order(:AUXLND)
        |> Map.put(:trader_id, "dev")

      json_order = Poison.encode!(order)

      conn =
        build_conn()
        |> put_req_header(
          "content-type",
          "application/json"
        )
        |> put_req_header(
          "authorization",
          "Bearer " <> token
        )
        |> post("/ticker/AUXLND/traders/dev/orders", json_order)

      assert conn.resp_body |> Poison.decode!() == "Failed to place order."
    end

    test "Unauthorized request to cancel order" do
      conn = delete(build_conn(), "/ticker/AUXLND/traders/alchemist9/orders/1/delete")
      assert conn.resp_body |> Poison.decode!() == %{"error" => "unauthenticated"}
    end

    test "Authorized request to cancel order", %{token: token} do
      conn =
        build_conn()
        |> put_req_header(
          "authorization",
          "Bearer " <> token
        )
        |> delete("/ticker/AUXLND/traders/alchemist9/orders/1/delete")

      assert conn.resp_body |> Poison.decode!() == "Failed to cancel order."
    end

    test "Unauthorized request get of completed orders" do
      conn = get(build_conn(), "/ticker/AUXLND/traders/alchemist9/orders/1/completed")
      assert conn.resp_body |> Poison.decode!() == %{"error" => "unauthenticated"}
    end

    test "Authorized request get of completed orders", %{token: token} do
      conn =
        build_conn()
        |> put_req_header(
          "authorization",
          "Bearer " <> token
        )
        |> get("/ticker/AUXLND/traders/alchemist9/orders/1/completed")

      assert conn.resp_body |> Poison.decode!() == %{"data" => []}
    end
  end
end
