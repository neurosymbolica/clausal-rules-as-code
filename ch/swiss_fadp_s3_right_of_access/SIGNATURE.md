# SIGNATURE — ch/swiss_fadp_s3_right_of_access

Shape family: **deontic**.

Package layout, unchanged: kernel -> citations -> parameters -> swiss_fadp_s3_right_of_access -> queries -> fixtures -> package facade.

There is one determination slice: `swiss_fadp_s3_right_of_access.clausal`. All predicates carry the prefix `swiss_fadp_s3_right_of_access_` except the contract-named queries listed below.

## 1. Public query surface

### Totality and determinism

- Every public predicate yields EXACTLY ONE solution for every input. The scorer collects all solutions, so a duplicate solution is a refutation.
- Final answers come from disjoint clause routes, with the ground verdict in the head (C17).
- There is no `!`, `->` or `*->`.
- Where an answer is computed over a set of completions, it is collected with `findall` + `sort` into a set before a single disjoint route fires.
- The input check never fails and never raises.

### Contract queries (non-negotiable names and shapes)

- `swiss_access_request_answer(Profile, Result, Citations)`: whether the request is in the required form and whether access must be given or may be refused, restricted or deferred.
  - Result: `access_request_not_in_required_form` | `access_must_be_given` | `access_may_be_refused_restricted_or_deferred` | status compound.
  - Cites: DSG Art 25(1); DSV Art 16(1), (3); DSG Arts 26 and 27; DSG Art 26(4); DSV Art 18(3).
- `swiss_access_cost_contribution(Profile, Result, Citations)`: whether access is free of charge or a cost contribution may be requested.
  - Result: `access_free_of_charge` | `cost_contribution_may_be_requested` | status compound.
  - Cites: DSG Art 25(6); DSV Art 19(1)-(3).
- `swiss_access_deadline(ReceiptDate, DeadlineDate, Citations)`: the last day of the Swiss 30-day limit, RECEIPT + 30 days, never moved.
  - Cites: `ch_fadp_art_25_7`, `ch_fadp_ord_art_18_1`.
- `swiss_access_deadline_after_cost_notice(CostNoticeDate, DeadlineDate, Citations)`: the last day after a cost notice, NOTICE + 40 days.
  - Cites: `ch_fadp_art_25_7`, `ch_fadp_ord_art_18_1`, `ch_fadp_ord_art_19_3`.
- `eu_access_response_deadline(ReceiptDate, DeadlineDate, Citations)`: the EU one-month last day: same date next month, else that month's last day, then Saturday or Sunday to Monday.
  - Cites: `eu_reg_2016_679_art_12_3`, `eu_reg_1971_1182_art_3_1`, `eu_reg_1971_1182_art_3_2_c`, `eu_reg_1971_1182_art_3_4`.
  - Covers query type #15 (deadline).
- `compare_swiss_eu_access_deadline(ReceiptDate, SwissDeadline, EuDeadline, Difference, ChangedBy)`: compares the Swiss and EU last days for the same receipt.
  - Difference: `swiss_earlier` | `same` | `swiss_later`.
  - ChangedBy is `[cite(ch_fadp_ord_art_18_1), cite(eu_reg_2016_679_art_12_3)]` unless the days are the same, in which case it is `[]`.
  - Covers query type #5 (comparison).
- `swiss_fadp_s3_right_of_access_input_problems(Profile, Problems)`: THE INPUT CHECK. Problems is the BARE flat list, in this order:
  1. `duplicate_key/1` or `wrong_type/1`, per contract key in contract order;
  2. then `unknown_key/1`, in first-occurrence order.
  - A profile that is not an attribute list gives `[wrong_type(profile)]`.
  - Cites: none. This is a structural check.

### Scaffold facade (names kept)

- `decide_swiss_fadp_s3_right_of_access(Profile, swiss_fadp_s3_right_of_access_verdict(Status, Citations))`: the facade over `swiss_access_request_answer/3`. Status and Citations are exactly that query's Result and Citations.
  - Cites: as `swiss_access_request_answer/3`.
- `swiss_fadp_s3_right_of_access_status(Profile, Status)`: Status only, from the same query.
  - Cites: as above.
