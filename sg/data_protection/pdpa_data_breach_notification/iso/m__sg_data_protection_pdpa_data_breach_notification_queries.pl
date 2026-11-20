% SPDX-License-Identifier: EUPL-1.2
:- module(m__sg_data_protection_pdpa_data_breach_notification_queries, [pdpa_data_breach_notification_profile_keys/1, pdpa_data_breach_notification_what_if/4, significant_harm/3, significant_scale/3, significant_harm/0, significant_scale/0, no_significant_harm/0, no_significant_scale/0, notifiable/0, not_notifiable/0, not_applicable/0, required/0, not_required/0, prohibited/0, waived/0, assessment_required/0, notify_organisation_without_undue_delay/0, notify_public_agency_without_undue_delay/0, no_duty_triggered/0, n_a/0, pdpa_breach/5, indeterminate/1, needs_legal_review/2, provenance/2, content_item/2, additional_item/3, unknown_key/1, duplicate_key/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_is_list/1]).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(m__sg_data_protection_pdpa_data_breach_notification_kernel, [pdpa_data_breach_notification_input_problems/2]).
:- use_module(m__sg_data_protection_pdpa_data_breach_notification_pdpa_data_breach_notification, [pdpa_data_breach_notification_status/2, pdpa_data_breach_notification_checklist/2, notification_contents/2]).

pdpa_data_breach_notification_profile_keys([breach_occurred_date, within_organisation_only, breach_kinds, is_data_breach, breached_data, publicly_available_or_lawfully_disclosed, assessed_likely_significant_harm, affected_individuals_count, assessed_likely_significant_scale, prohibited_by_law_enforcement_agency, prohibited_by_commission_direction, commission_waiver_granted, remedial_action_renders_harm_unlikely, prior_technological_measure_renders_harm_unlikely, assessment_date, caller_role, reason_to_believe_breach_occurred, personal_data_in_possession_or_control, notified_by_data_intermediary]).

judgement_keys([is_data_breach, assessed_likely_significant_harm, assessed_likely_significant_scale, remedial_action_renders_harm_unlikely, prior_technological_measure_renders_harm_unlikely, reason_to_believe_breach_occurred]).

significant_harm(Profile, Result, Citations) :-
    pdpa_data_breach_notification_checklist(Profile, Checklist),
    harm_row(Checklist, Result, Citations).

significant_scale(Profile, Result, Citations) :-
    pdpa_data_breach_notification_checklist(Profile, Checklist),
    scale_row(Checklist, Result, Citations).

harm_row([item(significant_harm, Result, Citations)|_], Result, Citations).

scale_row([_, item(significant_scale, Result, Citations)|_], Result, Citations).

pdpa_data_breach_notification_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    attributes_without_key(Profile, OverriddenKey, Kept),
    append(Kept, [attribute(OverriddenKey, NewValue)], Hypothesis),
    pdpa_data_breach_notification_status(Hypothesis, NewStatus).

attributes_without_key([], _, []).
attributes_without_key([attribute(ElementKey, _)|Elements], OverriddenKey, Kept) :-
    ElementKey == OverriddenKey,
    attributes_without_key(Elements, OverriddenKey, Kept).
attributes_without_key([attribute(ElementKey, ElementValue)|Elements], OverriddenKey, [attribute(ElementKey, ElementValue)|Kept]) :-
    ElementKey \== OverriddenKey,
    attributes_without_key(Elements, OverriddenKey, Kept).

indeterminate([MissingKey]) :-
    pdpa_data_breach_notification_profile_keys(ProfileKeys),
    memberd_t(MissingKey, ProfileKeys, true).

needs_legal_review(open_textured(Input, cite(CitationKey)), [inputs_relied_on(Pairs)]) :-
    judgement_keys(JudgementKeys),
    memberd_t(Input, JudgementKeys, true),
    atom(CitationKey),
    clausal_is_list(Pairs).

