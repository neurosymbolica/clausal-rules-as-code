# SIGNATURE — ch/swiss_fadp_s1_international_transfers

## Public query surface

The layout is fixed: kernel -> citations -> parameters -> swiss_fadp_s1_international_transfers -> queries -> fixtures -> package facade. There are seven test modes and a v2 manifest. File and module names are unchanged.

### Totality and determinism

- Every public predicate yields EXACTLY ONE solution for every term. The scorer counts solutions, so a duplicate is a refutation.
- Routes are disjoint clause heads with the ground result folded into the head (C17).
- There is no `!`, no `->` and no `*->`.
- Precedence between steps is expressed by mutually exclusive guards (state-of-stage predicates that are themselves single-solution), not by commitment.
- No statutory figures are imported or declared: the domain has no thresholds.

### Verdict STATUS atoms

These replace the placeholder `{ required, permitted, not_applicable }`.

The facade status is the result of `swiss_disclosure_abroad/3`:

- `permitted_by_adequacy_decision`
- `permitted_by_safeguards`
- `permitted_by_derogation`
- `disclosure_abroad_not_permitted`
- a status compound: `indeterminate([Key])`, `needs_legal_review(Reason, Context)` or `input_problems(Problems)`.

Other result atoms of the contract:

| Query | Result atoms |
|---|---|
| Art 16 query | `permitted_by_adequacy_decision`, `permitted_by_safeguards`, `no_adequacy_decision_or_safeguards` |
| EU query | `permitted_by_adequacy_decision`, `permitted_by_safeguards`, `no_adequacy_decision_or_safeguards` |
| Art 17(2) query | `information_of_commissioner_required`, `information_of_commissioner_not_required` |
| Comparison DIFFERENCE | `same`, `differs` |

Checklist item statuses come from formalize_lib vocabulary: `met`, `unmet(Reason)`, `unknown(Keys)`.

### Result constructors

These are exported and are never queries. They are exact functors and arities:

- `indeterminate/1`
- `needs_legal_review/2`
- `open_textured/2`
- `cross_reference_unresolved/2`
- `resolution/2`
- `inputs_relied_on/1`
- `provenance/2`
- `outside_fact/2`
- `attested/2`
- `attestation/4`
- `url/2`
- `document/2`
- `input_problems/1`
- `unknown_key/1`
- `wrong_type/1`
- `duplicate_key/1`

The bare atom `indeterminate` is never written.

## Profile keys

The profile is an attribute list `[attribute(Key, Value), ...]`. It is read only with `profile_get/3`, by presence first and then by value. Keys are bare atoms.

There are 27 keys. They appear here in root_exports / input_contract order. Kinds:

- **J** = judgement: `true`, `false` or `unsure`.
- **C** = crisp: `true` or `false`.
- **O** = outside fact: `attested(true|false, attestation(By, At, Reason, Evidence))`.

There are no numeric or date keys.

| # | Key | Kind | Read by queries |
|---|---|---|---|
| 1 | `federal_council_adequacy_listing_covers_disclosure` | O | A B C E |
| 2 | `international_treaty_ensures_suitable_protection` | J | A B C E |
| 3 | `contract_clauses_ensure_suitable_protection` | J | A B C E |
| 4 | `contract_clauses_notified_to_commissioner_beforehand` | C | A B C E |
| 5 | `specific_guarantees_ensure_suitable_protection` | J | A B C E |
| 6 | `specific_guarantees_notified_to_commissioner_beforehand` | C | A B C E |
| 7 | `standard_clauses_ensure_suitable_protection` | J | A B C E |
| 8 | `standard_clauses_approved_issued_or_recognised_by_commissioner` | O | A B C E |
| 9 | `binding_corporate_rules_ensure_suitable_protection` | J | A B C E |
| 10 | `binding_corporate_rules_approved_beforehand` | O | A B C E |
| 11 | `code_of_conduct_ensures_suitable_protection` | J | A B C E |
| 12 | `code_of_conduct_submitted_to_commissioner_for_approval_beforehand` | C | A B C E |
| 13 | `code_of_conduct_backed_by_binding_enforceable_commitment` | J | A B C E |
| 14 | `certification_ensures_suitable_protection` | J | A B C E |
| 15 | `certification_backed_by_binding_enforceable_commitment` | J | A B C E |
| 16 | `data_subject_explicitly_consented` | J | B |
| 17 | `disclosure_directly_connected_with_contract_with_data_subject` | J | B |
| 18 | `disclosure_directly_connected_with_contract_in_interest_of_data_subject` | J | B C |
| 19 | `disclosure_necessary_for_overriding_public_interest` | J | B C |
| 20 | `disclosure_necessary_for_legal_claims_before_court_or_foreign_authority` | J | B C |
| 21 | `disclosure_necessary_to_protect_life_or_physical_integrity_and_consent_not_obtainable` | J | B C |
| 22 | `data_made_generally_accessible_and_processing_not_expressly_prohibited` | J | B |
| 23 | `data_from_statutory_register_and_inspection_conditions_met` | J | B |
| 24 | `commissioner_requested_information_on_disclosure` | C | C |
| 25 | `commission_adequacy_decision_covers_transfer` | O | D E |
| 26 | `appropriate_safeguards_provided` | J | D E |
| 27 | `enforceable_rights_and_effective_remedies_available` | J | D E |

