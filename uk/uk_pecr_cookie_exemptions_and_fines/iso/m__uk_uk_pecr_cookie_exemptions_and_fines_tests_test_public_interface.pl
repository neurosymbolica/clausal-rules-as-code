% SPDX-License-Identifier: EUPL-1.2
:- module(m__uk_uk_pecr_cookie_exemptions_and_fines_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_msort/2]).
:- use_module(m__uk_uk_pecr_cookie_exemptions_and_fines_uk_pecr_cookie_exemptions_and_fines, [decide_uk_pecr_cookie_exemptions_and_fines/2, uk_pecr_cookie_exemptions_and_fines_status/2, uk_pecr_cookie_exemptions_and_fines_checklist/2, uk_pecr_cookie_exemptions_and_fines_decision_resolvable/1, uk_pecr_cookie_exemptions_and_fines_status_values/1, uk_terminal_equipment_storage_or_access/3, eu_terminal_equipment_storage_or_access/3, compare_uk_eu_terminal_equipment_storage_or_access/5, uk_breach_notification_timing/3, uk_penalty_maximum_tier/3, uk_penalty_maximum_amount_in_pence/3]).
:- use_module(m__uk_uk_pecr_cookie_exemptions_and_fines_fixtures, [uk_pecr_cookie_exemptions_and_fines_subject/1, uk_pecr_cookie_exemptions_and_fines_profile_for/2, uk_pecr_cookie_exemptions_and_fines_assess/2]).
:- use_module(m__uk_uk_pecr_cookie_exemptions_and_fines_queries, [uk_pecr_cookie_exemptions_and_fines_what_if/4]).
:- use_module(m__uk_uk_pecr_cookie_exemptions_and_fines_kernel, [uk_pecr_cookie_exemptions_and_fines_input_problems/2]).

test(cookie_consent_given_is_permitted) :-
    uk_pecr_cookie_exemptions_and_fines_assess(cookie_consent_given, uk_pecr_cookie_exemptions_and_fines_verdict(Status, Citations)),
    Status == permitted,
    Citations = [_|_].
test(cookie_consent_withheld_is_not_permitted) :-
    uk_pecr_cookie_exemptions_and_fines_assess(cookie_consent_withheld, uk_pecr_cookie_exemptions_and_fines_verdict(Status, Citations)),
    Status == not_permitted,
    Citations = [_|_].
test(cookie_transmission_only_is_permitted) :-
    uk_pecr_cookie_exemptions_and_fines_assess(cookie_transmission_only, uk_pecr_cookie_exemptions_and_fines_verdict(Status, _)),
    Status == permitted.
test(cookie_transmission_absent_is_not_permitted) :-
    uk_pecr_cookie_exemptions_and_fines_assess(cookie_transmission_absent, uk_pecr_cookie_exemptions_and_fines_verdict(Status, _)),
    Status == not_permitted.
test(cookie_strictly_necessary_is_permitted) :-
    uk_pecr_cookie_exemptions_and_fines_assess(cookie_strictly_necessary, uk_pecr_cookie_exemptions_and_fines_verdict(Status, _)),
    Status == permitted.
test(cookie_not_strictly_necessary_is_not_permitted) :-
    uk_pecr_cookie_exemptions_and_fines_assess(cookie_not_strictly_necessary, uk_pecr_cookie_exemptions_and_fines_verdict(Status, _)),
    Status == not_permitted.
test(cookie_statistics_is_permitted) :-
    uk_pecr_cookie_exemptions_and_fines_assess(cookie_statistics, uk_pecr_cookie_exemptions_and_fines_verdict(Status, _)),
    Status == permitted.
test(cookie_statistics_emitted_signals_is_not_permitted) :-
    uk_pecr_cookie_exemptions_and_fines_assess(cookie_statistics_emitted_signals, uk_pecr_cookie_exemptions_and_fines_verdict(Status, _)),
    Status == not_permitted.
