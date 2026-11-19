# SIGNATURE — ch/swiss_fadp_s4_criminal_provisions

## Public query surface

The facade has these entry points:

- `decide_swiss_fadp_s4_criminal_provisions(PROFILE, swiss_fadp_s4_criminal_provisions_verdict(STATUS, CITATIONS))`
- `swiss_fadp_s4_criminal_provisions_status(PROFILE, STATUS)`

Both report the STATUS determination of the order: the RESULT and CITATIONS of `swiss_offence_punishable/3`, unchanged.

The seven contract queries (A) to (G) are exported unchanged from the slice and re-exported by the facade.

PROFILE is an attribute list `[attribute(KEY, VALUE), ...]`:

- It is read ONLY with `profile_get/3`, by presence first and then by value.
- It holds up to ten keys (below).

Guarantees:

- **Totality:** every query yields exactly ONE solution for every input term, malformed ones included.
- **Determinism:** no answer is yielded twice. The disjoint routes are folded into clause heads (C17), with no `!`, `->` or `*->`.
- **Figures:** all statutory figures are declared once with `constant_value/2` in the slice. Nothing is imported from another domain.

## Verdict STATUS atoms

These replace the placeholder `{ required, permitted, not_applicable }`.

Final atoms of the facade STATUS, which is `swiss_offence_punishable/3`:

- `punishable_by_fine_under_article_60_1_a`
- `punishable_by_fine_under_article_60_1_b_1`
- `punishable_by_fine_under_article_60_1_b_2`
- `punishable_by_fine_under_article_60_2`
- `punishable_by_fine_under_article_61_a`
- `punishable_by_fine_under_article_61_b`
- `punishable_by_fine_under_article_61_c`
- `punishable_by_fine_under_article_62_1`
- `punishable_by_fine_under_article_62_2`
- `punishable_by_fine_under_article_63`
- `not_punishable_under_examined_offence`

Other final atoms of the order:

- **Complaint:** `prosecuted_ex_officio`, `complaint_offence_complaint_filed`, `complaint_offence_no_complaint_filed`.
- **Limitation:** `five_year_limitation_period_expired`, `five_year_limitation_period_not_expired`.
- **Business:** `business_may_be_ordered_to_pay_fine`, `business_substitution_not_available`.
- **EU:** `fine_up_to_10_million_euro_or_2_percent_of_turnover`, `fine_up_to_20_million_euro_or_4_percent_of_turnover`, `no_administrative_fine_under_article_83_4_to_83_6`.
- **Comparison:** `same`, `differs`.

Status compounds for answers that are not final. They are exported result constructors with exact functors and arities.

- `indeterminate([KEY])`: exactly one bare key atom. The bare atom `indeterminate` is never written.
- `needs_legal_review(open_textured(KEY, cite(CITE)), [inputs_relied_on(PAIRS)])`, where PAIRS is a flat list of `KEY-VALUE` terms.
- `input_problems(PROBLEMS)`, where PROBLEMS is a flat list of `unknown_key(KEY)`, `wrong_type(KEY)` and `duplicate_key(KEY)` terms.
- `provenance/2` is exported and reserved. Its trailing CONTEXT element is optional and unscored; this order does not emit it.
- A not-final answer always has CITATIONS `[]`.

Check vocabulary (from formalize_lib, not redefined): `met`, `unmet(Reason)`, `unknown(Keys)`, `applicable`, `inapplicable`.

## Profile keys

The ten keys, in root_exports and input_contract order:

| # | key | type | values |
|---|-----|------|--------|
| 1 | `conduct_meets_offence_description` | judgement | `true`, `false`, `unsure` |
| 2 | `acted_wilfully` | judgement | `true`, `false`, `unsure` |
| 3 | `examined_offence` | enumeration | `article_60_1_a`, `article_60_1_b_1`, `article_60_1_b_2`, `article_60_2`, `article_61_a`, `article_61_b`, `article_61_c`, `article_62_1`, `article_62_2`, `article_63` |
| 4 | `offender_is_private_person` | judgement | `true`, `false`, `unsure` |
| 5 | `criminal_complaint_filed` | crisp | `true`, `false` |
| 6 | `offence_committed_in_business` | judgement | `true`, `false`, `unsure` |
| 7 | `fine_in_consideration_in_francs` | figure | non-negative integer (whole francs) |
| 8 | `identifying_punishable_persons_requires_disproportionate_investigation` | judgement | `true`, `false`, `unsure` |
| 9 | `eu_infringement_established` | judgement | `true`, `false`, `unsure` |
| 10 | `eu_infringed_obligation_listed_in` | enumeration | `listed_in_article_83_4`, `listed_in_article_83_5_or_83_6`, `not_listed_in_article_83_4_to_83_6` |

