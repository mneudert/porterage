defmodule Porterage.Fetcher.FileReadTest do
  use ExUnit.Case, async: true

  alias Porterage.Fetcher.FileRead
  alias Porterage.TestHelpers.DummyDeliverer

  test "file is read and sent to deliverer" do
    sup_pid =
      start_supervised!({
        Porterage,
        %{
          deliverer: DummyDeliverer,
          deliverer_opts: %{parent: self()},
          fetcher: FileRead,
          fetcher_opts: %{
            file: Path.join(__DIR__, "file_read_test.exs")
          }
        }
      })

    Porterage.fetch(sup_pid)

    assert_receive contents
    assert contents =~ "defmodule Porterage.Fetcher.FileReadTest"
  end

  test "missing files are ignored" do
    sup_pid =
      start_supervised!({
        Porterage,
        %{
          deliverer: DummyDeliverer,
          deliverer_opts: %{parent: self()},
          fetcher: FileRead,
          fetcher_opts: %{
            file: Path.join(__DIR__, "file-that-does-not-exist")
          }
        }
      })

    Porterage.fetch(sup_pid)

    refute_receive _, 100
  end
end
