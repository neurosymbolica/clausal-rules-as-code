# What is the minimum time limit for receipt (Art 27-31)?

`eu/procurement/time_limits`

| Tests passed | Provision tracking | Citations | Parameters | Provenance |
|---|---|---|---|---|
| 117/117 | enforced: 43 units: 18 formalized, 25 deferred (25 authorized, 0 expansion), 0 unaccounted | pass | pass | pass |

## Scope

EU Directive 2014/24/EU Articles 27-31 -- the minimum-time-limit decision surface for the five competitive procedures. Given a procedure type, a stage (receipt of tenders / receipt of requests to participate), and three circumstance flags (prior information notice published per Art 27(2)/28(3); electronic tender submission accepted per Art 22(1) with Art 27(4)/28(5); state of urgency duly substantiated per Art 27(3)/28(6)), returns the minimum lawful time limit in days plus the article citation(s). Given additionally the day count the notice ACTUALLY allowed (observed_time_limit_days), returns whether that limit meets the prescribed minimum -- the CONFORMITY slot of the verdict. An unsupplied day count is reported as such and is never compliance; where the Directive prescribes no minimum there is nothing to meet, and that too is said rather than left blank. Reductions do not compound ...

## Pinned sources

| Document | Consolidated | Fetched | SHA-256 (extract) |
|---|---|---|---|
| CELEX 02014L0024 | 2026-01-01 | 2026-08-19 | `6b6f2cb8a2b8fe17...` |
| CELEX 02014L0024 | 2026-01-01 | 2026-08-19 | `011ec7ed1f35ae08...` |
| CELEX 02014L0024 | 2026-01-01 | 2026-08-19 | `d9aa1bb576687bb4...` |
| CELEX 02014L0024 | 2026-01-01 | 2026-08-19 | `14d3f31ea1c05b3a...` |
| CELEX 02014L0024 | 2026-01-01 | 2026-08-19 | `cbcf709f96da0372...` |

[Side-by-side provision report](../reports/eu-procurement-time_limits.html){ .md-button }
[Source on GitHub](https://github.com/neurosymbolica/clausal-rules-as-code/blob/main/eu/procurement/time_limits){ .md-button }

## Provisions deferred, and what follows

??? info "subcentral_mutual_agreement_deadline"

    **Why:** Art 28(4) lets a sub-central contracting authority set the tender deadline by mutual agreement with the candidates invited, in place of the Art 28(2) minimum. The order excludes it because the profile carries neither the contracting-authority type nor the agreement input the branch needs.

    **Consequence for a user:** A sub-central authority that HAS reached such an agreement is governed by the agreed deadline, not by the minimum this domain reports. The verdict here is the Directive's floor for the general case, and a caller in that position must not read it as binding.

??? info "conduct_of_negotiation_dialogue_and_partnership"

    **Why:** Arts 29(2)-(4) and (6), 30(2)-(8) and 31(2)-(3) and (5)-(7) govern the CONDUCT and STRUCTURE of the competitive procedure with negotiation, the competitive dialogue and the innovation partnership: who may tender, the duty to negotiate, staging, confidentiality, prizes to dialogue participants, partnership phasing and its proportionality. Not one of them prescribes a day count. This domain's entire input surface is (procedure, stage, three circumstance flags, observed days) and its outputs are a minimum day count, a status and a conformity, so none of these provisions is reachable by it (ruling 2026-09-08).

    **Consequence for a user:** A conforming verdict from this domain says the day counts clear the Arts 27-31 floors. It says NOTHING about whether the negotiation or dialogue was lawfully conducted, staged or concluded; a caller must apply those provisions itself.

??? info "article_heading"

    **Why:** The five article titles carry no obligation: document structure, not operative law. Deferred rather than bound so that this domain reads the same way as every other in the campaign (ruling 2026-09-08).

    **Consequence for a user:** None. A heading states no rule, so nothing turns on it.

??? info "general_adequacy_and_extension_duties"

    **Why:** Art 47 imposes a standalone duty to set ADEQUATE time limits and to EXTEND them in named circumstances. That is a separate deontic determination from the minimum-days tables the order scopes here.

    **Consequence for a user:** THE SHARP EDGE. Meeting the minimum in Arts 27-31 does NOT discharge Art 47: a limit can clear the floor and still be inadequate to the complexity of the procurement, or require extension because site visits were needed or documents changed late. A `minimum_days_prescribed` verdict is a floor, never a finding that the limit set was lawful.

??? info "calendar_deadline_computation"

    **Why:** This domain reports a minimum DAY COUNT. Turning that count plus a dispatch date into a calendar deadline is governed by the periods-and-dates Regulation -- which day the period starts, how weekends and public holidays fall, when it expires -- and the order scopes it out.

    **Consequence for a user:** A caller must do the calendar arithmetic itself under Reg 1182/71. The commonest error this prevents is assuming the period starts on the dispatch date; it does not.

??? info "negotiated_without_publication"

    **Why:** Art 32 dispenses with the call for competition altogether, so there is no time-limit table to apply. Sibling determination.

    **Consequence for a user:** Where Art 32 is made out, no minimum from this domain applies. A caller must settle the Art 32 question first; asking this domain for a deadline presupposes a call for competition exists.

