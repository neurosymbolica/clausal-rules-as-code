# SIGNATURE — eu/dora_ict_incident_management_process

## Public query surface (summary)

The package exposes the three called-contract queries, the input check and the scaffold facade.

- **Three called-contract queries.** Each takes `PROFILE` and returns `RESULT` and `CITATIONS`.
- **Input check:** `dora_ict_incident_management_process_input_problems/2`.
- **Facade:** `decide_dora_ict_incident_management_process(PROFILE, dora_ict_incident_management_process_verdict(STATUS, CITATIONS))`, `dora_ict_incident_management_process_status(PROFILE, STATUS)`, `dora_ict_incident_management_process_checklist/2`, `dora_ict_incident_management_process_what_if/4` and fixtures.

The facade's STATUS replaces the scaffold placeholder `{ required, permitted, not_applicable }`. STATUS is the principal functor name of the RESULT of `ict_incident_management_process_duties_complete`.

**Totality and determinism.** Every public predicate is total and deterministic: it gives EXACTLY ONE solution for every term, including an unbound PROFILE, a partial list, bad elements and unbound keys or values. It never fails and never raises.

**Imported figures.** This order has none. No threshold, period or figure is declared, so `parameters.clausal` keeps no `constant_value/2` for this order. It records only that RULINGS ruling 6 is not engaged.

**Data types.** No public predicate returns a float, a string or a record.

## 1. Verdict STATUS atoms

These replace the scaffold placeholders.

**Final answers:**

| Answer | Arity | Query |
|---|---|---|
| `complete` | atom | `_complete` |
| `incomplete` | atom | `_complete` |
| `none_outstanding` | atom | `_outstanding` |
| `required(DUTIES)` | arity 1 | `_required` |
| `outstanding(DUTIES)` | arity 1 | `_outstanding` |

**Status compounds.** These are never final, and their CITATIONS are always `[]`.

- `indeterminate([KEY])`: MISSING_KEYS holds exactly one bare key atom. The bare atom `indeterminate` is NEVER written.
- `needs_legal_review(open_textured(KEY, cite(CITATION_KEY)), [inputs_relied_on(PAIRS)])`. CONTEXT may optionally end with one unscored `provenance(CLAUSE, CITATIONS)`.
- `input_problems(PROBLEMS)`: PROBLEMS is a list of `duplicate_key(KEY)`, `wrong_type(KEY)` and `unknown_key(KEY)` terms.

**Facade STATUS (`dora_ict_incident_management_process_status/2`)** is one of `complete`, `incomplete`, `indeterminate`, `needs_legal_review` or `input_problems`.