Query letters: A = `swiss_disclosure_under_article_16/3`, B = `swiss_disclosure_abroad/3`, C = `swiss_information_of_commissioner_on_request/3`, D = `eu_transfer_under_articles_45_and_46/3`, E = DIFFERENCE of `compare_swiss_eu_transfer_routes/5`.

## Citation-key atoms

These come from the canonical lexicon (`_lexicon/citations.yaml`). They are declared in citations.clausal. No shortened atom is ever written.

**DSG Art 16:**

- `ch_fadp_art_16_1`
- `ch_fadp_art_16_2`, `ch_fadp_art_16_2_a`, `ch_fadp_art_16_2_b`, `ch_fadp_art_16_2_c`, `ch_fadp_art_16_2_d`, `ch_fadp_art_16_2_e`
- `ch_fadp_art_16_3`

**DSG Art 17:**

- `ch_fadp_art_17_1`, `ch_fadp_art_17_1_a`
- `ch_fadp_art_17_1_b`, `ch_fadp_art_17_1_b_1`, `ch_fadp_art_17_1_b_2`
- `ch_fadp_art_17_1_c`, `ch_fadp_art_17_1_c_1`, `ch_fadp_art_17_1_c_2`
- `ch_fadp_art_17_1_d`, `ch_fadp_art_17_1_e`, `ch_fadp_art_17_1_f`
- `ch_fadp_art_17_2`

**DSV:**

- `ch_fadp_ord_art_8_1`, `ch_fadp_ord_annex_1`
- `ch_fadp_ord_art_12_1`, `ch_fadp_ord_art_12_2`, `ch_fadp_ord_art_12_3`

**EU GDPR:**

- `eu_reg_2016_679_art_45_1`
- `eu_reg_2016_679_art_46_1`

**Referral targets** (cross_reference_unresolved):

- `federal_council_adequacy_listing_statement`
- `commissioner_standard_clauses_statement`
- `swiss_binding_corporate_rules_approval_statement`
- `commission_adequacy_decision_statement`

Deferred and excluded units get NO citation atom in any answer. citations.clausal records them only as source-unit identifiers in a `deferred_unit/2` table, for provenance documentation.

## Public predicates

