defmodule BananaBankWeb.Token do
  @moduledoc """
  Module responsible for handling tokens.
  """
  alias Phoenix.Token
  alias BananaBankWeb.Endpoint

  @sign_salt "dev_test"

  def sign(user) do
    Token.sign(Endpoint, @sign_salt, user.id)
  end

  def verify(token) do
    case Token.verify(Endpoint, @sign_salt, token, max_age: 28800) do
      {:ok, data} -> {:ok, data}
      {:error, reason} -> {:error, %{message: reason, status: :unauthorized}}
    end
  end
end
