defmodule BananaBank.Users do
  @moduledoc """
  Provides delegations for user-related modules and functions.
  """

  alias BananaBank.Users.Create
  alias BananaBank.Users.Get
  alias BananaBank.Users.Update

  defdelegate create(params), to: Create, as: :call
  defdelegate get(id), to: Get, as: :call
  defdelegate update(params), to: Update, as: :call
end
