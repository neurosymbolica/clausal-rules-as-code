# SIGNATURE — eu/data_protection/gdpr_data_subject_rights_response_duties

## 1 Public query surface

The ORDER's scored queries are:

- `request_response_deadline(PROFILE, DEADLINE)`
- `response_duties(PROFILE, DUTIES)`
- `recipient_notification(PROFILE, DUTIES)`
- `gdpr_data_subject_rights_response_duties_input_problems(PROFILE, PROBLEMS)`

PROFILE is an attribute list `[attribute(KEY, VALUE), ...]` read only through `formalize_lib:profile_get/3` and `profile_has/2`. Keys are bare atoms, never strings.

Every public predicate is TOTAL and DETERMINISTIC: exactly one solution for every profile, with no cut, no `->` and no `*->`. Ground outputs are folded into clause heads, one clause per disjoint route.

The scaffold facade predicates are kept: `decide_gdpr_data_subject_rights_response_duties/2`, `gdpr_data_subject_rights_response_duties_status/2`, `gdpr_data_subject_rights_response_duties_checklist/2` and `gdpr_data_subject_rights_response_duties_what_if/4`. They are package conveniences built on the internal decision, not order queries.

The internal relations of the parent order are computed in the slice and NOT exported (SCOPE OF THIS ORDER):

- `decide_data_subject_request/2`
- `applicable_response_period/2`
- `response_deadline/3`
- `request_outside_facts/2`

No figure is imported from another domain. The two statutory periods are declared once in the slice.

## 2 Verdict STATUS atoms (replace the placeholder `{ required, permitted, not_applicable }`)

Internal decision COMPLY, also the facade STATUS. It is exactly one of:

| COMPLY | meaning |
|---|---|
| `must_comply` | bare atom |
| `need_not_comply` | bare atom |
| `indeterminate(MissingKeys)` | MissingKeys a non-empty list of bare key atoms. The bare atom `indeterminate` is NEVER written. |
| `needs_legal_review(Reason, Context)` | Reason is `open_textured(InputKey, cite(CitationAtom))` or `cross_reference_unresolved(cite(CitationAtom), cite(TargetAtom))`. Context is `[resolution(cite(TargetAtom), not_attempted)]` (cross_reference only) followed by `inputs_relied_on(Pairs)`. |
| `suspended(art12_6_identity_not_confirmed)` | non-final |
| `input_problems(Problems)` | non-final |

Internal verdict term:

`gdpr_data_subject_request_verdict(COMPLY, BASIS, EXCEPTION, CONDITIONS, CITATIONS)`

BASIS atoms:

- `art15_1`
- `art16_inaccurate_data`, `art16_incomplete_data`
- `art17_1_a`, `art17_1_b`, `art17_1_c`, `art17_1_d`, `art17_1_e`, `art17_1_f`
- `art18_1_a`, `art18_1_b`, `art18_1_c`, `art18_1_d`
- `art20_1`
- `art21_1`, `art21_2`, `art21_6`
- `art22_1`
- `none`

EXCEPTION atoms:

- `art17_3_a`, `art17_3_b`, `art17_3_c`, `art17_3_d`, `art17_3_e`
- `art20_3_public_task`, `art20_4_rights_of_others`
- `art21_1_compelling_legitimate_grounds`, `art21_1_legal_claims`
- `art21_6_public_interest_task`
- `art22_2_a`, `art22_2_b`, `art22_2_c`
- `art12_5_manifestly_unfounded_or_excessive`
- `art12_2_unable_to_identify`
- `art23_legislative_restriction`
- `none`

CONDITIONS atoms:

- `reasonable_fee_may_be_charged`
- `human_intervention`, `express_point_of_view`, `contest_decision`
- the empty list `[]`

PERIOD atoms (internal): `first_period`, `extended_period`.

Duty terms in the output lists of (D) and (E):

