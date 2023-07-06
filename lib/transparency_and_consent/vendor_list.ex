defmodule TransparencyAndConsent.VendorList do
  @moduledoc false

  alias TransparencyAndConsent.DecodeError

  @encoding_type %{
    "0" => :field,
    "1" => :range
  }

  def decode(<<max_id::binary-size(16), input::binary>>) do
    with {:ok, max_id} <- max_id(max_id),
         {:ok, encoding_type, input} <- encoding_type(input) do
      do_decode(encoding_type, input, max_id)
    end
  end

  def decode(_), do: invalid_input_error()

  defp do_decode(:field, input, max_id) do
    init = {:ok, [], input}

    Enum.reduce_while(1..max_id, init, fn
      i, {:ok, entries, "1" <> rest} ->
        {:cont, {:ok, [i | entries], rest}}

      _, {:ok, entries, "0" <> rest} ->
        {:cont, {:ok, entries, rest}}

      _, _ ->
        {:halt, invalid_input_error()}
    end)
  end

  defp do_decode(:range, input, _max_id) do
    with {:ok, num_entries, rest} <- num_entries(input) do
      Enum.reduce_while(1..num_entries, {:ok, [], rest}, fn _, {:ok, entries, remaining} ->
        with {:ok, is_id_range?, remaining} <- is_id_range?(remaining),
             {:ok, _, _} = result <- extract_entries(remaining, entries, is_id_range?) do
          {:cont, result}
        else
          error -> {:halt, error}
        end
      end)
    end
  end

  defp extract_entries(
         <<start_id::binary-size(16), end_id::binary-size(16), rest::binary>>,
         entries,
         true
       ) do
    with {start_id, ""} <- Integer.parse(start_id, 2),
         {end_id, ""} <- Integer.parse(end_id, 2) do
      updated_entries = Enum.reduce(start_id..end_id, entries, fn id, acc -> [id | acc] end)
      {:ok, updated_entries, rest}
    else
      _ -> {:error, %DecodeError{message: "invalid vendor list range"}}
    end
  end

  defp extract_entries(<<vendor_id::binary-size(16), rest::binary>>, entries, false) do
    case Integer.parse(vendor_id, 2) do
      {vendor_id, ""} -> {:ok, [vendor_id | entries], rest}
      _ -> invalid_input_error()
    end
  end

  defp extract_entries(_, _, _), do: {:error, :invalid_input}

  defp max_id(input) do
    case Integer.parse(input, 2) do
      {max_id, ""} -> {:ok, max_id}
      _ -> invalid_input_error()
    end
  end

  defp encoding_type(<<type::binary-size(1), rest::binary>>) do
    case Map.get(@encoding_type, type) do
      nil -> {:error, %DecodeError{message: "invalid vendor list encoding type"}}
      type -> {:ok, type, rest}
    end
  end

  defp num_entries(<<num_entries::binary-size(12), rest::binary>>) do
    case Integer.parse(num_entries, 2) do
      {num, ""} -> {:ok, num, rest}
      _ -> {:error, :invalid_input}
    end
  end

  defp is_id_range?("1" <> rest), do: {:ok, true, rest}
  defp is_id_range?("0" <> rest), do: {:ok, false, rest}
  defp is_id_range?(_), do: invalid_input_error()

  defp invalid_input_error, do: {:error, %DecodeError{message: "invalid input"}}
end
