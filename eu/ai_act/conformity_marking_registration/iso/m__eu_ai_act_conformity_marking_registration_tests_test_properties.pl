% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_conformity_marking_registration_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_is_list/1, clausal_msort/2]).
:- use_module(m__eu_ai_act_conformity_marking_registration_conformity_marking_registration, [conformity_assessment_procedure/4, annex_vii_notified_body/4, new_conformity_assessment_status/4, declaration_of_conformity_status/4, declaration_keeping_status/4, ce_marking_status/5, registration_status/5, listed_items/3, decide_conformity_marking_registration/2]).
:- use_module(m__eu_ai_act_conformity_marking_registration_citations, [citation/2]).
:- use_module(m__eu_ai_act_conformity_marking_registration_fixtures, [conformity_marking_registration_subject/1, conformity_marking_registration_profile_for/2]).

subject_case(Subject, Profile, AssessmentDate) :-
    conformity_marking_registration_profile_for(Subject, assessment(Profile, AssessmentDate)).

query_descriptor(conformity_assessment_procedure).
query_descriptor(annex_vii_notified_body).
query_descriptor(new_conformity_assessment_status).
query_descriptor(declaration_of_conformity_status).
query_descriptor(ce_marking(digital_ce_marking)).
query_descriptor(ce_marking(ce_marking_affixed_to_the_system)).
query_descriptor(ce_marking(ce_marking_affixed_to_the_packaging_or_accompanying_documentation)).
query_descriptor(ce_marking(identification_number_of_the_notified_body)).
query_descriptor(ce_marking(indication_of_the_other_union_law)).
query_descriptor(registration(provider)).
query_descriptor(registration(deployer)).

ask(conformity_assessment_procedure, Profile, AssessmentDate, Result, Citations) :-
    conformity_assessment_procedure(Profile, AssessmentDate, Result, Citations).
ask(annex_vii_notified_body, Profile, AssessmentDate, Result, Citations) :-
    annex_vii_notified_body(Profile, AssessmentDate, Result, Citations).
ask(new_conformity_assessment_status, Profile, AssessmentDate, Result, Citations) :-
    new_conformity_assessment_status(Profile, AssessmentDate, Result, Citations).
ask(declaration_of_conformity_status, Profile, AssessmentDate, Result, Citations) :-
    declaration_of_conformity_status(Profile, AssessmentDate, Result, Citations).
ask(ce_marking(Element), Profile, AssessmentDate, Result, Citations) :-
    ce_marking_status(Profile, Element, AssessmentDate, Result, Citations).
ask(registration(Registrant), Profile, AssessmentDate, Result, Citations) :-
    registration_status(Profile, Registrant, AssessmentDate, Result, Citations).

subject_descriptor(Subject, Descriptor) :-
    conformity_marking_registration_subject(Subject),
    query_descriptor(Descriptor).

all_pairs(Pairs) :-
    findall(Subject - Descriptor, subject_descriptor(Subject, Descriptor), Pairs).

single_answer(Subject - Descriptor) :-
    subject_case(Subject, Profile, AssessmentDate),
    findall(Result - Citations, ask(Descriptor, Profile, AssessmentDate, Result, Citations), Answers),
    length(Answers, 1).

well_shaped(Subject - Descriptor) :-
    subject_case(Subject, Profile, AssessmentDate),
    ask(Descriptor, Profile, AssessmentDate, Result, Citations),
    shape_ok(Result, Citations).

shape_ok(Result, [_|_]) :-
    atom(Result).
shape_ok(indeterminate([Key]), []) :-
    atom(Key).
shape_ok(needs_legal_review(open_textured(Key, cite(Citation)), [inputs_relied_on(Pairs)]), []) :-
    atom(Key),
    atom(Citation),
    clausal_is_list(Pairs).
shape_ok(input_problems([_|_]), []).

citations_recorded_and_distinct(Subject - Descriptor) :-
    subject_case(Subject, Profile, AssessmentDate),
    ask(Descriptor, Profile, AssessmentDate, _, Citations),
    maplist(recorded_citation, Citations),
    sort(Citations, Distinct),
    length(Citations, Count),
    length(Distinct, Count).

recorded_citation(cite(Key)) :-
    citation(Key, _).

early_answer(Subject - Descriptor) :-
    subject_case(Subject, Profile, _),
    ask(Descriptor, Profile, date(2027, 12, 1), Result, Citations),
    Result == not_applicable_on_date,
    clausal_msort(Citations, [cite(eu_reg_2024_1689_art_113), cite(eu_reg_2024_1689_art_113_c), cite(eu_reg_2024_1689_art_113_c_i)]).

subject_classifies(Subject) :-
    conformity_marking_registration_subject(Subject),
    conformity_marking_registration_profile_for(Subject, AssessmentCase),
    decide_conformity_marking_registration(AssessmentCase, _Verdict).

item_list_name(annex_vi_internal_control, 3).
item_list_name(annex_vii_quality_management_system_application, 6).
item_list_name(annex_vii_technical_documentation_application, 3).
item_list_name(annex_viii_section_a, 13).
item_list_name(annex_viii_section_b, 7).
item_list_name(annex_viii_section_c, 5).
item_list_name(annex_ix, 5).
item_list_name(annex_viii_section_a_secure_section, 7).
item_list_name(annex_viii_section_b_secure_section, 6).
item_list_name(annex_viii_section_c_secure_section, 3).
item_list_name(annex_ix_secure_section, 4).

list_has_one_answer_of_its_length(ItemList - Length) :-
    findall(Items - Citations, listed_items(ItemList, Items, Citations), [Items - [_|_]]),
    length(Items, Length).

test(totality_every_subject_classifies) :-
    findall(Subject, conformity_marking_registration_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_query_on_every_subject_has_exactly_one_answer) :-
    all_pairs(Pairs),
    Pairs = [_|_],
    maplist(single_answer, Pairs).
test(every_answer_has_the_contract_shape) :-
    all_pairs(Pairs),
    maplist(well_shaped, Pairs).
test(every_citation_is_recorded_and_written_once) :-
    all_pairs(Pairs),
    maplist(citations_recorded_and_distinct, Pairs).
test(before_2_december_2027_nothing_applies_to_any_subject) :-
    all_pairs(Pairs),
    maplist(early_answer, Pairs).
test(every_item_list_has_one_answer_of_its_length) :-
    findall(ItemList - Length, item_list_name(ItemList, Length), Lists),
    length(Lists, 11),
    maplist(list_has_one_answer_of_its_length, Lists).
test(the_keeping_status_has_one_answer) :-
    findall(Result - Citations, declaration_keeping_status(date(2028, 2, 29), date(2038, 2, 28), Result, Citations), Answers),
    Answers == [declaration_to_be_kept - [cite(eu_reg_2024_1689_art_47_1)]].
test(the_input_problem_answer_has_one_solution) :-
    findall(Result - Citations, registration_status(colour, provider, date(2029, 1, 1), Result, Citations), Answers),
    Answers == [input_problems([wrong_type(profile)]) - []].

cp_test_names([totality_every_subject_classifies, determinism_every_query_on_every_subject_has_exactly_one_answer, every_answer_has_the_contract_shape, every_citation_is_recorded_and_written_once, before_2_december_2027_nothing_applies_to_any_subject, every_item_list_has_one_answer_of_its_length, the_keeping_status_has_one_answer, the_input_problem_answer_has_one_solution]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