- `respond_with_action_taken(Period, cite(eu_reg_2016_679_art_12_3))`
- `inform_of_extension_with_reasons(first_period, cite(eu_reg_2016_679_art_12_3))`
- `inform_of_reasons_and_remedies(first_period, cite(eu_reg_2016_679_art_12_4))`
- `communicate_to_each_recipient(cite(eu_reg_2016_679_art_19))`
- `inform_data_subject_of_recipients(cite(eu_reg_2016_679_art_19))`
- `recipient_notification_excused(cite(eu_reg_2016_679_art_19))`
- `recipient_notification_not_applicable(cite(eu_reg_2016_679_art_19))`

Input problem terms:

- `unknown_key(Key)`
- `wrong_type(Key)`
- `wrong_type(profile)`
- `duplicate_key(Key)`

## 3 Profile keys (fifty-four exactly, in root_exports order)

The root_exports order below is the order for MISSING_KEYS, PROBLEMS and PAIRS.

### Atom keys (2)

- `request_type`: one of `access`, `rectification`, `erasure`, `restriction`, `portability`, `objection`, `automated_decision`. REQUIRED.
- `objection_ground_claimed`: one of `art21_1`, `art21_2`, `art21_6`. Read only for objection, and then REQUIRED.

### Date key (1)

- `request_received_on`: `date(Year, Month, Day)`, a real Gregorian calendar day. Read only by `request_response_deadline/2`.

### Crisp keys (25): atom `true` or `false`

1. `extension_claimed` (defeater)
2. `controller_demonstrates_unable_to_identify_data_subject` (defeater)
3. `identity_confirmed`
4. `personal_data_inaccurate`
5. `consent_is_the_basis_of_processing`
6. `consent_withdrawn`
7. `other_legal_ground_for_processing_exists`
8. `objection_under_art21_1_made`
9. `objection_under_art21_2_made`
10. `collected_in_relation_to_information_society_services_offer`
11. `accuracy_contested_by_data_subject`
12. `data_subject_opposes_erasure`
13. `data_required_by_data_subject_for_legal_claims`
14. `verification_of_overriding_grounds_pending`
15. `personal_data_provided_by_data_subject`
16. `processing_based_on_consent_or_contract`
17. `processing_carried_out_by_automated_means`
18. `processing_based_on_art6_1_e_or_f`
19. `processing_for_direct_marketing`
20. `processing_for_research_or_statistics_pursuant_to_art89_1`
21. `data_subject_gave_explicit_consent` (exception key: defeater)
22. `decision_based_on_special_categories` (defeater)
23. `special_category_condition_and_safeguards_met_for_decision` (REQUIRED once item 22 is `true`)
24. `personal_data_disclosed_to_recipients`
25. `data_subject_asks_who_the_recipients_are` (defeater)

### Judgement keys (21): `true`, `false` or `unsure`

All are the user's judgement and are never derived.

1. `extension_necessary_for_complexity_and_number`
2. `reasonable_doubts_about_identity` (defeater)
3. `request_manifestly_unfounded_or_excessive` (defeater)
4. `personal_data_incomplete_in_light_of_purposes`
5. `data_no_longer_necessary_for_purposes`
6. `overriding_legitimate_grounds_exist`
7. `personal_data_unlawfully_processed`
8. `processing_necessary_for_freedom_of_expression_and_information` (exception: defeater)
9. `processing_necessary_for_public_task_or_official_authority` (exception: defeater)
10. `processing_necessary_for_public_health_in_accordance_with_art9_2_h_and_i` (exception: defeater)
11. `processing_for_archiving_research_or_statistics_in_accordance_with_art89_1` (exception: defeater)
12. `erasure_would_render_impossible_or_seriously_impair_processing_objectives` (exception: defeater)
13. `processing_necessary_for_legal_claims` (exception: defeater)
14. `controller_no_longer_needs_data_for_processing_purposes`
15. `transmission_would_adversely_affect_rights_and_freedoms_of_others` (exception: defeater)
16. `objection_grounds_relate_to_particular_situation`
17. `controller_demonstrates_compelling_legitimate_grounds` (exception: defeater)
18. `decision_based_solely_on_automated_processing`
19. `decision_produces_legal_or_similarly_significant_effects`
20. `decision_necessary_for_contract_with_data_subject` (exception: defeater)
21. `recipient_notification_impossible_or_disproportionate_effort`

