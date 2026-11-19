% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_consent_conditions_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_consent_conditions_queries, [gdpr_consent_conditions_profile_keys/1, gdpr_consent_conditions_what_if/4, gdpr_consent_conditions_eligibility/2, gdpr_consent_conditions_obligations/2, gdpr_consent_conditions_compliance/3, conditions_met/0, must_inform_data_subject/0]).
:- use_module(m__eu_data_protection_gdpr_consent_conditions_kernel, [gdpr_consent_conditions_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_consent_conditions_fixtures, [gdpr_consent_conditions_profile_for/2]).

affirmed_statement(attested(true, attestation(by, at, reason, none))).

denied_statement(attested(false, attestation(by, at, reason, none))).

test(profile_keys_are_the_contract_keys) :-
    gdpr_consent_conditions_profile_keys(ProfileKeys),
    ProfileKeys == [processing_based_on_consent, consent_demonstrable, consent_in_declaration_with_other_matters, request_clearly_distinguishable_and_intelligible, declaration_part_infringes_regulation, informed_of_withdrawal_right_before_consent, withdrawal_as_easy_as_giving_consent, contract_conditional_on_unneeded_consent, consent_freely_given, purposes_do_not_require_identification, able_to_demonstrate_not_in_position_to_identify, informing_data_subject_possible, additional_identifying_information_provided].
test(the_reexported_input_check_answers_once) :-
    findall(Problems, gdpr_consent_conditions_input_problems([attribute(colour, red)], Problems), Answers),
    Answers == [[unknown_key(colour)]].
test(the_status_atoms_are_defined) :-
    conditions_met,
    must_inform_data_subject.
test(eligibility_all_conditions_met_is_eligible_with_its_checklist) :-
    gdpr_consent_conditions_profile_for(consent_all_conditions_met, Profile),
    findall(Assessment, gdpr_consent_conditions_eligibility(Profile, Assessment), Answers),
    Answers == [assessment(consent, eligible, [item(scope, met, cite(eu_reg_2016_679_art_7_1)), item(demonstration, met, cite(eu_reg_2016_679_art_7_1)), item(request_presentation, inapplicable, cite(eu_reg_2016_679_art_7_2)), item(withdrawal, met, cite(eu_reg_2016_679_art_7_3)), item(freely_given, met, cite(eu_reg_2016_679_art_7_4))])].
test(eligibility_unmet_limb_is_ineligible) :-
    gdpr_consent_conditions_profile_for(consent_demonstration_not_shown, Profile),
    gdpr_consent_conditions_eligibility(Profile, assessment(consent, ineligible, _)).
test(eligibility_not_based_on_consent_is_ineligible) :-
    gdpr_consent_conditions_profile_for(processing_not_based_on_consent, Profile),
    gdpr_consent_conditions_eligibility(Profile, assessment(consent, ineligible, _)).
test(eligibility_missing_scope_is_undecided) :-
    gdpr_consent_conditions_profile_for(consent_scope_absent, Profile),
    gdpr_consent_conditions_eligibility(Profile, assessment(consent, undecided, _)).
test(eligibility_referral_is_undecided) :-
    gdpr_consent_conditions_profile_for(consent_demonstration_statement_absent, Profile),
    gdpr_consent_conditions_eligibility(Profile, assessment(consent, undecided, _)).
test(eligibility_input_problems_are_undecided_with_the_problem_row) :-
    gdpr_consent_conditions_eligibility([attribute(colour, red)], assessment(consent, undecided, [item(input_check, unmet(input_problems([unknown_key(colour)])), cite(eu_reg_2016_679_art_7_1))])).
test(obligations_for_consent_without_a_declaration) :-
    gdpr_consent_conditions_profile_for(consent_all_conditions_met, Profile),
    findall(Obligations, gdpr_consent_conditions_obligations(Profile, Obligations), Answers),
    Answers == [[obligation(demonstrate_consent, cite(eu_reg_2016_679_art_7_1)), obligation(inform_of_withdrawal_right_before_consent, cite(eu_reg_2016_679_art_7_3)), obligation(make_withdrawal_as_easy_as_giving_consent, cite(eu_reg_2016_679_art_7_3))]].
test(obligations_with_a_declaration_add_the_presentation_duty) :-
    gdpr_consent_conditions_profile_for(consent_declaration_request_clear, Profile),
    gdpr_consent_conditions_obligations(Profile, Obligations),
    Obligations == [obligation(demonstrate_consent, cite(eu_reg_2016_679_art_7_1)), obligation(present_consent_request_distinguishably, cite(eu_reg_2016_679_art_7_2)), obligation(inform_of_withdrawal_right_before_consent, cite(eu_reg_2016_679_art_7_3)), obligation(make_withdrawal_as_easy_as_giving_consent, cite(eu_reg_2016_679_art_7_3))].
test(obligations_when_processing_is_not_based_on_consent_are_none) :-
    gdpr_consent_conditions_profile_for(processing_not_based_on_consent, Profile),
    gdpr_consent_conditions_obligations(Profile, []).
test(obligations_surface_the_article_11_2_duty) :-
    gdpr_consent_conditions_profile_for(informing_data_subject_is_possible, Profile),
    gdpr_consent_conditions_obligations(Profile, [obligation(inform_data_subject_not_in_position_to_identify, cite(eu_reg_2016_679_art_11_2))]).
test(obligations_without_the_possibility_omit_the_duty) :-
    gdpr_consent_conditions_profile_for(informing_data_subject_is_impossible, Profile),
    gdpr_consent_conditions_obligations(Profile, []).
test(obligations_report_input_problems_alone) :-
    gdpr_consent_conditions_obligations([attribute(colour, red)], input_problems([unknown_key(colour)])).
test(relying_on_consent_with_the_conditions_met_is_compliant) :-
    gdpr_consent_conditions_profile_for(consent_all_conditions_met, Profile),
    findall(Verdict, gdpr_consent_conditions_compliance(Profile, rely_on_consent_for_processing, Verdict), Verdicts),
    Verdicts == [compliant].
test(relying_on_consent_with_an_unmet_limb_is_non_compliant) :-
    gdpr_consent_conditions_profile_for(consent_withdrawal_harder_than_giving, Profile),
    gdpr_consent_conditions_compliance(Profile, rely_on_consent_for_processing, non_compliant).
test(relying_on_consent_with_a_referral_is_undecided) :-
    gdpr_consent_conditions_profile_for(consent_demonstration_statement_absent, Profile),
    gdpr_consent_conditions_compliance(Profile, rely_on_consent_for_processing, undecided).
test(enforcing_an_infringing_part_is_non_compliant) :-
    gdpr_consent_conditions_profile_for(declaration_part_infringing, Profile),
    gdpr_consent_conditions_compliance(Profile, enforce_infringing_declaration_part, non_compliant).
test(enforcing_with_no_infringing_part_is_compliant) :-
    gdpr_consent_conditions_profile_for(declaration_no_part_infringing, Profile),
    gdpr_consent_conditions_compliance(Profile, enforce_infringing_declaration_part, compliant).
test(declining_a_request_without_identifying_information_is_compliant) :-
    gdpr_consent_conditions_profile_for(identifying_information_not_provided, Profile),
    gdpr_consent_conditions_compliance(Profile, decline_request_under_articles_15_to_20, compliant).
test(declining_a_request_with_identifying_information_is_non_compliant) :-
    gdpr_consent_conditions_profile_for(identifying_information_provided, Profile),
    gdpr_consent_conditions_compliance(Profile, decline_request_under_articles_15_to_20, non_compliant).
test(what_if_consent_is_attested_not_freely_given) :-
    gdpr_consent_conditions_profile_for(consent_all_conditions_met, Profile),
    denied_statement(Denied),
    findall(Status, gdpr_consent_conditions_what_if(Profile, consent_freely_given, Denied, Status), Statuses),
    Statuses == [conditions_not_met].
test(what_if_processing_is_not_based_on_consent) :-
    gdpr_consent_conditions_profile_for(consent_all_conditions_met, Profile),
    gdpr_consent_conditions_what_if(Profile, processing_based_on_consent, false, not_applicable).
test(what_if_the_demonstration_is_attested_true) :-
    gdpr_consent_conditions_profile_for(consent_demonstration_not_shown, Profile),
    affirmed_statement(Affirmed),
    gdpr_consent_conditions_what_if(Profile, consent_demonstrable, Affirmed, conditions_met).
test(what_if_adds_an_absent_key) :-
    gdpr_consent_conditions_profile_for(consent_crisp_keys_absent, Profile),
    gdpr_consent_conditions_what_if(Profile, informed_of_withdrawal_right_before_consent, true, indeterminate([consent_in_declaration_with_other_matters])).
test(what_if_with_a_wrong_value_reports_the_input_problem) :-
    gdpr_consent_conditions_profile_for(consent_all_conditions_met, Profile),
    gdpr_consent_conditions_what_if(Profile, consent_freely_given, true, input_problems([wrong_type(consent_freely_given)])).

test(eligibility_unmet_limb_is_not_eligible, fail) :-
    gdpr_consent_conditions_profile_for(consent_demonstration_not_shown, Profile),
    gdpr_consent_conditions_eligibility(Profile, assessment(consent, eligible, _)).
test(relying_on_consent_with_an_unmet_limb_is_not_compliant, fail) :-
    gdpr_consent_conditions_profile_for(consent_withdrawal_harder_than_giving, Profile),
    gdpr_consent_conditions_compliance(Profile, rely_on_consent_for_processing, compliant).
test(an_unknown_action_has_no_verdict, fail) :-
    gdpr_consent_conditions_profile_for(consent_all_conditions_met, Profile),
    gdpr_consent_conditions_compliance(Profile, sell_the_data, _).

cp_test_names([profile_keys_are_the_contract_keys, the_reexported_input_check_answers_once, the_status_atoms_are_defined, eligibility_all_conditions_met_is_eligible_with_its_checklist, eligibility_unmet_limb_is_ineligible, eligibility_not_based_on_consent_is_ineligible, eligibility_missing_scope_is_undecided, eligibility_referral_is_undecided, eligibility_input_problems_are_undecided_with_the_problem_row, obligations_for_consent_without_a_declaration, obligations_with_a_declaration_add_the_presentation_duty, obligations_when_processing_is_not_based_on_consent_are_none, obligations_surface_the_article_11_2_duty, obligations_without_the_possibility_omit_the_duty, obligations_report_input_problems_alone, relying_on_consent_with_the_conditions_met_is_compliant, relying_on_consent_with_an_unmet_limb_is_non_compliant, relying_on_consent_with_a_referral_is_undecided, enforcing_an_infringing_part_is_non_compliant, enforcing_with_no_infringing_part_is_compliant, declining_a_request_without_identifying_information_is_compliant, declining_a_request_with_identifying_information_is_non_compliant, what_if_consent_is_attested_not_freely_given, what_if_processing_is_not_based_on_consent, what_if_the_demonstration_is_attested_true, what_if_adds_an_absent_key, what_if_with_a_wrong_value_reports_the_input_problem]).
cp_test_fail_names([eligibility_unmet_limb_is_not_eligible, relying_on_consent_with_an_unmet_limb_is_not_compliant, an_unknown_action_has_no_verdict]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
