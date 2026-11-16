% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_provider_side_duties_provider_side_duties, [operator_duty_status/5, retention_period_end/4, decide_provider_side_duties/2, provider_side_duties_status/2, provider_side_duties_checklist/2, provider_side_duties_decision_resolvable/1, provider_side_duties_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [tfilter/3]).
:- use_module(library(clpz)).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(formalize_lib, [profile_get/3, profile_lacks/2]).
:- use_module(m__eu_ai_act_provider_side_duties_kernel, [provider_side_duties_input_problems/2, provider_side_duties_calendar_date_t/2, provider_side_duties_month_length/3, provider_side_duties_date_before_t/3]).
:- use_module(m__eu_ai_act_provider_side_duties_citations, [implements/1]).

provider_side_duties_status_values([not_applicable_on_date, earlier_text_not_formalised, not_an_ai_system, not_a_high_risk_ai_system, not_the_addressee_of_the_duty, compliance_required_by_31_december_2030, compliance_required_by_2_august_2030, system_already_placed_without_significant_change, duty_not_triggered, duty_applies]).

application_date(chapter_i, date(2025, 2, 2), cite(eu_reg_2024_1689_art_113_a)).
application_date(chapter_iii_annex_iii, date(2027, 12, 2), cite(eu_reg_2024_1689_art_113_c_i)).
application_date(chapter_iii_annex_i, date(2028, 8, 2), cite(eu_reg_2024_1689_art_113_c_ii)).

pinned_text_date(date(2026, 7, 27), cite(eu_reg_2024_1689_art_113_a)).

compliance_day(large_scale_it_system, date(2030, 12, 31), cite(eu_reg_2024_1689_art_111_1)).
compliance_day(public_authorities, date(2030, 8, 2), cite(eu_reg_2024_1689_art_111_2)).

retention_period(documentation_keeping, period(10, years), cite(eu_reg_2024_1689_art_18_1)).
retention_period(keeping_of_the_provider_contact_details_and_documents, period(10, years), cite(eu_reg_2024_1689_art_22_3_b)).
retention_period(importer_keeping_of_copies, period(10, years), cite(eu_reg_2024_1689_art_23_5)).
retention_period(log_keeping, period(6, months), cite(eu_reg_2024_1689_art_19_1)).

role_citation(provider, cite(eu_reg_2024_1689_art_3_3)).
role_citation(authorised_representative, cite(eu_reg_2024_1689_art_3_5)).
role_citation(importer, cite(eu_reg_2024_1689_art_3_6)).
role_citation(distributor, cite(eu_reg_2024_1689_art_3_7)).

duty_row(compliance_with_the_requirements_of_section_2, provider, always, [cite(eu_reg_2024_1689_art_16_a)]).
duty_row(provider_name_and_contact_address, provider, always, [cite(eu_reg_2024_1689_art_16_b)]).
duty_row(quality_management_system, provider, always, [cite(eu_reg_2024_1689_art_16_c)]).
duty_row(documentation_keeping, provider, always, [cite(eu_reg_2024_1689_art_16_d), cite(eu_reg_2024_1689_art_18_1), cite(eu_reg_2024_1689_art_18_1_a), cite(eu_reg_2024_1689_art_18_1_b), cite(eu_reg_2024_1689_art_18_1_c), cite(eu_reg_2024_1689_art_18_1_d), cite(eu_reg_2024_1689_art_18_1_e)]).
duty_row(log_keeping, provider, key_true(logs_under_the_providers_control), [cite(eu_reg_2024_1689_art_16_e), cite(eu_reg_2024_1689_art_19_1)]).
duty_row(conformity_assessment_before_placing_on_the_market, provider, always, [cite(eu_reg_2024_1689_art_16_f)]).
duty_row(eu_declaration_of_conformity, provider, always, [cite(eu_reg_2024_1689_art_16_g)]).
duty_row(ce_marking, provider, always, [cite(eu_reg_2024_1689_art_16_h)]).
duty_row(registration, provider, always, [cite(eu_reg_2024_1689_art_16_i)]).
duty_row(corrective_actions_and_information, provider, key_true(provider_considers_or_has_reason_to_consider_the_system_not_in_conformity), [cite(eu_reg_2024_1689_art_16_j), cite(eu_reg_2024_1689_art_20_1)]).
duty_row(investigation_and_information_on_a_risk, provider, both(presents_a_risk_within_the_meaning_of_article_79_1, provider_aware_of_the_risk), [cite(eu_reg_2024_1689_art_16_j), cite(eu_reg_2024_1689_art_20_2)]).
duty_row(demonstration_of_conformity_on_request, provider, key_true(reasoned_request_from_a_competent_authority), [cite(eu_reg_2024_1689_art_16_k), cite(eu_reg_2024_1689_art_21_1)]).
duty_row(access_to_logs_on_request, provider, both(reasoned_request_from_a_competent_authority, logs_under_the_providers_control), [cite(eu_reg_2024_1689_art_21_2)]).
duty_row(accessibility_requirements, provider, always, [cite(eu_reg_2024_1689_art_16_l)]).
duty_row(appointment_of_an_authorised_representative, provider, key_true(provider_established_in_a_third_country), [cite(eu_reg_2024_1689_art_22_1)]).
duty_row(enabling_the_authorised_representative, provider, key_true(provider_established_in_a_third_country), [cite(eu_reg_2024_1689_art_22_2)]).
duty_row(performance_of_the_mandate_tasks, authorised_representative, always, [cite(eu_reg_2024_1689_art_22_3)]).
duty_row(copy_of_the_mandate_on_request, authorised_representative, key_true(request_from_a_market_surveillance_authority_for_a_copy_of_the_mandate), [cite(eu_reg_2024_1689_art_22_3)]).
duty_row(verification_of_the_declaration_documentation_and_conformity_assessment, authorised_representative, always, [cite(eu_reg_2024_1689_art_22_3), cite(eu_reg_2024_1689_art_22_3_a)]).
duty_row(keeping_of_the_provider_contact_details_and_documents, authorised_representative, always, [cite(eu_reg_2024_1689_art_22_3), cite(eu_reg_2024_1689_art_22_3_b)]).
duty_row(representative_information_on_request, authorised_representative, key_true(reasoned_request_from_a_competent_authority), [cite(eu_reg_2024_1689_art_22_3), cite(eu_reg_2024_1689_art_22_3_c)]).
duty_row(representative_cooperation_with_authorities, authorised_representative, both(reasoned_request_from_a_competent_authority, competent_authority_action_in_relation_to_the_system), [cite(eu_reg_2024_1689_art_22_3), cite(eu_reg_2024_1689_art_22_3_d)]).
duty_row(representative_registration, authorised_representative, always, [cite(eu_reg_2024_1689_art_22_3), cite(eu_reg_2024_1689_art_22_3_e)]).
duty_row(termination_of_the_mandate, authorised_representative, key_true(representative_considers_or_has_reason_to_consider_the_provider_acting_contrary_to_its_obligations), [cite(eu_reg_2024_1689_art_22_4)]).
duty_row(importer_verification_before_placing_on_the_market, importer, always, [cite(eu_reg_2024_1689_art_23_1), cite(eu_reg_2024_1689_art_23_1_a), cite(eu_reg_2024_1689_art_23_1_b), cite(eu_reg_2024_1689_art_23_1_c), cite(eu_reg_2024_1689_art_23_1_d)]).
duty_row(importer_withholding_of_a_non_conforming_system, importer, key_true(importer_has_sufficient_reason_to_consider_the_system_not_in_conformity_or_falsified), [cite(eu_reg_2024_1689_art_23_2)]).
duty_row(importer_information_on_a_risk, importer, key_true(presents_a_risk_within_the_meaning_of_article_79_1), [cite(eu_reg_2024_1689_art_23_2)]).
duty_row(importer_name_and_contact_address, importer, always, [cite(eu_reg_2024_1689_art_23_3)]).
duty_row(importer_storage_and_transport_conditions, importer, key_true(system_under_the_operators_responsibility), [cite(eu_reg_2024_1689_art_23_4)]).
duty_row(importer_keeping_of_copies, importer, always, [cite(eu_reg_2024_1689_art_23_5)]).
duty_row(importer_information_on_request, importer, key_true(reasoned_request_from_a_competent_authority), [cite(eu_reg_2024_1689_art_23_6)]).
duty_row(importer_cooperation_with_authorities, importer, key_true(competent_authority_action_in_relation_to_the_system), [cite(eu_reg_2024_1689_art_23_7)]).
duty_row(distributor_verification_before_making_available, distributor, always, [cite(eu_reg_2024_1689_art_24_1)]).
duty_row(distributor_withholding_of_a_non_conforming_system, distributor, key_true(distributor_considers_or_has_reason_to_consider_the_system_not_in_conformity), [cite(eu_reg_2024_1689_art_24_2)]).
duty_row(distributor_information_on_a_risk, distributor, key_true(presents_a_risk_within_the_meaning_of_article_79_1), [cite(eu_reg_2024_1689_art_24_2), cite(eu_reg_2024_1689_art_24_4)]).
duty_row(distributor_storage_and_transport_conditions, distributor, key_true(system_under_the_operators_responsibility), [cite(eu_reg_2024_1689_art_24_3)]).
duty_row(distributor_corrective_actions, distributor, both(distributor_considers_or_has_reason_to_consider_the_system_not_in_conformity, distributor_has_made_the_system_available_on_the_market), [cite(eu_reg_2024_1689_art_24_4)]).
duty_row(distributor_information_on_request, distributor, key_true(reasoned_request_from_a_competent_authority), [cite(eu_reg_2024_1689_art_24_5)]).
duty_row(distributor_cooperation_with_authorities, distributor, key_true(competent_authority_action_in_relation_to_the_system), [cite(eu_reg_2024_1689_art_24_6)]).