### Outside facts (5)

Order of `outside_facts:`. Each is `attested(Value, attestation(By, At, Reason, Evidence))`. Evidence is `url(Url, RetrievedAt)`, `document(UploadId, Sha256)` or `none`. Fetcher: `none`.

1. `erasure_required_by_union_or_member_state_law`: Value `true` or `false`. ENABLING: absent means OPEN BY OUTSIDE FACT.
2. `processing_required_by_union_or_member_state_law`: Value `true` or `false`. BLOCKING: absent means UNMET.
3. `decision_authorised_by_union_or_member_state_law`: Value `true` or `false`. BLOCKING.
4. `legislative_restriction_applies_to_the_right`: Value `true` or `false`. BLOCKING.
5. `public_holidays`: Value a list, possibly `[]`, of real `date(Year, Month, Day)`. Absent means no holiday shift. Read only by (C).

No money and no numeric keys, so no unit suffixes are needed.

## 4 Citation-key atoms (one per load-bearing unit; declared in citations.clausal)

| atom | unit |
|---|---|
| `eu_reg_2016_679_art_12_2` | parag_012.002 |
| `eu_reg_2016_679_art_12_3` | parag_012.003 |
| `eu_reg_2016_679_art_12_4` | parag_012.004 |
| `eu_reg_2016_679_art_12_5` | parag_012.005, point_012.005_a, point_012.005_b |
| `eu_reg_2016_679_art_12_6` | parag_012.006 |
| `eu_reg_2016_679_art_15_1` | parag_015.001, opening words |
| `eu_reg_2016_679_art_16` | art_016 |
| `eu_reg_2016_679_art_17_1` | parag_017.001 |
| `eu_reg_2016_679_art_17_3` | parag_017.003 |
| `eu_reg_2016_679_art_18_1` | parag_018.001 |
| `eu_reg_2016_679_art_19` | art_019 |
| `eu_reg_2016_679_art_20_1` | parag_020.001 |
| `eu_reg_2016_679_art_20_3` | parag_020.003 |
| `eu_reg_2016_679_art_20_4` | parag_020.004 |
| `eu_reg_2016_679_art_21_1` | parag_021.001 |
| `eu_reg_2016_679_art_21_2` | parag_021.002 |
| `eu_reg_2016_679_art_21_3` | parag_021.003 |
| `eu_reg_2016_679_art_21_6` | parag_021.006 |
| `eu_reg_2016_679_art_22_1` | parag_022.001 |
| `eu_reg_2016_679_art_22_2` | parag_022.002 |
| `eu_reg_2016_679_art_22_3` | parag_022.003, deferred, context only |
| `eu_reg_2016_679_art_22_4` | parag_022.004 |
| `eu_reg_2016_679_art_23_1` | parag_023.001, opening words |
| `eu_reg_1971_1182_art_3` | 31971R1182 Art 2(2), 3(1) second subparagraph, 3(2)(c), 3(4) |

The TARGET atoms of `cross_reference_unresolved` come from the manifest `outside_facts:` table. They are not re-declared in the slice.

## 5 Public predicates

### Order queries

- `request_response_deadline(Profile, Deadline)`: (C).
  - Gives `date(Year, Month, Day)`, with bare integers queried element-wise. Otherwise it gives one status compound: `indeterminate/1`, `needs_legal_review/2`, `suspended/1` or `input_problems/1`.
  - It applies AFTER THE DECISION. A refusal uses the first period. Must-comply uses the period of (B).
  - The Art 3(4) holiday shift uses attested `public_holidays`.
  - Cites: `eu_reg_2016_679_art_12_3`, `eu_reg_2016_679_art_12_4`, `eu_reg_1971_1182_art_3`.
