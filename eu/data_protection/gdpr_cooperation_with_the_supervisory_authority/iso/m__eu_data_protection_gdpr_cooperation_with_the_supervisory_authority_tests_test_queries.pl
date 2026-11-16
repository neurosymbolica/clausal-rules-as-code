% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_cooperation_with_the_supervisory_authority_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_cooperation_with_the_supervisory_authority_queries, [gdpr_cooperation_with_the_supervisory_authority_profile_keys/1, gdpr_cooperation_with_the_supervisory_authority_what_if/4]).
:- use_module(m__eu_data_protection_gdpr_cooperation_with_the_supervisory_authority_kernel, [gdpr_cooperation_with_the_supervisory_authority_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_cooperation_with_the_supervisory_authority_gdpr_cooperation_with_the_supervisory_authority, [gdpr_cooperation_with_the_supervisory_authority_status/2, gdpr_cooperation_with_the_supervisory_authority_checklist/2]).
:- use_module(m__eu_data_protection_gdpr_cooperation_with_the_supervisory_authority_fixtures, [gdpr_cooperation_with_the_supervisory_authority_profile_for/2]).

what_if_subject(Subject, Key, Value, Status) :-
    gdpr_cooperation_with_the_supervisory_authority_profile_for(Subject, Profile),
    gdpr_cooperation_with_the_supervisory_authority_what_if(Profile, Key, Value, Status).

test(profile_keys_are_the_contract_keys) :-
    gdpr_cooperation_with_the_supervisory_authority_profile_keys(ProfileKeys),
    ProfileKeys == [acts_as_controller, acts_as_processor, acts_as_representative_of_controller_or_processor, authority_request_made, request_is_in_performance_of_authority_tasks, cooperation_given].
test(input_check_is_reexported) :-
    gdpr_cooperation_with_the_supervisory_authority_input_problems([attribute(acts_as_processor, maybe)], Problems),
    Problems == [wrong_type(acts_as_processor)].
test(status_query_answers) :-
    gdpr_cooperation_with_the_supervisory_authority_profile_for(representative_alone_bound, Profile),
    gdpr_cooperation_with_the_supervisory_authority_status(Profile, Status),
    Status == cooperation_met.
test(checklist_query_cites_every_item) :-
    gdpr_cooperation_with_the_supervisory_authority_profile_for(cooperation_statement_attested_false, Profile),
    gdpr_cooperation_with_the_supervisory_authority_checklist(Profile, Items),
    Items == [item(party_bound, met, cite(eu_reg_2016_679_art_31)), item(request_made, met, cite(eu_reg_2016_679_art_31)), item(request_in_performance_of_tasks, met, cite(eu_reg_2016_679_art_31)), item(cooperation_given, unmet(cooperation_not_given), cite(eu_reg_2016_679_art_31))].
test(checklist_of_a_bad_profile_names_the_problem) :-
    gdpr_cooperation_with_the_supervisory_authority_profile_for(wrong_type_role_key, Profile),
    gdpr_cooperation_with_the_supervisory_authority_checklist(Profile, Items),
    Items == [item(input_check, unmet(input_problems([wrong_type(acts_as_controller)])), cite(eu_reg_2016_679_art_31))].
test(what_if_a_request_is_made) :-
    what_if_subject(no_request_made, authority_request_made, true, Status),
    Status == cooperation_met.
test(what_if_the_caller_becomes_a_processor) :-
    what_if_subject(caller_not_bound, acts_as_processor, true, Status),
    Status == cooperation_met.
test(what_if_the_judgement_is_settled) :-
    what_if_subject(tasks_judgement_unsure, request_is_in_performance_of_authority_tasks, true, Status),
    Status == cooperation_met.
test(what_if_the_judgement_turns_unsure) :-
    what_if_subject(request_made_and_cooperated, request_is_in_performance_of_authority_tasks, unsure, Status),
    Status == needs_legal_review(open_textured(request_is_in_performance_of_authority_tasks, cite(eu_reg_2016_679_art_31)), [inputs_relied_on([request_is_in_performance_of_authority_tasks - unsure])]).
test(what_if_an_absent_key_is_supplied) :-
    what_if_subject(processor_key_missing, acts_as_processor, true, Status),
    Status == cooperation_met.
test(what_if_a_bad_value_is_an_input_problem) :-
    what_if_subject(request_made_and_cooperated, acts_as_controller, unsure, Status),
    Status == input_problems([wrong_type(acts_as_controller)]).
test(what_if_repairs_a_duplicate) :-
    what_if_subject(duplicate_role_key, acts_as_controller, true, Status),
    Status == cooperation_not_required.
test(what_if_answers_once) :-
    gdpr_cooperation_with_the_supervisory_authority_profile_for(cooperation_statement_absent, Profile),
    findall(Status, gdpr_cooperation_with_the_supervisory_authority_what_if(Profile, cooperation_given, attested(true, attestation(by, at, reason, none)), Status), Statuses),
    Statuses == [cooperation_met].

test(what_if_a_request_is_made_is_not_not_required, fail) :-
    what_if_subject(no_request_made, authority_request_made, true, cooperation_not_required).

cp_test_names([profile_keys_are_the_contract_keys, input_check_is_reexported, status_query_answers, checklist_query_cites_every_item, checklist_of_a_bad_profile_names_the_problem, what_if_a_request_is_made, what_if_the_caller_becomes_a_processor, what_if_the_judgement_is_settled, what_if_the_judgement_turns_unsure, what_if_an_absent_key_is_supplied, what_if_a_bad_value_is_an_input_problem, what_if_repairs_a_duplicate, what_if_answers_once]).
cp_test_fail_names([what_if_a_request_is_made_is_not_not_required]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
