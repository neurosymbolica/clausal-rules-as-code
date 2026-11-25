# SIGNATURE — eu/dora_penalties

## Public query surface

### Contract predicates

The five contract predicates plus the input check are the authoritative answers. Each yields EXACTLY ONE solution for any term.

- `administrative_penalty_rules_required(Profile, Result, Citations)`
- `minimum_powers(Profile, Powers)`
- `penalty_decision_safeguards(Profile, Safeguards)`
- `circumstances_to_take_into_account(Profile, Circumstances)`
- `criminal_penalty_liaison_duties(Profile, Duties)`
- `dora_penalties_input_problems(Profile, Problems)`

### Scaffold facade

The facade (eligibility, query type #2, with a cited checklist for justification, query type #7) is a thin view over `administrative_penalty_rules_required/3`:

- `decide_dora_penalties(Profile, dora_penalties_verdict(Status, Citations))`
- `dora_penalties_status(Profile, Status)`
- `dora_penalties_checklist(Profile, Checklist)`
- `dora_penalties_what_if(Profile, Key, Value, Status)`

The placeholder `{ required, permitted, not_applicable }` is replaced by:

- `Status in { required, not_required_criminal_penalties, missing_facts, rejected_profile }`

The bare atoms `indeterminate` and `input_problems` are NEVER written, because of atom-shadowing against `indeterminate/1` and `input_problems/1`.

### Totality and determinism

- Every route is a disjoint clause with the ground output folded into the head (C17).
- There is no `!`, no `->` and no `*->`.
- Duplicate keys are refused by the input check before any `profile_get/3`, so no query answers twice.

### Imported figures

No statutory figures are imported. The order has no numbers and no dates.

## Verdict and status atoms

### Final results

- `administrative_penalty_rules_required`: `required`, `not_required_criminal_penalties`.
- Lists of the other four contract predicates: `power/3`, `circumstance/2`, `properly_reasoned/1`, `right_of_appeal/1`, `receive_criminal_proceedings_information/1`, `provide_information_to_authorities_and_esas/1`.
- `[]` is a final answer for safeguards and duties. It is not a status.

### Power vocabulary

Power KIND:

- `supervisory`
- `penalty`
- `extension`

Power MEASURE, KIND supervisory:

- `access_to_documents_and_data`
- `on_site_inspections_and_investigations`
- `require_corrective_and_remedial_measures`

Power MEASURE, KIND penalty:

- `cease_and_desist_order`
- `cessation_of_practice_or_conduct`
- `measures_to_ensure_continued_compliance`
- `require_data_traffic_records`
- `public_notice`

Power MEASURE, KIND extension:

- `management_body_and_responsible_individuals`

### Circumstance atoms, in order

- `intent_or_negligence`
- `materiality_gravity_and_duration`
- `degree_of_responsibility`
- `financial_strength`
- `profits_gained_or_losses_avoided`
- `losses_for_third_parties`
- `cooperation_with_competent_authority`
- `previous_breaches`

### Status compounds

- `indeterminate([Key])`
- `needs_legal_review(open_textured(Key, cite(CitationKey)), [inputs_relied_on(Pairs)])`, optionally followed by one unscored `provenance(Clause, Citations)`
- `input_problems(Problems)`

### Input problem terms

- `duplicate_key(Key)`
- `wrong_type(Key)`
- `unknown_key(Key)`
- `wrong_type(profile)`

### Facade labels

`labels(required, missing_facts, not_required_criminal_penalties)`, plus `rejected_profile` when Problems is non-empty.

## Profile keys

The thirteen keys below are in root_exports and input_contract order. There are no numeric or date keys. Values are bare atoms, never Python booleans or strings.

Crisp facts, type `boolean` (the atoms `true` or `false`; `unsure` is `wrong_type`):

1. `breach_subject_to_criminal_penalties_under_national_law`
2. `member_state_chose_no_administrative_rules_for_criminally_penalised_breaches`
3. `member_state_laid_down_criminal_penalties_for_breaches`
4. `national_law_permits_requiring_data_traffic_records`
5. `measures_applied_to_legal_person`
6. `decision_imposes_art_50_2_c_measure`

Judgement keys, type `one_of(boolean, unsure)`. Each is the authority's appraisal as reported by the caller:

7. `breach_materiality_gravity_duration_relevant`
8. `degree_of_responsibility_relevant`
9. `financial_strength_relevant`
10. `profits_gained_or_losses_avoided_relevant`
11. `third_party_losses_relevant`
12. `cooperation_with_authority_relevant`
13. `previous_breaches_relevant`

No key gives entity type, Article 16(1) status or microenterprise status. The attested wrapper is not used.

## Citation-key atoms

These are canonical `_lexicon/citations.yaml` keys, always written as `cite(Key)`, and never shortened.

Art 50:

- `eu_reg_2022_2554_art_50_2_a`
- `eu_reg_2022_2554_art_50_2_b`
- `eu_reg_2022_2554_art_50_2_c`
- `eu_reg_2022_2554_art_50_3`
- `eu_reg_2022_2554_art_50_4_a`
- `eu_reg_2022_2554_art_50_4_b`
- `eu_reg_2022_2554_art_50_4_c`
- `eu_reg_2022_2554_art_50_4_d`
- `eu_reg_2022_2554_art_50_4_e`
- `eu_reg_2022_2554_art_50_5`
- `eu_reg_2022_2554_art_50_6`

Art 51:

- `eu_reg_2022_2554_art_51_2`
- `eu_reg_2022_2554_art_51_2_a`
- `eu_reg_2022_2554_art_51_2_b`
- `eu_reg_2022_2554_art_51_2_c`
- `eu_reg_2022_2554_art_51_2_d`
- `eu_reg_2022_2554_art_51_2_e`
- `eu_reg_2022_2554_art_51_2_f`
- `eu_reg_2022_2554_art_51_2_g`

Art 52:

- `eu_reg_2022_2554_art_52_1`
- `eu_reg_2022_2554_art_52_2`

The deferred units (Art 50(1), Art 51(1), the headings) are recorded in citations.clausal as deferred. They are never emitted in an answer.

## Public predicates

- `administrative_penalty_rules_required(Profile, Result, Citations)`: whether rules for administrative penalties and remedial measures are required. Result is `required` or `not_required_criminal_penalties`, else a status compound. Citations is a set of `cite/1`, `[]` for a status. Citations: Art 50(3), Art 52(1).
- `minimum_powers(Profile, Powers)`: one ordered list of `power(Kind, Measure, cite(Key))`, never empty, or a status compound. Citations: Art 50(2)(a)–(c), Art 50(4)(a)–(e), Art 50(5).
- `penalty_decision_safeguards(Profile, Safeguards)`: either `[]`, or `[properly_reasoned(cite(eu_reg_2022_2554_art_50_6)), right_of_appeal(cite(eu_reg_2022_2554_art_50_6))]`, or a status compound. Citation: Art 50(6).
- `circumstances_to_take_into_account(Profile, Circumstances)`: one ordered list of `circumstance(Atom, cite(Key))`, always headed by `intent_or_negligence`, or a status compound. Citations: Art 51(2) and points (a)–(g).
- `criminal_penalty_liaison_duties(Profile, Duties)`: either `[]`, or `[receive_criminal_proceedings_information(cite(eu_reg_2022_2554_art_52_2)), provide_information_to_authorities_and_esas(cite(eu_reg_2022_2554_art_52_2))]`, or a status compound. Citation: Art 52(2).
- `dora_penalties_input_problems(Profile, Problems)`: the typed input check. Never fails, never raises, one solution. Citation: the input contract (no article).
- `decide_dora_penalties(Profile, dora_penalties_verdict(Status, Citations))`: the facade verdict. Status and citations mirror `administrative_penalty_rules_required/3`, mapped to the facade labels. Citations: Art 50(3), Art 52(1).
- `dora_penalties_status(Profile, Status)`: the Status of `decide_dora_penalties/2` only. Citations: Art 50(3), Art 52(1).
- `dora_penalties_checklist(Profile, Checklist)`: a list of `item(RequirementId, Status, cite(Key))` produced by `formalize_lib` `assess/6` over `dora_penalties_requirement/4`. Every item carries `cite(...)`, met items included. It is `[]` when the profile has input problems. Citations: Art 50(3), Art 52(1).
- `dora_penalties_what_if(Profile, Key, Value, Status)`: replaces Key with `attribute(Key, Value)` via `profile_set/3`, then gives `dora_penalties_status/2` on the result. Citations: as the status.
- `dora_penalties_fixture(Name, Profile)` and `dora_penalties_fixture_expected(Name, Query, Answer)`: named fixture profiles with their expected answers. Citations: none (test data).

## Planned reuse (manifest `uses:`)

- `formalize_lib`:
  - `profile_get/3`, `profile_has/2`, `profile_lacks/2`, `profile_set/3`: profile access, by presence first and then by value;
  - `not_defeated/3`: the guarded `once/1` defeater for the Art 52(1) option;
  - `assess/6`, `decide_labeled/3`, `labels/3`, `item/3`, `unmet/1`, `unknown/1`, `attribute/2`: the facade checklist;
  - vocabulary atom `met`.
- `validate_props` (tests): `run_props/1`, `prop_totality/3`, `prop_determinism/3`, `prop_citation_complete/3`, `prop_missing_key_coverage/3`, `bad_citation/1`.
- `_common` deontic backbone: none beyond `formalize_lib`. No compliance_lib modality lattice is needed, because the answers are lists of required powers and duties, not a permit or deny verdict.
- Not used: currency, VAT, date and deadline libraries. There are no money or date keys.

## Slice: dora_penalties.clausal

The only determination slice. It is self-contained for Arts 50–52.

### Statutory VALUE facts owned here

These are ordered row tables, not constants. There are no numeric thresholds, so no `constant_value/2`.

- **Supervisory rows.** `dora_penalties_supervisory_power_row(Position, Measure, CitationKey)`, positions 1–3, Art 50(2)(a)–(c):
  - `access_to_documents_and_data`, `eu_reg_2022_2554_art_50_2_a`
  - `on_site_inspections_and_investigations`, `eu_reg_2022_2554_art_50_2_b`
  - `require_corrective_and_remedial_measures`, `eu_reg_2022_2554_art_50_2_c`
- **Penalty rows.** `dora_penalties_penalty_power_row(Position, Measure, CitationKey)`, positions 1–5, Art 50(4)(a)–(e):
  - `cease_and_desist_order`, `eu_reg_2022_2554_art_50_4_a`
  - `cessation_of_practice_or_conduct`, `eu_reg_2022_2554_art_50_4_b`
  - `measures_to_ensure_continued_compliance`, `eu_reg_2022_2554_art_50_4_c`
  - `require_data_traffic_records`, `eu_reg_2022_2554_art_50_4_d`. This row carries a guard flag: it is listed only when `national_law_permits_requiring_data_traffic_records` is true.
  - `public_notice`, `eu_reg_2022_2554_art_50_4_e`
- **Extension row.** `dora_penalties_extension_power_row(management_body_and_responsible_individuals, eu_reg_2022_2554_art_50_5)`.
- **Circumstance rows.** `dora_penalties_circumstance_row(Position, JudgementKey, CircumstanceAtom, CitationKey)`, positions 1–7, Art 51(2)(a)–(g), in the key order given in the profile section. The lead row `circumstance(intent_or_negligence, cite(eu_reg_2022_2554_art_51_2))` is a separate fact, always first.
- **Referral rows.** `dora_penalties_referral_row(JudgementKey, CitationKey, Inputs)`: one row per judgement key, citation Art 51(2)(x). Inputs is the list of all seven judgement keys.

### Rules and requirements (THE LIMBS, verbatim in effect)

A step fires only if every earlier step did not.

#### Administrative penalty rules (A)

| Step | Condition | Result | Citations |
|---|---|---|---|
| A0 | problems non-empty | `input_problems(P)` | `[]` |
| A1 | criminal-breach key absent | `indeterminate([breach_subject_to_criminal_penalties_under_national_law])` | `[]` |
| A2 | criminal-breach key false | `required` | `[cite(art_50_3)]` |
| A3 | criminal-breach key true, option-choice key absent | `indeterminate([member_state_chose_no_administrative_rules_for_criminally_penalised_breaches])` | `[]` |
| A4 | option-choice key true | `not_required_criminal_penalties` | `[cite(art_52_1)]` |
| A5 | option-choice key false | `required` | `[cite(art_50_3), cite(art_52_1)]` |

Citation keys are shortened in this table for layout only. Write them in full in code.

How the defeater is coded: the Art 50(3) duty `dora_penalties_rule(art_50_3_administrative_rules_duty)` is defeated by `dora_penalties_defeater(art_52_1_option, Profile)`. The defeater holds iff both option keys are true, and is evaluated under `once/1` inside `not_defeated/3`. A5 and A2 are the undefeated route; A4 is the defeated route.

#### Minimum powers (P)

- **P0**: problems non-empty gives `input_problems(P)`.
- **P1**: if neither option key is false:
  - criminal-breach key absent gives `indeterminate([breach_subject_to_criminal_penalties_under_national_law])`;
  - otherwise option-choice key absent gives `indeterminate([member_state_chose_no_administrative_rules_for_criminally_penalised_breaches])`.
- **P2**: option does not apply (either key false) and the data-traffic key is absent: `indeterminate([national_law_permits_requiring_data_traffic_records])`.
- **P3**: legal-person key absent: `indeterminate([measures_applied_to_legal_person])`.
- **P4**: the list, built in this order:
  1. the three supervisory rows;
  2. if the option does not apply, the penalty rows, with point (d) only when the data-traffic key is true;
  3. if the legal-person key is true, the extension row.

  The list is never empty.

#### Safeguards (D)

- D0: problems non-empty gives `input_problems(P)`.
- D1: `decision_imposes_art_50_2_c_measure` absent gives `indeterminate([decision_imposes_art_50_2_c_measure])`.
- D2: false gives `[]`.
- D3: true gives the two Art 50(6) terms.

#### Circumstances (C)

- **C0**: problems non-empty gives `input_problems(P)`.
- **C1**: the first absent judgement key in row order gives `indeterminate([Key])`. Absent keys are named before any unsure key is referred.
- **C2**: the first unsure judgement key gives `needs_legal_review(open_textured(Key, cite(ReferralCitation)), [inputs_relied_on(Pairs)])`. Pairs is every `Key-Value` pair of a judgement key present in Profile, in row order, with the value exactly as given.
- **C3**: the lead intent-or-negligence term, then one term for each true key, in row order.

#### Liaison duties (L)

- L0: problems non-empty gives `input_problems(P)`.
- L1: `member_state_laid_down_criminal_penalties_for_breaches` absent gives `indeterminate([member_state_laid_down_criminal_penalties_for_breaches])`.
- L2: false gives `[]`.
- L3: true gives the two Art 52(2) terms.

#### Facade requirement and checklist

The facade requirement is `dora_penalties_requirement(RequirementId, Profile, Status, Citation)`, with RequirementId first and three mutually exclusive clauses:

- `administrative_rules_duty_not_defeated`:
  - `met` if the criminal-breach key or the option-choice key is false;
  - `unmet(art_52_1_option_used)` if both are true;
  - `unknown([Key])` naming the key P1 would name.
- Citation: `cite(eu_reg_2022_2554_art_50_3)`.

The checklist is `assess(dora_penalties, [administrative_rules_duty_not_defeated], Profile, dora_penalties_requirement, labels(required, missing_facts, not_required_criminal_penalties), Result)`.

### Determinism discipline

- Each step is its own clause, with mutually exclusive guards written as presence and value tests. `profile_lacks/2` is used for absence. Negation of false is written as explicit enumeration of true or absent.
- List assembly is by ordered row traversal with guarded inclusion clauses.
- `findall/3` is used only to collect present judgement pairs for Pairs. It is not used for the R1 pattern over `item/3`.

### Verdict atoms of this slice

- `required`
- `not_required_criminal_penalties`
- facade labels: `missing_facts`, `rejected_profile`

### Shared with another place (kernel.clausal)

Kernel holds only what queries.clausal, the package facade and the tests also need:

- **Key-order table.** `dora_penalties_contract_key(Position, Key, Type)`, positions 1–13, Type `fact` or `judgement`. It is root_exports and input_contract order.
- **Value-type check.** `dora_penalties_value_has_type(Type, Value)`:
  - `fact` accepts the atoms `true` and `false`;
  - `judgement` accepts `true`, `false` and `unsure`;
  - an unbound or numeric Value fails the test, and the check reports `wrong_type(Key)`.
- **The input check.** `dora_penalties_input_problems(Profile, Problems)`:
  - a non-list, partial list, unbound Profile, unbound element or any non-`attribute/2` element gives `[wrong_type(profile)]`;
  - otherwise, per contract key in order: `duplicate_key(Key)` if it occurs more than once (values unread), else `wrong_type(Key)` if its value is outside its type;
  - then `unknown_key(Key)` once per non-contract key, in order of first occurrence, with identity by `==`. Distinct variables are distinct keys; numbers, strings and compounds are reported as given; an unknown key's value is never checked.
  - An absent key is never a problem.

Nothing else is shared. The row tables stay in dora_penalties.clausal.

## Tests (seven modes, v2 manifest)

1. **load**: the package loads.
2. **per-rule**: each limb route of A, P, D, C and L, including the precedence of `indeterminate` over `needs_legal_review`.
3. **checklist**: every item is cited.
4. **verdict**: facade labels.
5. **count and determinism**: `findall` plus `length(Answers, 1)` for every fixture and every input-problem shape.
6. **input check**:
   - duplicates, wrong types, unknown keys and the variable-key cases;
   - partial or unbound profile;
   - floats;
   - `unsure` on a fact key.
7. **what-if and fixtures**: flipping the option key changes the status between `required` and `not_required_criminal_penalties`.

Every `test(_, fail)` is paired with a positive test over the same case.
