defmodule Porterage.Tester.Fstat do
  @moduledoc """
  Tester based on results of `File.stat/1` calls.
  """

  @behaviour Porterage.Tester

  @impl Porterage.Tester
  def init(%{file: _, stat_key: _} = state), do: state

  @impl Porterage.Tester
  def test(%{file: file, stat: {:ok, last_stat}, stat_key: stat_key} = state) do
    stat = File.stat(file)
    state = %{state | stat: stat}

    result =
      case stat do
        {:ok, new_stat} -> new_stat[stat_key] != last_stat[stat_key]
        {:error, _} -> false
      end

    {state, result}
  end

  def test(%{file: file} = state) do
    stat = File.stat(file)
    state = Map.put(state, :stat, stat)

    result =
      case stat do
        {:ok, _} -> true
        {:error, _} -> false
      end

    {state, result}
  end
end
