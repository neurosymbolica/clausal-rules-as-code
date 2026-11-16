% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_art15_access_copy_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_art15_access_copy_kernel, [gdpr_art15_access_copy_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_art15_access_copy_citations, [citation/2, implements/1]).

test(the_chapeau_citation_is_recorded) :-
    citation(eu_reg_2016_679_art_15_1, _Record).
test(the_copy_citation_is_recorded) :-
    citation(eu_reg_2016_679_art_15_3, _Record).
test(the_rights_of_others_citation_is_recorded) :-
    citation(eu_reg_2016_679_art_15_4, _Record).
test(the_referral_targets_are_recorded) :-
    citation(article_22_automated_decision_making_statement, _Article22Record),
    citation(article_46_safeguards_statement, _Article46Record).
test(the_marker_holds_for_a_recorded_key) :-
    implements(eu_reg_2016_679_art_15_1_h).
test(the_chapeau_record_carries_label_ref_verbatim) :-
    citation(eu_reg_2016_679_art_15_1, [label - _Label, ref - _Reference, verbatim - _Verbatim]).
test(the_copy_scope_atoms_are_distinct) :-
    dif(full_copy, copy_limited_by_rights_and_freedoms_of_others),
    dif(full_copy, no_personal_data_to_copy),
    dif(copy_limited_by_rights_and_freedoms_of_others, no_personal_data_to_copy).
test(the_copy_fee_atoms_are_distinct) :-
    dif(no_fee_under_article_15_3, reasonable_fee_permitted),
    dif(no_fee_under_article_15_3, no_personal_data_to_copy).
test(the_information_form_atoms_are_distinct) :-
    dif(no_electronic_request, other_form_requested),
    dif(other_form_requested, commonly_used_electronic_form),
    dif(no_electronic_request, commonly_used_electronic_form).
test(the_slice_verdict_atoms_are_distinct) :-
    dif(access_answer_complete, access_answer_incomplete),
    dif(access_answer_awaiting_input, access_answer_referred_for_legal_review),
    dif(access_answer_incomplete, access_answer_input_rejected).
test(the_verdict_term_carries_status_and_citations) :-
    Verdict = gdpr_art15_access_copy_verdict(access_answer_complete, [cite(eu_reg_2016_679_art_15_1)]),
    Verdict = gdpr_art15_access_copy_verdict(Status, Citations),
    Status == access_answer_complete,
    Citations == [cite(eu_reg_2016_679_art_15_1)].
test(the_absent_referral_term_destructures) :-
    Result = needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_15_2), cite(article_46_safeguards_statement)), [resolution(cite(article_46_safeguards_statement), not_attempted), inputs_relied_on([transfer_subject_to_article_46_safeguards - absent])]),
    Result = needs_legal_review(cross_reference_unresolved(cite(Citation), cite(Target)), [resolution(cite(Target), Resolution), inputs_relied_on([Key - Value])]),
    Citation == eu_reg_2016_679_art_15_2,
    Target == article_46_safeguards_statement,
    Resolution == not_attempted,
    Key == transfer_subject_to_article_46_safeguards,
    Value == absent.
test(the_open_textured_term_destructures) :-
    Result = needs_legal_review(open_textured(copy_would_adversely_affect_rights_and_freedoms_of_others, cite(eu_reg_2016_679_art_15_4)), [inputs_relied_on([copy_would_adversely_affect_rights_and_freedoms_of_others - unsure])]),
    Result = needs_legal_review(open_textured(Input, cite(Citation)), [inputs_relied_on(Pairs)]),
    Input == copy_would_adversely_affect_rights_and_freedoms_of_others,
    Citation == eu_reg_2016_679_art_15_4,
    Pairs == [copy_would_adversely_affect_rights_and_freedoms_of_others - unsure].
test(the_basis_item_carries_the_attested_term) :-
    Attested = attested(true, attestation(by, at, reason, none)),
    Basis = [outside_fact(automated_decision_making_referred_to_in_article_22, Attested)],
    Basis = [outside_fact(Key, attested(Value, attestation(_By, _At, _Reason, Evidence)))],
    Key == automated_decision_making_referred_to_in_article_22,
    Value == true,
    Evidence == none.
