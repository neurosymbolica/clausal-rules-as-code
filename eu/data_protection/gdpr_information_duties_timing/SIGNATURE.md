# SIGNATURE — eu/data_protection/gdpr_information_duties_timing

The package has a deontic shape. Its layers are:

`kernel -> citations -> parameters -> information_deadline_basis -> information_timing_verdict -> queries -> fixtures -> package facade`

All file names, module names and the package layout are kept. Predicate prefix: `gdpr_information_duties_timing_`.

## 1. Public query surface

The scored relations take PROFILE only; there are no date arguments (Q13). Each relation gives exactly ONE solution per query (COUNTING).

**(D) Deadline**
- `information_deadline(PROFILE, DEADLINE)` answers one of:
  - `date(Year, Month, Day)` with bare integers;
  - `indeterminate(MISSING_KEYS)`;
  - `input_problems(PROBLEMS)`.

**(E) Basis**
- `information_deadline_basis(PROFILE, BASIS)` answers one of:
  - `art13_1`, `art14_3_a`, `art14_3_b` or `art14_3_c`;
  - `indeterminate(MISSING_KEYS)`;
  - `input_problems(PROBLEMS)`.

**(F) Timing verdict**
- `information_timing_verdict(PROFILE, VERDICT, CITES)` answers one of:
  - `timely` or `late`;
  - `indeterminate(MISSING_KEYS)`;
  - `needs_legal_review(open_textured(provided_within_reasonable_period, cite(eu_reg_2016_679_art_14_3_a)), CONTEXT)`;
  - `input_problems(PROBLEMS)`.

**(K) Input check**
- `gdpr_information_duties_timing_input_problems(PROFILE, PROBLEMS)` answers PROBLEMS = `[]` or a list of problem terms. It is exported unchanged.

Precedence: `input_problems` first; then MET / UNMET; then `indeterminate`; then `open_textured`. No leaning is declared.

## 2. Verdict STATUS atoms (replacing the scaffold placeholders)

- Basis status: `art13_1`, `art14_3_a`, `art14_3_b`, `art14_3_c`.
- Timing status: `timely`, `late`.
- Non-final (compounds only; the bare atom `indeterminate` is NEVER written):
  - `indeterminate(MissingKeys)`;
  - `needs_legal_review(Reason, Context)`;
  - `input_problems(Problems)`.
- Checklist item statuses come from formalize_lib: `met`, `unmet(Reason)`, `unknown(Keys)`. The extra item atom `inapplicable` marks a limb that does not apply.
- Root-exported atom: `unsure`. The atoms `true` and `false` are never pinned in verdict_vocabulary or root_exports.
- Result constructors are exported and never called as queries:
  - `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`;
  - `indeterminate/1`, `needs_legal_review/2`, `open_textured/2`, `inputs_relied_on/1`, `provenance/2`;
  - `attested/2`, `attestation/4`, `url/2`, `document/2`.

## 3. Profile keys

The profile holds `attribute(Key, Value)` entries. It is read only with `profile_get/3`, `profile_has/2` and `profile_lacks/2`. There are twenty-six keys, in root_exports order:

| # | Key | Type |
|---|---|---|
| 1 | personal_data_collected_from_data_subject | CRISP true / false |
| 2 | items_provided | LIST of item atoms |
| 3 | items_data_subject_already_has | LIST of item atoms |
| 4 | data_protection_officer_designated | CRISP |
| 5 | processing_based_on_legitimate_interests | CRISP |
| 6 | recipients_exist | CRISP |
| 7 | transfer_intended | CRISP |
| 8 | processing_based_on_consent | CRISP |
| 9 | automated_decision_making_under_article_22 | JUDGEMENT true / false / unsure |
| 10 | obtaining_date | DATE date(Year, Month, Day) |
| 11 | provision_date | DATE |
| 12 | data_used_for_communication_with_data_subject | CRISP |
| 13 | first_communication_date | DATE |
| 14 | disclosure_to_another_recipient_envisaged | CRISP |
| 15 | first_disclosure_date | DATE |
| 16 | provided_within_reasonable_period | JUDGEMENT |
| 17 | provision_impossible_or_disproportionate_effort | JUDGEMENT |
| 18 | protective_measures_taken | CRISP |
| 19 | obtaining_or_disclosure_laid_down_by_law | OUTSIDE FACT attested(true or false, attestation(By, At, Reason, Evidence)) |
| 20 | professional_secrecy_obligation_by_law | OUTSIDE FACT, same shape |
| 21 | further_processing_for_another_purpose_intended | CRISP |
| 22 | further_processing_start_date | DATE |
| 23 | further_processing_information_date | DATE |
| 24 | further_processing_items_provided | LIST of item atoms |
| 25 | paragraph_2_information_relevant_to_further_processing | JUDGEMENT |
| 26 | public_holidays | OUTSIDE FACT attested(ListOfDates, attestation(By, At, Reason, Evidence)) |

