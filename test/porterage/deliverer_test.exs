defmodule Porterage.DelivererTest do
  use ExUnit.Case, async: true

  alias Porterage.TestHelpers.DummyScheduler

  test "deliver called after fetcher fetch" do
    defmodule DummyTester do
      @behaviour Porterage.Tester

      def test(_), do: true
    end

    defmodule DummyFetcher do
      @behaviour Porterage.Fetcher

      def fetch(_), do: {:ok, :some_data}
    end

    defmodule DummyDeliverer do
      @behaviour Porterage.Deliverer

      def deliver(parent, data) do
        send(parent, data)
      end

      def init(parent) do
        send(parent, :init)
        parent
      end
    end

    start_supervised(
      {Porterage,
       %{
         deliverer: DummyDeliverer,
         deliverer_opts: self(),
         fetcher: DummyFetcher,
         scheduler: DummyScheduler,
         scheduler_opts: %{return_tick: true},
         tester: DummyTester
       }}
    )

    assert_receive :init
    assert_receive :some_data
  end
end
