% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_payment_related_incidents_dora_payment_related_incidents, [decide_dora_payment_related_incidents/2, dora_payment_related_incidents_status/2, dora_payment_related_incidents_checklist/2, dora_payment_related_incidents_decision_resolvable/1, dora_payment_related_incidents_status_values/1, payment_related_incident_status/3, payment_related_incident_report_recipients/3, chapter_requirements_and_article_19_reporting_apply/0, chapter_requirements_apply/0, not_a_payment_related_incident/0, not_an_article_23_entity/0, relevant_competent_authority/0, national_competent_authority_designated_under_directive_2013_36/0, directive_2022_2555_competent_authority_or_csirt/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_payment_related_incidents_kernel, [dora_payment_related_incidents_input_problems/2, dora_payment_related_incidents_contract_keys/1]).
:- use_module(m__eu_dora_payment_related_incidents_citations, [implements/1]).
:- use_module(formalize_lib, [profile_get/3, profile_lacks/2, eval_requirements/4]).
:- use_module(library(reif), [memberd_t/3]).

chapter_requirements_and_article_19_reporting_apply.

chapter_requirements_apply.

not_a_payment_related_incident.

not_an_article_23_entity.

relevant_competent_authority.

national_competent_authority_designated_under_directive_2013_36.

directive_2022_2555_competent_authority_or_csirt.

dora_payment_related_incidents_status_values([chapter_requirements_and_article_19_reporting_apply, chapter_requirements_apply, not_a_payment_related_incident, not_an_article_23_entity]).

article_23_entity_type(credit_institution, cite(eu_reg_2022_2554_art_2_1_a)).
article_23_entity_type(payment_institution, cite(eu_reg_2022_2554_art_3_35)).
article_23_entity_type(exempted_payment_institution, cite(eu_reg_2022_2554_art_3_36)).
article_23_entity_type(account_information_service_provider, cite(eu_reg_2022_2554_art_3_37)).
article_23_entity_type(electronic_money_institution, cite(eu_reg_2022_2554_art_3_38)).
article_23_entity_type(exempted_electronic_money_institution, cite(eu_reg_2022_2554_art_3_39)).

key_state(Profile, Key, absent) :-
    profile_lacks(Profile, Key).
key_state(Profile, Key, given(Value)) :-
    profile_get(Profile, Key, Value).

judgement_open(true).
judgement_open(unsure).

relied_pairs(Profile, ReadKeys, Pairs) :-
    dora_payment_related_incidents_contract_keys(ContractKeys),
    findall(Key - Value, (member(Key, ContractKeys), member(Key, ReadKeys), profile_get(Profile, Key, Value)), Pairs).

status_pairs(Profile, Pairs) :-
    relied_pairs(Profile, [dora_entity_type, incident_is_operational_or_security_payment_related, payment_related_incident_is_major], Pairs).

recipients_pairs(Profile, Pairs) :-
    dora_payment_related_incidents_contract_keys(ContractKeys),
    relied_pairs(Profile, ContractKeys, Pairs).

entity_reach(EntityType, Reach) :-
    implements(eu_reg_2022_2554_art_23),
    implements(eu_reg_2022_2554_art_2_1_a),
    implements(eu_reg_2022_2554_art_2_1_b),
    implements(eu_reg_2022_2554_art_2_1_c),
    implements(eu_reg_2022_2554_art_2_1_d),
    findall(ReachedType, article_23_entity_type(ReachedType, _Citation), ReachedTypes),
    memberd_t(EntityType, ReachedTypes, IsReached),
    reach_of_truth(IsReached, Reach).

reach_of_truth(true, reached).
reach_of_truth(false, not_reached) :-
    implements(eu_reg_2022_2554_art_3_32).

payment_related_incident_status(Profile, Status, Citations) :-
    dora_payment_related_incidents_input_problems(Profile, Problems),
    status_after_check(Problems, Profile, Status, Citations).

