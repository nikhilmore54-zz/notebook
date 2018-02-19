defmodule Notebook.NoteController do
  use Notebook.Web, :controller

  alias Notebook.Note
  alias Notebook.User

  plug :scrub_params, "note" when action in [:create, :update]

  def action(conn, _) do
    apply(__MODULE__, action_name(conn),
          [conn, conn.params, conn.assigns.current_user])
  end

  defp user_note_by_id(user, note_id) do
    user
    |> user_notes
    |> Repo.get(note_id)
  end

  defp user_notes(user) do
    assoc(user, :notes)
  end

  def index(conn, %{"user_id" => user_id}, _current_user) do
    user = User |> Repo.get!(user_id )

    notes =
      user
      |> user_notes
      |> Repo.all
      |> Repo.preload(:user)

    render(conn, "index.html", notes: notes, user: user)
  end

  def show(conn, %{"user_id" => user_id, "id" => id}, _current_user) do
    user = User |> Repo.get!(user_id)

    note = user |> user_note_by_id(id) |> Repo.preload(:user)

    render(conn, "show.html", note: note, user: user)
  end

  def new(conn, _params, current_user) do
    changeset =
      current_user
      |> build_assoc(:notes)
      |> Note.changeset

      render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"note" => note_params}, current_user) do
    changeset =
      current_user
      |> build_assoc(:notes)
      |> Note.changeset(note_params)

    case Repo.insert(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Post was created successfully")
        |> redirect(to: user_note_path(conn, :index, current_user.id))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}, current_user) do
    note = current_user |> user_note_by_id(id)

    if note do
      changeset = Note.changeset(note)

      render(conn, "edit.html", note: note, changeset: changeset)
    else
      conn
      |> put_status(:not_found)
      |> render(Notebook.ErrorView, "404.html")
    end
  end

  def update(conn, %{"id" => id, "note" => note_params}, current_user) do
    note = current_user |> user_note_by_id(id)

    changeset = Note.changeset(note, note_params)

    case Repo.update(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Note was updated successfully")
        |> redirect(to: user_note_path(conn, :show, current_user.id, note.id))
      {:error, changeset} ->
        render(conn, "edit.html", note: note, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id, "user_id" => user_id}, current_user) do
    user = User |> Repo.get!(user_id)

    note = user |> user_note_by_id(id) |> Repo.preload(:user)

    if current_user.id == note.user.id || current_user.is_admin do
      Repo.delete!(note)

      conn
      |> put_flash(:info, "Note was deleted successfully")
      |> redirect(to: user_note_path(conn, :index, current_user.id))
    else
      conn
      |> put_flash(:info, "You can't delete this post")
      |> redirect(to: user_note_path(conn, :show, user.id, note.id))
    end
  end
end
