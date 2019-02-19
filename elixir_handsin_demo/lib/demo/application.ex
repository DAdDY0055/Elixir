defmodule  do
  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    children = [
      # Starts a worker by calling: Demo.Worker.start_link(arg1, arg2, arg3)
      # worker(Demo.Worker, [arg1, arg2, arg3]),
      worker(__MODULE__, [], function: :start_cowboy) # ココ! アプリのスーパバイザーにstart_cowboyを処理するワーカーを追加
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Demo.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # cowboyの起動処理
  def start_cowboy do
    routes = [
      # ここにルーティングのパス定義を記述する
      {"/", Demo.HelloHandler, []},
    ]
    dispatch = :cowboy_router.compile([{:_, routes}]) # 全てのホストに対して上のパスを定義する
    opts = [{:port, 4000}] # 4000番ポートで接続する
    env = %{dispatch: dispatch}

    # TCPによるコネクションに備えて待機(Listen)
    {:ok, _pid} = :cowboy.start_clear(
                    :http,       # Listener名
                    10,          # コネクションをacceptするプロセス数
                    opts,        # トランスポートオプション（port番号など）
                    %{env: env}) # プロトコルオプション（コンパイルしたルーティングなど）
  end
end
