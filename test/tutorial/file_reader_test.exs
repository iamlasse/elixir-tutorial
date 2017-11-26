defmodule FileReaderTest do
  use ExUnit.Case, async: true
  import Tutorial.FileReader
  import Mock

  doctest Tutorial.FileReader

  test "Passing a file should return a string" do
    with_mock File, read!: fn _ -> "One tweet\nSecond tweet\nThird tweet" end do
      str = get_strings("no.txt")

      assert str != nil
    end
  end

  test "Will not return a tring longer than 140 characters" do
    with_mock File,
      read!: fn _ ->
        "Esse voluptate est qui culpa sunt commodo officia enim dolor aliquip pariatur incididunt. Esse voluptate est qui culpa sunt commodo officia enim dolor aliquip pariatur incididunt.\nShort line"
      end do
      str = get_strings("no.txt")
      assert str == "Short line"
    end
  end

  test "Should return an empty string" do
    with_mock File, read!: fn _ -> "" end do
      str = get_strings("no.txt")

      assert str == ""
    end
  end

  test "Should return a trimmed version of the string" do
    with_mock File, read!: fn _ -> " ABC " end do
      str = get_strings("no.txt")
      assert str == "ABC"
    end
  end
end
