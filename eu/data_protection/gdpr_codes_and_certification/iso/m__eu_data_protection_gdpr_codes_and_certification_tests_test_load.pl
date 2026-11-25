% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_codes_and_certification_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_codes_and_certification_kernel, [gdpr_codes_and_certification_input_problems/2, calendar_date_t/2, date_triple_order/7, crisp_step/5, judgement_step/5, all_step/4, walk_ladder/3, combine_parts/3, combine_one/2, relied_pairs/3]).
:- use_module(m__eu_data_protection_gdpr_codes_and_certification_citations, [citation/2, implements/1]).

test(the_certification_result_carries_validity_and_transfer) :-
    Result = certification_result(within_maximum_period, transfer_conditions_met),
    Result = certification_result(Validity, Transfer),
    Validity == within_maximum_period,
    Transfer == transfer_conditions_met.
test(the_code_result_carries_the_duties_in_order) :-
    Result = code_result(monitoring_by_accredited_body([take_appropriate_action_on_infringement, inform_supervisory_authority_of_actions_and_reasons]), not_relied_on_for_transfers),
    Result = code_result(monitoring_by_accredited_body(Duties), Transfer),
    Duties == [take_appropriate_action_on_infringement, inform_supervisory_authority_of_actions_and_reasons],
    Transfer == not_relied_on_for_transfers.
test(the_slice_verdict_term_carries_result_and_citations) :-
    Verdict = gdpr_codes_and_certification_verdict(accreditation_conditions_met, [cite(eu_reg_2016_679_art_43_2)]),
    Verdict = gdpr_codes_and_certification_verdict(Result, Citations),
    Result == accreditation_conditions_met,
    Citations == [cite(eu_reg_2016_679_art_43_2)].
test(the_referral_builds_and_destructures) :-
    Result = needs_legal_review(open_textured(certification_requirements_not_met, cite(eu_reg_2016_679_art_42_7)), [inputs_relied_on([certification_requirements_not_met - unsure])]),
    Result = needs_legal_review(open_textured(Key, cite(CitationKey)), [inputs_relied_on(Pairs)]),
    Key == certification_requirements_not_met,
    CitationKey == eu_reg_2016_679_art_42_7,
    Pairs == [certification_requirements_not_met - unsure].
test(the_open_statuses_are_compounds) :-
    Missing = indeterminate([certification_issuer]),
    Missing = indeterminate([Key]),
    Key == certification_issuer,
    Problems = input_problems([wrong_type(check_date)]),
    Problems = input_problems([wrong_type(Name)]),
    Name == check_date.
test(the_validity_atoms_are_distinct) :-
    dif(not_yet_issued, maximum_period_ended),
    dif(not_issued_by_competent_issuer, criteria_not_approved),
    dif(issued_without_informing_supervisory_authority, withdrawn),
    dif(withdrawn, withdrawal_required),
    dif(withdrawal_required, within_maximum_period).
test(the_transfer_atoms_are_distinct) :-
    dif(not_relied_on_for_transfers, transfer_conditions_not_met),
    dif(transfer_conditions_not_met, transfer_conditions_met).
test(the_monitoring_atoms_are_distinct) :-
    dif(article_41_not_applicable, not_a_code_under_article_40_2),
    dif(code_not_approved, monitoring_mechanisms_missing),
    dif(monitoring_mechanisms_missing, no_accredited_monitoring_body).
test(the_accreditation_atoms_are_distinct) :-
    dif(not_yet_accredited, accreditation_revoked),
    dif(not_accredited_by_entity_named_in_article_43_1, accreditation_conditions_not_met),
    dif(accreditation_conditions_not_met, revocation_required),
    dif(revocation_required, accreditation_conditions_met).
test(the_same_atom_unifies) :-
    withdrawn = withdrawn.
test(the_period_citation_is_recorded) :-
    citation(eu_reg_2016_679_art_42_7, _Record).
test(the_accreditation_period_citation_is_recorded) :-
    citation(eu_reg_2016_679_art_43_4, _Record).
test(the_monitoring_citation_is_recorded) :-
    citation(eu_reg_2016_679_art_41_1, _Record).
test(a_recorded_key_is_implemented) :-
    implements(eu_reg_2016_679_art_40_2).
test(an_empty_profile_has_no_problem) :-
    gdpr_codes_and_certification_input_problems([], []).