referral_row(ai_system, _, cite(eu_reg_2024_1689_art_3_1)).
referral_row(significant_change_in_design_as_from_the_date_of_application_of_chapter_iii, _, cite(eu_reg_2024_1689_art_111_2)).
referral_row(intended_to_be_used_by_public_authorities, _, cite(eu_reg_2024_1689_art_111_2)).
referral_row(provider_considers_or_has_reason_to_consider_the_system_not_in_conformity, _, cite(eu_reg_2024_1689_art_20_1)).
referral_row(presents_a_risk_within_the_meaning_of_article_79_1, investigation_and_information_on_a_risk, cite(eu_reg_2024_1689_art_20_2)).
referral_row(presents_a_risk_within_the_meaning_of_article_79_1, importer_information_on_a_risk, cite(eu_reg_2024_1689_art_23_2)).
referral_row(presents_a_risk_within_the_meaning_of_article_79_1, distributor_information_on_a_risk, cite(eu_reg_2024_1689_art_24_2)).
referral_row(representative_considers_or_has_reason_to_consider_the_provider_acting_contrary_to_its_obligations, _, cite(eu_reg_2024_1689_art_22_4)).
referral_row(importer_has_sufficient_reason_to_consider_the_system_not_in_conformity_or_falsified, _, cite(eu_reg_2024_1689_art_23_2)).
referral_row(distributor_considers_or_has_reason_to_consider_the_system_not_in_conformity, distributor_withholding_of_a_non_conforming_system, cite(eu_reg_2024_1689_art_24_2)).
referral_row(distributor_considers_or_has_reason_to_consider_the_system_not_in_conformity, distributor_corrective_actions, cite(eu_reg_2024_1689_art_24_4)).

decision_order_keys([ai_system, high_risk_ai_system, high_risk_route, actor_role, component_of_a_large_scale_it_system_listed_in_annex_x, placed_on_the_market_or_put_into_service_before_2_august_2027, placed_on_the_market_or_put_into_service_before_the_date_of_application_of_chapter_iii, significant_change_in_design_as_from_the_date_of_application_of_chapter_iii, intended_to_be_used_by_public_authorities, provider_established_in_a_third_country, logs_under_the_providers_control, reasoned_request_from_a_competent_authority, request_from_a_market_surveillance_authority_for_a_copy_of_the_mandate, competent_authority_action_in_relation_to_the_system, system_under_the_operators_responsibility, provider_considers_or_has_reason_to_consider_the_system_not_in_conformity, presents_a_risk_within_the_meaning_of_article_79_1, provider_aware_of_the_risk, representative_considers_or_has_reason_to_consider_the_provider_acting_contrary_to_its_obligations, importer_has_sufficient_reason_to_consider_the_system_not_in_conformity_or_falsified, distributor_considers_or_has_reason_to_consider_the_system_not_in_conformity, distributor_has_made_the_system_available_on_the_market]).

judgement_keys([ai_system, significant_change_in_design_as_from_the_date_of_application_of_chapter_iii, intended_to_be_used_by_public_authorities, provider_considers_or_has_reason_to_consider_the_system_not_in_conformity, presents_a_risk_within_the_meaning_of_article_79_1, representative_considers_or_has_reason_to_consider_the_provider_acting_contrary_to_its_obligations, importer_has_sufficient_reason_to_consider_the_system_not_in_conformity_or_falsified, distributor_considers_or_has_reason_to_consider_the_system_not_in_conformity]).

