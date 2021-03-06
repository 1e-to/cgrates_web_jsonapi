defmodule CgratesWebJsonapi.TpAttributeControllerTest do
  use CgratesWebJsonapi.ConnCase
  alias CgratesWebJsonapi.TpAttribute
  alias CgratesWebJsonapi.Repo

  import CgratesWebJsonapi.Factory

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

  describe "GET index" do
    test "lists all entries related tariff plan on index", %{conn: conn} do
      tariff_plan_1 = insert :tariff_plan
      tariff_plan_2 = insert :tariff_plan

      insert :tp_attribute, tpid: tariff_plan_1.alias
      insert :tp_attribute, tpid: tariff_plan_2.alias

      conn = get(conn, tp_attribute_path(conn, :index, tpid: tariff_plan_1.alias)) |> doc
      assert length(json_response(conn, 200)["data"]) == 1
    end

    test "filtering by tenant", %{conn: conn} do
      tariff_plan = insert :tariff_plan

      t1 = insert :tp_attribute, tpid: tariff_plan.alias
      t2 = insert :tp_attribute, tpid: tariff_plan.alias

      conn = get(conn, tp_attribute_path(conn, :index, tpid: tariff_plan.alias), filter: %{tenant: t1.tenant})
      |> doc
      assert length(json_response(conn, 200)["data"]) == 1
    end

    test "filtering by custom_id", %{conn: conn} do
      tariff_plan = insert :tariff_plan

      t1 = insert :tp_attribute, tpid: tariff_plan.alias
      t2 = insert :tp_attribute, tpid: tariff_plan.alias

      conn = get(conn, tp_attribute_path(conn, :index, tpid: tariff_plan.alias), filter: %{custom_id: t1.custom_id})
      |> doc
      assert length(json_response(conn, 200)["data"]) == 1
    end

    test "filtering by contexts", %{conn: conn} do
      tariff_plan = insert :tariff_plan

      t1 = insert :tp_attribute, tpid: tariff_plan.alias
      t2 = insert :tp_attribute, tpid: tariff_plan.alias

      conn = get(conn, tp_attribute_path(conn, :index, tpid: tariff_plan.alias), filter: %{contexts: t1.contexts})
      |> doc
      assert length(json_response(conn, 200)["data"]) == 1
    end

    test "filtering by filter_ids", %{conn: conn} do
      tariff_plan = insert :tariff_plan

      t1 = insert :tp_attribute, tpid: tariff_plan.alias
      t2 = insert :tp_attribute, tpid: tariff_plan.alias

      conn = get(conn, tp_attribute_path(conn, :index, tpid: tariff_plan.alias), filter: %{filter_ids: t1.filter_ids})
      |> doc
      assert length(json_response(conn, 200)["data"]) == 1
    end

    test "filtering by activation_interval", %{conn: conn} do
      tariff_plan = insert :tariff_plan

      t1 = insert :tp_attribute, tpid: tariff_plan.alias
      t2 = insert :tp_attribute, tpid: tariff_plan.alias

      conn = get(conn, tp_attribute_path(conn, :index, tpid: tariff_plan.alias), filter: %{activation_interval: t1.activation_interval})
      |> doc
      assert length(json_response(conn, 200)["data"]) == 1
    end

    test "filtering by field_name", %{conn: conn} do
      tariff_plan = insert :tariff_plan

      t1 = insert :tp_attribute, tpid: tariff_plan.alias
      t2 = insert :tp_attribute, tpid: tariff_plan.alias

      conn = get(conn, tp_attribute_path(conn, :index, tpid: tariff_plan.alias), filter: %{field_name: t1.field_name})
      |> doc
      assert length(json_response(conn, 200)["data"]) == 1
    end

    test "filtering by initial", %{conn: conn} do
      tariff_plan = insert :tariff_plan

      t1 = insert :tp_attribute, tpid: tariff_plan.alias
      t2 = insert :tp_attribute, tpid: tariff_plan.alias

      conn = get(conn, tp_attribute_path(conn, :index, tpid: tariff_plan.alias), filter: %{initial: t1.initial})
      |> doc
      assert length(json_response(conn, 200)["data"]) == 1
    end

    test "filtering by append", %{conn: conn} do
      tariff_plan = insert :tariff_plan

      t1 = insert :tp_attribute, tpid: tariff_plan.alias, append: true
      t2 = insert :tp_attribute, tpid: tariff_plan.alias, append: false

      conn = get(conn, tp_attribute_path(conn, :index, tpid: tariff_plan.alias), filter: %{append: true})
      |> doc
      assert length(json_response(conn, 200)["data"]) == 1
    end

    test "filtering by substitute", %{conn: conn} do
      tariff_plan = insert :tariff_plan

      t1 = insert :tp_attribute, tpid: tariff_plan.alias
      t2 = insert :tp_attribute, tpid: tariff_plan.alias

      conn = get(conn, tp_attribute_path(conn, :index, tpid: tariff_plan.alias), filter: %{substitute: t1.substitute})
      |> doc
      assert length(json_response(conn, 200)["data"]) == 1
    end

    test "filtering by blocker", %{conn: conn} do
      tariff_plan = insert :tariff_plan

      t1 = insert :tp_attribute, tpid: tariff_plan.alias, blocker: true
      t2 = insert :tp_attribute, tpid: tariff_plan.alias, blocker: false

      conn = get(conn, tp_attribute_path(conn, :index, tpid: tariff_plan.alias), filter: %{blocker: true})
      |> doc
      assert length(json_response(conn, 200)["data"]) == 1
    end

    test "filtering by weight", %{conn: conn} do
      tariff_plan = insert :tariff_plan

      t1 = insert :tp_attribute, tpid: tariff_plan.alias, weight: 1
      t2 = insert :tp_attribute, tpid: tariff_plan.alias, weight: 2

      conn = get(conn, tp_attribute_path(conn, :index, tpid: tariff_plan.alias), filter: %{weight: t1.weight})
      |> doc
      assert length(json_response(conn, 200)["data"]) == 1
    end
  end

  describe "GET show" do
    test "shows chosen resource", %{conn: conn} do
      tariff_plan = insert :tariff_plan
      tp_attribute = insert :tp_attribute, tpid: tariff_plan.alias

      conn = get(conn, tp_attribute_path(conn, :show, tp_attribute)) |> doc
      data = json_response(conn, 200)["data"]
      assert data["id"] == "#{tp_attribute.pk}"
      assert data["type"] == "tp-attribute"
      assert data["attributes"]["tpid"] == tp_attribute.tpid
      assert data["attributes"]["tenant"] == tp_attribute.tenant
      assert data["attributes"]["contexts"] == tp_attribute.contexts
      assert data["attributes"]["filter-ids"] == tp_attribute.filter_ids
      assert data["attributes"]["activation-interval"] == tp_attribute.activation_interval
      assert data["attributes"]["field-name"] == tp_attribute.field_name
      assert data["attributes"]["initial"] == tp_attribute.initial
      assert data["attributes"]["substitute"] == tp_attribute.substitute
      assert data["attributes"]["append"] == tp_attribute.append
      assert data["attributes"]["blocker"] == tp_attribute.blocker
      assert data["attributes"]["weight"] == "10.00"
    end

    test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
      assert_error_sent 404, fn ->
        get(conn, tp_attribute_path(conn, :show, -1)) |> doc
      end
    end
  end

  describe "GET export_to_csv" do
    test "returns status 'ok'", %{conn: conn} do
      tariff_plan = insert :tariff_plan
      insert :tp_attribute, tpid: tariff_plan.alias, blocker: true, tenant: "t1"
      insert :tp_attribute, tpid: tariff_plan.alias, blocker: false

      conn = conn
      |> get(tp_attribute_path(conn, :export_to_csv), %{tpid: tariff_plan.alias, filter: %{blocker: true, tenant: "t1"}})
      |> doc()
      assert conn.status == 200
    end
  end

  describe "POST create" do
    test "creates and renders resource when data is valid", %{conn: conn} do
      tariff_plan = insert :tariff_plan
      params = Map.merge params_for(:tp_attribute), %{tpid: tariff_plan.alias}

      conn = post(conn, tp_attribute_path(conn, :create), %{
        "meta" => %{},
        "data" => %{
          "type" => "tp_attribute",
          "attributes" => params,
        }
      }) |> doc

      assert json_response(conn, 201)["data"]["id"]
      assert Repo.get_by(TpAttribute, params)
    end

    test "does not create resource and renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, tp_attribute_path(conn, :create), %{
        "meta" => %{},
        "data" => %{
          "type" => "tp_attribute",
          "attributes" => %{field_name: nil},
        }
      }) |> doc

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "PATCH/PUT update" do
    test "updates and renders chosen resource when data is valid", %{conn: conn} do
      tariff_plan = insert :tariff_plan
      tp_attribute = insert :tp_attribute, tpid: tariff_plan.alias
      params = params_for(:tp_attribute)

      conn = put(conn, tp_attribute_path(conn, :update, tp_attribute), %{
        "meta" => %{},
        "data" => %{
          "type" => "tp_attribute",
          "id" => tp_attribute.pk,
          "attributes" => params,
        }
      }) |> doc

      assert json_response(conn, 200)["data"]["id"]
      assert Repo.get_by(TpAttribute, params)
    end

    test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
      tariff_plan = insert :tariff_plan
      tp_attribute = insert :tp_attribute, tpid: tariff_plan.alias

      conn = put(conn, tp_attribute_path(conn, :update, tp_attribute), %{
        "meta" => %{},
        "data" => %{
          "type" => "tp_attribute",
          "id" => tp_attribute.pk,
          "attributes" => %{field_name: nil},
        }
      }) |> doc

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "DELETE destroy" do
    test "deletes chosen resource", %{conn: conn} do
      tariff_plan = insert :tariff_plan
      tp_attribute = insert :tp_attribute, tpid: tariff_plan.alias

      conn = delete(conn, tp_attribute_path(conn, :delete, tp_attribute)) |> doc
      assert response(conn, 204)
      refute Repo.get(TpAttribute, tp_attribute.pk)
    end
  end

  describe "DELETE delete_all" do
    test "deletes all records by filter", %{conn: conn}  do
      tariff_plan = insert :tariff_plan

      tp_attribute1 = insert :tp_attribute, tpid: tariff_plan.alias, blocker: true, field_name: "field1"
      tp_attribute2 = insert :tp_attribute, tpid: tariff_plan.alias, blocker: false

      conn = conn
      |> post(tp_attribute_path(conn, :delete_all), %{tpid: tariff_plan.alias, filter: %{blocker: false}})

      assert Repo.get(TpAttribute, tp_attribute1.pk)
      refute Repo.get(TpAttribute, tp_attribute2.pk)
    end
  end
end
