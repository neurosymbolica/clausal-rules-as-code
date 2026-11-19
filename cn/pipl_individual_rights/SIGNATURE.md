# SIGNATURE — cn/pipl_individual_rights

Package layout, unchanged:

`kernel.clausal` -> `citations.clausal` -> `parameters.clausal` -> `pipl_individual_rights.clausal` -> `queries.clausal` -> `fixtures.clausal` -> package facade

The manifest is v2 and there are seven test modes. Predicate prefix: `pipl_individual_rights_`.

## 1 Public query surface

The CALLED CONTRACT consists of nine queries `QUERY(Profile, Result, Citations)` and the input check `pipl_individual_rights_input_problems(Profile, Problems)`. All are exported from the facade with exactly the arities and terms of the order.

The scaffold facade adds query types #2 (eligibility) and #7 (justification). It answers ONE named query per call:

- `decide_pipl_individual_rights(question(QueryName, Profile), pipl_individual_rights_verdict(Status, Checklist))`
- `pipl_individual_rights_status(question(QueryName, Profile), Status)`

The facade's terms are stated here, so they fall under the 'terms stated here' allowance of the contract. The facade never combines queries.

PROFILE is `[attribute(Key, Value), ...]` and is read only with `profile_get/3`, presence first.

Totality and determinism:

- Every contract query and the input check yield EXACTLY ONE solution for every term given.
- Every facade predicate yields exactly one solution for each of the nine query names. For any other QueryName it fails; this is tested as a paired negative test.
- No figures are imported or declared. The domain has no statutory numbers (NOTES S5).

## 2 Status atoms

### 2.1 Contract RESULT atoms (per query)

| Query | Final RESULT atoms |
|---|---|
| `restriction_or_refusal_right` | `right_available`, `excluded_by_other_law` |
| `access_and_copy_duty` | `provide_in_time`, `not_owed` |
| `portability_duty` | `provide_transfer_route`, `not_owed` |
| `correction_duty` | `correct_or_supplement_in_time`, `no_correction_owed` |
| `deletion_duty` | `delete_personal_information`, `stop_processing_except_storage_and_security`, `not_owed` |
| `explanation_duty` | `explain_processing_rules` |
| `deceased_person_rights` | `near_relative_may_exercise`, `near_relative_may_not_exercise` |
| `request_mechanism` | `requirement_met`, `requirement_not_met` |
| `refusal_status` | `not_refused`, `refused_with_reasons`, `refused_without_reasons` |

- **All queries:** `pinned_text_not_applicable`.
- **Status compounds** (never bare): `indeterminate([Key])`, `needs_legal_review(open_textured(Key, cite(Unit)), [inputs_relied_on(Pairs)])`, `input_problems(Problems)`.
- **Problem terms:** `duplicate_key(Key)`, `wrong_type(Key)`, `wrong_type(profile)`, `unknown_key(Key)`.
- **Result constructors** (exported, never called as queries): `indeterminate/1`, `needs_legal_review/2`, `open_textured/2`, `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`, `inputs_relied_on/1`.

### 2.2 Facade STATUS atoms (replace the placeholder `{ required, permitted, not_applicable }`)

`eligible`, `ineligible`, `undetermined`, `referred_for_legal_review`, `text_not_in_force`, `input_rejected`.

The atom `indeterminate` is never bare. Mapping from the query RESULT:

- `input_problems(_)` -> `input_rejected`
- `indeterminate(_)` -> `undetermined`
- `needs_legal_review(_, _)` -> `referred_for_legal_review`
- `pinned_text_not_applicable` -> `text_not_in_force`
- `eligible`, meaning the right or duty asked about is engaged: `right_available`, `provide_in_time`, `provide_transfer_route`, `correct_or_supplement_in_time`, `delete_personal_information`, `stop_processing_except_storage_and_security`, `explain_processing_rules`, `near_relative_may_exercise`, `requirement_met`, `refused_with_reasons`, `refused_without_reasons` (the last two because the individual may sue, Art 50(2))
- `ineligible`: `excluded_by_other_law`, `not_owed`, `no_correction_owed`, `near_relative_may_not_exercise`, `requirement_not_met`, `not_refused`

The mapping is the fact table `pipl_individual_rights_status_of_result/2`. It has one clause per final atom and one clause per compound functor, so it is head-folded (C17).

## 3 Profile keys (twenty, in root_exports / input_contract order)

No key is numeric or a date. The order takes no date argument (R2).

