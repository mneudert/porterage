defmodule Porterage do
  @moduledoc """
  Porterage
  """

  use Supervisor

  alias Porterage.Deliverer
  alias Porterage.Fetcher
  alias Porterage.Scheduler
  alias Porterage.Tester

  @doc false
  def start_link(config) do
    Supervisor.start_link(__MODULE__, config)
  end

  @doc false
  def init(config) do
    children = [
      {Scheduler, [self(), config[:scheduler]]},
      {Tester, [self(), config[:tester]]},
      {Fetcher, [self(), config[:fetcher]]},
      {Deliverer, [self(), config[:deliverer]]}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
