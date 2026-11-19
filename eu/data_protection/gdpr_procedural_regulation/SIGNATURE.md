# SIGNATURE — eu/data_protection/gdpr_procedural_regulation

## Public query surface

The nine contract queries are listed below. Their names, arguments and terms come exactly from THE CALLED CONTRACT. Each yields exactly ONE solution for every input.

- Each query starts with `gdpr_procedural_regulation_input_problems/2`. When PROBLEMS is non-empty it gives `input_problems(PROBLEMS)`, with BASIS `[]` where the query has BASIS, and CITATIONS `[]`.
- Clauses are disjoint routes. Ground results are folded into clause heads (C17). There is no `!`, `->` or `*->`.
- Presence of a key is tested with `profile_get/3` and `profile_lacks/2`.
- Duplicate keys are excluded beforehand by the input check, so `profile_get/3` has one witness.

The five facade predicates of the scaffold sit on top of these queries:
- `decide_gdpr_procedural_regulation/2`
- `gdpr_procedural_regulation_status/2`
- `gdpr_procedural_regulation_checklist/2`
- `gdpr_procedural_regulation_what_if/4`
- fixtures

The facade's STATUS is the **admissibility** determination (query type #3).

### Verdict STATUS atoms (these replace `required / permitted / not_applicable`)

- **Facade STATUS** (complaint_admissibility):
  - final: `admissible`, `inadmissible`;
  - non-final: `indeterminate([KEY])` or `input_problems(PROBLEMS)`.
- **prior_request_condition:** `prior_request_not_required`, `prior_request_made`, `prior_request_not_made`.
- **early_resolution:** `early_resolution_not_available`, `complaint_not_devoid_of_purpose`, `early_resolution_objected`, `resolution_established_by_receiving_authority`, `draft_decision_establishing_resolution`.
- **simple_cooperation_procedure:** `chapter_iii_not_applicable`, `simple_procedure_not_available`, `simple_procedure_excluded_by_objection`, `simple_procedure_available`.
- **draft_decision_time_limit:**
  - RESULT: `draft_decision_limit(15|12, no_extension | extension(up_to, 12|2, months))`;
  - BASIS atoms: `suspended_until_board_binding_decision`, `extension_not_permitted`.
- **late_step_effect:** `legality_and_validity_not_affected`, `not_governed_by_article_14`.
- **temporal_application:** `part_applies`, `part_does_not_apply`.
- **Status compounds** (never the bare atom `indeterminate`):
  - `indeterminate([KEY])`;
  - `needs_legal_review(open_textured(KEY, cite(C)), [inputs_relied_on([KEY-unsure])])`;
  - `needs_legal_review(cross_reference_unresolved(cite(C), cite(T)), [resolution(cite(T), not_attempted), inputs_relied_on([KEY-absent])])`;
  - `input_problems(PROBLEMS)`, with PROBLEMS made of `wrong_type/1`, `duplicate_key/1` and `unknown_key/1`.

### Profile keys (22, in root_exports / input_contract order)

The profile is an attribute list `[attribute(KEY, VALUE), ...]`. There are no numeric or date keys. Dates enter only as the EVENT_DATE argument `date(Year, Month, Day)`.

| # | Key | Type |
|---|---|---|
| 1 | complaint_lodged_by | enumeration: data_subject / article_80_1_body / article_80_2_body |
| 2 | lodging_person_name_and_contact_details_included | crisp |
| 3 | proof_of_proper_constitution_included | crisp |
| 4 | proof_of_data_subject_mandate_included | crisp |
| 5 | controller_or_processor_identification_information_included | crisp |
| 6 | alleged_infringement_description_included | crisp |
| 7 | complaint_concerns_right_exercised_by_request | judgement: true / false / unsure |
| 8 | request_made_to_controller_before_complaint | crisp |
| 9 | complaint_concerns_chapter_iii_rights | crisp |
| 10 | end_of_infringement_established_on_supporting_evidence | crisp |
| 11 | complainant_objected_to_early_resolution_in_time | crisp |
| 12 | early_resolution_procedure_before | enumeration: receiving_authority / lead_authority |
| 13 | case_handled_under_article_56_2 | outside fact: attested(true\|false, attestation(_,_,_,_)) |
| 14 | lead_authority_considers_no_reasonable_doubt_as_to_scope | crisp |
| 15 | issues_addressable_without_additional_cooperation | judgement |
| 16 | concerned_authority_objected_to_simple_procedure_in_time | crisp |
| 17 | simple_cooperation_procedure_applied | crisp |
| 18 | draft_decision_time_limit_extended | crisp |
| 19 | board_request_under_article_11_6_made | crisp |
| 20 | extension_justified_by_exceptional_complexity | judgement |
| 21 | national_law_requires_domestic_proceedings_after_time_limit | outside fact |
| 22 | time_limit_set_by_this_regulation_or_article_65_6 | outside fact |

