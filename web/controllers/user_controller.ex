defmodule CgratesWebJsonapi.UserController do
  use CgratesWebJsonapi.Web, :controller
  use JaResource

  alias CgratesWebJsonapi.User
  alias JaSerializer.Params

  plug JaResource

  def handle_show(conn, id), do: Repo.get!(User, id)

  def handle_create(conn, attributes) do
    User.registration_changeset(%User{}, attributes)
  end
end
