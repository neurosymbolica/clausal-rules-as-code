# SIGNATURE — eu/data_protection/gdpr_data_subject_rights_response_duties

Predicate prefix: gdpr_data_subject_rights_response_duties_. Layout is kept: kernel, citations, parameters, one determination slice, queries, fixtures, package facade.

## Verdict STATUS atoms (replace scaffold placeholders required / permitted / not_applicable)

Verdict term: gdpr_data_subject_request_verdict(COMPLY, BASIS, EXCEPTION, CONDITIONS, CITATIONS).

- COMPLY is one of: must_comply, need_not_comply, indeterminate(MissingKeys), needs_legal_review(Reason, Context), suspended(art12_6_identity_not_confirmed), input_problems(Problems).
- The bare atom indeterminate is never written.
- Reason is open_textured(Input, cite(Key)) or cross_reference_unresolved(cite(Citation), cite(Target)).
- Context is [resolution(cite(Target), not_attempted)] first, for cross_reference_unresolved only, then inputs_relied_on(Pairs).
- Problems are duplicate_key(Key), wrong_type(Key) or unknown_key(Key).
- BASIS: art15_1, art16_inaccurate_data, art16_incomplete_data, art17_1_a to art17_1_f, art18_1_a to art18_1_d, art20_1, art21_1, art21_2, art21_6, art22_1, none.
- EXCEPTION: art17_3_a to art17_3_e, art20_3_public_task, art20_4_rights_of_others, art21_1_compelling_legitimate_grounds, art21_1_legal_claims, art21_6_public_interest_task, art22_2_a, art22_2_b, art22_2_c, art12_5_manifestly_unfounded_or_excessive, art12_2_unable_to_identify, art23_legislative_restriction, none.
- CONDITIONS: [], [reasonable_fee_may_be_charged], or [human_intervention, express_point_of_view, contest_decision].
- Duty terms: respond_with_action_taken/2, inform_of_extension_with_reasons/2, inform_of_reasons_and_remedies/2, communicate_to_each_recipient/1, inform_data_subject_of_recipients/1, recipient_notification_excused/1, recipient_notification_not_applicable/1.
- Periods: first_period, extended_period.

## Profile keys (attribute list [attribute(Key, Value), ...], read only with profile_get/3; exactly 54 keys)

- Two atom keys: request_type (access, rectification, erasure, restriction, portability, objection, automated_decision; required) and objection_ground_claimed (art21_1, art21_2, art21_6; required only for objection).
- One date key: request_received_on, a ground date(Year, Month, Day), read only by request_response_deadline/2.
- Twenty-five crisp keys (true or false): extension_claimed, controller_demonstrates_unable_to_identify_data_subject, identity_confirmed, personal_data_inaccurate, consent_is_the_basis_of_processing, consent_withdrawn, other_legal_ground_for_processing_exists, objection_under_art21_1_made, objection_under_art21_2_made, collected_in_relation_to_information_society_services_offer, accuracy_contested_by_data_subject, data_subject_opposes_erasure, data_required_by_data_subject_for_legal_claims, verification_of_overriding_grounds_pending, personal_data_provided_by_data_subject, processing_based_on_consent_or_contract, processing_carried_out_by_automated_means, processing_based_on_art6_1_e_or_f, processing_for_direct_marketing, processing_for_research_or_statistics_pursuant_to_art89_1, data_subject_gave_explicit_consent, decision_based_on_special_categories, special_category_condition_and_safeguards_met_for_decision, personal_data_disclosed_to_recipients, data_subject_asks_who_the_recipients_are.
- Twenty-one judgement keys (true, false or unsure): extension_necessary_for_complexity_and_number, reasonable_doubts_about_identity, request_manifestly_unfounded_or_excessive, personal_data_incomplete_in_light_of_purposes, data_no_longer_necessary_for_purposes, overriding_legitimate_grounds_exist, personal_data_unlawfully_processed, processing_necessary_for_freedom_of_expression_and_information, processing_necessary_for_public_task_or_official_authority, processing_necessary_for_public_health_in_accordance_with_art9_2_h_and_i, processing_for_archiving_research_or_statistics_in_accordance_with_art89_1, erasure_would_render_impossible_or_seriously_impair_processing_objectives, processing_necessary_for_legal_claims, controller_no_longer_needs_data_for_processing_purposes, transmission_would_adversely_affect_rights_and_freedoms_of_others, objection_grounds_relate_to_particular_situation, controller_demonstrates_compelling_legitimate_grounds, decision_based_solely_on_automated_processing, decision_produces_legal_or_similarly_significant_effects, decision_necessary_for_contract_with_data_subject, recipient_notification_impossible_or_disproportionate_effort.
- Five outside facts, each attested(Value, attestation(By, At, Reason, Evidence)): erasure_required_by_union_or_member_state_law (enabling), processing_required_by_union_or_member_state_law (blocking), decision_authorised_by_union_or_member_state_law (blocking), legislative_restriction_applies_to_the_right (blocking), public_holidays (a list of ground dates; absent means no shift). Evidence is url(Url, RetrievedAt), document(UploadId, Sha256) or none.
- Defeater keys (absent is unmet): extension_claimed, controller_demonstrates_unable_to_identify_data_subject, reasonable_doubts_about_identity, request_manifestly_unfounded_or_excessive, every exception key, data_subject_asks_who_the_recipients_are, decision_based_on_special_categories. All other keys read by a limb are required.
- Argument names of the date helper (not profile keys): receipt_date, response_period.

