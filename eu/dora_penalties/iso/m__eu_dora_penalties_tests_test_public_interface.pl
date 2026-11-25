% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_penalties_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_msort/2]).
:- use_module(m__eu_dora_penalties_dora_penalties, [administrative_penalty_rules_required/3, minimum_powers/2, penalty_decision_safeguards/2, circumstances_to_take_into_account/2, criminal_penalty_liaison_duties/2, decide_dora_penalties/2, dora_penalties_status/2, dora_penalties_checklist/2, dora_penalties_decision_resolvable/1, dora_penalties_status_values/1]).
:- use_module(m__eu_dora_penalties_kernel, [dora_penalties_input_problems/2]).
:- use_module(m__eu_dora_penalties_queries, [dora_penalties_what_if/4]).
:- use_module(m__eu_dora_penalties_fixtures, [dora_penalties_subject/1, dora_penalties_profile_for/2, dora_penalties_assess/2]).

expected_status(option_used, not_required_criminal_penalties).
expected_status(option_not_used, required).
expected_status(breach_not_criminally_penalised, required).
expected_status(breach_criminal_choice_absent, indeterminate).
expected_status(breach_key_absent, indeterminate).
expected_status(fact_key_unsure, input_problems).
expected_status(duplicate_breach_key, input_problems).
expected_status(unknown_key_given, input_problems).
expected_status(judgement_unsure, required).
expected_status(no_criminal_penalties_laid_down, required).

subjects_match_expected([]).
subjects_match_expected([Subject|Subjects]) :-
    expected_status(Subject, Expected),
    findall(Verdict, dora_penalties_assess(Subject, Verdict), Verdicts),
    Verdicts = [dora_penalties_verdict(Status, _Citations)],
    Status == Expected,
    dora_penalties_status_values(StatusValues),
    member(Status, StatusValues),
    subjects_match_expected(Subjects).

subjects_have_checklists([]).
subjects_have_checklists([Subject|Subjects]) :-
    dora_penalties_profile_for(Subject, Profile),
    dora_penalties_decision_resolvable(Profile),
    findall(Items, dora_penalties_checklist(Profile, Items), Checklists),
    Checklists = [[_FirstItem|_OtherItems]],
    subjects_have_checklists(Subjects).

subjects_answer_once([]).
subjects_answer_once([Subject|Subjects]) :-
    dora_penalties_profile_for(Subject, Profile),
    findall(Result - Citations, administrative_penalty_rules_required(Profile, Result, Citations), RulesAnswers),
    length(RulesAnswers, 1),
    findall(Powers, minimum_powers(Profile, Powers), PowersAnswers),
    length(PowersAnswers, 1),
    findall(Safeguards, penalty_decision_safeguards(Profile, Safeguards), SafeguardsAnswers),
    length(SafeguardsAnswers, 1),
    findall(Circumstances, circumstances_to_take_into_account(Profile, Circumstances), CircumstancesAnswers),
    length(CircumstancesAnswers, 1),
    findall(Duties, criminal_penalty_liaison_duties(Profile, Duties), DutiesAnswers),
    length(DutiesAnswers, 1),
    findall(Problems, dora_penalties_input_problems(Profile, Problems), ProblemsAnswers),
    length(ProblemsAnswers, 1),
    subjects_answer_once(Subjects).

all_subjects(Subjects) :-
    findall(Subject, dora_penalties_subject(Subject), Subjects).

test(every_subject_resolves_to_its_expected_status) :-
    all_subjects(Subjects),
    length(Subjects, 10),
    subjects_match_expected(Subjects).
test(every_subject_has_a_non_empty_checklist) :-
    all_subjects(Subjects),
    subjects_have_checklists(Subjects).
test(every_query_answers_exactly_once_for_every_subject) :-
    all_subjects(Subjects),
    subjects_answer_once(Subjects).
test(option_used_is_not_required_with_its_citation) :-
    dora_penalties_profile_for(option_used, Profile),
    administrative_penalty_rules_required(Profile, not_required_criminal_penalties, [cite(eu_reg_2022_2554_art_52_1)]).
test(option_not_used_is_required_citing_both) :-
    dora_penalties_profile_for(option_not_used, Profile),
    administrative_penalty_rules_required(Profile, required, Citations),
    clausal_msort(Citations, Sorted),
    Sorted == [cite(eu_reg_2022_2554_art_50_3), cite(eu_reg_2022_2554_art_52_1)].
