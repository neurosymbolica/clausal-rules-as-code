# SIGNATURE — eu/ai_act/transparency_art50

Layout (kept as scaffolded): `kernel -> citations -> parameters -> transparency_art50 -> queries -> fixtures -> package facade`. Seven test modes; v2 manifest.

## 1. Public query surface (summary)

### The called contract (scored)

- `transparency_duty_status(Profile, Duty, AssessmentDate, Result, Citations)`
- `transparency_compliance(Profile, Duty, AssessmentDate, Result, Citations)`
- `transparency_art50_input_problems(Profile, Problems)`

Each yields exactly ONE solution for every input. This is total and deterministic: the routes are disjoint, there is no cut, no `->` and no `*->`.

### The scaffold facade (kept names)

The facade wraps the called contract over a request term `transparency_art50_request(Profile, Duty, AssessmentDate)`:

- `decide_transparency_art50/2`
- `transparency_art50_status/2`
- `transparency_art50_checklist/2`
- `transparency_art50_what_if/4`
- fixtures

Imported figures: none. The statutory dates are value facts of the slice (section 6).

## 2. Verdict STATUS atoms (replace the placeholder `{ required, permitted, not_applicable }`)

Status query (`transparency_duty_status/5`):

- `duty_applies`
- `limited_disclosure_applies`
- `duty_does_not_apply`
- `not_applicable_on_date`
- `not_an_ai_system`
- `in_transitional_period`

Compliance query (`transparency_compliance/5`):

- `compliant`
- `not_compliant`
- passed through from the status ladder: `duty_does_not_apply`, `not_applicable_on_date`, `not_an_ai_system`, `in_transitional_period`

Not-final status compounds. Each is the term ITSELF, never wrapped in a list, and always comes with Citations `[]`:

- `indeterminate([Key])` — exactly one bare key atom. The bare atom `indeterminate` is never written.
- `needs_legal_review(open_textured(Key, cite(CitationKey)), [inputs_relied_on(Pairs)])` — Pairs is a flat list of `Key-Value` terms. A trailing `provenance(Clause, Citations)` is optional and unscored.
- `input_problems(Problems)` — Problems is a flat list.

Problem constructors: `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`.

Result constructors (exported, never queried): `indeterminate/1`, `needs_legal_review/2`, `open_textured/2`, `inputs_relied_on/1`, `provenance/2`, `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`.

Duty atoms (the `Duty` argument):

- `interaction_information`
- `machine_readable_marking`
- `emotion_recognition_or_biometric_categorisation_information`
- `deep_fake_disclosure`
- `public_interest_text_disclosure`

`AssessmentDate` is a ground `date(Year, Month, Day)` term of a real calendar day.

## 3. Profile keys (attribute list `[attribute(Key, Value), ...]`, read only with `profile_get/3`)

There are twenty-three keys, listed in this order, which is the order of `root_exports` and of the `input_contract` attribute_list. There are no numeric keys and no date keys in the profile.

The types are:

- **crisp** — `true` or `false`;
- **judgement** — `true`, `false` or `unsure`;
- **enumeration** — one of its two listed atoms.

