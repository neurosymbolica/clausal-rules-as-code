% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_consent_conditions_queries, [gdpr_consent_conditions_profile_keys/1, gdpr_consent_conditions_what_if/4, gdpr_consent_conditions_eligibility/2, gdpr_consent_conditions_obligations/2, gdpr_consent_conditions_compliance/3, not_applicable/0, conditions_met/0, conditions_not_met/0, part_not_binding/0, no_part_infringing/0, not_obliged_to_acquire_identifying_information/0, art11_1_not_engaged/0, art11_2_not_engaged/0, must_inform_data_subject/0, need_not_inform_data_subject/0, articles_15_to_20_apply/0, articles_15_to_20_do_not_apply/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(formalize_lib, [profile_get/3]).
:- use_module(m__eu_data_protection_gdpr_consent_conditions_kernel, [gdpr_consent_conditions_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_consent_conditions_citations, [implements/1]).
:- use_module(m__eu_data_protection_gdpr_consent_conditions_gdpr_consent_conditions, [gdpr_consent_conditions_status/2, gdpr_consent_conditions_checklist/2, consent_conditions_status/4, consent_declaration_effect/3, identification_information_duty/4, identification_rights_effect/4]).

gdpr_consent_conditions_profile_keys([processing_based_on_consent, consent_demonstrable, consent_in_declaration_with_other_matters, request_clearly_distinguishable_and_intelligible, declaration_part_infringes_regulation, informed_of_withdrawal_right_before_consent, withdrawal_as_easy_as_giving_consent, contract_conditional_on_unneeded_consent, consent_freely_given, purposes_do_not_require_identification, able_to_demonstrate_not_in_position_to_identify, informing_data_subject_possible, additional_identifying_information_provided]).

gdpr_consent_conditions_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    profile_with_override(Profile, OverriddenKey, NewValue, Hypothesis),
    gdpr_consent_conditions_status(Hypothesis, NewStatus).

profile_with_override([], Key, Value, [attribute(Key, Value)]).
profile_with_override([attribute(ElementKey, _)|Elements], Key, Value, Hypothesis) :-
    ElementKey == Key,
    profile_with_override(Elements, Key, Value, Hypothesis).
profile_with_override([attribute(ElementKey, ElementValue)|Elements], Key, Value, [attribute(ElementKey, ElementValue)|Hypothesis]) :-
    ElementKey \== Key,
    profile_with_override(Elements, Key, Value, Hypothesis).

gdpr_consent_conditions_eligibility(Profile, assessment(consent, Decision, Checklist)) :-
    gdpr_consent_conditions_status(Profile, Status),
    eligibility_decision(Status, Decision),
    gdpr_consent_conditions_checklist(Profile, Checklist).

eligibility_decision(conditions_met, eligible) :-
    implements(eu_reg_2016_679_art_7_1).
eligibility_decision(conditions_not_met, ineligible) :-
    implements(eu_reg_2016_679_art_7_1).
eligibility_decision(not_applicable, ineligible) :-
    implements(eu_reg_2016_679_art_7_1).
eligibility_decision(indeterminate(_), undecided).
eligibility_decision(needs_legal_review(_, _), undecided).
eligibility_decision(input_problems(_), undecided).

gdpr_consent_conditions_obligations(Profile, Obligations) :-
    gdpr_consent_conditions_input_problems(Profile, Problems),
    obligations_answer(Problems, Profile, Obligations).

obligations_answer([Problem|Problems], _, input_problems([Problem|Problems])).
obligations_answer([], Profile, Obligations) :-
    findall(Obligation, obligation_due(Profile, Obligation), Obligations).

obligation_due(Profile, obligation(demonstrate_consent, cite(eu_reg_2016_679_art_7_1))) :-
    implements(eu_reg_2016_679_art_7_1),
    profile_get(Profile, processing_based_on_consent, true).
obligation_due(Profile, obligation(present_consent_request_distinguishably, cite(eu_reg_2016_679_art_7_2))) :-
    implements(eu_reg_2016_679_art_7_2),
    profile_get(Profile, processing_based_on_consent, true),
    profile_get(Profile, consent_in_declaration_with_other_matters, true).
obligation_due(Profile, obligation(inform_of_withdrawal_right_before_consent, cite(eu_reg_2016_679_art_7_3))) :-
    implements(eu_reg_2016_679_art_7_3),
    profile_get(Profile, processing_based_on_consent, true).
obligation_due(Profile, obligation(make_withdrawal_as_easy_as_giving_consent, cite(eu_reg_2016_679_art_7_3))) :-
    implements(eu_reg_2016_679_art_7_3),
    profile_get(Profile, processing_based_on_consent, true).
obligation_due(Profile, obligation(inform_data_subject_not_in_position_to_identify, cite(eu_reg_2016_679_art_11_2))) :-
    implements(eu_reg_2016_679_art_11_2),
    identification_information_duty(Profile, must_inform_data_subject, _, _).

gdpr_consent_conditions_compliance(Profile, rely_on_consent_for_processing, Verdict) :-
    consent_conditions_status(Profile, Status, _, _),
    consent_reliance_verdict(Status, Verdict).
gdpr_consent_conditions_compliance(Profile, enforce_infringing_declaration_part, Verdict) :-
    consent_declaration_effect(Profile, Status, _),
    declaration_enforcement_verdict(Status, Verdict).
gdpr_consent_conditions_compliance(Profile, decline_request_under_articles_15_to_20, Verdict) :-
    identification_rights_effect(Profile, Status, _, _),
    request_decline_verdict(Status, Verdict).

consent_reliance_verdict(conditions_met, compliant) :-
    implements(eu_reg_2016_679_art_7_1).
consent_reliance_verdict(conditions_not_met, non_compliant) :-
    implements(eu_reg_2016_679_art_7_1).
consent_reliance_verdict(not_applicable, undecided).
consent_reliance_verdict(indeterminate(_), undecided).
consent_reliance_verdict(needs_legal_review(_, _), undecided).
consent_reliance_verdict(input_problems(_), undecided).

declaration_enforcement_verdict(part_not_binding, non_compliant) :-
    implements(eu_reg_2016_679_art_7_2).
declaration_enforcement_verdict(no_part_infringing, compliant) :-
    implements(eu_reg_2016_679_art_7_2).
declaration_enforcement_verdict(not_applicable, undecided).
declaration_enforcement_verdict(indeterminate(_), undecided).
declaration_enforcement_verdict(input_problems(_), undecided).

request_decline_verdict(articles_15_to_20_do_not_apply, compliant) :-
    implements(eu_reg_2016_679_art_11_2).
request_decline_verdict(articles_15_to_20_apply, non_compliant) :-
    implements(eu_reg_2016_679_art_11_2).
request_decline_verdict(art11_2_not_engaged, undecided).
request_decline_verdict(indeterminate(_), undecided).
request_decline_verdict(needs_legal_review(_, _), undecided).
request_decline_verdict(input_problems(_), undecided).

not_applicable.

conditions_met.

conditions_not_met.

part_not_binding.

no_part_infringing.

not_obliged_to_acquire_identifying_information.

art11_1_not_engaged.

art11_2_not_engaged.

must_inform_data_subject.

need_not_inform_data_subject.

articles_15_to_20_apply.

articles_15_to_20_do_not_apply.
