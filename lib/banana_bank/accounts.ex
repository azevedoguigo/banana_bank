defmodule BananaBank.Accounts do
  @moduledoc """
  Provides delegations for account-related modules and functions.
  """

  alias BananaBank.Accounts.Create

  defdelegate create(params), to: Create, as: :call
end
