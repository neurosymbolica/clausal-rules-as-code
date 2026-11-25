% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_change_management_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_rts_change_management_dora_rts_change_management, [ict_change_management_duties_required/3, ict_change_management_duties_complete/3, ict_change_management_duties_outstanding/3, decide_dora_rts_change_management/2]).
:- use_module(m__eu_dora_rts_change_management_fixtures, [dora_rts_change_management_subject/1, dora_rts_change_management_profile_for/2]).

query_name(duties_required).
query_name(duties_complete).
query_name(duties_outstanding).

query_answer(duties_required, Profile, Result, Citations) :-
    ict_change_management_duties_required(Profile, Result, Citations).
query_answer(duties_complete, Profile, Result, Citations) :-
    ict_change_management_duties_complete(Profile, Result, Citations).
query_answer(duties_outstanding, Profile, Result, Citations) :-
    ict_change_management_duties_outstanding(Profile, Result, Citations).

duty_sequence([verification_of_ict_security_requirements, independence_of_change_approval_functions, roles_for_specifying_and_planning_changes, roles_for_designing_the_transition, roles_for_controlled_testing_and_finalisation, roles_for_quality_assurance, documentation_of_purpose_and_scope_of_change, documentation_of_implementation_timeline, documentation_of_expected_outcomes, fall_back_procedures_and_responsibilities, management_of_emergency_changes, review_of_emergency_changes_after_implementation, impact_of_change_on_ict_security_measures, stringent_testing_after_significant_changes, central_counterparty_involvement_of_parties_in_testing, central_securities_depository_involvement_of_parties_in_testing]).

subsequence([], _).
subsequence([Element|Elements], [Element|Others]) :-
    subsequence(Elements, Others).
subsequence([Element|Elements], [Other|Others]) :-
    dif(Element, Other),
    subsequence([Element|Elements], Others).

vocabulary_citation(cite(eu_reg_2024_1774_art_17_1)).
vocabulary_citation(cite(eu_reg_2024_1774_art_17_2)).
vocabulary_citation(cite(eu_reg_2022_2554_art_16_1)).

final_result(complete).
final_result(incomplete).
final_result(none_outstanding).
final_result(simplified_framework_entity).
final_result(required([_|_])).
final_result(outstanding([_|_])).

answer_well_cited(input_problems([_|_]), []).
answer_well_cited(indeterminate([_]), []).
answer_well_cited(needs_legal_review(open_textured(_, cite(_)), [inputs_relied_on(_)]), []).
answer_well_cited(Result, [Citation|Citations]) :-
    final_result(Result),
    maplist(vocabulary_citation, [Citation|Citations]),
    sort([Citation|Citations], Distinct),
    length(Distinct, Count),
    length([Citation|Citations], Count).

consistent(complete, none_outstanding).
consistent(incomplete, outstanding(_)).
consistent(incomplete, indeterminate(_)).
consistent(incomplete, needs_legal_review(_, _)).
consistent(simplified_framework_entity, simplified_framework_entity).
consistent(input_problems(Problems), input_problems(Problems)).
consistent(indeterminate(_), indeterminate(_)).
consistent(indeterminate(_), needs_legal_review(_, _)).
consistent(needs_legal_review(_, _), needs_legal_review(_, _)).
consistent(needs_legal_review(_, _), indeterminate(_)).

one_answer_each(Profile) :-
    findall(Result - Citations, ict_change_management_duties_required(Profile, Result, Citations), [_]),
    findall(Result - Citations, ict_change_management_duties_complete(Profile, Result, Citations), [_]),
    findall(Result - Citations, ict_change_management_duties_outstanding(Profile, Result, Citations), [_]).

subject_classifies(Subject) :-
    dora_rts_change_management_subject(Subject),
    dora_rts_change_management_profile_for(Subject, Profile),
    decide_dora_rts_change_management(Profile, _Verdict).

test(totality_every_subject_classifies) :-
    findall(Subject, dora_rts_change_management_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_query_yields_exactly_one_answer) :-
    findall(Subject, dora_rts_change_management_subject(Subject), Subjects),
    findall(Subject, (dora_rts_change_management_subject(Subject), dora_rts_change_management_profile_for(Subject, Profile), one_answer_each(Profile)), DeterministicSubjects),
    DeterministicSubjects == Subjects.
test(citations_are_well_formed_for_every_answer) :-
    findall(Subject - QueryName, (dora_rts_change_management_subject(Subject), query_name(QueryName)), AllPairs),
    findall(Subject - QueryName, (dora_rts_change_management_subject(Subject), query_name(QueryName), dora_rts_change_management_profile_for(Subject, Profile), query_answer(QueryName, Profile, Result, Citations), answer_well_cited(Result, Citations)), WellCitedPairs),
    WellCitedPairs == AllPairs.
test(required_lists_keep_duty_order) :-
    duty_sequence(Sequence),
    findall(Duties, (dora_rts_change_management_subject(Subject), dora_rts_change_management_profile_for(Subject, Profile), ict_change_management_duties_required(Profile, required(Duties), _)), DutyLists),
    DutyLists = [_|_],
    maplist(subsequence_of(Sequence), DutyLists).
test(complete_and_outstanding_agree) :-
    findall(Subject, dora_rts_change_management_subject(Subject), Subjects),
    findall(Subject, (dora_rts_change_management_subject(Subject), dora_rts_change_management_profile_for(Subject, Profile), ict_change_management_duties_complete(Profile, CompleteResult, _), ict_change_management_duties_outstanding(Profile, OutstandingResult, _), consistent(CompleteResult, OutstandingResult)), ConsistentSubjects),
    ConsistentSubjects == Subjects.
test(outstanding_duties_are_required_duties) :-
    findall(Outstanding - Required, (dora_rts_change_management_subject(Subject), dora_rts_change_management_profile_for(Subject, Profile), ict_change_management_duties_outstanding(Profile, outstanding(Outstanding), _), ict_change_management_duties_required(Profile, required(Required), _)), Pairs),
    Pairs = [_|_],
    maplist(outstanding_within_required, Pairs).

subsequence_of(Sequence, Duties) :-
    subsequence(Duties, Sequence).

outstanding_within_required(Outstanding - Required) :-
    subsequence(Outstanding, Required).

cp_test_names([totality_every_subject_classifies, determinism_every_query_yields_exactly_one_answer, citations_are_well_formed_for_every_answer, required_lists_keep_duty_order, complete_and_outstanding_agree, outstanding_duties_are_required_duties]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
