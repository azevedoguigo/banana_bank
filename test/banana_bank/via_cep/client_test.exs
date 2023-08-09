defmodule BananaBank.ViaCep.ClientTest do
  use ExUnit.Case, async: true

  alias BananaBank.ViaCep.Client

  setup do
    bypass = Bypass.open()
    {:ok, bypass: bypass}
  end

  describe "call/1" do
    test "Returns a tuple with :ok and the location data when the zip code is valid.", %{bypass: bypass} do
      cep = "01001000"

      body = ~s({
        "bairro": "Sé",
        "cep": "01001-000",
        "complemento": "lado ímpar",
        "ddd": "11",
        "gia": "1004",
        "ibge": "3550308",
        "localidade": "São Paulo",
        "logradouro": "Praça da Sé",
        "siafi": "7107",
        "uf": "SP"
      })

      Bypass.expect(bypass, fn conn ->
        conn
        |> Plug.Conn.put_resp_content_type("application/json")
        |> Plug.Conn.resp(200, body)
      end)

      response =
        bypass.port
        |> endpoint_url()
        |> Client.call(cep)

      expected_response = {
        :ok,
        %{
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
      }

      assert expected_response == response
    end

    test "returns a tuple with :error and a map with status code and message if CEP is not found.", %{bypass: bypass} do
      cep = "00000000"

      Bypass.expect(bypass, fn conn ->
        conn
        |> Plug.Conn.put_resp_content_type("application/json")
        |> Plug.Conn.resp(200, ~s({"erro": true}))
      end)

      response =
        bypass.port
        |> endpoint_url()
        |> Client.call(cep)

      expected_response = {
        :error,
        %{
          message: "CEP não encontrado!",
          status: :not_found
        }
      }

      assert expected_response == response
    end

    test "Returns an error if the CEP is invalid.", %{bypass: bypass} do
      cep = "invalid"

      Bypass.expect(bypass, fn conn ->
        conn
        |> Plug.Conn.resp(400, "")
      end)

      response =
        bypass.port
        |> endpoint_url()
        |> Client.call(cep)

      expected_response =
        {
          :error,
          %{
            message: "Erro ao validar o CEP! Verifique e tente novamente.",
            status: :bad_request
          }
        }

      assert expected_response == response
    end

    test "returns an internal server error when the connection fails.", %{bypass: bypass} do
      cep = "01001000"

      Bypass.down(bypass)

      response =
        bypass.port
        |> endpoint_url()
        |> Client.call(cep)

      assert {:error, :internal_server_error} == response
    end
  end

  defp endpoint_url(port), do: "http://localhost:#{port}"
end
