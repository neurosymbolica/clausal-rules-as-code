# SIGNATURE — eu/data_protection/gdpr_procedural_regulation

## 0. Public query surface (summary)

The package serves eight contract queries (A)–(H), the input check (I) and the scaffold facade.

**Query types:**

- **#3 status determination:** `complaint_admissibility/3` and the facade `decide_gdpr_procedural_regulation/2` / `gdpr_procedural_regulation_status/2`.
- **#13 compliance check:** `simple_cooperation_procedure/4`, `prior_request_condition/3`, `late_step_effect/4`.
- **#15 deadline:** `procedural_time_limit/4`, `draft_decision_time_limit/4`, `temporal_application/5`.

**Totality.** Every public query yields **exactly one** solution for every input term, malformed ones included. It never fails and never raises.

**Determinism.** Routes have disjoint guards and one clause per route. Constant results are folded into the head (C17). There is no `!`, `->` or `*->`, and no `once/1`.

**Imports.** No figure is imported from another domain. All statutory figures are declared in the slice.

The public predicate prefix is `gdpr_procedural_regulation_`. The contract query names (A)–(H) are exported exactly as the order spells them. They are also re-exported from the package facade.

## 1. Verdict / result atoms (replacing the placeholder `{ required, permitted, not_applicable }`)

### Final result atoms

| Query | Result atoms |
|---|---|
| `complaint_admissibility` | `admissible`, `inadmissible` |
| `prior_request_condition` | `prior_request_not_required`, `prior_request_made`, `prior_request_not_made` |
| `early_resolution` | `early_resolution_not_available`, `complaint_not_devoid_of_purpose`, `early_resolution_objected`, `resolution_established_by_receiving_authority`, `draft_decision_establishing_resolution` |
| `simple_cooperation_procedure` | `chapter_iii_not_applicable`, `simple_procedure_not_available`, `simple_procedure_excluded_by_objection`, `simple_procedure_available` |
| `draft_decision_time_limit` | `draft_decision_limit(MONTHS, EXTENSION)`, where MONTHS is 15 or 12 and EXTENSION is `no_extension` or `extension(up_to, N, months)` with N 12 or 2 |
| `late_step_effect` | `legality_and_validity_not_affected`, `not_governed_by_article_14` |
| `procedural_time_limit` | `limit(N, UNIT, RELATION, EVENT, EXTENSION)` |
| `temporal_application` | `part_applies`, `part_does_not_apply` |

### BASIS atoms and items

- `suspended_until_board_binding_decision`
- `extension_not_permitted`
- `outside_fact(KEY, ATTESTED)`

### LIMIT vocabulary

- **Units:** `weeks`, `months`.
- **Relations:** `within`, `at_least_before`.
- **Extensions:** `no_extension`, `extension(exactly, N, UNIT)`, `extension(up_to, N, UNIT)`.
- **Events (10):**
  - `receipt_of_complaint`
  - `complainant_receiving_early_resolution_information`
  - `expiry_of_objection_time_limit`
  - `confirmation_of_competence_or_board_binding_decision`
  - `notification_of_simple_cooperation_procedure`
  - `receipt_of_summary_of_key_issues`
  - `expiry_of_comment_period`
  - `expiry_of_draft_decision_time_limit`
  - `being_informed_of_extension`
  - `expiry_of_simple_procedure_time_limit`

### Step atoms (16)

1. `declare_complaint_inadmissible`
2. `transmit_complaint_to_presumed_lead_authority`
3. `confirm_competence_or_refer_to_board`
4. `object_to_early_resolution`
5. `establish_early_resolution`
6. `submit_early_resolution_draft_decision`
7. `notify_simple_cooperation_procedure`
8. `object_to_simple_cooperation_procedure`
9. `provide_summary_of_key_issues`
10. `comment_on_summary_of_key_issues`
11. `respond_to_comments_on_summary_of_key_issues`
12. `submit_draft_decision`
13. `inform_of_draft_decision_extension`
14. `object_to_draft_decision_extension`
15. `submit_draft_decision_in_simple_procedure`
16. `inform_of_simple_procedure_extension`

### Part atoms

