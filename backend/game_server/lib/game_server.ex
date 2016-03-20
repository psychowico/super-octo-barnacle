defmodule GameServer do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # Define workers and child supervisors to be supervised
      # worker(GameServer.Worker, [arg1, arg2, arg3]),
      worker(Entity, [])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :simple_one_for_one, name: GameServer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def spawn_cell do
    Supervisor.start_child(GameServer.Supervisor, [Cell.born])
  end
end
