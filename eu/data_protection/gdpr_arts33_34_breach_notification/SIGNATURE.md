# SIGNATURE — eu/data_protection/gdpr_arts33_34_breach_notification

## Public query surface

The called contract names below are non-negotiable and stay unprefixed, as the interface states. The predicate prefix gdpr_arts33_34_breach_notification_ is used for the input check and the what-if facade.

Totality and determinism:

- Every public query yields **exactly one solution** for every argument pattern, including ill-typed ones. Ill-typed arguments give `input_problems/1`.
- No public query raises an error.
- Guards are disjoint and written in heads and bodies. There is no cut, no `->` and no `*->`.

Statutory figures are declared once as `constant_value/2` in the slice and read with `constant/1`. No figure is imported from another domain.

Layout: kernel -> citations -> parameters -> breach_notification_verdict -> queries -> fixtures -> package facade. File and module names are unchanged.

## Verdict STATUS atoms (replace scaffold `satisfied` / `not_satisfied`)

### Final answers

- **VERDICT:**
  - `eligible`
  - `ineligible`
  - `notification_requirement_not_met(without_undue_delay)`
  - `notification_requirement_not_met(reasons_for_delay)`
- **OBLIGATION:** a non-empty list of duty terms, using these duty constructors (arity 1, argument `cite(KEY)`):
  - `no_notification_required/1`
  - `notify_supervisory_authority/1`
  - `notify_controller/1`
  - `document_breach/1`
  - `communicate_to_data_subject/1`
  - `no_communication_required/1`
  - `public_communication_or_similar_measure/1`

  A DEFAULTED list adds one last item `inputs_relied_on([supervisory_authority_decision_on_communication-no_decision])`.
- **RESULT (content checks):**
  - `all_requirements_met`
  - `requirements_not_met(ITEMS)`
  - `information_to_follow_in_phases(ITEMS)` (authority notification only)
- **DEADLINE:** `date(Y, M, D)`.
- **PERIOD_END:** `period_end(date(Y, M, D), END_HOUR)`.
- **HOURS:** the integer `72`.

### Non-final answers (exactly one per answer)

- `indeterminate(MISSING_KEYS)`. The bare atom `indeterminate` is never written.
- `needs_legal_review(open_textured(KEY, cite(CITATION_KEY)), CONTEXT)`.
- `input_problems(PROBLEMS)`, whose items are:
  - `duplicate_key/1`
  - `wrong_type/1`
  - `unknown_key/1`
  - `contradictory_inputs/1`

### Context terms

- `inputs_relied_on(PAIRS)`, each pair `KEY-VALUE`.
- `provenance(CLAUSE, CITATIONS)`: unscored, allowed only last, and only in CONTEXT ELSEWHERE.

### Item atoms

- **Authority notification:**
  - `nature_of_breach`
  - `categories_and_approximate_numbers`
  - `contact_point`
  - `likely_consequences`
  - `measures_taken_or_proposed`
  - `mitigation_measures`
- **Data-subject communication:**
  - `without_undue_delay`
  - `nature_of_breach_in_clear_and_plain_language`
  - `contact_point`
  - `likely_consequences`
  - `measures_taken_or_proposed`
  - `mitigation_measures`

### Enumeration atoms

- party_role: `controller`, `processor`.
- supervisory_authority_decision_on_communication: `no_decision`, `required_communication`, `decided_point_a_condition_met`, `decided_point_b_condition_met`, `decided_point_c_condition_met`.
- The judgement value `unsure`.

The atoms `true` and `false` are NEVER pinned in verdict_vocabulary or root_exports.

### Result constructors (exported, never called as queries)

input_problems/1, unknown_key/1, wrong_type/1, duplicate_key/1, contradictory_inputs/1, no_notification_required/1, notify_supervisory_authority/1, notify_controller/1, document_breach/1, communicate_to_data_subject/1, no_communication_required/1, public_communication_or_similar_measure/1, notification_requirement_not_met/1, period_end/2, requirements_not_met/1, information_to_follow_in_phases/1, indeterminate/1, needs_legal_review/2, open_textured/2, inputs_relied_on/1, provenance/2.

## Profile keys (25, in root_exports / input_contract order)

