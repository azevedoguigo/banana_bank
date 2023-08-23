defmodule BananaBankWeb.AccountsTest do
  use BananaBankWeb.ConnCase

  import Mox

  alias BananaBank.Users.User
  alias BananaBank.Users

  setup do
    user_params = %{
      "name" => "azevedoguigo",
      "email" => "azevedoguigo@example.com",
      "password" => "supersenha",
      "cep" => "01001000"
    }

    via_cep_body_response = %{
      "bairro" => "Sé",
      "cep" => "01001-000",
      "complemento" => "lado ímpar",
      "ddd" => "11",
      "gia" => "1004",
      "ibge" => "3550308",
      "localidade" => "São Paulo",
      "logradouro" => "Praça da Sé",
      "siafi" => "7107",
      "uf" => "SP"
    }

    {:ok, %{user_params: user_params, body: via_cep_body_response}}
  end

  describe "create/2" do
    test "Creates the account when all parameters are valid.", %{conn: conn, user_params: user_params, body: body} do
      expect(BananaBank.ViaCep.ClientMock, :call, fn "01001000" ->
        {:ok, body}
      end)

      {:ok, %User{id: id}} = Users.create(user_params)

      account_params = %{
        "user_id" => id,
        "balance" => 100,
      }

      response =
        conn
        |> post(~p"/api/accounts", account_params)
        |> json_response(:created)

      assert %{
        "data" => %{
            "balance" => "100",
            "id" => _id
          },
          "message" => "Conta criada com sucesso!"
        } = response
    end

    test "Returns an error if the user tries to create more than one account.", %{conn: conn, user_params: user_params, body: body} do
      expect(BananaBank.ViaCep.ClientMock, :call, fn "01001000" ->
        {:ok, body}
      end)

      {:ok, %User{id: id}} = Users.create(user_params)

      account_params = %{
        "user_id" => id,
        "balance" => 100,
      }

      conn
        |> post(~p"/api/accounts", account_params)
        |> json_response(:created)

      response =
        conn
        |> post(~p"/api/accounts", account_params)
        |> json_response(:bad_request)

      assert %{"errors" => %{"user_id" => ["has already been taken"]}} == response
    end

    test "Returns an error when id does not belong to any user.", %{conn: conn} do
      account_params = %{
        "user_id" => 999,
        "balance" => 100,
      }

      response =
        conn
        |> post(~p"/api/accounts", account_params)
        |> json_response(:not_found)

      assert %{"message" => "Usuário não encontrado!", "status" => 404} == response
    end

    test "Returns an error when the balance is negative.", %{conn: conn, user_params: user_params, body: body} do
      expect(BananaBank.ViaCep.ClientMock, :call, fn "01001000" ->
        {:ok, body}
      end)

      {:ok, %User{id: id}} = Users.create(user_params)

      account_params = %{
        "user_id" => id,
        "balance" => -100,
      }

      response =
        conn
        |> post(~p"/api/accounts", account_params)
        |> json_response(:bad_request)

      assert %{"errors" => %{"balance" => ["is invalid"]}} == response
    end
  end
end