test(cookie_website_enhancement_is_permitted) :-
    uk_pecr_cookie_exemptions_and_fines_assess(cookie_website_enhancement, uk_pecr_cookie_exemptions_and_fines_verdict(Status, _)),
    Status == permitted.
test(cookie_website_enhancement_objected_is_not_permitted) :-
    uk_pecr_cookie_exemptions_and_fines_assess(cookie_website_enhancement_objected, uk_pecr_cookie_exemptions_and_fines_verdict(Status, _)),
    Status == not_permitted.
test(cookie_emergency_location_is_permitted) :-
    uk_pecr_cookie_exemptions_and_fines_assess(cookie_emergency_location, uk_pecr_cookie_exemptions_and_fines_verdict(Status, _)),
    Status == permitted.
test(cookie_emergency_without_location_purpose_is_not_permitted) :-
    uk_pecr_cookie_exemptions_and_fines_assess(cookie_emergency_without_location_purpose, uk_pecr_cookie_exemptions_and_fines_verdict(Status, _)),
    Status == not_permitted.
test(cookie_outside_regulation_6_is_not_applicable) :-
    uk_pecr_cookie_exemptions_and_fines_assess(cookie_outside_regulation_6, uk_pecr_cookie_exemptions_and_fines_verdict(Status, Citations)),
    Status == not_applicable,
    Citations == [cite(uk_si_2003_2426_reg_6_1), cite(uk_si_2003_2426_reg_6_2)].
test(cookie_within_regulation_6_no_way_is_not_permitted) :-
    uk_pecr_cookie_exemptions_and_fines_assess(cookie_within_regulation_6_no_way, uk_pecr_cookie_exemptions_and_fines_verdict(Status, _)),
    Status == not_permitted.
test(permitted_cookie_cites_the_fixed_list) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(cookie_transmission_only, Profile),
    uk_terminal_equipment_storage_or_access(Profile, Result, Citations),
    Result == permitted,
    clausal_msort(Citations, Sorted),
    clausal_msort([cite(uk_si_2003_2426_reg_6_1), cite(uk_si_2003_2426_sch_a1_para_2_1), cite(uk_si_2003_2426_sch_a1_para_3), cite(uk_si_2003_2426_sch_a1_para_4_1), cite(uk_si_2003_2426_sch_a1_para_5_1), cite(uk_si_2003_2426_sch_a1_para_6_1), cite(uk_si_2003_2426_sch_a1_para_7)], Expected),
    Sorted == Expected.
test(status_projection_matches_verdict) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(cookie_emergency_location, Profile),
    uk_pecr_cookie_exemptions_and_fines_status(Profile, Status),
    Status == permitted.
test(checklist_is_cited_and_non_empty) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(cookie_consent_given, Profile),
    uk_pecr_cookie_exemptions_and_fines_decision_resolvable(Profile),
    uk_pecr_cookie_exemptions_and_fines_checklist(Profile, Items),
    Items = [_|_],
    member(item(scope, met, cite(uk_si_2003_2426_reg_6_1)), Items),
    member(item(consent, met, cite(uk_si_2003_2426_sch_a1_para_2_1)), Items).
test(checklist_near_miss_marks_consent_unmet) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(cookie_consent_withheld, Profile),
    uk_pecr_cookie_exemptions_and_fines_checklist(Profile, Items),
    member(item(consent, unmet(some_conjunct_unmet), cite(uk_si_2003_2426_sch_a1_para_2_1)), Items).
test(what_if_consent_given_flips_to_permitted) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(cookie_consent_withheld, Profile),
    uk_pecr_cookie_exemptions_and_fines_what_if(Profile, consent_to_the_storage_or_access_given, true, Status),
    Status == permitted.
