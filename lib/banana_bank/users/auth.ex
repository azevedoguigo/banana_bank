defmodule BananaBank.Users.Auth do
  @moduledoc """
  Module responsible for user authentication.
  """

  alias BananaBank.Users

  def call(%{"id" => user_id, "password" => password} = _params) do
    case Users.get(user_id) do
      {:ok, user} -> handle_password_check(user, password)
      {:error, error_data} -> {:error, error_data}
    end
  end

  defp handle_password_check(user, password) do
    case Argon2.verify_pass(password, user.password_hash) do
      true -> {:ok, user}
      false -> {:error, %{message: "Senha inválida!", status: :unauthorized}}
    end
  end
end
