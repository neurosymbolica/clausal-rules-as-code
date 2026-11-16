% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_queries, [request_decision/2, request_exception/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_request_exception, [decide_request_exception/2, request_exception_status/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_fixtures, [gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_profile_for/2]).

test(engaged_portability_yields_exactly_one_status) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_profile_for(portability_engaged, Profile),
    findall(Status, request_exception_status(Profile, Status), Statuses),
    Statuses == [none].
test(engaged_portability_cites_art_20_1) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_profile_for(portability_engaged, Profile),
    decide_request_exception(Profile, request_exception_verdict(none, [cite(eu_reg_2016_679_art_20_1)])).
test(public_task_cites_basis_and_exception) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_profile_for(portability_public_task, Profile),
    decide_request_exception(Profile, request_exception_verdict(art20_3_public_task, [cite(eu_reg_2016_679_art_20_1), cite(eu_reg_2016_679_art_20_3)])).
test(not_engaged_has_no_citation) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_profile_for(portability_not_automated, Profile),
    decide_request_exception(Profile, request_exception_verdict(none, [])).
test(decision_is_a_single_answer) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_profile_for(objection_art21_2_engaged, Profile),
    findall(Comply, request_decision(Profile, Comply), Answers),
    Answers == [must_comply].
test(exception_is_a_single_answer) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_profile_for(portability_manifestly_excessive, Profile),
    findall(Exception, request_exception(Profile, Exception), Answers),
    Answers == [art12_5_manifestly_unfounded_or_excessive].
test(objection_art21_2_has_no_balancing) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_profile_for(objection_art21_2_no_balancing, Profile),
    request_decision(Profile, must_comply),
    request_exception(Profile, none).
test(art21_1_compelling_grounds) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_profile_for(objection_art21_1_compelling, Profile),
    request_decision(Profile, need_not_comply),
    request_exception(Profile, art21_1_compelling_legitimate_grounds).
test(art21_1_legal_claims) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_profile_for(objection_art21_1_legal_claims, Profile),
    request_exception(Profile, art21_1_legal_claims).
test(art21_6_public_interest) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_profile_for(objection_art21_6_public_interest, Profile),
    request_exception(Profile, art21_6_public_interest_task).
test(art22_contract) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_profile_for(automated_contract, Profile),
    request_exception(Profile, art22_2_a).
test(art22_law_authorised) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_profile_for(automated_law_authorised, Profile),
    request_exception(Profile, art22_2_b).
test(art22_consent_with_safeguarded_special_categories) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_profile_for(automated_consent_special_safeguarded, Profile),
    request_exception(Profile, art22_2_c).
test(art23_restriction) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_profile_for(portability_restricted_by_law, Profile),
    request_exception(Profile, art23_legislative_restriction).
test(unable_to_identify) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_profile_for(portability_unable_to_identify, Profile),
    request_exception(Profile, art12_2_unable_to_identify).
test(missing_keys_in_root_order) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_profile_for(missing_keys_automated, Profile),
    request_decision(Profile, indeterminate([decision_based_solely_on_automated_processing, decision_produces_legal_or_similarly_significant_effects])).
test(missing_objection_ground) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_profile_for(objection_missing_ground, Profile),
    request_decision(Profile, indeterminate([objection_ground_claimed])).
test(unsure_judgement_is_referred_with_citation_and_pairs) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_profile_for(portability_open_unsure_rights_of_others, Profile),
    request_decision(Profile, needs_legal_review(open_textured(transmission_would_adversely_affect_rights_and_freedoms_of_others, cite(eu_reg_2016_679_art_20_4)), [inputs_relied_on([request_type - portability, transmission_would_adversely_affect_rights_and_freedoms_of_others - unsure])])).
test(unsure_particular_situation_is_referred) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_profile_for(objection_art21_1_unsure_particular, Profile),
    request_decision(Profile, needs_legal_review(open_textured(objection_grounds_relate_to_particular_situation, cite(eu_reg_2016_679_art_21_1)), _Context)).

cp_test_names([engaged_portability_yields_exactly_one_status, engaged_portability_cites_art_20_1, public_task_cites_basis_and_exception, not_engaged_has_no_citation, decision_is_a_single_answer, exception_is_a_single_answer, objection_art21_2_has_no_balancing, art21_1_compelling_grounds, art21_1_legal_claims, art21_6_public_interest, art22_contract, art22_law_authorised, art22_consent_with_safeguarded_special_categories, art23_restriction, unable_to_identify, missing_keys_in_root_order, missing_objection_ground, unsure_judgement_is_referred_with_citation_and_pairs, unsure_particular_situation_is_referred]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
