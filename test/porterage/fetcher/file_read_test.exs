defmodule Porterage.Fetcher.FileReadTest do
  use ExUnit.Case, async: true

  alias Porterage.Fetcher.FileRead
  alias Porterage.TestHelpers.DummyDeliverer
  alias Porterage.TestHelpers.DummyScheduler
  alias Porterage.TestHelpers.DummyTester

  test "file is read and send to deliverer" do
    start_supervised(
      {Porterage,
       %{
         deliverer: DummyDeliverer,
         deliverer_opts: %{parent: self()},
         fetcher: FileRead,
         fetcher_opts: %{
           file: Path.join([__DIR__, "file_read_test.exs"])
         },
         scheduler: DummyScheduler,
         scheduler_opts: %{return_tick: true},
         tester: DummyTester,
         tester_opts: %{return_test: true}
       }}
    )

    assert_receive contents
    assert contents =~ "defmodule Porterage.Fetcher.FileReadTest"
  end

  test "missing files are ignored" do
    start_supervised(
      {Porterage,
       %{
         deliverer: DummyDeliverer,
         deliverer_opts: %{parent: self()},
         fetcher: FileRead,
         fetcher_opts: %{
           file: Path.join([__DIR__, "file-that-does-not-exist"])
         },
         scheduler: DummyScheduler,
         scheduler_opts: %{return_tick: true},
         tester: DummyTester,
         tester_opts: %{return_test: true}
       }}
    )

    refute_receive _, 100
  end
end
