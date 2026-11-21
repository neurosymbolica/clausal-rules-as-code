% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_proportionality_and_simplified_framework_dora_proportionality_and_simplified_framework, [simplified_framework_qualification/3, simplified_framework_duties_required/3, simplified_framework_duties_complete/3, simplified_framework_duties_outstanding/3, article_16_1_entity/0, not_article_16_1_entity/0, out_of_scope/0, not_a_financial_entity/0, complete/0, incomplete/0, none_outstanding/0, decide_dora_proportionality_and_simplified_framework/2, dora_proportionality_and_simplified_framework_status/2, dora_proportionality_and_simplified_framework_checklist/2, dora_proportionality_and_simplified_framework_decision_resolvable/1, dora_proportionality_and_simplified_framework_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [last/2]).
:- use_module(library(clpz)).
:- use_module(formalize_lib, [profile_get/3, profile_lacks/2]).
:- use_module(m__eu_dora_proportionality_and_simplified_framework_kernel, [dora_proportionality_and_simplified_framework_input_problems/2, contract_key_order/1]).
:- use_module(m__eu_dora_proportionality_and_simplified_framework_citations, [implements/1]).

other_financial_entity_type(credit_institution, cite(eu_reg_2022_2554_art_2_2)).
other_financial_entity_type(payment_institution, cite(eu_reg_2022_2554_art_2_2)).
other_financial_entity_type(account_information_service_provider, cite(eu_reg_2022_2554_art_2_2)).
other_financial_entity_type(electronic_money_institution, cite(eu_reg_2022_2554_art_2_2)).
other_financial_entity_type(crypto_asset_service_provider, cite(eu_reg_2022_2554_art_2_2)).
other_financial_entity_type(issuer_of_asset_referenced_tokens, cite(eu_reg_2022_2554_art_2_2)).
other_financial_entity_type(central_securities_depository, cite(eu_reg_2022_2554_art_2_2)).
other_financial_entity_type(central_counterparty, cite(eu_reg_2022_2554_art_2_2)).
other_financial_entity_type(trading_venue, cite(eu_reg_2022_2554_art_2_2)).
other_financial_entity_type(trade_repository, cite(eu_reg_2022_2554_art_2_2)).
other_financial_entity_type(manager_of_alternative_investment_funds, cite(eu_reg_2022_2554_art_2_2)).
other_financial_entity_type(management_company, cite(eu_reg_2022_2554_art_2_2)).
other_financial_entity_type(data_reporting_service_provider, cite(eu_reg_2022_2554_art_2_2)).
other_financial_entity_type(insurance_undertaking, cite(eu_reg_2022_2554_art_2_2)).
other_financial_entity_type(reinsurance_undertaking, cite(eu_reg_2022_2554_art_2_2)).
other_financial_entity_type(insurance_intermediary, cite(eu_reg_2022_2554_art_2_2)).
other_financial_entity_type(reinsurance_intermediary, cite(eu_reg_2022_2554_art_2_2)).
other_financial_entity_type(ancillary_insurance_intermediary, cite(eu_reg_2022_2554_art_2_2)).
other_financial_entity_type(credit_rating_agency, cite(eu_reg_2022_2554_art_2_2)).
other_financial_entity_type(administrator_of_critical_benchmarks, cite(eu_reg_2022_2554_art_2_2)).
other_financial_entity_type(crowdfunding_service_provider, cite(eu_reg_2022_2554_art_2_2)).
other_financial_entity_type(securitisation_repository, cite(eu_reg_2022_2554_art_2_2)).

