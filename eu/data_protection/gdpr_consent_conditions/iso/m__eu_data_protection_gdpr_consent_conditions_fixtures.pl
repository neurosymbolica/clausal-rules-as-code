% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_consent_conditions_fixtures, [gdpr_consent_conditions_subject/1, gdpr_consent_conditions_profile_for/2, gdpr_consent_conditions_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_consent_conditions_gdpr_consent_conditions, [decide_gdpr_consent_conditions/2]).

gdpr_consent_conditions_subject(consent_met_plain).
gdpr_consent_conditions_subject(consent_met_with_declaration).
gdpr_consent_conditions_subject(consent_not_demonstrable).
gdpr_consent_conditions_subject(consent_request_unclear).
gdpr_consent_conditions_subject(consent_withdrawal_not_informed).
gdpr_consent_conditions_subject(consent_not_freely_given).
gdpr_consent_conditions_subject(consent_two_conditions_unmet).
gdpr_consent_conditions_subject(consent_freely_given_not_stated).
gdpr_consent_conditions_subject(processing_not_on_consent).
gdpr_consent_conditions_subject(consent_scope_not_stated).
gdpr_consent_conditions_subject(declaration_part_infringing).
gdpr_consent_conditions_subject(contract_conditional_consent).
gdpr_consent_conditions_subject(contract_unconditional_consent).
gdpr_consent_conditions_subject(identification_not_required).
gdpr_consent_conditions_subject(identification_information_provided).
gdpr_consent_conditions_subject(identification_purposes_require).
gdpr_consent_conditions_subject(identification_inability_denied).
gdpr_consent_conditions_subject(identification_statements_absent).
gdpr_consent_conditions_subject(identification_rights_not_stated).
gdpr_consent_conditions_subject(input_problem_profile).

attested_true(attested(true, attestation(host_system, recorded_2026_11_12, fixture_statement, none))).

attested_false(attested(false, attestation(host_system, recorded_2026_11_12, fixture_statement, none))).

gdpr_consent_conditions_profile_for(consent_met_plain, [attribute(processing_based_on_consent, true), attribute(consent_demonstrable, Demonstrable), attribute(consent_in_declaration_with_other_matters, false), attribute(informed_of_withdrawal_right_before_consent, true), attribute(withdrawal_as_easy_as_giving_consent, Easy), attribute(consent_freely_given, Freely)]) :-
    attested_true(Demonstrable),
    attested_true(Easy),
    attested_true(Freely).
gdpr_consent_conditions_profile_for(consent_met_with_declaration, [attribute(processing_based_on_consent, true), attribute(consent_demonstrable, Demonstrable), attribute(consent_in_declaration_with_other_matters, true), attribute(request_clearly_distinguishable_and_intelligible, Distinguishable), attribute(declaration_part_infringes_regulation, false), attribute(informed_of_withdrawal_right_before_consent, true), attribute(withdrawal_as_easy_as_giving_consent, Easy), attribute(consent_freely_given, Freely)]) :-
    attested_true(Demonstrable),
    attested_true(Distinguishable),
    attested_true(Easy),
    attested_true(Freely).
gdpr_consent_conditions_profile_for(consent_not_demonstrable, [attribute(processing_based_on_consent, true), attribute(consent_demonstrable, Demonstrable), attribute(consent_in_declaration_with_other_matters, false), attribute(informed_of_withdrawal_right_before_consent, true), attribute(withdrawal_as_easy_as_giving_consent, Easy), attribute(consent_freely_given, Freely)]) :-
    attested_false(Demonstrable),
    attested_true(Easy),
    attested_true(Freely).
gdpr_consent_conditions_profile_for(consent_request_unclear, [attribute(processing_based_on_consent, true), attribute(consent_demonstrable, Demonstrable), attribute(consent_in_declaration_with_other_matters, true), attribute(request_clearly_distinguishable_and_intelligible, Distinguishable), attribute(declaration_part_infringes_regulation, false), attribute(informed_of_withdrawal_right_before_consent, true), attribute(withdrawal_as_easy_as_giving_consent, Easy), attribute(consent_freely_given, Freely)]) :-
    attested_true(Demonstrable),
    attested_false(Distinguishable),
    attested_true(Easy),
    attested_true(Freely).
