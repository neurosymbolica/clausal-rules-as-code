% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_chapter_v_extras_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists, [msort/2]).
:- use_module(m__eu_data_protection_gdpr_chapter_v_extras_gdpr_chapter_v_extras, [decide_gdpr_chapter_v_extras/2, gdpr_chapter_v_extras_status/2, gdpr_chapter_v_extras_checklist/2, gdpr_chapter_v_extras_decision_resolvable/1, gdpr_chapter_v_extras_status_values/1, second_subparagraph_duty/5, foreign_judgment_or_decision_recognition/4, onward_transfer_condition/4]).
:- use_module(m__eu_data_protection_gdpr_chapter_v_extras_fixtures, [gdpr_chapter_v_extras_subject/1, gdpr_chapter_v_extras_profile_for/2, gdpr_chapter_v_extras_assess/2]).
:- use_module(m__eu_data_protection_gdpr_chapter_v_extras_queries, [gdpr_chapter_v_extras_what_if/4]).
:- use_module(m__eu_data_protection_gdpr_chapter_v_extras_kernel, [gdpr_chapter_v_extras_input_problems/2]).

expected_status(controller_all_duties_met, no_condition_breached).
expected_status(controller_data_subject_not_told_interests, condition_breached).
expected_status(controller_supervisory_authority_not_informed, condition_breached).
expected_status(controller_safeguards_not_documented, condition_breached).
expected_status(processor_documentation_met, no_condition_breached).
expected_status(processor_documentation_pending, more_input_needed).
expected_status(no_second_subparagraph_transfer_stated, no_condition_breached).
expected_status(second_subparagraph_unstated, more_input_needed).
expected_status(party_role_unstated, more_input_needed).
expected_status(foreign_judgment_with_agreement, no_condition_breached).
expected_status(foreign_judgment_without_agreement, condition_breached).
expected_status(foreign_judgment_agreement_unstated, more_input_needed).
expected_status(onward_transfer_with_basis, no_condition_breached).
expected_status(onward_transfer_without_basis, condition_breached).
expected_status(onward_transfer_basis_unstated, more_input_needed).
expected_status(malformed_bare_boolean_outside_fact, input_problems([wrong_type(transfer_is_onward_transfer)])).

near_miss(controller_all_duties_met, controller_data_subject_not_told_interests).
near_miss(controller_all_duties_met, controller_supervisory_authority_not_informed).
near_miss(controller_all_duties_met, controller_safeguards_not_documented).
near_miss(controller_all_duties_met, party_role_unstated).
near_miss(processor_documentation_met, processor_documentation_pending).
near_miss(no_second_subparagraph_transfer_stated, second_subparagraph_unstated).
near_miss(foreign_judgment_with_agreement, foreign_judgment_without_agreement).
near_miss(foreign_judgment_with_agreement, foreign_judgment_agreement_unstated).
near_miss(onward_transfer_with_basis, onward_transfer_without_basis).
near_miss(onward_transfer_with_basis, onward_transfer_basis_unstated).
near_miss(onward_transfer_with_basis, malformed_bare_boolean_outside_fact).

subject_status(Subject, Status) :-
    gdpr_chapter_v_extras_assess(Subject, gdpr_chapter_v_extras_verdict(Status, _)).

subject_has_checklist(Subject) :-
    gdpr_chapter_v_extras_profile_for(Subject, Profile),
    gdpr_chapter_v_extras_checklist(Profile, [_|_]).

subject_answers_once(Subject) :-
    findall(Verdict, gdpr_chapter_v_extras_assess(Subject, Verdict), Verdicts),
    length(Verdicts, 1).

near_miss_differs(Positive - Control) :-
    subject_status(Positive, PositiveStatus),
    subject_status(Control, ControlStatus),
    dif(PositiveStatus, ControlStatus).

subject_profile(Subject, Profile) :-
    gdpr_chapter_v_extras_profile_for(Subject, Profile).

test(every_subject_has_an_expected_status) :-
    findall(Subject, gdpr_chapter_v_extras_subject(Subject), Subjects),
    findall(Subject, expected_status(Subject, _), ExpectedSubjects),
    msort(Subjects, SortedSubjects),
    msort(ExpectedSubjects, SortedExpectedSubjects),
    SortedSubjects == SortedExpectedSubjects.