duty(simplified_ict_risk_management_framework, simplified_framework_in_place_and_maintained, always, cite(eu_reg_2022_2554_art_16_1_a)).
duty(continuous_monitoring_of_ict_systems, ict_systems_continuously_monitored, always, cite(eu_reg_2022_2554_art_16_1_b)).
duty(ict_risk_impact_minimisation, ict_risk_impact_minimised_with_sound_systems, always, cite(eu_reg_2022_2554_art_16_1_c)).
duty(detection_and_handling, risk_sources_detected_and_incidents_handled, always, cite(eu_reg_2022_2554_art_16_1_d)).
duty(key_third_party_dependencies, key_ict_third_party_dependencies_identified, always, cite(eu_reg_2022_2554_art_16_1_e)).
duty(continuity_of_critical_or_important_functions, continuity_of_critical_functions_ensured, always, cite(eu_reg_2022_2554_art_16_1_f)).
duty(regular_testing, plans_and_controls_tested_regularly, always, cite(eu_reg_2022_2554_art_16_1_g)).
duty(operational_conclusions_implemented, test_and_incident_conclusions_implemented, always, cite(eu_reg_2022_2554_art_16_1_h)).
duty(awareness_and_training_programmes, awareness_and_training_programmes_developed, always, cite(eu_reg_2022_2554_art_16_1_h)).
duty(framework_documentation_and_review, simplified_framework_documented_and_reviewed, always, cite(eu_reg_2022_2554_art_16_2)).
duty(continuous_improvement, simplified_framework_continuously_improved, always, cite(eu_reg_2022_2554_art_16_2)).
duty(review_report_to_authority, simplified_framework_review_report_submitted, on_request, cite(eu_reg_2022_2554_art_16_2)).

duty_citation_list([cite(eu_reg_2022_2554_art_4_1), cite(eu_reg_2022_2554_art_16_1), cite(eu_reg_2022_2554_art_16_1_a), cite(eu_reg_2022_2554_art_16_1_b), cite(eu_reg_2022_2554_art_16_1_c), cite(eu_reg_2022_2554_art_16_1_d), cite(eu_reg_2022_2554_art_16_1_e), cite(eu_reg_2022_2554_art_16_1_f), cite(eu_reg_2022_2554_art_16_1_g), cite(eu_reg_2022_2554_art_16_1_h), cite(eu_reg_2022_2554_art_16_2)]).

referral_row(simplified_ict_risk_management_framework_unclear, open_textured, simplified_framework_in_place_and_maintained, cite(eu_reg_2022_2554_art_16_1_a)).
referral_row(continuous_monitoring_of_ict_systems_unclear, open_textured, ict_systems_continuously_monitored, cite(eu_reg_2022_2554_art_16_1_b)).
referral_row(ict_risk_impact_minimisation_unclear, open_textured, ict_risk_impact_minimised_with_sound_systems, cite(eu_reg_2022_2554_art_16_1_c)).
referral_row(detection_and_handling_unclear, open_textured, risk_sources_detected_and_incidents_handled, cite(eu_reg_2022_2554_art_16_1_d)).
referral_row(key_third_party_dependencies_unclear, open_textured, key_ict_third_party_dependencies_identified, cite(eu_reg_2022_2554_art_16_1_e)).
referral_row(continuity_of_critical_or_important_functions_unclear, open_textured, continuity_of_critical_functions_ensured, cite(eu_reg_2022_2554_art_16_1_f)).
referral_row(regular_testing_unclear, open_textured, plans_and_controls_tested_regularly, cite(eu_reg_2022_2554_art_16_1_g)).
referral_row(operational_conclusions_implemented_unclear, open_textured, test_and_incident_conclusions_implemented, cite(eu_reg_2022_2554_art_16_1_h)).
referral_row(awareness_and_training_programmes_unclear, open_textured, awareness_and_training_programmes_developed, cite(eu_reg_2022_2554_art_16_1_h)).
referral_row(framework_documentation_and_review_unclear, open_textured, simplified_framework_documented_and_reviewed, cite(eu_reg_2022_2554_art_16_2)).
referral_row(continuous_improvement_unclear, open_textured, simplified_framework_continuously_improved, cite(eu_reg_2022_2554_art_16_2)).

article_16_1_entity.

not_article_16_1_entity.

out_of_scope.

not_a_financial_entity.

complete.

incomplete.

none_outstanding.

key_state(Profile, Key, given(Value)) :-
    profile_get(Profile, Key, Value).
key_state(Profile, Key, absent) :-
    profile_lacks(Profile, Key).

relied_pairs(Profile, Pairs) :-
    contract_key_order(Keys),
    findall(Key - Value, (member(Key, Keys), profile_get(Profile, Key, Value)), Pairs).

simplified_framework_qualification(Profile, Result, Citations) :-
    dora_proportionality_and_simplified_framework_input_problems(Profile, Problems),
    qualification_step(Problems, Profile, Result, Citations).

qualification_step([Problem|Problems], _, input_problems([Problem|Problems]), []).
qualification_step([], Profile, Result, Citations) :-
    qualify_profile(Profile, Result, Citations).

