defmodule TransparencyAndConsentTest do
  use ExUnit.Case
  doctest TransparencyAndConsent

  describe "decode/1" do
    test "all segments, with `field` type vendor_consents" do
      input =
        "CGL23UdMFJzvuA9ACCENAXCEAC0AAGrAAA5YA5ht7-_d_7_vd-f-nrf4_4A4hM4JCKoK4YhmAqABgAEgAA.IFut_a83_Ma_t-_SvB3v4-IAeIAACAIgSAAQAIAgEQACEABAAAgAQFAEAIAAAGBAAgAAAAQAIFAAMCQAAgAAQiRAEQAAAAANAAIAAggAIYQFAAARmggBC3ZCYzU2yIA.QFulWfTw4obx_Z2zUj6XkNIAeIAACAIgSAAQAIAgEQACEABAAAgAQFAEAIAAAGBAAgAAAAQAIFAAMCQAAgAAQiRAEQAAAAANAAIAAggAIYQFAAARmggBC3ZCYzU2yIA"

      assert {:ok, %TransparencyAndConsent{version: 2, vendor_consents: consents}} =
               TransparencyAndConsent.decode(input)

      assert length(consents) == 91
    end

    test "all segments with `range` type vendor_consents" do
      input =
        "CO4D9fZO4D9fZAGABCENAyCsAP_AAE_AABaYGGQHwAAwAKAAsABoAGQAOAAgABUADIAGgAOoAegB8AEUAJgAUAAwgBoAEJAI4AkABLACiAFaAMsAeAA_QCAAEHAIwAWYBJ4C8wGGAIPAHADQAIQARwAywB4AEAAIOASMgDAAqACYAI4AZYBGAF5iIAYAKgBlgEYCQDQAFgAZAA4ACAAFQANAAfABMAEsAMsAfoBGAF5hoAYAKgBlgEYFQBgAVABMAEcAMsAjAC8x0AwABYAGQAOAAgABUADQAHwATABLAD9AIwAvMhAGAAWABkAFQATABHAEYJQBgAFgAZAA4AEwAjAC8ykAoABYAGQAOAAgABUADQAJgA_QCMALzAAA.YAAAAAAAAAAA"

      assert {:ok, %TransparencyAndConsent{version: 2, vendor_consents: consents}} =
               TransparencyAndConsent.decode(input)

      assert length(consents) == 35
    end

    test "returns DecodeError for invalid input" do
      assert {:error, %TransparencyAndConsent.DecodeError{}} =
               TransparencyAndConsent.decode("WAT")
    end

    test "correctly parses version 1.1 as well" do
      input =
        "BOtn-dKO4E4lPAKAkBITDW-AAAAyN7_______9_-____9uz_Ov_v_f__33e8__9v_l_7_-___u_-23d4u_1vf99yfmx-7etr3tp_47ues2_Xurf_71__3z3_9pxP78E89r7335EQ_v-_t-b7BCHN_Y2v-8K96lPKACE"

      assert {:ok, %TransparencyAndConsent{version: 1, vendor_consents: consents}} =
               TransparencyAndConsent.decode(input)

      assert length(consents) == 605
    end
  end
end