gdpr_consent_conditions_profile_for(consent_withdrawal_not_informed, [attribute(processing_based_on_consent, true), attribute(consent_demonstrable, Demonstrable), attribute(consent_in_declaration_with_other_matters, false), attribute(informed_of_withdrawal_right_before_consent, false), attribute(withdrawal_as_easy_as_giving_consent, Easy), attribute(consent_freely_given, Freely)]) :-
    attested_true(Demonstrable),
    attested_true(Easy),
    attested_true(Freely).
gdpr_consent_conditions_profile_for(consent_not_freely_given, [attribute(processing_based_on_consent, true), attribute(consent_demonstrable, Demonstrable), attribute(consent_in_declaration_with_other_matters, false), attribute(informed_of_withdrawal_right_before_consent, true), attribute(withdrawal_as_easy_as_giving_consent, Easy), attribute(consent_freely_given, Freely)]) :-
    attested_true(Demonstrable),
    attested_true(Easy),
    attested_false(Freely).
gdpr_consent_conditions_profile_for(consent_two_conditions_unmet, [attribute(processing_based_on_consent, true), attribute(consent_demonstrable, Demonstrable), attribute(consent_in_declaration_with_other_matters, false), attribute(informed_of_withdrawal_right_before_consent, true), attribute(withdrawal_as_easy_as_giving_consent, Easy), attribute(consent_freely_given, Freely)]) :-
    attested_false(Demonstrable),
    attested_true(Easy),
    attested_false(Freely).
gdpr_consent_conditions_profile_for(consent_freely_given_not_stated, [attribute(processing_based_on_consent, true), attribute(consent_demonstrable, Demonstrable), attribute(consent_in_declaration_with_other_matters, false), attribute(informed_of_withdrawal_right_before_consent, true), attribute(withdrawal_as_easy_as_giving_consent, Easy)]) :-
    attested_true(Demonstrable),
    attested_true(Easy).
gdpr_consent_conditions_profile_for(processing_not_on_consent, [attribute(processing_based_on_consent, false)]).
gdpr_consent_conditions_profile_for(consent_scope_not_stated, []).
gdpr_consent_conditions_profile_for(declaration_part_infringing, [attribute(processing_based_on_consent, true), attribute(consent_in_declaration_with_other_matters, true), attribute(declaration_part_infringes_regulation, true)]).
gdpr_consent_conditions_profile_for(contract_conditional_consent, [attribute(contract_conditional_on_unneeded_consent, true)]).
gdpr_consent_conditions_profile_for(contract_unconditional_consent, [attribute(contract_conditional_on_unneeded_consent, false)]).
gdpr_consent_conditions_profile_for(identification_not_required, [attribute(purposes_do_not_require_identification, Purposes), attribute(able_to_demonstrate_not_in_position_to_identify, Unable), attribute(informing_data_subject_possible, Possible), attribute(additional_identifying_information_provided, false)]) :-
    attested_true(Purposes),
    attested_true(Unable),
    attested_true(Possible).
gdpr_consent_conditions_profile_for(identification_information_provided, [attribute(purposes_do_not_require_identification, Purposes), attribute(able_to_demonstrate_not_in_position_to_identify, Unable), attribute(informing_data_subject_possible, Possible), attribute(additional_identifying_information_provided, true)]) :-
    attested_true(Purposes),
    attested_true(Unable),
    attested_false(Possible).
gdpr_consent_conditions_profile_for(identification_purposes_require, [attribute(purposes_do_not_require_identification, Purposes), attribute(able_to_demonstrate_not_in_position_to_identify, Unable), attribute(informing_data_subject_possible, Possible), attribute(additional_identifying_information_provided, false)]) :-
    attested_false(Purposes),
    attested_true(Unable),
    attested_true(Possible).
gdpr_consent_conditions_profile_for(identification_inability_denied, [attribute(able_to_demonstrate_not_in_position_to_identify, Unable)]) :-
    attested_false(Unable).
gdpr_consent_conditions_profile_for(identification_statements_absent, []).
gdpr_consent_conditions_profile_for(identification_rights_not_stated, [attribute(purposes_do_not_require_identification, Purposes), attribute(able_to_demonstrate_not_in_position_to_identify, Unable), attribute(informing_data_subject_possible, Possible)]) :-
    attested_true(Purposes),
    attested_true(Unable),
    attested_true(Possible).
gdpr_consent_conditions_profile_for(input_problem_profile, [attribute(processing_based_on_consent, true), attribute(processing_based_on_consent, false), attribute(unexpected_key, 1)]).

gdpr_consent_conditions_assess(Subject, Result) :-
    gdpr_consent_conditions_profile_for(Subject, Profile),
    decide_gdpr_consent_conditions(Profile, Result).
