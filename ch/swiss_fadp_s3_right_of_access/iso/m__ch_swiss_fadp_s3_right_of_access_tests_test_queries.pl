% SPDX-License-Identifier: EUPL-1.2
:- module(m__ch_swiss_fadp_s3_right_of_access_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__ch_swiss_fadp_s3_right_of_access_queries, [swiss_fadp_s3_right_of_access_profile_keys/1, swiss_fadp_s3_right_of_access_what_if/4, swiss_fadp_s3_right_of_access_controller_obligations/2, unsure/0, written/0, request_form/0]).
:- use_module(m__ch_swiss_fadp_s3_right_of_access_swiss_fadp_s3_right_of_access, [swiss_fadp_s3_right_of_access_status/2, swiss_fadp_s3_right_of_access_checklist/2, swiss_access_deadline/3, compare_swiss_eu_access_deadline/5]).
:- use_module(m__ch_swiss_fadp_s3_right_of_access_fixtures, [swiss_fadp_s3_right_of_access_profile_for/2]).

test(profile_keys_are_the_contract_keys) :-
    swiss_fadp_s3_right_of_access_profile_keys(ProfileKeys),
    ProfileKeys == [request_form, controller_agreed_to_oral_request, controller_category, formal_law_provides_for_restriction, restriction_required_by_overriding_third_party_interests, request_manifestly_unfounded_or_querulous, restriction_required_by_overriding_controller_interests, controller_discloses_the_personal_data_to_third_parties, restriction_required_by_overriding_public_interests, information_could_endanger_investigation_or_proceedings, processed_exclusively_for_publication_in_editorial_part_of_periodical_medium, data_reveal_information_sources, access_would_give_insight_into_drafts_for_publications, publication_would_endanger_free_formation_of_public_opinion, data_serve_media_professional_exclusively_as_personal_working_instrument, access_involves_disproportionate_effort].
test(root_export_atoms_are_served) :-
    unsure,
    written,
    request_form.
test(status_of_the_baseline) :-
    swiss_fadp_s3_right_of_access_profile_for(written_request_no_ground, Profile),
    findall(Status, swiss_fadp_s3_right_of_access_status(Profile, Status), [access_must_be_given]).
test(what_if_a_formal_law_flips_the_obligation) :-
    swiss_fadp_s3_right_of_access_profile_for(written_request_no_ground, Profile),
    findall(Result, swiss_fadp_s3_right_of_access_what_if(Profile, formal_law_provides_for_restriction, true, Result), Results),
    Results == [access_may_be_refused_restricted_or_deferred].
test(what_if_an_oral_request_fails_the_form) :-
    swiss_fadp_s3_right_of_access_profile_for(written_request_third_party_interests, Profile),
    swiss_fadp_s3_right_of_access_what_if(Profile, request_form, oral, access_request_not_in_required_form).
test(what_if_adds_an_absent_key) :-
    swiss_fadp_s3_right_of_access_what_if([], request_form, written, indeterminate([formal_law_provides_for_restriction])).
test(what_if_with_a_bad_value_reports_the_problem) :-
    swiss_fadp_s3_right_of_access_what_if([], request_form, letter, input_problems([wrong_type(request_form)])).
test(what_if_the_same_value_keeps_the_answer) :-
    swiss_fadp_s3_right_of_access_profile_for(written_request_no_ground, Profile),
    swiss_fadp_s3_right_of_access_what_if(Profile, formal_law_provides_for_restriction, false, access_must_be_given).
test(obligations_of_an_owed_access) :-
    swiss_fadp_s3_right_of_access_profile_for(written_request_no_ground, Profile),
    findall(Obligations, swiss_fadp_s3_right_of_access_controller_obligations(Profile, Obligations), Answers),
    Answers == [[obligation(give_access, cite(ch_fadp_art_25_1)), obligation(give_access_within_time_limit, cite(ch_fadp_ord_art_18_1))]].
test(obligations_of_a_permitted_restriction) :-
    swiss_fadp_s3_right_of_access_profile_for(written_request_third_party_interests, Profile),
    swiss_fadp_s3_right_of_access_controller_obligations(Profile, [obligation(state_reasons_for_measure, cite(ch_fadp_art_26_4)), obligation(communicate_measure_within_time_limit, cite(ch_fadp_ord_art_18_3))]).
test(no_obligation_for_a_request_not_in_form) :-
    swiss_fadp_s3_right_of_access_profile_for(oral_request_without_agreement, Profile),
    swiss_fadp_s3_right_of_access_controller_obligations(Profile, []).
test(obligations_pass_a_missing_key_through) :-
    swiss_fadp_s3_right_of_access_controller_obligations([], indeterminate([request_form])).
test(obligations_pass_input_problems_through) :-
    swiss_fadp_s3_right_of_access_controller_obligations(nonsense, input_problems([wrong_type(profile)])).
test(checklist_carries_a_citation_per_item) :-
    swiss_fadp_s3_right_of_access_profile_for(written_request_third_party_interests, Profile),
    swiss_fadp_s3_right_of_access_checklist(Profile, Items),
    length(Items, 7),
    member(item(third_party_interest_ground, met, cite(ch_fadp_art_26_1_b)), Items),
    member(item(formal_law_ground, unmet(condition_not_met), cite(ch_fadp_art_26_1_a)), Items).
test(checklist_reports_input_problems) :-
    swiss_fadp_s3_right_of_access_checklist([attribute(colour, red)], [item(input_check, unmet(input_problems([unknown_key(colour)])), cite(ch_fadp_art_25_1))]).
test(deadline_thirty_days_after_receipt) :-
    swiss_access_deadline(date(2026, 3, 1), date(2026, 3, 31), [cite(ch_fadp_art_25_7), cite(ch_fadp_ord_art_18_1)]).
test(comparison_of_the_two_last_days) :-
    compare_swiss_eu_access_deadline(date(2026, 3, 1), date(2026, 3, 31), date(2026, 4, 1), swiss_earlier, [cite(ch_fadp_ord_art_18_1), cite(eu_reg_2016_679_art_12_3)]).
test(comparison_of_the_same_last_day) :-
    compare_swiss_eu_access_deadline(date(2026, 1, 31), date(2026, 3, 2), date(2026, 3, 2), same, []).

test(no_give_access_duty_when_restriction_is_permitted, fail) :-
    swiss_fadp_s3_right_of_access_profile_for(written_request_third_party_interests, Profile),
    swiss_fadp_s3_right_of_access_controller_obligations(Profile, [obligation(give_access, _)|_]).

cp_test_names([profile_keys_are_the_contract_keys, root_export_atoms_are_served, status_of_the_baseline, what_if_a_formal_law_flips_the_obligation, what_if_an_oral_request_fails_the_form, what_if_adds_an_absent_key, what_if_with_a_bad_value_reports_the_problem, what_if_the_same_value_keeps_the_answer, obligations_of_an_owed_access, obligations_of_a_permitted_restriction, no_obligation_for_a_request_not_in_form, obligations_pass_a_missing_key_through, obligations_pass_input_problems_through, checklist_carries_a_citation_per_item, checklist_reports_input_problems, deadline_thirty_days_after_receipt, comparison_of_the_two_last_days, comparison_of_the_same_last_day]).
cp_test_fail_names([no_give_access_duty_when_restriction_is_permitted]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
