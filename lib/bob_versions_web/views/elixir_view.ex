defmodule BobVersionsWeb.ElixirView do
  use BobVersionsWeb, :view
  import Phoenix.Component

  def tabs(assigns) do
    ~H"""
    <div class="hero-foot">
      <nav class="tabs is-boxed is-fullwidth">
        <div class="container">
          <ul>
            <%= for {minor, _list} <- sort_by_minor(@data), match?(<<"v"::binary, _::binary>>, minor) || ("master" == minor) do %>
              <li class={if minor == @stable, do: "is-active"}>
                <a href={"#version_#{minor}"}><%= String.trim_leading(minor, "v") %></a>
              </li>
            <% end %>
          </ul>
        </div>
      </nav>
    </div>
    """
  end

  def sort_by_minor(list) do
    Enum.sort(list, fn {k1, _v1}, {k2, _v2} ->
      sort_order(k1, k2, :desc)
    end)
  end

  def sort_by_version(list) do
    Enum.sort(list, fn %{version: k1}, %{version: k2} ->
      sort_order(k1, k2, :desc)
    end)
  end

  defp sort_order(k1, k2, direction) do
    false_version_order =
      case direction do
        :asc -> :gt
        :desc -> :lt
      end

    case {k1, k2} do
      {<<"v"::binary, v1::binary>>, <<"v"::binary, v2::binary>>} ->
        with {_, {:ok, v1}} <- {:v1, version_for_sure(v1)},
             {_, {:ok, v2}} <- {:v2, version_for_sure(v2)} do
          Version.compare(v1, v2) != false_version_order
        else
          {:v1, :error} -> true
          {:v2, :error} -> false
        end

      {"master", _} ->
        true

      {_, "master"} ->
        false

      {<<"v"::binary, _::binary>>, _} ->
        true

      {_, <<"v"::binary, _::binary>>} ->
        false

      {_, _} ->
        true
    end
  end

  defp version_for_sure(version) do
    with :error <- Version.parse(version),
         :error <- Version.parse("#{version}.999") do
      :error
    end
  end
end
