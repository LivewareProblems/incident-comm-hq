defmodule IncidentBridgeWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :incident_bridge_web

  socket "/socket", IncidentBridgeWeb.UserSocket,
    websocket: true,
    longpoll: false

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/",
    from: :incident_bridge_web,
    gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  plug Plug.Session,
    store: :cookie,
    key: "_incident_bridge_web_key",
    signing_salt: "uh4Dx/ax"

  plug IncidentBridgeWeb.Router

  def init(_key, config) do
    if config[:load_from_system_env] do
      port = System.get_env("PORT") || raise "expected the PORT environment variable to be set"

      secret_key_base =
        System.get_env("SECRET_KEY_BASE") ||
          raise "expected the SECRET_KEY_BASE environment variable to be set"

      {
        :ok,
        config
        |> put_in([:http, :inet6, :port], port)
        |> put_in([:secret_key_base], secret_key_base)
        |> put_in([:url, :host], "incidentbridge.com")
        |> put_in([:url, :port], 443)
      }
    else
      {:ok, config}
    end
  end
end
