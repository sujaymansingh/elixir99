defmodule ListsTest do
  use ExUnit.Case, async: true
  doctest Lists

  test "element_at position 4 in list" do
    assert Lists.element_at([:a, :b, :c, :d], 4) == :d
  end
end
