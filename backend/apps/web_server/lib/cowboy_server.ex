defmodule WebServer.CowboyServer do

  def start_link(args) do
    dispatch = :cowboy_router.compile([{ :_,
        [
            {"/css/[...]", :cowboy_static, {:priv_dir,  :web_server, "css"}},
            {"/js/[...]", :cowboy_static, {:priv_dir,  :web_server, "js"}},
            {"/ws", WebServer.WebsocketHandler, []},
            {"/[...]", :cowboy_static, {:priv_dir,  :web_server, "static_htmls"}}
        ]
    }])

    start_html(dispatch)
  end

  defp start_html(dispatch) do
    IO.puts "Cowboy started"
      :cowboy.start_http(
        :http,
        100,
        [{:port, 8080}],
        [{ :env, [{:dispatch, dispatch}]}]
      )
  end
end
