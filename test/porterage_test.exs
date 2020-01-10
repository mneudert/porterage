defmodule PorterageTest do
  use ExUnit.Case, async: true

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
end
