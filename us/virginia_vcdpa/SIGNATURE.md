# SIGNATURE — us/virginia_vcdpa

## Public surface

The package facade is built over the queries below.

- `decide_virginia_vcdpa(Profile, virginia_vcdpa_verdict(Status, Citations))` gives the coverage verdict with its citations.
- `virginia_vcdpa_status(Profile, Status)` gives the verdict status alone.
- Status is the `applicability_status/3` answer.

Totality and determinism: every public query yields exactly ONE solution for every input term, unbound terms included.

- Routes are disjoint clauses with ground outputs in the head (C17).
- No cut, `->` or `*->` is used.
- No `once/1` or findall dedupe is used.

Statutory figures are declared once with `constant_value/2` in `virginia_vcdpa.clausal` and are never re-declared.

## Verdict STATUS atoms

These replace the placeholder set `{ required, permitted, not_applicable }`.

**Final atoms, by query:**

| Query | Final answers |
|---|---|
| applicability_status | `in_scope`, `out_of_scope`, `exempt_entity` |
| extended_response_deadline | `no_extension_available`, besides a date |
| attorney_general_action_status | `notice_not_yet_provided`, `cure_period_running`, `action_may_be_initiated`, `no_action_for_cured_violation` |
| response_deadline, appeal_response_deadline, cure_period_last_day | a `date(Y, M, D)` term |
| civil_penalty_maximum | a non-negative integer |

**Not-final compounds:** each stands alone in the answer position, never in a list, always with Citations `[]`.

- `input_problems(Problems)`
- `indeterminate([Key])`, holding exactly one key. The bare atom `indeterminate` is never written.
- `needs_legal_review(open_textured(Key, cite(Citation)), [inputs_relied_on([Key-unsure])])`

An optional, unscored `provenance(Step, Citations)` may trail the context list.

**Constructors (exported, never queried):** `indeterminate/1`, `needs_legal_review/2`, `open_textured/2`, `inputs_relied_on/1`, `provenance/2`, `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`.

## Profile keys

The profile is `[attribute(Key, Value), ...]`, read only with `profile_get/3`. Keys are listed in root_exports / input_contract order:

| # | Key | Kind | Values |
|---|---|---|---|
| 1 | `entity_category` | enumeration | `public_body_of_the_commonwealth`, `financial_institution_subject_to_glba`, `hipaa_covered_entity_or_business_associate`, `nonprofit_organization`, `institution_of_higher_education`, `none_of_the_exempt_categories` |
| 2 | `conducts_business_in_or_targets_virginia` | judgement | `true`, `false`, `unsure` |
| 3 | `consumer_count` | figure | non-negative integer (a count of consumers; the unit is persons) |
| 4 | `over_half_of_gross_revenue_from_sale` | crisp | `true`, `false` |
| 5 | `extension_reasonably_necessary` | judgement | `true`, `false`, `unsure` |
| 6 | `extension_notice_given_within_initial_period` | crisp | `true`, `false` |
| 7 | `cured_with_express_written_statement` | crisp | `true`, `false` |
| 8 | `continued_violation_or_statement_breached` | crisp | `true`, `false` |
| 9 | `violation_count` | figure | non-negative integer (a count of violations) |

Key names are fixed by the contract. Figure keys are counts, so they carry no money unit.

The atoms `glba` and `hipaa` are contract-fixed proper names. They carry the pragma `% lint: allow-abbreviation(contract atom)`.

**Date arguments (not profile keys).** These are ground `date(Year, Month, Day)` terms of a real Gregorian day, with Year from 2000 to 2100.

| Argument | Problem term when invalid |
|---|---|
| `ReceivedDate` | `received_date` |
| `AppealReceivedDate` | `appeal_received_date` |
| `NoticeDate` | `notice_date` |
| `ReferenceDate` | `reference_date` |

## Citation-key atoms

These come from the canonical lexicon `_lexicon/citations.yaml`, declared in `citations.clausal`. Never shorten them.

**Cited in answers:**

| Citation key | Provision |
|---|---|
| `us_va_code_59_1_576_a` | 59.1-576(A) |
| `us_va_code_59_1_576_b` | 59.1-576(B) |
| `us_va_code_59_1_577_b_1` | 59.1-577(B)(1) |
| `us_va_code_59_1_577_b_2` | 59.1-577(B)(2) |
| `us_va_code_59_1_577_c` | 59.1-577(C) |
| `us_va_code_59_1_584_b` | 59.1-584(B) |
| `us_va_code_59_1_584_c` | 59.1-584(C) |

