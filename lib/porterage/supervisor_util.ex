defmodule Porterage.SupervisorUtil do
  @moduledoc false

  @doc """
  Returns the pid of a specific child from a supervisor.
  """
  @spec child(Supervisor.supervisor(), module) :: pid | nil
  def child(supervisor, id) do
    supervisor
    |> Supervisor.which_children()
    |> find_child(id)
  end

  defp find_child([], _), do: nil
  defp find_child([{id, pid, :worker, _} | _], id), do: pid
  defp find_child([_ | children], id), do: find_child(children, id)
end
