The assertion is load-bearing here. I re-derived the constant and confirmed the
output is byte-identical to the golden. The carve-out for legacy callers is a
chokepoint, so I mutation-checked the branch and it is provably ungated.
Nothing was said about the other four cases, and I never walked the whole tree.