The query arguments are STEP (one of 16 step atoms), PART (complaints_and_early_resolution, cooperation_and_files or dispute_resolution_and_urgency) and EVENT_DATE (`date(Y, M, D)` of integers). These argument names appear in the problem terms `wrong_type(step)`, `wrong_type(part)` and `wrong_type(event_date)`.

### Citation-key atoms (canonical lexicon; never shortened further)

eu_reg_2025_2518_art_4_1, eu_reg_2025_2518_art_4_1_a, eu_reg_2025_2518_art_4_1_b, eu_reg_2025_2518_art_4_1_c, eu_reg_2025_2518_art_4_1_d, eu_reg_2025_2518_art_4_1_e, eu_reg_2025_2518_art_4_2, eu_reg_2025_2518_art_4_3, eu_reg_2025_2518_art_4_5, eu_reg_2025_2518_art_4_6, eu_reg_2025_2518_art_5_1, eu_reg_2025_2518_art_5_1_a, eu_reg_2025_2518_art_5_1_b, eu_reg_2025_2518_art_5_2, eu_reg_2025_2518_art_5_2_c, eu_reg_2025_2518_art_5_3, eu_reg_2025_2518_art_5_4, eu_reg_2025_2518_art_5_6, eu_reg_2025_2518_art_6_1, eu_reg_2025_2518_art_6_1_a, eu_reg_2025_2518_art_6_1_b, eu_reg_2025_2518_art_6_2, eu_reg_2025_2518_art_6_3, eu_reg_2025_2518_art_6_5, eu_reg_2025_2518_art_10_3, eu_reg_2025_2518_art_10_4, eu_reg_2025_2518_art_10_5, eu_reg_2025_2518_art_12_1, eu_reg_2025_2518_art_12_2, eu_reg_2025_2518_art_12_3, eu_reg_2025_2518_art_12_4, eu_reg_2025_2518_art_12_6, eu_reg_2025_2518_art_14, eu_reg_2025_2518_art_36, eu_reg_2025_2518_art_37_2.

Referral targets (outside_facts):
- article_56_2_local_case_statement;
- national_domestic_proceedings_statement;
- time_limit_source_statement.

### Public predicates (one line each)

- `complaint_admissibility(Profile, Result, Citations)`: Admissible or inadmissible under the Art 4(1) items. A false item decides before any absent key is read. Missing keys are named in the order N, D, E, L, B, M. Cites Art 4(1), (1)(a)–(e) as they apply, 4(2) and 4(5). Type #3.
- `prior_request_condition(Profile, Result, Citations)`: Whether a prior request to the controller is required and was made. Order: R absent, R false, Q absent, R unsure (to a lawyer), R true. Cites Art 4(3). Type #13.
- `early_resolution(Profile, Result, Citations)`: What follows from early resolution. Keys are read in the order H, F, J, W. Cites Art 5(1), 5(1)(a)/(b), 5(2), 5(2)(c), 5(3)/(4) and 5(6).
- `simple_cooperation_procedure(Profile, Result, Basis, Citations)`: Whether the lead authority MAY use the simple procedure. BASIS is `[outside_fact(case_handled_under_article_56_2, Attested)]` when the result is final. Precedence follows steps 1–9 of THE LIMBS (Q10). Cites Art 6(1), 6(1)(a), 6(1)(b), 6(3) and 6(5). Type #13.
- `draft_decision_time_limit(Profile, Result, Basis, Citations)`: Gives `draft_decision_limit(Months, Extension)`. 15 months under Art 12(1)–(3), with the Art 12(2) suspension reported in BASIS. 12 months under Art 6(1) and 12(6). Type #15.
- `late_step_effect(Profile, Result, Basis, Citations)`: The consequence of a step taken after its time limit. Reads only the outside fact T. Cites Art 14. Type #15.
- `procedural_time_limit(Profile, Step, Limit, Citations)`: The `limit(N, Unit, Relation, Event, Extension)` row for Step, read from the table. Reads no profile key, but still runs the input check. Cites Art 4–6, 10 and 12 per row. Type #15.
- `temporal_application(Profile, Part, EventDate, Result, Citations)`: Whether Chapter II, Chapters III–IV or Chapters V–VI apply at EventDate, measured against date(2027,4,2). Cites Art 37(2), plus Art 36 for the latter two parts.
- `gdpr_procedural_regulation_input_problems(Profile, Problems)`: The typed input check. Never fails, never raises, gives one solution.
- `decide_gdpr_procedural_regulation(Profile, gdpr_procedural_regulation_verdict(Status, Citations))`: Facade. Status and Citations are exactly those of complaint_admissibility. Cites Art 4(1), 4(2), 4(5) and points.
- `gdpr_procedural_regulation_status(Profile, Status)`: Facade projection of the Status of the decide predicate.
- `gdpr_procedural_regulation_checklist(Profile, Checklist)`: The Art 4(1) items as a label-neutral checklist, built by `assess/6` over the requirement ids listed in the slice. It is a display aid only: the Status always comes from THE LIMBS, never from `decide_labeled/3`.
- `gdpr_procedural_regulation_what_if(Profile, Key, Value, Status)`: Sets `attribute(Key, Value)` with `profile_set/3`, then gives the facade Status. A changed profile is checked again by the input check.
- **Fixtures** (in fixtures.clausal): `gdpr_procedural_regulation_fixture(Name, Profile)`, with named cases covering every limb of every query. `gdpr_procedural_regulation_fixture_expectation(Name, Query, Expected)` pairs each fixture with its expected output.

