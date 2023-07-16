ExUnit.configure(exclude: [:integration, :server_only])
ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Cbt.Repo, :manual)
