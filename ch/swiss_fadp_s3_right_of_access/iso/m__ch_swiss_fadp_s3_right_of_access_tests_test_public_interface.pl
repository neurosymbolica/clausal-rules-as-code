% SPDX-License-Identifier: EUPL-1.2
:- module(m__ch_swiss_fadp_s3_right_of_access_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__ch_swiss_fadp_s3_right_of_access_swiss_fadp_s3_right_of_access, [decide_swiss_fadp_s3_right_of_access/2, swiss_fadp_s3_right_of_access_status/2, swiss_fadp_s3_right_of_access_checklist/2, swiss_fadp_s3_right_of_access_decision_resolvable/1, swiss_fadp_s3_right_of_access_status_values/1, swiss_access_request_answer/3, swiss_access_cost_contribution/3, swiss_access_deadline/3, swiss_access_deadline_after_cost_notice/3, eu_access_response_deadline/3, compare_swiss_eu_access_deadline/5, provenance/2]).
:- use_module(m__ch_swiss_fadp_s3_right_of_access_fixtures, [swiss_fadp_s3_right_of_access_subject/1, swiss_fadp_s3_right_of_access_profile_for/2, swiss_fadp_s3_right_of_access_assess/2]).
:- use_module(m__ch_swiss_fadp_s3_right_of_access_kernel, [swiss_fadp_s3_right_of_access_input_problems/2]).
:- use_module(m__ch_swiss_fadp_s3_right_of_access_queries, [swiss_fadp_s3_right_of_access_what_if/4, swiss_fadp_s3_right_of_access_controller_obligations/2]).

subject_verdict(Subject, Status, CitationCount) :-
    swiss_fadp_s3_right_of_access_assess(Subject, swiss_fadp_s3_right_of_access_verdict(Status, Citations)),
    length(Citations, CitationCount).

one_verdict(Subject) :-
    findall(Verdict, swiss_fadp_s3_right_of_access_assess(Subject, Verdict), Verdicts),
    length(Verdicts, 1).

item_has_citation(item(_, _, cite(_))).

attribute_pair(attribute(InputKey, Value), InputKey - Value).

test(every_subject_has_exactly_one_verdict) :-
    findall(Subject, swiss_fadp_s3_right_of_access_subject(Subject), Subjects),
    length(Subjects, 19),
    maplist(one_verdict, Subjects).
test(oral_request_without_agreement_is_not_in_required_form) :-
    subject_verdict(oral_request_without_agreement, access_request_not_in_required_form, 3).
test(oral_request_with_agreement_must_be_given) :-
    subject_verdict(oral_request_with_agreement, access_must_be_given, 20).
test(the_form_decides_before_any_ground) :-
    subject_verdict(oral_request_without_agreement_with_ground, access_request_not_in_required_form, 3).
test(electronic_request_is_in_required_form) :-
    subject_verdict(electronic_request_no_ground, access_must_be_given, 20).
test(written_request_no_ground_must_be_given) :-
    subject_verdict(written_request_no_ground, access_must_be_given, 20).
test(third_party_interests_permit_restriction) :-
    subject_verdict(written_request_third_party_interests, access_may_be_refused_restricted_or_deferred, 22).
test(private_controller_interests_permit_restriction) :-
    subject_verdict(private_controller_overriding_interests, access_may_be_refused_restricted_or_deferred, 22).
test(private_controller_disclosing_must_give_access) :-
    subject_verdict(private_controller_discloses_to_third_parties, access_must_be_given, 20).
test(federal_body_endangered_investigation_permits_restriction) :-
    subject_verdict(federal_body_investigation_endangered, access_may_be_refused_restricted_or_deferred, 22).
test(federal_body_without_condition_must_give_access) :-
    subject_verdict(federal_body_no_condition, access_must_be_given, 20).
test(private_person_cannot_use_the_federal_letter) :-
    subject_verdict(private_person_investigation_endangered, access_must_be_given, 20).
test(category_absent_with_both_letters_is_settled) :-
    subject_verdict(category_absent_both_letters_met, access_may_be_refused_restricted_or_deferred, 22).
test(category_absent_with_one_letter_asks_for_the_category) :-
    subject_verdict(category_absent_private_letter_only, indeterminate([controller_category]), 0).
