defmodule Fetcher do
  @moduledoc """
  Documentation for `Fetcher`.
  """

  import File, only: [stream!: 1]
  require Logger
  require CSV


  defp read_csv_file(name) do
    Logger.info("Reading CSV file... #{name}")
    stream!(name) |> CSV.decode!(headers: true, validate_row_length: true)
  end


end