chapter_three_base_keys([high_risk_ai_system, high_risk_route, actor_role, component_of_a_large_scale_it_system_listed_in_annex_x, placed_on_the_market_or_put_into_service_before_2_august_2027, placed_on_the_market_or_put_into_service_before_the_date_of_application_of_chapter_iii, significant_change_in_design_as_from_the_date_of_application_of_chapter_iii]).

public_authority_keys(provider, [intended_to_be_used_by_public_authorities]).
public_authority_keys(authorised_representative, []).
public_authority_keys(importer, []).
public_authority_keys(distributor, []).

condition_keys(always, []).
condition_keys(key_true(Key), [Key]).
condition_keys(both(FirstKey, SecondKey), [FirstKey, SecondKey]).

chapter_three_date_citations([cite(eu_reg_2024_1689_art_113_c), cite(eu_reg_2024_1689_art_113_c_i), cite(eu_reg_2024_1689_art_113_c_ii)]).

truth_and(true, Truth, Truth).
truth_and(false, _, false).

truth_or(true, _, true).
truth_or(false, Truth, Truth).

truth_not(true, false).
truth_not(false, true).

same_atom_t(Value, Value, true).
same_atom_t(First, Second, false) :-
    dif(First, Second).

value_of(Assignment, Key, Value) :-
    member(Key - Value, Assignment).

operator_duty_status(Profile, Duty, AssessmentDate, Result, Citations) :-
    provider_side_duties_input_problems(Profile, ProfileProblems),
    duty_problems(Duty, DutyProblems),
    date_problems(AssessmentDate, assessment_date, DateProblems),
    append([ProfileProblems, DutyProblems, DateProblems], Problems),
    duty_status_answer(Problems, Profile, Duty, AssessmentDate, Result, Citations).

duty_status_answer([], Profile, Duty, AssessmentDate, Result, Citations) :-
    determine_duty_status(Profile, Duty, AssessmentDate, Result, Citations).
duty_status_answer([Problem|Problems], _, _, _, input_problems([Problem|Problems]), []).

all_duty_atoms([ai_literacy_measures|Duties]) :-
    findall(Duty, duty_row(Duty, _, _, _), Duties).

duty_problems(Duty, Problems) :-
    duty_atom_t(Duty, IsDuty),
    duty_problem_list(IsDuty, Problems).

duty_atom_t(Duty, false) :-
    var(Duty).
duty_atom_t(Duty, IsDuty) :-
    nonvar(Duty),
    all_duty_atoms(Duties),
    memberd_t(Duty, Duties, IsDuty).

duty_problem_list(true, []).
duty_problem_list(false, [wrong_type(duty)]).

date_problems(Date, Name, Problems) :-
    provider_side_duties_calendar_date_t(Date, IsDate),
    date_problem_list(IsDate, Name, Problems).

date_problem_list(true, _, []).
date_problem_list(false, Name, [wrong_type(Name)]).

determine_duty_status(Profile, Duty, AssessmentDate, Result, Citations) :-
    duty_relevant_keys(Duty, Keys),
    domain_addressee(Duty, Addressee),
    split_keys(Keys, Profile, Addressee, FreeKeys, FixedAssignment),
    build_tree(FreeKeys, FixedAssignment, Duty, AssessmentDate, Tree),
    findall(Answer, leaf_answer(Tree, Answer), Answers),
    sort(Answers, DistinctAnswers),
    settle(DistinctAnswers, Tree, FreeKeys, Profile, Duty, Result, Citations).

duty_relevant_keys(ai_literacy_measures, Keys) :-
    order_keys([ai_system, actor_role], Keys).
duty_relevant_keys(Duty, Keys) :-
    duty_row(Duty, Addressee, Condition, _),
    chapter_three_base_keys(BaseKeys),
    public_authority_keys(Addressee, PublicKeys),
    condition_keys(Condition, ConditionKeys),
    append([BaseKeys, PublicKeys, ConditionKeys], KeySet),
    order_keys(KeySet, Keys).

order_keys(KeySet, Keys) :-
    decision_order_keys(Order),
    tfilter(key_in_set_t(KeySet), Order, Keys).

key_in_set_t(KeySet, Key, Truth) :-
    memberd_t(Key, KeySet, Truth).

domain_addressee(ai_literacy_measures, provider).
domain_addressee(Duty, Addressee) :-
    duty_row(Duty, Addressee, _, _).

key_state(Profile, Key, absent) :-
    profile_lacks(Profile, Key).
key_state(Profile, Key, State) :-
    profile_get(Profile, Key, Value),
    present_state(Value, State).

present_state(unsure, unsure).
present_state(Value, given(Value)) :-
    dif(Value, unsure).

key_domain(actor_role, Addressee, [Addressee, affected_person]).
key_domain(high_risk_route, _, [annex_iii, annex_i]).
key_domain(Key, _, [true, false]) :-
    dif(Key, actor_role),
    dif(Key, high_risk_route).

split_keys([], _, _, [], []).
split_keys([Key|Keys], Profile, Addressee, FreeKeys, FixedAssignment) :-
    key_state(Profile, Key, State),
    split_keys(Keys, Profile, Addressee, LaterFreeKeys, LaterFixed),
    place_key(State, Key, Addressee, LaterFreeKeys, LaterFixed, FreeKeys, FixedAssignment).

place_key(absent, Key, Addressee, LaterFreeKeys, LaterFixed, [free_key(Key, Domain, absent)|LaterFreeKeys], LaterFixed) :-
    key_domain(Key, Addressee, Domain).
place_key(unsure, Key, Addressee, LaterFreeKeys, LaterFixed, [free_key(Key, Domain, unsure)|LaterFreeKeys], LaterFixed) :-
    key_domain(Key, Addressee, Domain).
place_key(given(Value), Key, _, LaterFreeKeys, LaterFixed, LaterFreeKeys, [Key - Value|LaterFixed]).

build_tree([], Assignment, Duty, AssessmentDate, leaf(answer(Result, SortedCitations))) :-
    duty_ladder(Duty, AssessmentDate, Assignment, Result, Citations),
    sort(Citations, SortedCitations).
