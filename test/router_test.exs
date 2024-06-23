defmodule RouterTest do
  use ExUnit.Case, async: true
  use Plug.Test
  require Jason


  @opts Challenge.Router.init([])


  test "health" do
    conn = conn(:get, "/health")
    conn = Challenge.Router.call(conn, @opts)
    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "{\"message\":\"OK\"}"
  end


  test "404" do
    conn = conn(:get, "/nothing")
    conn = Challenge.Router.call(conn, @opts)
    assert conn.state == :sent
    assert conn.status == 404
    assert conn.resp_body == "Oops!"
  end


end
