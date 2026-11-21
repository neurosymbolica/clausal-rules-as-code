% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_churches_and_religious_associations_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_msort/2]).
:- use_module(m__eu_data_protection_gdpr_churches_and_religious_associations_gdpr_churches_and_religious_associations, [church_rules_continuation/4, church_supervision/4, decide_gdpr_churches_and_religious_associations/2, gdpr_churches_and_religious_associations_status/2]).
:- use_module(m__eu_data_protection_gdpr_churches_and_religious_associations_fixtures, [gdpr_churches_and_religious_associations_subject/1, gdpr_churches_and_religious_associations_profile_for/2]).

entry_statement(Value, attested(Value, attestation(host, moment_of_the_question, statement_of_the_body, none))).

chapter_statement(Value, attested(Value, attestation(host, moment_of_the_question, statement_on_the_authority, none))).

continuing_subject(rules_continue_authority_not_specific).
continuing_subject(specific_authority_fulfils_chapter_vi).
continuing_subject(specific_authority_fails_chapter_vi).
continuing_subject(specific_authority_chapter_vi_not_stated).
continuing_subject(authority_specificity_not_stated).
continuing_subject(chapter_vi_stated_for_authority_not_specific).

cut_subject(body_not_a_church).
cut_subject(rules_not_applied_in_a_member_state).
cut_subject(rules_not_comprehensive).
cut_subject(rules_not_applied_at_entry_into_force).
cut_subject(rules_not_brought_into_line).
cut_subject(two_conditions_false).

entry_referral(needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_91_1), cite(rules_applied_at_entry_into_force_statement)), [resolution(cite(rules_applied_at_entry_into_force_statement), not_attempted), inputs_relied_on([comprehensive_rules_relating_to_protection_with_regard_to_processing - true, rules_applied_at_entry_into_force_of_the_regulation - absent, rules_brought_into_line_with_the_regulation - true])])).

chapter_referral(needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_91_2), cite(chapter_vi_conditions_statement)), [resolution(cite(chapter_vi_conditions_statement), not_attempted), inputs_relied_on([comprehensive_rules_relating_to_protection_with_regard_to_processing - true, rules_brought_into_line_with_the_regulation - true, specific_authority_fulfils_chapter_vi_conditions - absent])])).

comprehensive_referral(needs_legal_review(open_textured(comprehensive_rules_relating_to_protection_with_regard_to_processing, cite(eu_reg_2016_679_art_91_1)), [inputs_relied_on([comprehensive_rules_relating_to_protection_with_regard_to_processing - unsure, rules_brought_into_line_with_the_regulation - true])])).

brought_referral(needs_legal_review(open_textured(rules_brought_into_line_with_the_regulation, cite(eu_reg_2016_679_art_91_1)), [inputs_relied_on([comprehensive_rules_relating_to_protection_with_regard_to_processing - true, rules_brought_into_line_with_the_regulation - unsure])])).

expected_continuation(Subject, church_rules_may_continue_to_apply, [outside_fact(rules_applied_at_entry_into_force_of_the_regulation, Entry)], [cite(eu_reg_2016_679_art_91_1)]) :-
    continuing_subject(Subject),
    entry_statement(true, Entry).
expected_continuation(Subject, church_rules_not_covered_by_article_91_1, [], [cite(eu_reg_2016_679_art_91_1)]) :-
    cut_subject(Subject).
expected_continuation(body_status_not_stated, indeterminate([body_is_church_or_religious_association_or_community]), [], []).
expected_continuation(entry_into_force_not_attested, Referral, [], []) :-
    entry_referral(Referral).
expected_continuation(comprehensive_rules_unsure, Referral, [], []) :-
    comprehensive_referral(Referral).
expected_continuation(bringing_into_line_unsure, Referral, [], []) :-
    brought_referral(Referral).
expected_continuation(crisp_key_given_unsure, input_problems([wrong_type(rules_applied_in_a_member_state)]), [], []).

expected_supervision(rules_continue_authority_not_specific, subject_to_independent_supervisory_authority, [outside_fact(rules_applied_at_entry_into_force_of_the_regulation, Entry)], [cite(eu_reg_2016_679_art_91_1), cite(eu_reg_2016_679_art_91_2)]) :-
    entry_statement(true, Entry).
expected_supervision(chapter_vi_stated_for_authority_not_specific, subject_to_independent_supervisory_authority, [outside_fact(rules_applied_at_entry_into_force_of_the_regulation, Entry)], [cite(eu_reg_2016_679_art_91_1), cite(eu_reg_2016_679_art_91_2)]) :-
    entry_statement(true, Entry).
