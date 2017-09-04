  defmodule CgratesWebJsonapi.DestinationController do
  use CgratesWebJsonapi.Web, :controller

  alias CgratesWebJsonapi.Destination
  alias CgratesWebJsonapi.Cgrates.DestinationRepo
  alias JaSerializer.Params

  plug :scrub_params, "data" when action in [:create, :update]

  def index(conn, _params) do
    destinations = DestinationRepo.all
    render(conn, "index.json-api", data: destinations)
  end

  def create(conn, %{"data" => data = %{"type" => "destination", "attributes" => _destination_params}}) do
    changeset = Destination.changeset(%Destination{}, Params.to_attributes(data))

    case DestinationRepo.insert(changeset) do
      {:ok, destination} ->
        destination |> IO.inspect
        conn
        |> put_status(:created)
        |> put_resp_header("location", destination_path(conn, :show, destination))
        |> render("show.json-api", data: destination)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:errors, data: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    destination = DestinationRepo.get!(id) |> IO.inspect
    render(conn, "show.json-api", data: destination)
  end

  def update(conn, %{"id" => id, "data" => data = %{"type" => "destination", "attributes" => _destination_params}}) do
    destination = DestinationRepo.get!(Destination, id)
    changeset = Destination.changeset(destination, Params.to_attributes(data))

    case DestinationRepo.insert(changeset) do
      {:ok, destination} ->
        render(conn, "show.json-api", data: destination)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:errors, data: changeset)
    end
  end

  # def delete(conn, %{"id" => id}) do
  #   destination = Repo.get!(Destination, id)
  #
  #   # Here we use delete! (with a bang) because we expect
  #   # it to always work (and if it does not, it will raise).
  #   Repo.delete!(destination)
  #
  #   send_resp(conn, :no_content, "")
  # end

end