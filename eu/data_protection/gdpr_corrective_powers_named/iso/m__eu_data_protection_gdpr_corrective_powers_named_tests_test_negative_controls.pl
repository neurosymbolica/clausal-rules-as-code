% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_corrective_powers_named_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_corrective_powers_named_gdpr_corrective_powers_named, [corrective_power_named/4]).
:- use_module(m__eu_data_protection_gdpr_corrective_powers_named_fixtures, [gdpr_corrective_powers_named_profile_for/2, gdpr_corrective_powers_named_assess/2]).

test(a_past_infringement_names_the_reprimand) :-
    gdpr_corrective_powers_named_assess(past_infringement, gdpr_corrective_powers_named_verdict(powers_named(Powers, authority_discretion), _Citations)),
    member(power(reprimand, [controller, processor]), Powers).
test(no_infringement_names_no_power) :-
    gdpr_corrective_powers_named_assess(all_false, gdpr_corrective_powers_named_verdict(powers_named([], authority_discretion), _Citations)).
test(non_compliance_names_the_limitation) :-
    gdpr_corrective_powers_named_assess(non_compliance_only, gdpr_corrective_powers_named_verdict(powers_named(Powers, authority_discretion), _Citations)),
    member(power(limitation_or_ban_on_processing, []), Powers).
test(all_three_false_give_limitation_not_named) :-
    gdpr_corrective_powers_named_profile_for(all_false, Profile),
    corrective_power_named(Profile, limitation_or_ban_on_processing, not_named, _Citations).
test(a_failing_certification_names_its_withdrawal) :-
    gdpr_corrective_powers_named_profile_for(certification_failing, Profile),
    corrective_power_named(Profile, withdrawal_or_refusal_of_certification, named([certification_body], authority_discretion), _Citations).
test(no_certification_settles_before_the_unsure_requirements) :-
    gdpr_corrective_powers_named_profile_for(certification_not_held, Profile),
    corrective_power_named(Profile, withdrawal_or_refusal_of_certification, not_named, _Citations).
test(a_breach_order_goes_to_the_controller) :-
    gdpr_corrective_powers_named_profile_for(breach_stated_plainly, Profile),
    corrective_power_named(Profile, order_to_communicate_personal_data_breach, named([controller], authority_discretion), _Citations).
test(missing_flows_name_the_flows_key) :-
    gdpr_corrective_powers_named_assess(missing_flows, gdpr_corrective_powers_named_verdict(indeterminate([data_flows_to_third_country_or_international_organisation]), [])).
test(stated_flows_name_the_suspension) :-
    gdpr_corrective_powers_named_assess(third_country_flows, gdpr_corrective_powers_named_verdict(powers_named([power(suspension_of_data_flows, [])], authority_discretion), _Citations)).
test(the_absent_certification_key_is_named_first) :-
    gdpr_corrective_powers_named_assess(missing_certification_key, gdpr_corrective_powers_named_verdict(indeterminate([certification_issued_or_applied_for]), [])).
test(an_unsure_infringement_refers_on_point_b) :-
    gdpr_corrective_powers_named_assess(unsure_infringement, gdpr_corrective_powers_named_verdict(needs_legal_review(open_textured(processing_has_infringed, cite(eu_reg_2016_679_art_58_2_b)), [inputs_relied_on(_Pairs)]), [])).
test(unsure_requirements_refer_on_point_h) :-
    gdpr_corrective_powers_named_assess(unsure_requirements, gdpr_corrective_powers_named_verdict(needs_legal_review(open_textured(certification_requirements_not_met, cite(eu_reg_2016_679_art_58_2_h)), [inputs_relied_on(_Pairs)]), [])).
test(an_attested_value_is_an_input_problem) :-
    gdpr_corrective_powers_named_assess(attested_value, gdpr_corrective_powers_named_verdict(input_problems([wrong_type(personal_data_breach_occurred)]), [])).
test(a_duplicate_and_an_unknown_key_are_named) :-
    gdpr_corrective_powers_named_assess(duplicate_and_unknown, gdpr_corrective_powers_named_verdict(input_problems([duplicate_key(processing_has_infringed), unknown_key(fine_amount)]), [])).
