defmodule Util.Ecto do
  import Ecto.Changeset

  def validate_date_not_in_the_future(changeset, field) do
    case get_field(changeset, field) do
      nil ->
        changeset

      dt ->
        if NaiveDateTime.after?(dt, NaiveDateTime.utc_now()) do
          add_error(changeset, field, "must be in the past")
        else
          changeset
        end
    end
  end
end
