# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Notebook.Repo.insert!(%Notebook.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Notebook.Repo
alias Notebook.User

admin_params = %{ name: "Admin User",
                  email: "admin@test.com",
                  password: "password",
                  is_admin: true}

unless Repo.get_by(User, email: admin_params[:email]) do
  %User{ }
  |> User.registration_changeset(admin_params)
  |> Repo.insert!
end
