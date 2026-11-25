% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_penalties_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_penalties_dora_penalties, [administrative_penalty_rules_required/3, minimum_powers/2, penalty_decision_safeguards/2, circumstances_to_take_into_account/2, criminal_penalty_liaison_duties/2, decide_dora_penalties/2, dora_penalties_status/2]).
:- use_module(m__eu_dora_penalties_fixtures, [dora_penalties_profile_for/2]).

all_supervisory([power(supervisory, access_to_documents_and_data, cite(eu_reg_2022_2554_art_50_2_a)), power(supervisory, on_site_inspections_and_investigations, cite(eu_reg_2022_2554_art_50_2_b)), power(supervisory, require_corrective_and_remedial_measures, cite(eu_reg_2022_2554_art_50_2_c))]).

test(rules_option_used) :-
    dora_penalties_profile_for(option_used, Profile),
    findall(Result - Citations, administrative_penalty_rules_required(Profile, Result, Citations), Answers),
    Answers == [not_required_criminal_penalties - [cite(eu_reg_2022_2554_art_52_1)]].
test(rules_option_not_used) :-
    dora_penalties_profile_for(option_not_used, Profile),
    findall(Result - Citations, administrative_penalty_rules_required(Profile, Result, Citations), Answers),
    Answers == [required - [cite(eu_reg_2022_2554_art_50_3), cite(eu_reg_2022_2554_art_52_1)]].
test(rules_breach_not_criminally_penalised) :-
    dora_penalties_profile_for(breach_not_criminally_penalised, Profile),
    findall(Result - Citations, administrative_penalty_rules_required(Profile, Result, Citations), Answers),
    Answers == [required - [cite(eu_reg_2022_2554_art_50_3)]].
test(rules_choice_absent) :-
    dora_penalties_profile_for(breach_criminal_choice_absent, Profile),
    findall(Result - Citations, administrative_penalty_rules_required(Profile, Result, Citations), Answers),
    Answers == [indeterminate([member_state_chose_no_administrative_rules_for_criminally_penalised_breaches]) - []].
test(rules_breach_key_absent) :-
    dora_penalties_profile_for(breach_key_absent, Profile),
    findall(Result - Citations, administrative_penalty_rules_required(Profile, Result, Citations), Answers),
    Answers == [indeterminate([breach_subject_to_criminal_penalties_under_national_law]) - []].
test(rules_duplicate_key) :-
    dora_penalties_profile_for(duplicate_breach_key, Profile),
    findall(Result - Citations, administrative_penalty_rules_required(Profile, Result, Citations), Answers),
    Answers == [input_problems([duplicate_key(breach_subject_to_criminal_penalties_under_national_law)]) - []].
test(rules_fact_key_unsure) :-
    dora_penalties_profile_for(fact_key_unsure, Profile),
    findall(Result - Citations, administrative_penalty_rules_required(Profile, Result, Citations), Answers),
    Answers == [input_problems([wrong_type(breach_subject_to_criminal_penalties_under_national_law)]) - []].
test(rules_unknown_key) :-
    dora_penalties_profile_for(unknown_key_given, Profile),
    findall(Result - Citations, administrative_penalty_rules_required(Profile, Result, Citations), Answers),
    Answers == [input_problems([unknown_key(colour)]) - []].
test(powers_option_used) :-
    dora_penalties_profile_for(option_used, Profile),
    findall(Powers, minimum_powers(Profile, Powers), Answers),
    all_supervisory(Supervisory),
    append(Supervisory, [power(extension, management_body_and_responsible_individuals, cite(eu_reg_2022_2554_art_50_5))], Expected),
    Answers == [Expected].