- `swiss_fadp_s3_right_of_access_checklist(Profile, Checklist)`: the justification view, query type #14... see the list below for its contents.
  - Covers query type #7 (justification).
  - Checklist is a list of `item(RequirementId, Status, cite(Key))` in this fixed order:
    - `request_form_met` (cite `ch_fadp_ord_art_16_1`)
    - `ground_formal_law` (cite `ch_fadp_art_26_1_a`)
    - `ground_third_party_interests` (cite `ch_fadp_art_26_1_b`)
    - `ground_manifestly_unfounded_or_querulous` (cite `ch_fadp_art_26_1_c`)
    - `ground_private_controller_interests` (cite `ch_fadp_art_26_2_a`)
    - `ground_federal_body_interests` (cite `ch_fadp_art_26_2_b`)
    - `ground_media_editorial` (cite `ch_fadp_art_27_1`)
    - `ground_media_personal_working_instrument` (cite `ch_fadp_art_27_2`)
  - Status is the formalize_lib vocabulary: `met` | `unmet(Reason)` | `unknown(Keys)`.
  - Built with `eval_requirements/4` over the requirement closure `swiss_fadp_s3_right_of_access_requirement`, whose head is `(RequirementId, Profile, Status, Citation)`.
  - Met items carry cite too.
  - With input problems, the answer is `input_problems(Problems)` itself.
- `swiss_fadp_s3_right_of_access_what_if(Profile, Key, Value, Result)`: the request answer after overriding Key with Value.
  - Implemented with `profile_set/3` (formalize_lib), then `swiss_access_request_answer/3`; Result is that query's Result.
  - Cites: as the request answer.
- `swiss_fadp_s3_right_of_access_controller_obligations(Profile, Obligations)`: what the controller must do. Covers query type #14 (obligation surfacing).
  - Obligations is a flat list of `obligation(Action, cite(Key))`, derived from the request answer:

    | Request answer | Obligations |
    |---|---|
    | `access_must_be_given` | `[obligation(give_access, cite(ch_fadp_art_25_1)), obligation(give_access_within_time_limit, cite(ch_fadp_ord_art_18_1))]` |
    | `access_may_be_refused_restricted_or_deferred` | `[obligation(state_reasons_for_measure, cite(ch_fadp_art_26_4)), obligation(communicate_measure_within_time_limit, cite(ch_fadp_ord_art_18_3))]` |
    | `access_request_not_in_required_form` | `[]` |
    | a status compound | the status compound itself |

  - Free of charge and costs remain in `swiss_access_cost_contribution/3`.
- `swiss_fadp_s3_right_of_access_fixture(Name, Kind, Input, Expected)`: named fixtures (section 6).

## 2. Verdict STATUS atoms (replacing the placeholders `required`, `permitted`, `not_applicable`)

**Request answer:**
- `access_request_not_in_required_form`
- `access_must_be_given` (obligation)
- `access_may_be_refused_restricted_or_deferred` (permission)

**Cost:**
- `access_free_of_charge` (obligation of gratuity)
- `cost_contribution_may_be_requested` (permission)

**Comparison:**
- `swiss_earlier`, `same`, `swiss_later`

**Obligation actions:**
- `give_access`
- `give_access_within_time_limit`
- `state_reasons_for_measure`
- `communicate_measure_within_time_limit`

**Not-final status compounds** (exact functors and arities; there is never a bare `indeterminate` atom):
- `indeterminate([Key])`
- `needs_legal_review(open_textured(Key, cite(CitationKey)), [inputs_relied_on(Pairs)])`
- `input_problems(Problems)`

**Problem terms:**
- `unknown_key(Key)`
- `wrong_type(Key)`
- `duplicate_key(Key)`

**Other exported constructors:**
- `provenance/2`
- `date/3`: the plain interface term `date(Year, Month, Day)` of bare integers.

## 3. Profile keys (root_exports order; every key optional)

Profile is `[attribute(Key, Value), ...]`, read only with `profile_get/3`. The order has no outside facts and no attested wrapper.

