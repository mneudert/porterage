defmodule PorterageTest do
  use ExUnit.Case, async: true

  alias Porterage.TestHelpers.DummyFetcher
  alias Porterage.TestHelpers.DummyScheduler

  test "named supervisor" do
    start_supervised({
      Porterage,
      %{
        scheduler: DummyScheduler,
        scheduler_opts: %{return_tick: false},
        supervisor: [name: :porterage_test_named]
      }
    })

    assert :porterage_test_named |> Process.whereis() |> is_pid()
  end

  test "allow manual fetching" do
    sup_name = :porterage_test_named_fetch

    {:ok, sup_pid} =
      start_supervised({
        Porterage,
        %{
          fetcher: DummyFetcher,
          fetcher_opts: %{parent: self(), send_fetch: :fetch},
          scheduler: DummyScheduler,
          scheduler_opts: %{return_tick: false},
          supervisor: [name: sup_name]
        }
      })

    :ok = Porterage.fetch(sup_name)
    :ok = Porterage.fetch(sup_pid)

    assert_receive :fetch
    assert_receive :fetch
  end

  test "allow manual ticking" do
    sup_name = :porterage_test_named_tick

    {:ok, sup_pid} =
      start_supervised({
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

  test "return error for invalid instances" do
    sup_opts = [strategy: :one_for_one, name: :porterage_test_error]
    {:ok, sup_pid} = start_supervised({DynamicSupervisor, sup_opts})

    assert :error == Porterage.fetch(sup_pid)
    assert :error == Porterage.tick(sup_pid)
  end
end
