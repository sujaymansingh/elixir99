defmodule ArithmeticTest do
  use ExUnit.Case, async: true
  doctest Arithmetic

  test "We can identify prime numbers" do
    assert Arithmetic.prime?(1) == true
    assert Arithmetic.prime?(2) == true
    assert Arithmetic.prime?(3) == true
    assert Arithmetic.prime?(5101) == true

    assert Arithmetic.prime?(33) == false
    assert Arithmetic.prime?(25) == false
  end

  test "Can't work out prime factors of a non-positive integer" do
    assert Arithmetic.prime_factors(0) == []
    assert Arithmetic.prime_factors(-1) == []
  end
end
