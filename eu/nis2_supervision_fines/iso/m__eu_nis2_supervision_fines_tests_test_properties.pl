% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_supervision_fines_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [last/2, clausal_is_list/1, clausal_msort/2]).
:- use_module(m__eu_nis2_supervision_fines_nis2_supervision_fines, [decide_nis2_supervision_fines/2, nis2_supervision_fines_status/2, nis2_supervision_fines_status_values/1, fine_ceiling_floor/3, minimum_powers/2, escalation_powers_exercisable/3, fine_barred_by_gdpr_fine/3, data_protection_authority_information/2]).
:- use_module(m__eu_nis2_supervision_fines_citations, [citation/2]).
:- use_module(m__eu_nis2_supervision_fines_fixtures, [nis2_supervision_fines_subject/1, nis2_supervision_fines_profile_for/2]).

subject_classifies(Subject) :-
    nis2_supervision_fines_subject(Subject),
    nis2_supervision_fines_profile_for(Subject, Profile),
    decide_nis2_supervision_fines(Profile, _Verdict).

test(totality_every_subject_classifies) :-
    findall(Subject, nis2_supervision_fines_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_query_gives_one_answer_per_subject) :-
    findall(Subject - QueryName, subject_query(Subject, QueryName), AllPairs),
    findall(Subject - QueryName, subject_query_single(Subject, QueryName), SinglePairs),
    SinglePairs == AllPairs.
test(every_status_is_in_the_status_table) :-
    findall(Subject, nis2_supervision_fines_subject(Subject), Subjects),
    findall(Subject, subject_status_in_table(Subject), TabledSubjects),
    TabledSubjects == Subjects.
test(citation_completeness_every_returned_citation_is_recorded) :-
    findall(Subject - Labelled, subject_citations(Subject, Labelled), AllCitations),
    sort(AllCitations, AllSet),
    findall(Subject - Labelled, subject_citations_recorded(Subject, Labelled), RecordedCitations),
    sort(RecordedCitations, AllSet).
test(every_floor_is_at_least_the_smaller_fixed_amount) :-
    findall(Subject - AmountEur, subject_floor(Subject, AmountEur), Floors),
    Floors = [_|_],
    findall(Subject - AmountEur, subject_floor_at_least_fixed(Subject, AmountEur), CheckedFloors),
    CheckedFloors == Floors.
test(the_essential_floor_never_falls_as_turnover_rises) :-
    maplist(essential_floor_at, [0, 1, 499999999, 500000000, 500000001, 1000000000, 5000000000], Amounts),
    clausal_msort(Amounts, Amounts).
test(the_important_floor_never_falls_as_turnover_rises) :-
    maplist(important_floor_at, [0, 1, 499999999, 500000000, 500000001, 1000000000, 5000000000], Amounts),
    clausal_msort(Amounts, Amounts).
test(the_essential_floor_is_never_below_the_important_floor) :-
    essential_floor_at(800000000, EssentialAmountEur),
    important_floor_at(800000000, ImportantAmountEur),
    EssentialAmountEur >= ImportantAmountEur.
test(a_barred_fine_leaves_every_power_in_place) :-
    nis2_supervision_fines_profile_for(gdpr_fine_bars_nis2_fine, Profile),
    fine_barred_by_gdpr_fine(Profile, fine_barred, _),
    minimum_powers(Profile, Powers),
    length(Powers, 18),
    nis2_supervision_fines_status(Profile, eligible).
test(a_public_administration_entity_keeps_the_administrative_fine) :-
    nis2_supervision_fines_profile_for(escalation_public_administration_entity, Profile),
    minimum_powers(Profile, Powers),
    last(Powers, power(enforcement, administrative_fine, cite(eu_dir_2022_2555_art_32_4_i))).

query_name(decide_nis2_supervision_fines).
query_name(fine_ceiling_floor).
query_name(minimum_powers).
query_name(escalation_powers_exercisable).
query_name(fine_barred_by_gdpr_fine).
query_name(data_protection_authority_information).

query_answers(decide_nis2_supervision_fines, Profile, Answers) :-
    findall(Verdict, decide_nis2_supervision_fines(Profile, Verdict), Answers).
query_answers(fine_ceiling_floor, Profile, Answers) :-
    findall(Ceiling - Citations, fine_ceiling_floor(Profile, Ceiling, Citations), Answers).
query_answers(minimum_powers, Profile, Answers) :-
    findall(Powers, minimum_powers(Profile, Powers), Answers).
