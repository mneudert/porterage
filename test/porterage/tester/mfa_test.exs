defmodule Porterage.Tester.MFATest do
  use ExUnit.Case, async: true

  alias Porterage.Tester.MFA

  test "test result defined by configured callable" do
    defmodule MFATester do
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
      start_supervised!(
        {Porterage,
         %{
           tester: MFA,
           tester_opts: %{mfa: {MFATester, :test, [self()]}}
         }}
      )

    Porterage.test(sup_pid)
    Porterage.test(sup_pid)

    assert_receive :first
    assert_receive :second
  end
end