| # | Key | Type |
|---|---|---|
| 1 | `pinned_text_in_force_on_reference_day` | crisp |
| 2 | `laws_or_regulations_provide_otherwise` | crisp |
| 3 | `article_18_1_case` | crisp |
| 4 | `article_35_case` | crisp |
| 5 | `cyberspace_department_transfer_conditions_met` | crisp |
| 6 | `verification_confirms_inaccurate_or_incomplete` | judgement |
| 7 | `purpose_achieved_impossible_or_unnecessary` | judgement |
| 8 | `service_stopped_or_retention_period_expired` | crisp |
| 9 | `consent_withdrawn` | crisp |
| 10 | `processing_violates_law_or_agreement` | judgement |
| 11 | `other_deletion_case_prescribed_by_law` | crisp |
| 12 | `legal_retention_period_unexpired` | crisp |
| 13 | `deletion_technically_difficult` | judgement |
| 14 | `person_deceased` | crisp |
| 15 | `requester_is_near_relative` | crisp |
| 16 | `for_requester_own_lawful_and_legitimate_interests` | judgement |
| 17 | `deceased_arranged_otherwise` | crisp |
| 18 | `convenient_mechanism_established` | judgement |
| 19 | `request_refused` | crisp |
| 20 | `refusal_reasons_given` | crisp |

- A crisp key is one of the atoms `true` or `false`.
- A judgement key is one of the atoms `true`, `false` or `unsure`.

## 4 Citation-key atoms (`citation_vocabulary`, canonical lexicon scheme)

`cn_pipl_art_44_p1`, `cn_pipl_art_45_p1`, `cn_pipl_art_45_p2`, `cn_pipl_art_45_p3`, `cn_pipl_art_46_p1`, `cn_pipl_art_46_p2`, `cn_pipl_art_47_p1`, `cn_pipl_art_47_p1_i1`, `cn_pipl_art_47_p1_i2`, `cn_pipl_art_47_p1_i3`, `cn_pipl_art_47_p1_i4`, `cn_pipl_art_47_p1_i5`, `cn_pipl_art_47_p2`, `cn_pipl_art_48_p1`, `cn_pipl_art_49_p1`, `cn_pipl_art_50_p1`, `cn_pipl_art_50_p2`.

That is seventeen atoms. They are always written `cite(Key)` and never shortened. Arts 3, 73 and 74 are pinned and quoted in NOTES but have no limb and appear in no CITATIONS.

## 5 Public predicates

- `restriction_or_refusal_right(Profile, Result, Citations)`: may the individual restrict or refuse processing by others — PIPL Art 44 (`cn_pipl_art_44_p1`).
- `access_and_copy_duty(Profile, Result, Citations)`: must the handler provide the information for consulting or copying in time — PIPL Art 45(1), 45(2) (`cn_pipl_art_45_p1`, `cn_pipl_art_45_p2`).
- `portability_duty(Profile, Result, Citations)`: must the handler provide a way to transfer — PIPL Art 45(3) (`cn_pipl_art_45_p3`).
- `correction_duty(Profile, Result, Citations)`: must the handler correct or supplement in time — PIPL Art 46(1), 46(2) (`cn_pipl_art_46_p1`, `cn_pipl_art_46_p2`).
- `deletion_duty(Profile, Result, Citations)`: must the handler delete, or stop processing except storage and security — PIPL Art 47(1) items (1) to (5), 47(2) (`cn_pipl_art_47_p1`, `cn_pipl_art_47_p1_i1` to `cn_pipl_art_47_p1_i5`, `cn_pipl_art_47_p2`).
- `explanation_duty(Profile, Result, Citations)`: must the handler explain its processing rules — PIPL Art 48 (`cn_pipl_art_48_p1`).
- `deceased_person_rights(Profile, Result, Citations)`: may the near relative exercise the Chapter IV rights over the deceased's information — PIPL Art 49 (`cn_pipl_art_49_p1`).
- `request_mechanism(Profile, Result, Citations)`: has the handler set up a convenient request mechanism — PIPL Art 50(1), first sentence (`cn_pipl_art_50_p1`).
- `refusal_status(Profile, Result, Citations)`: refused or not, with or without reasons; may the individual sue — PIPL Art 50(1), second sentence, and 50(2) (`cn_pipl_art_50_p1`, `cn_pipl_art_50_p2`).
- `pipl_individual_rights_input_problems(Profile, Problems)`: the typed input check (NOTES S5). It never fails and never raises. No citation.
- `decide_pipl_individual_rights(Question, Verdict)`: Question is `question(QueryName, Profile)`; Verdict is `pipl_individual_rights_verdict(Status, Checklist)`. Status follows §2.2. Checklist is a list of `item(RequirementId, ItemStatus, cite(Unit))` for the query's requirements (§7.4). Citation: the named query's units.
- `pipl_individual_rights_status(Question, Status)`: Status of `decide_pipl_individual_rights/2` alone. Citation: as above.
- `pipl_individual_rights_checklist(Question, Checklist)`: the checklist alone, for query type #7. Every item carries `cite(...)`, met items included.
- `pipl_individual_rights_what_if(Question, Key, Value, Verdict)`: the verdict for the same query with `Key` set to `Value`. Implemented as `what_if(Profile, Key, Value, pipl_individual_rights_decide_profile(QueryName), Verdict)`, where the closure is called as `pipl_individual_rights_decide_profile(QueryName, Profile2, Verdict)`. If `override_key/4` does not accept an attribute list, fall back to `profile_set/3` followed by a decide call.
- `pipl_individual_rights_fixture(FixtureName, Profile)`: named test profiles (`fixtures.clausal`).
- `pipl_individual_rights_fixture_expectation(FixtureName, QueryName, Result, Citations)`: the expected answer of a fixture for a query.

