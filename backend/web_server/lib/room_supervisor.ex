defmodule WebServer.RoomSupervisor do
    use Supervisor

    @name RoomSupervisor

    def start_link do
        IO.puts "RoomSupervisor started"
        Supervisor.start_link(__MODULE__, :ok, name: @name)
    end

    def init(:ok) do
        children = [
            worker(WebServer.Room, [:data_room])
        ]
        supervise(children, strategy: :one_for_one)
    end

    def join_to_room(name, pid) do
        Room.join_to_room(name, pid)
    end

    def disconnect_from_room(name, pid) do
        Room.kick_from_room(name, pid)
    end

    def message_to_room(room_name, subject, message) do
        Room.message_to_room(room_name, subject, message)
    end

end
