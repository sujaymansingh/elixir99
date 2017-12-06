defmodule LogicTest do
  use ExUnit.Case, async: true

  alias Logic.Node

  doctest Logic

  test "producing a truth table" do
    f = fn [a, b] -> Logic.and_(a, Logic.or_(a, b)) end
    result = Logic.table(2, f)

    assert result == [
             [true, true, true],
             [true, false, true],
             [false, true, false],
             [false, false, false]
           ]
  end

  test "traversing a tree" do
    n3 = %Node{label: :three, value: 3}
    n4 = %Node{label: :four, value: 4}
    n5 = %Node{label: :five, value: 5}

    n2 = %Node{label: :two, value: 2, left_child: n3, right_child: n4}

    n1 = %Node{label: :one, value: 1, left_child: n2, right_child: n5}

    func = fn acc, node, trail ->
      # the trail goes up to the root, so we reverse it to make it easier to read
      simplified_trail =
        trail
        |> Enum.map(fn {parent_node, direction} -> {parent_node.label, direction} end)
        |> Enum.reverse()

      [{node.label, simplified_trail} | acc]
    end

    leafs_and_paths = Logic.depth_first_search(n1, [], func)

    # Now here are the leaf nodes, in reverse order...
    assert leafs_and_paths == [
             {:five, [one: :right]},
             {:four, [one: :left, two: :right]},
             {:three, [one: :left, two: :left]}
           ]
  end
end
