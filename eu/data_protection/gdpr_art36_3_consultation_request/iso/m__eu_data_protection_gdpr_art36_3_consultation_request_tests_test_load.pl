% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_art36_3_consultation_request_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_art36_3_consultation_request_kernel, [gdpr_art36_3_consultation_request_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_art36_3_consultation_request_citations, [citation/2, implements/1]).

test(the_verdict_term_carries_result_and_citations) :-
    Verdict = gdpr_art36_3_consultation_request_verdict(consultation_request_complete, [cite(eu_reg_2016_679_art_36_3)]),
    Verdict = gdpr_art36_3_consultation_request_verdict(Result, Citations),
    Result == consultation_request_complete,
    Citations == [cite(eu_reg_2016_679_art_36_3)].
test(the_basis_term_carries_the_attested_term_as_supplied) :-
    Attested = attested(true, attestation(host_user, host_time, stated_reason, none)),
    Basis = [outside_fact(joint_controllers_or_processors_involved, Attested)],
    Basis = [outside_fact(Key, Copied)],
    Key == joint_controllers_or_processors_involved,
    Copied == Attested.
test(the_absent_referral_destructures) :-
    Referral = needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_36_3_a), cite(controller_and_processor_roles_statement)), [resolution(cite(controller_and_processor_roles_statement), not_attempted), inputs_relied_on([joint_controllers_or_processors_involved - absent])]),
    Referral = needs_legal_review(cross_reference_unresolved(cite(CitationKey), cite(TargetKey)), [resolution(cite(TargetKey), Resolution), inputs_relied_on(Pairs)]),
    CitationKey == eu_reg_2016_679_art_36_3_a,
    TargetKey == controller_and_processor_roles_statement,
    Resolution == not_attempted,
    Pairs == [joint_controllers_or_processors_involved - absent].
test(the_indeterminate_status_names_one_key) :-
    Status = indeterminate([consultation_under_article_36_1]),
    Status = indeterminate([Key]),
    Key == consultation_under_article_36_1.
test(the_result_atoms_are_distinct) :-
    dif(consultation_request_complete, consultation_request_incomplete),
    dif(consultation_request_complete, not_governed_by_article_36_3),
    dif(consultation_request_incomplete, not_governed_by_article_36_3).
test(the_item_atoms_are_distinct) :-
    Items = [respective_responsibilities, purposes_and_means, measures_and_safeguards, data_protection_officer_contact_details, data_protection_impact_assessment, other_requested_information],
    sort(Items, Sorted),
    length(Items, ItemCount),
    length(Sorted, SortedCount),
    ItemCount == SortedCount.
test(the_paragraph_citation_is_recorded) :-
    citation(eu_reg_2016_679_art_36_3, _Record).
test(every_point_citation_is_recorded) :-
    citation(eu_reg_2016_679_art_36_3_a, _RecordA),
    citation(eu_reg_2016_679_art_36_3_b, _RecordB),
    citation(eu_reg_2016_679_art_36_3_c, _RecordC),
    citation(eu_reg_2016_679_art_36_3_d, _RecordD),
    citation(eu_reg_2016_679_art_36_3_e, _RecordE),
    citation(eu_reg_2016_679_art_36_3_f, _RecordF).
test(the_referral_target_is_recorded) :-
    citation(controller_and_processor_roles_statement, _Record).
test(the_marker_holds_for_a_recorded_key) :-
    implements(eu_reg_2016_679_art_36_3_a).
test(an_empty_profile_has_no_problem) :-
    gdpr_art36_3_consultation_request_input_problems([], Problems),
    Problems == [].
test(a_well_formed_profile_has_no_problem) :-
    gdpr_art36_3_consultation_request_input_problems([attribute(consultation_under_article_36_1, true), attribute(joint_controllers_or_processors_involved, attested(false, attestation(host_user, host_time, stated_reason, none))), attribute(purposes_and_means_provided, false)], Problems),
    Problems == [].
test(an_attested_crisp_key_is_wrong_type) :-
    gdpr_art36_3_consultation_request_input_problems([attribute(purposes_and_means_provided, attested(true, attestation(host_user, host_time, stated_reason, none)))], Problems),
    Problems == [wrong_type(purposes_and_means_provided)].
test(a_bare_outside_fact_is_wrong_type) :-
    gdpr_art36_3_consultation_request_input_problems([attribute(joint_controllers_or_processors_involved, true)], Problems),
    Problems == [wrong_type(joint_controllers_or_processors_involved)].
test(a_repeated_key_is_a_duplicate_only) :-
    gdpr_art36_3_consultation_request_input_problems([attribute(impact_assessment_provided, true), attribute(impact_assessment_provided, unsure)], Problems),
    Problems == [duplicate_key(impact_assessment_provided)].
test(a_key_outside_the_contract_is_unknown) :-
    gdpr_art36_3_consultation_request_input_problems([attribute(extra_key, true), attribute(extra_key, false)], Problems),
    Problems == [unknown_key(extra_key)].
test(a_term_that_is_not_an_attribute_list_is_wrong_type) :-
    gdpr_art36_3_consultation_request_input_problems([consultation_under_article_36_1], Problems),
    Problems == [wrong_type(profile)].
test(the_input_check_gives_exactly_one_answer) :-
    findall(Problems, gdpr_art36_3_consultation_request_input_problems([attribute(consultation_under_article_36_1, true)], Problems), Answers),
    Answers == [[]].

test(the_complete_result_is_not_the_incomplete_result, fail) :-
    consultation_request_complete = consultation_request_incomplete.
test(the_marker_fails_for_an_unrecorded_key, fail) :-
    implements(eu_reg_2016_679_art_36).

cp_test_names([the_verdict_term_carries_result_and_citations, the_basis_term_carries_the_attested_term_as_supplied, the_absent_referral_destructures, the_indeterminate_status_names_one_key, the_result_atoms_are_distinct, the_item_atoms_are_distinct, the_paragraph_citation_is_recorded, every_point_citation_is_recorded, the_referral_target_is_recorded, the_marker_holds_for_a_recorded_key, an_empty_profile_has_no_problem, a_well_formed_profile_has_no_problem, an_attested_crisp_key_is_wrong_type, a_bare_outside_fact_is_wrong_type, a_repeated_key_is_a_duplicate_only, a_key_outside_the_contract_is_unknown, a_term_that_is_not_an_attribute_list_is_wrong_type, the_input_check_gives_exactly_one_answer]).
cp_test_fail_names([the_complete_result_is_not_the_incomplete_result, the_marker_fails_for_an_unrecorded_key]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
