% SPDX-License-Identifier: EUPL-1.2
:- module(m__uk_uk_pecr_cookie_exemptions_and_fines_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__uk_uk_pecr_cookie_exemptions_and_fines_uk_pecr_cookie_exemptions_and_fines, [decide_uk_pecr_cookie_exemptions_and_fines/2, uk_terminal_equipment_storage_or_access/3, eu_terminal_equipment_storage_or_access/3, compare_uk_eu_terminal_equipment_storage_or_access/5, uk_breach_notification_timing/3, uk_penalty_maximum_tier/3, uk_penalty_maximum_amount_in_pence/3, uk_pecr_cookie_exemptions_and_fines_checklist/2]).
:- use_module(m__uk_uk_pecr_cookie_exemptions_and_fines_fixtures, [uk_pecr_cookie_exemptions_and_fines_profile_for/2]).

uk_way_citations([cite(uk_si_2003_2426_reg_6_1), cite(uk_si_2003_2426_sch_a1_para_2_1), cite(uk_si_2003_2426_sch_a1_para_3), cite(uk_si_2003_2426_sch_a1_para_4_1), cite(uk_si_2003_2426_sch_a1_para_5_1), cite(uk_si_2003_2426_sch_a1_para_6_1), cite(uk_si_2003_2426_sch_a1_para_7)]).

test(uk_consent_yields_one_permitted_answer) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(cookie_consent_given, Profile),
    findall(Result - Citations, uk_terminal_equipment_storage_or_access(Profile, Result, Citations), Answers),
    uk_way_citations(WayCitations),
    Answers == [permitted - WayCitations].
test(uk_no_way_yields_one_not_permitted_answer) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(cookie_within_regulation_6_no_way, Profile),
    findall(Result - Citations, uk_terminal_equipment_storage_or_access(Profile, Result, Citations), Answers),
    uk_way_citations(WayCitations),
    Answers == [not_permitted - WayCitations].
test(uk_empty_profile_asks_for_the_gate) :-
    findall(Result - Citations, uk_terminal_equipment_storage_or_access([], Result, Citations), Answers),
    Answers == [indeterminate([storage_or_access_within_regulation_6]) - []].
test(uk_gate_false_settles_whatever_else_is_absent) :-
    findall(Result, uk_terminal_equipment_storage_or_access([attribute(storage_or_access_within_regulation_6, false), attribute(consent_to_the_storage_or_access_given, unsure)], Result, _), Answers),
    Answers == [not_applicable].
test(uk_unsure_gate_with_all_ways_false_is_referred) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(cookie_outside_regulation_6, AllFalse),
    AllFalse = [_|Others],
    Profile = [attribute(storage_or_access_within_regulation_6, unsure)|Others],
    findall(Result, uk_terminal_equipment_storage_or_access(Profile, Result, []), Answers),
    Answers = [needs_legal_review(open_textured(storage_or_access_within_regulation_6, cite(uk_si_2003_2426_reg_6_1)), [inputs_relied_on(Pairs)])],
    length(Pairs, 16).
test(decide_wraps_the_uk_answer) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(cookie_transmission_only, Profile),
    findall(Verdict, decide_uk_pecr_cookie_exemptions_and_fines(Profile, Verdict), Verdicts),
    uk_way_citations(WayCitations),
    Verdicts == [uk_pecr_cookie_exemptions_and_fines_verdict(permitted, WayCitations)].
test(checklist_marks_the_met_way) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(cookie_emergency_location, Profile),
    uk_pecr_cookie_exemptions_and_fines_checklist(Profile, Items),
    member(item(emergency_assistance, met, cite(uk_si_2003_2426_sch_a1_para_7)), Items),
    member(item(scope, met, cite(uk_si_2003_2426_reg_6_1)), Items).
test(eu_consent_without_information_is_not_permitted) :-
    findall(Result - Citations, eu_terminal_equipment_storage_or_access([attribute(storage_or_access_in_terminal_equipment, true), attribute(storage_or_access_solely_for_transmission, false), attribute(service_explicitly_requested_by_user, false), attribute(strictly_necessary_to_provide_requested_service, false), attribute(user_consent_given, true), attribute(clear_and_comprehensive_information_provided, false)], Result, Citations), Answers),
    Answers == [not_permitted - [cite(eu_dir_2002_58_art_5_3)]].
test(eu_empty_profile_asks_for_the_scope) :-
    findall(Result, eu_terminal_equipment_storage_or_access([], Result, []), Answers),
    Answers == [indeterminate([storage_or_access_in_terminal_equipment])].
