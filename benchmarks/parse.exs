# Operating System: Linux
# CPU Information: 12th Gen Intel(R) Core(TM) i9-12900HK
# Number of Available Cores: 20
# Available memory: 62.46 GB
# Elixir 1.15.2
# Erlang 26.0.2
#
# Benchmark suite executing with the following configuration:
# warmup: 2 s
# time: 5 s
# memory time: 0 ns
# reduction time: 0 ns
# parallel: 1
# inputs: none specified
# Estimated total run time: 14 s
#
# Benchmarking Gpp ...
# Benchmarking TransparencyAndConsent ...
#
# Name                             ips        average  deviation         median         99th %
# Gpp                          14.71 K       67.98 μs    ±16.20%       65.53 μs      130.14 μs
# TransparencyAndConsent        5.76 K      173.67 μs    ±26.33%      160.27 μs      348.86 μs
#
# Comparison:
# Gpp                          14.71 K
# TransparencyAndConsent        5.76 K - 2.55x slower +105.68 μs

# massive example consent string
input = "CPs8KYAPs8KYAAGABCENDECsAP_AAH_AAAiQIJtd_H_fbX9j-f596ft0eY1f9_rzruQzDheNk-4FyJ_W_LwX_2E7NB36pq4KmR4Eu1LBAQNlHMHUDUmwaIkVqTHsak2MpTNKJ7BEknMZOydYGF9vmxFD-QKY5t5_93b52D-9_9v-z9z3381Xn3N538_02BAAAAAAAAAAAAAAAAAAAAAAggmAQYCAgAAAIIAAAAIAQgAAhBEgAAAAACAACgAAAIFAAErAIjAQAAEAgAhAABCCAhAgEAAAAASAAACAFggAAAEAgABAAAAAAAIAAQEAFgIAAAAASAAAEAAIEABEAABSGBAQAEEAKAAAAAWSGAEARZQAEAAAAAAAAAAAAAAAAAAAAAAACA2EgjgAIAAXABQAFQAMgAcAA8ACAAGAAMoAaABqADyAIYAigBMACeAFUAN4AcwA9AB-AENAIgAiQBLACaAFKALcAYYAyABlgDZAHeAPYAfEA-wD9gH-AgABFICLgIwARwAkwBKQCggFPAKuAXMAxQBrADaAG4AOIAfIBDoCRAEygJ2AUOAo8BSICmgFigLYAXIAu8BgwDDQGSAMnAZcAzkBnwDSIGsAayA28KABAEUEAFAAbABIAUsAs4BogE2AKbAYEA0cBtQaA2AFwAQwAyABlgDZgH2AfgBAACCgEYAJMAU8Aq8BaAFpANYAdUA-QCHQETAIqASIAnYBSIC5AGTgM5AZ4Az4OABAXQGACAJsAU2A0cBtQiAsAIYAZAAywBswD7APwAgABGACTAFPAKuAawA6oB8gEOgJEATsApEBcgDIwGTgM5AZ8JAAgLoEAAwASAJsAbUKgIAAUACGAEwALgAjgBlgEcAKvAWgBaQFsALkAZGAzkBngDPgG5CwAIC6BQAIBNgDahkA4AIYATABHADLAI4AVcArYC0QFsALkAZGAzkBngDPhoAEBdAwAEAmwBtQ6CwAAuACgAKgAZAA4ACAAF0AMAAygBoAGoAPAAfQBDAEUAJgATwAqgBcADEAGYAN4AcwA9AB-AENAIgAiQBLACaAFGAKUAWIAt4BhAGGAMgAZQA0QBsgDvAHtAPsA_QB_gEUgIsAjEBHAEdAJMASkAoIBTwCrgFigLQAtIBcwC8gGKANoAbgA4gBzgDqAH2AQ6AioBF4CRAEqAJ2AUOAo8BTQCrAFigLYAXAAuQBdoC7wGDAMNAY9AyMDJAGTgMqAZYAy4BmYDOQGfANEAaQA1gBt48AEAIoAjI4AOACQAKABmQE2AKbAaOA2ohA0AAWABQADIALgAYgA1ACGAEwAKYAVQAuABiADMAG8APQAjgBSgCxAGEAMoAd4A-wB_gEUAI4ASkAoIBTwCrwFoAWkAuYBigDaAHOAOoAkQBKgCmgFWALFAWiAtgBcAC5AF2gMjAZOAzkBngDPgGiAOAIgAgCMgJiIABABmgGZATYA2olA0AAQAAsACgAGQAOAAfgBgAGIAPAAiABMACqAFwAMQAZgBDQCIAIkAUYApQBbgDCAGUANkAd8A-wD8AI4AU8Aq8BaAFpALmAYoA3AB1AD5AIdARMAioBF4CRAFHgLFAWwAu0BkYDJwGWAM5AZ4Az4BpADWAG3gOAJgAQCMkgAYAzQDMgJsKQQgAFwAUABUADIAHAAQQAwADKAGgAagA8gCGAIoATAAngBSACqAGIAMwAcwA_ACGgEQARIAowBSgCxAFuAMIAZAAygBogDZAHfAPsA_QCLAEYgI4AjoBKQCggFXAK2AXMAvIBtADcAH2AQ6AiYBF4CRAEnAJ2AUOAqwBYoC2AFwALkAXaAw2BkYGSAMnAZYAy4BnIDPAGfANIgawBrIDbyoAEANpQAMACQAP4BBwCTgJsAU2A.YAAAAAAAAAAA"

Benchee.run(%{
  "TransparencyAndConsent" => fn -> TransparencyAndConsent.decode(input) end,
  "Gpp" => fn -> Gpp.Sections.Tcf.parse(input) end
})