test(editorial_media_sources_permit_restriction) :-
    subject_verdict(editorial_media_sources_revealed, access_may_be_refused_restricted_or_deferred, 22).
test(sources_outside_editorial_media_must_give_access) :-
    subject_verdict(sources_revealed_not_editorial_media, access_must_be_given, 20).
test(personal_working_instrument_is_a_ground_of_its_own) :-
    subject_verdict(media_professional_working_instrument, access_may_be_refused_restricted_or_deferred, 22).
test(empty_profile_asks_for_the_form) :-
    subject_verdict(empty_profile, indeterminate([request_form]), 0).
test(unsure_formal_law_goes_to_a_lawyer) :-
    swiss_fadp_s3_right_of_access_profile_for(formal_law_unsure, Profile),
    maplist(attribute_pair, Profile, ExpectedPairs),
    subject_verdict(formal_law_unsure, Status, 0),
    Status == needs_legal_review(open_textured(formal_law_provides_for_restriction, cite(ch_fadp_art_26_1_a)), [inputs_relied_on(ExpectedPairs)]).
test(unsure_formal_law_with_a_ground_is_settled) :-
    subject_verdict(formal_law_unsure_third_party_interests, access_may_be_refused_restricted_or_deferred, 22).
test(an_unknown_key_is_an_input_problem) :-
    findall(Result - Citations, swiss_access_request_answer([attribute(colour, red)], Result, Citations), Answers),
    Answers == [input_problems([unknown_key(colour)]) - []].
test(provenance_constructor_accepts_a_bound_source_and_detail) :-
    provenance(ch_fadp_art_26_1_a, unit('ch-fadp-sr-235-1-2025-07-07#art_26/para_1/lbl_a')).
test(status_projection_matches_the_verdict) :-
    swiss_fadp_s3_right_of_access_profile_for(written_request_third_party_interests, Profile),
    swiss_fadp_s3_right_of_access_status(Profile, access_may_be_refused_restricted_or_deferred).
test(final_status_is_in_the_status_values) :-
    swiss_fadp_s3_right_of_access_status_values(StatusValues),
    subject_verdict(written_request_no_ground, Status, _),
    member(Status, StatusValues).
test(decision_is_resolvable_on_a_fixture) :-
    swiss_fadp_s3_right_of_access_profile_for(empty_profile, Profile),
    swiss_fadp_s3_right_of_access_decision_resolvable(Profile).
test(verdict_carries_the_fixed_citations) :-
    swiss_fadp_s3_right_of_access_profile_for(oral_request_without_agreement, Profile),
    decide_swiss_fadp_s3_right_of_access(Profile, swiss_fadp_s3_right_of_access_verdict(access_request_not_in_required_form, [cite(ch_fadp_art_25_1), cite(ch_fadp_ord_art_16_1), cite(ch_fadp_ord_art_16_3)])).
test(checklist_carries_a_citation_per_item) :-
    swiss_fadp_s3_right_of_access_profile_for(written_request_third_party_interests, Profile),
    swiss_fadp_s3_right_of_access_checklist(Profile, Items),
    length(Items, 7),
    maplist(item_has_citation, Items),
    member(item(third_party_interest_ground, met, cite(ch_fadp_art_26_1_b)), Items).
test(checklist_near_miss_marks_the_ground_unmet) :-
    swiss_fadp_s3_right_of_access_profile_for(written_request_no_ground, Profile),
    swiss_fadp_s3_right_of_access_checklist(Profile, [_FirstItem|_OtherItems]),
    swiss_fadp_s3_right_of_access_checklist(Profile, Items),
    member(item(third_party_interest_ground, unmet(condition_not_met), cite(ch_fadp_art_26_1_b)), Items).
test(access_due_obliges_giving_access_in_time) :-
    swiss_fadp_s3_right_of_access_profile_for(written_request_no_ground, Profile),
    swiss_fadp_s3_right_of_access_controller_obligations(Profile, Obligations),
    Obligations == [obligation(give_access, cite(ch_fadp_art_25_1)), obligation(give_access_within_time_limit, cite(ch_fadp_ord_art_18_1))].
