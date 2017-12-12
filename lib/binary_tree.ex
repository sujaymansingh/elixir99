defmodule BinaryTree do
  @moduledoc """
  https://sites.google.com/site/prologsite/prolog-problems/4

  A binary tree is either empty or it is composed of a root element and two successors, which are 
  binary trees themselves.
  In ~~Prolog~~ Elixir we represent the empty tree by ~~the atom~~ 'nil' and the non-empty tree
  by the term `{X,L,R}`, where `X` denotes the root node and `L` and `R` denote the left and right
  subtree, respectively.
  """

  @doc """
  Check whether a given term represents a binary tree

    iex> BinaryTree.istree?({:a, {:b, nil, nil}, nil})
    true
    iex> BinaryTree.istree?({:a, {:b, nil, nil}})
    false
  """
  def istree?(nil), do: true
  def istree?({_, left, right}), do: istree?(left) and istree?(right)
  def istree?(_), do: false

  @doc """
  Construct completely balanced binary trees

  In a completely balanced binary tree, the following property holds for every node:
  The number of nodes in its left subtree and the number of nodes in its right subtree are almost 
  equal, which means their difference is not greater than one.
  """
  def cbal_tree(n), do: cbal_tree(n, :x)

  def cbal_tree(0, _), do: [nil]

  def cbal_tree(n, default_element) do
    num_remaining = n - 1

    case rem(num_remaining, 2) do
      0 ->
        # This is easy, as each side can only have num_remaining/2 nodes
        each_side = div(num_remaining, 2)
        possible_subtrees = cbal_tree(each_side, default_element)
        build_possible_trees(default_element, possible_subtrees, possible_subtrees)

      1 ->
        # This is a bit more complex. The number of nodes on each side can differ by only 1.
        # n = m + (m + 1)
        # Thus we have two options:
        # 1) left has m, right has m + 1
        # 2) left has m + 1, right has m
        m = div(num_remaining, 2)
        little_half = cbal_tree(m, default_element)
        bigger_half = cbal_tree(m + 1, default_element)

        build_possible_trees(default_element, little_half, bigger_half) ++
          build_possible_trees(default_element, bigger_half, little_half)
    end
  end

  defp build_possible_trees(default_element, possible_left_subtrees, possible_right_subtrees) do
    for possible_left <- possible_left_subtrees,
        possible_right <- possible_right_subtrees do
      {default_element, possible_left, possible_right}
    end
  end

  def tree(root_element, left_child, right_child), do: {root_element, left_child, right_child}
  def tree(root_element), do: {root_element, nil, nil}
  def tree(), do: nil

  @doc """
  Symmetric binary trees

  Let us call a binary tree symmetric if you can draw a vertical line through the root node and
  then the right subtree is the mirror image of the left subtree.
  """
  def symmetric?({_, left, right}) do
    mirror?(left, right)
  end

  @doc """
  Return true if the two tree structures are mirror images (root elements are ignored)
  """
  def mirror?(nil, nil), do: true
  def mirror?(_, nil), do: false
  def mirror?(nil, _), do: false

  def mirror?({_, left_a, right_a}, {_, left_b, right_b}) do
    mirror?(left_a, right_b) and mirror?(right_a, left_b)
  end

  @doc """
  Binary search trees (dictionaries)

  Write a predicate to construct a binary search tree from a list of integer numbers.

      iex> BinaryTree.construct([3, 2, 5, 7, 1])
      {3, {2, {1, nil, nil}, nil}, {5, nil, {7, nil, nil}}}
  """
  def construct(numbers) do
    Enum.reduce(numbers, tree(), fn num, current_tree -> add(current_tree, num) end)
  end

  @doc """
  Add a number to the relevant binary tree (and in the correct place)
  """
  def add(nil, num), do: tree(num)
  def add({root, nil, right}, num) when num <= root, do: {root, tree(num), right}
  def add({root, left, nil}, num) when num > root, do: {root, left, tree(num)}
  def add({root, left, right}, num) when num <= root, do: {root, add(left, num), right}
  def add({root, left, right}, num) when num > root, do: {root, left, add(right, num)}

  @doc """
  Return true if the binary tree constructed from the given numbers is symmetric
  """
  def test_symmetric(numbers), do: construct(numbers) |> symmetric?

  @doc """
  Generate-and-test paradigm

  Apply the generate-and-test paradigm to construct all symmetric,
  completely balanced binary trees with a given number of nodes.
  """
  def sym_cbal_trees(n), do: sym_cbal_trees(n, :x)

  def sym_cbal_trees(n, default_element) do
    cbal_tree(n, default_element)
    |> Enum.filter(&symmetric?/1)
  end

  @doc """
  Construct height-balanced binary trees

  In a height-balanced binary tree, the following property holds for every node:
  The height of its left subtree and the height of its right subtree are almost equal,
  which means their difference is not greater than one.
  """
end
