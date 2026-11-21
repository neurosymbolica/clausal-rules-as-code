# SIGNATURE — us/texas_tdpsa

## Public query surface

The facade is `decide_texas_tdpsa(Profile, texas_tdpsa_verdict(Status, Citations))` and `texas_tdpsa_status(Profile, Status)`.

Both project the **applicability** determination of Sec. 541.002, the classification query (#3). `Status` is the RESULT of `applicability_status/4` and `Citations` is its CITATIONS list.

The seven contract queries are below. Each takes PROFILE first and yields exactly ONE solution. Every query is total over all terms, including unbound and malformed input. It never fails and never raises; malformed input gives `input_problems(Problems)`.

## Verdict STATUS atoms (replace scaffold `required / permitted / not_applicable`)

| Query | Final result atoms |
|---|---|
| applicability | `in_scope`, `out_of_scope` |
| extended response deadline | `no_extension_available` (or a date) |
| attorney general action status | `cure_period_running`, `action_may_be_brought`, `no_action_for_cured_violation` |
| civil penalty maximum | `no_civil_penalty` (or a bare integer of whole US dollars) |
| response, appeal, cure deadlines | a `date(Year, Month, Day)` |

The not-final status compounds are:

- `indeterminate([Key])`, naming exactly one key;
- `needs_legal_review(open_textured(Key, cite(C)), [inputs_relied_on(Pairs)])`;
- `needs_legal_review(cross_reference_unresolved(cite(us_tx_bc_541_002_a_3), cite(sba_small_business_size_determination)), [resolution(cite(sba_small_business_size_determination), not_attempted), inputs_relied_on([small_business_as_defined_by_sba-absent])])`;
- `input_problems(Problems)`.

The bare atom `indeterminate` is never written.

Other atoms used are `unsure`, `absent`, `not_attempted`, `true` and `false`.

## Profile keys (attribute list, read only with `profile_get/3`; root_exports order)

| # | Key | Type | Values |
|---|---|---|---|
| 1 | `entity_category` | enumeration | `state_agency_or_political_subdivision`, `financial_institution`, `covered_entity_or_business_associate_under_hipaa`, `nonprofit_organization`, `institution_of_higher_education`, `electric_utility_power_generation_company_or_retail_electric_provider`, `none_of_the_excluded_categories` |
| 2 | `processes_or_sells_personal_data` | crisp | `true` / `false` |
| 3 | `conducts_business_in_texas_or_serves_texas_residents` | judgement | `true` / `false` / `unsure` |
| 4 | `small_business_as_defined_by_sba` | outside fact | `attested(true\|false, attestation(By, At, Reason, Evidence))`; Evidence is `url(Url, RetrievedAt)`, `document(UploadId, Sha256)` or `none` |
| 5 | `extension_reasonably_necessary` | judgement | `true` / `false` / `unsure` |
| 6 | `extension_notice_given_within_initial_period` | crisp | `true` / `false` |
| 7 | `cured_within_cure_period` | crisp | `true` / `false` |
| 8 | `written_statement_provided` | crisp | `true` / `false` |
| 9 | `written_statement_breached` | crisp | `true` / `false` |
| 10 | `violation_after_cure_period_or_statement_breach` | crisp | `true` / `false` |
| 11 | `violation_count` | figure | integer ≥ 0 |

The date arguments are not profile keys: `ReceivedDate`, `AppealReceivedDate`, `NoticeDate` and `ReferenceDate`. Each is `date(Year, Month, Day)` of bare integers naming a real Gregorian day, with Year from 1 to 9999.

Money is whole US dollars as a bare integer (`usd` from `currency_vocab`, named in documentation only). No float is ever produced.

## Citation-key atoms (canonical lexicon, `_lexicon/citations.yaml`)

The statute keys are:

- `us_tx_bc_541_002_a`, `us_tx_bc_541_002_a_1`, `us_tx_bc_541_002_a_2`, `us_tx_bc_541_002_a_3`;
- `us_tx_bc_541_002_b`, `us_tx_bc_541_002_b_1`, `us_tx_bc_541_002_b_2`, `us_tx_bc_541_002_b_3`, `us_tx_bc_541_002_b_4`, `us_tx_bc_541_002_b_5`, `us_tx_bc_541_002_b_6`;
- `us_tx_bc_541_052_b`, `us_tx_bc_541_052_c`, `us_tx_bc_541_053_c`;
- `us_tx_bc_541_154`, `us_tx_bc_541_154_1`, `us_tx_bc_541_154_2`, `us_tx_bc_541_154_2_a`, `us_tx_bc_541_154_2_b`, `us_tx_bc_541_154_2_c`, `us_tx_bc_541_154_2_d`;
- `us_tx_bc_541_155_a`.

The outside-fact target is `sba_small_business_size_determination`.

Each citation is written as `cite(Key)`. No shortened atom is ever invented.

## Public predicates

**Contract queries:**

- `applicability_status(Profile, Result, Basis, Citations)`: Sec. 541.002 classification (#3). Citations are the eleven `us_tx_bc_541_002_*` keys. Basis is `[outside_fact(small_business_as_defined_by_sba, Attested)]` for `in_scope`, and for `out_of_scope` when the person is attested a small business; otherwise it is `[]`.
- `response_deadline(Profile, ReceivedDate, Result, Citations)`: ReceivedDate + 45 days (#15). Cites `us_tx_bc_541_052_b` and `us_tx_bc_541_052_c`.
- `extended_response_deadline(Profile, ReceivedDate, Result, Citations)`: ReceivedDate + 90 days, or `no_extension_available` (#15). Cites `us_tx_bc_541_052_b`.
- `appeal_response_deadline(Profile, AppealReceivedDate, Result, Citations)`: AppealReceivedDate + 60 days (#15). Cites `us_tx_bc_541_053_c`.
- `cure_period_last_day(Profile, NoticeDate, Result, Citations)`: NoticeDate + 30 days (#15). Cites `us_tx_bc_541_154` and `us_tx_bc_541_154_1`.
- `attorney_general_action_status(Profile, NoticeDate, ReferenceDate, Result, Citations)`: the status on the reference day (#3/#15). Cites:
  - `cure_period_running`: `us_tx_bc_541_154`;
  - `action_may_be_brought`: `541_154`, `_1`, `_2`, `_2_a` to `_2_d` and `541_155_a`;
  - `no_action_for_cured_violation`: the same list without `541_155_a`.
- `civil_penalty_maximum(Profile, Result, Citations)`: 7500 × violation_count, or `no_civil_penalty` (#23). Cites `us_tx_bc_541_155_a`.
- `texas_tdpsa_input_problems(Profile, Problems)`: THE INPUT CHECK. Problems is a bare flat list: `duplicate_key/1` or `wrong_type/1` per contract key in contract order, then `unknown_key/1` in first-occurrence order. A non-attribute-list Profile gives `[wrong_type(profile)]`.

**Result constructors (exported, never called as queries; exact functors and arities):**

- `indeterminate(MissingKeys)`: not-final status naming the one first missing profile key. Citation: the step of THE LIMBS that fires (e.g. `us_tx_bc_541_002_a`).
- `needs_legal_review(Reason, Context)`: not-final referral status. Citation: the firing referral row (`us_tx_bc_541_002_a_1`, `us_tx_bc_541_052_b` or `us_tx_bc_541_002_a_3`).
- `open_textured(Key, Citation)`: referral reason for an `unsure` judgement. Citation: `us_tx_bc_541_002_a_1` or `us_tx_bc_541_052_b`.
- `cross_reference_unresolved(Citation, Target)`: referral reason for the absent SBA outside fact. Citation: `us_tx_bc_541_002_a_3` → `sba_small_business_size_determination`.
- `resolution(Target, State)`: context element of the cross-reference referral, State `not_attempted`. Citation: `us_tx_bc_541_002_a_3`.
- `inputs_relied_on(Pairs)`: context element listing the `Key-Value` pairs of the firing referral row. Citation: the firing referral row.
- `provenance(Clause, Citations)`: optional trailing element of a `needs_legal_review` CONTEXT list naming the clause that fired and its citation list; unscored. Citation: the firing referral row (`us_tx_bc_541_002_a_1`, `us_tx_bc_541_052_b` or `us_tx_bc_541_002_a_3`).
- `outside_fact(Key, Attested)`: BASIS element of `applicability_status/4` carrying the attested SBA term as supplied. Citation: `us_tx_bc_541_002_a_3`.
- `attested(Value, Attestation)` and `attestation(By, At, Reason, Evidence)`: the outside-fact wrapper. Citation: `us_tx_bc_541_002_a_3`.
- `url(Url, RetrievedAt)` and `document(UploadId, Sha256)`: attestation evidence forms. Citation: `us_tx_bc_541_002_a_3`.
- `input_problems(Problems)`, `unknown_key(Key)`, `wrong_type(Key)`, `duplicate_key(Key)`: THE INPUT CHECK terms. Citation: Ch. 541 typed input contract (no statutory key; CITATIONS `[]`).

**Facade (scaffold names kept):**

- `decide_texas_tdpsa(Profile, Verdict)`: Verdict is `texas_tdpsa_verdict(Status, Citations)`, built from `applicability_status/4`. Cites the Sec. 541.002 keys.
- `texas_tdpsa_status(Profile, Status)`: Status is the applicability RESULT only. Cites Sec. 541.002.
- `texas_tdpsa_checklist(Profile, Checklist)`: justification (#7). The applicability checklist of `item(RequirementId, Status, cite(Key))` rows comes from `formalize_lib:eval_requirements/4` over `texas_tdpsa_requirement/4`. Requirement ids and their citations:
  - `not_an_excluded_category`: `us_tx_bc_541_002_b`;
  - `processes_or_sells_personal_data`: `us_tx_bc_541_002_a_2`;
  - `conducts_business_in_texas_or_serves_texas_residents`: `us_tx_bc_541_002_a_1`;
  - `not_a_small_business`: `us_tx_bc_541_002_a_3`.
  
  Each item carries `cite(...)`, met items included. Each requirement has exactly three clauses (met / unmet / unknown) and no cut.
- `texas_tdpsa_what_if(Profile, Key, Value, Status)`: the applicability status with one key overridden. Uses `kit/query_combinators:what_if/5` with the closure `texas_tdpsa_status`. Cites Sec. 541.002.

**Fixtures:**

- `texas_tdpsa_fixture(Name, Profile)`: named profiles.
- `texas_tdpsa_fixture_expectation(Name, Query, Expected)`.

The named profiles are:

- `in_scope_controller`;
- `small_business_attested`;
- `nonprofit_excluded`;
- `sba_absent_referral`;
- `conducts_business_unsure`;
- `extension_granted`;
- `extension_notice_late`;
- `cure_completed`;
- `statement_breached`;
- `penalty_three_violations`;
- `penalty_count_missing`;
- `malformed_duplicate_key`.

## Planned reuse (manifest `uses:`)

- **`formalize_lib`**:
  - `profile_get/3`, `profile_has/2`, `profile_lacks/2` for reading keys;
  - `eval_requirements/4`, `item/3`, `unmet/1`, `unknown/1` for the checklist;
  - `check_tri/4` for the judgement requirement row;
  - `memberd/2`, `not_member/2`.
- **`library(datetime)`**: `date_add/3` and `timedelta/3` for all day arithmetic. No day count is hand-rolled.
- **`kit/deadline_lib`**: `month_last_day/3` for real-day validation of a `date(Year, Month, Day)` argument. It also supplies `date_on_or_before/2` and `date_before/2` for calendar-day comparison. `deadline/4` is used only if P2 confirms its convention is trigger plus N days with the trigger excluded; otherwise the local kernel helper below is used.
- **`kit/query_combinators`**: `what_if/5` for `texas_tdpsa_what_if/4`.
- **`validate_props`**: `prop_totality/3`, `prop_determinism/3`, `prop_citation_complete/3`, `prop_boundary_coverage/2`, `prop_missing_key_coverage/3` and `run_props/1` in the tests.
- **`currency_vocab`**: `usd`, in documentation and metadata only.
- **Not used**: `kit/compliance_lib`, `kit/rolling_window`, `country`.

## Kernel (`kernel.clausal`) — shared floor only

The kernel holds only what more than one query needs. The slice is the only consumer today; the kernel stays minimal so that sibling slices (Sec. 541.107) can reuse it.

- **`texas_tdpsa_date_well_formed(Date)`**: succeeds iff Date is `date(Year, Month, Day)` with three bound integers, 1 ≤ Year ≤ 9999, 1 ≤ Month ≤ 12 and 1 ≤ Day ≤ `month_last_day`. It is used by the step-0 date check of every dated query.
- **`texas_tdpsa_date_plus_days(Date, Days, Later)`**: calendar-day addition with the event day excluded. It is called only after validation, because the arithmetic is forward-only.
  - **Native route**: build the native date with `date/4`, apply `timedelta(Days, 0, Delta)` and `date_add/3`, then project back to `date(Year, Month, Day)`. This works around the `date/3` registration gap noted in MODULES.yaml.
  - **Fallback**: if no native route is available, the kit's `deadline_lib` `next_day/2` is iterated.
- **`texas_tdpsa_date_problems(ArgumentName, Date, Problems)`**: Problems is `[]` or `[wrong_type(ArgumentName)]`.

## Slice: `texas_tdpsa.clausal` (self-contained determination slice)

### Value facts owned here (never in a shared constants file)

The statutory figures:

- `:- constant_value(texas_tdpsa_response_period_days, 45).` (541.052(b), (c))
- `:- constant_value(texas_tdpsa_extension_period_days, 45).` (541.052(b); the extended total is 45 + 45 = 90, derived, not inlined)
- `:- constant_value(texas_tdpsa_appeal_response_period_days, 60).` (541.053(c))
- `:- constant_value(texas_tdpsa_cure_period_days, 30).` (541.154)
- `:- constant_value(texas_tdpsa_civil_penalty_per_violation_usd, 7500).` (541.155(a), inclusive maximum)

The tables:

- the contract key order (the eleven keys) with their types;
- the six excluded category atoms;
- the citation lists per final result, as stated in THE LIMBS;
- the referral rows:
  - `conducts_business_in_texas_or_serves_texas_residents`: `us_tx_bc_541_002_a_1`;
  - `extension_reasonably_necessary`: `us_tx_bc_541_052_b`;
  - `small_business_as_defined_by_sba`: `us_tx_bc_541_002_a_3` → `sba_small_business_size_determination`.

### Rules (one clause per disjoint route; ground outputs folded into heads; no `!`, `->` or `*->`)

**Step 0, the input check.**

- `texas_tdpsa_input_problems/2`:
  1. A shape guard: a proper list of `attribute/2` elements, with no unbound tail or elements.
  2. Per-key occurrence counting gives `duplicate_key`.
  3. Type predicates per key give `wrong_type`. The outside fact needs `attested(true|false, attestation(A, B, C, D))` with each argument ground.
  4. A first-occurrence scan gives `unknown_key`; a non-atom key counts as unknown.
- Then the date problems, in argument order.
- For the action query, the ADDED CHECK: `ReferenceDate @< NoticeDate` gives `wrong_type(reference_date)`. Dates are compared by calendar order, using `date_before/2`.

**Applicability**, in steps (1) to (6) of THE LIMBS:

1. Attested true gives `out_of_scope` with the attestation in BASIS.
2. An excluded category, or a false condition, gives `out_of_scope` with BASIS `[]`.
3. The first absent key of the three conditions gives `indeterminate`.
4. An absent outside fact gives THE ABSENT REFERRAL.
5. An `unsure` judgement gives the `open_textured` referral.
6. Otherwise the result is `in_scope` with the attestation in BASIS.

Mutual exclusion is by explicit guards per clause, not by ordering cuts.

**Response and appeal.**

- Response: `date_plus_days(ReceivedDate, constant(texas_tdpsa_response_period_days))`.
- Appeal: `date_plus_days(AppealReceivedDate, constant(texas_tdpsa_appeal_response_period_days))`.
- No profile key is read, but the profile is still input-checked.

**Extension.**

1. A false key gives `no_extension_available`.
2. The first absent key gives `indeterminate`.
3. Notice true with necessity `unsure` gives the referral.
4. Both keys true gives ReceivedDate + (response + extension) days.

**Cure.** The last day is NoticeDate + `texas_tdpsa_cure_period_days`.

**Action**, with Last as the last day of the cure period:

1. ReferenceDate on or before Last gives `cure_period_running`.
2. A false cure key, a false statement key or a true breach gives `action_may_be_brought`.
3. The first absent key gives `indeterminate`.
4. Otherwise `no_action_for_cured_violation`.

**Penalty.**

1. A false trigger key gives `no_civil_penalty`.
2. An absent trigger gives `indeterminate([violation_after_cure_period_or_statement_breach])`.
3. An absent count gives `indeterminate([violation_count])`.
4. Otherwise the result is the integer `constant(texas_tdpsa_civil_penalty_per_violation_usd) * violation_count`.

**Checklist requirements**, as `texas_tdpsa_requirement(RequirementId, Profile, Status, Citation)` with RequirementId first. There are four rows, each with three clauses (met / unmet / unknown). This is the justification surface (#7) and never decides a contract answer.

### Verdict atoms

The slice's verdict atoms are `in_scope`, `out_of_scope`, `no_extension_available`, `cure_period_running`, `action_may_be_brought`, `no_action_for_cured_violation` and `no_civil_penalty`, plus dates, the integer penalty and the status compounds above.

### Shared with another slice (belongs in kernel)

Only the three date helpers are shared: `texas_tdpsa_date_well_formed/1`, `texas_tdpsa_date_plus_days/3` and `texas_tdpsa_date_problems/3`. Nothing else is shared.

### Per-rule tests (seven modes)

**Boundaries:**

- the 45th, 90th, 60th and 30th days;
- reference day = NoticeDate + 30 gives `cure_period_running`; NoticeDate + 31 reads the keys;
- reference day = NoticeDate − 1 gives `wrong_type(reference_date)`;
- leap day: 2028-01-15 + 45 = 2028-02-29;
- year rollover;
- violation_count 0 gives 0.

**Malformed input:** `date(2026, 2, 30)`, an unbound date, a duplicate key, a non-atom key, a bare `true` for the outside fact, an attestation holding an unbound argument, and a partial list.

**Other properties:**

- Every query is checked for exactly one solution, via a `findall` length of 1.
- A key a query does not read, whether present or absent, must not change its answer.
- Each negative test is paired with a positive test over the same case.