qualify_profile(Profile, Result, Citations) :-
    key_state(Profile, dora_entity_type, TypeState),
    qualify_type_state(TypeState, Profile, Result, Citations).

qualify_type_state(absent, _, indeterminate([dora_entity_type]), []).
qualify_type_state(given(EntityType), Profile, Result, Citations) :-
    type_route(EntityType, Profile, Result, Citations).

type_route(ict_third_party_service_provider, _, not_a_financial_entity, [cite(eu_reg_2022_2554_art_2_1_u), cite(eu_reg_2022_2554_art_2_2)]) :-
    implements(eu_reg_2022_2554_art_2_2).
type_route(none_of_the_listed_types, _, out_of_scope, [cite(eu_reg_2022_2554_art_2_1)]) :-
    implements(eu_reg_2022_2554_art_2_1).
type_route(exempted_payment_institution, _, article_16_1_entity, [cite(eu_reg_2022_2554_art_16_1), cite(eu_reg_2022_2554_art_3_36)]) :-
    implements(eu_reg_2022_2554_art_3_36).
type_route(exempted_electronic_money_institution, _, article_16_1_entity, [cite(eu_reg_2022_2554_art_16_1), cite(eu_reg_2022_2554_art_3_39)]) :-
    implements(eu_reg_2022_2554_art_3_39).
type_route(investment_firm, Profile, Result, Citations) :-
    implements(eu_reg_2022_2554_art_3_34),
    key_state(Profile, investment_firm_is_small_and_non_interconnected, SmallState),
    investment_firm_route(SmallState, Result, Citations).
type_route(institution_for_occupational_retirement_provision, Profile, Result, Citations) :-
    implements(eu_reg_2022_2554_art_3_53),
    key_state(Profile, iorp_pension_scheme_members_total, MembersState),
    occupational_retirement_route(MembersState, Result, Citations).
type_route(institution_exempted_pursuant_to_directive_2013_36, Profile, Result, Citations) :-
    implements(eu_reg_2022_2554_art_3_32),
    key_state(Profile, exempted_from_dora_scope_by_member_state, ExclusionState),
    directive_2013_36_route(ExclusionState, Result, Citations).
type_route(EntityType, _, not_article_16_1_entity, [cite(eu_reg_2022_2554_art_16_1)]) :-
    implements(eu_reg_2022_2554_art_16_1),
    other_financial_entity_type(EntityType, _).

investment_firm_route(absent, indeterminate([investment_firm_is_small_and_non_interconnected]), []).
investment_firm_route(given(true), article_16_1_entity, [cite(eu_reg_2022_2554_art_16_1), cite(eu_reg_2022_2554_art_3_34)]) :-
    implements(eu_reg_2022_2554_art_3_34).
investment_firm_route(given(false), not_article_16_1_entity, [cite(eu_reg_2022_2554_art_16_1)]) :-
    implements(eu_reg_2022_2554_art_16_1).

occupational_retirement_route(absent, indeterminate([iorp_pension_scheme_members_total]), []).
occupational_retirement_route(given(Members), out_of_scope, [cite(eu_reg_2022_2554_art_2_3_c)]) :-
    implements(eu_reg_2022_2554_art_2_3_c),
    Members #< 16.
occupational_retirement_route(given(Members), article_16_1_entity, [cite(eu_reg_2022_2554_art_16_1), cite(eu_reg_2022_2554_art_3_53)]) :-
    implements(eu_reg_2022_2554_art_3_53),
    Members #> 15,
    Members #< 100.
occupational_retirement_route(given(Members), not_article_16_1_entity, [cite(eu_reg_2022_2554_art_16_1)]) :-
    implements(eu_reg_2022_2554_art_3_53),
    Members #>= 100.

directive_2013_36_route(absent, indeterminate([exempted_from_dora_scope_by_member_state]), []).
directive_2013_36_route(given(true), out_of_scope, [cite(eu_reg_2022_2554_art_2_4)]) :-
    implements(eu_reg_2022_2554_art_2_4).
directive_2013_36_route(given(false), article_16_1_entity, [cite(eu_reg_2022_2554_art_16_1), cite(eu_reg_2022_2554_art_3_32)]) :-
    implements(eu_reg_2022_2554_art_16_1).

