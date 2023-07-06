defmodule TransparencyAndConsent.MixProject do
  use Mix.Project

  @name "TransparencyAndConsent"
  @version "0.1.0"
  @repo_url "https://github.com/AppMonet/transparency_and_consent"

  def project do
    [
      app: :transparency_and_consent,
      version: @version,
      elixir: "~> 1.7",
      description: "Decode IAB Transparency and Consent Framework v1.1 & v2.0 strings.",
      package: package(),
      docs: docs(),
      start_permanent: Mix.env() == :prod,
      name: @name,
      source_url: @repo_url,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:gpp, github: "Adaptmx/gpp", only: :dev},
      {:benchee, "~> 1.0", only: :dev},
      {:ex_doc, "~> 0.22", only: :dev, runtime: false}
    ]
  end

  defp package do
    %{
      licenses: ["Apache 2"],
      maintainers: ["Nico Piderman"],
      links: %{"GitHub" => @repo_url}
    }
  end

  defp docs do
    [
      main: "TransparencyAndConsent",
      source_ref: "v#{@version}",
      source_url: @repo_url
    ]
  end
end