test(comparison_differs_lists_the_uk_citations) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(comparison_differs, Profile),
    findall(answer(UnitedKingdomResult, UnionResult, Difference, ChangedBy), compare_uk_eu_terminal_equipment_storage_or_access(Profile, UnitedKingdomResult, UnionResult, Difference, ChangedBy), Answers),
    uk_way_citations(WayCitations),
    Answers == [answer(permitted, not_applicable, differs, WayCitations)].
test(comparison_same_has_no_changed_by) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(comparison_same, Profile),
    findall(answer(UnitedKingdomResult, UnionResult, Difference, ChangedBy), compare_uk_eu_terminal_equipment_storage_or_access(Profile, UnitedKingdomResult, UnionResult, Difference, ChangedBy), Answers),
    Answers == [answer(permitted, permitted, same, [])].
test(comparison_settles_differs_while_uk_is_open) :-
    findall(Difference - ChangedBy, compare_uk_eu_terminal_equipment_storage_or_access([attribute(storage_or_access_within_regulation_6, true), attribute(storage_or_access_in_terminal_equipment, false)], _, _, Difference, ChangedBy), Answers),
    Answers == [differs - []].
test(breach_72nd_hour_in_time) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(breach_notified_in_72nd_hour, Profile),
    findall(Result - Citations, uk_breach_notification_timing(Profile, Result, Citations), Answers),
    Answers == [notification_in_time - [cite(uk_si_2003_2426_reg_5a_2), cite(uk_reg_611_2013_art_2_2), cite(uk_reg_1182_1971_art_3_1)]].
test(breach_73rd_hour_feasible_out_of_time) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(breach_notified_in_73rd_hour, Profile),
    findall(Result - Citations, uk_breach_notification_timing(Profile, Result, Citations), Answers),
    Answers == [notification_out_of_time - [cite(uk_si_2003_2426_reg_5a_2), cite(uk_reg_611_2013_art_2_2), cite(uk_reg_1182_1971_art_3_1)]].
test(breach_late_with_reasons_cites_regulation_5a_3a) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(breach_late_with_reasons, Profile),
    findall(Result - Citations, uk_breach_notification_timing(Profile, Result, Citations), Answers),
    Answers == [notification_late_with_reasons - [cite(uk_si_2003_2426_reg_5a_2), cite(uk_si_2003_2426_reg_5a_3a), cite(uk_reg_611_2013_art_2_2), cite(uk_reg_1182_1971_art_3_1)]].
test(breach_not_provider_not_applicable) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(breach_not_a_service_provider, Profile),
    findall(Result - Citations, uk_breach_notification_timing(Profile, Result, Citations), Answers),
    Answers == [not_applicable - [cite(uk_si_2003_2426_reg_5_1), cite(uk_si_2003_2426_reg_5a_1), cite(uk_si_2003_2426_reg_5a_2)]].
test(breach_earlier_awareness_refers_with_pairs) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(breach_awareness_before_amendment, Profile),
    findall(Result - Citations, uk_breach_notification_timing(Profile, Result, Citations), Answers),
    Answers == [needs_legal_review(cross_reference_unresolved(cite(uk_si_2025_904_reg_2_p), cite(uk_si_2003_2426_reg_5a_as_in_effect_before_20_august_2025)), [resolution(cite(uk_si_2003_2426_reg_5a_as_in_effect_before_20_august_2025), not_attempted), inputs_relied_on([provider_of_a_public_electronic_communications_service - true, personal_data_breach_occurred - true, became_aware_on_or_after_20_august_2025 - false])]) - []].
test(breach_empty_profile_asks_for_awareness) :-
    findall(Result, uk_breach_notification_timing([], Result, []), Answers),
    Answers == [indeterminate([became_aware_on_or_after_20_august_2025])].
test(tier_commission_notice_is_higher) :-
    findall(Result - Citations, uk_penalty_maximum_tier([attribute(act_or_omission_on_or_after_5_february_2026, true), attribute(provision_infringed, commission_notice_not_complied_with)], Result, Citations), Answers),
    Answers == [higher_maximum_amount - [cite(uk_dpa_2018_s_157_4), cite(uk_si_2026_82_reg_11_2)]].
