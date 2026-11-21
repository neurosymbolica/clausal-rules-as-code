% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_chapter_v_extras_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_chapter_v_extras_gdpr_chapter_v_extras, [second_subparagraph_duty/5, foreign_judgment_or_decision_recognition/4, onward_transfer_condition/4, gdpr_chapter_v_extras_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_chapter_v_extras_fixtures, [gdpr_chapter_v_extras_profile_for/2]).

query_answer(Profile, duty(AskedDuty), Result) :-
    second_subparagraph_duty(Profile, AskedDuty, Result, _Basis, _Citations).
query_answer(Profile, article_48, Result) :-
    foreign_judgment_or_decision_recognition(Profile, Result, _Basis, _Citations).
query_answer(Profile, onward_transfer, Result) :-
    onward_transfer_condition(Profile, Result, _Basis, _Citations).

answer_of(Subject, Query, Result) :-
    gdpr_chapter_v_extras_profile_for(Subject, Profile),
    query_answer(Profile, Query, Result).

referral_on(OutsideKey, needs_legal_review(cross_reference_unresolved(_, _), [resolution(_, not_attempted), inputs_relied_on([OutsideKey - absent])])).

test(every_final_atom_is_in_the_status_table) :-
    gdpr_chapter_v_extras_status_values(StatusValues),
    maplist(table_member(StatusValues), [no_second_subparagraph_transfer, not_a_processor_duty, duty_met, duty_not_met, article_48_not_engaged, not_barred_by_article_48, not_recognisable_or_enforceable, not_an_onward_transfer, onward_transfer_may_take_place, onward_transfer_may_not_take_place]).
test(processor_route_positive) :-
    answer_of(processor_asks_about_informing, duty(inform_supervisory_authority), not_a_processor_duty).
test(processor_route_near_miss_controller_answer) :-
    answer_of(supervisory_authority_informed, duty(inform_supervisory_authority), duty_met).
test(transfer_referral_positive) :-
    answer_of(controller_asks_with_transfer_fact_absent, duty(inform_supervisory_authority), Result),
    referral_on(transfer_relies_on_article_49_1_second_subparagraph, Result).
test(transfer_referral_near_miss_processor_answer) :-
    answer_of(processor_asks_with_transfer_fact_absent, duty(inform_supervisory_authority), not_a_processor_duty).
test(party_role_route_positive) :-
    answer_of(party_role_unstated, duty(inform_supervisory_authority), indeterminate([party_role])).
test(no_second_subparagraph_route_positive) :-
    answer_of(transfer_not_under_second_subparagraph, duty(inform_supervisory_authority), no_second_subparagraph_transfer).
test(no_second_subparagraph_route_near_miss_answer) :-
    answer_of(transfer_not_under_second_subparagraph_role_unstated, duty(inform_supervisory_authority), indeterminate([party_role])).
test(authority_not_informed_positive) :-
    answer_of(supervisory_authority_not_informed, duty(inform_supervisory_authority), duty_not_met).
test(authority_information_unstated_positive) :-
    answer_of(supervisory_authority_information_unstated, duty(inform_supervisory_authority), indeterminate([supervisory_authority_informed_of_transfer])).
test(data_subject_route_positive) :-
    answer_of(data_subject_fully_informed, duty(inform_data_subject), duty_met).
test(data_subject_route_near_miss_answer) :-
    answer_of(data_subject_not_told_of_interests, duty(inform_data_subject), duty_not_met).
test(false_key_before_absent_key_positive) :-
    answer_of(data_subject_interests_refused_transfer_unstated, duty(inform_data_subject), duty_not_met).
test(false_key_before_absent_key_near_miss_answer) :-
    answer_of(data_subject_transfer_information_unstated, duty(inform_data_subject), indeterminate([data_subject_informed_of_transfer])).
test(documentation_route_positive) :-
    answer_of(records_complete_for_processor, duty(document_assessment_and_safeguards), duty_met).