test(every_subject_resolves_to_its_expected_status) :-
    findall(Subject - Status, (gdpr_chapter_v_extras_subject(Subject), subject_status(Subject, Status)), Actual),
    findall(Subject - Status, expected_status(Subject, Status), Expected),
    msort(Actual, SortedActual),
    msort(Expected, SortedExpected),
    SortedActual == SortedExpected.
test(every_subject_answers_exactly_once) :-
    findall(Subject, gdpr_chapter_v_extras_subject(Subject), Subjects),
    maplist(subject_answers_once, Subjects).
test(every_subject_has_a_non_empty_checklist) :-
    findall(Subject, gdpr_chapter_v_extras_subject(Subject), Subjects),
    maplist(subject_has_checklist, Subjects).
test(every_near_miss_control_gets_another_status) :-
    findall(Positive - Control, near_miss(Positive, Control), Pairs),
    maplist(near_miss_differs, Pairs).
test(every_final_status_is_in_the_status_values) :-
    gdpr_chapter_v_extras_status_values(StatusValues),
    subject_status(controller_all_duties_met, ClearStatus),
    subject_status(controller_data_subject_not_told_interests, BreachedStatus),
    subject_status(processor_documentation_pending, OpenStatus),
    member(ClearStatus, StatusValues),
    member(BreachedStatus, StatusValues),
    member(OpenStatus, StatusValues).
test(controller_all_duties_met_is_clear) :-
    subject_status(controller_all_duties_met, no_condition_breached).
test(untold_interests_breach_the_duty) :-
    subject_status(controller_data_subject_not_told_interests, condition_breached).
test(processor_documentation_met_is_clear) :-
    subject_status(processor_documentation_met, no_condition_breached).
test(processor_documentation_pending_needs_input) :-
    subject_status(processor_documentation_pending, more_input_needed).
test(the_unstated_second_subparagraph_needs_input) :-
    subject_status(second_subparagraph_unstated, more_input_needed).
test(foreign_judgment_without_agreement_is_breached) :-
    subject_status(foreign_judgment_without_agreement, condition_breached).
test(onward_transfer_with_basis_is_clear) :-
    subject_status(onward_transfer_with_basis, no_condition_breached).
test(onward_transfer_without_basis_is_breached) :-
    subject_status(onward_transfer_without_basis, condition_breached).
test(the_malformed_subject_gets_input_problems_and_no_citations) :-
    gdpr_chapter_v_extras_assess(malformed_bare_boolean_outside_fact, gdpr_chapter_v_extras_verdict(input_problems([wrong_type(transfer_is_onward_transfer)]), [])).
test(a_clear_verdict_cites_the_provisions) :-
    gdpr_chapter_v_extras_assess(controller_all_duties_met, gdpr_chapter_v_extras_verdict(no_condition_breached, Citations)),
    member(cite(eu_reg_2016_679_art_49_6), Citations),
    member(cite(eu_reg_2016_679_art_49_1_second_subpara), Citations).
test(the_status_matches_the_decision) :-
    subject_profile(onward_transfer_without_basis, Profile),
    gdpr_chapter_v_extras_status(Profile, condition_breached),
    decide_gdpr_chapter_v_extras(Profile, gdpr_chapter_v_extras_verdict(condition_breached, _)),
    gdpr_chapter_v_extras_decision_resolvable(Profile).
test(the_untold_interests_duty_is_not_met_once) :-
    subject_profile(controller_data_subject_not_told_interests, Profile),
    member(attribute(transfer_relies_on_article_49_1_second_subparagraph, Attested), Profile),
    findall(Result - Basis - Citations, second_subparagraph_duty(Profile, inform_data_subject, Result, Basis, Citations), Answers),
    Answers == [duty_not_met - [outside_fact(transfer_relies_on_article_49_1_second_subparagraph, Attested)] - [cite(eu_reg_2016_679_art_49_1_second_subpara)]].
