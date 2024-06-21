defmodule Challenge.Application do
  @moduledoc false

  use Application
  require Logger


  @impl true
  def start(_type, _args) do
    children = [
    ]

    opts = [
      strategy: :one_for_one,
      name: Boss
    ]
    Supervisor.start_link(children, opts)
  end


  defp cowboy_port do
    port = Application.get_env(:plug_cowboy, :cowboy_port, 8080)
    Logger.info("Reading the configured port... #{port}")
    port
  end


  defp file_name do
    fname = Application.get_env(:challenge, :file_name)
    Logger.info("Reading the configured file path... #{fname}")
    fname
  end


end
