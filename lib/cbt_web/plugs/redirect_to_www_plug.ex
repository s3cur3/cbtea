defmodule CbtWeb.RedirectToWwwPlug do
  @moduledoc """
  Redirects all traffic to the www subdomain.
  """
  @behaviour Plug

  @impl Plug
  def init(opts), do: opts

  @impl Plug
  def call(conn, _opts) do
    if needs_redirect?(conn) do
      redirect(conn)
    else
      conn
    end
  end

  defp needs_redirect?(%Plug.Conn{host: "www." <> _}), do: false
  defp needs_redirect?(_), do: true

  defp redirect(%Plug.Conn{} = conn) do
    url = redirect_url(conn)

    conn
    |> Phoenix.Controller.redirect(external: url)
    |> Plug.Conn.halt()
  end

  defp redirect_url(%Plug.Conn{host: host, request_path: path} = conn) do
    add_query_string("https://www.#{host}#{path}", conn)
  end

  defp add_query_string(url, %Plug.Conn{query_string: ""}), do: url
  defp add_query_string(url, %Plug.Conn{query_string: query}), do: "#{url}?#{query}"
end
