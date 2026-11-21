% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_kernel, [gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_input_problems/2, contract_keys/1]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_citations, [citation/2, implements/1]).

test(the_contract_has_fifty_four_keys) :-
    contract_keys(ContractKeys),
    length(ContractKeys, 54).
test(the_contract_keys_are_distinct) :-
    contract_keys(ContractKeys),
    sort(ContractKeys, SortedKeys),
    length(SortedKeys, 54).
test(the_contract_opens_with_request_type) :-
    contract_keys([request_type, objection_ground_claimed|_]).
test(an_empty_profile_has_no_problem) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_input_problems([], []).
test(a_well_formed_profile_has_exactly_one_answer) :-
    findall(Problems, gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_input_problems([attribute(request_type, portability), attribute(personal_data_provided_by_data_subject, true), attribute(transmission_would_adversely_affect_rights_and_freedoms_of_others, unsure), attribute(legislative_restriction_applies_to_the_right, attested(false, attestation(by, at, reason, none)))], Problems), Answers),
    Answers == [[]].
test(a_request_type_outside_its_enum_is_wrong_type) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_input_problems([attribute(request_type, deletion)], [wrong_type(request_type)]).
test(a_crisp_flag_given_unsure_is_wrong_type) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_input_problems([attribute(identity_confirmed, unsure)], [wrong_type(identity_confirmed)]).
test(a_judgement_given_unsure_is_well_typed) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_input_problems([attribute(decision_based_solely_on_automated_processing, unsure)], []).
test(an_unreal_calendar_day_is_wrong_type) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_input_problems([attribute(request_received_on, date(2026, 2, 30))], [wrong_type(request_received_on)]).
test(a_bare_outside_fact_is_wrong_type) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_input_problems([attribute(decision_authorised_by_union_or_member_state_law, true)], [wrong_type(decision_authorised_by_union_or_member_state_law)]).
test(a_repeated_key_is_one_duplicate_and_never_wrong_type) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_input_problems([attribute(identity_confirmed, true), attribute(identity_confirmed, nonsense)], [duplicate_key(identity_confirmed)]).
test(unknown_keys_follow_contract_problems_in_first_occurrence_order) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_input_problems([attribute(zeta_extra, one), attribute(request_type, deletion), attribute(alpha_extra, two), attribute(zeta_extra, three)], [wrong_type(request_type), unknown_key(zeta_extra), unknown_key(alpha_extra)]).
test(a_term_that_is_not_an_attribute_list_is_wrong_type_profile) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_input_problems(not_a_profile, [wrong_type(profile)]).
test(an_unbound_profile_is_wrong_type_profile) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_input_problems(_Unbound, [wrong_type(profile)]).
test(the_verdict_term_builds_and_destructures) :-
    Verdict = gdpr_data_subject_request_verdict(need_not_comply, art22_1, art22_2_c, [human_intervention, express_point_of_view, contest_decision], []),
    Verdict = gdpr_data_subject_request_verdict(Comply, Basis, Exception, Conditions, Citations),
    Comply == need_not_comply,
    Basis == art22_1,
    Exception == art22_2_c,
    Conditions == [human_intervention, express_point_of_view, contest_decision],
    Citations == [].
test(a_compound_indeterminate_carries_its_missing_keys) :-
    Comply = indeterminate([request_type]),
    Comply = indeterminate(MissingKeys),
    MissingKeys == [request_type].
test(a_referral_carries_its_reason_and_context) :-
    Comply = needs_legal_review(open_textured(reasonable_doubts_about_identity, cite(eu_reg_2016_679_art_12_6)), [inputs_relied_on([request_type - portability, reasonable_doubts_about_identity - unsure])]),
    Comply = needs_legal_review(open_textured(InputKey, cite(CitationKey)), [inputs_relied_on(Pairs)]),
    InputKey == reasonable_doubts_about_identity,
    CitationKey == eu_reg_2016_679_art_12_6,
    Pairs == [request_type - portability, reasonable_doubts_about_identity - unsure].
test(the_suspension_carries_its_reason) :-
    Comply = suspended(art12_6_identity_not_confirmed),
    Comply = suspended(Reason),
    Reason == art12_6_identity_not_confirmed.
test(the_modal_atoms_are_distinct) :-
    dif(must_comply, need_not_comply).
test(the_exception_atoms_are_distinct) :-
    dif(art20_3_public_task, art20_4_rights_of_others),
    dif(art22_2_a, art22_2_c),
    dif(art12_5_manifestly_unfounded_or_excessive, art12_2_unable_to_identify),
    dif(art23_legislative_restriction, none).
test(the_art_22_1_citation_is_recorded) :-
    citation(eu_reg_2016_679_art_22_1, Record),
    Record = [label - _, ref - _, verbatim - _].
test(the_referral_citations_resolve) :-
    citation(eu_reg_2016_679_art_12_5, _),
    citation(eu_reg_2016_679_art_12_6, _),
    citation(eu_reg_2016_679_art_20_3, _),
    citation(eu_reg_2016_679_art_20_4, _),
    citation(eu_reg_2016_679_art_21_1, _),
    citation(eu_reg_2016_679_art_21_6, _),
    citation(eu_reg_2016_679_art_22_1, _),
    citation(eu_reg_2016_679_art_22_2_a, _).
test(the_provenance_marker_holds_for_a_recorded_key) :-
    implements(eu_reg_2016_679_art_23_1).

test(a_well_formed_profile_is_not_flagged, fail) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_input_problems([attribute(request_type, portability)], [_|_]).
test(the_bare_indeterminate_is_not_the_compound, fail) :-
    indeterminate = indeterminate(_).
test(the_provenance_marker_fails_for_an_unrecorded_key, fail) :-
    implements(eu_todo_primary_source).
test(the_placeholder_citation_is_gone, fail) :-
    citation(eu_todo_primary_source, _).

cp_test_names([the_contract_has_fifty_four_keys, the_contract_keys_are_distinct, the_contract_opens_with_request_type, an_empty_profile_has_no_problem, a_well_formed_profile_has_exactly_one_answer, a_request_type_outside_its_enum_is_wrong_type, a_crisp_flag_given_unsure_is_wrong_type, a_judgement_given_unsure_is_well_typed, an_unreal_calendar_day_is_wrong_type, a_bare_outside_fact_is_wrong_type, a_repeated_key_is_one_duplicate_and_never_wrong_type, unknown_keys_follow_contract_problems_in_first_occurrence_order, a_term_that_is_not_an_attribute_list_is_wrong_type_profile, an_unbound_profile_is_wrong_type_profile, the_verdict_term_builds_and_destructures, a_compound_indeterminate_carries_its_missing_keys, a_referral_carries_its_reason_and_context, the_suspension_carries_its_reason, the_modal_atoms_are_distinct, the_exception_atoms_are_distinct, the_art_22_1_citation_is_recorded, the_referral_citations_resolve, the_provenance_marker_holds_for_a_recorded_key]).
cp_test_fail_names([a_well_formed_profile_is_not_flagged, the_bare_indeterminate_is_not_the_compound, the_provenance_marker_fails_for_an_unrecorded_key, the_placeholder_citation_is_gone]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
