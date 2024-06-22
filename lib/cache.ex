defmodule Cache do
  @moduledoc """
  Documentation for 'Cache'
  """
  use GenServer
  require Logger


  @table :lunch


  def start_link(state \\ "") do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end


  @impl true
  def init(state) do
    create_table(@table)
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


end