test(powers_option_not_used_full_list) :-
    dora_penalties_profile_for(option_not_used, Profile),
    findall(Powers, minimum_powers(Profile, Powers), Answers),
    all_supervisory(Supervisory),
    append(Supervisory, [power(penalty, cease_and_desist_order, cite(eu_reg_2022_2554_art_50_4_a)), power(penalty, cessation_of_practice_or_conduct, cite(eu_reg_2022_2554_art_50_4_b)), power(penalty, measures_to_ensure_continued_compliance, cite(eu_reg_2022_2554_art_50_4_c)), power(penalty, require_data_traffic_records, cite(eu_reg_2022_2554_art_50_4_d)), power(penalty, public_notice, cite(eu_reg_2022_2554_art_50_4_e)), power(extension, management_body_and_responsible_individuals, cite(eu_reg_2022_2554_art_50_5))], Expected),
    Answers == [Expected].
test(powers_short_list) :-
    dora_penalties_profile_for(no_criminal_penalties_laid_down, Profile),
    findall(Powers, minimum_powers(Profile, Powers), Answers),
    all_supervisory(Supervisory),
    append(Supervisory, [power(penalty, cease_and_desist_order, cite(eu_reg_2022_2554_art_50_4_a)), power(penalty, cessation_of_practice_or_conduct, cite(eu_reg_2022_2554_art_50_4_b)), power(penalty, measures_to_ensure_continued_compliance, cite(eu_reg_2022_2554_art_50_4_c)), power(penalty, public_notice, cite(eu_reg_2022_2554_art_50_4_e))], Expected),
    Answers == [Expected].
test(powers_breach_key_absent) :-
    dora_penalties_profile_for(breach_key_absent, Profile),
    findall(Powers, minimum_powers(Profile, Powers), Answers),
    Answers == [indeterminate([breach_subject_to_criminal_penalties_under_national_law])].
test(powers_choice_absent) :-
    dora_penalties_profile_for(breach_criminal_choice_absent, Profile),
    findall(Powers, minimum_powers(Profile, Powers), Answers),
    Answers == [indeterminate([member_state_chose_no_administrative_rules_for_criminally_penalised_breaches])].
test(powers_choice_false_with_breach_absent) :-
    findall(Powers, minimum_powers([attribute(member_state_chose_no_administrative_rules_for_criminally_penalised_breaches, false), attribute(national_law_permits_requiring_data_traffic_records, true)], Powers), Answers),
    Answers == [indeterminate([measures_applied_to_legal_person])].
test(powers_option_applies_data_traffic_not_read) :-
    findall(Powers, minimum_powers([attribute(breach_subject_to_criminal_penalties_under_national_law, true), attribute(member_state_chose_no_administrative_rules_for_criminally_penalised_breaches, true)], Powers), Answers),
    Answers == [indeterminate([measures_applied_to_legal_person])].
test(safeguards_point_c_decision) :-
    dora_penalties_profile_for(option_not_used, Profile),
    findall(Safeguards, penalty_decision_safeguards(Profile, Safeguards), Answers),
    Answers == [[properly_reasoned(cite(eu_reg_2022_2554_art_50_6)), right_of_appeal(cite(eu_reg_2022_2554_art_50_6))]].
test(safeguards_none) :-
    dora_penalties_profile_for(no_criminal_penalties_laid_down, Profile),
    findall(Safeguards, penalty_decision_safeguards(Profile, Safeguards), Answers),
    Answers == [[]].
test(circumstances_settled) :-
    dora_penalties_profile_for(option_used, Profile),
    findall(Circumstances, circumstances_to_take_into_account(Profile, Circumstances), Answers),
    Answers == [[circumstance(intent_or_negligence, cite(eu_reg_2022_2554_art_51_2)), circumstance(materiality_gravity_and_duration, cite(eu_reg_2022_2554_art_51_2_a)), circumstance(financial_strength, cite(eu_reg_2022_2554_art_51_2_c)), circumstance(cooperation_with_competent_authority, cite(eu_reg_2022_2554_art_51_2_f)), circumstance(previous_breaches, cite(eu_reg_2022_2554_art_51_2_g))]].