| # | Key | Type | Provision |
|---|---|---|---|
| 1 | `request_form` | enumeration `written` / `electronic` / `oral` | DSV 16(1),(3) |
| 2 | `controller_agreed_to_oral_request` | crisp `true` / `false` | DSV 16(1) |
| 3 | `controller_category` | enumeration `private_person` / `federal_body` | DSG 26(2) |
| 4 | `formal_law_provides_for_restriction` | judgement `true` / `false` / `unsure` | DSG 26(1)(a) |
| 5 | `restriction_required_by_overriding_third_party_interests` | judgement | DSG 26(1)(b) |
| 6 | `request_manifestly_unfounded_or_querulous` | judgement | DSG 26(1)(c) |
| 7 | `restriction_required_by_overriding_controller_interests` | judgement | DSG 26(2)(a)(1) |
| 8 | `controller_discloses_the_personal_data_to_third_parties` | crisp | DSG 26(2)(a)(2), 26(3) |
| 9 | `restriction_required_by_overriding_public_interests` | judgement | DSG 26(2)(b)(1) |
| 10 | `information_could_endanger_investigation_or_proceedings` | judgement | DSG 26(2)(b)(2) |
| 11 | `processed_exclusively_for_publication_in_editorial_part_of_periodical_medium` | judgement | DSG 27(1) |
| 12 | `data_reveal_information_sources` | judgement | DSG 27(1)(a) |
| 13 | `access_would_give_insight_into_drafts_for_publications` | judgement | DSG 27(1)(b) |
| 14 | `publication_would_endanger_free_formation_of_public_opinion` | judgement | DSG 27(1)(c) |
| 15 | `data_serve_media_professional_exclusively_as_personal_working_instrument` | judgement | DSG 27(2) |
| 16 | `access_involves_disproportionate_effort` | judgement | DSV 19(1); DSG 25(6) |

root_exports then lists the enumeration atoms `written`, `electronic`, `oral`, `private_person`, `federal_body`, and `unsure`.

**Date arguments** (not profile keys) are `receipt_date` and `cost_notice_date`. Each is a ground `date(Year, Month, Day)` of bare integers naming a real Gregorian day, with Year from 1900 to 2199.

No money key exists. The CHF 300 cap is cited, not checked.

## 4. Citation-key atoms (canonical lexicon; `citations.clausal`)

Each key is declared once, with its pinned unit id and source sha256. These are the only citation atoms used.

- **DSG (Art 25):**
  - `ch_fadp_art_25_1` -> ch-fadp-sr-235-1-2025-07-07#art_25/para_1
  - `ch_fadp_art_25_6` -> #art_25/para_6
  - `ch_fadp_art_25_7` -> #art_25/para_7
- **DSG (Art 26):**
  - `ch_fadp_art_26_1` -> #art_26/para_1 (+listintro)
  - `ch_fadp_art_26_1_a`, `ch_fadp_art_26_1_b`, `ch_fadp_art_26_1_c` -> #art_26/para_1/lbl_a..c
  - `ch_fadp_art_26_2` -> #art_26/para_2
  - `ch_fadp_art_26_2_a` -> #art_26/para_2/lbl_a
  - `ch_fadp_art_26_2_a_1`, `ch_fadp_art_26_2_a_2` -> #art_26/para_2/lbl_a/lbl_1, lbl_2
  - `ch_fadp_art_26_2_b` -> #art_26/para_2/lbl_b
  - `ch_fadp_art_26_2_b_1`, `ch_fadp_art_26_2_b_2` -> #art_26/para_2/lbl_b/lbl_1, lbl_2
  - `ch_fadp_art_26_3` -> #art_26/para_3
  - `ch_fadp_art_26_4` -> #art_26/para_4
- **DSG (Art 27):**
  - `ch_fadp_art_27_1` -> #art_27/para_1
  - `ch_fadp_art_27_1_a`, `ch_fadp_art_27_1_b`, `ch_fadp_art_27_1_c` -> #art_27/para_1/lbl_a..c
  - `ch_fadp_art_27_2` -> #art_27/para_2
- **DSV:**
  - `ch_fadp_ord_art_16_1` -> ch-fadp-ord-sr-235-11-2025-12-01#art_16/para_1
  - `ch_fadp_ord_art_16_3` -> #art_16/para_3
  - `ch_fadp_ord_art_18_1` -> #art_18/para_1
  - `ch_fadp_ord_art_18_3` -> #art_18/para_3
  - `ch_fadp_ord_art_19_1`, `ch_fadp_ord_art_19_2`, `ch_fadp_ord_art_19_3` -> #art_19/para_1..3
- **EU:**
  - `eu_reg_2016_679_art_12_3` -> 02016R0679-20160504#parag_012.003
  - `eu_reg_1971_1182_art_3_1` -> 31971R1182#parag_003.001
  - `eu_reg_1971_1182_art_3_2_c` -> 31971R1182#point_003.002_c (with parag_003.002 lead-in)
  - `eu_reg_1971_1182_art_3_4` -> 31971R1182#parag_003.004