test(restriction_obliges_reasons_in_time) :-
    swiss_fadp_s3_right_of_access_profile_for(written_request_third_party_interests, Profile),
    swiss_fadp_s3_right_of_access_controller_obligations(Profile, Obligations),
    Obligations == [obligation(state_reasons_for_measure, cite(ch_fadp_art_26_4)), obligation(communicate_measure_within_time_limit, cite(ch_fadp_ord_art_18_3))].
test(form_failure_raises_no_obligation) :-
    swiss_fadp_s3_right_of_access_profile_for(oral_request_without_agreement, Profile),
    swiss_fadp_s3_right_of_access_controller_obligations(Profile, []).
test(missing_fact_passes_the_status_through) :-
    swiss_fadp_s3_right_of_access_controller_obligations([], indeterminate([request_form])).
test(what_if_a_ground_holds) :-
    swiss_fadp_s3_right_of_access_profile_for(written_request_no_ground, Profile),
    swiss_fadp_s3_right_of_access_what_if(Profile, restriction_required_by_overriding_third_party_interests, true, access_may_be_refused_restricted_or_deferred).
test(what_if_the_agreement_is_withdrawn) :-
    swiss_fadp_s3_right_of_access_profile_for(oral_request_with_agreement, Profile),
    swiss_fadp_s3_right_of_access_what_if(Profile, controller_agreed_to_oral_request, false, access_request_not_in_required_form).
test(what_if_the_missing_category_is_supplied) :-
    swiss_fadp_s3_right_of_access_profile_for(category_absent_private_letter_only, Profile),
    swiss_fadp_s3_right_of_access_what_if(Profile, controller_category, private_person, access_may_be_refused_restricted_or_deferred).
test(no_disproportionate_effort_is_free) :-
    findall(Result - Citations, swiss_access_cost_contribution([attribute(access_involves_disproportionate_effort, false)], Result, Citations), Answers),
    Answers == [access_free_of_charge - [cite(ch_fadp_art_25_6), cite(ch_fadp_ord_art_19_1)]].
test(disproportionate_effort_allows_a_contribution) :-
    swiss_access_cost_contribution([attribute(access_involves_disproportionate_effort, true)], cost_contribution_may_be_requested, [cite(ch_fadp_art_25_6), cite(ch_fadp_ord_art_19_1), cite(ch_fadp_ord_art_19_2), cite(ch_fadp_ord_art_19_3)]).
test(absent_effort_is_asked_for) :-
    swiss_access_cost_contribution([], indeterminate([access_involves_disproportionate_effort]), []).
test(unsure_effort_goes_to_a_lawyer) :-
    swiss_access_cost_contribution([attribute(access_involves_disproportionate_effort, unsure)], needs_legal_review(open_textured(access_involves_disproportionate_effort, cite(ch_fadp_ord_art_19_1)), [inputs_relied_on([access_involves_disproportionate_effort - unsure])]), []).
test(a_bad_effort_value_is_an_input_problem) :-
    swiss_access_cost_contribution([attribute(access_involves_disproportionate_effort, maybe)], input_problems([wrong_type(access_involves_disproportionate_effort)]), []).
test(swiss_deadline_in_march) :-
    findall(Deadline - Citations, swiss_access_deadline(date(2026, 3, 1), Deadline, Citations), Answers),
    Answers == [date(2026, 3, 31) - [cite(ch_fadp_art_25_7), cite(ch_fadp_ord_art_18_1)]].
test(swiss_deadline_on_a_saturday_is_not_moved) :-
    swiss_access_deadline(date(2026, 1, 15), date(2026, 2, 14), _).
test(swiss_deadline_across_february) :-
    swiss_access_deadline(date(2026, 2, 1), date(2026, 3, 3), _).
test(swiss_deadline_from_the_last_accepted_year) :-
    swiss_access_deadline(date(2199, 12, 31), date(2200, 1, 30), _).
test(swiss_deadline_from_the_first_accepted_year) :-
    swiss_access_deadline(date(1900, 1, 1), date(1900, 1, 31), _).
test(a_year_before_the_bound_is_refused) :-
    swiss_access_deadline(date(1899, 12, 31), input_problems([wrong_type(receipt_date)]), []).
