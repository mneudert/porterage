defmodule Porterage.FetcherTest do
  use ExUnit.Case, async: true

  test "fetch called after tester test" do
    defmodule DummyScheduler do
      @behaviour Porterage.Scheduler

      def tick(_), do: true
    end

    defmodule DummyTester do
      @behaviour Porterage.Tester

      def test(_), do: true
    end

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
         tester: DummyTester
       }}
    )

    assert_receive :init
    assert_receive :fetch
  end
end
