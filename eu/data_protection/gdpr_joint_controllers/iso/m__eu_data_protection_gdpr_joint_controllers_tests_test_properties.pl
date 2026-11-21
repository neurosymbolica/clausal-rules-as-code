% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_joint_controllers_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_joint_controllers_gdpr_joint_controllers, [decide_gdpr_joint_controllers/2, rights_against_each_joint_controller/3, liability_for_the_entire_damage/4, recourse_after_full_compensation/4]).
:- use_module(m__eu_data_protection_gdpr_joint_controllers_fixtures, [gdpr_joint_controllers_subject/1, gdpr_joint_controllers_profile_for/2]).

subject_classifies(Subject) :-
    gdpr_joint_controllers_subject(Subject),
    gdpr_joint_controllers_profile_for(Subject, Profile),
    decide_gdpr_joint_controllers(Profile, _Verdict).

subject_verdict_count(Subject - Count) :-
    gdpr_joint_controllers_subject(Subject),
    gdpr_joint_controllers_profile_for(Subject, Profile),
    findall(Verdict, decide_gdpr_joint_controllers(Profile, Verdict), Verdicts),
    length(Verdicts, Count).

exactly_one(_ - 1).

attested_statement(Value, attested(Value, attestation(host_service, attested_moment, stated_reason, none))).

joint_choice(absent).
joint_choice(present(true)).
joint_choice(present(false)).
joint_choice(present(unsure)).

responsibility_choice(absent).
responsibility_choice(present(Attested)) :-
    attested_statement(true, Attested).
responsibility_choice(present(Attested)) :-
    attested_statement(false, Attested).

parties_choice(absent).
parties_choice(present([])).
parties_choice(present([controller_alpha, processor_beta])).

payment_choice(absent).
payment_choice(present(true)).
payment_choice(present(false)).
payment_choice(present(unsure)).

optional_attribute(_, absent, []).
optional_attribute(Key, present(Value), [attribute(Key, Value)]).

grid_profile(choices(JointChoice, ResponsibilityChoice, PartiesChoice, PaymentChoice), Profile) :-
    joint_choice(JointChoice),
    responsibility_choice(ResponsibilityChoice),
    parties_choice(PartiesChoice),
    payment_choice(PaymentChoice),
    optional_attribute(controllers_jointly_determine_purposes_and_means, JointChoice, JointPart),
    optional_attribute(responsible_under_article_82_2_and_3, ResponsibilityChoice, ResponsibilityPart),
    optional_attribute(other_responsible_parties, PartiesChoice, PartiesPart),
    optional_attribute(full_compensation_paid, PaymentChoice, PaymentPart),
    append([JointPart, ResponsibilityPart, PartiesPart, PaymentPart], Profile).

query_counts(Profile, counts(RightsCount, LiabilityCount, RecourseCount)) :-
    findall(Result - Citations, rights_against_each_joint_controller(Profile, Result, Citations), RightsAnswers),
    length(RightsAnswers, RightsCount),
    findall(Result - Basis - Citations, liability_for_the_entire_damage(Profile, Result, Basis, Citations), LiabilityAnswers),
    length(LiabilityAnswers, LiabilityCount),
    findall(Result - Basis - Citations, recourse_after_full_compensation(Profile, Result, Basis, Citations), RecourseAnswers),
    length(RecourseAnswers, RecourseCount).

rights_answer_consistent(not_joint_controllers - [cite(eu_reg_2016_679_art_26_3)]).
rights_answer_consistent(rights_exercisable_against_this_controller - [cite(eu_reg_2016_679_art_26_3), cite(eu_reg_2016_679_art_28_10)]).
rights_answer_consistent(indeterminate([_]) - []).
rights_answer_consistent(needs_legal_review(_, _) - []).
rights_answer_consistent(input_problems([_|_]) - []).

liability_answer_consistent(not_responsible_for_the_damage - [outside_fact(responsible_under_article_82_2_and_3, attested(false, _))] - [cite(eu_reg_2016_679_art_82_4)]).
liability_answer_consistent(no_other_responsible_party - [outside_fact(responsible_under_article_82_2_and_3, attested(true, _))] - [cite(eu_reg_2016_679_art_82_4)]).
liability_answer_consistent(liable_for_the_entire_damage - [outside_fact(responsible_under_article_82_2_and_3, attested(true, _))] - [cite(eu_reg_2016_679_art_82_4)]).
liability_answer_consistent(indeterminate([_]) - [] - []).
liability_answer_consistent(needs_legal_review(_, _) - [] - []).
liability_answer_consistent(input_problems([_|_]) - [] - []).