**Deferred-unit entries.** These are recorded in `citations.clausal` with status `deferred` and are never emitted in an answer:

- `us_va_code_59_1_575_consumer`
- `us_va_code_59_1_575_personal_data`
- `us_va_code_59_1_575_sale_of_personal_data`
- `us_va_code_59_1_575_nonprofit_organization`
- `us_va_code_59_1_575_institution_of_higher_education`
- `us_va_code_59_1_577_b`

## Public predicates

**Facade:**

- `decide_virginia_vcdpa(Profile, Verdict)`: Verdict = `virginia_vcdpa_verdict(Status, Citations)` from `applicability_status/3`. Cites us_va_code_59_1_576_a and us_va_code_59_1_576_b.
- `virginia_vcdpa_status(Profile, Status)`: Status of the coverage verdict alone. Cites us_va_code_59_1_576_a and us_va_code_59_1_576_b.
- `virginia_vcdpa_checklist(Profile, Checklist)`: query type #7. A checklist of `item(RequirementId, Status, cite(Key))` built by `assess/6`; every item, met included, carries its cite. Cites us_va_code_59_1_576_a and us_va_code_59_1_576_b.
- `virginia_vcdpa_what_if(Profile, Key, Value, Status)`: Status after `profile_set(Profile, attribute(Key, Value), NewProfile)`, re-decided with `virginia_vcdpa_status/2`. Cites us_va_code_59_1_576_a and us_va_code_59_1_576_b.
- `virginia_vcdpa_fixture(Name, Profile)` (the fixtures facade): named, ground example profiles. No citation.

**Contract queries:**

- `applicability_status(Profile, Result, Citations)`: query type #3. Limbs (0) to (6). Cites us_va_code_59_1_576_a and us_va_code_59_1_576_b.
- `response_deadline(Profile, ReceivedDate, Deadline, Citations)`: query type #15. ReceivedDate + 45 days. Cites us_va_code_59_1_577_b_1 and us_va_code_59_1_577_b_2.
- `extended_response_deadline(Profile, ReceivedDate, Deadline, Citations)`: query type #15. Gives ReceivedDate + 90 days or `no_extension_available`. Limbs (8) to (12). Cites us_va_code_59_1_577_b_1.
- `appeal_response_deadline(Profile, AppealReceivedDate, Deadline, Citations)`: query type #15. AppealReceivedDate + 60 days. Cites us_va_code_59_1_577_c.
- `cure_period_last_day(Profile, NoticeDate, LastDay, Citations)`: query type #15. NoticeDate + 30 days. Cites us_va_code_59_1_584_b.
- `attorney_general_action_status(Profile, NoticeDate, ReferenceDate, Result, Citations)`: query types #3 and #15. Limbs (15) to (19). Cites us_va_code_59_1_584_b and us_va_code_59_1_584_c.
- `civil_penalty_maximum(Profile, Maximum, Citations)`: query type #23. 7500 × violation_count, an exact integer. Cites us_va_code_59_1_584_c.
- `virginia_vcdpa_input_problems(Profile, Problems)`: the bare problem list of THE INPUT CHECK. No citation.

