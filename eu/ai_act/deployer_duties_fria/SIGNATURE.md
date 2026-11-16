# SIGNATURE — eu/ai_act/deployer_duties_fria

Predicate prefix: `deployer_duties_fria_`.

Shape family: deontic.

Layout:

`kernel -> citations -> parameters -> deployer_duties_fria -> queries -> fixtures -> package facade`

File names and modules are unchanged.

## 1. Public query surface (summary)

The contracted queries are:
- `deployer_obligation_status/5`
- `log_retention_period_status/5`
- `deployer_duties_fria_input_problems/2`

The scaffold facade (`decide_deployer_duties_fria/2`, `deployer_duties_fria_status/2`, `deployer_duties_fria_checklist/2`, `deployer_duties_fria_what_if/4`, fixtures) takes a REQUEST term. It delegates to the contracted queries, so the two can never disagree. The REQUEST terms are:

- `obligation_request(Profile, Obligation, AssessmentDate)` routes to `deployer_obligation_status/5`.
- `retention_request(Profile, RetentionMonths, AssessmentDate)` routes to `log_retention_period_status/5`.

A REQUEST that is neither term answers `input_problems([wrong_type(request)])`.

Totality and determinism: every query yields EXACTLY ONE solution for every input term, unbound ones included. It is never a duplicate solution, never a failure and never an exception. This is proven by validate_props `prop_totality/3` and `prop_determinism/3`, with `findall` and `length(_, 1)`.

## 2. Verdict STATUS atoms (replace placeholder `{required, permitted, not_applicable}`)

Final RESULT atoms of `deployer_obligation_status/5`:
- `not_applicable_on_date`
- `not_a_deployer`
- `not_a_high_risk_ai_system`
- `obligation_does_not_apply`
- `information_under_article_13_of_directive_2016_680`
- `compliance_required_by_31_december_2030`
- `existing_system_without_significant_changes_not_covered`
- `compliance_required_by_2_august_2030`
- `obligation_applies`

Final RESULT atoms of `log_retention_period_status/5`:
- `not_applicable_on_date`
- `not_a_deployer`
- `not_a_high_risk_ai_system`
- `obligation_does_not_apply`
- `compliance_required_by_31_december_2030`
- `existing_system_without_significant_changes_not_covered`
- `compliance_required_by_2_august_2030`
- `period_set_by_other_union_or_national_law`
- `retention_period_of_at_least_six_months`
- `retention_period_shorter_than_six_months`

Not-final status compounds always carry CITATIONS `[]`. Each is the RESULT term itself, never wrapped in a list:
- `input_problems(Problems)`
- `indeterminate([Key])`: exactly one bare key. The bare atom `indeterminate` is NEVER written.
- `needs_legal_review(open_textured(Key, cite(CitationKey)), [inputs_relied_on(Pairs)])`: an optional trailing `provenance(Clause, Citations)` may follow.

The constructors are exported as result constructors, never called as queries:
- `date/3`
- `indeterminate/1`
- `needs_legal_review/2`
- `open_textured/2`
- `inputs_relied_on/1`
- `provenance/2`
- `input_problems/1`
- `unknown_key/1`
- `wrong_type/1`
- `duplicate_key/1`

OBLIGATION atoms (never enumerated by the queries):
- `log_retention`
- `information_of_workers_and_their_representatives`
- `information_of_natural_persons_subject_to_decisions`
- `fundamental_rights_impact_assessment`
- `notification_of_assessment_results`

## 3. Profile keys (input_contract order = root_exports order = decision order)

PROFILE is `[attribute(Key, Value), ...]`, read only with `profile_get/3`. Types:
- `crisp` = boolean: the atoms `true` and `false`.
- `judgement` = one_of boolean or unsure: `true`, `false` or `unsure`.