provenance(Input, cite(CitationKey)) :-
    pdpa_data_breach_notification_profile_keys(ProfileKeys),
    memberd_t(Input, ProfileKeys, true),
    atom(CitationKey).

content_item(Name, Citation) :-
    content_topic(Topic),
    notification_contents(Topic, Items),
    memberd_t(content_item(Name, Citation), Items, true).

content_topic(commission).
content_topic(affected_individual).

additional_item(Name, Condition, Citation) :-
    notification_contents(commission_additional, Items),
    memberd_t(additional_item(Name, Condition, Citation), Items, true).

unknown_key(ProblemKey) :-
    pdpa_data_breach_notification_profile_keys(ProfileKeys),
    memberd_t(ProblemKey, ProfileKeys, false).

duplicate_key(ProblemKey) :-
    pdpa_data_breach_notification_profile_keys(ProfileKeys),
    memberd_t(ProblemKey, ProfileKeys, true).

pdpa_breach(Decision, Grounds, Deadline, Individuals, Citations) :-
    combined_decision(Decision),
    combined_grounds(Grounds),
    combined_deadline(Deadline),
    combined_individuals(Individuals),
    clausal_is_list(Citations).

combined_decision(notifiable).
combined_decision(not_notifiable).
combined_decision(not_applicable).
combined_decision(indeterminate(_)).
combined_decision(needs_legal_review(_, _)).
combined_decision(input_problems(_)).

combined_grounds([]).
combined_grounds([significant_harm]).
combined_grounds([significant_scale]).
combined_grounds([significant_harm, significant_scale]).

combined_deadline(n_a).
combined_deadline(date(_, _, _)).
combined_deadline(indeterminate([assessment_date])).

combined_individuals(n_a).
combined_individuals(required).
combined_individuals(not_required).
combined_individuals(prohibited).
combined_individuals(waived).
combined_individuals(not_applicable).
combined_individuals(indeterminate(_)).
combined_individuals(needs_legal_review(_, _)).

significant_harm.

significant_scale.

no_significant_harm.

no_significant_scale.

notifiable.

not_notifiable.

not_applicable.

required.

not_required.

prohibited.

waived.

assessment_required.

notify_organisation_without_undue_delay.

notify_public_agency_without_undue_delay.

no_duty_triggered.

n_a.

what_if_profile([attribute(breach_occurred_date, date(2025, 3, 10)), attribute(within_organisation_only, false), attribute(breach_kinds, [unauthorised_disclosure]), attribute(is_data_breach, true), attribute(breached_data, [other_personal_data]), attribute(assessed_likely_significant_harm, false), attribute(affected_individuals_count, 499), attribute(assessed_likely_significant_scale, false)]).

test(the_schema_has_nineteen_keys) :-
    pdpa_data_breach_notification_profile_keys(ProfileKeys),
    length(ProfileKeys, 19).
test(below_the_prescribed_number_is_not_notifiable) :-
    what_if_profile(Profile),
    pdpa_data_breach_notification_status(Profile, not_notifiable).
test(raising_the_count_to_the_prescribed_number_flips_to_notifiable) :-
    what_if_profile(Profile),
    pdpa_data_breach_notification_what_if(Profile, affected_individuals_count, 500, notifiable).
test(what_if_gives_exactly_one_answer) :-
    what_if_profile(Profile),
    findall(Status, pdpa_data_breach_notification_what_if(Profile, affected_individuals_count, 500, Status), Statuses),
    Statuses == [notifiable].
test(what_if_on_an_absent_key_adds_it) :-
    what_if_profile(Profile),
    pdpa_data_breach_notification_what_if(Profile, assessed_likely_significant_harm, true, notifiable).
test(the_input_check_is_reexported) :-
    what_if_profile(Profile),
    pdpa_data_breach_notification_input_problems(Profile, Problems),
    Problems == [].
