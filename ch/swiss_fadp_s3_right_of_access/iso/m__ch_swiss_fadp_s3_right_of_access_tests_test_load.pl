% SPDX-License-Identifier: EUPL-1.2
:- module(m__ch_swiss_fadp_s3_right_of_access_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__ch_swiss_fadp_s3_right_of_access_kernel, [swiss_fadp_s3_right_of_access_input_problems/2]).
:- use_module(m__ch_swiss_fadp_s3_right_of_access_citations, [citation/2, implements/1]).

test(the_request_answer_atoms_are_distinct) :-
    dif(access_request_not_in_required_form, access_must_be_given),
    dif(access_request_not_in_required_form, access_may_be_refused_restricted_or_deferred),
    dif(access_must_be_given, access_may_be_refused_restricted_or_deferred).
test(the_cost_answer_atoms_are_distinct) :-
    dif(access_free_of_charge, cost_contribution_may_be_requested).
test(the_comparison_atoms_are_distinct) :-
    dif(swiss_earlier, same),
    dif(swiss_earlier, swiss_later),
    dif(same, swiss_later).
test(the_verdict_term_carries_status_and_citations) :-
    Verdict = swiss_fadp_s3_right_of_access_verdict(access_must_be_given, [cite(ch_fadp_art_25_1)]),
    Verdict = swiss_fadp_s3_right_of_access_verdict(Status, Citations),
    Status == access_must_be_given,
    Citations == [cite(ch_fadp_art_25_1)].
test(the_indeterminate_status_carries_one_bare_key) :-
    Status = indeterminate([request_form]),
    Status = indeterminate([Key]),
    Key == request_form.
test(the_referral_status_builds_and_destructures) :-
    Status = needs_legal_review(open_textured(access_involves_disproportionate_effort, cite(ch_fadp_ord_art_19_1)), [inputs_relied_on([access_involves_disproportionate_effort - unsure])]),
    Status = needs_legal_review(open_textured(Input, cite(CitationKey)), [inputs_relied_on(Pairs)]),
    Input == access_involves_disproportionate_effort,
    CitationKey == ch_fadp_ord_art_19_1,
    Pairs == [access_involves_disproportionate_effort - unsure].
test(the_date_output_destructures_into_integers) :-
    Deadline = date(2026, 3, 31),
    Deadline = date(Year, Month, Day),
    integer(Year),
    integer(Month),
    integer(Day).
test(an_empty_profile_has_no_problem) :-
    swiss_fadp_s3_right_of_access_input_problems([], Problems),
    Problems == [].
test(a_well_formed_profile_has_no_problem) :-
    swiss_fadp_s3_right_of_access_input_problems([attribute(request_form, written), attribute(controller_agreed_to_oral_request, false), attribute(controller_category, federal_body), attribute(formal_law_provides_for_restriction, unsure), attribute(access_involves_disproportionate_effort, true)], Problems),
    Problems == [].
test(the_input_check_gives_exactly_one_answer) :-
    findall(Problems, swiss_fadp_s3_right_of_access_input_problems([attribute(request_form, oral)], Problems), Answers),
    Answers == [[]].
test(a_key_outside_the_contract_is_unknown) :-
    swiss_fadp_s3_right_of_access_input_problems([attribute(favourite_colour, blue)], Problems),
    Problems == [unknown_key(favourite_colour)].
test(an_enumeration_value_outside_its_list_is_wrong_type) :-
    swiss_fadp_s3_right_of_access_input_problems([attribute(request_form, telepathic)], Problems),
    Problems == [wrong_type(request_form)].
test(a_crisp_key_given_unsure_is_wrong_type) :-
    swiss_fadp_s3_right_of_access_input_problems([attribute(controller_discloses_the_personal_data_to_third_parties, unsure)], Problems),
    Problems == [wrong_type(controller_discloses_the_personal_data_to_third_parties)].
test(a_repeated_key_is_a_duplicate_and_never_wrong_type) :-
    swiss_fadp_s3_right_of_access_input_problems([attribute(controller_category, private_person), attribute(controller_category, nonsense)], Problems),
    Problems == [duplicate_key(controller_category)].
test(contract_problems_come_before_unknown_keys) :-
    swiss_fadp_s3_right_of_access_input_problems([attribute(favourite_colour, blue), attribute(request_form, telepathic)], Problems),
    Problems == [wrong_type(request_form), unknown_key(favourite_colour)].
test(a_term_that_is_not_an_attribute_list_is_wrong_type_profile) :-
    swiss_fadp_s3_right_of_access_input_problems(42, Problems),
    Problems == [wrong_type(profile)].
test(an_unbound_profile_is_wrong_type_profile) :-
    findall(Problems, swiss_fadp_s3_right_of_access_input_problems(_, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(a_list_with_a_stray_element_is_wrong_type_profile) :-
    swiss_fadp_s3_right_of_access_input_problems([attribute(request_form, written), stray], Problems),
    Problems == [wrong_type(profile)].
test(the_right_of_access_citation_is_recorded) :-
    citation(ch_fadp_art_25_1, _Record).
test(the_time_limit_citation_is_recorded) :-
    citation(ch_fadp_ord_art_18_1, _Record).
test(the_eu_comparison_citation_is_recorded) :-
    citation(eu_reg_2016_679_art_12_3, _Record).
test(the_marker_succeeds_for_a_recorded_key) :-
    implements(ch_fadp_ord_art_19_3).

test(the_marker_fails_for_an_unrecorded_key, fail) :-
    implements(ch_todo_primary_source).

cp_test_names([the_request_answer_atoms_are_distinct, the_cost_answer_atoms_are_distinct, the_comparison_atoms_are_distinct, the_verdict_term_carries_status_and_citations, the_indeterminate_status_carries_one_bare_key, the_referral_status_builds_and_destructures, the_date_output_destructures_into_integers, an_empty_profile_has_no_problem, a_well_formed_profile_has_no_problem, the_input_check_gives_exactly_one_answer, a_key_outside_the_contract_is_unknown, an_enumeration_value_outside_its_list_is_wrong_type, a_crisp_key_given_unsure_is_wrong_type, a_repeated_key_is_a_duplicate_and_never_wrong_type, contract_problems_come_before_unknown_keys, a_term_that_is_not_an_attribute_list_is_wrong_type_profile, an_unbound_profile_is_wrong_type_profile, a_list_with_a_stray_element_is_wrong_type_profile, the_right_of_access_citation_is_recorded, the_time_limit_citation_is_recorded, the_eu_comparison_citation_is_recorded, the_marker_succeeds_for_a_recorded_key]).
cp_test_fail_names([the_marker_fails_for_an_unrecorded_key]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