- `response_duties(Profile, Duties)`: (D).
  - Gives one non-empty duty list or one status compound.
  - Must-comply with the first period: `[respond_with_action_taken(first_period, ...)]`.
  - Must-comply with the extended period: `[inform_of_extension_with_reasons(first_period, ...), respond_with_action_taken(extended_period, ...)]`.
  - Need-not-comply: `[inform_of_reasons_and_remedies(first_period, ...)]`.
  - Cites: `eu_reg_2016_679_art_12_3`, `eu_reg_2016_679_art_12_4`.
- `recipient_notification(Profile, Duties)`: (E).
  - Gives one non-empty list or one status compound.
  - The Art 19 duty arises only for rectification, erasure and restriction with `must_comply`.
  - Outcomes: not applicable; excused; or communicate, plus inform the data subject when asked.
  - Cite: `eu_reg_2016_679_art_19`.
- `gdpr_data_subject_rights_response_duties_input_problems(Profile, Problems)`: the INPUT CHECK.
  - Gives `[]` for a well-formed profile. Otherwise `duplicate_key` or `wrong_type` in contract order, then `unknown_key` in first-occurrence order.
  - A non-list profile gives `[wrong_type(profile)]`.
  - Cite: none (input contract).

### Facade (kept scaffold names; package conveniences, not order queries)

- `decide_gdpr_data_subject_rights_response_duties(Profile, gdpr_data_subject_rights_response_duties_verdict(Status, Citations))`: the facade decision.
  - Status is the internal COMPLY.
  - Citations is the sorted set of citation atoms in the `response_duties/2` and `recipient_notification/2` outputs, and `[]` when either is a status compound.
  - Cites: the article 12 and 19 atoms.
- `gdpr_data_subject_rights_response_duties_status(Profile, Status)`: the facade status. Status is the internal COMPLY alone. Cites: as the decision.
- `gdpr_data_subject_rights_response_duties_checklist(Profile, Checklist)`: one `formalize_lib:item(LimbId, ItemStatus, cite(Atom))` per limb read for the request type.
  - Limbs, in this order: `engagement`, `identity_suspension`, then each exception id in decision order.
  - ItemStatus is `met`, `unmet(Reason)` or `unknown(Keys)`.
  - Met items carry a cite too.
- `gdpr_data_subject_rights_response_duties_what_if(Profile, Key, Value, Status)`: replaces Key by `profile_set/3` with `attribute(Key, Value)`, then calls the facade status. One solution.

### Fixtures

- `gdpr_data_subject_rights_response_duties_fixture(Name, Profile)`: named profiles (see section 9).
- `gdpr_data_subject_rights_response_duties_fixture_expected(Name, Query, Answer)`: the expected answer for each fixture and query.

### Result constructors (exported, never queries)

- status compounds: `indeterminate/1`, `needs_legal_review/2`, `open_textured/2`, `cross_reference_unresolved/2`, `resolution/2`, `inputs_relied_on/1`, `provenance/2`, `suspended/1`
- input problems: `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`
- attestations: `attested/2`, `attestation/4`, `url/2`, `document/2`
- duty terms: `respond_with_action_taken/2`, `inform_of_extension_with_reasons/2`, `inform_of_reasons_and_remedies/2`, `communicate_to_each_recipient/1`, `inform_data_subject_of_recipients/1`, `recipient_notification_excused/1`, `recipient_notification_not_applicable/1`

## 6 Planned reuse (manifest `uses:`)

### formalize_lib

- `profile_get/3`, `profile_has/2`, `profile_lacks/2`, `profile_keys/2` and `profile_set/3`: all profile access and the what_if override.
- `memberd/2` and `not_member/2`: enum and holiday-list membership, deterministic.
- `item/3`, `unmet/1` and `unknown/1`: checklist rows.
- `first_applicable/2`: the first MET exception over the ordered exception list.

