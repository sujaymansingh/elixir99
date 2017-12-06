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
  Return true iff if the argument is a term that represents a tree.

    iex> BinaryTree.istree?({:a, {:b, nil, nil}, nil})
    true
    iex> BinaryTree.istree?({:a, {:b, nil, nil}})
    false
  """
  def istree?(nil), do: true
  def istree?({_, left, right}), do: istree?(left) and istree?(right)
  def istree?(_), do: false
end
