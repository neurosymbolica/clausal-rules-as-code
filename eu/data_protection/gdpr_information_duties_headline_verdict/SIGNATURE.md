# SIGNATURE — eu/data_protection/gdpr_information_duties_headline_verdict

## Public query surface (summary)

The scorer calls three queries, each with the PROFILE attribute list only. There are no date or number arguments.

- `information_duty_verdict(Profile, Verdict, Cites)`: the headline (I).
- `information_duty_exemption(Profile, Exemption)`: the exemption (G).
- `information_outside_facts(Profile, OutsideFacts)`: the outside facts (J).

The input check `gdpr_information_duties_headline_verdict_input_problems(Profile, Problems)` (K) is exported unchanged.

Properties:

- **Totality:** every query has exactly ONE solution for every ground profile.
- **Determinism:** never two solutions, and never `[]` as an answer (COUNTING).
- **Precedence:**
  1. `input_problems(Problems)`;
  2. MET or UNMET;
  3. `indeterminate(MissingKeys)`;
  4. `needs_legal_review(open_textured(Input, cite(Key)), [inputs_relied_on(Pairs)])`.

No figure is imported from another domain. The one-month period and the 1182/71 calendar rule are declared in the verdict slice.

## Verdict STATUS atoms (replace the placeholders)

### Headline (I)

- Final: `eligible`, `ineligible`.
- Non-final constructors: `indeterminate/1`, `needs_legal_review/2`, `input_problems/1`.
- The bare atom `indeterminate` is NEVER written.

### Exemption (G)

- `impossible_or_disproportionate_effort`
- `law_lays_down_obtaining_or_disclosure`
- `professional_secrecy_obligation`
- `none`
- plus `indeterminate/1`, `needs_legal_review/2`, `input_problems/1`

### Internal stage atoms

- Route: `art13`, `art14`.
- Timing: `timely`, `late`.
- Further processing: `eligible`, `ineligible`, `not_applicable`.
- Missing items: `no_item_missing`.
- Deadline basis: `art13_1`, `art14_3_a`, `art14_3_b`, `art14_3_c`.
- Terms: `owed_item/2`, `missing_item/2`.

### Constructors and other atoms

- Result constructors: `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`, `indeterminate/1`, `needs_legal_review/2`, `open_textured/2`, `inputs_relied_on/1`, `provenance/2`, `outside_fact/2`, `attested/2`, `attestation/4`, `url/2`, `document/2`, `cite/1`.
- Also root-exported: `unsure`, `absent`, `profile`, `none`.
- `true` and `false` are NEVER pinned in `verdict_vocabulary` or `root_exports`.

## Profile keys

There are 26 keys, in root_exports order; this order governs MISSING_KEYS, PROBLEMS and PAIRS. Every key is root-exported. Every date is a ground `date(Year, Month, Day)` term of integers and a real Gregorian calendar day. There are no numeric amounts, so no unit suffixes are needed.

| # | key | type |
|---|-----|------|
| 1 | personal_data_collected_from_data_subject | CRISP |
| 2 | items_provided | LIST of item atoms, without other_purpose_information |
| 3 | items_data_subject_already_has | LIST of item atoms; other_purpose_information allowed |
| 4 | data_protection_officer_designated | CRISP |
| 5 | processing_based_on_legitimate_interests | CRISP |
| 6 | recipients_exist | CRISP |
| 7 | transfer_intended | CRISP |
| 8 | processing_based_on_consent | CRISP |
| 9 | automated_decision_making_under_article_22 | JUDGEMENT |
| 10 | obtaining_date | DATE |
| 11 | provision_date | DATE |
| 12 | data_used_for_communication_with_data_subject | CRISP |
| 13 | first_communication_date | DATE |
| 14 | disclosure_to_another_recipient_envisaged | CRISP |
| 15 | first_disclosure_date | DATE |
| 16 | provided_within_reasonable_period | JUDGEMENT |
| 17 | provision_impossible_or_disproportionate_effort | JUDGEMENT |
| 18 | protective_measures_taken | CRISP |
| 19 | obtaining_or_disclosure_laid_down_by_law | OUTSIDE FACT: attested(true or false, attestation(By, At, Reason, Evidence)) |
| 20 | professional_secrecy_obligation_by_law | OUTSIDE FACT, the same shape |
| 21 | further_processing_for_another_purpose_intended | CRISP |
| 22 | further_processing_start_date | DATE |
| 23 | further_processing_information_date | DATE |
| 24 | further_processing_items_provided | LIST of item atoms; other_purpose_information allowed |
| 25 | paragraph_2_information_relevant_to_further_processing | JUDGEMENT |
| 26 | public_holidays | OUTSIDE FACT: attested(DateList, attestation(...)) |

