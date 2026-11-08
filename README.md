# Prove2Me corpus preparation

Compatibility checks for the public Couret Lean corpus, requested by Alexandre Couret on 8 November 2026.

This branch contains preparation tools and references to already public source archives. It contains no API key or account token. The workflow does not publish to Prove2Me, alter existing sources, merge branches or certify mathematical originality. Each source file is preserved unchanged and identified by SHA-256. Configuration alone targets the supported Lean 4.30.0 / Mathlib c5ea003 environment.

Independent family builds preserve both failures and successes. The Lean elaborator, rather than source-text matching, supplies declaration spans and dependencies for subsequent preparation. An import graph and a list of historical files are not proof verification.

The two extraction scripts are retained from https://github.com/prove2me/prove2me_workspace ; their source, comments are preserved. The five input archive digests come from the public corpus catalogue. Archive availability is not treated as a new licence grant.
