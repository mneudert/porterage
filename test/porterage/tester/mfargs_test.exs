defmodule Porterage.Tester.MFArgsTest do
  use ExUnit.Case, async: true

  alias Porterage.Tester.MFArgs

  test "test result defined by configured callable" do
    defmodule MFArgsTester do
      def test(nil, notify_pid) do
        send(notify_pid, :first)
        {:first, false}
      end

      def test(:first, notify_pid) do
        send(notify_pid, :second)
        {:second, false}
      end
    end

    sup_pid =
      start_supervised!({
        Porterage,
        %{
          tester: MFArgs,
          tester_opts: %{mfargs: {MFArgsTester, :test, [self()]}}
        }
      })

    Porterage.test(sup_pid)
    Porterage.test(sup_pid)

    assert_receive :first
    assert_receive :second
  end
end
