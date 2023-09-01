defmodule BananaBankWeb.FallbackController do
  use BananaBankWeb, :controller

  def call(conn, {:error, %{status: :not_found} = error_data}) do
    conn
    |> put_status(:not_found)
    |> put_view(json: BananaBankWeb.ErrorJSON)
    |> render(:error, error_data: error_data)
  end

  def call(conn, {:error, %{status: :bad_request} = error_data}) do
    conn
    |> put_status(:bad_request)
    |> put_view(json: BananaBankWeb.ErrorJSON)
    |> render(:error, error_data: error_data)
  end

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:bad_request)
    |> put_view(json: BananaBankWeb.ErrorJSON)
    |> render(:error, changeset: changeset)
  end

  def call(conn, {:error, message}) do
    conn
    |> put_status(:bad_request)
    |> put_view(json: BananaBankWeb.ErrorJSON)
    |> render(:error, message: message)
  end
end
