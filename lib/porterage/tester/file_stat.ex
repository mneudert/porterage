defmodule Porterage.Tester.FileStat do
  @moduledoc """
  Tester based on results of `File.stat/1` calls.

  ## Configuration

      {
        tester: Porterage.Tester.FileStat,
        tester_opts: %{file :: Path.t(), stat_key :: atom}
      }
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
        {:ok, new_stat} -> Map.get(new_stat, stat_key) != Map.get(last_stat, stat_key)
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