test(breach_not_criminally_penalised_is_required_citing_art_50_3) :-
    dora_penalties_profile_for(breach_not_criminally_penalised, Profile),
    administrative_penalty_rules_required(Profile, required, [cite(eu_reg_2022_2554_art_50_3)]).
test(choice_absent_names_the_choice_key) :-
    dora_penalties_profile_for(breach_criminal_choice_absent, Profile),
    administrative_penalty_rules_required(Profile, indeterminate([member_state_chose_no_administrative_rules_for_criminally_penalised_breaches]), []).
test(breach_key_absent_names_the_breach_key) :-
    dora_penalties_profile_for(breach_key_absent, Profile),
    administrative_penalty_rules_required(Profile, indeterminate([breach_subject_to_criminal_penalties_under_national_law]), []).
test(unsure_on_a_fact_key_is_wrong_type) :-
    dora_penalties_profile_for(fact_key_unsure, Profile),
    dora_penalties_input_problems(Profile, [wrong_type(breach_subject_to_criminal_penalties_under_national_law)]),
    administrative_penalty_rules_required(Profile, input_problems([wrong_type(breach_subject_to_criminal_penalties_under_national_law)]), []).
test(duplicate_key_is_reported_once) :-
    dora_penalties_profile_for(duplicate_breach_key, Profile),
    dora_penalties_input_problems(Profile, [duplicate_key(breach_subject_to_criminal_penalties_under_national_law)]),
    minimum_powers(Profile, input_problems([duplicate_key(breach_subject_to_criminal_penalties_under_national_law)])).
test(unknown_key_is_reported) :-
    dora_penalties_profile_for(unknown_key_given, Profile),
    dora_penalties_input_problems(Profile, [unknown_key(colour)]),
    circumstances_to_take_into_account(Profile, input_problems([unknown_key(colour)])).
test(well_formed_fixture_has_no_problem) :-
    dora_penalties_profile_for(option_used, Profile),
    dora_penalties_input_problems(Profile, []).
test(not_a_list_is_wrong_type_profile) :-
    dora_penalties_input_problems(not_a_list, [wrong_type(profile)]).
test(option_used_keeps_supervisory_powers_and_extension_only) :-
    dora_penalties_profile_for(option_used, Profile),
    minimum_powers(Profile, Powers),
    Powers == [power(supervisory, access_to_documents_and_data, cite(eu_reg_2022_2554_art_50_2_a)), power(supervisory, on_site_inspections_and_investigations, cite(eu_reg_2022_2554_art_50_2_b)), power(supervisory, require_corrective_and_remedial_measures, cite(eu_reg_2022_2554_art_50_2_c)), power(extension, management_body_and_responsible_individuals, cite(eu_reg_2022_2554_art_50_5))].
test(option_not_used_lists_every_power) :-
    dora_penalties_profile_for(option_not_used, Profile),
    minimum_powers(Profile, Powers),
    Powers == [power(supervisory, access_to_documents_and_data, cite(eu_reg_2022_2554_art_50_2_a)), power(supervisory, on_site_inspections_and_investigations, cite(eu_reg_2022_2554_art_50_2_b)), power(supervisory, require_corrective_and_remedial_measures, cite(eu_reg_2022_2554_art_50_2_c)), power(penalty, cease_and_desist_order, cite(eu_reg_2022_2554_art_50_4_a)), power(penalty, cessation_of_practice_or_conduct, cite(eu_reg_2022_2554_art_50_4_b)), power(penalty, measures_to_ensure_continued_compliance, cite(eu_reg_2022_2554_art_50_4_c)), power(penalty, require_data_traffic_records, cite(eu_reg_2022_2554_art_50_4_d)), power(penalty, public_notice, cite(eu_reg_2022_2554_art_50_4_e)), power(extension, management_body_and_responsible_individuals, cite(eu_reg_2022_2554_art_50_5))].
test(no_data_traffic_records_and_no_legal_person_gives_seven_powers) :-
    dora_penalties_profile_for(no_criminal_penalties_laid_down, Profile),
    minimum_powers(Profile, Powers),
    length(Powers, 7).
test(choice_absent_powers_name_the_choice_key) :-
    dora_penalties_profile_for(breach_criminal_choice_absent, Profile),
    minimum_powers(Profile, indeterminate([member_state_chose_no_administrative_rules_for_criminally_penalised_breaches])).
test(point_c_decision_gets_both_safeguards) :-
    dora_penalties_profile_for(option_not_used, Profile),
    penalty_decision_safeguards(Profile, [properly_reasoned(cite(eu_reg_2022_2554_art_50_6)), right_of_appeal(cite(eu_reg_2022_2554_art_50_6))]).
