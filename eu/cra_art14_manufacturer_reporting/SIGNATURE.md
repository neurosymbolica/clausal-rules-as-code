# SIGNATURE — eu/cra_art14_manufacturer_reporting

## Query surface (summary)

The contract queries are fixed by INTERFACE - THE CALLED CONTRACT:

- `severe_incident_status(Profile, Status, Citations)` — query type #2, eligibility-shaped;
- `manufacturer_reporting_steps(Profile, Event, AwarenessDate, Steps)` — query type #15, deadline;
- `manufacturer_reporting_step_timeliness(Profile, Event, Step, HoursElapsed, Result)` — query type #15, the consequence of missing a limit;
- `cra_art14_manufacturer_reporting_input_problems(Profile, Problems)` — the input check.

The scaffold facade keeps its names and delegates to the severity query:

- `decide_cra_art14_manufacturer_reporting(Profile, cra_art14_manufacturer_reporting_verdict(Status, Citations))`
- `cra_art14_manufacturer_reporting_status(Profile, Status)`

**Totality and determinism.** Every query yields EXACTLY ONE solution for every input term and never raises:

- the input check runs first and is total;
- each later route is one clause with its ground output in the head;
- the routes are pairwise disjoint;
- there is no `!`, `->`, `*->` or `once/1`.

No figure is imported from another domain. All statutory figures are declared once, in the slice.

## Verdict / status atoms (replace placeholder `satisfied` / `not_satisfied`)

- **Severity STATUS:** `severe` | `not_severe` | `indeterminate([Key])` | `needs_legal_review(open_textured(Key, cite(Citation)), [inputs_relied_on(Pairs)])` | `input_problems(Problems)`.
- **Steps STEPS:** one of the following.
  - A flat list of `step_due(Step, Limit, cite(Citation))`, in the order early_warning, notification, final_report, intermediate_report.
  - `[]` when no step is due.
  - A bare status compound.
- **Step atoms:** `early_warning`, `notification`, `final_report`, `intermediate_report`.
- **Limit terms:** `hours_after_awareness(24)`, `hours_after_awareness(72)`, `days_after_measure_available(14)`, `months_after_notification(1)`, and the atom `on_request_of_coordinator_csirt`.
- **Timeliness RESULT:** `on_time` | `late(hour_limit)` | `late(without_undue_delay)` | a status compound.
- **Input problem terms:** `duplicate_key(Key)`, `wrong_type(Key)`, `unknown_key(Key)`. The argument problems are `wrong_type(profile)`, `wrong_type(event)`, `wrong_type(awareness_date)`, `wrong_type(step)` and `wrong_type(hours_elapsed)`.
- **Never returned:** the bare atoms `indeterminate`, `needs_legal_review` and `input_problems`.
- **Event atoms (arguments, not profile keys):** `actively_exploited_vulnerability`, `incident_impacting_product_security`.
- **Result constructors (exported, never queried):** `date/3`, `step_due/3`, `hours_after_awareness/1`, `days_after_measure_available/1`, `months_after_notification/1`, `late/1`, `indeterminate/1`, `needs_legal_review/2`, `open_textured/2`, `inputs_relied_on/1`, `provenance/2`, `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`.

## Profile keys

The profile is an attribute list `[attribute(Key, Value), ...]`, read only with `profile_get/3`. There are four keys, in root_exports and input_contract order. Every key is a JUDGEMENT key whose value is the atom `true`, `false` or `unsure`.

| Order | Key | Provision | Meaning of `true` |
|---|---|---|---|
| 1 | `affects_protection_of_sensitive_or_important_data_or_functions` | Art 14(5)(a) | The incident affects, or is capable of affecting, the protection of sensitive or important data or functions. |
| 2 | `leads_to_malicious_code_in_product_or_user_systems` | Art 14(5)(b) | The incident has led, or is capable of leading, to malicious code in the product or in a user's systems. |
| 3 | `early_warning_without_undue_delay` | Art 14(2)(a), 14(4)(a) | The early warning was submitted without undue delay. |
| 4 | `notification_without_undue_delay` | Art 14(2)(b), 14(4)(b) | The notification was submitted without undue delay. |

The query arguments are not profile keys:

