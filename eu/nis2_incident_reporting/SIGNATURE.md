# SIGNATURE — eu/nis2_incident_reporting

## Public query surface

`decide_nis2_incident_reporting(PROFILE, nis2_incident_reporting_verdict(STATUS, CITATIONS))` is the eligibility verdict (query type #2). It delegates to `incident_significance/3` and returns its STATUS and CITATIONS unchanged. `nis2_incident_reporting_status(PROFILE, STATUS)` projects that STATUS.

The deadline query type (#15) is served by two queries:

- `incident_reporting_steps/2`: which steps are due and what each limit is.
- `reporting_step_timeliness/4`: was a step on time; the consequence of missing is `late(hour_limit)` or `late(without_undue_delay)`, never excused.

PROFILE is an attribute list `[attribute(KEY, VALUE), ...]` read only with `profile_get/3`.

**Totality.** Every query yields exactly ONE solution for every ground input, including ill-formed inputs, which give `input_problems(...)`.

**Determinism.** Routes are disjoint decision-table rows, matched on the deterministic state of each key. The input check rules out duplicates before any key is read.

No statutory figure is imported. The hour limits are declared once, in the slice.

## Verdict STATUS atoms (replacing satisfied / not_satisfied)

- **Final, `incident_significance` / facade:** `significant`, `not_significant`.
- **Final, `incident_reporting_steps`:** a list of `step_due/3` (possibly `[]`).
- **Final, `reporting_step_timeliness`:** `on_time`, `late(hour_limit)`, `late(without_undue_delay)`.
- **Non-final, all queries:**
  - `indeterminate([KEY])`: exactly one key; the bare atom `indeterminate` is never written.
  - `needs_legal_review(open_textured(KEY, cite(CITE)), [inputs_relied_on(PAIRS)])`: optionally `provenance(CLAUSE, CITATIONS)` after `inputs_relied_on`, unscored.
  - `input_problems(PROBLEMS)`.

## Profile keys (root_exports order = input_contract order)

| # | Key | Kind | Values | Provision |
|---|---|---|---|---|
| 1 | `severe_operational_disruption_or_financial_loss` (A) | judgement | true / false / unsure | Art 23(3)(a) |
| 2 | `considerable_damage_to_other_persons` (B) | judgement | true / false / unsure | Art 23(3)(b) |
| 3 | `trust_service_provider_incident_affects_trust_services` (TSP) | crisp | true / false | Art 23(4) last sentence |
| 4 | `incident_ongoing_at_final_report_due` (ONG) | crisp | true / false | Art 23(4)(e) |
| 5 | `early_warning_without_undue_delay` (EW) | judgement | true / false / unsure | Art 23(4)(a) |
| 6 | `incident_notification_without_undue_delay` (IN) | judgement | true / false / unsure | Art 23(4)(b) |

**Arguments that are not profile keys:**

- STEP is the atom `early_warning` or `incident_notification`.
- HOURS_ELAPSED is a non-negative integer: whole hours, rounded UP, from becoming aware to submission.

No date is a profile key. The order is driven by an hour count, and the one-month limits are listed, not computed. Where a caller holds datetimes, the helper below converts them with `library(datetime)`.

## Citation-key atoms (canonical scheme, `_lexicon/citations.yaml`; never shortened further)

- `eu_dir_2022_2555_art_23_3_a`: Art 23(3)(a), significance limb (a).
- `eu_dir_2022_2555_art_23_3_b`: Art 23(3)(b), significance limb (b).
- `eu_dir_2022_2555_art_23_4`: Art 23(4) last sentence, the trust service provider 24-hour incident notification.
- `eu_dir_2022_2555_art_23_4_a`: Art 23(4)(a), early warning, 24 h.
- `eu_dir_2022_2555_art_23_4_b`: Art 23(4)(b), incident notification, 72 h.
- `eu_dir_2022_2555_art_23_4_c`: Art 23(4)(c), intermediate report on request.
- `eu_dir_2022_2555_art_23_4_d`: Art 23(4)(d), final report one month after notification.
- `eu_dir_2022_2555_art_23_4_e`: Art 23(4)(e), progress report and final report after handling.

The `dir` segment is part of the canonical lexicon atom. It is carried verbatim and is not coined here. If the C6 lint flags it, record a `% lint:` pragma citing the lexicon; do not rename the atom.

## Public predicates (one line each)

- `incident_significance(Profile, Status, Citations)`: significance verdict, THE LIMBS steps (0) to (4); Citations is a set-like `cite/1` list, `[]` when non-final. Cites Art 23(3)(a) and (b).
- `incident_reporting_steps(Profile, Steps)`: an ordered `step_due(Step, Limit, cite(Key))` list, `[]`, or one status compound; THE LIMBS steps (0), (5) to (7). Cites Art 23(4)(a) to (e) and the last sentence.
- `reporting_step_timeliness(Profile, Step, HoursElapsed, Result)`: hour limit and without-undue-delay check for one submitted step; THE LIMBS steps (0), (8), (9). Cites Art 23(4)(a), (b) and the last sentence.
- `nis2_incident_reporting_input_problems(Profile, Problems)`: the bare ordered problem list, `[]` when well-formed. This is THE INPUT CHECK.
- `decide_nis2_incident_reporting(Profile, Verdict)`: Verdict = `nis2_incident_reporting_verdict(Status, Citations)` from `incident_significance/3`. Cites Art 23(3).
- `nis2_incident_reporting_status(Profile, Status)`: the Status of the verdict above. Cites Art 23(3).
- `nis2_incident_reporting_checklist(Profile, Checklist)`: the cited checklist (see the facade section below). Cites Art 23(3)(a) and (b).
- `nis2_incident_reporting_what_if(Profile, Key, Value, Verdict)`: the verdict of `decide_nis2_incident_reporting/2` on Profile with `attribute(Key, Value)` set via `profile_set/3`.
- `nis2_incident_reporting_hours_elapsed(AwareDatetime, SubmissionDatetime, HoursElapsed)`: a helper, not scored. HoursElapsed is the ceiling of (seconds between the two) / 3600, using `timestamp/2` from `library(datetime)`. Both inputs must be bound (forward-only). It fails when submission precedes awareness. Cites Art 23(4)(a) and (b), reading (4).
- `nis2_incident_reporting_fixture(Name, Profile)` and `nis2_incident_reporting_fixture_expectation(Name, Query, Expected)`: named fixtures.

**Result constructors** (exported, never called as queries): `indeterminate/1`, `needs_legal_review/2`, `open_textured/2`, `inputs_relied_on/1`, `provenance/2`, `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`, `step_due/3`, `hours_after_awareness/1`, `months_after_notification/1`, `months_after_handling/1`, `late/1`.

## Planned reuse (manifest `uses:`)

- `formalize_lib`:
  - `profile_get/3`, `profile_has/2`, `profile_lacks/2`: all key reads.
  - `profile_set/3`: the what_if facade.
  - `profile_keys/2`: the duplicate and unknown-key scan.
  - `check_tri/4`: checklist items for limbs (a) and (b), unsure and absent mapping to unknown.
  - `or_status/2`: the checklist summary.
  - `memberd/2`, `not_member/2`: the input-check scans.
  - `attribute/2`, `item/3`, `unknown/1`.
- `library(datetime)`: `timestamp/2`, `datetime/7`. Used for the hours helper only. Native datetime is the only date/time logic.
- `validate_props`:
  - `run_props/1`, `prop_totality/3`, `prop_determinism/3`;
  - `prop_citation_complete/3`, `prop_boundary_coverage/2`;
  - `prop_missing_key_coverage/3`, `bad_citation/1`.

  These are for the property test mode.
- `list_item/3` (built-in), if positional access is needed in tests.
- NOT used: `kit.deadline_lib`, whose month rule is Australian s 36 and whose day periods do not apply. `kit.compliance_lib`, `currency_vocab`, `vat_category`, `country` and `kit.rolling_window` are not used either: they have no bearing on this order.

## Layout

kernel -> citations -> parameters -> nis2_incident_reporting -> queries -> fixtures -> package facade. All file and module names are kept as scaffolded.

### kernel.clausal (shared floor only)

- The result-constructor declarations listed above.
- The tri-state value vocabulary:
  - `nis2_incident_reporting_judgement_value/1` (true, false, unsure);
  - `nis2_incident_reporting_crisp_value/1` (true, false).
- `nis2_incident_reporting_key_state(Profile, Key, State)`: State is the present value, or `absent`. There are two disjoint clauses: one head is `key_state(Profile, Key, absent) :- profile_lacks(Profile, Key).`, the other reads `profile_get/3`.

The queries file shares this predicate for its argument check. Nothing else is shared.

### citations.clausal

The eight citation atoms above, as `citation_vocabulary` facts, each with its pinned unit id.

### parameters.clausal

Intentionally holds NO statutory figure. Values live in the slice. It keeps only the scaffold's source pin (32022L2555, OJ L 333, 27.12.2022, sha256 6ee66d5c…cb589).

## Slice: nis2_incident_reporting.clausal

This slice is self-contained for Art 23(3) and (4).

### Value facts owned here

- `:- constant_value(early_warning_limit_hours, 24).`: Art 23(4)(a).
- `:- constant_value(incident_notification_limit_hours, 72).`: Art 23(4)(b).
- `:- constant_value(trust_service_incident_notification_limit_hours, 24).`: Art 23(4) last sentence.
- `:- constant_value(final_report_period_months, 1).`: Art 23(4)(d), listed only.
- `:- constant_value(final_report_after_handling_period_months, 1).`: Art 23(4)(e), listed only.
- `:- constant_value(seconds_per_hour, 3600).`: used by the hours helper.

The input contract facts are `contract_key(Position, Key, Kind)` for the six keys, in the order above, with Kind `judgement` or `crisp`.

### Rules and requirements

1. **Input check.** `nis2_incident_reporting_input_problems/2`:
   - A non-list, or a list holding a non-`attribute/2` element, gives `[wrong_type(profile)]`.
   - Otherwise, for each contract key in contract order: if it occurs more than once, `duplicate_key(Key)`; else, if present with a value outside its kind, `wrong_type(Key)`.
   - Then `unknown_key(Key)` for each non-contract key, in first-occurrence order, once each.
   - It is built by a deterministic fold, with no findall over item constructors (R1).
2. **Significance table.** The fact table `significance_outcome(StateA, StateB, Outcome)` covers all 16 combinations of {true, false, unsure, absent}, with Outcome one of:
   - `significant(cite(eu_dir_2022_2555_art_23_3_a))` when A is true;
   - `significant(cite(eu_dir_2022_2555_art_23_3_b))` when A is not true and B is true;
   - `missing(KEY)`: the first absent key, A before B;
   - `unsure(KEY, CITE)`: the first unsure key;
   - `not_significant` when both are false.

   A single table row matches each pair, which guarantees one solution.
3. **incident_significance/3.** One clause per outcome route, with the ground output in the head (C17):
   - non-empty problems give `input_problems(P)` and `[]`;
   - `significant` gives the single first-limb citation;
   - `missing` gives `indeterminate([K])` and `[]`;
   - `unsure` gives `needs_legal_review(open_textured(K, C), [inputs_relied_on(Pairs)])` and `[]`, where Pairs = [A-ValueA, B-ValueB] (both present at this route);
   - `not_significant` gives both citations.
4. **incident_reporting_steps/2.** It reads the significance outcome, then:
   - `missing(K)` (step 6) gives `indeterminate([K])`;
   - `not_significant` (6a) gives `[]`;
   - `unsure` (6b): the first absent of TSP and ONG gives `indeterminate([K])`; both present gives `needs_legal_review(...)` with Pairs A and B;
   - `significant` (6c): the first absent of TSP and ONG gives `indeterminate([K])`; else step (7).

   Step (7) builds the list:
   - `step_due(early_warning, hours_after_awareness(24), cite(eu_dir_2022_2555_art_23_4_a))`;
   - `step_due(incident_notification, hours_after_awareness(N), C)`, where TSP true gives N = 24 and `cite(eu_dir_2022_2555_art_23_4)`, and TSP false gives N = 72 and `cite(eu_dir_2022_2555_art_23_4_b)`;
   - `step_due(intermediate_report, on_request_of_csirt_or_competent_authority, cite(eu_dir_2022_2555_art_23_4_c))`;
   - `step_due(final_report, months_after_notification(1), cite(eu_dir_2022_2555_art_23_4_d))`;
   - when ONG is true only, `step_due(progress_report, at_final_report_due, cite(eu_dir_2022_2555_art_23_4_e))`, then `step_due(final_report_after_handling, months_after_handling(1), cite(eu_dir_2022_2555_art_23_4_e))`.

   N is read from the constants. The month integers come from the period constants.
5. **reporting_step_timeliness/4.**
   - PROBLEMS are the profile problems, then `wrong_type(step)`, then `wrong_type(hours_elapsed)`.
   - The hour band `hours_band(Step, Hours, Band)` is disjoint by arithmetic guards against constants:
     - early warning: `within` when Hours =< 24, `over_limit` when Hours > 24;
     - incident notification: `within` when Hours =< 24, `trust_service_dependent` for 25 to 72, `over_limit` when Hours > 72.
   - `over_limit` gives `late(hour_limit)`, and no key is read.
   - `trust_service_dependent` reads TSP: absent gives `indeterminate([trust_service_provider_incident_affects_trust_services])`; true gives `late(hour_limit)`; false goes on to the delay judgement.
   - The delay judgement (EW or IN by step):
     - absent gives `indeterminate([Key])`;
     - true gives `on_time`;
     - false gives `late(without_undue_delay)`;
     - unsure gives `needs_legal_review(open_textured(Key, cite(art_23_4_a or art_23_4_b)), [inputs_relied_on([Key-unsure])])`.
   - A and B are never read (reading (14)).
6. **Hours helper.** `nis2_incident_reporting_hours_elapsed/3` uses `timestamp/2`. HoursElapsed = (Seconds + seconds_per_hour - 1) // seconds_per_hour, with Seconds >= 0 required.

### Verdict atoms of this slice

- Final: `significant`, `not_significant`, step lists, `on_time`, `late(hour_limit)`, `late(without_undue_delay)`.
- Non-final: `indeterminate/1`, `needs_legal_review/2`, `input_problems/1`.

### Shared with another slice

Only `nis2_incident_reporting_key_state/3` and the value vocabulary, which live in kernel.clausal. There is no other slice.

### Per-rule tests (owned by the slice)

- All 16 significance rows.
- Steps for each of 6, 6a, 6b (TSP absent, ONG absent, both present) and 6c, with TSP and ONG in every combination.
- Timeliness boundaries at 0, 24, 25, 72 and 73 for both steps, with TSP absent, true and false.
- Duplicates, wrong types, unknown keys and a non-list profile.
- Single-solution counting via `findall` plus `length(_, 1)`.

## queries.clausal

It re-exports the three queries and the input check from the slice. It adds the STEP and HOURS_ELAPSED argument checks used by `reporting_step_timeliness/4`, using kernel `key_state/3` for nothing else.

## fixtures.clausal

| Fixture | Profile | Expected |
|---|---|---|
| `limb_a_only` | A true | `significant` [23_3_a] |
| `limb_b_with_a_unsure` | A unsure, B true | `significant` [23_3_b] |
| `both_false` | A and B false | `not_significant`, both citations; steps `[]` |
| `a_absent` | A absent | `indeterminate([severe_operational_disruption_or_financial_loss])` |
| `a_unsure_trust_absent` | A unsure, B false | steps `indeterminate([trust_service_provider_incident_affects_trust_services])` |
| `trust_provider_ongoing` | A true, TSP true, ONG true | six steps, incident notification 24 h |
| `notification_hour_48_trust_provider` | TSP true, 48 h | `late(hour_limit)` |
| `early_warning_hour_24_prompt` | EW true, 24 h | `on_time` |
| `early_warning_hour_25` | 25 h | `late(hour_limit)` |
| `notification_hour_73` | 73 h | `late(hour_limit)` |
| `notification_unsure_delay` | IN unsure, 10 h | `needs_legal_review` |
| `duplicate_and_unknown` | duplicate and unknown keys | `input_problems([duplicate_key(...), unknown_key(...)])` |

## Package facade

Keeps `decide_nis2_incident_reporting/2`, `nis2_incident_reporting_status/2`, `nis2_incident_reporting_checklist/2`, `nis2_incident_reporting_what_if/4` and the fixtures exports.

The checklist is `[item(limb_a, StatusA, cite(eu_dir_2022_2555_art_23_3_a)), item(limb_b, StatusB, cite(eu_dir_2022_2555_art_23_3_b))]`, with each Status from `check_tri/4`. It is explanatory: the scored verdict always comes from `incident_significance/3`.

## Seven test modes (v2 manifest)

1. **load:** every module loads.
2. **unit:** the per-rule slice tests.
3. **fixtures:** every fixture expectation.
4. **properties:** totality, determinism, citation completeness and missing-key coverage via `validate_props`.
5. **boundary:** the 24/25 and 72/73 cases, plus the TSP band.
6. **counting:** exactly one solution per query.
7. **mutations:** flip OR to AND, `=<` to `<`, 72 to 24, and missing versus unsure precedence. Each mutation must be killed.
