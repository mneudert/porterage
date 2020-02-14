defmodule Porterage.Fetcher.MFArgsTest do
  use ExUnit.Case, async: true

  alias Porterage.Fetcher.MFArgs
  alias Porterage.TestHelpers.DummyDeliverer

  test "fetcher can send data to deliverer" do
    defmodule MFArgsDataFetcher do
      def fetch(data), do: {:ok, data}
    end

    sup_pid =
      start_supervised!({
        Porterage,
        %{
          deliverer: DummyDeliverer,
          deliverer_opts: %{parent: self()},
          fetcher: MFArgs,
          fetcher_opts: %{mfargs: {MFArgsDataFetcher, :fetch, [:some_data]}}
        }
      })

    Porterage.fetch(sup_pid)

    assert_receive :some_data
  end

  test "fetcher can skip data sending" do
    defmodule MFArgsNodataFetcher do
      def fetch, do: :nodata
    end

    sup_pid =
      start_supervised!({
        Porterage,
        %{
          deliverer: DummyDeliverer,
          deliverer_opts: %{parent: self()},
          fetcher: MFArgs,
          fetcher_opts: %{mfargs: {MFArgsNodataFetcher, :fetch, []}}
        }
      })

    Porterage.fetch(sup_pid)

    refute_receive _, 100
  end
end