## 6 Planned reuse (manifest `uses:`)

- **`formalize_lib`**: `profile_get/3`, `profile_has/2`, `profile_lacks/2`, `profile_set/3`, `check_true/4`, `check_false/4`, `check_tri/4`, `check_tri_neg/4`, `or_status/2`, `eval_requirements/4`, `memberd/2`, `not_member/2`, `attribute/2`, `item/3`, `unmet/1`, `unknown/1`.
  - `check_tri/4` and `check_tri_neg/4` are used for the six judgements in checklist rows, so they are never hand-rolled (C15).
  - `eval_requirements/4` takes the closure `pipl_individual_rights_requirement(QueryName)`. It is never hand-rolled with findall (R1 lint).
- **`kit.query_combinators`**: `what_if/5`, `override_key/4`.
- **`validate_props`**: `run_props/1`, `prop_totality/3`, `prop_determinism/3`, `prop_citation_complete/3`, `prop_missing_key_coverage/3`, `bad_citation/1`.
- **Not used, and why:**
  - `kit.deadline_lib` and `date_time`: there is no period or date (R3, R2).
  - `ratio_bps`: no ratio.
  - `compliance_lib`: the ladders' first-step precedence is not the lattice's deny-overrides.
  - `assess/6`: the facade status must follow the ladder, not checklist aggregation.
  - `rolling_window`, `currency_vocab`, `vat_category`, `country`: no use in this domain.
- **No `_common` family backbone predicate applies.** The deontic ladders are domain-specific.

## 7 Determination slices

### 7.0 kernel.clausal (shared floor)

These are the only predicates shared across files: the slice, `queries.clausal` and the facade.

- **`pipl_individual_rights_contract_key(Key, Type)`**: twenty facts in §3 order. Type is `crisp` or `judgement`.
- **`pipl_individual_rights_type_value(Type, Value)`**: `crisp` allows `true` and `false`; `judgement` allows `true`, `false` and `unsure`.
- **`pipl_individual_rights_input_problems(Profile, Problems)`**: the input check.
  - (i) A Profile that is not a proper list of `attribute(_, _)` terms gives `[wrong_type(profile)]`. This covers an unbound Profile, a partial list, an unbound element and a non-attribute element; each is tested with `var/1`- and `is_list/1`-style guards before any unification.
  - (ii) Otherwise, for each contract key in order: `duplicate_key(Key)` if it occurs at least twice, its values not read; else `wrong_type(Key)` if it occurs once with a value that is unbound or outside its type.
  - (iii) Then `unknown_key(Key)` for each non-contract key, including non-atoms and unbound keys as given, once, in order of first occurrence. Comparison is `==`, so a variable key is matched only to itself.
  - Exactly one solution.
- **`pipl_individual_rights_key_state(Profile, Key, State)`**: on a well-formed profile, exactly one State.
  - `absent` when `profile_lacks(Profile, Key)`;
  - otherwise the value given by `profile_get(Profile, Key, Value)`.
  - The `absent` clause is guarded by `profile_lacks`, and the value clause by `profile_has`.