test(the_supervisory_authority_duty_is_met_in_the_same_profile) :-
    subject_profile(controller_data_subject_not_told_interests, Profile),
    second_subparagraph_duty(Profile, inform_supervisory_authority, duty_met, _, [cite(eu_reg_2016_679_art_49_1_second_subpara)]).
test(a_processor_is_told_the_duty_to_inform_is_not_its_own) :-
    subject_profile(processor_documentation_met, Profile),
    findall(Result - Basis - Citations, second_subparagraph_duty(Profile, inform_supervisory_authority, Result, Basis, Citations), Answers),
    Answers == [not_a_processor_duty - [] - [cite(eu_reg_2016_679_art_49_1_second_subpara)]].
test(a_processor_documentation_duty_is_met) :-
    subject_profile(processor_documentation_met, Profile),
    second_subparagraph_duty(Profile, document_assessment_and_safeguards, duty_met, _, [cite(eu_reg_2016_679_art_49_6)]).
test(a_pending_documentation_names_the_safeguards_key) :-
    subject_profile(processor_documentation_pending, Profile),
    findall(Result - Basis - Citations, second_subparagraph_duty(Profile, document_assessment_and_safeguards, Result, Basis, Citations), Answers),
    Answers == [indeterminate([suitable_safeguards_documented_in_records]) - [] - []].
test(the_unstated_second_subparagraph_is_referred) :-
    subject_profile(second_subparagraph_unstated, Profile),
    findall(Result, second_subparagraph_duty(Profile, inform_data_subject, Result, _, _), Answers),
    Answers == [needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_49_1_second_subpara), cite(second_subparagraph_transfer_statement)), [resolution(cite(second_subparagraph_transfer_statement), not_attempted), inputs_relied_on([transfer_relies_on_article_49_1_second_subparagraph - absent])])].
test(an_unstated_party_role_is_named) :-
    subject_profile(party_role_unstated, Profile),
    second_subparagraph_duty(Profile, inform_supervisory_authority, indeterminate([party_role]), [], []).
test(a_stated_false_second_subparagraph_gives_no_duty) :-
    subject_profile(no_second_subparagraph_transfer_stated, Profile),
    second_subparagraph_duty(Profile, document_assessment_and_safeguards, no_second_subparagraph_transfer, [outside_fact(transfer_relies_on_article_49_1_second_subparagraph, _)], [cite(eu_reg_2016_679_art_49_6)]).
test(a_bad_duty_is_an_input_problem) :-
    subject_profile(controller_all_duties_met, Profile),
    findall(Result - Basis - Citations, second_subparagraph_duty(Profile, inform_everyone, Result, Basis, Citations), Answers),
    Answers == [input_problems([wrong_type(duty)]) - [] - []].
test(article_48_bars_without_an_agreement_once) :-
    subject_profile(foreign_judgment_without_agreement, Profile),
    findall(Result - Citations, foreign_judgment_or_decision_recognition(Profile, Result, _, Citations), Answers),
    Answers == [not_recognisable_or_enforceable - [cite(eu_reg_2016_679_art_48)]].
test(article_48_does_not_bar_with_an_agreement) :-
    subject_profile(foreign_judgment_with_agreement, Profile),
    foreign_judgment_or_decision_recognition(Profile, not_barred_by_article_48, [_, _], [cite(eu_reg_2016_679_art_48)]).
test(article_48_is_not_engaged_without_a_judgment) :-
    subject_profile(controller_all_duties_met, Profile),
    foreign_judgment_or_decision_recognition(Profile, article_48_not_engaged, [_], [cite(eu_reg_2016_679_art_48)]).
test(an_onward_transfer_with_a_basis_may_take_place_once) :-
    subject_profile(onward_transfer_with_basis, Profile),
    findall(Result - Citations, onward_transfer_condition(Profile, Result, _, Citations), Answers),
    Answers == [onward_transfer_may_take_place - [cite(eu_reg_2016_679_art_44)]].
test(an_onward_transfer_without_a_basis_may_not_take_place) :-
    subject_profile(onward_transfer_without_basis, Profile),
    onward_transfer_condition(Profile, onward_transfer_may_not_take_place, [_, _], [cite(eu_reg_2016_679_art_44)]).