test(tier_section_142_8b_is_higher) :-
    findall(Result - Citations, uk_penalty_maximum_tier([attribute(act_or_omission_on_or_after_5_february_2026, true), attribute(provision_infringed, section_142_8b_of_the_data_protection_act_2018)], Result, Citations), Answers),
    Answers == [higher_maximum_amount - [cite(uk_si_2003_2426_sch_1_para_18_d), cite(uk_si_2026_82_reg_11_2)]].
test(tier_without_provision_asks_for_it) :-
    findall(Result, uk_penalty_maximum_tier([attribute(act_or_omission_on_or_after_5_february_2026, true)], Result, []), Answers),
    Answers == [indeterminate([provision_infringed])].
test(amount_above_higher_tie) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(amount_higher_above_tie, Profile),
    findall(Result - Citations, uk_penalty_maximum_amount_in_pence(Profile, Result, Citations), Answers),
    Answers = [Amount - AmountCitations],
    Amount =:= 1750000004,
    AmountCitations == [cite(uk_si_2003_2426_sch_1_para_18_b_ii), cite(uk_dpa_2018_s_157_2), cite(uk_si_2026_82_reg_11_2), cite(uk_dpa_2018_s_157_5)].
test(amount_above_standard_tie) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(amount_standard_above_tie, Profile),
    findall(Result - Citations, uk_penalty_maximum_amount_in_pence(Profile, Result, Citations), Answers),
    Answers = [Amount - AmountCitations],
    Amount =:= 870000002,
    AmountCitations == [cite(uk_dpa_2018_s_157_2), cite(uk_si_2026_82_reg_11_2), cite(uk_dpa_2018_s_157_6)].
test(amount_at_standard_tie_is_fixed) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(amount_standard_tie, Profile),
    findall(Result, uk_penalty_maximum_amount_in_pence(Profile, Result, _), Answers),
    Answers = [Amount],
    Amount =:= 870000000.
test(amount_earlier_act_refers_with_four_key_pairs) :-
    findall(Result - Citations, uk_penalty_maximum_amount_in_pence([attribute(act_or_omission_on_or_after_5_february_2026, false), attribute(provision_infringed, regulation_6)], Result, Citations), Answers),
    Answers == [needs_legal_review(cross_reference_unresolved(cite(uk_si_2026_82_reg_11_1), cite(uk_si_2003_2426_as_in_effect_before_5_february_2026)), [resolution(cite(uk_si_2003_2426_as_in_effect_before_5_february_2026), not_attempted), inputs_relied_on([act_or_omission_on_or_after_5_february_2026 - false, provision_infringed - regulation_6])]) - []].
test(amount_without_undertaking_judgement_asks_for_it) :-
    findall(Result, uk_penalty_maximum_amount_in_pence([attribute(act_or_omission_on_or_after_5_february_2026, true), attribute(provision_infringed, regulation_6)], Result, []), Answers),
    Answers == [indeterminate([penalised_person_is_an_undertaking])].
test(amount_undertaking_without_turnover_asks_for_turnover) :-
    findall(Result, uk_penalty_maximum_amount_in_pence([attribute(act_or_omission_on_or_after_5_february_2026, true), attribute(provision_infringed, regulation_6), attribute(penalised_person_is_an_undertaking, unsure)], Result, []), Answers),
    Answers == [indeterminate([total_annual_worldwide_turnover_in_preceding_financial_year_in_pounds])].

cp_test_names([uk_consent_yields_one_permitted_answer, uk_no_way_yields_one_not_permitted_answer, uk_empty_profile_asks_for_the_gate, uk_gate_false_settles_whatever_else_is_absent, uk_unsure_gate_with_all_ways_false_is_referred, decide_wraps_the_uk_answer, checklist_marks_the_met_way, eu_consent_without_information_is_not_permitted, eu_empty_profile_asks_for_the_scope, comparison_differs_lists_the_uk_citations, comparison_same_has_no_changed_by, comparison_settles_differs_while_uk_is_open, breach_72nd_hour_in_time, breach_73rd_hour_feasible_out_of_time, breach_late_with_reasons_cites_regulation_5a_3a, breach_not_provider_not_applicable, breach_earlier_awareness_refers_with_pairs, breach_empty_profile_asks_for_awareness, tier_commission_notice_is_higher, tier_section_142_8b_is_higher, tier_without_provision_asks_for_it, amount_above_higher_tie, amount_above_standard_tie, amount_at_standard_tie_is_fixed, amount_earlier_act_refers_with_four_key_pairs, amount_without_undertaking_judgement_asks_for_it, amount_undertaking_without_turnover_asks_for_turnover]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
