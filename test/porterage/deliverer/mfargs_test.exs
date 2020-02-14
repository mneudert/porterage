defmodule Porterage.Deliverer.MFArgsTest do
  use ExUnit.Case, async: true

  alias Porterage.Deliverer.MFArgs

  test "data delivered to configured pid" do
    defmodule MFArgsDeliverer do
      def deliver(data, notify_pid), do: send(notify_pid, data)
    end

    sup_pid =
      start_supervised!({
        Porterage,
        %{
          deliverer: MFArgs,
          deliverer_opts: %{mfargs: {MFArgsDeliverer, :deliver, [self()]}}
        }
      })

    Porterage.deliver(sup_pid, :some_data)

    assert_receive :some_data
  end
end
