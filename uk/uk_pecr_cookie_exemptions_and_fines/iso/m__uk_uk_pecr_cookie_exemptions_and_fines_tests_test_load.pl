% SPDX-License-Identifier: EUPL-1.2
:- module(m__uk_uk_pecr_cookie_exemptions_and_fines_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__uk_uk_pecr_cookie_exemptions_and_fines_kernel, [uk_pecr_cookie_exemptions_and_fines_input_problems/2]).
:- use_module(m__uk_uk_pecr_cookie_exemptions_and_fines_citations, [citation/2, implements/1]).

test(the_verdict_term_carries_status_and_citations) :-
    Verdict = uk_pecr_cookie_exemptions_and_fines_verdict(permitted, [cite(uk_si_2003_2426_reg_6_1)]),
    Verdict = uk_pecr_cookie_exemptions_and_fines_verdict(Status, Citations),
    Status == permitted,
    Citations == [cite(uk_si_2003_2426_reg_6_1)].
test(the_indeterminate_status_names_one_key) :-
    Result = indeterminate([storage_or_access_within_regulation_6]),
    Result = indeterminate([Key]),
    Key == storage_or_access_within_regulation_6.
test(the_open_textured_referral_destructures) :-
    Result = needs_legal_review(open_textured(consent_to_the_storage_or_access_given, cite(uk_si_2003_2426_sch_a1_para_2_1_b)), [inputs_relied_on([consent_to_the_storage_or_access_given - unsure])]),
    Result = needs_legal_review(open_textured(Key, cite(Cite)), [inputs_relied_on(Pairs)]),
    Key == consent_to_the_storage_or_access_given,
    Cite == uk_si_2003_2426_sch_a1_para_2_1_b,
    Pairs == [consent_to_the_storage_or_access_given - unsure].
test(the_cross_reference_referral_destructures) :-
    Result = needs_legal_review(cross_reference_unresolved(cite(uk_si_2026_82_reg_11_1), cite(uk_si_2003_2426_as_in_effect_before_5_february_2026)), [resolution(cite(uk_si_2003_2426_as_in_effect_before_5_february_2026), not_attempted), inputs_relied_on([act_or_omission_on_or_after_5_february_2026 - false])]),
    Result = needs_legal_review(cross_reference_unresolved(cite(Cite), cite(Target)), [resolution(cite(Target), Resolution), inputs_relied_on(Pairs)]),
    Cite == uk_si_2026_82_reg_11_1,
    Target == uk_si_2003_2426_as_in_effect_before_5_february_2026,
    Resolution == not_attempted,
    Pairs == [act_or_omission_on_or_after_5_february_2026 - false].
test(the_cookie_atoms_are_distinct) :-
    dif(permitted, not_permitted),
    dif(permitted, not_applicable),
    dif(not_permitted, not_applicable).
test(the_comparison_atoms_are_distinct) :-
    dif(same, differs).
test(the_breach_atoms_are_distinct) :-
    dif(notification_in_time, notification_late_with_reasons),
    dif(notification_in_time, notification_out_of_time),
    dif(notification_in_time, notification_reasons_for_delay_missing),
    dif(notification_late_with_reasons, notification_out_of_time),
    dif(notification_late_with_reasons, notification_reasons_for_delay_missing),
    dif(notification_out_of_time, notification_reasons_for_delay_missing),
    dif(notification_in_time, not_applicable).
test(the_tier_atoms_are_distinct) :-
    dif(higher_maximum_amount, standard_maximum_amount).
test(the_cookie_prohibition_citation_is_recorded) :-
    citation(uk_si_2003_2426_reg_6_1, _Record).
test(the_breach_citation_is_recorded) :-
    citation(uk_si_2003_2426_reg_5a_2, _Record).
test(the_maximum_amount_citation_is_recorded) :-
    citation(uk_dpa_2018_s_157_5, _Record).
test(the_directive_citation_is_recorded) :-
    citation(eu_dir_2002_58_art_5_3, _Record).
test(the_citation_record_has_label_and_reference) :-
    citation(uk_si_2003_2426_reg_6_1, [label - Label, ref - Reference]),
    atom(Label),
    atom(Reference).
test(the_provenance_marker_holds_for_a_recorded_key) :-
    implements(uk_si_2003_2426_sch_a1_para_2_1).
test(an_empty_profile_has_no_problem) :-
    findall(Problems, uk_pecr_cookie_exemptions_and_fines_input_problems([], Problems), Answers),
    Answers == [[]].
test(a_well_formed_profile_has_no_problem) :-
    Profile = [attribute(storage_or_access_within_regulation_6, true), attribute(consent_to_the_storage_or_access_given, unsure), attribute(subscriber_or_user_has_not_objected, false), attribute(hours_elapsed_at_notification, 73), attribute(provision_infringed, regulation_6), attribute(total_annual_worldwide_turnover_in_preceding_financial_year_in_pounds, 0)],
    findall(Problems, uk_pecr_cookie_exemptions_and_fines_input_problems(Profile, Problems), Answers),
    Answers == [[]].
