defmodule DemoWeb.HelloController do
  use DemoWeb, :controller # コントローラー関連の機能を使うための指定

  def hello(conn, params) do
    name = params["name"]
    render(conn, "hello.html", %{who: name})
  end
end
