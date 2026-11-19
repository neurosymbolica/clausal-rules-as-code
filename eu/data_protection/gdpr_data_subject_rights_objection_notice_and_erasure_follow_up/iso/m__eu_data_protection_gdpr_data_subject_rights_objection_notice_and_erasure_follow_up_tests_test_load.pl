% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_kernel, [gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_citations, [citation/2, implements/1]).

test(the_article_21_4_citation_is_recorded) :-
    citation(eu_reg_2016_679_art_21_4, _Record).
test(the_article_17_2_citation_is_recorded) :-
    citation(eu_reg_2016_679_art_17_2, _Record).
test(the_right_to_object_target_is_recorded) :-
    citation(article_21_right_to_object_statement, _Record).
test(the_erasure_obligation_target_is_recorded) :-
    citation(article_17_1_erasure_obligation_statement, _Record).
test(the_citation_record_has_label_reference_and_verbatim) :-
    citation(eu_reg_2016_679_art_21_4, [label - _Label, ref - _Reference, verbatim - _Verbatim]).
test(the_marker_succeeds_for_a_recorded_key) :-
    implements(eu_reg_2016_679_art_17_2).
test(the_notice_atoms_are_distinct) :-
    dif(notice_not_owed, notice_not_yet_due),
    dif(notice_not_owed, notice_complies),
    dif(notice_not_owed, notice_does_not_comply),
    dif(notice_not_yet_due, notice_complies),
    dif(notice_not_yet_due, notice_does_not_comply),
    dif(notice_complies, notice_does_not_comply).
test(the_follow_up_atoms_are_distinct) :-
    dif(follow_up_duty_does_not_apply, follow_up_duty_met),
    dif(follow_up_duty_does_not_apply, follow_up_duty_not_met),
    dif(follow_up_duty_met, follow_up_duty_not_met).
test(the_problem_constructors_are_distinct) :-
    dif(unknown_key(right_presented_clearly), wrong_type(right_presented_clearly)),
    dif(wrong_type(right_presented_clearly), duplicate_key(right_presented_clearly)).
test(the_absent_referral_builds_and_destructures) :-
    Result = needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_21_4), cite(article_21_right_to_object_statement)), [resolution(cite(article_21_right_to_object_statement), not_attempted), inputs_relied_on([right_to_object_applies - absent])]),
    Result = needs_legal_review(cross_reference_unresolved(cite(Citation), cite(Target)), [resolution(cite(ResolvedTarget), Resolution), inputs_relied_on(Pairs)]),
    Citation == eu_reg_2016_679_art_21_4,
    Target == article_21_right_to_object_statement,
    ResolvedTarget == Target,
    Resolution == not_attempted,
    Pairs == [right_to_object_applies - absent],
    citation(Citation, _CitationRecord),
    citation(Target, _TargetRecord).
test(the_open_textured_referral_builds_and_destructures) :-
    Result = needs_legal_review(open_textured(reasonable_steps_taken_to_inform_other_controllers, cite(eu_reg_2016_679_art_17_2)), [inputs_relied_on([reasonable_steps_taken_to_inform_other_controllers - unsure])]),
    Result = needs_legal_review(open_textured(Key, cite(Citation)), [inputs_relied_on([PairKey - PairValue])]),
    Key == reasonable_steps_taken_to_inform_other_controllers,
    PairKey == Key,
    PairValue == unsure,
    citation(Citation, _Record).
test(the_indeterminate_status_names_one_key) :-
    Result = indeterminate([first_communication_with_data_subject_has_taken_place]),
    Result = indeterminate([Key]),
    Key == first_communication_with_data_subject_has_taken_place.
test(the_basis_item_copies_the_attested_term) :-
    Attested = attested(true, attestation(host, recorded_time, stated_reason, none)),
    Basis = [outside_fact(right_to_object_applies, Attested)],
    Basis = [outside_fact(Key, attested(Value, attestation(_By, _At, _Reason, Evidence)))],
    Key == right_to_object_applies,
    Value == true,
    Evidence == none.
test(the_facade_verdict_carries_status_and_citations) :-
    Verdict = gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_verdict(determination(notice_complies, follow_up_duty_met), [cite(eu_reg_2016_679_art_17_2), cite(eu_reg_2016_679_art_21_4)]),
    Verdict = gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_verdict(determination(NoticeResult, FollowUpResult), Citations),
    NoticeResult == notice_complies,
    FollowUpResult == follow_up_duty_met,
    Citations == [cite(eu_reg_2016_679_art_17_2), cite(eu_reg_2016_679_art_21_4)].
test(an_empty_profile_has_no_problem) :-
    findall(Problems, gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_input_problems([], Problems), Answers),
    Answers == [[]].