Deferred units are listed in citations as deferred and are cited by no answer: Art 25(2)-(5); DSV 16(2),(4),(5); DSV 17; DSV 18(2).

## 5. Planned reuse (manifest `uses:`)

### formalize_lib

- `profile_get/3`, `profile_has/2`, `profile_lacks/2`, `profile_set/3`, `profile_keys/2`
- `check_tri/4`, `check_eq/5`, `check_false/4`
- `or_status/2`, `and_status/2`
- `eval_requirements/4`, `memberd/2`, `not_member/2`
- The constructors `attribute/2`, `item/3`, `unmet/1`, `unknown/1`

### library(datetime)

- `timedelta/3` and `date_add/3`: day addition.
- `weekday/2`: Saturday/Sunday test.
- `ordinal/2`

These work on the date/4 object. The interface term is the plain `date(Y, M, D)`, converted at the boundary in the kernel.

### kit/deadline_lib

- `month_last_day/3`: EU fallback day and Gregorian validity.
- `next_day/2`: weekend roll.
- `deadline/4`: may be used for +30 and +40 if it accepts the plain date term. Otherwise use datetime `date_add/3`.
- NOT `deadline_months_after/3`: its semantics differ, see NOTES Q9.

### Other modules

- **kit/query_combinators**: `what_if/5` is considered for `what_if/4`. `profile_set/3` is the primary route, because the profile is an attribute list, not a dict.
- **validate_props**, in tests:
  - `prop_totality/3` and `prop_determinism/3` over generated profiles and dates;
  - `prop_citation_complete/3`: every final answer carries its fixed citation set;
  - `prop_missing_key_coverage/3`.
- **currency_vocab**: `chf`, used only in the constant name / comment for the CHF 300 cap.
- **Not used**: kit/compliance_lib. Its deny-overrides lattice does not fit the permission-overrides-obligation structure of Art 26. The grounds are a disjunction of permissions, which the slice evaluates directly.

## 6. Fixtures (`fixtures.clausal`)

### Date fixtures

| Query | Input | Expected |
|---|---|---|
| Swiss deadline | 2026-03-01 | 2026-03-31 |
| Swiss deadline | 2026-01-15 | 2026-02-14 |
| Swiss deadline | 2026-02-01 | 2026-03-03 |
| After cost notice | 2026-03-01 | 2026-04-10 |
| EU deadline | 2026-10-29 | 2026-11-30 |
| EU deadline | 2026-01-31 | 2026-03-02 |
| EU deadline | 2028-01-31 | 2028-02-29 |
| EU deadline | 2026-03-01 | 2026-04-01 |
| Compare | 2026-03-01 | 2026-03-31 vs 2026-04-01, `swiss_earlier` |
| Compare | 2026-01-31 | 2026-03-02 vs 2026-03-02, `same`, ChangedBy `[]` |
| Compare | 2026-02-01 | 2026-03-03 vs 2026-03-02, `swiss_later` |
| Compare | 2028-01-31 | 2028-03-01 vs 2028-02-29, `swiss_later` |
| Compare | 2026-10-29 | 2026-11-28 vs 2026-11-30, `swiss_earlier` |

### Bad date inputs

- `date(2026, 2, 30)`, `date(1899, 12, 31)` and `foo` each give `input_problems([wrong_type(receipt_date)])`, with Citations `[]`.
- A bad cost notice date gives `input_problems([wrong_type(cost_notice_date)])`.

### Request fixtures

- `oral_without_agreement`: `request_form` oral, `controller_agreed_to_oral_request` false. Expected: `access_request_not_in_required_form`.
- `written_no_ground`: written, private_person, all judgements false, discloses true. Expected: `access_must_be_given`.
- `written_third_party_interest`: as above, with (b) true. Expected: `access_may_be_refused_restricted_or_deferred`.
- `private_controller_ground`: private_person, controller interests true, discloses false. Expected: may be refused.
- `federal_body_investigation`: federal_body, endanger true. Expected: may be refused.
- `category_absent_both_hold`: category absent, (d) and (e) conditions met. Expected: may be refused.
- `media_working_instrument`: (g) true, editorial false. Expected: may be refused (Q5).
- `empty_profile`: Expected: `indeterminate([request_form])`.
- `written_formal_law_unsure`: all others false. Expected: `needs_legal_review(open_textured(formal_law_provides_for_restriction, cite(ch_fadp_art_26_1_a)), [inputs_relied_on(Pairs)])`, where Pairs is every present key-value pair in root_exports order.

