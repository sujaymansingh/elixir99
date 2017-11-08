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

  test "identify palindromes correctly" do
    assert Lists.is_palindrome([:x, :a, :m, :a, :x]) == true
    assert Lists.is_palindrome([:x, :a, :a, :x]) == true

    assert Lists.is_palindrome([:x, :a, :m, :a]) == false
    assert Lists.is_palindrome([:x, :a, :m, :a, :b]) == false
    assert Lists.is_palindrome([]) == false
  end

  test "splitting should still work if the list is too small" do
    assert Lists.split([:a, :b, :c], 100) == {[:a, :b, :c], []}
  end

  test "splitting on zero should result in {[], list}" do
    assert Lists.split([:a, :b, :c, :d], 0) == {[], [:a, :b, :c, :d]}
  end

  test "slicing past the end shouldn't break" do
    assert Lists.slice([:a, :b, :c], -1, 2) == [:a, :b]
    assert Lists.slice([:a, :b, :c], 2, 10) == [:b, :c]
  end

  test "rotating by zero should return the same list" do
    assert Lists.rotate([:a, :b, :c], 0) == [:a, :b, :c]
  end
end
