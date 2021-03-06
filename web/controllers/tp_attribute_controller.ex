defmodule CgratesWebJsonapi.TpAttributeController do
  use CgratesWebJsonapi.Web, :controller
  use JaResource
  use CgratesWebJsonapi.TpSubresource
  use CgratesWebJsonapi.DefaultSorting
  use CgratesWebJsonapi.CsvExport
  use CgratesWebJsonapi.DeleteAll

  alias CgratesWebJsonapi.TpAttribute

  plug JaResource

  def handle_show(conn, id), do: Repo.get!(TpAttribute, id)

  def filter(_conn, query, "tenant", val),              do: query |> where([r], like(r.tenant, ^"%#{val}%"))
  def filter(_conn, query, "custom_id", val),           do: query |> where([r], like(r.custom_id, ^"%#{val}%"))
  def filter(_conn, query, "contexts", val),            do: query |> where([r], like(r.contexts, ^"%#{val}%"))
  def filter(_conn, query, "filter_ids", val),          do: query |> where([r], like(r.filter_ids, ^"%#{val}%"))
  def filter(_conn, query, "activation_interval", val), do: query |> where([r], like(r.activation_interval, ^"%#{val}%"))
  def filter(_conn, query, "field_name", val),          do: query |> where([r], like(r.field_name, ^"%#{val}%"))
  def filter(_conn, query, "initial", val),             do: query |> where([r], like(r.initial, ^"%#{val}%"))
  def filter(_conn, query, "append", val),              do: query |> where(append: ^val)
  def filter(_conn, query, "substitute", val),          do: query |> where([r], like(r.substitute, ^"%#{val}%"))
  def filter(_conn, query, "blocker", val),             do: query |> where(blocker: ^val)
  def filter(_conn, query, "weight", val),              do: query |> where(weight: ^val)

  defp build_query(conn, params) do
    conn
    |> handle_index(params)
    |> JaResource.Index.filter(conn, __MODULE__)
  end
end
