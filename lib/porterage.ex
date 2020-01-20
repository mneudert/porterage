defmodule Porterage do
  @moduledoc """
  Porterage

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

  ### Supervisor Configuration

  If a `:supervisor` key is set the values are passed
  as the options argument to `Supervisor.start_link/3`.
  """

  use Supervisor

  alias Porterage.Deliverer
  alias Porterage.Fetcher
  alias Porterage.Scheduler
  alias Porterage.SupervisorUtil
  alias Porterage.Tester

  @doc false
  def start_link(config) do
    Supervisor.start_link(__MODULE__, config, config[:supervisor] || [])
  end

  @doc false
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
    case SupervisorUtil.child(supervisor, Porterage.Deliverer) do
      deliverer when is_pid(deliverer) -> GenServer.cast(deliverer, {:deliver, data})
      _ -> :error
    end
  end

  @doc """
  Force a fetch for a specific instance.
  """
  @spec fetch(Supervisor.supervisor()) :: :ok | :error
  def fetch(supervisor) do
    case SupervisorUtil.child(supervisor, Porterage.Fetcher) do
      fetcher when is_pid(fetcher) -> GenServer.cast(fetcher, :fetch)
      _ -> :error
    end
  end

  @doc """
  Force a test for a specific instance.
  """
  @spec test(Supervisor.supervisor()) :: :ok | :error
  def test(supervisor) do
    case SupervisorUtil.child(supervisor, Porterage.Tester) do
      tester when is_pid(tester) -> GenServer.cast(tester, :test)
      _ -> :error
    end
  end

  @doc """
  Force a tick for a specific instance.
  """
  @spec tick(Supervisor.supervisor()) :: :ok | :error
  def tick(supervisor) do
    case SupervisorUtil.child(supervisor, Porterage.Scheduler) do
      scheduler when is_pid(scheduler) -> GenServer.cast(scheduler, :tick)
      _ -> :error
    end
  end
end
