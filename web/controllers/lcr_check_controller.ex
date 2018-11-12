defmodule CgratesWebJsonapi.LcrCheckController do
  use CgratesWebJsonapi.Web, :controller
  alias CgratesWebJsonapi.Cgrates.Adapter

  def create(conn, params) do
    lcr_params = %{
      IgnoreErrors: true,
      ID: params["account"],
      Event: %{
        Account: params["account"],
        Destination: params["destination"],
        Subject: params["subject"],
        Category: params["category"],
        Duration: params["duration"],
        SetupTime: DateTime.utc_now |> DateTime.to_string
      }
    }

    cgrates_response = Adapter.execute(%{method: "SupplierSv1.GetSuppliers", params: lcr_params})

    conn
    |> put_status(:created)
    |> json(cgrates_response)
  end
end