build_tree([free_key(Key, [FirstValue, SecondValue], _)|FreeKeys], Assignment, Duty, AssessmentDate, node(FirstTree, SecondTree)) :-
    build_tree(FreeKeys, [Key - FirstValue|Assignment], Duty, AssessmentDate, FirstTree),
    build_tree(FreeKeys, [Key - SecondValue|Assignment], Duty, AssessmentDate, SecondTree).

leaf_answer(leaf(Answer), Answer).
leaf_answer(node(FirstTree, SecondTree), Answer) :-
    member(Subtree, [FirstTree, SecondTree]),
    leaf_answer(Subtree, Answer).

settle([answer(Result, Citations)], _, _, _, _, Result, Citations).
settle([_, _|_], Tree, FreeKeys, Profile, Duty, Result, []) :-
    key_witnesses_list(FreeKeys, Tree, 0, Witnessed),
    tfilter(absent_mattering_t, Witnessed, MissingCandidates),
    unsettled_answer(MissingCandidates, Witnessed, Profile, Duty, Result).

unsettled_answer([First|Rest], _, _, _, indeterminate([Key])) :-
    pick_missing([First|Rest], [First|Rest], Key).
unsettled_answer([], Witnessed, Profile, Duty, needs_legal_review(open_textured(Judgement, Citation), [inputs_relied_on(Pairs)])) :-
    tfilter(unsure_mattering_t, Witnessed, [key_witnesses(Judgement, _, _, _)|_]),
    referral_row(Judgement, Duty, Citation),
    relied_pairs(Profile, Pairs).

key_witnesses_list([], _, _, []).
key_witnesses_list([free_key(Key, _, Kind)|FreeKeys], Tree, Index, [key_witnesses(Key, Kind, Index, Witnesses)|Witnessed]) :-
    findall(Context, witness(Tree, Index, 0, [], Context), Witnesses),
    NextIndex #= Index + 1,
    key_witnesses_list(FreeKeys, Tree, NextIndex, Witnessed).

witness(node(FirstTree, SecondTree), Index, Depth, ReversedPrefix, Context) :-
    Depth #< Index,
    member(Bit - Subtree, [0 - FirstTree, 1 - SecondTree]),
    NextDepth #= Depth + 1,
    witness(Subtree, Index, NextDepth, [Bit|ReversedPrefix], Context).
witness(node(FirstTree, SecondTree), Index, Depth, ReversedPrefix, Context) :-
    Depth #= Index,
    differing_leaves(FirstTree, SecondTree, Suffix),
    reverse(ReversedPrefix, Prefix),
    append(Prefix, [pivot|Suffix], Context).

differing_leaves(leaf(FirstAnswer), leaf(SecondAnswer), []) :-
    dif(FirstAnswer, SecondAnswer).
differing_leaves(node(FirstZero, FirstOne), node(SecondZero, SecondOne), [Bit|Bits]) :-
    member(Bit - FirstSubtree - SecondSubtree, [0 - FirstZero - SecondZero, 1 - FirstOne - SecondOne]),
    differing_leaves(FirstSubtree, SecondSubtree, Bits).

absent_mattering_t(key_witnesses(_, absent, _, [_|_]), true).
absent_mattering_t(key_witnesses(_, absent, _, []), false).
absent_mattering_t(key_witnesses(_, unsure, _, _), false).

unsure_mattering_t(key_witnesses(_, unsure, _, [_|_]), true).
unsure_mattering_t(key_witnesses(_, unsure, _, []), false).
unsure_mattering_t(key_witnesses(_, absent, _, _), false).

pick_missing([Candidate|Rest], AllCandidates, Key) :-
    behind_any_t(Candidate, AllCandidates, IsBehind),
    pick_by(IsBehind, Candidate, Rest, AllCandidates, Key).
pick_missing([], [key_witnesses(Key, _, _, _)|_], Key).

pick_by(false, key_witnesses(Key, _, _, _), _, _, Key).
pick_by(true, _, Rest, AllCandidates, Key) :-
    pick_missing(Rest, AllCandidates, Key).

behind_any_t(_, [], false).
behind_any_t(Candidate, [Other|Others], IsBehind) :-
    behind_pair_t(Candidate, Other, BehindThis),
    behind_any_t(Candidate, Others, BehindAnother),
    truth_or(BehindThis, BehindAnother, IsBehind).

behind_pair_t(key_witnesses(_, _, KeyIndex, KeyWitnesses), key_witnesses(_, _, OtherIndex, OtherWitnesses), IsBehind) :-
    same_atom_t(KeyIndex, OtherIndex, Same),
    behind_unless_same(Same, KeyIndex, KeyWitnesses, OtherIndex, OtherWitnesses, IsBehind).

behind_unless_same(true, _, _, _, _, false).
behind_unless_same(false, KeyIndex, KeyWitnesses, OtherIndex, OtherWitnesses, IsBehind) :-
    bits_at(KeyWitnesses, OtherIndex, OtherBits),
    bits_at(OtherWitnesses, KeyIndex, KeyBits),
    single_bit_t(OtherBits, OnlySome),
    both_bits_t(KeyBits, Every),
    truth_and(OnlySome, Every, IsBehind).

bits_at(Contexts, Index, Bits) :-
    findall(Bit, (member(Context, Contexts), nth0(Index, Context, Bit)), AllBits),
    sort(AllBits, Bits).

single_bit_t([_], true).
single_bit_t([], false).
single_bit_t([_, _|_], false).

both_bits_t([0, 1], true).
both_bits_t([0], false).
both_bits_t([1], false).
both_bits_t([], false).

relied_pairs(Profile, Pairs) :-
    judgement_keys(Judgements),
    relied_pairs_of(Judgements, Profile, Pairs).

relied_pairs_of([], _, []).
relied_pairs_of([Judgement|Judgements], Profile, Pairs) :-
    key_state(Profile, Judgement, State),
    relied_pairs_of(Judgements, Profile, LaterPairs),
    add_pair(State, Judgement, LaterPairs, Pairs).

add_pair(absent, _, Pairs, Pairs).
add_pair(unsure, Judgement, Pairs, [Judgement - unsure|Pairs]).
add_pair(given(Value), Judgement, Pairs, [Judgement - Value|Pairs]).

duty_ladder(ai_literacy_measures, AssessmentDate, Assignment, Result, Citations) :-
    article_four_steps(AssessmentDate, Assignment, Result, Citations).
duty_ladder(Duty, AssessmentDate, Assignment, Result, Citations) :-
    duty_row(Duty, Addressee, Condition, DutyCitations),
    chapter_three_steps(row(Addressee, Condition, DutyCitations), AssessmentDate, Assignment, Result, Citations).