### Result constructors (exported, never called as queries)

These are data terms of THE CALLED CONTRACT; they are written where needed and listed here so every file spells them alike.

- `url(Url, RetrievedAt)`: EVIDENCE form inside an outside-fact attestation, the URL the statement was retrieved from and when; never inspected beyond the unbound-variable test, copied verbatim into BASIS. Cites the outside fact's entry (Art 6(5), Art 12(6) or Art 14).
- `document(UploadId, Sha256)`: EVIDENCE form inside an attestation, an uploaded document and its hash; not inspected beyond the unbound-variable test. Cites the outside fact's entry (Art 6(5), Art 12(6) or Art 14).
- `attested(Value, Attestation)`: the outside-fact wrapper, Value true or false. Cites Art 6(5), Art 12(6) or Art 14.
- `attestation(By, At, Reason, Evidence)`: who stated the outside fact, when, why and on what evidence. Cites Art 6(5), Art 12(6) or Art 14.
- `outside_fact(Key, Attested)`: BASIS item copying a present outside fact. Cites Art 6(5), Art 12(6) or Art 14.
- `draft_decision_limit(Months, Extension)` and `extension(Kind, Number, Unit)`: the draft decision limit and its extension. Cites Art 12(1), (3) and (6).
- `limit(Number, Unit, Relation, Event, Extension)`: a row of THE TIME LIMITS. Cites the row's provision.
- `date(Year, Month, Day)`: the EVENT_DATE argument. Cites Art 36, Art 37(2).
- `indeterminate(MissingKeys)`, `needs_legal_review(Reason, Context)`, `open_textured(Input, Citation)`, `cross_reference_unresolved(Citation, Target)`, `resolution(Target, Attempt)`, `inputs_relied_on(Pairs)`: the status compounds of INTERFACE - THE STATUSES.
- `input_problems(Problems)`, `unknown_key(Key)`, `wrong_type(Key)`, `duplicate_key(Key)`: THE INPUT CHECK terms.

### Planned reuse (manifest `uses:`)

- **formalize_lib:**
  - `profile_get/3`, `profile_lacks/2`, `profile_has/2` and `profile_set/3`: profile access, keys as bare atoms;
  - `assess/6`, `item/3`, `unmet/1`, `unknown/1` and `labels/3`: the checklist;
  - `memberd/2`: the input check (the duplicate scan and unknown-key collection).
- **kit.deadline_lib:** `month_last_day/3`, used ONLY to check that EVENT_DATE is a real Gregorian day. Period end dates are deferred, so no deadline arithmetic is used.
- **kit.query_combinators:** not imported. what_if goes through `profile_set/3` because the profile is an attribute list, not a dictionary.
- **validate_props** (tests only):
  - `prop_totality/3` and `prop_determinism/3`: one solution for every fixture and query;
  - `prop_citation_complete/3`: every cite is in the vocabulary.