- `swiss_disclosure_under_article_16(Profile, Result, Citations)`: route under DSG Art 16 alone. Steps (1)-(7) of THE LIMBS. Cites DSG Art 16(1)-(3), DSV Art 8(1), Annex 1 and Art 12(1)-(3).
- `swiss_disclosure_abroad(Profile, Result, Citations)`: full cascade of finding, safeguards and derogation. Steps (8)-(15). Cites DSG Art 16, Art 17(1)(a)-(f), DSV Art 8(1), Annex 1 and Art 12.
- `swiss_information_of_commissioner_on_request(Profile, Result, Citations)`: obligation surfacing (#14), the ten-part duty. Steps (16)-(20). Cites `[cite(ch_fadp_art_17_1), cite(ch_fadp_art_17_2)]`.
- `eu_transfer_under_articles_45_and_46(Profile, Result, Citations)`: EU limb, refer-first. Steps (21)-(26). Cites GDPR Art 45(1) and 46(1).
- `compare_swiss_eu_transfer_routes(Profile, SwissResult, EuResult, Difference, ChangedBy)`: comparison (#5). Steps (27)-(30). ChangedBy is `[cite(ch_fadp_art_16_1), cite(ch_fadp_art_16_2), cite(eu_reg_2016_679_art_45_1), cite(eu_reg_2016_679_art_46_1)]` iff Difference is `differs`, else `[]`.
- `outside_facts_supplied(Profile, Facts)`: echoes the present outside facts as `outside_fact(Key, Attested)`, in root_exports order. Step (31).
- `swiss_fadp_s1_international_transfers_input_problems(Profile, Problems)`: THE INPUT CHECK. Problems is the bare list: duplicate_key or wrong_type per contract key in contract order, then unknown_key by first occurrence; or `[wrong_type(profile)]`.
- `decide_swiss_fadp_s1_international_transfers(Profile, Verdict)`: Verdict is `swiss_fadp_s1_international_transfers_verdict(Status, Citations)`, taken from `swiss_disclosure_abroad/3`. Cites DSG Arts 16 and 17(1), DSV Arts 8(1) and 12, and Annex 1.
- `swiss_fadp_s1_international_transfers_status(Profile, Status)`: the Status of the verdict above. Same citations.
- `swiss_fadp_s1_international_transfers_checklist(Profile, Checklist)`: justification (#7). Checklist is a list of `item(RequirementId, ItemStatus, cite(Key))`, one item per element:
  - `adequacy_finding` (`ch_fadp_art_16_1`);
  - the seven safeguard ways, `safeguard_international_treaty` ... `safeguard_certification`, each citing its letter or DSV Art 12 paragraph;
  - the eight derogation ways, `derogation_explicit_consent` ... `derogation_statutory_register`, each citing its letter or number.

  ItemStatus is `met`, `unmet(Reason)` or `unknown(Keys)`. Built with formalize_lib `eval_requirements/4` over the slice's `requirement/4`.
- `swiss_fadp_s1_international_transfers_what_if(Profile, Key, Value, Verdict)`: re-decides with one key overridden. Uses formalize_lib `profile_set/3`, then `decide_swiss_fadp_s1_international_transfers/2`. Same citations as decide.
- `swiss_fadp_s1_international_transfers_fixture(Name, Profile)` (fixtures module): named example profiles. Each one covers:
  - a route of each query, including adequacy, every safeguard way and every derogation way;
  - both Art 17(2) outcomes;
  - same and differs comparisons;
  - each status compound: missing key, BEHIND key, Swiss outside-fact referral, EU refer-first, unsure referral;
  - each input problem: unknown, wrong type, duplicate, not-a-list, unbound.

## Planned reuse

These become manifest `uses:`.

**formalize_lib**

- `profile_get/3`, `profile_has/2`, `profile_lacks/2`: profile access.
- `profile_set/3`: for what_if.
- `eval_requirements/4`: the checklist; no hand-rolled findall row-helper (R1).
- `item/3`, `unmet/1`, `unknown/1`, `attribute/2`: constructors.
- `memberd/2`, `not_member/2`: deterministic membership.

`check_tri/4` is used for judgement items in the checklist. It is not re-implemented (C15).

**validate_props** (tests)

- `run_props/1`
- `prop_totality/3`, `prop_determinism/3`
- `prop_citation_complete/3` (every final answer carries its fixed citation list)
- `prop_missing_key_coverage/3`

**kit.query_combinators** (tests and what_if checks)

- `diff_checklists/3`, `changed_deltas/2`: to show what a what_if changed.

**Not used, by reading (3):**

- the `country` module: destinations are never looked up;
- deadline, date_time and rolling_window: no dates;
- currency_vocab and vat_category;
- compliance_lib: the route cascade and the status rule do not fit the deny-overrides lattice.

## kernel.clausal — the shared floor

Only what the slice AND the queries or facade both need lives here:

- `profile_key/3`, `profile_key(Position, Key, Kind)`: the 27-row contract table, with Kind in `judgement`, `crisp`, `outside_fact`. Used by the input check, the PAIRS builder and root_exports ordering.
- `key_state(Profile, Key, State)`: State in `true`, `false`, `open_absent`, `open_unsure`. Reads `attested(V, _)` for outside facts. Single solution.
- `swiss_fadp_s1_international_transfers_input_problems/2`, with these helpers:
  - an attribute-list well-formedness test that never raises: partial or unbound lists and elements give `[wrong_type(profile)]`;
  - per-key occurrence count;
  - type test for each kind: an unbound value gives wrong_type;
  - non-atom keys give `unknown_key` as given.
- `inputs_relied_on_pairs(Profile, ReadKeys, ReferredOutsideFact, Pairs)`: THE PAIRS RULE. Present judgement and crisp keys, as `Key-Value`, in root_exports order, with the referred outside fact as `Key-absent` at its place.

## parameters.clausal

There are no statutory figures. It holds only the referral-citation table `referral_citation(Key, CitationAtom)` and the outside-fact table `outside_fact_reference(Key, CitationAtom, TargetAtom)`, both copied verbatim from the order. They are kept here because the queries module and the slice both read them.

## Slice: swiss_fadp_s1_international_transfers.clausal

This slice is self-contained for the transfer determination.

**Value facts owned.** These are tables, not numbers.

- `safeguard_way(WayId, Keys, Citation)`, seven rows:

  | WayId | Keys | Citation |
  |---|---|---|
  | `international_treaty` | [2] | `ch_fadp_art_16_2_a` |
  | `contract_clauses` | [3, 4] | `ch_fadp_art_16_2_b` |
  | `specific_guarantees` | [5, 6] | `ch_fadp_art_16_2_c` |
  | `standard_clauses` | [7, 8] | `ch_fadp_art_16_2_d` |
  | `binding_corporate_rules` | [9, 10] | `ch_fadp_art_16_2_e` |
  | `code_of_conduct` | [11, 12, 13] | `ch_fadp_ord_art_12_1` |
  | `certification` | [14, 15] | `ch_fadp_ord_art_12_1` |

- `derogation_way(WayId, Key, Citation)`, eight rows, keys 16-23, citing `ch_fadp_art_17_1_a` ... `ch_fadp_art_17_1_f`.
- `eu_safeguard_way(eu_appropriate_safeguards, [26, 27], eu_reg_2016_679_art_46_1)`.
- `listed_case_key/1`: keys 18-21 (DSG Art 17(2)).
- `result_citations(Query, ResultAtom, CitationList)`: the fixed per-answer lists of THE LIMBS (1)-(3), (8)-(11), (16)-(17) and (21)-(23), verbatim.

**Rules and requirements.**

- **Way state.** A way is HELD, FAILED or OPEN. A stage is HELD, FAILED or OPEN. Each is single-solution, with disjoint clauses.
- **SINGLE key of an OPEN way or part.**
- **Art 16 cascade.** Steps (1)-(3) final. Then (4) missing; (5) adequacy outside fact; (6) other Swiss outside fact of a live stage; (7) unsure.
- **Full cascade.** Steps (8)-(11) final. Live stages are the SAFEGUARDS, then the DEROGATIONS. Then (12)-(15).
- **Ten-part duty.** Steps (16)-(20). A FAILED part decides first.
- **EU cascade.** Steps (21)-(23). Then (24) refers first on an absent Commission decision, (25) missing, (26) unsure.
- **Comparison DIFFERENCE.** Computed by THE STATUS RULE over keys 1-15 and 25-27, without brute-force enumeration:
  - Each side abstracts to its adequacy fact plus one stage. The Swiss side is the OR of seven AND-ways. The EU side is one AND-way.
  - The two sides share no key, so the possible-outcome sets of each side are computed independently.
  - `same` holds when both sets are the same singleton. `differs` holds when the sets are disjoint.
  - MATTERS and BEHIND per key are derived from the per-side outcome sets with that key fixed true or false, with the remaining keys of its way and stage held at their states.
  - The precedence is: Commission decision; first non-BEHIND missing key in root_exports order; Swiss outside fact; unsure judgement (referral citation from parameters).
  - The test suite cross-checks this against a brute-force completion oracle on fixtures with few open keys.
- **`requirement(RequirementId, Profile, Status, Citation)`.** Argument order is the kit's, Id first. There is one clause per item, each with three exclusive clauses: met, `unmet(Reason)`, `unknown(Keys)`. It feeds the checklist.

**Verdict atoms owned.** All the result atoms listed above.

**Shared with kernel.** Only `key_state/3`, `profile_key/3` and the PAIRS builder. Nothing else leaves the slice.

## queries.clausal

- Puts THE INPUT CHECK first in front of each slice query. When Problems is non-empty, each answer position becomes `input_problems(Problems)` and the citations become `[]`.
- Exposes the seven contract predicates.
- Builds compare's SwissResult and EuResult by calling the two queries unchanged, with their PAIRS.
- Builds `outside_facts_supplied/2`.
- Each predicate has exactly one solution.

## Test plan

The seven modes, from the v2 manifest:

1. **Load.**
2. **Per-rule unit tests.** Every step (0)-(31).
3. **Fixtures golden.**
4. **Determinism and solution count.** `findall` plus `length(Solutions, 1)` for every query and fixture.
5. **Citation completeness.** Final answers carry their fixed list; not-final answers carry `[]`.
6. **Status precedence.** BEHIND, refer-first, Swiss outside fact after a missing key, unsure last.
7. **Input-check robustness.** Unbound or partial profile, non-atom key, unbound value, duplicates.

Every negative `fail` test is paired with a positive test over the same case.