status_after_check([Problem|Problems], _Profile, input_problems([Problem|Problems]), []).
status_after_check([], Profile, Status, Citations) :-
    key_state(Profile, dora_entity_type, TypeState),
    status_by_type(TypeState, Profile, Status, Citations).

status_by_type(absent, _Profile, indeterminate([dora_entity_type]), []).
status_by_type(given(EntityType), Profile, Status, Citations) :-
    entity_reach(EntityType, Reach),
    status_by_reach(Reach, Profile, Status, Citations).

status_by_reach(not_reached, _Profile, not_an_article_23_entity, [cite(eu_reg_2022_2554_art_23)]) :-
    implements(eu_reg_2022_2554_art_23).
status_by_reach(reached, Profile, Status, Citations) :-
    implements(eu_reg_2022_2554_art_23),
    key_state(Profile, incident_is_operational_or_security_payment_related, IncidentState),
    key_state(Profile, payment_related_incident_is_major, MajorState),
    status_by_incident(IncidentState, MajorState, Profile, Status, Citations).

status_by_incident(given(false), _MajorState, _Profile, not_a_payment_related_incident, [cite(eu_reg_2022_2554_art_23), cite(eu_reg_2022_2554_art_3_9)]) :-
    implements(eu_reg_2022_2554_art_3_9).
status_by_incident(absent, _MajorState, _Profile, indeterminate([incident_is_operational_or_security_payment_related]), []).
status_by_incident(given(IncidentValue), absent, _Profile, indeterminate([payment_related_incident_is_major]), []) :-
    judgement_open(IncidentValue).
status_by_incident(given(unsure), given(_MajorValue), Profile, needs_legal_review(open_textured(incident_is_operational_or_security_payment_related, cite(eu_reg_2022_2554_art_3_9)), [inputs_relied_on(Pairs)]), []) :-
    implements(eu_reg_2022_2554_art_3_9),
    status_pairs(Profile, Pairs).
status_by_incident(given(true), given(unsure), Profile, needs_legal_review(open_textured(payment_related_incident_is_major, cite(eu_reg_2022_2554_art_3_11)), [inputs_relied_on(Pairs)]), []) :-
    implements(eu_reg_2022_2554_art_3_11),
    status_pairs(Profile, Pairs).
status_by_incident(given(true), given(false), _Profile, chapter_requirements_apply, [cite(eu_reg_2022_2554_art_23), cite(eu_reg_2022_2554_art_3_9), cite(eu_reg_2022_2554_art_3_11)]) :-
    implements(eu_reg_2022_2554_art_3_11).
status_by_incident(given(true), given(true), _Profile, chapter_requirements_and_article_19_reporting_apply, [cite(eu_reg_2022_2554_art_23), cite(eu_reg_2022_2554_art_3_9), cite(eu_reg_2022_2554_art_3_11), cite(eu_reg_2022_2554_art_18_3_a), cite(eu_reg_2022_2554_art_19_1)]) :-
    implements(eu_reg_2022_2554_art_18_3_a).

payment_related_incident_report_recipients(Profile, Result, Citations) :-
    dora_payment_related_incidents_input_problems(Profile, Problems),
    recipients_after_check(Problems, Profile, Result, Citations).

recipients_after_check([Problem|Problems], _Profile, input_problems([Problem|Problems]), []).
recipients_after_check([], Profile, Result, Citations) :-
    key_state(Profile, dora_entity_type, TypeState),
    recipients_by_type(TypeState, Profile, Result, Citations).

recipients_by_type(absent, _Profile, indeterminate([dora_entity_type]), []).
recipients_by_type(given(EntityType), Profile, Result, Citations) :-
    entity_reach(EntityType, Reach),
    recipients_by_reach(Reach, EntityType, Profile, Result, Citations).

recipients_by_reach(not_reached, _EntityType, _Profile, not_an_article_23_entity, [cite(eu_reg_2022_2554_art_23)]) :-
    implements(eu_reg_2022_2554_art_23).
