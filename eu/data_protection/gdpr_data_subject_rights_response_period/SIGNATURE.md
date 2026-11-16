# SIGNATURE — eu/data_protection/gdpr_data_subject_rights_response_period

The package layout is kept as scaffolded:

`kernel -> citations -> parameters -> gdpr_data_subject_rights_response_period -> queries -> fixtures -> package facade`

There is one determination slice, `gdpr_data_subject_rights_response_period.clausal`. It owns all value facts, all arithmetic, the input check, and its own tests, checklist and verdict.

## Public query surface

The order-mandated relations below keep the exact names and arities fixed by INTERFACE - THE RELATIONS, which the scorer calls. The scaffold facade names are kept as well.

Every public relation yields EXACTLY ONE solution for every input (COUNTING):

- clauses are disjoint;
- there is no cut, no if-then-else and no once/1;
- the input check runs first.

All arithmetic is exact integers.

## Verdict STATUS atoms

These replace the scaffold placeholders `required`, `permitted` and `not_applicable`.

- `first_period`: the one-month period applies.
- `extended_period`: the three-month period applies.
- `indeterminate`: a required key is absent (here only `extension_necessary_for_complexity_and_number`).
- `needs_legal_review`: the judgement is `unsure`.
- `input_problems`: the profile failed the input check.

`applicable_response_period/2` returns the full result term in its PERIOD argument. That term is one of:

- `first_period`
- `extended_period`
- `indeterminate([extension_necessary_for_complexity_and_number])`
- `needs_legal_review(open_textured(extension_necessary_for_complexity_and_number, cite(eu_reg_2016_679_art_12_3)), [inputs_relied_on([extension_necessary_for_complexity_and_number-unsure])])`
- `input_problems(PROBLEMS)`

The facade status/2 projects the term to its STATUS atom.

## Result constructors

These are exported and never called as queries:

indeterminate/1, needs_legal_review/2, open_textured/2, inputs_relied_on/1, provenance/2, input_problems/1, unknown_key/1, wrong_type/1, duplicate_key/1, outside_fact/2, attested/2, attestation/4, url/2, document/2.

## Profile keys

There are exactly fifty-four keys, in contract order. The contract order is the manifest root_exports order. If the scaffold manifest already fixes that order, the manifest wins and the input check follows it.

PROFILE is an attribute list `[attribute(KEY, VALUE), ...]`. It is read only with `profile_get/3`, `profile_has/2` and `profile_lacks/2`, and keys are always atoms, never string literals.

**Atom keys.** Neither is read by any query of this order; both are input-check only.

- `request_type`: one of `access`, `rectification`, `erasure`, `restriction`, `portability`, `objection`, `automated_decision`.
- `objection_ground_claimed`: one of `art21_1`, `art21_2`, `art21_6`.

**Date key.** Not read by any query; input-check only.

- `request_received_on`: a ground `date(Year, Month, Day)` of a real calendar day.

**Crisp keys.** Twenty-five keys, each the atom `true` or `false`:

- `extension_claimed`: READ, as a defeater.
- The other twenty-four are input-check only:
  - controller_demonstrates_unable_to_identify_data_subject
  - identity_confirmed
  - personal_data_inaccurate
  - consent_is_the_basis_of_processing
  - consent_withdrawn
  - other_legal_ground_for_processing_exists
  - objection_under_art21_1_made
  - objection_under_art21_2_made
  - collected_in_relation_to_information_society_services_offer
  - accuracy_contested_by_data_subject
  - data_subject_opposes_erasure
  - data_required_by_data_subject_for_legal_claims
  - verification_of_overriding_grounds_pending
  - personal_data_provided_by_data_subject
  - processing_based_on_consent_or_contract
  - processing_carried_out_by_automated_means
  - processing_based_on_art6_1_e_or_f
  - processing_for_direct_marketing
  - processing_for_research_or_statistics_pursuant_to_art89_1
  - data_subject_gave_explicit_consent
  - decision_based_on_special_categories
  - special_category_condition_and_safeguards_met_for_decision
  - personal_data_disclosed_to_recipients
  - data_subject_asks_who_the_recipients_are

