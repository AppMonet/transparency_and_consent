defmodule TransparencyAndConsent.Base64 do
  @moduledoc false
  alias TransparencyAndConsent.DecodeError

  @charset "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_"
  @reverse_dict @charset
                |> String.split("", trim: true)
                |> Enum.with_index(0)
                |> Map.new()

  @doc """
  Decodes a base64url encoded bitfield string to a bitfield string.

  ## Examples

      iex> TransparencyAndConsent.Base64.decode("COvFyGBOvFyGBAbAAAENAPCAAOAAAAAAAAAAAEEUACCKAAA")
      {:ok, "000010001110101111000101110010000110000001001110101111000101110010000110000001000000011011000000000000000000000100001101000000001111000010000000000000001110000000000000000000000000000000000000000000000000000000000000000000000100000100010100000000000010000010001010000000000000000000"}

  """
  def decode(input), do: do_decode(input, [])

  defp do_decode(<<>>, acc), do: {:ok, acc |> Enum.reverse() |> Enum.join()}

  defp do_decode(<<char::binary-size(1), rest::binary()>>, acc) do
    case decode_char(char) do
      :error ->
        {:error, %DecodeError{message: "invalid character in segment: `#{char}`"}}

      value ->
        bitfield_string =
          value
          |> Integer.to_string(2)
          |> pad()

        do_decode(rest, [bitfield_string | acc])
    end
  end

  defp pad(string) when byte_size(string) == 6, do: string
  defp pad(string) when byte_size(string) == 5, do: "0" <> string
  defp pad(string) when byte_size(string) == 4, do: "00" <> string
  defp pad(string) when byte_size(string) == 3, do: "000" <> string
  defp pad(string) when byte_size(string) == 2, do: "0000" <> string
  defp pad(string) when byte_size(string) == 1, do: "00000" <> string

  for {char, int} <- @reverse_dict do
    defp decode_char(unquote(char)), do: unquote(int)
  end

  defp decode_char(_), do: :error
end
