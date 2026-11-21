# SIGNATURE — eu/cra_manufacturer_duties

## Public query surface

The called contract has four predicates. Their names are fixed by the order and kept unprefixed, as THE CALLED CONTRACT requires:
- `requirements_applicability/4` (#3 status determination);
- `support_period_minimum/4` (#23 calculation);
- `retention_end_date/5` (#23 calculation);
- `cra_manufacturer_duties_input_problems/2` (the input check).

The scaffold facade wraps them over a QUESTION term. A QUESTION is one of:
- `requirements_applicability(PROFILE, ASSESSMENT_DATE)`;
- `support_period_minimum(PROFILE, ASSESSMENT_DATE)`;
- `retention_end_date(PROFILE, ASSESSMENT_DATE, ITEM)`.

The facade predicates are:
- `decide_cra_manufacturer_duties(QUESTION, cra_manufacturer_duties_verdict(VERDICT, CITATIONS))`;
- `cra_manufacturer_duties_status(QUESTION, VERDICT)`;
- `cra_manufacturer_duties_checklist(QUESTION, CHECKLIST)`, the #7 justification: one `item(StepId, Status, cite(KEY))` per legal step reached;
- `cra_manufacturer_duties_what_if(QUESTION, KEY, VALUE, VERDICT)`.

Totality and determinism: every call of every public predicate, on any term, yields EXACTLY ONE solution and never raises. The scorer counts every solution.
- Clauses are made disjoint by guards: an empty or non-empty problem list, date ranges, and `profile_has` against `profile_lacks`.
- No `!`, `->`, `*->` or `once/1` is used.
- Ground verdicts are folded into clause heads (C17).
- After a clean input check each contract key occurs at most once, so `profile_get/3` has at most one solution.

All statutory figures are declared in the slice file and never re-declared elsewhere.

## Verdict atoms (replace the placeholders satisfied / not_satisfied)

**Final answers**
- `subject_to_requirements`: query A.
- `article_14_only`: query A.
- `not_yet_applicable`: queries A, B and C.
- `minimum_support_period(MONTHS)`: query B. MONTHS is a bare non-negative integer.
- `keep_until(date(Y, M, D))`: query C. The date has bare integers.
- `not_applicable_outside_support_period`: query C, security_update only.

**Status compounds** (all have CITATIONS `[]`)
- `indeterminate([KEY])`: exactly one key. The bare atom indeterminate is never written.
- `needs_legal_review(open_textured(substantially_modified_on_or_after_application_date, cite(eu_reg_2024_2847_art_69_2)), [inputs_relied_on([substantially_modified_on_or_after_application_date-unsure])])`: query A only.
- `input_problems(PROBLEMS)`: PROBLEMS is a list of `duplicate_key(KEY)`, `wrong_type(KEY)` and `unknown_key(KEY)` terms.

**Output wrappers and constructors**
- Facade wrapper: `cra_manufacturer_duties_verdict(VERDICT, CITATIONS)`.
- The verdict_vocabulary pins the four bare final atoms and the constructor names. It never pins `true` or `false`.
- Result constructors are exported and never called as queries: `date/3`, `minimum_support_period/1`, `keep_until/1`, `indeterminate/1`, `needs_legal_review/2`, `open_textured/2`, `inputs_relied_on/1`, `provenance/2`, `input_problems/1`, `unknown_key/1`, `wrong_type/1` and `duplicate_key/1`.

## Profile keys

PROFILE is `[attribute(KEY, VALUE), ...]`, read only with `profile_get/3`. The keys are listed in root_exports and input_contract order.

| # | Key | Kind | Type | Source |
|---|---|---|---|---|
| 1 | `placing_on_market_date` | crisp | `date(Year, Month, Day)`, a real calendar day | Art 3(21) |
| 2 | `substantially_modified_on_or_after_application_date` | judgement | `true`, `false` or `unsure` (typed one_of boolean or unsure) | Art 69(2), Art 3(30) |
| 3 | `expected_use_time_in_months` | crisp | non-negative integer, unit months | Art 13(8) |
| 4 | `security_update_issue_date` | crisp | `date(Year, Month, Day)`, a real calendar day | Art 13(9) |
| 5 | `support_period_end_date` | crisp | `date(Year, Month, Day)`, a real calendar day | Art 13(8), (19) |

Arguments that are not profile keys:
- `ASSESSMENT_DATE`: a `date(Year, Month, Day)` real calendar day, with no year range beyond an integer.
- `ITEM`: one of `technical_documentation_and_declaration_of_conformity`, `information_and_instructions_to_the_user`, `security_update`.

## Citation-key atoms

These follow the canonical lexicon scheme in `_lexicon/citations.yaml` and live in citation_vocabulary. No shortened atom is ever invented.
- `eu_reg_2024_2847_art_71_2`: dates of application.
- `eu_reg_2024_2847_art_69_2`: products placed before 11 December 2027.
- `eu_reg_2024_2847_art_69_3`: Article 14 for those products.
- `eu_reg_2024_2847_art_13_8`: the support period floor.
- `eu_reg_2024_2847_art_13_9`: availability of security updates.
- `eu_reg_2024_2847_art_13_13`: technical documentation and EU declaration of conformity.
- `eu_reg_2024_2847_art_13_18`: information and instructions to the user.

Art 3(20), (21), (30) and Art 13(19) are context units. They are recorded in citations.clausal as `context_unit/3` with the unit id and a gloss, and are never emitted.

## Public predicates

- `requirements_applicability(Profile, AssessmentDate, Verdict, Citations)`: which requirements bind the product at the date, following steps A0 to A5. Cites Art 71(2), or Art 69(2), or Art 69(2) and (3).
- `support_period_minimum(Profile, AssessmentDate, Verdict, Citations)`: the floor in months, following steps B0 to B3. Cites Art 13(8) (and Art 71(2) for not_yet_applicable).
- `retention_end_date(Profile, AssessmentDate, Item, Verdict, Citations)`: the keep-until date for the item, following steps C0 to C4. Cites Art 13(13), Art 13(18) or Art 13(9) (and Art 71(2) for not_yet_applicable).
- `cra_manufacturer_duties_input_problems(Profile, Problems)`: profile-only typed input check. It is total and deterministic. It has no citation (a structural check).
- `decide_cra_manufacturer_duties(Question, Verdict)`: the facade. It dispatches Question to the matching query and gives `cra_manufacturer_duties_verdict(VERDICT, CITATIONS)`. Its citations are those of the query.
- `cra_manufacturer_duties_status(Question, Status)`: the VERDICT alone (#3). Its citations are those of the query.
- `cra_manufacturer_duties_checklist(Question, Checklist)`: the #7 justification. It returns the list of `item(StepId, Status, cite(KEY))` for the steps reached. Status is `met`, `unmet(Reason)` or `unknown([KEY])`. Every item is cited, met items included. It is `[]` when the input check fails, because no legal step is reached, which mirrors CITATIONS `[]`. Citations are per item as in the slice section.
- `cra_manufacturer_duties_what_if(Question, Key, Value, Verdict)`: re-decides with Key overridden to Value. The override removes every occurrence of Key, then adds `attribute(Key, Value)` through `profile_set/3`. It gives one solution. Its citations are those of the query.
- `cra_manufacturer_duties_fixture(Name, Question)` and `cra_manufacturer_duties_fixture_expected(Name, Verdict, Citations)`: named worked cases, listed under fixtures.clausal.

## Planned reuse (manifest uses:)

- `formalize_lib`:
  - `profile_get/3`, `profile_has/2`, `profile_lacks/2`, `profile_set/3`: profile access and what-if;
  - `eval_requirements/4`: checklist rows, with the closure `step_requirement(QueryTag, AssessmentDate)`, which the kit calls as `step_requirement(QueryTag, AssessmentDate, StepId, Profile, Status, Citation)`. RequirementId comes first among the kit-supplied arguments;
  - `item/3`, `unknown/1`, `unmet/1`, `attribute/2`: constructors.
- `kit/deadline_lib`: `month_last_day/3`, the month length used for real-calendar-day validation and the 29 February rule.
- `validate_props`: `run_props/1`, `prop_totality/3`, `prop_determinism/3`, `prop_citation_complete/3`, `prop_boundary_coverage/2`, `prop_missing_key_coverage/3`. Used in tests.
- Not used, and why:
  - `deadline_months_after/3`: it uses last-day-of-period semantics, which is wrong for '10 years after'.
  - `library(datetime)` `date_add/3` and `timedelta/3`: no day counts are needed. Years are not a fixed number of days.
  - `date/3` native: not registered yet.
  - `check_tri/4`: the unsure branch must give needs_legal_review with its PAIRS, not a checklist unknown, so the tri-state branch is three explicit head-folded clauses.
  - `kit/query_combinators` `what_if/5`: it assumes dict profiles. The attribute-list override uses `profile_set/3` instead.

## Module layout (unchanged file and module names)

- **kernel.clausal** holds the shared floor. Its predicates are used by the slice, queries.clausal and fixtures.clausal:
  - `real_calendar_day/1`: ground `date(Y, M, D)`; Y an integer; M an integer from 1 to 12; D an integer from 1 to `month_last_day(Y, M)`. The leap-year rule comes through deadline_lib. It fails and never raises on a non-ground term or a non-integer.
  - `date_earlier/2` and `date_not_earlier/2`: disjoint year, then month, then day integer comparisons, three clauses each.
  - `date_later_of/3`: two disjoint clauses. Equal dates give that date.
- **citations.clausal** holds `citation_vocabulary/1` facts for the seven keys and `citation_unit/3` (key, unit id, gloss). It also holds `context_unit/3`.
- **parameters.clausal** holds no statutory figure. Every value fact lives in the slice. It keeps the scaffold module and re-exports the slice's `constant_value` names for discovery only.
- **cra_manufacturer_duties.clausal** is the determination slice described below.
- **queries.clausal** holds the facade dispatch: `decide_cra_manufacturer_duties/2`, `cra_manufacturer_duties_status/2`, `cra_manufacturer_duties_checklist/2` and `cra_manufacturer_duties_what_if/4`. It has one clause per QUESTION functor, plus one clause for any other term, giving `input_problems([wrong_type(question)])` with CITATIONS `[]`.
- **fixtures.clausal** holds the named cases.
- **The package facade** re-exports the four contract predicates, the facade predicates, the fixtures and the result constructors.

## Slice — cra_manufacturer_duties.clausal

### Statutory value facts

These are owned here and declared once with `constant_value/2`. If constant_value takes only numbers, each date is split into `_year`, `_month` and `_day` integer constants.
- `article_14_application_date`: `date(2026, 9, 11)`, Art 71(2) second sentence.
- `regulation_application_date`: `date(2027, 12, 11)`, Art 71(2) first sentence and Art 69(2).
- `support_period_floor_months`: 60, Art 13(8) third subparagraph (five years).
- `availability_period_years`: 10, Art 13(9), (13) and (18).
- `item_start_key/2`, `item_citation/2` (facts):
  - `technical_documentation_and_declaration_of_conformity`: start key `placing_on_market_date`, citation `eu_reg_2024_2847_art_13_13`;
  - `information_and_instructions_to_the_user`: start key `placing_on_market_date`, citation `eu_reg_2024_2847_art_13_18`;
  - `security_update`: start key `security_update_issue_date`, citation `eu_reg_2024_2847_art_13_9`.
- `contract_key/2`, `contract_key_type/2` (facts): the five keys in order, with type date, judgement or non_negative_integer_months.

### Rules

**The input check (step 0 of every query)**

`cra_manufacturer_duties_input_problems(Profile, Problems)` works as follows.
1. `attribute_list(Profile)` holds only for a proper list in which every element is a nonvar `attribute(K, V)`. It is checked by recursion with var guards, so an unbound tail or element gives failure and never loops. Otherwise PROBLEMS is `[wrong_type(profile)]`.
2. For each contract key in contract order:
   - if it occurs two or more times, add `duplicate_key(K)` and do not read its values;
   - if it occurs once and its value fails its type, add `wrong_type(K)`. An unbound value fails every type.
3. Then add `unknown_key(K)` for each non-contract key, in order of first occurrence. This covers non-atom keys, which are given as written. Repeats are deduplicated by `==`, so an unbound key is matched by identity, never by unification.
4. The query adds argument problems after the profile problems:
   - `wrong_type(assessment_date)` unless `real_calendar_day(AssessmentDate)`;
   - then, for C only, `wrong_type(item)` unless the item is one of the three atoms. The membership test is on a nonvar atom, so an unbound item is wrong_type.

**Query A: requirements_applicability**, in step order, with each step's guard disjoint from the others.

| Step | Condition | VERDICT | CITATIONS |
|---|---|---|---|
| A0 | problems non-empty | `input_problems(P)` | `[]` |
| A1 | date earlier than `article_14_application_date` | `not_yet_applicable` | `[cite(eu_reg_2024_2847_art_71_2)]` |
| A2 | date not earlier than `article_14_application_date` and earlier than `regulation_application_date` | `article_14_only` | `[cite(eu_reg_2024_2847_art_71_2)]` |
| A3 | date not earlier than `regulation_application_date`, `placing_on_market_date` absent | `indeterminate([placing_on_market_date])` | `[]` |
| A4 | placing date not earlier than `regulation_application_date` | `subject_to_requirements` | `[cite(eu_reg_2024_2847_art_71_2)]` |
| A5 | placing date earlier, judgement absent | `indeterminate([substantially_modified_on_or_after_application_date])` | `[]` |
| A5 | placing date earlier, judgement `true` | `subject_to_requirements` | `[cite(eu_reg_2024_2847_art_69_2)]` |
| A5 | placing date earlier, judgement `false` | `article_14_only` | `[cite(eu_reg_2024_2847_art_69_2), cite(eu_reg_2024_2847_art_69_3)]` |
| A5 | placing date earlier, judgement `unsure` | `needs_legal_review(open_textured(substantially_modified_on_or_after_application_date, cite(eu_reg_2024_2847_art_69_2)), [inputs_relied_on([substantially_modified_on_or_after_application_date-unsure])])` | `[]` |

**Query B: support_period_minimum**

| Step | Condition | VERDICT | CITATIONS |
|---|---|---|---|
| B0 | problems non-empty | `input_problems(P)` | `[]` |
| B1 | date earlier than `regulation_application_date` | `not_yet_applicable` | `[cite(eu_reg_2024_2847_art_71_2)]` |
| B2 | `expected_use_time_in_months` absent | `indeterminate([expected_use_time_in_months])` | `[]` |
| B3 | E of 60 or more (`>=` the floor constant) | `minimum_support_period(60)` | `[cite(eu_reg_2024_2847_art_13_8)]` |
| B3 | E less than 60 | `minimum_support_period(E)` | `[cite(eu_reg_2024_2847_art_13_8)]` |

**Query C: retention_end_date**

| Step | Condition | VERDICT | CITATIONS |
|---|---|---|---|
| C0 | problems non-empty | `input_problems(P)` | `[]` |
| C1 | date earlier than `regulation_application_date` | `not_yet_applicable` | `[cite(eu_reg_2024_2847_art_71_2)]` |
| C2 | the first absent of START and `support_period_end_date`, in root_exports order | `indeterminate([K])` | `[]` |
| C3 | `security_update` with issue date later than end date | `not_applicable_outside_support_period` | `[cite(eu_reg_2024_2847_art_13_9)]` |
| C4 | otherwise | `keep_until(Date)`, with Date given by `date_later_of(StartPlusTen, EndDate)` | `[cite(item_citation)]` |

Notes on query C:
- In C2 the first absent key is `placing_on_market_date` or `security_update_issue_date` before `support_period_end_date`, because START precedes it in root_exports order for every item.
- In C3, 'later than' is checked as `date_earlier(EndDate, IssueDate)`.
- In C4, StartPlusTen is given by `calendar_years_after(Start, availability_period_years, StartPlusTen)`:
  - `date(Y, M, D)` gives `date(Y + 10, M, D)` unless M is 2 and D is 29;
  - `date(Y, 2, 29)` gives `date(Y + 10, 2, 28)`;
  - the two clauses are disjoint.

**Checklist steps**

The checklist uses `step_requirement/6` with `eval_requirements/4`. Its StepIds and cites are:
- `assessment_date_from_article_14_application_date`: cites 71_2.
- `assessment_date_from_regulation_application_date`: cites 71_2.
- `placed_on_market_from_regulation_application_date`: cites 71_2.
- `substantially_modified_from_regulation_application_date`: cites 69_2. Its status is `unknown([key])` for absent or unsure.
- `expected_use_time_known`: cites 13_8.
- `support_period_floor_applied`: cites 13_8.
- `start_date_known`: cites the item citation.
- `support_period_end_date_known`: cites the item citation.
- `security_update_within_support_period`: cites 13_9.
- `retention_date_computed`: cites the item citation.

Only the steps reached before the deciding step are listed, in step order. The checklist must agree with the verdict, and a consistency test checks this.

### Verdict atoms owned

- `subject_to_requirements`
- `article_14_only`
- `not_yet_applicable`
- `not_applicable_outside_support_period`
- `minimum_support_period/1`
- `keep_until/1`
- the three status compounds

### Predicates shared with another module (and so placed in kernel.clausal)

`real_calendar_day/1`, `date_earlier/2`, `date_not_earlier/2` and `date_later_of/3`. They are used by the slice, by queries.clausal (QUESTION validation in what-if) and by fixtures.clausal. Nothing else is shared.

## Tests (seven modes)

- **load:** the modules load and the exports resolve.
- **unit per step:** one positive test and one paired negative test for each of A0 to A5, B0 to B3 and C0 to C4.
- **boundary:**
  - assessment dates 2026-09-10 and 2026-09-11, and 2027-12-10 and 2027-12-11;
  - placing dates 2027-12-10 and 2027-12-11;
  - E of 59, 60, 61 and 0;
  - an issue date equal to the end date, and one a day after;
  - start plus ten equal to the end date;
  - 29 February 2028 giving 28 February 2038;
  - month and day ordering such as day 2 against day 15.
- **counting:** `findall` over every public predicate gives length 1 on every fixture and on malformed inputs: an unbound profile, a partial list, an unbound key, value, date or item, and duplicates.
- **input check:** PROBLEMS come in the right order:
  - duplicate_key wins over wrong_type;
  - unknown keys come in first-occurrence order;
  - wrong_type(profile) is followed by the argument problems.
- **citation completeness:** final answers carry the exact sets from the steps, and status compounds carry `[]`.
- **properties:** totality, determinism and missing-key coverage through validate_props, plus fixture regression.

## Fixtures (fixtures.clausal)

| Name | Question | Expected answer |
|---|---|---|
| `before_article_14_date` | A, 2026-06-01 | `not_yet_applicable` + 71_2 |
| `article_14_window` | A, 2027-01-15, empty profile | `article_14_only` + 71_2 |
| `new_product_after_application` | A, 2028-03-01, placed 2028-01-10 | `subject_to_requirements` + 71_2 |
| `legacy_product_modified` | A, 2028-03-01, placed 2025-05-05, true | `subject_to_requirements` + 69_2 |
| `legacy_product_unmodified` | A, false | `article_14_only` + 69_2, 69_3 |
| `legacy_product_unsure` | A, unsure | `needs_legal_review` |
| `missing_placing_date` | A, empty profile at 2028 | `indeterminate([placing_on_market_date])` |
| `long_lived_router` | B, E 120 | `minimum_support_period(60)` + 13_8 |
| `short_lived_gadget` | B, E 24 | `minimum_support_period(24)` |
| `documentation_ten_years_wins` | C, placed 2028-02-01, end 2033-02-01 | `keep_until(date(2038, 2, 1))` + 13_13 |
| `instructions_support_period_wins` | C, end 2040-06-30 | `keep_until(date(2040, 6, 30))` + 13_18 |
| `leap_day_update` | C, `security_update` issued 2028-02-29, end 2030-01-01 | `keep_until(date(2038, 2, 28))` + 13_9 |
| `update_after_support_period` | C, issued 2031-01-02, end 2031-01-01 | `not_applicable_outside_support_period` + 13_9 |
| `duplicate_and_unknown_keys` | input check | `[duplicate_key(placing_on_market_date), unknown_key(colour)]` |