test(a_day_that_does_not_exist_is_refused) :-
    swiss_access_deadline(date(2026, 2, 30), input_problems([wrong_type(receipt_date)]), []).
test(a_non_date_is_refused) :-
    swiss_access_deadline(foo, input_problems([wrong_type(receipt_date)]), []).
test(an_unbound_receipt_is_refused) :-
    findall(Deadline, swiss_access_deadline(_, Deadline, []), Deadlines),
    Deadlines == [input_problems([wrong_type(receipt_date)])].
test(swiss_deadline_after_cost_notice) :-
    swiss_access_deadline_after_cost_notice(date(2026, 3, 1), date(2026, 4, 10), [cite(ch_fadp_art_25_7), cite(ch_fadp_ord_art_18_1), cite(ch_fadp_ord_art_19_3)]).
test(a_bad_cost_notice_date_is_refused) :-
    swiss_access_deadline_after_cost_notice(date(2026, 13, 1), input_problems([wrong_type(cost_notice_date)]), []).
test(eu_deadline_moves_from_sunday) :-
    eu_access_response_deadline(date(2026, 10, 29), date(2026, 11, 30), [cite(eu_reg_2016_679_art_12_3), cite(eu_reg_1971_1182_art_3_1), cite(eu_reg_1971_1182_art_3_2_c), cite(eu_reg_1971_1182_art_3_4)]).
test(eu_deadline_month_end_moves_from_saturday) :-
    eu_access_response_deadline(date(2026, 1, 31), date(2026, 3, 2), _).
test(eu_deadline_leap_year) :-
    eu_access_response_deadline(date(2028, 1, 31), date(2028, 2, 29), _).
test(eu_deadline_on_a_weekday_is_not_moved) :-
    eu_access_response_deadline(date(2026, 3, 1), date(2026, 4, 1), _).
test(eu_deadline_carries_into_the_next_year) :-
    eu_access_response_deadline(date(2026, 12, 15), date(2027, 1, 15), _).
test(eu_deadline_century_not_leap) :-
    eu_access_response_deadline(date(1900, 1, 31), date(1900, 2, 28), _).
test(eu_deadline_century_leap) :-
    eu_access_response_deadline(date(2000, 1, 31), date(2000, 2, 29), _).
test(eu_deadline_bad_date_is_refused) :-
    eu_access_response_deadline(date(2026, 4, 31), input_problems([wrong_type(receipt_date)]), []).
test(comparison_swiss_earlier) :-
    findall(Swiss - Eu - Difference - ChangedBy, compare_swiss_eu_access_deadline(date(2026, 3, 1), Swiss, Eu, Difference, ChangedBy), Answers),
    Answers == [date(2026, 3, 31) - date(2026, 4, 1) - swiss_earlier - [cite(ch_fadp_ord_art_18_1), cite(eu_reg_2016_679_art_12_3)]].
test(comparison_same_day) :-
    compare_swiss_eu_access_deadline(date(2026, 1, 31), date(2026, 3, 2), date(2026, 3, 2), same, []).
test(comparison_swiss_later) :-
    compare_swiss_eu_access_deadline(date(2026, 2, 1), date(2026, 3, 3), date(2026, 3, 2), swiss_later, [cite(ch_fadp_ord_art_18_1), cite(eu_reg_2016_679_art_12_3)]).
test(comparison_swiss_later_in_a_leap_year) :-
    compare_swiss_eu_access_deadline(date(2028, 1, 31), date(2028, 3, 1), date(2028, 2, 29), swiss_later, _).
test(comparison_swiss_earlier_before_a_weekend_shift) :-
    compare_swiss_eu_access_deadline(date(2026, 10, 29), date(2026, 11, 28), date(2026, 11, 30), swiss_earlier, _).
test(comparison_with_a_bad_date) :-
    findall(Swiss - Eu - Difference - ChangedBy, compare_swiss_eu_access_deadline(nonsense, Swiss, Eu, Difference, ChangedBy), Answers),
    Answers == [input_problems([wrong_type(receipt_date)]) - input_problems([wrong_type(receipt_date)]) - input_problems([wrong_type(receipt_date)]) - []].
