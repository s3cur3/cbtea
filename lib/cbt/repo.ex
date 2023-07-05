defmodule Cbt.Repo do
  use Ecto.Repo,
    otp_app: :cbt,
    adapter: Ecto.Adapters.Postgres

  @type id :: integer()

  def id(schema_or_id, _module) when is_integer(schema_or_id), do: schema_or_id
  def id(%module{} = schema_or_id, module), do: schema_or_id.id
end
