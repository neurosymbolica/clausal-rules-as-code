# SIGNATURE — eu/dora_rts_change_management

The package keeps the scaffold layout:

`kernel -> citations -> parameters -> dora_rts_change_management -> queries -> fixtures -> package facade`

The predicate prefix is `dora_rts_change_management_`. The shape family is deontic. Every public predicate yields EXACTLY ONE solution for every input term. There is no cut, `->` or `*->`. Selection among candidates is cut-free: the order builds the ordered candidate list with findall/3 and takes its head by unification, or uses a guarded `once/1` defeater. Ground verdicts are folded into clause heads (C17), with one clause per disjoint route.

## Verdict STATUS atoms

These replace the scaffold placeholders `required`, `permitted` and `not_applicable`.

**Final answers:**

- `required(Duties)`, a compound of arity 1;
- `complete`;
- `incomplete`;
- `none_outstanding`;
- `outstanding(Duties)`, a compound of arity 1;
- `simplified_framework_entity`.

**Status compounds (never final; CITATIONS `[]`):**

- `indeterminate([Key])`, with exactly one key. The bare atom `indeterminate` is never written.
- `needs_legal_review(open_textured(Key, cite(CitationKey)), [inputs_relied_on(Pairs)])`. The list may carry one more, unscored item: `provenance(Clause, Citations)`.
- `input_problems(Problems)`.

**Problem terms:** `duplicate_key(Key)`, `wrong_type(Key)` and `unknown_key(Key)`. The term `wrong_type(profile)` is used for a profile that is not an attribute list.

