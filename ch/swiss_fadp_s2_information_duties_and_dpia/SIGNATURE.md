# SIGNATURE — ch/swiss_fadp_s2_information_duties_and_dpia

## Public query surface (summary)

The facade headline is the Swiss duty to inform (obligation surfacing, #14):
`decide_swiss_fadp_s2_information_duties_and_dpia(PROFILE, swiss_fadp_s2_information_duties_and_dpia_verdict(STATUS, CITATIONS))` and `swiss_fadp_s2_information_duties_and_dpia_status(PROFILE, STATUS)`.

STATUS is one of these, replacing the placeholder `{ required, permitted, not_applicable }`:
- `information_required`
- `information_not_required`
- `information_may_be_restricted_deferred_or_omitted`
- a status compound `input_problems(PROBLEMS)`, `indeterminate([KEY])` or `needs_legal_review(open_textured(KEY, cite(CITE)), [inputs_relied_on(PAIRS)])`

The twelve contract queries (A)-(L) and the input check (M) are exported unchanged by name and arity.

Totality and determinism: every public predicate yields EXACTLY ONE solution for every input term, and never fails or raises. This is achieved by mutually exclusive clauses with the ground verdict folded into the head (C17), and no `!`, `->` or `*->`. Every result-producing collection is `findall` + `sort` inside the kernel engine, never exposed as multiple solutions.

No figure is imported or declared: the order has no threshold, amount, period or date (reading (20)). `parameters.clausal` therefore holds no `constant_value/2` and only a comment stating why.

## Verdict / result atoms

- Swiss duty to inform: `information_required`, `information_not_required`, `information_may_be_restricted_deferred_or_omitted`
- Minimum item: `information_item_required`, `information_item_not_required`
- Automated decision information (Swiss and EU): `automated_decision_information_required`, `automated_decision_information_not_required`
- Review: `view_and_review_rights_apply`, `view_and_review_rights_do_not_apply`
- Marking: `decision_marking_required`, `decision_marking_not_required`
- Impact assessment: `impact_assessment_required`, `impact_assessment_not_required`, `impact_assessment_may_be_omitted` (the last is Swiss only)
- EU duty to inform: `information_required`, `information_not_required`
- Comparison DIFFERENCE: `same`, `differs`
- Status constructors (exact functor/arity): `indeterminate/1`, `needs_legal_review/2`, `open_textured/2`, `inputs_relied_on/1`, `provenance/2` (optional trailing element, unscored, not produced by default), `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`. The bare atom `indeterminate` is never written.
- Item atoms (input type `information_item`), in order: `identity_and_contact_details_of_controller`, `processing_purpose`, `recipients_or_categories_of_recipients`, `categories_of_personal_data_processed`, `state_or_international_body`, `safeguards_or_exception_relied_on`.

## Profile keys (root_exports / input_contract order; no numbers, no dates)

The contract has forty-two keys: J = judgement (true / false / unsure), C = crisp (true / false).

1. controller_is_federal_body C
2. personal_data_collected_from_data_subject C
3. data_subject_already_has_information J
4. processing_provided_for_by_law J
5. controller_bound_by_statutory_secrecy J
6. article_27_conditions_met J
7. information_impossible_or_requires_disproportionate_effort J
8. overriding_third_party_interests_require_restriction J
9. information_defeats_purpose_of_processing J
10. overriding_controller_interests_require_restriction J
11. controller_discloses_personal_data_to_third_parties C
12. overriding_public_interests_require_restriction J
13. information_may_endanger_investigation_or_proceedings J
14. personal_data_disclosed_to_recipients C
15. personal_data_disclosed_abroad C
16. disclosure_abroad_relies_on_safeguards_or_exception C
17. decision_based_solely_on_automated_processing J
18. decision_has_legal_consequence_or_significantly_impairs_data_subject J
19. decision_directly_related_to_contract_with_data_subject J
20. data_subject_request_granted C
21. data_subject_explicitly_consented_to_automated_decision J
22. data_subject_need_not_be_heard_before_decision J
23. processing_may_entail_high_risk_to_personality_or_fundamental_rights J
24. large_scale_processing_of_sensitive_personal_data J
25. systematic_large_scale_monitoring_of_public_areas J
26. controller_legally_obliged_to_process_data J
27. system_product_or_service_certified_for_intended_use J
28. controller_complies_with_code_of_conduct J
29. code_of_conduct_based_on_impact_assessment J
30. code_of_conduct_provides_protective_measures J
31. code_of_conduct_submitted_to_commissioner C
32. eu_data_subject_already_has_information J
33. eu_information_impossible_disproportionate_or_seriously_impairing J
34. eu_obtaining_or_disclosure_expressly_laid_down_by_law J
35. eu_personal_data_confidential_under_professional_secrecy J
36. eu_decision_based_solely_on_automated_processing J
37. eu_decision_has_legal_or_similarly_significant_effects J
38. eu_processing_likely_to_result_in_high_risk J
39. eu_systematic_extensive_evaluation_with_significant_automated_decisions J
40. eu_large_scale_processing_of_special_categories_or_criminal_data J
41. eu_systematic_large_scale_monitoring_of_publicly_accessible_area J
42. eu_article_35_10_exemption_applies J

Read only with `profile_get/3` (presence first via `profile_has/2` / `profile_lacks/2`, then value). Keys are bare atoms.

## Citation-key atoms (canonical lexicon, `_lexicon/citations.yaml`; never shortened)

Swiss:
- `ch_fadp_art_19_1`, `ch_fadp_art_19_2`, `ch_fadp_art_19_2_a`, `ch_fadp_art_19_2_b`, `ch_fadp_art_19_2_c`, `ch_fadp_art_19_3`, `ch_fadp_art_19_4`
- `ch_fadp_art_20_1`, `ch_fadp_art_20_1_a`, `ch_fadp_art_20_1_b`, `ch_fadp_art_20_1_c`, `ch_fadp_art_20_1_d`
- `ch_fadp_art_20_2`, `ch_fadp_art_20_2_a`, `ch_fadp_art_20_2_b`
- `ch_fadp_art_20_3`, `ch_fadp_art_20_3_a`, `ch_fadp_art_20_3_b`, `ch_fadp_art_20_3_c`, `ch_fadp_art_20_3_c_1`, `ch_fadp_art_20_3_c_2`, `ch_fadp_art_20_3_d`, `ch_fadp_art_20_3_d_1`, `ch_fadp_art_20_3_d_2`, `ch_fadp_art_20_4`
- `ch_fadp_art_21_1`, `ch_fadp_art_21_2`, `ch_fadp_art_21_3`, `ch_fadp_art_21_3_a`, `ch_fadp_art_21_3_b`, `ch_fadp_art_21_4`
- `ch_fadp_art_22_1`, `ch_fadp_art_22_2`, `ch_fadp_art_22_2_a`, `ch_fadp_art_22_2_b`, `ch_fadp_art_22_4`, `ch_fadp_art_22_5`, `ch_fadp_art_22_5_a`, `ch_fadp_art_22_5_b`, `ch_fadp_art_22_5_c`

EU:
- `eu_reg_2016_679_art_13_1`, `eu_reg_2016_679_art_13_2`, `eu_reg_2016_679_art_13_2_f`, `eu_reg_2016_679_art_13_4`
- `eu_reg_2016_679_art_14_1`, `eu_reg_2016_679_art_14_2`, `eu_reg_2016_679_art_14_2_g`, `eu_reg_2016_679_art_14_5`, `eu_reg_2016_679_art_14_5_a`, `eu_reg_2016_679_art_14_5_b`, `eu_reg_2016_679_art_14_5_c`, `eu_reg_2016_679_art_14_5_d`
- `eu_reg_2016_679_art_22_1`
- `eu_reg_2016_679_art_35_1`, `eu_reg_2016_679_art_35_3`, `eu_reg_2016_679_art_35_3_a`, `eu_reg_2016_679_art_35_3_b`, `eu_reg_2016_679_art_35_3_c`, `eu_reg_2016_679_art_35_10`

`citations.clausal` declares each atom once with its unit id (for example `ch-fadp-sr-235-1-2025-07-07#art_20/para_3/lbl_c/lbl_2`, `02016R0679-20160504#point_014.005_b`), its source file sha256, and the verbatim pinned text. Deferred units (art_19/para_5, art_22/para_3, GDPR Art 22(2)-(4)) are recorded as `deferred_unit/2` facts and are never cited by an answer.

## Public predicates (one line each)

- `swiss_information_duty(Profile, Result, Citations)`: Swiss duty to inform, the exceptions, and the restriction permission (limbs 1-3) + DSG Art 19(1), 20(1)-(4).
- `swiss_minimum_information_item(Profile, Item, Result, Citations)`: whether ITEM is in the Swiss minimum (limbs 4-5) + DSG Art 19(2)-(4).
- `swiss_automated_decision_information(Profile, Result, Citations)`: duty to inform of an automated individual decision (limbs 6-7) + DSG Art 21(1), (3).
- `swiss_automated_decision_review(Profile, Result, Citations)`: point-of-view and human-review rights (limbs 8-9) + DSG Art 21(1)-(4).
- `swiss_automated_decision_marking(Profile, Result, Citations)`: federal-body marking (limbs 10-11) + DSG Art 21(1), (4).
- `swiss_impact_assessment(Profile, Result, Citations)`: Swiss impact assessment (limbs 12-15) + DSG Art 22(1), (2), (4), (5).
- `eu_information_duty(Profile, Result, Citations)`: EU duty to inform (limbs 16-17) + GDPR Art 13(1), (4), 14(1), (5).
- `eu_automated_decision_information(Profile, Result, Citations)`: EU automated-decision information (limbs 18-19) + GDPR Art 13(2)(f), 14(2)(g), 22(1).
- `eu_impact_assessment(Profile, Result, Citations)`: EU impact assessment (limbs 20-21) + GDPR Art 35(1), (3), (10).
- `compare_swiss_eu_information_duty(Profile, SwissResult, EuResult, Difference, ChangedBy)`: comparison #5 (limbs 22-25) + DSG Arts 19, 20; GDPR Arts 13, 14.
- `compare_swiss_eu_automated_decision_information(Profile, SwissResult, EuResult, Difference, ChangedBy)`: comparison #5 (limbs 26-29) + DSG Art 21; GDPR Arts 13(2)(f), 14(2)(g), 22(1).
- `compare_swiss_eu_impact_assessment(Profile, SwissResult, EuResult, Difference, ChangedBy)`: comparison #5 (limbs 30-33) + DSG Art 22; GDPR Art 35.
- `swiss_fadp_s2_information_duties_and_dpia_input_problems(Profile, Problems)`: THE INPUT CHECK, returning the bare list of `duplicate_key` / `wrong_type` / `unknown_key` terms. Contract-driven, no citation.
- `decide_swiss_fadp_s2_information_duties_and_dpia(Profile, Verdict)`: Verdict = `swiss_fadp_s2_information_duties_and_dpia_verdict(Result, Citations)` from `swiss_information_duty/3` + DSG Art 19(1), 20.
- `swiss_fadp_s2_information_duties_and_dpia_status(Profile, Status)`: the Result of `swiss_information_duty/3` alone + DSG Art 19(1), 20.
- `swiss_fadp_s2_information_duties_and_dpia_checklist(Profile, Checklist)`: justification #7. A flat list of `item(DeterminationId, Result, Citations)` (formalize_lib `item/3`) in this fixed order: `swiss_information_duty`, `swiss_automated_decision_information`, `swiss_automated_decision_review`, `swiss_automated_decision_marking`, `swiss_impact_assessment`, `eu_information_duty`, `eu_automated_decision_information`, `eu_impact_assessment`. Each Citations is the `cite(...)` list of that answer, or [] with the status compound when not final. Built with formalize_lib `eval_requirements/4` over a `determination_requirement/4` closure (RequirementId first). One solution.
- `swiss_fadp_s2_information_duties_and_dpia_what_if(Profile, Key, Value, Verdict)`: re-decides the headline with `attribute(Key, Value)` set, via kit.query_combinators `what_if/5` with closure `decide_swiss_fadp_s2_information_duties_and_dpia`. Input problems of the edited profile surface in Verdict. One solution.
- `swiss_fadp_s2_information_duties_and_dpia_obligations(Profile, Obligations)`: obligation surfacing #14. A flat list of `obligation(ResultAtom, Citations)` for each determination whose final Result is a duty: `information_required`, `automated_decision_information_required`, `view_and_review_rights_apply`, `decision_marking_required`, `impact_assessment_required` (Swiss only). It includes the Swiss minimum items as `obligation(information_item(Item), Citations)` when `swiss_information_duty` is `information_required` or `information_may_be_restricted_deferred_or_omitted` and the item is `information_item_required`. Not-final answers are listed as `open(DeterminationId, StatusCompound)`. Ordered as in the checklist. One solution. This is a NEW name, not one of the scored contract positions, so it may carry structured records.
- Fixtures: `swiss_fadp_s2_information_duties_and_dpia_fixture(Name, Profile)` and `swiss_fadp_s2_information_duties_and_dpia_expected(Name, Query, ExpectedAnswerTuple)` (see Fixtures below).

## Planned reuse (manifest `uses:`)

- formalize_lib: `profile_get/3`, `profile_has/2`, `profile_lacks/2`, `profile_set/3`, `memberd/2`, `not_member/2`, `eval_requirements/4`, `item/3`, `attribute/2`. `check_tri/4` is NOT used for the status rule: answers are status compounds of this contract, not checklist statuses. No clone of `check_tri` / `check_tri_neg` / `ratio_bps` is written (C14, C15).
- kit.query_combinators: `what_if/5` (facade what-if), `diff_sets/5` (tests comparing citation sets).
- validate_props: `run_props/1`, `prop_totality/3`, `prop_determinism/3`, `prop_citation_complete/3`, `prop_missing_key_coverage/3`, `bad_citation/1` (tests).
- Not used: kit.deadline_lib (no timing read), kit.compliance_lib (the permission atoms are contract atoms, not the modality lattice), date_time, currency_vocab, country.
- Family backbone (`_common`, deontic): none required. The status engine is local in kernel.clausal and flagged in NOTES.md as a kit candidate.

## kernel.clausal — the shared floor (ONLY what more than one layer needs)

- `contract_key(Position, Key, Type)`: the forty-two keys in order, Type in `judgement` / `crisp`. Used by the input check, the PAIRS rule and the root order of NEEDED.
- `information_item_atom(Item)`: the six item atoms, in order.
- `swiss_fadp_s2_information_duties_and_dpia_input_problems/2` (exported through the facade). The algorithm:
  1. If Profile is not a proper list of ground-functor `attribute/2` elements (an unbound list, a partial list, an unbound element, or a non-attribute element), the result is `[wrong_type(profile)]`.
  2. Otherwise, for each contract key in order: `duplicate_key(K)` if it occurs twice or more (values not read); else `wrong_type(K)` if it occurs once with a value outside its type (unbound included; tested with `var/1` first, then `memberd` against the type's atoms).
  3. Then `unknown_key(K)` for each non-contract key (non-atoms and variables included, kept as given), in first-occurrence order, deduplicated by `==` (not unification).
  4. The check never fails and never raises.
- The status engine, generic over a closure `Evaluate(Assignment, Result)`, which takes a list of `Key-Bool` pairs covering the query's read keys:
  - `open_keys(Profile, ReadKeys, Absent, Unsure)`.
  - `settled_result(Profile, ReadKeys, Evaluate, Result)`.
  - `can_still_change(Profile, ReadKeys, Evaluate, Key)`.
  - `needed_keys/5`.
  - `behind/6`, exactly the definition of THE STATUS RULE (K behind L iff K can change with L added one way but not the other, and L can change with K added true and with K added false).
  - `status_answer(Profile, Query, ReadKeys, Evaluate, Result)`, which gives the final atom or `indeterminate([K])` or `needs_legal_review(open_textured(K, cite(C)), [inputs_relied_on(Pairs)])`.
  - Implementation: split-on-demand. A local three-valued evaluator of the query formula over the partial assignment (true / false / open). A key is only split when that evaluator answers open. A pair formula (the result with K true versus the result with K false) is used for `can_still_change`. Exact, since the three-valued evaluation is sound, and it avoids 2^17 enumeration on the comparison profiles. A brute-force reference implementation lives in tests only (for the oracle mode).
- `pairs_for(Profile, ReadKeys, Pairs)`: the PAIRS rule (present keys, root order, the unsure ones included).
- Nothing else is shared. Result citations and referral rows belong to the slice.

## Slice — swiss_fadp_s2_information_duties_and_dpia.clausal

The only determination slice. It is self-contained for every legal concept of the order.

### VALUE facts it owns

There is no numeric value, no threshold, no period and no date. It owns these tables:

- `query_reads(Query, ReadKeys)` for the twelve queries, each in root order exactly as THE LIMBS list them.
- `result_citations(Query, Result, CitationList)`: the fixed list per final RESULT.
  - swiss_information_duty:
    - `information_not_required` gives [19_1, 20_1, 20_1_a, 20_1_b, 20_1_c, 20_1_d, 20_2, 20_2_a, 20_2_b].
    - `information_may_be_restricted_deferred_or_omitted` gives [19_1, 20_3, 20_3_a, 20_3_b, 20_3_c, 20_3_c_1, 20_3_c_2, 20_3_d, 20_3_d_1, 20_3_d_2, 20_4].
    - `information_required` gives [19_1, 20_1, 20_2, 20_3].
  - Automated decision information, both results: [21_1, 21_3, 21_3_a, 21_3_b].
  - Review, both results: [21_1, 21_2, 21_3, 21_3_a, 21_3_b, 21_4].
  - Marking, both results: [21_1, 21_4].
  - Swiss impact assessment:
    - `impact_assessment_not_required` gives [22_1, 22_2, 22_2_a, 22_2_b, 22_4].
    - `impact_assessment_may_be_omitted` gives [22_1, 22_5, 22_5_a, 22_5_b, 22_5_c].
    - `impact_assessment_required` gives [22_1, 22_2, 22_4, 22_5].
  - EU duty to inform, both results: [13_1, 13_4, 14_1, 14_5, 14_5_a, 14_5_b, 14_5_c, 14_5_d].
  - EU automated decision information, both results: [13_2, 13_2_f, 13_4, 14_2, 14_2_g, 14_5, 14_5_a, 14_5_b, 14_5_c, 14_5_d, 22_1].
  - EU impact assessment, both results: [35_1, 35_3, 35_3_a, 35_3_b, 35_3_c, 35_10].
  - Above, the short numbers stand for the full `ch_fadp_art_` / `eu_reg_2016_679_art_` atoms. The file writes them in full.
- `item_citations(Item, CitationList)`:
  - `identity_and_contact_details_of_controller`: [ch_fadp_art_19_2, ch_fadp_art_19_2_a]
  - `processing_purpose`: [ch_fadp_art_19_2, ch_fadp_art_19_2_b]
  - `recipients_or_categories_of_recipients`: [ch_fadp_art_19_2, ch_fadp_art_19_2_c]
  - `categories_of_personal_data_processed`: [ch_fadp_art_19_3]
  - `state_or_international_body`: [ch_fadp_art_19_4]
  - `safeguards_or_exception_relied_on`: [ch_fadp_art_19_4]
- `item_reads(Item, Keys)`: [] / [] / [personal_data_disclosed_to_recipients] / [personal_data_collected_from_data_subject] / [personal_data_disclosed_abroad] / [personal_data_disclosed_abroad, disclosure_abroad_relies_on_safeguards_or_exception].
- `changed_by(Comparison, CitationList)`:
  - information duty: [ch_fadp_art_19_1, ch_fadp_art_20_1, ch_fadp_art_20_2, ch_fadp_art_20_3, eu_reg_2016_679_art_13_4, eu_reg_2016_679_art_14_5]
  - automated decision information: [ch_fadp_art_21_1, ch_fadp_art_21_3, eu_reg_2016_679_art_13_2_f, eu_reg_2016_679_art_14_2_g, eu_reg_2016_679_art_13_4, eu_reg_2016_679_art_14_5, eu_reg_2016_679_art_22_1]
  - impact assessment: [ch_fadp_art_22_1, ch_fadp_art_22_2, ch_fadp_art_22_4, ch_fadp_art_22_5, eu_reg_2016_679_art_35_1, eu_reg_2016_679_art_35_3, eu_reg_2016_679_art_35_10]
- `referral_row(Query, JudgementKey, Citation)`: one row per judgement key each query reads (comparisons have their own rows, with the same citations). Each row's `inputs` = `query_reads/2` of that query. Citation by key:
  - data_subject_already_has_information: ch_fadp_art_20_1_a
  - processing_provided_for_by_law: ch_fadp_art_20_1_b
  - controller_bound_by_statutory_secrecy: ch_fadp_art_20_1_c
  - article_27_conditions_met: ch_fadp_art_20_1_d
  - information_impossible_or_requires_disproportionate_effort: ch_fadp_art_20_2
  - overriding_third_party_interests_require_restriction: ch_fadp_art_20_3_a
  - information_defeats_purpose_of_processing: ch_fadp_art_20_3_b
  - overriding_controller_interests_require_restriction: ch_fadp_art_20_3_c_1
  - overriding_public_interests_require_restriction: ch_fadp_art_20_3_d_1
  - information_may_endanger_investigation_or_proceedings: ch_fadp_art_20_3_d_2
  - decision_based_solely_on_automated_processing: ch_fadp_art_21_1
  - decision_has_legal_consequence_or_significantly_impairs_data_subject: ch_fadp_art_21_1
  - decision_directly_related_to_contract_with_data_subject: ch_fadp_art_21_3_a
  - data_subject_explicitly_consented_to_automated_decision: ch_fadp_art_21_3_b
  - data_subject_need_not_be_heard_before_decision: ch_fadp_art_21_4
  - processing_may_entail_high_risk_to_personality_or_fundamental_rights: ch_fadp_art_22_1
  - large_scale_processing_of_sensitive_personal_data: ch_fadp_art_22_2_a
  - systematic_large_scale_monitoring_of_public_areas: ch_fadp_art_22_2_b
  - controller_legally_obliged_to_process_data: ch_fadp_art_22_4
  - system_product_or_service_certified_for_intended_use: ch_fadp_art_22_5
  - controller_complies_with_code_of_conduct: ch_fadp_art_22_5
  - code_of_conduct_based_on_impact_assessment: ch_fadp_art_22_5_a
  - code_of_conduct_provides_protective_measures: ch_fadp_art_22_5_b
  - eu_data_subject_already_has_information: eu_reg_2016_679_art_13_4
  - eu_information_impossible_disproportionate_or_seriously_impairing: eu_reg_2016_679_art_14_5_b
  - eu_obtaining_or_disclosure_expressly_laid_down_by_law: eu_reg_2016_679_art_14_5_c
  - eu_personal_data_confidential_under_professional_secrecy: eu_reg_2016_679_art_14_5_d
  - eu_decision_based_solely_on_automated_processing: eu_reg_2016_679_art_22_1
  - eu_decision_has_legal_or_similarly_significant_effects: eu_reg_2016_679_art_22_1
  - eu_processing_likely_to_result_in_high_risk: eu_reg_2016_679_art_35_1
  - eu_systematic_extensive_evaluation_with_significant_automated_decisions: eu_reg_2016_679_art_35_3_a
  - eu_large_scale_processing_of_special_categories_or_criminal_data: eu_reg_2016_679_art_35_3_b
  - eu_systematic_large_scale_monitoring_of_publicly_accessible_area: eu_reg_2016_679_art_35_3_c
  - eu_article_35_10_exemption_applies: eu_reg_2016_679_art_35_10

### Rules / requirements (completion evaluators; one clause per disjoint route, verdict in head)

- `swiss_exception_holds(Assignment, Bool)`: 20(1)(a) OR 20(1)(b) OR (private AND secrecy) OR 20(1)(d) OR (not collected AND impossible-or-disproportionate).
- `swiss_restriction_case_holds(Assignment, Bool)`: 20(3)(a) OR (b) OR (private AND controller interests AND NOT discloses-to-third-parties) OR (federal AND (public interests OR endangers investigation)).
- `swiss_information_duty_of_completion`: an exception gives `information_not_required`; else a restriction case gives `information_may_be_restricted_deferred_or_omitted`; else `information_required`.
- `minimum_item_of_completion(Item, Assignment, Result)`: per the item table. The safeguards item is required only when abroad AND relies.
- `automated_individual_decision` = solely automated AND legal-or-significant. `article_21_3_exception` = (contract-related AND request granted) OR explicit consent.
- Automated decision information: decision AND NOT exception gives required, else not required.
- Review: decision AND NOT exception AND NOT (federal AND need-not-be-heard) gives apply, else do not apply.
- Marking: federal AND decision gives required, else not required. The Art 21(3) exceptions are not read.
- Swiss impact assessment:
  1. No high risk (all three false) gives not required.
  2. Else private AND legally obliged gives not required.
  3. Else private AND (certified OR all four code keys true) gives may be omitted.
  4. Else required.
- `eu_exception_holds`: (collected AND eu-already-has) OR (not collected AND any of the four Art 14(5) keys).
- EU duty to inform: an exception gives not required, else required.
- EU automated decision information: solely automated AND significant effects AND NOT exception gives required, else not required.
- EU impact assessment: (all four high-risk keys false) OR the Art 35(10) exemption gives not required, else required.
- Each query runs:
  1. The input check first (input_problems with [] citations; for the minimum item, `wrong_type(information_item)` is appended when ITEM is not one of the six or is unbound).
  2. Then kernel `status_answer/5` with the slice's evaluator closure.
  3. The final atom is paired with `result_citations/3` (or `item_citations/2`). Not-final answers get [].
- Comparisons:
  - SWISS_RESULT and EU_RESULT are the side queries' own answers, unchanged (their referral PAIRS included).
  - DIFFERENCE uses the joint evaluator `same` / `differs` over the union of read keys, through the same status engine, with the comparison's own referral rows.
  - CHANGED_BY comes from `changed_by/2` only when DIFFERENCE is `differs`, else [].
  - With input problems, the three answer positions are `input_problems(P)` and CHANGED_BY is [].

### Verdict atoms owned

All result atoms listed above. The facade headline status set is the three Swiss duty-to-inform atoms plus the status compounds.

### Shared with another slice

None. There is no other determination slice. The status engine, contract key table and input check sit in kernel.clausal only because the facade, queries.clausal and the tests also call them.

### Tests (seven modes, under tests/)

1. load
2. per-rule unit tests: each limb with a positive and a paired negative over the same case
3. fixtures: expected answers below
4. totality / determinism over generated profiles: exactly one solution per query, via validate_props
5. citation completeness: every cited atom is in the vocabulary, and the same RESULT always gives the same citations
6. status-rule oracle: the kernel split-on-demand engine is compared to a brute-force enumeration on random partial profiles, including the behind rule
7. input-check edge cases: unbound profile, partial list, non-attribute element, unbound key, unbound value, duplicate with equal values, unknown repeated

## Fixtures (planned worked cases; expected answers)

- F1 empty profile []: `swiss_information_duty` gives `indeterminate([data_subject_already_has_information])`. `controller_is_federal_body` and `personal_data_collected_from_data_subject` are behind it: each matters only when no other exception settles the answer.
- F2 [attribute(data_subject_already_has_information, true)]: `swiss_information_duty` gives `information_not_required` with the nine exception citations, whatever the other keys are.
- F3 a private controller, data collected from the data subject, every Art 20(1) / (2) key false, `overriding_third_party_interests_require_restriction` true, the other restriction keys false, discloses false: `information_may_be_restricted_deferred_or_omitted` with the eleven Art 20(3) / (4) citations.
- F4 as F3 but `data_subject_already_has_information` unsure and every restriction key false: `needs_legal_review(open_textured(data_subject_already_has_information, cite(ch_fadp_art_20_1_a)), [inputs_relied_on(PAIRS)])`, where PAIRS are the thirteen present keys in root order, `data_subject_already_has_information-unsure` included. CITATIONS [].
- F5 the minimum item `safeguards_or_exception_relied_on` with only `attribute(disclosure_abroad_relies_on_safeguards_or_exception, false)`: `information_item_not_required`, [cite(ch_fadp_art_19_4)].
- F6 the minimum item `state_or_international_body` on []: `indeterminate([personal_data_disclosed_abroad])`.
- F7 the minimum item `unknown_item_atom` on []: `input_problems([wrong_type(information_item)])`, [].
- F8 [attribute(controller_is_federal_body, maybe)]: every query gives `input_problems([wrong_type(controller_is_federal_body)])`, and the input check gives `[wrong_type(controller_is_federal_body)]`.
- F9 [attribute(controller_is_federal_body, true), attribute(controller_is_federal_body, true), attribute(colour, red)]: the input check gives [duplicate_key(controller_is_federal_body), unknown_key(colour)].
- F10 a federal body, solely automated true, significant true, explicit consent true: marking gives `decision_marking_required`. Automated decision information gives `automated_decision_information_not_required`. Review gives `view_and_review_rights_do_not_apply`.
- F11 [attribute(eu_article_35_10_exemption_applies, true)]: `eu_impact_assessment` gives `impact_assessment_not_required`.
- F12 the three Swiss high-risk keys false: `swiss_impact_assessment` gives `impact_assessment_not_required` with the Art 22(1), (2), (2)(a), (2)(b), (4) citations.
- F13 a private controller, `large_scale_processing_of_sensitive_personal_data` true, `controller_legally_obliged_to_process_data` false, `system_product_or_service_certified_for_intended_use` true; the EU high-risk keys false and the Art 35(10) key false: the impact assessment comparison gives Swiss `impact_assessment_may_be_omitted`, EU `impact_assessment_not_required`, `differs`, and the impact assessment CHANGED_BY list.
- F14 data collected from the data subject, `data_subject_already_has_information` true, `eu_data_subject_already_has_information` true: the duty-to-inform comparison gives `information_not_required`, `information_not_required`, `same`, [].
