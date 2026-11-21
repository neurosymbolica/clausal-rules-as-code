# SIGNATURE — eu/dora_proportionality_and_simplified_framework

Shape family: **deontic**. Layout:

`kernel -> citations -> parameters -> dora_proportionality_and_simplified_framework -> queries -> fixtures -> package facade`

There is one determination slice, `dora_proportionality_and_simplified_framework.clausal`. It owns its value facts, derived arithmetic, rules, per-rule tests, checklist and verdict.

## Public query surface (summary)

Every public predicate takes PROFILE, an attribute list `[attribute(KEY, VALUE), ...]` read ONLY with `profile_get/3`, and yields EXACTLY ONE solution for every input term. There are no floats, strings or records. Booleans are the atoms `true` and `false`.

- `simplified_framework_qualification/3` is the **eligibility** query (#2).
- `simplified_framework_duties_complete/3` is the **compliance_check** query (#13).
- `dora_proportionality_and_simplified_framework_checklist/2` gives the **justification** (#7): one checklist item per step, each with `cite(...)`.

The determinism and totality claims are verified with `validate_props`.

No figure is imported. The two IORP thresholds are this order's own and are declared once in the slice.

## Verdict STATUS atoms (replacing the placeholders `required/permitted/not_applicable`)

### Final answers

**Qualification** (`simplified_framework_qualification/3`):
- `article_16_1_entity`
- `not_article_16_1_entity`
- `out_of_scope`
- `not_a_financial_entity`

**Duties required** (`simplified_framework_duties_required/3`):
- `required(DUTIES)`
- or a qualification final other than `article_16_1_entity`, passed on unchanged

**Duties complete** (`simplified_framework_duties_complete/3`):
- `complete`
- `incomplete`
- or a passed-on qualification final

**Duties outstanding** (`simplified_framework_duties_outstanding/3`):
- `none_outstanding`
- `outstanding(DUTIES)`
- or a passed-on qualification final

### Status compounds

Every status compound has CITATIONS `[]`.

- `indeterminate([KEY])` — exactly one key. The bare atom `indeterminate` is NEVER written.
- `needs_legal_review(open_textured(KEY, cite(CITATION)), [inputs_relied_on(PAIRS)])`, optionally followed by one unscored `provenance(CLAUSE, CITATIONS)`.
  - It is produced only by duties_complete and duties_outstanding.
  - PAIRS holds every `KEY-VALUE` present in PROFILE, in root_exports order, with values as given.
- `input_problems(PROBLEMS)` — PROBLEMS are `duplicate_key(KEY)`, `wrong_type(KEY)` and `unknown_key(KEY)`, in the scored order of THE INPUT CHECK.

### Result constructors

These are exported and never called as queries:
`required/1`, `outstanding/1`, `indeterminate/1`, `needs_legal_review/2`, `open_textured/2`, `inputs_relied_on/1`, `provenance/2`, `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`.

### Duty atoms (DUTY ORDER, scored)

These are result atoms only and never profile keys:

1. `simplified_ict_risk_management_framework`
2. `continuous_monitoring_of_ict_systems`
3. `ict_risk_impact_minimisation`
4. `detection_and_handling`
5. `key_third_party_dependencies`
6. `continuity_of_critical_or_important_functions`
7. `regular_testing`
8. `operational_conclusions_implemented`
9. `awareness_and_training_programmes`
10. `framework_documentation_and_review`
11. `continuous_improvement`
12. `review_report_to_authority`

### Facade checklist item status vocabulary

These atoms come from `formalize_lib`:
- `met`
- `unmet(Reason)`
- `unknown(Keys)`
- `inapplicable`, used for the report duty when the trigger is `false`

## Profile keys (root_exports / input_contract order — seventeen, exactly this order)

There is no numeric money key and no date key. The only number is a member count, an exact non-negative integer.

| # | Key | Type (typed input_contract) | Read when |
|---|---|---|---|
| 1 | `dora_entity_type` | `entity_type` — enum of the 29 atoms of the DORA order on scope and entity types | always |
| 2 | `investment_firm_is_small_and_non_interconnected` | fact: `true` / `false` (crisp) | type `investment_firm` |
| 3 | `iorp_pension_scheme_members_total` | `non_negative_integer` (members, exact count, 0 included, no upper bound) | type `institution_for_occupational_retirement_provision` |
| 4 | `exempted_from_dora_scope_by_member_state` | fact (crisp) | type `institution_exempted_pursuant_to_directive_2013_36` |
| 5 | `authority_requested_framework_review_report` | fact (crisp) — TRIGGER | duty 12 |
| 6 | `simplified_framework_in_place_and_maintained` | judgement: `true` / `false` / `unsure` | duty 1 |
| 7 | `ict_systems_continuously_monitored` | judgement | duty 2 |
| 8 | `ict_risk_impact_minimised_with_sound_systems` | judgement | duty 3 |
| 9 | `risk_sources_detected_and_incidents_handled` | judgement | duty 4 |
| 10 | `key_ict_third_party_dependencies_identified` | judgement | duty 5 |
| 11 | `continuity_of_critical_functions_ensured` | judgement | duty 6 |
| 12 | `plans_and_controls_tested_regularly` | judgement | duty 7 |
| 13 | `test_and_incident_conclusions_implemented` | judgement | duty 8 |
| 14 | `awareness_and_training_programmes_developed` | judgement | duty 9 |
| 15 | `simplified_framework_documented_and_reviewed` | judgement | duty 10 |
| 16 | `simplified_framework_continuously_improved` | judgement | duty 11 |
| 17 | `simplified_framework_review_report_submitted` | fact (crisp) | duty 12, when the trigger is `true` |

The 29 atoms of `dora_entity_type` are:
`credit_institution`, `institution_exempted_pursuant_to_directive_2013_36`, `payment_institution`, `exempted_payment_institution`, `account_information_service_provider`, `electronic_money_institution`, `exempted_electronic_money_institution`, `investment_firm`, `crypto_asset_service_provider`, `issuer_of_asset_referenced_tokens`, `central_securities_depository`, `central_counterparty`, `trading_venue`, `trade_repository`, `manager_of_alternative_investment_funds`, `management_company`, `data_reporting_service_provider`, `insurance_undertaking`, `reinsurance_undertaking`, `insurance_intermediary`, `reinsurance_intermediary`, `ancillary_insurance_intermediary`, `institution_for_occupational_retirement_provision`, `credit_rating_agency`, `administrator_of_critical_benchmarks`, `crowdfunding_service_provider`, `securitisation_repository`, `ict_third_party_service_provider`, `none_of_the_listed_types`.

Typing notes:
- `unsure` is `wrong_type` for the four crisp keys and for `dora_entity_type`.
- A float (15.0 included), a negative integer, an atom or a string is `wrong_type` for key 3.
- There is no attested wrapper (ruling 2 is not used). <<DNUM>>, <<DNUM>> and <<DNUM>> do not arise.

## Citation-key atoms (canonical lexicon, `_lexicon/citations.yaml`; never shortened)

These are the entries of citation_vocabulary. Each is used as `cite(KEY)`.

- `eu_reg_2022_2554_art_2_1` — Art 2(1), lead words
- `eu_reg_2022_2554_art_2_1_u` — Art 2(1)(u)
- `eu_reg_2022_2554_art_2_2` — Art 2(2)
- `eu_reg_2022_2554_art_2_3_c` — Art 2(3)(c)
- `eu_reg_2022_2554_art_2_4` — Art 2(4), first sentence
- `eu_reg_2022_2554_art_3_32` — Art 3(32)
- `eu_reg_2022_2554_art_3_34` — Art 3(34)
- `eu_reg_2022_2554_art_3_36` — Art 3(36)
- `eu_reg_2022_2554_art_3_39` — Art 3(39)
- `eu_reg_2022_2554_art_3_53` — Art 3(53)
- `eu_reg_2022_2554_art_4_1` — Art 4(1)
- `eu_reg_2022_2554_art_16_1` — Art 16(1), first subparagraph
- `eu_reg_2022_2554_art_16_1_a` to `eu_reg_2022_2554_art_16_1_h` — Art 16(1), second subparagraph, points (a) to (h)
- `eu_reg_2022_2554_art_16_2` — Art 16(2)

The fixed duty-answer citation list, used by `required/1`, `complete`, `incomplete` and `none_outstanding`, has eleven entries:
- Art 4(1);
- Art 16(1);
- Art 16(1)(a) to (h);
- Art 16(2).

## Public predicates (one line each)

- `simplified_framework_qualification(Profile, Result, Citations)`: Is the entity one of Art 16(1), first subparagraph? This is the ELIGIBILITY query (#2), following steps (0) to (9) of THE LIMBS. It cites Art 16(1), Art 2(1), (1)(u), (2), (3)(c), (4) and Art 3(32), (34), (36), (39), (53) per route.
- `simplified_framework_duties_required(Profile, Result, Citations)`: The applying duties in DUTY ORDER, following steps (R0), (R-Q), (R1), (R2). Cites Art 4(1), Art 16(1), Art 16(1)(a) to (h), Art 16(2).
- `simplified_framework_duties_complete(Profile, Result, Citations)`: Have all applying duties been performed? This is the COMPLIANCE CHECK (#13), following steps (S0), (S-Q), (S1) to (S4), with the <<DNUM>> behind-relation. Cites Art 4(1), Art 16(1), Art 16(1)(a) to (h), Art 16(2).
- `simplified_framework_duties_outstanding(Profile, Result, Citations)`: The outstanding duties in DUTY ORDER, following steps (M0), (M-Q), (M1) to (M3). Cites Art 4(1), Art 16(1) and each outstanding duty's citation.
- `dora_proportionality_and_simplified_framework_input_problems(Profile, Problems)`: THE INPUT CHECK against the typed input_contract. It never fails or raises, and it yields one solution. It cites the input contract.
- `decide_dora_proportionality_and_simplified_framework(Profile, dora_proportionality_and_simplified_framework_verdict(Status, Citations))`: The facade verdict. Status and Citations are exactly the Result and Citations of `simplified_framework_duties_complete/3`, the compliance check. Citations are as there.
- `dora_proportionality_and_simplified_framework_status(Profile, Status)`: Status alone, the same as decide. Citations are as there.
- `dora_proportionality_and_simplified_framework_checklist(Profile, Checklist)`: The JUSTIFICATION (#7). It is a list of `item(Id, Status, cite(KEY))` built with `formalize_lib:eval_requirements/4` over the slice's `requirement/4`. Every item carries `cite(...)`, met items included.
  - Items:
    - one `qualification` item, citing Art 16(1);
    - then one item per duty atom in DUTY ORDER, each citing its duty citation;
    - the report duty is `inapplicable` when the trigger is `false`.
  - An input-problem profile gives `[]`.
- `dora_proportionality_and_simplified_framework_what_if(Profile, Key, Value, Verdict)`: The decide verdict on Profile with Key set to Value. It uses `kit/query_combinators:what_if/5` with closure `decide_dora_proportionality_and_simplified_framework`. Citations are as decide.
- Fixtures: `dora_proportionality_and_simplified_framework_fixture(Name, Profile)` and `dora_proportionality_and_simplified_framework_fixture_expected(Name, Query, Result, Citations)`. They cover:
  - each of the nine qualification routes;
  - IORP members 15, 16, 99 and 100;
  - trigger `true` and `false`;
  - complete and incomplete;
  - outstanding with point (h) as two duties;
  - each <<DNUM>> ordering case;
  - unsure referral;
  - duplicate, wrong-type, unknown, unbound and non-list inputs.

## Planned reuse (manifest `uses:`)

- **`formalize_lib`**:
  - Profile access: `profile_get/3`, `profile_has/2`, `profile_lacks/2`, `profile_set/3`.
  - List helpers: `memberd/2`, `not_member/2`.
  - Checklist: `eval_requirements/4`, `item/3`, `unmet/1`, `unknown/1`.
  - Status checks: `check_true/4` and `check_tri/4`, for the per-duty met/unmet/unknown statuses of the checklist.
  - Defeaters: `not_defeated/3`, for the defeasible 'duty applies' default whose defeater is the trigger being `false`.
  - Vocabulary atoms: `met`, `applicable`, `inapplicable`.
- **`kit/query_combinators`**: `what_if/5`, used for the what_if facade.
- **`validate_props`**:
  - `run_props/1`, `prop_totality/3`, `prop_determinism/3`;
  - `prop_citation_complete/3`, `prop_boundary_coverage/2`, `prop_missing_key_coverage/3`;
  - `bad_citation/1`.
  - These run in the tests: exactly one solution per query, and every final answer cited from citation_vocabulary.
- **NOT used**:
  - `kit/compliance_lib` — its deny-overrides modality lattice cannot express the fixed step order (S1) to (S4), with <<DNUM>> and <<DNUM>>. The compliance check is the slice's own, and compliance_lib is not listed in `uses:`.
  - `deadline_lib`, `date_time`, `rolling_window` — no date is read.
  - `ratio_bps` and the other ratio helpers — there is no ratio.
  - `currency_vocab` and `country`.

## Idioms

- **Integer units.** The only numeric threshold is the integer member count, compared exactly.
- **Defeasible logic.** The defeasible default is 'each duty applies'. Its single defeater is that the report duty is defeated when the trigger is `false`. The defeater is guarded by `once/1` around a deterministic `memberd/2` test, with no cut, `->` or `*->`.
- **Open-textured judgement.** It is handed to the user as `needs_legal_review(open_textured(...))` and is never decided crisply.
- **Head-folded statuses.** Ground statuses are folded into the clause heads (C17), one clause per disjoint route.

---

## Slice: `dora_proportionality_and_simplified_framework.clausal`

### Owned VALUE facts

Each is declared once and read with `constant(Name)`; none is inlined.

- `:- constant_value(occupational_retirement_exclusion_maximum_members, 15).` — Art 2(3)(c): members `=<` 15 gives `out_of_scope`.
- `:- constant_value(small_occupational_retirement_members_exclusive_limit, 100).` — Art 3(53): members `<` 100 is small.
  - Derived: `>= 16` and `< 100` gives `article_16_1_entity`; `>= 100` gives `not_article_16_1_entity`.
- **Tables** (facts in this file):
  - `entity_type_atom/1` — the 29 atoms.
  - `financial_entity_type_without_rule/1` — the 22 other financial types. These are all the atoms except:
    - `ict_third_party_service_provider`, `none_of_the_listed_types`;
    - `exempted_payment_institution`, `exempted_electronic_money_institution`;
    - `investment_firm`, `institution_for_occupational_retirement_provision`, `institution_exempted_pursuant_to_directive_2013_36`.
  - `contract_key(Key, Type)` — the 17 keys in root_exports order, each with type `entity_type`, `fact`, `judgement` or `non_negative_integer`.
  - `duty(DutyAtom, ProfileKey, CitationKey, Applicability)`, for the 12 duties in DUTY ORDER:
    - `Applicability` is `always`, or `when_requested` for `review_report_to_authority`;
    - the CitationKey is also the referral citation of the judgement keys.
  - `duty_answer_citation/1` — the fixed eleven, in order.

### Rules / requirements

1. **Q-input.** Input problems come first in every query, by calling the kernel input check. A non-empty PROBLEMS gives `input_problems(PROBLEMS)` with citations `[]`.
2. **Q-type.** Qualification steps (1) to (9), as disjoint clauses keyed on `dora_entity_type`. The per-type key is read only inside its type's clause, which makes the <<DNUM>> 'behind entity type' relation hold by construction. The routes are:
   - type absent: `indeterminate([dora_entity_type])`;
   - `ict_third_party_service_provider`: `not_a_financial_entity`, citing Art 2(1)(u) and Art 2(2);
   - `none_of_the_listed_types`: `out_of_scope`, citing Art 2(1);
   - `exempted_payment_institution`: `article_16_1_entity`, citing Art 16(1) and Art 3(36);
   - `exempted_electronic_money_institution`: `article_16_1_entity`, citing Art 16(1) and Art 3(39);
   - `investment_firm`:
     - key absent: `indeterminate([investment_firm_is_small_and_non_interconnected])`;
     - `true`: `article_16_1_entity`, citing Art 16(1) and Art 3(34);
     - `false`: `not_article_16_1_entity`, citing Art 16(1);
   - `institution_for_occupational_retirement_provision`:
     - members absent: `indeterminate([iorp_pension_scheme_members_total])`;
     - members `=<` 15: `out_of_scope`, citing Art 2(3)(c);
     - members 16 to 99: `article_16_1_entity`, citing Art 16(1) and Art 3(53);
     - members `>=` 100: `not_article_16_1_entity`, citing Art 16(1);
   - `institution_exempted_pursuant_to_directive_2013_36`:
     - key absent: `indeterminate([exempted_from_dora_scope_by_member_state])`;
     - `true`: `out_of_scope`, citing Art 2(4);
     - `false`: `article_16_1_entity`, citing Art 16(1) and Art 3(32);
   - any of the other 22 types: `not_article_16_1_entity`, citing Art 16(1).
3. **Pass-through.** The three duty queries take the qualification. Any Result other than `article_16_1_entity` is returned unchanged, with its Citations.
4. **Duty applicability (defeasible).**
   - `duty_applies(Duty, Profile)` holds for `always` duties.
   - It holds for `review_report_to_authority` only when the trigger is `true`.
   - `duty_open(Duty, Profile)` holds for `always` duties, or for the report duty when the trigger is not `false`.
   - `duty_fails(Duty, Profile)` holds when the duty applies and its key is `false`.
5. **Required, steps (R1) and (R2).**
   - Trigger absent: `indeterminate([authority_requested_framework_review_report])`.
   - Otherwise `required(DUTIES)`, built as the ordered filter of the duty table by `duty_applies`:
     - eleven duties when the trigger is `false`;
     - twelve duties when the trigger is `true`.
6. **Complete, step (S1).** If some duty fails, the result is `incomplete`. This decides before any absent or unsure key is read.
7. **Complete, step (S2).** The first absent key that can change the answer and is not BEHIND another such key, in root_exports order.
   - A key can change the answer if it is either:
     - the key of an open duty; or
     - the trigger, while the report key is not `true`.
   - A key decides alone if it is either:
     - the key of an applying duty; or
     - the trigger, while the report key is `false`.
   - A key is behind another when that other key decides alone and it does not.
   - The result is `indeterminate([KEY])`.
8. **Complete, steps (S3) and (S4).**
   - (S3): the first unsure judgement key of an open duty gives `needs_legal_review(open_textured(KEY, cite(DutyCitation)), [inputs_relied_on(PAIRS)])`.
   - (S4): otherwise the result is `complete`.
9. **Outstanding, step (M1).** The first absent key in root_exports order that is either:
   - the key of an open duty; or
   - the trigger, while the report key is not `true`.

   A `false` key does not stop this step.
10. **Outstanding, step (M2).** The first unsure judgement of an open duty is referred.
11. **Outstanding, step (M3).** The failing duties in DUTY ORDER.
    - If there are none, the result is `none_outstanding`, with the fixed eleven citations.
    - Otherwise the result is `outstanding(LIST)`, citing Art 4(1), Art 16(1) and each listed duty's citation, deduplicated. Point (h) is written once even if both of its duties are outstanding.
12. **PAIRS.** Every present `KEY-VALUE`, in root_exports order, with values as given. These are the `inputs` of the firing referral row, which are all seventeen keys.
13. **requirement/4** (`requirement(RequirementId, Profile, Status, Citation)`) is for the checklist. It gives:
    - for `qualification`: `met` if `article_16_1_entity`, `unmet(Result)` for another final answer, and `unknown([Key])` if a key is missing;
    - for each duty atom: met / unmet / unknown via `check_true/4` or `check_tri/4` on its key, or `inapplicable` for the report duty when the trigger is `false`.

    It has exactly three mutually exclusive clauses per check, and no cut.
14. **Per-rule tests (in this slice).** These are each `test(Name)` paired with a positive test over the same case:
    - every qualification route;
    - IORP boundaries at 15, 16, 99 and 100;
    - required with eleven or twelve duties;
    - S1 deciding over absent and unsure keys;
    - each <<DNUM>> case: duty absent with the report key absent, so the duty key is named; report key `false` with the trigger absent, so the trigger is named; report key `true` with the trigger absent and all duties true, so the result is `complete`; trigger absent with no absent always-duty key and the report key absent, so the trigger is named;
    - unsure referral;
    - outstanding ordering with point (h) cited once;
    - each query's `findall` length is 1.

### Verdict atoms owned

The slice owns all the atoms of the 'Verdict STATUS atoms' section above:
- `article_16_1_entity`, `not_article_16_1_entity`, `out_of_scope`, `not_a_financial_entity`;
- `required/1`, `complete`, `incomplete`, `none_outstanding`, `outstanding/1`;
- the status compounds;
- the 12 duty atoms.

### Predicates SHARED with other modules (these, and only these, go in `kernel.clausal`)

- `dora_proportionality_and_simplified_framework_input_problems/2` — THE INPUT CHECK. It is shared by the slice (step 0 of every query), `queries.clausal`, the facade and the fixtures.
- `contract_key_order/1` — the 17-key list in root_exports order. It is used by the input check, PAIRS construction and the absent-key scans.
- `attribute_list/1` — a total, never-raising structural test: a proper list whose every element is a nonvar `attribute(_, _)`. It uses var/nonvar guards.

Everything else (values, tables, rules, checklist, verdicts) stays in the slice file.
