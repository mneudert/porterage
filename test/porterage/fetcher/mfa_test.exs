defmodule Porterage.Fetcher.MFATest do
  use ExUnit.Case, async: true

  alias Porterage.Fetcher.MFA
  alias Porterage.TestHelpers.DummyDeliverer
  alias Porterage.TestHelpers.DummyScheduler
  alias Porterage.TestHelpers.DummyTester

  test "fetcher can send data to deliverer" do
    defmodule MFADataFetcher do
      def fetch(data), do: {:ok, data}
    end

    start_supervised(
      {Porterage,
       %{
         deliverer: DummyDeliverer,
         deliverer_opts: %{parent: self()},
         fetcher: MFA,
         fetcher_opts: %{mfa: {MFADataFetcher, :fetch, [:some_data]}},
         scheduler: DummyScheduler,
         scheduler_opts: %{return_tick: true},
         tester: DummyTester,
         tester_opts: %{return_test: true}
       }}
    )

    assert_receive :some_data
  end

  test "fetcher can skip data sending" do
    defmodule MFANodataFetcher do
      def fetch, do: :nodata
    end

    start_supervised(
      {Porterage,
       %{
         deliverer: DummyDeliverer,
         deliverer_opts: %{parent: self()},
         fetcher: MFA,
         fetcher_opts: %{mfa: {MFANodataFetcher, :fetch, []}},
         scheduler: DummyScheduler,
         scheduler_opts: %{return_tick: true},
         tester: DummyTester,
         tester_opts: %{return_test: true}
       }}
    )

    refute_receive _, 100
  end
end
