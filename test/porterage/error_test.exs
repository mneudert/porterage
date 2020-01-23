defmodule Porterage.ErrorTest do
  use ExUnit.Case, async: true

  test "unconfigured modules are ignored" do
    sup_pid = start_supervised!({Porterage, %{}})

    assert :error == Porterage.deliver(sup_pid, :some_data)
    assert :error == Porterage.fetch(sup_pid)
    assert :error == Porterage.test(sup_pid)
    assert :error == Porterage.tick(sup_pid)
  end
end
