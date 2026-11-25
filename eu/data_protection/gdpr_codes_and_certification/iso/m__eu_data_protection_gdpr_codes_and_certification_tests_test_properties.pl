% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_codes_and_certification_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_codes_and_certification_gdpr_codes_and_certification, [certification_status/5, accreditation_status/6, decide_gdpr_codes_and_certification/2, gdpr_codes_and_certification_status/2, gdpr_codes_and_certification_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_codes_and_certification_fixtures, [gdpr_codes_and_certification_subject/1, gdpr_codes_and_certification_profile_for/2, gdpr_codes_and_certification_assess/2]).

subject_classifies(Subject) :-
    gdpr_codes_and_certification_subject(Subject),
    gdpr_codes_and_certification_profile_for(Subject, Profile),
    decide_gdpr_codes_and_certification(Profile, _Verdict).

subject_assessed(Subject) :-
    gdpr_codes_and_certification_subject(Subject),
    gdpr_codes_and_certification_assess(Subject, _Verdict).

subject_verdicts(Subject - Verdicts) :-
    gdpr_codes_and_certification_subject(Subject),
    findall(Verdict, gdpr_codes_and_certification_assess(Subject, Verdict), Verdicts).

single_verdict(_Subject - [_Verdict]).

citation_shape(gdpr_codes_and_certification_verdict(input_problems(_), [])).
citation_shape(gdpr_codes_and_certification_verdict(indeterminate([_]), [])).
citation_shape(gdpr_codes_and_certification_verdict(needs_legal_review(open_textured(_, cite(_)), [inputs_relied_on(_)]), [])).
citation_shape(gdpr_codes_and_certification_verdict(certification_result(_, _), [Citation|Citations])) :-
    maplist(cite_term, [Citation|Citations]).
citation_shape(gdpr_codes_and_certification_verdict(code_result(_, _), [Citation|Citations])) :-
    maplist(cite_term, [Citation|Citations]).
citation_shape(gdpr_codes_and_certification_verdict(Result, [Citation|Citations])) :-
    atom(Result),
    maplist(cite_term, [Citation|Citations]).

cite_term(cite(Key)) :-
    atom(Key).

status_in_table(Subject) :-
    gdpr_codes_and_certification_profile_for(Subject, Profile),
    gdpr_codes_and_certification_status(Profile, Status),
    gdpr_codes_and_certification_status_values(StatusValues),
    member(Status, StatusValues).

certification_case(certification_in_force, date(2024, 1, 15), date(2026, 6, 1)).
certification_case(certification_withdrawn, date(2024, 1, 15), date(2026, 6, 1)).
certification_case(certification_requirements_unsure, date(2024, 1, 15), date(2026, 6, 1)).
certification_case(certification_issuer_absent, date(2024, 1, 15), date(2026, 6, 1)).
certification_case(certification_for_transfers_conditions_met, date(2024, 1, 15), date(2026, 6, 1)).

monitoring_body_case(monitoring_body_conditions_met).
monitoring_body_case(monitoring_body_independence_unsure).
monitoring_body_case(monitoring_body_actions_infringe).

certification_unread_keys_invariant(Subject) :-
    certification_case(Subject, IssuedOn, CheckDate),
    gdpr_codes_and_certification_profile_for(Subject, Profile),
    certification_status(Profile, IssuedOn, CheckDate, Result, Citations),
    append(Profile, [attribute(processing_by_public_authority_or_body, true), attribute(monitoring_body_accredited, false), attribute(certification_body_accrediting_entity, other_entity)], Extended),
    certification_status(Extended, IssuedOn, CheckDate, ExtendedResult, ExtendedCitations),
    ExtendedResult == Result,
    ExtendedCitations == Citations.

monitoring_body_unread_keys_invariant(Subject) :-
    monitoring_body_case(Subject),
    gdpr_codes_and_certification_profile_for(Subject, Profile),
    accreditation_status(Profile, monitoring_body, date(2020, 1, 1), date(2030, 1, 1), Result, Citations),
    append(Profile, [attribute(certification_body_accreditation_revoked, true), attribute(certification_body_actions_infringe_regulation, unsure), attribute(certification_withdrawn, true)], Extended),
    accreditation_status(Extended, monitoring_body, date(2020, 1, 1), date(2030, 1, 1), ExtendedResult, ExtendedCitations),
    ExtendedResult == Result,
    ExtendedCitations == Citations.

test(totality_every_subject_classifies) :-
    findall(Subject, gdpr_codes_and_certification_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(totality_every_subject_is_assessed_by_its_own_query) :-
    findall(Subject, gdpr_codes_and_certification_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_assessed(Subject), AssessedSubjects),
    sort(AssessedSubjects, SubjectSet).
test(determinism_every_subject_yields_exactly_one_verdict) :-
    findall(Row, subject_verdicts(Row), Rows),
    Rows = [_|_],
    maplist(single_verdict, Rows).
test(every_verdict_has_the_citation_shape_of_its_status) :-
    findall(Verdict, (gdpr_codes_and_certification_subject(Subject), gdpr_codes_and_certification_assess(Subject, Verdict)), Verdicts),
    Verdicts = [_|_],
    maplist(citation_shape, Verdicts).
test(every_facade_status_is_in_the_status_table) :-
    findall(Subject, gdpr_codes_and_certification_subject(Subject), Subjects),
    maplist(status_in_table, Subjects).
test(unread_keys_never_change_a_certification_answer) :-
    findall(Subject, certification_case(Subject, _, _), Subjects),
    maplist(certification_unread_keys_invariant, Subjects).
test(unread_keys_never_change_a_monitoring_body_answer) :-
    findall(Subject, monitoring_body_case(Subject), Subjects),
    maplist(monitoring_body_unread_keys_invariant, Subjects).

test(a_final_answer_never_carries_an_empty_citation_list, fail) :-
    citation_shape(gdpr_codes_and_certification_verdict(certification_result(withdrawn, not_relied_on_for_transfers), [])).
test(a_status_that_is_not_final_never_carries_citations, fail) :-
    citation_shape(gdpr_codes_and_certification_verdict(indeterminate([certification_issuer]), [cite(eu_reg_2016_679_art_42_5)])).

cp_test_names([totality_every_subject_classifies, totality_every_subject_is_assessed_by_its_own_query, determinism_every_subject_yields_exactly_one_verdict, every_verdict_has_the_citation_shape_of_its_status, every_facade_status_is_in_the_status_table, unread_keys_never_change_a_certification_answer, unread_keys_never_change_a_monitoring_body_answer]).
cp_test_fail_names([a_final_answer_never_carries_an_empty_citation_list, a_status_that_is_not_final_never_carries_citations]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
