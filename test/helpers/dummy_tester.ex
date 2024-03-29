defmodule Porterage.TestHelpers.DummyTester do
  @moduledoc false

  @behaviour Porterage.TesterBehaviour

  @impl Porterage.TesterBehaviour
  def init(%{parent: parent, send_init: send_init} = state) do
    send(parent, send_init)
    state
  end

  def init(state), do: state

  @impl Porterage.TesterBehaviour
  def test(%{parent: parent, return_test: return_test, send_test: send_test} = state) do
    send(parent, send_test)
    {state, return_test}
  end

  def test(%{return_test: return_test} = state), do: {state, return_test}
end