| # | key | type |
|---|---|---|
| 1 | `deployer_of_the_system` | crisp |
| 2 | `system_is_a_high_risk_ai_system_listed_in_annex_iii` | crisp |
| 3 | `system_is_a_high_risk_ai_system_under_article_6_1_and_annex_i` | crisp |
| 4 | `logs_automatically_generated_by_the_system_under_the_deployers_control` | crisp |
| 5 | `union_or_national_law_provides_otherwise_on_the_log_retention_period` | crisp |
| 6 | `deployer_is_an_employer` | crisp |
| 7 | `put_into_service_or_used_at_the_workplace` | crisp |
| 8 | `makes_or_assists_in_making_decisions_related_to_natural_persons` | judgement |
| 9 | `used_for_law_enforcement_purposes` | crisp |
| 10 | `system_listed_under_point_2_of_annex_iii` | crisp |
| 11 | `body_governed_by_public_law` | judgement |
| 12 | `private_entity_providing_public_services` | judgement |
| 13 | `system_listed_under_point_5_b_of_annex_iii` | crisp |
| 14 | `system_listed_under_point_5_c_of_annex_iii` | crisp |
| 15 | `exempt_from_notification_in_the_case_of_article_46_1` | crisp |
| 16 | `component_of_an_annex_x_large_scale_it_system_placed_on_the_market_or_put_into_service_before_2_august_2027` | crisp |
| 17 | `placed_on_the_market_or_put_into_service_before_the_chapter_iii_date` | crisp |
| 18 | `significant_changes_in_design_as_from_the_chapter_iii_date` | judgement |
| 19 | `intended_to_be_used_by_public_authorities` | judgement |

The non-profile arguments are:
- `AssessmentDate`: a ground `date(Year, Month, Day)` of a real calendar day, Year 1..9999.
- `RetentionMonths`: a non-negative integer number of whole months (unit-suffixed in the slice as `retention_period_months`).
- `Obligation`: one of the five atoms.

There are no money figures. Every numeric threshold is an integer: months.

QUERY KEYS, in decision order:
- `deployer_obligation_status/5`: keys 1-4 and 6-19. That is all nineteen except key 5. They are the same for every OBLIGATION.
- `log_retention_period_status/5`: keys 1, 2, 3, 4, 5, 16, 17, 18, 19.

## 4. Citation-key atoms (citations.clausal; canonical lexicon scheme, never shortened)

| atom | unit |
|---|---|
| `eu_reg_2024_1689_art_3_4` | `02024R1689-20260727#point_003_4` |
| `eu_reg_2024_1689_art_26_6` | `#parag_026.006` |
| `eu_reg_2024_1689_art_26_7` | `#parag_026.007` |
| `eu_reg_2024_1689_art_26_11` | `#parag_026.011` |
| `eu_reg_2024_1689_art_27_1` | `#parag_027.001` |
| `eu_reg_2024_1689_art_27_2` | `#parag_027.002` |
| `eu_reg_2024_1689_art_27_3` | `#parag_027.003` |
| `eu_reg_2024_1689_art_111_1` | `#parag_111.001` |
| `eu_reg_2024_1689_art_111_2` | `#parag_111.002` |
| `eu_reg_2024_1689_art_113_c` | `#point_113_c` |
| `eu_reg_2024_1689_art_113_c_i` | `#point_113_c_i` |
| `eu_reg_2024_1689_art_113_c_ii` | `#point_113_c_ii` |

Each is declared in `citation_vocabulary` and emitted only as `cite(Atom)`.

CITATIONS is a set-like flat list: each atom appears once, and order is not scored. Lists are joined with a duplicate-free union. An example is `[cite(eu_reg_2024_1689_art_111_1)]` joined with the applying citations.

## 5. Public predicates (one line each)

Contracted queries (queries.clausal; logic in the slice):
- `deployer_obligation_status(Profile, Obligation, AssessmentDate, Result, Citations)`: whether one of the five deployer obligations applies on the day. The answer comes from the ladder with steps (0)-(10), then THE STATUS RULE. Cites Arts 3(4), 26(6), 26(7), 26(11), 27(1)-(3), 111(1), (2), 113(c)(i), (ii).
- `log_retention_period_status(Profile, RetentionMonths, AssessmentDate, Result, Citations)`: query types #13 compliance_check and #15. Says whether keeping logs RetentionMonths whole months meets the Art 26(6) minimum, with steps (0)-(11). Cites Arts 3(4), 26(6), 111, 113(c).
- `deployer_duties_fria_input_problems(Profile, Problems)`: THE INPUT CHECK. Problems is the bare flat list, in this order: `duplicate_key`/`wrong_type` per contract key, then `unknown_key` by first occurrence; or `[wrong_type(profile)]`. The check never fails or raises. Input contract (no provision).

