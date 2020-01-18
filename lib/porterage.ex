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
         tester: MyTester,
         tester_opts: %{}
       }}
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
