defmodule MiniRedis.Protocol do
    
  def parse(str), do: parse(str, [])  
  defp parse(<<>>, acc), do: {:ok, parse_result(acc)} 
  defp parse(<<"\n">>, acc), do: {:ok, parse_result(acc)} 
  defp parse(<<"\r\n">>, acc), do: {:ok, parse_result(acc)} 

  defp parse(<<" ", rest::binary>>, [[]| _tl] = acc), do: parse(rest, acc)
  defp parse(<<" ", rest::binary>>, acc), do: parse(rest, [[] | acc]) 
  defp parse(<<?"::utf8, rest::binary>>, acc),  do: parse(rest, acc, :open)
  defp parse(<<c::binary-size(1), rest::binary>>, []), do: parse(rest, [c])
  defp parse(<<c::binary-size(1), rest::binary>>, [[] | tl]), do: parse(rest, [c | tl]) 
  defp parse(<<c::binary-size(1), rest::binary>>, [hd | tl]), do: parse(rest, [hd <> c | tl]) 
  defp parse(<<c::binary-size(1), rest::binary>>, [[] | tl], :open), do: parse(rest, [c | tl], :cont) 
  defp parse(<<c::binary-size(1), rest::binary>>, acc, :open), do: parse(rest, [c | acc], :cont) 
  defp parse(<<?"::utf8, rest::binary>>, acc, :cont), do: parse(rest, acc)
  defp parse(<<?\\, ?", rest::binary>>, [hd | tl], :cont), do:  parse(rest, [hd <> "\"" | tl], :cont)
  defp parse(<<?\\, ?\\, rest::binary>>, [hd | tl], :cont), do: parse(rest, [hd <> "\\" | tl], :cont) 
  defp parse(<<"\\n", rest::binary>>, [hd | tl], :cont), do: parse(rest, [hd <> "\n" | tl], :cont) 
  defp parse(<<c::binary-size(1), rest::binary>>, [hd | tl], :cont), do: parse(rest, [hd <> c | tl], :cont) 
  defp parse(<<>>, _, :cont), do: {:error, :no_qoute} 
  
  defp parse_result(acc), do: acc |> Enum.reverse  |> List.flatten |> Enum.map(&String.trim(&1))
  
end