defmodule Cbt.I18nTest do
  use Cbt.DataCase, async: true

  alias Cbt.I18n

  test "formats dates for French locale" do
    french_i18n = %I18n{locale: "fr", timezone: "Etc/UTC", timezone_offset_mins: 0}
    date = ~N[2020-05-30 03:52:56Z]
    assert I18n.format_datetime(french_i18n, date) == "30 mai 2020, 03:52:56 UTC"
  end

  test "formats dates for English, Chicago time zone" do
    chicago_i18n = %I18n{locale: "en", timezone: "America/Chicago", timezone_offset_mins: -300}
    date = ~N[2020-05-30 03:52:56Z]
    assert I18n.format_datetime(chicago_i18n, date) == "May 29, 2020, 10:52:56 PM CDT"
  end
end
