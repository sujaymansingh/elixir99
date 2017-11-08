defmodule Elixir99Test do
  use ExUnit.Case
  doctest Elixir99

  test "greets the world" do
    assert Elixir99.hello() == :world
  end
end