**Judgement keys.** Twenty-one keys, each the atom `true`, `false` or `unsure`:

- `extension_necessary_for_complexity_and_number`: READ. It is required only when `extension_claimed` is `true`.
- The other twenty are input-check only:
  - reasonable_doubts_about_identity
  - request_manifestly_unfounded_or_excessive
  - personal_data_incomplete_in_light_of_purposes
  - data_no_longer_necessary_for_purposes
  - overriding_legitimate_grounds_exist
  - personal_data_unlawfully_processed
  - processing_necessary_for_freedom_of_expression_and_information
  - processing_necessary_for_public_task_or_official_authority
  - processing_necessary_for_public_health_in_accordance_with_art9_2_h_and_i
  - processing_for_archiving_research_or_statistics_in_accordance_with_art89_1
  - erasure_would_render_impossible_or_seriously_impair_processing_objectives
  - processing_necessary_for_legal_claims
  - controller_no_longer_needs_data_for_processing_purposes
  - transmission_would_adversely_affect_rights_and_freedoms_of_others
  - objection_grounds_relate_to_particular_situation
  - controller_demonstrates_compelling_legitimate_grounds
  - decision_based_solely_on_automated_processing
  - decision_produces_legal_or_similarly_significant_effects
  - decision_necessary_for_contract_with_data_subject
  - recipient_notification_impossible_or_disproportionate_effort

**Outside facts.** Five keys, listed in `outside_facts:` order:

1. `erasure_required_by_union_or_member_state_law`: enabling; never read by a query here.
2. `processing_required_by_union_or_member_state_law`: blocking.
3. `decision_authorised_by_union_or_member_state_law`: blocking.
4. `legislative_restriction_applies_to_the_right`: blocking.
5. `public_holidays`: VALUE is a list, possibly [], of real `date(Y, M, D)` days.

Each present value is `attested(VALUE, attestation(BY, AT, REASON, EVIDENCE))`. EVIDENCE is `url(URL, RETRIEVED_AT)`, `document(UPLOAD_ID, SHA256)` or `none`. The fetcher is `none`, so only attested values are read. All five are recorded by `request_outside_facts/2` only.

**Argument names, not profile keys.** These appear only in problem terms of `response_deadline/3`:

- `receipt_date`: the first argument (RECEIPT).
- `response_period`: the second argument (PERIOD), atom `first_period` or `extended_period`.

## Citation-key atoms

These live in citations.clausal.

**Load-bearing:**

- `eu_reg_2016_679_art_12_3`: GDPR Art 12(3), the one-month period and its extension.
- `eu_reg_1971_1182_art_3`: Reg (EEC, Euratom) No 1182/71 Art 3(1), 3(2)(c) and 3(4), the computation of periods. Pinned Formex extract 31971R1182-art003.fmx4.xml, sha256 55a56126f24456ad48cb09bc6a7698d768cceec70806959dda928d252e96b8c1.

**Context only, for the `outside_facts:` manifest table (CITATION column):**

- `eu_reg_2016_679_art_17_1_e`
- `eu_reg_2016_679_art_17_3_b`
- `eu_reg_2016_679_art_22_2_b`
- `eu_reg_2016_679_art_23_1`

If the scaffold manifest already names CITATION and TARGET for these, those values are kept unchanged. `public_holidays` cites `eu_reg_1971_1182_art_3`.

The deferred units parag_012.002, .004, .005 and .006 get no load-bearing atom.

## Public predicates

- `applicable_response_period(Profile, Period)`: THE PERIOD (INTERFACE (B)).
  - Input problems give `input_problems(Problems)`.
  - `extension_claimed` absent or `false` gives `first_period`.
  - `extension_claimed` `true`, with necessity:
    - absent: `indeterminate([extension_necessary_for_complexity_and_number])`;
    - `true`: `extended_period`;
    - `false`: `first_period`;
    - `unsure`: `needs_legal_review(open_textured(...), [inputs_relied_on([...-unsure])])`.
  - Reads no other key. Citation: `eu_reg_2016_679_art_12_3`.
