% SPDX-License-Identifier: EUPL-1.2
:- module(m__ch_swiss_fadp_s1_international_transfers_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__ch_swiss_fadp_s1_international_transfers_kernel, [swiss_fadp_s1_international_transfers_input_problems/2, profile_key/3, key_state/3, inputs_relied_on_pairs/4]).
:- use_module(m__ch_swiss_fadp_s1_international_transfers_citations, [citation/2, implements/1]).

test(the_contract_has_twenty_seven_keys) :-
    findall(Key, profile_key(_, Key, _), Keys),
    length(Keys, 27).
test(the_first_and_last_keys_are_in_root_exports_order) :-
    profile_key(1, federal_council_adequacy_listing_covers_disclosure, outside_fact),
    profile_key(27, enforceable_rights_and_effective_remedies_available, judgement).
test(the_four_outside_facts_are_declared) :-
    findall(Key, profile_key(_, Key, outside_fact), Keys),
    Keys == [federal_council_adequacy_listing_covers_disclosure, standard_clauses_approved_issued_or_recognised_by_commissioner, binding_corporate_rules_approved_beforehand, commission_adequacy_decision_covers_transfer].
test(the_four_crisp_keys_are_declared) :-
    findall(Key, profile_key(_, Key, crisp), Keys),
    Keys == [contract_clauses_notified_to_commissioner_beforehand, specific_guarantees_notified_to_commissioner_beforehand, code_of_conduct_submitted_to_commissioner_for_approval_beforehand, commissioner_requested_information_on_disclosure].
test(an_empty_profile_has_no_problem) :-
    swiss_fadp_s1_international_transfers_input_problems([], Problems),
    Problems == [].
test(an_unknown_key_is_a_problem) :-
    swiss_fadp_s1_international_transfers_input_problems([attribute(stray_key, true)], Problems),
    Problems == [unknown_key(stray_key)].
test(a_non_list_profile_is_wrong_type) :-
    swiss_fadp_s1_international_transfers_input_problems(not_a_profile, Problems),
    Problems == [wrong_type(profile)].
test(an_attested_true_outside_fact_reads_true) :-
    key_state([attribute(commission_adequacy_decision_covers_transfer, attested(true, attestation(by, at, reason, none)))], commission_adequacy_decision_covers_transfer, State),
    State == true.
test(an_absent_judgement_reads_open_absent) :-
    key_state([], appropriate_safeguards_provided, State),
    State == open_absent.
test(pairs_name_the_referred_outside_fact_as_absent) :-
    inputs_relied_on_pairs([attribute(appropriate_safeguards_provided, true)], [commission_adequacy_decision_covers_transfer, appropriate_safeguards_provided, enforceable_rights_and_effective_remedies_available], commission_adequacy_decision_covers_transfer, Pairs),
    Pairs == [commission_adequacy_decision_covers_transfer - absent, appropriate_safeguards_provided - true].
test(the_article_16_route_atoms_are_distinct) :-
    dif(permitted_by_adequacy_decision, permitted_by_safeguards),
    dif(permitted_by_adequacy_decision, no_adequacy_decision_or_safeguards),
    dif(permitted_by_safeguards, no_adequacy_decision_or_safeguards).
test(the_disclosure_abroad_atoms_are_distinct) :-
    dif(permitted_by_derogation, disclosure_abroad_not_permitted),
    dif(permitted_by_derogation, permitted_by_safeguards),
    dif(disclosure_abroad_not_permitted, no_adequacy_decision_or_safeguards).
test(the_information_atoms_are_distinct) :-
    dif(information_of_commissioner_required, information_of_commissioner_not_required).
test(the_difference_atoms_are_distinct) :-
    dif(same, differs).
test(the_verdict_term_carries_status_and_citations) :-
    Verdict = swiss_fadp_s1_international_transfers_verdict(permitted_by_adequacy_decision, [cite(ch_fadp_art_16_1), cite(ch_fadp_ord_art_8_1), cite(ch_fadp_ord_annex_1)]),
    Verdict = swiss_fadp_s1_international_transfers_verdict(Status, Citations),
    Status == permitted_by_adequacy_decision,
    Citations == [cite(ch_fadp_art_16_1), cite(ch_fadp_ord_art_8_1), cite(ch_fadp_ord_annex_1)].