applies_under(always, _) :-
    implements(eu_reg_2022_2554_art_16_1).
applies_under(on_request, true) :-
    implements(eu_reg_2022_2554_art_16_2).

failing_duties(Profile, Failing) :-
    key_state(Profile, authority_requested_framework_review_report, TriggerState),
    findall(Duty, duty_fails(Profile, TriggerState, Duty), Failing).

duty_fails(Profile, _, Duty) :-
    implements(eu_reg_2022_2554_art_16_1),
    duty(Duty, Key, always, _),
    key_state(Profile, Key, given(false)).
duty_fails(Profile, given(true), Duty) :-
    implements(eu_reg_2022_2554_art_16_2),
    duty(Duty, Key, on_request, _),
    key_state(Profile, Key, given(false)).

unsure_keys(Profile, Keys) :-
    findall(Key, (duty(_, Key, always, _), key_state(Profile, Key, given(unsure))), Keys).

absent_key_candidates(Profile, Candidates) :-
    key_state(Profile, authority_requested_framework_review_report, TriggerState),
    key_state(Profile, simplified_framework_review_report_submitted, ReportState),
    trigger_class(TriggerState, ReportState, TriggerClass),
    findall(Key - Alone, duty_key_candidate(Profile, TriggerState, Key, Alone), DutyCandidates),
    prepend_trigger(TriggerClass, DutyCandidates, Candidates).

trigger_class(given(_), _, none).
trigger_class(absent, given(true), none).
trigger_class(absent, given(false), candidate(alone)).
trigger_class(absent, absent, candidate(dependent)).

prepend_trigger(none, Candidates, Candidates).
prepend_trigger(candidate(Alone), Candidates, [authority_requested_framework_review_report - Alone|Candidates]).

duty_key_candidate(Profile, TriggerState, Key, Alone) :-
    duty(_, Key, Applicability, _),
    key_state(Profile, Key, KeyState),
    duty_key_class(Applicability, KeyState, TriggerState, candidate(Alone)).

duty_key_class(always, absent, _, candidate(alone)).
duty_key_class(always, given(_), _, none).
duty_key_class(on_request, given(_), _, none).
duty_key_class(on_request, absent, given(false), none).
duty_key_class(on_request, absent, given(true), candidate(alone)).
duty_key_class(on_request, absent, absent, candidate(dependent)).

named_absent_key([Key|_], _, key(Key)).
named_absent_key([], [Key|_], key(Key)).
named_absent_key([], [], no_key).

referral(Profile, Key, needs_legal_review(open_textured(Key, Citation), [inputs_relied_on(Pairs)])) :-
    implements(eu_reg_2022_2554_art_4_1),
    referral_row(_, open_textured, Key, Citation),
    relied_pairs(Profile, Pairs).

outstanding_citations(Failing, Citations) :-
    implements(eu_reg_2022_2554_art_4_1),
    findall(Citation, (member(Duty, Failing), duty(Duty, _, _, Citation)), DutyCitations),
    sort([cite(eu_reg_2022_2554_art_4_1), cite(eu_reg_2022_2554_art_16_1)|DutyCitations], Citations).

simplified_framework_duties_required(Profile, Result, Citations) :-
    dora_proportionality_and_simplified_framework_input_problems(Profile, Problems),
    required_step(Problems, Profile, Result, Citations).

required_step([Problem|Problems], _, input_problems([Problem|Problems]), []).
required_step([], Profile, Result, Citations) :-
    qualify_profile(Profile, Qualification, QualificationCitations),
    required_after_qualification(Qualification, QualificationCitations, Profile, Result, Citations).

required_after_qualification(article_16_1_entity, _, Profile, Result, Citations) :-
    key_state(Profile, authority_requested_framework_review_report, TriggerState),
    required_for_trigger(TriggerState, Result, Citations).
required_after_qualification(Qualification, QualificationCitations, _, Qualification, QualificationCitations) :-
    dif(Qualification, article_16_1_entity).

required_for_trigger(absent, indeterminate([authority_requested_framework_review_report]), []).
required_for_trigger(given(Requested), required(Duties), Citations) :-
    implements(eu_reg_2022_2554_art_4_1),
    findall(Duty, (duty(Duty, _, Applicability, _), applies_under(Applicability, Requested)), Duties),
    duty_citation_list(Citations).

