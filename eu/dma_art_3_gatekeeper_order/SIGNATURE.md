# SIGNATURE — eu/dma_art_3_gatekeeper_order

## Public query surface

`decide_dma_art_3_gatekeeper_order(Profile, dma_art_3_gatekeeper_order_verdict(Status, Citations))` and `dma_art_3_gatekeeper_order_status(Profile, Status)` answer the central determination of the domain. That determination is the answer of `designation_requirements_status/4`: are the conditions of the Art 3(1) duty ('shall be designated') met?

PROFILE is an attribute list `[attribute(Key, Value), ...]` over the seventeen keys below. It is read only with `profile_get/3` (presence first, through `profile_has/2` / `profile_lacks/2`, then value).

The six legal queries of the called contract are public under their contract names (no prefix), together with the prefixed input check.

Totality and determinism: every public predicate yields EXACTLY ONE solution for every term it is given. This includes non-lists, partial lists and unbound values, which are routed to the input check. Every disjunctive condition is computed as one classification, never one clause per witness.

No figure is imported from another domain. The five statutory thresholds are declared once, as `constant_value/2` facts in the slice file.

The order uses no dates, no clock and no floats.

## Verdict STATUS atoms (replacing `required / permitted / not_applicable`)

The facade STATUS (= the RESULT of `designation_requirements_status/4`) is exactly one of:

- `requirements_presumed_met`: all of the Art 3(2) thresholds are met and no accepted rebuttal is shown.
- `requirements_met`: the thresholds are not all met, and all three Art 3(1) judgements are true. This is not a designation.
- `requirements_not_met`
- one of the status compounds:
  - `indeterminate([Key])`
  - `needs_legal_review(open_textured(Key, cite(Citation)), [inputs_relied_on(Pairs)])`
  - `needs_legal_review(cross_reference_unresolved(cite(Citation), cite(Target)), [resolution(cite(Target), not_attempted), inputs_relied_on(Pairs)])`
  - `input_problems(Problems)`

Per-query RESULT atoms (contract):

| Query | Final atoms |
|---|---|
| impact_threshold_status/3 | `impact_threshold_met`, `impact_threshold_not_met` |
| gateway_threshold_status/3 | `gateway_threshold_met`, `gateway_threshold_not_met` |
| entrenchment_threshold_status/3 | `entrenchment_threshold_met`, `entrenchment_threshold_not_met` |
| presumption_status/3 | `gatekeeper_presumed`, `gatekeeper_not_presumed` |
| designation_requirements_status/4 | `requirements_presumed_met`, `requirements_met`, `requirements_not_met` |
| gatekeeper_status/4 | `designated_gatekeeper`, `not_designated_gatekeeper` |

