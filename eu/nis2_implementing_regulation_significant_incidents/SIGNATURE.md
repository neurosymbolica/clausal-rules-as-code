# SIGNATURE — eu/nis2_implementing_regulation_significant_incidents

Pin: 32024R2690, Commission Implementing Regulation (EU) 2024/2690, original act. Source sha256 `1d10f42c31a2b3c6b929b4696a04093ee1d84a298c0c0437a22f8718a9ffb3cd`. Shape family: deontic. Query type #2 (eligibility).

## Public query surface

The called contract is `significant_incident_criteria(PROFILE, RESULT, CITATIONS)`, together with the input check `nis2_implementing_regulation_significant_incidents_input_problems(PROFILE, PROBLEMS)`. The scaffold facade wraps both:

- `decide_nis2_implementing_regulation_significant_incidents(PROFILE, nis2_implementing_regulation_significant_incidents_verdict(RESULT, CITATIONS))`
- `nis2_implementing_regulation_significant_incidents_status(PROFILE, RESULT)`

PROFILE is an attribute list `[attribute(KEY, VALUE), ...]`.

- It is read ONLY through `profile_get/3`, presence first and then value.
- All twenty-five keys are optional.
- Absence is never an input problem.

Totality and determinism:

- Every public query is total: it never fails and never raises.
- Every public query is deterministic: EXACTLY ONE solution for every term.
- This holds because the clause heads are mutually exclusive, with guards in the bodies and no `!`, `->` or `*->`.
- Any enumeration (the settings of the unsure rule, the eleven entity types, the ways) is collected with `findall/3`, then selected by guarded, mutually exclusive clauses.

The package holds no imported figures. Every statutory number is declared once with `:- constant_value/2` in the slice file and read with `constant/1`.

## Verdict STATUS atoms

These replace the placeholder `{ required, permitted, not_applicable }`.

| RESULT | Kind | Eligibility role | CITATIONS |
|---|---|---|---|
| `significant` | final atom | positive (eligible) | `[cite(eu_reg_2024_2690_art_3_1)]` |
| `not_significant` | final atom | negative (ineligible) | `[cite(eu_reg_2024_2690_art_3_1), cite(eu_reg_2024_2690_art_3_2)]` |
| `indeterminate([KEY])` | status compound, ONE bare key atom | indeterminate | `[]` |
| `needs_legal_review(open_textured(KEY, cite(CITE)), [inputs_relied_on(PAIRS)])` | status compound | indeterminate (lawyer) | `[]` |
| `input_problems(PROBLEMS)` | status compound, PROBLEMS non-empty | precedes all | `[]` |

Shape rules:

- The bare atom `indeterminate` is NEVER written (atom-shadowing trap).
- A status is never wrapped in a list.
- PAIRS are `KEY-VALUE` terms for the judgement keys PRESENT in the profile, in root_exports order, the unsure ones included.

Result constructors (exported, never queried):

- `indeterminate/1`
- `needs_legal_review/2`
- `open_textured/2`
- `inputs_relied_on/1`
- `provenance/2`
- `input_problems/1`
- `unknown_key/1`
- `wrong_type/1`
- `duplicate_key/1`

## Profile keys

The keys are listed in root_exports and input_contract order. Money is whole euro cents, and durations are whole seconds. The order has no date keys.

| # | Key | Type |
|---|---|---|
| 1 | `scheduled_interruption_or_maintenance` | crisp: `true` / `false` |
| 2 | `relevant_entity_type` | entity type: one of the eleven atoms below |
| 3 | `direct_financial_loss_euro_cents` | figure: non-negative integer |
| 4 | `annual_turnover_preceding_financial_year_euro_cents` | figure |
| 5 | `trade_secret_exfiltration` | judgement: `true` / `false` / `unsure` |
| 6 | `death_of_natural_person` | judgement |
| 7 | `considerable_damage_to_natural_person_health` | judgement |
| 8 | `suspectedly_malicious_unauthorised_access_capable_of_severe_operational_disruption` | judgement |
| 9 | `recurring_incidents_within_six_months` | figure (count of incidents) |
| 10 | `same_apparent_root_cause` | judgement |
| 11 | `recurring_collective_direct_financial_loss_euro_cents` | figure |
| 12 | `complete_unavailability_seconds` | figure |
| 13 | `average_response_time_above_ten_seconds_seconds` | figure |
| 14 | `limited_availability_seconds` | figure |
| 15 | `weekly_unavailability_seconds` | figure |
| 16 | `complete_unavailability_users` | figure |
| 17 | `limited_availability_users` | figure |
| 18 | `data_compromise_users` | figure |
| 19 | `service_users_in_union` | figure |
| 20 | `data_compromised` | judgement |
| 21 | `data_compromise_suspectedly_malicious` | judgement |
| 22 | `physical_access_compromised` | judgement |
| 23 | `incorrect_data_only_by_misconfiguration` | crisp |
| 24 | `incorrect_domain_names` | figure |
| 25 | `managed_domain_names` | figure |

