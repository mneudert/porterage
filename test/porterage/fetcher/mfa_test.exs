defmodule Porterage.Fetcher.MFATest do
  use ExUnit.Case, async: true

  alias Porterage.Fetcher.MFA
  alias Porterage.TestHelpers.DummyDeliverer

  test "fetcher can send data to deliverer" do
    defmodule MFADataFetcher do
      def fetch(data), do: {:ok, data}
    end

    sup_pid =
      start_supervised!({
        Porterage,
        %{
          deliverer: DummyDeliverer,
          deliverer_opts: %{parent: self()},
          fetcher: MFA,
          fetcher_opts: %{mfa: {MFADataFetcher, :fetch, [:some_data]}}
        }
      })

    Porterage.fetch(sup_pid)

    assert_receive :some_data
  end

  test "fetcher can skip data sending" do
    defmodule MFANodataFetcher do
      def fetch, do: :nodata
    end

    sup_pid =
      start_supervised!({
        Porterage,
        %{
          deliverer: DummyDeliverer,
          deliverer_opts: %{parent: self()},
          fetcher: MFA,
          fetcher_opts: %{mfa: {MFANodataFetcher, :fetch, []}}
        }
      })

    Porterage.fetch(sup_pid)

    refute_receive _, 100
  end
end
