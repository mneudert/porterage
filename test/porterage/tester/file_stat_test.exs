defmodule Porterage.Scheduler.FileStatTest do
  use ExUnit.Case, async: true

  alias Porterage.Tester.FileStat
  alias Porterage.TestHelpers.DummyFetcher

  test "deleted file does not trigger :fetch" do
    file = Path.join(__DIR__, "../../temp/file_stat_delete_test")

    File.touch(file)

    {:ok, sup_pid} =
      start_supervised(
        {Porterage,
         %{
           tester: FileStat,
           tester_opts: %{file: file, stat_key: :mtime},
           fetcher: DummyFetcher,
           fetcher_opts: %{parent: self(), send_fetch: :fetch}
         }}
      )

    Porterage.test(sup_pid)

    assert_receive :fetch

    File.rm(file)
    Porterage.test(sup_pid)

    refute_receive _, 100
  end

  test "changed file triggers :fetch" do
    file = Path.join(__DIR__, "../../temp/file_stat_change_test")

    File.touch(file, {{2000, 12, 12}, {12, 12, 12}})

    {:ok, sup_pid} =
      start_supervised(
        {Porterage,
         %{
           tester: FileStat,
           tester_opts: %{file: file, stat_key: :mtime},
           fetcher: DummyFetcher,
           fetcher_opts: %{parent: self(), send_fetch: :fetch}
         }}
      )

    Porterage.test(sup_pid)

    assert_receive :fetch

    File.touch(file)
    Porterage.test(sup_pid)

    assert_receive :fetch

    File.rm(file)
  end

  test "unchanged file only triggers :fetch once" do
    {:ok, sup_pid} =
      start_supervised(
        {Porterage,
         %{
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
