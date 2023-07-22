defmodule BananaBank.Users.Update do
  alias BananaBank.Users.User
  alias BananaBank.Users
  alias BananaBank.Repo

  def call(%{"id" => id} = params) do
    case Users.get(id) do
      {:error, error_data} -> {:error, error_data}
      {:ok, user} -> update(user, params)
    end
  end

  defp update(user, params) do
    user
    |> User.changeset(params)
    |> Repo.update()
  end
end