Which keys are read:
- Read here: 1, 10, 11, 12, 13, 14, 15, 16, 26.
- Accepted, type-checked and ignored: every other key.
- Money: none. Numeric values are integers inside date terms only. No unit-suffixed numeric keys are needed.
- Item atoms: the item row of the manifest verdict_vocabulary (type `item` of input_contract), copied verbatim. They are not invented here. `other_purpose_information` is valid in `further_processing_items_provided` only; inside `items_provided` it is `wrong_type(items_provided)`.

## 4. Citation-key atoms (canonical lexicon scheme)

**In CITES**
- `eu_reg_2016_679_art_13_1`: the Art 13(1) chapeau, at the time of obtaining.
- `eu_reg_2016_679_art_14_3_a`: reasonable period, at the latest one month.
- `eu_reg_2016_679_art_14_3_b`: first communication.
- `eu_reg_2016_679_art_14_3_c`: first disclosure.

**In checklist provenance only, never in (F) CITES**
- `eu_reg_1971_1182_art_3`: the period computation for limb (a).

**Reasoning only, never cited, not added as CITES entries**
- Art 4(1), (4), (7) and (9). They are documented in the working notes (not published).

## 5. Public predicates

- `information_deadline(Profile, Deadline)`: the information deadline (D), query type #15. Cites Art 13(1) or Art 14(3)(a)-(c), with Reg 1182/71 Art 3 for limb (a).
- `information_deadline_basis(Profile, Basis)`: the limb fixing the deadline (E), with ties going to (a), (b), (c). Cites Art 13(1) or Art 14(3).
- `information_timing_verdict(Profile, Verdict, Citations)`: timely, late or non-final (F), query types #2 and #15. The consequence of missing the deadline is `late`. Cites Art 13(1) or Art 14(3)(a)-(c).
- `gdpr_information_duties_timing_input_problems(Profile, Problems)`: the input check (K) over all 26 keys. It is input contract G1.
- `decide_information_deadline_basis(Profile, information_deadline_basis_result(Status, Citations))`: the basis status plus `[cite(K)]` of the limb, or `[]` when non-final. Cites Art 13(1) or Art 14(3).
- `information_deadline_basis_status(Profile, Status)`: the Status of the above. Cites Art 13(1) or Art 14(3).
- `information_deadline_basis_checklist(Profile, Checklist)`: the rows below, built by `eval_requirements/4` over the slice's `requirement/4`. Cites each row's article.
  - `item(route, Status, cite(...))`
  - `item(limb_a_one_month, Status, cite(eu_reg_1971_1182_art_3))`
  - `item(limb_b_first_communication, Status, cite(eu_reg_2016_679_art_14_3_b))`
  - `item(limb_c_first_disclosure, Status, cite(eu_reg_2016_679_art_14_3_c))`
- `decide_information_timing_verdict(Profile, information_timing_verdict_result(Status, Citations))`: `timely` / `late` with CITES as in (F), or non-final with `[]`. Query type #2 eligibility: timely is the positive outcome. Cites Art 13(1) or Art 14(3).
- `information_timing_verdict_status(Profile, Status)`: the Status of the above. Cites Art 13(1) or Art 14(3).
- `information_timing_verdict_checklist(Profile, Checklist)`: the rows `item(deadline_determined, ...)`, `item(provided_on_or_before_deadline, ...)` and `item(provided_within_reasonable_period, ...)`, where the last is `inapplicable` on the Art 13 route. Each row carries `cite(...)`.
- `gdpr_information_duties_timing_what_if(Profile, Key, Value, Result)`: query type #13 compliance check (is the proposed provision allowed?). It runs `profile_set(Profile, attribute(Key, Value), Changed)` and then `decide_information_timing_verdict(Changed, Result)`. A typical call is Key = `provision_date` with a proposed date. Cites as in (F).
- `gdpr_information_duties_timing_obligation(Profile, Obligation)`: query type #14 obligation surfacing. It answers `obligation(provide_information, by(Deadline), Basis, [cite(K)])`, or a non-final term (`indeterminate(...)` / `input_problems(...)`). Cites Art 13(1) or Art 14(3).
- Fixtures:
  - `gdpr_information_duties_timing_fixture(Name, Profile)`: the named golden profiles of the working notes (not published), plus the route, tie, judgement, absence and input-problem cases.
  - `gdpr_information_duties_timing_fixture_expected(Name, Relation, Answer)`.

