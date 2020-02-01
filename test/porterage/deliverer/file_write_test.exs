defmodule Porterage.Deliverer.FileWriteTest do
  use ExUnit.Case, async: true

  alias Porterage.Deliverer.FileWrite

  test "data written to configured file" do
    contents = "some data"
    file = Path.join(__DIR__, "../../temp/file_write_test")

    File.rm(file)

    sup_pid =
      start_supervised!({
        Porterage,
        %{
          deliverer: FileWrite,
          deliverer_opts: %{file: file}
        }
      })

    Porterage.deliver(sup_pid, contents)

    :timer.sleep(50)

    assert File.regular?(file)
    assert {:ok, ^contents} = File.read(file)

    File.rm(file)
  end
end
