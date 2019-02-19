defmodule Demo.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false # これを忘れていた！
    # List all child processes to be supervised
    children = [
      # Starts a worker by calling: Demo.Worker.start_link(arg)
      # {Demo.Worker, arg}
      worker(__MODULE__, [], function: :start_cowboy)
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Demo.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # cowboyの起動処理
  def start_cowboy do
    routes = [
      # ここにルーティングのパス定義を記述する
      {"/", Demo.HelloHandler, []},
      {"/static/[...]", :cowboy_static, {:priv_dir, :demo, "static_files"}}
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
