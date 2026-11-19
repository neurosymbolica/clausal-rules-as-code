% SPDX-License-Identifier: EUPL-1.2
:- module(m__cn_pipl_handler_duties_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(clpz)).
:- use_module(m__cn_pipl_handler_duties_pipl_handler_duties, [decide_pipl_handler_duties/2, duty_status/4, duty_contents/2, pipl_handler_duties_status/2, pipl_handler_duties_status_values/1]).
:- use_module(m__cn_pipl_handler_duties_kernel, [pipl_handler_duties_input_problems/2]).
:- use_module(m__cn_pipl_handler_duties_fixtures, [pipl_handler_duties_subject/1, pipl_handler_duties_profile_for/2]).

duty(compliance_measures).
duty(protection_officer).
duty(officer_contact_details).
duty(china_representative).
duty(compliance_audit).
duty(impact_assessment).
duty(assessment_record_retention).
duty(breach_remedial_measures).
duty(breach_notice_to_department).
duty(breach_notice_to_individuals).
duty(large_platform_obligations).
duty(entrusted_party_safeguards).

topic(compliance_measures).
topic(impact_assessment).
topic(breach_notice).
topic(large_platform_obligations).

duty_status_vocabulary([cn_pipl_art_3_p2, cn_pipl_art_3_p2_i1, cn_pipl_art_3_p2_i2, cn_pipl_art_3_p2_i3, cn_pipl_art_51_p1, cn_pipl_art_52_p1, cn_pipl_art_52_p2, cn_pipl_art_53_p1, cn_pipl_art_54_p1, cn_pipl_art_55_p1, cn_pipl_art_55_p1_i1, cn_pipl_art_55_p1_i2, cn_pipl_art_55_p1_i3, cn_pipl_art_55_p1_i4, cn_pipl_art_55_p1_i5, cn_pipl_art_56_p1, cn_pipl_art_56_p2, cn_pipl_art_57_p1, cn_pipl_art_57_p2, cn_pipl_art_58_p1, cn_pipl_art_59_p1, cn_pipl_art_73_p1_i1, cn_pipl_art_73_p1_i2, cn_pipl_art_74_p1]).

duty_contents_vocabulary([cn_pipl_art_51_p1_i1, cn_pipl_art_51_p1_i2, cn_pipl_art_51_p1_i3, cn_pipl_art_51_p1_i4, cn_pipl_art_51_p1_i5, cn_pipl_art_51_p1_i6, cn_pipl_art_56_p1_i1, cn_pipl_art_56_p1_i2, cn_pipl_art_56_p1_i3, cn_pipl_art_57_p1_i1, cn_pipl_art_57_p1_i2, cn_pipl_art_57_p1_i3, cn_pipl_art_58_p1_i1, cn_pipl_art_58_p1_i2, cn_pipl_art_58_p1_i3, cn_pipl_art_58_p1_i4]).

subject_answer(Subject, Duty, Result, Citations) :-
    pipl_handler_duties_subject(Subject),
    duty(Duty),
    pipl_handler_duties_profile_for(Subject, Profile),
    duty_status(Duty, Profile, Result, Citations).

subject_duty_answer_count(Subject, Duty, Count) :-
    pipl_handler_duties_subject(Subject),
    duty(Duty),
    pipl_handler_duties_profile_for(Subject, Profile),
    findall(Result - Citations, duty_status(Duty, Profile, Result, Citations), Answers),
    length(Answers, Count).

subject_verdict_count(Subject, Count) :-
    pipl_handler_duties_subject(Subject),
    pipl_handler_duties_profile_for(Subject, Profile),
    findall(Verdict, decide_pipl_handler_duties(Profile, Verdict), Verdicts),
    length(Verdicts, Count).

topic_list_count(Topic, Count) :-
    topic(Topic),
    findall(Items, duty_contents(Topic, Items), Lists),
    length(Lists, Count).

result_kind(required, cited).
result_kind(required_in_advance, cited).
result_kind(required_immediately, cited).
result_kind(required_for_at_least_three_years, cited).
result_kind(notice_may_be_omitted, cited).
result_kind(not_required, cited).
result_kind(not_in_force, cited).
result_kind(pinned_text_not_applicable, uncited).
result_kind(indeterminate(_), uncited).
result_kind(needs_legal_review(_, _), uncited).
result_kind(input_problems(_), uncited).

citations_kind([], uncited).
citations_kind([_|_], cited).

answer_shape(ResultKind - CitationsKind) :-
    subject_answer(_, _, Result, Citations),
    result_kind(Result, ResultKind),
    citations_kind(Citations, CitationsKind).

answer_citation_key(Key) :-
    subject_answer(_, _, _, Citations),
    member(cite(Key), Citations).

contents_citation_key(Key) :-
    topic(Topic),
    duty_contents(Topic, Items),
    member(content_item(_, cite(Key)), Items).

allowed_duty_citation(Key) :-
    duty_status_vocabulary(Vocabulary),
    member(Key, Vocabulary).

