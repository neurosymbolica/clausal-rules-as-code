% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_cooperation_with_the_supervisory_authority_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_cooperation_with_the_supervisory_authority_queries, [gdpr_cooperation_with_the_supervisory_authority_profile_keys/1, gdpr_cooperation_with_the_supervisory_authority_what_if/4, acts_as_controller/0, acts_as_processor/0, acts_as_representative_of_controller_or_processor/0, authority_request_made/0, request_is_in_performance_of_authority_tasks/0, cooperation_given/0, unsure/0]).
:- use_module(m__eu_data_protection_gdpr_cooperation_with_the_supervisory_authority_kernel, [gdpr_cooperation_with_the_supervisory_authority_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_cooperation_with_the_supervisory_authority_gdpr_cooperation_with_the_supervisory_authority, [gdpr_cooperation_with_the_supervisory_authority_status/2, gdpr_cooperation_with_the_supervisory_authority_checklist/2, cooperation_not_required/0, cooperation_met/0, cooperation_not_met/0]).
:- use_module(m__eu_data_protection_gdpr_cooperation_with_the_supervisory_authority_fixtures, [gdpr_cooperation_with_the_supervisory_authority_profile_for/2, gdpr_cooperation_with_the_supervisory_authority_assess/2]).

test(profile_keys_are_the_contract_keys) :-
    gdpr_cooperation_with_the_supervisory_authority_profile_keys(ProfileKeys),
    ProfileKeys == [acts_as_controller, acts_as_processor, acts_as_representative_of_controller_or_processor, authority_request_made, request_is_in_performance_of_authority_tasks, cooperation_given].
test(the_root_export_atoms_are_served) :-
    acts_as_controller,
    acts_as_processor,
    acts_as_representative_of_controller_or_processor,
    authority_request_made,
    request_is_in_performance_of_authority_tasks,
    cooperation_given,
    unsure,
    cooperation_not_required,
    cooperation_met,
    cooperation_not_met.
test(status_reads_the_verdict) :-
    gdpr_cooperation_with_the_supervisory_authority_profile_for(controller_cooperated, Profile),
    findall(Status, gdpr_cooperation_with_the_supervisory_authority_status(Profile, Status), Statuses),
    Statuses == [cooperation_met].
test(assess_wraps_the_verdict) :-
    gdpr_cooperation_with_the_supervisory_authority_assess(no_request, gdpr_cooperation_with_the_supervisory_authority_verdict(cooperation_not_required, [cite(eu_reg_2016_679_art_31)])).
test(checklist_cites_every_item_for_a_met_duty) :-
    gdpr_cooperation_with_the_supervisory_authority_profile_for(controller_cooperated, Profile),
    gdpr_cooperation_with_the_supervisory_authority_checklist(Profile, Items),
    Items == [item(bound_by_article_31, met, cite(eu_reg_2016_679_art_31)), item(request_made, met, cite(eu_reg_2016_679_art_31)), item(request_in_performance_of_tasks, met, cite(eu_reg_2016_679_art_31)), item(cooperation_given, met, cite(eu_reg_2016_679_art_31))].
test(checklist_marks_the_unmet_item_for_a_refusal) :-
    gdpr_cooperation_with_the_supervisory_authority_profile_for(controller_refused, Profile),
    gdpr_cooperation_with_the_supervisory_authority_checklist(Profile, Items),
    member(item(cooperation_given, unmet(cooperation_not_given), cite(eu_reg_2016_679_art_31)), Items).
test(checklist_reports_input_problems) :-
    gdpr_cooperation_with_the_supervisory_authority_profile_for(wrong_types, Profile),
    gdpr_cooperation_with_the_supervisory_authority_checklist(Profile, [item(input_check, unmet(input_problems([wrong_type(acts_as_processor), wrong_type(cooperation_given)])), cite(eu_reg_2016_679_art_31))]).
test(what_if_the_statement_turns_false) :-
    gdpr_cooperation_with_the_supervisory_authority_profile_for(controller_cooperated, Profile),
    gdpr_cooperation_with_the_supervisory_authority_what_if(Profile, cooperation_given, attested(false, attestation(host, at_time, reason, none)), cooperation_not_met).
test(what_if_no_request_was_made) :-
    gdpr_cooperation_with_the_supervisory_authority_profile_for(controller_cooperated, Profile),
    findall(Status, gdpr_cooperation_with_the_supervisory_authority_what_if(Profile, authority_request_made, false, Status), Statuses),
    Statuses == [cooperation_not_required].
test(what_if_the_judgement_is_unsure) :-
    gdpr_cooperation_with_the_supervisory_authority_profile_for(controller_cooperated, Profile),
    gdpr_cooperation_with_the_supervisory_authority_what_if(Profile, request_is_in_performance_of_authority_tasks, unsure, needs_legal_review(open_textured(request_is_in_performance_of_authority_tasks, cite(eu_reg_2016_679_art_31)), [inputs_relied_on([request_is_in_performance_of_authority_tasks - unsure])])).
test(what_if_supplies_an_absent_key) :-
    gdpr_cooperation_with_the_supervisory_authority_profile_for(two_keys_missing, Profile),
    gdpr_cooperation_with_the_supervisory_authority_what_if(Profile, authority_request_made, true, indeterminate([request_is_in_performance_of_authority_tasks])).
test(what_if_a_wrong_value_is_an_input_problem) :-
    gdpr_cooperation_with_the_supervisory_authority_profile_for(controller_cooperated, Profile),
    gdpr_cooperation_with_the_supervisory_authority_what_if(Profile, acts_as_controller, unsure, input_problems([wrong_type(acts_as_controller)])).
test(the_reexported_input_check_accepts_a_fixture) :-
    gdpr_cooperation_with_the_supervisory_authority_profile_for(controller_cooperated, Profile),
    gdpr_cooperation_with_the_supervisory_authority_input_problems(Profile, []).
test(the_reexported_input_check_names_problems) :-
    gdpr_cooperation_with_the_supervisory_authority_input_problems([attribute(colour, blue)], [unknown_key(colour)]).

test(what_if_the_original_status_is_not_kept, fail) :-
    gdpr_cooperation_with_the_supervisory_authority_profile_for(controller_cooperated, Profile),
    gdpr_cooperation_with_the_supervisory_authority_what_if(Profile, authority_request_made, false, cooperation_met).

cp_test_names([profile_keys_are_the_contract_keys, the_root_export_atoms_are_served, status_reads_the_verdict, assess_wraps_the_verdict, checklist_cites_every_item_for_a_met_duty, checklist_marks_the_unmet_item_for_a_refusal, checklist_reports_input_problems, what_if_the_statement_turns_false, what_if_no_request_was_made, what_if_the_judgement_is_unsure, what_if_supplies_an_absent_key, what_if_a_wrong_value_is_an_input_problem, the_reexported_input_check_accepts_a_fixture, the_reexported_input_check_names_problems]).
cp_test_fail_names([what_if_the_original_status_is_not_kept]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