### Cost fixtures

| Profile | Expected |
|---|---|
| effort false | `access_free_of_charge` |
| effort true | `cost_contribution_may_be_requested` |
| `[]` | `indeterminate([access_involves_disproportionate_effort])` |
| effort unsure | `needs_legal_review(open_textured(access_involves_disproportionate_effort, cite(ch_fadp_ord_art_19_1)), [inputs_relied_on([access_involves_disproportionate_effort-unsure])])` |

### Input-check fixtures

| Profile | Expected |
|---|---|
| `[attribute(request_form, fax)]` | `[wrong_type(request_form)]` |
| `[attribute(controller_agreed_to_oral_request, unsure)]` | `[wrong_type(controller_agreed_to_oral_request)]` |
| duplicate `request_form` | `[duplicate_key(request_form)]` |
| `[attribute(colour, red), attribute(colour, blue)]` | `[unknown_key(colour)]` |
| `[foo]` | `[wrong_type(profile)]` |
| an unbound profile | `[wrong_type(profile)]` |

## 7. Kernel / citations / parameters

### kernel.clausal (the shared floor; only what a slice must share)

- **Result constructors and the input check:** `swiss_fadp_s3_right_of_access_input_problems/2`, with the contract key table `swiss_fadp_s3_right_of_access_contract_key(Key, Type)` in root_exports order, where Type is `judgement`, `crisp`, `enumeration([...])`.
  - Total over any term: it guards unbound and partial lists with `var`/`is_list`-style tests in disjoint clauses.
- **Date validation:** `swiss_fadp_s3_right_of_access_valid_date(Term)`, plus its complement `swiss_fadp_s3_right_of_access_invalid_date(Term)`, written as disjoint clauses.
  - Ground `date/3` of integers.
  - Month 1-12.
  - Day 1..`month_last_day/3`.
  - Year from 1900 to 2199.
- **Date helpers:**
  - `swiss_fadp_s3_right_of_access_add_days(date(Y,M,D), Days, date(Y2,M2,D2))`: through the datetime object, forward only.
  - `swiss_fadp_s3_right_of_access_calendar_key(date(Y,M,D), Key)`: Key is Y*10000 + M*100 + D, for chronological comparison.
  - `swiss_fadp_s3_right_of_access_weekend_day(Date)`: weekday/2 is Saturday or Sunday.

### citations.clausal

The section-4 table, as `swiss_fadp_s3_right_of_access_citation(Key, UnitId, SourceSha256)`.

### parameters.clausal

Non-statutory configuration only: `:- constant_value(input_year_minimum, 1900).` and `:- constant_value(input_year_maximum, 2199).` Statutory figures live in the slice.

### queries.clausal

The facade predicates of section 1 (status, checklist, what_if, controller_obligations), each delegating to the slice.

## 8. Determination slice — `swiss_fadp_s3_right_of_access.clausal`

### Statutory VALUE facts owned here

- `:- constant_value(swiss_access_period_days, 30).` (DSG 25(7); DSV 18(1))
- `:- constant_value(cost_reflection_period_days, 10).` (DSV 19(3))
- Derived: `swiss_access_period_after_cost_notice_days` = `cost_reflection_period_days` + `swiss_access_period_days` = 40. It is computed from the two constants, not inlined.
- `:- constant_value(cost_contribution_maximum_chf_rappen, 30000).` (DSV 19(2)). Integer minor units; cited, not checked.
- `:- constant_value(eu_access_period_months, 1).` (GDPR 12(3))
- Fixed citation lists, one fact per final answer:
  - `swiss_fadp_s3_right_of_access_answer_citations(Result, Citations)`: exactly the lists of THE LIMBS steps (1), (2), (3), (5), (6), (9), (10), (11), (14).
  - `swiss_fadp_s3_right_of_access_referral_citation(Query, Key, CitationKey)`: the referral rows of THE LIMBS step (4) and step (8).

### Rules / requirements

