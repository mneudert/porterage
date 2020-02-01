defmodule Porterage.Deliverer.SendTest do
  use ExUnit.Case, async: true

  alias Porterage.Deliverer.Send

  test "data delivered to configured pid" do
    sup_pid =
      start_supervised!(
        {Porterage,
         %{
           deliverer: Send,
           deliverer_opts: %{dest: self()}
         }}
      )

    Porterage.deliver(sup_pid, :some_data)

    assert_receive :some_data
  end
end