- `response_deadline(Receipt, Period, Deadline)`: THE DEADLINE (INTERFACE (A)).
  - Deadline is `date(Year, Month, Day)` with bare integers. It is the same day 1 or 3 months after Receipt, clipped to the last day of the target month, then moved off a Saturday or Sunday.
  - It applies no public-holiday shift.
  - Problem answers:
    - an invalid Receipt gives `input_problems([wrong_type(receipt_date)])`;
    - an invalid Period gives `input_problems([wrong_type(response_period)])`;
    - both give `input_problems([wrong_type(receipt_date), wrong_type(response_period)])`.
  - Citation: `eu_reg_2016_679_art_12_3`, `eu_reg_1971_1182_art_3`.
- `request_outside_facts(Profile, OutsideFacts)`:
  - Gives `[outside_fact(Key, Attested), ...]` for the five outside facts in `outside_facts:` order.
  - Attested is the attested(...) term as given, or `absent`.
  - Input problems give `input_problems(Problems)`.
  - Citation: `eu_reg_1971_1182_art_3` (public_holidays). The other four are context only.
- `gdpr_data_subject_rights_response_period_input_problems(Profile, Problems)`: THE INPUT CHECK (G1).
  - A well-formed profile gives `[]`.
  - A non-attribute-list profile gives `[wrong_type(profile)]`.
  - Otherwise, for each contract key in contract order: `duplicate_key(Key)` if the key repeats (its values are not read), else `wrong_type(Key)` if its value is ill-typed.
  - Then `unknown_key(Key)` once per non-contract key, in order of first occurrence.
  - Absence is never a problem. Citation: `eu_reg_2016_679_art_12_3`.
- `decide_gdpr_data_subject_rights_response_period(Profile, gdpr_data_subject_rights_response_period_verdict(Status, Citations))`: the facade verdict.
  - Status is the STATUS atom of `applicable_response_period/2`.
  - Citations is `[eu_reg_2016_679_art_12_3]`, or `[]` for `input_problems`.
- `gdpr_data_subject_rights_response_period_status(Profile, Status)`: the STATUS atom only.
- `gdpr_data_subject_rights_response_period_checklist(Profile, Checklist)`: `[item(RequirementId, Status, cite(Citation)), ...]`, or `input_problems(Problems)`.
  - Requirement ids:
    - `extension_claimed_by_controller`: `met` when present `true`; `unmet(extension_not_claimed)` when absent or `false`.
    - `extension_necessary_for_complexity_and_number`: `inapplicable` when the extension is not claimed; otherwise via `check_tri/4` (`met`, `unmet(...)`, or `unknown([Key])`, where absent or `unsure` is unknown).
  - Built with `eval_requirements/4` over the slice's `requirement/4` closure (RequirementId first).
- `gdpr_data_subject_rights_response_period_what_if(Profile, Key, Value, Period)`: the PERIOD of the profile with `attribute(Key, Value)` set. It is built with `profile_set/3`, which replaces the entry rather than duplicating it; P2 pins this with a test. The input check runs on the edited profile.
- Fixtures: `gdpr_data_subject_rights_response_period_fixture(Name, Profile, ExpectedPeriod)` and `gdpr_data_subject_rights_response_period_deadline_fixture(Name, Receipt, Period, ExpectedDeadline)`. Both are listed in the slice section below.

## Planned reuse (manifest `uses:`)

**formalize_lib:**

- profile_get/3, profile_has/2, profile_lacks/2, profile_set/3
- check_tri/4, eval_requirements/4
- not_member/2, int_min/3
- attribute/2, item/3, unmet/1, unknown/1

**kit/deadline_lib:**

- `month_last_day/3`: the last day of the target month. P2 pins the Gregorian rule by test: 1900-02 has 28 days, 2000-02 has 29, 2028-02 has 29. If it is not Gregorian, the slice defines its own local version instead.
- Do NOT use `deadline_months_after/3`. It counts to the last day of the period, which is not the Art 3(2)(c) same-date rule.

**library(datetime):**

- `weekday/2`, `date_add/3`, `timedelta/3`, on date/4 objects.
- Native date objects are used only internally. The interface terms stay `date(Y, M, D)` with integers.

