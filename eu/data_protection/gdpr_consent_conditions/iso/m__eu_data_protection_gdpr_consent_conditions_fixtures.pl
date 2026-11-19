% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_consent_conditions_fixtures, [gdpr_consent_conditions_subject/1, gdpr_consent_conditions_profile_for/2, gdpr_consent_conditions_assess/2, gdpr_consent_conditions_expected/3]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_consent_conditions_gdpr_consent_conditions, [decide_gdpr_consent_conditions/2]).

gdpr_consent_conditions_subject(consent_all_conditions_met).
gdpr_consent_conditions_subject(consent_demonstration_not_shown).
gdpr_consent_conditions_subject(consent_declaration_request_clear).
gdpr_consent_conditions_subject(consent_declaration_request_unclear).
gdpr_consent_conditions_subject(consent_withdrawal_not_informed).
gdpr_consent_conditions_subject(consent_withdrawal_harder_than_giving).
gdpr_consent_conditions_subject(consent_not_freely_given).
gdpr_consent_conditions_subject(processing_not_based_on_consent).
gdpr_consent_conditions_subject(consent_scope_absent).
gdpr_consent_conditions_subject(consent_crisp_keys_absent).
gdpr_consent_conditions_subject(consent_demonstration_statement_absent).
gdpr_consent_conditions_subject(consent_unknown_key_profile).
gdpr_consent_conditions_subject(declaration_part_infringing).
gdpr_consent_conditions_subject(declaration_no_part_infringing).
gdpr_consent_conditions_subject(declaration_without_other_matters).
gdpr_consent_conditions_subject(contract_conditional_on_unneeded_consent_factor).
gdpr_consent_conditions_subject(contract_not_conditional_on_unneeded_consent).
gdpr_consent_conditions_subject(identification_not_required).
gdpr_consent_conditions_subject(identification_required).
gdpr_consent_conditions_subject(informing_data_subject_is_possible).
gdpr_consent_conditions_subject(informing_data_subject_is_impossible).
gdpr_consent_conditions_subject(inability_to_identify_not_demonstrated).
gdpr_consent_conditions_subject(identifying_information_provided).
gdpr_consent_conditions_subject(identifying_information_not_provided).
gdpr_consent_conditions_subject(rights_engagement_open_information_key_absent).

yes_statement(attested(true, attestation(by, at, reason, none))).

no_statement(attested(false, attestation(by, at, reason, none))).

gdpr_consent_conditions_profile_for(consent_all_conditions_met, Profile) :-
    yes_statement(Yes),
    Profile = [attribute(processing_based_on_consent, true), attribute(consent_demonstrable, Yes), attribute(consent_in_declaration_with_other_matters, false), attribute(informed_of_withdrawal_right_before_consent, true), attribute(withdrawal_as_easy_as_giving_consent, Yes), attribute(consent_freely_given, Yes)].
gdpr_consent_conditions_profile_for(consent_demonstration_not_shown, Profile) :-
    yes_statement(Yes),
    no_statement(No),
    Profile = [attribute(processing_based_on_consent, true), attribute(consent_demonstrable, No), attribute(consent_in_declaration_with_other_matters, false), attribute(informed_of_withdrawal_right_before_consent, true), attribute(withdrawal_as_easy_as_giving_consent, Yes), attribute(consent_freely_given, Yes)].
gdpr_consent_conditions_profile_for(consent_declaration_request_clear, Profile) :-
    yes_statement(Yes),
    Profile = [attribute(processing_based_on_consent, true), attribute(consent_demonstrable, Yes), attribute(consent_in_declaration_with_other_matters, true), attribute(request_clearly_distinguishable_and_intelligible, Yes), attribute(informed_of_withdrawal_right_before_consent, true), attribute(withdrawal_as_easy_as_giving_consent, Yes), attribute(consent_freely_given, Yes)].
gdpr_consent_conditions_profile_for(consent_declaration_request_unclear, Profile) :-
    yes_statement(Yes),
    no_statement(No),
    Profile = [attribute(processing_based_on_consent, true), attribute(consent_demonstrable, Yes), attribute(consent_in_declaration_with_other_matters, true), attribute(request_clearly_distinguishable_and_intelligible, No), attribute(informed_of_withdrawal_right_before_consent, true), attribute(withdrawal_as_easy_as_giving_consent, Yes), attribute(consent_freely_given, Yes)].
gdpr_consent_conditions_profile_for(consent_withdrawal_not_informed, Profile) :-
    yes_statement(Yes),
    Profile = [attribute(processing_based_on_consent, true), attribute(consent_demonstrable, Yes), attribute(consent_in_declaration_with_other_matters, false), attribute(informed_of_withdrawal_right_before_consent, false), attribute(withdrawal_as_easy_as_giving_consent, Yes), attribute(consent_freely_given, Yes)].