article_four_steps(AssessmentDate, Assignment, Result, Citations) :-
    application_date(chapter_i, StartDate, _),
    provider_side_duties_date_before_t(AssessmentDate, StartDate, BeforeStart),
    article_four_date_step(BeforeStart, AssessmentDate, Assignment, Result, Citations).

article_four_date_step(true, _, _, not_applicable_on_date, [cite(eu_reg_2024_1689_art_113_a)]) :-
    implements(eu_reg_2024_1689_art_113_a).
article_four_date_step(false, AssessmentDate, Assignment, Result, Citations) :-
    implements(eu_reg_2024_1689_art_113_a),
    pinned_text_date(TextDate, _),
    provider_side_duties_date_before_t(AssessmentDate, TextDate, EarlierText),
    article_four_text_step(EarlierText, Assignment, Result, Citations).

article_four_text_step(true, _, earlier_text_not_formalised, [cite(eu_reg_2024_1689_art_113_a)]) :-
    implements(eu_reg_2024_1689_art_113_a).
article_four_text_step(false, Assignment, Result, Citations) :-
    implements(eu_reg_2024_1689_art_4_1),
    value_of(Assignment, actor_role, Role),
    memberd_t(Role, [provider, deployer], IsAddressee),
    article_four_addressee_step(IsAddressee, Assignment, Result, Citations).

article_four_addressee_step(false, _, not_the_addressee_of_the_duty, [cite(eu_reg_2024_1689_art_3_3), cite(eu_reg_2024_1689_art_3_4), cite(eu_reg_2024_1689_art_4_1)]) :-
    implements(eu_reg_2024_1689_art_4_1).
article_four_addressee_step(true, Assignment, Result, Citations) :-
    implements(eu_reg_2024_1689_art_3_1),
    value_of(Assignment, ai_system, IsArtificialIntelligenceSystem),
    article_four_system_step(IsArtificialIntelligenceSystem, Result, Citations).

article_four_system_step(false, not_an_ai_system, [cite(eu_reg_2024_1689_art_3_1), cite(eu_reg_2024_1689_art_4_1)]) :-
    implements(eu_reg_2024_1689_art_3_1).
article_four_system_step(true, duty_applies, [cite(eu_reg_2024_1689_art_4_1)]) :-
    implements(eu_reg_2024_1689_art_4_1).

chapter_three_steps(Row, AssessmentDate, Assignment, Result, Citations) :-
    application_date(chapter_iii_annex_iii, StartDate, _),
    provider_side_duties_date_before_t(AssessmentDate, StartDate, BeforeStart),
    chapter_three_date_step(BeforeStart, Row, AssessmentDate, Assignment, Result, Citations).

chapter_three_date_step(true, _, _, _, not_applicable_on_date, Citations) :-
    implements(eu_reg_2024_1689_art_113_c),
    chapter_three_date_citations(Citations).
chapter_three_date_step(false, Row, AssessmentDate, Assignment, Result, Citations) :-
    implements(eu_reg_2024_1689_art_113_c),
    value_of(Assignment, high_risk_ai_system, HighRisk),
    high_risk_step(HighRisk, Row, AssessmentDate, Assignment, Result, Citations).

high_risk_step(false, row(_, _, DutyCitations), _, _, not_a_high_risk_ai_system, DutyCitations) :-
    implements(eu_reg_2024_1689_art_113_c).
high_risk_step(true, Row, AssessmentDate, Assignment, Result, Citations) :-
    implements(eu_reg_2024_1689_art_113_c_ii),
    value_of(Assignment, high_risk_route, Route),
    application_date(chapter_iii_annex_i, AnnexOneStart, _),
    annex_one_not_yet_t(Route, AssessmentDate, AnnexOneStart, NotYet),
    route_step(NotYet, Row, AssessmentDate, Assignment, Result, Citations).

annex_one_not_yet_t(annex_iii, _, _, false).
annex_one_not_yet_t(annex_i, AssessmentDate, AnnexOneStart, NotYet) :-
    provider_side_duties_date_before_t(AssessmentDate, AnnexOneStart, NotYet).

route_step(true, _, _, _, not_applicable_on_date, Citations) :-
    implements(eu_reg_2024_1689_art_113_c_ii),
    chapter_three_date_citations(Citations).
route_step(false, Row, AssessmentDate, Assignment, Result, Citations) :-
    implements(eu_reg_2024_1689_art_3_8),
    Row = row(Addressee, _, _),
    value_of(Assignment, actor_role, Role),
    same_atom_t(Role, Addressee, IsAddressee),
    addressee_step(IsAddressee, Row, AssessmentDate, Assignment, Result, Citations).

addressee_step(false, row(Addressee, _, DutyCitations), _, _, not_the_addressee_of_the_duty, Citations) :-
    implements(eu_reg_2024_1689_art_3_8),
    role_citation(Addressee, RoleCitation),
    append(DutyCitations, [RoleCitation], Citations).
addressee_step(true, Row, AssessmentDate, Assignment, Result, Citations) :-
    implements(eu_reg_2024_1689_art_111_1),
    large_scale_t(Assignment, LargeScale),
    compliance_day(large_scale_it_system, LastDay, _),
    provider_side_duties_date_before_t(AssessmentDate, LastDay, BeforeLastDay),
    truth_and(LargeScale, BeforeLastDay, Fires),
    large_scale_step(Fires, LargeScale, Row, AssessmentDate, Assignment, Result, Citations).

large_scale_step(true, _, row(_, _, DutyCitations), _, _, compliance_required_by_31_december_2030, Citations) :-
    implements(eu_reg_2024_1689_art_111_1),
    compliance_day(large_scale_it_system, _, Citation),
    append(DutyCitations, [Citation], Citations).
large_scale_step(false, LargeScale, Row, AssessmentDate, Assignment, Result, Citations) :-
    implements(eu_reg_2024_1689_art_111_2),
    Row = row(Addressee, _, _),
    already_placed_t(LargeScale, Assignment, AlreadyPlaced),
    public_authority_t(Addressee, Assignment, PublicAuthority),
    compliance_day(public_authorities, PublicDay, _),
    provider_side_duties_date_before_t(AssessmentDate, PublicDay, BeforePublicDay),
    truth_and(AlreadyPlaced, PublicAuthority, PlacedForPublic),
    truth_and(PlacedForPublic, BeforePublicDay, Fires),
    public_authority_step(Fires, AlreadyPlaced, PublicAuthority, Row, Assignment, Result, Citations).