| # | Key | Type |
|---|---|---|
| 1 | `intended_to_interact_directly_with_natural_persons` | crisp |
| 2 | `interaction_obvious_to_a_reasonably_well_informed_observant_and_circumspect_person` | judgement |
| 3 | `generates_synthetic_audio_image_video_or_text_content` | crisp |
| 4 | `performs_an_assistive_function_for_standard_editing` | judgement |
| 5 | `does_not_substantially_alter_the_input_data_or_its_semantics` | judgement |
| 6 | `emotion_recognition_or_biometric_categorisation_system` | judgement |
| 7 | `permitted_by_law_to_detect_prevent_or_investigate_criminal_offences` | crisp |
| 8 | `generates_or_manipulates_deep_fake_image_audio_or_video_content` | judgement |
| 9 | `generates_or_manipulates_text_published_to_inform_the_public_on_matters_of_public_interest` | judgement |
| 10 | `used_in_a_personal_non_professional_activity` | crisp |
| 11 | `authorised_by_law_to_detect_prevent_investigate_or_prosecute_criminal_offences` | crisp |
| 12 | `available_for_the_public_to_report_a_criminal_offence` | crisp |
| 13 | `content_underwent_human_review_or_editorial_control` | crisp |
| 14 | `natural_or_legal_person_holds_editorial_responsibility` | crisp |
| 15 | `ai_system` | judgement |
| 16 | `part_of_an_evidently_artistic_creative_satirical_fictional_or_analogous_work` | judgement |
| 17 | `placed_on_the_market_before_2_august_2026` | crisp |
| 18 | `required_information_given` | crisp |
| 19 | `disclosure_of_existence_appropriate_and_does_not_hamper_the_work` | judgement |
| 20 | `information_timing` | enumeration: `at_or_before_first_interaction_or_exposure` / `after_first_interaction_or_exposure` |
| 21 | `provided_in_a_clear_and_distinguishable_manner` | judgement |
| 22 | `conforms_to_the_applicable_accessibility_requirements` | judgement |
| 23 | `outputs_marked_machine_readable_and_detectable_as_artificially_generated` | judgement |

In the typed `input_contract`, `judgement` = `one_of [boolean, unsure]` and `crisp` = `boolean`. Here boolean means the atoms `true` and `false`, never a Python boolean. There is no attestation wrapper (RULINGS ruling 2 does not apply).

## 4. Citation-key atoms (canonical lexicon scheme, `_lexicon/citations.yaml`; never shortened)

| Citation key | Provision | Content |
|---|---|---|
| `eu_reg_2024_1689_art_113` | Art 113, second sentence | Date of application |
| `eu_reg_2024_1689_art_50_1` | Art 50(1) | Interaction information |
| `eu_reg_2024_1689_art_50_2` | Art 50(2) | Machine-readable marking |
| `eu_reg_2024_1689_art_50_3` | Art 50(3) | Emotion recognition / biometric categorisation information |
| `eu_reg_2024_1689_art_50_4` | Art 50(4) | Deep fakes; public-interest text |
| `eu_reg_2024_1689_art_50_5` | Art 50(5) | Time and form |
| `eu_reg_2024_1689_art_111_4` | Art 111(4) | Transitional period for marking |
| `eu_reg_2024_1689_art_3_1` | Art 3(1) | AI system |
| `eu_reg_2024_1689_art_3_4` | Art 3(4) | Deployer |

These are declared in `citations.clausal` as `citation_vocabulary/1` facts. Answers write each atom once, in a set-like list.

## 5. Public predicates (one line each)

