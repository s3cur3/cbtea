defmodule CbtWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :cbt
  use SiteEncrypt.Phoenix

  plug SiteEncrypt.AcmeChallenge, __MODULE__

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  @session_options [
    store: :cookie,
    key: "_cbt_key",
    signing_salt: "QBwtDchd",
    same_site: "Lax"
  ]

  socket "/live", Phoenix.LiveView.Socket, websocket: [connect_info: [session: @session_options]]

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
    plug Phoenix.Ecto.CheckRepoStatus, otp_app: :cbt
  end

  plug Phoenix.LiveDashboard.RequestLogger,
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

  @impl Phoenix.Endpoint
  def init(_key, config) do
    # this will merge key, cert, and chain into `:https` configuration from config.exs
    {:ok, SiteEncrypt.Phoenix.configure_https(config, port: 4001)}
  end

  @impl SiteEncrypt
  def certification do
    SiteEncrypt.configure(
      # Note that native client is very immature. If you want a more stable behaviour, you can
      # provide `:certbot` instead. Note that in this case certbot needs to be installed on the
      # host machine.
      client: :certbot,
      domains: ["cbtea.app", "www.cbtea.app"],
      emails: ["tyler+certbot@tylerayoung.com"],

      # By default the certs will be stored in tmp/site_encrypt_db, which is convenient for
      # local development. Make sure that tmp folder is gitignored.
      #
      # Set OS env var SITE_ENCRYPT_DB on staging/production hosts to some absolute path
      # outside of the deployment folder. Otherwise, the deploy may delete the db_folder,
      # which will effectively remove the generated key and certificate files.
      db_folder: System.get_env("SITE_ENCRYPT_DB", Path.join("tmp", "site_encrypt_db")),

      # set OS env var CERT_MODE to "staging" or "production" on staging/production hosts
      directory_url:
        case System.get_env("CERT_MODE", "local") do
          "local" -> {:internal, port: 4002}
          "staging" -> "https://acme-staging-v02.api.letsencrypt.org/directory"
          "production" -> "https://acme-v02.api.letsencrypt.org/directory"
        end
    )
  end
end