test(the_input_check_names_the_bare_boolean) :-
    subject_profile(malformed_bare_boolean_outside_fact, Profile),
    findall(Problems, gdpr_chapter_v_extras_input_problems(Profile, Problems), All),
    All == [[wrong_type(transfer_is_onward_transfer)]].
test(the_input_check_passes_a_well_formed_fixture) :-
    subject_profile(controller_all_duties_met, Profile),
    gdpr_chapter_v_extras_input_problems(Profile, []).
test(the_malformed_checklist_is_the_input_check_row) :-
    subject_profile(malformed_bare_boolean_outside_fact, Profile),
    gdpr_chapter_v_extras_checklist(Profile, [item(input_check, unmet(input_problems([wrong_type(transfer_is_onward_transfer)])), [])]).
test(url_evidence_passes_the_input_check) :-
    Attested = attested(true, attestation(host_user, host_timestamp, stated_reason, url(statement_location, retrieved_at_timestamp))),
    findall(Problems, gdpr_chapter_v_extras_input_problems([attribute(transfer_relies_on_article_49_1_second_subparagraph, Attested)], Problems), All),
    All == [[]].
test(url_evidence_is_copied_into_the_duty_basis) :-
    Attested = attested(true, attestation(host_user, host_timestamp, stated_reason, url(statement_location, retrieved_at_timestamp))),
    Profile = [attribute(transfer_relies_on_article_49_1_second_subparagraph, Attested), attribute(party_role, controller), attribute(supervisory_authority_informed_of_transfer, true)],
    findall(Result - Basis - Citations, second_subparagraph_duty(Profile, inform_supervisory_authority, Result, Basis, Citations), Answers),
    Answers == [duty_met - [outside_fact(transfer_relies_on_article_49_1_second_subparagraph, attested(true, attestation(host_user, host_timestamp, stated_reason, url(statement_location, retrieved_at_timestamp))))] - [cite(eu_reg_2016_679_art_49_1_second_subpara)]].
test(url_evidence_with_a_false_key_is_not_met) :-
    Attested = attested(true, attestation(host_user, host_timestamp, stated_reason, url(statement_location, retrieved_at_timestamp))),
    Profile = [attribute(transfer_relies_on_article_49_1_second_subparagraph, Attested), attribute(party_role, controller), attribute(supervisory_authority_informed_of_transfer, false)],
    second_subparagraph_duty(Profile, inform_supervisory_authority, duty_not_met, [outside_fact(transfer_relies_on_article_49_1_second_subparagraph, Attested)], [cite(eu_reg_2016_679_art_49_1_second_subpara)]).
test(document_evidence_passes_the_input_check) :-
    Attested = attested(false, attestation(host_user, host_timestamp, stated_reason, document(upload_identifier, sha256_digest))),
    findall(Problems, gdpr_chapter_v_extras_input_problems([attribute(transfer_is_onward_transfer, Attested)], Problems), All),
    All == [[]].
test(document_evidence_is_copied_into_the_onward_basis) :-
    OnwardAttested = attested(true, attestation(host_user, host_timestamp, stated_reason, document(upload_identifier, sha256_digest))),
    BasisAttested = attested(true, attestation(host_user, host_timestamp, stated_reason, document(second_upload, second_digest))),
    Profile = [attribute(transfer_is_onward_transfer, OnwardAttested), attribute(onward_transfer_has_chapter_v_basis, BasisAttested)],
    findall(Result - Basis - Citations, onward_transfer_condition(Profile, Result, Basis, Citations), Answers),
    Answers == [onward_transfer_may_take_place - [outside_fact(transfer_is_onward_transfer, attested(true, attestation(host_user, host_timestamp, stated_reason, document(upload_identifier, sha256_digest)))), outside_fact(onward_transfer_has_chapter_v_basis, attested(true, attestation(host_user, host_timestamp, stated_reason, document(second_upload, second_digest))))] - [cite(eu_reg_2016_679_art_44)]].
test(document_evidence_not_onward) :-
    Attested = attested(false, attestation(host_user, host_timestamp, stated_reason, document(upload_identifier, sha256_digest))),
    onward_transfer_condition([attribute(transfer_is_onward_transfer, Attested)], not_an_onward_transfer, [outside_fact(transfer_is_onward_transfer, Attested)], [cite(eu_reg_2016_679_art_44)]).
