% SPDX-License-Identifier: EUPL-1.2
:- module(m__ae_uae_pdpl_scope_and_exclusions_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__ae_uae_pdpl_scope_and_exclusions_uae_pdpl_scope_and_exclusions, [pdpl_applies/3, pdpl_in_force/3]).
:- use_module(m__ae_uae_pdpl_scope_and_exclusions_queries, [uae_pdpl_scope_and_exclusions_profile_keys/1, uae_pdpl_scope_and_exclusions_what_if/4, indeterminate/1, needs_legal_review/2, open_textured/2, inputs_relied_on/1, input_problems/1, duplicate_key/1]).
:- use_module(m__ae_uae_pdpl_scope_and_exclusions_kernel, [uae_pdpl_scope_and_exclusions_input_problems/2]).
:- use_module(m__ae_uae_pdpl_scope_and_exclusions_uae_pdpl_scope_and_exclusions, [uae_pdpl_scope_and_exclusions_checklist/2]).
:- use_module(m__ae_uae_pdpl_scope_and_exclusions_fixtures, [uae_pdpl_scope_and_exclusions_profile_for/2]).

baseline(Profile) :-
    uae_pdpl_scope_and_exclusions_profile_for(applies_on_commencement_day, Profile).

exclusion_key(personal_data_is_government_data).
exclusion_key(governmental_entity_controls_or_processes).
exclusion_key(personal_data_held_by_security_or_judicial_authorities).
exclusion_key(data_subject_processing_own_data_for_personal_purposes).
exclusion_key(personal_health_data_with_own_protection_legislation).
exclusion_key(personal_banking_or_credit_data_with_own_protection_legislation).
exclusion_key(free_zone_company_or_establishment_with_own_data_protection_legislation).

exclusion_flips(ExclusionKey) :-
    exclusion_key(ExclusionKey),
    baseline(Profile),
    findall(Status, uae_pdpl_scope_and_exclusions_what_if(Profile, ExclusionKey, true, Status), [does_not_apply]).

cited_item(item(_, _, cite(CitationKey))) :-
    atom(CitationKey).

test(profile_keys_are_the_contract_keys) :-
    uae_pdpl_scope_and_exclusions_profile_keys(ProfileKeys),
    ProfileKeys == [processing_date, activity_is_processing_of_personal_data, personal_data_is_government_data, governmental_entity_controls_or_processes, personal_data_held_by_security_or_judicial_authorities, data_subject_processing_own_data_for_personal_purposes, personal_health_data_with_own_protection_legislation, personal_banking_or_credit_data_with_own_protection_legislation, free_zone_company_or_establishment_with_own_data_protection_legislation, data_subject_resides_or_has_place_of_business_in_state, controller_or_processor_resides_in_state, data_subject_inside_state].
test(the_eligibility_query_answers_once) :-
    baseline(Profile),
    findall(Result, pdpl_applies(Profile, Result, _), Results),
    Results == [applies].
test(the_in_force_query_answers_through_queries) :-
    pdpl_in_force([attribute(processing_date, date(2022, 1, 2))], in_force, [cite(uae_pdpl_art_31)]).
test(the_input_check_through_queries) :-
    uae_pdpl_scope_and_exclusions_input_problems([attribute(colour, red)], [unknown_key(colour)]).
test(every_checklist_item_is_cited) :-
    baseline(Profile),
    uae_pdpl_scope_and_exclusions_checklist(Profile, Items),
    length(Items, 10),
    maplist(cited_item, Items).
test(the_checklist_marks_a_held_exclusion_unmet) :-
    uae_pdpl_scope_and_exclusions_profile_for(government_data_excluded, Profile),
    uae_pdpl_scope_and_exclusions_checklist(Profile, Items),
    member(item(government_data_exclusion_does_not_hold, unmet(personal_data_is_government_data), cite(uae_pdpl_art_2_2_a)), Items).
test(every_exclusion_flips_applies_by_what_if) :-
    findall(ExclusionKey, exclusion_flips(ExclusionKey), Flipping),
    length(Flipping, 7).
test(what_if_the_day_before_is_not_in_force) :-
    baseline(Profile),
    uae_pdpl_scope_and_exclusions_what_if(Profile, processing_date, date(2022, 1, 1), not_in_force).
test(what_if_an_unsure_judgement_is_referred) :-
    baseline(Profile),
    uae_pdpl_scope_and_exclusions_what_if(Profile, governmental_entity_controls_or_processes, unsure, Status),
    Status = needs_legal_review(Reason, Context),
    needs_legal_review(Reason, Context),
    Reason == open_textured(governmental_entity_controls_or_processes, cite(uae_pdpl_art_2_2_b)).
test(what_if_replaces_a_duplicated_key) :-
    uae_pdpl_scope_and_exclusions_profile_for(duplicate_data_subject_inside_state, Profile),
    findall(Status, uae_pdpl_scope_and_exclusions_what_if(Profile, data_subject_inside_state, false, Status), Statuses),
    Statuses == [applies].
test(what_if_a_wrong_value_is_an_input_problem) :-
    baseline(Profile),
    uae_pdpl_scope_and_exclusions_what_if(Profile, data_subject_inside_state, unsure, input_problems([wrong_type(data_subject_inside_state)])).
test(what_if_removing_every_way_does_not_apply) :-
    baseline(Profile),
    uae_pdpl_scope_and_exclusions_what_if(Profile, data_subject_resides_or_has_place_of_business_in_state, false, does_not_apply).
test(the_constructors_recognise_the_answers) :-
    uae_pdpl_scope_and_exclusions_profile_for(processing_date_missing, MissingProfile),
    pdpl_applies(MissingProfile, indeterminate(MissingKeys), []),
    indeterminate(MissingKeys),
    uae_pdpl_scope_and_exclusions_profile_for(processing_judgement_unsure, UnsureProfile),
    pdpl_applies(UnsureProfile, needs_legal_review(open_textured(ReferredKey, CitationTerm), [inputs_relied_on(ReliedPairs)]), []),
    open_textured(ReferredKey, CitationTerm),
    inputs_relied_on(ReliedPairs),
    uae_pdpl_scope_and_exclusions_profile_for(duplicate_data_subject_inside_state, DuplicateProfile),
    pdpl_applies(DuplicateProfile, input_problems(ProblemList), []),
    input_problems(ProblemList),
    ProblemList = [duplicate_key(DuplicateKey)],
    duplicate_key(DuplicateKey).

test(a_malformed_profile_has_no_checklist, fail) :-
    uae_pdpl_scope_and_exclusions_profile_for(unknown_key_colour, Profile),
    uae_pdpl_scope_and_exclusions_checklist(Profile, _).
test(what_if_the_day_before_is_not_applies, fail) :-
    baseline(Profile),
    uae_pdpl_scope_and_exclusions_what_if(Profile, processing_date, date(2022, 1, 1), applies).

cp_test_names([profile_keys_are_the_contract_keys, the_eligibility_query_answers_once, the_in_force_query_answers_through_queries, the_input_check_through_queries, every_checklist_item_is_cited, the_checklist_marks_a_held_exclusion_unmet, every_exclusion_flips_applies_by_what_if, what_if_the_day_before_is_not_in_force, what_if_an_unsure_judgement_is_referred, what_if_replaces_a_duplicated_key, what_if_a_wrong_value_is_an_input_problem, what_if_removing_every_way_does_not_apply, the_constructors_recognise_the_answers]).
cp_test_fail_names([a_malformed_profile_has_no_checklist, what_if_the_day_before_is_not_applies]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