- `complaints_and_early_resolution`
- `cooperation_and_files`
- `dispute_resolution_and_urgency`

### Status compounds (non-final)

- `indeterminate([KEY])`: exactly one key. The bare atom `indeterminate` is never written (atom-shadowing trap).
- `needs_legal_review(open_textured(KEY, cite(CITATION)), [inputs_relied_on([KEY-unsure])])`
- `needs_legal_review(cross_reference_unresolved(cite(CITATION), cite(TARGET)), [resolution(cite(TARGET), not_attempted), inputs_relied_on([KEY-absent])])`
- `input_problems(PROBLEMS)`, where PROBLEMS are drawn from `duplicate_key(KEY)`, `wrong_type(KEY)` (including `wrong_type(profile|step|part|event_date)`) and `unknown_key(KEY)`.

**Other root_exports atoms:**

- the enumeration values: `data_subject`, `article_80_1_body`, `article_80_2_body`, `receiving_authority`, `lead_authority`;
- the judgement value `unsure`;
- the pair value `absent`;
- the resolution value `not_attempted`;
- the booleans `true` and `false`.

**Facade STATUS** (from `complaint_admissibility`): `admissible`, `inadmissible`, `indeterminate([KEY])` or `input_problems(PROBLEMS)`. The facade introduces no new atom.

## 2. Profile keys

The PROFILE is `[attribute(KEY, VALUE), ...]`. It is read only through `profile_get/3`, by presence first and then by value. There are 22 keys, listed in root_exports and input_contract order. No key is numeric. No date is a profile key; EVENT_DATE is an argument.

| # | Key | Kind | Values |
|---|---|---|---|
| 1 | `complaint_lodged_by` | enumeration | `data_subject`, `article_80_1_body`, `article_80_2_body` |
| 2 | `lodging_person_name_and_contact_details_included` | crisp | `true` / `false` |
| 3 | `proof_of_proper_constitution_included` | crisp | `true` / `false` |
| 4 | `proof_of_data_subject_mandate_included` | crisp | `true` / `false` |
| 5 | `controller_or_processor_identification_information_included` | crisp | `true` / `false` |
| 6 | `alleged_infringement_description_included` | crisp | `true` / `false` |
| 7 | `complaint_concerns_right_exercised_by_request` | judgement | `true` / `false` / `unsure` |
| 8 | `request_made_to_controller_before_complaint` | crisp | `true` / `false` |
| 9 | `complaint_concerns_chapter_iii_rights` | crisp | `true` / `false` |
| 10 | `end_of_infringement_established_on_supporting_evidence` | crisp | `true` / `false` |
| 11 | `complainant_objected_to_early_resolution_in_time` | crisp | `true` / `false` (absent while the four weeks run) |
| 12 | `early_resolution_procedure_before` | enumeration | `receiving_authority`, `lead_authority` |
| 13 | `case_handled_under_article_56_2` | outside fact | `attested(true\|false, attestation(BY, AT, REASON, EVIDENCE))` |
| 14 | `lead_authority_considers_no_reasonable_doubt_as_to_scope` | crisp | `true` / `false` |
| 15 | `issues_addressable_without_additional_cooperation` | judgement | `true` / `false` / `unsure` |
| 16 | `concerned_authority_objected_to_simple_procedure_in_time` | crisp | `true` / `false` (absent while the two weeks run) |
| 17 | `simple_cooperation_procedure_applied` | crisp | `true` / `false` |
| 18 | `draft_decision_time_limit_extended` | crisp | `true` / `false` |
| 19 | `board_request_under_article_11_6_made` | crisp | `true` / `false` |
| 20 | `extension_justified_by_exceptional_complexity` | judgement | `true` / `false` / `unsure` |
| 21 | `national_law_requires_domestic_proceedings_after_time_limit` | outside fact | `attested(...)` as row 13 |
| 22 | `time_limit_set_by_this_regulation_or_article_65_6` | outside fact | `attested(...)` as row 13 |

An `attested(...)` value given to a crisp or judgement key is `wrong_type(KEY)`. A bare value given to an outside-fact key is `wrong_type(KEY)`.

### Arguments (not profile keys)

