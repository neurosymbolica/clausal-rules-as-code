% SPDX-License-Identifier: EUPL-1.2
:- module(m__ch_swiss_fadp_s3_right_of_access_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__ch_swiss_fadp_s3_right_of_access_swiss_fadp_s3_right_of_access, [swiss_access_request_answer/3, swiss_access_cost_contribution/3, swiss_access_deadline/3, swiss_access_deadline_after_cost_notice/3, eu_access_response_deadline/3, compare_swiss_eu_access_deadline/5, swiss_fadp_s3_right_of_access_status/2, swiss_fadp_s3_right_of_access_status_values/1]).
:- use_module(m__ch_swiss_fadp_s3_right_of_access_fixtures, [swiss_fadp_s3_right_of_access_profile_for/2]).

subject_status(Subject, Status) :-
    swiss_fadp_s3_right_of_access_profile_for(Subject, Profile),
    swiss_fadp_s3_right_of_access_status(Profile, Status).

edited_status(Subject, InputKey, Value, Status) :-
    swiss_fadp_s3_right_of_access_profile_for(Subject, Profile),
    maplist(replace_attribute(InputKey, Value), Profile, Changed),
    swiss_access_request_answer(Changed, Status, _).

replace_attribute(InputKey, Value, attribute(InputKey, _), attribute(InputKey, Value)).
replace_attribute(InputKey, _, attribute(OtherKey, OtherValue), attribute(OtherKey, OtherValue)) :-
    dif(InputKey, OtherKey).

test(the_status_table_holds_the_three_final_atoms) :-
    swiss_fadp_s3_right_of_access_status_values(StatusValues),
    StatusValues == [access_request_not_in_required_form, access_must_be_given, access_may_be_refused_restricted_or_deferred].
test(form_oral_without_agreement_fails) :-
    subject_status(oral_request_without_agreement, access_request_not_in_required_form).
test(form_oral_with_agreement_is_met) :-
    subject_status(oral_request_with_agreement, access_must_be_given).
test(electronic_request_is_in_the_required_form) :-
    subject_status(electronic_request_no_ground, access_must_be_given).
test(formal_law_permits_restriction) :-
    edited_status(written_request_no_ground, formal_law_provides_for_restriction, true, access_may_be_refused_restricted_or_deferred).
test(no_formal_law_gives_access) :-
    edited_status(written_request_no_ground, formal_law_provides_for_restriction, false, access_must_be_given).
test(third_party_interests_permit_restriction) :-
    subject_status(written_request_third_party_interests, access_may_be_refused_restricted_or_deferred).
test(no_third_party_interests_gives_access) :-
    subject_status(written_request_no_ground, access_must_be_given).
test(unfounded_request_permits_restriction) :-
    edited_status(written_request_no_ground, request_manifestly_unfounded_or_querulous, true, access_may_be_refused_restricted_or_deferred).
test(private_controller_interests_permit_restriction) :-
    subject_status(private_controller_overriding_interests, access_may_be_refused_restricted_or_deferred).
test(private_controller_disclosing_gives_access) :-
    subject_status(private_controller_discloses_to_third_parties, access_must_be_given).
test(federal_body_endangered_investigation_permits_restriction) :-
    subject_status(federal_body_investigation_endangered, access_may_be_refused_restricted_or_deferred).
test(federal_body_without_condition_gives_access) :-
    subject_status(federal_body_no_condition, access_must_be_given).
test(federal_public_interest_alone_permits_restriction) :-
    edited_status(federal_body_no_condition, restriction_required_by_overriding_public_interests, true, access_may_be_refused_restricted_or_deferred).
test(category_absent_with_both_letters_permits_restriction) :-
    subject_status(category_absent_both_letters_met, access_may_be_refused_restricted_or_deferred).
test(category_absent_with_one_letter_asks_for_the_category) :-
    subject_status(category_absent_private_letter_only, indeterminate([controller_category])).
test(editorial_sources_permit_restriction) :-
    subject_status(editorial_media_sources_revealed, access_may_be_refused_restricted_or_deferred).
test(sources_outside_editorial_media_give_access) :-
    subject_status(sources_revealed_not_editorial_media, access_must_be_given).
test(working_instrument_permits_restriction) :-
    subject_status(media_professional_working_instrument, access_may_be_refused_restricted_or_deferred).
test(unsure_formal_law_that_matters_goes_to_a_lawyer) :-
    subject_status(formal_law_unsure, needs_legal_review(open_textured(formal_law_provides_for_restriction, cite(ch_fadp_art_26_1_a)), [inputs_relied_on(_)])).
