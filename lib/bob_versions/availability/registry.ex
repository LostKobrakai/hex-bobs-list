defmodule BobVersions.Availability.Registry do
  def child_spec(opts) do
    defaults = [keys: :unique, name: __MODULE__]
    opts = Keyword.merge(defaults, opts)
    Registry.child_spec(opts)
  end

  def via_tuple(url) do
    {:via, Registry, {__MODULE__, url}}
  end
end
