defmodule BananaBank.Accounts.Transaction do
  @moduledoc """
  Module responsible for the transaction between accounts.
  """

  alias Ecto.Multi
  alias BananaBank.Accounts.Account
  alias BananaBank.Repo

  def call(from_id, to_id, value) do
    with %Account{} = from_account <- Repo.get(Account, from_id),
         %Account{} = to_account <- Repo.get(Account, to_id),
         {:ok, value} <- Decimal.cast(value) do

      Multi.new()
      |> withdraw(from_account, value)
      |> deposit(to_account, value)
      |> Repo.transaction()
    else
      nil -> {:error, :not_found}
      :error -> {:error, "Invalid value"}
    end
  end

  defp withdraw(multi, from_account, value) do
    new_balance = Decimal.sub(from_account.balance, value)
    changeset = Account.changeset(from_account, %{balance: new_balance})
    Multi.update(multi, :withdraw, changeset)
  end

  defp deposit(multi, to_account, value) do
    new_balance = Decimal.add(to_account.balance, value)
    changeset = Account.changeset(to_account, %{balance: new_balance})
    Multi.update(multi, :deposit, changeset)
  end
end
