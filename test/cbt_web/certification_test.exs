defmodule CbtWeb.Endpoint.CertificationTest do
  use ExUnit.Case, async: false

  import SiteEncrypt.Phoenix.Test

  @tag server_only: true
  test "certification" do
    clean_restart(CbtWeb.Endpoint)
    cert = get_cert(CbtWeb.Endpoint)
    assert cert.domains == ~w/cbtea.app www.cbtea.app/
  end
end