test(unsure_formal_law_that_does_not_matter_is_settled) :-
    subject_status(formal_law_unsure_third_party_interests, access_may_be_refused_restricted_or_deferred).
test(empty_profile_names_the_form_first) :-
    subject_status(empty_profile, indeterminate([request_form])).
test(disproportionate_effort_permits_a_contribution) :-
    swiss_access_cost_contribution([attribute(access_involves_disproportionate_effort, true)], cost_contribution_may_be_requested, _).
test(proportionate_effort_is_free) :-
    swiss_access_cost_contribution([attribute(access_involves_disproportionate_effort, false)], access_free_of_charge, _).
test(swiss_limit_ends_on_the_thirtieth_day) :-
    swiss_access_deadline(date(2026, 3, 1), date(2026, 3, 31), _).
test(cost_notice_limit_ends_on_the_fortieth_day) :-
    swiss_access_deadline_after_cost_notice(date(2026, 3, 1), date(2026, 4, 10), _).
test(eu_month_ending_on_sunday_moves_to_monday) :-
    eu_access_response_deadline(date(2026, 10, 29), date(2026, 11, 30), _).
test(eu_month_on_a_weekday_is_not_moved) :-
    eu_access_response_deadline(date(2028, 1, 31), date(2028, 2, 29), _).
test(comparison_swiss_earlier_cites_both_limits) :-
    compare_swiss_eu_access_deadline(date(2026, 3, 1), _, _, swiss_earlier, [cite(ch_fadp_ord_art_18_1), cite(eu_reg_2016_679_art_12_3)]).
test(comparison_same_cites_nothing) :-
    compare_swiss_eu_access_deadline(date(2026, 4, 15), _, _, same, []).
test(comparison_swiss_later) :-
    compare_swiss_eu_access_deadline(date(2026, 2, 10), _, _, swiss_later, _).
test(a_real_leap_day_is_a_receipt_date) :-
    swiss_access_deadline(date(2028, 2, 29), date(2028, 3, 30), _).
test(a_nonexistent_leap_day_is_refused) :-
    swiss_access_deadline(date(2026, 2, 29), input_problems([wrong_type(receipt_date)]), []).

test(form_oral_with_agreement_is_not_a_form_failure, fail) :-
    subject_status(oral_request_with_agreement, access_request_not_in_required_form).
test(form_oral_without_agreement_is_not_an_obligation, fail) :-
    subject_status(oral_request_without_agreement, access_must_be_given).
test(electronic_request_is_not_a_form_failure, fail) :-
    subject_status(electronic_request_no_ground, access_request_not_in_required_form).
test(no_formal_law_is_not_a_permission, fail) :-
    edited_status(written_request_no_ground, formal_law_provides_for_restriction, false, access_may_be_refused_restricted_or_deferred).
test(third_party_interests_are_not_an_obligation, fail) :-
    subject_status(written_request_third_party_interests, access_must_be_given).
test(founded_request_is_not_a_permission, fail) :-
    edited_status(written_request_no_ground, request_manifestly_unfounded_or_querulous, false, access_may_be_refused_restricted_or_deferred).
test(private_controller_disclosing_is_not_a_permission, fail) :-
    subject_status(private_controller_discloses_to_third_parties, access_may_be_refused_restricted_or_deferred).
test(private_letter_does_not_serve_a_federal_body, fail) :-
    edited_status(private_controller_overriding_interests, controller_category, federal_body, access_may_be_refused_restricted_or_deferred).
test(federal_body_without_condition_is_not_a_permission, fail) :-
    subject_status(federal_body_no_condition, access_may_be_refused_restricted_or_deferred).
test(federal_letter_does_not_serve_a_private_person, fail) :-
    subject_status(private_person_investigation_endangered, access_may_be_refused_restricted_or_deferred).
test(category_absent_with_one_letter_is_not_a_permission, fail) :-
    subject_status(category_absent_private_letter_only, access_may_be_refused_restricted_or_deferred).
test(sources_outside_editorial_media_are_not_a_permission, fail) :-
    subject_status(sources_revealed_not_editorial_media, access_may_be_refused_restricted_or_deferred).
test(editorial_media_without_a_reason_is_not_a_permission, fail) :-
    edited_status(sources_revealed_not_editorial_media, data_reveal_information_sources, false, access_may_be_refused_restricted_or_deferred).
test(no_working_instrument_is_not_a_permission, fail) :-
    edited_status(media_professional_working_instrument, data_serve_media_professional_exclusively_as_personal_working_instrument, false, access_may_be_refused_restricted_or_deferred).
