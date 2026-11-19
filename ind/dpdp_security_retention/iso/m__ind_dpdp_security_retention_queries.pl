% SPDX-License-Identifier: EUPL-1.2
:- module(m__ind_dpdp_security_retention_queries, [dpdp_security_retention_profile_keys/1, dpdp_security_retention_what_if/4, required_with_rule_6_minimum/0, required_minimum_not_prescribed/0, not_required/0, not_in_force/0, required/0, erase/0, erase_and_cause_data_processor_to_erase/0, retain_until_minimum_retention_period_end/0, retain_as_required_by_other_law/0, not_yet_required/0, deemed_no_longer_served/0, not_yet_deemed/0, not_listed/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_is_list/1]).
:- use_module(m__ind_dpdp_security_retention_kernel, [dpdp_security_retention_input_problems/2]).
:- use_module(m__ind_dpdp_security_retention_dpdp_security_retention, [dpdp_security_retention_status/2]).

dpdp_security_retention_profile_keys([section_8_3_in_force, section_8_5_in_force, section_8_7_in_force, section_8_8_in_force, acts_as_data_fiduciary, likely_used_for_decision_affecting_data_principal, likely_disclosed_to_another_data_fiduciary, retention_necessary_for_compliance_with_law, consent_withdrawn, specified_purpose_no_longer_served, assessment_date, last_processing_date, data_made_available_to_data_processor, third_schedule_class, registered_users_in_india, third_schedule_purpose_excepted, last_approached_date]).

dpdp_security_retention_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    ground(Profile),
    clausal_is_list(Profile),
    profile_without_key(Profile, OverriddenKey, RemainingAttributes),
    append(RemainingAttributes, [attribute(OverriddenKey, NewValue)], Hypothesis),
    dpdp_security_retention_status(Hypothesis, NewStatus).

profile_without_key([], _, []).
profile_without_key([attribute(ElementKey, _)|Elements], OverriddenKey, RemainingAttributes) :-
    ElementKey == OverriddenKey,
    profile_without_key(Elements, OverriddenKey, RemainingAttributes).
profile_without_key([attribute(ElementKey, ElementValue)|Elements], OverriddenKey, [attribute(ElementKey, ElementValue)|RemainingAttributes]) :-
    ElementKey \== OverriddenKey,
    profile_without_key(Elements, OverriddenKey, RemainingAttributes).

required_with_rule_6_minimum.

required_minimum_not_prescribed.

not_required.

not_in_force.

required.

erase.

erase_and_cause_data_processor_to_erase.

retain_until_minimum_retention_period_end.

retain_as_required_by_other_law.

not_yet_required.

deemed_no_longer_served.

not_yet_deemed.

not_listed.

test(what_if_makes_a_processor_a_fiduciary) :-
    findall(Status, dpdp_security_retention_what_if([attribute(section_8_5_in_force, true), attribute(acts_as_data_fiduciary, false), attribute(assessment_date, date(2028, 1, 1))], acts_as_data_fiduciary, true, Status), Statuses),
    Statuses == [section_8_duty_owed].
test(what_if_keeps_one_attribute_per_key) :-
    profile_without_key([attribute(consent_withdrawn, true), attribute(assessment_date, date(2028, 1, 1))], consent_withdrawn, RemainingAttributes),
    RemainingAttributes == [attribute(assessment_date, date(2028, 1, 1))].
test(what_if_on_a_list_has_an_answer) :-
    dpdp_security_retention_what_if([], consent_withdrawn, true, section_8_duty_undetermined).
test(root_result_atoms_have_defining_clauses) :-
    required_with_rule_6_minimum,
    not_in_force,
    erase,
    not_listed.

test(what_if_on_a_non_list_has_no_answer, fail) :-
    dpdp_security_retention_what_if(not_a_list, consent_withdrawn, true, _).
