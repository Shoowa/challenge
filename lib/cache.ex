defmodule Cache do
  @moduledoc """
  Documentation for 'Cache'
  """
  use GenServer
  import Fetcher, only: [read_csv_file: 1, filter_data: 1]
  require Logger


  @table :lunch
  @bizname "Applicant"


  def start_link(state \\ "") do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end


  @impl true
  def init(state) do
    create_table(@table)
    load_lunch_info(state)
    {:ok, state}
  end


  defp create_table(name) do
    Logger.info("Creating a new ETS table... #{name}")
    options = [
      :named_table,
      :set,
      :protected,
      read_concurrency: true
    ]
    :ets.new(name, options)
  end


  @doc ~s"""
  Read from a CSV file and write to a GenServer governing an ETS table.

      iex> :ets.lookup(:lunch, "Natan's Catering") |> length()
      1

  """
  @spec load_lunch_info(binary()) :: Enum.t
  def load_lunch_info(file_name) do
    read_csv_file(file_name)
    |> filter_data
    |> Enum.map( &internal_write/1 )
  end


  defp internal_write(data) do
    d = data |> Map.pop!(@bizname)
    :ets.insert(@table, d)
  end


  @doc ~S"""
  Display data about a single food truck.

      iex> Cache.read_vendor("San Francisco Taco Truck")
      %{
          "Address" => "345 WILLIAMS AVE",
          "ExpirationDate" => "11/15/2024 12:00:00 AM",
          "FoodItems" => "Tacos: Tortas: Burritos",
          "Latitude" => "37.72980548057414",
          "Longitude" => "-122.39924710472444",
          "Status" => "APPROVED",
          "dayshours" => ""
      }

  """
  @spec read_vendor(String.t()) :: map()
  def read_vendor(vendor), do: GenServer.call(__MODULE__, {:read_vendor, vendor})


  @impl true
  def handle_call({:read_vendor, vendor}, _from, state) do
    response = read_key(vendor)
    {:reply, response, state}
  end


  defp read_key(key) do
    case :ets.lookup(@table, key) do
      [{_, response}] -> response
      [] -> nil
      _ -> nil
    end
  end


end
