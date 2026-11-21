# SIGNATURE — eu/data_protection/gdpr_accountability_security

## Public query surface (summary)

The called contract has five queries. Each yields **exactly one solution** for every input.

- `duty_status(PROFILE, DUTY, RESULT, BASIS, CITATIONS)`
- `non_binding_items(PROFILE, TOPIC, ITEMS)`
- `joint_controller_arrangement(PROFILE, RESULT, CITATIONS)`
- `joint_controller_arrangement_content(PROFILE, RESULT, BASIS, CITATIONS)`
- `gdpr_accountability_security_input_problems(PROFILE, PROBLEMS)`

The package facade adds:

- `decide_gdpr_accountability_security(PROFILE, gdpr_accountability_security_verdict(STATUS, CITATIONS))`
- `gdpr_accountability_security_status(PROFILE, STATUS)`
- `gdpr_accountability_security_checklist(PROFILE, CHECKLIST)`
- `gdpr_accountability_security_what_if(PROFILE, KEY, VALUE, VERDICT)`
- the fixtures

PROFILE is `[attribute(KEY, VALUE), ...]`, read only with `profile_get/3`.

Totality and determinism hold throughout. There are no cuts and no if-then-else; routes are disjoint clauses. Statuses are folded into clause heads (C17).

No numeric or date figures exist in this order. The only "values" are the duty table, the key order and type table, the referral targets and the two non-binding lists. All of them live in the slice.

## Verdict STATUS atoms (replace the scaffold placeholders)

The scaffold placeholders `required`, `permitted` and `not_applicable` are removed.

