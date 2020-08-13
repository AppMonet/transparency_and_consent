defmodule TransparencyAndConsent.Segment do
  @moduledoc false
  alias TransparencyAndConsent.{VendorList, DecodeError}

  @segments %{
    0 => :core,
    1 => :vendors_disclosed,
    2 => :vendors_allowed,
    3 => :publisher_tc
  }

  @v1_core_fields [
    :created,
    :last_updated,
    :cmp_id,
    :cmp_version,
    :consent_screen,
    :consent_language,
    :vendor_list_version,
    :purpose_consents,
    :vendor_consents
  ]

  @v2_core_fields [
    :created,
    :last_updated,
    :cmp_id,
    :cmp_version,
    :consent_screen,
    :consent_language,
    :vendor_list_version,
    :tcf_policy_version,
    :is_service_specific,
    :use_non_standard_stacks,
    :special_feature_opt_ins,
    :purpose_consents,
    :publisher_legitimate_interests,
    :purpose_one_treatment,
    :publisher_country_code,
    :vendor_consents,
    :vendor_legitimate_interests,
    :publisher_restrictions
  ]

  for {id, segment} <- @segments do
    def id_to_segment(unquote(id)), do: {:ok, unquote(segment)}
    def segment_to_id(unquote(segment)), do: {:ok, unquote(id)}
  end

  def id_to_segment(_), do: {:error, %DecodeError{message: "unknown segment type"}}
  def segment_to_id(_), do: {:error, %DecodeError{message: "unknown segment type"}}

  def decode_segment(:core, segment, acc) do
    with {:ok, acc, rest} <- version(segment, acc),
         {:ok, field_sequence} <- field_sequence(acc) do
      Enum.reduce_while(field_sequence, {:ok, acc, rest}, fn field, {:ok, acc, segment} ->
        case decode_field(field, segment, acc) do
          {:ok, acc, rest} -> {:cont, {:ok, acc, rest}}
          error -> {:halt, error}
        end
      end)
      |> case do
        {:ok, acc, _} -> {:ok, acc}
        error -> error
      end
    end
  end

  def decode_segment(_type, _segment, _acc) do
    {:error, %DecodeError{message: "unsupported segment type"}}
  end

  defp field_sequence(%{version: 1}), do: {:ok, @v1_core_fields}
  defp field_sequence(%{version: 2}), do: {:ok, @v2_core_fields}

  defp field_sequence(%{version: version}) do
    {:error, %DecodeError{message: "unsupported version #{version}"}}
  end

  defp version(<<version::binary-size(6), rest::binary()>>, acc) do
    case Integer.parse(version, 2) do
      {version, ""} ->
        {:ok, %{acc | version: version}, rest}

      _ ->
        {:error, %DecodeError{message: "invalid version"}}
    end
  end

  defp decode_field(:version, _segment, _acc), do: invalid_input_error()

  defp decode_field(:created, <<_created::binary-size(36), rest::binary()>>, acc) do
    {:ok, acc, rest}
  end

  defp decode_field(:created, _segment, _acc), do: invalid_input_error()

  defp decode_field(:last_updated, <<_last_updated::binary-size(36), rest::binary()>>, acc) do
    {:ok, acc, rest}
  end

  defp decode_field(:last_updated, _segment, _acc), do: invalid_input_error()

  defp decode_field(:cmp_id, <<_cmp_id::binary-size(12), rest::binary()>>, acc) do
    {:ok, acc, rest}
  end

  defp decode_field(:cmp_id, _segment, _acc), do: invalid_input_error()

  defp decode_field(:cmp_version, <<_cmp_version::binary-size(12), rest::binary()>>, acc) do
    {:ok, acc, rest}
  end

  defp decode_field(:cmp_version, _segment, _acc), do: invalid_input_error()

  defp decode_field(:consent_screen, <<_consent_screen::binary-size(6), rest::binary()>>, acc) do
    {:ok, acc, rest}
  end

  defp decode_field(:consent_screen, _segement, _acc), do: invalid_input_error()

  defp decode_field(
         :consent_language,
         <<_consent_language::binary-size(12), rest::binary()>>,
         acc
       ) do
    {:ok, acc, rest}
  end

  defp decode_field(:consent_language, _segement, _acc), do: invalid_input_error()

  defp decode_field(
         :vendor_list_version,
         <<_vendor_list_version::binary-size(12), rest::binary()>>,
         acc
       ) do
    {:ok, acc, rest}
  end

  defp decode_field(:vendor_list_version, _segement, _acc), do: invalid_input_error()

  defp decode_field(
         :tcf_policy_version,
         <<_tcf_policy_version::binary-size(6), rest::binary()>>,
         acc
       ) do
    {:ok, acc, rest}
  end

  defp decode_field(:tcf_policy_version, _segement, _acc), do: invalid_input_error()

  defp decode_field(
         :is_service_specific,
         <<_is_service_specific::binary-size(1), rest::binary()>>,
         acc
       ) do
    {:ok, acc, rest}
  end

  defp decode_field(:is_service_specific, _segement, _acc), do: invalid_input_error()

  defp decode_field(
         :use_non_standard_stacks,
         <<_use_non_standard_stacks::binary-size(1), rest::binary()>>,
         acc
       ) do
    {:ok, acc, rest}
  end

  defp decode_field(:use_non_standard_stacks, _segement, _acc), do: invalid_input_error()

  defp decode_field(
         :special_feature_opt_ins,
         <<_special_feature_opt_ins::binary-size(12), rest::binary()>>,
         acc
       ) do
    {:ok, acc, rest}
  end

  defp decode_field(:special_feature_opt_ins, _segement, _acc), do: invalid_input_error()

  defp decode_field(
         :purpose_consents,
         <<_purpose_consents::binary-size(24), rest::binary()>>,
         acc
       ) do
    {:ok, acc, rest}
  end

  defp decode_field(:purpose_consents, _segement, _acc), do: invalid_input_error()

  defp decode_field(
         :publisher_legitimate_interests,
         <<_publisher_legitimate_interests::binary-size(24), rest::binary()>>,
         acc
       ) do
    {:ok, acc, rest}
  end

  defp decode_field(:publisher_legitimate_interests, _segement, _acc), do: invalid_input_error()

  defp decode_field(
         :purpose_one_treatment,
         <<_purpose_one_treatment::binary-size(1), rest::binary()>>,
         acc
       ) do
    {:ok, acc, rest}
  end

  defp decode_field(:purpose_one_treatment, _segement, _acc), do: invalid_input_error()

  defp decode_field(
         :publisher_country_code,
         <<_publisher_country_code::binary-size(12), rest::binary()>>,
         acc
       ) do
    {:ok, acc, rest}
  end

  defp decode_field(:publisher_country_code, _segement, _acc), do: invalid_input_error()

  defp decode_field(:vendor_consents, segment, acc) do
    IO.inspect(segment)

    with {:ok, vendor_consents, rest} <- VendorList.decode(segment) do
      {:ok, %{acc | vendor_consents: vendor_consents}, rest}
    end
  end

  defp decode_field(
         :vendor_legitimate_interests,
         <<_vendor_legitimate_interests::binary-size(12), rest::binary()>>,
         acc
       ) do
    {:ok, acc, rest}
  end

  defp decode_field(:vendor_legitimate_interests, _segement, _acc), do: invalid_input_error()

  defp decode_field(_field, segment, acc), do: {:ok, acc, segment}

  defp invalid_input_error, do: {:error, %DecodeError{message: "invalid input"}}
end