Value types:

- CRISP is the atom `true` or `false`.
- JUDGEMENT is `true`, `false` or `unsure`.
- Evidence is `url(Url, RetrievedAt)`, `document(UploadId, Sha256)` or `none`.

Absent never means false and never means `[]`. Keys are read only with `profile_get/3` (presence first, then value).

## Item vocabulary (checklist order; every atom root-exported)

| # | item | Art 13 cite | Art 14 cite | condition |
|---|------|-------------|-------------|-----------|
| 1 | controller_identity_and_contact_details | eu_reg_2016_679_art_13_1_a | eu_reg_2016_679_art_14_1_a | none |
| 2 | data_protection_officer_contact_details | eu_reg_2016_679_art_13_1_b | eu_reg_2016_679_art_14_1_b | data_protection_officer_designated |
| 3 | purposes_and_legal_basis | eu_reg_2016_679_art_13_1_c | eu_reg_2016_679_art_14_1_c | none |
| 4 | legitimate_interests | eu_reg_2016_679_art_13_1_d | eu_reg_2016_679_art_14_2_b | processing_based_on_legitimate_interests |
| 5 | recipients_or_categories_of_recipients | eu_reg_2016_679_art_13_1_e | eu_reg_2016_679_art_14_1_e | recipients_exist |
| 6 | third_country_transfer_information | eu_reg_2016_679_art_13_1_f | eu_reg_2016_679_art_14_1_f | transfer_intended |
| 7 | categories_of_personal_data | (not listed) | eu_reg_2016_679_art_14_1_d | none |
| 8 | storage_period_or_criteria | eu_reg_2016_679_art_13_2_a | eu_reg_2016_679_art_14_2_a | none |
| 9 | data_subject_rights | eu_reg_2016_679_art_13_2_b | eu_reg_2016_679_art_14_2_c | none |
| 10 | right_to_withdraw_consent | eu_reg_2016_679_art_13_2_c | eu_reg_2016_679_art_14_2_d | processing_based_on_consent |
| 11 | right_to_lodge_complaint | eu_reg_2016_679_art_13_2_d | eu_reg_2016_679_art_14_2_e | none |
| 12 | statutory_or_contractual_requirement | eu_reg_2016_679_art_13_2_e | (not listed) | none |
| 13 | source_of_personal_data | (not listed) | eu_reg_2016_679_art_14_2_f | none |
| 14 | automated_decision_making_information | eu_reg_2016_679_art_13_2_f | eu_reg_2016_679_art_14_2_g | judgement automated_decision_making_under_article_22 |
| 15 | other_purpose_information | eu_reg_2016_679_art_13_3 | eu_reg_2016_679_art_14_4 | further processing only |

Paragraph-2 items:

- Art 13 route: items 8, 9, 10, 11, 12 and 14.
- Art 14 route: items 4, 8, 9, 10, 11, 13 and 14.

Items listed in a profile for the other route are accepted and ignored.

## Citation-key atoms (canonical lexicon scheme; no shortened forms)

Atoms that can appear in CITES:

- `eu_reg_2016_679_art_13_1`, `eu_reg_2016_679_art_13_1_a` … `eu_reg_2016_679_art_13_1_f`
- `eu_reg_2016_679_art_13_2_a` … `eu_reg_2016_679_art_13_2_f`
- `eu_reg_2016_679_art_13_3`
- `eu_reg_2016_679_art_14_1`, `eu_reg_2016_679_art_14_1_a` … `eu_reg_2016_679_art_14_1_f`
- `eu_reg_2016_679_art_14_2_a` … `eu_reg_2016_679_art_14_2_g`
- `eu_reg_2016_679_art_14_3_a`, `eu_reg_2016_679_art_14_3_b`, `eu_reg_2016_679_art_14_3_c`
- `eu_reg_2016_679_art_14_4`
- `eu_reg_2016_679_art_14_5_b`, `eu_reg_2016_679_art_14_5_c`, `eu_reg_2016_679_art_14_5_d`

