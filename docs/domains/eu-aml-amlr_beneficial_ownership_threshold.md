# Does a person's effective holding reach the 25 % threshold (AMLR Art 52)?

`eu/aml/amlr_beneficial_ownership_threshold`

| Tests passed | Provision tracking | Citations | Parameters | Provenance |
|---|---|---|---|---|
| 105/105 | enforced: 13 units: 3 formalized, 10 deferred (9 authorized, 1 expansion), 0 unaccounted | pass | pass | pass |

## Scope

Determines whether a natural person qualifies as a beneficial owner under AMLR Art 52 by computing their aggregate effective ownership percentage (direct and indirect) and comparing it to the 25% statutory threshold. Holdings are expressed in basis points (1 BP = 0.01%, so 25% = 2500 BP). Indirect holdings multiply across each level of an ownership chain; parallel chains are summed to produce the total effective holding. The profile must be complete: a ground dict whose ownership_chains is a list of non-empty chains of integer basis points 0..10000; any other profile is indeterminate, with the problem named by amlr_bo_input_problem/2 as the reason.

## Pinned sources

| Document | Consolidated | Fetched | SHA-256 (extract) |
|---|---|---|---|
| CELEX 32024R1624 | base act | 2026-09-09 | `eb5f95f7039a8f34...` |
| CELEX 32024R1624 | base act | 2026-09-09 | `8f7024212fe23c18...` |
| CELEX 32024R1624 | base act | 2026-09-09 | `3e57bab019652124...` |

[Side-by-side provision report](../reports/eu-aml-amlr_beneficial_ownership_threshold.html){ .md-button }
[Source on GitHub](https://github.com/neurosymbolica/clausal-rules-as-code/blob/main/eu/aml/amlr_beneficial_ownership_threshold){ .md-button }

## Provisions deferred, and what follows

??? info "control_based_ubo"

    **Why:** Beneficial ownership through control (Art 51, first paragraph, point (b), and its second paragraph; Art 52(4) for entities whose ownership cannot be calculated; Art 54 where ownership interest and control coexist across the layers of a chain) is the separate Art 53 control test. This domain decides the Art 52(1) ownership-interest test only.

    **Consequence for a user:** A natural person below the 25 % line who controls the entity, or who reaches it only through a mix of ownership and control along a chain, is reported as not a beneficial owner here. A caller must run the control test separately and combine the results.

??? info "sectoral_15pct_lowering"

    **Why:** Art 52(2)-(3) empower the Commission to set lower thresholds (at most 15 %) for higher-risk categories of corporate entities by delegated act, and to review that act. No such delegated act is in force.

    **Consequence for a user:** Every corporate entity is tested against 25 %. If a delegated act lowers the threshold for a category, entities in that category are tested against the wrong line until this domain is updated.

??? info "article_headings"

    **Why:** The heading of Art 52 carries no obligation. Deferred so that every unit of the pinned extract is accounted for.

    **Consequence for a user:** None. A heading states no rule.

??? info "trust_and_arrangement_ubo"

    **Why:** Beneficial owners of express trusts, similar legal arrangements and similar legal entities (Arts 55-56) are identified by role, not by an ownership percentage. Those articles are not in this domain's pinned extract, so this entry names no units.

    **Consequence for a user:** A trust or similar arrangement handed to this domain is assessed as if it were a corporate entity with ownership chains, which is not the Arts 55-56 test. A caller must route trusts and arrangements to a domain that implements those articles.

