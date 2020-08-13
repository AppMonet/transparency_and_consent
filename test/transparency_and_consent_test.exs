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

    test "returns DecodeError for unsupported versions" do
      v1_input =
        "BOeLqXmOeLqXmAtABBENCL-AAAAmB7_______9______5uz_Ov_v_f__33e8__9v_l_7_-___u_-33d4-_1vf99yfm1-7ftr3tp_87ues2_Xur__59__3z3_9phPrsks9Kg"

      assert {:error, %TransparencyAndConsent.DecodeError{message: "unsupported version: 1"}} =
               TransparencyAndConsent.decode(v1_input)
    end
  end
end