test(a_well_typed_profile_has_no_problem) :-
    gdpr_codes_and_certification_input_problems([attribute(certification_issuer, certification_body), attribute(certification_requirements_not_met, unsure)], []).
test(a_key_outside_the_contract_is_unknown) :-
    gdpr_codes_and_certification_input_problems([attribute(colour, red)], [unknown_key(colour)]).
test(a_repeated_key_is_a_duplicate) :-
    gdpr_codes_and_certification_input_problems([attribute(certification_withdrawn, true), attribute(certification_withdrawn, false)], [duplicate_key(certification_withdrawn)]).
test(unsure_is_wrong_for_a_crisp_key) :-
    gdpr_codes_and_certification_input_problems([attribute(certification_withdrawn, unsure)], [wrong_type(certification_withdrawn)]).
test(a_non_list_is_not_a_profile) :-
    gdpr_codes_and_certification_input_problems(not_a_list, [wrong_type(profile)]).
test(a_real_day_is_a_date) :-
    calendar_date_t(date(2025, 2, 28), true).
test(a_non_leap_day_is_not_a_date) :-
    calendar_date_t(date(2025, 2, 29), false).
test(a_later_month_compares_later) :-
    date_triple_order(2025, 3, 1, 2025, 2, 28, >).
test(a_deciding_crisp_value_decides) :-
    crisp_step([attribute(certification_withdrawn, true)], certification_withdrawn, true, withdrawn, decides(withdrawn)).
test(an_absent_crisp_key_is_open_by_absence) :-
    crisp_step([], certification_withdrawn, true, withdrawn, open_by_absence(certification_withdrawn)).
test(an_unsure_judgement_is_open_by_judgement) :-
    judgement_step([attribute(certification_requirements_not_met, unsure)], certification_requirements_not_met, true, withdrawal_required, open_by_judgement(certification_requirements_not_met)).
test(a_false_member_decides_an_all_step) :-
    all_step([attribute(code_has_general_validity, false)], [code_approved_by_competent_supervisory_authority, code_has_general_validity], transfer_conditions_not_met, decides(transfer_conditions_not_met)).
test(the_walker_gives_the_final_atom) :-
    walk_ladder([passed, passed], within_maximum_period, answer(within_maximum_period)).
test(one_part_combines_alone) :-
    combine_one(answer(accreditation_conditions_met), answer(accreditation_conditions_met)).
test(an_absence_in_the_first_part_comes_first) :-
    combine_parts(absence(certification_issuer), absence(certification_holder_not_subject_to_regulation), absence(certification_issuer)).
test(present_keys_are_relied_on_in_order) :-
    relied_pairs([attribute(certification_withdrawn, false), attribute(certification_issuer, certification_body)], [certification_issuer, certification_body_accredited, certification_withdrawn], [certification_issuer - certification_body, certification_withdrawn - false]).

test(distinct_atoms_do_not_unify, fail) :-
    withdrawn = withdrawal_required.
test(an_unrecorded_key_is_not_implemented, fail) :-
    implements(eu_reg_2016_679_art_42_3).

cp_test_names([the_certification_result_carries_validity_and_transfer, the_code_result_carries_the_duties_in_order, the_slice_verdict_term_carries_result_and_citations, the_referral_builds_and_destructures, the_open_statuses_are_compounds, the_validity_atoms_are_distinct, the_transfer_atoms_are_distinct, the_monitoring_atoms_are_distinct, the_accreditation_atoms_are_distinct, the_same_atom_unifies, the_period_citation_is_recorded, the_accreditation_period_citation_is_recorded, the_monitoring_citation_is_recorded, a_recorded_key_is_implemented, an_empty_profile_has_no_problem, a_well_typed_profile_has_no_problem, a_key_outside_the_contract_is_unknown, a_repeated_key_is_a_duplicate, unsure_is_wrong_for_a_crisp_key, a_non_list_is_not_a_profile, a_real_day_is_a_date, a_non_leap_day_is_not_a_date, a_later_month_compares_later, a_deciding_crisp_value_decides, an_absent_crisp_key_is_open_by_absence, an_unsure_judgement_is_open_by_judgement, a_false_member_decides_an_all_step, the_walker_gives_the_final_atom, one_part_combines_alone, an_absence_in_the_first_part_comes_first, present_keys_are_relied_on_in_order]).
cp_test_fail_names([distinct_atoms_do_not_unify, an_unrecorded_key_is_not_implemented]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