- **library(datetime):** not needed for computation (no date arithmetic). Dates are ground `date(Y, M, D)` terms, compared with `@<` and `@>=` after validation. Native datetime stays at the boundary, as the idiom requires; no ISO strings are hand-rolled.
- **kit.compliance_lib:** not used. The deontic outputs of #13 are fixed by the contract atoms, and a modality lattice would add extra solutions.

## Module chain

kernel → citations → parameters → gdpr_procedural_regulation → queries → fixtures → package facade.

- **parameters.clausal** holds no figures; every statutory value lives in the slice. It only re-exports nothing and stays as a scaffolded placeholder comment.
- **citations.clausal** declares the 35 citation keys and the 3 targets as `citation_vocabulary` facts.
- **queries.clausal** re-exports the nine contract predicates.
- **The facade** builds the four facade predicates on top of complaint_admissibility.

## kernel.clausal — shared floor (only what more than one module calls)

The input check is called by the slice (step 0 of every query), by queries.clausal and by the facade. The kernel therefore holds:

- `gdpr_procedural_regulation_input_problems(Profile, Problems)`, which collects:
  1. `duplicate_key` / `wrong_type`, per contract key in contract order;
  2. `unknown_key`, in first-occurrence order.

  Anything other than a proper list of `attribute/2` elements gives `[wrong_type(profile)]`. This test must be safe on variables and partial lists: use `is_list` after a groundness-safe walk, and never unify into the input.
- `gdpr_procedural_regulation_contract_key(Key, Type)`: 22 facts in contract order. Type is one of:
  - `enumeration([..])`;
  - `judgement`;
  - `crisp`;
  - `outside_fact`.
- `gdpr_procedural_regulation_value_has_type(Type, Value)`:
  - judgement accepts true, false, unsure;
  - crisp accepts true, false;
  - enumeration accepts membership;
  - outside_fact accepts `attested(V, attestation(By, At, Reason, Evidence))` with V in {true, false} and each of the four arguments ground.
  - An unbound value fails every type.
- `gdpr_procedural_regulation_absent_referral(Key, Result)`: builds THE ABSENT REFERRAL from `outside_fact_entry(Key, Citation, Target)`. The facts are:
  - case_handled_under_article_56_2 → eu_reg_2025_2518_art_6_5 / article_56_2_local_case_statement;
  - national_law_requires_domestic_proceedings_after_time_limit → eu_reg_2025_2518_art_12_6 / national_domestic_proceedings_statement;
  - time_limit_set_by_this_regulation_or_article_65_6 → eu_reg_2025_2518_art_14 / time_limit_source_statement.
- `gdpr_procedural_regulation_valid_calendar_date(EventDate)`: true when EventDate is a ground `date(Y, M, D)` of integers, M is 1..12, and D is 1..LastDay with LastDay from `month_last_day/3`.

## Slice: gdpr_procedural_regulation.clausal (self-contained)

### Value facts owned by the slice

- **Application day.**
  - `:- constant_value(application_year, 2027).`
  - `:- constant_value(application_month, 4).`
  - `:- constant_value(application_day_of_month, 2).`
  - These give DAY = `date(2027, 4, 2)` (Art 37(2), Art 36).
- **Draft decision months.**
  - `constant_value(draft_decision_months, 15)` and `constant_value(draft_decision_extension_ceiling_months, 12)`: Art 12(1) and (3).
  - `constant_value(simple_procedure_draft_decision_months, 12)` and `constant_value(simple_procedure_extension_ceiling_months, 2)`: Art 12(6).
