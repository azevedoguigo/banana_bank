defmodule BananaBank.Users.Get do
  alias BananaBank.Users.User
  alias BananaBank.Repo

  def call(id) do
    case Repo.get(User, id) do
      nil ->
        {:error, %{status: :not_found, message: "Usuário não encontrado!"}}
      user ->
        {:ok, user}
    end
  end
end