- **STEP:** one of the 16 step atoms.
- **PART:** one of the 3 part atoms.
- **EVENT_DATE:** `date(Year, Month, Day)` of bare integers naming a real Gregorian day.

## 3. Citation-key atoms (canonical lexicon scheme, `_lexicon/citations.yaml`; never shortened)

**Article 4:**

- `eu_reg_2025_2518_art_4_1`
- `eu_reg_2025_2518_art_4_1_a`
- `eu_reg_2025_2518_art_4_1_b`
- `eu_reg_2025_2518_art_4_1_c`
- `eu_reg_2025_2518_art_4_1_d`
- `eu_reg_2025_2518_art_4_1_e`
- `eu_reg_2025_2518_art_4_2`
- `eu_reg_2025_2518_art_4_3`
- `eu_reg_2025_2518_art_4_5`
- `eu_reg_2025_2518_art_4_6`

**Article 5:**

- `eu_reg_2025_2518_art_5_1`
- `eu_reg_2025_2518_art_5_1_a`
- `eu_reg_2025_2518_art_5_1_b`
- `eu_reg_2025_2518_art_5_2`
- `eu_reg_2025_2518_art_5_2_c`
- `eu_reg_2025_2518_art_5_3`
- `eu_reg_2025_2518_art_5_4`
- `eu_reg_2025_2518_art_5_6`

**Article 6:**

- `eu_reg_2025_2518_art_6_1`
- `eu_reg_2025_2518_art_6_1_a`
- `eu_reg_2025_2518_art_6_1_b`
- `eu_reg_2025_2518_art_6_2`
- `eu_reg_2025_2518_art_6_3`
- `eu_reg_2025_2518_art_6_5`

**Article 10:**

- `eu_reg_2025_2518_art_10_3`
- `eu_reg_2025_2518_art_10_4`
- `eu_reg_2025_2518_art_10_5`

**Article 12:**

- `eu_reg_2025_2518_art_12_1`
- `eu_reg_2025_2518_art_12_2`
- `eu_reg_2025_2518_art_12_3`
- `eu_reg_2025_2518_art_12_4`
- `eu_reg_2025_2518_art_12_6`

**Articles 14, 36 and 37:**

- `eu_reg_2025_2518_art_14`
- `eu_reg_2025_2518_art_36`
- `eu_reg_2025_2518_art_37_2`

**Referral targets** (`citations.clausal`, kind target):

- `article_56_2_local_case_statement`
- `national_domestic_proceedings_statement`
- `time_limit_source_statement`

Each citation fact carries the pinned unit id, for example `32025R2518#parag_004.001` or `#point_004.001_a`, and the verbatim pinned text.

The `outside_facts:` block in the manifest maps each outside-fact key to its citation and target:

| Outside-fact key | Citation | Target |
|---|---|---|
| `case_handled_under_article_56_2` | `eu_reg_2025_2518_art_6_5` | `article_56_2_local_case_statement` |
| `national_law_requires_domestic_proceedings_after_time_limit` | `eu_reg_2025_2518_art_12_6` | `national_domestic_proceedings_statement` |
| `time_limit_set_by_this_regulation_or_article_65_6` | `eu_reg_2025_2518_art_14` | `time_limit_source_statement` |

Fetcher is `none` for all three, and the kind is `attested`.

The `referrals:` table has these rows:

| Judgement key | Citation |
|---|---|
| `complaint_concerns_right_exercised_by_request` | `eu_reg_2025_2518_art_4_3` |
| `issues_addressable_without_additional_cooperation` | `eu_reg_2025_2518_art_6_1_b` |
| `extension_justified_by_exceptional_complexity` | `eu_reg_2025_2518_art_12_3` |

It also has the three absent-outside-fact rows above. PAIRS follow THE PAIRS RULE.

## 4. Public predicates (one line each)

CITATIONS is always a set-like list of `cite(KEY)`. Every non-final status carries `CITATIONS []` and `BASIS []`.