The dates are NOT profile keys. They are arguments 2 and 3 of `swiss_prosecution_limitation/5`: `date(Year, Month, Day)` terms of three integers naming a real Gregorian day. A bad date gives `wrong_type(offence_date)` or `wrong_type(assessment_date)`, added after the profile problems.

The offence groups used below:

- **PRIVATE-PERSON OFFENCE:** `article_60_1_a`, `article_60_1_b_1`, `article_60_1_b_2`, `article_60_2`, `article_61_a`, `article_61_b`, `article_61_c`, `article_63`.
- **ARTICLE 62 OFFENCE:** `article_62_1`, `article_62_2`.
- **EX OFFICIO OFFENCE:** `article_60_2`, `article_63`.
- **COMPLAINT OFFENCE:** the other eight.

## Citation-key atoms

These use the canonical `_lexicon/citations.yaml` scheme. No shortened atoms are invented.

- **Swiss offences:**
  - `ch_fadp_art_60_1`, `ch_fadp_art_60_1_a`, `ch_fadp_art_60_1_b`, `ch_fadp_art_60_1_b_1`, `ch_fadp_art_60_1_b_2`, `ch_fadp_art_60_2`
  - `ch_fadp_art_61`, `ch_fadp_art_61_a`, `ch_fadp_art_61_b`, `ch_fadp_art_61_c`
  - `ch_fadp_art_62_1`, `ch_fadp_art_62_2`, `ch_fadp_art_62_3`, `ch_fadp_art_63`
- **Swiss procedure:** `ch_fadp_art_64_2`, `ch_fadp_art_66`.
- **Swiss grouped key:** `ch_fadp_art_60_to_63`. It is used only as the CITE of a comparison referral on a Swiss judgement.
- **EU:**
  - `eu_reg_2016_679_art_83_4`, `eu_reg_2016_679_art_83_4_a`, `eu_reg_2016_679_art_83_4_b`, `eu_reg_2016_679_art_83_4_c`
  - `eu_reg_2016_679_art_83_5`, `eu_reg_2016_679_art_83_5_a`, `eu_reg_2016_679_art_83_5_b`, `eu_reg_2016_679_art_83_5_c`, `eu_reg_2016_679_art_83_5_d`, `eu_reg_2016_679_art_83_5_e`
  - `eu_reg_2016_679_art_83_6`
- **Deferred** (in citations.clausal for provenance, never emitted): `ch_fadp_art_64_1`, `eu_reg_2016_679_art_83_2_b`.

## Public predicates

**Contract queries (A) to (G)**

- `swiss_offence_punishable(Profile, Result, Citations)`: status determination for the examined offence. It follows LIMBS steps (0) to (4); final citations are per offence, as in THE LIMBS. Cites DSG Arts 60 to 63 (+ 62(3)).
- `swiss_prosecution_complaint_condition(Profile, Result, Citations)`: ex officio, or complaint filed / not filed. It follows LIMBS steps (0) and (5) to (9). Cites DSG Arts 60(1), 60(2), 61, 62(1), 62(2) and 63.
- `swiss_prosecution_limitation(Profile, OffenceDate, AssessmentDate, Result, Citations)`: the deadline query. Expiry means AssessmentDate is strictly after the fifth anniversary of OffenceDate, with the 29 February to 28 February clamp. It follows LIMBS steps (10) to (12). Cites `ch_fadp_art_66`.
- `swiss_business_ordered_to_pay_fine(Profile, Result, Citations)`: the threshold query for Art 64(2). The 50000-franc boundary is inclusive. It follows LIMBS steps (0) and (13) to (16). Cites `ch_fadp_art_64_2`.
- `eu_administrative_fine_ceiling(Profile, Result, Citations)`: the EU ceiling class. It follows LIMBS steps (0) and (17) to (21). Cites GDPR Art 83(4), (5) and (6) with their points.
- `compare_swiss_eu_fine_provided(Profile, SwissResult, EuResult, Difference, ChangedBy)`: the comparison of FINE / NO FINE classes over all completions. It follows LIMBS steps (22) to (25). ChangedBy is the fixed nine-cite list when Difference is `differs`, and `[]` otherwise. Cites DSG Arts 60 to 63 and GDPR Art 83(4) to (6).
- `swiss_fadp_s4_criminal_provisions_input_problems(Profile, Problems)`: THE INPUT CHECK. It returns the BARE problem list in contract order. It never fails or raises and yields one solution. It cites no provision.