simplified_framework_duties_complete(Profile, Result, Citations) :-
    dora_proportionality_and_simplified_framework_input_problems(Profile, Problems),
    complete_step(Problems, Profile, Result, Citations).

complete_step([Problem|Problems], _, input_problems([Problem|Problems]), []).
complete_step([], Profile, Result, Citations) :-
    qualify_profile(Profile, Qualification, QualificationCitations),
    complete_after_qualification(Qualification, QualificationCitations, Profile, Result, Citations).

complete_after_qualification(article_16_1_entity, _, Profile, Result, Citations) :-
    failing_duties(Profile, Failing),
    complete_failure_step(Failing, Profile, Result, Citations).
complete_after_qualification(Qualification, QualificationCitations, _, Qualification, QualificationCitations) :-
    dif(Qualification, article_16_1_entity).

complete_failure_step([_|_], _, incomplete, Citations) :-
    implements(eu_reg_2022_2554_art_16_1),
    duty_citation_list(Citations).
complete_failure_step([], Profile, Result, Citations) :-
    absent_key_candidates(Profile, Candidates),
    findall(AloneKey, member(AloneKey - alone, Candidates), AloneKeys),
    findall(CandidateKey, member(CandidateKey - _, Candidates), CandidateKeys),
    named_absent_key(AloneKeys, CandidateKeys, Named),
    complete_absent_step(Named, Profile, Result, Citations).

complete_absent_step(key(Key), _, indeterminate([Key]), []).
complete_absent_step(no_key, Profile, Result, Citations) :-
    unsure_keys(Profile, UnsureKeys),
    complete_unsure_step(UnsureKeys, Profile, Result, Citations).

complete_unsure_step([Key|_], Profile, Review, []) :-
    referral(Profile, Key, Review).
complete_unsure_step([], _, complete, Citations) :-
    implements(eu_reg_2022_2554_art_4_1),
    duty_citation_list(Citations).

simplified_framework_duties_outstanding(Profile, Result, Citations) :-
    dora_proportionality_and_simplified_framework_input_problems(Profile, Problems),
    outstanding_step(Problems, Profile, Result, Citations).

outstanding_step([Problem|Problems], _, input_problems([Problem|Problems]), []).
outstanding_step([], Profile, Result, Citations) :-
    qualify_profile(Profile, Qualification, QualificationCitations),
    outstanding_after_qualification(Qualification, QualificationCitations, Profile, Result, Citations).

outstanding_after_qualification(article_16_1_entity, _, Profile, Result, Citations) :-
    absent_key_candidates(Profile, Candidates),
    findall(CandidateKey, member(CandidateKey - _, Candidates), CandidateKeys),
    outstanding_absent_step(CandidateKeys, Profile, Result, Citations).
outstanding_after_qualification(Qualification, QualificationCitations, _, Qualification, QualificationCitations) :-
    dif(Qualification, article_16_1_entity).

outstanding_absent_step([Key|_], _, indeterminate([Key]), []).
outstanding_absent_step([], Profile, Result, Citations) :-
    unsure_keys(Profile, UnsureKeys),
    outstanding_unsure_step(UnsureKeys, Profile, Result, Citations).

outstanding_unsure_step([Key|_], Profile, Review, []) :-
    referral(Profile, Key, Review).
outstanding_unsure_step([], Profile, Result, Citations) :-
    failing_duties(Profile, Failing),
    outstanding_final(Failing, Result, Citations).

outstanding_final([], none_outstanding, Citations) :-
    implements(eu_reg_2022_2554_art_4_1),
    duty_citation_list(Citations).
outstanding_final([Duty|Duties], outstanding([Duty|Duties]), Citations) :-
    implements(eu_reg_2022_2554_art_4_1),
    outstanding_citations([Duty|Duties], Citations).

dora_proportionality_and_simplified_framework_status_values([complete, incomplete, not_article_16_1_entity, out_of_scope, not_a_financial_entity]).

decide_dora_proportionality_and_simplified_framework(Profile, dora_proportionality_and_simplified_framework_verdict(Status, Citations)) :-
    simplified_framework_duties_complete(Profile, Status, Citations).

dora_proportionality_and_simplified_framework_status(Profile, Status) :-
    decide_dora_proportionality_and_simplified_framework(Profile, dora_proportionality_and_simplified_framework_verdict(Status, _Citations)).

