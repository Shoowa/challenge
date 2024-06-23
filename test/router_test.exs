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


  test "vendor name" do
    result = Jason.encode!(%{
        "Address": "Assessors Block 3941/Lot001",
        "ExpirationDate": "11/15/2024 12:00:00 AM",
        "FoodItems": "Burgers: melts: hot dogs: burritos:sandwiches: fries: onion rings: drinks",
        "Latitude": "37.764741322674965",
        "Longitude": "-122.38712481217911",
        "Status": "APPROVED",
        "dayshours": ""
    })

    conn = conn(:get, "/v0/vendor/Natan's Catering")
    conn = Challenge.Router.call(conn, @opts)
    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == result
  end


  test "one burger" do
    result = Jason.encode!(%{
    "Natan's Catering": %{
        "Address": "Assessors Block 3941/Lot001",
        "ExpirationDate": "11/15/2024 12:00:00 AM",
        "FoodItems": "Burgers: melts: hot dogs: burritos:sandwiches: fries: onion rings: drinks",
        "Latitude": "37.764741322674965",
        "Longitude": "-122.38712481217911",
        "Status": "APPROVED",
        "dayshours": ""
        }
    })

    conn = conn(:get, "/v0/food/burger")
    conn = Challenge.Router.call(conn, @opts)
    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == result
  end


end
