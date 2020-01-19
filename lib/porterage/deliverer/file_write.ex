defmodule Porterage.Deliverer.FileWrite do
  @moduledoc """
  Deliverer to write files.

  ## Configuration

      {
        deliverer: Porterage.Deliverer.FileWrite,
        deliverer_opts: %{file: _}
      }

  See `t:options/0` for a specification of available options.
  """

  @type options :: %{file: Path.t()}

  @behaviour Porterage.Deliverer

  @impl Porterage.Deliverer
  def init(%{file: _} = state), do: state

  @impl Porterage.Deliverer
  def deliver(%{file: file} = state, data) do
    :ok = File.write(file, data)
    state
  end
end
