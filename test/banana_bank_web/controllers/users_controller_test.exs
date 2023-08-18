defmodule BananaBankWeb.UsersControllerTest do
  use BananaBankWeb.ConnCase

  import Mox

  alias BananaBank.Users.User
  alias BananaBank.Users

  setup do
    params = %{
      "name" => "azevedoguigo",
      "email" => "azevedoguigo@example.com",
      "password" => "supersenha",
      "cep" => "01001000"
    }

    body = %{
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

    {:ok, %{user_params: params, body: body}}
  end

  describe "create/2" do
    test "Creates and returns the user when all parameters are valid.", %{conn: conn, user_params: params, body: body} do
      expect(BananaBank.ViaCep.ClientMock, :call, fn "01001000" ->
        {:ok, body}
      end)

      response =
        conn
        |> post(~p"/api/users", params)
        |> json_response(:created)

      assert %{
        "data" => %{
            "cep" => "01001000",
            "email" => "azevedoguigo@example.com",
            "id" => _id,
            "name" => "azevedoguigo"
          },
          "message" => "Usuário criado com sucesso!"
        } = response
    end

    test "When there are invalid parameters, it returns an error.", %{conn: conn, body: body} do
      params = %{
        "name" => "azevedoguigo",
        "email" => "azevedoguigo.example.com", # Invalid email format.
        "password" => "123", # Very short password.
        "cep" => "01001000"
      }

      expect(BananaBank.ViaCep.ClientMock, :call, fn "01001000" ->
        {:ok, body}
      end)

      response =
        conn
        |> post(~p"/api/users", params)
        |> json_response(:bad_request)

      assert %{
        "errors" => %{
          "email" => ["has invalid format"],
          "password" => ["should be at least 6 character(s)"]
        }
      } == response
    end

    test "Returns an error message and status code when the CEP is not found.", %{conn: conn} do
      params = %{
        "name" => "azevedoguigo",
        "email" => "azevedoguigo@example.com",
        "password" => "supersenha",
        "cep" => "12345678"
      }

      expect(BananaBank.ViaCep.ClientMock, :call, fn "12345678" ->
        {:error, %{message: "CEP não encontrado!", status: :not_found}}
      end)

      response =
        conn
        |> post(~p"/api/users", params)
        |> json_response(:not_found)

      assert %{"message" => "CEP não encontrado!", "status" => 404} == response
    end
  end

  describe "get/2" do
    test "When the id is a registered user, it returns the user.", %{conn: conn, user_params: params, body: body} do
      expect(BananaBank.ViaCep.ClientMock, :call, fn "01001000" ->
        {:ok, body}
      end)

      {:ok, %User{id: user_id}} = Users.create(params)

      response =
        conn
        |> get(~p"/api/users/#{user_id}")
        |> json_response(:ok)

      assert %{
        "data" => %{
          "cep" => "01001000",
          "email" => "azevedoguigo@example.com",
          "id" => user_id,
          "name" => "azevedoguigo"
        }
      } == response
    end

    test "When the id does not belong to any user, it returns an error message.", %{conn: conn} do
      response =
        conn
        |> get(~p"/api/users/2077")
        |> json_response(:not_found)

      assert %{"message" => "Usuário não encontrado!", "status" => 404} == response
    end
  end

  describe "update/2" do
    test "Updates and returns the user as long as the parameters are valid.", %{conn: conn, user_params: params, body: body} do
      expect(BananaBank.ViaCep.ClientMock, :call, fn "01001000" ->
        {:ok, body}
      end)

      {:ok, %User{id: user_id}} = Users.create(params)

      params_to_update = %{
        "name" => "updated name"
      }

      response =
        conn
        |> put(~p"/api/users/#{user_id}", params_to_update)
        |> json_response(:ok)

      assert %{
        "data" => %{
          "cep" => "01001000",
          "email" => "azevedoguigo@example.com",
          "id" => user_id,
          "name" => "updated name"
        },
        "message" => "Usuário atualizado com sucesso!"
      } == response
    end

    test "Returns an error if the id is not linking to an existing user.", %{conn: conn} do
      params_to_update = %{
        "name" => "updated name"
      }

      response =
        conn
        |> put(~p"/api/users/2077", params_to_update)
        |> json_response(:not_found)

      assert %{"message" => "Usuário não encontrado!", "status" => 404} == response
    end

    test "Returns an error if the parameters are invalid.", %{conn: conn, user_params: params, body: body} do
      expect(BananaBank.ViaCep.ClientMock, :call, fn "01001000" ->
        {:ok, body}
      end)

      {:ok, %User{id: user_id}} = Users.create(params)

      update_with_invalid_email = %{"email" => "azevedoguigo.example.com"}

      response =
        conn
        |> put(~p"/api/users/#{user_id}", update_with_invalid_email)
        |> json_response(:bad_request)

      assert %{"errors" => %{"email" => ["has invalid format"]}} == response
    end
  end

  describe "delete/2" do
    test "Deletes a user if the id is linked to a user.", %{conn: conn, user_params: params, body: body} do
      expect(BananaBank.ViaCep.ClientMock, :call, fn "01001000" ->
        {:ok, body}
      end)

      {:ok, %User{id: user_id}} = Users.create(params)

      response =
        conn
        |> delete(~p"/api/users/#{user_id}")
        |> json_response(:ok)

      assert %{
        "data" => %{
          "cep" => "01001000",
          "email" => "azevedoguigo@example.com",
          "id" => user_id,
          "name" => "azevedoguigo"
        },
        "message" => "Usuário deleteado com sucesso!"
      } == response
    end

    test "Returns an error if the id is not linked to any user.", %{conn: conn} do
      response =
        conn
        |> delete(~p"/api/users/2077")
        |> json_response(:not_found)

      assert %{"message" => "Usuário não encontrado!", "status" => 404} == response
    end
  end
end
