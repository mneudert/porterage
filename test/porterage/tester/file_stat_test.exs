defmodule Porterage.Scheduler.FileStatTest do
  use ExUnit.Case, async: true

  alias Porterage.Scheduler.Once
  alias Porterage.Tester.FileStat
  alias Porterage.TestHelpers.DummyFetcher

  test "Initial startup triggers :fetch" do
    start_supervised(
      {Porterage,
       %{
         scheduler: Once,
         tester: FileStat,
         tester_opts: %{file: Path.join([__DIR__, "file_stat_test.exs"]), stat_key: :mtime},
         fetcher: DummyFetcher,
         fetcher_opts: %{parent: self(), send_fetch: :fetch}
       }}
    )

    assert_receive :fetch
  end
end
