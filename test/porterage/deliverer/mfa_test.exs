defmodule Porterage.Deliverer.MFATest do
  use ExUnit.Case, async: true

  alias Porterage.Deliverer.MFA

  test "data delivered to configured pid" do
    parent = self()

    Code.compile_quoted(
      quote do
        defmodule MFADeliverer do
          def send(data), do: send(unquote(parent), data)
        end
      end
    )

    {:ok, sup_pid} =
      start_supervised(
        {Porterage,
         %{
           deliverer: MFA,
           deliverer_opts: %{mfa: {MFADeliverer, :send, []}}
         }}
      )

    Porterage.deliver(sup_pid, :some_data)

    assert_receive :some_data
  end
end
