defmodule Porterage do
  @moduledoc """

  Checks, fetches and delivers configurable datasources.

  ## Usage

  Place a porterage instance in your supervision tree:

      {Porterage,
       %{
         deliverer: MyDeliverer,
         deliverer_opts: %{},
         fetcher: MyFetcher,
         fetcher_opts: %{},
         scheduler: MyScheduler,
         scheduler_opts: %{},
         supervisor: [],
         tester: MyTester,
         tester_opts: %{}
       }}

  See `t:config/0` for a specification of the available configuration keys.

  ### Supervisor Configuration

  If a `:supervisor` key is set the values are passed
  as the options argument to `Supervisor.start_link/3`.
  """

  use Supervisor

  alias Porterage.Deliverer
  alias Porterage.Fetcher
  alias Porterage.Scheduler
  alias Porterage.Tester

  @type config :: %{
          :deliverer => module,
          :fetcher => module,
          :scheduler => module,
          :tester => module,
          optional(:deliverer_opts) => map,
          optional(:fetcher_opts) => map,
          optional(:scheduler_opts) => map,
          optional(:supervisor) => [
            Supervisor.option() | Supervisor.init_option()
          ],
          optional(:tester_opts) => map
        }

  @doc false
  @spec start_link(config) :: Supervisor.on_start()
  def start_link(config) do
    Supervisor.start_link(__MODULE__, config, config[:supervisor] || [])
  end

  @doc false
  @spec init(config) :: {:ok, {:supervisor.sup_flags(), [:supervisor.child_spec()]}}
  def init(config) do
    children = [
      {Scheduler, [self(), config[:scheduler], config[:scheduler_opts]]},
      {Tester, [self(), config[:tester], config[:tester_opts]]},
      {Fetcher, [self(), config[:fetcher], config[:fetcher_opts]]},
      {Deliverer, [self(), config[:deliverer], config[:deliverer_opts]]}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  @doc """
  Force a delivery for a specific instance with custom data.
  """
  @spec deliver(Supervisor.supervisor(), any) :: :ok | :error
  def deliver(supervisor, data) do
    case child(supervisor, Porterage.Deliverer) do
      deliverer when is_pid(deliverer) -> GenServer.cast(deliverer, {:deliver, data})
      _ -> :error
    end
  end

  @doc """
  Force a fetch for a specific instance.
  """
  @spec fetch(Supervisor.supervisor()) :: :ok | :error
  def fetch(supervisor) do
    case child(supervisor, Porterage.Fetcher) do
      fetcher when is_pid(fetcher) -> GenServer.cast(fetcher, :fetch)
      _ -> :error
    end
  end

  @doc """
  Force a test for a specific instance.
  """
  @spec test(Supervisor.supervisor()) :: :ok | :error
  def test(supervisor) do
    case child(supervisor, Porterage.Tester) do
      tester when is_pid(tester) -> GenServer.cast(tester, :test)
      _ -> :error
    end
  end

  @doc """
  Force a tick for a specific instance.
  """
  @spec tick(Supervisor.supervisor()) :: :ok | :error
  def tick(supervisor) do
    case child(supervisor, Porterage.Scheduler) do
      scheduler when is_pid(scheduler) -> GenServer.cast(scheduler, :tick)
      _ -> :error
    end
  end

  defp child(supervisor, id) do
    supervisor
    |> Supervisor.which_children()
    |> find_child(id)
  end

  defp find_child([], _), do: nil
  defp find_child([{id, pid, :worker, _} | _], id), do: pid
  defp find_child([_ | children], id), do: find_child(children, id)
end