dora_proportionality_and_simplified_framework_decision_resolvable(Profile) :-
    decide_dora_proportionality_and_simplified_framework(Profile, _Verdict).

dora_proportionality_and_simplified_framework_checklist(Profile, Items) :-
    dora_proportionality_and_simplified_framework_input_problems(Profile, Problems),
    checklist_step(Problems, Profile, Items).

checklist_step([Problem|Problems], _, [item(input_check, input_problems([Problem|Problems]), [])]).
checklist_step([], Profile, [item(qualification, Qualification, QualificationCitations)|DutyItems]) :-
    qualify_profile(Profile, Qualification, QualificationCitations),
    duty_items(Qualification, Profile, DutyItems).

duty_items(article_16_1_entity, Profile, Items) :-
    key_state(Profile, authority_requested_framework_review_report, TriggerState),
    findall(item(Duty, Status, Citation), duty_item(Profile, TriggerState, Duty, Status, Citation), Items).
duty_items(Qualification, _, []) :-
    dif(Qualification, article_16_1_entity).

duty_item(Profile, TriggerState, Duty, Status, Citation) :-
    duty(Duty, Key, Applicability, Citation),
    key_state(Profile, Key, KeyState),
    duty_item_status(Applicability, TriggerState, Key, KeyState, Status).

duty_item_status(always, _, Key, KeyState, Status) :-
    key_item_status(KeyState, Key, Status).
duty_item_status(on_request, given(true), Key, KeyState, Status) :-
    key_item_status(KeyState, Key, Status).
duty_item_status(on_request, given(false), _, _, inapplicable).
duty_item_status(on_request, absent, _, given(true), met).
duty_item_status(on_request, absent, _, given(false), unknown([authority_requested_framework_review_report])).
duty_item_status(on_request, absent, _, absent, unknown([authority_requested_framework_review_report])).

key_item_status(given(true), _, met).
key_item_status(given(false), _, unmet(not_performed)).
key_item_status(given(unsure), Key, unknown([Key])).
key_item_status(absent, Key, unknown([Key])).

later_duty_attributes([attribute(ict_systems_continuously_monitored, true), attribute(ict_risk_impact_minimised_with_sound_systems, true), attribute(risk_sources_detected_and_incidents_handled, true), attribute(key_ict_third_party_dependencies_identified, true), attribute(continuity_of_critical_functions_ensured, true), attribute(plans_and_controls_tested_regularly, true), attribute(test_and_incident_conclusions_implemented, true), attribute(awareness_and_training_programmes_developed, true), attribute(simplified_framework_documented_and_reviewed, true), attribute(simplified_framework_continuously_improved, true)]).

performed_duty_attributes([attribute(simplified_framework_in_place_and_maintained, true)|Others]) :-
    later_duty_attributes(Others).

entity_profile(Extra, Profile) :-
    performed_duty_attributes(Duties),
    append([attribute(dora_entity_type, exempted_payment_institution)|Extra], Duties, Profile).

test(an_absent_type_is_asked_first) :-
    simplified_framework_qualification([], indeterminate([dora_entity_type]), []).
test(an_exempted_payment_institution_qualifies) :-
    simplified_framework_qualification([attribute(dora_entity_type, exempted_payment_institution)], article_16_1_entity, Citations),
    Citations == [cite(eu_reg_2022_2554_art_16_1), cite(eu_reg_2022_2554_art_3_36)].
test(an_ict_third_party_service_provider_is_not_a_financial_entity) :-
    simplified_framework_qualification([attribute(dora_entity_type, ict_third_party_service_provider)], not_a_financial_entity, Citations),
    Citations == [cite(eu_reg_2022_2554_art_2_1_u), cite(eu_reg_2022_2554_art_2_2)].
test(an_unlisted_type_is_out_of_scope) :-
    simplified_framework_qualification([attribute(dora_entity_type, none_of_the_listed_types)], out_of_scope, [cite(eu_reg_2022_2554_art_2_1)]).
test(an_investment_firm_waits_for_its_size_key) :-
    simplified_framework_qualification([attribute(dora_entity_type, investment_firm)], indeterminate([investment_firm_is_small_and_non_interconnected]), []).