**kit/query_combinators:** none. what_if is a one-key override through profile_set/3.

**validate_props (tests):**

- prop_totality/3 and prop_determinism/3 over fixture profiles and deadline fixtures;
- prop_boundary_coverage/2 over month-end, leap-year and weekend receipts;
- prop_missing_key_coverage/3 for `extension_necessary_for_complexity_and_number`.

**kernel.clausal:** no new shared predicate; there is only one slice. The scaffold kernel floor stays as is.

**parameters.clausal:** holds no figures. The period lengths are owned by the slice.

**queries.clausal:** re-exports:

- applicable_response_period/2
- response_deadline/3
- request_outside_facts/2
- gdpr_data_subject_rights_response_period_input_problems/2

It must not export request_response_deadline/2.

## Slice: gdpr_data_subject_rights_response_period.clausal

### Value facts owned

- `:- constant_value(first_period_months, 1).` (Art 12(3))
- `:- constant_value(extended_period_months, 3).` (Art 12(3): one month plus two further months, counted from receipt)
- `period_months(first_period, first_period_months).` and `period_months(extended_period, extended_period_months).`
- `weekend_shift_days(WeekdayCode, Days)`: Saturday 2 days, Sunday 1 day, any other weekday 0. The codes follow the native `weekday/2` numbering, pinned by test: 2026-11-28 is a Saturday and 2026-11-29 a Sunday. Citation: `eu_reg_1971_1182_art_3` (Art 3(4)).
- `gregorian_cycle_years(400)`: used only for the year-10000 edge (the working notes (not published)).
- The contract tables:
  - `contract_key(Key, Type)` for all fifty-four keys, in contract order. Type is one of:
    - `atom_enum(request_type)`, `atom_enum(objection_ground_claimed)`
    - `calendar_date`
    - `crisp`
    - `judgement`
    - `outside_fact_boolean`
    - `outside_fact_date_list`
  - `enum_value(request_type, Atom)` for the seven request types.
  - `enum_value(objection_ground_claimed, Atom)` for the three grounds.
  - `outside_fact_order(Key)` in `outside_facts:` order.

### Rules

1. **Input check.**
   - `profile_is_attribute_list/1` and its disjoint complement give `[wrong_type(profile)]`.
   - Otherwise:
     - per contract key: `key_occurrence_count`, giving `duplicate_key(Key)` when the count is above 1;
     - when the count is 1, `value_has_type(Type, Value)` or the complement `wrong_type(Key)`;
     - when the count is 0, nothing;
     - then the unknown keys, deduplicated in first-occurrence order.
   - `real_calendar_date(date(Y, M, D))`: integers, 1 =< Y =< 9999, 1 =< M =< 12, 1 =< D =< month_last_day.
2. **Period** (`applicable_response_period/2`): seven disjoint clauses with the result folded into the head (C17):
   1. problems;
   2. extension_claimed absent;
   3. extension_claimed false;
   4. claimed and necessity absent;
   5. claimed and necessity true;
   6. claimed and necessity false;
   7. claimed and necessity unsure.

   Clauses 2-7 all require the problem list to be `[]`.
3. **Month arithmetic.**
   - MonthIndex is Year * 12 + (Month - 1) + Months.
   - TargetYear is MonthIndex // 12.
   - TargetMonth is MonthIndex mod 12 + 1.
   - TargetDay comes from int_min of Day and LastDay (Art 3(2)(c); Art 3(1) is honoured because the receipt day itself is not counted).
4. **Weekend shift** (Art 3(4), Saturday and Sunday only).
   - Build the native date/4 for the target. Use TargetYear - 400 when TargetYear > 9999.
   - Take weekday/2, then weekend_shift_days, then timedelta(Days, 0, Delta), then date_add.
   - Read back the integers, re-adding 400 years if they were subtracted.
5. **Deadline** (`response_deadline/3`): four disjoint clauses:
   1. valid receipt and valid period;
   2. invalid receipt only;
   3. invalid period only;
   4. both invalid.

   A valid period is `first_period` or `extended_period`.