test(the_harm_query_is_served_once) :-
    findall(Result - Citations, significant_harm([attribute(breached_data, [account_identifier, account_access_credential])], Result, Citations), Answers),
    Answers == [significant_harm - [cite(sg_pdpa_2012_s26b_2_a), cite(sg_pdpa_2012_s64_2021_reg_3_1_b)]].
test(the_scale_query_is_served_once) :-
    findall(Result - Citations, significant_scale([attribute(affected_individuals_count, 500)], Result, Citations), Answers),
    Answers == [significant_scale - [cite(sg_pdpa_2012_s26b_3_a), cite(sg_pdpa_2012_s64_2021_reg_4)]].
test(the_result_atoms_are_served) :-
    significant_harm,
    significant_scale,
    notifiable,
    not_notifiable,
    not_applicable,
    n_a.
test(an_indeterminate_result_names_a_contract_key) :-
    findall(found, indeterminate([breach_occurred_date]), Answers),
    Answers == [found].
test(a_referral_term_is_recognised) :-
    findall(found, needs_legal_review(open_textured(is_data_breach, cite(sg_pdpa_2012_s26a_def_databreach)), [inputs_relied_on([is_data_breach - unsure])]), Answers),
    Answers == [found].
test(a_provenance_item_is_recognised) :-
    findall(found, provenance(is_data_breach, cite(sg_pdpa_2012_s26a_def_databreach)), Answers),
    Answers == [found].
test(a_content_item_is_recognised_once) :-
    findall(found, content_item(potential_harm, cite(sg_pdpa_2012_s64_2021_reg_6_c)), Answers),
    Answers == [found].
test(an_additional_item_is_recognised) :-
    findall(found, additional_item(late_notification_reasons_and_evidence, notified_after_period, cite(sg_pdpa_2012_s64_2021_reg_5_2)), Answers),
    Answers == [found].
test(an_unknown_key_is_recognised) :-
    findall(found, unknown_key(colour), Answers),
    Answers == [found].
test(a_duplicate_key_is_recognised) :-
    findall(found, duplicate_key(is_data_breach), Answers),
    Answers == [found].
test(a_combined_answer_is_recognised) :-
    findall(found, pdpa_breach(notifiable, [significant_harm], date(2026, 1, 4), required, [cite(sg_pdpa_2012_s26d_1)]), Answers),
    Answers == [found].
test(a_refused_combined_answer_is_recognised) :-
    findall(found, pdpa_breach(input_problems([wrong_type(profile)]), [], n_a, n_a, []), Answers),
    Answers == [found].

test(raising_the_count_to_the_prescribed_number_is_not_not_notifiable, fail) :-
    what_if_profile(Profile),
    pdpa_data_breach_notification_what_if(Profile, affected_individuals_count, 500, not_notifiable).
test(the_scale_query_below_the_number_is_not_significant, fail) :-
    significant_scale([attribute(affected_individuals_count, 499), attribute(assessed_likely_significant_scale, false)], significant_scale, _).
test(an_indeterminate_result_of_a_foreign_key_is_refused, fail) :-
    indeterminate([colour]).
test(a_referral_on_a_crisp_key_is_refused, fail) :-
    needs_legal_review(open_textured(within_organisation_only, cite(sg_pdpa_2012_s26b_4)), [inputs_relied_on([])]).
test(a_content_item_with_a_wrong_citation_is_refused, fail) :-
    content_item(how_breach_occurred, cite(sg_pdpa_2012_s64_2021_reg_5_1_d)).
test(a_contract_key_is_not_an_unknown_key, fail) :-
    unknown_key(is_data_breach).
test(a_foreign_key_is_not_a_duplicate_contract_key, fail) :-
    duplicate_key(colour).
test(a_combined_answer_with_a_foreign_ground_is_refused, fail) :-
    pdpa_breach(notifiable, [significant_risk], n_a, n_a, []).