recourse_answer_consistent(entitled_to_claim_back([_|_]) - [outside_fact(responsible_under_article_82_2_and_3, attested(true, _))] - [cite(eu_reg_2016_679_art_82_5)]).
recourse_answer_consistent(not_entitled_to_claim_back - [outside_fact(responsible_under_article_82_2_and_3, attested(false, _))] - [cite(eu_reg_2016_679_art_82_5)]).
recourse_answer_consistent(not_entitled_to_claim_back - [] - [cite(eu_reg_2016_679_art_82_5)]).
recourse_answer_consistent(indeterminate([_]) - [] - []).
recourse_answer_consistent(needs_legal_review(_, _) - [] - []).
recourse_answer_consistent(input_problems([_|_]) - [] - []).

test(totality_every_subject_classifies) :-
    findall(Subject, gdpr_joint_controllers_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_subject_has_exactly_one_verdict) :-
    findall(Pair, subject_verdict_count(Pair), Pairs),
    Pairs = [_|_],
    maplist(exactly_one, Pairs).
test(the_grid_has_every_combination) :-
    findall(Profile, grid_profile(_, Profile), Profiles),
    length(Profiles, 144).
test(every_grid_profile_yields_exactly_one_answer_per_query) :-
    findall(Counts, (grid_profile(_, Profile), query_counts(Profile, Counts)), AllCounts),
    length(AllCounts, 144),
    maplist(==(counts(1, 1, 1)), AllCounts).
test(every_rights_answer_has_a_consistent_shape) :-
    findall(Result - Citations, (grid_profile(_, Profile), rights_against_each_joint_controller(Profile, Result, Citations)), Answers),
    maplist(rights_answer_consistent, Answers).
test(every_liability_answer_has_a_consistent_shape) :-
    findall(Result - Basis - Citations, (grid_profile(_, Profile), liability_for_the_entire_damage(Profile, Result, Basis, Citations)), Answers),
    maplist(liability_answer_consistent, Answers).
test(every_recourse_answer_has_a_consistent_shape) :-
    findall(Result - Basis - Citations, (grid_profile(_, Profile), recourse_after_full_compensation(Profile, Result, Basis, Citations)), Answers),
    maplist(recourse_answer_consistent, Answers).
test(the_rights_answer_turns_on_the_joint_determination_alone) :-
    findall(JointChoice - Result, (grid_profile(choices(JointChoice, _, _, _), Profile), rights_against_each_joint_controller(Profile, Result, _)), Pairs),
    sort(Pairs, DistinctPairs),
    length(DistinctPairs, 4).
test(a_claim_back_arises_only_with_liability_for_the_entire_damage) :-
    findall(LiabilityResult, (grid_profile(_, Profile), recourse_after_full_compensation(Profile, entitled_to_claim_back(_), _, _), liability_for_the_entire_damage(Profile, LiabilityResult, _, _)), LiabilityResults),
    LiabilityResults = [_|_],
    sort(LiabilityResults, [liable_for_the_entire_damage]).
test(a_party_stated_not_responsible_never_gets_a_claim_back) :-
    findall(Result, (grid_profile(choices(_, present(attested(false, _)), _, _), Profile), recourse_after_full_compensation(Profile, Result, _, _)), Results),
    sort(Results, [not_entitled_to_claim_back]).

cp_test_names([totality_every_subject_classifies, determinism_every_subject_has_exactly_one_verdict, the_grid_has_every_combination, every_grid_profile_yields_exactly_one_answer_per_query, every_rights_answer_has_a_consistent_shape, every_liability_answer_has_a_consistent_shape, every_recourse_answer_has_a_consistent_shape, the_rights_answer_turns_on_the_joint_determination_alone, a_claim_back_arises_only_with_liability_for_the_entire_damage, a_party_stated_not_responsible_never_gets_a_claim_back]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