public_authority_step(true, _, _, row(_, _, DutyCitations), _, compliance_required_by_2_august_2030, Citations) :-
    implements(eu_reg_2024_1689_art_111_2),
    compliance_day(public_authorities, _, Citation),
    append(DutyCitations, [Citation], Citations).
public_authority_step(false, AlreadyPlaced, PublicAuthority, Row, Assignment, Result, Citations) :-
    implements(eu_reg_2024_1689_art_111_2),
    truth_not(PublicAuthority, NotPublic),
    truth_and(AlreadyPlaced, NotPublic, Fires),
    already_placed_step(Fires, Row, Assignment, Result, Citations).

already_placed_step(true, row(_, _, DutyCitations), _, system_already_placed_without_significant_change, Citations) :-
    implements(eu_reg_2024_1689_art_111_2),
    append(DutyCitations, [cite(eu_reg_2024_1689_art_111_2)], Citations).
already_placed_step(false, row(_, Condition, DutyCitations), Assignment, Result, Citations) :-
    implements(eu_reg_2024_1689_art_3_8),
    condition_t(Condition, Assignment, Holds),
    condition_result(Holds, DutyCitations, Result, Citations).

condition_result(false, DutyCitations, duty_not_triggered, DutyCitations).
condition_result(true, DutyCitations, duty_applies, DutyCitations).

condition_t(always, _, true).
condition_t(key_true(Key), Assignment, Holds) :-
    value_of(Assignment, Key, Holds).
condition_t(both(FirstKey, SecondKey), Assignment, Holds) :-
    value_of(Assignment, FirstKey, FirstHolds),
    value_of(Assignment, SecondKey, SecondHolds),
    truth_and(FirstHolds, SecondHolds, Holds).

large_scale_t(Assignment, LargeScale) :-
    implements(eu_reg_2024_1689_art_111_1),
    value_of(Assignment, component_of_a_large_scale_it_system_listed_in_annex_x, Component),
    value_of(Assignment, placed_on_the_market_or_put_into_service_before_2_august_2027, PlacedBeforeAugust),
    truth_and(Component, PlacedBeforeAugust, LargeScale).

already_placed_t(LargeScale, Assignment, AlreadyPlaced) :-
    implements(eu_reg_2024_1689_art_111_2),
    truth_not(LargeScale, NotLargeScale),
    value_of(Assignment, placed_on_the_market_or_put_into_service_before_2_august_2027, PlacedBeforeAugust),
    value_of(Assignment, placed_on_the_market_or_put_into_service_before_the_date_of_application_of_chapter_iii, PlacedBeforeApplication),
    truth_or(PlacedBeforeAugust, PlacedBeforeApplication, Placed),
    value_of(Assignment, significant_change_in_design_as_from_the_date_of_application_of_chapter_iii, SignificantChange),
    truth_not(SignificantChange, NoSignificantChange),
    truth_and(NotLargeScale, Placed, PlacedNotLargeScale),
    truth_and(PlacedNotLargeScale, NoSignificantChange, AlreadyPlaced).

public_authority_t(provider, Assignment, PublicAuthority) :-
    implements(eu_reg_2024_1689_art_111_2),
    value_of(Assignment, intended_to_be_used_by_public_authorities, PublicAuthority).
public_authority_t(Addressee, _, false) :-
    implements(eu_reg_2024_1689_art_111_2),
    dif(Addressee, provider).

retention_period_end(KeepingDuty, StartDate, EndDate, Citations) :-
    keeping_duty_problems(KeepingDuty, DutyProblems),
    date_problems(StartDate, start_date, DateProblems),
    append(DutyProblems, DateProblems, Problems),
    retention_answer(Problems, KeepingDuty, StartDate, EndDate, Citations).

retention_answer([], KeepingDuty, StartDate, EndDate, Citations) :-
    retention_end(KeepingDuty, StartDate, EndDate, Citations).
retention_answer([Problem|Problems], _, _, input_problems([Problem|Problems]), []).

keeping_duty_problems(KeepingDuty, Problems) :-
    keeping_duty_t(KeepingDuty, IsKeepingDuty),
    keeping_problem_list(IsKeepingDuty, Problems).

keeping_duty_t(KeepingDuty, false) :-
    var(KeepingDuty).
keeping_duty_t(KeepingDuty, IsKeepingDuty) :-
    nonvar(KeepingDuty),
    findall(Duty, retention_period(Duty, _, _), KeepingDuties),
    memberd_t(KeepingDuty, KeepingDuties, IsKeepingDuty).

keeping_problem_list(true, []).
keeping_problem_list(false, [wrong_type(keeping_duty)]).

retention_end(documentation_keeping, StartDate, EndDate, [Citation]) :-
    implements(eu_reg_2024_1689_art_18_1),
    retention_period(documentation_keeping, Period, Citation),
    period_end(Period, StartDate, EndDate).
retention_end(keeping_of_the_provider_contact_details_and_documents, StartDate, EndDate, [Citation]) :-
    implements(eu_reg_2024_1689_art_22_3_b),
    retention_period(keeping_of_the_provider_contact_details_and_documents, Period, Citation),
    period_end(Period, StartDate, EndDate).
retention_end(importer_keeping_of_copies, StartDate, EndDate, [Citation]) :-
    implements(eu_reg_2024_1689_art_23_5),
    retention_period(importer_keeping_of_copies, Period, Citation),
    period_end(Period, StartDate, EndDate).
retention_end(log_keeping, StartDate, EndDate, [Citation]) :-
    implements(eu_reg_2024_1689_art_19_1),
    retention_period(log_keeping, Period, Citation),
    period_end(Period, StartDate, EndDate).

period_end(period(Years, years), StartDate, EndDate) :-
    Months #= Years * 12,
    months_after(StartDate, Months, EndDate).
period_end(period(Months, months), StartDate, EndDate) :-
    months_after(StartDate, Months, EndDate).

months_after(date(Year, Month, Day), Months, date(EndYear, EndMonth, EndDay)) :-
    MonthCount #= Month - 1 + Months,
    EndYear #= Year + MonthCount // 12,
    EndMonth #= MonthCount mod 12 + 1,
    provider_side_duties_month_length(EndYear, EndMonth, LastDay),
    clamp_day(Day, LastDay, EndDay).

clamp_day(Day, LastDay, Day) :-
    Day #=< LastDay.
clamp_day(Day, LastDay, LastDay) :-
    Day #> LastDay.

owed_duties(Profile, AssessmentDate, Duties) :-
    all_duty_atoms(AllDuties),
    findall(Duty, (member(Duty, AllDuties), operator_duty_status(Profile, Duty, AssessmentDate, duty_applies, _)), Owed),
    sort(Owed, Duties).

