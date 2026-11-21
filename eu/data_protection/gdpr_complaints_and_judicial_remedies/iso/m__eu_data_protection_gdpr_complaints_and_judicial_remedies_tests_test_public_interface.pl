% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_complaints_and_judicial_remedies_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [subtract/3]).
:- use_module(m__eu_data_protection_gdpr_complaints_and_judicial_remedies_gdpr_complaints_and_judicial_remedies, [decide_gdpr_complaints_and_judicial_remedies/2, gdpr_complaints_and_judicial_remedies_status/2, gdpr_complaints_and_judicial_remedies_checklist/2, gdpr_complaints_and_judicial_remedies_decision_resolvable/1, gdpr_complaints_and_judicial_remedies_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_complaints_and_judicial_remedies_fixtures, [gdpr_complaints_and_judicial_remedies_subject/1, gdpr_complaints_and_judicial_remedies_profile_for/2, gdpr_complaints_and_judicial_remedies_assess/2]).

expected_result(full_positive, complaint_right, complaint_right_exists).
expected_result(full_positive, authority_decision_remedy_right, decision_remedy_right_exists).
expected_result(full_positive, authority_inaction_remedy_right, inaction_remedy_right_exists).
expected_result(full_positive, controller_processor_remedy_right, judicial_remedy_right_exists).
expected_result(full_positive, controller_processor_forum, forum_establishment_or_habitual_residence_state).
expected_result(not_a_data_subject, complaint_right, no_complaint_right).
expected_result(not_a_data_subject, authority_decision_remedy_right, decision_remedy_right_exists).
expected_result(not_a_data_subject, authority_inaction_remedy_right, no_inaction_remedy_right).
expected_result(not_a_data_subject, controller_processor_remedy_right, no_judicial_remedy_right).
expected_result(not_a_data_subject, controller_processor_forum, forum_establishment_or_habitual_residence_state).
expected_result(complaint_no_consideration, complaint_right, no_complaint_right).
expected_result(complaint_no_consideration, authority_decision_remedy_right, decision_remedy_right_exists).
expected_result(complaint_no_consideration, authority_inaction_remedy_right, inaction_remedy_right_exists).
expected_result(complaint_no_consideration, controller_processor_remedy_right, judicial_remedy_right_exists).
expected_result(complaint_no_consideration, controller_processor_forum, forum_establishment_or_habitual_residence_state).
expected_result(decision_not_binding, complaint_right, complaint_right_exists).
expected_result(decision_not_binding, authority_decision_remedy_right, no_decision_remedy_right).
expected_result(decision_not_binding, authority_inaction_remedy_right, inaction_remedy_right_exists).
expected_result(decision_not_binding, controller_processor_remedy_right, judicial_remedy_right_exists).
expected_result(decision_not_binding, controller_processor_forum, forum_establishment_or_habitual_residence_state).
expected_result(decision_unsure_binding, complaint_right, complaint_right_exists).
expected_result(decision_unsure_binding, authority_decision_remedy_right, needs_legal_review(open_textured(decision_is_legally_binding, cite(eu_reg_2016_679_art_78_1)), [inputs_relied_on([decision_is_legally_binding - unsure, decision_concerns_the_caller - true])])).
expected_result(decision_unsure_binding, authority_inaction_remedy_right, inaction_remedy_right_exists).
expected_result(decision_unsure_binding, controller_processor_remedy_right, judicial_remedy_right_exists).
expected_result(decision_unsure_binding, controller_processor_forum, forum_establishment_or_habitual_residence_state).
expected_result(decision_unsure_and_missing, complaint_right, complaint_right_exists).
expected_result(decision_unsure_and_missing, authority_decision_remedy_right, indeterminate([decision_concerns_the_caller])).
expected_result(decision_unsure_and_missing, authority_inaction_remedy_right, inaction_remedy_right_exists).
expected_result(decision_unsure_and_missing, controller_processor_remedy_right, judicial_remedy_right_exists).
expected_result(decision_unsure_and_missing, controller_processor_forum, forum_establishment_or_habitual_residence_state).
expected_result(inaction_competence_absent, complaint_right, complaint_right_exists).
expected_result(inaction_competence_absent, authority_decision_remedy_right, decision_remedy_right_exists).
expected_result(inaction_competence_absent, authority_inaction_remedy_right, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_78_2), cite(competence_statement)), [resolution(cite(competence_statement), not_attempted), inputs_relied_on([authority_competent_under_articles_55_and_56 - absent])])).
expected_result(inaction_competence_absent, controller_processor_remedy_right, judicial_remedy_right_exists).
expected_result(inaction_competence_absent, controller_processor_forum, forum_establishment_or_habitual_residence_state).
expected_result(inaction_competence_false, complaint_right, complaint_right_exists).
expected_result(inaction_competence_false, authority_decision_remedy_right, decision_remedy_right_exists).
expected_result(inaction_competence_false, authority_inaction_remedy_right, no_inaction_remedy_right).
expected_result(inaction_competence_false, controller_processor_remedy_right, judicial_remedy_right_exists).
expected_result(inaction_competence_false, controller_processor_forum, forum_establishment_or_habitual_residence_state).
expected_result(inaction_handled_and_informed, complaint_right, complaint_right_exists).
expected_result(inaction_handled_and_informed, authority_decision_remedy_right, decision_remedy_right_exists).
expected_result(inaction_handled_and_informed, authority_inaction_remedy_right, no_inaction_remedy_right).
expected_result(inaction_handled_and_informed, controller_processor_remedy_right, judicial_remedy_right_exists).
expected_result(inaction_handled_and_informed, controller_processor_forum, forum_establishment_or_habitual_residence_state).
expected_result(inaction_three_months_uninformed_handled_absent, complaint_right, complaint_right_exists).
expected_result(inaction_three_months_uninformed_handled_absent, authority_decision_remedy_right, decision_remedy_right_exists).
expected_result(inaction_three_months_uninformed_handled_absent, authority_inaction_remedy_right, inaction_remedy_right_exists).
expected_result(inaction_three_months_uninformed_handled_absent, controller_processor_remedy_right, judicial_remedy_right_exists).
expected_result(inaction_three_months_uninformed_handled_absent, controller_processor_forum, forum_establishment_or_habitual_residence_state).
expected_result(inaction_three_months_informed_handled_absent, complaint_right, complaint_right_exists).
expected_result(inaction_three_months_informed_handled_absent, authority_decision_remedy_right, decision_remedy_right_exists).
expected_result(inaction_three_months_informed_handled_absent, authority_inaction_remedy_right, indeterminate([authority_handled_the_complaint])).
expected_result(inaction_three_months_informed_handled_absent, controller_processor_remedy_right, judicial_remedy_right_exists).
expected_result(inaction_three_months_informed_handled_absent, controller_processor_forum, forum_establishment_or_habitual_residence_state).
expected_result(inaction_handled_three_months_absent, complaint_right, complaint_right_exists).
expected_result(inaction_handled_three_months_absent, authority_decision_remedy_right, decision_remedy_right_exists).
expected_result(inaction_handled_three_months_absent, authority_inaction_remedy_right, indeterminate([three_months_from_the_complaint_have_passed])).
expected_result(inaction_handled_three_months_absent, controller_processor_remedy_right, judicial_remedy_right_exists).
expected_result(inaction_handled_three_months_absent, controller_processor_forum, forum_establishment_or_habitual_residence_state).
expected_result(remedy_no_consideration, complaint_right, complaint_right_exists).
expected_result(remedy_no_consideration, authority_decision_remedy_right, decision_remedy_right_exists).
expected_result(remedy_no_consideration, authority_inaction_remedy_right, inaction_remedy_right_exists).
expected_result(remedy_no_consideration, controller_processor_remedy_right, no_judicial_remedy_right).
expected_result(remedy_no_consideration, controller_processor_forum, forum_establishment_or_habitual_residence_state).
expected_result(forum_public_authority, complaint_right, complaint_right_exists).
expected_result(forum_public_authority, authority_decision_remedy_right, decision_remedy_right_exists).
expected_result(forum_public_authority, authority_inaction_remedy_right, inaction_remedy_right_exists).
expected_result(forum_public_authority, controller_processor_remedy_right, judicial_remedy_right_exists).
expected_result(forum_public_authority, controller_processor_forum, forum_establishment_state_only).
expected_result(empty_profile, complaint_right, indeterminate([is_data_subject])).
expected_result(empty_profile, authority_decision_remedy_right, indeterminate([decision_is_legally_binding])).
expected_result(empty_profile, authority_inaction_remedy_right, indeterminate([is_data_subject])).
expected_result(empty_profile, controller_processor_remedy_right, indeterminate([is_data_subject])).
expected_result(empty_profile, controller_processor_forum, indeterminate([defendant_is_member_state_public_authority_acting_in_public_powers])).
expected_result(malformed_duplicate_and_unknown, complaint_right, input_problems([duplicate_key(is_data_subject), wrong_type(decision_concerns_the_caller), unknown_key(colour)])).
expected_result(malformed_duplicate_and_unknown, authority_decision_remedy_right, input_problems([duplicate_key(is_data_subject), wrong_type(decision_concerns_the_caller), unknown_key(colour)])).
expected_result(malformed_duplicate_and_unknown, authority_inaction_remedy_right, input_problems([duplicate_key(is_data_subject), wrong_type(decision_concerns_the_caller), unknown_key(colour)])).
expected_result(malformed_duplicate_and_unknown, controller_processor_remedy_right, input_problems([duplicate_key(is_data_subject), wrong_type(decision_concerns_the_caller), unknown_key(colour)])).
expected_result(malformed_duplicate_and_unknown, controller_processor_forum, input_problems([duplicate_key(is_data_subject), wrong_type(decision_concerns_the_caller), unknown_key(colour)])).
expected_result(malformed_unbound_attestation, complaint_right, input_problems([wrong_type(authority_competent_under_articles_55_and_56)])).
expected_result(malformed_unbound_attestation, authority_decision_remedy_right, input_problems([wrong_type(authority_competent_under_articles_55_and_56)])).
expected_result(malformed_unbound_attestation, authority_inaction_remedy_right, input_problems([wrong_type(authority_competent_under_articles_55_and_56)])).
expected_result(malformed_unbound_attestation, controller_processor_remedy_right, input_problems([wrong_type(authority_competent_under_articles_55_and_56)])).
expected_result(malformed_unbound_attestation, controller_processor_forum, input_problems([wrong_type(authority_competent_under_articles_55_and_56)])).

