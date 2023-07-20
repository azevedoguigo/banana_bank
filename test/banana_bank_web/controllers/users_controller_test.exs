defmodule BananaBankWeb.UsersControllerTest do
  use BananaBankWeb.ConnCase

  alias BananaBank.Users.User
  alias BananaBank.Users

  describe "create/2" do
    test "success in creating a user.", %{conn: conn} do
      params = %{
        name: "azevedoguigo",
        email: "azevedoguigo@example.com",
        password: "supersenha",
        cep: "12345678"
      }

      response =
        conn
        |> post(~p"/api/users", params)
        |> json_response(:created)

      assert %{
        "data" => %{
            "cep" => "12345678",
            "email" => "azevedoguigo@example.com",
            "id" => _id,
            "name" => "azevedoguigo"
          },
          "message" => "Usuário criado com sucesso!"
        } = response
    end

    test "When there are invalid parameters, it returns an error.", %{conn: conn} do
      params = %{
        name: "azevedoguigo",
        email: "azevedoguigo.example.com", # Invalid email format.
        password: "123", # Very short password.
        cep: "12345678"
      }

      response =
        conn
        |> post(~p"/api/users", params)
        |>json_response(:bad_request)

      assert %{
        "errors" => %{
          "email" => ["has invalid format"],
          "password" => ["should be at least 6 character(s)"]
        }
      } == response
    end
  end

  describe "get/2" do
    test "When the id is a registered user, it returns the user.", %{conn: conn} do
      params = %{
        name: "azevedoguigo",
        email: "azevedoguigo@example.com",
        password: "supersenha",
        cep: "12345678"
      }

      {:ok, %User{id: user_id}} = Users.create(params)

      response =
        conn
        |> get(~p"/api/users/#{user_id}")
        |> json_response(:ok)

      assert %{
        "data" => %{
          "cep" => "12345678",
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

      assert %{"message" => "Usuário não cadastrado.", "status" => 404} == response
    end
  end

  describe "update/2" do
    test "Updates and returns the user as long as the parameters are valid.", %{conn: conn} do
      params = %{
        name: "azevedoguigo",
        email: "azevedoguigo@example.com",
        password: "supersenha",
        cep: "12345678"
      }

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
          "cep" => "12345678",
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

      assert %{"message" => "Usuário não cadastrado.", "status" => 404} == response
    end

    test "Returns an error if the parameters are invalid.", %{conn: conn} do
      params = %{
        name: "azevedoguigo",
        email: "azevedoguigo@example.com",
        password: "supersenha",
        cep: "12345678"
      }

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
    test "Deletes a user if the id is linked to a user.", %{conn: conn} do
      params = %{
        name: "azevedoguigo",
        email: "azevedoguigo@example.com",
        password: "supersenha",
        cep: "12345678"
      }

      {:ok, %User{id: user_id}} = Users.create(params)

      response =
        conn
        |> delete(~p"/api/users/#{user_id}")
        |> json_response(:ok)

      assert %{
        "data" => %{
          "cep" => "12345678",
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

      assert %{"message" => "Usuário não cadastrado.", "status" => 404} == response
    end
  end
end
