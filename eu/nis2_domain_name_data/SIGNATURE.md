# SIGNATURE — eu/nis2_domain_name_data

## Public query surface (one paragraph)

The facade gives the eligibility-style verdict on whether an entity is an Art 28 addressee:

`decide_nis2_domain_name_data(PROFILE, nis2_domain_name_data_verdict(STATUS, CITATIONS))`

`nis2_domain_name_data_status(PROFILE, STATUS)` projects STATUS from that verdict.

The five contract queries of the interface give the substance:

- `provider_duties/2`
- `required_registration_data/2`
- `publication_duty/3`
- `access_duty/3`
- `access_reply_timeliness/3`

The input check is `nis2_domain_name_data_input_problems/2`.

PROFILE is `[attribute(KEY, VALUE), ...]` and is read only with `formalize_lib:profile_get/3`.

**Totality.** Every query yields exactly ONE solution for every ground input. The routes are disjoint clause heads, with no `!`, `->` or `*->`.

**Imported figures.** No figure is imported from another domain. The only statutory figure, 72 hours, is owned by the slice.

## Verdict STATUS atoms (replace scaffold `required/permitted/not_applicable`)

STATUS is one of the following. The bare atom `indeterminate` is never written.

| STATUS | When |
|---|---|
| `addressed_provider` | `provider_type` is `tld_name_registry` or `domain_name_registration_service_entity`. Art 28 duties apply. |
| `not_addressed_provider` | `provider_type` is `other`. Art 28 gives no duty. |
| `indeterminate([provider_type])` | `provider_type` is absent. |
| `input_problems(PROBLEMS)` | The input check fails. |

The kit labels are `labels(addressed_provider, provider_type_unstated, not_addressed_provider)`. `provider_type_unstated` is internal only: head-folded clauses map it to `indeterminate([provider_type])`, so it never reaches the caller.

The result atoms of the contract queries are listed in the slice section below.

The status compounds are:

- `indeterminate/1`
- `needs_legal_review/2`, with `open_textured/2` and `inputs_relied_on/1`; `provenance/2` is optional and unscored
- `input_problems/1`, with `unknown_key/1`, `wrong_type/1` and `duplicate_key/1`

The other result constructors are `duty/2`, `field/2` and `late/1`.

## Profile keys (root_exports order = input_contract order)

| # | Key | Kind | Values | Source |
|---|---|---|---|---|
| 1 | `provider_type` | enumeration | `tld_name_registry`, `domain_name_registration_service_entity`, `other` | Art 28(1)-(6) |
| 2 | `point_of_contact_email_address_differs_from_registrant` | crisp | `true`, `false` | Art 28(2)(d) |
| 3 | `point_of_contact_telephone_number_differs_from_registrant` | crisp | `true`, `false` | Art 28(2)(d) |
| 4 | `registration_data_is_personal_data` | judgement | `true`, `false`, `unsure` | Art 28(4) |
| 5 | `requester_is_legitimate_access_seeker` | judgement | `true`, `false`, `unsure` | Art 28(5) |
| 6 | `request_is_lawful_and_duly_substantiated` | judgement | `true`, `false`, `unsure` | Art 28(5) |
| 7 | `reply_without_undue_delay` | judgement | `true`, `false`, `unsure` | Art 28(5) |

Non-profile input:

- `HOURS_ELAPSED` is a non-negative integer in whole hours, rounded up from receipt to reply.
- The deadline helpers take `datetime/7` objects from `library(datetime)`: `ReceiptDatetime` and `ReplyDatetime`.
- There are no date triples and no ISO strings inside the logic. At a JSON boundary, use `datetime_string_iso/2`.

## Citation-key atoms (canonical lexicon; never shortened)

- `eu_dir_2022_2555_art_28_1`
- `eu_dir_2022_2555_art_28_2`
- `eu_dir_2022_2555_art_28_2_a`
- `eu_dir_2022_2555_art_28_2_b`
- `eu_dir_2022_2555_art_28_2_c`
- `eu_dir_2022_2555_art_28_2_d`
- `eu_dir_2022_2555_art_28_3`
- `eu_dir_2022_2555_art_28_4`
- `eu_dir_2022_2555_art_28_5`
- `eu_dir_2022_2555_art_28_6`

All are written as `cite(KEY)`.

## Public predicates

### Facade

- `decide_nis2_domain_name_data(Profile, Verdict)`: Verdict is `nis2_domain_name_data_verdict(Status, Citations)`; one solution.
  - `addressed_provider` has Citations `[cite(eu_dir_2022_2555_art_28_1), cite(eu_dir_2022_2555_art_28_2), cite(eu_dir_2022_2555_art_28_3), cite(eu_dir_2022_2555_art_28_4), cite(eu_dir_2022_2555_art_28_5), cite(eu_dir_2022_2555_art_28_6)]`.
  - `not_addressed_provider` has Citations `[cite(eu_dir_2022_2555_art_28_1)]`.
  - Non-final statuses have Citations `[]`.
  - Source: Art 28(1)-(6).
