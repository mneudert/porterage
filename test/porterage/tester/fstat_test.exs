defmodule Porterage.Scheduler.FstatTest do
  use ExUnit.Case, async: true

  alias Porterage.Scheduler.Once
  alias Porterage.Tester.Fstat
  alias Porterage.TestHelpers.DummyFetcher

  test "Initial startup triggers :fetch" do
    start_supervised(
      {Porterage,
       %{
         scheduler: Once,
         tester: Fstat,
         tester_opts: %{file: Path.join([__DIR__, "fstat_test.exs"]), stat_key: :mtime},
         fetcher: DummyFetcher,
         fetcher_opts: %{parent: self(), send_fetch: :fetch}
       }}
    )

    assert_receive :fetch
  end
end