6. **Outside facts** (`request_outside_facts/2`): a problems clause, and a clean clause that maps the five keys in order. For each key, `profile_has` gives the attested term as given, and `profile_lacks` gives `absent`.

### Verdict atoms

`first_period`, `extended_period`, `indeterminate`, `needs_legal_review`, `input_problems`.

### Shared with another slice

None. Nothing moves to kernel.clausal.

### Per-rule tests

Each test asserts the full findall list, so a duplicate answer fails it.

**response_deadline/3**, with no holiday shift:

| Receipt | Period | Deadline | Why |
|---|---|---|---|
| date(2026, 10, 29) | first_period | date(2026, 11, 30) | Sunday 29th shifts to Monday |
| date(2026, 1, 31) | first_period | date(2026, 3, 2) | clipped to Saturday 28 Feb, shifts to Monday |
| date(2028, 1, 31) | first_period | date(2028, 2, 29) | leap year |
| date(2026, 12, 31) | first_period | date(2027, 2, 1) | year carry; Sunday 31 Jan shifts to Monday |
| date(2026, 1, 31) | extended_period | date(2026, 4, 30) | not 2026-04-28 |
| date(2026, 11, 30) | extended_period | date(2027, 3, 1) | Sunday 28 Feb shifts to Monday |
| date(2026, 3, 15) | first_period | date(2026, 4, 15) | Wednesday, no shift |

Problem cases:

- `date(2026, 2, 30)`, `first_period`: `input_problems([wrong_type(receipt_date)])`.
- `date(2026, 1, 1)`, `two_months`: `input_problems([wrong_type(response_period)])`.
- `foo`, `bar`: `input_problems([wrong_type(receipt_date), wrong_type(response_period)])`.
- `[2026, 1, 1]`, `first_period`: wrong_type(receipt_date).
- year-10000 edge: `date(9999, 12, 15)`, `extended_period` gives a ground date(10000, 3, Day) and exactly one solution.

**applicable_response_period/2:**

| Profile | Period |
|---|---|
| [] | first_period |
| [attribute(extension_claimed, false)] | first_period |
| [attribute(extension_necessary_for_complexity_and_number, true)] | first_period (not read) |
| [attribute(extension_claimed, true)] | indeterminate([extension_necessary_for_complexity_and_number]) |
| claimed true, necessity true | extended_period |
| claimed true, necessity false | first_period |
| claimed true, necessity unsure | the needs_legal_review term above |

An unread key such as `attribute(request_type, erasure)` or `attribute(consent_withdrawn, true)` must not change any answer.

**Input check:**

| Profile | Problems |
|---|---|
| [attribute(foo, 1), attribute(foo, 2)] | [unknown_key(foo)] |
| two extension_claimed entries | [duplicate_key(extension_claimed)], whatever the values; never also wrong_type |
| [attribute(extension_claimed, unsure)] | [wrong_type(extension_claimed)] |
| [attribute(request_type, deletion)] | [wrong_type(request_type)] |
| [attribute(request_received_on, date(2026, 2, 29))] | [wrong_type(request_received_on)] |
| public_holidays given as attested([date(2026, 13, 1)], attestation(b, a, r, none)) | [wrong_type(public_holidays)] |
| legislative_restriction_applies_to_the_right given as a bare true | [wrong_type(legislative_restriction_applies_to_the_right)] |
| foo | [wrong_type(profile)] |
| [x] | [wrong_type(profile)] |

The check also orders its problems: contract-key problems come in contract order, then unknown keys.

**request_outside_facts/2:**

- With `public_holidays` given as `attested([date(2026, 11, 30)], attestation(b, a, r, none))`, the fifth item is `outside_fact(public_holidays, attested(...))`, and the other four are `absent`.
- `response_deadline(date(2026, 10, 29), first_period, D)` still gives `date(2026, 11, 30)`.

**Facade:**

- status, decide, checklist and what_if agree with applicable_response_period on every fixture.
- what_if(P, extension_necessary_for_complexity_and_number, true, R) on a claimed profile gives `extended_period`.

### Checklist

The two requirement ids above, each item with `cite(eu_reg_2016_679_art_12_3)`, met items included.