test(documentation_route_near_miss_answer) :-
    answer_of(records_lack_safeguards, duty(document_assessment_and_safeguards), duty_not_met).
test(documentation_unstated_positive) :-
    answer_of(records_safeguards_unstated, duty(document_assessment_and_safeguards), indeterminate([suitable_safeguards_documented_in_records])).
test(article_48_not_engaged_positive) :-
    answer_of(judgment_not_requiring_transfer, article_48, article_48_not_engaged).
test(article_48_not_barred_positive) :-
    answer_of(judgment_with_international_agreement, article_48, not_barred_by_article_48).
test(article_48_bar_near_miss_answer) :-
    answer_of(judgment_without_international_agreement, article_48, not_recognisable_or_enforceable).
test(article_48_agreement_referral_positive) :-
    answer_of(judgment_agreement_unstated, article_48, Result),
    referral_on(international_agreement_basis_for_judgment_or_decision, Result).
test(article_48_judgment_referral_positive) :-
    answer_of(judgment_unstated_agreement_stated, article_48, Result),
    referral_on(third_country_judgment_or_decision_requires_transfer, Result).
test(onward_may_take_place_positive) :-
    answer_of(onward_transfer_with_chapter_v_basis, onward_transfer, onward_transfer_may_take_place).
test(onward_near_miss_answer) :-
    answer_of(onward_transfer_without_chapter_v_basis, onward_transfer, onward_transfer_may_not_take_place).
test(not_onward_positive) :-
    answer_of(transfer_not_onward, onward_transfer, not_an_onward_transfer).
test(onward_basis_referral_positive) :-
    answer_of(onward_transfer_basis_unstated, onward_transfer, Result),
    referral_on(onward_transfer_has_chapter_v_basis, Result).
test(onward_status_referral_positive) :-
    answer_of(onward_status_unstated_basis_stated, onward_transfer, Result),
    referral_on(transfer_is_onward_transfer, Result).
test(input_problem_route_positive) :-
    answer_of(duplicated_party_role, duty(inform_supervisory_authority), input_problems([duplicate_key(party_role)])).

table_member(StatusValues, Status) :-
    memberchk(Status, StatusValues).

test(processor_route_near_miss_is_not_a_processor_duty, fail) :-
    answer_of(supervisory_authority_informed, duty(inform_supervisory_authority), not_a_processor_duty).
test(documentation_duty_is_never_not_a_processor_duty, fail) :-
    answer_of(records_complete_for_processor, duty(document_assessment_and_safeguards), not_a_processor_duty).
test(transfer_referral_near_miss_does_not_refer, fail) :-
    answer_of(processor_asks_with_transfer_fact_absent, duty(inform_supervisory_authority), Result),
    referral_on(transfer_relies_on_article_49_1_second_subparagraph, Result).
test(party_role_route_near_miss_is_not_indeterminate, fail) :-
    answer_of(supervisory_authority_informed, duty(inform_supervisory_authority), indeterminate([party_role])).
test(no_second_subparagraph_route_near_miss_is_not_the_positive, fail) :-
    answer_of(transfer_not_under_second_subparagraph_role_unstated, duty(inform_supervisory_authority), no_second_subparagraph_transfer).
test(authority_informed_is_not_duty_not_met, fail) :-
    answer_of(supervisory_authority_informed, duty(inform_supervisory_authority), duty_not_met).
test(authority_not_informed_is_not_duty_met, fail) :-
    answer_of(supervisory_authority_not_informed, duty(inform_supervisory_authority), duty_met).
test(authority_information_unstated_is_not_duty_met, fail) :-
    answer_of(supervisory_authority_information_unstated, duty(inform_supervisory_authority), duty_met).
test(data_subject_route_near_miss_is_not_met, fail) :-
    answer_of(data_subject_not_told_of_interests, duty(inform_data_subject), duty_met).
test(false_key_before_absent_key_near_miss_is_not_not_met, fail) :-
    answer_of(data_subject_transfer_information_unstated, duty(inform_data_subject), duty_not_met).