Query-type predicates (queries.clausal):
- `deployer_duties_fria_obligation_status(Request, Result)`: #14 obligation_surfacing. Gives the RESULT for an `obligation_request`. The caller surfaces all five by asking per OBLIGATION atom; fixtures cover each. Cites Arts 26, 27.
- `deployer_duties_fria_chapter_iii_date(Profile, ChapterThreeDate)`: #15 deadline. Gives `date(2027, 12, 2)` when key 2 is `true`, `date(2028, 8, 2)` when key 2 is `false`. If key 2 is absent or ill-typed there is no solution, and the caller first runs the input check. It returns no structured record beyond `date/3`. Cites Art 113(c)(i), (ii).
- `deployer_duties_fria_compliance_check(Request, Result)`: #13. Gives the RESULT for a `retention_request` (proposed retention period). Cites Art 26(6).
- `deployer_duties_fria_checklist(Request, Checklist)`: #7 justification. Gives a list of `item(StepId, Status, cite(Key))`, one per ladder step reached. Status is `met` / `unmet(Reason)` / `unknown([Key])`, and met items are cited too. It is built with formalize_lib `eval_requirements/4` over the slice's `deployer_duties_fria_requirement/4`, which takes (RequirementId, Request, Status, Citation).

Scaffold facade (package facade):
- `decide_deployer_duties_fria(Request, deployer_duties_fria_verdict(Result, Citations))`: the package verdict, exactly the contracted query's RESULT and CITATIONS.
- `deployer_duties_fria_status(Request, Result)`: the RESULT alone.
- `deployer_duties_fria_what_if(Request, Key, Value, Result)`: the RESULT after overriding one profile key, using formalize_lib `profile_set/3` with `attribute(Key, Value)`. The new value passes through the input check; an ill-typed override gives `input_problems`.
- `deployer_duties_fria_fixture(FixtureName, Request, ExpectedResult)` (fixtures.clausal): named cases for every RESULT atom, every status compound and each boundary day (see §7).

## 6. Determination slice: deployer_duties_fria.clausal

This is the only determination slice. It is self-contained for the deployer-duty and FRIA concept.

### 6.1 Statutory VALUE facts it owns

Each is declared once with `:- constant_value(Name, Value).` and read with `constant(Name)`.

| constant | value | source |
|---|---|---|
| `chapter_iii_application_date_annex_iii` | `date(2027, 12, 2)` | Art 113(c)(i) |
| `chapter_iii_application_date_annex_i` | `date(2028, 8, 2)` | Art 113(c)(ii) |
| `large_scale_it_system_compliance_date` | `date(2030, 12, 31)` | Art 111(1) |
| `public_authority_system_compliance_date` | `date(2030, 8, 2)` | Art 111(2) |
| `minimum_log_retention_period_months` | `6` (integer) | Art 26(6) |

The slice also owns the following tables as facts:
- `obligation_atom/1`: the five atoms.
- `applying_citations/2` and `not_applying_citations/2`: per OBLIGATION, from THE LIMBS.
- `obligation_read_keys/2`: per OBLIGATION, the keys its ladder can read. This bounds the completion enumeration exactly, because an unread key never matters.
- `referral_citation/2`, mapping each judgement key to its citation:
  - `makes_or_assists_in_making_decisions_related_to_natural_persons` → `art_26_11`;
  - `body_governed_by_public_law` → `art_27_1`;
  - `private_entity_providing_public_services` → `art_27_1`;
  - `significant_changes_in_design_as_from_the_chapter_iii_date` → `art_111_2`;
  - `intended_to_be_used_by_public_authorities` → `art_111_2`.

The read-key sets are:

| OBLIGATION | read keys |
|---|---|
| common to all | 1, 2, 3, 16, 17, 18, 19 |
| `log_retention` | common + 4 |
| `information_of_workers_and_their_representatives` | common + 6, 7 |
| `information_of_natural_persons_subject_to_decisions` | common + 8, 9 |
| `fundamental_rights_impact_assessment` | common + 10, 11, 12, 13, 14 |
| `notification_of_assessment_results` | common + 10-15 |
| `log_retention_period_status` | the full query keys |

