defmodule BobVersions.Finch do
  def child_spec(_) do
    Finch.child_spec(
      name: __MODULE__,
      pools: %{
        :default => [size: 10, count: 2],
        "https://repo.hex.pm" => [size: 32, count: 8]
      }
    )
  end
end