## 6. kernel.clausal — the shared floor (only what both slices share)

**Input check**
- `gdpr_information_duties_timing_input_problems/2`, as specified in the working notes (not published).
- `contract_key/2`: Key and its Type, as 26 facts in root order.
- `key_has_type/2`.

**Calendar primitives**, all on `date(Year, Month, Day)` integer terms:
- `real_calendar_day/1`, using `month_last_day/3`.
- `date_order/3` returns `before`, `same` or `after`, comparing Year, then Month, then Day as integers.
- `date_on_or_before/2`.
- `weekend_day/1`: build `date(Y, M, D, Object)` and call `weekday/2`. The numbering is pinned by tests.
- `attested_public_holiday/2`: Profile and Date, tested with `once(memberd/2)` on the attested list; absent gives false.
- `working_day/2`.
- `following_working_day/3`.

**The shared deadline determination**
- `gdpr_information_duties_timing_deadline_outcome(Profile, Outcome)`.
- Outcome is `deadline(Date, Basis)`, `indeterminate(MissingKeys)` or `input_problems(Problems)`.
- It is shared because both slices read DEADLINE. It calls the limb-(a) date computation owned by the basis slice through the injected closure `limb_a_date/3`, so the period value stays in that slice. Exactly one solution.

**Missing-key assembly**
- `missing_in_root_order/2`, which uses `missing_keys/3`.

## 7. Determination slice: information_deadline_basis.clausal

**Statutory VALUE facts owned here**
- `:- constant_value(article_14_3_a_period_months, 1).` This is Art 14(3)(a), 'within one month'.
- `limb_rank(art14_3_a, 1). limb_rank(art14_3_b, 2). limb_rank(art14_3_c, 3).` This is the tie order.
- `basis_citation(art13_1, eu_reg_2016_679_art_13_1).` and likewise for `_a`, `_b`, `_c`.

**Rules**
- R1 route: key (1) `true` gives Art 13, `false` gives Art 14, absent gives indeterminate per the working notes (not published).
- R2 Art 13: DEADLINE is `obtaining_date`, unshifted.
- R3 limb (a), `limb_a_date(Profile, ObtainingDate, Date)`:
  - add `constant(article_14_3_a_period_months)` months to Month, rolling December over to January;
  - cap the day with `month_last_day/3` and `int_min/3`;
  - shift forward over weekend days and attested holidays (Reg 1182/71 Art 3(1), 3(2)(c), 3(4)).
- R4 limb (b): it applies iff (12) is `true`, and its date is (13).
- R5 limb (c): it applies iff (14) is `true`, and its date is (15).
- R6 earliest: this is defeasible. Each candidate basis holds only if `not_defeated(Basis, Profile, limb_defeater)`. `limb_defeater/2` is true when an applicable limb has a strictly earlier date, or an equal date with a lower `limb_rank`. Each defeater body is wrapped in `once/1`, and there is no cut.
- R7 absence: absent keys give `indeterminate(MissingKeys)` per the working notes (not published).

**Verdict atoms**: `art13_1`, `art14_3_a`, `art14_3_b`, `art14_3_c`, plus the non-final compounds.

**Exports**: `information_deadline/2`, `information_deadline_basis/2`, `decide_information_deadline_basis/2`, `information_deadline_basis_status/2`, `information_deadline_basis_checklist/2`, `requirement/4`, `limb_a_date/3`.

**Tests**
- All eight golden dates of the working notes (not published).
- Tie cases: a = b gives `_a`; b = c gives `_b`.
- A flag `false` with its date absent still determines DEADLINE.
- Route absent gives `[personal_data_collected_from_data_subject, obtaining_date]`.
- Holiday-list duplicates still give one solution.
- Each negative test is paired with a positive test over the same case.
- `findall` / `length(_, 1)` tests check that every query has exactly one solution.