test(the_indeterminate_compound_holds_one_key) :-
    Result = indeterminate([appropriate_safeguards_provided]),
    Result = indeterminate([MissingKey]),
    MissingKey == appropriate_safeguards_provided.
test(the_open_textured_referral_destructures) :-
    Result = needs_legal_review(open_textured(appropriate_safeguards_provided, cite(eu_reg_2016_679_art_46_1)), [inputs_relied_on([appropriate_safeguards_provided - unsure])]),
    Result = needs_legal_review(open_textured(Key, cite(Citation)), [inputs_relied_on(Pairs)]),
    Key == appropriate_safeguards_provided,
    Citation == eu_reg_2016_679_art_46_1,
    Pairs == [appropriate_safeguards_provided - unsure].
test(the_cross_reference_referral_destructures) :-
    Result = needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_45_1), cite(commission_adequacy_decision_statement)), [resolution(cite(commission_adequacy_decision_statement), not_attempted), inputs_relied_on([commission_adequacy_decision_covers_transfer - absent])]),
    Result = needs_legal_review(cross_reference_unresolved(cite(Citation), cite(Target)), [resolution(cite(Target), Resolution), inputs_relied_on(Pairs)]),
    Citation == eu_reg_2016_679_art_45_1,
    Target == commission_adequacy_decision_statement,
    Resolution == not_attempted,
    Pairs == [commission_adequacy_decision_covers_transfer - absent].
test(the_input_problems_compound_destructures) :-
    Result = input_problems([unknown_key(stray_key)]),
    Result = input_problems(Problems),
    Problems == [unknown_key(stray_key)].
test(the_outside_fact_term_destructures) :-
    Fact = outside_fact(federal_council_adequacy_listing_covers_disclosure, attested(false, attestation(by, at, reason, none))),
    Fact = outside_fact(Key, attested(Value, attestation(_, _, _, Evidence))),
    Key == federal_council_adequacy_listing_covers_disclosure,
    Value == false,
    Evidence == none.
test(the_article_16_1_citation_is_recorded) :-
    citation(ch_fadp_art_16_1, _Record).
test(the_article_17_2_citation_is_recorded) :-
    citation(ch_fadp_art_17_2, _Record).
test(the_gdpr_citations_are_recorded) :-
    citation(eu_reg_2016_679_art_45_1, _FirstRecord),
    citation(eu_reg_2016_679_art_46_1, _SecondRecord).
test(the_referral_targets_are_recorded) :-
    implements(federal_council_adequacy_listing_statement),
    implements(commissioner_standard_clauses_statement),
    implements(swiss_binding_corporate_rules_approval_statement),
    implements(commission_adequacy_decision_statement).

test(the_placeholder_citation_is_gone, fail) :-
    citation(ch_todo_primary_source, _Record).

cp_test_names([the_contract_has_twenty_seven_keys, the_first_and_last_keys_are_in_root_exports_order, the_four_outside_facts_are_declared, the_four_crisp_keys_are_declared, an_empty_profile_has_no_problem, an_unknown_key_is_a_problem, a_non_list_profile_is_wrong_type, an_attested_true_outside_fact_reads_true, an_absent_judgement_reads_open_absent, pairs_name_the_referred_outside_fact_as_absent, the_article_16_route_atoms_are_distinct, the_disclosure_abroad_atoms_are_distinct, the_information_atoms_are_distinct, the_difference_atoms_are_distinct, the_verdict_term_carries_status_and_citations, the_indeterminate_compound_holds_one_key, the_open_textured_referral_destructures, the_cross_reference_referral_destructures, the_input_problems_compound_destructures, the_outside_fact_term_destructures, the_article_16_1_citation_is_recorded, the_article_17_2_citation_is_recorded, the_gdpr_citations_are_recorded, the_referral_targets_are_recorded]).
cp_test_fail_names([the_placeholder_citation_is_gone]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
