% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_complaints_and_judicial_remedies_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_complaints_and_judicial_remedies_gdpr_complaints_and_judicial_remedies, [authority_inaction_remedy_right/4, decide_gdpr_complaints_and_judicial_remedies/2, gdpr_complaints_and_judicial_remedies_checklist/2]).
:- use_module(m__eu_data_protection_gdpr_complaints_and_judicial_remedies_fixtures, [gdpr_complaints_and_judicial_remedies_subject/1, gdpr_complaints_and_judicial_remedies_profile_for/2, gdpr_complaints_and_judicial_remedies_assess/2]).

expected(complaint_data_subject_who_considers, complaint_right_exists).
expected(complaint_data_subject_who_does_not_consider, no_complaint_right).
expected(complaint_not_a_data_subject, no_complaint_right).
expected(complaint_consideration_not_stated, indeterminate([data_subject_considers_processing_infringes_regulation])).
expected(complaint_settled_false_before_missing, no_complaint_right).
expected(decision_binding_and_concerning, decision_remedy_right_exists).
expected(decision_not_binding, no_decision_remedy_right).
expected(decision_not_concerning, no_decision_remedy_right).
expected(decision_binding_unsure, needs_legal_review(open_textured(decision_is_legally_binding, cite(eu_reg_2016_679_art_78_1)), [inputs_relied_on([decision_is_legally_binding - unsure, decision_concerns_the_caller - true])])).
expected(decision_concerns_unsure, needs_legal_review(open_textured(decision_concerns_the_caller, cite(eu_reg_2016_679_art_78_1)), [inputs_relied_on([decision_is_legally_binding - true, decision_concerns_the_caller - unsure])])).
expected(decision_unsure_with_concern_missing, indeterminate([decision_concerns_the_caller])).
expected(inaction_unhandled_competent, inaction_remedy_right_exists).
expected(inaction_handled_and_informed, no_inaction_remedy_right).
expected(inaction_uninformed_after_three_months, inaction_remedy_right_exists).
expected(inaction_handled_within_three_months, no_inaction_remedy_right).
expected(inaction_authority_not_competent, no_inaction_remedy_right).
expected(inaction_competence_not_stated, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_78_2), cite(competence_statement)), [resolution(cite(competence_statement), not_attempted), inputs_relied_on([authority_competent_under_articles_55_and_56 - absent])])).
expected(inaction_no_complaint_lodged, no_inaction_remedy_right).
expected(inaction_handling_not_stated, indeterminate([authority_handled_the_complaint])).
expected(judicial_data_subject_who_considers, judicial_remedy_right_exists).
expected(judicial_data_subject_who_does_not_consider, no_judicial_remedy_right).
expected(judicial_not_a_data_subject, no_judicial_remedy_right).
expected(forum_public_authority_defendant, forum_establishment_state_only).
expected(forum_private_defendant, forum_establishment_or_habitual_residence_state).
expected(forum_exception_not_stated, indeterminate([defendant_is_member_state_public_authority_acting_in_public_powers])).
expected(input_unknown_key, input_problems([unknown_key(colour)])).
expected(input_crisp_key_unsure, input_problems([wrong_type(is_data_subject)])).
expected(input_duplicate_key, input_problems([duplicate_key(is_data_subject)])).
expected(input_not_a_profile, input_problems([wrong_type(profile)])).
expected(input_mixed_problems, input_problems([duplicate_key(is_data_subject), unknown_key(colour)])).

expected_results_hold([]).
expected_results_hold([Subject - Result|Rest]) :-
    findall(Found, gdpr_complaints_and_judicial_remedies_assess(Subject, gdpr_complaints_and_judicial_remedies_verdict(Found, _)), Founds),
    Founds == [Result],
    expected_results_hold(Rest).

test(every_subject_has_an_expected_result) :-
    findall(Subject, gdpr_complaints_and_judicial_remedies_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, expected(Subject, _), ExpectedSubjects),
    sort(ExpectedSubjects, SubjectSet).
test(every_subject_reads_out_exactly_its_expected_result) :-
    findall(Subject - Result, expected(Subject, Result), Pairs),
    expected_results_hold(Pairs).
test(the_inaction_basis_copies_the_attested_term) :-
    gdpr_complaints_and_judicial_remedies_profile_for(inaction_uninformed_after_three_months, Profile),
    member(attribute(authority_competent_under_articles_55_and_56, Attested), Profile),
    findall(Result - Basis - Citations, authority_inaction_remedy_right(Profile, Result, Basis, Citations), Answers),
    Answers == [inaction_remedy_right_exists - [outside_fact(authority_competent_under_articles_55_and_56, Attested)] - [cite(eu_reg_2016_679_art_78_2)]].
test(a_referral_reads_out_an_empty_basis_and_no_citation) :-
    gdpr_complaints_and_judicial_remedies_profile_for(inaction_competence_not_stated, Profile),
    findall(Basis - Citations, authority_inaction_remedy_right(Profile, _, Basis, Citations), Answers),
    Answers == [[] - []].
test(the_verdict_carries_a_citation) :-
    gdpr_complaints_and_judicial_remedies_profile_for(complaint_data_subject_who_considers, Profile),
    decide_gdpr_complaints_and_judicial_remedies(Profile, gdpr_complaints_and_judicial_remedies_verdict(remedy_available, [cite(eu_reg_2016_679_art_77_1)])).
test(the_checklist_reads_out_one_cited_item_per_right) :-
    gdpr_complaints_and_judicial_remedies_profile_for(judicial_data_subject_who_considers, Profile),
    gdpr_complaints_and_judicial_remedies_checklist(Profile, Items),
    findall(Id - Citation, member(item(Id, _, Citation), Items), Rows),
    Rows == [complaint_right - cite(eu_reg_2016_679_art_77_1), authority_decision_remedy_right - cite(eu_reg_2016_679_art_78_1), authority_inaction_remedy_right - cite(eu_reg_2016_679_art_78_2), controller_processor_remedy_right - cite(eu_reg_2016_679_art_79_1)],
    member(item(controller_processor_remedy_right, met, _), Items).

cp_test_names([every_subject_has_an_expected_result, every_subject_reads_out_exactly_its_expected_result, the_inaction_basis_copies_the_attested_term, a_referral_reads_out_an_empty_basis_and_no_citation, the_verdict_carries_a_citation, the_checklist_reads_out_one_cited_item_per_right]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
