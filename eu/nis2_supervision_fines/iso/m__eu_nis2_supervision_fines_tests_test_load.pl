% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_supervision_fines_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_supervision_fines_kernel, [nis2_supervision_fines_input_problems/2, nis2_supervision_fines_pairs/3, nis2_supervision_fines_missing_in_order/3]).
:- use_module(m__eu_nis2_supervision_fines_citations, [citation/2, implements/1]).

test(a_well_formed_profile_has_exactly_one_empty_problem_list) :-
    findall(Problems, nis2_supervision_fines_input_problems([attribute(entity_class, essential), attribute(infringed_provision, art_21), attribute(worldwide_annual_turnover_eur, 600000000)], Problems), Answers),
    Answers == [[]].
test(an_unknown_key_is_named) :-
    findall(Problems, nis2_supervision_fines_input_problems([attribute(colour, red)], Problems), Answers),
    Answers == [[unknown_key(colour)]].
test(a_non_list_profile_is_wrong_type) :-
    nis2_supervision_fines_input_problems(essential, [wrong_type(profile)]).
test(unsure_on_a_judgement_key_is_well_typed) :-
    nis2_supervision_fines_input_problems([attribute(gdpr_fine_for_same_conduct, unsure)], []).
test(pairs_are_the_present_judgements_in_order) :-
    findall(Pairs, nis2_supervision_fines_pairs([attribute(earlier_measures_ineffective, unsure)], [earlier_measures_ineffective], Pairs), Answers),
    Answers == [[earlier_measures_ineffective - unsure]].
test(missing_keys_are_named_in_root_order) :-
    nis2_supervision_fines_missing_in_order([], [entity_class, worldwide_annual_turnover_eur], Missing),
    Missing == [entity_class, worldwide_annual_turnover_eur].
test(the_ceiling_term_carries_amount_and_basis) :-
    Ceiling = minimum_national_maximum(10000000, fixed_amount),
    Ceiling = minimum_national_maximum(AmountEur, Basis),
    AmountEur =:= 10000000,
    Basis == fixed_amount.
test(the_power_term_carries_kind_measure_and_citation) :-
    Power = power(escalation, suspend_certification_or_authorisation, cite(eu_dir_2022_2555_art_32_5_a)),
    Power = power(Kind, Measure, cite(Key)),
    Kind == escalation,
    Measure == suspend_certification_or_authorisation,
    citation(Key, _).
test(the_not_exercisable_term_carries_its_reason) :-
    Result = not_exercisable(important_entity),
    Result = not_exercisable(Reason),
    Reason == important_entity.
test(the_referral_term_carries_reason_and_context) :-
    Status = needs_legal_review(open_textured(earlier_measures_ineffective, cite(eu_dir_2022_2555_art_32_5)), [inputs_relied_on([earlier_measures_ineffective - unsure])]),
    Status = needs_legal_review(open_textured(Input, cite(Key)), [inputs_relied_on(Pairs)]),
    Input == earlier_measures_ineffective,
    Pairs == [earlier_measures_ineffective - unsure],
    citation(Key, _).
test(the_duty_terms_carry_their_citations) :-
    Duty = [inform_gdpr_supervisory_authorities(cite(eu_dir_2022_2555_art_35_1)), inform_supervisory_authority_in_own_member_state(cite(eu_dir_2022_2555_art_35_3))],
    Duty = [inform_gdpr_supervisory_authorities(cite(FirstKey)), inform_supervisory_authority_in_own_member_state(cite(SecondKey))],
    citation(FirstKey, _),
    citation(SecondKey, _).
test(the_verdict_atoms_are_distinct) :-
    dif(fine_barred, fine_not_barred),
    dif(exercisable, no_union_minimum),
    dif(fixed_amount, turnover_percentage),
    dif(supervision, enforcement),
    dif(enforcement, escalation).
test(the_reason_atoms_are_distinct) :-
    dif(important_entity, public_administration_entity),
    dif(measures_not_ineffective, no_deadline_set),
    dif(no_deadline_set, action_taken_within_deadline).
test(the_essential_fine_floor_citation_is_recorded) :-
    citation(eu_dir_2022_2555_art_34_4, _Record).
test(the_important_fine_floor_citation_is_recorded) :-
    citation(eu_dir_2022_2555_art_34_5, _Record).
test(the_escalation_citation_is_implemented) :-
    implements(eu_dir_2022_2555_art_32_5).

test(an_unknown_key_is_not_a_clean_profile, fail) :-
    nis2_supervision_fines_input_problems([attribute(colour, red)], []).
test(unsure_on_a_crisp_key_is_not_well_typed, fail) :-
    nis2_supervision_fines_input_problems([attribute(gdpr_fine_imposed_under_art_58_2_i, unsure)], []).
test(the_indeterminate_term_is_a_compound_not_a_bare_atom, fail) :-
    indeterminate([entity_class]) = indeterminate.
test(the_placeholder_citation_is_not_recorded, fail) :-
    citation(eu_todo_primary_source, _Record).
test(a_shortened_citation_is_not_implemented, fail) :-
    implements(eu_dir_2022_2555_art_35).

cp_test_names([a_well_formed_profile_has_exactly_one_empty_problem_list, an_unknown_key_is_named, a_non_list_profile_is_wrong_type, unsure_on_a_judgement_key_is_well_typed, pairs_are_the_present_judgements_in_order, missing_keys_are_named_in_root_order, the_ceiling_term_carries_amount_and_basis, the_power_term_carries_kind_measure_and_citation, the_not_exercisable_term_carries_its_reason, the_referral_term_carries_reason_and_context, the_duty_terms_carry_their_citations, the_verdict_atoms_are_distinct, the_reason_atoms_are_distinct, the_essential_fine_floor_citation_is_recorded, the_important_fine_floor_citation_is_recorded, the_escalation_citation_is_implemented]).
cp_test_fail_names([an_unknown_key_is_not_a_clean_profile, unsure_on_a_crisp_key_is_not_well_typed, the_indeterminate_term_is_a_compound_not_a_bare_atom, the_placeholder_citation_is_not_recorded, a_shortened_citation_is_not_implemented]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
