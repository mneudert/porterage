defmodule Porterage.Deliverer.SendTest do
  use ExUnit.Case, async: true

  alias Porterage.Deliverer.Send
  alias Porterage.TestHelpers.DummyFetcher
  alias Porterage.TestHelpers.DummyScheduler
  alias Porterage.TestHelpers.DummyTester

  test "data delivered to configured pid" do
    start_supervised(
      {Porterage,
       %{
         deliverer: Send,
         deliverer_opts: %{dest: self()},
         fetcher: DummyFetcher,
         fetcher_opts: %{return_fetch: :some_data},
         scheduler: DummyScheduler,
         scheduler_opts: %{return_tick: true},
         tester: DummyTester,
         tester_opts: %{return_test: true}
       }}
    )

    assert_receive :some_data
  end
end