test(every_subject_has_exactly_one_verdict) :-
    findall(Subject - Count, (uk_pecr_cookie_exemptions_and_fines_subject(Subject), uk_pecr_cookie_exemptions_and_fines_profile_for(Subject, Profile), findall(Verdict, decide_uk_pecr_cookie_exemptions_and_fines(Profile, Verdict), Verdicts), length(Verdicts, Count)), Counts),
    Counts = [_|_],
    findall(Count, member(_ - Count, Counts), CountList),
    sort(CountList, [1]).
test(final_cookie_statuses_are_in_the_vocabulary) :-
    uk_pecr_cookie_exemptions_and_fines_assess(cookie_consent_given, uk_pecr_cookie_exemptions_and_fines_verdict(Status, _)),
    uk_pecr_cookie_exemptions_and_fines_status_values(StatusValues),
    member(Status, StatusValues).
test(eu_transmission_is_permitted) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(comparison_same, Profile),
    eu_terminal_equipment_storage_or_access(Profile, Result, Citations),
    Result == permitted,
    Citations == [cite(eu_dir_2002_58_art_5_3)].
test(comparison_same_is_same) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(comparison_same, Profile),
    compare_uk_eu_terminal_equipment_storage_or_access(Profile, UnitedKingdomResult, UnionResult, Difference, ChangedBy),
    UnitedKingdomResult == permitted,
    UnionResult == permitted,
    Difference == same,
    ChangedBy == [].
test(comparison_differs_is_differs) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(comparison_differs, Profile),
    compare_uk_eu_terminal_equipment_storage_or_access(Profile, UnitedKingdomResult, UnionResult, Difference, ChangedBy),
    UnitedKingdomResult == permitted,
    UnionResult == not_applicable,
    Difference == differs,
    length(ChangedBy, 7),
    member(cite(uk_si_2003_2426_reg_6_1), ChangedBy).
test(breach_in_72nd_hour_is_in_time) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(breach_notified_in_72nd_hour, Profile),
    findall(Result - Citations, uk_breach_notification_timing(Profile, Result, Citations), Answers),
    Answers == [notification_in_time - [cite(uk_si_2003_2426_reg_5a_2), cite(uk_reg_611_2013_art_2_2), cite(uk_reg_1182_1971_art_3_1)]].
test(breach_in_73rd_hour_is_out_of_time) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(breach_notified_in_73rd_hour, Profile),
    uk_breach_notification_timing(Profile, Result, _),
    Result == notification_out_of_time.
test(breach_late_with_reasons) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(breach_late_with_reasons, Profile),
    uk_breach_notification_timing(Profile, Result, Citations),
    Result == notification_late_with_reasons,
    member(cite(uk_si_2003_2426_reg_5a_3a), Citations).
test(breach_late_without_reasons) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(breach_late_without_reasons, Profile),
    uk_breach_notification_timing(Profile, Result, _),
    Result == notification_reasons_for_delay_missing.
test(breach_undue_delay_is_out_of_time) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(breach_undue_delay, Profile),
    uk_breach_notification_timing(Profile, Result, _),
    Result == notification_out_of_time.
test(breach_awareness_before_amendment_is_referred) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(breach_awareness_before_amendment, Profile),
    uk_breach_notification_timing(Profile, Result, Citations),
    Citations == [],
    Result == needs_legal_review(cross_reference_unresolved(cite(uk_si_2025_904_reg_2_p), cite(uk_si_2003_2426_reg_5a_as_in_effect_before_20_august_2025)), [resolution(cite(uk_si_2003_2426_reg_5a_as_in_effect_before_20_august_2025), not_attempted), inputs_relied_on([provider_of_a_public_electronic_communications_service - true, personal_data_breach_occurred - true, became_aware_on_or_after_20_august_2025 - false])]).
