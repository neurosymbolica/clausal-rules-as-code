% SPDX-License-Identifier: EUPL-1.2
:- module(m__ind_dpdp_notice_consent_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__ind_dpdp_notice_consent_kernel, [dpdp_notice_consent_input_problems/2, key_state/3, relied_pairs/3, referral/5]).
:- use_module(m__ind_dpdp_notice_consent_citations, [citation/2, implements/1, citation_vocabulary/1]).

test(the_final_result_atoms_are_distinct) :-
    Atoms = [lawful_on_consent, not_lawful_on_consent, lawful_on_legitimate_use, not_lawful_on_legitimate_use, notice_with_request_required, notice_with_request_required_before_rule_3, notice_for_earlier_consent_required, notice_for_earlier_consent_required_before_rule_3, not_required, cease_processing_required, processing_may_continue_without_consent, may_act_as_consent_manager, may_not_act_as_consent_manager, not_in_force],
    sort(Atoms, Sorted),
    length(Atoms, Count),
    length(Sorted, Count),
    Count == 14.
test(the_consent_ground_atoms_are_distinct) :-
    dif(lawful_on_consent, not_lawful_on_consent),
    dif(lawful_on_consent, not_in_force),
    dif(not_lawful_on_consent, not_in_force).
test(the_notice_atom_differs_from_its_before_rule_3_twin) :-
    dif(notice_with_request_required, notice_with_request_required_before_rule_3),
    dif(notice_for_earlier_consent_required, notice_for_earlier_consent_required_before_rule_3).
test(the_withdrawal_atoms_are_distinct) :-
    dif(cease_processing_required, processing_may_continue_without_consent),
    dif(cease_processing_required, not_required).
test(the_consent_manager_atoms_are_distinct) :-
    dif(may_act_as_consent_manager, may_not_act_as_consent_manager).
test(the_indeterminate_status_names_one_key) :-
    Result = indeterminate([sections_4_to_7_in_force]),
    Result = indeterminate([MissingKey]),
    MissingKey == sections_4_to_7_in_force.
test(the_referral_status_destructures) :-
    Result = needs_legal_review(open_textured(lawful_purpose, cite(in_dpdp_act_2023_s_4_2)), [inputs_relied_on([lawful_purpose - unsure])]),
    Result = needs_legal_review(open_textured(Input, cite(CitationKey)), [inputs_relied_on(Pairs)]),
    Input == lawful_purpose,
    CitationKey == in_dpdp_act_2023_s_4_2,
    Pairs == [lawful_purpose - unsure].
test(the_input_problems_status_destructures) :-
    Result = input_problems([wrong_type(consent_given)]),
    Result = input_problems([wrong_type(Key)]),
    Key == consent_given.
test(the_content_item_destructures) :-
    Item = content_item(manner_to_complain_to_board, cite(in_dpdp_act_2023_s_5_1_iii)),
    Item = content_item(Name, cite(Key)),
    Name == manner_to_complain_to_board,
    Key == in_dpdp_act_2023_s_5_1_iii.
test(the_lawful_purpose_citation_is_recorded) :-
    citation(in_dpdp_act_2023_s_4_2, Record),
    member(ref - Ref, Record),
    Ref == 'in-dpdp-act-2023-meity-pdf#s4_2'.
test(the_rule_3_commencement_citation_is_recorded) :-
    citation(in_dpdp_rules_2025_r_1_4, _Record).
test(the_consent_manager_citation_implements) :-
    implements(in_dpdp_act_2023_s_6_9).
test(a_marker_only_key_is_recorded_but_not_in_the_vocabulary) :-
    implements(in_dpdp_rules_2025_r_5_1),
    citation_vocabulary(Keys),
    sort(Keys, SortedKeys),
    length(Keys, Count),
    length(SortedKeys, Count).
test(an_empty_profile_has_no_problem) :-
    dpdp_notice_consent_input_problems([], Problems),
    Problems == [].
test(a_good_date_is_accepted) :-
    dpdp_notice_consent_input_problems([attribute(question_date, date(2027, 5, 13))], Problems),
    Problems == [].
test(a_non_day_is_wrong_type) :-
    dpdp_notice_consent_input_problems([attribute(question_date, date(2027, 2, 29))], Problems),
    Problems == [wrong_type(question_date)].
test(a_number_profile_is_not_a_profile) :-
    dpdp_notice_consent_input_problems(42, Problems),
    Problems == [wrong_type(profile)].
test(an_absent_key_is_absent) :-
    key_state([], consent_withdrawn, State),
    State == absent.
test(the_pairs_keep_root_order) :-
    relied_pairs([attribute(processing_required_or_authorised_by_law, unsure), attribute(acts_as_data_fiduciary, true)], [acts_as_data_fiduciary, processing_required_or_authorised_by_law], Pairs),
    Pairs == [acts_as_data_fiduciary - true, processing_required_or_authorised_by_law - unsure].
test(the_referral_builds_the_review_term) :-
    referral(processing_required_or_authorised_by_law, in_dpdp_act_2023_s_6_6, [attribute(processing_required_or_authorised_by_law, unsure)], [acts_as_data_fiduciary, processing_required_or_authorised_by_law], Result),
    Result == needs_legal_review(open_textured(processing_required_or_authorised_by_law, cite(in_dpdp_act_2023_s_6_6)), [inputs_relied_on([processing_required_or_authorised_by_law - unsure])]).

test(a_marker_only_key_is_never_returnable, fail) :-
    citation_vocabulary(Keys),
    member(in_dpdp_rules_2025_r_5_1, Keys).
test(an_invented_key_is_not_recorded, fail) :-
    citation(dpdp_s_4_2, _Record).

cp_test_names([the_final_result_atoms_are_distinct, the_consent_ground_atoms_are_distinct, the_notice_atom_differs_from_its_before_rule_3_twin, the_withdrawal_atoms_are_distinct, the_consent_manager_atoms_are_distinct, the_indeterminate_status_names_one_key, the_referral_status_destructures, the_input_problems_status_destructures, the_content_item_destructures, the_lawful_purpose_citation_is_recorded, the_rule_3_commencement_citation_is_recorded, the_consent_manager_citation_implements, a_marker_only_key_is_recorded_but_not_in_the_vocabulary, an_empty_profile_has_no_problem, a_good_date_is_accepted, a_non_day_is_wrong_type, a_number_profile_is_not_a_profile, an_absent_key_is_absent, the_pairs_keep_root_order, the_referral_builds_the_review_term]).
cp_test_fail_names([a_marker_only_key_is_never_returnable, an_invented_key_is_not_recorded]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
