defmodule Porterage.ErrorTest do
  use ExUnit.Case, async: false

  import ExUnit.CaptureLog

  test "unconfigured modules are ignored" do
    sup_pid = start_supervised!({Porterage, %{}})

    assert :error == Porterage.deliver(sup_pid, :some_data)
    assert :error == Porterage.fetch(sup_pid)
    assert :error == Porterage.test(sup_pid)
    assert :error == Porterage.tick(sup_pid)
  end

  test "unloadable modules are ignored after warning" do
    log =
      capture_log(fn ->
        sup_pid =
          start_supervised!(
            {Porterage,
             %{
               deliverer: UnloadableDeliverer,
               fetcher: UnloadableFetcher,
               scheduler: UnloadableScheduler,
               tester: UnloadableTester
             }}
          )

        assert :error == Porterage.deliver(sup_pid, :some_data)
        assert :error == Porterage.fetch(sup_pid)
        assert :error == Porterage.test(sup_pid)
        assert :error == Porterage.tick(sup_pid)
      end)

    assert log =~ ~r/deliverer module.+UnloadableDeliverer/
    assert log =~ ~r/fetcher module.+UnloadableFetcher/
    assert log =~ ~r/scheduler module.+UnloadableScheduler/
    assert log =~ ~r/tester module.+UnloadableTester/
  end
end
