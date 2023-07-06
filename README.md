# Deprecation notice!

This library has been deprecated in favor of [`Gpp`](https://github.com/AdaptMX/gpp), which provides the same functionality, plus quite a bit more.
`Gpp` is also much faster at parsing TCF strings, see `benchmarks/parse.exs`.

# TransparencyAndConsent

Decode IAB Transparency and Consent Framework v1.1 & v2.0 strings.

Currently only decodes the version, and the list of vendor consents for maximum performance.

## Installation

```elixir
def deps do
  [
    {:transparency_and_consent, "~> 0.1.0"}
  ]
end
```

Documentation can be found at [https://hexdocs.pm/transparency_and_consent](https://hexdocs.pm/transparency_and_consent).
