defmodule BananaBankWeb.Plugs.Auth do
  import Plug.Conn

  alias BananaBankWeb.Token

  def init(opts), do: opts

  def call(conn, _opts) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, data} <- Token.verify(token) do
      assign(conn, :user_id, data)
    else
      _error ->
        conn
        |> put_status(:unauthorized)
        |> Phoenix.Controller.put_view(json: BananaBankWeb.ErrorJSON)
        |> Phoenix.Controller.render(:error, %{status: :unauthorized, message: "Faça login para realizar a operação"})
        |> halt()
    end
  end
end