**Facade and fixture predicates** (scaffold names kept)

- `decide_swiss_fadp_s4_criminal_provisions(Profile, swiss_fadp_s4_criminal_provisions_verdict(Status, Citations))`: the verdict. It wraps `swiss_offence_punishable/3`. Cites DSG Arts 60 to 63.
- `swiss_fadp_s4_criminal_provisions_status(Profile, Status)`: the status alone, the same Status as decide. Cites DSG Arts 60 to 63.
- `swiss_fadp_s4_criminal_provisions_checklist(Profile, Checklist)`: the justification checklist, built via formalize_lib `assess/6` and `eval_requirements` with injected `requirement/4`. It has one `item(RequirementId, Status, cite(KEY))` per element: `conduct_meets_offence_description`, `acted_wilfully` and `offender_is_private_person` (`inapplicable` for the Art 62 offences). The cite is the per-offence key of LIMBS step (4), or `ch_fadp_art_60_to_63` when examined_offence is absent. Input problems give `[]`.
- `swiss_fadp_s4_criminal_provisions_what_if(Profile, Key, Value, Status)`: counterfactual status. It replaces Key with Value via formalize_lib `profile_set/3`, then reruns the status. Cites as the status does.
- `swiss_fadp_s4_criminal_provisions_threshold(Name, Value, Citation)`: exposes the statutory figures as facts:
  - `business_substitution_maximum_fine_in_francs` 50000 `cite(ch_fadp_art_64_2)`, inclusive;
  - `swiss_maximum_fine_in_francs` 250000 `cite(ch_fadp_art_60_1)` (informational);
  - `limitation_period_in_years` 5 `cite(ch_fadp_art_66)`.
- `swiss_prosecution_limitation_last_day(OffenceDate, LastDay)`: the deadline helper. LastDay is the fifth anniversary, the last day on which prosecution is not time-barred. Cites `ch_fadp_art_66`.
- `swiss_fadp_s4_criminal_provisions_fixture(Name, Profile)`: named profiles for tests and evaluation. The fixtures module cites no provision.

## Planned reuse (manifest `uses:`)

- **formalize_lib:**
  - `profile_get/3`, `profile_has/2`, `profile_lacks/2`: all profile reads, presence first.
  - `profile_set/3`: what_if.
  - `check_tri/4`: tri-state checklist items.
  - `assess/6` and `eval_requirements/4`: the facade checklist.
  - `int_max/3` where useful.
  - Vocabulary `met`, `unmet/1`, `unknown/1`, `applicable`, `inapplicable`.
  - Nothing is re-defined (C14, C15 and R1 lints).
- **kit/deadline_lib:** `month_last_day/3`, for day validity and the leap test of the 29 February clamp. `deadline_months_after/3` is deliberately NOT used (different semantics; NOTES I2).
- **kit/query_combinators:** `flip_scan/4`, in the threshold test, to verify that the Art 64(2) outcome flips between 50000 and 50001, with probe closure `business_answer_at(Profile)`.
- **validate_props** (tests only): `prop_totality/3`, `prop_determinism/3`, `prop_citation_complete/3`, `prop_boundary_coverage/2`, `prop_missing_key_coverage/3`.
- **Not used, and why:**
  - kit/compliance_lib: the order has no norm-modality lattice. The one permission ('kann', Art 64(2)) is a single head-folded atom.
  - library(datetime): `date/3` is not registered (NOTES I15).
  - currency_vocab: amounts are carried in unit-suffixed integer names (`_in_francs`, `_in_eur_cents`), not as currency terms.
  - kit/rolling_window: it works on `[Y,M,D]` lists.

## kernel.clausal (the shared floor)

It holds only what the slice, queries and facade all need:

- `swiss_fadp_s4_criminal_provisions_contract_key(Position, Key, Type)`: the ten keys in input_contract order. Type is one of:
  - `judgement`
  - `crisp`
  - `enumeration(Atoms)`
  - `figure`
- `swiss_fadp_s4_criminal_provisions_input_problems/2`: THE INPUT CHECK. Contract (G) is defined here and re-exported by the slice and the facade.
  - **Structure first:** `wrong_type(profile)` alone for an unbound term, a partial list, a list with an unbound or non-attribute element, or a non-list.
  - **Then per contract key:** in contract order, `duplicate_key(KEY)` if the key repeats (its values are not read), otherwise `wrong_type(KEY)` if its value is out of type (an unbound value included).
  - **Then unknown keys:** `unknown_key(KEY)` once per non-contract key (non-atom keys included, as given), in first-occurrence order.
  - **Engine safety:** written with `var/1`, `atom/1`, `integer/1` and `\+` guards so that it never raises or fails, and with disjoint clauses so that it has exactly one solution.
- `swiss_fadp_s4_criminal_provisions_present_pairs(Profile, Keys, Pairs)`: the PAIRS rule. For each key of Keys present in Profile, in the given order, it emits `KEY-VALUE`; absent keys are skipped.

## Slice: swiss_fadp_s4_criminal_provisions.clausal

**VALUE facts owned** (all declared here with `:- constant_value(Name, Value).`, never inlined in a rule body):

- `swiss_maximum_fine_in_francs` = 250000 (DSG Arts 60(1), 60(2), 61, 62(1), 63; Art 62(2) by 'Gleich').
- `business_substitution_maximum_fine_in_francs` = 50000 (DSG Art 64(2), inclusive).
- `limitation_period_in_years` = 5 (DSG Art 66).
- `eu_lower_ceiling_in_eur_cents` = 1000000000 and `eu_lower_ceiling_turnover_basis_points` = 200 (GDPR Art 83(4)).
- `eu_upper_ceiling_in_eur_cents` = 2000000000 and `eu_upper_ceiling_turnover_basis_points` = 400 (GDPR Art 83(5), (6)).
- The EU figures are informational: no amount is computed.

**Table facts owned:**

- `offence(Atom, PrivatePerson, Prosecution)`: Prosecution is `complaint` or `ex_officio`.
- `punishable_result(OffenceAtom, ResultAtom, Citations)`: the ten rows of LIMBS step (2).
- `referral_citation(Key, OffenceAtom, CiteKey)`: the table of LIMBS step (4).
- Fixed lists for `not_punishable_citations`, `complaint_citations`, `ex_officio_citations`, `eu_none_citations`, `eu_lower_citations`, `eu_upper_citations` and `comparison_changed_by_citations`.
- `result_class(Atom, fine | no_fine)`.

**Rules and requirements, in order** (the first step that answers decides; each step is a separate clause with its ground answer in the head):

- **(A) `swiss_offence_punishable/3`.**
  - Input problems.
  - NOT PUNISHABLE: any settled false of description or wilfulness, or a private-person offence with private-person false. This is one route per witness, made disjoint by ordering the guards (the description is false; or it is not false and wilfulness is false; or neither is false, the offence is private-person, and private-person is false). This prevents a duplicate solution.
  - PUNISHABLE: per offence.
  - `indeterminate` on the first NEEDED key.
  - `needs_legal_review` on the first unsure key, with the per-offence CITE and PAIRS from the step's inputs.
- **(B) `swiss_prosecution_complaint_condition/3`.**
  - Input problems.
  - `indeterminate([examined_offence])`.
  - `prosecuted_ex_officio`.
  - Complaint filed.
  - No complaint filed.
  - `indeterminate([criminal_complaint_filed])`.
- **(C) `swiss_prosecution_limitation/5`.**
  - Date validity: the term is `date(Y,M,D)` with integers, 1 =< M =< 12, and 1 =< D =< `month_last_day(Y,M)`.
  - Problems are profile problems first, then `wrong_type(offence_date)`, then `wrong_type(assessment_date)`.
  - FIFTH_ANNIVERSARY = `date(Y+5, M, D)`, or `date(Y+5, 2, 28)` when M=2, D=29 and `month_last_day(Y+5, 2, 28)`.
  - Compare lexicographically on integer components.
  - Strictly later gives expired; otherwise not expired. The local helper `date_strictly_later(Later, Earlier)` has three disjoint clauses (year greater; year equal and month greater; year and month equal and day greater).