The eleven entity-type atoms:

- `dns_service_provider`
- `tld_name_registry`
- `cloud_computing_service_provider`
- `data_centre_service_provider`
- `content_delivery_network_provider`
- `managed_service_provider`
- `managed_security_service_provider`
- `online_marketplace_provider`
- `online_search_engine_provider`
- `social_networking_services_platform_provider`
- `trust_service_provider`

A figure is a Prolog integer `>= 0`. It is never a float or a negative number.

## Citation-key atoms

All are canonical `_lexicon/citations.yaml` scheme atoms, listed in `citation_vocabulary`. Shortened atoms are never invented.

**Returned in CITATIONS:**

- `eu_reg_2024_2690_art_3_1`
- `eu_reg_2024_2690_art_3_2`

**Referral CITEs:**

- `eu_reg_2024_2690_art_3_1_b`
- `eu_reg_2024_2690_art_3_1_c`
- `eu_reg_2024_2690_art_3_1_d`
- `eu_reg_2024_2690_art_3_1_e`
- `eu_reg_2024_2690_art_4_b`
- `eu_reg_2024_2690_art_3_1_g`

**Carried by `implements(KEY)` on the ways (not returned):**

- Art 3(1) points:
  - `eu_reg_2024_2690_art_3_1_a`
  - `eu_reg_2024_2690_art_3_1_b`
  - `eu_reg_2024_2690_art_3_1_c`
  - `eu_reg_2024_2690_art_3_1_d`
  - `eu_reg_2024_2690_art_3_1_e`
  - `eu_reg_2024_2690_art_3_1_f`
  - `eu_reg_2024_2690_art_3_1_g`
- Art 4:
  - `eu_reg_2024_2690_art_4`
  - `eu_reg_2024_2690_art_4_a`
  - `eu_reg_2024_2690_art_4_b`
  - `eu_reg_2024_2690_art_4_c`
- Art 5: `eu_reg_2024_2690_art_5`, `eu_reg_2024_2690_art_5_a`, `eu_reg_2024_2690_art_5_b`, `eu_reg_2024_2690_art_5_c`
- Art 6: `eu_reg_2024_2690_art_6`, `eu_reg_2024_2690_art_6_a`, `eu_reg_2024_2690_art_6_b`, `eu_reg_2024_2690_art_6_c`
- Art 7: `eu_reg_2024_2690_art_7`, `eu_reg_2024_2690_art_7_a`, `eu_reg_2024_2690_art_7_b`, `eu_reg_2024_2690_art_7_c`, `eu_reg_2024_2690_art_7_d`
- Art 8: `eu_reg_2024_2690_art_8`, `eu_reg_2024_2690_art_8_a`, `eu_reg_2024_2690_art_8_b`, `eu_reg_2024_2690_art_8_c`, `eu_reg_2024_2690_art_8_d`
- Art 9: `eu_reg_2024_2690_art_9`, `eu_reg_2024_2690_art_9_a`, `eu_reg_2024_2690_art_9_b`, `eu_reg_2024_2690_art_9_c`, `eu_reg_2024_2690_art_9_d`
- Art 10: `eu_reg_2024_2690_art_10`, `eu_reg_2024_2690_art_10_a`, `eu_reg_2024_2690_art_10_b`, `eu_reg_2024_2690_art_10_c`, `eu_reg_2024_2690_art_10_d`
- Art 11: `eu_reg_2024_2690_art_11`, `eu_reg_2024_2690_art_11_a`, `eu_reg_2024_2690_art_11_b`, `eu_reg_2024_2690_art_11_c`, `eu_reg_2024_2690_art_11_d`
- Art 12: `eu_reg_2024_2690_art_12`, `eu_reg_2024_2690_art_12_a`, `eu_reg_2024_2690_art_12_b`, `eu_reg_2024_2690_art_12_c`, `eu_reg_2024_2690_art_12_d`
- Art 13: `eu_reg_2024_2690_art_13`, `eu_reg_2024_2690_art_13_a`, `eu_reg_2024_2690_art_13_b`, `eu_reg_2024_2690_art_13_c`, `eu_reg_2024_2690_art_13_d`
- Art 14: `eu_reg_2024_2690_art_14`, `eu_reg_2024_2690_art_14_a`, `eu_reg_2024_2690_art_14_b`, `eu_reg_2024_2690_art_14_c`, `eu_reg_2024_2690_art_14_d`, `eu_reg_2024_2690_art_14_e`

