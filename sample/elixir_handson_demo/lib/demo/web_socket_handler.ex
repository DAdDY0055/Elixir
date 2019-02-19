defmodule Demo.WebSocketHandler do
  @behaviour :cowboy_websocket

  # [必須]最初の接続時に呼ばれるコールバック関数
  def init(req, opts) do
    {:cowboy_websocket, req, opts}
  end

  # [任意]接続がきれた時に呼ばれるコールバック関数
  # 接続が切断された時に、購読を停止する
  def terminate(_reason, _req, _opts) do
    Phoenix.PubSub.unsubscribe(:chat_pubsub, "mytopic")
    :ok
  end

  # [任意]プロトコルがHTTPからWebSocketに変わった(Upgradeした)時に1度だけ呼ばれるコールバック関数
  # 1度だけ通信開始時にsubscribeする
  def websocket_init(opts) do
    Phoenix.PubSub.subscribe(:chat_pubsub, "mytopic")
    {:ok ,opts}
  end

  # [必須]WebSocketの接続でデータを受け取った時に呼ばれるコールバック関数
  # クライアントからテキストデータ(content)を受信しているのでbroadcastする
  def websocket_handle({:text, content}, opts) do
    Phoenix.PubSub.broadcast(:chat_pubsub, "mytopic", {:text, content})
    {:ok, opts}
  end
  def websocket_handle(_frame, opts) do
    {:ok, opts}
  end

  # [必須]ハンドラのプロセスがElixir(Erlang)のメッセージを受け取った時に呼ばれるコールバック関数
  # PubSubモジュールがbroadcastしたメッセージを各プロセスが受信
  def websocket_info({:text, content}, opts) do
    {:reply, {:text, content}, opts}
  end
  def websocket_info(_info, opts) do
    {:ok, opts}
  end
end