**Facade labels (query type #2):**

- `labels(complete, indeterminate, incomplete)`. The order reuses the order's own atoms, so it adds no new atom.
- `simplified_framework_entity` is returned as itself.

**Result constructors:** `required/1`, `outstanding/1`, `indeterminate/1`, `needs_legal_review/2`, `open_textured/2`, `inputs_relied_on/1`, `provenance/2`, `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`. These are exported and never called as queries.

`verdict_vocabulary` never pins `true` or `false`.

## Profile keys

PROFILE is `[attribute(Key, Value), ...]`. It is read ONLY with `profile_get/3`, by presence first and then by value. There are nineteen keys, in root_exports and input_contract order:

| # | Key | Type | Values |
|---|---|---|---|
| 1 | `financial_entity_is_article_16_1_entity` | fact (gate) | `true` \| `false` |
| 2 | `dora_entity_type` | entity_type | one of 29 atoms (below) |
| 3 | `significant_changes_made_to_ict_systems` | fact (trigger) | `true` \| `false` |
| 4 | `change_procedures_verify_whether_ict_security_requirements_met` | judgement | `true` \| `false` \| `unsure` |
| 5 | `change_procedures_ensure_independence_of_approving_functions` | judgement | tri |
| 6 | `change_roles_described_for_specifying_and_planning` | judgement | tri |
| 7 | `change_roles_described_for_designing_adequate_transition` | judgement | tri |
| 8 | `change_roles_described_for_controlled_testing_and_finalisation` | judgement | tri |
| 9 | `change_roles_described_for_effective_quality_assurance` | judgement | tri |
| 10 | `change_purpose_and_scope_documented_and_communicated` | judgement | tri |
| 11 | `change_implementation_timeline_documented_and_communicated` | judgement | tri |
| 12 | `change_expected_outcomes_documented_and_communicated` | judgement | tri |
| 13 | `change_fall_back_procedures_and_responsibilities_identified` | judgement | tri |
| 14 | `emergency_change_procedures_protocols_and_tools_provide_adequate_safeguards` | judgement | tri |
| 15 | `emergency_changes_documented_reevaluated_assessed_and_approved_after_implementation` | judgement | tri |
| 16 | `change_impact_on_ict_security_measures_identified_and_assessed` | judgement | tri |
| 17 | `ict_systems_submitted_to_stringent_testing_simulating_stressed_conditions` | judgement | tri |
| 18 | `clearing_members_clients_and_other_parties_involved_in_testing` | judgement | tri |
| 19 | `users_service_providers_and_other_parties_involved_in_testing` | judgement | tri |

The `dora_entity_type` atoms are:

> `credit_institution`, `institution_exempted_pursuant_to_directive_2013_36`, `payment_institution`, `exempted_payment_institution`, `account_information_service_provider`, `electronic_money_institution`, `exempted_electronic_money_institution`, `investment_firm`, `crypto_asset_service_provider`, `issuer_of_asset_referenced_tokens`, `central_securities_depository`, `central_counterparty`, `trading_venue`, `trade_repository`, `manager_of_alternative_investment_funds`, `management_company`, `data_reporting_service_provider`, `insurance_undertaking`, `reinsurance_undertaking`, `insurance_intermediary`, `reinsurance_intermediary`, `ancillary_insurance_intermediary`, `institution_for_occupational_retirement_provision`, `credit_rating_agency`, `administrator_of_critical_benchmarks`, `crowdfunding_service_provider`, `securitisation_repository`, `ict_third_party_service_provider`, `none_of_the_listed_types`.

Typing and value rules:

- In input_contract, `boolean` means the atoms `true` and `false`; `judgement` is `one_of boolean or unsure`.
- There are no numeric or date keys, so there are no unit suffixes and no `date(...)` terms.
- No value is a Python boolean or a quoted string.
- The duty atoms are result atoms only and are never profile keys.

## Citation-key atoms

These use the canonical scheme of `_lexicon/citations.yaml`.

| Key | Provision |
|---|---|
| `eu_reg_2024_1774_art_17_1` | Delegated Regulation (EU) 2024/1774, Art 17(1), the lead words and all its points |
| `eu_reg_2024_1774_art_17_2` | Delegated Regulation (EU) 2024/1774, Art 17(2), all three subparagraphs and their points |
| `eu_reg_2022_2554_art_16_1` | Regulation (EU) 2022/2554 (DORA), Art 16(1), first subparagraph |

No other citation atom is used, and no shortened form is ever invented. The fixed citations are `[cite(eu_reg_2024_1774_art_17_1), cite(eu_reg_2024_1774_art_17_2)]`.

## Public predicates

- `ict_change_management_duties_required(Profile, Result, Citations)`: which duties apply. It gives `required(Duties)` in duty order, or `simplified_framework_entity`, or a status compound. It reads the gate and the condition keys only, and never refers. Cites Art 17(1) and Art 17(2) as listed, or DORA Art 16(1).
- `ict_change_management_duties_complete(Profile, Result, Citations)`: query types #13 compliance_check and #2 eligibility. It gives `complete`, `incomplete` or `simplified_framework_entity`, or a status compound, by steps S0 to S4. Cites the fixed citations, or `eu_reg_2022_2554_art_16_1`.
- `ict_change_management_duties_outstanding(Profile, Result, Citations)`: gives `none_outstanding`, `outstanding(Duties)` or `simplified_framework_entity`, or a status compound, by steps M0 to M3. Cites the fixed citations, or the paragraph of each outstanding duty, or the gate key.
- `dora_rts_change_management_input_problems(Profile, Problems)`: THE INPUT CHECK. It checks the profile against the typed input_contract, yields one solution, and never fails or raises. Cites none.
- `decide_dora_rts_change_management(Profile, dora_rts_change_management_verdict(Status, Citations))`: the facade verdict for query type #13 compliance_check. It answers whether the entity's ICT change management, as stated, meets Article 17. `Status` and `Citations` are exactly the `Result` and `Citations` of `ict_change_management_duties_complete/3`. Cites Art 17(1), Art 17(2) and DORA Art 16(1).
- `dora_rts_change_management_status(Profile, Status)`: the eligibility verdict for query type #2. `Status` is the `Result` of `ict_change_management_duties_complete/3`: `complete` (positive), `incomplete` (negative), `indeterminate([Key])`, `needs_legal_review(...)`, `input_problems(...)` or `simplified_framework_entity`. Citations as above.
- `dora_rts_change_management_checklist(Profile, Checklist)`: query type #7 justification. `Checklist` is a list of `item(Duty, Status, cite(ParagraphKey))`, one item per OPEN duty, in duty order.
  - `Status` is `met`, `unmet(not_performed(Key))` or `unknown([Key])`.
  - An unsure key gives `unknown([Key])`, with its open-textured referral carried by the status predicate.
  - The list is built with `formalize_lib:eval_requirements/4` over the slice's `requirement/4`.
  - An input-problem profile or a gate-true profile gives `[]`.
  - Every item carries cite(...), met items included.
- `dora_rts_change_management_what_if(Profile, Key, Value, Status)`: the status after overriding one key. It is built on `query_combinators:what_if/5` with the closure `dora_rts_change_management_status`. Citations come from the status.
- Fixtures: `dora_rts_change_management_fixture(Name, Profile)` and `dora_rts_change_management_fixture_expected(Name, Query, Result, Citations)`. These are named cases for the seven test modes.

Totality and determinism claims:

- Every public predicate is total over any term, unbound included, and yields exactly one solution.
- Validation uses `validate_props:prop_totality/3`, `prop_determinism/3`, `prop_citation_complete/3` and `prop_missing_key_coverage/3`.
- Imported figures: none. The order has no statutory numbers, and `parameters.clausal` declares no `constant_value`.

## Planned reuse

These entries become manifest `uses:`.

- **`formalize_lib`:**
  - `profile_get/3`, `profile_has/2` and `profile_lacks/2` for all profile reads;
  - `check_tri/4` for each tri-state duty requirement (met / unmet / unknown);
  - `eval_requirements/4` and `assess/6` with `labels(complete, indeterminate, incomplete)` for the checklist (no hand-rolled findall item builder: R1);
  - `not_defeated/3` for the Art 16(1) defeater;
  - `memberd/2` for condition set membership;
  - `missing_keys/3`;
  - `attribute/2` and `item/3`.
- **`kit/query_combinators`:** `what_if/5` for `dora_rts_change_management_what_if/4`.
- **`validate_props`:** `run_props/1`, `prop_totality/3`, `prop_determinism/3`, `prop_citation_complete/3`, `prop_missing_key_coverage/3`, `bad_citation/1`.
- **`kit/compliance_lib`:** not used. It was considered for #13, but this order has no action/modality lattice: each duty is an obligation that is performed or not. #13 is therefore served by `ict_change_management_duties_complete/3`. This is noted in NOTES.md.
- **`deadline_lib`, `rolling_window`, `date_time`, `currency_vocab`, `country`, `vat_category`:** not used, because the order reads no date, money or country.
- **Family backbone (`_common`, deontic):** the shared open_textured referral row shape (`referral(Key, Citation, Inputs)`) and the input_contract typing, if `_common` advertises them. Otherwise they are kept local.

## Defeasible structure

- Article 17 duties are the default rule.
- DORA Art 16(1) is the defeater. Its guard is `once(profile_get(Profile, financial_entity_is_article_16_1_entity, true))`, and it is consulted through `not_defeated(article_17_duties, Profile, dora_rts_change_management_defeater)`. It is cut-free.
- The gate-true route and the gate-false route are disjoint clause heads.

## kernel.clausal — predicates shared across slices and layers

The kernel holds ONLY what the slice, the queries, the facade and the fixtures all call:

- `dora_rts_change_management_attribute_list(Profile)`: the profile is a proper list whose every element is `attribute(_, _)`. It is safe on unbound or partial input, and fails without raising.
- `dora_rts_change_management_key_occurrences(Profile, Key, Count)`: counts occurrences by `==` identity, so distinct variables count as distinct keys.
- `dora_rts_change_management_first_occurrence_keys(Profile, Keys)`: keys in order of first occurrence, deduplicated by `==`.
- `dora_rts_change_management_first_in_order(Candidates, KeyOrder, Key)`: cut-free; the first element of `KeyOrder` that is `memberd` of `Candidates`.
- `dora_rts_change_management_present_pairs(Profile, KeyOrder, Pairs)`: `Key-Value` pairs present, in key order. Used for PAIRS.

No domain law lives in the kernel.

## Slice: dora_rts_change_management.clausal

This slice is self-contained for Article 17 and its gate. It owns every value fact below.

### Value facts (owned here)

There are no numeric thresholds or periods. The tables are:

- **`dora_rts_change_management_key_order(Keys)`:** the nineteen keys in contract order.
- **`dora_rts_change_management_key_type(Key, Type)`:** `Type` is one of:
  - `fact` for the gate and the trigger;
  - `entity_type` for `dora_entity_type`;
  - `judgement` for the sixteen duty keys.
- **`dora_rts_change_management_entity_type_atom(Atom)`:** the 29 atoms.
- **`dora_rts_change_management_condition_key(Key)`:** `dora_entity_type` and `significant_changes_made_to_ict_systems`, in that order.
- **`dora_rts_change_management_duty(Order, Duty, Key, CitationKey, Conditions)`:** sixteen rows in duty order. Conditions:
  - rows 1–13: `[]`;
  - row 14: `[condition(dora_entity_type, [central_counterparty, central_securities_depository]), condition(significant_changes_made_to_ict_systems, [true])]`;
  - row 15: `[condition(dora_entity_type, [central_counterparty]), condition(significant_changes_made_to_ict_systems, [true])]`;
  - row 16: `[condition(dora_entity_type, [central_securities_depository]), condition(significant_changes_made_to_ict_systems, [true])]`.
- **`dora_rts_change_management_referral(Key, cite(CitationKey), Inputs)`:** one row per judgement key.
  - Keys 4–16 cite `eu_reg_2024_1774_art_17_1`; keys 17–19 cite `eu_reg_2024_1774_art_17_2`.
  - `Inputs` is all nineteen keys.
- **`dora_rts_change_management_fixed_citations([cite(eu_reg_2024_1774_art_17_1), cite(eu_reg_2024_1774_art_17_2)])`.**
- **`dora_rts_change_management_values_of(Key, Values)`:** `[true, false]` for the trigger, and the 29 atoms for the type. These are the completion domains.

### Rules / requirements

Each rule is one predicate with disjoint clauses and no cut.

- **R-input:** `dora_rts_change_management_input_problems/2`.
  1. Not an attribute list gives `[wrong_type(profile)]`.
  2. Otherwise, for each contract key in key order:
     - `duplicate_key(Key)` if its count is greater than 1, and no value is read;
     - else `wrong_type(Key)` if it is present with a value outside its type (an unbound value is wrong);
     - then `unknown_key(Key)` for each non-contract key in first-occurrence order (`==` identity), its value never checked.
- **Condition state:** `condition_state(Profile, condition(Key, Values), State)` with `State` in {`holds`, `fails`, `open`}:
  - `holds`: present and `memberd` of `Values`;
  - `fails`: present and not a member;
  - `open`: absent.
- **Duty state:**
  - `duty_applies(Profile, Order)`: every condition holds.
  - `duty_open(Profile, Order)`: no condition fails.
  - `duty_fails(Profile, Order)`: applies, and its key is `false`.
  - `duty_key_not_true(Profile, Order)`: the key is false, unsure or absent.
- **Gate:** route G1 (true), then G2 (absent), else continue. `dora_rts_change_management_defeater(article_17_duties, Profile)` holds when the gate is true.
- **Required (R1/R2):**
  - Candidates are the absent condition keys that carry a condition of an open duty. The first, in key order, gives `indeterminate([Key])`.
  - Otherwise `required(Duties)` holds the applying duties in order. Citations are the distinct paragraphs.
- **Complete (S1–S4):**
  - S1: some duty fails gives `incomplete` with the fixed citations.
  - S2: no open duty has a not-true key gives `complete` with the fixed citations.
  - S3 part 1 (a), `can_change(Profile, Key)` for a duty key: the key of open duty D is absent, and no other duty whose key is false has each of its conditions holding or among the conditions of D.
  - S3 part 1 (b), `can_change(Profile, Key)` for a condition key X: X is absent, and there exist values V and W from `values_of(X)`, and an open duty D, such that:
    - D's condition on X holds for V and not for W;
    - D's key is not true;
    - no duty E other than D whose key is false has, at once, a condition on X holding for W (or no condition on X) and each of its other conditions holding or among the conditions of D.
  - S3 part 3, `decides_alone(Profile, Key)`:
    - a duty key decides alone when its duty applies;
    - a condition key X decides alone when, for some V, a duty with a false key has its condition on X holding for V and all its other conditions holding.
  - S3 part 3, `behind(Profile, X, Y)`: Y decides alone and X does not.
  - S3 part 2 / part 4, the key named: the first candidate in key order among those that decide alone, if any; else the first candidate. The result is `indeterminate([Key])`.
  - S4: the first unsure judgement key that satisfies part 1 (a) gives `needs_legal_review(open_textured(Key, Citation), [inputs_relied_on(Pairs)])`. `Citation` comes from the referral row. `Pairs` holds every present pair in key order.
- **Outstanding (M1–M3):**
  - M1: the first absent key that is either the key of an open duty, or a condition key of an open duty whose key is not true, gives `indeterminate([Key])`.
  - M2: the first unsure key of an open duty gives `needs_legal_review(...)` as in S4.
  - M3: if no duty fails, `none_outstanding` with the fixed citations. Otherwise `outstanding(FailingDuties)` in duty order, cited by its distinct paragraphs.
- **`requirement(Duty, Profile, Status, Citation)`:** RequirementId first, for `eval_requirements/4`. It is `check_tri/4` on the duty key, with `Citation` `cite(ParagraphKey)`. Only open duties are passed as requirement ids.

### Verdict atoms of this slice

- `required/1`, `complete`, `incomplete`, `none_outstanding`, `outstanding/1`, `simplified_framework_entity`;
- statuses `indeterminate/1`, `needs_legal_review/2` (with `open_textured/2`, `inputs_relied_on/1`, `provenance/2`) and `input_problems/1`;
- problem terms `duplicate_key/1`, `wrong_type/1`, `unknown_key/1`.

The duty atoms are the sixteen of THE SIXTEEN DUTIES, in duty order:

1. `verification_of_ict_security_requirements`
2. `independence_of_change_approval_functions`
3. `roles_for_specifying_and_planning_changes`
4. `roles_for_designing_the_transition`
5. `roles_for_controlled_testing_and_finalisation`
6. `roles_for_quality_assurance`
7. `documentation_of_purpose_and_scope_of_change`
8. `documentation_of_implementation_timeline`
9. `documentation_of_expected_outcomes`
10. `fall_back_procedures_and_responsibilities`
11. `management_of_emergency_changes`
12. `review_of_emergency_changes_after_implementation`
13. `impact_of_change_on_ict_security_measures`
14. `stringent_testing_after_significant_changes`
15. `central_counterparty_involvement_of_parties_in_testing`
16. `central_securities_depository_involvement_of_parties_in_testing`

### Shared predicates

The slice uses only the kernel predicates listed above. It exports nothing to other slices, because there is no other determination slice.

### Per-rule tests (slice tests file)

Each positive test is paired with a negative test over the same case. Solutions are counted with `findall` plus `length(_, 1)`.

- **Gate:** true with duties false gives `simplified_framework_entity` and cites the DORA gate. Absent gives `indeterminate([financial_entity_is_article_16_1_entity])`.
- **Required:**
  - credit institution: thirteen duties, Art 17(1) only;
  - central counterparty with trigger true: duties 1–15;
  - central securities depository with trigger true: 1–14 and 16;
  - trigger false with type absent: thirteen duties;
  - type absent with trigger absent: names `dora_entity_type`;
  - central counterparty with trigger absent: names the trigger;
  - credit institution with trigger absent: thirteen duties.
- **Complete:**
  - one false key decides `incomplete` even with absent keys;
  - all true for a credit institution gives `complete`;
  - <<DNUM>>: with key 4 absent and the type absent, the order names key 4, unless a false Art 17(2) key with the trigger true makes the type decide alone;
  - an unsure key with nothing absent that matters gives `needs_legal_review` with the full PAIRS.
- **Outstanding:**
  - a false key with another key absent names the absent key;
  - all known gives `outstanding` in duty order with distinct paragraphs;
  - none failing gives `none_outstanding` with the fixed citations.
- **Input check:**
  - a duplicate contract key gives `duplicate_key` and never `wrong_type`;
  - `unsure` on the gate gives `wrong_type`;
  - an unknown variable key is reported as that same variable;
  - an unbound profile or a partial list gives `[wrong_type(profile)]`;
  - a number as a value gives `wrong_type`;
  - ordering: contract problems first, then unknown keys.