## Citation-key atoms

- eu_reg_2016_679_art_12_2, eu_reg_2016_679_art_12_3, eu_reg_2016_679_art_12_4, eu_reg_2016_679_art_12_5, eu_reg_2016_679_art_12_6
- eu_reg_2016_679_art_15_1, eu_reg_2016_679_art_16, eu_reg_2016_679_art_17_1, eu_reg_2016_679_art_17_3, eu_reg_2016_679_art_18_1, eu_reg_2016_679_art_19
- eu_reg_2016_679_art_20_1, eu_reg_2016_679_art_20_3, eu_reg_2016_679_art_20_4
- eu_reg_2016_679_art_21_1, eu_reg_2016_679_art_21_2, eu_reg_2016_679_art_21_3, eu_reg_2016_679_art_21_6
- eu_reg_2016_679_art_22_1, eu_reg_2016_679_art_22_2, eu_reg_2016_679_art_22_3, eu_reg_2016_679_art_22_4
- eu_reg_2016_679_art_23_1
- eu_reg_1971_1182_art_3

The referrals table maps each judgement key to its cite(Key), per request type. The table lives in the slice. For example, the Art 17(3) judgements map to cite(eu_reg_2016_679_art_17_3), and identity_doubts_reasonable maps to cite(eu_reg_2016_679_art_12_6).

## Public predicates (one line each)

- request_response_deadline(Profile, Deadline): the Art 12(3) and 12(4) response deadline as an element-wise date(Y, M, D), with the Art 3(4) weekend and attested-holiday shift. It returns the non-final status when the decision or period is not final. Cites eu_reg_2016_679_art_12_3 and eu_reg_1971_1182_art_3.
- response_duties(Profile, Duties): a single list of duties (respond_with_action_taken, inform_of_extension_with_reasons, inform_of_reasons_and_remedies), or the status compound alone. Cites eu_reg_2016_679_art_12_3 and eu_reg_2016_679_art_12_4.
- recipient_notification(Profile, Duties): a single list of Art 19 duties, or the status compound alone. Cites eu_reg_2016_679_art_19.
- gdpr_data_subject_rights_response_duties_input_problems(Profile, Problems): input check. It reports duplicate_key, wrong_type and unknown_key in contract order, and [] for a well-formed profile.
- provenance(Clause, Citations): result constructor (never called as a query). It is an optional, unscored item that may follow the KEY-absent pair in the inputs_relied_on(Pairs) list of a needs_legal_review context, marking the deciding clause and the citation keys it rests on. Cites eu_reg_2016_679_art_17_1 (the enabling Art 17(1)(e) fact) and eu_reg_2016_679_art_12_3.
- decide_gdpr_data_subject_rights_response_duties(Profile, Verdict): facade over the internal decision (not one of the scored queries). It returns gdpr_data_subject_request_verdict(Comply, Basis, Exception, Conditions, Citations).
- gdpr_data_subject_rights_response_duties_status(Profile, Status): the COMPLY component of the verdict.
- gdpr_data_subject_rights_response_duties_checklist(Profile, Checklist): checklist of engagement, exception and suspension limbs, each item carrying cite(...).
- gdpr_data_subject_rights_response_duties_what_if(Profile, Key, Value, Result): re-decide with one key overridden.
- fixtures: worked profiles for each request type and each status, one per decision step.