query_answers(escalation_powers_exercisable, Profile, Answers) :-
    findall(Result - Citations, escalation_powers_exercisable(Profile, Result, Citations), Answers).
query_answers(fine_barred_by_gdpr_fine, Profile, Answers) :-
    findall(Result - Citations, fine_barred_by_gdpr_fine(Profile, Result, Citations), Answers).
query_answers(data_protection_authority_information, Profile, Answers) :-
    findall(DutyList, data_protection_authority_information(Profile, DutyList), Answers).

subject_query(Subject, QueryName) :-
    nis2_supervision_fines_subject(Subject),
    query_name(QueryName).

subject_query_single(Subject, QueryName) :-
    nis2_supervision_fines_subject(Subject),
    nis2_supervision_fines_profile_for(Subject, Profile),
    query_name(QueryName),
    query_answers(QueryName, Profile, Answers),
    length(Answers, 1).

subject_status_in_table(Subject) :-
    nis2_supervision_fines_subject(Subject),
    nis2_supervision_fines_profile_for(Subject, Profile),
    nis2_supervision_fines_status(Profile, Status),
    nis2_supervision_fines_status_values(StatusValues),
    member(Status, StatusValues).

subject_citations(Subject, fine_ceiling_floor - Citations) :-
    nis2_supervision_fines_subject(Subject),
    nis2_supervision_fines_profile_for(Subject, Profile),
    fine_ceiling_floor(Profile, _, Citations).
subject_citations(Subject, escalation_powers_exercisable - Citations) :-
    nis2_supervision_fines_subject(Subject),
    nis2_supervision_fines_profile_for(Subject, Profile),
    escalation_powers_exercisable(Profile, _, Citations).
subject_citations(Subject, fine_barred_by_gdpr_fine - Citations) :-
    nis2_supervision_fines_subject(Subject),
    nis2_supervision_fines_profile_for(Subject, Profile),
    fine_barred_by_gdpr_fine(Profile, _, Citations).
subject_citations(Subject, data_protection_authority_information - Citations) :-
    nis2_supervision_fines_subject(Subject),
    nis2_supervision_fines_profile_for(Subject, Profile),
    data_protection_authority_information(Profile, DutyList),
    clausal_is_list(DutyList),
    maplist(duty_item_citation, DutyList, Citations).

duty_item_citation(inform_gdpr_supervisory_authorities(Citation), Citation).
duty_item_citation(inform_supervisory_authority_in_own_member_state(Citation), Citation).

recorded_citations([]).
recorded_citations([cite(CitationKey)|MoreCitations]) :-
    citation(CitationKey, _),
    recorded_citations(MoreCitations).

subject_citations_recorded(Subject, Labelled) :-
    subject_citations(Subject, Labelled),
    Labelled = _ - Citations,
    recorded_citations(Citations).

subject_floor(Subject, AmountEur) :-
    nis2_supervision_fines_subject(Subject),
    nis2_supervision_fines_profile_for(Subject, Profile),
    fine_ceiling_floor(Profile, minimum_national_maximum(AmountEur, _), _).

subject_floor_at_least_fixed(Subject, AmountEur) :-
    subject_floor(Subject, AmountEur),
    AmountEur >= 7000000.

essential_floor_at(TurnoverEur, AmountEur) :-
    fine_ceiling_floor([attribute(infringed_provision, art_21), attribute(entity_class, essential), attribute(worldwide_annual_turnover_eur, TurnoverEur)], minimum_national_maximum(AmountEur, _), _).

important_floor_at(TurnoverEur, AmountEur) :-
    fine_ceiling_floor([attribute(infringed_provision, art_23), attribute(entity_class, important), attribute(worldwide_annual_turnover_eur, TurnoverEur)], minimum_national_maximum(AmountEur, _), _).

test(a_public_administration_entity_has_no_escalation_power, fail) :-
    nis2_supervision_fines_profile_for(escalation_public_administration_entity, Profile),
    minimum_powers(Profile, Powers),
    member(power(escalation, _, _), Powers).

cp_test_names([totality_every_subject_classifies, determinism_every_query_gives_one_answer_per_subject, every_status_is_in_the_status_table, citation_completeness_every_returned_citation_is_recorded, every_floor_is_at_least_the_smaller_fixed_amount, the_essential_floor_never_falls_as_turnover_rises, the_important_floor_never_falls_as_turnover_rises, the_essential_floor_is_never_below_the_important_floor, a_barred_fine_leaves_every_power_in_place, a_public_administration_entity_keeps_the_administrative_fine]).
cp_test_fail_names([a_public_administration_entity_has_no_escalation_power]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
