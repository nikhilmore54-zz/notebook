defmodule Notebook.Note do
  use Notebook.Web, :model

  schema "notes" do
    field :title, :string
    field :body, :string
    belongs_to :user, Notebook.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  @required_fields ~w(title)a
  @optional_fields ~w(body)a

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> assoc_constraint(:user)
  end
end