**Facade STATUS (query types #2 and #7):**

| Atom | Meaning | Eligibility role |
|---|---|---|
| `compliant` | every checklist item is met | eligible |
| `not_compliant` | some item is unmet | ineligible |
| `review_required` | no item is unmet, but some item is unknown | indeterminate |
| `input_problems(PROBLEMS)` | the profile is ill-formed | — |

The bare atom `indeterminate` is never written. It would shadow `indeterminate/1`.

**Called-contract RESULT atoms, by query:**

| Query | Final atoms |
|---|---|
| `duty_status` | `met`, `not_met` |
| `joint_controller_arrangement` | `not_joint_controllers`, `arrangement_not_required`, `arrangement_in_place`, `arrangement_missing` |
| `joint_controller_arrangement_content` | `content_requirements_met`, `content_requirements_not_met` |

**Status compounds** are never wrapped:

- `indeterminate([KEY])`, a list of exactly one key;
- `needs_legal_review(open_textured(KEY, cite(C)), [inputs_relied_on(PAIRS)])`;
- `needs_legal_review(cross_reference_unresolved(cite(C), cite(T)), [resolution(cite(T), not_attempted), inputs_relied_on(PAIRS)])`;
- `input_problems(PROBLEMS)`.

**DUTY atoms:** `accountability`, `controller_measures`, `data_protection_policies`, `data_protection_by_design`, `data_protection_by_default`, `security_of_processing`, `processing_on_instructions`.

**TOPIC atoms:** `accountability_principles`, `security_measures`.

## Profile keys

There are seventeen keys, in root_exports and input_contract order. None is numeric and none is a date.

| # | Key | Type | Optional? |
|---|---|---|---|
| 1 | `accountability_demonstrated` | outside fact | |
| 2 | `controller_measures_implemented_and_reviewed` | outside fact | |
| 3 | `data_protection_policies_implemented` | outside fact | |
| 4 | `by_design_measures_implemented` | outside fact | |
| 5 | `by_default_only_necessary_data_processed` | outside fact | |
| 6 | `security_level_appropriate_to_risk` | outside fact | |
| 7 | `authorised_persons_process_only_on_instructions` | outside fact | |
| 8 | `controllers_jointly_determine_purposes_and_means` | judgement: `true`/`false`/`unsure` | |
| 9 | `responsibilities_set_by_union_or_member_state_law` | crisp: `true`/`false` | |
| 10 | `arrangement_between_controllers_exists` | crisp | |
| 11 | `arrangement_reflects_roles_and_relationships` | outside fact | |
| 12 | `essence_of_arrangement_made_available` | crisp | |
| 13 | `by_default_amount_collected_limited_to_necessary` | outside fact | OPTIONAL |
| 14 | `by_default_extent_of_processing_limited_to_necessary` | outside fact | OPTIONAL |
| 15 | `by_default_storage_period_limited_to_necessary` | outside fact | OPTIONAL |
| 16 | `by_default_accessibility_limited_to_necessary` | outside fact | OPTIONAL |
| 17 | `by_default_not_accessible_to_indefinite_number_without_intervention` | crisp | OPTIONAL |

An outside-fact value is `attested(true|false, attestation(BY, AT, REASON, EVIDENCE))`, where EVIDENCE is `url(URL, RETRIEVED_AT)`, `document(UPLOAD_ID, SHA256)` or `none`. The type check does not inspect these four arguments.

## Citation-key atoms

These are the canonical lexicon atoms (`_lexicon/citations.yaml`). They are never shortened.

- **Art 5:** `eu_reg_2016_679_art_5_1_a`, `eu_reg_2016_679_art_5_1_b`, `eu_reg_2016_679_art_5_1_c`, `eu_reg_2016_679_art_5_1_d`, `eu_reg_2016_679_art_5_1_e`, `eu_reg_2016_679_art_5_1_f`, `eu_reg_2016_679_art_5_2`
- **Art 24:** `eu_reg_2016_679_art_24_1`, `eu_reg_2016_679_art_24_2`
- **Art 25:** `eu_reg_2016_679_art_25_1`, `eu_reg_2016_679_art_25_2`
- **Art 26:** `eu_reg_2016_679_art_26_1`, `eu_reg_2016_679_art_26_2`
- **Art 32:** `eu_reg_2016_679_art_32_1`, `eu_reg_2016_679_art_32_1_a`, `eu_reg_2016_679_art_32_1_b`, `eu_reg_2016_679_art_32_1_c`, `eu_reg_2016_679_art_32_1_d`, `eu_reg_2016_679_art_32_2`, `eu_reg_2016_679_art_32_4`

**Referral TARGET atoms.** These are planned names. Confirm each against the manifest `outside_facts:` block; the manifest wins.

| Outside fact | Target |
|---|---|
| `accountability_demonstrated` | `accountability_statement` |
| `controller_measures_implemented_and_reviewed` | `controller_measures_statement` |
| `data_protection_policies_implemented` | `data_protection_policies_statement` |
| `by_design_measures_implemented` | `by_design_measures_statement` |
| `by_default_only_necessary_data_processed` | `by_default_processing_statement` |
| `security_level_appropriate_to_risk` | `security_level_statement` |
| `authorised_persons_process_only_on_instructions` | `processing_on_instructions_statement` |
| `arrangement_reflects_roles_and_relationships` | `arrangement_roles_statement` (fixed by the interface) |
| `by_default_amount_collected_limited_to_necessary` | `by_default_amount_statement` (declared, never referred) |
| `by_default_extent_of_processing_limited_to_necessary` | `by_default_extent_statement` (declared, never referred) |
| `by_default_storage_period_limited_to_necessary` | `by_default_storage_statement` (declared, never referred) |
| `by_default_accessibility_limited_to_necessary` | `by_default_accessibility_statement` (declared, never referred) |

## Public predicates

**Called contract:**

- `gdpr_accountability_security_input_problems(Profile, Problems)`: the typed input check. It gives one solution for every term; `[]` when well-formed. Problems are `duplicate_key`, `wrong_type` (or `[wrong_type(profile)]`) and `unknown_key`. Citation: input_contract, no legal citation.
- `duty_status(Profile, Duty, Result, Basis, Citations)`: the steps are tried in order:
  - (0) input problems;
  - (B) for `data_protection_by_default` only, the first false one of keys 13 to 17;
  - (1) the duty's key absent gives a cross-reference referral;
  - (2) attested true gives `met`;
  - (3) attested false gives `not_met`.
  - Citations: Art 5(2), 24(1), 24(2), 25(1), 25(2), 32(1)+32(2) and 32(4), by duty.
- `non_binding_items(Profile, Topic, Items)`: a fixed ordered list of `non_binding_item(NAME, cite(K))`, or `input_problems(PROBLEMS)` alone. Citations: Art 5(1)(a) to (f), and Art 32(1)(a) to (d).
- `joint_controller_arrangement(Profile, Result, Citations)`: Art 26(1) steps (1) to (6) over J, L and A, with the `unsure` J referred as `open_textured`. Citation: `eu_reg_2016_679_art_26_1`.
- `joint_controller_arrangement_content(Profile, Result, Basis, Citations)`: Art 26(2) steps (1) to (5) over E and R. Citation: `eu_reg_2016_679_art_26_2`.

**Facade (scaffold names kept):**

- `decide_gdpr_accountability_security(Profile, gdpr_accountability_security_verdict(Status, Citations))`: works as follows:
  - if input problems are non-empty, it gives `input_problems(Problems)` with Citations `[]`;
  - otherwise it calls `assess/6` over the nine requirement ids, with `labels(compliant, review_required, not_compliant)`;
  - Citations are the set-like union of the item `cite`s.
  - Citations: all load-bearing articles above.
- `gdpr_accountability_security_status(Profile, Status)`: projects the Status from the verdict.
- `gdpr_accountability_security_checklist(Profile, Checklist)`: a list of nine `item(RequirementId, Status, cite(K))`. Status is `met`, `unmet(Reason)` or `unknown(Keys)`; met items are cited too.
- `gdpr_accountability_security_what_if(Profile, Key, Value, Verdict)`: overrides Key with Value and re-decides, through kit `what_if/5` with the closure `decide_gdpr_accountability_security`.

**Fixtures (in `fixtures`):**

- `gdpr_accountability_security_fixture(Name, Profile)`
- `gdpr_accountability_security_fixture_expected(Name, Status)`

The fixture names are:

- `all_statements_true_not_joint`
- `security_attested_false`
- `accountability_absent`
- `by_default_aspect_false_overrides_true`
- `by_default_crisp_false`
- `by_default_aspects_true_overall_absent`
- `joint_unsure_law_false_arrangement_present`
- `joint_true_law_absent`
- `joint_true_arrangement_missing`
- `content_essence_false`
- `content_roles_absent`
- `duplicate_and_unknown_keys`
- `not_an_attribute_list`

## Planned reuse (manifest `uses:`)

**`formalize_lib`:**

- `profile_get/3`, `profile_has/2`, `profile_lacks/2` for all profile reads, presence first;
- `assess/6`, `labels/3`, `item/3`, `unmet/1`, `unknown/1` for the facade checklist and verdict, through `requirement(RequirementId, Profile, Status, Citation)`;
- `not_member/2` and `memberd/2` in the input check.

**`kit.query_combinators`:** `what_if/5` for the what-if facade.

**`validate_props`** (tests):

- `run_props/1`
- `prop_totality/3`
- `prop_determinism/3`
- `prop_citation_complete/3`
- `prop_missing_key_coverage/3`
- `bad_citation/1`

**`list_item/3`** (built-in): not needed.

**No `_common` family-backbone predicate fits.** The attested outside-fact pattern is local and noted in NOTES.md as a kit candidate.

**Not used:**

- `check_tri/4`: the judgement's `unsure` must refer through `open_textured`, not become `unknown`;
- `deadline_lib`, `date_time`, `currency_vocab` and `country`: no dates, money or countries.

## Layout

`kernel -> citations -> parameters -> gdpr_accountability_security -> queries -> fixtures -> package facade`. All file and module names are unchanged.

- **`kernel.clausal`**: the shared floor. It holds nothing domain-specific, because there is only one slice; see the slice's SHARED line. It keeps the scaffold's re-exports of the result constructors:
  - `indeterminate/1`, `needs_legal_review/2`, `open_textured/2`, `cross_reference_unresolved/2`;
  - `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`;
  - `resolution/2`, `inputs_relied_on/1`, `provenance/2`, `outside_fact/2`;
  - `attested/2`, `attestation/4`, `url/2`, `document/2`, `non_binding_item/2`.
- **`citations.clausal`**: the citation vocabulary `gdpr_accountability_security_citation(Key)` for the twenty atoms above, used by `bad_citation/1` checks.
- **`parameters.clausal`**: no statutory figures. It states that the order has none.
- **`queries.clausal`**: thin public wrappers that delegate to the slice.
- **facade**: the four facade predicates.

## Slice: gdpr_accountability_security.clausal

### VALUE facts owned (all here, none in a shared constants file)

- `gdpr_accountability_security_key_order(Keys)`: the seventeen keys in order.
- `gdpr_accountability_security_key_type(Key, Type)`: Type is `outside_fact`, `judgement` or `crisp`, one fact per key.
- `gdpr_accountability_security_duty_key(Duty, Key)`: the seven rows of THE SEVEN DUTIES.
- `gdpr_accountability_security_duty_citations(Duty, Citations)`, one row per duty:
  - `accountability`: `[cite(eu_reg_2016_679_art_5_2)]`
  - `controller_measures`: `[cite(eu_reg_2016_679_art_24_1)]`
  - `data_protection_policies`: `[cite(eu_reg_2016_679_art_24_2)]`
  - `data_protection_by_design`: `[cite(eu_reg_2016_679_art_25_1)]`
  - `data_protection_by_default`: `[cite(eu_reg_2016_679_art_25_2)]`
  - `security_of_processing`: `[cite(eu_reg_2016_679_art_32_1), cite(eu_reg_2016_679_art_32_2)]`
  - `processing_on_instructions`: `[cite(eu_reg_2016_679_art_32_4)]`
- `gdpr_accountability_security_outside_fact_target(Key, Target)`: the twelve rows of the target table above.
- `gdpr_accountability_security_by_default_depth_keys(Keys)`: keys 13 to 17 in root_exports order.
- `gdpr_accountability_security_items(Topic, Items)`: the two fixed lists.
  - `accountability_principles`, one item per Art 5(1) point (a) to (f): `lawfulness_fairness_transparency`, `purpose_limitation`, `data_minimisation`, `accuracy`, `storage_limitation`, `integrity_and_confidentiality`.
  - `security_measures`, one item per Art 32(1) point (a) to (d): `pseudonymisation_and_encryption`, `confidentiality_integrity_availability_resilience`, `restore_availability_and_access`, `regular_testing_assessing_evaluating`.

### Rules / requirements

**R0 input check.** It goes through these stages, using only disjoint type-test clauses:

1. Shape: `[wrong_type(profile)]` when the profile is not a proper list of `attribute/2` terms. This covers an unbound profile, a partial list and an unbound or foreign element.
2. Per contract key, in order, using the occurrence count from `findall` over `memberd`:
   - a count of 2 or more gives `duplicate_key(K)`;
   - a count of 1 whose value fails the type gives `wrong_type(K)`, with an unbound value failing;
   - otherwise nothing.
3. Unknown keys: each first occurrence of a key (atom or not) outside the seventeen gives `unknown_key(K)` once.

The outside-fact type is `nonvar(V)`, `V = attested(B, A)`, `B` in {true, false}, and `A = attestation(_, _, _, _)`.

**R1 duty_status.** Each duty has its own clauses, one per route, with the head carrying the constant. The routes are:

- **(0)** problems are non-empty: `input_problems(P)`, `[]`, `[]`.
- **(B)**, by-default only: no problems, and a helper `gdpr_accountability_security_first_false_depth_key(Profile, Keys, Key)`:
  - the helper is recursive with disjoint clauses: the head is false, or the head is not false and the search goes on;
  - it gives `not_met` with `[cite(eu_reg_2016_679_art_25_2)]`;
  - BASIS is `[outside_fact(K, Attested)]` for an aspect key, and `[]` for the crisp key 17.
- **(1)** no problems, (B) found no false key, and the duty key is absent: cross-reference referral with `cite(FirstCitation)` and `cite(Target)`, and `inputs_relied_on([Key-absent])`. BASIS and CITATIONS are `[]`.
- **(2)** the key is attested true: `met`, `[outside_fact(Key, Attested)]`, the duty citations.
- **(3)** the key is attested false: `not_met`, `[outside_fact(Key, Attested)]`, the duty citations.

**R2 non_binding_items.** If problems are non-empty, ITEMS is `input_problems(P)`. Otherwise ITEMS is the fixed list for the topic.

**R3 joint_controller_arrangement**, over J, L and A:

| Step | Condition | Result | CITATIONS |
|---|---|---|---|
| (1) | J absent | `indeterminate([controllers_jointly_determine_purposes_and_means])` | `[]` |
| (2) | J false | `not_joint_controllers` | `[cite(eu_reg_2016_679_art_26_1)]` |
| (3) | J true or unsure, L absent | `indeterminate([responsibilities_set_by_union_or_member_state_law])` | `[]` |
| (4a) | L true, J unsure | `needs_legal_review(open_textured(controllers_jointly_determine_purposes_and_means, cite(eu_reg_2016_679_art_26_1)), [inputs_relied_on([controllers_jointly_determine_purposes_and_means-unsure])])` | `[]` |
| (4b) | L true, J true | `arrangement_not_required` | `[cite(eu_reg_2016_679_art_26_1)]` |
| (5) | L false, A absent | `indeterminate([arrangement_between_controllers_exists])` | `[]` |
| (6a) | L false, A present, J unsure | the same `open_textured` referral as (4a) | `[]` |
| (6b) | L false, J true, A true | `arrangement_in_place` | `[cite(eu_reg_2016_679_art_26_1)]` |
| (6c) | L false, J true, A false | `arrangement_missing` | `[cite(eu_reg_2016_679_art_26_1)]` |

**R4 joint_controller_arrangement_content**, over E and R:

| Step | Condition | Result | BASIS | CITATIONS |
|---|---|---|---|---|
| (1) | E false | `content_requirements_not_met` | `[]` | `[cite(eu_reg_2016_679_art_26_2)]` |
| (2) | E not false, R attested false | `content_requirements_not_met` | `[outside_fact(arrangement_reflects_roles_and_relationships, Attested)]` | `[cite(eu_reg_2016_679_art_26_2)]` |
| (3) | E absent, R not false | `indeterminate([essence_of_arrangement_made_available])` | `[]` | `[]` |
| (4) | E true, R absent | `needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_26_2), cite(arrangement_roles_statement)), [resolution(cite(arrangement_roles_statement), not_attempted), inputs_relied_on([arrangement_reflects_roles_and_relationships-absent])])` | `[]` | `[]` |
| (5) | E true, R attested true | `content_requirements_met` | `[outside_fact(...)]` | `[cite(eu_reg_2016_679_art_26_2)]` |

**R5 facade requirement rows.** `gdpr_accountability_security_requirement(RequirementId, Profile, Status, Citation)`, with RequirementId first. There are nine ids: the seven duty atoms, `joint_controller_arrangement` and `joint_controller_arrangement_content`.

Each row has exactly three disjoint clauses: met, unmet and unknown. They map as follows:

- **Duty rows:**
  - `met` gives `met`;
  - `not_met` gives `unmet(Duty)`;
  - any compound gives `unknown(Keys)`, where Keys is the MISSING_KEYS list, or the referred key.
- **Arrangement row:**
  - `not_joint_controllers`, `arrangement_not_required` and `arrangement_in_place` give `met`;
  - `arrangement_missing` gives `unmet(arrangement_missing)`;
  - a compound gives `unknown`.
- **Content row:**
  - when the arrangement result is `arrangement_in_place`, it maps the content result;
  - when it is `not_joint_controllers` or `arrangement_not_required`, it is `met`;
  - when it is `arrangement_missing`, it is `unmet(arrangement_missing)`;
  - otherwise it is `unknown` with the arrangement's key.

Citation is the first duty citation, `cite(eu_reg_2016_679_art_26_1)` or `cite(eu_reg_2016_679_art_26_2)`.

### Verdict atoms of this slice

- **Duty results:** `met`, `not_met`.
- **Arrangement results:** `not_joint_controllers`, `arrangement_not_required`, `arrangement_in_place`, `arrangement_missing`.
- **Content results:** `content_requirements_met`, `content_requirements_not_met`.
- **Status compounds:** `indeterminate/1`, `needs_legal_review/2`, `input_problems/1`.
- **Facade labels:** `compliant`, `review_required`, `not_compliant`.

### Per-rule tests (seven test modes)

1. **Unit:** each route of R1 to R4, including the step (B) first-false order and the Q7 case.
2. **Negative paired with positive:** each `fail` test has a positive twin over the same case.
3. **Counting:** `findall` length is 1 for every query, over every fixture and every malformed profile.
4. **Input check:**
   - duplicates are never also `wrong_type`;
   - a non-atom key gives `unknown_key`;
   - an unbound profile or value is handled;
   - repeated unknown keys are reported once.
5. **Citations:** every cite is in the vocabulary (`prop_citation_complete/3`, `bad_citation/1`).
6. **Totality and determinism:** over generated profiles, using validate_props.
7. **<<DNUM>> invariance:** adding true or absent depth keys changes no answer. This is a monotonicity check over keys 13 to 17.

### SHARED with another slice (belongs in kernel.clausal)

None. This is the only determination slice. The input check, the outside-fact shape test and the PAIRS construction stay in this slice, so that it is self-contained. Only the result-constructor re-exports sit in the kernel.
