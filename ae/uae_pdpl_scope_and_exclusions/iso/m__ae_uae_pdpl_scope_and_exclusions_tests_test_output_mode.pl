% SPDX-License-Identifier: EUPL-1.2
:- module(m__ae_uae_pdpl_scope_and_exclusions_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__ae_uae_pdpl_scope_and_exclusions_uae_pdpl_scope_and_exclusions, [pdpl_applies/3, pdpl_in_force/3, decide_uae_pdpl_scope_and_exclusions/2, uae_pdpl_scope_and_exclusions_status/2]).
:- use_module(m__ae_uae_pdpl_scope_and_exclusions_fixtures, [uae_pdpl_scope_and_exclusions_subject/1, uae_pdpl_scope_and_exclusions_profile_for/2]).

applies_citations([cite(uae_pdpl_art_1_personal_data), cite(uae_pdpl_art_1_processing), cite(uae_pdpl_art_2_1), cite(uae_pdpl_art_2_1_a), cite(uae_pdpl_art_2_1_b), cite(uae_pdpl_art_2_1_c), cite(uae_pdpl_art_2_2), cite(uae_pdpl_art_31)]).

answers_for(Subject, Answers) :-
    uae_pdpl_scope_and_exclusions_profile_for(Subject, Profile),
    findall(Result - Citations, pdpl_applies(Profile, Result, Citations), Answers).

in_force_answers_for(Subject, Answers) :-
    uae_pdpl_scope_and_exclusions_profile_for(Subject, Profile),
    findall(Result - Citations, pdpl_in_force(Profile, Result, Citations), Answers).

test(the_baseline_profile_yields_exactly_one_status) :-
    uae_pdpl_scope_and_exclusions_profile_for(applies_on_commencement_day, Profile),
    findall(Status, uae_pdpl_scope_and_exclusions_status(Profile, Status), Statuses),
    Statuses == [applies].
test(the_verdict_carries_a_citation) :-
    uae_pdpl_scope_and_exclusions_profile_for(applies_on_commencement_day, Profile),
    decide_uae_pdpl_scope_and_exclusions(Profile, uae_pdpl_scope_and_exclusions_verdict(applies, [_FirstCitation|_OtherCitations])).
test(applies_on_the_commencement_day) :-
    applies_citations(Citations),
    answers_for(applies_on_commencement_day, Answers),
    Answers == [applies - Citations].
test(applies_on_the_last_contract_day) :-
    applies_citations(Citations),
    answers_for(applies_on_last_contract_day, Answers),
    Answers == [applies - Citations].
test(applies_on_a_leap_day) :-
    applies_citations(Citations),
    answers_for(leap_day_processing_date, Answers),
    Answers == [applies - Citations].
test(not_in_force_on_the_day_before) :-
    answers_for(not_in_force_on_day_before_commencement, Answers),
    Answers == [not_in_force - [cite(uae_pdpl_art_31)]].
test(not_in_force_in_year_one) :-
    answers_for(not_in_force_in_year_one, Answers),
    Answers == [not_in_force - [cite(uae_pdpl_art_31)]].
test(not_processing_does_not_apply) :-
    answers_for(not_processing_of_personal_data, Answers),
    Answers == [does_not_apply - [cite(uae_pdpl_art_2_1), cite(uae_pdpl_art_2_2)]].
test(no_way_does_not_apply) :-
    answers_for(no_way_of_scope_met, Answers),
    Answers == [does_not_apply - [cite(uae_pdpl_art_2_1), cite(uae_pdpl_art_2_2)]].
test(the_third_way_applies) :-
    applies_citations(Citations),
    answers_for(foreign_controller_with_data_subject_inside_state, Answers),
    Answers == [applies - Citations].
test(the_second_way_applies) :-
    applies_citations(Citations),
    answers_for(resident_controller_with_data_subjects_abroad, Answers),
    Answers == [applies - Citations].
test(the_missing_day_is_named) :-
    answers_for(processing_date_missing, Answers),
    Answers == [indeterminate([processing_date]) - []].
test(the_missing_processing_judgement_is_named) :-
    answers_for(processing_judgement_missing, Answers),
    Answers == [indeterminate([activity_is_processing_of_personal_data]) - []].
test(the_missing_free_zone_judgement_is_named) :-
    answers_for(free_zone_judgement_missing, Answers),
    Answers == [indeterminate([free_zone_company_or_establishment_with_own_data_protection_legislation]) - []].
test(the_first_way_key_is_named_when_all_are_missing) :-
    answers_for(way_keys_missing, Answers),
    Answers == [indeterminate([data_subject_resides_or_has_place_of_business_in_state]) - []].
test(the_controller_residence_is_named) :-
    answers_for(controller_residence_missing, Answers),
    Answers == [indeterminate([controller_or_processor_resides_in_state]) - []].