recipients_by_reach(reached, EntityType, Profile, Result, Citations) :-
    implements(eu_reg_2022_2554_art_23),
    key_state(Profile, incident_is_operational_or_security_payment_related, IncidentState),
    key_state(Profile, payment_related_incident_is_major, MajorState),
    recipients_by_incident(IncidentState, MajorState, EntityType, Profile, Result, Citations).

recipients_by_incident(given(false), _MajorState, _EntityType, _Profile, not_a_payment_related_incident, [cite(eu_reg_2022_2554_art_23), cite(eu_reg_2022_2554_art_3_9)]) :-
    implements(eu_reg_2022_2554_art_3_9).
recipients_by_incident(absent, _MajorState, _EntityType, _Profile, indeterminate([incident_is_operational_or_security_payment_related]), []).
recipients_by_incident(given(IncidentValue), absent, _EntityType, _Profile, indeterminate([payment_related_incident_is_major]), []) :-
    judgement_open(IncidentValue).
recipients_by_incident(given(unsure), given(false), _EntityType, Profile, needs_legal_review(open_textured(incident_is_operational_or_security_payment_related, cite(eu_reg_2022_2554_art_3_9)), [inputs_relied_on(Pairs)]), []) :-
    implements(eu_reg_2022_2554_art_3_9),
    recipients_pairs(Profile, Pairs).
recipients_by_incident(given(true), given(false), _EntityType, _Profile, chapter_requirements_apply, [cite(eu_reg_2022_2554_art_23), cite(eu_reg_2022_2554_art_3_9), cite(eu_reg_2022_2554_art_3_11)]) :-
    implements(eu_reg_2022_2554_art_3_11).
recipients_by_incident(given(IncidentValue), given(MajorValue), EntityType, Profile, Result, Citations) :-
    implements(eu_reg_2022_2554_art_19_1),
    judgement_open(IncidentValue),
    judgement_open(MajorValue),
    significance_state(EntityType, Profile, SignificanceState),
    key_state(Profile, member_state_requires_reports_to_directive_2022_2555_authorities, MemberStateState),
    recipients_by_facts(SignificanceState, MemberStateState, IncidentValue, MajorValue, Profile, Result, Citations).

significance_state(credit_institution, Profile, SignificanceState) :-
    implements(eu_reg_2022_2554_art_19_1_third_subparagraph),
    key_state(Profile, credit_institution_classified_as_significant, SignificanceState).
significance_state(EntityType, _Profile, not_read) :-
    implements(eu_reg_2022_2554_art_19_1_third_subparagraph),
    dif(EntityType, credit_institution).

significance_settled(given(_SignificanceValue)).
significance_settled(not_read).

recipients_by_facts(absent, _MemberStateState, _IncidentValue, _MajorValue, _Profile, indeterminate([credit_institution_classified_as_significant]), []).
recipients_by_facts(SignificanceState, absent, _IncidentValue, _MajorValue, _Profile, indeterminate([member_state_requires_reports_to_directive_2022_2555_authorities]), []) :-
    significance_settled(SignificanceState).
recipients_by_facts(SignificanceState, given(_MemberStateValue), unsure, _MajorValue, Profile, needs_legal_review(open_textured(incident_is_operational_or_security_payment_related, cite(eu_reg_2022_2554_art_3_9)), [inputs_relied_on(Pairs)]), []) :-
    implements(eu_reg_2022_2554_art_3_9),
    significance_settled(SignificanceState),
    recipients_pairs(Profile, Pairs).
recipients_by_facts(SignificanceState, given(_MemberStateValue), true, unsure, Profile, needs_legal_review(open_textured(payment_related_incident_is_major, cite(eu_reg_2022_2554_art_3_11)), [inputs_relied_on(Pairs)]), []) :-
    implements(eu_reg_2022_2554_art_3_11),
    significance_settled(SignificanceState),
    recipients_pairs(Profile, Pairs).
