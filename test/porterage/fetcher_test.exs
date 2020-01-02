defmodule Porterage.FetcherTest do
  use ExUnit.Case, async: true

  alias Porterage.TestHelpers.DummyFetcher
  alias Porterage.TestHelpers.DummyScheduler
  alias Porterage.TestHelpers.DummyTester

  test "fetch called after tester test" do
    start_supervised(
      {Porterage,
       %{
         fetcher: DummyFetcher,
         fetcher_opts: %{
           parent: self(),
           return_fetch: :nodata,
           send_fetch: :fetch,
           send_init: :init
         },
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
