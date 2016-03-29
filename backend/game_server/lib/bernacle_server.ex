defmodule BernacleServer do
  use Application
  alias BernacleServer.Supervisors.ServerSupervisor

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    ServerSupervisor.start_link()
  end

  def spawn_cell do
    for x <- 1..10000 do
        BernacleServer.Supervisors.CellSupervisor.spawn_cell()
    end
    BernacleServer.Supervisors.CellSupervisor.do_on_child(:move, [1])
  end

end