subject_result(Subject, Query, Result, Citations) :-
    gdpr_complaints_and_judicial_remedies_assess(Subject, gdpr_complaints_and_judicial_remedies_verdict(answer(Query, Result), Citations)).

expected_row_holds(Subject - Query - Expected) :-
    findall(Actual, subject_result(Subject, Query, Actual, _), Actuals),
    Actuals == [Expected].

subject_has_five_expected_rows(Subject) :-
    findall(Query, expected_result(Subject, Query, _), Queries),
    length(Queries, 5).

subject_has_five_verdicts(Subject) :-
    findall(Verdict, gdpr_complaints_and_judicial_remedies_assess(Subject, Verdict), Verdicts),
    length(Verdicts, 5).

cited_item(item(_, _, cite(Key))) :-
    atom(Key).

test(every_subject_has_an_expected_row_per_query) :-
    findall(Subject, gdpr_complaints_and_judicial_remedies_subject(Subject), Subjects),
    length(Subjects, 17),
    maplist(subject_has_five_expected_rows, Subjects).
test(every_expected_row_holds_exactly) :-
    findall(Subject - Query - Expected, expected_result(Subject, Query, Expected), ExpectedRows),
    length(ExpectedRows, 85),
    maplist(expected_row_holds, ExpectedRows).
