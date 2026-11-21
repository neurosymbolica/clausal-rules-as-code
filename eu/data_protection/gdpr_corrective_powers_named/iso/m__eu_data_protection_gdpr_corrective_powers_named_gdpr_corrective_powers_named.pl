% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_corrective_powers_named_gdpr_corrective_powers_named, [corrective_powers_named/3, corrective_power_named/4, decide_gdpr_corrective_powers_named/2, gdpr_corrective_powers_named_status/2, gdpr_corrective_powers_named_checklist/2, gdpr_corrective_powers_named_decision_resolvable/1, gdpr_corrective_powers_named_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(pairs), [pairs_values/2]).
:- use_module(library(reif), [(=)/3]).
:- use_module(library(reif), [if_/3, memberd_t/3]).
:- use_module(formalize_lib, [profile_get/3]).
:- use_module(m__eu_data_protection_gdpr_corrective_powers_named_kernel, [gdpr_corrective_powers_named_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_corrective_powers_named_citations, [implements/1]).

gdpr_corrective_powers_named_status_values([powers_named, indeterminate, needs_legal_review, input_problems]).

measure_point(warning, [controller, processor], cite(eu_reg_2016_679_art_58_2_a)).
measure_point(reprimand, [controller, processor], cite(eu_reg_2016_679_art_58_2_b)).
measure_point(order_to_comply_with_data_subject_requests, [controller, processor], cite(eu_reg_2016_679_art_58_2_c)).
measure_point(order_to_bring_processing_into_compliance, [controller, processor], cite(eu_reg_2016_679_art_58_2_d)).
measure_point(order_to_communicate_personal_data_breach, [controller], cite(eu_reg_2016_679_art_58_2_e)).
measure_point(limitation_or_ban_on_processing, [], cite(eu_reg_2016_679_art_58_2_f)).
measure_point(order_of_rectification_erasure_or_restriction, [], cite(eu_reg_2016_679_art_58_2_g)).
measure_point(withdrawal_or_refusal_of_certification, [certification_body], cite(eu_reg_2016_679_art_58_2_h)).
measure_point(administrative_fine, [], cite(eu_reg_2016_679_art_58_2_i)).
measure_point(suspension_of_data_flows, [], cite(eu_reg_2016_679_art_58_2_j)).

point_keys(warning, [intended_processing_likely_to_infringe]).
point_keys(reprimand, [processing_has_infringed]).
point_keys(order_to_comply_with_data_subject_requests, [data_subject_request_to_exercise_rights_made]).
point_keys(order_to_bring_processing_into_compliance, [processing_not_in_compliance]).
point_keys(order_to_communicate_personal_data_breach, [personal_data_breach_occurred]).
point_keys(limitation_or_ban_on_processing, [intended_processing_likely_to_infringe, processing_has_infringed, processing_not_in_compliance]).
point_keys(order_of_rectification_erasure_or_restriction, [rectification_erasure_or_restriction_ground_met]).
point_keys(withdrawal_or_refusal_of_certification, [certification_issued_or_applied_for, certification_requirements_not_met]).
point_keys(administrative_fine, [processing_has_infringed]).
point_keys(suspension_of_data_flows, [data_flows_to_third_country_or_international_organisation]).

referral_citation(intended_processing_likely_to_infringe, cite(eu_reg_2016_679_art_58_2_a)).
referral_citation(processing_has_infringed, cite(eu_reg_2016_679_art_58_2_b)).
referral_citation(processing_not_in_compliance, cite(eu_reg_2016_679_art_58_2_d)).
referral_citation(rectification_erasure_or_restriction_ground_met, cite(eu_reg_2016_679_art_58_2_g)).
referral_citation(certification_requirements_not_met, cite(eu_reg_2016_679_art_58_2_h)).

contract_keys([intended_processing_likely_to_infringe, processing_has_infringed, data_subject_request_to_exercise_rights_made, processing_not_in_compliance, personal_data_breach_occurred, rectification_erasure_or_restriction_ground_met, certification_issued_or_applied_for, certification_requirements_not_met, data_flows_to_third_country_or_international_organisation]).

list_citations([cite(eu_reg_2016_679_art_58_2), cite(eu_reg_2016_679_art_58_2_a), cite(eu_reg_2016_679_art_58_2_b), cite(eu_reg_2016_679_art_58_2_c), cite(eu_reg_2016_679_art_58_2_d), cite(eu_reg_2016_679_art_58_2_e), cite(eu_reg_2016_679_art_58_2_f), cite(eu_reg_2016_679_art_58_2_g), cite(eu_reg_2016_679_art_58_2_h), cite(eu_reg_2016_679_art_58_2_i), cite(eu_reg_2016_679_art_58_2_j)]).

key_value(Profile, Key, State) :-
    findall(Value, profile_get(Profile, Key, Value), Values),
    key_value_state(Values, State).

key_value_state([], absent).
key_value_state([Value], Value).

key_states(_, [], []).
key_states(Profile, [Key|Keys], [Key - State|States]) :-
    key_value(Profile, Key, State),
    key_states(Profile, Keys, States).

present_pairs(Profile, Keys, Pairs) :-
    findall(Key - Value, (member(Key, Keys), profile_get(Profile, Key, Value)), Pairs).

first_with_value([Key - Found|Pairs], Wanted, Result) :-
    if_(Found = Wanted, Result = Key, first_with_value(Pairs, Wanted, Result)).

measure_atoms(Measures) :-
    findall(Measure, measure_point(Measure, _, _), Measures).

measure_t(Measure, Truth) :-
    term_variables(Measure, Variables),
    measure_ground_t(Variables, Measure, Truth).

measure_ground_t([_|_], _, false).
measure_ground_t([], Measure, Truth) :-
    measure_atoms(Measures),
    memberd_t(Measure, Measures, Truth).

measure_problems(Measure, []) :-
    measure_t(Measure, true).
measure_problems(Measure, [wrong_type(measure)]) :-
    measure_t(Measure, false).

power_problems(Profile, Measure, Problems) :-
    gdpr_corrective_powers_named_input_problems(Profile, ProfileProblems),
    measure_problems(Measure, MeasureProblems),
    append(ProfileProblems, MeasureProblems, Problems).

one_key_state(true, _, named) :-
    implements(eu_reg_2016_679_art_58_2).
one_key_state(false, _, not_named) :-
    implements(eu_reg_2016_679_art_58_2).
one_key_state(absent, Key, open_by_absence(Key)) :-
    implements(eu_reg_2016_679_art_58_2).
one_key_state(unsure, Key, open_by_judgement(Key)) :-
    implements(eu_reg_2016_679_art_58_2).

point_state(Profile, warning, State) :-
    implements(eu_reg_2016_679_art_58_2_a),
    key_value(Profile, intended_processing_likely_to_infringe, Value),
    one_key_state(Value, intended_processing_likely_to_infringe, State).
point_state(Profile, reprimand, State) :-
    implements(eu_reg_2016_679_art_58_2_b),
    key_value(Profile, processing_has_infringed, Value),
    one_key_state(Value, processing_has_infringed, State).
point_state(Profile, order_to_comply_with_data_subject_requests, State) :-
    implements(eu_reg_2016_679_art_58_2_c),
    key_value(Profile, data_subject_request_to_exercise_rights_made, Value),
    one_key_state(Value, data_subject_request_to_exercise_rights_made, State).
point_state(Profile, order_to_bring_processing_into_compliance, State) :-
    implements(eu_reg_2016_679_art_58_2_d),
    key_value(Profile, processing_not_in_compliance, Value),
    one_key_state(Value, processing_not_in_compliance, State).
point_state(Profile, order_to_communicate_personal_data_breach, State) :-
    implements(eu_reg_2016_679_art_58_2_e),
    key_value(Profile, personal_data_breach_occurred, Value),
    one_key_state(Value, personal_data_breach_occurred, State).
point_state(Profile, limitation_or_ban_on_processing, State) :-
    implements(eu_reg_2016_679_art_58_2_f),
    point_keys(limitation_or_ban_on_processing, Keys),
    key_states(Profile, Keys, Pairs),
    limitation_state(Pairs, State).
point_state(Profile, order_of_rectification_erasure_or_restriction, State) :-
    implements(eu_reg_2016_679_art_58_2_g),
    key_value(Profile, rectification_erasure_or_restriction_ground_met, Value),
    one_key_state(Value, rectification_erasure_or_restriction_ground_met, State).
point_state(Profile, withdrawal_or_refusal_of_certification, State) :-
    implements(eu_reg_2016_679_art_58_2_h),
    key_value(Profile, certification_issued_or_applied_for, Issued),
    key_value(Profile, certification_requirements_not_met, Requirements),
    certification_state(Issued, Requirements, State).
point_state(Profile, administrative_fine, State) :-
    implements(eu_reg_2016_679_art_58_2_i),
    key_value(Profile, processing_has_infringed, Value),
    one_key_state(Value, processing_has_infringed, State).
point_state(Profile, suspension_of_data_flows, State) :-
    implements(eu_reg_2016_679_art_58_2_j),
    key_value(Profile, data_flows_to_third_country_or_international_organisation, Value),
    one_key_state(Value, data_flows_to_third_country_or_international_organisation, State).

limitation_state(Pairs, State) :-
    implements(eu_reg_2016_679_art_58_2_f),
    pairs_values(Pairs, Values),
    memberd_t(true, Values, AnyTrue),
    limitation_after_true(AnyTrue, Pairs, Values, State).

limitation_after_true(true, _, _, named) :-
    implements(eu_reg_2016_679_art_58_2_f).
limitation_after_true(false, Pairs, Values, State) :-
    implements(eu_reg_2016_679_art_58_2_f),
    memberd_t(absent, Values, AnyAbsent),
    limitation_after_absent(AnyAbsent, Pairs, Values, State).

limitation_after_absent(true, Pairs, _, open_by_absence(Key)) :-
    implements(eu_reg_2016_679_art_58_2_f),
    first_with_value(Pairs, absent, Key).
limitation_after_absent(false, Pairs, Values, State) :-
    implements(eu_reg_2016_679_art_58_2_f),
    memberd_t(unsure, Values, AnyUnsure),
    limitation_after_unsure(AnyUnsure, Pairs, State).

limitation_after_unsure(true, Pairs, open_by_judgement(Key)) :-
    implements(eu_reg_2016_679_art_58_2_f),
    first_with_value(Pairs, unsure, Key).
limitation_after_unsure(false, _, not_named) :-
    implements(eu_reg_2016_679_art_58_2_f).

certification_state(false, _, not_named) :-
    implements(eu_reg_2016_679_art_58_2_h).
certification_state(true, false, not_named) :-
    implements(eu_reg_2016_679_art_58_2_h).
certification_state(absent, false, not_named) :-
    implements(eu_reg_2016_679_art_58_2_h).
certification_state(true, true, named) :-
    implements(eu_reg_2016_679_art_58_2_h).
certification_state(absent, true, open_by_absence(certification_issued_or_applied_for)) :-
    implements(eu_reg_2016_679_art_58_2_h).
certification_state(absent, unsure, open_by_absence(certification_issued_or_applied_for)) :-
    implements(eu_reg_2016_679_art_58_2_h).
certification_state(absent, absent, open_by_absence(certification_issued_or_applied_for)) :-
    implements(eu_reg_2016_679_art_58_2_h).
certification_state(true, absent, open_by_absence(certification_requirements_not_met)) :-
    implements(eu_reg_2016_679_art_58_2_h).
certification_state(true, unsure, open_by_judgement(certification_requirements_not_met)) :-
    implements(eu_reg_2016_679_art_58_2_h).

corrective_power_named(Profile, Measure, input_problems([Problem|Problems]), []) :-
    power_problems(Profile, Measure, [Problem|Problems]).
corrective_power_named(Profile, Measure, Result, Citations) :-
    power_problems(Profile, Measure, []),
    point_state(Profile, Measure, State),
    point_answer(State, Profile, Measure, Result, Citations).

point_answer(named, _, Measure, named(Addressees, authority_discretion), [cite(eu_reg_2016_679_art_58_2), PointCitation]) :-
    implements(eu_reg_2016_679_art_58_2),
    implements(eu_reg_2016_679_art_58_4),
    measure_point(Measure, Addressees, PointCitation).
point_answer(not_named, _, Measure, not_named, [cite(eu_reg_2016_679_art_58_2), PointCitation]) :-
    implements(eu_reg_2016_679_art_58_2),
    measure_point(Measure, _, PointCitation).
point_answer(open_by_absence(Key), _, _, indeterminate([Key]), []) :-
    implements(eu_reg_2016_679_art_58_2).
point_answer(open_by_judgement(Key), Profile, Measure, needs_legal_review(open_textured(Key, Citation), [inputs_relied_on(Pairs)]), []) :-
    implements(eu_reg_2016_679_art_58_2),
    referral_citation(Key, Citation),
    point_keys(Measure, Keys),
    present_pairs(Profile, Keys, Pairs).

corrective_powers_named(Profile, input_problems([Problem|Problems]), []) :-
    gdpr_corrective_powers_named_input_problems(Profile, [Problem|Problems]).
corrective_powers_named(Profile, Result, Citations) :-
    gdpr_corrective_powers_named_input_problems(Profile, []),
    point_states(Profile, StatePairs),
    findall(Key, member(_ - open_by_absence(Key), StatePairs), AbsenceKeys),
    findall(Key, member(_ - open_by_judgement(Key), StatePairs), JudgementKeys),
    list_answer(AbsenceKeys, JudgementKeys, StatePairs, Profile, Result, Citations).

point_states(Profile, StatePairs) :-
    findall(Measure - State, (measure_point(Measure, _, _), point_state(Profile, Measure, State)), StatePairs).

list_answer([Key|_], _, _, _, indeterminate([Key]), []) :-
    implements(eu_reg_2016_679_art_58_2).
list_answer([], [Key|_], _, Profile, needs_legal_review(open_textured(Key, Citation), [inputs_relied_on(Pairs)]), []) :-
    implements(eu_reg_2016_679_art_58_2),
    referral_citation(Key, Citation),
    contract_keys(Keys),
    present_pairs(Profile, Keys, Pairs).
list_answer([], [], StatePairs, _, powers_named(Powers, authority_discretion), Citations) :-
    implements(eu_reg_2016_679_art_58_2),
    implements(eu_reg_2016_679_art_58_4),
    implements(eu_reg_2016_679_art_58_5),
    implements(eu_reg_2016_679_art_58_6),
    findall(power(Measure, Addressees), (member(Measure - named, StatePairs), measure_point(Measure, Addressees, _)), Powers),
    list_citations(Citations).

decide_gdpr_corrective_powers_named(Profile, gdpr_corrective_powers_named_verdict(Result, Citations)) :-
    corrective_powers_named(Profile, Result, Citations).

gdpr_corrective_powers_named_status(Profile, Result) :-
    decide_gdpr_corrective_powers_named(Profile, gdpr_corrective_powers_named_verdict(Result, _Citations)).

gdpr_corrective_powers_named_checklist(Profile, Items) :-
    gdpr_corrective_powers_named_input_problems(Profile, []),
    findall(item(Measure, Status, Citation), (measure_point(Measure, _, Citation), point_state(Profile, Measure, State), checklist_status(State, Status)), Items).
gdpr_corrective_powers_named_checklist(Profile, [item(input_check, unmet(input_problems([Problem|Problems])), cite(eu_reg_2016_679_art_58_2))]) :-
    gdpr_corrective_powers_named_input_problems(Profile, [Problem|Problems]).

checklist_status(named, met).
checklist_status(not_named, unmet(not_named)).
checklist_status(open_by_absence(Key), unknown([Key])).
checklist_status(open_by_judgement(Key), unknown([Key])).

gdpr_corrective_powers_named_decision_resolvable(Profile) :-
    decide_gdpr_corrective_powers_named(Profile, _Verdict).

test(all_false_names_no_power) :-
    findall(Result - Citations, corrective_powers_named([attribute(intended_processing_likely_to_infringe, false), attribute(processing_has_infringed, false), attribute(data_subject_request_to_exercise_rights_made, false), attribute(processing_not_in_compliance, false), attribute(personal_data_breach_occurred, false), attribute(rectification_erasure_or_restriction_ground_met, false), attribute(certification_issued_or_applied_for, false), attribute(certification_requirements_not_met, false), attribute(data_flows_to_third_country_or_international_organisation, false)], Result, Citations), Answers),
    list_citations(Expected),
    Answers == [powers_named([], authority_discretion) - Expected].
test(infringement_names_reprimand_limitation_and_fine) :-
    findall(Result, corrective_powers_named([attribute(intended_processing_likely_to_infringe, false), attribute(processing_has_infringed, true), attribute(data_subject_request_to_exercise_rights_made, false), attribute(processing_not_in_compliance, false), attribute(personal_data_breach_occurred, false), attribute(rectification_erasure_or_restriction_ground_met, false), attribute(certification_issued_or_applied_for, false), attribute(data_flows_to_third_country_or_international_organisation, false)], Result, _), Results),
    Results == [powers_named([power(reprimand, [controller, processor]), power(limitation_or_ban_on_processing, []), power(administrative_fine, [])], authority_discretion)].
test(empty_profile_names_first_key) :-
    findall(Result - Citations, corrective_powers_named([], Result, Citations), Answers),
    Answers == [indeterminate([intended_processing_likely_to_infringe]) - []].
test(missing_certification_key_named_in_list) :-
    findall(Result, corrective_powers_named([attribute(intended_processing_likely_to_infringe, false), attribute(processing_has_infringed, false), attribute(data_subject_request_to_exercise_rights_made, false), attribute(processing_not_in_compliance, false), attribute(personal_data_breach_occurred, false), attribute(rectification_erasure_or_restriction_ground_met, unsure), attribute(data_flows_to_third_country_or_international_organisation, false)], Result, _), Results),
    Results == [indeterminate([certification_issued_or_applied_for])].
test(list_refers_unsure_with_all_present_pairs) :-
    findall(Result, corrective_powers_named([attribute(intended_processing_likely_to_infringe, unsure), attribute(processing_has_infringed, false), attribute(data_subject_request_to_exercise_rights_made, false), attribute(processing_not_in_compliance, false), attribute(personal_data_breach_occurred, false), attribute(rectification_erasure_or_restriction_ground_met, false), attribute(certification_issued_or_applied_for, false), attribute(data_flows_to_third_country_or_international_organisation, false)], Result, _), Results),
    Results == [needs_legal_review(open_textured(intended_processing_likely_to_infringe, cite(eu_reg_2016_679_art_58_2_a)), [inputs_relied_on([intended_processing_likely_to_infringe - unsure, processing_has_infringed - false, data_subject_request_to_exercise_rights_made - false, processing_not_in_compliance - false, personal_data_breach_occurred - false, rectification_erasure_or_restriction_ground_met - false, certification_issued_or_applied_for - false, data_flows_to_third_country_or_international_organisation - false])])].
test(warning_named_for_controller_or_processor) :-
    findall(Result - Citations, corrective_power_named([attribute(intended_processing_likely_to_infringe, true)], warning, Result, Citations), Answers),
    Answers == [named([controller, processor], authority_discretion) - [cite(eu_reg_2016_679_art_58_2), cite(eu_reg_2016_679_art_58_2_a)]].
test(warning_not_named) :-
    corrective_power_named([attribute(intended_processing_likely_to_infringe, false)], warning, not_named, [cite(eu_reg_2016_679_art_58_2), cite(eu_reg_2016_679_art_58_2_a)]).
test(warning_unsure_refers) :-
    findall(Result, corrective_power_named([attribute(intended_processing_likely_to_infringe, unsure), attribute(processing_has_infringed, true)], warning, Result, _), Results),
    Results == [needs_legal_review(open_textured(intended_processing_likely_to_infringe, cite(eu_reg_2016_679_art_58_2_a)), [inputs_relied_on([intended_processing_likely_to_infringe - unsure])])].
test(unread_key_does_not_change_warning) :-
    corrective_power_named([attribute(intended_processing_likely_to_infringe, true)], warning, named([controller, processor], authority_discretion), _).
test(limitation_named_by_one_true) :-
    findall(Result, corrective_power_named([attribute(processing_has_infringed, true)], limitation_or_ban_on_processing, Result, _), Results),
    Results == [named([], authority_discretion)].
test(limitation_absent_before_unsure) :-
    findall(Result, corrective_power_named([attribute(intended_processing_likely_to_infringe, unsure), attribute(processing_not_in_compliance, false)], limitation_or_ban_on_processing, Result, _), Results),
    Results == [indeterminate([processing_has_infringed])].
test(limitation_refers_first_unsure) :-
    findall(Result, corrective_power_named([attribute(intended_processing_likely_to_infringe, false), attribute(processing_has_infringed, unsure), attribute(processing_not_in_compliance, unsure)], limitation_or_ban_on_processing, Result, _), Results),
    Results == [needs_legal_review(open_textured(processing_has_infringed, cite(eu_reg_2016_679_art_58_2_b)), [inputs_relied_on([intended_processing_likely_to_infringe - false, processing_has_infringed - unsure, processing_not_in_compliance - unsure])])].
test(certification_false_requirements_settle_it) :-
    findall(Result, corrective_power_named([attribute(certification_requirements_not_met, false)], withdrawal_or_refusal_of_certification, Result, _), Results),
    Results == [not_named].
test(certification_requirements_wait_behind_issued) :-
    findall(Result, corrective_power_named([attribute(certification_requirements_not_met, unsure)], withdrawal_or_refusal_of_certification, Result, _), Results),
    Results == [indeterminate([certification_issued_or_applied_for])].
test(certification_named_for_certification_body) :-
    corrective_power_named([attribute(certification_issued_or_applied_for, true), attribute(certification_requirements_not_met, true)], withdrawal_or_refusal_of_certification, named([certification_body], authority_discretion), [cite(eu_reg_2016_679_art_58_2), cite(eu_reg_2016_679_art_58_2_h)]).
test(breach_order_to_controller_only) :-
    corrective_power_named([attribute(personal_data_breach_occurred, true)], order_to_communicate_personal_data_breach, named([controller], authority_discretion), _).
test(unknown_measure_is_wrong_type) :-
    findall(Result - Citations, corrective_power_named([], caution, Result, Citations), Answers),
    Answers == [input_problems([wrong_type(measure)]) - []].
test(unbound_measure_is_not_enumerated) :-
    findall(Result, corrective_power_named([], _, Result, _), Results),
    Results == [input_problems([wrong_type(measure)])].
test(profile_problems_before_measure_problem) :-
    findall(Result, corrective_power_named([attribute(processing_has_infringed, unsure), attribute(processing_has_infringed, true), attribute(personal_data_breach_occurred, unsure)], caution, Result, _), Results),
    Results == [input_problems([duplicate_key(processing_has_infringed), wrong_type(personal_data_breach_occurred), wrong_type(measure)])].
test(attested_value_is_wrong_type) :-
    corrective_powers_named([attribute(processing_has_infringed, attested(authority_finding))], input_problems([wrong_type(processing_has_infringed)]), []).
test(checklist_carries_citations) :-
    gdpr_corrective_powers_named_checklist([attribute(intended_processing_likely_to_infringe, true)], Items),
    member(item(warning, met, cite(eu_reg_2016_679_art_58_2_a)), Items),
    member(item(reprimand, unknown([processing_has_infringed]), cite(eu_reg_2016_679_art_58_2_b)), Items),
    length(Items, 10).
test(facade_verdict_matches_query) :-
    decide_gdpr_corrective_powers_named([], gdpr_corrective_powers_named_verdict(indeterminate([intended_processing_likely_to_infringe]), [])).

test(warning_not_named_is_not_named_form, fail) :-
    corrective_power_named([attribute(intended_processing_likely_to_infringe, false)], warning, named(_, _), _).
