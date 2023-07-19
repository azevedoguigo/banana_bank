defmodule BananaBank.Users do
  @moduledoc """
  Provides delegations for user-related modules and functions.
  """

  alias BananaBank.Users.Create

  defdelegate create(params), to: Create, as: :call
end
