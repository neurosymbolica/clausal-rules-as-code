# Is a person a beneficial owner through direct and indirect holdings in a chain of entities (AMLR Art 52(1))?

`eu/aml/amlr_bo_chain`

| Tests passed | Provision tracking | Citations | Parameters | Provenance |
|---|---|---|---|---|
| 84/84 | enforced: 10 units: 3 formalized, 7 deferred (2 authorized, 5 expansion), 0 unaccounted | pass | pass | pass |

## Scope

AMLR Reg 2024/1624 Art 52(1): is a natural person a beneficial owner — effective ownership (direct + indirect; chains multiply per level, add across parallel chains) >= 25%. Inputs must be complete: holdings a ground list of [holder, entity, integer basis points 0..10000] edges with no cycle, person and entity names; any other input gives no verdict (bo_chain_input_problem/4 names the problem).

## Pinned sources

| Document | Consolidated | Fetched | SHA-256 (extract) |
|---|---|---|---|
| CELEX 32024R1624 | base act | 2026-09-09 | `eb5f95f7039a8f34...` |
| CELEX 32024R1624 | base act | 2026-09-09 | `8f7024212fe23c18...` |

[Side-by-side provision report](../reports/eu-aml-amlr_bo_chain.html){ .md-button }
[Source on GitHub](https://github.com/neurosymbolica/clausal-rules-as-code/blob/main/eu/aml/amlr_bo_chain){ .md-button }

## Provisions deferred, and what follows

??? info "control_based_ubo"

    **Why:** Beneficial ownership through control via other means (Art 51, first paragraph, point (b), its second paragraph, and Art 52(4) for entities whose ownership cannot be calculated) is the separate Art 53 control test. This domain decides the Art 52(1) ownership-interest test only.

    **Consequence for a user:** A natural person below the 25 % ownership line who controls the entity by other means is reported as not a beneficial owner here. A caller must run the control test separately and combine the two results.

??? info "delegated_lower_thresholds"

    **Why:** Art 52(2)-(3) empower the Commission to set lower thresholds (at most 15 %) for higher-risk categories of corporate entities by delegated act, and to review that act. No such delegated act is in force, so there is no lower threshold to apply.

    **Consequence for a user:** Every corporate entity is tested against 25 %. If a delegated act lowers the threshold for a category, entities in that category are tested against the wrong line until this domain is updated.

??? info "article_headings"

    **Why:** The heading of Art 52 carries no obligation. Deferred so that every unit of the pinned extract is accounted for.

    **Consequence for a user:** None. A heading states no rule.

