% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_art36_3_consultation_request_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_art36_3_consultation_request_queries, [gdpr_art36_3_consultation_request_profile_keys/1, gdpr_art36_3_consultation_request_what_if/4, consultation_request_complete/0, data_protection_impact_assessment/0]).
:- use_module(m__eu_data_protection_gdpr_art36_3_consultation_request_kernel, [gdpr_art36_3_consultation_request_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_art36_3_consultation_request_gdpr_art36_3_consultation_request, [consultation_request_status/4, missing_consultation_request_items/4, gdpr_art36_3_consultation_request_status/2, gdpr_art36_3_consultation_request_checklist/2]).
:- use_module(m__eu_data_protection_gdpr_art36_3_consultation_request_fixtures, [gdpr_art36_3_consultation_request_profile_for/2, gdpr_art36_3_consultation_request_assess/2]).

test(profile_keys_are_the_contract_keys) :-
    gdpr_art36_3_consultation_request_profile_keys(ProfileKeys),
    ProfileKeys == [consultation_under_article_36_1, joint_controllers_or_processors_involved, respective_responsibilities_provided, purposes_and_means_provided, measures_and_safeguards_provided, data_protection_officer_designated, data_protection_officer_contact_details_provided, impact_assessment_provided, other_information_requested_by_supervisory_authority, requested_other_information_provided].
test(the_reexported_input_check_answers) :-
    findall(Problems, gdpr_art36_3_consultation_request_input_problems([attribute(controller_name, acme)], Problems), Answers),
    Answers == [[unknown_key(controller_name)]].
test(root_exports_resolve) :-
    consultation_request_complete,
    data_protection_impact_assessment.
test(status_projection_gives_one_status) :-
    gdpr_art36_3_consultation_request_profile_for(authority_request_not_answered, Profile),
    findall(Status, gdpr_art36_3_consultation_request_status(Profile, Status), Statuses),
    Statuses == [consultation_request_incomplete].
test(compliance_check_complete_request) :-
    gdpr_art36_3_consultation_request_profile_for(officer_designated_contact_given, Profile),
    findall(Result, consultation_request_status(Profile, Result, _, _), Results),
    Results == [consultation_request_complete].
test(enumeration_lists_every_missing_item) :-
    gdpr_art36_3_consultation_request_profile_for(processor_involved_responsibilities_missing, Profile),
    findall(Items, missing_consultation_request_items(Profile, Items, _, _), Answers),
    Answers == [[respective_responsibilities]].
test(justification_checklist_cites_every_point) :-
    gdpr_art36_3_consultation_request_profile_for(impact_assessment_not_provided, Profile),
    findall(Checklist, gdpr_art36_3_consultation_request_checklist(Profile, Checklist), Answers),
    Answers == [[item(respective_responsibilities, met, cite(eu_reg_2016_679_art_36_3_a)), item(purposes_and_means, met, cite(eu_reg_2016_679_art_36_3_b)), item(measures_and_safeguards, met, cite(eu_reg_2016_679_art_36_3_c)), item(data_protection_officer_contact_details, met, cite(eu_reg_2016_679_art_36_3_d)), item(data_protection_impact_assessment, unmet(not_provided(impact_assessment_provided)), cite(eu_reg_2016_679_art_36_3_e)), item(other_requested_information, met, cite(eu_reg_2016_679_art_36_3_f))]].
test(justification_checklist_hands_the_role_question_to_a_human) :-
    gdpr_art36_3_consultation_request_profile_for(roles_not_attested_responsibilities_not_given, Profile),
    gdpr_art36_3_consultation_request_checklist(Profile, [FirstRow|_OtherRows]),
    FirstRow == item(respective_responsibilities, unknown(referred(joint_controllers_or_processors_involved)), cite(eu_reg_2016_679_art_36_3_a)).
test(justification_checklist_is_empty_when_not_governed) :-
    gdpr_art36_3_consultation_request_profile_for(consultation_under_member_state_law, Profile),
    gdpr_art36_3_consultation_request_checklist(Profile, Checklist),
    Checklist == [].
test(what_if_withdrawing_the_assessment_makes_the_request_incomplete) :-
    gdpr_art36_3_consultation_request_profile_for(controller_alone_complete, Profile),
    gdpr_art36_3_consultation_request_what_if(Profile, impact_assessment_provided, false, NewStatus),
    NewStatus == consultation_request_incomplete.
test(what_if_giving_the_contact_details_completes_the_request) :-
    gdpr_art36_3_consultation_request_profile_for(officer_designated_contact_missing, Profile),
    gdpr_art36_3_consultation_request_what_if(Profile, data_protection_officer_contact_details_provided, true, NewStatus),
    NewStatus == consultation_request_complete.
test(what_if_an_out_of_type_value_is_an_input_problem) :-
    gdpr_art36_3_consultation_request_profile_for(controller_alone_complete, Profile),
    gdpr_art36_3_consultation_request_what_if(Profile, impact_assessment_provided, unsure, NewStatus),
    NewStatus == input_problems([wrong_type(impact_assessment_provided)]).
test(the_assess_wrapper_gives_the_verdict) :-
    gdpr_art36_3_consultation_request_assess(consultation_under_member_state_law, Verdict),
    Verdict == gdpr_art36_3_consultation_request_verdict(not_governed_by_article_36_3, [cite(eu_reg_2016_679_art_36_3)]).

test(what_if_does_not_flip_an_unchanged_answer, fail) :-
    gdpr_art36_3_consultation_request_profile_for(controller_alone_complete, Profile),
    gdpr_art36_3_consultation_request_what_if(Profile, impact_assessment_provided, true, consultation_request_incomplete).

cp_test_names([profile_keys_are_the_contract_keys, the_reexported_input_check_answers, root_exports_resolve, status_projection_gives_one_status, compliance_check_complete_request, enumeration_lists_every_missing_item, justification_checklist_cites_every_point, justification_checklist_hands_the_role_question_to_a_human, justification_checklist_is_empty_when_not_governed, what_if_withdrawing_the_assessment_makes_the_request_incomplete, what_if_giving_the_contact_details_completes_the_request, what_if_an_out_of_type_value_is_an_input_problem, the_assess_wrapper_gives_the_verdict]).
cp_test_fail_names([what_if_does_not_flip_an_unchanged_answer]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
