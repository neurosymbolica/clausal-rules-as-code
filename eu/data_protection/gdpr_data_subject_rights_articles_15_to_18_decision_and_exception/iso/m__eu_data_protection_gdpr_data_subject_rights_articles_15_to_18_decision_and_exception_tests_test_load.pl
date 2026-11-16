% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_kernel, [gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_citations, [citation/2, implements/1]).

test(a_well_formed_profile_has_no_problem_exactly_once) :-
    findall(Problems, gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_input_problems([attribute(request_type, access)], Problems), Answers),
    Answers == [[]].
test(the_empty_profile_has_no_problem) :-
    gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_input_problems([], []).
test(a_term_that_is_not_an_attribute_list_is_wrong_type_profile) :-
    findall(Problems, gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_input_problems(profile_atom, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(a_key_outside_the_contract_is_unknown) :-
    gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_input_problems([attribute(request_type, erasure), attribute(colour, red)], [unknown_key(colour)]).
test(a_repeated_key_is_a_duplicate_and_not_also_wrong_type) :-
    gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_input_problems([attribute(request_type, erasure), attribute(request_type, deletion)], [duplicate_key(request_type)]).
test(a_value_outside_the_enum_is_wrong_type) :-
    gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_input_problems([attribute(request_type, deletion)], [wrong_type(request_type)]).
test(a_judgement_may_be_unsure) :-
    gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_input_problems([attribute(request_type, erasure), attribute(reasonable_doubts_about_identity, unsure)], []).
test(a_crisp_flag_given_unsure_is_wrong_type) :-
    gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_input_problems([attribute(request_type, erasure), attribute(identity_confirmed, unsure)], [wrong_type(identity_confirmed)]).
test(an_attested_outside_fact_is_well_formed) :-
    gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_input_problems([attribute(request_type, erasure), attribute(legislative_restriction_applies_to_the_right, attested(true, attestation(by, at, reason, none)))], []).
test(a_bare_outside_fact_is_wrong_type) :-
    gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_input_problems([attribute(request_type, erasure), attribute(erasure_required_by_union_or_member_state_law, true)], [wrong_type(erasure_required_by_union_or_member_state_law)]).
test(a_real_calendar_date_is_well_formed) :-
    gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_input_problems([attribute(request_received_on, date(2024, 2, 29))], []).
test(an_impossible_date_is_wrong_type) :-
    gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_input_problems([attribute(request_received_on, date(2023, 2, 29))], [wrong_type(request_received_on)]).
test(the_comply_atoms_are_distinct) :-
    dif(must_comply, need_not_comply).
test(the_exception_atoms_are_distinct) :-
    dif(art17_3_a, art17_3_b),
    dif(art17_3_d, art17_3_e),
    dif(art12_5_manifestly_unfounded_or_excessive, art12_2_unable_to_identify),
    dif(art23_legislative_restriction, none).
test(the_problem_constructors_are_distinct) :-
    dif(unknown_key(colour), wrong_type(colour)),
    dif(wrong_type(colour), duplicate_key(colour)).
test(the_verdict_term_carries_its_five_fields) :-
    Verdict = gdpr_data_subject_request_verdict(need_not_comply, art17_1_a, art12_5_manifestly_unfounded_or_excessive, [reasonable_fee_may_be_charged], []),
    Verdict = gdpr_data_subject_request_verdict(Comply, Basis, Exception, Conditions, Citations),
    Comply == need_not_comply,
    Basis == art17_1_a,
    Exception == art12_5_manifestly_unfounded_or_excessive,
    Conditions == [reasonable_fee_may_be_charged],
    Citations == [].
test(the_indeterminate_status_carries_its_missing_keys) :-
    Comply = indeterminate([request_type]),
    Comply = indeterminate(MissingKeys),
    MissingKeys == [request_type].
test(the_open_textured_referral_destructures) :-
    Comply = needs_legal_review(open_textured(personal_data_unlawfully_processed, cite(eu_reg_2016_679_art_17_1_d)), [inputs_relied_on([request_type - erasure, personal_data_unlawfully_processed - unsure])]),
    Comply = needs_legal_review(open_textured(Input, cite(Key)), [inputs_relied_on(Pairs)]),
    Input == personal_data_unlawfully_processed,
    Key == eu_reg_2016_679_art_17_1_d,
    Pairs == [request_type - erasure, personal_data_unlawfully_processed - unsure].
test(the_cross_reference_referral_destructures) :-
    Comply = needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_17_1_e), cite(union_or_member_state_law_requiring_erasure)), [resolution(cite(union_or_member_state_law_requiring_erasure), not_attempted), inputs_relied_on([request_type - erasure, erasure_required_by_union_or_member_state_law - absent])]),
    Comply = needs_legal_review(cross_reference_unresolved(cite(Citation), cite(Target)), [resolution(cite(Target), Status), inputs_relied_on(_Pairs)]),
    Citation == eu_reg_2016_679_art_17_1_e,
    Target == union_or_member_state_law_requiring_erasure,
    Status == not_attempted.
test(the_suspended_status_destructures) :-
    Comply = suspended(art12_6_identity_not_confirmed),
    Comply = suspended(Reason),
    Reason == art12_6_identity_not_confirmed.
test(the_input_problems_status_destructures) :-
    Comply = input_problems([wrong_type(profile)]),
    Comply = input_problems(Problems),
    Problems == [wrong_type(profile)].
test(a_referral_citation_is_recorded) :-
    citation(eu_reg_2016_679_art_17_3_d, _Record).
test(the_outside_fact_citation_and_target_are_recorded) :-
    citation(eu_reg_2016_679_art_17_1_e, _CitationRecord),
    citation(union_or_member_state_law_requiring_erasure, _TargetRecord).
test(the_marker_succeeds_for_a_recorded_key) :-
    implements(eu_reg_2016_679_art_12_6).

test(a_well_formed_profile_is_not_wrong_type_profile, fail) :-
    gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_input_problems([attribute(request_type, access)], [wrong_type(profile)]).
test(the_placeholder_citation_is_gone, fail) :-
    citation(eu_todo_primary_source, _Record).

cp_test_names([a_well_formed_profile_has_no_problem_exactly_once, the_empty_profile_has_no_problem, a_term_that_is_not_an_attribute_list_is_wrong_type_profile, a_key_outside_the_contract_is_unknown, a_repeated_key_is_a_duplicate_and_not_also_wrong_type, a_value_outside_the_enum_is_wrong_type, a_judgement_may_be_unsure, a_crisp_flag_given_unsure_is_wrong_type, an_attested_outside_fact_is_well_formed, a_bare_outside_fact_is_wrong_type, a_real_calendar_date_is_well_formed, an_impossible_date_is_wrong_type, the_comply_atoms_are_distinct, the_exception_atoms_are_distinct, the_problem_constructors_are_distinct, the_verdict_term_carries_its_five_fields, the_indeterminate_status_carries_its_missing_keys, the_open_textured_referral_destructures, the_cross_reference_referral_destructures, the_suspended_status_destructures, the_input_problems_status_destructures, a_referral_citation_is_recorded, the_outside_fact_citation_and_target_are_recorded, the_marker_succeeds_for_a_recorded_key]).
cp_test_fail_names([a_well_formed_profile_is_not_wrong_type_profile, the_placeholder_citation_is_gone]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