## Public predicates

- `significant_incident_criteria(Profile, Result, Citations)`: THE CALLED CONTRACT. It runs THE LIMBS steps 0 to 8 and gives exactly one solution. Citations are fixed per final result, `[]` otherwise. Cites `eu_reg_2024_2690_art_3_1` and `eu_reg_2024_2690_art_3_2`.
- `nis2_implementing_regulation_significant_incidents_input_problems(Profile, Problems)`: THE INPUT CHECK. Problems is a BARE flat list, `[]` when the profile is well-formed. The list holds:
  - `duplicate_key/1`, else `wrong_type/1`, per contract key in contract order;
  - then `unknown_key/1` in order of first occurrence;
  - or `[wrong_type(profile)]` alone.
  - It never fails and never raises. Cites the input_contract.
- `decide_nis2_implementing_regulation_significant_incidents(Profile, Verdict)`: the eligibility verdict. Verdict is `nis2_implementing_regulation_significant_incidents_verdict(Result, Citations)`, with Result and Citations exactly as `significant_incident_criteria/3` gives them. Cites Art 3(1) and Art 3(2).
- `nis2_implementing_regulation_significant_incidents_status(Profile, Status)`: argument 2 of `significant_incident_criteria/3`, as ONE scalar atom or status compound. Cites Art 3(1) and Art 3(2).
- `nis2_implementing_regulation_significant_incidents_checklist(Profile, Checklist)`: the cited checklist (query type #2).
  - It holds one `item(WayId, Status, cite(KEY))` per way: W1 to W6, then the entity's article points, or WG when the type is absent.
  - Status is `met`, `unmet(Reason)` or `unknown(Keys)`.
  - It is built with `formalize_lib` `eval_requirements/4` over `nis2_implementing_regulation_significant_incidents_requirement/4`.
  - The checklist is INFORMATIONAL. Its OR semantics differ from `decide_labeled/3`'s AND, so the verdict comes ONLY from `significant_incident_criteria/3`.
  - Cites each way's point key.
- `nis2_implementing_regulation_significant_incidents_what_if(Profile, Key, Value, Result)`: Result is the RESULT for Profile with Key set to Value. It uses `query_combinators` `what_if/5`, with closure `nis2_implementing_regulation_significant_incidents_status`. Cites the same as status/2.
- `nis2_implementing_regulation_significant_incidents_fixture(FixtureName, Profile)`: named, ground profiles. The scorer's worked cases live here. Cites per fixture.
- `nis2_implementing_regulation_significant_incidents_fixture_expected(FixtureName, Result, Citations)`: the expected answer of each fixture. Cites per fixture.

Fixture names (minimum set):

| Fixture | Expected result |
|---|---|
| `scheduled_maintenance_with_loss` | not_significant |
| `loss_above_floor_not_scheduled` | significant |
| `loss_above_floor_scheduled_absent` | indeterminate scheduled |
| `loss_equal_floor_turnover_large` | not_significant (boundary) |
| `loss_above_five_percent_of_small_turnover` | significant |
| `loss_below_floor_turnover_absent` | indeterminate turnover |
| `recurring_twice_same_cause_collective_loss` | significant |
| `dns_outage_exactly_thirty_minutes` | not_significant (boundary) |
| `dns_outage_thirty_minutes_one_second` | significant |
| `dns_misconfiguration_exception_applies` | not_significant |
| `dns_misconfiguration_one_percent_exceeded` | significant |
| `tld_any_complete_unavailability` | significant |
| `cloud_limited_availability_users_total_absent` | indeterminate service_users_in_union |
| `data_centre_physical_access` | significant |
| `marketplace_complete_unavailability_over_one_million` | significant |
| `trust_unavailable_twenty_minutes` | not_significant (boundary) |
| `trust_data_compromise_over_one_hundred_users` | significant |
| `entity_type_absent_all_types_closed` | not_significant |
| `entity_type_absent_open` | indeterminate relevant_entity_type |
| `death_unsure_decisive` | needs_legal_review cite art_3_1_c |
| `death_unsure_count_absent` | indeterminate recurring_incidents_within_six_months |
| `unsure_irrelevant_loss_met` | significant |
| `wrong_type_float_loss` | input_problems |
| `duplicate_and_unknown_keys` | input_problems |
| `profile_not_attribute_list` | input_problems wrong_type profile |

## Planned reuse (manifest `uses:`)

**`formalize_lib`:**

- `profile_get/3` (the only profile reader)
- `profile_has/2`
- `profile_lacks/2`
- `profile_set/3` (builds the profile for each setting of the unsure judgements)
- `memberd/2`
- `not_member/2`
- `eval_requirements/4` (checklist)
- `item/3`
- `unmet/1`
- `unknown/1`
- `attribute/2`
- vocabulary atom `met`

`check_tri/4` and `ratio_bps/4` are NOT used:

- The TRUE condition must give OPEN with NO needed key for `unsure`. That is a status shape `check_tri` does not carry.
- The SMALLER-OF tests need exact cross-multiplication, which basis points would round.
- Both are documented in the working notes (not published) as the reason, so as not to trip C14/C15. The local predicates are not clones: they return a needed-key list.

**`kit/query_combinators`:**

- `what_if/5` (what_if facade)

**`validate_props`:**

- `run_props/1`
- `prop_totality/3`
- `prop_determinism/3`
- `prop_citation_complete/3`
- `prop_boundary_coverage/2`
- `prop_missing_key_coverage/3`
- `prop_monotone/5`

These serve the test modes: load, unit per rule, fixtures, boundary, totality/determinism, citation completeness, and monotonicity in the money and user figures.

**Not used:** currency_vocab (euro cents is a unit suffix, with no currency key), deadline_lib, rolling_window and date_time (there are no dates; durations are measured seconds), compliance_lib.

## Layout

`kernel -> citations -> parameters -> nis2_implementing_regulation_significant_incidents -> queries -> fixtures -> package facade`. File and module names are unchanged.

- **kernel.clausal**: result constructors only:
  - `indeterminate/1`
  - `needs_legal_review/2`
  - `open_textured/2`
  - `inputs_relied_on/1`
  - `provenance/2`
  - `input_problems/1`
  - `unknown_key/1`
  - `wrong_type/1`
  - `duplicate_key/1`
  - No predicate is shared between determination slices, because there is one slice.
- **citations.clausal**: `citation_vocabulary` with every key above, and `citation_text(KEY, UnitId)` mapping each key to its pinned unit id (for example `eu_reg_2024_2690_art_7_b` to `32024R2690#point_007_b`).
- **parameters.clausal**: the pin metadata only:
  - source sha256;
  - CELEX;
  - act date 2024-10-17, as an ISO string via `date_string_iso/2` if ever needed;
  - NO statutory figure.
- **queries.clausal**: the facade predicates listed above. They delegate to the slice.
- **fixtures.clausal**: the fixture facts.

## Slice: nis2_implementing_regulation_significant_incidents.clausal

This slice is self-contained: it holds the values, the arithmetic, the input check, the ladder, the unsure rule, the per-rule tests, the checklist rows and the verdict.

### Statutory VALUE facts (owned here, `:- constant_value(Name, Value).`)

| Constant | Value | Source |
|---|---|---|
| `money_limit_euro_cents` | 50000000 | Art 3(1)(a), Art 4(c) |
| `money_turnover_share_percent` | 5 | Art 3(1)(a) |
| `recurring_minimum_incident_count` | 2 | Art 4(a) (`>=`) |
| `thirty_minutes_limit_seconds` | 1800 | Arts 5(a), 7(a), 9(a), 10(a) |
| `twenty_minutes_limit_seconds` | 1200 | Art 14(a) |
| `one_hour_limit_seconds` | 3600 | Arts 5(b), 6(b), 7(b), 8(b), 9(b), 10(b), 14(b) |
| `any_duration_limit_seconds` | 0 | Arts 6(a), 8(a) (Q5) |
| `user_limit_count` | 1000000 | Arts 7, 9 to 13 |
| `user_share_percent` | 5 | Arts 7, 9 to 13 |
| `trust_limited_availability_user_limit_count` | 200000 | Art 14(c) |
| `trust_limited_availability_user_share_percent` | 1 | Art 14(c) |
| `trust_data_user_limit_count` | 100 | Art 14(e) |
| `trust_data_user_share_per_thousand` | 1 | Art 14(e), 0.1 %, as `U * 1000 > Total` |
| `domain_name_exception_limit_count` | 1000 | Art 5(c) (`<`) |
| `domain_name_exception_share_percent` | 1 | Art 5(c) (`=<`) |

Percent tests are always exact cross-multiplication:

- percent: `Count * 100 > Total * Share`
- per thousand: `Count * 1000 > Total * Share`

### Key tables

- `contract_key(Key, Type)`: the twenty-five rows in contract order. Type is one of `entity_type`, `crisp`, `figure` or `judgement`.
- `entity_type_atom/1`: eleven facts.
- `judgement_key/1`: eight facts, in root_exports order (also the PAIRS order).
- `entity_article(EntityType, Article)`: eleven facts mapping each type to an article. Both `managed_service_provider` and `managed_security_service_provider` map to `article_10`.

### Conditions (local, three-valued)

The outcome predicate is `condition_outcome(Profile, Condition, Outcome)`, with Outcome one of `holds`, `fails` or `open(NeededKeys)`. There is exactly one clause per disjoint route.

- **`true_condition(Key)`**: Art 3(1)(b) to (e), Art 4(b), data, malice and physical access.
  - `true` gives `holds`.
  - `false` gives `fails`.
  - absent gives `open([Key])`.
  - `unsure` gives `open([])`.
- **`more_condition(Key, ConstantName)`**: strict `>`.
- **`at_least_condition(Key, ConstantName)`**: `>=`, used for Art 4(a).
- **`smaller_of_condition(UsersKey, TotalKey, LimitConstant, ShareConstant, Scale)`**: Scale is `percent` or `per_thousand`.
  - It `holds` when the count is above the limit, or when the count share exceeds the total share.
  - It `fails` when the count is 0, or when the count is at or below the limit, the total is present and the share comparison is false.
  - Otherwise it is `open`, needing the count key if absent, then the total key if absent.
- **`not_excepted_condition(incorrect_data_only_by_misconfiguration, incorrect_domain_names, managed_domain_names)`**: the Art 5(c) exception, as in THE WAYS.

### Ways (rules / requirements), fixed order

The way facts are:

- `way(WayId, Article, Conditions)`: Article is `general` for W1 to W6.
- `implements(Key)`: one clause per way and key, headed `implements(KEY) :- way(WayId, _, _)` (or a fact), for every key of the way's provision.

The ways:

- **W1** `article_3_1_a`: smaller_of(loss, turnover, money).
- **W2** `article_3_1_b`: true(trade_secret_exfiltration).
- **W3** `article_3_1_c`: true(death_of_natural_person).
- **W4** `article_3_1_d`: true(considerable_damage_to_natural_person_health).
- **W5** `article_3_1_e`: true(suspectedly_malicious_unauthorised_access_capable_of_severe_operational_disruption).
- **W6** `article_3_1_f`: at_least(recurring_incidents_within_six_months, 2) AND true(same_apparent_root_cause) AND smaller_of(recurring_collective_direct_financial_loss_euro_cents, turnover, money).
- **Art 5**:
  - `article_5_a`: more(complete_unavailability_seconds, 1800)
  - `article_5_b`: more(average_response_time_above_ten_seconds_seconds, 3600)
  - `article_5_c`: true(data_compromised) AND not_excepted
- **Art 6**:
  - `article_6_a`: more(complete, 0)
  - `article_6_b`: more(average response, 3600)
  - `article_6_c`: true(data_compromised)
- **Arts 7, 9 and 10**, points `_a` to `_d`:
  - (a): more(complete, 1800)
  - (b): more(limited_availability_seconds, 3600) AND smaller_of(limited_availability_users, service_users_in_union, 1000000, 5 %)
  - (c): true(data_compromised) AND true(data_compromise_suspectedly_malicious)
  - (d): true(data_compromised) AND smaller_of(data_compromise_users, service_users_in_union, 1000000, 5 %)
- **Art 8**:
  - (a): more(complete, 0)
  - (b): more(limited, 3600)
  - (c): data AND malicious
  - (d): true(physical_access_compromised)
- **Arts 11, 12 and 13**:
  - (a): smaller_of(complete_unavailability_users, total, 1000000, 5 %)
  - (b): smaller_of(limited_availability_users, total, 1000000, 5 %)
  - (c): data AND malicious
  - (d): data AND smaller_of(data_compromise_users, total, 1000000, 5 %)
- **Art 14**:
  - (a): more(complete, 1200)
  - (b): more(weekly_unavailability_seconds, 3600)
  - (c): smaller_of(limited_availability_users, total, 200000, 1 %)
  - (d): true(physical_access_compromised)
  - (e): data AND smaller_of(data_compromise_users, total, 100, per thousand 1)
- **WG** `article_3_1_g_entity_type_absent`: used when the type is absent.
  - Each of the eleven types is folded to `met`, `closed` or `open`.
  - WG is `met` if all eleven are met.
  - WG is `closed` if all eleven are closed.
  - Otherwise WG is `open([relevant_entity_type])`.

Way helpers:

- `way_outcome(Profile, WayId, Outcome)`: Outcome is `met`, `closed` or `open(NeededKeys)`. The needed keys are the concatenation, in condition order, without duplicates.
- `active_ways(Profile, WayIds)`: W1 to W6, then the entity article's points, or WG.

### Ladder and unsure rule

The helpers:

- `ladder_answer(Profile, Result, Citations)` runs steps 1 to 5. The step routes:
  - step 1: scheduled is `true`.
  - step 2: some way met. If scheduled is `false`, the answer is `significant`. If scheduled is absent, it is `indeterminate([scheduled_interruption_or_maintenance])`.
  - step 3: all ways closed, giving `not_significant`.
  - step 4: some way open and scheduled absent.
  - step 5: the fewest-needed open way.
  - In step 5, an open way may have zero needed keys (only from `unsure`). This cannot occur in the ladder, because the ladder runs on unsure-free settings.
- `unsure_judgements(Profile, Keys)`: the unsure keys, in root_exports order.
- `setting_profiles(Profile, Keys, Settings)`: all 2^n `Assignment-Profile` pairs, built with `profile_set/3`.
- `unsure_answer(Profile, Result, Citations)` runs steps 6, 7 and 8:
  - step 6: some setting gives `indeterminate`. The key named is the first such key in root_exports order.
  - step 7: all settings give the same result.
  - step 8: the first turning unsure key, with CITE taken from `referral_citation(Key, Cite)` (eight facts) and PAIRS taken from `inputs_relied_on_pairs/2`.

`significant_incident_criteria/3` has three mutually exclusive clauses:

- Problems is non-empty.
- Problems is `[]` and there are no unsure judgements: the ladder.
- Problems is `[]` and there are unsure judgements: the unsure rule.

### Input check (owned here)

The check builds its lists in this order:

1. `contract_key_problems/2`: for each contract key in order, `duplicate_key` if the key occurs 2 or more times; else `wrong_type` if a single present value fails its type (an unbound value fails).
2. `unknown_keys_in_order/2`: the first occurrence of each non-contract key. Non-atom keys, unbound keys included, are unknown and are given as they are.
3. `well_formed_attribute_list/1`: a proper, ground-spined list whose every element is a non-variable `attribute/2`. Otherwise the result is `[wrong_type(profile)]`.

The check never fails and never raises.

### Verdict atoms

- final: `significant`, `not_significant`.
- status: `indeterminate/1`, `needs_legal_review/2`, `input_problems/1`.

### Per-rule tests (in this slice's test file)

- One positive and one negative test per way, at each boundary:
  - 1800 against 1801;
  - 3600 against 3601;
  - 1200 against 1201;
  - 0 against 1;
  - 50000000 against 50000001;
  - 5 % exact against 5 % plus one;
  - 1000000 against 1000001;
  - 200000, 100, 1000 and 1 % at their edges.
- Precedence tests:
  - scheduled over met;
  - met before other keys;
  - closed regardless of scheduled;
  - the fewest-needed tie-break;
  - TOTAL counted while U is absent.
- Unsure tests: the status rule naming (Q16), common answer, the turning key, and the citation for each referral key.
- Input-check tests: duplicate over wrong_type, unknown order, non-list, partial list, unbound value, non-atom key.
- Every negative test is paired with a positive test over the same case. Solution counts are asserted with `findall` + `length(_, 1)`.

### Predicates shared with another slice

None. Only the result constructors live in kernel.clausal.
