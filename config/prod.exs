import Config

alias Swoosh.ApiClient.Finch

config :cbt, CbtWeb.Endpoint, cache_static_manifest: "priv/static/cache_manifest.json"

# Do not print debug messages in production
config :logger, level: :info

# Configures Swoosh API Client
config :swoosh, api_client: Finch, finch_name: Cbt.Finch