test(no_point_c_decision_gets_no_safeguard) :-
    dora_penalties_profile_for(no_criminal_penalties_laid_down, Profile),
    penalty_decision_safeguards(Profile, []).
test(settled_judgements_list_in_printed_order) :-
    dora_penalties_profile_for(option_not_used, Profile),
    circumstances_to_take_into_account(Profile, Circumstances),
    Circumstances == [circumstance(intent_or_negligence, cite(eu_reg_2022_2554_art_51_2)), circumstance(materiality_gravity_and_duration, cite(eu_reg_2022_2554_art_51_2_a)), circumstance(financial_strength, cite(eu_reg_2022_2554_art_51_2_c)), circumstance(cooperation_with_competent_authority, cite(eu_reg_2022_2554_art_51_2_f)), circumstance(previous_breaches, cite(eu_reg_2022_2554_art_51_2_g))].
test(every_judgement_true_lists_every_circumstance) :-
    Profile = [attribute(breach_materiality_gravity_duration_relevant, true), attribute(degree_of_responsibility_relevant, true), attribute(financial_strength_relevant, true), attribute(profits_gained_or_losses_avoided_relevant, true), attribute(third_party_losses_relevant, true), attribute(cooperation_with_authority_relevant, true), attribute(previous_breaches_relevant, true)],
    findall(Answer, circumstances_to_take_into_account(Profile, Answer), Answers),
    Answers == [[circumstance(intent_or_negligence, cite(eu_reg_2022_2554_art_51_2)), circumstance(materiality_gravity_and_duration, cite(eu_reg_2022_2554_art_51_2_a)), circumstance(degree_of_responsibility, cite(eu_reg_2022_2554_art_51_2_b)), circumstance(financial_strength, cite(eu_reg_2022_2554_art_51_2_c)), circumstance(profits_gained_or_losses_avoided, cite(eu_reg_2022_2554_art_51_2_d)), circumstance(losses_for_third_parties, cite(eu_reg_2022_2554_art_51_2_e)), circumstance(cooperation_with_competent_authority, cite(eu_reg_2022_2554_art_51_2_f)), circumstance(previous_breaches, cite(eu_reg_2022_2554_art_51_2_g))]].
test(unsure_judgement_is_referred) :-
    dora_penalties_profile_for(judgement_unsure, Profile),
    circumstances_to_take_into_account(Profile, Answer),
    Answer == needs_legal_review(open_textured(degree_of_responsibility_relevant, cite(eu_reg_2022_2554_art_51_2_b)), [inputs_relied_on([breach_materiality_gravity_duration_relevant - true, degree_of_responsibility_relevant - unsure, financial_strength_relevant - true, profits_gained_or_losses_avoided_relevant - false, third_party_losses_relevant - false, cooperation_with_authority_relevant - true, previous_breaches_relevant - true])]).
test(referral_context_opens_with_inputs_relied_on) :-
    dora_penalties_profile_for(judgement_unsure, Profile),
    circumstances_to_take_into_account(Profile, needs_legal_review(_, [inputs_relied_on(_)|Optional])),
    Optional == [].
test(criminal_penalties_laid_down_give_both_duties) :-
    dora_penalties_profile_for(option_used, Profile),
    criminal_penalty_liaison_duties(Profile, [receive_criminal_proceedings_information(cite(eu_reg_2022_2554_art_52_2)), provide_information_to_authorities_and_esas(cite(eu_reg_2022_2554_art_52_2))]).
test(no_criminal_penalties_laid_down_give_no_duty) :-
    dora_penalties_profile_for(no_criminal_penalties_laid_down, Profile),
    criminal_penalty_liaison_duties(Profile, []).
test(checklist_first_item_carries_its_citation) :-
    dora_penalties_profile_for(option_used, Profile),
    dora_penalties_checklist(Profile, [item(administrative_penalty_rules_required, not_required_criminal_penalties, [cite(eu_reg_2022_2554_art_52_1)])|_]).
test(verdict_carries_citations) :-
    dora_penalties_profile_for(option_not_used, Profile),
    decide_dora_penalties(Profile, dora_penalties_verdict(required, [_|_])).
test(what_if_option_chosen_flips_to_not_required) :-
    dora_penalties_profile_for(option_not_used, Profile),
    dora_penalties_what_if(Profile, member_state_chose_no_administrative_rules_for_criminally_penalised_breaches, true, not_required_criminal_penalties).
