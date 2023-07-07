defmodule Cbt.I18n do
  use TypedStruct

  typedstruct enforce: true do
    field :locale, String.t()
    field :timezone, String.t()
    field :timezone_offset_mins, integer
  end

  @spec format_datetime(I18n.t(), NaiveDateTime.t()) :: String.t()
  def format_datetime(%__MODULE__{timezone: tz, locale: locale}, %NaiveDateTime{} = naive) do
    local_date =
      naive
      |> DateTime.from_naive!("Etc/UTC")
      |> DateTime.shift_zone!(tz)

    case Cbt.Cldr.DateTime.to_string(local_date, format: :long, locale: locale) do
      {:ok, str} -> str
      _ -> DateTime.to_string(local_date)
    end
  end
end