## 8. Determination slice: information_timing_verdict.clausal

**Statutory VALUE facts owned here**
- `reasonable_period_citation(eu_reg_2016_679_art_14_3_a).`
- `timing_judgement_key(provided_within_reasonable_period).` This is the only judgement key read.

**Rules**, all with ground verdicts folded into clause heads and one clause per disjoint route:
- V0: input problems give `input_problems(P)` with `[]`.
- V1: deadline outcome indeterminate. MISSING_KEYS is the deadline's keys plus `provision_date` if absent, in root order, with `[]`.
- V2: deadline known and (11) absent give `indeterminate([provision_date])` with `[]`.
- V3: `provision_date` after DEADLINE gives `late` with `[cite(K of Basis)]`.
- V4: Art 13 and on-or-before give `timely` with `[cite(eu_reg_2016_679_art_13_1)]`.
- V5: Art 14, on-or-before, (16) `true` give `timely` with `[cite(K of Basis)]`.
- V6: Art 14, on-or-before, (16) `false` give `late` with `[cite(eu_reg_2016_679_art_14_3_a)]`.
- V7: Art 14, on-or-before, (16) `unsure` give `needs_legal_review(open_textured(provided_within_reasonable_period, cite(eu_reg_2016_679_art_14_3_a)), [inputs_relied_on([provided_within_reasonable_period-unsure]), provenance(information_timing_verdict_reasonable_period, [cite(eu_reg_2016_679_art_14_3_a)])])` with `[]`.
- V8: Art 14, on-or-before, (16) absent give `indeterminate([provided_within_reasonable_period])` with `[]`.
- On-or-before is INCLUSIVE.
- Read for (16) uses `check_tri/4` from formalize_lib. It is the user's judgement and never derived.

**Verdict atoms**: `timely`, `late`, plus the non-final compounds.

**Imports**: `gdpr_information_duties_timing_deadline_outcome/2` and the date order from kernel only.

**Exports**: `information_timing_verdict/3`, `decide_information_timing_verdict/2`, `information_timing_verdict_status/2`, `information_timing_verdict_checklist/2`, `requirement/4`.

**Tests**
- Provision on the deadline day is timely, and the day after is late.
- Art 13 with provision before obtaining is timely (Q8).
- A date-late provision with (16) unsure is late, not a referral.
- Each of V5, V6, V7 and V8 is tested.
- An unread key changes nothing (for example, toggling `transfer_intended`).
- `input_problems` precedence.
- Exactly-one-solution counting.

## 9. Queries, fixtures and facade

- `queries.clausal`: `gdpr_information_duties_timing_what_if/4` and `gdpr_information_duties_timing_obligation/2`.
- `fixtures.clausal`: `gdpr_information_duties_timing_fixture/2` and `gdpr_information_duties_timing_fixture_expected/3`.
- Package facade: it re-exports every predicate of section 5 and the result constructors.
- Totality: every well-typed or ill-typed PROFILE gets exactly one answer per relation.
- Determinism: one solution.

## 10. Planned reuse (manifest `uses:`)

**formalize_lib**
- `profile_get/3`, `profile_has/2`, `profile_lacks/2`, `profile_set/3`, `profile_keys/2`;
- `missing_keys/3`, `check_tri/4`, `not_defeated/3`, `memberd/2`, `int_min/3`;
- `eval_requirements/4`, `item/3`, `unmet/1`, `unknown/1`, `attribute/2`.

**kit/deadline_lib**
- `month_last_day/3`, used for the cap and for real-calendar-day validation.
- `deadline_months_after/3` is deliberately NOT used: it computes the AU s 36 rule, not Reg 1182/71 Art 3.

**library(datetime)**
- `weekday/2` on date/4 objects for the Saturday / Sunday test.
- `date_add/3` and `timedelta/3` for next day, with inputs bound.

**validate_props**
- `run_props/1`, `prop_totality/3`, `prop_determinism/3`, `prop_citation_complete/3`, `prop_boundary_coverage/2`, `prop_missing_key_coverage/3`.

**kit/compliance_lib and kit/query_combinators**: not used. Their key-override and modality machinery does not fit an attribute-list profile with a single obligation. The compliance check is `profile_set/3` plus the verdict.
