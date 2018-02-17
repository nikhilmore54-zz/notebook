defmodule Notebook.PageController do
  use Notebook.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
