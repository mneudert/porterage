defmodule Porterage.Scheduler.FileStatTest do
  use ExUnit.Case, async: true

  alias Porterage.Scheduler.Once
  alias Porterage.Tester.FileStat
  alias Porterage.TestHelpers.DummyFetcher
  alias Porterage.TestHelpers.DummyScheduler

  test "initial startup triggers :fetch" do
    start_supervised(
      {Porterage,
       %{
         scheduler: Once,
         tester: FileStat,
         tester_opts: %{file: Path.join(__DIR__, "file_stat_test.exs"), stat_key: :mtime},
         fetcher: DummyFetcher,
         fetcher_opts: %{parent: self(), send_fetch: :fetch}
       }}
    )

    assert_receive :fetch
  end

  test "unchanged file only triggers :fetch once" do
    {:ok, sup_pid} =
      start_supervised(
        {Porterage,
         %{
           scheduler: DummyScheduler,
           scheduler_opts: %{return_tick: false},
           tester: FileStat,
           tester_opts: %{file: Path.join(__DIR__, "file_stat_test.exs"), stat_key: :mtime},
           fetcher: DummyFetcher,
           fetcher_opts: %{parent: self(), send_fetch: :fetch}
         }}
      )

    Porterage.test(sup_pid)
    Porterage.test(sup_pid)

    assert_receive :fetch
    refute_receive _, 100
  end
end
