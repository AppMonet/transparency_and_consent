defmodule TransparencyAndConsent.DecodeError do
  defexception [:message]
  @type t :: %__MODULE__{message: binary()}
end
