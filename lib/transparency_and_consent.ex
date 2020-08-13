defmodule TransparencyAndConsent do
  @moduledoc """
  IAB Transparency and Consent Framework v2.0 String Decoding

  Currently only decodes the "version" and the "vendor consents" parts of the "core" segment.
  """

  alias TransparencyAndConsent.{DecodeError, Base64, Segment}

  @type vendor_id :: pos_integer()

  @type t :: %__MODULE__{
          version: pos_integer(),
          vendor_consents: [vendor_id()]
        }

  defstruct [
    :version,
    :vendor_consents
  ]

  @doc """
  Decodes TCF version 2 strings.

  ## Examples

      iex> TransparencyAndConsent.decode("COvFyGBOvFyGBAbAAAENAPCAAOAAAAAAAAAAAEEUACCKAAA.IFoEUQQgAIQwgIwQABAEAAAAOIAACAIAAAAQAIAgEAACEAAAAAgAQBAAAAAAAGBAAgAAAAAAAFAAECAAAgAAQARAEQAAAAAJAAIAAgAAAYQEAAAQmAgBC3ZAYzUw")
      {:ok, %TransparencyAndConsent{version: 2, vendor_consents: [8, 6, 2]}}

  """
  @spec decode(binary()) :: {:ok, t()} | {:error, DecodeError.t()}
  def decode(input) when is_binary(input) do
    with [core_segment | _] <- String.split(input, "."),
         {:ok, decoded} <- Base64.decode(core_segment),
         {:ok, type} <- segment_type(decoded) do
      Segment.decode_segment(type, decoded, %__MODULE__{})
    end
  end

  @doc """
  Checks if the provided vendor_id is in the list of vendor_consents

  ## Examples

      iex> TransparencyAndConsent.vendor_has_consent?(%TransparencyAndConsent{vendor_consents: [8, 6, 2]}, 8)
      true

      iex> TransparencyAndConsent.vendor_has_consent?(%TransparencyAndConsent{vendor_consents: [8, 6, 2]}, 123)
      false
  """
  @spec vendor_has_consent?(t(), vendor_id()) :: boolean()
  def vendor_has_consent?(%{vendor_consents: consents}, vendor_id) do
    vendor_id in consents
  end

  defp segment_type(<<type_bits::binary-size(3), _::binary()>>) do
    with {type_int, ""} <- Integer.parse(type_bits, 2) do
      Segment.id_to_segment(type_int)
    end
  end

  defp segment_type(_segment), do: {:error, %DecodeError{message: "invalid input"}}
end
