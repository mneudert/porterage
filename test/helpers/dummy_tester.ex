defmodule Porterage.TestHelpers.DummyTester do
  @moduledoc false

  @behaviour Porterage.Tester

  @impl Porterage.Tester
  def init(%{parent: parent, send_init: send_init} = state) do
    send(parent, send_init)
    state
  end

  def init(state), do: state

  @impl Porterage.Tester
  def test(%{parent: parent, return_test: return_test, send_test: send_test}) do
    send(parent, send_test)
    return_test
  end

  def test(%{return_test: return_test}), do: return_test
end
