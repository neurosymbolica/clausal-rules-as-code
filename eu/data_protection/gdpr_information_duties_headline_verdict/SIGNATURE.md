# SIGNATURE — eu/data_protection/gdpr_information_duties_headline_verdict

The public surface is the facade, the headline and exemption relations, the outside-facts record and the input check. All are authored as determination slices over a shared kernel. Answers are total and deterministic: exactly one solution per query, with disjoint clauses and guarded `once/1` defeaters, cut-free. The profile is an attribute list read only with `profile_get/3`.

## Verdict STATUS atoms (replace the scaffold placeholders)

- Headline verdict: `eligible`, `ineligible`.
- Exemption: `impossible_or_disproportionate_effort`, `law_lays_down_obtaining_or_disclosure`, `professional_secrecy_obligation`, `none`.
- Non-final: `indeterminate(MissingKeys)`, `needs_legal_review(open_textured(Key, cite(Citation)), [inputs_relied_on(Pairs)])`, `input_problems(Problems)`.
- Internal stage atoms: `timely`, `late`, `not_applicable`, `no_item_missing`.
- `true` and `false` are never pinned in `verdict_vocabulary` or `root_exports`. `unsure` is root-exported.

## Profile keys (26, root-exported, in this order)

1. `personal_data_collected_from_data_subject` (crisp)
2. `items_provided` (list)
3. `items_data_subject_already_has` (list)
4. `data_protection_officer_designated` (crisp)
5. `processing_based_on_legitimate_interests` (crisp)
6. `recipients_exist` (crisp)
7. `transfer_intended` (crisp)
8. `processing_based_on_consent` (crisp)
9. `automated_decision_making_under_article_22` (judgement)
10. `obtaining_date` (date)
11. `provision_date` (date)
12. `data_used_for_communication_with_data_subject` (crisp)
13. `first_communication_date` (date)
14. `disclosure_to_another_recipient_envisaged` (crisp)
15. `first_disclosure_date` (date)
16. `provided_within_reasonable_period` (judgement)
17. `provision_impossible_or_disproportionate_effort` (judgement)
18. `protective_measures_taken` (crisp)
19. `obtaining_or_disclosure_laid_down_by_law` (outside fact)
20. `professional_secrecy_obligation_by_law` (outside fact)
21. `further_processing_for_another_purpose_intended` (crisp)
22. `further_processing_start_date` (date)
23. `further_processing_information_date` (date)
24. `further_processing_items_provided` (list)
25. `paragraph_2_information_relevant_to_further_processing` (judgement)
26. `public_holidays` (outside fact)

Value types:

- Crisp keys are the atom `true` or `false`.
- Judgement keys are `true`, `false` or `unsure`.
- List keys are lists of item atoms. `[]` means none.
- Date keys are ground `date(Year, Month, Day)` integer terms of a real calendar day.
- Outside-fact keys are `attested(Value, attestation(By, At, Reason, Evidence))`. Value is `true` or `false`, or for `public_holidays` a list of ground dates. `Evidence` is `url(Url, RetrievedAt)`, `document(UploadId, Sha256)` or `none`.
- Absent means not supplied.
- There are no numeric keys, so no unit suffix applies.

## Item atoms (root-exported, in checklist order)

1. `controller_identity_and_contact_details`
2. `data_protection_officer_contact_details`
3. `purposes_and_legal_basis`
4. `legitimate_interests`
5. `recipients_or_categories_of_recipients`
6. `third_country_transfer_information`
7. `categories_of_personal_data`
8. `storage_period_or_criteria`
9. `data_subject_rights`
10. `right_to_withdraw_consent`
11. `right_to_lodge_complaint`
12. `statutory_or_contractual_requirement`
13. `source_of_personal_data`
14. `automated_decision_making_information`
15. `other_purpose_information`

## Citation-key atoms

- `eu_reg_2016_679_art_13_1`
- `eu_reg_2016_679_art_13_1_a` to `eu_reg_2016_679_art_13_1_f`
- `eu_reg_2016_679_art_13_2_a` to `eu_reg_2016_679_art_13_2_f`
- `eu_reg_2016_679_art_13_3`
- `eu_reg_2016_679_art_13_4`
- `eu_reg_2016_679_art_14_1`
- `eu_reg_2016_679_art_14_1_a` to `eu_reg_2016_679_art_14_1_f`
- `eu_reg_2016_679_art_14_2_a` to `eu_reg_2016_679_art_14_2_g`
- `eu_reg_2016_679_art_14_3_a`, `eu_reg_2016_679_art_14_3_b`, `eu_reg_2016_679_art_14_3_c`
- `eu_reg_2016_679_art_14_4`
- `eu_reg_2016_679_art_14_5_a` to `eu_reg_2016_679_art_14_5_d`
- `eu_reg_1971_1182_art_3`