gdpr_consent_conditions_profile_for(consent_withdrawal_harder_than_giving, Profile) :-
    yes_statement(Yes),
    no_statement(No),
    Profile = [attribute(processing_based_on_consent, true), attribute(consent_demonstrable, Yes), attribute(consent_in_declaration_with_other_matters, false), attribute(informed_of_withdrawal_right_before_consent, true), attribute(withdrawal_as_easy_as_giving_consent, No), attribute(consent_freely_given, Yes)].
gdpr_consent_conditions_profile_for(consent_not_freely_given, Profile) :-
    yes_statement(Yes),
    no_statement(No),
    Profile = [attribute(processing_based_on_consent, true), attribute(consent_demonstrable, Yes), attribute(consent_in_declaration_with_other_matters, false), attribute(informed_of_withdrawal_right_before_consent, true), attribute(withdrawal_as_easy_as_giving_consent, Yes), attribute(consent_freely_given, No)].
gdpr_consent_conditions_profile_for(processing_not_based_on_consent, Profile) :-
    yes_statement(Yes),
    Profile = [attribute(processing_based_on_consent, false), attribute(consent_demonstrable, Yes), attribute(consent_in_declaration_with_other_matters, false), attribute(informed_of_withdrawal_right_before_consent, true), attribute(withdrawal_as_easy_as_giving_consent, Yes), attribute(consent_freely_given, Yes)].
gdpr_consent_conditions_profile_for(consent_scope_absent, Profile) :-
    yes_statement(Yes),
    Profile = [attribute(consent_demonstrable, Yes), attribute(consent_in_declaration_with_other_matters, false), attribute(informed_of_withdrawal_right_before_consent, true), attribute(withdrawal_as_easy_as_giving_consent, Yes), attribute(consent_freely_given, Yes)].
gdpr_consent_conditions_profile_for(consent_crisp_keys_absent, Profile) :-
    yes_statement(Yes),
    Profile = [attribute(processing_based_on_consent, true), attribute(consent_demonstrable, Yes), attribute(withdrawal_as_easy_as_giving_consent, Yes), attribute(consent_freely_given, Yes)].
gdpr_consent_conditions_profile_for(consent_demonstration_statement_absent, Profile) :-
    yes_statement(Yes),
    Profile = [attribute(processing_based_on_consent, true), attribute(consent_in_declaration_with_other_matters, false), attribute(informed_of_withdrawal_right_before_consent, true), attribute(withdrawal_as_easy_as_giving_consent, Yes), attribute(consent_freely_given, Yes)].
gdpr_consent_conditions_profile_for(consent_unknown_key_profile, Profile) :-
    Profile = [attribute(processing_based_on_consent, true), attribute(colour, red)].
gdpr_consent_conditions_profile_for(declaration_part_infringing, Profile) :-
    Profile = [attribute(consent_in_declaration_with_other_matters, true), attribute(declaration_part_infringes_regulation, true)].
gdpr_consent_conditions_profile_for(declaration_no_part_infringing, Profile) :-
    Profile = [attribute(consent_in_declaration_with_other_matters, true), attribute(declaration_part_infringes_regulation, false)].
gdpr_consent_conditions_profile_for(declaration_without_other_matters, Profile) :-
    Profile = [attribute(consent_in_declaration_with_other_matters, false), attribute(declaration_part_infringes_regulation, true)].
gdpr_consent_conditions_profile_for(contract_conditional_on_unneeded_consent_factor, Profile) :-
    Profile = [attribute(contract_conditional_on_unneeded_consent, true)].
gdpr_consent_conditions_profile_for(contract_not_conditional_on_unneeded_consent, Profile) :-
    Profile = [attribute(contract_conditional_on_unneeded_consent, false)].
gdpr_consent_conditions_profile_for(identification_not_required, Profile) :-
    yes_statement(Yes),
    Profile = [attribute(purposes_do_not_require_identification, Yes)].
gdpr_consent_conditions_profile_for(identification_required, Profile) :-
    no_statement(No),
    Profile = [attribute(purposes_do_not_require_identification, No)].
gdpr_consent_conditions_profile_for(informing_data_subject_is_possible, Profile) :-
    yes_statement(Yes),
    Profile = [attribute(purposes_do_not_require_identification, Yes), attribute(able_to_demonstrate_not_in_position_to_identify, Yes), attribute(informing_data_subject_possible, Yes)].
gdpr_consent_conditions_profile_for(informing_data_subject_is_impossible, Profile) :-
    yes_statement(Yes),
    no_statement(No),
    Profile = [attribute(purposes_do_not_require_identification, Yes), attribute(able_to_demonstrate_not_in_position_to_identify, Yes), attribute(informing_data_subject_possible, No)].
