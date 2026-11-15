defmodule ProtocolTest do
  use ExUnit.Case, async: true

  alias MiniRedis.Protocol

  test "1" do
    assert Protocol.parse("SET name \"Taras Shevchenko\"\n") ==
             {:ok, ["SET", "name", "Taras Shevchenko"]}
  end

  test "2" do
    assert Protocol.parse(~S(SET name "Taras Shevchenko") <> "\n") ==
             {:ok, ["SET", "name", "Taras Shevchenko"]}
  end

  test "3" do
    assert Protocol.parse(~S(SET quote "say \"hi\"") <> "\n") ==
             {:ok, ["SET", "quote", ~S(say "hi")]}
  end

  test "4" do
    assert Protocol.parse(~S(SET k "line1\nline2") <> "\n") ==
             {:ok, ["SET", "k", "line1\nline2"]}
  end
  
  test "PING" do
    assert Protocol.parse(~S(PING ) <> "\n") ==
             {:ok, ["PING"]}
  end

  test "" do
    assert {:error, _} = Protocol.parse(~S(SET broken "abc) <> "\n")
  end
end