test(every_subject_gives_five_verdicts) :-
    findall(Subject, gdpr_complaints_and_judicial_remedies_subject(Subject), Subjects),
    maplist(subject_has_five_verdicts, Subjects).
test(full_positive_complaint_right_exists) :-
    subject_result(full_positive, complaint_right, Result, Citations),
    Result == complaint_right_exists,
    Citations == [cite(eu_reg_2016_679_art_77_1)].
test(not_a_data_subject_has_no_complaint_right) :-
    subject_result(not_a_data_subject, complaint_right, Result, Citations),
    Result == no_complaint_right,
    Citations == [cite(eu_reg_2016_679_art_77_1)].
test(complaint_no_consideration_has_no_complaint_right) :-
    subject_result(complaint_no_consideration, complaint_right, Result, _),
    Result == no_complaint_right.
test(full_positive_decision_remedy_exists) :-
    subject_result(full_positive, authority_decision_remedy_right, Result, Citations),
    Result == decision_remedy_right_exists,
    Citations == [cite(eu_reg_2016_679_art_78_1)].
test(decision_not_binding_has_no_decision_remedy) :-
    subject_result(decision_not_binding, authority_decision_remedy_right, Result, Citations),
    Result == no_decision_remedy_right,
    Citations == [cite(eu_reg_2016_679_art_78_1)].
