% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_request_exception, [request_decision/2, request_exception/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_request_exception, [request_exception_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_fixtures, [gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_profile_for/2]).

decision_of(Subject, Comply) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_profile_for(Subject, Profile),
    request_decision(Profile, Comply).

exception_of(Subject, Exception) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_profile_for(Subject, Profile),
    request_exception(Profile, Exception).

table_atom(StatusValues, Atom) :-
    member(Atom, StatusValues).

test(every_near_miss_exception_atom_is_a_table_atom) :-
    request_exception_status_values(StatusValues),
    maplist(table_atom(StatusValues), [art20_3_public_task, art20_4_rights_of_others, art21_1_compelling_legitimate_grounds, art21_1_legal_claims, art21_6_public_interest_task, art22_2_a, art22_2_b, art22_2_c, art12_5_manifestly_unfounded_or_excessive, art12_2_unable_to_identify, art23_legislative_restriction, none]).
test(engaged_portability_must_comply) :-
    decision_of(portability_engaged_must_comply, must_comply).
test(not_automated_need_not_comply) :-
    decision_of(portability_not_automated_not_engaged, need_not_comply).
test(engaged_automated_decision_must_comply) :-
    decision_of(automated_decision_engaged_must_comply, must_comply).
test(not_solely_automated_need_not_comply) :-
    decision_of(automated_decision_not_solely_automated, need_not_comply).
test(direct_marketing_must_comply) :-
    decision_of(objection_direct_marketing_absolute, must_comply).
test(direct_marketing_has_no_art21_exception) :-
    exception_of(objection_direct_marketing_absolute, none).
test(no_direct_marketing_need_not_comply) :-
    decision_of(objection_direct_marketing_not_engaged, need_not_comply).
test(public_task_relieves) :-
    exception_of(portability_public_task_relieves, art20_3_public_task).
test(public_task_false_must_comply) :-
    decision_of(portability_public_task_false_must_comply, must_comply).
test(rights_of_others_relieves) :-
    exception_of(portability_rights_of_others_relieves, art20_4_rights_of_others).
test(rights_of_others_unsure_exception_none) :-
    exception_of(portability_rights_of_others_unsure_refers, none).
test(compelling_grounds_relieve) :-
    exception_of(objection_article_21_1_compelling_grounds, art21_1_compelling_legitimate_grounds).
test(compelling_grounds_false_must_comply) :-
    decision_of(objection_article_21_1_compelling_grounds_false, must_comply).
test(legal_claims_relieve) :-
    exception_of(objection_article_21_1_legal_claims, art21_1_legal_claims).
test(legal_claims_false_must_comply) :-
    decision_of(objection_article_21_1_legal_claims_false, must_comply).
test(art21_6_public_interest_task_relieves) :-
    exception_of(objection_article_21_6_public_interest_task, art21_6_public_interest_task).
test(art21_6_public_interest_task_false_must_comply) :-
    decision_of(objection_article_21_6_public_interest_task_false, must_comply).
test(contract_necessity_relieves) :-
    exception_of(automated_decision_contract_with_safeguards, art22_2_a).
test(contract_necessity_unsure_exception_none) :-
    exception_of(automated_decision_contract_unsure_refers, none).
test(authorising_law_attested_true_relieves) :-
    exception_of(automated_decision_authorised_by_law_attested, art22_2_b).
test(authorising_law_attested_false_must_comply) :-
    decision_of(automated_decision_authorised_by_law_attested_false, must_comply).
test(explicit_consent_with_safeguards_relieves) :-
    exception_of(automated_decision_explicit_consent_safeguards_met, art22_2_c).
test(special_category_bar_must_comply) :-
    decision_of(automated_decision_explicit_consent_barred_special_categories, must_comply).
test(manifestly_excessive_relieves) :-
    exception_of(manifestly_excessive_fee_open, art12_5_manifestly_unfounded_or_excessive).
test(manifestly_excessive_unsure_exception_none) :-
    exception_of(manifestly_excessive_unsure_refers, none).
test(unable_to_identify_relieves) :-
    exception_of(unable_to_identify_relieves, art12_2_unable_to_identify).
test(unable_to_identify_false_must_comply) :-
    decision_of(unable_to_identify_false_must_comply, must_comply).
test(legislative_restriction_attested_true_relieves) :-
    exception_of(legislative_restriction_attested_true, art23_legislative_restriction).
test(legislative_restriction_attested_false_must_comply) :-
    decision_of(legislative_restriction_attested_false, must_comply).
test(identity_doubts_suspend) :-
    decision_of(identity_doubts_suspend, suspended(art12_6_identity_not_confirmed)).
test(identity_confirmed_must_comply) :-
    decision_of(identity_doubts_identity_confirmed, must_comply).
test(missing_engagement_keys_indeterminate) :-
    decision_of(portability_missing_keys, indeterminate(_)).
test(safeguards_key_missing_indeterminate) :-
    decision_of(automated_decision_special_category_safeguards_missing, indeterminate([special_category_condition_and_safeguards_met_for_decision])).
test(identity_doubts_unsure_refers) :-
    decision_of(identity_doubts_unsure_refers, needs_legal_review(open_textured(reasonable_doubts_about_identity, cite(eu_reg_2016_679_art_12_6)), _)).
test(types_disagree_name_request_type) :-
    decision_of(request_type_absent_types_disagree, indeterminate([request_type])).
test(types_agree_decide) :-
    decision_of(request_type_absent_all_types_not_engaged, need_not_comply).
test(grounds_disagree_name_the_ground) :-
    decision_of(objection_ground_absent_grounds_disagree, indeterminate([objection_ground_claimed])).
test(grounds_agree_decide) :-
    decision_of(objection_ground_absent_grounds_agree, need_not_comply).
test(wrong_type_is_an_input_problem) :-
    decision_of(crisp_flag_given_unsure_wrong_type, input_problems([wrong_type(processing_carried_out_by_automated_means)])).

test(not_automated_is_not_must_comply, fail) :-
    decision_of(portability_not_automated_not_engaged, must_comply).
test(not_solely_automated_is_not_must_comply, fail) :-
    decision_of(automated_decision_not_solely_automated, must_comply).
test(direct_marketing_compelling_grounds_do_not_relieve, fail) :-
    exception_of(objection_direct_marketing_absolute, art21_1_compelling_legitimate_grounds).
test(public_task_false_does_not_relieve, fail) :-
    exception_of(portability_public_task_false_must_comply, art20_3_public_task).
test(rights_of_others_unsure_does_not_relieve, fail) :-
    decision_of(portability_rights_of_others_unsure_refers, need_not_comply).
test(compelling_grounds_false_do_not_relieve, fail) :-
    exception_of(objection_article_21_1_compelling_grounds_false, art21_1_compelling_legitimate_grounds).
test(legal_claims_false_do_not_relieve, fail) :-
    exception_of(objection_article_21_1_legal_claims_false, art21_1_legal_claims).
test(art21_6_public_interest_task_false_does_not_relieve, fail) :-
    exception_of(objection_article_21_6_public_interest_task_false, art21_6_public_interest_task).
test(contract_necessity_unsure_does_not_relieve, fail) :-
    exception_of(automated_decision_contract_unsure_refers, art22_2_a).
test(authorising_law_attested_false_does_not_relieve, fail) :-
    exception_of(automated_decision_authorised_by_law_attested_false, art22_2_b).
test(special_category_bar_blocks_consent, fail) :-
    exception_of(automated_decision_explicit_consent_barred_special_categories, art22_2_c).
test(manifestly_excessive_unsure_does_not_relieve, fail) :-
    exception_of(manifestly_excessive_unsure_refers, art12_5_manifestly_unfounded_or_excessive).
test(unable_to_identify_false_does_not_relieve, fail) :-
    exception_of(unable_to_identify_false_must_comply, art12_2_unable_to_identify).
test(legislative_restriction_attested_false_does_not_relieve, fail) :-
    exception_of(legislative_restriction_attested_false, art23_legislative_restriction).
test(identity_confirmed_is_not_suspended, fail) :-
    decision_of(identity_doubts_identity_confirmed, suspended(_)).
test(missing_engagement_keys_not_need_not_comply, fail) :-
    decision_of(portability_missing_keys, need_not_comply).
test(safeguards_key_missing_does_not_relieve, fail) :-
    exception_of(automated_decision_special_category_safeguards_missing, art22_2_c).
test(identity_doubts_unsure_is_not_suspended, fail) :-
    decision_of(identity_doubts_unsure_refers, suspended(_)).
test(types_agree_do_not_name_request_type, fail) :-
    decision_of(request_type_absent_all_types_not_engaged, indeterminate(_)).
test(grounds_agree_do_not_name_the_ground, fail) :-
    decision_of(objection_ground_absent_grounds_agree, indeterminate(_)).
test(wrong_type_gets_no_decision, fail) :-
    decision_of(crisp_flag_given_unsure_wrong_type, must_comply).
test(well_formed_profile_has_no_input_problems, fail) :-
    decision_of(portability_engaged_must_comply, input_problems(_)).

cp_test_names([every_near_miss_exception_atom_is_a_table_atom, engaged_portability_must_comply, not_automated_need_not_comply, engaged_automated_decision_must_comply, not_solely_automated_need_not_comply, direct_marketing_must_comply, direct_marketing_has_no_art21_exception, no_direct_marketing_need_not_comply, public_task_relieves, public_task_false_must_comply, rights_of_others_relieves, rights_of_others_unsure_exception_none, compelling_grounds_relieve, compelling_grounds_false_must_comply, legal_claims_relieve, legal_claims_false_must_comply, art21_6_public_interest_task_relieves, art21_6_public_interest_task_false_must_comply, contract_necessity_relieves, contract_necessity_unsure_exception_none, authorising_law_attested_true_relieves, authorising_law_attested_false_must_comply, explicit_consent_with_safeguards_relieves, special_category_bar_must_comply, manifestly_excessive_relieves, manifestly_excessive_unsure_exception_none, unable_to_identify_relieves, unable_to_identify_false_must_comply, legislative_restriction_attested_true_relieves, legislative_restriction_attested_false_must_comply, identity_doubts_suspend, identity_confirmed_must_comply, missing_engagement_keys_indeterminate, safeguards_key_missing_indeterminate, identity_doubts_unsure_refers, types_disagree_name_request_type, types_agree_decide, grounds_disagree_name_the_ground, grounds_agree_decide, wrong_type_is_an_input_problem]).
cp_test_fail_names([not_automated_is_not_must_comply, not_solely_automated_is_not_must_comply, direct_marketing_compelling_grounds_do_not_relieve, public_task_false_does_not_relieve, rights_of_others_unsure_does_not_relieve, compelling_grounds_false_do_not_relieve, legal_claims_false_do_not_relieve, art21_6_public_interest_task_false_does_not_relieve, contract_necessity_unsure_does_not_relieve, authorising_law_attested_false_does_not_relieve, special_category_bar_blocks_consent, manifestly_excessive_unsure_does_not_relieve, unable_to_identify_false_does_not_relieve, legislative_restriction_attested_false_does_not_relieve, identity_confirmed_is_not_suspended, missing_engagement_keys_not_need_not_comply, safeguards_key_missing_does_not_relieve, identity_doubts_unsure_is_not_suspended, types_agree_do_not_name_request_type, grounds_agree_do_not_name_the_ground, wrong_type_gets_no_decision, well_formed_profile_has_no_input_problems]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