test(a_small_investment_firm_qualifies) :-
    simplified_framework_qualification([attribute(dora_entity_type, investment_firm), attribute(investment_firm_is_small_and_non_interconnected, true)], article_16_1_entity, _).
test(fifteen_members_is_out_of_scope) :-
    simplified_framework_qualification([attribute(dora_entity_type, institution_for_occupational_retirement_provision), attribute(iorp_pension_scheme_members_total, 15)], out_of_scope, [cite(eu_reg_2022_2554_art_2_3_c)]).
test(sixteen_members_qualifies) :-
    simplified_framework_qualification([attribute(dora_entity_type, institution_for_occupational_retirement_provision), attribute(iorp_pension_scheme_members_total, 16)], article_16_1_entity, _).
test(ninety_nine_members_qualifies) :-
    simplified_framework_qualification([attribute(dora_entity_type, institution_for_occupational_retirement_provision), attribute(iorp_pension_scheme_members_total, 99)], article_16_1_entity, _).
test(one_hundred_members_does_not_qualify) :-
    simplified_framework_qualification([attribute(dora_entity_type, institution_for_occupational_retirement_provision), attribute(iorp_pension_scheme_members_total, 100)], not_article_16_1_entity, [cite(eu_reg_2022_2554_art_16_1)]).
test(a_member_state_exclusion_is_out_of_scope) :-
    simplified_framework_qualification([attribute(dora_entity_type, institution_exempted_pursuant_to_directive_2013_36), attribute(exempted_from_dora_scope_by_member_state, true)], out_of_scope, [cite(eu_reg_2022_2554_art_2_4)]).
test(a_credit_institution_does_not_qualify) :-
    simplified_framework_qualification([attribute(dora_entity_type, credit_institution)], not_article_16_1_entity, [cite(eu_reg_2022_2554_art_16_1)]).
test(a_wrong_type_is_refused_first) :-
    simplified_framework_qualification([attribute(dora_entity_type, bogus)], input_problems([wrong_type(dora_entity_type)]), []).
test(required_waits_for_the_trigger) :-
    simplified_framework_duties_required([attribute(dora_entity_type, exempted_payment_institution)], indeterminate([authority_requested_framework_review_report]), []).
test(a_requested_report_adds_the_twelfth_duty) :-
    simplified_framework_duties_required([attribute(dora_entity_type, exempted_payment_institution), attribute(authority_requested_framework_review_report, true)], required(Duties), Citations),
    length(Duties, 12),
    last(Duties, review_report_to_authority),
    length(Citations, 11).
test(no_request_gives_eleven_duties) :-
    simplified_framework_duties_required([attribute(dora_entity_type, exempted_payment_institution), attribute(authority_requested_framework_review_report, false)], required(Duties), _),
    length(Duties, 11),
    Duties = [simplified_ict_risk_management_framework|_].
test(required_passes_on_the_qualification) :-
    simplified_framework_duties_required([attribute(dora_entity_type, investment_firm), attribute(investment_firm_is_small_and_non_interconnected, false)], not_article_16_1_entity, [cite(eu_reg_2022_2554_art_16_1)]).
test(all_duties_performed_is_complete) :-
    entity_profile([attribute(authority_requested_framework_review_report, false)], Profile),
    simplified_framework_duties_complete(Profile, complete, Citations),
    length(Citations, 11).
test(a_false_duty_decides_before_absent_keys) :-
    simplified_framework_duties_complete([attribute(dora_entity_type, exempted_payment_institution), attribute(simplified_framework_in_place_and_maintained, false)], incomplete, _).
test(an_unsent_requested_report_is_incomplete) :-
    entity_profile([attribute(authority_requested_framework_review_report, true), attribute(simplified_framework_review_report_submitted, false)], Profile),
    simplified_framework_duties_complete(Profile, incomplete, _).
test(an_absent_always_duty_comes_before_the_trigger) :-
    simplified_framework_duties_complete([attribute(dora_entity_type, exempted_payment_institution)], indeterminate([simplified_framework_in_place_and_maintained]), []).
test(an_unsent_report_makes_the_trigger_decide_alone) :-
    entity_profile([attribute(simplified_framework_review_report_submitted, false)], Profile),
    simplified_framework_duties_complete(Profile, indeterminate([authority_requested_framework_review_report]), []).
