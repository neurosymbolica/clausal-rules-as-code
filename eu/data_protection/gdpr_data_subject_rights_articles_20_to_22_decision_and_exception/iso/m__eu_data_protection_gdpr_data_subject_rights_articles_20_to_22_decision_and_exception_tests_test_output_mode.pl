% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_request_exception, [request_decision/2, request_exception/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_request_exception, [decide_request_exception/2, request_exception_verdict/2, request_exception_checklist/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_fixtures, [gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_profile_for/2]).

subject_profile(Subject, Profile) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_profile_for(Subject, Profile).

decisions_of(Subject, Answers) :-
    subject_profile(Subject, Profile),
    findall(Comply, request_decision(Profile, Comply), Answers).

exceptions_of(Subject, Answers) :-
    subject_profile(Subject, Profile),
    findall(Exception, request_exception(Profile, Exception), Answers).

verdicts_of(Subject, Verdicts) :-
    subject_profile(Subject, Profile),
    findall(Verdict, request_exception_verdict(Profile, Verdict), Verdicts).

test(route_v_must_comply_once) :-
    verdicts_of(portability_engaged_must_comply, Verdicts),
    Verdicts == [gdpr_data_subject_request_verdict(must_comply, art20_1, none, [], [])].
test(route_ii_not_engaged_once) :-
    verdicts_of(portability_not_automated_not_engaged, Verdicts),
    Verdicts == [gdpr_data_subject_request_verdict(need_not_comply, none, none, [], [])].
test(route_iii_public_task_once) :-
    verdicts_of(portability_public_task_relieves, Verdicts),
    Verdicts == [gdpr_data_subject_request_verdict(need_not_comply, art20_1, art20_3_public_task, [], [])].
test(route_iii_contract_carries_the_safeguards) :-
    verdicts_of(automated_decision_contract_with_safeguards, Verdicts),
    Verdicts == [gdpr_data_subject_request_verdict(need_not_comply, art22_1, art22_2_a, [human_intervention, express_point_of_view, contest_decision], [])].
test(route_iii_manifestly_excessive_carries_the_fee) :-
    verdicts_of(manifestly_excessive_fee_open, Verdicts),
    Verdicts == [gdpr_data_subject_request_verdict(need_not_comply, art20_1, art12_5_manifestly_unfounded_or_excessive, [reasonable_fee_may_be_charged], [])].
test(route_iii_authorising_law_once) :-
    exceptions_of(automated_decision_authorised_by_law_attested, Answers),
    Answers == [art22_2_b].
test(route_iii_legislative_restriction_once) :-
    exceptions_of(legislative_restriction_attested_true, Answers),
    Answers == [art23_legislative_restriction].
test(route_iii_a_suspension_once) :-
    decisions_of(identity_doubts_suspend, Answers),
    Answers == [suspended(art12_6_identity_not_confirmed)].
test(route_iv_missing_keys_listed_all_once) :-
    decisions_of(portability_missing_keys, Answers),
    Answers == [indeterminate([personal_data_provided_by_data_subject, processing_based_on_consent_or_contract, processing_carried_out_by_automated_means])].
test(route_iv_safeguards_key_missing_once) :-
    decisions_of(automated_decision_special_category_safeguards_missing, Answers),
    Answers == [indeterminate([special_category_condition_and_safeguards_met_for_decision])].
test(route_iv_contract_unsure_refers_once) :-
    decisions_of(automated_decision_contract_unsure_refers, Answers),
    Answers == [needs_legal_review(open_textured(decision_necessary_for_contract_with_data_subject, cite(eu_reg_2016_679_art_22_2_a)), [inputs_relied_on([request_type - automated_decision, decision_necessary_for_contract_with_data_subject - unsure])])].
test(route_iv_identity_doubts_unsure_refers_once) :-
    decisions_of(identity_doubts_unsure_refers, Answers),
    Answers == [needs_legal_review(open_textured(reasonable_doubts_about_identity, cite(eu_reg_2016_679_art_12_6)), [inputs_relied_on([request_type - portability, reasonable_doubts_about_identity - unsure])])].
test(route_iv_rights_of_others_unsure_refers_once) :-
    decisions_of(portability_rights_of_others_unsure_refers, Answers),
    Answers == [needs_legal_review(open_textured(transmission_would_adversely_affect_rights_and_freedoms_of_others, cite(eu_reg_2016_679_art_20_4)), [inputs_relied_on([request_type - portability, transmission_would_adversely_affect_rights_and_freedoms_of_others - unsure])])].
test(route_i_types_disagree_once) :-
    decisions_of(request_type_absent_types_disagree, Answers),
    Answers == [indeterminate([request_type])].
test(route_i_types_agree_once) :-
    verdicts_of(request_type_absent_all_types_not_engaged, Verdicts),
    Verdicts == [gdpr_data_subject_request_verdict(need_not_comply, none, none, [], [])].
test(route_i_grounds_disagree_once) :-
    decisions_of(objection_ground_absent_grounds_disagree, Answers),
    Answers == [indeterminate([objection_ground_claimed])].
test(route_0_input_problems_once) :-
    verdicts_of(duplicate_and_unknown_keys, Verdicts),
    Verdicts == [gdpr_data_subject_request_verdict(input_problems([duplicate_key(request_type), unknown_key(colour)]), none, none, [], [])].
test(the_relief_verdict_carries_its_citation) :-
    subject_profile(portability_public_task_relieves, Profile),
    findall(Verdict, decide_request_exception(Profile, Verdict), Verdicts),
    Verdicts == [request_exception_verdict(art20_3_public_task, [cite(eu_reg_2016_679_art_20_3)])].
test(the_no_exception_verdict_carries_no_citation) :-
    subject_profile(portability_engaged_must_comply, Profile),
    findall(Verdict, decide_request_exception(Profile, Verdict), Verdicts),
    Verdicts == [request_exception_verdict(none, [])].
test(the_checklist_reads_out_every_limb_with_its_citation) :-
    subject_profile(portability_engaged_must_comply, Profile),
    findall(ChecklistItems, request_exception_checklist(Profile, ChecklistItems), Checklists),
    Checklists == [[item(engagement(portability), met, cite(eu_reg_2016_679_art_20_1)), item(suspension(portability), unmet(suspension), cite(eu_reg_2016_679_art_12_6)), item(exception(portability, art20_3_public_task), unmet(art20_3_public_task), cite(eu_reg_2016_679_art_20_3)), item(exception(portability, art20_4_rights_of_others), unmet(art20_4_rights_of_others), cite(eu_reg_2016_679_art_20_4)), item(exception(portability, art12_5_manifestly_unfounded_or_excessive), unmet(art12_5_manifestly_unfounded_or_excessive), cite(eu_reg_2016_679_art_12_5)), item(exception(portability, art12_2_unable_to_identify), unmet(art12_2_unable_to_identify), cite(eu_reg_2016_679_art_12_2)), item(exception(portability, art23_legislative_restriction), unmet(art23_legislative_restriction), cite(eu_reg_2016_679_art_23_1))]].
test(the_checklist_of_a_malformed_profile_is_empty) :-
    subject_profile(duplicate_and_unknown_keys, Profile),
    request_exception_checklist(Profile, []).

cp_test_names([route_v_must_comply_once, route_ii_not_engaged_once, route_iii_public_task_once, route_iii_contract_carries_the_safeguards, route_iii_manifestly_excessive_carries_the_fee, route_iii_authorising_law_once, route_iii_legislative_restriction_once, route_iii_a_suspension_once, route_iv_missing_keys_listed_all_once, route_iv_safeguards_key_missing_once, route_iv_contract_unsure_refers_once, route_iv_identity_doubts_unsure_refers_once, route_iv_rights_of_others_unsure_refers_once, route_i_types_disagree_once, route_i_types_agree_once, route_i_grounds_disagree_once, route_0_input_problems_once, the_relief_verdict_carries_its_citation, the_no_exception_verdict_carries_no_citation, the_checklist_reads_out_every_limb_with_its_citation, the_checklist_of_a_malformed_profile_is_empty]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
