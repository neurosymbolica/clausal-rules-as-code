% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_complaints_and_judicial_remedies_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_complaints_and_judicial_remedies_gdpr_complaints_and_judicial_remedies, [complaint_right/3, authority_decision_remedy_right/3, authority_inaction_remedy_right/4, controller_processor_remedy_right/3, controller_processor_forum/3, gdpr_complaints_and_judicial_remedies_status/2]).
:- use_module(m__eu_data_protection_gdpr_complaints_and_judicial_remedies_fixtures, [gdpr_complaints_and_judicial_remedies_profile_for/2]).
:- use_module(m__eu_data_protection_gdpr_complaints_and_judicial_remedies_kernel, [gdpr_complaints_and_judicial_remedies_input_problems/2]).

test(the_complaint_right_holds_with_the_result_bound) :-
    gdpr_complaints_and_judicial_remedies_profile_for(complaint_data_subject_who_considers, Profile),
    complaint_right(Profile, complaint_right_exists, [cite(eu_reg_2016_679_art_77_1)]).
test(the_facade_status_holds_with_the_verdict_bound) :-
    gdpr_complaints_and_judicial_remedies_profile_for(complaint_data_subject_who_considers, Profile),
    gdpr_complaints_and_judicial_remedies_status(Profile, remedy_available).
test(the_unsure_binding_referral_holds_bound) :-
    gdpr_complaints_and_judicial_remedies_profile_for(decision_binding_unsure, Profile),
    authority_decision_remedy_right(Profile, needs_legal_review(open_textured(decision_is_legally_binding, cite(eu_reg_2016_679_art_78_1)), [inputs_relied_on([decision_is_legally_binding - unsure, decision_concerns_the_caller - true])]), []).
test(the_attested_incompetence_holds_bound_with_its_basis) :-
    gdpr_complaints_and_judicial_remedies_profile_for(inaction_authority_not_competent, Profile),
    member(attribute(authority_competent_under_articles_55_and_56, Attested), Profile),
    authority_inaction_remedy_right(Profile, no_inaction_remedy_right, [outside_fact(authority_competent_under_articles_55_and_56, Attested)], [cite(eu_reg_2016_679_art_78_2)]).
test(the_judicial_remedy_holds_bound) :-
    gdpr_complaints_and_judicial_remedies_profile_for(judicial_data_subject_who_considers, Profile),
    controller_processor_remedy_right(Profile, judicial_remedy_right_exists, [cite(eu_reg_2016_679_art_79_1)]).
test(the_forum_holds_bound) :-
    gdpr_complaints_and_judicial_remedies_profile_for(forum_private_defendant, Profile),
    controller_processor_forum(Profile, forum_establishment_or_habitual_residence_state, [cite(eu_reg_2016_679_art_79_2)]).
test(the_order_of_the_attributes_does_not_matter) :-
    complaint_right([attribute(data_subject_considers_processing_infringes_regulation, true), attribute(is_data_subject, true)], complaint_right_exists, [cite(eu_reg_2016_679_art_77_1)]).
test(unknown_keys_are_named_once_in_order_of_first_occurrence) :-
    gdpr_complaints_and_judicial_remedies_input_problems([attribute(colour, blue), attribute(size, big), attribute(colour, red)], [unknown_key(colour), unknown_key(size)]).
test(wrong_types_follow_the_contract_order) :-
    gdpr_complaints_and_judicial_remedies_input_problems([attribute(decision_is_legally_binding, maybe), attribute(is_data_subject, unsure)], [wrong_type(is_data_subject), wrong_type(decision_is_legally_binding)]).
test(an_attestation_of_three_arguments_is_wrong_type) :-
    gdpr_complaints_and_judicial_remedies_input_problems([attribute(authority_competent_under_articles_55_and_56, attested(true, attestation(host, at, reason)))], [wrong_type(authority_competent_under_articles_55_and_56)]).
test(an_attested_unsure_is_wrong_type) :-
    gdpr_complaints_and_judicial_remedies_input_problems([attribute(authority_competent_under_articles_55_and_56, attested(unsure, attestation(host, at, reason, none)))], [wrong_type(authority_competent_under_articles_55_and_56)]).
test(the_attestation_arguments_are_not_inspected) :-
    gdpr_complaints_and_judicial_remedies_input_problems([attribute(authority_competent_under_articles_55_and_56, attested(true, attestation(anyone, anytime, any_reason, document(upload, digest))))], []).
test(a_stray_element_makes_the_profile_wrong_type_alone) :-
    gdpr_complaints_and_judicial_remedies_input_problems([attribute(is_data_subject, unsure), stray], [wrong_type(profile)]).
test(an_unbound_value_is_wrong_type) :-
    findall(Problems, gdpr_complaints_and_judicial_remedies_input_problems([attribute(is_data_subject, _)], Problems), Answers),
    Answers == [[wrong_type(is_data_subject)]].
test(a_number_key_is_an_unknown_key) :-
    gdpr_complaints_and_judicial_remedies_input_problems([attribute(1, true)], [unknown_key(1)]).
test(every_query_answers_the_input_problems_first) :-
    controller_processor_forum([attribute(colour, blue), attribute(defendant_is_member_state_public_authority_acting_in_public_powers, true)], input_problems([unknown_key(colour)]), []).

test(the_wrong_bound_complaint_result_is_rejected, fail) :-
    gdpr_complaints_and_judicial_remedies_profile_for(complaint_data_subject_who_considers, Profile),
    complaint_right(Profile, no_complaint_right, _).
test(the_wrong_bound_status_is_rejected, fail) :-
    gdpr_complaints_and_judicial_remedies_profile_for(complaint_data_subject_who_considers, Profile),
    gdpr_complaints_and_judicial_remedies_status(Profile, no_remedy_available).

cp_test_names([the_complaint_right_holds_with_the_result_bound, the_facade_status_holds_with_the_verdict_bound, the_unsure_binding_referral_holds_bound, the_attested_incompetence_holds_bound_with_its_basis, the_judicial_remedy_holds_bound, the_forum_holds_bound, the_order_of_the_attributes_does_not_matter, unknown_keys_are_named_once_in_order_of_first_occurrence, wrong_types_follow_the_contract_order, an_attestation_of_three_arguments_is_wrong_type, an_attested_unsure_is_wrong_type, the_attestation_arguments_are_not_inspected, a_stray_element_makes_the_profile_wrong_type_alone, an_unbound_value_is_wrong_type, a_number_key_is_an_unknown_key, every_query_answers_the_input_problems_first]).
cp_test_fail_names([the_wrong_bound_complaint_result_is_rejected, the_wrong_bound_status_is_rejected]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
