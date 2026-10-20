"""The provenance-marker functor, and NOTHING ELSE.

A LEAF MODULE ON PURPOSE: it imports nothing, so adding it to `auto/rerun.py`'s
GATE_TOOLS allowlist grows that list by one auditable file rather than by a
package. That allowlist is curated against a seal rationale -- check_corpus_
conventions is excluded because its R4 imports mutation_runner, which executes
the sealed oracle -- so every addition has to clear the same bar, and a leaf
with no imports clears it trivially.

WHY IT EXISTS. The 2026-08-28 marker rename put `CITE_FUNCTOR` in
`_tools/provisions/clauses.py` and had `scaffold_citations.py` import it from
there, to keep one source of truth. That added an edge to GATE_TOOLS' transitive
import closure which the allowlist does not ship: producer scratch trees get a
truncated `_tools/` with seven files and no `provisions/` package, so
`check_citations` raised `ModuleNotFoundError` on import in EVERY scratch tree
and the assure gate failed with a traceback the producer could not act on.

It was invisible in every check we run. The corpus checks pass in the LIVE tree,
where `_tools/provisions/` is present; only a RUN builds a truncated one. Suite
green, hook green, corpus green, every evaluation run broken. Found by a known-green
CONTROL domain going red in an evaluation run -- thresholds, 5/5 before, blocked at
assure.

Single source of truth is preserved: `provisions/clauses.py` and
`scaffold_citations.py` both read the constant from here.
"""

#: The clause-body functor that declares which provision a clause implements.
#: `cite` is NOT this -- it is the data constructor building the citation list a
#: verdict returns, and conflating the two is what the rename separated.
CITE_FUNCTOR = "implements"
