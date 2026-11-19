# SIGNATURE — eu/data_protection/gdpr_information_duties_timing

## Contents

1. Query surface
2. Answer atoms and status compounds
3. Profile keys
4. Citation-key atoms
5. Public predicates
6. kernel.clausal — the shared floor
7. citations.clausal and parameters.clausal
8. Slice information_deadline_basis.clausal
9. Slice information_timing_verdict.clausal
10. queries.clausal
11. fixtures.clausal and tests
12. Planned reuse (manifest `uses:`)
13. Totality, determinism and counting claims

## 1. Query surface

The scored surface is four relations. Each is called with the PROFILE attribute list only, takes no date argument, and gives exactly one solution per call.

- `information_deadline(Profile, Deadline)`
- `information_deadline_basis(Profile, Basis)`
- `information_timing_verdict(Profile, Verdict, Citations)`
- `gdpr_information_duties_timing_input_problems(Profile, Problems)`

The scaffold facade keeps the names:

- `decide_information_deadline_basis/2`
- `information_deadline_basis_status/2`
- `information_deadline_basis_checklist/2`
- `decide_information_timing_verdict/2`
- `information_timing_verdict_status/2`
- `information_timing_verdict_checklist/2`
- `gdpr_information_duties_timing_what_if/4`
- `fixture/2`

