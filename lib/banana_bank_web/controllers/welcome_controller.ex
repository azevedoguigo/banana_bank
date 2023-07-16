defmodule BananaBankWeb.WelcomeController do
  use BananaBankWeb, :controller

  def index(conn, _) do
    IO.inspect(conn)

    conn
    |> put_status(:ok)
    |> json(%{message: "Bem vindo(a) ao Banana Bank!"})
  end
end
