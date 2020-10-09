defmodule ExchangeApiWeb.UserControllerTest do
  use ExchangeApiWeb.ConnCase

  @create_attrs %{
    "email" => "user#{System.unique_integer()}@example.com"
  }
  @invalid_attrs %{
    "email" => nil
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @create_attrs)
      assert %{"jwt" => _jwt} = json_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @invalid_attrs)
      assert json_response(conn, 422) == "Failed to create user"
    end
  end
end
