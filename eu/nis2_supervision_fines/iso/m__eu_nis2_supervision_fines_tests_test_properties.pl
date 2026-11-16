% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_supervision_fines_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [is_list/1]).
:- use_module(library(clpz)).
:- use_module(m__eu_nis2_supervision_fines_nis2_supervision_fines, [decide_nis2_supervision_fines/2, nis2_supervision_fines_checklist/2, fine_ceiling_floor/3, minimum_powers/2, escalation_powers_exercisable/3, fine_barred_by_gdpr_fine/3, data_protection_authority_information/2]).
:- use_module(m__eu_nis2_supervision_fines_fixtures, [nis2_supervision_fines_subject/1, nis2_supervision_fines_profile_for/2]).

subject_profile(Subject, Profile) :-
    nis2_supervision_fines_subject(Subject),
    nis2_supervision_fines_profile_for(Subject, Profile).

subject_classifies(Subject) :-
    subject_profile(Subject, Profile),
    decide_nis2_supervision_fines(Profile, _Verdict).

test(totality_every_subject_classifies) :-
    findall(Subject, nis2_supervision_fines_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_subject_one_answer_per_query) :-
    findall(Profile, subject_profile(_, Profile), Profiles),
    Profiles = [_|_],
    maplist(one_answer_per_query, Profiles).
test(citation_completeness_every_checklist_item_is_cited) :-
    findall(Profile, subject_profile(_, Profile), Profiles),
    maplist(checklist_cited, Profiles).
test(the_least_maximum_is_never_below_its_fixed_amount) :-
    findall(AmountEur - Citations, (subject_profile(_, Profile), fine_ceiling_floor(Profile, minimum_national_maximum(AmountEur, _), Citations)), Rows),
    Rows = [_|_],
    maplist(amount_at_least_floor, Rows).
test(the_essential_least_maximum_is_monotone_in_turnover) :-
    maplist(ceiling_amount_at(essential), [0, 1, 499999999, 500000000, 500000001, 1000000000], Amounts),
    non_decreasing(Amounts).
test(the_important_least_maximum_is_monotone_in_turnover) :-
    maplist(ceiling_amount_at(important), [0, 1, 500000000, 500000001, 1000000000], Amounts),
    non_decreasing(Amounts).
test(escalation_powers_only_for_essential_non_public_administration) :-
    findall(Subject, lists_escalation_power(Subject), Subjects),
    sort(Subjects, SubjectSet),
    SubjectSet == [escalation_action_taken_within_deadline, escalation_deadline_keys_missing, escalation_exercisable, escalation_measures_not_ineffective, escalation_measures_unsure, escalation_no_deadline_set].
test(the_facade_agrees_with_the_escalation_query) :-
    findall(Profile, subject_profile(_, Profile), Profiles),
    maplist(facade_agrees, Profiles).
test(a_gdpr_fine_bar_leaves_the_measures_available) :-
    nis2_supervision_fines_profile_for(gdpr_fine_barred, Profile),
    fine_barred_by_gdpr_fine(Profile, fine_barred, _),
    minimum_powers(Profile, Powers),
    length(Powers, 14).

one_answer_per_query(Profile) :-
    findall(Verdict, decide_nis2_supervision_fines(Profile, Verdict), Verdicts),
    length(Verdicts, 1),
    findall(Ceiling - CeilingCitations, fine_ceiling_floor(Profile, Ceiling, CeilingCitations), Ceilings),
    length(Ceilings, 1),
    findall(Powers, minimum_powers(Profile, Powers), PowerAnswers),
    length(PowerAnswers, 1),
    findall(Result - ResultCitations, escalation_powers_exercisable(Profile, Result, ResultCitations), Results),
    length(Results, 1),
    findall(Bar - BarCitations, fine_barred_by_gdpr_fine(Profile, Bar, BarCitations), Bars),
    length(Bars, 1),
    findall(Duty, data_protection_authority_information(Profile, Duty), Duties),
    length(Duties, 1).

item_cited(item(_, _, cite(Key))) :-
    atom(Key).

checklist_cited(Profile) :-
    nis2_supervision_fines_checklist(Profile, Items),
    Items = [_|_],
    maplist(item_cited, Items).

amount_at_least_floor(AmountEur - [cite(eu_dir_2022_2555_art_34_4)]) :-
    AmountEur #>= 10000000.
amount_at_least_floor(AmountEur - [cite(eu_dir_2022_2555_art_34_5)]) :-
    AmountEur #>= 7000000.

ceiling_amount_at(EntityClass, TurnoverEur, AmountEur) :-
    fine_ceiling_floor([attribute(entity_class, EntityClass), attribute(infringed_provision, art_21), attribute(worldwide_annual_turnover_eur, TurnoverEur)], minimum_national_maximum(AmountEur, _), _).

non_decreasing([_]).
non_decreasing([First, Second|Rest]) :-
    First #=< Second,
    non_decreasing([Second|Rest]).

lists_escalation_power(Subject) :-
    subject_profile(Subject, Profile),
    minimum_powers(Profile, Powers),
    is_list(Powers),
    member(power(escalation, _, _), Powers).

facade_pair(exercisable, eligible).
facade_pair(not_exercisable(_), ineligible).
facade_pair(indeterminate(MissingKeys), indeterminate(MissingKeys)).
facade_pair(needs_legal_review(Reason, Context), needs_legal_review(Reason, Context)).
facade_pair(input_problems(Problems), input_problems(Problems)).

facade_agrees(Profile) :-
    decide_nis2_supervision_fines(Profile, nis2_supervision_fines_verdict(Status, _)),
    escalation_powers_exercisable(Profile, Result, _),
    facade_pair(Result, Status).

cp_test_names([totality_every_subject_classifies, determinism_every_subject_one_answer_per_query, citation_completeness_every_checklist_item_is_cited, the_least_maximum_is_never_below_its_fixed_amount, the_essential_least_maximum_is_monotone_in_turnover, the_important_least_maximum_is_monotone_in_turnover, escalation_powers_only_for_essential_non_public_administration, the_facade_agrees_with_the_escalation_query, a_gdpr_fine_bar_leaves_the_measures_available]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