decide_provider_side_duties(duty_case(Profile, Duty, AssessmentDate), provider_side_duties_verdict(Status, Citations)) :-
    operator_duty_status(Profile, Duty, AssessmentDate, Status, Citations).

provider_side_duties_status(Case, Status) :-
    decide_provider_side_duties(Case, provider_side_duties_verdict(Status, _)).

provider_side_duties_checklist(duty_case(Profile, Duty, AssessmentDate), [item(Duty, Status, Citations)]) :-
    decide_provider_side_duties(duty_case(Profile, Duty, AssessmentDate), provider_side_duties_verdict(Status, Citations)).

provider_side_duties_decision_resolvable(Case) :-
    decide_provider_side_duties(Case, _).

provider_profile([attribute(high_risk_ai_system, true), attribute(high_risk_route, annex_iii), attribute(actor_role, provider), attribute(component_of_a_large_scale_it_system_listed_in_annex_x, false), attribute(placed_on_the_market_or_put_into_service_before_2_august_2027, false), attribute(placed_on_the_market_or_put_into_service_before_the_date_of_application_of_chapter_iii, false), attribute(significant_change_in_design_as_from_the_date_of_application_of_chapter_iii, false), attribute(intended_to_be_used_by_public_authorities, false)]).

importer_profile([attribute(high_risk_ai_system, true), attribute(high_risk_route, annex_iii), attribute(actor_role, importer), attribute(component_of_a_large_scale_it_system_listed_in_annex_x, false), attribute(placed_on_the_market_or_put_into_service_before_2_august_2027, false), attribute(placed_on_the_market_or_put_into_service_before_the_date_of_application_of_chapter_iii, false), attribute(significant_change_in_design_as_from_the_date_of_application_of_chapter_iii, false), attribute(importer_has_sufficient_reason_to_consider_the_system_not_in_conformity_or_falsified, false), attribute(presents_a_risk_within_the_meaning_of_article_79_1, false), attribute(system_under_the_operators_responsibility, false), attribute(reasoned_request_from_a_competent_authority, false), attribute(competent_authority_action_in_relation_to_the_system, false)]).

test(a_provider_owes_section_2_compliance) :-
    provider_profile(Profile),
    findall(Result - Citations, operator_duty_status(Profile, compliance_with_the_requirements_of_section_2, date(2028, 1, 1), Result, Citations), Answers),
    Answers == [duty_applies - [cite(eu_reg_2024_1689_art_16_a)]].
test(before_chapter_three_applies) :-
    findall(Result - Citations, operator_duty_status([], ce_marking, date(2027, 12, 1), Result, Citations), Answers),
    sort([cite(eu_reg_2024_1689_art_113_c), cite(eu_reg_2024_1689_art_113_c_i), cite(eu_reg_2024_1689_art_113_c_ii)], Expected),
    Answers == [not_applicable_on_date - Expected].
test(an_empty_profile_asks_for_high_risk_first) :-
    findall(Result - Citations, operator_duty_status([], compliance_with_the_requirements_of_section_2, date(2029, 1, 1), Result, Citations), Answers),
    Answers == [indeterminate([high_risk_ai_system]) - []].
test(an_absent_log_control_key_is_missing) :-
    provider_profile(Profile),
    operator_duty_status(Profile, log_keeping, date(2028, 1, 1), Result, Citations),
    Result == indeterminate([logs_under_the_providers_control]),
    Citations == [].
test(logs_not_under_control_do_not_trigger) :-
    provider_profile(Profile),
    operator_duty_status([attribute(logs_under_the_providers_control, false)|Profile], log_keeping, date(2028, 1, 1), Result, Citations),
    Result == duty_not_triggered,
    sort([cite(eu_reg_2024_1689_art_16_e), cite(eu_reg_2024_1689_art_19_1)], Expected),
    Citations == Expected.
test(an_importer_is_not_the_addressee_of_a_provider_duty) :-
    operator_duty_status([attribute(high_risk_ai_system, true), attribute(high_risk_route, annex_iii), attribute(actor_role, importer)], quality_management_system, date(2028, 1, 1), Result, Citations),
    Result == not_the_addressee_of_the_duty,
    sort([cite(eu_reg_2024_1689_art_16_c), cite(eu_reg_2024_1689_art_3_3)], Expected),
    Citations == Expected.
test(the_annex_one_route_waits_until_august_2028) :-
    operator_duty_status([attribute(high_risk_ai_system, true), attribute(high_risk_route, annex_i)], ce_marking, date(2028, 1, 1), Result, _),
    Result == not_applicable_on_date.
test(a_large_scale_component_for_public_authorities_follows_article_111_1) :-
    operator_duty_status([attribute(high_risk_ai_system, true), attribute(high_risk_route, annex_iii), attribute(actor_role, provider), attribute(component_of_a_large_scale_it_system_listed_in_annex_x, true), attribute(placed_on_the_market_or_put_into_service_before_2_august_2027, true), attribute(intended_to_be_used_by_public_authorities, true)], ce_marking, date(2030, 9, 1), Result, Citations),
    Result == compliance_required_by_31_december_2030,
    sort([cite(eu_reg_2024_1689_art_16_h), cite(eu_reg_2024_1689_art_111_1)], Expected),
    Citations == Expected.
test(an_already_placed_system_without_change) :-
    operator_duty_status([attribute(high_risk_ai_system, true), attribute(high_risk_route, annex_iii), attribute(actor_role, provider), attribute(component_of_a_large_scale_it_system_listed_in_annex_x, false), attribute(placed_on_the_market_or_put_into_service_before_2_august_2027, true), attribute(placed_on_the_market_or_put_into_service_before_the_date_of_application_of_chapter_iii, false), attribute(significant_change_in_design_as_from_the_date_of_application_of_chapter_iii, false), attribute(intended_to_be_used_by_public_authorities, false)], compliance_with_the_requirements_of_section_2, date(2029, 1, 1), Result, Citations),
    Result == system_already_placed_without_significant_change,
    sort([cite(eu_reg_2024_1689_art_16_a), cite(eu_reg_2024_1689_art_111_2)], Expected),
    Citations == Expected.
test(a_public_authority_system_must_comply_by_august_2030) :-
    operator_duty_status([attribute(high_risk_ai_system, true), attribute(high_risk_route, annex_iii), attribute(actor_role, provider), attribute(component_of_a_large_scale_it_system_listed_in_annex_x, false), attribute(placed_on_the_market_or_put_into_service_before_2_august_2027, true), attribute(significant_change_in_design_as_from_the_date_of_application_of_chapter_iii, false), attribute(intended_to_be_used_by_public_authorities, true)], registration, date(2029, 1, 1), Result, _),
    Result == compliance_required_by_2_august_2030.
