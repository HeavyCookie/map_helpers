defmodule TestModule do
  defstruct [:test]
  @moduledoc """
  Test module with struct for `MapHelpersTest`
  """
end

defmodule Map.HelpersTest do
  @moduledoc false
  use ExUnit.Case
  doctest Map.Helpers

  use ExUnit.Case

  test ".underscore_keys" do
    result = Map.Helpers.underscore_keys(%{"MapHelpers" => "are fun"})
    assert result == %{"map_helpers" => "are fun"}
  end

  describe ".stringify_keys" do
    test "not a map" do
      result = Map.Helpers.stringify_keys("a")
      assert result == "a"
    end

    test "with atom keys" do
      result = Map.Helpers.stringify_keys(%{a: "b"})
      assert result == %{"a" => "b"}
    end

    test "with multiple level" do
      result = Map.Helpers.stringify_keys(%{a: %{b: "c"}})
      assert result == %{"a" => %{"b" => "c"}}
    end

    test "with mixed keys" do
      result = Map.Helpers.stringify_keys(%{:a => "b", "c" => "d"})
      assert result == %{"a" => "b", "c" => "d"}
    end
  end

  describe ".atomize_keys" do
    test "not a map" do
      result = Map.Helpers.stringify_keys("a")
      assert result == "a"
    end

    test "with string keys" do
      result = Map.Helpers.atomize_keys(%{"a" => "b"})
      assert result == %{a: "b"}
    end

    test "with multiple levels" do
      result = Map.Helpers.atomize_keys(%{"a" => %{"b" => "c"}})
      assert result == %{a: %{b: "c"}}
    end

    test "don't do enumerable and anyway the keys are already atoms" do
      result = Map.Helpers.atomize_keys(%TestModule{test: "test"})
      assert result == %TestModule{test: "test"}
    end
  end

  describe ".deep_merge" do
    test "one level of maps without conflict" do
      result = Map.Helpers.deep_merge(%{a: 1}, %{b: 2})
      assert result == %{a: 1, b: 2}
    end

    test "two levels of maps without conflict" do
      result = Map.Helpers.deep_merge(%{a: %{b: 1}}, %{a: %{c: 3}})
      assert result == %{a: %{b: 1, c: 3}}
    end

    test "three levels of maps without conflict" do
      result = Map.Helpers.deep_merge(%{a: %{b: %{c: 1}}}, %{a: %{b: %{d: 2}}})
      assert result == %{a: %{b: %{c: 1, d: 2}}}
    end

    test "non-map value in left" do
      result = Map.Helpers.deep_merge(%{a: 1}, %{a: %{b: 2}})
      assert result == %{a: %{b:  2}}
    end

    test "non-map value in right" do
      result = Map.Helpers.deep_merge(%{a: %{b: 1}}, %{a: 2})
      assert result == %{a: 2}
    end

    test "non-map value in both" do
      result = Map.Helpers.deep_merge(%{a: 1}, %{a: 2})
      assert result == %{a: 2}
    end
  end
end
