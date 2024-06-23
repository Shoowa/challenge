defmodule Challenge.Router do
  @moduledoc """
  Provides RESTful functions to read JSON records.
  """

  use Plug.Router
  use Plug.ErrorHandler
  require Jason


  @corpname "saasprovider"


  plug Plug.Logger
  plug :match
  plug Plug.Parsers, parsers: [:json], pass: ["application/json"], json_decoder: Jason
  plug :dispatch


  get "/health" do
    render_json conn, %{message: "OK"}
  end


  # Handles any unmatched request as a 404.
  match _ do
    send_resp(conn, 404, "Oops!")
  end


  @impl Plug.ErrorHandler
  def handle_errors(conn, %{kind: _kind, reason: _reason, stack: _stack}) do
    send_resp(conn, conn.status, "Something went wrong")
  end


  defp render_json(conn, data) do
    body = Jason.encode! data
    conn
    |> put_resp_content_type("application/json")
    |> put_resp_header("company", @corpname)
    |> send_resp(200, body)
  end


end