recipients_by_facts(SignificanceState, given(MemberStateValue), true, true, _Profile, recipients([PrimaryRecipient|AdditionalRecipients]), [cite(eu_reg_2022_2554_art_23), cite(eu_reg_2022_2554_art_3_9), cite(eu_reg_2022_2554_art_3_11), cite(eu_reg_2022_2554_art_18_3_a), cite(eu_reg_2022_2554_art_19_1)]) :-
    implements(eu_reg_2022_2554_art_19_1),
    significance_settled(SignificanceState),
    primary_recipient(SignificanceState, PrimaryRecipient),
    additional_recipients(MemberStateValue, AdditionalRecipients).

primary_recipient(given(true), national_competent_authority_designated_under_directive_2013_36) :-
    implements(eu_reg_2022_2554_art_19_1_third_subparagraph).
primary_recipient(given(false), relevant_competent_authority) :-
    implements(eu_reg_2022_2554_art_19_1).
primary_recipient(not_read, relevant_competent_authority) :-
    implements(eu_reg_2022_2554_art_19_1).

additional_recipients(true, [directive_2022_2555_competent_authority_or_csirt]) :-
    implements(eu_reg_2022_2554_art_19_1_sixth_subparagraph).
additional_recipients(false, []) :-
    implements(eu_reg_2022_2554_art_19_1_sixth_subparagraph).

decide_dora_payment_related_incidents(Profile, dora_payment_related_incidents_verdict(Status, Citations)) :-
    payment_related_incident_status(Profile, Status, Citations).

dora_payment_related_incidents_status(Profile, Status) :-
    decide_dora_payment_related_incidents(Profile, dora_payment_related_incidents_verdict(Status, _Citations)).

dora_payment_related_incidents_decision_resolvable(Profile) :-
    decide_dora_payment_related_incidents(Profile, _Verdict).

dora_payment_related_incidents_checklist(Profile, Items) :-
    dora_payment_related_incidents_input_problems(Profile, Problems),
    checklist_after_check(Problems, Profile, Items).

checklist_after_check([Problem|Problems], _Profile, [item(well_formed_profile, unmet(input_problems([Problem|Problems])), cite(eu_reg_2022_2554_art_23))]).
checklist_after_check([], Profile, Items) :-
    eval_requirements([article_23_entity, payment_related_incident, major_incident], Profile, dora_payment_related_incidents_requirement, Items).

dora_payment_related_incidents_requirement(article_23_entity, Profile, Status, cite(eu_reg_2022_2554_art_23)) :-
    implements(eu_reg_2022_2554_art_23),
    key_state(Profile, dora_entity_type, TypeState),
    entity_requirement_status(TypeState, Status).
dora_payment_related_incidents_requirement(payment_related_incident, Profile, Status, cite(eu_reg_2022_2554_art_3_9)) :-
    implements(eu_reg_2022_2554_art_3_9),
    key_state(Profile, incident_is_operational_or_security_payment_related, IncidentState),
    judgement_requirement_status(IncidentState, incident_is_operational_or_security_payment_related, not_a_payment_related_incident, Status).
dora_payment_related_incidents_requirement(major_incident, Profile, Status, cite(eu_reg_2022_2554_art_3_11)) :-
    implements(eu_reg_2022_2554_art_3_11),
    key_state(Profile, payment_related_incident_is_major, MajorState),
    judgement_requirement_status(MajorState, payment_related_incident_is_major, not_a_major_incident, Status).

entity_requirement_status(absent, unknown([dora_entity_type])).
entity_requirement_status(given(EntityType), Status) :-
    entity_reach(EntityType, Reach),
    reach_requirement_status(Reach, Status).

reach_requirement_status(reached, met).
reach_requirement_status(not_reached, unmet(not_an_article_23_entity)).

judgement_requirement_status(absent, Key, _Reason, unknown([Key])).
judgement_requirement_status(given(true), _Key, _Reason, met).
judgement_requirement_status(given(false), _Key, Reason, unmet(Reason)).
judgement_requirement_status(given(unsure), Key, _Reason, unknown([Key])).