test(unsure_formal_law_that_does_not_matter_is_not_referred, fail) :-
    subject_status(formal_law_unsure_third_party_interests, needs_legal_review(_, _)).
test(empty_profile_does_not_name_a_ground_first, fail) :-
    subject_status(empty_profile, indeterminate([formal_law_provides_for_restriction])).
test(proportionate_effort_permits_no_contribution, fail) :-
    swiss_access_cost_contribution([attribute(access_involves_disproportionate_effort, false)], cost_contribution_may_be_requested, _).
test(disproportionate_effort_is_not_free, fail) :-
    swiss_access_cost_contribution([attribute(access_involves_disproportionate_effort, true)], access_free_of_charge, _).
test(swiss_limit_does_not_end_on_the_thirty_first_day, fail) :-
    swiss_access_deadline(date(2026, 3, 1), date(2026, 4, 1), _).
test(swiss_limit_on_a_saturday_is_not_moved, fail) :-
    swiss_access_deadline(date(2026, 1, 15), date(2026, 2, 16), _).
test(cost_notice_limit_is_not_the_plain_limit, fail) :-
    swiss_access_deadline_after_cost_notice(date(2026, 3, 1), date(2026, 3, 31), _).
test(eu_month_ending_on_sunday_is_not_kept, fail) :-
    eu_access_response_deadline(date(2026, 10, 29), date(2026, 11, 29), _).
test(comparison_swiss_earlier_is_not_same, fail) :-
    compare_swiss_eu_access_deadline(date(2026, 3, 1), _, _, same, _).
test(comparison_swiss_later_is_not_swiss_earlier, fail) :-
    compare_swiss_eu_access_deadline(date(2026, 2, 10), _, _, swiss_earlier, _).
test(a_nonexistent_leap_day_gives_no_date, fail) :-
    swiss_access_deadline(date(2026, 2, 29), date(_, _, _), _).

cp_test_names([the_status_table_holds_the_three_final_atoms, form_oral_without_agreement_fails, form_oral_with_agreement_is_met, electronic_request_is_in_the_required_form, formal_law_permits_restriction, no_formal_law_gives_access, third_party_interests_permit_restriction, no_third_party_interests_gives_access, unfounded_request_permits_restriction, private_controller_interests_permit_restriction, private_controller_disclosing_gives_access, federal_body_endangered_investigation_permits_restriction, federal_body_without_condition_gives_access, federal_public_interest_alone_permits_restriction, category_absent_with_both_letters_permits_restriction, category_absent_with_one_letter_asks_for_the_category, editorial_sources_permit_restriction, sources_outside_editorial_media_give_access, working_instrument_permits_restriction, unsure_formal_law_that_matters_goes_to_a_lawyer, unsure_formal_law_that_does_not_matter_is_settled, empty_profile_names_the_form_first, disproportionate_effort_permits_a_contribution, proportionate_effort_is_free, swiss_limit_ends_on_the_thirtieth_day, cost_notice_limit_ends_on_the_fortieth_day, eu_month_ending_on_sunday_moves_to_monday, eu_month_on_a_weekday_is_not_moved, comparison_swiss_earlier_cites_both_limits, comparison_same_cites_nothing, comparison_swiss_later, a_real_leap_day_is_a_receipt_date, a_nonexistent_leap_day_is_refused]).
cp_test_fail_names([form_oral_with_agreement_is_not_a_form_failure, form_oral_without_agreement_is_not_an_obligation, electronic_request_is_not_a_form_failure, no_formal_law_is_not_a_permission, third_party_interests_are_not_an_obligation, founded_request_is_not_a_permission, private_controller_disclosing_is_not_a_permission, private_letter_does_not_serve_a_federal_body, federal_body_without_condition_is_not_a_permission, federal_letter_does_not_serve_a_private_person, category_absent_with_one_letter_is_not_a_permission, sources_outside_editorial_media_are_not_a_permission, editorial_media_without_a_reason_is_not_a_permission, no_working_instrument_is_not_a_permission, unsure_formal_law_that_does_not_matter_is_not_referred, empty_profile_does_not_name_a_ground_first, proportionate_effort_permits_no_contribution, disproportionate_effort_is_not_free, swiss_limit_does_not_end_on_the_thirty_first_day, swiss_limit_on_a_saturday_is_not_moved, cost_notice_limit_is_not_the_plain_limit, eu_month_ending_on_sunday_is_not_kept, comparison_swiss_earlier_is_not_same, comparison_swiss_later_is_not_swiss_earlier, a_nonexistent_leap_day_gives_no_date]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