test(a_missing_key_is_named_before_an_unsure_one_is_referred) :-
    answers_for(government_data_unsure_with_free_zone_missing, Answers),
    Answers == [indeterminate([free_zone_company_or_establishment_with_own_data_protection_legislation]) - []].
test(the_unsure_processing_judgement_is_referred_with_every_pair) :-
    answers_for(processing_judgement_unsure, Answers),
    Answers == [needs_legal_review(open_textured(activity_is_processing_of_personal_data, cite(uae_pdpl_art_1_personal_data)), [inputs_relied_on([processing_date - date(2022, 1, 2), activity_is_processing_of_personal_data - unsure, personal_data_is_government_data - false, governmental_entity_controls_or_processes - false, personal_data_held_by_security_or_judicial_authorities - false, data_subject_processing_own_data_for_personal_purposes - false, personal_health_data_with_own_protection_legislation - false, personal_banking_or_credit_data_with_own_protection_legislation - false, free_zone_company_or_establishment_with_own_data_protection_legislation - false, data_subject_resides_or_has_place_of_business_in_state - true, controller_or_processor_resides_in_state - false, data_subject_inside_state - false])]) - []].
test(the_unsure_free_zone_judgement_is_referred) :-
    answers_for(free_zone_judgement_unsure, Answers),
    Answers = [needs_legal_review(open_textured(free_zone_company_or_establishment_with_own_data_protection_legislation, cite(uae_pdpl_art_2_2_g)), [inputs_relied_on(ReliedPairs)]) - []],
    length(ReliedPairs, 12),
    member(free_zone_company_or_establishment_with_own_data_protection_legislation - unsure, ReliedPairs).
test(an_impossible_day_is_an_input_problem) :-
    answers_for(impossible_processing_date, Answers),
    Answers == [input_problems([wrong_type(processing_date)]) - []].
test(a_duplicate_key_is_an_input_problem) :-
    answers_for(duplicate_data_subject_inside_state, Answers),
    Answers == [input_problems([duplicate_key(data_subject_inside_state)]) - []].
test(an_unknown_key_is_an_input_problem) :-
    answers_for(unknown_key_colour, Answers),
    Answers == [input_problems([unknown_key(colour)]) - []].
test(in_force_on_the_commencement_day) :-
    in_force_answers_for(applies_on_commencement_day, Answers),
    Answers == [in_force - [cite(uae_pdpl_art_31)]].
test(in_force_not_on_the_day_before) :-
    in_force_answers_for(not_in_force_on_day_before_commencement, Answers),
    Answers == [not_in_force - [cite(uae_pdpl_art_31)]].
test(in_force_names_the_missing_day) :-
    in_force_answers_for(processing_date_missing, Answers),
    Answers == [indeterminate([processing_date]) - []].
test(in_force_reports_the_input_problem) :-
    in_force_answers_for(unknown_key_colour, Answers),
    Answers == [input_problems([unknown_key(colour)]) - []].
test(enumerate_the_subjects_that_do_not_apply) :-
    findall(Subject, (uae_pdpl_scope_and_exclusions_subject(Subject), uae_pdpl_scope_and_exclusions_profile_for(Subject, Profile), pdpl_applies(Profile, does_not_apply, _)), Found),
    sort(Found, FoundSet),
    sort([not_processing_of_personal_data, no_way_of_scope_met, government_data_excluded, governmental_entity_excluded, security_or_judicial_authorities_excluded, personal_purposes_excluded, health_data_with_own_legislation_excluded, banking_or_credit_data_with_own_legislation_excluded, free_zone_establishment_excluded], ExpectedSet),
    FoundSet == ExpectedSet.

cp_test_names([the_baseline_profile_yields_exactly_one_status, the_verdict_carries_a_citation, applies_on_the_commencement_day, applies_on_the_last_contract_day, applies_on_a_leap_day, not_in_force_on_the_day_before, not_in_force_in_year_one, not_processing_does_not_apply, no_way_does_not_apply, the_third_way_applies, the_second_way_applies, the_missing_day_is_named, the_missing_processing_judgement_is_named, the_missing_free_zone_judgement_is_named, the_first_way_key_is_named_when_all_are_missing, the_controller_residence_is_named, a_missing_key_is_named_before_an_unsure_one_is_referred, the_unsure_processing_judgement_is_referred_with_every_pair, the_unsure_free_zone_judgement_is_referred, an_impossible_day_is_an_input_problem, a_duplicate_key_is_an_input_problem, an_unknown_key_is_an_input_problem, in_force_on_the_commencement_day, in_force_not_on_the_day_before, in_force_names_the_missing_day, in_force_reports_the_input_problem, enumerate_the_subjects_that_do_not_apply]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