- **Event:** the atom `actively_exploited_vulnerability` or `incident_impacting_product_security`.
- **AwarenessDate:** a `date(Year, Month, Day)` term naming a real calendar day.
- **Step:** the atom `early_warning` or `notification`.
- **HoursElapsed:** a non-negative integer count of whole hours, with a partial hour rounded UP.

There are no money keys, and no Python booleans or strings.

## Citation-key atoms (canonical lexicon scheme, `_lexicon/citations.yaml`)

| Citation key | Provision | Used in |
|---|---|---|
| `eu_reg_2024_2847_art_14_2_a` | vulnerability early warning, 24 h | steps, timeliness |
| `eu_reg_2024_2847_art_14_2_b` | vulnerability notification, 72 h | steps, timeliness |
| `eu_reg_2024_2847_art_14_2_c` | vulnerability final report, 14 days | steps |
| `eu_reg_2024_2847_art_14_4_a` | incident early warning, 24 h | steps, timeliness |
| `eu_reg_2024_2847_art_14_4_b` | incident notification, 72 h | steps, timeliness |
| `eu_reg_2024_2847_art_14_4_c` | incident final report, 1 month | steps |
| `eu_reg_2024_2847_art_14_5` | severity, whole paragraph | severe answer |
| `eu_reg_2024_2847_art_14_5_a` | severity limb (a) | not_severe answer, referral, checklist |
| `eu_reg_2024_2847_art_14_5_b` | severity limb (b) | not_severe answer, referral, checklist |
| `eu_reg_2024_2847_art_14_6` | intermediate report on request | steps |
| `eu_reg_2024_2847_art_71_2` | application of Art 14 from 11 September 2026 | provenance only; never in a scored output |

No shortened or invented atoms are used.

## Public predicates

- `severe_incident_status(Profile, Status, Citations)`: decides whether an incident impacting product security is severe, following routes S0 to S4.
  - Citations is a set-like flat list:
    - `[cite(eu_reg_2024_2847_art_14_5)]` when severe;
    - `[cite(eu_reg_2024_2847_art_14_5_a), cite(eu_reg_2024_2847_art_14_5_b)]` when not severe;
    - `[]` for every status compound.
  - Citation: Regulation (EU) 2024/2847, Art 14(5)(a), (b).
- `manufacturer_reporting_steps(Profile, Event, AwarenessDate, Steps)`: lists the due steps in fixed order, following routes R0 to R3.
  - Before `date(2026, 9, 11)` the list is `[]`.
  - For an actively exploited vulnerability, the four steps are listed and no key is read.
  - For an incident, the severity is read as in S1 to S4: not severe gives `[]`; an open severity answer passes on the same compound; severe gives the four incident steps.
  - Citation: Art 14(2)(a)-(c), 14(4)(a)-(c), 14(6), 71(2).
- `manufacturer_reporting_step_timeliness(Profile, Event, Step, HoursElapsed, Result)`: decides timeliness, following routes T0 to T2.
  - T1: HoursElapsed greater than the limit (24 for early_warning, 72 for notification) gives `late(hour_limit)`.
  - T2: otherwise the step's own undue-delay key decides.
  - Citation: Art 14(2)(a), (b) or 14(4)(a), (b), chosen by Event.
- `cra_art14_manufacturer_reporting_input_problems(Profile, Problems)`: the total input check against the typed input_contract (THE INPUT CHECK). Citation: none (structural).
- `decide_cra_art14_manufacturer_reporting(Profile, Verdict)`: the facade. Verdict is `cra_art14_manufacturer_reporting_verdict(Status, Citations)`, taken from `severe_incident_status/3`. Citation: Art 14(5).
- `cra_art14_manufacturer_reporting_status(Profile, Status)`: the facade. Status is the STATUS of `severe_incident_status/3`. Citation: Art 14(5).
- `cra_art14_manufacturer_reporting_checklist(Profile, Checklist)`: a cited checklist built with `eval_requirements/4`.
  - Its items are `item(severity_limb_sensitive_or_important_data, Status, cite(eu_reg_2024_2847_art_14_5_a))` and `item(severity_limb_malicious_code, Status, cite(eu_reg_2024_2847_art_14_5_b))`.
  - Each item Status is `met`, `unmet(...)` or `unknown([Key])`.
  - Citation: Art 14(5)(a), (b).
