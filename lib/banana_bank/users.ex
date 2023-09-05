defmodule BananaBank.Users do
  @moduledoc """
  Provides delegations for user-related modules and functions.
  """

  alias BananaBank.Users.Create
  alias BananaBank.Users.Get
  alias BananaBank.Users.Update
  alias BananaBank.Users.Delete
  alias BananaBank.Users.Auth

  defdelegate create(params), to: Create, as: :call
  defdelegate get(id), to: Get, as: :call
  defdelegate update(params), to: Update, as: :call
  defdelegate delete(id), to: Delete, as: :call
  defdelegate auth(params), to: Auth, as: :call
end
