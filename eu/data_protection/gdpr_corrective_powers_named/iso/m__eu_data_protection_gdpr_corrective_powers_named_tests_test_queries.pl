% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_corrective_powers_named_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_corrective_powers_named_queries, [gdpr_corrective_powers_named_profile_keys/1, gdpr_corrective_powers_named_what_if/4, not_named/0, authority_discretion/0, controller/0, processor/0, certification_body/0, powers_named/2]).
:- use_module(m__eu_data_protection_gdpr_corrective_powers_named_kernel, [gdpr_corrective_powers_named_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_corrective_powers_named_fixtures, [gdpr_corrective_powers_named_profile_for/2]).

test(profile_keys_are_the_contract_keys) :-
    gdpr_corrective_powers_named_profile_keys(ProfileKeys),
    ProfileKeys == [intended_processing_likely_to_infringe, processing_has_infringed, data_subject_request_to_exercise_rights_made, processing_not_in_compliance, personal_data_breach_occurred, rectification_erasure_or_restriction_ground_met, certification_issued_or_applied_for, certification_requirements_not_met, data_flows_to_third_country_or_international_organisation].
test(what_if_the_infringement_is_withdrawn_names_nothing) :-
    gdpr_corrective_powers_named_profile_for(past_infringement, Profile),
    findall(Result, gdpr_corrective_powers_named_what_if(Profile, processing_has_infringed, false, Result), Results),
    Results == [powers_named([], authority_discretion)].
test(what_if_the_infringement_is_unsure_refers) :-
    gdpr_corrective_powers_named_profile_for(past_infringement, Profile),
    findall(Result, gdpr_corrective_powers_named_what_if(Profile, processing_has_infringed, unsure, Result), Results),
    Results == [needs_legal_review(open_textured(processing_has_infringed, cite(eu_reg_2016_679_art_58_2_b)), [inputs_relied_on([intended_processing_likely_to_infringe - false, processing_has_infringed - unsure, data_subject_request_to_exercise_rights_made - false, processing_not_in_compliance - false, personal_data_breach_occurred - false, rectification_erasure_or_restriction_ground_met - false, certification_issued_or_applied_for - false, certification_requirements_not_met - false, data_flows_to_third_country_or_international_organisation - false])])].
test(what_if_the_missing_flows_are_stated) :-
    gdpr_corrective_powers_named_profile_for(missing_flows, Profile),
    findall(Result, gdpr_corrective_powers_named_what_if(Profile, data_flows_to_third_country_or_international_organisation, true, Result), Results),
    Results == [powers_named([power(suspension_of_data_flows, [])], authority_discretion)].
test(what_if_the_certification_key_is_stated_refers_the_requirements) :-
    gdpr_corrective_powers_named_profile_for(missing_certification_key, Profile),
    findall(Result, gdpr_corrective_powers_named_what_if(Profile, certification_issued_or_applied_for, true, Result), Results),
    Results = [needs_legal_review(open_textured(certification_requirements_not_met, cite(eu_reg_2016_679_art_58_2_h)), [inputs_relied_on(_Pairs)])].
test(what_if_checks_the_original_profile_first) :-
    gdpr_corrective_powers_named_profile_for(attested_value, Profile),
    findall(Result, gdpr_corrective_powers_named_what_if(Profile, personal_data_breach_occurred, true, Result), Results),
    Results == [input_problems([wrong_type(personal_data_breach_occurred)])].
test(what_if_with_an_unknown_key_reports_it) :-
    gdpr_corrective_powers_named_profile_for(all_false, Profile),
    findall(Result, gdpr_corrective_powers_named_what_if(Profile, fine_amount, true, Result), Results),
    Results == [input_problems([unknown_key(fine_amount)])].
test(the_reexported_input_check_reports_problems) :-
    gdpr_corrective_powers_named_input_problems([attribute(colour, red)], Problems),
    Problems == [unknown_key(colour)].
test(the_exported_vocabulary_is_defined) :-
    not_named,
    authority_discretion,
    controller,
    processor,
    certification_body,
    powers_named([], authority_discretion).

test(what_if_does_not_name_the_original_answer, fail) :-
    gdpr_corrective_powers_named_profile_for(past_infringement, Profile),
    gdpr_corrective_powers_named_what_if(Profile, processing_has_infringed, false, powers_named([_Power|_Powers], _Discretion)).

cp_test_names([profile_keys_are_the_contract_keys, what_if_the_infringement_is_withdrawn_names_nothing, what_if_the_infringement_is_unsure_refers, what_if_the_missing_flows_are_stated, what_if_the_certification_key_is_stated_refers_the_requirements, what_if_checks_the_original_profile_first, what_if_with_an_unknown_key_reports_it, the_reexported_input_check_reports_problems, the_exported_vocabulary_is_defined]).
cp_test_fail_names([what_if_does_not_name_the_original_answer]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