- `complaint_admissibility(Profile, Result, Citations)`: admissible / inadmissible under the Art 4(1)(a)–(e) items that apply to who lodged. The inadmissible route cites Art 4(1), 4(2) and 4(5). The admissible route cites Art 4(1), 4(1)(a), (d), (e) and 4(5), plus (b) for a body and (c) for an Art 80(1) body. A false item decides before any absent key; then N, D, E, L, B, M are named in that order.
- `prior_request_condition(Profile, Result, Citations)`: whether the Art 4(3) prior request to the controller applies and was made. Cites Art 4(3). An unsure R refers via `open_textured(complaint_concerns_right_exercised_by_request, cite(eu_reg_2025_2518_art_4_3))` once Q is present.
- `early_resolution(Profile, Result, Citations)`: the outcome after examination for early resolution, Art 5(1)–(4), (6). The steps are H, then F, then J, then W, as in THE LIMBS, with the citations listed there.
- `simple_cooperation_procedure(Profile, Result, Basis, Citations)`: whether the lead authority MAY use the simple procedure (Art 6(1)(a), (b), 6(3), 6(5)). BASIS is `[outside_fact(case_handled_under_article_56_2, Attested)]` on every final result. Steps 1–9 of THE LIMBS: S true; then V false or A false (an absent S refers); then a missing V, A, O; then S absent refers; then A unsure refers; then O.
- `draft_decision_time_limit(Profile, Result, Basis, Citations)`: the draft decision limit `draft_decision_limit(15|12, no_extension|extension(up_to, 12|2, months))`. Outside the simple procedure: Art 12(1), (2), (3). Under the simple procedure: Art 6(1), 12(6). BASIS holds `[suspended_until_board_binding_decision?, extension_not_permitted?, outside_fact(national_law_requires_domestic_proceedings_after_time_limit, Attested)?]` in that order.
- `late_step_effect(Profile, Result, Basis, Citations)`: the Art 14 effect of a step taken after its time limit. It reads only the T outside fact; an absent T refers. Cites Art 14.
- `procedural_time_limit(Profile, Step, Limit, Citations)`: the row of THE TIME LIMITS for Step (16 rows, Arts 4(2), 4(5), 4(6), 5(2)(c), 5(3), 5(4), 6(2), 6(3), 10(3)–(5), 12(1)+(3), 12(3), 12(4), 12(6) ×2). It reads no profile key, but the profile is still input-checked.
- `temporal_application(Profile, Part, EventDate, Result, Citations)`: Chapter II applies on or after 2027-04-02 (cites Art 37(2)). Chapters III–IV and V–VI apply strictly after 2027-04-02 (cites Art 36 and Art 37(2)). It reads no profile key.
- `gdpr_procedural_regulation_input_problems(Profile, Problems)`: THE INPUT CHECK. It yields one solution for every term.
- `decide_gdpr_procedural_regulation(Profile, gdpr_procedural_regulation_verdict(Status, Citations))`: facade, the status determination of complaint admissibility. It equals `complaint_admissibility/3` and cites as that query does (Art 4(1), (2), (5) and points).
- `gdpr_procedural_regulation_status(Profile, Status)`: facade projection of the decide predicate to Status alone.
- `gdpr_procedural_regulation_checklist(Profile, Checklist)`: the Art 4(1) items as `item(RequirementId, Status, cite(Key))`, built with `eval_requirements/4` over `gdpr_procedural_regulation_requirement/4`.
  - Requirement ids: `name_and_contact_details`, `proper_constitution_proof`, `data_subject_mandate_proof`, `controller_or_processor_identification`, `infringement_description`.
  - Status: `met`, `unmet(missing_information)`, `unknown([Key])`, or `inapplicable` for (b)/(c) where the lodger is not such a body. While L is absent, (b) and (c) are `unknown([complaint_lodged_by])`.
  - Input problems give `[]`.
- `gdpr_procedural_regulation_what_if(Profile, Key, Value, Status)`: the admissibility status after setting Key to Value. Uses `what_if/5` with the closure `gdpr_procedural_regulation_status`. If `what_if/5` cannot take an attribute list, it falls back to `profile_set/3` followed by status.
- `gdpr_procedural_regulation_fixture(Name, Profile)`: the named fixture profiles (see §6). Fixtures are queried via the contract queries.