Internal and not exported: decide_data_subject_request/2, applicable_response_period/2, response_deadline/3, request_outside_facts/2. Result constructors are exported, never called as queries.

Every query yields exactly one solution per profile. All arithmetic is exact integers.

## Slice: gdpr_data_subject_rights_response_duties.clausal

**Value facts it owns**
- Period lengths: first_period is 1 month and extended_period is 3 months from receipt. Both are declared once with constant_value and read with constant(Name).
- The request-type to engagement table.
- The exception order per request type: specific exceptions first, then art12_5, art12_2, art23.
- The referral citation table: judgement key and request type to citation.
- The Art 22(3) safeguard list.
- The Gregorian leap rule and month-length table, or datetime-based equivalents.

**Rules and requirements**
1. Input check (step 0).
2. Absent request_type or objection_ground_claimed gives indeterminate (step i).
3. Engagement E per request type, with BASIS (Arts 15(1), 16, 17(1)(a) to (f), 18(1)(a) to (d), 20(1), 21(1), 21(2), 21(6), 22(1)).
4. Exceptions X1 to Xn: Art 17(3)(a) to (e), Art 20(3) and 20(4), Art 21(1) two exceptions, Art 21(6), Art 22(2)(a) to (c) with the Art 22(4) BAR, Art 12(5), Art 12(2), Art 23.
5. Suspension SUSP (Art 12(6)).
6. Open-limb precedence: missing keys, then cross reference, then open_textured, with inputs_relied_on pairs in root_exports order.
7. Period selection and calendar rule (Regulation 1182/71 Art 3).
8. Duty lists (Art 12(3), 12(4)) and Art 19 notification.

**Verdict atoms**
must_comply, need_not_comply, indeterminate/1, needs_legal_review/2, suspended/1, input_problems/1, plus the BASIS, EXCEPTION and CONDITIONS atoms above.

**Shared with other slices (kernel.clausal only)**
There is a single slice, so only the generic tri-state evaluation helpers go in the kernel: Kleene AND and OR over MET, UNMET, OPEN_ABSENCE, OPEN_JUDGEMENT and OPEN_OUTSIDE_FACT; the defeater read (present true only); and the attested outside-fact reader. Everything legal stays in the slice.

## Planned reuse (manifest uses:)

- formalize_lib: profile_get/3, profile_has/2, profile_lacks/2, profile_keys/2, memberd/2, not_member/2, missing_keys/3, all_present/2, int_min/3, int_max/3. The three-clause check predicates are written locally for tri-state strong Kleene (defeaters need a different absent rule). Where the kit's check_tri/check_true fits, it is used instead of a clone (lint C15). assess/6 and eval_requirements/4 carry the checklist facade, with the requirement/4 closure taking the requirement id first.
- library(datetime): date_add/3, timedelta/3, weekday/2, date_string_iso/2, days_between/3 for the weekday and shift logic, built from date/4 objects and converted to date(Y, M, D) terms at the boundary.
- validate_props: run_props, prop_totality, prop_determinism and prop_citation_complete for the seven test modes.
- kit.query_combinators: what_if/5 for the what_if facade.
- kit.deadline_lib: NOT used for the calendar rule, because deadline_months_after/3 counts from the day after the anchor, which differs from the same-date rule here. month_last_day/3 may be reused.
- Not used: currency_vocab, vat_category, country, rolling_window, compliance_lib.
