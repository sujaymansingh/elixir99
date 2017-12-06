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
end
