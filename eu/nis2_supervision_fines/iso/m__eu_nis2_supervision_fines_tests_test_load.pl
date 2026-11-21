% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_supervision_fines_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_supervision_fines_kernel, [nis2_supervision_fines_input_problems/2, nis2_supervision_fines_relied_pairs/3]).
:- use_module(m__eu_nis2_supervision_fines_citations, [citation/2, citation_vocabulary/1, implements/1]).

test(the_ceiling_term_carries_amount_and_basis) :-
    Ceiling = minimum_national_maximum(10000000, fixed_amount),
    Ceiling = minimum_national_maximum(AmountEur, Basis),
    AmountEur == 10000000,
    Basis == fixed_amount.
test(the_power_term_carries_kind_measure_and_cite) :-
    Power = power(supervision, security_scans, cite(eu_dir_2022_2555_art_33_2_c)),
    Power = power(Kind, Measure, cite(Key)),
    Kind == supervision,
    Measure == security_scans,
    Key == eu_dir_2022_2555_art_33_2_c.
test(the_not_exercisable_term_carries_its_reason) :-
    Result = not_exercisable(no_deadline_set),
    Result = not_exercisable(Reason),
    Reason == no_deadline_set.
test(the_duty_list_carries_its_citations) :-
    Duty = [inform_gdpr_supervisory_authorities(cite(eu_dir_2022_2555_art_35_1)), inform_supervisory_authority_in_own_member_state(cite(eu_dir_2022_2555_art_35_3))],
    Duty = [inform_gdpr_supervisory_authorities(cite(FirstKey)), inform_supervisory_authority_in_own_member_state(cite(SecondKey))],
    FirstKey == eu_dir_2022_2555_art_35_1,
    SecondKey == eu_dir_2022_2555_art_35_3.
test(the_referral_term_carries_reason_and_context) :-
    Status = needs_legal_review(open_textured(earlier_measures_ineffective, cite(eu_dir_2022_2555_art_32_5)), [inputs_relied_on([earlier_measures_ineffective - unsure])]),
    Status = needs_legal_review(open_textured(Input, cite(Citation)), [inputs_relied_on(Pairs)]),
    Input == earlier_measures_ineffective,
    Citation == eu_dir_2022_2555_art_32_5,
    Pairs == [earlier_measures_ineffective - unsure].
test(the_indeterminate_term_names_one_key) :-
    Status = indeterminate([infringed_provision]),
    Status = indeterminate([MissingKey]),
    MissingKey == infringed_provision.
test(the_verdict_term_carries_status_and_citations) :-
    Verdict = nis2_supervision_fines_verdict(eligible, [cite(eu_dir_2022_2555_art_34_4)]),
    Verdict = nis2_supervision_fines_verdict(Status, Citations),
    Status == eligible,
    Citations == [cite(eu_dir_2022_2555_art_34_4)].
test(the_verdict_atoms_are_distinct) :-
    dif(eligible, ineligible),
    dif(eligible, indeterminate),
    dif(ineligible, invalid_profile).
test(the_gdpr_bar_atoms_are_distinct) :-
    dif(fine_barred, fine_not_barred).
test(the_basis_atoms_are_distinct) :-
    dif(fixed_amount, turnover_percentage).
test(the_escalation_atoms_are_distinct) :-
    dif(exercisable, not_exercisable(important_entity)),
    dif(public_administration_entity, measures_not_ineffective),
    dif(no_deadline_set, action_taken_within_deadline).
test(a_well_formed_profile_has_no_problem) :-
    nis2_supervision_fines_input_problems([attribute(entity_class, important), attribute(infringed_provision, art_21), attribute(worldwide_annual_turnover_eur, 600000000)], []).
test(the_input_check_gives_one_answer) :-
    findall(Problems, nis2_supervision_fines_input_problems([attribute(entity_class, essential)], Problems), Answers),
    Answers == [[]].
test(an_unknown_key_is_a_problem) :-
    nis2_supervision_fines_input_problems([attribute(sector, energy)], [unknown_key(sector)]).
test(a_judgement_given_unsure_is_well_formed) :-
    nis2_supervision_fines_input_problems([attribute(gdpr_fine_for_same_conduct, unsure)], []).
test(a_crisp_key_given_unsure_is_wrong_type) :-
    nis2_supervision_fines_input_problems([attribute(deadline_set_for_necessary_action, unsure)], [wrong_type(deadline_set_for_necessary_action)]).
test(the_pairs_keep_present_judgements_in_order) :-
    nis2_supervision_fines_relied_pairs([attribute(gdpr_fine_for_same_conduct, unsure), attribute(infringement_may_entail_notifiable_personal_data_breach, true)], [infringement_may_entail_notifiable_personal_data_breach, gdpr_fine_for_same_conduct], [infringement_may_entail_notifiable_personal_data_breach - true, gdpr_fine_for_same_conduct - unsure]).
test(the_pairs_of_an_empty_profile_are_empty) :-
    nis2_supervision_fines_relied_pairs([], [earlier_measures_ineffective], []).
test(the_essential_floor_citation_is_recorded) :-
    citation(eu_dir_2022_2555_art_34_4, _Record).
test(the_escalation_citation_is_recorded) :-
    citation(eu_dir_2022_2555_art_32_5, _Record).
test(the_gdpr_bar_citation_is_in_the_vocabulary) :-
    citation_vocabulary(eu_dir_2022_2555_art_35_2).
test(a_recorded_key_is_implemented) :-
    implements(eu_dir_2022_2555_art_35_1).
test(a_lead_in_key_is_recorded) :-
    citation(eu_dir_2022_2555_art_32_2, _Record).

test(an_unknown_key_is_not_a_clean_profile, fail) :-
    nis2_supervision_fines_input_problems([attribute(sector, energy)], []).
test(an_unrecorded_key_is_not_implemented, fail) :-
    implements(eu_dir_2022_2555_art_36).
test(a_lead_in_key_is_not_in_the_vocabulary, fail) :-
    citation_vocabulary(eu_dir_2022_2555_art_32_2).

cp_test_names([the_ceiling_term_carries_amount_and_basis, the_power_term_carries_kind_measure_and_cite, the_not_exercisable_term_carries_its_reason, the_duty_list_carries_its_citations, the_referral_term_carries_reason_and_context, the_indeterminate_term_names_one_key, the_verdict_term_carries_status_and_citations, the_verdict_atoms_are_distinct, the_gdpr_bar_atoms_are_distinct, the_basis_atoms_are_distinct, the_escalation_atoms_are_distinct, a_well_formed_profile_has_no_problem, the_input_check_gives_one_answer, an_unknown_key_is_a_problem, a_judgement_given_unsure_is_well_formed, a_crisp_key_given_unsure_is_wrong_type, the_pairs_keep_present_judgements_in_order, the_pairs_of_an_empty_profile_are_empty, the_essential_floor_citation_is_recorded, the_escalation_citation_is_recorded, the_gdpr_bar_citation_is_in_the_vocabulary, a_recorded_key_is_implemented, a_lead_in_key_is_recorded]).
cp_test_fail_names([an_unknown_key_is_not_a_clean_profile, an_unrecorded_key_is_not_implemented, a_lead_in_key_is_not_in_the_vocabulary]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