**Threshold queries (query type #6):**

- `virginia_vcdpa_applicability_threshold(Limb, MinimumConsumerCount, Citation)`: two rows, both citing us_va_code_59_1_576_a.
  - `general_threshold`: 100000
  - `sale_of_personal_data_threshold`: 25000, with the revenue share strictly over half
- `virginia_vcdpa_consumer_count_boundary(Profile, Boundary)`: the lowest consumer_count at which the coverage status flips, given the other keys. It is found by `bisect_flip(0, 200000, consumer_count_status_at(Profile), Boundary)`. The closure sets `consumer_count` with `profile_set/3` and calls `virginia_vcdpa_status/2`. Cites us_va_code_59_1_576_a.

## Planned reuse (manifest `uses:`)

**`formalize_lib`:**

- profile access: `profile_get/3`, `profile_has/2`, `profile_lacks/2`, `profile_set/3`, `memberd/2`
- checklist engine: `assess/6`, `labels/3`, `item/3`, `unmet/1`, `unknown/1`, `assessment/3`

**`kit/deadline_lib`:**

- `deadline/4` (NormId, PeriodDays, TriggerDate, DeadlineDate), the native datetime wrapper for D + N
- `date_before/2` and `date_on_or_before/2` for the action-status comparisons
- `month_last_day/3` for date validity

**`kit/query_combinators`:** `bisect_flip/4` for the threshold boundary.

**`validate_props` (tests only):**

- `run_props/1`
- `prop_totality/3`, `prop_determinism/3`
- `prop_citation_complete/3`
- `prop_boundary_coverage/2`, `prop_missing_key_coverage/3`
- `prop_monotone/5`: consumer_count, in_scope is monotone upward

**Engine rules:**

- Dates use library(datetime) through deadline_lib. They are never hand-rolled. They are compared with deadline_lib or with `@<` / `@=<`, never with `<`.
- No family-backbone (`_common`) predicates are needed. The deontic family's compliance_lib is not used, because the order never decides breach.

## Module layout (unchanged)

kernel → citations → parameters → virginia_vcdpa → queries → fixtures → package facade

- `parameters.clausal` re-exports nothing statutory. It holds only the date-year bounds 2000 and 2100: `constant_value(earliest_supported_year, 2000)` and `constant_value(latest_supported_year, 2100)`.
- `queries.clausal` hosts the threshold and boundary queries.
- `fixtures.clausal` hosts `virginia_vcdpa_fixture/2`.

## Slice: kernel.clausal (shared floor only)

**Shared predicates.** They are used by `virginia_vcdpa.clausal`, the queries module and the facade.

- `virginia_vcdpa_input_problems(Profile, Problems)` implements THE INPUT CHECK.
  - **Not an attribute list.** A non-list, a partial list, an unbound profile, or any element that is not `attribute(_, _)` gives `[wrong_type(profile)]`.
  - **Contract keys, in contract order.** Each key gives `duplicate_key(Key)` if it occurs more than once; its values are not read. Otherwise it gives `wrong_type(Key)` if its value has the wrong type; an unbound value counts as a wrong type.
  - **Unknown keys.** Then each key outside the nine gives `unknown_key(Key)`, once, in order of first occurrence. A non-atom or variable key is unknown as given.
- `contract_key(Key, Kind)`: nine facts in root_exports order, where Kind is `enumeration(Atoms)`, `judgement`, `crisp` or `figure`.
- `valid_contract_date(Date)`: succeeds only for a ground `date(Year, Month, Day)` of integers, with Year from 2000 to 2100, Month from 1 to 12, and Day from 1 to `month_last_day(Year, Month, LastDay)`.
- `date_argument_problems(NamedDates, Problems)`: walks a list of `ArgumentName-Date` pairs in signature order and yields `wrong_type(ArgumentName)` for each invalid date.
- `query_problems(Profile, NamedDates, Problems)`: the profile problems followed by the date problems (limb step 0).
- `value_or_absent(Profile, Key, Value)`: Value is the profile value, or the atom `absent` when the key is missing. It yields exactly one solution once the input check is clean. Route clauses then guard positively by unification against `absent`, `true`, `false` or `unsure`.

Determinism of the kernel is by disjoint clauses. Counting uses `findall/3` with `length/2`.

## Slice: virginia_vcdpa.clausal (the whole determination)

### Value facts owned here

```
:- constant_value(general_consumer_threshold, 100000).
:- constant_value(sale_limb_consumer_threshold, 25000).
:- constant_value(response_period_days, 45).
:- constant_value(extended_response_period_days, 90).
:- constant_value(extension_period_days, 45).
:- constant_value(appeal_response_period_days, 60).
:- constant_value(cure_period_days, 30).
:- constant_value(civil_penalty_per_violation_usd_dollars, 7500).
```

Extended response period = response period + extension period. A unit test asserts that 45 + 45 = 90.

The NormIds passed to `deadline/4` are:

- `consumer_request_response`
- `consumer_request_extended_response`
- `appeal_response`
- `attorney_general_cure_period`

### Rules and requirements (one disjoint clause per route; ground outputs in heads)

In every route below, `query_problems(...)` must equal `[]` first. When it is non-empty, the route is `input_problems(Problems)` with Citations `[]`. That is step (0), for all seven queries.

**applicability_status/3.** Let Category, Link, Count and Share be the `value_or_absent` values of the four keys.

| Step | Condition | Result | Citations |
|---|---|---|---|
| (1) | Category is `absent` | `indeterminate([entity_category])` | `[]` |
| (2) | Category is one of the 5 exempt atoms (`exempt_category/1` facts) | `exempt_entity` | `[cite(us_va_code_59_1_576_b)]` |
| (3a) | Category is `none_of_the_exempt_categories`, Link is `false` | `out_of_scope` | `[cite(us_va_code_59_1_576_a)]` |
| (3b) | Link in {absent, true, unsure}, Count is an integer < 25000 | `out_of_scope` | `[cite(us_va_code_59_1_576_a)]` |
| (3c) | Link in {absent, true, unsure}, 25000 =< Count =< 99999, Share is `false` | `out_of_scope` | `[cite(us_va_code_59_1_576_a)]` |
| (4a) | Link is `absent`, and no 3b/3c route | `indeterminate([conducts_business_in_or_targets_virginia])` | `[]` |
| (4b) | Link in {true, unsure}, Count is `absent` | `indeterminate([consumer_count])` | `[]` |
| (4c) | Link in {true, unsure}, Count in 25000..99999, Share is `absent` | `indeterminate([over_half_of_gross_revenue_from_sale])` | `[]` |
| (5) | Link is `unsure`, and Count >= 100000 or (Count in 25000..99999 and Share is `true`) | `needs_legal_review(open_textured(conducts_business_in_or_targets_virginia, cite(us_va_code_59_1_576_a)), [inputs_relied_on([conducts_business_in_or_targets_virginia-unsure])])` | `[]` |
| (6) | Link is `true`, and Count >= 100000 or (Count in 25000..99999 and Share is `true`) | `in_scope` | `[cite(us_va_code_59_1_576_a)]` |

Route (4a) splits into disjoint clauses on Count: absent, at least 100000, or 25000..99999 with Share `true` or `absent`. Routes (5) and (6) are each two clauses, split on the Count band.

**response_deadline/4**

| Step | Condition | Deadline | Citations |
|---|---|---|---|
| (7) | — | `deadline(consumer_request_response, constant(response_period_days), ReceivedDate, Deadline)` | `[cite(us_va_code_59_1_577_b_1), cite(us_va_code_59_1_577_b_2)]` |

**extended_response_deadline/4.** Let Necessary = `extension_reasonably_necessary` and Notice = `extension_notice_given_within_initial_period`.

| Step | Condition | Deadline | Citations |
|---|---|---|---|
| (8) | Notice is `false` | `no_extension_available` | `[cite(us_va_code_59_1_577_b_1)]` |
| (9) | Notice in {absent, true}, Necessary is `false` | `no_extension_available` | `[cite(us_va_code_59_1_577_b_1)]` |
| (10a) | Necessary is `absent`, Notice in {absent, true} | `indeterminate([extension_reasonably_necessary])` | `[]` |
| (10b) | Necessary in {true, unsure}, Notice is `absent` | `indeterminate([extension_notice_given_within_initial_period])` | `[]` |
| (11) | Necessary is `unsure`, Notice is `true` | `needs_legal_review(open_textured(extension_reasonably_necessary, cite(us_va_code_59_1_577_b_1)), [inputs_relied_on([extension_reasonably_necessary-unsure])])` | `[]` |
| (12) | Necessary is `true`, Notice is `true` | ReceivedDate + `constant(extended_response_period_days)` | `[cite(us_va_code_59_1_577_b_1)]` |

**appeal_response_deadline/4**

| Step | Condition | Deadline | Citations |
|---|---|---|---|
| (13) | — | AppealReceivedDate + 60 | `[cite(us_va_code_59_1_577_c)]` |

**cure_period_last_day/4**

| Step | Condition | LastDay | Citations |
|---|---|---|---|
| (14) | — | NoticeDate + 30 | `[cite(us_va_code_59_1_584_b)]` |

**attorney_general_action_status/5.** Let LastDay = NoticeDate + 30, Cured = `cured_with_express_written_statement` and Continued = `continued_violation_or_statement_breached`.

| Step | Condition | Result | Citations |
|---|---|---|---|
| (15) | `date_before(ReferenceDate, NoticeDate)` | `notice_not_yet_provided` | `[cite(us_va_code_59_1_584_b)]` |
| (16) | `date_on_or_before(NoticeDate, ReferenceDate)` and `date_on_or_before(ReferenceDate, LastDay)` | `cure_period_running` | `[cite(us_va_code_59_1_584_b)]` |
| (17a) | `date_before(LastDay, ReferenceDate)`, Cured is `false` | `action_may_be_initiated` | `[cite(us_va_code_59_1_584_b), cite(us_va_code_59_1_584_c)]` |
| (17b) | `date_before(LastDay, ReferenceDate)`, Cured in {absent, true}, Continued is `true` | `action_may_be_initiated` | `[cite(us_va_code_59_1_584_b), cite(us_va_code_59_1_584_c)]` |
| (18a) | after LastDay, Cured is `absent`, Continued in {absent, false} | `indeterminate([cured_with_express_written_statement])` | `[]` |
| (18b) | after LastDay, Cured is `true`, Continued is `absent` | `indeterminate([continued_violation_or_statement_breached])` | `[]` |
| (19) | after LastDay, Cured is `true`, Continued is `false` | `no_action_for_cured_violation` | `[cite(us_va_code_59_1_584_b)]` |

**civil_penalty_maximum/3**

| Step | Condition | Maximum | Citations |
|---|---|---|---|
| (20) | `violation_count` is `absent` | `indeterminate([violation_count])` | `[]` |
| (21) | `violation_count` is a value | `constant(civil_penalty_per_violation_usd_dollars) * Count`, an exact integer | `[cite(us_va_code_59_1_584_c)]` |

### Checklist requirements (#7)

The checklist uses `requirement(RequirementId, Profile, Status, Citation)`. Each requirement has exactly three clauses: met, `unmet(Reason)`, and `unknown([Key])`.

| Requirement | Citation | Rule |
|---|---|---|
| `not_in_exempt_category` | `cite(us_va_code_59_1_576_b)` | The person is in none of the exempt categories. |
| `business_link_with_virginia` | `cite(us_va_code_59_1_576_a)` | `true` is met, `false` is unmet. `unsure` gives unknown, because the matter is referred. |
| `consumer_threshold_reached` | `cite(us_va_code_59_1_576_a)` | Count >= 100000, or Count in 25000..99999 with Share `true`. |

The checklist call is `assess(Profile, [not_in_exempt_category, business_link_with_virginia, consumer_threshold_reached], Profile, requirement, labels(in_scope, indeterminate, out_of_scope), Result)`.

The checklist explains the verdict. The verdict itself comes from the limbs. A consistency property checks that all items met implies `in_scope`.

### Verdict atoms of this slice

`in_scope`, `out_of_scope`, `exempt_entity`, `no_extension_available`, `notice_not_yet_provided`, `cure_period_running`, `action_may_be_initiated`, `no_action_for_cured_violation`, and the not-final compounds above.

### Shared with another slice

This slice shares nothing beyond the kernel predicates listed above. All statutory value facts stay in this file.

## Fixtures (named profiles)

| Fixture | Profile | Expected applicability |
|---|---|---|
| `large_virginia_controller` | none_of_the_exempt_categories, true, 150000 | `in_scope` |
| `data_broker_mid_size` | none, true, 30000, share true | `in_scope` |
| `mid_size_not_broker` | none, true, 30000, share false | `out_of_scope` |
| `exactly_general_threshold` | count 100000 | `in_scope` |
| `just_below_general_threshold` | count 99999, share false | `out_of_scope` |
| `exactly_sale_threshold` | count 25000, share true | `in_scope` |
| `just_below_sale_threshold` | count 24999 | `out_of_scope` |
| `hospital_hipaa` | hipaa_covered_entity_or_business_associate | `exempt_entity` |
| `unsure_business_link` | none, unsure, 150000 | `needs_legal_review` |
| `empty_profile` | `[]` | `indeterminate([entity_category])` |

## Tests (seven modes)

1. **Per-limb unit tests.** One test per step (0) to (21), each paired with a negative over the same case.
2. **Boundaries.**
   - counts 24999, 25000, 99999, 100000
   - reference days NoticeDate − 1, NoticeDate, NoticeDate + 30, NoticeDate + 31
3. **Dates.**
   - 2026-01-01 + 45 = 2026-02-15
   - 2026-01-01 + 90 = 2026-04-01
   - 2026-03-01 + 60 = 2026-04-30
   - 2026-12-15 + 30 = 2027-01-14
   - 2028-02-01 + 45 = 2028-03-17
   - 2027-02-01 + 45 = 2027-03-18
4. **Input problems.**
   - unknown_key, wrong_type, duplicate_key, in that order
   - `wrong_type(profile)`
   - `date(2100, 2, 29)` and `date(1999, 12, 31)` give the date wrong_type
   - an unbound date argument gives the date wrong_type
5. **Missing-key and unsure precedence**, including the behind test: Share is never named while Count is absent.
6. **Counting.** `findall` with `length(Solutions, 1)` for every query.
7. **Properties** via validate_props: totality, determinism, citation completeness, monotonicity in consumer_count.

Penalty examples: 0 gives 0, and 3 gives 22500.
