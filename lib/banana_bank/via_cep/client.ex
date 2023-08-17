defmodule BananaBank.ViaCep.Client do
  @moduledoc """
  Provide the function responsible for making requests to the ViaCEP external service for CEP validation.
  """

  @behaviour BananaBank.ViaCep.ClientBehavior

  use Tesla

  plug Tesla.Middleware.JSON

  @default_url "https://viacep.com.br/ws"

  @impl BananaBank.ViaCep.ClientBehavior
  def call(url \\ @default_url, cep) do
    "#{url}/#{cep}/json"
    |> get()
    |> handle_response()
  end

  defp handle_response({:ok, %Tesla.Env{status: 200, body: %{"erro" => true}}}) do
    {
      :error,
      %{
        status: :not_found,
        message: "CEP não encontrado!"
      }
    }
  end

  defp handle_response({:ok, %Tesla.Env{status: 200, body: body}}) do
    {:ok, body}
  end

  defp handle_response({:ok, %Tesla.Env{status: 400}}) do
    {
      :error,
      %{
        status: :bad_request,
        message: "Erro ao validar o CEP! Verifique e tente novamente."
      }
    }
  end

  defp handle_response({:error, _}) do
    {:error, :internal_server_error}
  end
end