test(from_august_2030_the_public_authority_duty_applies) :-
    operator_duty_status([attribute(high_risk_ai_system, true), attribute(high_risk_route, annex_iii), attribute(actor_role, provider), attribute(component_of_a_large_scale_it_system_listed_in_annex_x, false), attribute(placed_on_the_market_or_put_into_service_before_2_august_2027, true), attribute(significant_change_in_design_as_from_the_date_of_application_of_chapter_iii, false), attribute(intended_to_be_used_by_public_authorities, true)], registration, date(2030, 8, 2), Result, Citations),
    Result == duty_applies,
    Citations == [cite(eu_reg_2024_1689_art_16_i)].
test(article_four_before_the_pinned_text) :-
    operator_duty_status([], ai_literacy_measures, date(2026, 1, 1), Result, Citations),
    Result == earlier_text_not_formalised,
    Citations == [cite(eu_reg_2024_1689_art_113_a)].
test(article_four_before_chapter_one_applies) :-
    operator_duty_status([], ai_literacy_measures, date(2025, 2, 1), not_applicable_on_date, [cite(eu_reg_2024_1689_art_113_a)]).
test(article_four_an_importer_is_not_the_addressee) :-
    operator_duty_status([attribute(actor_role, importer)], ai_literacy_measures, date(2027, 1, 1), Result, Citations),
    Result == not_the_addressee_of_the_duty,
    sort([cite(eu_reg_2024_1689_art_3_3), cite(eu_reg_2024_1689_art_3_4), cite(eu_reg_2024_1689_art_4_1)], Expected),
    Citations == Expected.
test(article_four_a_deployer_of_an_ai_system) :-
    operator_duty_status([attribute(actor_role, deployer), attribute(ai_system, true)], ai_literacy_measures, date(2027, 1, 1), duty_applies, [cite(eu_reg_2024_1689_art_4_1)]).
test(article_four_an_unsure_ai_system_is_referred) :-
    findall(Result - Citations, operator_duty_status([attribute(actor_role, provider), attribute(ai_system, unsure)], ai_literacy_measures, date(2027, 1, 1), Result, Citations), Answers),
    Answers == [needs_legal_review(open_textured(ai_system, cite(eu_reg_2024_1689_art_3_1)), [inputs_relied_on([ai_system - unsure])]) - []].
test(a_missing_role_is_named_before_an_unsure_judgement) :-
    operator_duty_status([attribute(ai_system, unsure)], ai_literacy_measures, date(2027, 1, 1), Result, _),
    Result == indeterminate([actor_role]).
test(an_unsure_risk_for_a_distributor_is_referred_under_article_24_2) :-
    operator_duty_status([attribute(high_risk_ai_system, true), attribute(high_risk_route, annex_iii), attribute(actor_role, distributor), attribute(component_of_a_large_scale_it_system_listed_in_annex_x, false), attribute(placed_on_the_market_or_put_into_service_before_2_august_2027, false), attribute(placed_on_the_market_or_put_into_service_before_the_date_of_application_of_chapter_iii, false), attribute(significant_change_in_design_as_from_the_date_of_application_of_chapter_iii, false), attribute(presents_a_risk_within_the_meaning_of_article_79_1, unsure)], distributor_information_on_a_risk, date(2028, 1, 1), Result, Citations),
    Result == needs_legal_review(open_textured(presents_a_risk_within_the_meaning_of_article_79_1, cite(eu_reg_2024_1689_art_24_2)), [inputs_relied_on([significant_change_in_design_as_from_the_date_of_application_of_chapter_iii - false, presents_a_risk_within_the_meaning_of_article_79_1 - unsure])]),
    Citations == [].
test(argument_problems_follow_profile_problems) :-
    findall(Result - Citations, operator_duty_status([attribute(colour, blue)], unknown_duty, date(2026, 2, 30), Result, Citations), Answers),
    Answers == [input_problems([unknown_key(colour), wrong_type(duty), wrong_type(assessment_date)]) - []].
test(an_unbound_date_is_wrong_type) :-
    operator_duty_status([], ce_marking, _, input_problems([wrong_type(assessment_date)]), []).
test(the_importer_owes_three_unconditional_duties) :-
    importer_profile(Profile),
    owed_duties(Profile, date(2028, 1, 1), Duties),
    Duties == [importer_keeping_of_copies, importer_name_and_contact_address, importer_verification_before_placing_on_the_market].
test(ten_year_record) :-
    findall(EndDate - Citations, retention_period_end(documentation_keeping, date(2028, 3, 15), EndDate, Citations), Answers),
    Answers == [date(2038, 3, 15) - [cite(eu_reg_2024_1689_art_18_1)]].
test(six_month_logs) :-
    retention_period_end(log_keeping, date(2028, 3, 15), date(2028, 9, 15), [cite(eu_reg_2024_1689_art_19_1)]).
test(a_leap_day_moves_to_february_28) :-
    retention_period_end(importer_keeping_of_copies, date(2028, 2, 29), date(2038, 2, 28), [cite(eu_reg_2024_1689_art_23_5)]).
test(logs_from_august_31_end_on_the_last_day_of_february) :-
    retention_period_end(log_keeping, date(2028, 8, 31), date(2029, 2, 28), [cite(eu_reg_2024_1689_art_19_1)]).
test(an_end_year_above_9999_is_written) :-
    retention_period_end(keeping_of_the_provider_contact_details_and_documents, date(9999, 3, 1), date(10009, 3, 1), [cite(eu_reg_2024_1689_art_22_3_b)]).
test(retention_argument_problems) :-
    findall(EndDate - Citations, retention_period_end(ce_marking, date(2026, 13, 1), EndDate, Citations), Answers),
    Answers == [input_problems([wrong_type(keeping_duty), wrong_type(start_date)]) - []].
test(the_checklist_carries_the_citations) :-
    provider_profile(Profile),
    provider_side_duties_checklist(duty_case(Profile, ce_marking, date(2028, 1, 1)), [item(ce_marking, duty_applies, [cite(eu_reg_2024_1689_art_16_h)])]).

test(a_provider_answer_is_not_duty_not_triggered, fail) :-
    provider_profile(Profile),
    operator_duty_status(Profile, compliance_with_the_requirements_of_section_2, date(2028, 1, 1), duty_not_triggered, _).
