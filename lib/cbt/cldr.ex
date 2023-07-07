defmodule Cbt.Cldr do
  @moduledoc """
  Define a backend module that will host our
  Cldr configuration and public API.

  Most function calls in Cldr will be calls
  to functions on this module.
  """
  use Cldr,
    locales: ["en", "fr", "de", "es", "ja", "zh"],
    default_locale: "en",
    providers: [Cldr.Number, Cldr.Calendar, Cldr.DateTime]
end
