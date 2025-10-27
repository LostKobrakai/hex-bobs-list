defmodule BobVersions.Finch do
  def child_spec(_) do
    Finch.child_spec(
      name: __MODULE__,
      pools: %{
        :default => [],
        "https://repo.hex.pm" => [size: 4, count: 1]
      }
    )
  end
end
