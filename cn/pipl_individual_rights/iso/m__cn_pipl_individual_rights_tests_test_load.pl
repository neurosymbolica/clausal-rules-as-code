% SPDX-License-Identifier: EUPL-1.2
:- module(m__cn_pipl_individual_rights_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__cn_pipl_individual_rights_kernel, [pipl_individual_rights_input_problems/2, pipl_individual_rights_key_state/3, pipl_individual_rights_relied_pairs/3]).
:- use_module(m__cn_pipl_individual_rights_citations, [citation/2, implements/1]).

test(the_input_check_loads_and_passes_an_empty_profile) :-
    pipl_individual_rights_input_problems([], []).
test(the_input_check_has_exactly_one_answer_for_a_good_profile) :-
    findall(Problems, pipl_individual_rights_input_problems([attribute(pinned_text_in_force_on_reference_day, true), attribute(convenient_mechanism_established, unsure)], Problems), Answers),
    Answers == [[]].
test(the_input_check_names_a_wrong_type_and_an_unknown_key) :-
    pipl_individual_rights_input_problems([attribute(colour, red), attribute(request_refused, unsure)], [wrong_type(request_refused), unknown_key(colour)]).
test(a_non_list_profile_is_wrong_type_profile) :-
    pipl_individual_rights_input_problems(not_a_profile, [wrong_type(profile)]).
test(the_key_state_reads_absent_and_present_keys) :-
    pipl_individual_rights_key_state([attribute(person_deceased, false)], person_deceased, false),
    pipl_individual_rights_key_state([attribute(person_deceased, false)], request_refused, absent).
test(the_pairs_rule_keeps_present_judgements_in_list_order) :-
    pipl_individual_rights_relied_pairs([attribute(processing_violates_law_or_agreement, unsure), attribute(consent_withdrawn, true)], [purpose_achieved_impossible_or_unnecessary, processing_violates_law_or_agreement, deletion_technically_difficult], RelyPairs),
    RelyPairs == [processing_violates_law_or_agreement - unsure].
test(the_indeterminate_compound_carries_one_key) :-
    Result = indeterminate([pinned_text_in_force_on_reference_day]),
    Result = indeterminate([MissingKey]),
    MissingKey == pinned_text_in_force_on_reference_day.
test(the_referral_compound_carries_reason_and_context) :-
    Result = needs_legal_review(open_textured(convenient_mechanism_established, cite(cn_pipl_art_50_p1)), [inputs_relied_on([convenient_mechanism_established - unsure])]),
    Result = needs_legal_review(open_textured(Input, cite(CitationKey)), [inputs_relied_on(RelyPairs)]),
    Input == convenient_mechanism_established,
    CitationKey == cn_pipl_art_50_p1,
    RelyPairs == [convenient_mechanism_established - unsure].
test(the_input_problems_compound_carries_its_problems) :-
    Result = input_problems([duplicate_key(consent_withdrawn)]),
    Result = input_problems([Problem]),
    Problem == duplicate_key(consent_withdrawn).
test(the_facade_verdict_term_carries_status_and_checklist) :-
    Verdict = pipl_individual_rights_verdict(eligible, [item(convenient_mechanism, met, cite(cn_pipl_art_50_p1))]),
    Verdict = pipl_individual_rights_verdict(Status, Checklist),
    Status == eligible,
    Checklist = [item(Requirement, ItemStatus, cite(CitationKey))],
    Requirement == convenient_mechanism,
    ItemStatus == met,
    CitationKey == cn_pipl_art_50_p1.
test(the_deletion_answers_are_distinct) :-
    dif(not_owed, delete_personal_information),
    dif(delete_personal_information, stop_processing_except_storage_and_security),
    dif(not_owed, stop_processing_except_storage_and_security),
    dif(pinned_text_not_applicable, not_owed).
test(the_refusal_answers_are_distinct) :-
    dif(not_refused, refused_with_reasons),
    dif(refused_with_reasons, refused_without_reasons),
    dif(not_refused, refused_without_reasons).
test(the_other_answers_are_distinct) :-
    dif(right_available, excluded_by_other_law),
    dif(provide_in_time, provide_transfer_route),
    dif(correct_or_supplement_in_time, no_correction_owed),
    dif(near_relative_may_exercise, near_relative_may_not_exercise),
    dif(requirement_met, requirement_not_met),
    dif(explain_processing_rules, pinned_text_not_applicable).
test(the_facade_statuses_are_distinct) :-
    dif(eligible, ineligible),
    dif(undetermined, referred_for_legal_review),
    dif(text_not_in_force, input_rejected).
test(the_article_44_citation_is_recorded) :-
    citation(cn_pipl_art_44_p1, Record),
    member(label - _, Record),
    member(ref - _, Record).
test(the_article_47_2_citation_is_implemented) :-
    implements(cn_pipl_art_47_p2).
test(every_citation_vocabulary_key_is_recorded) :-
    maplist(implements, [cn_pipl_art_44_p1, cn_pipl_art_45_p1, cn_pipl_art_45_p2, cn_pipl_art_45_p3, cn_pipl_art_46_p1, cn_pipl_art_46_p2, cn_pipl_art_47_p1, cn_pipl_art_47_p1_i1, cn_pipl_art_47_p1_i2, cn_pipl_art_47_p1_i3, cn_pipl_art_47_p1_i4, cn_pipl_art_47_p1_i5, cn_pipl_art_47_p2, cn_pipl_art_48_p1, cn_pipl_art_49_p1, cn_pipl_art_50_p1, cn_pipl_art_50_p2]).

test(a_crisp_key_given_unsure_is_not_well_formed, fail) :-
    pipl_individual_rights_input_problems([attribute(request_refused, unsure)], []).
test(a_shortened_citation_key_is_not_recorded, fail) :-
    citation(pipl_art_44, _).

cp_test_names([the_input_check_loads_and_passes_an_empty_profile, the_input_check_has_exactly_one_answer_for_a_good_profile, the_input_check_names_a_wrong_type_and_an_unknown_key, a_non_list_profile_is_wrong_type_profile, the_key_state_reads_absent_and_present_keys, the_pairs_rule_keeps_present_judgements_in_list_order, the_indeterminate_compound_carries_one_key, the_referral_compound_carries_reason_and_context, the_input_problems_compound_carries_its_problems, the_facade_verdict_term_carries_status_and_checklist, the_deletion_answers_are_distinct, the_refusal_answers_are_distinct, the_other_answers_are_distinct, the_facade_statuses_are_distinct, the_article_44_citation_is_recorded, the_article_47_2_citation_is_implemented, every_citation_vocabulary_key_is_recorded]).
cp_test_fail_names([a_crisp_key_given_unsure_is_not_well_formed, a_shortened_citation_key_is_not_recorded]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
