# SIGNATURE — eu/dma_art_6_9_10_portability_and_business_data_order

## Public query surface

The three CALLED-CONTRACT queries, each `(PROFILE, RESULT, BASIS, CITATIONS)` and each yielding EXACTLY ONE solution:

- `article_6_application_status/4`
- `end_user_data_portability_status/4`
- `business_user_data_access_status/4`

The input check, also yielding exactly one solution:

- `dma_art_6_9_10_portability_and_business_data_order_input_problems/2`

The scaffold facade, built on the three queries:

- `decide_dma_art_6_9_10_portability_and_business_data_order/2`
- `dma_art_6_9_10_portability_and_business_data_order_status/2`
- `dma_art_6_9_10_portability_and_business_data_order_checklist/2`
- `dma_art_6_9_10_portability_and_business_data_order_what_if/4`
- the fixtures

Totality: every term given as PROFILE gets an answer from every query, by THE LIMBS steps 0 to 33.

Determinism: route clauses are pairwise disjoint by explicit guards. There is no cut, no `->`, no `*->`, no `once/1`, and constant results are folded into the clause heads (C17).

No figure is imported or declared. The pinned units contain no thresholds, periods or amounts.

## Verdict / RESULT atoms (replace the placeholders `required, permitted, not_applicable`)

**`article_6_application_status/4`:**

- `article_6_obligations_apply`
- `article_6_obligations_do_not_apply`

**`end_user_data_portability_status/4`:**

- `portability_duty_met`
- `portability_duty_not_met`
- `portability_not_requested`
- `data_outside_article_6_9`
- `article_6_obligations_do_not_apply`

**`business_user_data_access_status/4`:**

- `data_access_duty_met`
- `data_access_duty_not_met`
- `personal_data_access_duty_met`
- `personal_data_access_duty_not_met`
- `personal_data_access_not_required`
- `data_access_not_requested`
- `data_outside_article_6_10`
- `article_6_obligations_do_not_apply`

**Not-final status compounds**, in the RESULT position itself and never in a list:

- `indeterminate([KEY])`. Exactly one bare key. The bare atom `indeterminate` is NEVER written.
- `needs_legal_review(open_textured(KEY, cite(CITE)), [inputs_relied_on(PAIRS)])`
- `needs_legal_review(cross_reference_unresolved(cite(CITATION), cite(TARGET)), [resolution(cite(TARGET), not_attempted), inputs_relied_on(PAIRS)])`
- `input_problems(PROBLEMS)`

Every not-final answer has BASIS `[]` and CITATIONS `[]`.