test(an_empty_profile_has_no_problem) :-
    findall(Problems, gdpr_art15_access_copy_input_problems([], Problems), Answers),
    Answers == [[]].
test(a_well_formed_profile_has_no_problem) :-
    Profile = [attribute(items_provided, [confirmation_of_processing, copy_of_personal_data]), attribute(personal_data_concerning_data_subject_processed, true), attribute(automated_decision_making_referred_to_in_article_22, attested(false, attestation(by, at, reason, none))), attribute(copy_would_adversely_affect_rights_and_freedoms_of_others, unsure)],
    findall(Problems, gdpr_art15_access_copy_input_problems(Profile, Problems), Answers),
    Answers == [[]].
test(a_non_list_profile_is_wrong_type) :-
    findall(Problems, gdpr_art15_access_copy_input_problems(not_a_profile, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(an_unbound_profile_is_wrong_type) :-
    findall(Problems, gdpr_art15_access_copy_input_problems(_Unbound, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(an_unknown_key_is_named) :-
    gdpr_art15_access_copy_input_problems([attribute(bogus_key, true)], Problems),
    Problems == [unknown_key(bogus_key)].
test(a_repeated_key_is_a_duplicate) :-
    gdpr_art15_access_copy_input_problems([attribute(further_copy_requested, true), attribute(further_copy_requested, false)], Problems),
    Problems == [duplicate_key(further_copy_requested)].
test(a_bare_outside_fact_is_wrong_type) :-
    gdpr_art15_access_copy_input_problems([attribute(automated_decision_making_referred_to_in_article_22, true)], Problems),
    Problems == [wrong_type(automated_decision_making_referred_to_in_article_22)].
test(an_unsure_crisp_key_is_wrong_type) :-
    gdpr_art15_access_copy_input_problems([attribute(request_made_by_electronic_means, unsure)], Problems),
    Problems == [wrong_type(request_made_by_electronic_means)].
test(a_foreign_item_atom_is_wrong_type) :-
    gdpr_art15_access_copy_input_problems([attribute(items_provided, [confirmation_of_processing, not_an_item])], Problems),
    Problems == [wrong_type(items_provided)].
test(a_well_formed_profile_gives_the_empty_list) :-
    gdpr_art15_access_copy_input_problems([attribute(personal_data_concerning_data_subject_processed, false)], []).

test(the_marker_fails_for_an_unrecorded_key, fail) :-
    implements(eu_todo_primary_source).
test(a_well_formed_profile_is_not_wrong_type, fail) :-
    gdpr_art15_access_copy_input_problems([attribute(personal_data_concerning_data_subject_processed, false)], [wrong_type(_Key)]).

cp_test_names([the_chapeau_citation_is_recorded, the_copy_citation_is_recorded, the_rights_of_others_citation_is_recorded, the_referral_targets_are_recorded, the_marker_holds_for_a_recorded_key, the_chapeau_record_carries_label_ref_verbatim, the_copy_scope_atoms_are_distinct, the_copy_fee_atoms_are_distinct, the_information_form_atoms_are_distinct, the_slice_verdict_atoms_are_distinct, the_verdict_term_carries_status_and_citations, the_absent_referral_term_destructures, the_open_textured_term_destructures, the_basis_item_carries_the_attested_term, an_empty_profile_has_no_problem, a_well_formed_profile_has_no_problem, a_non_list_profile_is_wrong_type, an_unbound_profile_is_wrong_type, an_unknown_key_is_named, a_repeated_key_is_a_duplicate, a_bare_outside_fact_is_wrong_type, an_unsure_crisp_key_is_wrong_type, a_foreign_item_atom_is_wrong_type, a_well_formed_profile_gives_the_empty_list]).
cp_test_fail_names([the_marker_fails_for_an_unrecorded_key, a_well_formed_profile_is_not_wrong_type]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
