defmodule WebServer.WebsocketHandler do
  @behaviour :cowboy_websocket_handler

  #documentation
  #http://ninenines.eu/docs/en/cowboy/1.0/manual/cowboy_websocket_handler/

  def init({tcp, http}, _req, state) do
    # {:upgrade, :protocol, :cowboy_websocket}

    {:upgrade, :protocol, :cowboy_websocket}
  end

  def websocket_init(_, req, state) do
    WebServer.RoomSupervisor.message_to_room(:data_room, :any, "somebody join")
    WebServer.RoomSupervisor.join_to_room(:data_room, self())
    {:ok, req, []}
  end

  def websocket_terminate(reason, req, state) do
    WebServer.RoomSupervisor.disconnect_from_room(:data_room, self())
    WebServer.RoomSupervisor.message_to_room(:data_room, :any, "somebody left")
    :ok
  end

  def websocket_handle({:text, content}, req, state) do
    { :ok, %{ "message" => message} } = JSEX.decode(content)
    WebServer.RoomSupervisor.message_to_room(:data_room, :any, message)
    # {:reply, {:text, reply}, req, state}
    {:ok, req, state}
  end

  def websocket_handle(_, req, state), do: {:ok, req, state}

  def websocket_info(info, req, state) do
    case {subject, message} = info do
      {_, message} -> create_message(message, :text, req, state)
      _ -> {:ok, req, state}
    end
  end


  # def websocket_info(_data, req, state), do: {:ok, req, state}

  defp create_message(message, format, req, state) do
    case {status, message_in_json} = JSEX.encode(%{ reply: message}) do
      {:ok, message_in_json} -> { :reply, {format, message_in_json}, req, state}
      {_, _} -> { :ok, req, state}
    end
  end

end