test(a_well_formed_profile_has_no_problem) :-
    swiss_fadp_s3_right_of_access_profile_for(written_request_no_ground, Profile),
    swiss_fadp_s3_right_of_access_input_problems(Profile, []).
test(a_bad_enumeration_value_is_wrong_type) :-
    swiss_fadp_s3_right_of_access_input_problems([attribute(request_form, fax)], [wrong_type(request_form)]).
test(a_crisp_key_refuses_unsure) :-
    swiss_fadp_s3_right_of_access_input_problems([attribute(controller_agreed_to_oral_request, unsure)], [wrong_type(controller_agreed_to_oral_request)]).
test(a_repeated_key_is_a_duplicate) :-
    swiss_fadp_s3_right_of_access_input_problems([attribute(request_form, written), attribute(request_form, oral)], [duplicate_key(request_form)]).
test(an_unknown_key_is_named_once) :-
    swiss_fadp_s3_right_of_access_input_problems([attribute(colour, red), attribute(colour, blue)], [unknown_key(colour)]).
test(problems_come_in_contract_order_then_unknown_keys) :-
    swiss_fadp_s3_right_of_access_input_problems([attribute(colour, red), attribute(request_form, fax), attribute(controller_category, private_person), attribute(controller_category, federal_body)], Problems),
    Problems == [wrong_type(request_form), duplicate_key(controller_category), unknown_key(colour)].
test(a_non_attribute_element_is_not_a_profile) :-
    swiss_fadp_s3_right_of_access_input_problems([foo], [wrong_type(profile)]).
