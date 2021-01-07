defmodule BrambleTest do
  use ExUnit.Case
  doctest Bramble

  test "greets the world" do
    assert Bramble.hello() == :world
  end
end
