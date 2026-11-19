% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_consent_conditions_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_consent_conditions_gdpr_consent_conditions, [decide_gdpr_consent_conditions/2, gdpr_consent_conditions_checklist/2, consent_conditions_status/4, consent_declaration_effect/3, consent_assessment_factors/2, identification_obligation/4, identification_information_duty/4, identification_rights_effect/4]).
:- use_module(m__eu_data_protection_gdpr_consent_conditions_fixtures, [gdpr_consent_conditions_profile_for/2]).

affirmed_statement(attested(true, attestation(by, at, reason, none))).

denied_statement(attested(false, attestation(by, at, reason, none))).

consent_answers(Profile, Answers) :-
    findall(Status - Basis - Citations, consent_conditions_status(Profile, Status, Basis, Citations), Answers).

obligation_answers(Profile, Answers) :-
    findall(Status - Basis - Citations, identification_obligation(Profile, Status, Basis, Citations), Answers).

duty_answers(Profile, Answers) :-
    findall(Status - Basis - Citations, identification_information_duty(Profile, Status, Basis, Citations), Answers).

rights_answers(Profile, Answers) :-
    findall(Status - Basis - Citations, identification_rights_effect(Profile, Status, Basis, Citations), Answers).

test(conditions_met_with_a_declaration_reads_out_four_limbs) :-
    gdpr_consent_conditions_profile_for(consent_declaration_request_clear, Profile),
    affirmed_statement(Affirmed),
    consent_answers(Profile, Answers),
    Answers == [conditions_met - [outside_fact(consent_demonstrable, Affirmed), outside_fact(request_clearly_distinguishable_and_intelligible, Affirmed), outside_fact(withdrawal_as_easy_as_giving_consent, Affirmed), outside_fact(consent_freely_given, Affirmed)] - [cite(eu_reg_2016_679_art_7_1), cite(eu_reg_2016_679_art_7_2), cite(eu_reg_2016_679_art_7_3), cite(eu_reg_2016_679_art_7_4)]].
test(several_unmet_limbs_are_each_cited_once) :-
    affirmed_statement(Affirmed),
    denied_statement(Denied),
    Profile = [attribute(processing_based_on_consent, true), attribute(consent_demonstrable, Denied), attribute(consent_in_declaration_with_other_matters, false), attribute(informed_of_withdrawal_right_before_consent, false), attribute(withdrawal_as_easy_as_giving_consent, Affirmed), attribute(consent_freely_given, Denied)],
    consent_answers(Profile, Answers),
    Answers == [conditions_not_met - [outside_fact(consent_demonstrable, Denied), outside_fact(consent_freely_given, Denied)] - [cite(eu_reg_2016_679_art_7_1), cite(eu_reg_2016_679_art_7_3), cite(eu_reg_2016_679_art_7_4)]].
test(a_false_value_decides_before_absent_keys_are_read) :-
    denied_statement(Denied),
    consent_answers([attribute(processing_based_on_consent, true), attribute(consent_freely_given, Denied)], Answers),
    Answers == [conditions_not_met - [outside_fact(consent_freely_given, Denied)] - [cite(eu_reg_2016_679_art_7_4)]].
test(every_absent_needed_crisp_key_is_named_in_order) :-
    gdpr_consent_conditions_profile_for(consent_crisp_keys_absent, Profile),
    consent_answers(Profile, Answers),
    Answers == [indeterminate([consent_in_declaration_with_other_matters, informed_of_withdrawal_right_before_consent]) - [] - []].
test(an_absent_presentation_statement_refers_when_the_declaration_applies) :-
    affirmed_statement(Affirmed),
    Profile = [attribute(processing_based_on_consent, true), attribute(consent_demonstrable, Affirmed), attribute(consent_in_declaration_with_other_matters, true), attribute(informed_of_withdrawal_right_before_consent, true), attribute(withdrawal_as_easy_as_giving_consent, Affirmed), attribute(consent_freely_given, Affirmed)],
    consent_answers(Profile, Answers),
    Answers == [needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_7_2), cite(consent_request_presentation_statement)), [resolution(cite(consent_request_presentation_statement), not_attempted), inputs_relied_on([request_clearly_distinguishable_and_intelligible - absent])]) - [] - []].
test(an_absent_withdrawal_ease_statement_refers) :-
    affirmed_statement(Affirmed),
    Profile = [attribute(processing_based_on_consent, true), attribute(consent_demonstrable, Affirmed), attribute(consent_in_declaration_with_other_matters, false), attribute(informed_of_withdrawal_right_before_consent, true), attribute(consent_freely_given, Affirmed)],
    consent_answers(Profile, Answers),
    Answers == [needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_7_3), cite(withdrawal_ease_statement)), [resolution(cite(withdrawal_ease_statement), not_attempted), inputs_relied_on([withdrawal_as_easy_as_giving_consent - absent])]) - [] - []].
test(the_facade_verdict_carries_the_citations) :-
    gdpr_consent_conditions_profile_for(consent_all_conditions_met, Profile),
    findall(Verdict, decide_gdpr_consent_conditions(Profile, Verdict), Verdicts),
    Verdicts == [gdpr_consent_conditions_verdict(conditions_met, [cite(eu_reg_2016_679_art_7_1), cite(eu_reg_2016_679_art_7_3), cite(eu_reg_2016_679_art_7_4)])].