`check_tri/4` and `check_tri_neg/4` are NOT used. Our tri-state has FOUR open causes (absence, judgement, outside fact, and defeater-absent-is-unmet), which they cannot express. A local `limb_status` family is written instead, and it is not a clone: it carries the open cause and the keys. The NOTES flag this as a C15 lint exemption: `% lint: C15 four-cause Kleene, not check_tri`.

### kit/deadline_lib

- `month_last_day/3`: month length, Gregorian.
- `next_day/2`: the shift step. It is used only on integer-built `date(Y, M, D)` compounds. If `next_day/2` requires native dates, a local integer successor is used instead.

`deadline_months_after/3` is deliberately NOT used: it is the AU 'last day of the period' rule, not the same-date rule of Reg 1182/71 Art 3(2)(c).

### library(datetime)

- `weekday/2` on `date/4` objects: oracle in the calendar test mode only.
- `date_string_iso/2`: fixture readability only.

### validate_props

- `run_props/1`
- `prop_totality/3` and `prop_determinism/3`: the exactly-one-solution property, over the fixture generator.
- `prop_missing_key_coverage/3`
- `prop_citation_complete/3`
- `prop_boundary_coverage/2`: month-end and leap dates.

### kit/query_combinators

`diff_checklists/3`, used in the what-if test mode.

### Not used

- `compliance_lib`: the modality lattice does not fit the ordered first-exception rule.
- `rolling_window`.
- the `currency_vocab`, `vat_category` and `country` vocabularies: no money and no country keys.

The family backbone (`_common`, deontic) is used only for shared result-constructor declarations, if present.

## 7 Referral rows (the `referrals:` table plan)

Each row maps an input to the citation of its `open_textured` result. Inputs always carry `request_type`, plus `objection_ground_claimed` for objection. The PAIRS RULE adds the rest.

| row | input key | cite |
|---|---|---|
| `identity_doubts_reasonable` | `reasonable_doubts_about_identity` | `eu_reg_2016_679_art_12_6` |
| `manifestly_unfounded_or_excessive` | `request_manifestly_unfounded_or_excessive` | `eu_reg_2016_679_art_12_5` |
| `rectification_incomplete_data` | `personal_data_incomplete_in_light_of_purposes` | `eu_reg_2016_679_art_16` |
| `erasure_no_longer_necessary` | `data_no_longer_necessary_for_purposes` | `eu_reg_2016_679_art_17_1` |
| `erasure_overriding_grounds` | `overriding_legitimate_grounds_exist` | `eu_reg_2016_679_art_17_1` |
| `erasure_unlawful_processing` | `personal_data_unlawfully_processed` | `eu_reg_2016_679_art_17_1` |
| `erasure_legal_obligation_not_attested` | `erasure_required_by_union_or_member_state_law` (enabling fact) | `cross_reference_unresolved(cite(eu_reg_2016_679_art_17_1), cite(Target))` |
| `erasure_freedom_of_expression` | the 17(3)(a) key | `eu_reg_2016_679_art_17_3` |
| `erasure_public_task` | `processing_necessary_for_public_task_or_official_authority` | `eu_reg_2016_679_art_17_3` |
| `erasure_public_health` | the 17(3)(c) key | `eu_reg_2016_679_art_17_3` |
| `erasure_archiving_research_statistics` | the 17(3)(d) archiving key, partner listed | `eu_reg_2016_679_art_17_3` |
| `erasure_seriously_impair_objectives` | the 17(3)(d) impairment key, partner listed | `eu_reg_2016_679_art_17_3` |
| `erasure_legal_claims` | `processing_necessary_for_legal_claims` | `eu_reg_2016_679_art_17_3` |
| `restriction_unlawful_processing` | `personal_data_unlawfully_processed` | `eu_reg_2016_679_art_18_1` |
| `restriction_no_longer_needed` | `controller_no_longer_needs_data_for_processing_purposes` | `eu_reg_2016_679_art_18_1` |
| `portability_public_task` | the public-task key | `eu_reg_2016_679_art_20_3` |
| `portability_rights_of_others` | `transmission_would_adversely_affect_rights_and_freedoms_of_others` | `eu_reg_2016_679_art_20_4` |
| `objection_article_21_1_particular_situation` | `objection_grounds_relate_to_particular_situation` | `eu_reg_2016_679_art_21_1` |
| `objection_article_21_6_particular_situation` | `objection_grounds_relate_to_particular_situation` | `eu_reg_2016_679_art_21_6` |
| `objection_compelling_legitimate_grounds` | `controller_demonstrates_compelling_legitimate_grounds` | `eu_reg_2016_679_art_21_1` |
| `objection_legal_claims` | `processing_necessary_for_legal_claims` | `eu_reg_2016_679_art_21_1` |
| `objection_public_interest_task` | the public-task key | `eu_reg_2016_679_art_21_6` |
| `automated_decision_solely_automated` | `decision_based_solely_on_automated_processing`, partner listed | `eu_reg_2016_679_art_22_1` |
| `automated_decision_significant_effects` | `decision_produces_legal_or_similarly_significant_effects`, partner listed | `eu_reg_2016_679_art_22_1` |
| `automated_decision_contract_necessity` | `decision_necessary_for_contract_with_data_subject` | `eu_reg_2016_679_art_22_2` |
| `extension_not_clearly_necessary` | `extension_necessary_for_complexity_and_number` | `eu_reg_2016_679_art_12_3` |
| `recipient_notification_disproportionate_effort` | `recipient_notification_impossible_or_disproportionate_effort` | `eu_reg_2016_679_art_19` |