test(what_if_option_dropped_flips_to_required) :-
    dora_penalties_profile_for(option_used, Profile),
    dora_penalties_what_if(Profile, member_state_chose_no_administrative_rules_for_criminally_penalised_breaches, false, required).

test(option_used_is_not_required_status, fail) :-
    dora_penalties_profile_for(option_used, Profile),
    dora_penalties_status(Profile, required).
test(option_not_used_is_not_the_option_status, fail) :-
    dora_penalties_profile_for(option_not_used, Profile),
    dora_penalties_status(Profile, not_required_criminal_penalties).
test(breach_not_criminally_penalised_ignores_the_choice, fail) :-
    dora_penalties_profile_for(breach_not_criminally_penalised, Profile),
    dora_penalties_status(Profile, not_required_criminal_penalties).
test(choice_absent_is_not_final, fail) :-
    dora_penalties_profile_for(breach_criminal_choice_absent, Profile),
    dora_penalties_status(Profile, required).
test(breach_key_absent_is_not_the_option_status, fail) :-
    dora_penalties_profile_for(breach_key_absent, Profile),
    dora_penalties_status(Profile, not_required_criminal_penalties).
test(a_problem_profile_gets_no_final_status, fail) :-
    dora_penalties_profile_for(unknown_key_given, Profile),
    dora_penalties_status(Profile, not_required_criminal_penalties).
test(no_data_traffic_records_omits_point_d, fail) :-
    dora_penalties_profile_for(no_criminal_penalties_laid_down, Profile),
    minimum_powers(Profile, Powers),
    member(power(penalty, require_data_traffic_records, _), Powers).
test(points_b_d_e_false_are_not_listed, fail) :-
    dora_penalties_profile_for(option_not_used, Profile),
    circumstances_to_take_into_account(Profile, Circumstances),
    member(circumstance(Atom, _), Circumstances),
    member(Atom, [degree_of_responsibility, profits_gained_or_losses_avoided, losses_for_third_parties]).
test(unsure_judgement_is_not_a_final_list, fail) :-
    dora_penalties_profile_for(judgement_unsure, Profile),
    circumstances_to_take_into_account(Profile, [_|_]).
test(referral_context_carries_no_provenance_item, fail) :-
    dora_penalties_profile_for(judgement_unsure, Profile),
    circumstances_to_take_into_account(Profile, needs_legal_review(_, Context)),
    member(provenance(_, _), Context).
test(what_if_option_dropped_is_not_still_not_required, fail) :-
    dora_penalties_profile_for(option_used, Profile),
    dora_penalties_what_if(Profile, member_state_chose_no_administrative_rules_for_criminally_penalised_breaches, false, not_required_criminal_penalties).

cp_test_names([every_subject_resolves_to_its_expected_status, every_subject_has_a_non_empty_checklist, every_query_answers_exactly_once_for_every_subject, option_used_is_not_required_with_its_citation, option_not_used_is_required_citing_both, breach_not_criminally_penalised_is_required_citing_art_50_3, choice_absent_names_the_choice_key, breach_key_absent_names_the_breach_key, unsure_on_a_fact_key_is_wrong_type, duplicate_key_is_reported_once, unknown_key_is_reported, well_formed_fixture_has_no_problem, not_a_list_is_wrong_type_profile, option_used_keeps_supervisory_powers_and_extension_only, option_not_used_lists_every_power, no_data_traffic_records_and_no_legal_person_gives_seven_powers, choice_absent_powers_name_the_choice_key, point_c_decision_gets_both_safeguards, no_point_c_decision_gets_no_safeguard, settled_judgements_list_in_printed_order, every_judgement_true_lists_every_circumstance, unsure_judgement_is_referred, referral_context_opens_with_inputs_relied_on, criminal_penalties_laid_down_give_both_duties, no_criminal_penalties_laid_down_give_no_duty, checklist_first_item_carries_its_citation, verdict_carries_citations, what_if_option_chosen_flips_to_not_required, what_if_option_dropped_flips_to_required]).
cp_test_fail_names([option_used_is_not_required_status, option_not_used_is_not_the_option_status, breach_not_criminally_penalised_ignores_the_choice, choice_absent_is_not_final, breach_key_absent_is_not_the_option_status, a_problem_profile_gets_no_final_status, no_data_traffic_records_omits_point_d, points_b_d_e_false_are_not_listed, unsure_judgement_is_not_a_final_list, referral_context_carries_no_provenance_item, what_if_option_dropped_is_not_still_not_required]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
