defmodule Porterage.FetcherTest do
  use ExUnit.Case, async: true

  test "fetch called after tester test" do
    parent = self()

    defmodule DummyScheduler do
      @behaviour Porterage.Scheduler

      def tick, do: true
    end

    defmodule DummyTester do
      @behaviour Porterage.Tester

      def test, do: true
    end

    Code.compile_quoted(
      quote do
        defmodule DummyFetcher do
          @behaviour Porterage.Fetcher

          def fetch do
            send(unquote(parent), :fetch)
            :nodata
          end

          def init do
            send(unquote(parent), :init)
          end
        end
      end
    )

    start_supervised(
      {Porterage, %{fetcher: DummyFetcher, scheduler: DummyScheduler, tester: DummyTester}}
    )

    assert_receive :init
    assert_receive :fetch
  end
end