### 6.2 Rules / requirements (the ladder on a COMPLETE profile)

Requirement ids, in step order:

| step | requirement id | rule |
|---|---|---|
| 1 | `general_application_date` | ASSESSMENT_DATE before 2 Dec 2027 gives `not_applicable_on_date` [113_c, 113_c_i, 113_c_ii] |
| 2 | `deployer_role` | key 1 false gives `not_a_deployer` [3_4] |
| 3 | `high_risk_classification` | keys 2 and 3 false give `not_a_high_risk_ai_system` [applying citations; for retention, 26_6] |
| 4 | `annex_i_application_date` | ANNEX I ONLY and before 2 Aug 2028 give `not_applicable_on_date` [113_c, 113_c_ii] |
| 5 | `obligation_conditions` | the NOT-APPLYING TEST of OBLIGATION gives `obligation_does_not_apply` [not-applying citations]; for retention, key 4 false, [26_6] |
| 6 | `large_scale_it_system_transition` | the ANNEX X TEST gives `compliance_required_by_31_december_2030` [111_1 + applying] |
| 7 | `existing_system_not_covered` | the NOT COVERED TEST gives `existing_system_without_significant_changes_not_covered` [111_2] |
| 8 | `public_authority_transition` | the PUBLIC AUTHORITIES TEST gives `compliance_required_by_2_august_2030` [111_2 + applying] |
| 9 | `law_enforcement_information_rule` | natural persons only, key 9 true, gives `information_under_article_13_of_directive_2016_680` [26_11] |
| 10 | `obligation_applies` | otherwise, `obligation_applies` [applying citations] |

For `log_retention_period_status/5`, steps 9-11 are instead:
- (9) `other_law_on_retention_period`: key 5 true gives `period_set_by_other_union_or_national_law` [26_6].
- (10) `minimum_retention_period`: RetentionMonths `>=` `constant(minimum_log_retention_period_months)` gives `retention_period_of_at_least_six_months` [26_6].
- (11) otherwise `retention_period_shorter_than_six_months` [26_6].

Named tests, written as private predicates that succeed or fail on a complete profile:
- `impact_assessment_test`: ALL(key 2 true, key 10 false, ANY(11 true, 12 true, 13 true, 14 true)).
- `annex_i_only_test`: key 2 false and key 3 true.
- `not_high_risk_test`: keys 2 and 3 both false.
- `annex_x_test`: key 16 true and ASSESSMENT_DATE before 2030-12-31.
- `existing_system_test`: key 16 false, key 17 true and key 18 false.
- `not_covered_test`: the existing system test and key 19 false.
- `public_authorities_test`: the existing system test, key 19 true and the date before 2030-08-02.

DEFEASIBLE FORM (cut-free):
- Each step is a rule `ladder_answer(Step, Request, Result, Citations)` with the ground Result folded into the head (C17), one clause per disjoint route.
- A later step is guarded by `not_defeated(StepId, Request, earlier_step_fires)` from formalize_lib. This is a guarded `once/1` defeater check: an earlier step whose test is MET defeats every later step.
- Steps 9 and 10 of the obligation ladder are defeasible defaults. Law enforcement defeats `obligation_applies`. The Art 111 answers defeat both.
- There is no `!`, no `->` and no `*->`.

STATUS LAYER, in this order:
1. Input problems first: profile problems, then `wrong_type(obligation)` or `wrong_type(retention_months)`, then `wrong_type(assessment_date)`.
2. Otherwise the slice builds the varying set: the absent query keys plus the unsure judgement query keys, restricted to `obligation_read_keys`. It enumerates completions over it (at most 2^14) and evaluates the ladder per completion.
3. (S1) If there is one distinct answer (Result plus citation SET), that answer.
4. (S2) Otherwise, the first absent key in decision order that MATTERS and is not BEHIND another absent key, as `indeterminate([Key])`. A key matters when it has a witness pair of completions differing only in that key.
5. (S3) Otherwise, the first unsure judgement that matters, as `needs_legal_review(open_textured(Key, cite(referral_citation)), [inputs_relied_on(Pairs)])`. Pairs are the present judgement query keys in root_exports order, values as given, `unsure` included.

The set-based comparison yields one solution: results are collected with findall and the decision is a single deterministic clause chain.

### 6.3 Verdict atoms