**Facade STATUS atoms** (`..._status/2`, query type #2). Each is one scalar atom:

- `profile_rejected`: input problems are non-empty.
- `article_6_not_applicable`: designation attested false.
- `obligations_complied_with`: positive label of `assess/6`. No checklist item is unmet or unknown. This covers duty met, not requested, data outside, and not required.
- `obligation_not_complied_with`: negative label. Some item is unmet, that is portability, data access or personal-data access duty not met.
- `compliance_indeterminate`: indeterminate label. Some item is unknown (indeterminate or needs_legal_review) and none is unmet.

The three label atoms are passed as `labels(obligations_complied_with, compliance_indeterminate, obligation_not_complied_with)`.

## Profile keys

`attribute(KEY, VALUE)`, read ONLY with `profile_get/3`, presence first (`profile_has/2`, `profile_lacks/2`) and then by value. There are fifteen keys. This order is root_exports order and input_contract order:

| # | Key | Kind | Values |
|---|---|---|---|
| 1 | `designated_as_gatekeeper_for_core_platform_service` | outside fact (target `commission_designation_decision`, citation `eu_reg_2022_1925_art_6_1`) | `attested(true\|false, attestation(BY, AT, REASON, EVIDENCE))` |
| 2 | `portability_requested_by_end_user_or_authorised_third_party` | crisp | `true` / `false` |
| 3 | `data_provided_by_or_generated_through_activity_of_end_user` | judgement | `true` / `false` / `unsure` |
| 4 | `end_user_data_portability_free_of_charge` | crisp | `true` / `false` |
| 5 | `end_user_data_portability_effective` | judgement | tri-state |
| 6 | `end_user_data_portability_tools_provided` | judgement | tri-state |
| 7 | `end_user_data_continuous_real_time_access_provided` | judgement | tri-state |
| 8 | `data_access_requested_by_business_user_or_authorised_third_party` | crisp | `true` / `false` |
| 9 | `data_provided_or_generated_in_use_by_business_user_and_its_end_users` | judgement | tri-state |
| 10 | `requested_business_user_data_are_personal_data` | judgement | tri-state |
| 11 | `personal_data_directly_connected_with_end_user_use_of_business_user_offer` | judgement | tri-state |
| 12 | `end_users_opted_in_to_sharing_by_consent` | outside fact (target `digital_markets_business_user_data_sharing_consent_statement`, citation `eu_reg_2022_1925_art_6_10`) | `attested(true\|false, attestation(...))` |
| 13 | `business_user_data_access_free_of_charge` | crisp | `true` / `false` |
| 14 | `business_user_data_access_and_use_effective_and_high_quality` | judgement | tri-state |
| 15 | `business_user_data_access_continuous_and_real_time` | judgement | tri-state |

Notes on the keys:

- No numeric, money or date keys: none is needed.
- Attestation arguments must each be ground. EVIDENCE is `url(URL, RETRIEVED_AT)`, `document(UPLOAD_ID, SHA256)` or `none`. The order copies them and never reads them.

## Citation-key atoms (canonical lexicon; never shortened)

- `eu_reg_2022_1925_art_6_1`: Art 6(1), scope via designation.
- `eu_reg_2022_1925_art_6_9`: Art 6(9), end-user portability.
- `eu_reg_2022_1925_art_6_10`: Art 6(10), business-user data access.
- `eu_reg_2022_1925_art_2_25`: Art 2(25), personal data.
- `eu_reg_2022_1925_art_2_32`: Art 2(32), consent.
- Referral targets, which are not provisions:
  - `commission_designation_decision`
  - `digital_markets_business_user_data_sharing_consent_statement`

## Public predicates (one line each)

- `article_6_application_status(Profile, Result, Basis, Citations)`: whether Art 6 binds the service; reads only key 1. [Art 6(1)]
- `end_user_data_portability_status(Profile, Result, Basis, Citations)`: steps 0 and 4–14. [Art 6(1), 6(9)]
- `business_user_data_access_status(Profile, Result, Basis, Citations)`: steps 0 and 15–33. [Art 6(1), 6(10), 2(25), 2(32)]
- `dma_art_6_9_10_portability_and_business_data_order_input_problems(Profile, Problems)`: the BARE problem list, `[]` when well-formed. It is never wrapped in `input_problems/1`. [input_contract]
- `decide_dma_art_6_9_10_portability_and_business_data_order(Profile, dma_art_6_9_10_portability_and_business_data_order_verdict(Status, Citations))`: facade verdict.
  - Status is a facade STATUS atom.
  - Citations is the set-like union of the CITATIONS of the two duty queries.
  - On `profile_rejected`, Citations is `[]`.
  - On `article_6_not_applicable`, Citations is `[cite(eu_reg_2022_1925_art_6_1)]`.
  - One solution. [Art 6(1), 6(9), 6(10)]
- `dma_art_6_9_10_portability_and_business_data_order_status(Profile, Status)`: the scalar Status of the verdict. [as above]
- `dma_art_6_9_10_portability_and_business_data_order_checklist(Profile, Checklist)`: query type #7.
  - The checklist is `[item(end_user_data_portability, ItemStatus, cite(eu_reg_2022_1925_art_6_9)), item(business_user_data_access, ItemStatus, cite(eu_reg_2022_1925_art_6_10))]`, built by `eval_requirements/4` over the slice's `requirement/4`.
  - `met` for a final result that is not a 'not met' result.
  - `unmet(Result)` for a not-met result.
  - `unknown([Key])` for `indeterminate([Key])`.
  - `unknown([Key])` for a `needs_legal_review` naming its key, or naming the outside-fact key it refers on.
  - With input problems, the checklist is `[]`.
- `dma_art_6_9_10_portability_and_business_data_order_what_if(Profile, Key, Value, Status)`: sets `attribute(Key, Value)` with `profile_set/3` and returns the facade Status of the edited profile. One solution.
- `dma_art_6_9_10_portability_and_business_data_order_fixture(Name, Profile)`: one named profile per step of THE LIMBS, plus input-check profiles.
- `dma_art_6_9_10_portability_and_business_data_order_fixture_expected(Name, Query, Result, Basis, Citations)`: the expected answer for each fixture.

Result constructors are exported and never called as queries, with these exact arities:

- `indeterminate/1`, `needs_legal_review/2`, `open_textured/2`, `cross_reference_unresolved/2`, `resolution/2`, `inputs_relied_on/1`, `provenance/2`
- `outside_fact/2`, `attested/2`, `attestation/4`, `url/2`, `document/2`
- `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`
- `provenance/2` is never written.

## Planned reuse (manifest `uses:`)

**`formalize_lib`:**

- `profile_get/3`, `profile_has/2`, `profile_lacks/2`: the only profile access.
- `profile_set/3`: what_if.
- `memberd/2`, `not_member/2`: deterministic membership in the input check.
- `eval_requirements/4`, `assess/6`, `labels/3`, `item/3`, `unmet/1`, `unknown/1`, `has_unmet/1`, `has_unknown/1`: facade checklist and verdict. The requirement closure is `requirement`, called as `requirement(RequirementId, Profile, Status, Citation)` with the id FIRST.
- `check_tri/4` and `check_tri_neg/4` are NOT used. The judgement keys carry an explicit `unsure` value and a fixed step order that those combinators do not express. The step clauses compare views; they are not clones of check_tri, so C15 does not apply.

**`validate_props`** (tests): `run_props/1`, `prop_totality/3`, `prop_determinism/3`, `prop_citation_complete/3`, `prop_missing_key_coverage/3`, `bad_citation/1`.

**Not used:** `kit.query_combinators` `what_if/5`. It overrides a dict; the profile here is an attribute list, so `profile_set/3` is used. Also not used:

- `deadline_lib`, `rolling_window`, `date_time`: no time is counted.
- `compliance_lib`: this order's fixed limb order and BASIS rules are not deny-overrides norm lattices.
- `currency_vocab`, `vat_category`, `country`.

No `_common` family-backbone predicate fits the attested-outside-fact referral. It is authored in the kernel and noted in NOTES.md S3 as a kit candidate.

## kernel.clausal — the shared floor

This holds only what the slice, the queries, the fixtures and the facade all share:

- `contract_key/2` facts: `contract_key(Key, Kind)` in root_exports order. Kind is `outside_fact`, `crisp` or `judgement`. There are fifteen facts, in table order above.
- `contract_key_order/1`: the fifteen keys as one list.
- `outside_fact_entry/3`, `outside_fact_entry(Key, Citation, Target)`:
  - `designated_as_gatekeeper_for_core_platform_service` / `eu_reg_2022_1925_art_6_1` / `commission_designation_decision`
  - `end_users_opted_in_to_sharing_by_consent` / `eu_reg_2022_1925_art_6_10` / `digital_markets_business_user_data_sharing_consent_statement`
  - Declared kinds, in precedence order: attested, then fetched. The fetcher is `none` for both.
- **The input check** (`dma_art_6_9_10_portability_and_business_data_order_input_problems/2`, re-exported by the queries).
  - It never fails and never raises. Every test is guarded by `var/1` / `nonvar/1` / `is_list` / `ground/1` with disjoint clauses.
  - **Attribute-list test.** An unbound profile, a partial list, an unbound element, or any element that is not `attribute(_, _)` gives `[wrong_type(profile)]`.
  - **Per contract key, in order.** Occurrences are counted by `==` on the key.
    - More than one occurrence gives `duplicate_key(Key)`, and the values are not read.
    - Exactly one occurrence with a value of the wrong type gives `wrong_type(Key)`.
    - Crisp keys must be `true` or `false`; judgement keys `true`, `false` or `unsure`.
    - Outside facts must be `attested(B, attestation(A1, A2, A3, A4))` with B `true` or `false` and each Ai `ground`.
    - An unbound value is the wrong type.
  - **Unknown keys.** Then `unknown_key(Key)` once per non-contract key, by first occurrence, with identity by `==`.
    - A non-atom key is unknown.
    - An unbound key is reported as the SAME variable.
- `key_view/3`, `key_view(Profile, Key, View)`. View is `absent` or `given(Value)`. It is computed once by `profile_lacks/2` or by `profile_has/2` plus `profile_get/3`. It is called only after the input check is empty, so there is exactly one occurrence.
- `relied_pairs/4`, `relied_pairs(Profile, ReliedKeys, AbsentOutsideFact, Pairs)`.
  - It produces the `Key-Value` pairs of the PRESENT relied keys.
  - If AbsentOutsideFact is a key, `Key-absent` is merged at its root_exports place. If it is `none`, nothing is merged.
  - The order is root_exports order.
- `outside_fact_referral/3`, `outside_fact_referral(Key, Pairs, Result)`. It builds `needs_legal_review(cross_reference_unresolved(cite(Citation), cite(Target)), [resolution(cite(Target), not_attempted), inputs_relied_on(Pairs)])` from `outside_fact_entry/3`.
- `open_textured_referral/4`, `open_textured_referral(Key, Citation, Pairs, Result)`. It builds `needs_legal_review(open_textured(Key, cite(Citation)), [inputs_relied_on(Pairs)])`.

## citations.clausal

`citation(Key, Instrument, Unit, Text)` facts for the five provision keys. Each has:

- the pinned unit id and the verbatim text;
- the source sha256 `d6af21a4f11c2b001b0486391fbd0813deba32305fb0d3865fbceccd45b827eb`;
- `reference_target/2` facts for the two referral targets.

`citation_vocabulary/1` lists the five provision keys plus the two targets. Tests use it for `bad_citation/1`.

## parameters.clausal

It declares NO `constant_value`, with a comment stating why: the pinned units set no figure, no period and no amount. The no-hour-clock ruling has nothing to apply to.

## Slice: dma_art_6_9_10_portability_and_business_data_order.clausal

This slice is self-contained for Art 6(1), (9) and (10). It owns every value fact and every rule below.

### Value facts it owns

**Element keys:**

- `portability_element_keys/1`: `[end_user_data_portability_free_of_charge, end_user_data_portability_effective, end_user_data_portability_tools_provided, end_user_data_continuous_real_time_access_provided]`.
- `portability_judged_element_keys/1`: the last three.
- `data_access_element_keys/1`: `[business_user_data_access_free_of_charge, business_user_data_access_and_use_effective_and_high_quality, business_user_data_access_continuous_and_real_time]`.
- `data_access_judged_element_keys/1`: the last two.

**Relied-on keys:**

- `portability_relied_keys/1`: keys 2–7.
- `data_access_relied_keys/1`: keys 8–11 and 13–15.

**Fixed citations per final RESULT**, `result_citations(Result, Citations)`:

| Result | Citations |
|---|---|
| `article_6_obligations_apply`, `article_6_obligations_do_not_apply` | `[cite(eu_reg_2022_1925_art_6_1)]` |
| `portability_not_requested`, `data_outside_article_6_9`, `portability_duty_met`, `portability_duty_not_met` | `[cite(eu_reg_2022_1925_art_6_1), cite(eu_reg_2022_1925_art_6_9)]` |
| `data_access_not_requested`, `data_outside_article_6_10`, `data_access_duty_met`, `data_access_duty_not_met` | `[cite(eu_reg_2022_1925_art_6_1), cite(eu_reg_2022_1925_art_6_10)]` |
| `personal_data_access_not_required`, `personal_data_access_duty_met`, `personal_data_access_duty_not_met` | `[cite(eu_reg_2022_1925_art_6_1), cite(eu_reg_2022_1925_art_6_10), cite(eu_reg_2022_1925_art_2_25), cite(eu_reg_2022_1925_art_2_32)]` |

**Fixed BASIS keys per final RESULT**, `result_basis_keys(Result, Keys)`:

- `[designated_as_gatekeeper_for_core_platform_service]` for every final result, except:
- `[designated_as_gatekeeper_for_core_platform_service, end_users_opted_in_to_sharing_by_consent]` for `personal_data_access_duty_met` and `personal_data_access_duty_not_met`.

BASIS is built as `outside_fact(Key, Attested)`, with Attested exactly as supplied.

**Referral citations:**

- `eu_reg_2022_1925_art_6_9` for open-textured keys of the portability query.
- `eu_reg_2022_1925_art_6_10` for open-textured keys of the data-access query.

### Derived conditions (internal, three-clause where tri-valued)

**Portability:**

- `portability_element_fails`: some element key has `given(false)`.
- `portability_elements_hold`: all four have `given(true)`.
- `first_absent_portability_element(Key)`: the first absent element in root order.
- `first_unsure_portability_judgement(Key)`: the first unsure judged element in root order.

**Data access:**

- `data_access_element_fails`, `data_access_elements_hold`, `first_absent_data_access_element`, `first_unsure_data_access_judgement`: likewise.
- `personal_data_condition_fails`: key 11 is `given(false)`, or key 12 is attested false.
- `personal_data_conditions_hold`: key 11 is `given(true)` and key 12 is attested true.
- `paragraph_reaches_data`: key 1 attested true, key 8 `given(true)` and key 9 `given(true)`.

### Rules: article_6_application_status (Art 6(1))

| Step | Condition | RESULT |
|---|---|---|
| 0 | Problems non-empty | `input_problems(Problems)` |
| 1 | Key 1 attested true | `article_6_obligations_apply` |
| 2 | Key 1 attested false | `article_6_obligations_do_not_apply` |
| 3 | Key 1 absent | `outside_fact_referral` with pairs `[designated_as_gatekeeper_for_core_platform_service-absent]` |

### Rules: end_user_data_portability_status (Art 6(1), 6(9))

Each step's clause carries the negation of every earlier step as guards.

| Step | Condition | RESULT |
|---|---|---|
| 0 | Problems non-empty | `input_problems(Problems)` |
| 4 | Key 1 attested false | `article_6_obligations_do_not_apply` |
| 5 | Key 1 attested true, key 2 false | `portability_not_requested` |
| 6 | Key 1 attested true, key 2 true, key 3 false | `data_outside_article_6_9` |
| 7 | Key 1 attested true, key 2 true, key 3 true, elements hold | `portability_duty_met` |
| 8 | Key 1 attested true, key 2 true, key 3 true, an element fails | `portability_duty_not_met` |
| 9 | Key 2 absent | `indeterminate([portability_requested_by_end_user_or_authorised_third_party])` |
| 10 | Key 2 true, key 3 absent | `indeterminate([data_provided_by_or_generated_through_activity_of_end_user])` |
| 11 | Key 2 true, key 3 not false, no element fails, an element absent | `indeterminate([FirstAbsentElement])` |
| 12 | Key 1 absent | `outside_fact_referral`; pairs are the relied keys plus `designated...-absent` first |
| 13 | Key 3 unsure | `open_textured` on key 3, cite `eu_reg_2022_1925_art_6_9` |
| 14 | Otherwise | `open_textured` on the first unsure of keys 5–7, cite `eu_reg_2022_1925_art_6_9` |

In steps 13 and 14, PAIRS are the present relied keys, with no absent marker.

### Rules: business_user_data_access_status (Art 6(1), 6(10), 2(25), 2(32))

| Step | Condition | RESULT |
|---|---|---|
| 0 | Problems non-empty | `input_problems(Problems)` |
| 15 | Key 1 attested false | `article_6_obligations_do_not_apply` |
| 16 | Key 1 attested true, key 8 false | `data_access_not_requested` |
| 17 | Key 1 attested true, key 8 true, key 9 false | `data_outside_article_6_10` |
| 18 | Reaches the data, key 10 true, a personal-data condition fails | `personal_data_access_not_required` |
| 19 | Reaches the data, key 10 true, conditions hold, elements hold | `personal_data_access_duty_met` |
| 20 | Reaches the data, key 10 true, conditions hold, an element fails | `personal_data_access_duty_not_met` |
| 21 | Reaches the data, key 10 false, elements hold | `data_access_duty_met` |
| 22 | Reaches the data, key 10 false, an element fails | `data_access_duty_not_met` |
| 23 | Key 8 absent | `indeterminate([data_access_requested_by_business_user_or_authorised_third_party])` |
| 24 | Key 8 true, key 9 absent | `indeterminate([data_provided_or_generated_in_use_by_business_user_and_its_end_users])` |
| 25 | Key 8 true, key 9 not false, key 10 absent | `indeterminate([requested_business_user_data_are_personal_data])` |
| 26 | Key 8 true, key 9 not false, key 10 not false, key 12 not attested false, key 11 absent | `indeterminate([personal_data_directly_connected_with_end_user_use_of_business_user_offer])` |
| 27 | Key 8 true, key 9 not false, no element fails, not (key 10 true and a condition fails), an element absent | `indeterminate([FirstAbsentElement])` |
| 28 | Key 1 absent | `outside_fact_referral` on key 1 |
| 29 | Key 12 absent, key 10 not false, key 11 not false | `outside_fact_referral` on key 12 |
| 30 | Key 9 unsure | `open_textured` on key 9 |
| 31 | Key 10 unsure | `open_textured` on key 10 |
| 32 | Key 11 unsure, key 10 true, key 12 attested true | `open_textured` on key 11 |
| 33 | Otherwise | `open_textured` on the first unsure of keys 14–15 |

Notes on these steps:

- In step 26, the answer is the same whether or not key 12 or key 1 is absent.
- In steps 28 and 29, `KEY-absent` is merged at the key's root place: key 1 first, key 12 between keys 11 and 13.
- In steps 30 to 33, the citation is `eu_reg_2022_1925_art_6_10` and PAIRS are the present relied keys, with no absent marker.

### Slice requirement for the facade (requirement/4, id first)

- `requirement(end_user_data_portability, Profile, Status, cite(eu_reg_2022_1925_art_6_9))`
- `requirement(business_user_data_access, Profile, Status, cite(eu_reg_2022_1925_art_6_10))`

Each has exactly three disjoint clauses (met / unmet / unknown) over the query RESULT, as listed under the checklist predicate.

### Verdict atoms of the slice

Those listed for the two duty queries and for `article_6_application_status`.

### Shared with another slice

Nothing beyond the kernel predicates listed above. There is one slice. The kernel holds only what queries, fixtures and facade also read: the key table, the input check, key views, pairs and the referral builders.

## queries.clausal

It re-exports the three status queries and the input check under their contract names. It adds no logic.

## fixtures.clausal / tests

There is at least one fixture per limb step (0–33), plus:

- input-check edge cases: duplicate with equal values, unbound key, two distinct unbound keys, non-atom key, partial list, unbound value, attestation with a non-ground argument, non-attribute element;
- BASIS-stability pairs: consent absent versus attested false for step 18.

Every test counts solutions with `findall` and `length(_, 1)`. Each negative test is paired with a positive test over the same case. Property tests (`validate_props`) cover:

- totality and determinism over the generated tri-state product;
- citation completeness against `citation_vocabulary/1`;
- missing-key coverage: every key named in an `indeterminate/1` is a contract key and is never an outside fact.