test(an_unbound_profile_is_the_wrong_type) :-
    findall(Problems, uk_pecr_cookie_exemptions_and_fines_input_problems(_Profile, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(an_atom_is_not_an_attribute_list) :-
    findall(Problems, uk_pecr_cookie_exemptions_and_fines_input_problems(profile, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(a_list_with_a_foreign_element_is_not_an_attribute_list) :-
    findall(Problems, uk_pecr_cookie_exemptions_and_fines_input_problems([attribute(user_consent_given, true), user_consent_given], Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(an_unknown_key_is_named) :-
    findall(Problems, uk_pecr_cookie_exemptions_and_fines_input_problems([attribute(cookie_banner_shown, true)], Problems), Answers),
    Answers == [[unknown_key(cookie_banner_shown)]].
test(a_repeated_unknown_key_is_named_once) :-
    findall(Problems, uk_pecr_cookie_exemptions_and_fines_input_problems([attribute(cookie_banner_shown, true), attribute(cookie_banner_shown, false)], Problems), Answers),
    Answers == [[unknown_key(cookie_banner_shown)]].
test(a_crisp_key_given_unsure_is_the_wrong_type) :-
    findall(Problems, uk_pecr_cookie_exemptions_and_fines_input_problems([attribute(subscriber_or_user_has_not_objected, unsure)], Problems), Answers),
    Answers == [[wrong_type(subscriber_or_user_has_not_objected)]].
test(a_judgement_key_given_unsure_is_well_typed) :-
    uk_pecr_cookie_exemptions_and_fines_input_problems([attribute(user_consent_given, unsure)], []).
test(an_attested_value_is_the_wrong_type) :-
    uk_pecr_cookie_exemptions_and_fines_input_problems([attribute(user_consent_given, attested(true))], [wrong_type(user_consent_given)]).
test(a_negative_integer_is_the_wrong_type) :-
    uk_pecr_cookie_exemptions_and_fines_input_problems([attribute(hours_elapsed_at_notification, -1)], [wrong_type(hours_elapsed_at_notification)]).
test(a_float_is_the_wrong_type) :-
    uk_pecr_cookie_exemptions_and_fines_input_problems([attribute(total_annual_worldwide_turnover_in_preceding_financial_year_in_pounds, 1.5)], [wrong_type(total_annual_worldwide_turnover_in_preceding_financial_year_in_pounds)]).
test(an_unlisted_provision_is_the_wrong_type) :-
    uk_pecr_cookie_exemptions_and_fines_input_problems([attribute(provision_infringed, regulation_99)], [wrong_type(provision_infringed)]).
test(a_listed_provision_is_well_typed) :-
    uk_pecr_cookie_exemptions_and_fines_input_problems([attribute(provision_infringed, commission_notice_not_complied_with)], []).
test(an_unbound_value_is_the_wrong_type) :-
    findall(Problems, uk_pecr_cookie_exemptions_and_fines_input_problems([attribute(personal_data_breach_occurred, _Value)], Problems), Answers),
    Answers == [[wrong_type(personal_data_breach_occurred)]].
test(a_duplicate_key_is_named_once_and_not_typed) :-
    findall(Problems, uk_pecr_cookie_exemptions_and_fines_input_problems([attribute(provision_infringed, regulation_6), attribute(provision_infringed, regulation_99)], Problems), Answers),
    Answers == [[duplicate_key(provision_infringed)]].
test(contract_problems_come_before_unknown_keys) :-
    Profile = [attribute(cookie_banner_shown, true), attribute(penalised_person_is_an_undertaking, maybe), attribute(storage_or_access_within_regulation_6, yes)],
    findall(Problems, uk_pecr_cookie_exemptions_and_fines_input_problems(Profile, Problems), Answers),
    Answers == [[wrong_type(storage_or_access_within_regulation_6), wrong_type(penalised_person_is_an_undertaking), unknown_key(cookie_banner_shown)]].

test(the_provenance_marker_fails_for_an_unrecorded_key, fail) :-
    implements(uk_todo_primary_source).
test(a_well_formed_profile_reports_no_wrong_type, fail) :-
    uk_pecr_cookie_exemptions_and_fines_input_problems([attribute(user_consent_given, true)], [wrong_type(user_consent_given)]).

cp_test_names([the_verdict_term_carries_status_and_citations, the_indeterminate_status_names_one_key, the_open_textured_referral_destructures, the_cross_reference_referral_destructures, the_cookie_atoms_are_distinct, the_comparison_atoms_are_distinct, the_breach_atoms_are_distinct, the_tier_atoms_are_distinct, the_cookie_prohibition_citation_is_recorded, the_breach_citation_is_recorded, the_maximum_amount_citation_is_recorded, the_directive_citation_is_recorded, the_citation_record_has_label_and_reference, the_provenance_marker_holds_for_a_recorded_key, an_empty_profile_has_no_problem, a_well_formed_profile_has_no_problem, an_unbound_profile_is_the_wrong_type, an_atom_is_not_an_attribute_list, a_list_with_a_foreign_element_is_not_an_attribute_list, an_unknown_key_is_named, a_repeated_unknown_key_is_named_once, a_crisp_key_given_unsure_is_the_wrong_type, a_judgement_key_given_unsure_is_well_typed, an_attested_value_is_the_wrong_type, a_negative_integer_is_the_wrong_type, a_float_is_the_wrong_type, an_unlisted_provision_is_the_wrong_type, a_listed_provision_is_well_typed, an_unbound_value_is_the_wrong_type, a_duplicate_key_is_named_once_and_not_typed, contract_problems_come_before_unknown_keys]).
cp_test_fail_names([the_provenance_marker_fails_for_an_unrecorded_key, a_well_formed_profile_reports_no_wrong_type]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