PROFILE is `[attribute(KEY, VALUE), ...]`, read only with `profile_get/3`. Types: J = judgement (`true` / `false` / `unsure`), C = crisp (`true` / `false`), E = enumeration.

| # | Key | Type | Source |
|---|---|---|---|
| 1 | `breach_unlikely_to_result_in_risk` | J | Art 33(1) |
| 2 | `breach_likely_to_result_in_high_risk` | J | Art 34(1) |
| 3 | `delay_justified_by_reasons` | J | Art 33(1), second sentence |
| 4 | `party_role` | E: controller, processor | Art 33(1) and (2) |
| 5 | `notification_made_without_undue_delay` | J | Art 33(1) |
| 6 | `notification_accompanied_by_reasons_for_delay` | C | Art 33(1), second sentence |
| 7 | `supervisory_authority_decision_on_communication` | E: five atoms | Art 34(4); defaulted when absent in notification_obligation/2 only |
| 8 | `appropriate_protection_measures_applied_to_affected_data` | J | Art 34(3)(a) |
| 9 | `subsequent_measures_ensure_high_risk_no_longer_likely` | J | Art 34(3)(b) |
| 10 | `communication_would_involve_disproportionate_effort` | J | Art 34(3)(c) |
| 11 | `notification_describes_nature_of_breach` | C | Art 33(3)(a) |
| 12 | `notification_gives_categories_and_approximate_numbers` | C | Art 33(3)(a) |
| 13 | `categories_and_approximate_numbers_possible` | J | Art 33(3)(a), 'where possible' |
| 14 | `notification_gives_contact_point` | C | Art 33(3)(b) |
| 15 | `notification_describes_likely_consequences` | C | Art 33(3)(c) |
| 16 | `notification_describes_measures_taken_or_proposed` | C | Art 33(3)(d) |
| 17 | `notification_describes_mitigation_measures` | C | Art 33(3)(d) |
| 18 | `mitigation_measures_appropriate` | J | Art 33(3)(d), 'where appropriate' |
| 19 | `information_not_possible_to_provide_at_the_same_time` | J | Art 33(4) |
| 20 | `communication_made_without_undue_delay` | J | Art 34(1) |
| 21 | `communication_describes_nature_in_clear_and_plain_language` | J | Art 34(2) |
| 22 | `communication_gives_contact_point` | C | Art 34(2) with Art 33(3)(b) |
| 23 | `communication_describes_likely_consequences` | C | Art 34(2) with Art 33(3)(c) |
| 24 | `communication_describes_measures_taken_or_proposed` | C | Art 34(2) with Art 33(3)(d) |
| 25 | `communication_describes_mitigation_measures` | C | Art 34(2) with Art 33(3)(d) |

The following are argument names, NOT profile keys:

- `awareness_date`: AWARE, a `date(Year, Month, Day)` term of integers, as a UTC calendar day.
- `awareness_hour`: AWARENESS_HOUR, an integer from 0 to 23, the UTC clock hour.
- `hours_elapsed`: HOURS_ELAPSED, a non-negative integer, unit hours begun, with a partial hour rounded up.

`wrong_type(profile)` names the whole PROFILE argument.

### contradictory_combinations

1. `[breach_unlikely_to_result_in_risk-true, breach_likely_to_result_in_high_risk-true]`
2. `[delay_justified_by_reasons-true, notification_accompanied_by_reasons_for_delay-false]`

## Citation-key atoms (citations.clausal)

These use the canonical scheme of `_lexicon/citations.yaml`. Each is emitted only as `cite(KEY)`. Spellings are to be verified against the lexicon in the citations phase, and no shortened atom is ever invented.

**Load-bearing (emitted in answers):**

- `eu_reg_2016_679_art_33_1`: notification to the authority; risk threshold; 72 hours; reasons.
- `eu_reg_2016_679_art_33_2`: processor notifies controller.
- `eu_reg_2016_679_art_33_3_a`: nature, categories and numbers ('where possible').
- `eu_reg_2016_679_art_33_3_d`: measures and mitigation ('where appropriate').
- `eu_reg_2016_679_art_33_4`: information in phases.
- `eu_reg_2016_679_art_33_5`: documentation.
- `eu_reg_2016_679_art_34_1`: communication to the data subject; high risk; undue delay.
- `eu_reg_2016_679_art_34_2`: content and clear and plain language.
- `eu_reg_2016_679_art_34_3_a`, `eu_reg_2016_679_art_34_3_b`, `eu_reg_2016_679_art_34_3_c`: the exemptions.
- `eu_reg_2016_679_art_34_4`: decision of the authority.