test(decision_unsure_binding_goes_to_a_lawyer) :-
    subject_result(decision_unsure_binding, authority_decision_remedy_right, Result, Citations),
    Result == needs_legal_review(open_textured(decision_is_legally_binding, cite(eu_reg_2016_679_art_78_1)), [inputs_relied_on([decision_is_legally_binding - unsure, decision_concerns_the_caller - true])]),
    Citations == [].
test(decision_unsure_and_missing_names_the_missing_key) :-
    subject_result(decision_unsure_and_missing, authority_decision_remedy_right, Result, Citations),
    Result == indeterminate([decision_concerns_the_caller]),
    Citations == [].
test(full_positive_inaction_remedy_exists) :-
    subject_result(full_positive, authority_inaction_remedy_right, Result, Citations),
    Result == inaction_remedy_right_exists,
    Citations == [cite(eu_reg_2016_679_art_78_2)].
test(inaction_competence_absent_is_a_cross_reference) :-
    subject_result(inaction_competence_absent, authority_inaction_remedy_right, Result, Citations),
    Result == needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_78_2), cite(competence_statement)), [resolution(cite(competence_statement), not_attempted), inputs_relied_on([authority_competent_under_articles_55_and_56 - absent])]),
    Citations == [].
test(inaction_competence_false_has_no_inaction_remedy) :-
    subject_result(inaction_competence_false, authority_inaction_remedy_right, Result, Citations),
    Result == no_inaction_remedy_right,
    Citations == [cite(eu_reg_2016_679_art_78_2)].
test(inaction_handled_and_informed_has_no_inaction_remedy) :-
    subject_result(inaction_handled_and_informed, authority_inaction_remedy_right, Result, Citations),
    Result == no_inaction_remedy_right,
    Citations == [cite(eu_reg_2016_679_art_78_2)].
test(inaction_three_months_uninformed_exists_without_handled) :-
    subject_result(inaction_three_months_uninformed_handled_absent, authority_inaction_remedy_right, Result, _),
    Result == inaction_remedy_right_exists.
test(inaction_three_months_informed_needs_handled) :-
    subject_result(inaction_three_months_informed_handled_absent, authority_inaction_remedy_right, Result, Citations),
    Result == indeterminate([authority_handled_the_complaint]),
    Citations == [].
test(inaction_handled_three_months_absent_names_the_months) :-
    subject_result(inaction_handled_three_months_absent, authority_inaction_remedy_right, Result, _),
    Result == indeterminate([three_months_from_the_complaint_have_passed]).
test(full_positive_judicial_remedy_exists) :-
    subject_result(full_positive, controller_processor_remedy_right, Result, Citations),
    Result == judicial_remedy_right_exists,
    Citations == [cite(eu_reg_2016_679_art_79_1)].
test(remedy_no_consideration_has_no_judicial_remedy) :-
    subject_result(remedy_no_consideration, controller_processor_remedy_right, Result, Citations),
    Result == no_judicial_remedy_right,
    Citations == [cite(eu_reg_2016_679_art_79_1)].
test(full_positive_forum_both_states) :-
    subject_result(full_positive, controller_processor_forum, Result, Citations),
    Result == forum_establishment_or_habitual_residence_state,
    Citations == [cite(eu_reg_2016_679_art_79_2)].
test(forum_public_authority_establishment_state_only) :-
    subject_result(forum_public_authority, controller_processor_forum, Result, Citations),
    Result == forum_establishment_state_only,
    Citations == [cite(eu_reg_2016_679_art_79_2)].