expected_supervision(specific_authority_fulfils_chapter_vi, specific_supervisory_authority_permitted, [outside_fact(rules_applied_at_entry_into_force_of_the_regulation, Entry), outside_fact(specific_authority_fulfils_chapter_vi_conditions, Chapter)], [cite(eu_reg_2016_679_art_91_1), cite(eu_reg_2016_679_art_91_2)]) :-
    entry_statement(true, Entry),
    chapter_statement(true, Chapter).
expected_supervision(specific_authority_fails_chapter_vi, specific_supervisory_authority_not_permitted, [outside_fact(rules_applied_at_entry_into_force_of_the_regulation, Entry), outside_fact(specific_authority_fulfils_chapter_vi_conditions, Chapter)], [cite(eu_reg_2016_679_art_91_1), cite(eu_reg_2016_679_art_91_2)]) :-
    entry_statement(true, Entry),
    chapter_statement(false, Chapter).
expected_supervision(specific_authority_chapter_vi_not_stated, Referral, [], []) :-
    chapter_referral(Referral).
expected_supervision(authority_specificity_not_stated, indeterminate([supervisory_authority_is_specific]), [], []).
expected_supervision(Subject, article_91_2_not_engaged, [], [cite(eu_reg_2016_679_art_91_1), cite(eu_reg_2016_679_art_91_2)]) :-
    cut_subject(Subject).
expected_supervision(body_status_not_stated, indeterminate([body_is_church_or_religious_association_or_community]), [], []).
expected_supervision(entry_into_force_not_attested, Referral, [], []) :-
    entry_referral(Referral).
expected_supervision(comprehensive_rules_unsure, Referral, [], []) :-
    comprehensive_referral(Referral).
expected_supervision(bringing_into_line_unsure, Referral, [], []) :-
    brought_referral(Referral).
expected_supervision(crisp_key_given_unsure, input_problems([wrong_type(rules_applied_in_a_member_state)]), [], []).

continuation_answers_match(Subject) :-
    expected_continuation(Subject, Result, Basis, Citations),
    gdpr_churches_and_religious_associations_profile_for(Subject, Profile),
    findall(answer(ActualResult, ActualBasis, SortedActualCitations), (church_rules_continuation(Profile, ActualResult, ActualBasis, ActualCitations), clausal_msort(ActualCitations, SortedActualCitations)), Answers),
    clausal_msort(Citations, SortedCitations),
    Answers == [answer(Result, Basis, SortedCitations)].

supervision_answers_match(Subject) :-
    expected_supervision(Subject, Result, Basis, Citations),
    gdpr_churches_and_religious_associations_profile_for(Subject, Profile),
    findall(answer(ActualResult, ActualBasis, SortedActualCitations), (church_supervision(Profile, ActualResult, ActualBasis, ActualCitations), clausal_msort(ActualCitations, SortedActualCitations)), Answers),
    clausal_msort(Citations, SortedCitations),
    Answers == [answer(Result, Basis, SortedCitations)].

subject_set(SubjectSet) :-
    findall(Subject, gdpr_churches_and_religious_associations_subject(Subject), Subjects),
    sort(Subjects, SubjectSet).

test(every_subject_gets_exactly_its_continuation_answer) :-
    subject_set(SubjectSet),
    findall(Subject, continuation_answers_match(Subject), Matching),
    sort(Matching, MatchingSet),
    MatchingSet == SubjectSet.
test(every_subject_gets_exactly_its_supervision_answer) :-
    subject_set(SubjectSet),
    findall(Subject, supervision_answers_match(Subject), Matching),
    sort(Matching, MatchingSet),
    MatchingSet == SubjectSet.
test(the_baseline_profile_yields_exactly_one_status) :-
    gdpr_churches_and_religious_associations_profile_for(rules_continue_authority_not_specific, Profile),
    findall(Status, gdpr_churches_and_religious_associations_status(Profile, Status), Statuses),
    Statuses == [church_rules_may_continue_to_apply].
test(the_verdict_carries_a_citation) :-
    gdpr_churches_and_religious_associations_profile_for(rules_continue_authority_not_specific, Profile),
    decide_gdpr_churches_and_religious_associations(Profile, gdpr_churches_and_religious_associations_verdict(Status, Citations)),
    Status == church_rules_may_continue_to_apply,
    Citations == [cite(eu_reg_2016_679_art_91_1)].
test(a_referred_verdict_carries_no_citation) :-
    gdpr_churches_and_religious_associations_profile_for(comprehensive_rules_unsure, Profile),
    decide_gdpr_churches_and_religious_associations(Profile, gdpr_churches_and_religious_associations_verdict(_Status, Citations)),
    Citations == [].

cp_test_names([every_subject_gets_exactly_its_continuation_answer, every_subject_gets_exactly_its_supervision_answer, the_baseline_profile_yields_exactly_one_status, the_verdict_carries_a_citation, a_referred_verdict_carries_no_citation]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