The last two rows give their own one-pair PAIRS. The manifest table is authoritative; this is the authoring plan.

## 8 Slices

### 8.0 kernel.clausal (shared floor)

There is only ONE determination slice, so NO domain predicate is shared between slices. The kernel holds only:

- the result-constructor declarations;
- the root_exports key order: `gdpr_data_subject_rights_response_duties_contract_key(Index, Key, Kind)` for the 54 keys, where Kind is one of `atom_enum(List)`, `date`, `crisp`, `judgement`, `outside_fact_boolean` or `outside_fact_holiday_list`.

The key order is put in the kernel because the INPUT CHECK, the queries and the fixtures all read it.

### 8.1 citations.clausal

`citation(Atom, Instrument, Unit, VerbatimText)` for the 24 atoms of section 4. The unit text is pinned verbatim from the order.

### 8.2 parameters.clausal

It holds no value facts. Per the slice discipline, the periods live in the slice. It is left as the documented empty layer with a comment pointing to the slice.

### 8.3 gdpr_data_subject_rights_response_duties.clausal (THE slice)

#### Value facts it owns

- `:- constant_value(first_period_months, 1).` (Art 12(3), 12(4))
- `:- constant_value(extended_period_months, 3).` (Art 12(3): one month plus two further months, counted from receipt)
- `:- constant_value(months_per_year, 12).`
- `:- constant_value(gregorian_leap_cycle_years, 4)`, `gregorian_century_years 100` and `gregorian_era_years 400`, used only if `month_last_day/3` is replaced locally.
- Weekday codes: `saturday_weekday_number` and `sunday_weekday_number`, for the local integer formula, with Monday as 0.
- Ordered tables, stored as facts:
  - `request_type_value/1`: the 7 types.
  - `objection_ground_value/1`: the 3 grounds.
  - `request_type_exception(Type, Ground, Order, ExceptionId)`: the specific exceptions in statutory order, then the common three for every type.
  - `engagement_point(Type, Order, BasisAtom)`.
  - `article_19_request_type/1`: `rectification`, `erasure`, `restriction`.
  - `article_22_3_safeguard/2`: ordered `human_intervention`, `express_point_of_view`, `contest_decision`.
  - `referral_row(RowId, Type, Ground, InputKey, CitationAtom)`: section 7.
  - `outside_fact_direction(Key, enabling|blocking|holidays)`.

