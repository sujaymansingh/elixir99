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

  test "we can spot symmetric binary trees" do
    symmetric =
      BinaryTree.tree(
        :a,
        BinaryTree.tree(:b, nil, BinaryTree.tree(:d)),
        BinaryTree.tree(:c, BinaryTree.tree(:e), nil)
      )

    assert BinaryTree.symmetric?(symmetric) == true

    asymmetric =
      BinaryTree.tree(
        :a,
        BinaryTree.tree(:b, nil, BinaryTree.tree(:d)),
        BinaryTree.tree(:c, nil, BinaryTree.tree(:e))
      )

    assert BinaryTree.symmetric?(asymmetric) == false
  end

  test "adding a number to a binary tree" do
    assert BinaryTree.add({5, nil, nil}, 7) == {5, nil, {7, nil, nil}}
    assert BinaryTree.add({5, nil, nil}, 3) == {5, {3, nil, nil}, nil}
    assert BinaryTree.add({5, nil, {7, nil, nil}}, 6) == {5, nil, {7, {6, nil, nil}, nil}}
  end

  test "our symmetric? function" do
    assert BinaryTree.test_symmetric([5, 3, 18, 1, 4, 12, 21]) == true
    assert BinaryTree.test_symmetric([3, 2, 5, 7, 4]) == false
  end
end
