defmodule Redis.Coder do
  def encode(term) when is_binary(term) do
    if String.printable?(term), do: term, else: :erlang.term_to_binary(term)
  end

  def encode(term), do: :erlang.term_to_binary(term)

  def decode(binary) when is_binary(binary) do
    if String.printable?(binary), do: binary, else: :erlang.binary_to_term(binary)
  end

  def decode(list) when is_list(list) do
    for binary <- list, not is_nil(binary) do
      decode(binary)
    end
  end
end
