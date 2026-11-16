% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_supervision_fines_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_supervision_fines_queries, [nis2_supervision_fines_profile_keys/1, nis2_supervision_fines_what_if/4, entity_class/0, unsure/0, essential/0]).
:- use_module(m__eu_nis2_supervision_fines_kernel, [nis2_supervision_fines_input_problems/2]).
:- use_module(m__eu_nis2_supervision_fines_nis2_supervision_fines, [decide_nis2_supervision_fines/2, nis2_supervision_fines_checklist/2]).
:- use_module(m__eu_nis2_supervision_fines_fixtures, [nis2_supervision_fines_profile_for/2]).

test(profile_keys_are_the_contract_keys) :-
    nis2_supervision_fines_profile_keys(ProfileKeys),
    ProfileKeys == [entity_class, infringed_provision, worldwide_annual_turnover_eur, entity_is_public_administration, earlier_measures_ineffective, deadline_set_for_necessary_action, required_action_taken_within_deadline, infringement_may_entail_notifiable_personal_data_breach, authority_became_aware_in_supervision_or_enforcement, data_protection_authority_in_other_member_state, gdpr_fine_imposed_under_art_58_2_i, gdpr_fine_for_same_conduct].
test(eligibility_query_two) :-
    nis2_supervision_fines_profile_for(escalation_exercisable, Profile),
    findall(Verdict, decide_nis2_supervision_fines(Profile, Verdict), Verdicts),
    Verdicts == [nis2_supervision_fines_verdict(eligible, [cite(eu_dir_2022_2555_art_32_5)])].
test(justification_query_seven_every_item_cited) :-
    nis2_supervision_fines_profile_for(escalation_exercisable, Profile),
    nis2_supervision_fines_checklist(Profile, Items),
    length(Items, 5),
    maplist(item_met_and_cited, Items).
test(what_if_flips_ineligible_to_eligible) :-
    nis2_supervision_fines_profile_for(escalation_action_taken_within_deadline, Profile),
    nis2_supervision_fines_what_if(Profile, required_action_taken_within_deadline, false, eligible).
test(what_if_flips_eligible_to_ineligible) :-
    nis2_supervision_fines_profile_for(escalation_exercisable, Profile),
    nis2_supervision_fines_what_if(Profile, deadline_set_for_necessary_action, false, ineligible).
test(what_if_passes_an_unsure_judgement_through) :-
    nis2_supervision_fines_profile_for(escalation_exercisable, Profile),
    nis2_supervision_fines_what_if(Profile, earlier_measures_ineffective, unsure, needs_legal_review(open_textured(earlier_measures_ineffective, cite(eu_dir_2022_2555_art_32_5)), [inputs_relied_on([earlier_measures_ineffective - unsure])])).
test(what_if_with_a_bad_value_reports_input_problems) :-
    nis2_supervision_fines_profile_for(escalation_exercisable, Profile),
    nis2_supervision_fines_what_if(Profile, entity_class, banana, input_problems([wrong_type(entity_class)])).
test(input_check_is_re_exported) :-
    nis2_supervision_fines_input_problems([attribute(colour, red)], [unknown_key(colour)]).
test(root_atoms_are_exported) :-
    entity_class,
    unsure,
    essential.

item_met_and_cited(item(_, met, cite(eu_dir_2022_2555_art_32_5))).

test(what_if_does_not_crisp_the_unsure_judgement, fail) :-
    nis2_supervision_fines_profile_for(escalation_exercisable, Profile),
    nis2_supervision_fines_what_if(Profile, earlier_measures_ineffective, unsure, eligible).

cp_test_names([profile_keys_are_the_contract_keys, eligibility_query_two, justification_query_seven_every_item_cited, what_if_flips_ineligible_to_eligible, what_if_flips_eligible_to_ineligible, what_if_passes_an_unsure_judgement_through, what_if_with_a_bad_value_reports_input_problems, input_check_is_re_exported, root_atoms_are_exported]).
cp_test_fail_names([what_if_does_not_crisp_the_unsure_judgement]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
