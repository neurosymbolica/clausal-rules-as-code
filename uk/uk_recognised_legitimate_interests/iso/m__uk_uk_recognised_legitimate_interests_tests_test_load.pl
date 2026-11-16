% SPDX-License-Identifier: EUPL-1.2
:- module(m__uk_uk_recognised_legitimate_interests_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__uk_uk_recognised_legitimate_interests_kernel, [uk_recognised_legitimate_interests_input_problems/2]).
:- use_module(m__uk_uk_recognised_legitimate_interests_citations, [citation/2, implements/1]).

test(the_verdict_term_carries_status_and_citations) :-
    Verdict = uk_recognised_legitimate_interests_verdict(recognised_legitimate_interest_applies, [cite(uk_gdpr_art_6_1_ea), cite(uk_gdpr_art_6_5), cite(uk_gdpr_annex_1_para_2)]),
    Verdict = uk_recognised_legitimate_interests_verdict(Status, Citations),
    Status == recognised_legitimate_interest_applies,
    Citations == [cite(uk_gdpr_art_6_1_ea), cite(uk_gdpr_art_6_5), cite(uk_gdpr_annex_1_para_2)].
test(the_indeterminate_status_holds_one_bare_key) :-
    Status = indeterminate([processing_by_a_public_authority_in_the_performance_of_its_tasks]),
    Status = indeterminate([MissingKey]),
    MissingKey == processing_by_a_public_authority_in_the_performance_of_its_tasks.
test(the_referral_status_destructures) :-
    Status = needs_legal_review(open_textured(interests_overridden_by_data_subject_interests_or_fundamental_rights, cite(uk_gdpr_art_6_1_f)), [inputs_relied_on([interests_overridden_by_data_subject_interests_or_fundamental_rights - unsure])]),
    Status = needs_legal_review(open_textured(Key, cite(CitationKey)), [inputs_relied_on(Pairs)]),
    Key == interests_overridden_by_data_subject_interests_or_fundamental_rights,
    CitationKey == uk_gdpr_art_6_1_f,
    Pairs == [interests_overridden_by_data_subject_interests_or_fundamental_rights - unsure].
test(the_recognised_legitimate_interest_atoms_are_distinct) :-
    dif(recognised_legitimate_interest_applies, recognised_legitimate_interest_does_not_apply).
test(the_legitimate_interests_atoms_are_distinct) :-
    dif(legitimate_interests_applies, legitimate_interests_does_not_apply).
test(the_basis_atoms_are_distinct) :-
    dif(legitimate_interest_basis_available, legitimate_interest_basis_not_available).
test(the_difference_atoms_are_distinct) :-
    dif(same, differs),
    dif(same, not_comparable),
    dif(differs, not_comparable).
test(the_objection_atoms_are_distinct) :-
    dif(objection_right_not_engaged, controller_must_no_longer_process),
    dif(objection_right_not_engaged, controller_may_continue_processing),
    dif(controller_must_no_longer_process, controller_may_continue_processing).
test(an_empty_profile_has_no_problem) :-
    findall(Problems, uk_recognised_legitimate_interests_input_problems([], Problems), Answers),
    Answers == [[]].
test(a_well_formed_profile_has_no_problem) :-
    findall(Problems, uk_recognised_legitimate_interests_input_problems([attribute(processing_by_a_public_authority_in_the_performance_of_its_tasks, false), attribute(request_states_need_for_article_6_1_e_processing_with_article_6_3_basis, true), attribute(basis_relied_on, recognised_legitimate_interest), attribute(objection_on_grounds_relating_to_particular_situation, unsure)], Problems), Answers),
    Answers == [[]].
test(a_crisp_key_given_unsure_is_wrong_type) :-
    uk_recognised_legitimate_interests_input_problems([attribute(individual_aged_under_18, unsure)], Problems),
    Problems == [wrong_type(individual_aged_under_18)].
test(a_repeated_key_is_a_duplicate_and_unknown_keys_follow) :-
    uk_recognised_legitimate_interests_input_problems([attribute(color, red), attribute(basis_relied_on, public_task), attribute(basis_relied_on, nonsense), attribute(color, blue)], Problems),
    Problems == [duplicate_key(basis_relied_on), unknown_key(color)].
test(a_term_that_is_not_an_attribute_list_is_wrong_type_profile) :-
    findall(Problems, uk_recognised_legitimate_interests_input_problems(not_a_list, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(a_number_profile_is_wrong_type_profile) :-
    uk_recognised_legitimate_interests_input_problems(42, Problems),
    Problems == [wrong_type(profile)].
test(the_recognised_legitimate_interest_citation_is_recorded) :-
    citation(uk_gdpr_art_6_1_ea, _Record).
test(the_eu_legitimate_interests_citation_is_recorded) :-
    citation(eu_reg_2016_679_art_6_1_f, _Record).
test(the_right_to_object_citation_is_recorded) :-
    citation(uk_gdpr_art_21_1, _Record).
test(the_provenance_marker_holds_for_a_recorded_key) :-
    implements(uk_gdpr_annex_1_para_6).

test(a_well_formed_profile_is_not_reported_as_wrong_type, fail) :-
    uk_recognised_legitimate_interests_input_problems([attribute(basis_relied_on, other_basis)], [wrong_type(basis_relied_on)]).
test(the_provenance_marker_fails_for_an_unrecorded_key, fail) :-
    implements(uk_gdpr_annex_1_para_9).

cp_test_names([the_verdict_term_carries_status_and_citations, the_indeterminate_status_holds_one_bare_key, the_referral_status_destructures, the_recognised_legitimate_interest_atoms_are_distinct, the_legitimate_interests_atoms_are_distinct, the_basis_atoms_are_distinct, the_difference_atoms_are_distinct, the_objection_atoms_are_distinct, an_empty_profile_has_no_problem, a_well_formed_profile_has_no_problem, a_crisp_key_given_unsure_is_wrong_type, a_repeated_key_is_a_duplicate_and_unknown_keys_follow, a_term_that_is_not_an_attribute_list_is_wrong_type_profile, a_number_profile_is_wrong_type_profile, the_recognised_legitimate_interest_citation_is_recorded, the_eu_legitimate_interests_citation_is_recorded, the_right_to_object_citation_is_recorded, the_provenance_marker_holds_for_a_recorded_key]).
cp_test_fail_names([a_well_formed_profile_is_not_reported_as_wrong_type, the_provenance_marker_fails_for_an_unrecorded_key]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