- `cra_art14_manufacturer_reporting_what_if(Profile, Key, Value, Status)`: replaces Key with Value using `profile_set/3`, then re-runs `cra_art14_manufacturer_reporting_status/2`. Citation: Art 14(5).
- `cra_art14_manufacturer_reporting_fixture(Name, Profile)`: named test profiles, one per route. Examples: `severe_by_limb_a`, `not_severe`, `limb_b_missing`, `limb_a_unsure_referral`, `early_warning_on_time`, `duplicate_key_problem`. Citation: none.

## Planned reuse (manifest `uses:`)

- **formalize_lib:**
  - `profile_get/3` and `profile_lacks/2` for all key reads, by presence and then by value;
  - `profile_set/3` for the what-if;
  - `eval_requirements/4` and `item/3` for the checklist. Hand-rolling these is lint R1, so they are imported;
  - `attribute/2`.
  - `check_tri/4` is NOT used for the decision. Its status shape does not carry the <<DNUM>> order or the folded referral, and the severity is an OR of the limbs, not a conjunction. The decision routes are explicit disjoint clauses.
  - `assess/6` and `decide_labeled/3` are not used. Their labelling is conjunctive, while Art 14(5) is disjunctive.
- **kit/deadline_lib:** `month_last_day/3`, for real-calendar-day validation of AwarenessDate, including the leap-year rule. `deadline_months_after/3` is deliberately NOT used: the one-month and 14-day periods are listed, not computed (excluded set calendar_periods).
- **library(datetime):** no arithmetic is needed. The application-date comparison uses the integer fields of the ground, validated `date(Y, M, D)` term, compared year, then month, then day. This avoids the date/3 registration gap and the compound-order trap. `date_string_iso/2` is reserved for a JSON boundary if one appears.
- **validate_props:** `run_props/1`, `prop_totality/3`, `prop_determinism/3`, `prop_citation_complete/3`, `prop_boundary_coverage/2` (boundaries: hours 24/25 and 72/73; dates 2026-09-10/2026-09-11), and `prop_missing_key_coverage/3`.

## Slice: cra_art14_manufacturer_reporting.clausal

This is the only determination slice. It is self-contained and owns all value facts, rules, citations tables and verdicts.

### Value facts (declared once with `:- constant_value(Name, Value).`, read with `constant(Name)`)

- `cra_article_14_application_year` = 2026, `cra_article_14_application_month` = 9, `cra_article_14_application_day` = 11 (Art 71(2)).
- `early_warning_limit_hours` = 24 (Art 14(2)(a), 14(4)(a)).
- `notification_limit_hours` = 72 (Art 14(2)(b), 14(4)(b)).
- `vulnerability_final_report_days_after_measure` = 14 (Art 14(2)(c)).
- `incident_final_report_months_after_notification` = 1 (Art 14(4)(c)).

### Tables (facts)

- `judgement_value(true)`, `judgement_value(false)`, `judgement_value(unsure)`.
- `contract_key/1`, holding the four keys in input_contract order (as an ordered list fact `contract_keys(List)`).
- `reporting_event(actively_exploited_vulnerability)`, `reporting_event(incident_impacting_product_security)`.
- `timed_step(early_warning)`, `timed_step(notification)`.
- `step_limit_hours_constant(early_warning, early_warning_limit_hours)`, `step_limit_hours_constant(notification, notification_limit_hours)`.
- `step_undue_delay_key(early_warning, early_warning_without_undue_delay)`, `step_undue_delay_key(notification, notification_without_undue_delay)`.
- `step_citation(Event, Step, CitationKey)`. There are eight rows, one for each event and each of the four steps, matching the citation table above.

### Rules

1. **Judgement state (`judgement_state(Profile, Key, State)`).** State is `absent` when `profile_lacks/2`, otherwise the value from `profile_get/3`. It is called only after the input check passes, so the value is a single valid judgement.
2. **Severity routes (`severity_outcome(StateA, StateB, ValueA, ValueB, Status, Citations)`).** The ground outputs are folded into the heads; the clauses are disjoint and there are 16 state combinations. In the table, `not true` means false, unsure or absent.

