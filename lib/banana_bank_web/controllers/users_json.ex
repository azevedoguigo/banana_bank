defmodule BananaBankWeb.UsersJSON do
  alias BananaBank.Users.User

  def create(%{user: user}) do
    %{
      message: "Usuário criado com sucesso!",
      data: data(user)
    }
  end

  def get(%{user: user}), do: %{data: data(user)}

  def update(%{user: user}) do
    %{
      message: "Usuário atualizado com sucesso!",
      data: data(user)
    }
  end

  def delete(%{user: user}) do
    %{
      message: "Usuário deleteado com sucesso!",
      data: data(user)
    }
  end

  def login(%{token: token}) do
    %{
      message: "Usuário logado com sucesso!",
      token: token
    }
  end

  defp data(%User{} = user) do
    %{
      id: user.id,
      cep: user.cep,
      email: user.email,
      name: user.name
    }
  end
end