- **`pipl_individual_rights_relied_pairs(Profile, PairsKeys, Pairs)`**: the Key-Value pairs of PairsKeys that are present, in contract order. Implemented with one `findall/3` over `memberd/2` + `profile_get/3`.

### 7.1 citations.clausal

- `citation_vocabulary(Key)`: the seventeen §4 facts.
- `pipl_individual_rights_pinned_unit(UnitId, CitationKey)`: maps the pinned AKN units (`cn-pipl-2021#art_44_p1` -> `cn_pipl_art_44_p1`, and so on) for provenance.

### 7.2 parameters.clausal

No statutory figure exists (R3: 'in time' has no number; R2: Art 74's date is read by the caller). The file holds only the header comment saying so. No `constant_value/2` is declared.

### 7.3 pipl_individual_rights.clausal (the single determination slice)

**VALUE facts owned here:**

- `pipl_individual_rights_query_keys(QueryName, Keys)`: the keys each query reads (order §Profile).
- `pipl_individual_rights_pairs_keys(QueryName, Keys)`:
  - `correction_duty`: `[verification_confirms_inaccurate_or_incomplete]`;
  - `deletion_duty`: `[purpose_achieved_impossible_or_unnecessary, processing_violates_law_or_agreement, deletion_technically_difficult]`;
  - `deceased_person_rights`: `[for_requester_own_lawful_and_legitimate_interests]`;
  - `request_mechanism`: `[convenient_mechanism_established]`;
  - the other five queries: `[]`.
- `pipl_individual_rights_deletion_case_keys(Keys)`: the five item keys in item order (1) to (5).
- The fixed CITATIONS lists, as facts `pipl_individual_rights_final_citations(QueryName, ResultAtom, Citations)`:
  - Art 44 answers: `[cite(cn_pipl_art_44_p1)]`.
  - access `not_owed`: `[cite(cn_pipl_art_45_p1)]`; `provide_in_time`: `[cite(cn_pipl_art_45_p1), cite(cn_pipl_art_45_p2)]`.
  - portability answers: `[cite(cn_pipl_art_45_p3)]`.
  - correction answers: `[cite(cn_pipl_art_46_p1), cite(cn_pipl_art_46_p2)]`.
  - deletion `delete_personal_information` and `stop_processing_except_storage_and_security`: 47 p1, p1_i1 to p1_i5, and p2. Deletion `not_owed`: 47 p1 and p1_i1 to p1_i5, without p2.
  - `explain_processing_rules`: `[cite(cn_pipl_art_48_p1)]`.
  - Art 49 answers: `[cite(cn_pipl_art_49_p1)]`.
  - `requirement_met` / `requirement_not_met` / `not_refused`: `[cite(cn_pipl_art_50_p1)]`.
  - `refused_with_reasons` / `refused_without_reasons`: `[cite(cn_pipl_art_50_p1), cite(cn_pipl_art_50_p2)]`.

**Clause pattern:** every query has these clauses in this order.

- (0) `QUERY(Profile, input_problems(Problems), [])` when Problems is not `[]`.
- Every later clause first requires `pipl_individual_rights_input_problems(Profile, [])`, then reads key states with `pipl_individual_rights_key_state/3`.
- The guards make the steps pairwise disjoint: each step carries the negation of every earlier step's condition, written as positive state tests.
- The RESULT and CITATIONS are in the head (C17).
- Steps (1) and (2) are common to all queries:
  - pinned key `absent` -> `indeterminate([pinned_text_in_force_on_reference_day])`, [];
  - pinned key `false` -> `pinned_text_not_applicable`, [].
- All later steps require the pinned key `true`.

**restriction_or_refusal_right:**

- (3) `laws_or_regulations_provide_otherwise` absent -> `indeterminate([laws_or_regulations_provide_otherwise])`.
- (4) true -> `excluded_by_other_law`.
- (5) false -> `right_available`.

**access_and_copy_duty:**

- (3) `article_18_1_case` true -> `not_owed`.
- (4) `article_18_1_case` not true and `article_35_case` true -> `not_owed`.
- (5) `article_18_1_case` absent and `article_35_case` not true -> `indeterminate([article_18_1_case])`.
- (6) `article_18_1_case` false and `article_35_case` absent -> `indeterminate([article_35_case])`.
- (7) both false -> `provide_in_time`.

**portability_duty:**

- (3) `cyberspace_department_transfer_conditions_met` absent -> `indeterminate([cyberspace_department_transfer_conditions_met])`.
- (4) true -> `provide_transfer_route`.
- (5) false -> `not_owed`.

**correction_duty:**

- (3) `verification_confirms_inaccurate_or_incomplete` absent -> `indeterminate([verification_confirms_inaccurate_or_incomplete])`.
- (4) true -> `correct_or_supplement_in_time`.
- (5) false -> `no_correction_owed`.
- (6) unsure -> `needs_legal_review(open_textured(verification_confirms_inaccurate_or_incomplete, cite(cn_pipl_art_46_p2)), [inputs_relied_on(Pairs)])`, [].

**deletion_duty:**

- Compute `CaseValues`, the states of the five item keys, once.
- Named conditions:
  - SOME TRUE: `memberd(true, CaseValues)`;
  - ALL FALSE: `CaseValues = [false, false, false, false, false]`;
  - NONE TRUE: `not_member(true, CaseValues)`;
  - NOT ALL FALSE: NONE TRUE and not ALL FALSE, or SOME TRUE.
  - 47(2) HOLDS: retention `true` or difficulty `true`, written as two disjoint guards: retention true; or retention not true and difficulty true.
  - 47(2) FAILS: retention false and difficulty false.
- Steps:
  - (3) SOME TRUE and 47(2) HOLDS -> `stop_processing_except_storage_and_security`.
  - (4) SOME TRUE and 47(2) FAILS -> `delete_personal_information`.
  - (5) ALL FALSE -> `not_owed`.
  - (6) to (10) NONE TRUE, not ALL FALSE, and the first absent item key in item order -> `indeterminate([ThatKey])`. Each step requires the earlier item keys present.
  - (11) NONE TRUE or SOME TRUE (that is, not ALL FALSE); no item key absent unless SOME TRUE; retention absent; difficulty not true -> `indeterminate([legal_retention_period_unexpired])`.
  - (12) the same, with retention false and difficulty absent -> `indeterminate([deletion_technically_difficult])`.
  - (13) NONE TRUE, no absent case key, steps 11 and 12 not applicable, and `purpose_achieved_impossible_or_unnecessary` unsure -> `needs_legal_review(open_textured(purpose_achieved_impossible_or_unnecessary, cite(cn_pipl_art_47_p1_i1)), [inputs_relied_on(Pairs)])`.
  - (14) the same, with purpose not unsure and `processing_violates_law_or_agreement` unsure -> `open_textured(processing_violates_law_or_agreement, cite(cn_pipl_art_47_p1_i4))`.
  - (15) SOME TRUE, retention false, difficulty unsure -> `open_textured(deletion_technically_difficult, cite(cn_pipl_art_47_p2))`.
- Exhaustiveness is proved by the enumeration test (§8). Note that steps 3 and 4 take SOME TRUE first, so steps 6 to 10 never fire once any case is true.

**explanation_duty:**

- (3) pinned true -> `explain_processing_rules`.

**deceased_person_rights:**

- (3) `person_deceased` false -> `near_relative_may_not_exercise`.
- (4) `requester_is_near_relative` false -> `near_relative_may_not_exercise`.
- (5) `for_requester_own_lawful_and_legitimate_interests` false -> `near_relative_may_not_exercise`.
- (6) `deceased_arranged_otherwise` true -> `near_relative_may_not_exercise`.
- Steps 3 to 6 are made disjoint by requiring the earlier keys not to be in their wrong-way state.
- (7) to (10) no key in its wrong-way state, and the first absent key in contract order -> `indeterminate([ThatKey])`.
- (11) none absent and interests unsure -> `needs_legal_review(open_textured(for_requester_own_lawful_and_legitimate_interests, cite(cn_pipl_art_49_p1)), [inputs_relied_on(Pairs)])`.
- (12) deceased true, relative true, interests true and arranged false -> `near_relative_may_exercise`.

**request_mechanism:**

- (3) `convenient_mechanism_established` absent -> `indeterminate([convenient_mechanism_established])`.
- (4) true -> `requirement_met`.
- (5) false -> `requirement_not_met`.
- (6) unsure -> `needs_legal_review(open_textured(convenient_mechanism_established, cite(cn_pipl_art_50_p1)), [inputs_relied_on(Pairs)])`.

**refusal_status:**

- (3) `request_refused` false -> `not_refused`.
- (4) absent -> `indeterminate([request_refused])`.
- (5) refused true and `refusal_reasons_given` absent -> `indeterminate([refusal_reasons_given])`.
- (6) refused true and reasons true -> `refused_with_reasons`.
- (7) refused true and reasons false -> `refused_without_reasons`.

No query reads a key outside its `query_keys` fact.

**Verdict atoms owned by this slice:** all of §2.1.

**Shared predicates:** only the kernel predicates of §7.0. This slice exports nothing to other slices; there are none.

### 7.4 queries.clausal (facade support; justification checklist)

- `pipl_individual_rights_dispatch(QueryName, Profile, Result, Citations)`: one clause per query name.
- `pipl_individual_rights_requirement(QueryName, RequirementId, Profile, Status, Citation)`: the closure for `eval_requirements/4`. It is called with RequirementId first after the bound QueryName. Each row is met, unmet or unknown via `check_true` / `check_false` / `check_tri` / `check_tri_neg`, and each row is independent.
- `pipl_individual_rights_requirement_ids(QueryName, Ids)`:
  - every query begins with `requirement_text_in_force`, cited with the query's anchor unit (44_p1, 45_p1, 45_p3, 46_p2, 47_p1, 48_p1, 49_p1, 50_p1, 50_p1);
  - `restriction_or_refusal_right`: `requirement_no_other_law_exception` (44_p1);
  - `access_and_copy_duty`: `requirement_no_article_18_1_case`, `requirement_no_article_35_case` (45_p1);
  - `portability_duty`: `requirement_transfer_conditions_met` (45_p3);
  - `correction_duty`: `requirement_verification_confirms_inaccuracy` (46_p2);
  - `deletion_duty`: `requirement_deletion_case_holds` (47_p1, via `or_status/2` over the five items), `requirement_article_47_2_case` (47_p2; a branch marker: met means stop-processing applies);
  - `explanation_duty`: no further row;
  - `deceased_person_rights`: `requirement_person_deceased`, `requirement_requester_near_relative`, `requirement_own_lawful_interests`, `requirement_no_contrary_arrangement` (all 49_p1);
  - `request_mechanism`: `requirement_convenient_mechanism` (50_p1);
  - `refusal_status`: `requirement_request_refused` (50_p1), `requirement_refusal_reasons_given` (50_p1; a branch marker).
- Status ALWAYS comes from the dispatch RESULT via `pipl_individual_rights_status_of_result/2`, never from the checklist. On `input_problems`, the checklist is [].

### 7.5 fixtures.clausal

At least one fixture per ladder step of every query. Examples:

- `fixture_empty_profile`: nine times `indeterminate([pinned_text_in_force_on_reference_day])`.
- `fixture_text_not_in_force`: nine times `pinned_text_not_applicable`, [].
- `fixture_deletion_consent_withdrawn_retention_unexpired`: `stop_processing_except_storage_and_security`.
- `fixture_deletion_two_cases_true`: exactly one `delete_personal_information`.
- `fixture_deletion_purpose_unsure_retention_absent`: `indeterminate([legal_retention_period_unexpired])`.
- `fixture_deletion_purpose_unsure_rest_settled`: `needs_legal_review` with Pairs `[purpose_achieved_impossible_or_unnecessary-unsure, processing_violates_law_or_agreement-false, deletion_technically_difficult-false]`.
- `fixture_access_article_35_true_article_18_absent`: `not_owed`.
- `fixture_duplicate_key`: `input_problems([duplicate_key(consent_withdrawn)])`.
- `fixture_unknown_and_wrong_type`: `[wrong_type(article_35_case), unknown_key(colour)]`.
- `fixture_partial_list`: `[wrong_type(profile)]`.

## 8 Tests (seven modes; v2 manifest)

- **Per-step unit tests:** a positive test for every ladder step of every query, each paired with a negative test.
- **COUNTING:** `findall` plus `length(_, 1)` on every fixture and query.
- **Enumeration:** every combination of the read keys over absent / true / false / unsure.
  - Totality: exactly one solution.
  - The CITATIONS list is the fixed list for final atoms and [] otherwise.
  - Unread keys are invariant.
- **Input-check tests:** an unbound profile, partial lists, unbound keys and values, non-atom keys, and duplicates with equal and with unequal values.
- **Facade tests:** the status mapping; every checklist item cited; the what-if flip on `consent_withdrawn`.
- **validate_props run:** totality, determinism, citation completeness and missing-key coverage.
- **Mutation and lint gates:** C5, C6, C15, C17, R1.
