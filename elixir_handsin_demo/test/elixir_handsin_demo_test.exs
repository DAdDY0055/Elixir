defmodule ElixirHandsinDemoTest do
  use ExUnit.Case
  doctest ElixirHandsinDemo

  test "greets the world" do
    assert ElixirHandsinDemo.hello() == :world
  end
end