Atoms that are provenance only and never appear in CITES:

- `eu_reg_1971_1182_art_3`, for the calendar rule.
- The Art 4(1), (4), (7), (9) definitions and Art 13(4) / 14(5)(a). These are recorded in `citations.clausal` as `source_unit/3` facts (unit id, pinned version, gloss) and are never emitted as `cite/1`.

## Referrals block (THE PAIRS RULE lives in THE ANSWERS)

| judgement | route | citation | inputs every reaching query carries |
|-----------|-------|----------|-----------------------------------|
| automated_decision_making_under_article_22 | art13 | eu_reg_2016_679_art_13_2_f | [automated_decision_making_under_article_22] |
| automated_decision_making_under_article_22 | art14 | eu_reg_2016_679_art_14_2_g | [automated_decision_making_under_article_22, provided_within_reasonable_period] |
| provided_within_reasonable_period | art14 | eu_reg_2016_679_art_14_3_a | [provided_within_reasonable_period] |
| paragraph_2_information_relevant_to_further_processing | art13 | eu_reg_2016_679_art_13_3 | [paragraph_2_information_relevant_to_further_processing] |
| paragraph_2_information_relevant_to_further_processing | art14 | eu_reg_2016_679_art_14_4 | [provided_within_reasonable_period, paragraph_2_information_relevant_to_further_processing] |
| provision_impossible_or_disproportionate_effort | art14 | eu_reg_2016_679_art_14_5_b | [provision_impossible_or_disproportionate_effort] |

PAIRS add every other judgement key the ending stage read, in root order. At most one `provenance(Clause, Citations)` follows the pairs; it is not scored.

## Public predicates (one line each)

### Scored queries and the input check

- `information_duty_verdict(Profile, Verdict, Cites)`: the headline. Verdict is `eligible`, `ineligible`, `indeterminate(Keys)`, `needs_legal_review(Reason, Context)` or `input_problems(Problems)`. Cites follow (I): the route paragraph plus the (H) cite on a stage-one eligible; the 14(5) point on an exemption; missing-item cites, then the timing cite, then the (H) cite on ineligible; `[]` when non-final. Cites: GDPR Art 13(1), 14(1), 14(5)(b)–(d) and the item points.
- `information_duty_exemption(Profile, Exemption)`: the (G) evaluation, a strong-Kleene OR over Art 14(5)(b), (c), (d), whose first MET names the exemption. It is `none` on art13 and `indeterminate([personal_data_collected_from_data_subject])` when the route is absent. Cites: GDPR Art 14(5)(b), (c), (d).
- `information_outside_facts(Profile, OutsideFacts)`: (J). The list is `[outside_fact(obtaining_or_disclosure_laid_down_by_law, A1), outside_fact(professional_secrecy_obligation_by_law, A2), outside_fact(public_holidays, A3)]`, each A the attested term as given or `absent`; or `input_problems(P)`. Cites: GDPR Art 14(5)(c), (d); Reg 1182/71 Art 3(4).
- `gdpr_information_duties_headline_verdict_input_problems(Profile, Problems)`: (K), the INPUT CHECK. Problems are `[]`, or `[wrong_type(profile)]`, or, per contract key in order, `duplicate_key(K)` else `wrong_type(K)`, followed by `unknown_key(K)` in first-occurrence order. Cites the INPUT CONTRACT (G1).

### Facade, kept from the scaffold

