% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_churches_and_religious_associations_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_churches_and_religious_associations_kernel, [gdpr_churches_and_religious_associations_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_churches_and_religious_associations_citations, [citation/2, implements/1]).

test(the_kernel_input_check_loads_and_accepts_an_empty_profile) :-
    gdpr_churches_and_religious_associations_input_problems([], Problems),
    Problems == [].
test(the_kernel_input_check_gives_one_answer_for_an_empty_profile) :-
    findall(Problems, gdpr_churches_and_religious_associations_input_problems([], Problems), Answers),
    Answers == [[]].
test(the_kernel_input_check_refuses_a_non_list) :-
    gdpr_churches_and_religious_associations_input_problems(profile, Problems),
    Problems == [wrong_type(profile)].
test(the_continuation_atoms_are_distinct) :-
    dif(church_rules_may_continue_to_apply, church_rules_not_covered_by_article_91_1).
test(the_supervision_atoms_are_distinct) :-
    Atoms = [article_91_2_not_engaged, subject_to_independent_supervisory_authority, specific_supervisory_authority_permitted, specific_supervisory_authority_not_permitted],
    sort(Atoms, Sorted),
    length(Sorted, Count),
    Count == 4.
test(the_six_result_atoms_are_distinct) :-
    Atoms = [church_rules_may_continue_to_apply, church_rules_not_covered_by_article_91_1, article_91_2_not_engaged, subject_to_independent_supervisory_authority, specific_supervisory_authority_permitted, specific_supervisory_authority_not_permitted],
    sort(Atoms, Sorted),
    length(Sorted, Count),
    Count == 6.
test(the_judgement_value_unsure_is_not_a_boolean) :-
    dif(unsure, true),
    dif(unsure, false).
test(the_verdict_term_carries_status_and_citations) :-
    Verdict = gdpr_churches_and_religious_associations_verdict(church_rules_may_continue_to_apply, [cite(eu_reg_2016_679_art_91_1)]),
    Verdict = gdpr_churches_and_religious_associations_verdict(Status, Citations),
    Status == church_rules_may_continue_to_apply,
    Citations == [cite(eu_reg_2016_679_art_91_1)].
test(the_indeterminate_status_names_one_key) :-
    Result = indeterminate([body_is_church_or_religious_association_or_community]),
    Result = indeterminate([Key]),
    Key == body_is_church_or_religious_association_or_community.
test(the_open_textured_referral_destructures) :-
    Result = needs_legal_review(open_textured(comprehensive_rules_relating_to_protection_with_regard_to_processing, cite(eu_reg_2016_679_art_91_1)), [inputs_relied_on([comprehensive_rules_relating_to_protection_with_regard_to_processing - unsure, rules_brought_into_line_with_the_regulation - true])]),
    Result = needs_legal_review(open_textured(Key, cite(CitationKey)), [inputs_relied_on(Pairs)]),
    Key == comprehensive_rules_relating_to_protection_with_regard_to_processing,
    CitationKey == eu_reg_2016_679_art_91_1,
    Pairs == [comprehensive_rules_relating_to_protection_with_regard_to_processing - unsure, rules_brought_into_line_with_the_regulation - true].
test(the_cross_reference_referral_destructures) :-
    Result = needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_91_2), cite(chapter_vi_conditions_statement)), [resolution(cite(chapter_vi_conditions_statement), not_attempted), inputs_relied_on([comprehensive_rules_relating_to_protection_with_regard_to_processing - true, rules_brought_into_line_with_the_regulation - true, specific_authority_fulfils_chapter_vi_conditions - absent])]),
    Result = needs_legal_review(cross_reference_unresolved(cite(CitationKey), cite(Target)), [resolution(cite(ResolvedTarget), ResolutionStatus), inputs_relied_on(Pairs)]),
    CitationKey == eu_reg_2016_679_art_91_2,
    Target == chapter_vi_conditions_statement,
    ResolvedTarget == chapter_vi_conditions_statement,
    ResolutionStatus == not_attempted,
    length(Pairs, PairCount),
    PairCount == 3.
test(the_outside_fact_basis_copies_the_attested_value) :-
    Attested = attested(true, attestation(host, at, reason, none)),
    Basis = [outside_fact(rules_applied_at_entry_into_force_of_the_regulation, Attested)],
    Basis = [outside_fact(Key, attested(Value, attestation(By, At, Reason, Evidence)))],
    Key == rules_applied_at_entry_into_force_of_the_regulation,
    Value == true,
    By == host,
    At == at,
    Reason == reason,
    Evidence == none.
test(the_input_problems_status_destructures) :-
    Result = input_problems([duplicate_key(supervisory_authority_is_specific), unknown_key(colour)]),
    Result = input_problems([First|Rest]),
    First == duplicate_key(supervisory_authority_is_specific),
    Rest == [unknown_key(colour)].
test(the_article_91_1_citation_is_recorded) :-
    citation(eu_reg_2016_679_art_91_1, Record),
    Record = [label - _, ref - _, verbatim - _].
test(the_article_91_2_citation_is_recorded) :-
    citation(eu_reg_2016_679_art_91_2, Record),
    Record = [label - _, ref - _, verbatim - _].
test(the_marker_succeeds_for_a_recorded_key) :-
    implements(eu_reg_2016_679_art_91_1).

test(the_placeholder_citation_is_not_recorded, fail) :-
    citation(eu_todo_primary_source, _).
test(a_shortened_citation_key_is_not_recorded, fail) :-
    implements(gdpr_art_91_2).

cp_test_names([the_kernel_input_check_loads_and_accepts_an_empty_profile, the_kernel_input_check_gives_one_answer_for_an_empty_profile, the_kernel_input_check_refuses_a_non_list, the_continuation_atoms_are_distinct, the_supervision_atoms_are_distinct, the_six_result_atoms_are_distinct, the_judgement_value_unsure_is_not_a_boolean, the_verdict_term_carries_status_and_citations, the_indeterminate_status_names_one_key, the_open_textured_referral_destructures, the_cross_reference_referral_destructures, the_outside_fact_basis_copies_the_attested_value, the_input_problems_status_destructures, the_article_91_1_citation_is_recorded, the_article_91_2_citation_is_recorded, the_marker_succeeds_for_a_recorded_key]).
cp_test_fail_names([the_placeholder_citation_is_not_recorded, a_shortened_citation_key_is_not_recorded]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