test(a_well_formed_profile_has_no_problem) :-
    Profile = [attribute(right_to_object_applies, attested(true, attestation(host, recorded_time, stated_reason, none))), attribute(first_communication_with_data_subject_has_taken_place, true), attribute(right_explicitly_brought_to_attention_by_first_communication, true), attribute(right_presented_separately_from_other_information, false), attribute(right_presented_clearly, unsure), attribute(controller_made_personal_data_public, true), attribute(controller_obliged_to_erase_under_article_17_1, attested(false, attestation(host, recorded_time, stated_reason, url(address, retrieved_time)))), attribute(reasonable_steps_taken_to_inform_other_controllers, false)],
    findall(Problems, gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_input_problems(Profile, Problems), Answers),
    Answers == [[]].
test(a_bare_outside_fact_is_wrong_type) :-
    findall(Problems, gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_input_problems([attribute(right_to_object_applies, true)], Problems), Answers),
    Answers == [[wrong_type(right_to_object_applies)]].
test(an_attested_crisp_key_is_wrong_type) :-
    gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_input_problems([attribute(controller_made_personal_data_public, attested(true, attestation(host, recorded_time, stated_reason, none)))], [wrong_type(controller_made_personal_data_public)]).
test(an_unsure_crisp_key_is_wrong_type) :-
    gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_input_problems([attribute(first_communication_with_data_subject_has_taken_place, unsure)], [wrong_type(first_communication_with_data_subject_has_taken_place)]).
test(an_unbound_attestation_argument_is_wrong_type) :-
    findall(Problems, gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_input_problems([attribute(controller_obliged_to_erase_under_article_17_1, attested(true, attestation(_By, recorded_time, stated_reason, none)))], Problems), Answers),
    Answers == [[wrong_type(controller_obliged_to_erase_under_article_17_1)]].
test(an_unbound_value_is_wrong_type) :-
    findall(Problems, gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_input_problems([attribute(right_presented_clearly, _Value)], Problems), Answers),
    Answers == [[wrong_type(right_presented_clearly)]].
test(a_repeated_key_is_a_duplicate_only) :-
    findall(Problems, gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_input_problems([attribute(controller_made_personal_data_public, true), attribute(controller_made_personal_data_public, unsure)], Problems), Answers),
    Answers == [[duplicate_key(controller_made_personal_data_public)]].
test(a_key_outside_the_contract_is_unknown_once) :-
    findall(Problems, gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_input_problems([attribute(stray_key, true), attribute(right_presented_clearly, maybe), attribute(stray_key, false)], Problems), Answers),
    Answers == [[wrong_type(right_presented_clearly), unknown_key(stray_key)]].
test(an_unbound_profile_is_not_an_attribute_list) :-
    findall(Problems, gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_input_problems(_Profile, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(a_list_with_a_foreign_element_is_not_an_attribute_list) :-
    gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_input_problems([attribute(right_presented_clearly, true), pair(other, value)], [wrong_type(profile)]).
test(a_partial_list_is_not_an_attribute_list) :-
    findall(Problems, gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_input_problems([attribute(right_presented_clearly, true)|_Rest], Problems), Answers),
    Answers == [[wrong_type(profile)]].

test(the_marker_fails_for_an_unrecorded_key, fail) :-
    implements(eu_reg_2016_679_art_17_two).
test(a_bare_outside_fact_is_not_well_formed, fail) :-
    gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_input_problems([attribute(right_to_object_applies, true)], []).

cp_test_names([the_article_21_4_citation_is_recorded, the_article_17_2_citation_is_recorded, the_right_to_object_target_is_recorded, the_erasure_obligation_target_is_recorded, the_citation_record_has_label_reference_and_verbatim, the_marker_succeeds_for_a_recorded_key, the_notice_atoms_are_distinct, the_follow_up_atoms_are_distinct, the_problem_constructors_are_distinct, the_absent_referral_builds_and_destructures, the_open_textured_referral_builds_and_destructures, the_indeterminate_status_names_one_key, the_basis_item_copies_the_attested_term, the_facade_verdict_carries_status_and_citations, an_empty_profile_has_no_problem, a_well_formed_profile_has_no_problem, a_bare_outside_fact_is_wrong_type, an_attested_crisp_key_is_wrong_type, an_unsure_crisp_key_is_wrong_type, an_unbound_attestation_argument_is_wrong_type, an_unbound_value_is_wrong_type, a_repeated_key_is_a_duplicate_only, a_key_outside_the_contract_is_unknown_once, an_unbound_profile_is_not_an_attribute_list, a_list_with_a_foreign_element_is_not_an_attribute_list, a_partial_list_is_not_an_attribute_list]).
cp_test_fail_names([the_marker_fails_for_an_unrecorded_key, a_bare_outside_fact_is_not_well_formed]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
