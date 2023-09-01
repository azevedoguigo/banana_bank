defmodule BananaBank.Accounts do
  @moduledoc """
  Provides delegations for account-related modules and functions.
  """

  alias BananaBank.Accounts.Create
  alias BananaBank.Accounts.Transaction

  defdelegate create(params), to: Create, as: :call
  defdelegate transaction(params), to: Transaction, as: :call
end