test(optional_provenance_element_keeps_the_scored_context) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(breach_awareness_before_amendment, Profile),
    uk_breach_notification_timing(Profile, needs_legal_review(Reason, Context), []),
    Reason = cross_reference_unresolved(cite(uk_si_2025_904_reg_2_p), _),
    append(Context, [provenance(uk_si_2025_904_reg_2_p, not_pinned)], WithProvenance),
    WithProvenance = [resolution(_, not_attempted), inputs_relied_on(_), provenance(Source, Note)],
    Source == uk_si_2025_904_reg_2_p,
    Note == not_pinned,
    functor(provenance(Source, Note), provenance, 2).
test(breach_not_a_service_provider_is_not_applicable) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(breach_not_a_service_provider, Profile),
    uk_breach_notification_timing(Profile, Result, Citations),
    Result == not_applicable,
    Citations == [cite(uk_si_2003_2426_reg_5_1), cite(uk_si_2003_2426_reg_5a_1), cite(uk_si_2003_2426_reg_5a_2)].
test(listed_regulation_is_higher_tier) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(penalty_listed_regulation, Profile),
    uk_penalty_maximum_tier(Profile, Result, Citations),
    Result == higher_maximum_amount,
    Citations == [cite(uk_si_2003_2426_sch_1_para_18_b_ii), cite(uk_dpa_2018_s_157_2), cite(uk_si_2026_82_reg_11_2)].
test(other_provision_is_standard_tier) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(penalty_other_provision, Profile),
    uk_penalty_maximum_tier(Profile, Result, _),
    Result == standard_maximum_amount.
test(act_before_5_february_2026_is_referred) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(penalty_act_before_5_february_2026, Profile),
    uk_penalty_maximum_tier(Profile, Result, Citations),
    Citations == [],
    Result == needs_legal_review(cross_reference_unresolved(cite(uk_si_2026_82_reg_11_1), cite(uk_si_2003_2426_as_in_effect_before_5_february_2026)), [resolution(cite(uk_si_2003_2426_as_in_effect_before_5_february_2026), not_attempted), inputs_relied_on([act_or_omission_on_or_after_5_february_2026 - false, provision_infringed - regulation_6])]).
test(amount_higher_tie_is_fixed_amount) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(amount_higher_tie, Profile),
    findall(Result - Citations, uk_penalty_maximum_amount_in_pence(Profile, Result, Citations), [Amount - AmountCitations]),
    Amount =:= 1750000000,
    AmountCitations == [cite(uk_si_2003_2426_sch_1_para_18_b_ii), cite(uk_dpa_2018_s_157_2), cite(uk_si_2026_82_reg_11_2), cite(uk_dpa_2018_s_157_5)].
test(amount_higher_above_tie_is_percentage) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(amount_higher_above_tie, Profile),
    uk_penalty_maximum_amount_in_pence(Profile, Amount, _),
    Amount =:= 1750000004.
test(amount_standard_tie_is_fixed_amount) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(amount_standard_tie, Profile),
    uk_penalty_maximum_amount_in_pence(Profile, Amount, Citations),
    Amount =:= 870000000,
    member(cite(uk_dpa_2018_s_157_6), Citations).
test(amount_standard_above_tie_is_percentage) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(amount_standard_above_tie, Profile),
    uk_penalty_maximum_amount_in_pence(Profile, Amount, _),
    Amount =:= 870000002.
test(amount_not_an_undertaking_is_fixed_amount) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(amount_not_an_undertaking, Profile),
    uk_penalty_maximum_amount_in_pence(Profile, Amount, _),
    Amount =:= 1750000000.
test(fixture_profiles_are_well_formed) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(cookie_statistics, Profile),
    uk_pecr_cookie_exemptions_and_fines_input_problems(Profile, Problems),
    Problems == [].
test(unknown_key_is_reported_bare) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(input_problem_unknown_key, Profile),
    uk_pecr_cookie_exemptions_and_fines_input_problems(Profile, Problems),
    Problems == [unknown_key(colour)].
test(unknown_key_answers_input_problems) :-
    uk_pecr_cookie_exemptions_and_fines_assess(input_problem_unknown_key, uk_pecr_cookie_exemptions_and_fines_verdict(Status, Citations)),
    Status == input_problems([unknown_key(colour)]),
    Citations == [].