test(empty_profile_names_first_keys_without_citations) :-
    findall(Citations, subject_result(empty_profile, _, _, Citations), CitationLists),
    sort(CitationLists, Distinct),
    Distinct == [[]].
test(malformed_profile_gives_input_problems_everywhere) :-
    findall(Result, subject_result(malformed_duplicate_and_unknown, _, Result, _), Results),
    sort(Results, Distinct),
    Distinct == [input_problems([duplicate_key(is_data_subject), wrong_type(decision_concerns_the_caller), unknown_key(colour)])].
test(provenance_constructor_builds_and_destructures) :-
    Term = provenance(cite(eu_reg_2016_679_art_78_2), attested),
    Term = provenance(Source, Detail),
    Source == cite(eu_reg_2016_679_art_78_2),
    Detail == attested.
test(url_evidence_constructor_builds_and_destructures) :-
    Term = url('https://example.org/competence-register', '2026-11-12T09:00:00Z'),
    Term = url(Address, RetrievedAt),
    Address == 'https://example.org/competence-register',
    RetrievedAt == '2026-11-12T09:00:00Z'.
test(document_evidence_constructor_builds_and_destructures) :-
    Term = document(upload_competence_letter, 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855'),
    Term = document(UploadIdentifier, Sha256),
    UploadIdentifier == upload_competence_letter,
    Sha256 == 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855'.
test(url_evidence_is_copied_into_a_final_answer) :-
    Evidence = url('https://example.org/competence-register', '2026-11-12T09:00:00Z'),
    Profile = [attribute(is_data_subject, true), attribute(complaint_lodged_under_article_77, true), attribute(authority_competent_under_articles_55_and_56, attested(true, attestation(host_registry, '2026-11-12T09:00:00Z', competence_confirmed_by_host, Evidence))), attribute(authority_handled_the_complaint, false)],
    findall(Result, decide_gdpr_complaints_and_judicial_remedies(Profile, gdpr_complaints_and_judicial_remedies_verdict(answer(authority_inaction_remedy_right, Result), _)), Results),
    Results == [inaction_remedy_right_exists].
test(document_evidence_is_accepted_by_the_input_check) :-
    Evidence = document(upload_competence_letter, 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855'),
    Profile = [attribute(is_data_subject, true), attribute(complaint_lodged_under_article_77, true), attribute(authority_competent_under_articles_55_and_56, attested(false, attestation(host_registry, '2026-11-12T09:00:00Z', competence_denied_by_host, Evidence)))],
    findall(Result, decide_gdpr_complaints_and_judicial_remedies(Profile, gdpr_complaints_and_judicial_remedies_verdict(answer(authority_inaction_remedy_right, Result), _)), Results),
    Results == [no_inaction_remedy_right].
test(status_projects_the_verdict) :-
    gdpr_complaints_and_judicial_remedies_profile_for(forum_public_authority, Profile),
    gdpr_complaints_and_judicial_remedies_status(Profile, answer(controller_processor_forum, Result)),
    Result == forum_establishment_state_only.
test(decide_matches_assess) :-
    gdpr_complaints_and_judicial_remedies_profile_for(full_positive, Profile),
    findall(Verdict, decide_gdpr_complaints_and_judicial_remedies(Profile, Verdict), Verdicts),
    findall(Verdict, gdpr_complaints_and_judicial_remedies_assess(full_positive, Verdict), AssessedVerdicts),
    Verdicts == AssessedVerdicts.
test(final_results_are_status_values) :-
    gdpr_complaints_and_judicial_remedies_status_values(StatusValues),
    findall(Result, subject_result(full_positive, _, Result, _), Results),
    length(Results, 5),
    subtract(Results, StatusValues, Outside),
    Outside == [].
test(checklist_is_non_empty_and_cited) :-
    gdpr_complaints_and_judicial_remedies_profile_for(full_positive, Profile),
    gdpr_complaints_and_judicial_remedies_checklist(Profile, Items),
    Items = [_|_],
    length(Items, 5),
    maplist(cited_item, Items),
    member(item(authority_inaction_remedy_right, InactionResult, cite(eu_reg_2016_679_art_78_2)), Items),
    InactionResult == inaction_remedy_right_exists.
test(checklist_near_miss_flips_the_item) :-
    gdpr_complaints_and_judicial_remedies_profile_for(not_a_data_subject, Profile),
    gdpr_complaints_and_judicial_remedies_checklist(Profile, Items),
    member(item(complaint_right, ComplaintResult, cite(eu_reg_2016_679_art_77_1)), Items),
    ComplaintResult == no_complaint_right.
test(decision_resolvable_on_fixtures) :-
    gdpr_complaints_and_judicial_remedies_profile_for(full_positive, Profile),
    gdpr_complaints_and_judicial_remedies_decision_resolvable(Profile).

test(not_a_data_subject_complaint_right_is_not_exists, fail) :-
    subject_result(not_a_data_subject, complaint_right, complaint_right_exists, _).
test(complaint_no_consideration_is_not_exists, fail) :-
    subject_result(complaint_no_consideration, complaint_right, complaint_right_exists, _).
test(decision_not_binding_is_not_exists, fail) :-
    subject_result(decision_not_binding, authority_decision_remedy_right, decision_remedy_right_exists, _).
test(decision_unsure_binding_is_not_exists, fail) :-
    subject_result(decision_unsure_binding, authority_decision_remedy_right, decision_remedy_right_exists, _).
test(inaction_competence_absent_is_not_exists, fail) :-
    subject_result(inaction_competence_absent, authority_inaction_remedy_right, inaction_remedy_right_exists, _).
test(inaction_handled_and_informed_is_not_exists, fail) :-
    subject_result(inaction_handled_and_informed, authority_inaction_remedy_right, inaction_remedy_right_exists, _).
test(inaction_three_months_informed_is_not_exists, fail) :-
    subject_result(inaction_three_months_informed_handled_absent, authority_inaction_remedy_right, inaction_remedy_right_exists, _).
test(remedy_no_consideration_is_not_exists, fail) :-
    subject_result(remedy_no_consideration, controller_processor_remedy_right, judicial_remedy_right_exists, _).
test(forum_public_authority_is_not_both_states, fail) :-
    subject_result(forum_public_authority, controller_processor_forum, forum_establishment_or_habitual_residence_state, _).

cp_test_names([every_subject_has_an_expected_row_per_query, every_expected_row_holds_exactly, every_subject_gives_five_verdicts, full_positive_complaint_right_exists, not_a_data_subject_has_no_complaint_right, complaint_no_consideration_has_no_complaint_right, full_positive_decision_remedy_exists, decision_not_binding_has_no_decision_remedy, decision_unsure_binding_goes_to_a_lawyer, decision_unsure_and_missing_names_the_missing_key, full_positive_inaction_remedy_exists, inaction_competence_absent_is_a_cross_reference, inaction_competence_false_has_no_inaction_remedy, inaction_handled_and_informed_has_no_inaction_remedy, inaction_three_months_uninformed_exists_without_handled, inaction_three_months_informed_needs_handled, inaction_handled_three_months_absent_names_the_months, full_positive_judicial_remedy_exists, remedy_no_consideration_has_no_judicial_remedy, full_positive_forum_both_states, forum_public_authority_establishment_state_only, empty_profile_names_first_keys_without_citations, malformed_profile_gives_input_problems_everywhere, provenance_constructor_builds_and_destructures, url_evidence_constructor_builds_and_destructures, document_evidence_constructor_builds_and_destructures, url_evidence_is_copied_into_a_final_answer, document_evidence_is_accepted_by_the_input_check, status_projects_the_verdict, decide_matches_assess, final_results_are_status_values, checklist_is_non_empty_and_cited, checklist_near_miss_flips_the_item, decision_resolvable_on_fixtures]).
cp_test_fail_names([not_a_data_subject_complaint_right_is_not_exists, complaint_no_consideration_is_not_exists, decision_not_binding_is_not_exists, decision_unsure_binding_is_not_exists, inaction_competence_absent_is_not_exists, inaction_handled_and_informed_is_not_exists, inaction_three_months_informed_is_not_exists, remedy_no_consideration_is_not_exists, forum_public_authority_is_not_both_states]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
