defmodule Porterage.FetcherTest do
  use ExUnit.Case, async: true

  alias Porterage.TestHelpers.DummyScheduler
  alias Porterage.TestHelpers.DummyTester

  test "fetch called after tester test" do
    defmodule DummyFetcher do
      @behaviour Porterage.Fetcher

      def fetch(parent) do
        send(parent, :fetch)
        :nodata
      end

      def init(parent) do
        send(parent, :init)
        parent
      end
    end

    start_supervised(
      {Porterage,
       %{
         fetcher: DummyFetcher,
         fetcher_opts: self(),
         scheduler: DummyScheduler,
         scheduler_opts: %{return_tick: true},
         tester: DummyTester,
         tester_opts: %{return_test: true}
       }}
    )

    assert_receive :init
    assert_receive :fetch
  end
end