#### Rules and requirements (each one predicate family, cut-free, mutually exclusive clauses)

1. **Key readers.** Each reader returns a limb status of `met`, `unmet`, `open(absence, [Key])`, `open(judgement, [Key])` or `open(outside_fact, [Key])`.
   - `required_crisp_status(Profile, Key, Status)`
   - `required_judgement_status(Profile, Key, Status)`
   - `defeater_status(Profile, Key, Status)`: absent or `false` is `unmet`; `true` is `met`; `unsure` is `open(judgement)`.
   - `enabling_fact_status(Profile, Key, Status)`
   - `blocking_fact_status(Profile, Key, Status)`: absent or `false` is `unmet`.
2. **Combinators.**
   - `kleene_and(StatusList, Status)`: UNMET dominates; then absence; then outside fact, then judgement. Keys are accumulated only from open conjuncts.
   - `kleene_or(StatusList, Status)`: MET dominates; otherwise open; keys come from open disjuncts only.
   - `kleene_not(Status, Negated)`.
3. **Engagement.** `engagement_status(Profile, Type, Ground, Status, Basis)` follows INTERFACE - THE ENGAGEMENT, giving the first MET point's BASIS.
   - Access: always `met`, BASIS `art15_1`.
   - Rectification: Art 16.
   - Erasure: points A to F.
   - Restriction: points A to D.
   - Portability: Art 20(1).
   - Objection: per claimed ground.
   - Automated decision: Art 22(1).
4. **Exceptions.** `exception_status(Profile, Type, Ground, ExceptionId, Status)`, one clause group per exception id.
   - 17(3)(b) = blocking fact OR judgement.
   - 17(3)(d) = AND of its two judgements.
   - The Art 22 BAR = `defeater(decision_based_on_special_categories)` AND NOT `required(special_category_condition_and_safeguards_met_for_decision)`. The second key is read only when the first is `true`.
   - `art22_2_b` = blocking fact AND NOT BAR.
5. **Suspension.** `suspension_status(Profile, Status)`: `defeater(reasonable_doubts_about_identity)` AND NOT `required(identity_confirmed)`.
6. **Internal decision.** `data_subject_request_decision(Profile, Verdict)` runs steps (0) to (v) of THE DECISION.
   - Steps are disjoint by guards over the computed limb statuses.
   - The first MET exception is chosen with guarded `once/1` over the ordered list. That is the defeasible-defeater idiom; no cut.
   - MISSING_KEYS: the union of absence keys of open limbs, in root_exports order, deduplicated.
   - The `open_textured` input: the first unsure key in root_exports order among open limbs, excluding unsure keys inside UNMET sub-conjunctions.
   - PAIRS: built by the PAIRS RULE.
   - The verdict CITATIONS are `[]` throughout. The verdict is internal and its citations reach no output (reading 17).
7. **Period.** `applicable_response_period(Profile, Period)` follows (B). It does not read the decision.
8. **Calendar.** `response_deadline(Receipt, Period, Deadline)` follows (A), in exact integers.
   - Target month = month + months, carried over the year.
   - Day = min(day, `month_last_day`).
   - Then `working_day_on_or_after(Date, Holidays, Deadline)`, with `[]` holidays for (A).
   - `day_of_week(date(Y, M, D), Number)` is a local integer formula.
   - Termination: the holiday list is finite and each step advances a day.
