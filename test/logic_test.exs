defmodule LogicTest do
  use ExUnit.Case, async: true
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
end
