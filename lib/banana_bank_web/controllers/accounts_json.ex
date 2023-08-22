defmodule BananaBankWeb.AccountsJSON do
  alias BananaBank.Accounts.Account

  def create(%{account: account}) do
    %{
      message: "Conta criada com sucesso!",
      data: data(account)
    }
  end

  defp data(%Account{} = account) do
    %{
      id: account.id,
      balance: account.balance
    }
  end
end