test(an_unknown_measure_is_an_input_problem) :-
    gdpr_corrective_powers_named_profile_for(all_false, Profile),
    corrective_power_named(Profile, caution, input_problems([wrong_type(measure)]), []).

test(no_infringement_names_no_reprimand, fail) :-
    gdpr_corrective_powers_named_assess(all_false, gdpr_corrective_powers_named_verdict(powers_named(Powers, _Discretion), _Citations)),
    member(power(reprimand, _Addressees), Powers).
test(all_three_false_do_not_name_the_limitation, fail) :-
    gdpr_corrective_powers_named_profile_for(all_false, Profile),
    corrective_power_named(Profile, limitation_or_ban_on_processing, named(_Addressees, _Discretion), _Citations).
test(met_requirements_do_not_name_the_withdrawal, fail) :-
    gdpr_corrective_powers_named_profile_for(certification_requirements_met, Profile),
    corrective_power_named(Profile, withdrawal_or_refusal_of_certification, named(_Addressees, _Discretion), _Citations).
test(no_certification_is_never_referred, fail) :-
    gdpr_corrective_powers_named_profile_for(certification_not_held, Profile),
    corrective_power_named(Profile, withdrawal_or_refusal_of_certification, needs_legal_review(_Reason, _Context), _Citations).
test(a_breach_order_does_not_go_to_the_processor, fail) :-
    gdpr_corrective_powers_named_profile_for(breach_stated_plainly, Profile),
    corrective_power_named(Profile, order_to_communicate_personal_data_breach, named([controller, processor], _Discretion), _Citations).
test(stated_flows_are_not_indeterminate, fail) :-
    gdpr_corrective_powers_named_assess(third_country_flows, gdpr_corrective_powers_named_verdict(indeterminate(_MissingKeys), _Citations)).
test(the_waiting_requirements_are_not_referred, fail) :-
    gdpr_corrective_powers_named_assess(missing_certification_key, gdpr_corrective_powers_named_verdict(needs_legal_review(_Reason, _Context), _Citations)).
test(a_stated_infringement_is_not_referred, fail) :-
    gdpr_corrective_powers_named_assess(past_infringement, gdpr_corrective_powers_named_verdict(needs_legal_review(_Reason, _Context), _Citations)).
test(stated_requirements_are_not_referred, fail) :-
    gdpr_corrective_powers_named_assess(certification_failing, gdpr_corrective_powers_named_verdict(needs_legal_review(_Reason, _Context), _Citations)).
test(a_plain_value_is_no_input_problem, fail) :-
    gdpr_corrective_powers_named_assess(breach_stated_plainly, gdpr_corrective_powers_named_verdict(input_problems(_Problems), _Citations)).
test(a_well_formed_profile_has_no_input_problem, fail) :-
    gdpr_corrective_powers_named_assess(everything_true, gdpr_corrective_powers_named_verdict(input_problems(_Problems), _Citations)).
test(a_known_measure_is_no_input_problem, fail) :-
    gdpr_corrective_powers_named_profile_for(all_false, Profile),
    corrective_power_named(Profile, warning, input_problems(_Problems), _Citations).

cp_test_names([a_past_infringement_names_the_reprimand, no_infringement_names_no_power, non_compliance_names_the_limitation, all_three_false_give_limitation_not_named, a_failing_certification_names_its_withdrawal, no_certification_settles_before_the_unsure_requirements, a_breach_order_goes_to_the_controller, missing_flows_name_the_flows_key, stated_flows_name_the_suspension, the_absent_certification_key_is_named_first, an_unsure_infringement_refers_on_point_b, unsure_requirements_refer_on_point_h, an_attested_value_is_an_input_problem, a_duplicate_and_an_unknown_key_are_named, an_unknown_measure_is_an_input_problem]).
cp_test_fail_names([no_infringement_names_no_reprimand, all_three_false_do_not_name_the_limitation, met_requirements_do_not_name_the_withdrawal, no_certification_is_never_referred, a_breach_order_does_not_go_to_the_processor, stated_flows_are_not_indeterminate, the_waiting_requirements_are_not_referred, a_stated_infringement_is_not_referred, stated_requirements_are_not_referred, a_plain_value_is_no_input_problem, a_well_formed_profile_has_no_input_problem, a_known_measure_is_no_input_problem]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