The query-type predicates (#13, #14, #15) are added in queries.clausal.

Imported figures: none. The one-month period is the only statutory figure; it is declared once, in its slice.

## 2. Answer atoms and status compounds

The scaffold placeholder `{ required, permitted, not_applicable }` is REPLACED by the atoms below.

**BASIS atoms** (bare): `art13_1`, `art14_3_a`, `art14_3_b`, `art14_3_c`.

**VERDICT atoms** (bare): `timely`, `late`.

**DEADLINE:** `date(Year, Month, Day)`, three bare integers, queried element-wise.

**Status compounds.** These are returned as they are and never wrapped.

- `indeterminate(MissingKeys)`: a non-empty list in root_exports order with no duplicates. The bare atom `indeterminate` is NEVER written.
- `input_problems(Problems)`: built from `unknown_key/1`, `wrong_type/1` and `duplicate_key/1`.
- The open-texture review, for VERDICT only:
  `needs_legal_review(open_textured(provided_within_reasonable_period, cite(eu_reg_2016_679_art_14_3_a)), [inputs_relied_on([provided_within_reasonable_period-unsure]) | OptionalProvenance])`
- The public-holidays referral, REF, in the DEADLINE, BASIS and VERDICT slots:
  `needs_legal_review(cross_reference_unresolved(cite(eu_reg_1971_1182_art_3_4), cite(public_holidays_applicable_to_the_period)), [resolution(cite(public_holidays_applicable_to_the_period), not_attempted), inputs_relied_on(Pairs) | OptionalProvenance])`
  - Pairs is `[]` or `[provided_within_reasonable_period-Value]`.

OptionalProvenance is at most one unscored `provenance(Clause, Citations)` item.

**Other root-exported atoms:** `unsure`, `not_attempted`.

**Item atoms** are the item row of verdict_vocabulary. The type `item_provided` is that row without `other_purpose_information`.

The atoms `true` and `false` are never pinned in verdict_vocabulary or root_exports.

**Result constructors** are exported and never queried:

- input_problems/1, unknown_key/1, wrong_type/1, duplicate_key/1
- indeterminate/1, needs_legal_review/2, open_textured/2, cross_reference_unresolved/2
- resolution/2, inputs_relied_on/1, provenance/2
- attested/2, attestation/4, url/2, document/2

## 3. Profile keys

There are twenty-six keys, root-exported in exactly this order. MISSING_KEYS and PROBLEMS follow this order.

| # | Key | Type |
|---|---|---|
| 1 | personal_data_collected_from_data_subject | CRISP, `true`/`false` |
| 2 | items_provided | LIST of item_provided |
| 3 | items_data_subject_already_has | LIST of item |
| 4 | data_protection_officer_designated | CRISP |
| 5 | processing_based_on_legitimate_interests | CRISP |
| 6 | recipients_exist | CRISP |
| 7 | transfer_intended | CRISP |
| 8 | processing_based_on_consent | CRISP |
| 9 | automated_decision_making_under_article_22 | JUDGEMENT, `true`/`false`/`unsure` |
| 10 | obtaining_date | DATE, date(Year, Month, Day) |
| 11 | provision_date | DATE |
| 12 | data_used_for_communication_with_data_subject | CRISP |
| 13 | first_communication_date | DATE |
| 14 | disclosure_to_another_recipient_envisaged | CRISP |
| 15 | first_disclosure_date | DATE |
| 16 | provided_within_reasonable_period | JUDGEMENT |
| 17 | provision_impossible_or_disproportionate_effort | JUDGEMENT |
| 18 | protective_measures_taken | CRISP |
| 19 | obtaining_or_disclosure_laid_down_by_law | OUTSIDE FACT, attested(true/false, attestation(By, At, Reason, Evidence)) |
| 20 | professional_secrecy_obligation_by_law | OUTSIDE FACT, as 19 |
| 21 | further_processing_for_another_purpose_intended | CRISP |
| 22 | further_processing_start_date | DATE |
| 23 | further_processing_information_date | DATE |
| 24 | further_processing_items_provided | LIST of item |
| 25 | paragraph_2_information_relevant_to_further_processing | JUDGEMENT |
| 26 | public_holidays | OUTSIDE FACT, attested(ListOfDates, attestation(...)), fetcher none |

**Keys READ by this order:** 1, 10, 11, 12, 13, 14, 15, 16 and 26.

All other keys are accepted, type-checked by the input check, and ignored. A key that is not read never changes an answer.

There is no money key and no numeric key, so no unit suffix applies.

## 4. Citation-key atoms

These are the canonical atoms of _lexicon/citations.yaml. Shortened atoms are never invented.

- `eu_reg_2016_679_art_13_1`: GDPR Art 13(1), the Art 13 deadline.
- `eu_reg_2016_679_art_14_3_a`: GDPR Art 14(3)(a), one month and the reasonable period.
- `eu_reg_2016_679_art_14_3_b`: GDPR Art 14(3)(b), the first communication.
- `eu_reg_2016_679_art_14_3_c`: GDPR Art 14(3)(c), the first disclosure.
- `eu_reg_1971_1182_art_3`: Reg 1182/71 Art 3(1) second subparagraph, Art 3(2)(c) and Art 2(2). It is checklist provenance of the calendar rule only and never enters CITES.
- `eu_reg_1971_1182_art_3_4`: Reg 1182/71 Art 3(4). It appears only inside REF.
- `public_holidays_applicable_to_the_period`: the unresolved cross-reference target inside REF.

The definitions Art 4(1), (4), (7) and (9) are NOT citation keys of any answer.

## 5. Public predicates

### Scored relations

- `information_deadline(Profile, Deadline)`: Deadline is `date(Year, Month, Day)`, or `indeterminate/1`, `input_problems/1` or REF with Pairs []. It applies rules (D), (P) and (S1). Citations: eu_reg_2016_679_art_13_1, eu_reg_2016_679_art_14_3_a, eu_reg_2016_679_art_14_3_b, eu_reg_2016_679_art_14_3_c, eu_reg_1971_1182_art_3.
- `information_deadline_basis(Profile, Basis)`: Basis is art13_1, art14_3_a, art14_3_b or art14_3_c, or a status compound. It applies rules (E), (P) and (S2)-(S4). The limb citations are the same as above.
- `information_timing_verdict(Profile, Verdict, Citations)`: Verdict is timely, late or a status compound. Citations is [cite(K)] for a final Verdict, else []. It applies rules (F), (P) and (S5). Citations: eu_reg_2016_679_art_13_1 and eu_reg_2016_679_art_14_3_a/_b/_c.
- `gdpr_information_duties_timing_input_problems(Profile, Problems)`: the input check (K), G1. Problems is [] or a list in the order stated in section 6.

### Facade

- `decide_information_deadline_basis(Profile, information_deadline_basis_decision(Basis, Citations))`: Basis as (E). Citations is [cite(eu_reg_2016_679_art_13_1)] or [cite(eu_reg_2016_679_art_14_3_K)] for a final Basis, else [].
- `information_deadline_basis_status(Profile, Basis)`: the Basis projection of the decision.
- `information_deadline_basis_checklist(Profile, Checklist)`: a list of `item(RequirementId, Status, cite(Key))`, covering:
  - route_known, cited eu_reg_2016_679_art_13_1;
  - limb_a_period, cited eu_reg_2016_679_art_14_3_a;
  - calendar_rule, cited eu_reg_1971_1182_art_3;
  - limb_b_applies, cited eu_reg_2016_679_art_14_3_b;
  - limb_c_applies, cited eu_reg_2016_679_art_14_3_c.
- `decide_information_timing_verdict(Profile, information_timing_verdict_decision(Verdict, Citations))`: query type #2 (eligibility), with the checklist below. Citations as (F).
- `information_timing_verdict_status(Profile, Verdict)`: the Verdict projection of the decision.
- `information_timing_verdict_checklist(Profile, Checklist)`: query type #2. The items are:
  - deadline_known, cited for the limb of BASIS;
  - provided_on_or_before_deadline, cited for the limb of BASIS;
  - provided_within_reasonable_period, cited eu_reg_2016_679_art_14_3_a, via `check_tri/4`, Art 14 route only.
- `gdpr_information_duties_timing_what_if(Profile, Key, Value, Verdict)`: overrides one key with `profile_set/3`, then reads `information_timing_verdict_status/2`. Cited as (F).

### Query types (queries.clausal)

- `gdpr_information_duties_timing_compliance_check(Profile, ProposedProvisionDate, Verdict)`: query type #13. Is giving the information on ProposedProvisionDate allowed, that is, timely? It sets provision_date and answers as (F). This is a helper, not a scored relation, and the scored contract still carries no date argument. Citations as (F).
- `gdpr_information_duties_timing_obligation(Profile, Obligation)`: query type #14. Obligation is `obligation(provide_information, by(Deadline), basis(Basis), consequence(late))` when Deadline and Basis are final. Otherwise it is the status compound of (D) or (E), the first non-final one in that order. Cited for the limb of Basis.
- `information_deadline(Profile, Deadline)`: query type #15 (above). The consequence of missing the deadline is the verdict `late` of (F).

### Fixtures

- `fixture(FixtureName, Profile)`: the named hand-computed profiles of section 11.

## 6. kernel.clausal — the shared floor

Only these predicates are SHARED by both slices.

### Contract keys

- `contract_key(Key)`: twenty-six facts in root_exports order.
- `key_type(Key, Type)`: one of crisp, judgement, list_item, list_item_provided, date, law_fact, holiday_list.

### Input check

- `gdpr_information_duties_timing_input_problems(Profile, Problems)`: the G1 check. It produces problems in this order:
  1. `[wrong_type(profile)]` when Profile is not an attribute list;
  2. per contract key in contract order, `duplicate_key(Key)` if the key repeats (values not read), else `wrong_type(Key)` if its value is not of its type;
  3. `unknown_key(Key)` once per non-contract key, in first-occurrence order.

### Type tests

- `real_calendar_date(DateTerm)`: a ground date(Year, Month, Day) of integers with 1 =< Month =< 12 and 1 =< Day =< LastDay, where LastDay comes from `month_last_day/3` of kit/deadline_lib (Gregorian leap rule).
- `item_atom(Item)` and `item_provided_atom(Item)`: the vocabulary rows.

### Route and date helpers

- `route(Profile, Route)`: Route is art13, art14 or absent. It is read with profile_get/3 by presence, then by value. Its clauses are disjoint.
- `date_key(date(Year, Month, Day), Key)`: Key is Year*10000 + Month*100 + Day, an exact integer used for every comparison.
- `date_on_or_before(Earlier, Later)` and `date_strictly_before(Earlier, Later)`: comparisons on date_key. They are local names because the kit date_* predicates have an unstated representation; they are not re-definitions of imports.
- `weekend_day(DateTerm)`: builds the native date with `date(Year, Month, Day, DateObject)` (date/4) and tests `weekday(DateObject, Weekday)` for 5 or 6 (Monday = 0).
- `following_day(DateTerm, NextDateTerm)`: `timedelta(1, 0, OneDay)` and `date_add/3` on the native object, converted back to date/3.

### Shared answer pieces

- `earliest_event_limb(Profile, EarliestEventLimb)`: `known(none)`, `known(event(DateTerm, Limb))` (a (b)/(c) tie gives art14_3_b) or `unknown(MissingKeys)`. It reads (12), then (13) only if (12) is true, then (14), then (15) only if (14) is true. This is the X of (P) and (S).
- `holiday_referral(Pairs, Referral)`: builds REF.
- `missing_in_contract_order(Keys, Ordered)`: orders keys by the contract and removes duplicates.

## 7. citations.clausal and parameters.clausal

**citations.clausal:**

- `citation(Key, Instrument, Unit)` for the seven atoms of section 4.
- `limb_citation(Basis, Key)`, which maps:
  - art13_1 to eu_reg_2016_679_art_13_1;
  - art14_3_a to eu_reg_2016_679_art_14_3_a;
  - art14_3_b to eu_reg_2016_679_art_14_3_b;
  - art14_3_c to eu_reg_2016_679_art_14_3_c.

**parameters.clausal:**

- the pin of the consolidated text 02016R0679-20160504, in force from 2016-05-04, with the 2018 corrigendum;
- the pin of 31971R1182, OJ L 124, 8.6.1971.

Statutory values are NOT declared here; they live in their slices.

## 8. Slice information_deadline_basis.clausal

This slice owns relations (D) and (E), and the facade decide_/status/checklist of the basis.

### Value facts owned

- `:- constant_value(art_14_3_a_period_months, 1).`
- `period_day_not_counted(event_day)`: Art 3(1), second subparagraph.
- `month_period_end(same_date_capped)`: Art 3(2)(c).
- `last_day_roll(following_working_day)`: Art 3(4).

### Rules

1. `limb_a_date(ObtainingDate, HolidayList, LimbADate)`. The period of constant(art_14_3_a_period_months) months is added to the month, with December rolling into January of Year+1. The day is capped by month_last_day/3. Then the date rolls forward while it is a weekend_day, or a member of HolidayList by `memberd/2`. The last day is inclusive. The roll recurses cut-free.
2. `limb_a_date_without_holidays(ObtainingDate, LimbADateWithoutHolidays)` is `limb_a_date` with [] (A0).
3. Art 13 route: Deadline is obtaining_date and Basis is art13_1. Rule S3: (E) reads no date.
4. Art 14 route, holidays attested. Deadline is the earliest of LimbADate and the X of earliest_event_limb. Basis is the limb of the earliest, with ties going in order (a), (b), (c).
5. Art 14 route, holidays absent (P):
   - (D): X when X is on or before A0, else REF with [].
   - (E): art14_3_a when there is no X; the limb of X when X is strictly before A0; else REF with [].
6. Rule S1: (D) with the route absent, obtaining_date present and X known and equal to obtaining_date gives obtaining_date. Otherwise MISSING_KEYS lists the route key and obtaining_date when absent, and never (12) or (14).
7. Rule S2: (E) with the route absent gives `indeterminate([personal_data_collected_from_data_subject])`.
8. Rule S4: (E) on Art 14 with (12) and (14) both false gives art14_3_a, reading neither obtaining_date nor public_holidays.
9. Missing keys are list-all, in contract order. Input problems come first.

### Exports downstream

- `deadline_resolution(Profile, Resolution)`, for the verdict slice, which is the next layer in kernel -> citations -> parameters -> information_deadline_basis -> information_timing_verdict. Resolution is one of:
  - `fixed(DateTerm, Basis)`;
  - `missing(MissingKeys)`;
  - `holidays_unattested(LimbADateWithoutHolidays, EarliestEventLimb)`;
  - `problems(Problems)`.

### Verdict atoms

art13_1, art14_3_a, art14_3_b, art14_3_c, and the status compounds of section 2.

### Defeasible pattern

- The limb (a) default holds unless defeated.
- Defeaters are an earlier X and absent holidays.
- Defeat is tested through `not_defeated/3` with defeater clauses guarded by `once/1` around the deterministic date computation.
- No `!`, `->` or `*->` is used.
- Ground outputs are folded into the clause heads, one clause per disjoint route (C17).

### Tests

- every row of the I5 table of NOTES.md;
- the holiday 2027-02-01 case;
- ties (b)=(c) and (a)=(b);
- X before A0, X equal to A0, and X after A0 with holidays absent;
- S1-S4;
- the missing-key order;
- one-solution counts with findall plus length.

## 9. Slice information_timing_verdict.clausal

This slice owns relation (F), and the facade decide_/status/checklist/what_if of the verdict.

### Value facts owned

- `inclusive_last_day(true)`: provision on DEADLINE is timely.
- `reasonable_period_judgement_key(provided_within_reasonable_period)`.

There are no numeric thresholds.

### Rules

The slice reads deadline_resolution/2 and provision_date (11).

1. **Missing keys.** (11) is named with the keys of (D). With the route absent, the list is the route key plus (10) and (11) when absent.
2. **Late.** `fixed(Deadline, Basis)` with ProvisionDate strictly after Deadline gives `late` with [cite(limb of Basis)].
3. **Art 13 timely.** `fixed(Deadline, art13_1)` with provision on or before Deadline gives `timely` with [cite(eu_reg_2016_679_art_13_1)].
4. **Art 14 on time.** `fixed(Deadline, Basis)` with provision on or before Deadline. Then (16) decides:
   - true gives timely with [cite(limb of Basis)];
   - false gives late with [cite(eu_reg_2016_679_art_14_3_a)];
   - unsure gives open_textured with Pairs [provided_within_reasonable_period-unsure];
   - absent gives `indeterminate([provided_within_reasonable_period])`.
5. **Holidays absent (P).**
   - X strictly before A0: answer as rule 4, with Deadline X.
   - Else X present and P after X: REF with [].
   - Else (16) decides:
     - false gives late, citing _a;
     - absent gives indeterminate([provided_within_reasonable_period]);
     - true gives timely, citing _a, when there is no X and P is on or before A0, else REF with [provided_within_reasonable_period-true];
     - unsure gives open_textured when there is no X and P is on or before A0, else REF with [provided_within_reasonable_period-unsure].
6. **Rule S5, a defeater guarded by once/1.** On Art 14 with (16) false, the answer is late with [cite(eu_reg_2016_679_art_14_3_a)] when:
   - (i) there is no X; or
   - (ii) X is known and provision_date is present and on or before X; or
   - (iii) X is known, obtaining_date and public_holidays are present, and X is on or after limb_a_date.

   It decides before any absent key.
7. **Q24.** An absent key among (12)-(15) that (D) reads is still named, even when the provision is after A0.
8. CITES is [] for every non-final verdict.

### Verdict atoms

timely, late, and the status compounds of section 2.

### Shared needs

None beyond the kernel and the upstream `deadline_resolution/2`.

### Tests

- timely and late on each route;
- the inclusive last day;
- (16) true, false, unsure and absent;
- each branch of (P);
- S5 (i)-(iii);
- Q24;
- input_problems first, including duplicate_key and wrong_type, and other_purpose_information in items_provided;
- keys that are not read do not change the answer;
- exactly one solution.

## 10. queries.clausal

- `gdpr_information_duties_timing_compliance_check/3`
- `gdpr_information_duties_timing_obligation/2`
- `gdpr_information_duties_timing_what_if/4`

Each is built only from the slice exports, and each gives one solution.

## 11. fixtures.clausal and tests

`fixture(FixtureName, Profile)` rows, with their expected answers:

**art13_on_time.** Route true, obtaining 2026-03-10, provision 2026-03-10.

- (D) date(2026, 3, 10)
- (E) art13_1
- (F) timely, [cite(eu_reg_2016_679_art_13_1)]

**art14_weekend_roll.** Route false, obtaining 2026-01-15, (12) false, (14) false, holidays attested [], (16) true, provision 2026-02-16.

- (D) date(2026, 2, 16)
- (E) art14_3_a
- (F) timely

**art14_late_after_month.** As art14_weekend_roll, with provision 2026-02-17.

- (F) late, [cite(eu_reg_2016_679_art_14_3_a)]

**art14_communication_binds.** Obtaining 2026-01-15, (12) true, communication 2026-02-01, holidays absent.

- (D) date(2026, 2, 1)
- (E) art14_3_b

**art14_x_equals_a0_holidays_absent.** Communication 2026-02-16.

- (D) date(2026, 2, 16)
- (E) REF with []

**art14_x_after_a0_holidays_absent.** Communication 2026-03-01.

- (D) REF with []

**art14_no_x_holidays_absent.** (16) true, provision 2026-02-10.

- (D) REF
- (E) art14_3_a
- (F) timely, citing _a

**art14_holiday_attested.** Obtaining 2026-12-31, holidays [date(2027, 2, 1)].

- (D) date(2027, 2, 2)

**leap_year.** Obtaining 2028-01-31.

- (D) date(2028, 2, 29)

**route_absent.**

- (E) indeterminate([personal_data_collected_from_data_subject])

**unsure_reasonable.**

- (F) open_textured review

Tests use the seven test modes of the scaffold. Property runs use validate_props:

- `prop_totality/3` and `prop_determinism/3`;
- `prop_citation_complete/3`;
- `prop_boundary_coverage/2` over the I5 table;
- `prop_missing_key_coverage/3` over keys 1 and 10-16.

## 12. Planned reuse (manifest `uses:`)

**formalize_lib:**

- profile_get/3, profile_has/2, profile_lacks/2, profile_set/3, profile_keys/2
- missing_keys/3, all_present/2
- check_tri/4
- eval_requirements/4, assess/6
- not_defeated/3, memberd/2, not_member/2
- attribute/2, item/3

assess/6 is used with labels(timely, indeterminate, late) for the #2 checklist summary only. The authoritative verdict is (F).

**kit/deadline_lib:** month_last_day/3. deadline_months_after/3 is deliberately NOT used, because of its AU semantics.

**library(datetime):** weekday/2, date_add/3, timedelta/3, with native date/4 at the boundary.

**validate_props (tests):** run_props/1, prop_totality/3, prop_determinism/3, prop_citation_complete/3, prop_boundary_coverage/2, prop_missing_key_coverage/3.

**Not used:**

- kit/compliance_lib: a single obligation, so there is no modality conflict.
- kit/query_combinators: the what_if works on attribute lists, and profile_set/3 serves it.
- rolling_window: not relevant.

**Local candidate for the kit:** the EU 1182/71 month period with the weekend and holiday roll (see NOTES.md, Reuse notes).

## 13. Totality, determinism and counting claims

- Every relation is total over every term: an ill-formed profile gives input_problems.
- Every relation is deterministic, with exactly one solution and never a duplicate.
- Routes are disjoint clauses.
- The roll recursion has a single path.
- Every defeater is wrapped in once/1, with no cut.
- Duplicate keys are rejected before any profile_get/3.
