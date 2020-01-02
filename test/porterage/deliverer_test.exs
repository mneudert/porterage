defmodule Porterage.DelivererTest do
  use ExUnit.Case, async: true

  alias Porterage.TestHelpers.DummyDeliverer
  alias Porterage.TestHelpers.DummyFetcher
  alias Porterage.TestHelpers.DummyScheduler
  alias Porterage.TestHelpers.DummyTester

  test "deliver called after fetcher fetch" do
    start_supervised(
      {Porterage,
       %{
         deliverer: DummyDeliverer,
         deliverer_opts: %{parent: self(), send_init: :init},
         fetcher: DummyFetcher,
         fetcher_opts: %{return_fetch: {:ok, :some_data}},
         scheduler: DummyScheduler,
         scheduler_opts: %{return_tick: true},
         tester: DummyTester,
         tester_opts: %{return_test: true}
       }}
    )

    assert_receive :init
    assert_receive :some_data
  end
end