test(telling_the_interests_clears_the_breach) :-
    subject_profile(controller_data_subject_not_told_interests, Profile),
    findall(Status, gdpr_chapter_v_extras_what_if(Profile, data_subject_informed_of_compelling_legitimate_interests, true, Status), Statuses),
    Statuses == [no_condition_breached].
test(withholding_the_interests_breaches_the_duty) :-
    subject_profile(controller_all_duties_met, Profile),
    gdpr_chapter_v_extras_what_if(Profile, data_subject_informed_of_compelling_legitimate_interests, false, condition_breached).

test(controller_all_duties_met_is_not_breached, fail) :-
    subject_status(controller_all_duties_met, condition_breached).
test(untold_interests_are_not_clear, fail) :-
    subject_status(controller_data_subject_not_told_interests, no_condition_breached).
test(processor_documentation_pending_is_not_clear, fail) :-
    subject_status(processor_documentation_pending, no_condition_breached).
test(foreign_judgment_with_agreement_is_not_breached, fail) :-
    subject_status(foreign_judgment_with_agreement, condition_breached).
test(the_malformed_subject_is_not_clear, fail) :-
    subject_status(malformed_bare_boolean_outside_fact, no_condition_breached).
test(an_onward_transfer_without_a_basis_may_not_take_place_only, fail) :-
    subject_profile(onward_transfer_without_basis, Profile),
    onward_transfer_condition(Profile, onward_transfer_may_take_place, _, _).
test(withholding_the_interests_is_not_clear, fail) :-
    subject_profile(controller_all_duties_met, Profile),
    gdpr_chapter_v_extras_what_if(Profile, data_subject_informed_of_compelling_legitimate_interests, false, no_condition_breached).

cp_test_names([every_subject_has_an_expected_status, every_subject_resolves_to_its_expected_status, every_subject_answers_exactly_once, every_subject_has_a_non_empty_checklist, every_near_miss_control_gets_another_status, every_final_status_is_in_the_status_values, controller_all_duties_met_is_clear, untold_interests_breach_the_duty, processor_documentation_met_is_clear, processor_documentation_pending_needs_input, the_unstated_second_subparagraph_needs_input, foreign_judgment_without_agreement_is_breached, onward_transfer_with_basis_is_clear, onward_transfer_without_basis_is_breached, the_malformed_subject_gets_input_problems_and_no_citations, a_clear_verdict_cites_the_provisions, the_status_matches_the_decision, the_untold_interests_duty_is_not_met_once, the_supervisory_authority_duty_is_met_in_the_same_profile, a_processor_is_told_the_duty_to_inform_is_not_its_own, a_processor_documentation_duty_is_met, a_pending_documentation_names_the_safeguards_key, the_unstated_second_subparagraph_is_referred, an_unstated_party_role_is_named, a_stated_false_second_subparagraph_gives_no_duty, a_bad_duty_is_an_input_problem, article_48_bars_without_an_agreement_once, article_48_does_not_bar_with_an_agreement, article_48_is_not_engaged_without_a_judgment, an_onward_transfer_with_a_basis_may_take_place_once, an_onward_transfer_without_a_basis_may_not_take_place, the_input_check_names_the_bare_boolean, the_input_check_passes_a_well_formed_fixture, the_malformed_checklist_is_the_input_check_row, url_evidence_passes_the_input_check, url_evidence_is_copied_into_the_duty_basis, url_evidence_with_a_false_key_is_not_met, document_evidence_passes_the_input_check, document_evidence_is_copied_into_the_onward_basis, document_evidence_not_onward, telling_the_interests_clears_the_breach, withholding_the_interests_breaches_the_duty]).
cp_test_fail_names([controller_all_duties_met_is_not_breached, untold_interests_are_not_clear, processor_documentation_pending_is_not_clear, foreign_judgment_with_agreement_is_not_breached, the_malformed_subject_is_not_clear, an_onward_transfer_without_a_basis_may_not_take_place_only, withholding_the_interests_is_not_clear]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