- **(D) `swiss_business_ordered_to_pay_fine/3`.**
  - NOT AVAILABLE: a settled false, or a figure greater than 50000. The routes are made disjoint by guard ordering, in root_exports order.
  - AVAILABLE: all three conditions hold (figure =< the constant).
  - `indeterminate` on the first absent key.
  - `needs_legal_review` with `cite(ch_fadp_art_64_2)` and PAIRS over the three keys.
- **(E) `eu_administrative_fine_ceiling/3`.**
  - NONE: infringement false, or listing `not_listed`; the routes are disjoint as in (D).
  - LOWER for `listed_in_article_83_4`.
  - UPPER for `listed_in_article_83_5_or_83_6`.
  - `indeterminate` on the first absent key.
  - Review on `eu_infringement_established` with CITE by listing.
- **(F) `compare_swiss_eu_fine_provided/5`.**
  - SwissResult = (A) and EuResult = (E), copied unchanged.
  - `completions(Profile, Completion)` enumerates every completion of the six read keys: absent keys take all values, unsure judgements take true and false, and present settled values are kept. There are at most 2*2*10*2*2*3 = 480.
  - `same` if every completion gives equal classes; `differs` if every completion gives unequal classes.
  - Otherwise compute `can_still_change(Profile, Key)` and NEEDED (absent keys that can still change DIFFERENCE, in root_exports order).
  - Compute `behind(Profile, Key, Other)` per the behind test and name the first NEEDED key that is not behind another.
  - Otherwise refer the first unsure judgement that can still change DIFFERENCE. The CITE is `ch_fadp_art_60_to_63` for the Swiss judgements, and by listing for the EU judgement. PAIRS are over the six keys.
  - All enumeration uses `findall/3` and `forall/2` over finite tables, and the answer is head-folded, so there is exactly one solution.
  - ChangedBy is the fixed list only on `differs`.
- **Input problems** short-circuit every query, with each answer position set to `input_problems(Problems)`.

**Verdict atoms:** all final atoms listed above.

**Shared with kernel:** only `swiss_fadp_s4_criminal_provisions_input_problems/2` (with the contract key table) and `swiss_fadp_s4_criminal_provisions_present_pairs/3`. Everything else is local to this slice.

**Per-rule tests** (in the slice's test file):

- **Coverage:** one positive test and one paired negative test for each LIMBS step (0) to (25).
- **Art 64(2) boundary:** 50000 is available and 50001 is not.
- **Art 66 boundaries:**
  - offence 2020-03-15: assessed 2025-03-15 is not expired, and 2025-03-16 is expired;
  - offence 2020-02-29: assessed 2025-02-28 is not expired, and 2025-03-01 is expired;
  - offence 2024-02-29 (year 2029 is not leap): assessed 2029-02-28 is not expired, and 2029-03-01 is expired;
  - an ASSESSMENT_DATE before OFFENCE_DATE is not expired;
  - `date(2023, 2, 29)` gives `wrong_type(offence_date)`.
- **Comparison:**
  - `acted_wilfully` false with an EU ceiling gives `differs`;
  - an empty profile gives `indeterminate([conduct_meets_offence_description])`;
  - the behind cases;
  - a Swiss referral cites `ch_fadp_art_60_to_63`.
- **Input check:** duplicate, unknown, non-atom key, unbound value, partial list and non-attribute element.
- **Solution counts:** every query is counted with `findall` and `length(_, 1)`.

## queries.clausal, fixtures.clausal, package facade

- **queries.clausal:** re-exports (A) to (G), the threshold facts and `swiss_prosecution_limitation_last_day/2`.
- **fixtures.clausal:** `swiss_fadp_s4_criminal_provisions_fixture/2`, with these profiles:
  - `punishable_article_63`
  - `punishable_article_62_2_after_training`
  - `not_wilful_but_eu_ceiling` (gives `differs`)
  - `public_body_article_61_a`
  - `complaint_missing_article_61_c`
  - `ex_officio_article_60_2`
  - `business_boundary_50000`
  - `business_boundary_50001`
  - `eu_listed_83_5_unsure_infringement`
  - `empty_profile`
  - `malformed_duplicate_key`
- **Package facade:** `decide`, `status`, `checklist`, `what_if`, plus re-exports of all contract predicates and result constructors.