test(a_major_incident_of_a_payment_institution_is_reported) :-
    findall(Status - Citations, payment_related_incident_status([attribute(dora_entity_type, payment_institution), attribute(incident_is_operational_or_security_payment_related, true), attribute(payment_related_incident_is_major, true)], Status, Citations), Answers),
    Answers == [chapter_requirements_and_article_19_reporting_apply - [cite(eu_reg_2022_2554_art_23), cite(eu_reg_2022_2554_art_3_9), cite(eu_reg_2022_2554_art_3_11), cite(eu_reg_2022_2554_art_18_3_a), cite(eu_reg_2022_2554_art_19_1)]].
test(an_incident_that_is_not_major_brings_only_the_chapter) :-
    findall(Status, payment_related_incident_status([attribute(dora_entity_type, exempted_electronic_money_institution), attribute(incident_is_operational_or_security_payment_related, true), attribute(payment_related_incident_is_major, false)], Status, _Citations), Answers),
    Answers == [chapter_requirements_apply].
test(the_institution_exempted_under_directive_2013_36_is_not_reached) :-
    findall(Status - Citations, payment_related_incident_status([attribute(dora_entity_type, institution_exempted_pursuant_to_directive_2013_36), attribute(incident_is_operational_or_security_payment_related, false)], Status, Citations), Answers),
    Answers == [not_an_article_23_entity - [cite(eu_reg_2022_2554_art_23)]].
test(the_entity_type_is_the_gate) :-
    findall(Status, payment_related_incident_status([attribute(incident_is_operational_or_security_payment_related, false)], Status, _Citations), Answers),
    Answers == [indeterminate([dora_entity_type])].
test(not_payment_related_decides_alone) :-
    findall(Status, payment_related_incident_status([attribute(dora_entity_type, credit_institution), attribute(incident_is_operational_or_security_payment_related, false)], Status, _Citations), Answers),
    Answers == [not_a_payment_related_incident].
test(major_is_named_before_an_unsure_incident_is_referred) :-
    findall(Status, payment_related_incident_status([attribute(dora_entity_type, credit_institution), attribute(incident_is_operational_or_security_payment_related, unsure)], Status, _Citations), Answers),
    Answers == [indeterminate([payment_related_incident_is_major])].
test(an_unsure_incident_is_referred_with_the_pairs_the_status_reads) :-
    findall(Status - Citations, payment_related_incident_status([attribute(credit_institution_classified_as_significant, true), attribute(payment_related_incident_is_major, false), attribute(incident_is_operational_or_security_payment_related, unsure), attribute(dora_entity_type, credit_institution)], Status, Citations), Answers),
    Answers == [needs_legal_review(open_textured(incident_is_operational_or_security_payment_related, cite(eu_reg_2022_2554_art_3_9)), [inputs_relied_on([dora_entity_type - credit_institution, incident_is_operational_or_security_payment_related - unsure, payment_related_incident_is_major - false])]) - []].
test(an_input_problem_comes_first) :-
    findall(Status - Citations, payment_related_incident_status([attribute(dora_entity_type, bank)], Status, Citations), Answers),
    Answers == [input_problems([wrong_type(dora_entity_type)]) - []].
test(a_significant_credit_institution_reports_to_the_national_authority) :-
    findall(Result - Citations, payment_related_incident_report_recipients([attribute(dora_entity_type, credit_institution), attribute(incident_is_operational_or_security_payment_related, true), attribute(payment_related_incident_is_major, true), attribute(credit_institution_classified_as_significant, true), attribute(member_state_requires_reports_to_directive_2022_2555_authorities, true)], Result, Citations), Answers),
    Answers == [recipients([national_competent_authority_designated_under_directive_2013_36, directive_2022_2555_competent_authority_or_csirt]) - [cite(eu_reg_2022_2554_art_23), cite(eu_reg_2022_2554_art_3_9), cite(eu_reg_2022_2554_art_3_11), cite(eu_reg_2022_2554_art_18_3_a), cite(eu_reg_2022_2554_art_19_1)]].