test(an_unbound_profile_is_not_a_profile) :-
    findall(Problems, swiss_fadp_s3_right_of_access_input_problems(_, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(a_partial_list_is_not_a_profile) :-
    findall(Problems, swiss_fadp_s3_right_of_access_input_problems([attribute(request_form, written)|_], Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(a_number_key_is_unknown) :-
    swiss_fadp_s3_right_of_access_input_problems([attribute(42, red)], [unknown_key(42)]).
test(an_unbound_value_is_wrong_type) :-
    findall(Problems, swiss_fadp_s3_right_of_access_input_problems([attribute(request_form, _)], Problems), Answers),
    Answers == [[wrong_type(request_form)]].

test(oral_request_with_agreement_is_not_refused_for_form, fail) :-
    subject_verdict(oral_request_with_agreement, access_request_not_in_required_form, _).
test(the_form_failing_reads_no_ground, fail) :-
    subject_verdict(oral_request_without_agreement_with_ground, access_may_be_refused_restricted_or_deferred, _).
test(written_request_no_ground_is_not_a_permission, fail) :-
    subject_verdict(written_request_no_ground, access_may_be_refused_restricted_or_deferred, _).
test(third_party_interests_do_not_oblige_access, fail) :-
    subject_verdict(written_request_third_party_interests, access_must_be_given, _).
test(private_controller_disclosing_is_not_a_permission, fail) :-
    subject_verdict(private_controller_discloses_to_third_parties, access_may_be_refused_restricted_or_deferred, _).
test(private_person_endangered_investigation_is_not_a_permission, fail) :-
    subject_verdict(private_person_investigation_endangered, access_may_be_refused_restricted_or_deferred, _).
test(category_absent_with_one_letter_is_not_settled, fail) :-
    subject_verdict(category_absent_private_letter_only, access_may_be_refused_restricted_or_deferred, _).
test(sources_outside_editorial_media_is_not_a_permission, fail) :-
    subject_verdict(sources_revealed_not_editorial_media, access_may_be_refused_restricted_or_deferred, _).
test(unsure_formal_law_with_a_ground_is_not_referred, fail) :-
    subject_verdict(formal_law_unsure_third_party_interests, needs_legal_review(_, _), _).
test(provenance_constructor_refuses_an_unbound_source, fail) :-
    provenance(_, unit('ch-fadp-sr-235-1-2025-07-07#art_26/para_1/lbl_a')).
test(provenance_constructor_refuses_an_unbound_detail, fail) :-
    provenance(ch_fadp_art_26_1_a, _).
test(no_disproportionate_effort_allows_no_contribution, fail) :-
    swiss_access_cost_contribution([attribute(access_involves_disproportionate_effort, false)], cost_contribution_may_be_requested, _).
test(comparison_same_day_is_not_earlier, fail) :-
    compare_swiss_eu_access_deadline(date(2026, 1, 31), _, _, swiss_earlier, _).

cp_test_names([every_subject_has_exactly_one_verdict, oral_request_without_agreement_is_not_in_required_form, oral_request_with_agreement_must_be_given, the_form_decides_before_any_ground, electronic_request_is_in_required_form, written_request_no_ground_must_be_given, third_party_interests_permit_restriction, private_controller_interests_permit_restriction, private_controller_disclosing_must_give_access, federal_body_endangered_investigation_permits_restriction, federal_body_without_condition_must_give_access, private_person_cannot_use_the_federal_letter, category_absent_with_both_letters_is_settled, category_absent_with_one_letter_asks_for_the_category, editorial_media_sources_permit_restriction, sources_outside_editorial_media_must_give_access, personal_working_instrument_is_a_ground_of_its_own, empty_profile_asks_for_the_form, unsure_formal_law_goes_to_a_lawyer, unsure_formal_law_with_a_ground_is_settled, an_unknown_key_is_an_input_problem, provenance_constructor_accepts_a_bound_source_and_detail, status_projection_matches_the_verdict, final_status_is_in_the_status_values, decision_is_resolvable_on_a_fixture, verdict_carries_the_fixed_citations, checklist_carries_a_citation_per_item, checklist_near_miss_marks_the_ground_unmet, access_due_obliges_giving_access_in_time, restriction_obliges_reasons_in_time, form_failure_raises_no_obligation, missing_fact_passes_the_status_through, what_if_a_ground_holds, what_if_the_agreement_is_withdrawn, what_if_the_missing_category_is_supplied, no_disproportionate_effort_is_free, disproportionate_effort_allows_a_contribution, absent_effort_is_asked_for, unsure_effort_goes_to_a_lawyer, a_bad_effort_value_is_an_input_problem, swiss_deadline_in_march, swiss_deadline_on_a_saturday_is_not_moved, swiss_deadline_across_february, swiss_deadline_from_the_last_accepted_year, swiss_deadline_from_the_first_accepted_year, a_year_before_the_bound_is_refused, a_day_that_does_not_exist_is_refused, a_non_date_is_refused, an_unbound_receipt_is_refused, swiss_deadline_after_cost_notice, a_bad_cost_notice_date_is_refused, eu_deadline_moves_from_sunday, eu_deadline_month_end_moves_from_saturday, eu_deadline_leap_year, eu_deadline_on_a_weekday_is_not_moved, eu_deadline_carries_into_the_next_year, eu_deadline_century_not_leap, eu_deadline_century_leap, eu_deadline_bad_date_is_refused, comparison_swiss_earlier, comparison_same_day, comparison_swiss_later, comparison_swiss_later_in_a_leap_year, comparison_swiss_earlier_before_a_weekend_shift, comparison_with_a_bad_date, a_well_formed_profile_has_no_problem, a_bad_enumeration_value_is_wrong_type, a_crisp_key_refuses_unsure, a_repeated_key_is_a_duplicate, an_unknown_key_is_named_once, problems_come_in_contract_order_then_unknown_keys, a_non_attribute_element_is_not_a_profile, an_unbound_profile_is_not_a_profile, a_partial_list_is_not_a_profile, a_number_key_is_unknown, an_unbound_value_is_wrong_type]).
cp_test_fail_names([oral_request_with_agreement_is_not_refused_for_form, the_form_failing_reads_no_ground, written_request_no_ground_is_not_a_permission, third_party_interests_do_not_oblige_access, private_controller_disclosing_is_not_a_permission, private_person_endangered_investigation_is_not_a_permission, category_absent_with_one_letter_is_not_settled, sources_outside_editorial_media_is_not_a_permission, unsure_formal_law_with_a_ground_is_not_referred, provenance_constructor_refuses_an_unbound_source, provenance_constructor_refuses_an_unbound_detail, no_disproportionate_effort_allows_no_contribution, comparison_same_day_is_not_earlier]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
