defmodule Porterage.Deliverer.MFATest do
  use ExUnit.Case, async: true

  alias Porterage.Deliverer.MFA

  test "data delivered to configured pid" do
    defmodule MFADeliverer do
      def deliver(data, notify_pid), do: send(notify_pid, data)
    end

    {:ok, sup_pid} =
      start_supervised(
        {Porterage,
         %{
           deliverer: MFA,
           deliverer_opts: %{mfa: {MFADeliverer, :deliver, [self()]}}
         }}
      )

    Porterage.deliver(sup_pid, :some_data)

    assert_receive :some_data
  end
end