test(documentation_route_near_miss_is_not_met, fail) :-
    answer_of(records_lack_safeguards, duty(document_assessment_and_safeguards), duty_met).
test(documentation_assessment_false_is_not_indeterminate, fail) :-
    answer_of(records_lack_assessment_safeguards_unstated, duty(document_assessment_and_safeguards), indeterminate(_)).
test(article_48_engaged_is_not_not_engaged, fail) :-
    answer_of(judgment_with_international_agreement, article_48, article_48_not_engaged).
test(article_48_bar_near_miss_is_not_not_barred, fail) :-
    answer_of(judgment_without_international_agreement, article_48, not_barred_by_article_48).
test(article_48_agreement_stated_does_not_refer, fail) :-
    answer_of(judgment_without_international_agreement, article_48, Result),
    referral_on(international_agreement_basis_for_judgment_or_decision, Result).
test(article_48_judgment_stated_does_not_refer, fail) :-
    answer_of(judgment_with_international_agreement, article_48, Result),
    referral_on(third_country_judgment_or_decision_requires_transfer, Result).
test(onward_near_miss_may_not_take_place, fail) :-
    answer_of(onward_transfer_without_chapter_v_basis, onward_transfer, onward_transfer_may_take_place).
test(onward_is_not_not_onward, fail) :-
    answer_of(onward_transfer_with_chapter_v_basis, onward_transfer, not_an_onward_transfer).
test(onward_basis_stated_does_not_refer, fail) :-
    answer_of(onward_transfer_with_chapter_v_basis, onward_transfer, Result),
    referral_on(onward_transfer_has_chapter_v_basis, Result).
test(onward_status_stated_does_not_refer, fail) :-
    answer_of(transfer_not_onward, onward_transfer, Result),
    referral_on(transfer_is_onward_transfer, Result).
test(input_problem_route_near_miss_has_no_problem, fail) :-
    answer_of(supervisory_authority_informed, duty(inform_supervisory_authority), input_problems(_)).

cp_test_names([every_final_atom_is_in_the_status_table, processor_route_positive, processor_route_near_miss_controller_answer, transfer_referral_positive, transfer_referral_near_miss_processor_answer, party_role_route_positive, no_second_subparagraph_route_positive, no_second_subparagraph_route_near_miss_answer, authority_not_informed_positive, authority_information_unstated_positive, data_subject_route_positive, data_subject_route_near_miss_answer, false_key_before_absent_key_positive, false_key_before_absent_key_near_miss_answer, documentation_route_positive, documentation_route_near_miss_answer, documentation_unstated_positive, article_48_not_engaged_positive, article_48_not_barred_positive, article_48_bar_near_miss_answer, article_48_agreement_referral_positive, article_48_judgment_referral_positive, onward_may_take_place_positive, onward_near_miss_answer, not_onward_positive, onward_basis_referral_positive, onward_status_referral_positive, input_problem_route_positive]).
cp_test_fail_names([processor_route_near_miss_is_not_a_processor_duty, documentation_duty_is_never_not_a_processor_duty, transfer_referral_near_miss_does_not_refer, party_role_route_near_miss_is_not_indeterminate, no_second_subparagraph_route_near_miss_is_not_the_positive, authority_informed_is_not_duty_not_met, authority_not_informed_is_not_duty_met, authority_information_unstated_is_not_duty_met, data_subject_route_near_miss_is_not_met, false_key_before_absent_key_near_miss_is_not_not_met, documentation_route_near_miss_is_not_met, documentation_assessment_false_is_not_indeterminate, article_48_engaged_is_not_not_engaged, article_48_bar_near_miss_is_not_not_barred, article_48_agreement_stated_does_not_refer, article_48_judgment_stated_does_not_refer, onward_near_miss_may_not_take_place, onward_is_not_not_onward, onward_basis_stated_does_not_refer, onward_status_stated_does_not_refer, input_problem_route_near_miss_has_no_problem]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