The verdict atoms are exactly those in §2, for both queries.

### 6.4 Predicates SHARED with another slice (kernel.clausal)

There is only one determination slice, so nothing is shared slice-to-slice. kernel.clausal holds only the floor that queries.clausal, the facade and fixtures also need:
- `deployer_duties_fria_calendar_day(Term)`: succeeds on a ground `date(Y, M, D)` of a real day, Y 1..9999, using `month_last_day/3`.
- `deployer_duties_fria_day_before(Earlier, Later)`: wraps kit/deadline_lib `date_before/2`; it is called only after the calendar-day check.
- `deployer_duties_fria_citation_union(ListA, ListB, Union)`: the set-like join.
- The generic completion and 'matters'/'behind' engine, `status_from_completions(VaryingKeys, AnswerClosure, DecisionOrder, ReferralClosure, Result, Citations)`. This is the kit-candidate noted in the working notes (not published) §3.

### 6.5 Other modules (unchanged names)

- **citations.clausal**: `citation_vocabulary/1` and `citation_unit/2` facts (§4).
- **parameters.clausal**: the typed input_contract, i.e. `input_contract_key(Position, Key, Type)` for the nineteen keys (§3), and the root_exports key order. It holds NO statutory figure; those live in the slice. It also holds THE INPUT CHECK implementation:
  - a structural list walk, because the input check must see duplicates and non-atom keys, which profile_get/3 cannot;
  - `memberd/2` and `not_member/2` from formalize_lib.
- **queries.clausal**: the contracted and query-type predicates of §5.
- **fixtures.clausal**: §7.
- **The facade**: re-exports.

## 7. Tests (seven modes; v2 manifest)

1. **load**: every module loads and every export resolves.
2. **unit / per-rule**: one positive and one paired negative test per ladder step and per OBLIGATION.
3. **boundary**: the boundary days below, each tested on its day and on the day before:
   - 2027-12-01 / 2027-12-02;
   - 2028-08-01 / 2028-08-02;
   - 2030-08-01 / 2030-08-02;
   - 2030-12-30 / 2030-12-31;
   - RetentionMonths 5 / 6 / 0.

   Boundary coverage uses `prop_boundary_coverage/2`.
4. **status**: tests for the following, with `prop_missing_key_coverage/3`:
   - `indeterminate` naming the first non-behind key (Q9: point 2 key missing for a 5(b) deployer);
   - `needs_legal_review` for each judgement key with its citation;
   - a missing key preferred over an unsure judgement.
5. **input**: duplicate, wrong_type, unknown_key (non-atom key), non-list, partial list, unbound value, bad date (2027-02-30), bad obligation, negative or float months, and the problem ordering.
6. **properties**: `prop_totality/3`, `prop_determinism/3` (findall with `length(_, 1)`), `prop_citation_complete/3` (every cite in citation_vocabulary, `bad_citation/1`), and `prop_monotone/5` on RetentionMonths.
7. **fixtures / golden**: every `deployer_duties_fria_fixture/3` reproduces through `decide_deployer_duties_fria/2`.

## 8. Planned reuse (manifest `uses:`)

**formalize_lib:**
- `profile_get/3`, `profile_has/2`, `profile_lacks/2`, `profile_set/3`
- `memberd/2`, `not_member/2`
- `not_defeated/3`
- `eval_requirements/4`
- `item/3`, `unmet/1`, `unknown/1`
- `attribute/2`

**kit.deadline_lib:**
- `date_before/2`
- `month_last_day/3`

**kit.query_combinators:**
- `diff_checklists/3`: to report which steps change in `deployer_duties_fria_what_if/4` tests

**validate_props:**
- `run_props/1`
- `prop_totality/3`, `prop_determinism/3`
- `prop_citation_complete/3`
- `prop_boundary_coverage/2`
- `prop_missing_key_coverage/3`
- `prop_monotone/5`
- `bad_citation/1`

**Not used, with reasons:**
- kit.compliance_lib: its deny-overrides lattice does not fit an ordered exclusive ladder (the working notes (not published) §3).
- library(datetime) `date/4` objects: the contract fixes ground `date(Y, M, D)` terms, so the calendar check goes through deadline_lib.
- currency_vocab and vat_category: no money is involved.
