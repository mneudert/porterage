defmodule Porterage do
  @moduledoc """
  Checks, fetches and delivers configurable data sources.

  ## Usage

  Place a porterage instance in your supervision tree:

      {
        Porterage,
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
        }
      }

  See `t:config/0` for a specification of the available configuration keys.

  ### Supervisor Configuration

  If a `:supervisor` key is set the values are passed
  as the options argument to `Supervisor.start_link/3`.

  ## Data Flow

  1. `Porterage.Scheduler`

     Depending on the `:scheduler` chosen a `:tick` will start the data flow.

  2. `Porterage.Tester`

     If the scheduler decided it is time to test the data source the chosen
     `:tester` will receive a notification to do so.

  3. `Porterage.Fetcher`

     Every time a test for new data was deemed successful the `:fetcher` will
     retrieve the data to be delivered.

  4. `Porterage.Deliverer`

     Once the data was fetched in the previous step the `:deliverer` will take
     care of delivering it to the target.

  Every step of the flow can be manually triggered.
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

  @impl Supervisor
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
  def deliver(supervisor, data), do: cast_to_process(supervisor, Deliverer, {:deliver, data})

  @doc """
  Force a fetch for a specific instance.
  """
  @spec fetch(Supervisor.supervisor()) :: :ok | :error
  def fetch(supervisor), do: cast_to_process(supervisor, Fetcher, :fetch)

  @doc """
  Force a test for a specific instance.
  """
  @spec test(Supervisor.supervisor()) :: :ok | :error
  def test(supervisor), do: cast_to_process(supervisor, Tester, :test)

  @doc """
  Force a tick for a specific instance.
  """
  @spec tick(Supervisor.supervisor()) :: :ok | :error
  def tick(supervisor), do: cast_to_process(supervisor, Scheduler, :tick)

  defp cast_to_process(supervisor, module, message) do
    case child(supervisor, module) do
      pid when is_pid(pid) -> GenServer.cast(pid, message)
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