- `transparency_duty_status(Profile, Duty, AssessmentDate, Result, Citations)`: status determination (#3). Steps (0) input problems → (1) date → (2) duty test → (3) AI system → (4) kind of duty. This is the ladder. THE UNSURE RULE applies over the duty-status query keys. + Art 113; Art 50(1)-(4); Art 111(4); Art 3(1); Art 3(4).
- `transparency_compliance(Profile, Duty, AssessmentDate, Result, Citations)`: compliance check (#13). Steps (10) input problems → (11) steps (1)-(3) of the status ladder passed through, plus marking step (4) inside the transitional window → (12) compliance test. THE UNSURE RULE applies over the compliance query keys. + Art 50(1)-(5); Art 111(4); Art 113; Art 3(1).
- `transparency_art50_input_problems(Profile, Problems)`: THE INPUT CHECK. It yields the bare flat list. The order of problems is:
  1. for each contract key in contract order, `duplicate_key(Key)` (its values are never read), else `wrong_type(Key)`;
  2. then `unknown_key(Key)` in first-occurrence order;
  3. or `[wrong_type(profile)]` alone for a non-attribute list, a partial list, an unbound term or an unbound element.

  It never fails or raises. + input contract (no provision).
- `decide_transparency_art50(Request, transparency_art50_verdict(Result, Citations))`: facade. `Request = transparency_art50_request(Profile, Duty, AssessmentDate)`. It delegates to `transparency_compliance/5`. + as the called contract.
- `transparency_art50_status(Request, Result)`: facade. It gives the Result of `transparency_duty_status/5` for the request. + Art 50(1)-(4), Art 113, Art 111(4), Art 3(1).
- `transparency_art50_checklist(Request, Checklist)`: justification (#7). For each item, in order, of the duty test, then the compliance test of the requested duty, it gives one `item(ItemId, Status, cite(CitationKey))` (formalize_lib constructor). Status is `met`, `unmet(Reason)` or `unknown([Key])`. Every item, met items included, carries its `cite(...)`. + the citation of the item's provision.
- `transparency_art50_what_if(Request, Key, Value, Result)`: what-if (#16). It gives the compliance Result with attribute `Key` set to `Value`. It goes through `what_if/5` of kit/query_combinators with the closure `transparency_art50_compliance_result(Duty, AssessmentDate)`. If `override_key/4` does not accept attribute lists, it falls back to `profile_set/3`. + as the called contract.
- `transparency_art50_fixture(Name, Request, ExpectedStatus, ExpectedCitations)`: fixtures. There are named golden cases, at least one per route of each ladder step and one per date boundary:
  - dates: 2026-08-01, 2026-08-02, 2026-12-01, 2026-12-02;
  - an unsure case for each of U1, U2 and U3;
  - each input-problem shape.

  + the citation of the deciding provision.

## 6. Determination slices

### 6.0 kernel.clausal (shared floor — ONLY predicates shared between the slice and queries.clausal / facade)

- `transparency_art50_calendar_day(Date)`: Date is a ground `date(Y, M, D)` with integer Y, M in 1..12, D in 1..LastDay, using `month_last_day/3` (kit/deadline_lib). The slice's input step and the facade both use it.
- `transparency_art50_test_outcome(Profile, Items, Outcome)`: the evaluator of THE TESTS, shared by the duty tests and the compliance tests, which the checklist in queries.clausal also reads.
  - Items are `condition(Key, Value)` or `not_both(KeyOne, ValueOne, KeyTwo, ValueTwo)`.
  - Outcome is `test_failed`, `test_open(Key)` or `test_met`.
  - FAILED if some item fails; else OPEN(first absent key of the first undetermined item, K1 before K2); else MET.
  - Three mutually exclusive clause groups, cut-free.
- `transparency_art50_item_state(Profile, Item, State)`: State is `holds`, `fails` or `undetermined(Key)`, following THE TESTS.
- `transparency_art50_unsure_settings(Profile, QueryKeys, Settings)`: the unsure judgement keys among QueryKeys that are present with `unsure`, in query-key order. It enumerates every true/false assignment as a list of profiles, built with `profile_set/3`.
- `transparency_art50_unsure_combine(Runs, QueryKeys, UnsureKeys, Referral, Result, Citations)`: applies U1 / U2 / U3 over `run(Assignment, Result, Citations)` rows.
  - Citations are compared as sets (msort of atoms).
  - U3 picks the first unsure key J for which two runs that differ only at J differ.
  - The `Referral` closure supplies `cite(C)`.
  - It is candidate kit module `unsure_rule` (see the working notes (not published)).

### 6.1 citations.clausal

The nine `citation_vocabulary/1` facts of section 4, plus `bad_citation/1` wiring for validate_props.

### 6.2 parameters.clausal

Intentionally thin. There are no shared figures. Every statutory value is owned by the slice.

### 6.3 transparency_art50.clausal (the single determination slice)

The slice holds all legal content for Art 50(1)-(5) with Arts 3(1), 3(4), 111(4) and 113.

**VALUE facts owned here** (`:- constant_value(Name, Value).`, read with `constant(Name)`):

- `transparency_art50_application_date` = `date(2026, 8, 2)` — Art 113, second sentence; the first day of application, inclusive.
- `transparency_art50_transitional_first_day` = `date(2026, 8, 2)` — Art 111(4).
- `transparency_art50_transitional_last_day` = `date(2026, 12, 1)` — Art 111(4), read under Q5; inclusive.
- Duty atoms: `transparency_art50_duty/1`, five facts.
- Contract keys and their types, in order: `transparency_art50_contract_key(Position, Key, Type)`, where Type is `crisp`, `judgement` or `enumeration([at_or_before_first_interaction_or_exposure, after_first_interaction_or_exposure])`.

**Tables owned here:**

`transparency_art50_duty_test(Duty, Items)`, five facts, exactly as THE DUTY TESTS:

- `interaction_information`: `[condition(intended_to_interact_directly_with_natural_persons, true), condition(interaction_obvious_to_a_reasonably_well_informed_observant_and_circumspect_person, false), not_both(authorised_by_law_to_detect_prevent_investigate_or_prosecute_criminal_offences, true, available_for_the_public_to_report_a_criminal_offence, false)]`
- `machine_readable_marking`: `[condition(generates_synthetic_audio_image_video_or_text_content, true), condition(performs_an_assistive_function_for_standard_editing, false), condition(does_not_substantially_alter_the_input_data_or_its_semantics, false), condition(authorised_by_law_to_detect_prevent_investigate_or_prosecute_criminal_offences, false)]`
- `emotion_recognition_or_biometric_categorisation_information`: `[condition(emotion_recognition_or_biometric_categorisation_system, true), condition(permitted_by_law_to_detect_prevent_or_investigate_criminal_offences, false), condition(used_in_a_personal_non_professional_activity, false)]`
- `deep_fake_disclosure`: `[condition(generates_or_manipulates_deep_fake_image_audio_or_video_content, true), condition(used_in_a_personal_non_professional_activity, false), condition(authorised_by_law_to_detect_prevent_investigate_or_prosecute_criminal_offences, false)]`
- `public_interest_text_disclosure`: `[condition(generates_or_manipulates_text_published_to_inform_the_public_on_matters_of_public_interest, true), condition(used_in_a_personal_non_professional_activity, false), condition(authorised_by_law_to_detect_prevent_investigate_or_prosecute_criminal_offences, false), not_both(content_underwent_human_review_or_editorial_control, true, natural_or_legal_person_holds_editorial_responsibility, true)]`

`transparency_art50_compliance_test(Duty, Items)`, five facts:

- **The information list** is `[condition(required_information_given, true), condition(information_timing, at_or_before_first_interaction_or_exposure), condition(provided_in_a_clear_and_distinguishable_manner, true), condition(conforms_to_the_applicable_accessibility_requirements, true)]`. It is used by `interaction_information`, `emotion_recognition_or_biometric_categorisation_information` and `public_interest_text_disclosure`.
- `deep_fake_disclosure`: the information list followed by `not_both(part_of_an_evidently_artistic_creative_satirical_fictional_or_analogous_work, true, disclosure_of_existence_appropriate_and_does_not_hamper_the_work, false)`.
- `machine_readable_marking`: `[condition(outputs_marked_machine_readable_and_detectable_as_artificially_generated, true)]`.

`transparency_art50_query_keys(Query, Duty, Keys)`, where Query is `status` or `compliance`: ten facts, verbatim from THE KEYS OF EACH QUERY. This fixes the unsure enumeration, the U2/U3 order and the PAIRS order.

Citation tables:

- `transparency_art50_not_applying_citations(Duty, Citations)`:
  - `interaction_information`: `[cite(eu_reg_2024_1689_art_50_1)]`
  - `machine_readable_marking`: `[cite(eu_reg_2024_1689_art_50_2)]`
  - `emotion_recognition_or_biometric_categorisation_information`: `[cite(eu_reg_2024_1689_art_50_3), cite(eu_reg_2024_1689_art_3_4)]`
  - `deep_fake_disclosure`: `[cite(eu_reg_2024_1689_art_50_4), cite(eu_reg_2024_1689_art_3_4)]`
  - `public_interest_text_disclosure`: `[cite(eu_reg_2024_1689_art_50_4), cite(eu_reg_2024_1689_art_3_4)]`
- `transparency_art50_applying_citations(Duty, Citations)`: the paragraph citation of each duty alone, one of `art_50_1`, `art_50_2`, `art_50_3`, `art_50_4`, `art_50_4`.
- `transparency_art50_compliance_citations(Duty, Citations)`:
  - `machine_readable_marking`: `[cite(eu_reg_2024_1689_art_50_2)]`
  - every other duty: its paragraph citation followed by `cite(eu_reg_2024_1689_art_50_5)`

`transparency_art50_referral(JudgementKey, cite(CitationKey), Inputs)`: twelve referral rows. Inputs is the union of the judgement keys of every query and duty whose keys hold the row's key.

| Judgement key | Citation |
|---|---|
| `interaction_obvious_to_a_reasonably_well_informed_observant_and_circumspect_person` | `art_50_1` |
| `performs_an_assistive_function_for_standard_editing` | `art_50_2` |
| `does_not_substantially_alter_the_input_data_or_its_semantics` | `art_50_2` |
| `outputs_marked_machine_readable_and_detectable_as_artificially_generated` | `art_50_2` |
| `emotion_recognition_or_biometric_categorisation_system` | `art_50_3` |
| `generates_or_manipulates_deep_fake_image_audio_or_video_content` | `art_50_4` |
| `generates_or_manipulates_text_published_to_inform_the_public_on_matters_of_public_interest` | `art_50_4` |
| `part_of_an_evidently_artistic_creative_satirical_fictional_or_analogous_work` | `art_50_4` |
| `disclosure_of_existence_appropriate_and_does_not_hamper_the_work` | `art_50_4` |
| `provided_in_a_clear_and_distinguishable_manner` | `art_50_5` |
| `conforms_to_the_applicable_accessibility_requirements` | `art_50_5` |
| `ai_system` | `art_3_1` |

**Rules / requirements** (defeasible: each paragraph is a default rule. The exceptions are defeaters checked as guarded `once/1` goals over the ground, input-checked profile, cut-free. Ground results sit in clause heads, one clause per disjoint route, per C17):

1. **Input step.** `transparency_art50_input_problems/2`, then `wrong_type(duty)` and then `wrong_type(assessment_date)` appended in `transparency_art50_request_problems(Profile, Duty, AssessmentDate, Problems)`.
2. **Date step.** `transparency_art50_before_application(AssessmentDate)` via `date_before/2` against `constant(transparency_art50_application_date)`. It gives `not_applicable_on_date` with `[cite(eu_reg_2024_1689_art_113)]`, and no profile key is read.
3. **Duty step.** `transparency_art50_test_outcome/3` over the duty test:
   - `test_failed` gives `duty_does_not_apply` with the not-applying citations;
   - `test_open(Key)` gives `indeterminate([Key])` with `[]`.
4. **AI-system step.** Read after MET only (Q13):
   - `ai_system` false gives `not_an_ai_system` with `[cite(eu_reg_2024_1689_art_3_1)]`;
   - absent gives `indeterminate([ai_system])`.
5. **Kind-of-duty step.**
   - **Deep fakes**, by the artistic key:
     - true gives `limited_disclosure_applies` with `[cite(art_50_4)]`;
     - false gives `duty_applies` with `[cite(art_50_4)]`;
     - absent gives `indeterminate([...])`.
   - **Marking inside 2026-08-02..2026-12-01**, by `placed_on_the_market_before_2_august_2026`:
     - true gives `in_transitional_period` with `[cite(art_50_2), cite(art_111_4)]`;
     - false gives `duty_applies` with `[cite(art_50_2)]`;
     - absent gives `indeterminate([placed_on_the_market_before_2_august_2026])`.
   - **Marking on or after 2026-12-02**: `duty_applies` with `[cite(art_50_2)]`, and the key is not read.
   - **The other three duties**: `duty_applies` with the applying citations.
6. **Compliance step.**
   - Steps 2-4, plus marking step 5 inside the window when it yields `in_transitional_period` or that `indeterminate`, are passed through unchanged. The artistic key is not read at this step.
   - The compliance test then gives:
     - `test_failed`: `not_compliant`;
     - `test_open(K)`: `indeterminate([K])`;
     - `test_met`: `compliant`.

     The citations are the compliance citations.
7. **Ladder entry points (no unsure judgements).** `transparency_art50_status_ladder(Profile, Duty, AssessmentDate, Result, Citations)` and `transparency_art50_compliance_ladder(...)`.
8. **Unsure wrapper.** It collects the runs with findall over `transparency_art50_unsure_settings/3`, then `transparency_art50_unsure_combine/6`. Pairs are the present judgement keys among the query keys, in query-key order, with their values as given (`unsure` included).

**Verdict atoms of this slice:** all atoms and compounds of section 2.

**Shared with another slice:** none beyond kernel section 6.0. The slice exports the called contract to `queries.clausal`, which wires the facade, the checklist and what_if.

### 6.4 queries.clausal

- Facade predicates of section 5.
- The checklist maps each test item to `item(ItemId, Status, cite(C))`. ItemId is the item's key (the first key for `not_both`). The citation is the provision the item comes from (duty paragraph, `art_3_4` for the personal-use item, `art_50_5` for the timing, manner and accessibility items).
- what_if goes through kit/query_combinators.

### 6.5 fixtures.clausal

`transparency_art50_fixture/4` golden cases (section 5).

### 6.6 Tests (seven modes)

- **Per-rule unit tests.** One positive and one paired negative for each ladder route of each duty.
- **Boundary tests.** Dates 2026-08-01 / 2026-08-02 / 2026-12-01 / 2026-12-02.
- **Missing-key coverage.** First-absent-key order, including K1 before K2.
- **Unsure rule.** U1, U2 and U3, including an unsure key outside the query keys that is never read.
- **Input check.** Duplicate, wrong type, unknown key, non-list, partial list, unbound value, non-atom key.
- **Counting.** `findall` + `length(_, 1)` for every query.
- **validate_props.** `prop_totality`, `prop_determinism`, `prop_citation_complete`, `prop_boundary_coverage`, `prop_missing_key_coverage`.

## 7. Planned reuse (manifest `uses:`)

- **`formalize_lib`:**
  - `profile_get/3`, `profile_has/2`, `profile_lacks/2`, `profile_set/3`, `profile_keys/2`
  - `memberd/2`, `not_member/2`
  - `item/3`, `unmet/1`, `unknown/1`, `attribute/2`
  - `not_defeated/3` (guarded defeaters)

  Hand-rolled `check_tri` and `eval_requirements` clones are avoided: the tri-state test evaluator differs from them, because it uses the not-both items and the first-absent-key order.
- **`kit/deadline_lib`:** `date_before/2`, `date_on_or_after/2`, `date_on_or_before/2`, `month_last_day/3` (calendar comparison and real-day validity on `date(Y, M, D)` terms; no hand-rolled day counts).
- **`kit/query_combinators`:** `what_if/5`, `override_key/4`.
- **`validate_props`:** `run_props/1`, `prop_totality/3`, `prop_determinism/3`, `prop_citation_complete/3`, `prop_boundary_coverage/2`, `prop_missing_key_coverage/3`, `bad_citation/1`.
- **Not used:**
  - `kit/compliance_lib` — the modality lattice does not fit the fixed compliance-test ladder;
  - `currency_vocab`, `vat_category`, `country` — no money and no member-state keys;
  - rolling-window modules.
