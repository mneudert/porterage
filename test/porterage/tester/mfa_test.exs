defmodule Porterage.Tester.MFATest do
  use ExUnit.Case, async: true

  alias Porterage.Tester.MFA

  test "test result defined by configured callable" do
    parent = self()

    Code.compile_quoted(
      quote do
        defmodule MFATester do
          def test(nil) do
            send(unquote(parent), :first)
            {:first, false}
          end

          def test(:first) do
            send(unquote(parent), :second)
            {:second, false}
          end
        end
      end
    )

    {:ok, sup_pid} =
      start_supervised(
        {Porterage,
         %{
           tester: MFA,
           tester_opts: %{mfa: {MFATester, :test, []}}
         }}
      )

    Porterage.test(sup_pid)
    Porterage.test(sup_pid)

    assert_receive :first
    assert_receive :second
  end
end