test(not_a_list_is_wrong_type_profile) :-
    uk_pecr_cookie_exemptions_and_fines_input_problems(profile, Problems),
    Problems == [wrong_type(profile)].

test(cookie_consent_withheld_is_never_permitted, fail) :-
    uk_pecr_cookie_exemptions_and_fines_assess(cookie_consent_withheld, uk_pecr_cookie_exemptions_and_fines_verdict(permitted, _)).
test(cookie_within_regulation_6_no_way_is_not_not_applicable, fail) :-
    uk_pecr_cookie_exemptions_and_fines_assess(cookie_within_regulation_6_no_way, uk_pecr_cookie_exemptions_and_fines_verdict(not_applicable, _)).
test(comparison_differs_is_not_same, fail) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(comparison_differs, Profile),
    compare_uk_eu_terminal_equipment_storage_or_access(Profile, _, _, same, _).
test(breach_in_73rd_hour_is_not_in_time, fail) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(breach_notified_in_73rd_hour, Profile),
    uk_breach_notification_timing(Profile, notification_in_time, _).
test(the_answer_itself_carries_no_provenance_element, fail) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(breach_awareness_before_amendment, Profile),
    uk_breach_notification_timing(Profile, needs_legal_review(_, Context), []),
    member(provenance(_, _), Context).
test(other_provision_is_not_higher_tier, fail) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(penalty_other_provision, Profile),
    uk_penalty_maximum_tier(Profile, higher_maximum_amount, _).

est_placeholder_never_defined_guard :-
    true.

cp_test_names([cookie_consent_given_is_permitted, cookie_consent_withheld_is_not_permitted, cookie_transmission_only_is_permitted, cookie_transmission_absent_is_not_permitted, cookie_strictly_necessary_is_permitted, cookie_not_strictly_necessary_is_not_permitted, cookie_statistics_is_permitted, cookie_statistics_emitted_signals_is_not_permitted, cookie_website_enhancement_is_permitted, cookie_website_enhancement_objected_is_not_permitted, cookie_emergency_location_is_permitted, cookie_emergency_without_location_purpose_is_not_permitted, cookie_outside_regulation_6_is_not_applicable, cookie_within_regulation_6_no_way_is_not_permitted, permitted_cookie_cites_the_fixed_list, status_projection_matches_verdict, checklist_is_cited_and_non_empty, checklist_near_miss_marks_consent_unmet, what_if_consent_given_flips_to_permitted, every_subject_has_exactly_one_verdict, final_cookie_statuses_are_in_the_vocabulary, eu_transmission_is_permitted, comparison_same_is_same, comparison_differs_is_differs, breach_in_72nd_hour_is_in_time, breach_in_73rd_hour_is_out_of_time, breach_late_with_reasons, breach_late_without_reasons, breach_undue_delay_is_out_of_time, breach_awareness_before_amendment_is_referred, optional_provenance_element_keeps_the_scored_context, breach_not_a_service_provider_is_not_applicable, listed_regulation_is_higher_tier, other_provision_is_standard_tier, act_before_5_february_2026_is_referred, amount_higher_tie_is_fixed_amount, amount_higher_above_tie_is_percentage, amount_standard_tie_is_fixed_amount, amount_standard_above_tie_is_percentage, amount_not_an_undertaking_is_fixed_amount, fixture_profiles_are_well_formed, unknown_key_is_reported_bare, unknown_key_answers_input_problems, not_a_list_is_wrong_type_profile]).
cp_test_fail_names([cookie_consent_withheld_is_never_permitted, cookie_within_regulation_6_no_way_is_not_not_applicable, comparison_differs_is_not_same, breach_in_73rd_hour_is_not_in_time, the_answer_itself_carries_no_provenance_element, other_provision_is_not_higher_tier]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