9. **Holiday shift.** `holiday_list(Profile, Holidays)`: attested list or `[]`. (C) applies `working_day_on_or_after` to the raw clipped last day with the holiday list. This is equivalent to the weekend shift and then the holiday shift of (C).
10. **Completion engine (AFTER THE DECISION).**
    - `decision_completions(Profile, Completions)` uses lazy branching. Evaluate the decision; if it is non-final, branch on the FIRST open key in root_exports order over its finite domain:
      - `request_type`: 7 values;
      - `objection_ground_claimed`: 3 values;
      - crisp and judgement keys: `true` or `false`;
      - the enabling fact: `attested(true, ...)` or `attested(false, ...)`, with a placeholder attestation `attestation(completion, completion, completion, none)`, never output.

      Defeaters and blocking facts stay absent. A leaf is a final or suspended decision. Leaves are collected with findall into a sorted answer set.
    - `relation_answer_on_completion(Relation, Profile, Answer)` applies (C), (D) or (E) to a leaf, with the relation's own keys as they are.
    - `completion_test_settles(Relation, Profile, Answer)` succeeds when there is exactly one distinct leaf answer.
    - `key_can_change(Relation, Profile, Key)` asks whether two full assignments over the touched keys plus own keys, differing only in Key, give different answers. Enumeration is bounded per request type. While `request_type` is absent, only `request_type` and the own keys are tested.
11. **Relations.** `request_response_deadline/2`, `response_duties/2` and `recipient_notification/2`, each in this order:
    - input problems;
    - the completion test;
    - status mapping (2);
    - the final routes.

    Each relation has exactly one solution.
12. **Input check.** `gdpr_data_subject_rights_response_duties_input_problems/2`, built from the kernel's key order. Value predicates:
    - `valid_value(Kind, Value)`;
    - `real_calendar_date/1` (integers, 1 ≤ M ≤ 12, 1 ≤ D ≤ `month_last_day`);
    - `attested_boolean/1`;
    - `attested_holiday_list/1`.

    A duplicate is counted with findall over `profile_get` occurrences; values are not read.

#### Slice verdict atoms

Those of section 2.

#### Shared with another slice

NONE, so nothing beyond the kernel items of 8.0.

### 8.4 queries.clausal

It re-exports the four order queries and the facade checklist and what_if. There is no logic beyond delegation.

### 8.5 fixtures.clausal

Fixtures cover every BASIS, every EXCEPTION, each step (0) to (v), each referral row, and the calendar examples of NOTES S4 item 5. Named examples:

- `fixture_access_plain`
- `fixture_erasure_ground_e_absent_refers`
- `fixture_erasure_17_3_b_by_fact`
- `fixture_art23_absent_must_comply`
- `fixture_identity_suspended`
- `fixture_suspended_but_special_category_key_absent`
- `fixture_art12_5_fee`
- `fixture_restriction_unsure_in_unmet_conjunct`
- `fixture_art22_bar_blocks_consent`
- `fixture_art19_excused_asks_recipients` (Q24)
- `fixture_extension_unsure`
- `fixture_extension_three_months_from_receipt`
- `fixture_holiday_shift_2026_11_30`
- `fixture_duplicate_key`
- `fixture_string_key_unknown`
- `fixture_not_a_list`
- `fixture_request_type_absent_common_exception_met` (completion test)

### 8.6 Package facade

The four facade predicates of section 5, delegating to the slice.

## 9 Tests (seven modes, v2 manifest)

1. **load**: every module loads; exports match this signature.
2. **unit**: per-rule tests of each engagement point, exception, suspension, period and calendar example.
3. **fixture**: expected answers for every fixture and each of the three queries plus the input check.
4. **property**: totality and determinism, through `findall` and `length(Answers, 1)` for every fixture and query; missing-key coverage; citation completeness.
5. **boundary**: month-end clipping and leap years (1900 not leap, 2000 leap, 2028 leap). The extended period from 31 January and 30 November. A year carry from 31 December. Weekday oracle checked against `library(datetime)` `weekday/2` on `date/4`.
6. **negative**: each `test(Name, fail)` paired with a positive test over the same case. Includes: string keys, Python-style booleans, `unsure` given for a crisp key, an outside fact given as a bare atom, and an unreal date such as 2026-02-30.
7. **what_if**: for each of `request_manifestly_unfounded_or_excessive`, `identity_confirmed`, `extension_claimed` and `public_holidays`, flipping the key changes the status or deadline as the rules predict. Checked with `diff_checklists/3`.
