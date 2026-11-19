% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_queries, [gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_profile_keys/1, gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_what_if/4, gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_action_compliance/3]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_kernel, [gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_gdpr_data_subject_rights_objection_notice_and_erasure_follow_up, [decide_gdpr_data_subject_rights_objection_notice_and_erasure_follow_up/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_fixtures, [gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_profile_for/2]).

compliance_of(Subject, Action, Verdicts) :-
    gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_profile_for(Subject, Profile),
    findall(Verdict, gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_action_compliance(Profile, Action, Verdict), Verdicts).

test(profile_keys_are_the_contract_keys) :-
    gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_profile_keys(ProfileKeys),
    ProfileKeys == [right_to_object_applies, first_communication_with_data_subject_has_taken_place, right_explicitly_brought_to_attention_by_first_communication, right_presented_separately_from_other_information, right_presented_clearly, controller_made_personal_data_public, controller_obliged_to_erase_under_article_17_1, reasonable_steps_taken_to_inform_other_controllers].
test(the_reexported_input_check_reports_problems) :-
    findall(Problems, gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_input_problems([attribute(marketing_channel, email)], Problems), Answers),
    Answers == [[unknown_key(marketing_channel)]].
test(eligibility_verdict_is_cited) :-
    gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_profile_for(steps_failed_near_miss, Profile),
    decide_gdpr_data_subject_rights_objection_notice_and_erasure_follow_up(Profile, gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_verdict(determination(notice_complies, follow_up_duty_not_met), [cite(eu_reg_2016_679_art_17_2), cite(eu_reg_2016_679_art_21_4)])).
test(what_if_clarity_false_flips_the_notice) :-
    gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_profile_for(duties_fulfilled, Profile),
    findall(Status, gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_what_if(Profile, right_presented_clearly, false, Status), Statuses),
    Statuses == [determination(notice_does_not_comply, follow_up_duty_met)].
test(what_if_steps_true_meets_the_duty) :-
    gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_profile_for(steps_failed_near_miss, Profile),
    gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_what_if(Profile, reasonable_steps_taken_to_inform_other_controllers, true, determination(notice_complies, follow_up_duty_met)).
test(what_if_no_right_makes_notice_not_owed) :-
    gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_profile_for(duties_fulfilled, Profile),
    gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_what_if(Profile, right_to_object_applies, attested(false, attestation(host_user, host_time, stated_reason, none)), determination(notice_not_owed, follow_up_duty_met)).
test(omitting_the_notice_is_forbidden_where_the_right_exists) :-
    compliance_of(duties_fulfilled, first_communication_without_objection_notice, Verdicts),
    Verdicts == [forbidden].
test(omitting_the_notice_is_permitted_where_no_right_exists) :-
    compliance_of(no_right_to_object, first_communication_without_objection_notice, Verdicts),
    Verdicts == [permitted].
test(omitting_the_notice_with_the_right_not_attested_is_referred) :-
    compliance_of(right_not_attested, first_communication_without_objection_notice, Verdicts),
    Verdicts == [needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_21_4), cite(article_21_right_to_object_statement)), [resolution(cite(article_21_right_to_object_statement), not_attempted), inputs_relied_on([right_to_object_applies - absent])])].
test(giving_the_notice_is_permitted) :-
    compliance_of(duties_fulfilled, first_communication_with_objection_notice, Verdicts),
    Verdicts == [permitted].
test(skipping_the_follow_up_is_forbidden_where_the_duty_applies) :-
    compliance_of(duties_fulfilled, conclude_erasure_without_informing_other_controllers, Verdicts),
    Verdicts == [forbidden].
test(skipping_the_follow_up_is_permitted_for_data_not_made_public) :-
    compliance_of(data_not_public, conclude_erasure_without_informing_other_controllers, Verdicts),
    Verdicts == [permitted].
test(skipping_the_follow_up_is_permitted_without_an_obligation) :-
    compliance_of(no_obligation_to_erase, conclude_erasure_without_informing_other_controllers, Verdicts),
    Verdicts == [permitted].
test(skipping_the_follow_up_with_publication_unstated_asks_for_it) :-
    compliance_of(publication_not_stated, conclude_erasure_without_informing_other_controllers, Verdicts),
    Verdicts == [indeterminate([controller_made_personal_data_public])].
test(skipping_the_follow_up_with_obligation_unattested_is_referred) :-
    compliance_of(obligation_not_attested, conclude_erasure_without_informing_other_controllers, Verdicts),
    Verdicts == [needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_17_2), cite(article_17_1_erasure_obligation_statement)), [resolution(cite(article_17_1_erasure_obligation_statement), not_attempted), inputs_relied_on([controller_obliged_to_erase_under_article_17_1 - absent])])].
test(informing_the_other_controllers_is_permitted) :-
    compliance_of(duties_fulfilled, conclude_erasure_after_informing_other_controllers, Verdicts),
    Verdicts == [permitted].
test(a_malformed_profile_gets_input_problems_for_an_action) :-
    compliance_of(unknown_key_present, conclude_erasure_without_informing_other_controllers, Verdicts),
    Verdicts == [input_problems([unknown_key(marketing_channel)])].

test(an_unknown_action_gets_no_verdict, fail) :-
    gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_profile_for(duties_fulfilled, Profile),
    gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_action_compliance(Profile, publish_the_data, _Verdict).

cp_test_names([profile_keys_are_the_contract_keys, the_reexported_input_check_reports_problems, eligibility_verdict_is_cited, what_if_clarity_false_flips_the_notice, what_if_steps_true_meets_the_duty, what_if_no_right_makes_notice_not_owed, omitting_the_notice_is_forbidden_where_the_right_exists, omitting_the_notice_is_permitted_where_no_right_exists, omitting_the_notice_with_the_right_not_attested_is_referred, giving_the_notice_is_permitted, skipping_the_follow_up_is_forbidden_where_the_duty_applies, skipping_the_follow_up_is_permitted_for_data_not_made_public, skipping_the_follow_up_is_permitted_without_an_obligation, skipping_the_follow_up_with_publication_unstated_asks_for_it, skipping_the_follow_up_with_obligation_unattested_is_referred, informing_the_other_controllers_is_permitted, a_malformed_profile_gets_input_problems_for_an_action]).
cp_test_fail_names([an_unknown_action_gets_no_verdict]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
