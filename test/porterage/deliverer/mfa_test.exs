defmodule Porterage.Deliverer.MFATest do
  use ExUnit.Case, async: true

  alias Porterage.Deliverer.MFA
  alias Porterage.TestHelpers.DummyFetcher
  alias Porterage.TestHelpers.DummyScheduler
  alias Porterage.TestHelpers.DummyTester

  test "data delivered to configured pid" do
    parent = self()

    Code.compile_quoted(
      quote do
        defmodule MFADeliverer do
          def send(data), do: send(unquote(parent), data)
        end
      end
    )

    start_supervised(
      {Porterage,
       %{
         deliverer: MFA,
         deliverer_opts: %{mfa: {MFADeliverer, :send, []}},
         fetcher: DummyFetcher,
         fetcher_opts: %{return_fetch: :some_data},
         scheduler: DummyScheduler,
         scheduler_opts: %{return_tick: true},
         tester: DummyTester,
         tester_opts: %{return_test: true}
       }}
    )

    assert_receive :some_data
  end
end
