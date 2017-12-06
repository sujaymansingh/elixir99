defmodule BinaryTreeTest do
  use ExUnit.Case, async: true
  doctest BinaryTree

  test "all balances trees with 2 nodes" do
    # This is simple enough... the 2nd node is either on the left or the right.
    expected = [
      {:x, {:x, nil, nil}, nil},
      {:x, nil, {:x, nil, nil}}
    ]

    actual = BinaryTree.cbal_tree(2, :x)
    assert length(actual) == length(expected)
    assert MapSet.new(actual) == MapSet.new(expected)
  end

  test "all balances trees with 4 nodes" do
    # One way to think about this is:
    # If we had three nodes, we'd have
    # {:x, {:x, nil, nil}, {:x, nil, nil}}
    # So the final node, could replace any of the nils: thus 4 options
    expected = [
      {:x, {:x, {:x, nil, nil}, nil}, {:x, nil, nil}},
      {:x, {:x, nil, {:x, nil, nil}}, {:x, nil, nil}},
      {:x, {:x, nil, nil}, {:x, {:x, nil, nil}, nil}},
      {:x, {:x, nil, nil}, {:x, nil, {:x, nil, nil}}}
    ]

    actual = BinaryTree.cbal_tree(4, :x)
    assert length(actual) == length(expected)
    assert MapSet.new(actual) == MapSet.new(expected)
  end
end