### Result constructors (exported, never called as queries; spelled exactly as the order pins them)

- `url(Url, RetrievedAt)`: the EVIDENCE term inside `attestation(BY, AT, REASON, EVIDENCE)` of an outside fact, naming a web source and when it was retrieved; copied whole into BASIS, never inspected (INTERFACE - THE OUTSIDE FACTS; outside facts cite `eu_reg_2025_2518_art_6_5`, `eu_reg_2025_2518_art_12_6`, `eu_reg_2025_2518_art_14`).
- `document(UploadId, Sha256)`: the alternative EVIDENCE term, an uploaded document and its hash; never inspected (same citations as `url/2`).
- `attested(Value, Attestation)`: the outside-fact wrapper, Value `true` or `false` (Art 6(5), Art 12(6), Art 14).
- `attestation(By, At, Reason, Evidence)`: the host-supplied statement of who attested, when, why and on what evidence; only its arity is checked (Art 6(5), Art 12(6), Art 14).
- `outside_fact(Key, Attested)`: the BASIS item copying an outside fact as supplied (Art 6(5), Art 12(6), Art 14).
- `date(Year, Month, Day)`: the EVENT_DATE argument of `temporal_application/5` (Art 36, Art 37(2)).
- `draft_decision_limit(Months, Extension)`: the result of `draft_decision_time_limit/4` (Art 12(1), (3), (6), Art 6(1)).
- `extension(Kind, Number, Unit)`: an extension, Kind `exactly` or `up_to` (Art 10(4), (5), Art 12(3), (6)).
- `limit(Number, Unit, Relation, Event, Extension)`: a row of THE TIME LIMITS (Arts 4 to 6, 10 and 12).
- `indeterminate(MissingKeys)`: one missing judgement or crisp key (no provision).
- `needs_legal_review(Reason, Context)`: a referral to a lawyer (cites the firing row of the referrals table).
- `open_textured(Input, Citation)`: the referral reason for an unsure judgement (Art 4(3), Art 6(1)(b), Art 12(3)).
- `cross_reference_unresolved(Citation, Target)`: the referral reason for an absent outside fact (Art 6(5), Art 12(6), Art 14).
- `resolution(Target, Status)`: the context item of THE ABSENT REFERRAL, Status `not_attempted`.
- `inputs_relied_on(Pairs)`: the context item listing Key-Value pairs relied on (THE PAIRS RULE).
- `input_problems(Problems)`: the step-0 result of THE INPUT CHECK (no provision).
- `unknown_key(Key)`, `wrong_type(Key)`, `duplicate_key(Key)`: the input problem terms (no provision).

## 5. Determination slice — `gdpr_procedural_regulation.clausal`

This is the only slice. It is self-contained and owns all value facts, rules, verdicts and per-rule tests.

### 5.1 Value facts owned (declared once with `:- constant_value(Name, Value).`; never inlined)

**Months and extension ceilings:**

- `draft_decision_time_limit_months` = 15 (Art 12(1))
- `draft_decision_extension_ceiling_months` = 12 (Art 12(3))
- `simple_procedure_draft_decision_time_limit_months` = 12 (Art 12(6))
- `simple_procedure_extension_ceiling_months` = 2 (Art 12(6))

**Application day (Art 37(2), Art 36):**

- `application_year` = 2027
- `application_month` = 4
- `application_day_of_month` = 2

**The table of sixteen rows.** Each row is one fact: `time_limit_row(Step, Number, Unit, Relation, Event, Extension, Citations)`. There is one clause per step atom, so a lookup yields one solution. The rows hold exactly the figures of THE TIME LIMITS:

| Row | Number and unit | Relation | Extension |
|---|---|---|---|
| 1 | 2 weeks | within | none |
| 2 | 6 weeks | within | none |
| 3 | 6 weeks | within | none |
| 4 | 4 weeks | within | none |
| 5 | 2 weeks | within | none |
| 6 | 4 weeks | within | none |
| 7 | 6 weeks | within | none |
| 8 | 2 weeks | within | none |
| 9 | 3 months | within | none |
| 10 | 4 weeks | within | exactly 2 weeks |
| 11 | 4 weeks | within | exactly 2 weeks |
| 12 | 15 months | within | up to 12 months |
| 13 | 4 weeks | at_least_before | none |
| 14 | 2 weeks | within | none |
| 15 | 12 months | within | up to 2 months |
| 16 | 2 weeks | at_least_before | none |