**Declared for provenance and checklists (point-level content and periods):**

- `eu_reg_2016_679_art_33_3`
- `eu_reg_2016_679_art_33_3_b`
- `eu_reg_2016_679_art_33_3_c`
- `eu_reg_1971_1182_art_3_1`
- `eu_reg_1971_1182_art_3_2_a`
- `eu_reg_1971_1182_art_3_3`
- `eu_reg_1971_1182_art_3_4`

**Deferred (declared, cited by no rule):**

- `eu_reg_1971_1182_art_3_5`
- `eu_reg_1971_1182_art_1`

## Public predicates

- `authority_notification_deadline(AwarenessDate, DeadlineDate, PeriodHours)`: DeadlineDate is AwarenessDate plus three calendar days; PeriodHours is always 72. An AwarenessDate that is not a real day, or one in 29 to 31 December 9999, gives `input_problems([wrong_type(awareness_date)])`. Cites eu_reg_2016_679_art_33_1 and eu_reg_1971_1182_art_3_1 / 3_2_a / 3_3 / 3_4.
- `authority_notification_period_end(AwarenessDate, AwarenessHour, PeriodEnd)`: `period_end(Day, AwarenessHour + 1)`, where Day is AwarenessDate plus three days. Otherwise it gives `input_problems([wrong_type(awareness_date)?, wrong_type(awareness_hour)?])`. Cites eu_reg_2016_679_art_33_1 and eu_reg_1971_1182_art_3_1 / 3_2_a.
- `notification_obligation(Profile, Obligation)`: the controller duty list in article order (Art 33(1) term, then document_breach, then one Art 34 term, then the default item when DEFAULTED); or the processor list; or a status. Cites eu_reg_2016_679_art_33_1 / 33_2 / 33_5 / 34_1 / 34_3_a/b/c / 34_4.
- `breach_notification_verdict(Profile, HoursElapsed, Verdict, Citations)`: scores the controller's Art 33(1) notification. Citations is `[cite(eu_reg_2016_679_art_33_1)]` for a final verdict and `[]` otherwise. Cites eu_reg_2016_679_art_33_1.
- `authority_notification_content_check(Profile, Result)`: Art 33(3)(a)-(d) and Art 33(4). Cites eu_reg_2016_679_art_33_3_a / 33_3_d / 33_4.
- `data_subject_communication_check(Profile, Result)`: Art 34(1) timing and Art 34(2) content. Cites eu_reg_2016_679_art_34_1 / 34_2 / 33_3_d.
- `gdpr_arts33_34_breach_notification_input_problems(Profile, Problems)`: the typed input check. Problems is `[]` when the profile is well-formed. Implements THE INPUT CHECK.

### Package facade (scaffold names kept)

Case is `breach_case(Profile, HoursElapsed)`.

- `decide_breach_notification_verdict(Case, Decision)`: Decision is `breach_notification_verdict(Verdict, Citations)`, delegating to breach_notification_verdict/4. Cites eu_reg_2016_679_art_33_1.
- `breach_notification_verdict_status(Case, Status)`: Status is the Verdict alone. Cites eu_reg_2016_679_art_33_1.
- `breach_notification_verdict_checklist(Case, Checklist)`: a list of `item(RequirementId, Status, cite(KEY))`, built with `eval_requirements/4` over `breach_notification_requirement/4`. RequirementId is one of:
  - `risk_threshold_article_33_1`
  - `within_period_article_33_1`
  - `without_undue_delay_article_33_1`
  - `reasons_for_delay_article_33_1`
  - `delay_justified_article_33_1`

  Status is one of `met`, `unmet(Reason)` or `unknown(Keys)`. It is an explanatory view only; the verdict is decided by the limbs. Cites eu_reg_2016_679_art_33_1.