- `nis2_domain_name_data_status(Profile, Status)`: the STATUS of the verdict above. Source: Art 28(1).
- `nis2_domain_name_data_checklist(Profile, Checklist)`: the justification checklist (query type #7). Every item carries `cite(...)`, met items included.
  - `item(provider_type_stated, Status, cite(eu_dir_2022_2555_art_28_1))`.
  - `item(provider_is_addressed, Status, cite(eu_dir_2022_2555_art_28_1))`.
  - For an addressed provider, one more item per duty, in article order, with Status `applicable`:
    `item(DutyAtom, applicable, cite(Key))`.
  - The checklist is built by `formalize_lib:assess/6` with closure `nis2_domain_name_data_requirement`, called as `(RequirementId, Profile, Status, Citation)`.
- `nis2_domain_name_data_what_if(Profile, Key, Value, Verdict)`: the verdict after overriding Key with Value, via `kit/query_combinators:what_if/5` with closure `decide_nis2_domain_name_data`. Source: as decide.
- Fixtures (in `fixtures.clausal`):
  - `nis2_domain_name_data_fixture(Name, Profile)`.
  - `nis2_domain_name_data_fixture_hours(Name, Profile, HoursElapsed)`.
  - Named fixtures: `registry_full_profile`, `registrar_point_of_contact_same`, `registrar_email_differs_only`, `other_entity`, `provider_type_absent`, `personal_data_unsure`, `access_seeker_false_lawful_absent`, `access_seeker_unsure_lawful_absent`, `access_both_true`, `reply_72_hours_on_time`, `reply_73_hours_late`, `reply_unsure_undue_delay`, `duplicate_key_profile`, `unknown_key_profile`, `not_attribute_list`.

### Contract queries (interface A-F; non-negotiable shapes)

- `provider_duties(Profile, Duties)`: Duties is ONE flat ordered list of `duty(DutyAtom, cite(Key))`, or `[]` for `other`, or `indeterminate([provider_type])`, or `input_problems(P)`. Source: Art 28(1)-(6).
- `required_registration_data(Profile, Fields)`: Fields is ONE ordered list of `field(Name, cite(Key))`, or `indeterminate([K])` naming the first absent point-of-contact key, or `input_problems(P)`. Source: Art 28(2)(a)-(d).
- `publication_duty(Profile, Result, Citations)`: Result is one of `must_publish_without_undue_delay`, `no_publication_duty` or a status compound. Citations is `[cite(eu_dir_2022_2555_art_28_4)]` when final, else `[]`. Source: Art 28(4).
- `access_duty(Profile, Result, Citations)`: Result is one of `must_provide_access`, `no_duty_to_provide_access` or a status compound. Citations is `[cite(eu_dir_2022_2555_art_28_5)]` when final, else `[]`. Source: Art 28(5) first sentence.
- `access_reply_timeliness(Profile, HoursElapsed, Result)`: Result is one of `on_time`, `late(hour_limit)`, `late(without_undue_delay)` or a status compound. Source: Art 28(5) second sentence.
- `nis2_domain_name_data_input_problems(Profile, Problems)`: the BARE ordered list of problems (THE INPUT CHECK); `[]` when well-formed.

### Deadline (query type #15; convenience on native datetime; does not change the contract)

- `nis2_domain_name_data_reply_deadline(ReceiptDatetime, DeadlineDatetime)`: the latest reply moment. It is ReceiptDatetime plus `reply_hour_limit` hours, using `timedelta/3` with `Seconds = constant(reply_hour_limit) * 3600` and `date_add/3`.
  - Consequence of missing it: `access_reply_timeliness` gives `late(hour_limit)`.
  - Source: Art 28(5).
- `nis2_domain_name_data_hours_elapsed(ReceiptDatetime, ReplyDatetime, HoursElapsed)`: elapsed whole hours, rounded UP (Q8).
  - Uses `date_diff/3` to get a timedelta, then converts it to total seconds.
  - `HoursElapsed = (TotalSeconds + 3599) // 3600`.
  - Fails closed, with no solution and no clamping, if the reply precedes receipt.
  - Source: Art 28(5).

## Planned reuse (manifest `uses:`)

- **`formalize_lib`:** `profile_get/3`, `profile_has/2`, `profile_lacks/2`, `profile_keys/2`, `profile_set/3`, `assess/6`, `item/3`, `labels/3`, `not_member/2`, `memberd/2`.
- **`library(datetime)`:** `datetime/7`, `timedelta/3`, `date_add/3`, `date_diff/3`, `datetime_string_iso/2`.
- **`kit/query_combinators`:** `what_if/5`.
- **`validate_props`, in tests only:**
  - `run_props/1`, `prop_totality/3`, `prop_determinism/3`;
  - `prop_citation_complete/3`, `prop_boundary_coverage/2`, `prop_missing_key_coverage/3`;
  - `bad_citation/1`.
- **Not used:**
  - `kit/deadline_lib`, because it counts days and this order counts hours. The gap is noted in NOTES S2.
  - `check_tri/4`, because the results are domain atoms, not met/unmet. The tri-state reads are explicit head-folded clauses per value.
  - `compliance_lib`, because there is no modality lattice to combine.

## Layout (unchanged)

The build order is:

1. `kernel.clausal`
2. `citations.clausal`
3. `parameters.clausal`
4. `nis2_domain_name_data.clausal`
5. `queries.clausal`
6. `fixtures.clausal`
7. the package facade

The manifest is v2. There are seven test modes:

1. load
2. per-rule unit tests
3. fixtures and golden answers
4. boundaries (72/73)
5. missing-key coverage
6. determinism and counting (`findall` + `length(L, 1)`)
7. properties

### kernel.clausal (shared floor ONLY)

- `nis2_domain_name_data_contract_key(Key, Kind)`: the seven facts, in contract order. Kind is one of `enumeration(Atoms)`, `crisp` or `judgement`.
- `nis2_domain_name_data_input_problems(Profile, Problems)` and `nis2_domain_name_data_input_problems(Profile, HoursElapsed, Problems)`: the input check, shared by the facade, `queries.clausal` and the slice.
- `nis2_domain_name_data_pairs(Profile, JudgementKeys, Pairs)`: PAIRS is `Key-Value` for each present key, in the given order (THE PAIRS RULE).
- Nothing else lives here.

## Slice: nis2_domain_name_data.clausal

### Value facts owned

- `:- constant_value(reply_hour_limit, 72).` Source: Art 28(5); 72 is within the limit and 73 is late.
- `nis2_domain_name_data_duty_row(Position, DutyAtom, CitationKey)`: nine facts in article order.
  1. `collect_and_maintain_accurate_and_complete_registration_data`, `eu_dir_2022_2555_art_28_1`
  2. `hold_the_information_identifying_and_contacting_the_holders_and_points_of_contact`, `eu_dir_2022_2555_art_28_2`
  3. `have_policies_and_verification_procedures_for_accurate_and_complete_data`, `eu_dir_2022_2555_art_28_3`
  4. `make_the_accuracy_policies_and_procedures_publicly_available`, `eu_dir_2022_2555_art_28_3`
  5. `make_non_personal_registration_data_publicly_available`, `eu_dir_2022_2555_art_28_4`
  6. `provide_access_to_specific_registration_data_on_lawful_and_substantiated_requests`, `eu_dir_2022_2555_art_28_5`
  7. `reply_to_access_requests_within_72_hours`, `eu_dir_2022_2555_art_28_5`
  8. `make_the_disclosure_policies_and_procedures_publicly_available`, `eu_dir_2022_2555_art_28_5`
  9. `cooperate_to_avoid_duplicate_collection_of_registration_data`, `eu_dir_2022_2555_art_28_6`
- `nis2_domain_name_data_base_field(Position, Name, CitationKey)`: five fixed fields.
  - `domain_name`, `eu_dir_2022_2555_art_28_2_a`
  - `date_of_registration`, `eu_dir_2022_2555_art_28_2_b`
  - `registrant_name`, `eu_dir_2022_2555_art_28_2_c`
  - `registrant_contact_email_address`, `eu_dir_2022_2555_art_28_2_c`
  - `registrant_telephone_number`, `eu_dir_2022_2555_art_28_2_c`
- Conditional fields: `point_of_contact_contact_email_address` and `point_of_contact_telephone_number`, both `eu_dir_2022_2555_art_28_2_d`.

### Rules (THE LIMBS; first step that answers decides; each one head-folded clause per disjoint route)

Step (0), common to every query: when Problems is non-empty, the result is `input_problems(Problems)`, with Citations `[]` where there is a citations argument.

**provider_duties**

- (1) `provider_type` absent: `indeterminate([provider_type])`.
- (2) `other`: `[]`.
- (3) `tld_name_registry` or `domain_name_registration_service_entity`: the nine duties, in order. The list is built deterministically from the rows, sorted by Position.

**required_registration_data**

- (4) Email key absent: `indeterminate([point_of_contact_email_address_differs_from_registrant])`. Otherwise telephone key absent: `indeterminate([point_of_contact_telephone_number_differs_from_registrant])`.
- (5) Otherwise, four clauses, one per (email, telephone) value pair from `{true, false}` x `{true, false}`. Each gives the five base fields, then the email field if email is true, then the telephone field if telephone is true. Point (d) is read per element (Q2).

**publication_duty**

- (6) Absent: `indeterminate([registration_data_is_personal_data])`, `[]`.
- (7) `unsure`: `needs_legal_review(open_textured(registration_data_is_personal_data, cite(eu_dir_2022_2555_art_28_4)), [inputs_relied_on(Pairs)])`, `[]`.
- (8) `false`: `must_publish_without_undue_delay`, `[cite(eu_dir_2022_2555_art_28_4)]`.
- (9) `true`: `no_publication_duty`, `[cite(eu_dir_2022_2555_art_28_4)]`.

**access_duty** (S = `requester_is_legitimate_access_seeker`, L = `request_is_lawful_and_duly_substantiated`)

- (10) S false, or (S not false and L false): `no_duty_to_provide_access`, `[cite(eu_dir_2022_2555_art_28_5)]`. The clauses are written disjointly so the answer is yielded once even when both are false: S=false is one clause, and S in {true, unsure, absent} with L=false is another.
- (11) No false and S absent: `indeterminate([S])`. No false, S present and L absent: `indeterminate([L])`. This holds even when the other key is unsure.
- (12) Both present, none false, S unsure: `open_textured(S, cite(eu_dir_2022_2555_art_28_5))`. Otherwise L unsure: the same with L. Pairs are S-Value then L-Value.
- (13) Both true: `must_provide_access`, `[cite(eu_dir_2022_2555_art_28_5)]`.

**access_reply_timeliness**

- (14) `HoursElapsed > constant(reply_hour_limit)`: `late(hour_limit)`. No key is read, and there is no exception.
- (15) `HoursElapsed =< constant(reply_hour_limit)`, then by `reply_without_undue_delay`:
  - absent: `indeterminate([reply_without_undue_delay])`;
  - true: `on_time`;
  - false: `late(without_undue_delay)`;
  - unsure: `needs_legal_review(open_textured(reply_without_undue_delay, cite(eu_dir_2022_2555_art_28_5)), [inputs_relied_on(Pairs)])`.

**Deadline helpers**

- `nis2_domain_name_data_reply_deadline/2` and `nis2_domain_name_data_hours_elapsed/3`, as above.

**Facade requirements** (for `assess/6`; three exclusive clauses each)

- `nis2_domain_name_data_requirement(provider_type_stated, Profile, Status, cite(eu_dir_2022_2555_art_28_1))`: met when present, `unknown([provider_type])` when absent.
- `nis2_domain_name_data_requirement(provider_is_addressed, Profile, Status, cite(eu_dir_2022_2555_art_28_1))`:
  - met for `tld_name_registry` or `domain_name_registration_service_entity`;
  - `unmet(provider_type_other)` for `other`;
  - `unknown([provider_type])` when absent.

### Verdict atoms of this slice

- Facade: `addressed_provider`, `not_addressed_provider`, `indeterminate([provider_type])`, `input_problems(P)`.
- Queries:
  - `must_publish_without_undue_delay`, `no_publication_duty`;
  - `must_provide_access`, `no_duty_to_provide_access`;
  - `on_time`, `late(hour_limit)`, `late(without_undue_delay)`;
  - the DUTIES list, the FIELDS list;
  - `indeterminate([Key])`, `needs_legal_review(open_textured(Key, cite(Citation)), [inputs_relied_on(Pairs)])`.

### Shared with another slice (lives in kernel.clausal)

- The input check.
- The contract-key table.
- `nis2_domain_name_data_pairs/3`.

There is no other slice, so nothing else is shared.

### Per-rule tests owned by the slice

Every test asserts exactly one solution with `findall` + `length(L, 1)`.

- **Duties:**
  - order for both addressed types;
  - `[]` for `other`;
  - indeterminate when `provider_type` is absent.
- **Fields:** all four (email, telephone) combinations; email absent; telephone absent with email present.
- **Publication:** each of the four routes.
- **Access:**
  - S=false with L absent, unsure, true or false gives no duty once;
  - S unsure with L absent gives `indeterminate([request_is_lawful_and_duly_substantiated])`;
  - S absent with L unsure gives `indeterminate([requester_is_legitimate_access_seeker])`;
  - both unsure refers on S;
  - both true gives `must_provide_access`.
- **Reply:**
  - 0, 72 and 73 hours;
  - 73 hours with the key absent still gives `late(hour_limit)`;
  - 72 hours in each of the four key states.
- **Hours elapsed:** 72 h 30 min gives 73.
- **Input check:**
  - a duplicate key with equal values gives only `duplicate_key`;
  - `unknown_key` once per key, in first-occurrence order;
  - a non-attribute list gives `[wrong_type(profile)]`;
  - `access_reply_timeliness` with a bad profile and hours of -1 gives `[wrong_type(profile), wrong_type(hours_elapsed)]`.

Each negative test is paired with a positive test over the same case.