Row 12 cites Art 12(1) and Art 12(3). Row 13 cites Art 12(3). Rows 15 and 16 cite Art 12(6).

### 5.2 Rules / requirements

**Reification helpers** (domain-local, deterministic, three disjoint clauses each, no cut):

- `crisp_state(Profile, Key, State)`: State is `item_true`, `item_false` or `item_absent`.
- `judgement_state(Profile, Key, State)`: adds `item_unsure`.
- `enumeration_state(Profile, Key, State)`: the value, or `item_absent`.
- `outside_fact_state(Profile, Key, State)`: State is `attested_true(Attested)`, `attested_false(Attested)` or `item_absent`.

Each helper reads presence with `profile_lacks/2` / `profile_has/2`, then the value with `profile_get/3`. Duplicates cannot reach the helpers, because the input check runs first.

**Admissibility.**

- `admissibility_failure(Lodger, NameState, IdentificationState, DescriptionState, ConstitutionState, MandateState, Verdict)` is a total, disjoint decision table over the reified states.
- An `inadmissible` route exists only when some applicable item is `item_false`. It is computed as a single boolean `any_applicable_item_false/2` over a list of reified states, using `memberd/2` (no backtracking duplicates). So exactly one clause fires.
- Otherwise the `first_absent` key comes from an ordered list of `Key-State` pairs, filtered by applicability and walked by a deterministic recursion.
- Otherwise the complaint is `admissible`, with citations built from the lodger.

**Prior request.** Five disjoint clauses over (R state, Q state).

**Early resolution.** Eight disjoint clauses keyed on the first undecided state of H, F, J, W.

**Simple procedure.** Nine disjoint clauses with explicit guards that render the step order:

1. S `attested_true`.
2. (V false ∨ A false), computed as one boolean, then split on S `attested_false` versus absent.
3. V absent.
4. A absent.
5. O absent.
6. S absent.
7. A unsure.
8. O true.
9. O false.

Each later clause carries the negation of the earlier guards as state constraints, not `\+` over a disjunction.

**Draft decision.** P state and E state first.

- P false: B, then C (only when E is true), then the final assembly of BASIS and CITATIONS by route.
- P true: E false, then N absent (refers), then N attested true or false.

Figures come from `constant(...)`.

**Late step.** Three clauses on the T state.

**Time-limit lookup.** `time_limit_row/7` → `limit/5`.

**Temporal.**

- `valid_event_date(Term)`: ground `date(Y, M, D)`, integers, 1 ≤ M ≤ 12, 1 ≤ D ≤ `month_last_day(Y, M)`.
- `date_compare(date(Y, M, D), Order)`: Order is `before`, `same_day` or `after` against the application day, by integer comparison of Y, then M, then D. Three disjoint clauses.
- Mapping by part:
  - `complaints_and_early_resolution`: `same_day` or `after` gives `part_applies`.
  - The other two parts: `after` only gives `part_applies`.

**Facade requirement predicate.** `gdpr_procedural_regulation_requirement(RequirementId, Profile, Status, Citation)`, with the id FIRST. It has three clauses per requirement: met, unmet and unknown, plus `inapplicable`.

### 5.3 Verdict atoms of the slice

The slice uses all final atoms and status compounds of §1.

### 5.4 Predicates shared with another slice → `kernel.clausal`

There is no second determination slice, so nothing is shared for that reason. The kernel holds only the floor that every query, including the facade and `queries.clausal`, calls:

- `gdpr_procedural_regulation_contract_key(Key, Kind)`: the 22 keys in contract order, with kind `enumeration(Values)`, `judgement`, `crisp` or `outside_fact`.
- `gdpr_procedural_regulation_input_problems/2` and its argument extensions:
  - `step_problems(Step, Problems)`
  - `part_problems(Part, Problems)`
  - `event_date_problems(EventDate, Problems)`

  These cover the attribute-list shape test, duplicate counting (reads no value), type test per kind, and `unknown_key` in first-occurrence order. Unbound and partial terms are guarded with `var/1` / `is_list/1` tests first, so the check never raises.