test(the_report_key_waits_for_the_trigger) :-
    entity_profile([], Profile),
    simplified_framework_duties_complete(Profile, indeterminate([authority_requested_framework_review_report]), []).
test(a_sent_report_makes_the_trigger_irrelevant) :-
    entity_profile([attribute(simplified_framework_review_report_submitted, true)], Profile),
    simplified_framework_duties_complete(Profile, complete, _).
test(an_unsure_judgement_is_referred) :-
    later_duty_attributes(Others),
    Profile = [attribute(dora_entity_type, exempted_payment_institution), attribute(authority_requested_framework_review_report, false), attribute(simplified_framework_in_place_and_maintained, unsure)|Others],
    simplified_framework_duties_complete(Profile, needs_legal_review(open_textured(simplified_framework_in_place_and_maintained, cite(eu_reg_2022_2554_art_16_1_a)), [inputs_relied_on(Pairs)]), []),
    length(Pairs, 13),
    Pairs = [dora_entity_type - exempted_payment_institution, authority_requested_framework_review_report - false, simplified_framework_in_place_and_maintained - unsure|_].
test(a_false_duty_wins_over_an_unsure_one) :-
    Profile = [attribute(dora_entity_type, exempted_payment_institution), attribute(simplified_framework_in_place_and_maintained, unsure), attribute(ict_systems_continuously_monitored, false)],
    simplified_framework_duties_complete(Profile, incomplete, _).
test(complete_has_exactly_one_solution) :-
    entity_profile([attribute(authority_requested_framework_review_report, false)], Profile),
    findall(Result - Citations, simplified_framework_duties_complete(Profile, Result, Citations), Answers),
    length(Answers, 1).
test(outstanding_needs_every_key_first) :-
    simplified_framework_duties_outstanding([attribute(dora_entity_type, exempted_payment_institution), attribute(simplified_framework_in_place_and_maintained, false)], indeterminate([authority_requested_framework_review_report]), []).
test(outstanding_lists_the_failing_duties) :-
    later_duty_attributes(Others),
    Profile = [attribute(dora_entity_type, exempted_payment_institution), attribute(authority_requested_framework_review_report, true), attribute(simplified_framework_in_place_and_maintained, false), attribute(simplified_framework_review_report_submitted, false)|Others],
    simplified_framework_duties_outstanding(Profile, outstanding(Duties), Citations),
    Duties == [simplified_ict_risk_management_framework, review_report_to_authority],
    length(Citations, 4).
test(no_failing_duty_is_none_outstanding) :-
    entity_profile([attribute(authority_requested_framework_review_report, false)], Profile),
    simplified_framework_duties_outstanding(Profile, none_outstanding, _).
test(outstanding_has_exactly_one_solution) :-
    entity_profile([attribute(authority_requested_framework_review_report, false)], Profile),
    findall(Result, simplified_framework_duties_outstanding(Profile, Result, _), Answers),
    Answers == [none_outstanding].
test(the_facade_verdict_follows_completeness) :-
    entity_profile([attribute(authority_requested_framework_review_report, false)], Profile),
    decide_dora_proportionality_and_simplified_framework(Profile, dora_proportionality_and_simplified_framework_verdict(complete, _)).
test(the_checklist_has_a_row_per_duty) :-
    entity_profile([attribute(authority_requested_framework_review_report, false)], Profile),
    dora_proportionality_and_simplified_framework_checklist(Profile, Items),
    length(Items, 13).
test(the_checklist_of_another_entity_has_one_row) :-
    dora_proportionality_and_simplified_framework_checklist([attribute(dora_entity_type, credit_institution)], [item(qualification, not_article_16_1_entity, _)]).

test(one_hundred_members_is_not_article_16_1_entity, fail) :-
    simplified_framework_qualification([attribute(dora_entity_type, institution_for_occupational_retirement_provision), attribute(iorp_pension_scheme_members_total, 100)], article_16_1_entity, _).
test(a_credit_institution_is_not_article_16_1_entity, fail) :-
    simplified_framework_qualification([attribute(dora_entity_type, credit_institution)], article_16_1_entity, _).
test(all_duties_performed_is_not_incomplete, fail) :-
    entity_profile([attribute(authority_requested_framework_review_report, false)], Profile),
    simplified_framework_duties_complete(Profile, incomplete, _).