The definitions Art 4(1), (4), (7) and (9) never enter a CITES list.

## Public predicates

- `decide_information_duty_exemption(Profile, Decision)`: facade decision for the exemption slice, wrapping `information_duty_exemption/2`. Art 14(5)(b)-(d).
- `information_duty_exemption_status(Profile, Status)`: the status atom of the exemption (see the exemption slice). Art 14(5).
- `information_duty_exemption_checklist(Profile, Checklist)`: checklist items for (b), (c), (d) with `cite(...)`. Art 14(5)(b)-(d).
- `decide_information_duty_verdict(Profile, Decision)`: facade decision for the headline, wrapping `information_duty_verdict/3`. Query type #2, eligibility. Art 13, Art 14.
- `information_duty_verdict_status(Profile, Status)`: the status atom of the headline verdict. Art 13, Art 14.
- `information_duty_verdict_checklist(Profile, Checklist)`: a cited checklist of missing items and the timing and further-processing stages. It surfaces what the controller must still provide (query type #14, obligation surfacing) and the binding deadline (query type #15, deadline). Art 13(1)-(3), Art 14(1)-(4), Art 14(3).
- `gdpr_information_duties_headline_verdict_what_if(Profile, Key, Value, Result)`: compliance_check (#13). It overrides one key with `what_if/5` and re-decides the headline. Art 13, Art 14.
- `information_duty_verdict(Profile, Verdict, Cites)`: the headline, with a CITES list. Art 13(1), Art 14(1), Art 14(5)(b)-(d).
- `information_duty_exemption(Profile, Exemption)`: the exemption relation, with `none` on the Art 13 route. Art 14(5).
- `information_outside_facts(Profile, OutsideFacts)`: a list of three `outside_fact(Key, Attested | absent)` items. It gives `input_problems(Problems)` for a bad profile. Art 14(5)(c), Art 14(5)(d), Reg 1182/71 Art 3(4).
- `gdpr_information_duties_headline_verdict_input_problems(Profile, Problems)`: the input check. Problems is `[]` or a list of `duplicate_key(Key)`, `wrong_type(Key)` and `unknown_key(Key)`, plus `wrong_type(profile)` when the profile is not an attribute list.
- Fixtures (`fixtures`): named profiles covering both routes, every exemption, each unsure judgement, month-end and weekend deadline cases, the holiday-shift case, and the input-problem cases (unknown_key, wrong_type, duplicate_key, not a profile).
- Result constructors, exported and never queried: `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`, `indeterminate/1`, `needs_legal_review/2`, `open_textured/2`, `inputs_relied_on/1`, `provenance/2`, `outside_fact/2`, `attested/2`, `attestation/4`, `url/2`, `document/2`.

## kernel.clausal (shared floor)

The kernel holds only what both slices share:

- `gdpr_information_duties_headline_verdict_route(Profile, Route)`: art13 or art14, from key 1.
- `gdpr_information_duties_headline_verdict_attested_value(Profile, Key, Status)`: reads an outside fact as met, unmet or absent.
- The result-constructor declarations and the root-exported key and item atoms.
- The input check.

No thresholds or periods live in the kernel.

## Slice: information_duty_exemption.clausal

**Owns (value facts):**

- The exemption order: (b) effort, (c) law, (d) professional secrecy.
- The citation atoms `eu_reg_2016_679_art_14_5_b`, `_c`, `_d`.
- The reading that effort needs the judgement true AND `protective_measures_taken` true.
- The direction of the outside facts, which are BLOCKING: attested true is met, and attested false and absent are unmet.

**Rules and requirements:**

- On the Art 13 route, `none` and no exemption key is read.
- On the Art 14 route, evaluate all three disjuncts by strong Kleene. MET dominates OPEN, and the first MET in the order names the exemption.
- Only when none is MET:
  - key 17 absent gives `indeterminate([provision_impossible_or_disproportionate_effort])`.
  - key 17 true and key 18 absent gives `indeterminate([protective_measures_taken])`.
  - key 17 unsure gives `needs_legal_review(open_textured(provision_impossible_or_disproportionate_effort, cite(eu_reg_2016_679_art_14_5_b)), CONTEXT)`.
  - Otherwise `none`.

An absent key 19 or 20 is UNMET and never opens the exemption.

**Verdict atoms:** `impossible_or_disproportionate_effort`, `law_lays_down_obtaining_or_disclosure`, `professional_secrecy_obligation`, `none`, plus the non-final forms above.

**Shared predicates:** route and attested-value readers from the kernel only. The slice exposes `information_duty_exemption/2` so the verdict slice can import it.

## Slice: information_duty_verdict.clausal

**Owns (value facts):**

- The 15-item table, with one column per article (Art 13 point and Art 14 point) and the condition key per conditional item.
- The paragraph-2 item sets: Art 13 items 8, 9, 10, 11, 12, 14, and Art 14 items 4, 8, 9, 10, 11, 13, 14.
- The deadline arithmetic:
  - the one-month rule of Reg 1182/71 Art 3 with weekday computation by `library(datetime)`,
  - the earliest-of selection over limbs (a), (b), (c),
  - the tie order (a), (b), (c).
- The strict "prior to" comparison for further processing.

**Internal stages** (not public queries of this part):

- A: route.
- B: items owed. It gives the pure item order. An unsure key 9 gives needs_legal_review. Absent keys give `indeterminate` over keys 1, 4, 5, 6, 7, 8, 9.
- C: items missing. It gives `missing_item(Item, cite(Key))` terms or `[no_item_missing]`. Condition keys are read only for items not covered.
- D: deadline. On Art 13 it is the obtaining date. On Art 14 it is the earliest of the applicable dates. A flag false means its date is not read.
- E: basis atom.
- F: timing verdict. `late` when the provision date is after the deadline. On Art 14, when on time, key 16 decides.
- H: further-processing verdict, `not_applicable`, `eligible` or `ineligible`.

**Headline rules (I):**

- BASE is the Kleene AND of C, F and H.
- Stage one: BASE MET gives `eligible`, with the route-paragraph cite followed by H's cite when H is eligible. The exemption keys are not read.
- Stage two (Art 14 only): the exemption from the exemption slice. If it is not `none`, the verdict is `eligible` with cite `art_14_5_b`, `_c` or `_d`.
- Stage three (no exemption MET, BASE UNMET), in this precedence:
  - `indeterminate` if an exemption key was absent,
  - `needs_legal_review` if key 17 is unsure,
  - otherwise `ineligible`, with CITES in this order: missing-item cites, then the timing cite when late, then H's cite when ineligible, without duplicates.
- Stage four (BASE OPEN):
  - `indeterminate` over every absent key BASE read,
  - otherwise `needs_legal_review(open_textured(Key, Citation), Context)` for the first unsure judgement BASE read, in root_exports order.
- The PAIRS rule: Pairs are the present key-value pairs of the judgement keys the ending stage read, the unsure one included, in root_exports order. They may be followed by one unscored `provenance(Clause, Citations)`.
- Input problems come first on every relation.

**Verdict atoms:** `eligible`, `ineligible`, plus the non-final forms above.

**Shared predicates:** imports `information_duty_exemption/2` from the exemption slice. Everything else is local.

## Planned reuse (manifest `uses:`)

- `formalize_lib`: `profile_get/3`, `profile_has/2`, `profile_lacks/2`, `missing_keys/3`, `check_true/4`, `check_false/4`, `check_tri/4`, `or_status/2`, `and_status/2`, `collect_unknown/2`, `assess/6`, `eval_requirements/4`, `decide_labeled/3`, `memberd/2`, `not_member/2`, `first_applicable/2`, `int_min/3`, `int_max/3`.
- `library(datetime)`: `weekday/2`, `date_add/3`, `timedelta/3`, `days_between/3`.
- `kit/deadline_lib`: `month_last_day/3`, `next_day/2`, `date_on_or_before/2`. `deadline_months_after/3` is not used, because it counts from the day after the anchor, not the same date next month.
- `kit/query_combinators`: `what_if/5` for the what_if facade.
- `kit/compliance_lib`: the deny-overrides modality lattice, only if the compliance_check facade needs it.
- `validate_props`: `run_props/1`, `prop_totality/3`, `prop_determinism/3`, `prop_citation_complete/3`, `prop_boundary_coverage/2`, `prop_missing_key_coverage/3`, `declare_vacuous/1`.
- Unused: `currency_vocab`, `vat_category`, `country`, `rolling_window`.
