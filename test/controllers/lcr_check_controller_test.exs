defmodule CgratesWebJsonapi.LcrCheckControllerTest do
  use CgratesWebJsonapi.ConnCase

  import CgratesWebJsonapi.Factory
  import Mock

  setup do
    user = insert :user

    conn = build_conn()
     |> put_req_header("accept", "application/vnd.api+json")
     |> put_req_header("content-type", "application/vnd.api+json")
     |> Guardian.Plug.api_sign_in(
       user,
       :token,
       perms: %{default: [:read, :write]}
     )
    {:ok, conn: conn}
  end

  test "executes LcrCheck when data is valid", %{conn: conn} do
    with_mock CgratesWebJsonapi.Cgrates.Adapter, [
      execute: fn(_params) ->
        %{
          "result" => "OK",
          "error"  => nil,
          "id"     => nil
        }
      end
    ] do
      conn = post(conn, lcr_check_path(conn, :create), %{
        "meta" => %{},
        "data" => %{
          "attributes" => %{
            Account: "5be3ca83ef2acf250225fb54",
            Category: "trial",
            Destination: "8800200600",
            Duration: 60,
            Subject: "EU",
            Tenant: "cgrates.org"
          }
        }
      }) |> doc

      assert json_response(conn, 201)
    end
  end

  test "does not executes LcrCheck when data is invalid", %{conn: conn} do
    assert_error_sent 400, fn ->
      conn = post(conn, load_tariff_plan_path(conn, :create), %{
        "data" => %{
          "attributes" => %{}
        }
      }) |> doc
    end
  end

end
