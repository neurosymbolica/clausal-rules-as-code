% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_chapter_v_extras_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_chapter_v_extras_gdpr_chapter_v_extras, [decide_gdpr_chapter_v_extras/2, second_subparagraph_duty/5, foreign_judgment_or_decision_recognition/4, onward_transfer_condition/4, gdpr_chapter_v_extras_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_chapter_v_extras_kernel, [gdpr_chapter_v_extras_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_chapter_v_extras_fixtures, [gdpr_chapter_v_extras_subject/1, gdpr_chapter_v_extras_profile_for/2]).

duty_atoms([inform_supervisory_authority, inform_data_subject, document_assessment_and_safeguards]).

subject_profile(Subject, Profile) :-
    gdpr_chapter_v_extras_subject(Subject),
    gdpr_chapter_v_extras_profile_for(Subject, Profile).

subject_classifies(Subject) :-
    subject_profile(Subject, Profile),
    decide_gdpr_chapter_v_extras(Profile, _Verdict).

verdict_count(Subject, Count) :-
    subject_profile(Subject, Profile),
    findall(Verdict, decide_gdpr_chapter_v_extras(Profile, Verdict), Verdicts),
    length(Verdicts, Count).

duty_answer_count(Profile, Duty, Count) :-
    findall(Result - Basis - Citations, second_subparagraph_duty(Profile, Duty, Result, Basis, Citations), Answers),
    length(Answers, Count).

recognition_answer_count(Profile, Count) :-
    findall(Result - Basis - Citations, foreign_judgment_or_decision_recognition(Profile, Result, Basis, Citations), Answers),
    length(Answers, Count).

onward_answer_count(Profile, Count) :-
    findall(Result - Basis - Citations, onward_transfer_condition(Profile, Result, Basis, Citations), Answers),
    length(Answers, Count).

input_check_count(Profile, Count) :-
    findall(Problems, gdpr_chapter_v_extras_input_problems(Profile, Problems), Answers),
    length(Answers, Count).

all_answers(Answers) :-
    duty_atoms(Duties),
    findall(Result - Basis - Citations, (subject_profile(_, Profile), member(Duty, Duties), second_subparagraph_duty(Profile, Duty, Result, Basis, Citations)), DutyAnswers),
    findall(Result - Basis - Citations, (subject_profile(_, Profile), foreign_judgment_or_decision_recognition(Profile, Result, Basis, Citations)), RecognitionAnswers),
    findall(Result - Basis - Citations, (subject_profile(_, Profile), onward_transfer_condition(Profile, Result, Basis, Citations)), OnwardAnswers),
    append([DutyAnswers, RecognitionAnswers, OnwardAnswers], Answers).

final_result(duty_met).
final_result(duty_not_met).
final_result(no_second_subparagraph_transfer).
final_result(article_48_not_engaged).
final_result(not_barred_by_article_48).
final_result(not_recognisable_or_enforceable).
final_result(not_an_onward_transfer).
final_result(onward_transfer_may_take_place).
final_result(onward_transfer_may_not_take_place).

shape_holds(indeterminate([_]) - [] - []).
shape_holds(needs_legal_review(cross_reference_unresolved(cite(_), cite(_)), [resolution(cite(_), not_attempted), inputs_relied_on([_ - absent])]) - [] - []).
shape_holds(input_problems([_|_]) - [] - []).
shape_holds(not_a_processor_duty - [] - [cite(eu_reg_2016_679_art_49_1_second_subpara)]).
shape_holds(Result - [outside_fact(_, attested(_, attestation(_, _, _, _)))|_] - [cite(_)]) :-
    final_result(Result).

citations_set_like(_ - _ - Citations) :-
    sort(Citations, SortedCitations),
    length(Citations, CitationCount),
    length(SortedCitations, CitationCount).

status_in_vocabulary(Status) :-
    gdpr_chapter_v_extras_status_values(StatusValues),
    member(Status, StatusValues).
status_in_vocabulary(input_problems([_|_])).

test(totality_every_subject_classifies) :-
    findall(Subject, gdpr_chapter_v_extras_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_subject_has_one_verdict) :-
    findall(Count, verdict_count(_, Count), Counts),
    length(Counts, 16),
    maplist(=(1), Counts).
test(determinism_every_duty_query_yields_one_answer) :-
    duty_atoms(Duties),
    findall(Count, (subject_profile(_, Profile), member(Duty, Duties), duty_answer_count(Profile, Duty, Count)), Counts),
    length(Counts, 48),
    maplist(=(1), Counts).
test(determinism_every_recognition_query_yields_one_answer) :-
    findall(Count, (subject_profile(_, Profile), recognition_answer_count(Profile, Count)), Counts),
    length(Counts, 16),
    maplist(=(1), Counts).
test(determinism_every_onward_query_yields_one_answer) :-
    findall(Count, (subject_profile(_, Profile), onward_answer_count(Profile, Count)), Counts),
    length(Counts, 16),
    maplist(=(1), Counts).
test(determinism_the_input_check_yields_one_answer) :-
    findall(Count, (subject_profile(_, Profile), input_check_count(Profile, Count)), Counts),
    length(Counts, 16),
    maplist(=(1), Counts),
    input_check_count(_, UnboundCount),
    UnboundCount == 1,
    input_check_count([_|_], PartialCount),
    PartialCount == 1.
test(every_answer_has_a_shape_the_limbs_allow) :-
    all_answers(Answers),
    length(Answers, 80),
    maplist(shape_holds, Answers).
test(every_citation_list_is_set_like) :-
    all_answers(Answers),
    maplist(citations_set_like, Answers).
test(every_facade_status_is_in_the_vocabulary) :-
    findall(Status, (subject_profile(_, Profile), decide_gdpr_chapter_v_extras(Profile, gdpr_chapter_v_extras_verdict(Status, _))), Statuses),
    maplist(status_in_vocabulary, Statuses).
test(a_duty_to_inform_is_never_a_processor_duty_whatever_the_fact) :-
    Attestation = attestation(host_user, host_timestamp, fixture_statement, none),
    findall(Result, (member(Profile, [[attribute(party_role, processor)], [attribute(party_role, processor), attribute(transfer_relies_on_article_49_1_second_subparagraph, attested(true, Attestation))], [attribute(party_role, processor), attribute(transfer_relies_on_article_49_1_second_subparagraph, attested(false, Attestation))]]), member(Duty, [inform_supervisory_authority, inform_data_subject]), second_subparagraph_duty(Profile, Duty, Result, _, _)), Results),
    Results == [not_a_processor_duty, not_a_processor_duty, not_a_processor_duty, not_a_processor_duty, not_a_processor_duty, not_a_processor_duty].
test(a_key_the_onward_query_does_not_read_leaves_its_answer) :-
    gdpr_chapter_v_extras_profile_for(onward_transfer_with_basis, BaseProfile),
    onward_transfer_condition(BaseProfile, Result, Basis, Citations),
    onward_transfer_condition([attribute(supervisory_authority_informed_of_transfer, false)|BaseProfile], Result, Basis, Citations).
test(a_key_the_recognition_query_does_not_read_leaves_its_answer) :-
    gdpr_chapter_v_extras_profile_for(foreign_judgment_with_agreement, BaseProfile),
    foreign_judgment_or_decision_recognition(BaseProfile, Result, Basis, Citations),
    foreign_judgment_or_decision_recognition([attribute(onward_transfer_has_chapter_v_basis, attested(false, attestation(host_user, host_timestamp, fixture_statement, none)))|BaseProfile], Result, Basis, Citations).
test(a_fulfilment_key_of_another_duty_leaves_the_duty_answer) :-
    Attestation = attestation(host_user, host_timestamp, fixture_statement, none),
    BaseProfile = [attribute(transfer_relies_on_article_49_1_second_subparagraph, attested(true, Attestation)), attribute(party_role, controller), attribute(supervisory_authority_informed_of_transfer, true)],
    second_subparagraph_duty(BaseProfile, inform_supervisory_authority, duty_met, Basis, Citations),
    second_subparagraph_duty([attribute(data_subject_informed_of_transfer, false)|BaseProfile], inform_supervisory_authority, duty_met, Basis, Citations).

test(the_shape_check_rejects_a_final_result_without_basis, fail) :-
    shape_holds(duty_met - [] - [cite(eu_reg_2016_679_art_49_6)]).
test(the_shape_check_rejects_a_status_with_citations, fail) :-
    shape_holds(indeterminate([party_role]) - [] - [cite(eu_reg_2016_679_art_49_6)]).
test(the_set_like_check_rejects_a_repeated_citation, fail) :-
    citations_set_like(duty_met - [] - [cite(eu_reg_2016_679_art_44), cite(eu_reg_2016_679_art_44)]).

cp_test_names([totality_every_subject_classifies, determinism_every_subject_has_one_verdict, determinism_every_duty_query_yields_one_answer, determinism_every_recognition_query_yields_one_answer, determinism_every_onward_query_yields_one_answer, determinism_the_input_check_yields_one_answer, every_answer_has_a_shape_the_limbs_allow, every_citation_list_is_set_like, every_facade_status_is_in_the_vocabulary, a_duty_to_inform_is_never_a_processor_duty_whatever_the_fact, a_key_the_onward_query_does_not_read_leaves_its_answer, a_key_the_recognition_query_does_not_read_leaves_its_answer, a_fulfilment_key_of_another_duty_leaves_the_duty_answer]).
cp_test_fail_names([the_shape_check_rejects_a_final_result_without_basis, the_shape_check_rejects_a_status_with_citations, the_set_like_check_rejects_a_repeated_citation]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