Eligibility label (query type #2): `eligible` / `ineligible` / `undetermined`. The bare atom `indeterminate` is never written, because of the atom-shadowing trap with `indeterminate/1`.

Checklist item statuses are the formalize_lib vocabulary: `met`, `unmet(Reason)`, `unknown(Keys)`.

Result constructors are exported and never called as queries. They have exactly these arities: `indeterminate/1`, `needs_legal_review/2`, `open_textured/2`, `cross_reference_unresolved/2`, `resolution/2`, `inputs_relied_on/1`, `provenance/2`, `outside_fact/2`, `attested/2`, `attestation/4`, `url/2`, `document/2`, `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`.

## Profile keys (seventeen, in root_exports / input_contract order)

Money figures are whole euros, as the called contract requires; the keys are suffixed `_eur`. No dates are read.

| # | Key | Type | Source |
|---|---|---|---|
| 1 | `market_capitalisation_eur_most_recent_financial_year` | non-negative integer, whole euros | Art 3(2)(a) |
| 2 | `member_states_where_core_platform_service_provided` | non-negative integer, count | Art 3(2)(a) |
| 3 | `union_turnover_eur_most_recent_financial_year` | non-negative integer, whole euros | Art 3(2)(a) |
| 4 | `union_turnover_eur_second_most_recent_financial_year` | non-negative integer, whole euros | Art 3(2)(a) |
| 5 | `union_turnover_eur_third_most_recent_financial_year` | non-negative integer, whole euros | Art 3(2)(a) |
| 6 | `monthly_active_end_users_most_recent_financial_year` | non-negative integer, count | Art 3(2)(b),(c) |
| 7 | `monthly_active_end_users_second_most_recent_financial_year` | non-negative integer, count | Art 3(2)(c) |
| 8 | `monthly_active_end_users_third_most_recent_financial_year` | non-negative integer, count | Art 3(2)(c) |
| 9 | `yearly_active_business_users_most_recent_financial_year` | non-negative integer, count | Art 3(2)(b),(c) |
| 10 | `yearly_active_business_users_second_most_recent_financial_year` | non-negative integer, count | Art 3(2)(c) |
| 11 | `yearly_active_business_users_third_most_recent_financial_year` | non-negative integer, count | Art 3(2)(c) |
| 12 | `rebuttal_arguments_presented` | crisp: `true` / `false` | Art 3(5) |
| 13 | `rebuttal_accepted_by_commission` | outside fact: `attested(true or false, attestation(By, At, Reason, Evidence))` | Art 3(5) |
| 14 | `significant_impact_on_internal_market` | judgement: `true` / `false` / `unsure` | Art 3(1)(a) |
| 15 | `core_platform_service_is_important_gateway` | judgement: `true` / `false` / `unsure` | Art 3(1)(b) |
| 16 | `entrenched_and_durable_position` | judgement: `true` / `false` / `unsure` | Art 3(1)(c) |
| 17 | `designated_as_gatekeeper_for_core_platform_service` | outside fact: `attested(true or false, attestation(By, At, Reason, Evidence))` | Art 3(9) |

Evidence is `url(Url, RetrievedAt)`, `document(UploadIdentifier, Sha256)` or the atom `none`. The arguments of `attestation/4` are never inspected.

### `outside_facts:` declarations (manifest)

Both facts have kinds `[attested, fetched]` in precedence order, with fetcher `none`.

| Fact | Citation | Target |
|---|---|---|
| `rebuttal_accepted_by_commission` | `eu_reg_2022_1925_art_3_5` | `commission_rebuttal_conclusion` |
| `designated_as_gatekeeper_for_core_platform_service` | `eu_reg_2022_1925_art_3_9` | `commission_designation_decision` |

### `referrals:` rows (open_textured; PAIRS per THE PAIRS RULE)

| Judgement key | Citation |
|---|---|
| `significant_impact_on_internal_market` | `eu_reg_2022_1925_art_3_1_a` |
| `core_platform_service_is_important_gateway` | `eu_reg_2022_1925_art_3_1_b` |
| `entrenched_and_durable_position` | `eu_reg_2022_1925_art_3_1_c` |

## Citation-key atoms (canonical lexicon, citations.clausal)

These are canonical keys given by the brief; no shortened atom is invented.

- `eu_reg_2022_1925_art_3_1`: Art 3(1), chapeau (unit parag_003.001)
- `eu_reg_2022_1925_art_3_1_a`: Art 3(1)(a) (point_003.001_a)
- `eu_reg_2022_1925_art_3_1_b`: Art 3(1)(b) (point_003.001_b)
- `eu_reg_2022_1925_art_3_1_c`: Art 3(1)(c) (point_003.001_c)
- `eu_reg_2022_1925_art_3_2`: Art 3(2), chapeau (parag_003.002)
- `eu_reg_2022_1925_art_3_2_a`: Art 3(2)(a) (point_003.002_a)
- `eu_reg_2022_1925_art_3_2_b`: Art 3(2)(b) (point_003.002_b)
- `eu_reg_2022_1925_art_3_2_c`: Art 3(2)(c) (point_003.002_c)
- `eu_reg_2022_1925_art_3_5`: Art 3(5) (parag_003.005)
- `eu_reg_2022_1925_art_3_9`: Art 3(9) (parag_003.009)
- `commission_rebuttal_conclusion`: cross-reference target, the Commission conclusion under Art 3(5)
- `commission_designation_decision`: cross-reference target, the Commission designation decision under Art 3(9)

Each citation fact carries its pinned unit id and the source sha256 `d6af21a4f11c2b001b0486391fbd0813deba32305fb0d3865fbceccd45b827eb`.

## Public predicates (one line each)

The six contract queries:

- `impact_threshold_status(Profile, Result, Citations)`: is the Art 3(2)(a) threshold met (THE LIMBS steps 0 to 4). Cites `eu_reg_2022_1925_art_3_2_a`.
- `gateway_threshold_status(Profile, Result, Citations)`: are the Art 3(2)(b) thresholds met in the most recent financial year (steps 0, 5 to 7). Cites `eu_reg_2022_1925_art_3_2_b`.
- `entrenchment_threshold_status(Profile, Result, Citations)`: were the (b) thresholds met in each of the three years (steps 0, 8 to 10). Cites `eu_reg_2022_1925_art_3_2_c` and `eu_reg_2022_1925_art_3_2_b`.
- `presumption_status(Profile, Result, Citations)`: are all the Art 3(2) thresholds met (steps 0, 11 to 14). Cites `eu_reg_2022_1925_art_3_2_a`, `_b` and `_c` (only the failing points when not met).
- `designation_requirements_status(Profile, Result, Basis, Citations)`: are the requirements of Art 3(1) met, by the presumption with the Art 3(5) rebuttal, or by the three judgements (steps 0, 15 to 25). Cites `eu_reg_2022_1925_art_3_1`, `_3_1_a`, `_3_1_b`, `_3_1_c`, `_3_2` and `_3_5`, as the step states.
- `gatekeeper_status(Profile, Result, Basis, Citations)`: is a Commission designation under Art 3(9) stated for this service (steps 0, 26 to 28). Cites `eu_reg_2022_1925_art_3_9`.

The input check:

- `dma_art_3_gatekeeper_order_input_problems(Profile, Problems)`: THE INPUT CHECK. Problems is the BARE flat list of `duplicate_key/1`, `wrong_type/1` and `unknown_key/1` terms, or `[wrong_type(profile)]`. It is [] when the profile is well-formed, and is never wrapped. Cites the input_contract.

The facade (scaffold names kept):

- `decide_dma_art_3_gatekeeper_order(Profile, Verdict)`: Verdict is `dma_art_3_gatekeeper_order_verdict(Status, Citations)`, taking Status and Citations from `designation_requirements_status/4`. Cites Art 3(1), (2) and (5) as that query does.
- `dma_art_3_gatekeeper_order_status(Profile, Status)`: Status only, the same as argument 2 of `designation_requirements_status/4`. Cites Art 3(1).
- `dma_art_3_gatekeeper_order_checklist(Profile, Checklist)`: justification (query type #7). Checklist is the list built by `eval_requirements/4` over the six requirement ids, one `item(RequirementId, Status, cite(Key))` per question. It is [] when the input has problems. Cites per item.
- `dma_art_3_gatekeeper_order_eligibility(Profile, Eligibility, Checklist)`: eligibility (query type #2). Eligibility is `eligible`, `ineligible` or `undetermined`, derived from the designation_requirements item. Checklist is as above. Cites Art 3(1).
- `dma_art_3_gatekeeper_order_what_if(Profile, Key, Value, Verdict)`: sets `attribute(Key, Value)` with `profile_set/3` (replacing, never duplicating) and re-runs `decide_dma_art_3_gatekeeper_order/2`. Cites as for decide.

Fixtures:

- `dma_art_3_gatekeeper_order_fixture(Name, Profile)`: named profiles, for example `fixture_presumed_no_rebuttal`, `fixture_presumed_rebuttal_accepted`, `fixture_below_thresholds_all_judgements_true`, `fixture_member_states_two`, `fixture_turnover_boundary_equal` and `fixture_malformed_float_turnover`.
- `dma_art_3_gatekeeper_order_fixture_expected(Name, Query, Expected)`: the expected single answer for each fixture and query.

Checklist requirement ids, with the citation for each item:

| Requirement id | Item citation |
|---|---|
| `impact_threshold` | `cite(eu_reg_2022_1925_art_3_2_a)` |
| `gateway_threshold` | `cite(eu_reg_2022_1925_art_3_2_b)` |
| `entrenchment_threshold` | `cite(eu_reg_2022_1925_art_3_2_c)` |
| `presumption` | `cite(eu_reg_2022_1925_art_3_2)` |
| `designation_requirements` | `cite(eu_reg_2022_1925_art_3_1)` |
| `designation` | `cite(eu_reg_2022_1925_art_3_9)` |

Item status mapping:

- A met atom (or `requirements_presumed_met`, `requirements_met`, `designated_gatekeeper`, `gatekeeper_presumed`) gives `met`.
- A not-met atom (or `not_designated_gatekeeper`) gives `unmet(Atom)`.
- `indeterminate([Key])` gives `unknown([Key])`.
- A needs_legal_review answer gives `unknown([Key])`. Key is the unsure judgement key, or the absent outside-fact key.

## Planned reuse (manifest `uses:`)

From `formalize_lib`:

- `profile_get/3`, `profile_has/2` and `profile_lacks/2`: the only profile access.
- `profile_set/3`: what_if.
- `profile_keys/2`: the input check walk over present keys.
- `check_gte/5`: every figure-versus-threshold comparison, inclusive. It gives met, `unmet(Reason)` or `unknown([Key])`.
- `and_status/2`: the turnover branch, and the three-year user conjunction.
- `or_status/2`: turnover branch OR market branch.
- `eval_requirements/4`: the checklist built from `dma_art_3_gatekeeper_order_requirement/4`, as a closure with the RequirementId first.
- `has_unmet/1` and `has_unknown/1`: tests.
- `memberd/2` and `not_member/2`: the input check, for deterministic membership.
- Vocabulary: `item/3`, `unmet/1`, `unknown/1`, `attribute/2`.
- `check_tri/4` is deliberately NOT used. It merges absent with unsure, but THE LIMBS separate them (steps 23 and 24). A local four-way classifier is used instead (see the working notes (not published)).

From `validate_props`:

- `run_props/1`, `prop_totality/3`, `prop_determinism/3` (exactly one solution per query) and `prop_citation_complete/3`.
- `prop_boundary_coverage/2`: equal, minus one and plus one at each of the five thresholds.
- `prop_missing_key_coverage/3`
- `prop_monotone/5`: raising a figure never turns met into not_met.

From `kit.query_combinators`:

- `flip_scan/4`: boundary tests, with Probe as the closure `verdict_at(Key, Profile)`.
- `diff_checklists/3`: what_if justification tests.

Not used: `kit.deadline_lib`, `library(datetime)`, `kit.rolling_window` (no clock); `country` (the Member-State key is a count, Q10); `currency_vocab` (the currency is fixed as EUR by the key names); `kit.compliance_lib` (not served query types).

Family backbone (`_common`, deontic): none needed beyond formalize_lib. The deontic duty is expressed through the result atoms; there is no modality lattice.

## Package layout and what each file owns

The order of files is: kernel, then citations, parameters, the slice, queries, fixtures, and the package facade.

- `kernel.clausal`: the shared floor. It holds:
  - the contract key list `dma_art_3_gatekeeper_order_contract_key(Key, Type)` in input_contract order;
  - THE INPUT CHECK `dma_art_3_gatekeeper_order_input_problems/2`;
  - the attested outside-fact reader `dma_art_3_gatekeeper_order_outside_fact(Profile, Key, State)`, with State `attested_true(Attested)`, `attested_false(Attested)` or `absent`;
  - the set-like citation merge `dma_art_3_gatekeeper_order_merge_citations/3`.

  These are shared because the facade, queries and fixtures gate on the input check before any slice rule. A future sibling slice (Art 3(8)) would share all four.
- `citations.clausal`: the twelve citation-key facts above, with unit ids and the sha256.
- `parameters.clausal`: source pin metadata only (act 32022R1925, OJ L 265, 12.10.2022, sha256, corrigendum not read). It holds NO thresholds; those live in the slice.
- `dma_art_3_gatekeeper_order.clausal`: the single determination slice (below).
- `queries.clausal`: eligibility, checklist (`eval_requirements/4` over `dma_art_3_gatekeeper_order_requirement/4`) and what_if.
- `fixtures.clausal`: named profiles and expected answers.
- The facade module: decide, status, and the re-exports.

## Slice: dma_art_3_gatekeeper_order.clausal

### Statutory VALUE facts owned (declared once, read with `constant(Name)`)

- `:- constant_value(union_turnover_threshold_eur, 7500000000).` Art 3(2)(a), compared with `>=`.
- `:- constant_value(market_capitalisation_threshold_eur, 75000000000).` Art 3(2)(a), compared with `>=`.
- `:- constant_value(member_states_threshold_count, 3).` Art 3(2)(a), compared with `>=`.
- `:- constant_value(monthly_active_end_users_threshold_count, 45000000).` Art 3(2)(b),(c), compared with `>=`.
- `:- constant_value(yearly_active_business_users_threshold_count, 10000).` Art 3(2)(b),(c), compared with `>=`.

The slice also owns the root_exports key order lists used for first-missing-key selection:

- `impact_key_order`: market capitalisation, Member States, turnover most recent, second most recent, third most recent.
- `gateway_key_order`: end users most recent, business users most recent.
- `entrenchment_key_order`: the three end-user years, then the three business-user years.
- `judgement_key_order`: the three judgement keys.

### Internal classifiers (one solution each; disjoint clauses; no cut, no if-then-else)

- `figure_status(Profile, Key, ThresholdName, Status)`: wraps `check_gte/5`. Status is `met`, `unmet(below(Key))` or `unknown([Key])`.
- `turnover_branch(Profile, Branch)`: `and_status/2` over the three turnover statuses. Branch is `branch_holds`, `branch_fails` or `branch_open`, folded into the heads.
- `market_branch(Profile, Branch)`: the same three atoms, for the single market figure.
- `judgement_value(Profile, Key, Value)`: Value is `true`, `false`, `unsure` or `absent` (four disjoint clauses: `profile_lacks/2`, then three value clauses).
- `first_relevant_absent(KeyOrder, Relevance, Profile, Key)`: walks the list and yields the first absent key whose relevance test holds. It is deterministic.
- `presumption_route(Profile, Route)`: Route is one of:
  - `presumed`
  - `not_presumed`
  - `open(indeterminate([Key]))`

### Rules (THE LIMBS; first deciding step wins; each route one clause, ground outputs in the head)

Step 0, every query: if the input check gives non-empty Problems, then RESULT is `input_problems(Problems)`, CITATIONS is [], and BASIS is [] where the query has one.

impact_threshold_status, Art 3(2)(a):

- Step 1: Member States present and below 3 gives `impact_threshold_not_met`, citing `[cite(eu_reg_2022_1925_art_3_2_a)]`.
- Step 2: the turnover branch fails AND the market branch fails gives `impact_threshold_not_met`, with the same citation.
- Step 3: (the turnover branch holds OR the market branch holds) AND Member States is present gives `impact_threshold_met`, with the same citation.
- Step 4: otherwise `indeterminate([Key])` with CITATIONS []. Key is the first absent key, in impact order, that can still change the answer:
  - market capitalisation, unless the turnover branch holds;
  - Member States, always;
  - a turnover key, unless the turnover branch fails or the market branch holds.

gateway_threshold_status, Art 3(2)(b):

- Step 5: end users most recent below 45000000, OR business users most recent below 10000, gives `gateway_threshold_not_met`, citing `[cite(eu_reg_2022_1925_art_3_2_b)]`.
  - This is computed as one `and_status/2` result being unmet, not one clause per witness.
- Step 6: both present gives `gateway_threshold_met`, with the same citation.
- Step 7: otherwise `indeterminate([FirstAbsent])`, in gateway order.

entrenchment_threshold_status, Art 3(2)(c) with (b):

- Step 8: any of the six figures present and below its threshold gives `entrenchment_threshold_not_met`, citing `[cite(eu_reg_2022_1925_art_3_2_c), cite(eu_reg_2022_1925_art_3_2_b)]`.
- Step 9: all six present gives `entrenchment_threshold_met`, with the same citations.
- Step 10: otherwise `indeterminate([FirstAbsent])`, in entrenchment order.

presumption_status, Art 3(2). Here RA, RB and RC are the results of the three threshold queries.

- Step 11: any of RA, RB or RC is not-met gives `gatekeeper_not_presumed`. CITATIONS are the merged citations of the not-met queries, each atom once.
  - This is one clause over a computed list of not-met results, not one clause per witness.
- Step 12: otherwise, if RA is `indeterminate(Keys)`, that answer is copied, with CITATIONS [].
- Step 13: otherwise, if RC is `indeterminate(Keys)`, that answer is copied. RB's missing key is never copied.
- Step 14: otherwise `gatekeeper_presumed`, citing `[_3_2_a, _3_2_b, _3_2_c]` (as cite terms).

designation_requirements_status, Art 3(1) with (2) and (5). Here P is the presumption_status result.

While the presumption is unsettled:

- Step 15: P is indeterminate AND `rebuttal_arguments_presented` is true AND `rebuttal_accepted_by_commission` is attested true AND some judgement is false. This gives `requirements_not_met` with BASIS [], citing `[cite(eu_reg_2022_1925_art_3_1)]`.
- Step 16: P is indeterminate otherwise. P is copied, with BASIS [] and CITATIONS [].

Where the presumption applies (P is presumed; the judgement keys are not read):

- Step 17: arguments false, OR (arguments absent AND accepted attested false). This gives `requirements_presumed_met` with BASIS [], citing `[_3_1, _3_2]`.
- Step 18: arguments absent AND accepted not attested false gives `indeterminate([rebuttal_arguments_presented])`.
- Step 19: arguments true AND accepted attested false gives `requirements_presumed_met`, with BASIS `[outside_fact(rebuttal_accepted_by_commission, Attested)]`, citing `[_3_1, _3_2, _3_5]`.
- Step 20: arguments true AND accepted attested true gives `requirements_not_met`, with the same BASIS form, citing `[_3_1, _3_2, _3_5]`.
- Step 21: arguments true AND accepted absent gives
  `needs_legal_review(cross_reference_unresolved(cite(eu_reg_2022_1925_art_3_5), cite(commission_rebuttal_conclusion)), [resolution(cite(commission_rebuttal_conclusion), not_attempted), inputs_relied_on([rebuttal_accepted_by_commission-absent])])`, with BASIS [] and CITATIONS [].

Where the presumption does not apply (P is not_presumed; the rebuttal keys are not read):

- Step 22: any judgement false gives `requirements_not_met`, citing `[_3_1, _3_2]`.
- Step 23: any judgement absent gives `indeterminate([FirstAbsent])`, even if another judgement is unsure.
- Step 24: any judgement unsure gives `needs_legal_review(open_textured(FirstUnsure, cite(PointCitation)), [inputs_relied_on([significant_impact_on_internal_market-V1, core_platform_service_is_important_gateway-V2, entrenched_and_durable_position-V3])])`.
- Step 25: all three true gives `requirements_met`, citing `[_3_1_a, _3_1_b, _3_1_c]`.

gatekeeper_status, Art 3(9). Only `designated_as_gatekeeper_for_core_platform_service` is read.

- Step 26: attested true gives `designated_gatekeeper`, with BASIS `[outside_fact(designated_as_gatekeeper_for_core_platform_service, Attested)]`, citing `[cite(eu_reg_2022_1925_art_3_9)]`.
- Step 27: attested false gives `not_designated_gatekeeper`, with the same BASIS form and citation.
- Step 28: absent gives `needs_legal_review(cross_reference_unresolved(cite(eu_reg_2022_1925_art_3_9), cite(commission_designation_decision)), [resolution(cite(commission_designation_decision), not_attempted), inputs_relied_on([designated_as_gatekeeper_for_core_platform_service-absent])])`, with BASIS [] and CITATIONS [].

### Requirement predicate (for the checklist)

`dma_art_3_gatekeeper_order_requirement(RequirementId, Profile, Status, Citation)` has its arguments in the kit order. For each of the six ids it has exactly three disjoint clauses (met / unmet / unknown), mapping the query RESULT as described under Public predicates.

### Verdict atoms of this slice

All the final atoms listed in the per-query table, plus the status compounds.

### Predicates SHARED with kernel.clausal (and only these)

- `dma_art_3_gatekeeper_order_input_problems/2` (step 0)
- `dma_art_3_gatekeeper_order_contract_key/2`
- `dma_art_3_gatekeeper_order_outside_fact/3`
- `dma_art_3_gatekeeper_order_merge_citations/3`

Nothing else leaves the slice.

### Per-rule tests (in the slice's tests; seven test modes)

1. One positive and one paired negative test per step 0 to 28. Every `fail` test is paired with a positive test on the same case.
2. Boundary tests at each threshold: equal meets; one below does not meet.
3. Missing-key ordering, including Q12 relevance (for example, market capitalisation not named once the turnover branch holds).
4. Exactly-one-solution counts via `findall` + `length(Solutions, 1)` for every query and every fixture.
5. The input check:
   - duplicate keys (never also wrong_type);
   - a float turnover, a negative count, `unsure` on the crisp key;
   - a malformed attestation (three arguments);
   - a non-atom key, an unbound key or value, a partial list and a non-attribute element.
6. Outside facts: BASIS copies the attestation exactly; an absent fact gives a referral and is never in MISSING_KEYS.
7. Facade, checklist, eligibility and what_if agree with `designation_requirements_status/4`.

The checklist is the slice's verdict justification: every item carries `cite(...)`, met items included.
