defmodule BananaBank.Users.Delete do
  alias BananaBank.Users
  alias BananaBank.Repo

  def call(id) do
    case Users.get(id) do
      {:error, error_data} -> {:error, error_data}
      {:ok, user} -> Repo.delete(user)
    end
  end
end
