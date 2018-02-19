defmodule Notebook.Admin.UserController do
  use Notebook.Web, :controller

  alias Notebook. User

  def index(conn, _params) do
    users = Repo.all(User)

    render(conn, "index.html", users: users)
  end
end
