% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_cra_administrative_fines_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [last/2, clausal_msort/2, min_list/2]).
:- use_module(m__eu_cra_administrative_fines_cra_administrative_fines, [administrative_fine_maximum/4, decide_cra_administrative_fines/2, cra_administrative_fines_status_values/1]).
:- use_module(m__eu_cra_administrative_fines_fixtures, [cra_administrative_fines_subject/1, cra_administrative_fines_profile_for/2, cra_administrative_fines_assess/2]).

subject_set(SubjectSet) :-
    findall(Subject, cra_administrative_fines_subject(Subject), Subjects),
    sort(Subjects, SubjectSet).

subject_classifies(Subject) :-
    cra_administrative_fines_subject(Subject),
    cra_administrative_fines_profile_for(Subject, Request),
    decide_cra_administrative_fines(Request, _Verdict).

subject_is_deterministic(Subject) :-
    cra_administrative_fines_subject(Subject),
    findall(Result, cra_administrative_fines_assess(Subject, Result), Results),
    length(Results, 1).

tier_citation(highest_maximum_tier, eu_reg_2024_2847_art_64_2).
tier_citation(middle_maximum_tier, eu_reg_2024_2847_art_64_3).
tier_citation(lowest_maximum_tier, eu_reg_2024_2847_art_64_4).

basis_atom(fixed_amount).
basis_atom(percentage_of_turnover).
basis_atom(fixed_amount_for_non_undertaking).

well_shaped(indeterminate([Key]), []) :-
    atom(Key).
well_shaped(needs_legal_review(open_textured(Key, cite(Citation)), [inputs_relied_on([_|_])]), []) :-
    atom(Key),
    atom(Citation).
well_shaped(input_problems([_|_]), []).
well_shaped(not_yet_applicable, [cite(eu_reg_2024_2847_art_71_2)]).
well_shaped(not_listed_in_article_64, [cite(eu_reg_2024_2847_art_64_1), cite(eu_reg_2024_2847_art_64_2), cite(eu_reg_2024_2847_art_64_3), cite(eu_reg_2024_2847_art_64_4)]).
well_shaped(fine_excluded(open_source_software_steward), [cite(eu_reg_2024_2847_art_64_10_b)]).
well_shaped(fine_maximum(Tier, Basis, CapInEuroCents), [cite(Key)]) :-
    tier_citation(Tier, Key),
    basis_atom(Basis),
    integer(CapInEuroCents),
    CapInEuroCents >= 0.

subject_is_well_shaped(Subject) :-
    cra_administrative_fines_subject(Subject),
    cra_administrative_fines_assess(Subject, cra_administrative_fines_verdict(Verdict, Citations)),
    well_shaped(Verdict, Citations).

subject_status_in_table(Subject) :-
    cra_administrative_fines_subject(Subject),
    cra_administrative_fines_assess(Subject, cra_administrative_fines_verdict(Verdict, _Citations)),
    functor(Verdict, Name, Arity),
    cra_administrative_fines_status_values(StatusValues),
    member(Name/Arity, StatusValues).

highest_tier_cap(TurnoverEuros, CapInEuroCents) :-
    administrative_fine_maximum([attribute(infringed_provision, article_13), attribute(offender_is_undertaking, true), attribute(total_worldwide_annual_turnover_in_euros, TurnoverEuros)], date(2028, 1, 1), fine_maximum(highest_maximum_tier, _, CapInEuroCents), _).

middle_tier_cap(TurnoverEuros, CapInEuroCents) :-
    administrative_fine_maximum([attribute(infringed_provision, article_22), attribute(offender_is_open_source_software_steward, false), attribute(offender_is_undertaking, true), attribute(total_worldwide_annual_turnover_in_euros, TurnoverEuros)], date(2028, 1, 1), fine_maximum(middle_maximum_tier, _, CapInEuroCents), _).

fixture_cap(Subject, CapInEuroCents) :-
    cra_administrative_fines_assess(Subject, cra_administrative_fines_verdict(fine_maximum(_, _, CapInEuroCents), _)).

test(totality_every_subject_classifies) :-
    subject_set(SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_subject_yields_exactly_one_verdict) :-
    subject_set(SubjectSet),
    findall(Subject, subject_is_deterministic(Subject), DeterministicSubjects),
    sort(DeterministicSubjects, SubjectSet).
test(every_verdict_has_the_shape_the_order_fixes) :-
    subject_set(SubjectSet),
    findall(Subject, subject_is_well_shaped(Subject), ShapedSubjects),
    sort(ShapedSubjects, SubjectSet).
test(every_verdict_is_in_the_status_table) :-
    subject_set(SubjectSet),
    findall(Subject, subject_status_in_table(Subject), TabledSubjects),
    sort(TabledSubjects, SubjectSet).
test(the_highest_tier_cap_is_monotone_in_the_turnover) :-
    maplist(highest_tier_cap, [0, 1, 599999999, 600000000, 600000001, 600000002, 6000000000], Caps),
    clausal_msort(Caps, Caps),
    last(Caps, LargestCap),
    LargestCap =:= 15000000000.
test(the_middle_tier_cap_is_monotone_in_the_turnover) :-
    maplist(middle_tier_cap, [0, 499999999, 500000000, 500000001, 900000000], Caps),
    clausal_msort(Caps, Caps).
test(the_cap_of_an_undertaking_is_never_below_the_fixed_amount) :-
    maplist(highest_tier_cap, [0, 1, 2, 3, 599999999], Caps),
    min_list(Caps, LowestCap),
    LowestCap =:= 1500000000.
test(the_cap_never_passes_the_ceiling_of_the_text) :-
    highest_tier_cap(1000000001, CapInEuroCents),
    CapInEuroCents * 2 =:= 1000000001 * 5 - 1.
test(the_tiers_order_highest_middle_lowest) :-
    fixture_cap(application_day_highest_tier, HighestCap),
    fixture_cap(application_day_middle_tier, MiddleCap),
    fixture_cap(non_steward_lowest_tier, LowestCap),
    HighestCap > MiddleCap,
    MiddleCap > LowestCap.
test(final_citations_depend_only_on_kind_and_tier) :-
    cra_administrative_fines_assess(steward_absent_highest_tier, cra_administrative_fines_verdict(_, FirstCitations)),
    cra_administrative_fines_assess(highest_tier_two_euros_above_tie, cra_administrative_fines_verdict(_, SecondCitations)),
    cra_administrative_fines_assess(turnover_absent_non_undertaking, cra_administrative_fines_verdict(_, ThirdCitations)),
    FirstCitations == SecondCitations,
    SecondCitations == ThirdCitations.

cp_test_names([totality_every_subject_classifies, determinism_every_subject_yields_exactly_one_verdict, every_verdict_has_the_shape_the_order_fixes, every_verdict_is_in_the_status_table, the_highest_tier_cap_is_monotone_in_the_turnover, the_middle_tier_cap_is_monotone_in_the_turnover, the_cap_of_an_undertaking_is_never_below_the_fixed_amount, the_cap_never_passes_the_ceiling_of_the_text, the_tiers_order_highest_middle_lowest, final_citations_depend_only_on_kind_and_tier]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
