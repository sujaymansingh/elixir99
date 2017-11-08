defmodule ListsTest do
  use ExUnit.Case, async: true
  doctest Lists

  test "element_at position 4 in list" do
    assert Lists.element_at([:a, :b, :c, :d], 4) == :d
  end

  test "len works with empty list as well" do
    assert Lists.len([]) == 0
  end

  test "reverse an empty list gives an empty list" do
    assert Lists.reverse([]) == []
  end
end