test(the_checklist_reads_out_the_unmet_limb) :-
    gdpr_consent_conditions_profile_for(consent_demonstration_not_shown, Profile),
    findall(Items, gdpr_consent_conditions_checklist(Profile, Items), Checklists),
    Checklists == [[item(scope, met, cite(eu_reg_2016_679_art_7_1)), item(demonstration, unmet(condition_not_met), cite(eu_reg_2016_679_art_7_1)), item(request_presentation, inapplicable, cite(eu_reg_2016_679_art_7_2)), item(withdrawal, met, cite(eu_reg_2016_679_art_7_3)), item(freely_given, met, cite(eu_reg_2016_679_art_7_4))]].
test(the_declaration_effect_reads_out_once) :-
    gdpr_consent_conditions_profile_for(declaration_part_infringing, Profile),
    findall(Status - Citations, consent_declaration_effect(Profile, Status, Citations), Answers),
    Answers == [part_not_binding - [cite(eu_reg_2016_679_art_7_2)]].
test(an_absent_infringement_key_is_indeterminate) :-
    findall(Status - Citations, consent_declaration_effect([attribute(consent_in_declaration_with_other_matters, true)], Status, Citations), Answers),
    Answers == [indeterminate([declaration_part_infringes_regulation]) - []].
test(the_factors_are_one_list_in_one_solution) :-
    gdpr_consent_conditions_profile_for(contract_not_conditional_on_unneeded_consent, Profile),
    findall(Factors, consent_assessment_factors(Profile, Factors), Answers),
    Answers == [[]].
test(article_11_1_not_engaged_reads_out_the_basis) :-
    gdpr_consent_conditions_profile_for(identification_required, Profile),
    denied_statement(Denied),
    obligation_answers(Profile, Answers),
    Answers == [art11_1_not_engaged - [outside_fact(purposes_do_not_require_identification, Denied)] - [cite(eu_reg_2016_679_art_11_1)]].
test(both_engagement_facts_false_are_both_in_the_basis) :-
    denied_statement(Denied),
    duty_answers([attribute(purposes_do_not_require_identification, Denied), attribute(able_to_demonstrate_not_in_position_to_identify, Denied)], Answers),
    Answers == [art11_2_not_engaged - [outside_fact(purposes_do_not_require_identification, Denied), outside_fact(able_to_demonstrate_not_in_position_to_identify, Denied)] - [cite(eu_reg_2016_679_art_11_2)]].
test(must_inform_reads_out_three_facts) :-
    gdpr_consent_conditions_profile_for(informing_data_subject_is_possible, Profile),
    affirmed_statement(Affirmed),
    duty_answers(Profile, Answers),
    Answers == [must_inform_data_subject - [outside_fact(purposes_do_not_require_identification, Affirmed), outside_fact(able_to_demonstrate_not_in_position_to_identify, Affirmed), outside_fact(informing_data_subject_possible, Affirmed)] - [cite(eu_reg_2016_679_art_11_2)]].
test(an_absent_informing_statement_refers_once_engaged) :-
    affirmed_statement(Affirmed),
    duty_answers([attribute(purposes_do_not_require_identification, Affirmed), attribute(able_to_demonstrate_not_in_position_to_identify, Affirmed)], Answers),
    Answers == [needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_11_2), cite(informing_possible_statement)), [resolution(cite(informing_possible_statement), not_attempted), inputs_relied_on([informing_data_subject_possible - absent])]) - [] - []].
test(an_absent_purposes_statement_refers_in_the_duty) :-
    affirmed_statement(Affirmed),
    duty_answers([attribute(able_to_demonstrate_not_in_position_to_identify, Affirmed)], Answers),
    Answers == [needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_11_1), cite(identification_not_required_statement)), [resolution(cite(identification_not_required_statement), not_attempted), inputs_relied_on([purposes_do_not_require_identification - absent])]) - [] - []].
test(an_absent_inability_statement_refers_with_the_crisp_key_present) :-
    affirmed_statement(Affirmed),
    rights_answers([attribute(purposes_do_not_require_identification, Affirmed), attribute(additional_identifying_information_provided, false)], Answers),
    Answers == [needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_11_2), cite(inability_to_identify_statement)), [resolution(cite(inability_to_identify_statement), not_attempted), inputs_relied_on([able_to_demonstrate_not_in_position_to_identify - absent])]) - [] - []].
test(articles_15_to_20_do_not_apply_reads_out_two_facts) :-
    gdpr_consent_conditions_profile_for(identifying_information_not_provided, Profile),
    affirmed_statement(Affirmed),
    rights_answers(Profile, Answers),
    Answers == [articles_15_to_20_do_not_apply - [outside_fact(purposes_do_not_require_identification, Affirmed), outside_fact(able_to_demonstrate_not_in_position_to_identify, Affirmed)] - [cite(eu_reg_2016_679_art_11_2)]].

cp_test_names([conditions_met_with_a_declaration_reads_out_four_limbs, several_unmet_limbs_are_each_cited_once, a_false_value_decides_before_absent_keys_are_read, every_absent_needed_crisp_key_is_named_in_order, an_absent_presentation_statement_refers_when_the_declaration_applies, an_absent_withdrawal_ease_statement_refers, the_facade_verdict_carries_the_citations, the_checklist_reads_out_the_unmet_limb, the_declaration_effect_reads_out_once, an_absent_infringement_key_is_indeterminate, the_factors_are_one_list_in_one_solution, article_11_1_not_engaged_reads_out_the_basis, both_engagement_facts_false_are_both_in_the_basis, must_inform_reads_out_three_facts, an_absent_informing_statement_refers_once_engaged, an_absent_purposes_statement_refers_in_the_duty, an_absent_inability_statement_refers_with_the_crisp_key_present, articles_15_to_20_do_not_apply_reads_out_two_facts]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