**Eligibility-shaped mapping (query type #2).** The eligibility labels map onto this order as follows:
- `eligible` maps to `complete`.
- `ineligible` maps to `incomplete`.
- `indeterminate` maps to `indeterminate`.
- `needs_legal_review` and `input_problems` stay as they are.

The `assess/6` labels are `labels(complete, indeterminate, incomplete)`.

**Result constructors.** These are exported and are never called as queries: `required/1`, `outstanding/1`, `indeterminate/1`, `needs_legal_review/2`, `open_textured/2`, `inputs_relied_on/1`, `provenance/2`, `input_problems/1`, `unknown_key/1`, `wrong_type/1` and `duplicate_key/1`.

## 2. Profile keys

PROFILE is `[attribute(KEY, VALUE), ...]`. Every key is read ONLY with `profile_get/3`, by presence first and then by value.

There are ten JUDGEMENT keys. Each is tri-state: the atom `true`, `false` or `unsure`. In input_contract the type is `judgement: one_of boolean or unsure`, where boolean means the two atoms, never a Python boolean.

There is no fact key and no numeric or date key. This is the order of root_exports and of input_contract:

1. `ict_related_incident_management_process_defined_established_and_implemented`
2. `all_ict_related_incidents_and_significant_cyber_threats_recorded`
3. `procedures_for_monitoring_handling_follow_up_and_root_causes_established`
4. `early_warning_indicators_put_in_place`
5. `procedures_to_identify_track_log_categorise_and_classify_incidents_established`
6. `roles_and_responsibilities_for_incident_types_and_scenarios_assigned`
7. `communication_notification_escalation_and_counterpart_information_plans_set_out`
8. `major_incidents_reported_to_senior_management_and_management_body_informed`
9. `incident_response_procedures_established`
10. `cyber_threats_classified_as_significant_on_the_article_18_2_criteria`

## 3. Citation-key atoms

These are the canonical lexicon keys (`_lexicon/citations.yaml`) and form the citation_vocabulary. Each is used as `cite(KEY)`. Shortened forms are never invented.

| Key | Provision |
|---|---|
| `eu_reg_2022_2554_art_17_1` | DORA Art 17(1) |
| `eu_reg_2022_2554_art_17_2` | DORA Art 17(2), both sentences |
| `eu_reg_2022_2554_art_17_3` | DORA Art 17(3), lead words; in THE FIXED CITATIONS only |
| `eu_reg_2022_2554_art_17_3_a` | DORA Art 17(3)(a) |
| `eu_reg_2022_2554_art_17_3_b` | DORA Art 17(3)(b) |
| `eu_reg_2022_2554_art_17_3_c` | DORA Art 17(3)(c) |
| `eu_reg_2022_2554_art_17_3_d` | DORA Art 17(3)(d) |
| `eu_reg_2022_2554_art_17_3_e` | DORA Art 17(3)(e) |
| `eu_reg_2022_2554_art_17_3_f` | DORA Art 17(3)(f) |
| `eu_reg_2022_2554_art_18_2` | DORA Art 18(2) |

THE FIXED CITATIONS are `[cite(eu_reg_2022_2554_art_17_1), cite(eu_reg_2022_2554_art_17_2), cite(eu_reg_2022_2554_art_17_3), cite(eu_reg_2022_2554_art_18_2)]`.

The deferred provisions (Art 4(2), Art 16(1), Art 18(1), Art 18(3) and (4)) are recorded in NOTES.md and the manifest's deferred set. They are NOT in citation_vocabulary, because no answer cites them.

## 4. Public predicates

One line per predicate:

- `ict_incident_management_process_duties_required(Profile, Result, Citations)`: steps R0 and R1. Input problems first (`input_problems(Problems)`, `[]`). Otherwise `required(AllTenDutiesInDutyOrder)` with THE FIXED CITATIONS. Reads no judgement and never refers. Cites DORA Art 17(1), 17(2), 17(3) and 18(2).
- `ict_incident_management_process_duties_complete(Profile, Result, Citations)`: steps S0 to S4.
  - S0: `input_problems`.
  - S1: any key `false` gives `incomplete` with THE FIXED CITATIONS.
  - S2: the first absent key gives `indeterminate([Key])` with `[]`.
  - S3: the first unsure key gives `needs_legal_review(open_textured(Key, cite(DutyCitationKey)), [inputs_relied_on(Pairs)])` with `[]`.
  - S4: otherwise `complete` with THE FIXED CITATIONS.
  - Cites DORA Art 17 and 18(2).
- `ict_incident_management_process_duties_outstanding(Profile, Result, Citations)`: steps M0 to M3.
  - M0: `input_problems`.
  - M1: the first absent key gives `indeterminate([Key])`. A `false` key does not stop the query.
  - M2: the first unsure key gives `needs_legal_review(...)`.
  - M3: either `none_outstanding` with THE FIXED CITATIONS, or `outstanding(FailingDutiesInDutyOrder)` with each failing duty's citation once (the duties of 17(2) are deduplicated).
  - Cites DORA Art 17 and 18(2).
- `dora_ict_incident_management_process_input_problems(Profile, Problems)`: THE INPUT CHECK, which gives exactly one solution.
  - Problems is `[]` when the profile is well-formed.
  - Otherwise, for each contract key in contract order: `duplicate_key(Key)` if the key repeats, which reads no value; else `wrong_type(Key)` if the value is not `true`, `false` or `unsure`, an unbound value included.
  - Then `unknown_key(Key)` for each non-contract key, once, in first-occurrence order, using `==` identity. Its value is never checked, and a variable key is reported as that same variable.
  - `[wrong_type(profile)]` alone is given for a non-list, an unbound profile, a partial list, an unbound element or any element that is not `attribute/2`.
  - Cites DORA Art 17 and 18(2).
- `decide_dora_ict_incident_management_process(Profile, dora_ict_incident_management_process_verdict(Status, Citations))`: the facade over `ict_incident_management_process_duties_complete`. Status is the functor name of Result and Citations are that query's citations. This is the eligibility verdict (#2). Cites DORA Art 17 and 18(2).
- `dora_ict_incident_management_process_status(Profile, Status)`: projection of the facade STATUS only. Cites DORA Art 17 and 18(2).
- `dora_ict_incident_management_process_checklist(Profile, Checklist)`: the justification view (#7). It is built from `assess/6` over the ten duty ids with `requirement/4`, giving one `item(Duty, ItemStatus, cite(DutyCitationKey))` per duty in duty order. Met items carry their citation too. A malformed profile gives `[]`. Cites the duty's own provision, Art 17(1) to 18(2).
- `dora_ict_incident_management_process_compliance(Profile, Action, Verdict)`: the compliance check (#13). Action is `omit(Duty)` or `perform(Duty)` for a duty atom. Every duty is obligatory for every financial entity, so `omit(_)` is forbidden and `perform(_)` is permitted.
  - It is built on `kit/compliance_lib` `compliance_check/7`.
  - The `applies` closure is `dora_ict_incident_management_process_norm_applies`.
  - There is no repair norm. The combining world is deny-overrides.
  - Cites the duty's own citation key.
- `dora_ict_incident_management_process_what_if(Profile, Key, Value, Result)`: `profile_set/3` replaces `attribute(Key, _)` with `attribute(Key, Value)`, then the query reruns `ict_incident_management_process_duties_complete`. Result is the new RESULT, so an invalid Value gives `input_problems`. Cites DORA Art 17 and 18(2).
- `dora_ict_incident_management_process_fixture(Name, Profile)` and `dora_ict_incident_management_process_fixture_expected(Name, Query, Result, Citations)`: the fixtures (section 7).

## 5. Planned reuse (manifest `uses:`)

- **`formalize_lib`:**
  - `profile_get/3`, `profile_has/2`, `profile_lacks/2`, `profile_set/3`, `profile_keys/2`
  - `missing_keys/3` (ordered missing keys; the head is the named key)
  - `check_tri/4` (true/false/absent for each duty key; an unsure value is guarded in a separate earlier clause and never re-implemented)
  - `assess/6`, `eval_requirements/4`, `decide_labeled/3`, `has_unmet/1`, `has_unknown/1` (checklist)
  - `not_defeated/3` (defeasible layer with guarded `once/1` defeater over an empty table)
  - `not_member/2`, `memberd/2`
  - `attribute/2`, `item/3`, `unmet/1`, `unknown/1`, `labels/3`, `assessment/3`
- **`kit/compliance_lib`:** `nm/2`, `compliance_check/7`, `verdict/5`.
- **`validate_props`:** `run_props/1`, `prop_totality/3`, `prop_determinism/3`, `prop_citation_complete/3`, `prop_missing_key_coverage/3`, `declare_vacuous/1` (no boundary or monotone axis, because there is no numeric key), `bad_citation/1`.
- **`list_item`:** built in, used for duty-order positions where needed.
- **Not used:** deadline_lib, rolling_window and date_time (no date is read); currency_vocab and vat_category (no money); country.
- **Local helpers.** The input check and the first-unsure selector have no kit module and are noted in NOTES.md. Clones of `ratio_bps`, `check_tri` and `eval_requirements` are NOT written.

## 6. Package layout (unchanged)

`kernel -> citations -> parameters -> dora_ict_incident_management_process -> queries -> fixtures -> package facade`

- **`kernel.clausal`:** only what a slice must SHARE. With one slice, this is:
  - the RESULT constructors;
  - `dora_ict_incident_management_process_fixed_citations/1`, the fixed four-cite list, which both the queries and the facade use.
- **`citations.clausal`:** the ten `citation_key/2` facts (key, then provision text label) for section 3. It holds no logic.
- **`parameters.clausal`:** no `constant_value/1,2` declarations. A comment records that the order reads no figure, hour or count, so ruling 6 is not engaged.
- **`queries.clausal`:** the three called-contract queries, the input check, checklist, compliance and what_if wiring.
- **`fixtures.clausal`:** the named profiles and their expected results.
- **Package facade:** `decide_`, `_status`, `_checklist` and `_what_if`, re-exported.

## 7. Slice: `dora_ict_incident_management_process.clausal`

### 7.1 Statutory VALUE facts owned by this slice

The slice owns the duty table and holds no numeric constants. The table is one fact per duty, written as `dora_ict_incident_management_process_duty(Position, Duty, ProfileKey, CitationKey, ProvisionLabel)` in printed (duty) order:

| Position | Duty | Profile key | Citation key | Provision |
|---|---|---|---|---|
| 1 | `incident_management_process` | key 1 | `eu_reg_2022_2554_art_17_1` | Art 17(1) |
| 2 | `recording_of_incidents_and_significant_cyber_threats` | key 2 | `eu_reg_2022_2554_art_17_2` | Art 17(2), first sentence |
| 3 | `monitoring_handling_and_follow_up_procedures` | key 3 | `eu_reg_2022_2554_art_17_2` | Art 17(2), second sentence |
| 4 | `early_warning_indicators` | key 4 | `eu_reg_2022_2554_art_17_3_a` | Art 17(3)(a) |
| 5 | `identification_and_classification_procedures` | key 5 | `eu_reg_2022_2554_art_17_3_b` | Art 17(3)(b) |
| 6 | `incident_roles_and_responsibilities` | key 6 | `eu_reg_2022_2554_art_17_3_c` | Art 17(3)(c) |
| 7 | `communication_and_escalation_plans` | key 7 | `eu_reg_2022_2554_art_17_3_d` | Art 17(3)(d) |
| 8 | `reporting_to_senior_management_and_management_body` | key 8 | `eu_reg_2022_2554_art_17_3_e` | Art 17(3)(e) |
| 9 | `incident_response_procedures` | key 9 | `eu_reg_2022_2554_art_17_3_f` | Art 17(3)(f) |
| 10 | `classification_of_significant_cyber_threats` | key 10 | `eu_reg_2022_2554_art_18_2` | Art 18(2) |

Keys 1 to 10 are the profile keys of section 2, in the same order.

The slice also owns these facts:
- `dora_ict_incident_management_process_duty_order/1`: the list of the ten duty atoms in order.
- `dora_ict_incident_management_process_key_order/1`: the ten keys in root_exports order.
- `dora_ict_incident_management_process_referral_inputs/2`: for each key, all ten keys.
- `dora_ict_incident_management_process_defeater/2`: EMPTY. It is declared `discontiguous` and `dynamic` so that a call fails cleanly. A comment records that Art 16(1) and Art 4(2) were considered and rejected as defeaters (readings (2) to (4)).

### 7.2 Rules and requirements

1. **Applicability, defeasible.** `dora_ict_incident_management_process_duty_applies(Duty, Profile)` holds when the duty is in the table and `not_defeated(Duty, Profile, dora_ict_incident_management_process_defeated)` holds.
   - The defeater body is `once(dora_ict_incident_management_process_defeater(Duty, Profile))`, which is guarded and cut-free.
   - With the empty table, all ten duties always apply.
2. **Requirement.** `requirement(Duty, Profile, Status, Citation)` takes Duty FIRST, as `assess/6` requires. It has mutually exclusive clauses selected by presence and value:
   - (a) If the value is `unsure`, the status is `unknown(open_textured(Key))`. This hands the open-textured judgement to the user.
   - (b) Otherwise the key is absent or its value is `true` or `false`, and the status comes from `check_tri(Profile, Key, not_performed(Duty), Status)`: met, unmet or unknown of the missing keys.
   - Every item carries `cite(CitationKey)`.
3. **Duty fails.** `dora_ict_incident_management_process_duty_fails(Profile, Duty)` holds when `profile_get(Profile, Key, false)` holds for that duty's key.
4. **Outstanding list.** `dora_ict_incident_management_process_outstanding_duties(Profile, Duties)` is built by an ordered `findall` over the duty table. It is used only after M1 and M2 have established that every key is `true` or `false`.
5. **Outstanding citations.** `dora_ict_incident_management_process_outstanding_citations(Duties, Citations)` gives the duties' `cite/1` terms in duty order with exact duplicates removed. The deduplication keeps the first occurrence, so 17(2) appears once.
6. **First absent key.** `dora_ict_incident_management_process_first_absent_key(Profile, Key)` is the head of `missing_keys(Profile, KeyOrder, [Key|_])`. It is deterministic.
   - No key is BEHIND another, because every key decides alone.
7. **First unsure key.** `dora_ict_incident_management_process_first_unsure_key(Profile, Key)` is the first key in KeyOrder whose value is `unsure`. It is computed by ordered `findall` and takes the head.
8. **Pairs.** `dora_ict_incident_management_process_pairs(Profile, Pairs)` gives `Key-Value` for every present contract key, in root_exports order, with the value exactly as given.
9. **Step guards.** Each query clause is one disjoint route. The ground status is folded into the clause head (C17); there is no `!`, `->` or `*->`. The routes are separated by these guards:
   - problems empty or non-empty;
   - a false key exists or does not;
   - absent keys empty or non-empty;
   - unsure keys empty or non-empty.
   - Each clause therefore yields at most one solution, and the routes cover every case, so every call yields exactly one.
10. **Compliance norms.** There is one fact per duty, `nm(obligatory(Duty), obligatory)`. The closure `dora_ict_incident_management_process_norm_applies(Bearer, Action, World, NormModalities)` maps `omit(Duty)` to forbidden and `perform(Duty)` to obligatory.

### 7.3 Verdict atoms produced by this slice

The slice produces `complete`, `incomplete`, `none_outstanding`, `required/1`, `outstanding/1`, `indeterminate/1` and `needs_legal_review/2` (with `open_textured/2` and `inputs_relied_on/1`).

Its checklist item statuses are `met`, `unmet(not_performed(Duty))` and `unknown(...)`. Its compliance verdicts come from `compliance_lib`.

### 7.4 Shared with another slice (belongs in kernel)

Only two things are shared: `dora_ict_incident_management_process_fixed_citations/1` and the result constructors. Nothing else is shared, because there is one slice.

### 7.5 Per-rule tests (seven modes)

The tests cover these modes:

- **Unit.** One test per duty-table row and per requirement clause (met, unmet, absent-unknown and unsure-unknown).
- **Precedence.** Each case is paired with a positive test over the same profile:
  - In `_complete`, a false key with earlier absent keys gives `incomplete`.
  - In `_outstanding`, a false key with an absent key gives `indeterminate`.
  - An unsure key with a later absent key gives `indeterminate`.
- **Counting.** For every fixture and every query, `findall` gives a list of length 1.
- **Citation.** The fixed set holds for `complete`, `incomplete`, `none_outstanding` and `required`. When both 17(2) duties are outstanding, `cite(eu_reg_2022_2554_art_17_2)` appears exactly once. Every status compound has `[]`.
- **Input check.** Unknown keys with odd values, duplicate keys with unequal values (no wrong_type), keys 7 and 7.0, two distinct variable keys, one variable key twice, an unbound value, an unbound profile, a partial list, a non-attribute element, and float and string values.
- **Property.** Totality, determinism and citation-completeness come from `validate_props`; the absent boundary and monotone properties are `declare_vacuous`.
- **Facade/what_if.** The facade's status projection is checked, and a what_if test flips one false key to true.

### 7.6 Fixtures

| Fixture | Expected results |
|---|---|
| `all_ten_true` | `complete`; `none_outstanding`; `required` of all ten |
| `early_warning_indicators_false` | `incomplete`; `outstanding([early_warning_indicators])` with `[cite(eu_reg_2022_2554_art_17_3_a)]` |
| `both_article_17_2_duties_false` | `outstanding([recording_of_incidents_and_significant_cyber_threats, monitoring_handling_and_follow_up_procedures])` with `[cite(eu_reg_2022_2554_art_17_2)]` |
| `empty_profile` | `required` of all ten; `indeterminate([ict_related_incident_management_process_defined_established_and_implemented])` in both other queries |
| `false_and_absent` | `incomplete`; `_outstanding` gives indeterminate on the first absent key |
| `unsure_on_point_d_rest_true` | `needs_legal_review(open_textured(communication_notification_escalation_and_counterpart_information_plans_set_out, cite(eu_reg_2022_2554_art_17_3_d)), [inputs_relied_on(AllTenPairs)])` |
| `unsure_then_absent` | indeterminate on the absent key |
| `unknown_key_present` | `input_problems([unknown_key(...)])` |
| `duplicate_key_present` | `input_problems([duplicate_key(...)])` |
| `wrong_type_value` | `input_problems([wrong_type(...)])` |
| `not_an_attribute_list` | `input_problems([wrong_type(profile)])` |

In `false_and_absent`, the false key comes after the absent one.
