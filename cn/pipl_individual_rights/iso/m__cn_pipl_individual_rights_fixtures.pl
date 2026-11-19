% SPDX-License-Identifier: EUPL-1.2
:- module(m__cn_pipl_individual_rights_fixtures, [pipl_individual_rights_subject/1, pipl_individual_rights_profile_for/2, pipl_individual_rights_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(m__cn_pipl_individual_rights_pipl_individual_rights, [decide_pipl_individual_rights/2]).

baseline_profile([attribute(pinned_text_in_force_on_reference_day, true), attribute(laws_or_regulations_provide_otherwise, false), attribute(article_18_1_case, false), attribute(article_35_case, false), attribute(cyberspace_department_transfer_conditions_met, true), attribute(verification_confirms_inaccurate_or_incomplete, true), attribute(purpose_achieved_impossible_or_unnecessary, false), attribute(service_stopped_or_retention_period_expired, false), attribute(consent_withdrawn, true), attribute(processing_violates_law_or_agreement, false), attribute(other_deletion_case_prescribed_by_law, false), attribute(legal_retention_period_unexpired, false), attribute(deletion_technically_difficult, false), attribute(person_deceased, true), attribute(requester_is_near_relative, true), attribute(for_requester_own_lawful_and_legitimate_interests, true), attribute(deceased_arranged_otherwise, false), attribute(convenient_mechanism_established, true), attribute(request_refused, true), attribute(refusal_reasons_given, true)]).

subject_change(baseline_all_rights_engaged, [], [], []).
subject_change(restriction_excluded_by_other_law, [laws_or_regulations_provide_otherwise - true], [], []).
subject_change(restriction_other_law_unstated, [], [laws_or_regulations_provide_otherwise], []).
subject_change(access_article_18_1_case, [article_18_1_case - true], [], []).
subject_change(access_article_35_case, [article_35_case - true], [], []).
subject_change(access_article_35_unstated, [], [article_35_case], []).
subject_change(portability_conditions_not_met, [cyberspace_department_transfer_conditions_met - false], [], []).
subject_change(portability_conditions_unstated, [], [cyberspace_department_transfer_conditions_met], []).
subject_change(correction_verification_negative, [verification_confirms_inaccurate_or_incomplete - false], [], []).
subject_change(correction_verification_unsure, [verification_confirms_inaccurate_or_incomplete - unsure], [], []).
subject_change(deletion_retention_period_unexpired, [legal_retention_period_unexpired - true], [], []).
subject_change(deletion_technically_difficult, [deletion_technically_difficult - true], [], []).
subject_change(deletion_no_case_holds, [consent_withdrawn - false], [], []).
subject_change(deletion_two_cases_hold, [service_stopped_or_retention_period_expired - true], [], []).
subject_change(deletion_retention_unstated, [], [legal_retention_period_unexpired], []).
subject_change(deletion_purpose_unsure, [consent_withdrawn - false, purpose_achieved_impossible_or_unnecessary - unsure], [], []).
subject_change(deletion_violation_unsure, [consent_withdrawn - false, processing_violates_law_or_agreement - unsure], [], []).
subject_change(deletion_difficulty_unsure, [deletion_technically_difficult - unsure], [], []).
subject_change(deletion_purpose_unstated, [consent_withdrawn - false], [purpose_achieved_impossible_or_unnecessary], []).
subject_change(deceased_arranged_otherwise, [deceased_arranged_otherwise - true], [], []).
subject_change(deceased_requester_not_near_relative, [requester_is_near_relative - false], [], []).
subject_change(deceased_person_alive, [person_deceased - false], [], []).
subject_change(deceased_interests_unsure, [for_requester_own_lawful_and_legitimate_interests - unsure], [], []).
subject_change(mechanism_not_convenient, [convenient_mechanism_established - false], [], []).
subject_change(mechanism_convenience_unsure, [convenient_mechanism_established - unsure], [], []).
subject_change(refusal_without_reasons, [refusal_reasons_given - false], [], []).
subject_change(refusal_not_refused, [request_refused - false], [], []).
subject_change(refusal_reasons_unstated, [], [refusal_reasons_given], []).
subject_change(text_not_in_force, [pinned_text_in_force_on_reference_day - false], [], []).
subject_change(text_in_force_unstated, [], [pinned_text_in_force_on_reference_day], []).
subject_change(input_duplicate_key, [], [], [attribute(consent_withdrawn, false)]).
subject_change(input_wrong_type_and_unknown_key, [article_35_case - unsure], [], [attribute(colour, red)]).

subject_literal(input_empty_profile, []).
subject_literal(input_not_an_attribute_list, not_a_profile).

pipl_individual_rights_subject(Subject) :-
    subject_change(Subject, _, _, _).
pipl_individual_rights_subject(Subject) :-
    subject_literal(Subject, _).

pipl_individual_rights_profile_for(Subject, Profile) :-
    subject_change(Subject, Overrides, DroppedKeys, AddedItems),
    baseline_profile(Baseline),
    maplist(override_attribute(Overrides), Baseline, Overridden),
    without_keys(Overridden, DroppedKeys, Kept),
    append(Kept, AddedItems, Profile).
pipl_individual_rights_profile_for(Subject, Profile) :-
    subject_literal(Subject, Profile).

override_attribute(Overrides, attribute(Key, BaselineValue), attribute(Key, Value)) :-
    override_value(Overrides, Key, BaselineValue, Value).

override_value([], _, BaselineValue, BaselineValue).
override_value([Key - Value|_], Key, _, Value).
override_value([OtherKey - _|Overrides], Key, BaselineValue, Value) :-
    dif(OtherKey, Key),
    override_value(Overrides, Key, BaselineValue, Value).

without_keys([], _, []).
without_keys([attribute(Key, Value)|Items], DroppedKeys, Kept) :-
    memberd_t(Key, DroppedKeys, Dropped),
    keep_item(Dropped, attribute(Key, Value), LaterKept, Kept),
    without_keys(Items, DroppedKeys, LaterKept).

keep_item(true, _, Kept, Kept).
keep_item(false, Item, Kept, [Item|Kept]).

pipl_individual_rights_assess(Subject, Result) :-
    pipl_individual_rights_profile_for(Subject, Profile),
    decide_pipl_individual_rights(Profile, Result).

test(every_subject_has_exactly_one_profile) :-
    findall(Subject, pipl_individual_rights_subject(Subject), Subjects),
    maplist(one_profile, Subjects).
test(an_override_changes_one_value) :-
    pipl_individual_rights_profile_for(refusal_without_reasons, Profile),
    member(attribute(refusal_reasons_given, false), Profile),
    length(Profile, 20).
test(a_dropped_key_is_absent) :-
    pipl_individual_rights_profile_for(refusal_reasons_unstated, Profile),
    length(Profile, 19).

one_profile(Subject) :-
    findall(Profile, pipl_individual_rights_profile_for(Subject, Profile), Profiles),
    length(Profiles, 1).

test(a_dropped_key_is_not_present, fail) :-
    pipl_individual_rights_profile_for(refusal_reasons_unstated, Profile),
    member(attribute(refusal_reasons_given, _), Profile).
