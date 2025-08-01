defmodule CbtWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :cbt

  alias Phoenix.Ecto.CheckRepoStatus
  alias Phoenix.LiveDashboard.RequestLogger
  alias Phoenix.LiveView.Socket

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  @session_options [
    store: :cookie,
    key: "_cbt_key",
    signing_salt: "QBwtDchd",
    same_site: "Lax"
  ]

  socket "/live", Socket, websocket: [connect_info: [session: @session_options]]

  if Mix.env() == :prod do
    plug CbtWeb.RedirectToWwwPlug
  end

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/",
    from: :cbt,
    gzip: false,
    only: CbtWeb.static_paths()

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
    plug CheckRepoStatus, otp_app: :cbt
  end

  plug RequestLogger,
    param_key: "request_logger",
    cookie_key: "request_logger"

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug CbtWeb.Router
end