allowed_contents_citation(Key) :-
    duty_contents_vocabulary(Vocabulary),
    member(Key, Vocabulary).

single_missing_key(indeterminate([Key])) :-
    atom(Key).

well_formed_referral(needs_legal_review(open_textured(Input, cite(Key)), [inputs_relied_on(Pairs)])) :-
    atom(Key),
    member(Input - unsure, Pairs).

set_without_duplicates(Citations) :-
    sort(Citations, Sorted),
    length(Citations, Count),
    length(Sorted, Count).

test(totality_and_determinism_of_duty_status) :-
    findall(Subject, pipl_handler_duties_subject(Subject), Subjects),
    length(Subjects, SubjectCount),
    ExpectedCount #= SubjectCount * 12,
    findall(Count, subject_duty_answer_count(_, _, Count), Counts),
    length(Counts, ExpectedCount),
    sort(Counts, [1]).
test(totality_and_determinism_of_the_facade) :-
    findall(Subject, pipl_handler_duties_subject(Subject), Subjects),
    length(Subjects, SubjectCount),
    findall(Count, subject_verdict_count(_, Count), Counts),
    length(Counts, SubjectCount),
    sort(Counts, [1]).
test(every_topic_gives_one_list) :-
    findall(Count, topic_list_count(_, Count), Counts),
    Counts == [1, 1, 1, 1].
test(the_input_check_answers_once_on_every_subject) :-
    findall(Subject - Problems, (pipl_handler_duties_subject(Subject), pipl_handler_duties_profile_for(Subject, Profile), pipl_handler_duties_input_problems(Profile, Problems)), Pairs),
    findall(Subject, pipl_handler_duties_subject(Subject), Subjects),
    same_length(Pairs, Subjects).
test(final_answers_are_cited_and_the_others_are_not) :-
    findall(Shape, answer_shape(Shape), Shapes),
    sort(Shapes, Sorted),
    Sorted == [cited - cited, uncited - uncited].
test(every_citation_is_in_the_duty_status_vocabulary) :-
    findall(Key, answer_citation_key(Key), Keys),
    sort(Keys, [FirstKey|OtherKeys]),
    maplist(allowed_duty_citation, [FirstKey|OtherKeys]).
test(every_content_citation_is_in_the_contents_vocabulary) :-
    findall(Key, contents_citation_key(Key), Keys),
    length(Keys, 16),
    maplist(allowed_contents_citation, Keys).
test(citation_lists_are_sets) :-
    findall(Citations, subject_answer(_, _, _, Citations), CitationLists),
    maplist(set_without_duplicates, CitationLists).
test(every_indeterminate_answer_names_one_key) :-
    findall(Result, (subject_answer(_, _, Result, _), Result = indeterminate(_)), Results),
    Results = [_|_],
    maplist(single_missing_key, Results).
test(every_referral_relies_on_its_unsure_input) :-
    findall(Result, (subject_answer(_, _, Result, _), Result = needs_legal_review(_, _)), Results),
    Results = [_|_],
    maplist(well_formed_referral, Results).
test(not_in_force_dominates_every_other_key) :-
    Profile = [attribute(reference_date, date(2020, 1, 1)), attribute(pinned_articles_unamended_on_reference_date, false), attribute(decides_purposes_and_means, unsure)],
    findall(Result, (duty(Duty), duty_status(Duty, Profile, Result, _)), Results),
    sort(Results, [not_in_force]).
test(the_entrusted_party_duty_ignores_the_handler_key) :-
    findall(Result, (member(Handler, [true, false, unsure]), duty_status(entrusted_party_safeguards, [attribute(reference_date, date(2024, 1, 1)), attribute(pinned_articles_unamended_on_reference_date, true), attribute(decides_purposes_and_means, Handler), attribute(processes_on_entrustment, true)], Result, _)), Results),
    Results == [required, required, required].
test(every_facade_status_is_tabled_and_reached) :-
    findall(Status, (pipl_handler_duties_subject(Subject), pipl_handler_duties_profile_for(Subject, Profile), pipl_handler_duties_input_problems(Profile, []), pipl_handler_duties_status(Profile, Status)), Statuses),
    sort(Statuses, Sorted),
    pipl_handler_duties_status_values(Values),
    sort(Values, SortedValues),
    Sorted == SortedValues.

cp_test_names([totality_and_determinism_of_duty_status, totality_and_determinism_of_the_facade, every_topic_gives_one_list, the_input_check_answers_once_on_every_subject, final_answers_are_cited_and_the_others_are_not, every_citation_is_in_the_duty_status_vocabulary, every_content_citation_is_in_the_contents_vocabulary, citation_lists_are_sets, every_indeterminate_answer_names_one_key, every_referral_relies_on_its_unsure_input, not_in_force_dominates_every_other_key, the_entrusted_party_duty_ignores_the_handler_key, every_facade_status_is_tabled_and_reached]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
