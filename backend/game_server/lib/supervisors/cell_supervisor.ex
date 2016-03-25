defmodule BernacleServer.Supervisors.CellSupervisor do
    use Supervisor
    alias BernacleServer.{Entity,Cell}

    @name BernacleCellSupervisor

    def start_link do
        IO.puts "BernacleCellSupervisor started"
        Supervisor.start_link(__MODULE__, :ok, name: @name)
    end

    def init(:ok) do
        children = [
            worker(Entity, [Cell.born], restart: :temporary)
        ]
        supervise(children, strategy: :simple_one_for_one)
    end

    def spawn_cell do
        Supervisor.start_child(@name, [])
    end

    def give_children do
        for { _ , pid, _, _} <- Supervisor.which_children(@name), do: pid
    end

    def do_on_child({action, params}) do 
        for cell <- give_children, do: Entity.do_ability(cell, action, params)
    end


end
