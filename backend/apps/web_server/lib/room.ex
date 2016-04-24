defmodule WebServer.Room do
    def start_link(room_name) do
        "Room: #{room_name} started" |> IO.puts
        Agent.start_link(fn -> [] end, name: room_name)
    end

    def join_to_room(room_name, pid) do
        Agent.update(room_name, fn state ->
            add_to_room(state, pid)
        end)
    end

    def kick_from_room(room_name, pid) do
        Agent.update(room_name, fn state ->
            remove_from_room(state, pid)
        end)
    end

    def message_to_room(room_name, subject, message) do
        Agent.get(room_name, fn state ->
            Enum.each(state, fn(el) ->
                spawn(fn -> send(el, {subject, message}) end)
            end)
        end)
    end

    def remove_from_room(state, pid) do
        List.foldr(state, [], fn(item, acc) ->
            if (item == pid) do
                acc
            else
                [item | acc]
            end
        end)
    end



    defp add_to_room(state, pid) do
        [pid | state]
    end
end

