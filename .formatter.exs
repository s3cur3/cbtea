[
  line_length: 98,
  heex_line_length: 120,
  import_deps: [
    :ecto,
    :ecto_sql,
    :phoenix,
    :phoenix_live_view,
    :union_typespec
  ],
  plugins: [
    Phoenix.LiveView.HTMLFormatter,
    Quokka
  ],
  inputs: ["*.{ex,exs}", "priv/*/seeds.exs", "{config,lib,test}/**/*.{ex,exs,heex}"],
  subdirectories: ["priv/*/migrations", "priv/repo/data_migrations"],
  quokka: [
    files: %{
      excluded: ["lib/cbt/cldr.ex"]
    }
  ]
]