| Route | State A | State B | Status | Citations |
|---|---|---|---|---|
| S1 | true | any | `severe` | `[cite(eu_reg_2024_2847_art_14_5)]` |
| S1 | not true | true | `severe` | `[cite(eu_reg_2024_2847_art_14_5)]` |
| S2 | absent | false or unsure | `indeterminate([affects_protection_of_sensitive_or_important_data_or_functions])` | `[]` |
| S2 | false or unsure | absent | `indeterminate([leads_to_malicious_code_in_product_or_user_systems])` | `[]` |
| S3 | unsure | false or unsure | `needs_legal_review(open_textured(affects_protection_of_sensitive_or_important_data_or_functions, cite(eu_reg_2024_2847_art_14_5_a)), [inputs_relied_on([A-unsure, B-ValueB])])` | `[]` |
| S3 | false | unsure | `needs_legal_review(open_textured(leads_to_malicious_code_in_product_or_user_systems, cite(eu_reg_2024_2847_art_14_5_b)), [inputs_relied_on([A-false, B-unsure])])` | `[]` |
| S4 | false | false | `not_severe` | `[cite(eu_reg_2024_2847_art_14_5_a), cite(eu_reg_2024_2847_art_14_5_b)]` |

In the S3 rows, A and B stand for the full key names in Pairs; Pairs follows root_exports order.

3. **Application date.** `before_application(date(Year, Month, Day))` holds by integer comparison of the triple against the constants. Its disjoint complement is `on_or_after_application/1`. The comparison is strictly earlier, so 11 September 2026 counts as applicable.
4. **Steps routes.**
   - R0: input problems give `input_problems(Problems)`.
   - R1: before the application date gives `[]`.
   - R2: a vulnerability gives its four steps, from `step_citation/3` and the limit constants.
   - R3: an incident reuses `severity_outcome/6`. Severe gives the four incident steps; `not_severe` gives `[]`; any status compound is passed on unchanged.
5. **Timeliness routes.**
   - T0: input problems.
   - T1: `HoursElapsed > Limit` gives `late(hour_limit)`.
   - T2: `HoursElapsed =< Limit`, then the undue-delay key decides:
     - absent gives `indeterminate([Key])`;
     - true gives `on_time`;
     - false gives `late(without_undue_delay)`;
     - unsure gives `needs_legal_review(open_textured(Key, cite(Citation)), [inputs_relied_on([Key-unsure])])`.
6. **Input check.** The checks run in this order:
   - `attribute_list/1`: a proper list whose every element is `attribute(_, _)`, with no unbound element and no partial list. Failing it gives `[wrong_type(profile)]`.
   - Otherwise, for each contract key in order: `duplicate_key(Key)` if it occurs at least twice, else `wrong_type(Key)` if its present value is not a judgement value (an unbound value included).
   - Then `unknown_key(Key)`, once per non-contract key (non-atom keys included, as given), in order of first occurrence.
   - Then the argument problems, in argument order: event, then awareness_date (a ground date of a real day, via `month_last_day/3`) for the steps query; event, then step, then hours_elapsed (a non-negative integer) for the timeliness query.
   - All tests are type-guarded (`atom/1`, `integer/1`, `var/1`, `nonvar/1`), so the check never raises.
   - The input check is total by construction: it is built with `findall` over ordered key lists into one Problems list, never by an overlapping witness search.

### Verdict atoms

This slice owns all of them: `severe`, `not_severe`, `on_time`, `late/1`, `step_due/3` with its limit terms, and the status compounds listed above.

### Per-rule tests (seven modes)

- **Positive and negative pairs:** S1 through both limbs; S2 naming A and naming B; S3 on A and on B; S4.
- **Steps:** R1 on 2026-09-10 against 2026-09-11; R2; R3 severe, not severe, indeterminate and referral.
- **Timeliness:** T1 at 25/73 against 24/72; T2 for all four key states, for each event, showing its citation.
- **Input problems:** duplicates, wrong type, unknown keys, non-list and unbound profiles, a partial list, and every argument problem, including 29 February 2027 and 29 February 2028.
- **Solution counting:** every query is checked with `findall` and `length(Solutions, 1)`.

### Predicates shared with another slice

NONE. There is a single slice. `kernel.clausal` keeps only its scaffold floor (the module header and the re-export of `formalize_lib` profile access); no domain predicate moves into it. The queries module and the package facade re-export the four contract predicates and the facade predicates from this slice.