- `gdpr_arts33_34_breach_notification_what_if(Case, Key, Value, Decision)`: Decision for Case with Key overridden. A profile key is replaced through `profile_set/3`; Key `hours_elapsed` replaces the argument. Exactly one solution.
- **Fixtures** (fixtures.clausal):
  - `breach_notification_fixture(FixtureName, Case, ExpectedDecision)`
  - `obligation_fixture(FixtureName, Profile, ExpectedObligation)`
  - `deadline_fixture(FixtureName, AwarenessDate, AwarenessHour, ExpectedDeadline, ExpectedPeriodEnd)`
  - `content_fixture(FixtureName, Query, Profile, ExpectedResult)`

  Fixtures include the PERIODS worked boundaries (2025-10-31, 2032-02-26, 2032-02-27, 2025-12-30 at hour 23, and 9999-12-28 / 9999-12-29) and HOURS_ELAPSED 72 and 73.

## Planned reuse (manifest `uses:`)

- **formalize_lib:**
  - `profile_get/3`, `profile_has/2`, `profile_lacks/2`, `profile_set/3`
  - `not_member/2`, `memberd/2`
  - `eval_requirements/4`
  - `item/3`, `attribute/2`, `unmet/1`, `unknown/1`
- **date_time / library(datetime):** `timedelta/3` and `date_add/3`, the native three-day addition. The engine has date/4 only, so the plan is:
  1. Validate the integer triple first.
  2. Construct with `date(Y, M, D, Object)`.
  3. Add `timedelta(3, 0, Delta)`.
  4. Read the result back element-wise into a `date(Y, M, D)` of integers.

  Fallback, if the date/4 read-back is unavailable: kit/deadline_lib `next_day/2` three times. Comparisons of dates use `@<` / `@=<`, never `<`.
- **kit/deadline_lib:** `month_last_day/3` for the pure validity check of a real calendar day, so the check never raises. Year 1..9999 and the 9999-12-29 to 31 cap are checked against parameters constants.
- **kit/query_combinators:** `what_if/5`, backing gdpr_arts33_34_breach_notification_what_if/4 with a closure over the verdict.
- **validate_props (tests):**
  - `run_props/1`
  - `prop_totality/3`, `prop_determinism/3`
  - `prop_citation_complete/3`
  - `prop_boundary_coverage/2`
  - `prop_missing_key_coverage/3`
  - `bad_citation/1`
- **Not used:** compliance_lib, rolling_window, currency_vocab, vat_category, country.
  - Breach notification has no money or VAT.
  - The deny-overrides lattice does not fit the ordered limbs.

## Kernel (kernel.clausal) — shared floor only

There is a single slice. The kernel holds only what queries.clausal, the facade and the slice all call:

- `contract_key(Key, Type)`: the 25 keys in root_exports order. Type is `judgement`, `crisp` or `enumeration(Atoms)`.
- `judgement_value/1`, `crisp_value/1`, `enumeration_value/2`: type membership, with ground atoms only.
- `profile_is_attribute_list/1`, which rejects:
  - an unbound variable or partial list;
  - an unbound element;
  - a non-attribute element;
  - a compound key holding a variable.
- The input-check engine behind `gdpr_arts33_34_breach_notification_input_problems/2`, which reports in this order:
  1. For each contract key in order, `duplicate_key` or `wrong_type`.
  2. `unknown_key` in first-occurrence order, comparing keys by identity and leaving values unchecked.
  3. `contradictory_inputs` for the two pairs of contradictory_combinations.
- `argument_problems/…` checkers:
  - `awareness_date_problem/2`
  - `awareness_hour_problem/2`
  - `hours_elapsed_problem/2`

  Profile problems come first, then argument problems in input-contract order.
- `judgement_pairs/3`: builds PAIRS from the list of judgement keys read, in root_exports order.

## Slice: breach_notification_verdict.clausal (self-contained)

### VALUE facts owned here

| Constant | Value | Source |
|---|---|---|
| `authority_notification_period_hours` | 72 | Art 33(1) |
| `authority_notification_period_calendar_days` | 3 | 72 hours ending at the same full hour, PERIODS |
| `awareness_hour_maximum` | 23 | AWARENESS_HOUR range |
| `end_hour_offset` | 1 | Regulation No 1182/71 Art 3(1): the hour of awareness is not counted |
| `calendar_year_minimum` | 1 | date range |
| `calendar_year_maximum` | 9999 | date range |
| `last_awareness_date` | date(9999, 12, 28) | date range, open question (o) |

### Rules and requirements