- `decide_information_duty_exemption(Profile, information_duty_exemption_result(Exemption, Cites))`: Exemption as in (G). Cites are `[cite(eu_reg_2016_679_art_14_5_b|c|d)]` when MET, else `[]`. Cites: GDPR Art 14(5).
- `information_duty_exemption_status(Profile, Exemption)`: the status only, equal to `information_duty_exemption/2`. Cites: GDPR Art 14(5).
- `information_duty_exemption_checklist(Profile, Checklist)`: three `item(Limb, Status, cite(Key))` rows for (b), (c), (d), with Status `met`, `unmet(Reason)` or `unknown(Keys)`, in limb order. On art13 the checklist is `[]`; with the route absent it is `[item(route, unknown([personal_data_collected_from_data_subject]), cite(eu_reg_2016_679_art_14_1))]`. Cites: GDPR Art 14(5)(b)–(d).
- `decide_information_duty_verdict(Profile, information_duty_verdict_result(Verdict, Cites))`: the headline packaged as one term (#2 eligibility). Cites: GDPR Art 13, 14.
- `information_duty_verdict_status(Profile, Verdict)`: the headline Verdict only. Cites: GDPR Art 13(1), 14(1).
- `information_duty_verdict_checklist(Profile, Checklist)`: the cited checklist of the headline (#2 and #14 obligation surfacing). It has one `item(owed(Item), Status, cite(PointKey))` row per owed item in checklist order, then `item(timing, Status, cite(LimbKey))`, then `item(further_processing, Status, cite(Key))`, then `item(exemption, Status, cite(Key))` on art14. Status is `met`, `unmet(Reason)` or `unknown(Keys)`. Cites: GDPR Art 13(1)–(3), 14(1)–(5).
- `gdpr_information_duties_headline_verdict_what_if(Profile, Key, Value, Verdict)`: the headline after overriding one key, via `kit/query_combinators:what_if/5` with the closure `information_duty_verdict_status`. Cites as for the headline.

### Unscored helpers for the required query types (D-H)

- `gdpr_information_duties_headline_verdict_compliance_check(Profile, ProposedAction, Verdict)` (#13): ProposedAction is `provide_information_on(date(Y, M, D))` or `start_further_processing_on(date(Y, M, D))`. Verdict is `allowed`, `not_allowed` or a non-final constructor, computed by overriding `provision_date` / `further_processing_start_date` and re-running the headline. Cites: GDPR Art 13(1), 13(3), 14(3), 14(4).
- `gdpr_information_duties_headline_verdict_obligations(Profile, Obligations)` (#14): the list of `must_provide(Item, cite(PointKey))` for items owed and not covered, plus `must_provide_before(other_purpose_information, date(Y, M, D), cite(Key))` when further processing is intended. It is `[]` when an exemption is MET, `[no_item_missing]` when nothing is outstanding, else a non-final constructor. Cites: GDPR Art 13(1)–(3), 14(1)–(4).
- `gdpr_information_duties_headline_verdict_deadline(Profile, Deadline)` (#15): `deadline(date(Y, M, D), Basis, Consequence)`, where Basis is `art13_1` or `art14_3_a`/`b`/`c` and Consequence is `ineligible_if_later`; or a non-final constructor. Cites: GDPR Art 13(1), 14(3); Reg 1182/71 Art 3.

### Fixtures

- `fixture(Name, Profile)` and `fixture_expected(Name, Query, Expected)`, as listed in the fixtures section below.

## kernel.clausal (the shared floor; only predicates used by BOTH slices or by queries)

- `gdpr_information_duties_headline_verdict_input_problems/2`: the input check (K); every relation calls it first. It has local helpers `contract_key/2` (key, type), `key_occurrence_count/3`, `value_has_type/2`, `item_atom/1` and `item_allowed_in/2`.
  - The contract-key table is a value fact of the KERNEL because both slices and queries need it.
  - The profile shape test is the only place a profile list is inspected (via `profile_keys/2`), so the duplicate and unknown counts never traverse by hand.
- `calendar_day(date(Year, Month, Day))`: integer Gregorian validity, using `kit/deadline_lib:month_last_day/3`.
- `date_earlier(DateOne, DateTwo)` and `date_not_later(DateOne, DateTwo)`: integer lexicographic comparison (D-B).
- `route_status(Profile, Status)`: Status is `value(art13)`, `value(art14)` or `unknown([personal_data_collected_from_data_subject])`.
- `judgement_status(Profile, Key, Status)`: Status is `value(true)`, `value(false)`, `value(unsure)` or `unknown([Key])`. Its three clauses are disjoint.
- `outside_fact_status(Profile, Key, Status)`: Status is `met` (attested true), `unmet(attested_false)` or `unmet(absent)`. This is BLOCKING (A2); it is never unknown.
- `outside_fact_record(Profile, Key, Record)`: the attested term as given, or `absent`, for (J).
- `root_order_keys(Keys, Ordered)`: sorts and deduplicates keys by contract order (for MISSING_KEYS and PAIRS).
- `relied_pairs(Profile, JudgementKeys, Pairs)`: Key-Value pairs of the present judgement keys, in root order.

## citations.clausal

- `citation(Key, Instrument, Unit, Gloss)` for every citation-key atom above.
- `source_unit/3` for the provenance-only units.

## parameters.clausal

- The pinned versions only: `pinned_version(gdpr, '02016R0679-20160504')` and `pinned_version(regulation_1182_71, '31971R1182')`.
- No statutory figures; each slice owns its own.

## Slice: information_duty_exemption.clausal (G)

### Value facts (owned here)

- `exemption_limb(1, impossible_or_disproportionate_effort, eu_reg_2016_679_art_14_5_b)`
- `exemption_limb(2, law_lays_down_obtaining_or_disclosure, eu_reg_2016_679_art_14_5_c)`
- `exemption_limb(3, professional_secrecy_obligation, eu_reg_2016_679_art_14_5_d)`
- `exemption_fact_key(law_lays_down_obtaining_or_disclosure, obtaining_or_disclosure_laid_down_by_law)`
- `exemption_fact_key(professional_secrecy_obligation, professional_secrecy_obligation_by_law)`

### Rules and requirements

1. **E0 (input check first):** problems not `[]` gives `input_problems(P)`.
2. **E1 (route):** route `art13` gives `none`, reading no exemption key. Route unknown gives `indeterminate([personal_data_collected_from_data_subject])`, whatever the exemption keys are.
3. **E2 (limb b status), `limb_b_status(Profile, Status)`:**
   - MET when (17) is true and (18) is true.
   - UNMET when (17) is false or (18) is false.
   - `unknown([17])` when (17) is absent and (18) is true.
   - `unknown([17, 18])` when both are absent.
   - `unknown([18])` when (17) is true or unsure and (18) is absent.
   - `unknown([18])` also when (17) is absent and (18) is absent? No: that case is covered by the line above (both named).
   - `open_judgement` when (17) is unsure and (18) is true.
   - The clauses are disjoint, with no cut.
4. **E3 (limbs c and d):** `outside_fact_status/3` from the kernel. They are never open.
5. **E4 (first MET, strong-Kleene OR):** the defeasible order is written as guarded rules.
   - (b) MET gives `impossible_or_disproportionate_effort`.
   - (c) MET and NOT (b) MET gives `law_lays_down_obtaining_or_disclosure`.
   - (d) MET and NOT (b) MET and NOT (c) MET gives `professional_secrecy_obligation`.
   - Each guard is `\+` over a ground status goal.
6. **E5 (no MET):**
   - limb (b) UNMET gives `none`;
   - limb (b) unknown gives `indeterminate(Keys)`;
   - limb (b) open gives `needs_legal_review(open_textured(provision_impossible_or_disproportionate_effort, cite(eu_reg_2016_679_art_14_5_b)), [inputs_relied_on([provision_impossible_or_disproportionate_effort-unsure, provenance(e5, [cite(eu_reg_2016_679_art_14_5_b)])])])`.

### Verdict atoms

- `impossible_or_disproportionate_effort`, `law_lays_down_obtaining_or_disclosure`, `professional_secrecy_obligation`, `none`, plus the constructors.

### Shared with the verdict slice (exported from this slice, not the kernel)

- `exemption_evaluation(Profile, Exemption)`: the input-check-free (G) core that the headline stage two calls. It lives here because it is this slice's concept. The verdict slice imports it; no kernel copy exists.

### Per-rule tests

- E1 on art13 with garbage-free exemption keys gives `none`.
- Route absent gives `indeterminate([1])`.
- Each E2 row.
- (c) true with (17) absent gives `law_lays_down_obtaining_or_disclosure`.
- (17) true, (18) true, (19) true gives (b) (first MET).
- Absent (19) and (20) with (17) false gives `none`.
- Count tests: exactly one solution for each.

## Slice: information_duty_verdict.clausal (I, with internal stages A–F, H)

### Value facts (owned here)

- `:- constant_value(information_period_months, 1).` (Art 14(3)(a), 'one month'.)
- `weekend_day_number(6)` for Saturday and `weekend_day_number(0)` for Sunday. The numbering runs from Sunday 0 to Saturday 6, by the Sakamoto integer method (1182/71 Art 3(4)).
- `item_order(Number, Item)` for 1–15.
- `item_point(Item, art13|art14, CitationKey)`, following the item table.
- `item_condition(Item, ConditionKey)` and `item_condition_is_judgement(automated_decision_making_information)`.
- `paragraph_two_item(Route, Item)`.
- `route_paragraph_cite(art13, eu_reg_2016_679_art_13_1)` and `route_paragraph_cite(art14, eu_reg_2016_679_art_14_1)`.
- `further_processing_cite(art13, eu_reg_2016_679_art_13_3)` and `further_processing_cite(art14, eu_reg_2016_679_art_14_4)`.
- `deadline_limb_cite(art13_1, eu_reg_2016_679_art_13_1)`, `deadline_limb_cite(art14_3_a, eu_reg_2016_679_art_14_3_a)`, and likewise for `_b` and `_c`.
- `referral_cite(Judgement, Route, CitationKey)`, following the referrals block.

### Rules and requirements

Stages are internal and not exported as queries.

- **V-A (route):** `route_status/2` from the kernel.
- **V-B (owed):**
  - Each item is owed when its route lists it and its condition key is true; for item 14 when (9) is true.
  - The OWED list is in pure item order and is never empty.
  - An unsure (9) is an OPEN component, cited `13_2_f` / `14_2_g`.
- **V-C (missing):**
  - MISSING is OWED minus `items_provided` and minus `items_data_subject_already_has`.
  - Condition keys are read only for items not covered (D-G).
  - A definite missing item gives UNMET with `missing_item(Item, cite(Point))`.
  - Otherwise an unknown or unsure key gives OPEN.
  - Otherwise `[no_item_missing]` gives MET.
- **V-D (one month), `one_month_end(ObtainingDate, Holidays, EndDate)`:**
  1. Take month M+1, rolling December to January of Y+1.
  2. Take day `int_min(D, LastDay)`, with LastDay from `month_last_day/3`.
  3. Then, while the day is a weekend day or a member of Holidays, step one day (local `following_day/2`, integer arithmetic with month and year rollover).
  - Holidays is `[]` when `public_holidays` is absent.
  - Hand-checked fixtures, with no holidays:
    - 2026-01-15 gives 2026-02-16; 2026-01-31 gives 2026-03-02;
    - 2028-01-31 gives 2028-02-29; 2026-03-31 gives 2026-04-30;
    - 2026-12-15 gives 2027-01-15; 2026-12-31 gives 2027-02-01;
    - 2026-05-30 gives 2026-06-30.
  - With `[date(2027, 2, 1)]` attested, 2026-12-31 gives 2027-02-02.
- **V-E (deadline and basis):**
  - art13: the obtaining_date, basis `art13_1`.
  - art14: the earliest of limb (a), (b) when (12) is true, and (c) when (14) is true. On a tie, the first of (a), (b), (c).
  - Absent keys are read per (D).
- **V-F (timing):**
  1. The limb (a) late rule comes first: on art14, with (10) and (11) present and (11) after the limb (a) date, the result is `late` with cite `14_3_a`, whatever (12)–(15) are.
  2. Otherwise (11) after DEADLINE is `late`, cited by the basis limb.
  3. Otherwise, on art14, (16) true is `timely`; false is `late` (cite `14_3_a`); unsure is OPEN by judgement; absent is OPEN by absence.
  4. Otherwise, on art13, the result is `timely`.
- **V-H (further processing):**
  - (21) false is `not_applicable`.
  - Otherwise OWED is `other_purpose_information`, plus the route's paragraph-2 items whose condition holds when (25) is true.
  - UNMET when (23) is not strictly earlier than (22), or an owed item is in neither (24) nor (3).
  - MET is `eligible`.
  - An absent key among (21)–(25) or the read condition keys gives OPEN by absence.
  - An unsure (25) or an unsure read (9) gives OPEN by judgement.
- **V-BASE:** the Kleene AND of V-C, V-F and V-H, using `formalize_lib:and_status/2`.
  - UNMET dominates MET, and MET dominates OPEN.
  - The route-absent rule is D-A.
- **V-I (stage one):** BASE MET gives `eligible` with `[cite(route paragraph)]`, followed by the (H) cite when (H) is eligible. No exemption key is read.
- **V-I (stage two, defeater):** on art14 with BASE not MET, `exemption_evaluation/2` naming an exemption gives `eligible` with `[cite(14_5_x)]`.
  - This is written as a defeasible rule: `defeated_by_exemption(Profile, Exemption, Citation)`, guarded by `once/1` over the ground exemption evaluation (one solution guaranteed) and checked through `formalize_lib:not_defeated/3` in the base-ineligible and base-open rules.
- **V-I (stage three):** BASE UNMET and no exemption.
  - When (G) is non-final, the result is (G)'s answer: `indeterminate` over the exemption keys, or the (17) referral. With the route absent this is `indeterminate([1])` (D-A).
  - Otherwise the result is `ineligible` with the missing-item cites, then the timing cite if late, then the (H) cite if ineligible, without duplicates.
- **V-I (stage four):** BASE OPEN and no exemption.
  - When there are absent keys, the result is `indeterminate(Keys)`: every absent key BASE read, plus, on art14, (G)'s keys, in root order (list-all). Exemption keys are never included on art13 or with the route absent.
  - Otherwise the result is `needs_legal_review(open_textured(FirstUnsure, cite(referral_cite)), [inputs_relied_on(Pairs)])`.
- **Input problems** come first; Cites are `[]` for every non-final answer.

### Verdict atoms

- `eligible`, `ineligible`, plus the constructors.
- Internal atoms: `timely`, `late`, `not_applicable`, `no_item_missing`, the basis atoms, `owed_item/2` and `missing_item/2`.

### Shared with another slice

- It imports `exemption_evaluation/2` from `information_duty_exemption.clausal`.
- It imports `route_status/2`, `judgement_status/3`, `outside_fact_status/3`, `outside_fact_record/3`, the date comparisons, `calendar_day/1`, `root_order_keys/2` and `relied_pairs/3` from the kernel.
- Nothing of its own is needed by the exemption slice.

### Per-rule tests

- Each one-month fixture date.
- Tie basis selection.
- The limb (a) late rule with (12)–(15) absent.
- Covered-item condition keys absent, which must not change the answer.
- An unsure (9) masked by a definite missing item.
- Same-day further processing is ineligible.
- Stage-two exemption over BASE OPEN.
- A stage-four list-all mixing BASE keys and (17)/(18).
- Route absent with item 1 uncovered gives `indeterminate([1])`.
- Count tests on every case.

## queries.clausal

- The scored wrappers `information_duty_verdict/3`, `information_duty_exemption/2` and `information_outside_facts/2`, each with one clause for input problems (guarded on problems not `[]`) and one for a clean profile (problems `[]`).
- The unscored #13, #14 and #15 helpers, and the what-if wrapper.

## Fixtures (fixtures.clausal; each with hand-computed expectations)

1. **`art13_complete_timely`:** every owed item provided on the obtaining day, (21) false. Headline `eligible`, Cites `[cite(eu_reg_2016_679_art_13_1)]`; exemption `none`.
2. **`art13_missing_requirement_item`:** statutory_or_contractual_requirement not covered. Headline `ineligible`, Cites `[cite(eu_reg_2016_679_art_13_2_e)]`.
3. **`art14_month_end_weekend`:** obtaining 2026-01-31, provision 2026-03-02, (12) and (14) false, (16) true, complete. Headline `eligible`, Cites `[cite(eu_reg_2016_679_art_14_1)]`.
4. **`art14_late_limb_a_holidays`:** obtaining 2026-12-31, holidays `[date(2027, 2, 1)]`, provision 2027-02-03. Headline `ineligible`, Cites `[cite(eu_reg_2016_679_art_14_3_a)]`.
5. **`art14_exemption_law_overrides_open_base`:** (19) attested true, (16) unsure, (17) absent. Headline `eligible`, Cites `[cite(eu_reg_2016_679_art_14_5_c)]`; exemption `law_lays_down_obtaining_or_disclosure`.
6. **`art14_base_unmet_effort_unsure`:** source item missing, (17) unsure, (18) true. Headline is the needs_legal_review on (17), cite `14_5_b`.
7. **`art14_stage_four_list_all`:** (11) absent, (17) and (18) absent. Headline `indeterminate([provision_date, provision_impossible_or_disproportionate_effort, protective_measures_taken])`.
8. **`art13_adm_unsure`:** complete except item 14 uncovered and (9) unsure. Headline `needs_legal_review(open_textured(automated_decision_making_under_article_22, cite(eu_reg_2016_679_art_13_2_f)), [inputs_relied_on([automated_decision_making_under_article_22-unsure])])`.
9. **`input_problems_mix`:** duplicate `items_provided`, `obtaining_date` given `date(2026, 2, 30)`, unknown key `colour`. Every query gives `input_problems([duplicate_key(items_provided), wrong_type(obtaining_date), unknown_key(colour)])`.
10. **`not_a_profile`:** the atom `foo`. Every query gives `input_problems([wrong_type(profile)])`.
11. **`outside_facts_absent`:** (J) is `[outside_fact(obtaining_or_disclosure_laid_down_by_law, absent), outside_fact(professional_secrecy_obligation_by_law, absent), outside_fact(public_holidays, absent)]`.

## Test modes (seven)

1. Per-rule unit tests in each slice.
2. Checklist tests.
3. Verdict tests.
4. Input-check tests (kernel).
5. Counting and determinism: `findall` plus `length/2` gives exactly one solution, via `validate_props:prop_determinism/3` and `prop_totality/3`.
6. Boundary dates: the inclusive last day, the strict 'prior to', and ties, via `prop_boundary_coverage/2`.
7. Citation completeness and missing-key coverage: `prop_citation_complete/3`, and `prop_missing_key_coverage/3` over the 26 keys.

Every negative test is paired with a positive test over the same case.

## Planned reuse (manifest `uses:`)

### formalize_lib

- `profile_get/3`, `profile_has/2`, `profile_lacks/2`, `profile_keys/2`
- `missing_keys/3`, `and_status/2`, `or_status/2`, `collect_unknown/2`
- `not_defeated/3`
- `memberd/2`, `not_member/2`, `int_min/3`
- `item/3`, `unmet/1`, `unknown/1`, `value/1`, `absent/1`, `attribute/2`

### kit/deadline_lib

- `month_last_day/3`. This is integer-only, used for the cap and for calendar-day validity.
- `deadline_months_after/3` is deliberately NOT used: it implements the AU last-day rule, not the 1182/71 same-date rule.
- `next_day/2` and `date_on_or_before/2` are used only if P2 confirms they accept `date(Y, M, D)` compound terms; otherwise local `following_day/2` and the kernel comparisons are used.

### kit/query_combinators

- `what_if/5`, for `gdpr_information_duties_headline_verdict_what_if/4` and the #13 compliance helper.

### validate_props

- `run_props/1`, `prop_totality/3`, `prop_determinism/3`, `prop_citation_complete/3`, `prop_boundary_coverage/2`, `prop_missing_key_coverage/3`.

### Not used

- `kit/compliance_lib` is not used. Its deny-overrides modality lattice does not match the strong-Kleene staged headline; #13 is served by re-running the headline after a what-if override.
- `library(datetime)` is not used. It registers only `date/4`; the profile carries `date/3` compounds compared as integers (D-B), and the weekday is computed by integer Gregorian arithmetic (PERIODS: COMPUTED).

### Local, domain-specific or a kit candidate

- `one_month_end/3`, a kit candidate as `eu_period_months_end/4` (see NOTES).
- `day_of_week_number/2` and `following_day/2`.