gdpr_consent_conditions_profile_for(inability_to_identify_not_demonstrated, Profile) :-
    yes_statement(Yes),
    no_statement(No),
    Profile = [attribute(purposes_do_not_require_identification, Yes), attribute(able_to_demonstrate_not_in_position_to_identify, No), attribute(informing_data_subject_possible, Yes)].
gdpr_consent_conditions_profile_for(identifying_information_provided, Profile) :-
    yes_statement(Yes),
    Profile = [attribute(purposes_do_not_require_identification, Yes), attribute(able_to_demonstrate_not_in_position_to_identify, Yes), attribute(additional_identifying_information_provided, true)].
gdpr_consent_conditions_profile_for(identifying_information_not_provided, Profile) :-
    yes_statement(Yes),
    Profile = [attribute(purposes_do_not_require_identification, Yes), attribute(able_to_demonstrate_not_in_position_to_identify, Yes), attribute(additional_identifying_information_provided, false)].
gdpr_consent_conditions_profile_for(rights_engagement_open_information_key_absent, Profile) :-
    yes_statement(Yes),
    Profile = [attribute(able_to_demonstrate_not_in_position_to_identify, Yes)].

gdpr_consent_conditions_expected(consent_all_conditions_met, consent_conditions_status, conditions_met).
gdpr_consent_conditions_expected(consent_demonstration_not_shown, consent_conditions_status, conditions_not_met).
gdpr_consent_conditions_expected(consent_declaration_request_clear, consent_conditions_status, conditions_met).
gdpr_consent_conditions_expected(consent_declaration_request_unclear, consent_conditions_status, conditions_not_met).
gdpr_consent_conditions_expected(consent_withdrawal_not_informed, consent_conditions_status, conditions_not_met).
gdpr_consent_conditions_expected(consent_withdrawal_harder_than_giving, consent_conditions_status, conditions_not_met).
gdpr_consent_conditions_expected(consent_not_freely_given, consent_conditions_status, conditions_not_met).
gdpr_consent_conditions_expected(processing_not_based_on_consent, consent_conditions_status, not_applicable).
gdpr_consent_conditions_expected(consent_scope_absent, consent_conditions_status, indeterminate([processing_based_on_consent])).
gdpr_consent_conditions_expected(consent_crisp_keys_absent, consent_conditions_status, indeterminate([consent_in_declaration_with_other_matters, informed_of_withdrawal_right_before_consent])).
gdpr_consent_conditions_expected(consent_demonstration_statement_absent, consent_conditions_status, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_7_1), cite(consent_demonstration_statement)), [resolution(cite(consent_demonstration_statement), not_attempted), inputs_relied_on([consent_demonstrable - absent])])).
gdpr_consent_conditions_expected(consent_unknown_key_profile, consent_conditions_status, input_problems([unknown_key(colour)])).
gdpr_consent_conditions_expected(declaration_part_infringing, consent_declaration_effect, part_not_binding).
gdpr_consent_conditions_expected(declaration_no_part_infringing, consent_declaration_effect, no_part_infringing).
gdpr_consent_conditions_expected(declaration_without_other_matters, consent_declaration_effect, not_applicable).
gdpr_consent_conditions_expected(contract_conditional_on_unneeded_consent_factor, consent_assessment_factors, [factor(contract_conditional_on_unneeded_consent, cite(eu_reg_2016_679_art_7_4))]).
gdpr_consent_conditions_expected(contract_not_conditional_on_unneeded_consent, consent_assessment_factors, []).
gdpr_consent_conditions_expected(identification_not_required, identification_obligation, not_obliged_to_acquire_identifying_information).
gdpr_consent_conditions_expected(identification_required, identification_obligation, art11_1_not_engaged).
gdpr_consent_conditions_expected(informing_data_subject_is_possible, identification_information_duty, must_inform_data_subject).
gdpr_consent_conditions_expected(informing_data_subject_is_impossible, identification_information_duty, need_not_inform_data_subject).
gdpr_consent_conditions_expected(inability_to_identify_not_demonstrated, identification_information_duty, art11_2_not_engaged).
gdpr_consent_conditions_expected(identifying_information_provided, identification_rights_effect, articles_15_to_20_apply).
gdpr_consent_conditions_expected(identifying_information_not_provided, identification_rights_effect, articles_15_to_20_do_not_apply).
gdpr_consent_conditions_expected(rights_engagement_open_information_key_absent, identification_rights_effect, indeterminate([additional_identifying_information_provided])).

gdpr_consent_conditions_assess(Subject, Result) :-
    gdpr_consent_conditions_profile_for(Subject, Profile),
    decide_gdpr_consent_conditions(Profile, Result).