test(a_payment_institution_reports_to_the_relevant_authority) :-
    findall(Result, payment_related_incident_report_recipients([attribute(dora_entity_type, payment_institution), attribute(incident_is_operational_or_security_payment_related, true), attribute(payment_related_incident_is_major, true), attribute(credit_institution_classified_as_significant, true), attribute(member_state_requires_reports_to_directive_2022_2555_authorities, false)], Result, _Citations), Answers),
    Answers == [recipients([relevant_competent_authority])].
test(significance_is_named_before_an_unsure_judgement_is_referred) :-
    findall(Result, payment_related_incident_report_recipients([attribute(dora_entity_type, credit_institution), attribute(incident_is_operational_or_security_payment_related, unsure), attribute(payment_related_incident_is_major, true)], Result, _Citations), Answers),
    Answers == [indeterminate([credit_institution_classified_as_significant])].
test(the_member_state_key_is_named_for_another_type) :-
    findall(Result, payment_related_incident_report_recipients([attribute(dora_entity_type, account_information_service_provider), attribute(incident_is_operational_or_security_payment_related, true), attribute(payment_related_incident_is_major, unsure)], Result, _Citations), Answers),
    Answers == [indeterminate([member_state_requires_reports_to_directive_2022_2555_authorities])].
test(not_major_gives_no_list_and_reads_no_fact_key) :-
    findall(Result, payment_related_incident_report_recipients([attribute(dora_entity_type, credit_institution), attribute(incident_is_operational_or_security_payment_related, true), attribute(payment_related_incident_is_major, false)], Result, _Citations), Answers),
    Answers == [chapter_requirements_apply].
test(an_unsure_major_is_referred_with_all_present_pairs) :-
    findall(Result, payment_related_incident_report_recipients([attribute(dora_entity_type, electronic_money_institution), attribute(incident_is_operational_or_security_payment_related, true), attribute(payment_related_incident_is_major, unsure), attribute(credit_institution_classified_as_significant, false), attribute(member_state_requires_reports_to_directive_2022_2555_authorities, true)], Result, _Citations), Answers),
    Answers == [needs_legal_review(open_textured(payment_related_incident_is_major, cite(eu_reg_2022_2554_art_3_11)), [inputs_relied_on([dora_entity_type - electronic_money_institution, incident_is_operational_or_security_payment_related - true, payment_related_incident_is_major - unsure, credit_institution_classified_as_significant - false, member_state_requires_reports_to_directive_2022_2555_authorities - true])])].
test(a_type_not_reached_gives_no_recipients) :-
    findall(Result, payment_related_incident_report_recipients([attribute(dora_entity_type, ict_third_party_service_provider)], Result, _Citations), Answers),
    Answers == [not_an_article_23_entity].
test(the_facade_verdict_carries_the_status) :-
    decide_dora_payment_related_incidents([attribute(dora_entity_type, credit_institution), attribute(incident_is_operational_or_security_payment_related, true), attribute(payment_related_incident_is_major, false)], dora_payment_related_incidents_verdict(chapter_requirements_apply, _Citations)).
test(the_checklist_cites_each_requirement) :-
    dora_payment_related_incidents_checklist([attribute(dora_entity_type, credit_institution), attribute(incident_is_operational_or_security_payment_related, true)], Items),
    member(item(article_23_entity, met, cite(eu_reg_2022_2554_art_23)), Items),
    member(item(payment_related_incident, met, cite(eu_reg_2022_2554_art_3_9)), Items),
    member(item(major_incident, unknown([payment_related_incident_is_major]), cite(eu_reg_2022_2554_art_3_11)), Items).

test(a_type_not_reached_is_not_a_report, fail) :-
    payment_related_incident_report_recipients([attribute(dora_entity_type, ict_third_party_service_provider)], recipients(_Recipients), _Citations).