**R1 Deadline and period end (Art 33(1); Regulation No 1182/71 Art 3(1), 3(2)(a), 3(3), 3(4))**

- DEADLINE is AWARE plus calendar days; HOURS is 72.
- PERIOD_END is `period_end(DEADLINE, AWARENESS_HOUR + end_hour_offset)`.
- There is no shift for non-working days.

**R2 Notification obligation, limbs (0) to (6)**

Helpers:

- `authority_reading(Profile, Authority, Defaulted)`: absent gives no_decision and defaulted; present gives the value and stated.
- `article_34_outcome(Profile, J1, Authority, Outcome)`: Outcome is one of:
  - `term(Term)`
  - `missing(Key)`
  - `refer(Key, Citation, KeysRead)`
  - `no_term_from_exemptions` (no term from the exemptions)
- `article_33_1_term/2`: the Art 33(1) term from J1.
- `obligation_list/4`: assembles the list in article order. It inserts `no_communication_required(cite(eu_reg_2016_679_art_34_1))` under reading (16) and appends the default item under reading (15).

Steps:

- **(1)** party_role.
- **(2)** J1 is always read; the authority is read or defaulted.
- **(3)** J2 is read only when the authority is no_decision and J1 is false or unsure.
- **(4)** Exemptions A, then B, then the first absent of A, B, C, then unsure, then the TERM from C.
- **(5)** Referral on the first unsure of J1, J2, A, B, C. PAIRS includes the default pair in place 7 of root_exports.
- **(6)** Final list.

**R3 Breach notification verdict, steps (0) to (4)**

- **(0)** Input problems, with CITES [].
- **(1)** J1 absent gives indeterminate.
- **(2)** J1 true gives ineligible, with CITES [cite(art_33_1)].
- **(3)** HOURS_ELAPSED =< 72:
  1. The undue-delay key absent gives indeterminate.
  2. J1 unsure refers on J1.
  3. Otherwise undue delay unsure refers with the TIMING CONTEXT; true gives eligible; false gives notification_requirement_not_met(without_undue_delay).
- **(4)** HOURS_ELAPSED > 72:
  1. The reasons fact absent gives indeterminate.
  2. The reasons fact false gives a J1 referral if J1 is unsure, otherwise not_met(reasons_for_delay).
  3. The reasons fact true reads justified: absent gives indeterminate; J1 unsure refers on J1; true gives eligible; false or unsure refers with the TIMING CONTEXT.
- The comparison with 72 reads `constant(authority_notification_period_hours)`. The guards `=<` and `>` are disjoint.

**R4 Authority notification content check, steps (0) to (5)**

- `item_could_be_included/2`, `item_already_included/2`, `needed_content_keys/2` and `missing_content_keys/2` cover step (1), naming every absent key independently.
- Step (2) handles the phases key when there is a single candidate item.
- Step (3) is the first unsure judgement.
- Step (4) collects ITEMS in their order.
- Step (5) reads phases: unsure refers, true gives in_phases, false gives requirements_not_met.

**R5 Data subject communication check, steps (0) to (3)**

As stated in THE CONTENT CHECKS. It does not read J1, J2, party_role or the authority.

**R6 Checklist requirements**

`breach_notification_requirement(RequirementId, Case, Status, Citation)`. RequirementId comes first, and each requirement has three exclusive clauses: met, unmet and unknown. They mirror R3 for explanation only.

### Verdict atoms of this slice

All STATUS atoms above. Constructors are exported from this slice and re-exported by the facade.

### Predicates shared with another slice

None beyond the kernel list: the input check, the contract key catalogue and `judgement_pairs/3`. Everything else is local to this slice.

## Test plan (seven modes, v2 manifest)

1. Unit tests per limb.
2. Boundary tests: HOURS_ELAPSED 72 and 73; END_HOUR 24; leap day; year end; the 9999 cap.
3. Missing-key coverage (<<DNUM>>; the authority default never named).
4. Input-problem matrix: duplicate, wrong_type, unknown variable keys, contradictory pairs, non-list profile.
5. Determinism: exactly one solution, checked with findall and length 1.
6. Citation completeness: every cite KEY is in citation_vocabulary.
7. Fixtures round-trip through the facade and what_if.

Every `test(..., fail)` is paired with a positive test on the same case.