test(circumstances_referred) :-
    dora_penalties_profile_for(judgement_unsure, Profile),
    findall(Circumstances, circumstances_to_take_into_account(Profile, Circumstances), Answers),
    Answers == [needs_legal_review(open_textured(degree_of_responsibility_relevant, cite(eu_reg_2022_2554_art_51_2_b)), [inputs_relied_on([breach_materiality_gravity_duration_relevant - true, degree_of_responsibility_relevant - unsure, financial_strength_relevant - true, profits_gained_or_losses_avoided_relevant - false, third_party_losses_relevant - false, cooperation_with_authority_relevant - true, previous_breaches_relevant - true])])].
test(circumstances_only_intent_when_all_false) :-
    findall(Circumstances, circumstances_to_take_into_account([attribute(breach_materiality_gravity_duration_relevant, false), attribute(degree_of_responsibility_relevant, false), attribute(financial_strength_relevant, false), attribute(profits_gained_or_losses_avoided_relevant, false), attribute(third_party_losses_relevant, false), attribute(cooperation_with_authority_relevant, false), attribute(previous_breaches_relevant, false)], Circumstances), Answers),
    Answers == [[circumstance(intent_or_negligence, cite(eu_reg_2022_2554_art_51_2))]].
test(circumstances_absent_after_unsure_is_named) :-
    findall(Circumstances, circumstances_to_take_into_account([attribute(breach_materiality_gravity_duration_relevant, unsure), attribute(degree_of_responsibility_relevant, true), attribute(financial_strength_relevant, true), attribute(profits_gained_or_losses_avoided_relevant, true), attribute(third_party_losses_relevant, true), attribute(cooperation_with_authority_relevant, true)], Circumstances), Answers),
    Answers == [indeterminate([previous_breaches_relevant])].
test(duties_laid_down) :-
    dora_penalties_profile_for(option_used, Profile),
    findall(Duties, criminal_penalty_liaison_duties(Profile, Duties), Answers),
    Answers == [[receive_criminal_proceedings_information(cite(eu_reg_2022_2554_art_52_2)), provide_information_to_authorities_and_esas(cite(eu_reg_2022_2554_art_52_2))]].
test(duties_none) :-
    dora_penalties_profile_for(no_criminal_penalties_laid_down, Profile),
    findall(Duties, criminal_penalty_liaison_duties(Profile, Duties), Answers),
    Answers == [[]].
test(duties_absent) :-
    findall(Duties, criminal_penalty_liaison_duties([], Duties), Answers),
    Answers == [indeterminate([member_state_laid_down_criminal_penalties_for_breaches])].
test(verdict_option_used_carries_its_citation) :-
    dora_penalties_profile_for(option_used, Profile),
    findall(Verdict, decide_dora_penalties(Profile, Verdict), Answers),
    Answers == [dora_penalties_verdict(not_required_criminal_penalties, [cite(eu_reg_2022_2554_art_52_1)])].
test(status_judgement_unsure_is_required) :-
    dora_penalties_profile_for(judgement_unsure, Profile),
    findall(Status, dora_penalties_status(Profile, Status), Statuses),
    Statuses == [required].

cp_test_names([rules_option_used, rules_option_not_used, rules_breach_not_criminally_penalised, rules_choice_absent, rules_breach_key_absent, rules_duplicate_key, rules_fact_key_unsure, rules_unknown_key, powers_option_used, powers_option_not_used_full_list, powers_short_list, powers_breach_key_absent, powers_choice_absent, powers_choice_false_with_breach_absent, powers_option_applies_data_traffic_not_read, safeguards_point_c_decision, safeguards_none, circumstances_settled, circumstances_referred, circumstances_only_intent_when_all_false, circumstances_absent_after_unsure_is_named, duties_laid_down, duties_none, duties_absent, verdict_option_used_carries_its_citation, status_judgement_unsure_is_required]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
