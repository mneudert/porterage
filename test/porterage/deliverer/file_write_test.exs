defmodule Porterage.Deliverer.FileWriteTest do
  use ExUnit.Case, async: true

  alias Porterage.Deliverer.FileWrite
  alias Porterage.TestHelpers.DummyFetcher
  alias Porterage.TestHelpers.DummyScheduler
  alias Porterage.TestHelpers.DummyTester

  test "data written to configured file" do
    contents = "some data"
    file = Path.join(__DIR__, "../../temp/file_write_test")

    File.rm(file)

    start_supervised(
      {Porterage,
       %{
         deliverer: FileWrite,
         deliverer_opts: %{file: file},
         fetcher: DummyFetcher,
         fetcher_opts: %{return_fetch: contents},
         scheduler: DummyScheduler,
         scheduler_opts: %{return_tick: true},
         tester: DummyTester,
         tester_opts: %{return_test: true}
       }}
    )

    :timer.sleep(100)

    assert File.regular?(file)
    assert {:ok, ^contents} = File.read(file)

    File.rm(file)
  end
end