**R0 input.** A non-empty `swiss_fadp_s3_right_of_access_input_problems/2` result gives `input_problems(Problems)` with Citations `[]`.

**R1 form** (DSV 16(1),(3)): three-valued `met` / `failed` / `open`.
- `met`: `request_form` is written or electronic, or `controller_agreed_to_oral_request` is true.
- `failed`: oral and agreed false.
- `open`: otherwise.

**R2 grounds (a)-(g)** (DSG 26(1)(a)-(c), 26(2)(a), 26(2)(b), 27(1), 27(2)): each three-valued `holds` / `fails` / `open`, exactly per THE LIMBS.
- `unsure` is neither true nor false.
- Uses `check_tri/4` for single tri-state keys; conjunctions and disjunctions via `and_status/2` / `or_status/2`.

**R3 decision function** (on complete profiles):
- form failed gives `access_request_not_in_required_form`;
- else any ground holds gives `access_may_be_refused_restricted_or_deferred`;
- else `access_must_be_given`.

**R4 status rule** (generic over a query's own keys and decision function):
- A completion assigns each absent own key every value of its type and each unsure judgement true/false.
- (i) **Settled**: the sorted answer set over all completions is a singleton, giving that answer with its fixed citations.
- (ii) **First missing key**: first in root_exports order such that the key is absent, it matters, and it is behind no other absent key that matters. Gives `indeterminate([Key])`.
- (iii) **Referral**: the first unsure judgement that matters gives `needs_legal_review(open_textured(Key, cite(CitationKey)), [inputs_relied_on(Pairs)])`.
  - Pairs: present own keys in root_exports order, as `Key-Value`.

Implementation notes for R4:
- Steps (1)-(3) are computed first, directly from the three-valued R1/R2 statuses, as a fast settled path. The completion engine runs only for unsettled profiles.
- Each own key's completion domain comes from the kernel contract table.
- A property test checks that the fast path equals rule (i) over generated profiles.
- Worst case is about 49k completions (all keys absent). This is a performance risk, mitigated by evaluating R3 from cached per-ground status.

**R5 cost** (DSG 25(6); DSV 19(1)):

| `access_involves_disproportionate_effort` | Result |
|---|---|
| false | `access_free_of_charge` |
| true | `cost_contribution_may_be_requested` |
| absent | `indeterminate([access_involves_disproportionate_effort])` |
| unsure | referral citing `ch_fadp_ord_art_19_1` |

These four disjoint clauses agree with R4.

**R6 Swiss deadline**: valid receipt gives receipt + `swiss_access_period_days`.

**R7 deadline after cost notice**: valid notice gives notice + (`cost_reflection_period_days` + `swiss_access_period_days`).

**R8 EU deadline**:
1. Month + 1, carrying the year after December.
2. Day = min(D, `month_last_day/3`).
3. If Saturday, add 2; if Sunday, add 1. This uses two disjoint clauses plus a weekday clause, with no if-then-else.

**R9 comparison**:
- Compare R6 and R8 by calendar key: less gives `swiss_earlier`, equal gives `same`, greater gives `swiss_later`.
- ChangedBy is per THE LIMBS (14).
- Invalid receipt: all three date outputs are `input_problems([wrong_type(receipt_date)])`, and ChangedBy is `[]`.

### Verdict atoms

- `access_request_not_in_required_form`, `access_must_be_given`, `access_may_be_refused_restricted_or_deferred`
- `access_free_of_charge`, `cost_contribution_may_be_requested`
- `swiss_earlier`, `same`, `swiss_later`
- Status compounds: `indeterminate/1`, `needs_legal_review/2`, `input_problems/1`.

### Predicates shared with another slice

None; there is a single slice. Only the input check, date validation and date helpers are hosted in kernel.clausal. The facade (queries.clausal) uses them, and they are the floor any future sibling slice (for example, a DSG Art 25(2) content checklist) would need.

### Per-rule tests (in the slice's test file)

- One positive and one paired negative test per rule R1-R9.
- Every fixture of section 6.
- Solution-count tests use `findall` + `length(Solutions, 1)` for every query, including input-problem and status cases.
- Citation-fixity test: an answer reached with a key absent carries the same Citations as with that key supplied.
- Boundary tests:
  - month ends 28/29/30/31;
  - December to January carry;
  - the year 2199 input giving a 2200 output;
  - century leap years 1900 (not leap) and 2000 (leap).
