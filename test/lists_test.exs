defmodule ListsTest do
  use ExUnit.Case, async: true
  doctest Lists

  import Mock

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
    assert Lists.palindrome?([:x, :a, :m, :a, :x]) == true
    assert Lists.palindrome?([:x, :a, :a, :x]) == true

    assert Lists.palindrome?([:x, :a, :m, :a]) == false
    assert Lists.palindrome?([:x, :a, :m, :a, :b]) == false
    assert Lists.palindrome?([]) == false
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

  test "randomly select from a list" do
    with_mocks [{Random, [], [random: fn a.._ -> a end]}] do
      # We've mocked random to always return the lower bound of the range.
      # Thus the first item will be chosen each time.
      assert Lists.rnd_select([:a, :b, :c, :d], 2) == [:b, :a]
    end
  end

  test "draw lotto numbers" do
    with_mocks [{Random, [], [random: fn a.._ -> a end]}] do
      assert Lists.lotto(6, 49) == [6, 5, 4, 3, 2, 1]
    end
  end

  test "random permutation doesn't add/remove items" do
    initial_list = [1, 2, 3, 4, 5, 6, 7, 8, 9, :a, :b, :c, :d, :e]
    shuffled_list = Lists.rnd_permu(initial_list)

    assert Enum.sort(initial_list) == Enum.sort(shuffled_list)
  end

  test "grouping into disjoint sets" do
    groups = Lists.group([:a, :b, :c, :d, :e], [2, 3])

    assert groups == [
             [[:a, :b], [:c, :d, :e]],
             [[:a, :c], [:b, :d, :e]],
             [[:a, :d], [:b, :c, :e]],
             [[:a, :e], [:b, :c, :d]],
             [[:b, :c], [:a, :d, :e]],
             [[:b, :d], [:a, :c, :e]],
             [[:b, :e], [:a, :c, :d]],
             [[:c, :d], [:a, :b, :e]],
             [[:c, :e], [:a, :b, :d]],
             [[:d, :e], [:a, :b, :c]]
           ]
  end
end
