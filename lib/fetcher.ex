defmodule Fetcher do
  @moduledoc """
  Documentation for `Fetcher`.
  """

  import File, only: [stream!: 1]
  require Logger
  require CSV


  @bizname "Applicant"
  @addr "Address"
  @status "Status"
  @food "FoodItems"
  @lat "Latitude"
  @long "Longitude"
  @schedule "dayshours"
  @expire "ExpirationDate"


  defp read_csv_file(name) do
    Logger.info("Reading CSV file... #{name}")
    stream!(name) |> CSV.decode!(headers: true, validate_row_length: true)
  end


  defp desired_columns() do
    [
      @bizname,
      @addr,
      @status,
      @food,
      @lat,
      @long,
      @schedule,
      @expire
    ]
  end


  @doc ~S"""
  Identify and retain only `APPROVED` records.
  """
  @spec status_approved(map()) :: boolean()
  def status_approved(entry) do
    entry[@status] == "APPROVED"
  end


  @doc ~S"""
  Shrink the size of the CSV table to a relevant subset of columns and eligible records.

      iex> Fetcher.filter_data([%{
      ...> "Address" => "3201 03RD ST",
      ...> "blocklot" => "5660091",
      ...> "Applicant" => "Natan's Catering",
      ...> "ExpirationDate" => "11/15/2024 12:00:00 AM",
      ...> "FoodItems" => "Burgers: melts: hot dogs: burritos:sandwiches: fries: onion rings: drinks",
      ...> "Latitude" => "37.748445338837655",
      ...> "Longitude" => "-122.38687903197963",
      ...> "Status" => "REQUESTED",
      ...> "dayshours" => "",
      ...> "x" => "321"
      ...> },
      ...> %{
      ...> "Address" => "Assessors Block 7295/Lot022",
      ...> "blocklot" => "2360082",
      ...> "Applicant" => "Natan's Catering",
      ...> "ExpirationDate" => "11/15/2024 12:00:00 AM",
      ...> "FoodItems" => "Burgers: melts: hot dogs: burritos:sandwiches: fries: onion rings: drinks",
      ...> "Latitude" => "37.730003683189196",
      ...> "Longitude" => "-122.4781863254146",
      ...> "Status" => "APPROVED",
      ...> "dayshours" => "",
      ...> "x" => "123"
      ...> }])
      [%{
          "Address" => "Assessors Block 7295/Lot022",
          "Applicant" => "Natan's Catering",
          "ExpirationDate" => "11/15/2024 12:00:00 AM",
          "FoodItems" => "Burgers: melts: hot dogs: burritos:sandwiches: fries: onion rings: drinks",
          "Latitude" => "37.730003683189196",
          "Longitude" => "-122.4781863254146",
          "Status" => "APPROVED",
          "dayshours" => ""
      }]

  """
  @spec filter_data(Enum.t) :: Enum.t
  def filter_data(data) do
    data
    |> Enum.filter(&status_approved/1)
    |> Enum.map( &Map.take(&1, desired_columns()) )
  end

end
