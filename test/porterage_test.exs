defmodule PorterageTest do
  use ExUnit.Case, async: true

  alias Porterage.TestHelpers.DummyDeliverer
  alias Porterage.TestHelpers.DummyFetcher
  alias Porterage.TestHelpers.DummyScheduler
  alias Porterage.TestHelpers.DummyTester

  test "allow manual delivering" do
    sup_name = :porterage_test_named_deliver

    sup_pid =
      start_supervised!({
        Porterage,
        %{
          deliverer: DummyDeliverer,
          deliverer_opts: %{parent: self()},
          supervisor: [name: sup_name]
        }
      })

    :ok = Porterage.deliver(sup_name, :some_data_name)
    :ok = Porterage.deliver(sup_pid, :some_data_pid)

    assert_receive :some_data_name
    assert_receive :some_data_pid
  end

  test "allow manual fetching" do
    sup_name = :porterage_test_named_fetch

    sup_pid =
      start_supervised!({
        Porterage,
        %{
          fetcher: DummyFetcher,
          fetcher_opts: %{parent: self(), send_fetch: :fetch},
          supervisor: [name: sup_name]
        }
      })

    :ok = Porterage.fetch(sup_name)
    :ok = Porterage.fetch(sup_pid)

    assert_receive :fetch
    assert_receive :fetch
  end

  test "allow manual testing" do
    sup_name = :porterage_test_named_test

    sup_pid =
      start_supervised!({
        Porterage,
        %{
          tester: DummyTester,
          tester_opts: %{parent: self(), return_test: false, send_test: :test},
          supervisor: [name: sup_name]
        }
      })

    :ok = Porterage.test(sup_name)
    :ok = Porterage.test(sup_pid)

    assert_receive :test
    assert_receive :test
  end

  test "allow manual ticking" do
    sup_name = :porterage_test_named_tick

    sup_pid =
      start_supervised!({
        Porterage,
        %{
          scheduler: DummyScheduler,
          scheduler_opts: %{parent: self(), return_tick: false, send_tick: :tick},
          supervisor: [name: sup_name]
        }
      })

    :ok = Porterage.tick(sup_name)
    :ok = Porterage.tick(sup_pid)

    assert_receive :tick
    assert_receive :tick
    assert_receive :tick
  end
end
