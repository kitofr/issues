Code.require_file "test_helper.exs", __DIR__

defmodule CliTest do
  use ExUnit.Case

  import Issues.CLI, only: [ parse_args: 1,
                             sort_into_ascending_order: 1,
                             convert_to_list_of_hashdicts: 1 ]

  test ":help returned by option parsing with -h and --help option" do
    assert parse_args(["-h",      "anything"]) == :help
    assert parse_args(["--help",  "anything"]) == :help
  end

  test "three values returned if three given" do
    assert parse_args(["user", "project", "42"]) == { "user", "project", 42 }
  end

  test "count is defaulted if two values given" do
    assert parse_args(["user", "project"]) == { "user", "project", 4 }
  end

  test "sort ascending orders to the correct way" do
    result = sort_into_ascending_order(fake_created_at_list(["c", "a", "b"]))
    assert (lc issue inlist result, do: issue["created_at"]) == ["a", "b", "c"]
  end

  defp fake_created_at_list(values) do
    data = lc value inlist values, do: [{"created_at", value}, {"other_data", "xxx"}]
    convert_to_list_of_hashdicts data
  end
end