- **The time-limit table.** Sixteen facts `time_limit_row(Step, limit(N, Unit, Relation, Event, Extension), Citations)`, verbatim from THE TIME LIMITS:
  1. declare_complaint_inadmissible: 2 weeks within receipt_of_complaint, no_extension. [art_4_2]
  2. transmit_complaint_to_presumed_lead_authority: 6 weeks within receipt_of_complaint. [art_4_5]
  3. confirm_competence_or_refer_to_board: 6 weeks within receipt_of_complaint. [art_4_6]
  4. object_to_early_resolution: 4 weeks within complainant_receiving_early_resolution_information. [art_5_2_c]
  5. establish_early_resolution: 2 weeks within expiry_of_objection_time_limit. [art_5_3]
  6. submit_early_resolution_draft_decision: 4 weeks within expiry_of_objection_time_limit. [art_5_4]
  7. notify_simple_cooperation_procedure: 6 weeks within confirmation_of_competence_or_board_binding_decision. [art_6_2]
  8. object_to_simple_cooperation_procedure: 2 weeks within notification_of_simple_cooperation_procedure. [art_6_3]
  9. provide_summary_of_key_issues: 3 months within confirmation_of_competence_or_board_binding_decision. [art_10_3]
  10. comment_on_summary_of_key_issues: 4 weeks within receipt_of_summary_of_key_issues, extension(exactly, 2, weeks). [art_10_4]
  11. respond_to_comments_on_summary_of_key_issues: 4 weeks within expiry_of_comment_period, extension(exactly, 2, weeks). [art_10_5]
  12. submit_draft_decision: 15 months within confirmation_of_competence_or_board_binding_decision, extension(up_to, 12, months). [art_12_1, art_12_3]
  13. inform_of_draft_decision_extension: 4 weeks at_least_before expiry_of_draft_decision_time_limit. [art_12_3]
  14. object_to_draft_decision_extension: 2 weeks within being_informed_of_extension. [art_12_4]
  15. submit_draft_decision_in_simple_procedure: 12 months within confirmation_of_competence_or_board_binding_decision, extension(up_to, 2, months). [art_12_6]
  16. inform_of_simple_procedure_extension: 2 weeks at_least_before expiry_of_simple_procedure_time_limit. [art_12_6]

  All rows are no_extension unless stated. Citation atoms are written in full (`eu_reg_2025_2518_...`) in the code.
- **Requirement ids** for the checklist: name_and_contact_details_requirement, proper_constitution_requirement, data_subject_mandate_requirement, controller_or_processor_identification_requirement, alleged_infringement_description_requirement.
  - Each `requirement(RequirementId, Profile, Status, Citation)` has three exclusive clauses: met / unmet / unknown.
  - The constitution and mandate requirements are `met` (inapplicable) when L makes them not apply.

### Rules (each clause one disjoint route; THE LIMBS govern)

1. **complaint_admissibility.**
   - (1) If any applicable item is false, the result is inadmissible. The route is split into disjoint clauses on the first false item, in N, D, E, B, M order, guarded by the earlier items being not false; this keeps it to one solution.
   - (2) Otherwise, the first absent key in N, D, E, L, B (when L is a body), M (when L is article_80_1_body) is named.
   - (3) Otherwise admissible, with the citations of the points that applied.
2. **prior_request_condition.** Steps 1–5 of THE LIMBS.
3. **early_resolution.** Steps 1–8 of THE LIMBS.
4. **simple_cooperation_procedure.** Steps 1–9 of THE LIMBS.
   - SB = `[outside_fact(case_handled_under_article_56_2, Attested)]`.
   - Step 2 splits into V false versus (V not false and A false) to stay disjoint.
5. **draft_decision_time_limit.** Steps 1–9.
   - BASIS order: suspended_until_board_binding_decision, then extension_not_permitted, then NB.
6. **late_step_effect.** Steps 1–3.
7. **procedural_time_limit.** The input check, then a lookup of time_limit_row.
8. **temporal_application.** The input check (profile, then step / part / event_date), then a comparison of EventDate with DAY:
   - for complaints_and_early_resolution: `@>=` gives part_applies, `@<` gives part_does_not_apply;
   - for the other two parts: `@>` gives part_applies, `@=<` gives part_does_not_apply.

### Verdict atoms of the slice

All result, BASIS, LIMIT, EXTENSION, step, part and event atoms are listed in the Public query surface, and all are exported from root_exports together with the keys, enumeration atoms, `unsure`, `absent` and `not_attempted`.

### Shared predicates

The slice shares only the kernel predicates listed above: the input check, the key contract, type tests, the absent referral and calendar-date validity. Everything else is local to the slice.

## Tests (seven modes; per-rule)

- **Coverage:** one positive and one paired negative test per limb of every query, plus every row of the table.
- **Date boundaries:**
  - date(2027,4,1), date(2027,4,2) and date(2027,4,3) for each part;
  - date(2028,2,29) is valid;
  - date(2027,2,29) and date(2100,2,29) give wrong_type(event_date).
- **Input check:** duplicate, unknown, non-atom key, unbound profile, partial list, attested value on a crisp key, unbound attestation argument.
- **Precedence:** missing key versus absent outside fact versus unsure judgement in simple_cooperation_procedure (Q10).
- **Determinism:** `findall` / `length` equals 1 for every query on every fixture.
- **Irrelevance:** a key the query does not read never changes its answer.