- `absent_referral(Key, Result)`: builds THE ABSENT REFERRAL from the `outside_fact_entry(Key, Citation, Target)` facts.
- `open_textured_referral(Key, Citation, Result)`

## 6. Fixtures and tests (seven test modes, v2 manifest)

**Fixtures (named profiles):**

- `admissible_data_subject_complaint`
- `admissible_article_80_1_complaint`
- `inadmissible_missing_mandate`
- `inadmissible_missing_description_with_lodger_absent`
- `prior_request_not_made`
- `prior_request_unsure`
- `early_resolution_by_receiving_authority`
- `early_resolution_by_lead_authority`
- `early_resolution_objected`
- `local_case_under_article_56_2`
- `simple_procedure_available`
- `simple_procedure_objected`
- `simple_procedure_scope_doubt_without_local_statement`
- `simple_procedure_cooperation_unsure`
- `draft_decision_suspended_and_extended`
- `draft_decision_unjustified_extension`
- `simple_procedure_extension_with_national_statement`
- `simple_procedure_extension_without_national_statement`
- `late_step_under_this_regulation`
- `late_step_under_national_law`
- `malformed_profile_duplicates_and_unknown`

**Tests:**

- Every route of THE LIMBS, with the exact RESULT, BASIS and CITATIONS.
- **Counting.** `findall` plus `length(Solutions, 1)` for every query, on every fixture.
- **Boundary.**
  - 2027-04-01, 2027-04-02 and 2027-04-03, for each part.
  - Invalid dates: 2027-02-29, 2028-02-29 (valid), 1900-02-29 (invalid), 2000-02-29 (valid).
- **Irrelevance.** A key a query does not read, present or absent, does not change its answer.
- **Input check.** Unbound, partial-list and non-attribute profiles. Duplicate keys, never also `wrong_type`. Attested values given to crisp keys. Bare values given to outside facts.
- **Negative tests** paired with positive ones.
- **Mutations** in `eval/mutations.yaml`: 15 → 16, `>` → `>=` on Art 36, and swapping the missing-key / referral precedence.

## 7. Planned reuse (manifest `uses:`)

- **`formalize_lib`:**
  - `profile_get/3`, `profile_has/2`, `profile_lacks/2`, `profile_set/3`, `profile_keys/2`
  - `memberd/2`, `not_member/2`
  - `eval_requirements/4`, `item/3`
  - `attribute/2`, `unknown/1`, `unmet/1`
  - vocabulary `met`, `inapplicable`

  `check_tri/4` is used inside the requirement predicate where a tri-state check fits; no clone is written (C15).
- **`kit/deadline_lib`:** `month_last_day/3`, used for Gregorian validity of EVENT_DATE only. No end date is computed, because `period_end_dates` is deferred. Neither `deadline_months_after/3` nor any other end-date computation is used: its AU s 36 counting rule is not this Regulation's.
- **`kit/query_combinators`:** `what_if/5`, for the facade what-if.
- **`validate_props`:** `run_props/1`, `prop_totality/3`, `prop_determinism/3`, `prop_citation_complete/3`, `prop_boundary_coverage/2`, `prop_missing_key_coverage/3`, `bad_citation/1`. Used in the property test mode.
- **`library(datetime)`:** not imported yet. Native `date/3` does not exist, and `date/4` would raise on the invalid days the input check must answer without raising. The plan moves EVENT_DATE comparison to the native type when `date/3` lands (the working notes (not published)).
- **Not used, with reasons:**
  - `kit/compliance_lib`: its modality lattice does not produce the fixed result contract of (D) and (F).
  - `currency_vocab`, `vat_category`, `country`: no money, VAT or country atoms in this order.
  - `kit/rolling_window`: no look-back window.
- **Family backbone (`_common`, deontic):** none is adopted. The result contract is fixed by the order, and the attested-wrapper and referral builders stay in the kernel until promoted (the working notes (not published)).
