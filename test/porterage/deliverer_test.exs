defmodule Porterage.DelivererTest do
  use ExUnit.Case, async: true

  test "deliver called after fetcher fetch" do
    parent = self()

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

      def fetch(_), do: {:ok, :some_data}
    end

    Code.compile_quoted(
      quote do
        defmodule DummyDeliverer do
          @behaviour Porterage.Deliverer

          def deliver(:substate, data) do
            send(unquote(parent), data)
          end

          def init do
            send(unquote(parent), :init)
            :substate
          end
        end
      end
    )

    start_supervised(
      {Porterage,
       %{
         deliverer: DummyDeliverer,
         fetcher: DummyFetcher,
         scheduler: DummyScheduler,
         tester: DummyTester
       }}
    )

    assert_receive :init
    assert_receive :some_data
  end
end
