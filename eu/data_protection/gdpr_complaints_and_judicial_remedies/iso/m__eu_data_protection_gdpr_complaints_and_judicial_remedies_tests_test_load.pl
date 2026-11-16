% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_complaints_and_judicial_remedies_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_complaints_and_judicial_remedies_kernel, [gdpr_complaints_and_judicial_remedies_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_complaints_and_judicial_remedies_citations, [citation/2, implements/1]).

test(the_complaint_citation_is_recorded) :-
    citation(eu_reg_2016_679_art_77_1, _Record).
test(every_query_citation_is_recorded) :-
    citation(eu_reg_2016_679_art_77_1, _),
    citation(eu_reg_2016_679_art_78_1, _),
    citation(eu_reg_2016_679_art_78_2, _),
    citation(eu_reg_2016_679_art_79_1, _),
    citation(eu_reg_2016_679_art_79_2, _),
    citation(competence_statement, _).
test(the_citation_record_carries_label_ref_and_verbatim) :-
    citation(eu_reg_2016_679_art_79_2, [label - Label, ref - Reference, verbatim - Verbatim]),
    atom(Label),
    atom(Reference),
    atom(Verbatim).
test(the_competence_target_is_recorded_without_verbatim) :-
    citation(competence_statement, [label - Label, ref - Reference]),
    atom(Label),
    atom(Reference).
test(the_provenance_marker_holds_for_a_recorded_key) :-
    implements(eu_reg_2016_679_art_78_2).
test(the_complaint_atoms_are_distinct) :-
    dif(complaint_right_exists, no_complaint_right).
test(the_decision_remedy_atoms_are_distinct) :-
    dif(decision_remedy_right_exists, no_decision_remedy_right).
test(the_inaction_remedy_atoms_are_distinct) :-
    dif(inaction_remedy_right_exists, no_inaction_remedy_right).
test(the_judicial_remedy_atoms_are_distinct) :-
    dif(judicial_remedy_right_exists, no_judicial_remedy_right).
test(the_forum_atoms_are_distinct) :-
    dif(forum_establishment_state_only, forum_establishment_or_habitual_residence_state).
test(the_ten_result_atoms_are_pairwise_distinct) :-
    Atoms = [complaint_right_exists, no_complaint_right, decision_remedy_right_exists, no_decision_remedy_right, inaction_remedy_right_exists, no_inaction_remedy_right, judicial_remedy_right_exists, no_judicial_remedy_right, forum_establishment_state_only, forum_establishment_or_habitual_residence_state],
    sort(Atoms, Sorted),
    length(Sorted, 10).
test(the_verdict_term_carries_status_and_citations) :-
    Verdict = gdpr_complaints_and_judicial_remedies_verdict(complaint_right_exists, [cite(eu_reg_2016_679_art_77_1)]),
    Verdict = gdpr_complaints_and_judicial_remedies_verdict(Status, Citations),
    Status == complaint_right_exists,
    Citations == [cite(eu_reg_2016_679_art_77_1)].
test(the_indeterminate_result_names_one_key) :-
    Result = indeterminate([complaint_lodged_under_article_77]),
    Result = indeterminate([Key]),
    Key == complaint_lodged_under_article_77.
test(the_open_textured_referral_destructures) :-
    Result = needs_legal_review(open_textured(decision_concerns_the_caller, cite(eu_reg_2016_679_art_78_1)), [inputs_relied_on([decision_is_legally_binding - true, decision_concerns_the_caller - unsure])]),
    Result = needs_legal_review(open_textured(Input, cite(Citation)), [inputs_relied_on(Pairs)]),
    Input == decision_concerns_the_caller,
    Citation == eu_reg_2016_679_art_78_1,
    Pairs == [decision_is_legally_binding - true, decision_concerns_the_caller - unsure],
    citation(Citation, _).
test(the_cross_reference_referral_destructures) :-
    Result = needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_78_2), cite(competence_statement)), [resolution(cite(competence_statement), not_attempted), inputs_relied_on([authority_competent_under_articles_55_and_56 - absent])]),
    Result = needs_legal_review(cross_reference_unresolved(cite(Citation), cite(Target)), [resolution(cite(Target), Status), inputs_relied_on(Pairs)]),
    Citation == eu_reg_2016_679_art_78_2,
    Target == competence_statement,
    Status == not_attempted,
    Pairs == [authority_competent_under_articles_55_and_56 - absent],
    citation(Citation, _),
    citation(Target, _).
test(the_outside_fact_basis_is_copied_whole) :-
    Attested = attested(true, attestation(host_user, host_time, stated_by_caller, none)),
    Basis = [outside_fact(authority_competent_under_articles_55_and_56, Attested)],
    Basis = [outside_fact(Key, Copied)],
    Key == authority_competent_under_articles_55_and_56,
    Copied == Attested.
test(the_input_problems_result_destructures) :-
    Result = input_problems([wrong_type(is_data_subject), unknown_key(colour)]),
    Result = input_problems([First, Second]),
    First == wrong_type(is_data_subject),
    Second == unknown_key(colour).
test(an_empty_profile_has_no_problem) :-
    gdpr_complaints_and_judicial_remedies_input_problems([], []).
test(a_full_well_formed_profile_has_no_problem) :-
    gdpr_complaints_and_judicial_remedies_input_problems([attribute(is_data_subject, true), attribute(data_subject_considers_processing_infringes_regulation, true), attribute(decision_is_legally_binding, unsure), attribute(decision_concerns_the_caller, false), attribute(complaint_lodged_under_article_77, true), attribute(authority_competent_under_articles_55_and_56, attested(true, attestation(by, at, reason, none))), attribute(authority_handled_the_complaint, false), attribute(three_months_from_the_complaint_have_passed, true), attribute(authority_informed_on_progress_or_outcome, false), attribute(data_subject_considers_rights_infringed_by_processing, true), attribute(defendant_is_member_state_public_authority_acting_in_public_powers, false)], []).
test(the_input_check_gives_exactly_one_answer) :-
    findall(Problems, gdpr_complaints_and_judicial_remedies_input_problems([attribute(is_data_subject, true)], Problems), Answers),
    Answers == [[]].
test(a_crisp_key_given_unsure_is_wrong_type) :-
    gdpr_complaints_and_judicial_remedies_input_problems([attribute(is_data_subject, unsure)], [wrong_type(is_data_subject)]).
test(a_judgement_given_unsure_is_well_formed) :-
    gdpr_complaints_and_judicial_remedies_input_problems([attribute(decision_concerns_the_caller, unsure)], []).
test(a_bare_outside_fact_is_wrong_type) :-
    gdpr_complaints_and_judicial_remedies_input_problems([attribute(authority_competent_under_articles_55_and_56, true)], [wrong_type(authority_competent_under_articles_55_and_56)]).
test(an_attested_outside_fact_is_well_formed) :-
    gdpr_complaints_and_judicial_remedies_input_problems([attribute(authority_competent_under_articles_55_and_56, attested(false, attestation(by, at, reason, none)))], []).
test(an_unknown_key_comes_after_the_contract_problems) :-
    gdpr_complaints_and_judicial_remedies_input_problems([attribute(colour, blue), attribute(is_data_subject, maybe)], [wrong_type(is_data_subject), unknown_key(colour)]).
test(a_repeated_key_is_a_duplicate_only) :-
    gdpr_complaints_and_judicial_remedies_input_problems([attribute(is_data_subject, true), attribute(is_data_subject, unsure)], [duplicate_key(is_data_subject)]).
test(an_unbound_profile_is_not_an_attribute_list) :-
    findall(Problems, gdpr_complaints_and_judicial_remedies_input_problems(_, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(a_list_with_a_stray_element_is_not_an_attribute_list) :-
    gdpr_complaints_and_judicial_remedies_input_problems([attribute(is_data_subject, true), stray], [wrong_type(profile)]).

test(a_shortened_citation_is_not_recorded, fail) :-
    citation(art_77_1, _).
test(the_deferred_duty_to_inform_is_not_recorded, fail) :-
    implements(eu_reg_2016_679_art_77_2).
test(the_indeterminate_compound_is_not_the_bare_atom, fail) :-
    indeterminate([is_data_subject]) = indeterminate.
test(a_crisp_key_given_unsure_has_a_problem, fail) :-
    gdpr_complaints_and_judicial_remedies_input_problems([attribute(is_data_subject, unsure)], []).

cp_test_names([the_complaint_citation_is_recorded, every_query_citation_is_recorded, the_citation_record_carries_label_ref_and_verbatim, the_competence_target_is_recorded_without_verbatim, the_provenance_marker_holds_for_a_recorded_key, the_complaint_atoms_are_distinct, the_decision_remedy_atoms_are_distinct, the_inaction_remedy_atoms_are_distinct, the_judicial_remedy_atoms_are_distinct, the_forum_atoms_are_distinct, the_ten_result_atoms_are_pairwise_distinct, the_verdict_term_carries_status_and_citations, the_indeterminate_result_names_one_key, the_open_textured_referral_destructures, the_cross_reference_referral_destructures, the_outside_fact_basis_is_copied_whole, the_input_problems_result_destructures, an_empty_profile_has_no_problem, a_full_well_formed_profile_has_no_problem, the_input_check_gives_exactly_one_answer, a_crisp_key_given_unsure_is_wrong_type, a_judgement_given_unsure_is_well_formed, a_bare_outside_fact_is_wrong_type, an_attested_outside_fact_is_well_formed, an_unknown_key_comes_after_the_contract_problems, a_repeated_key_is_a_duplicate_only, an_unbound_profile_is_not_an_attribute_list, a_list_with_a_stray_element_is_not_an_attribute_list]).
cp_test_fail_names([a_shortened_citation_is_not_recorded, the_deferred_duty_to_inform_is_not_recorded, the_indeterminate_compound_is_not_the_bare_atom, a_crisp_key_given_unsure_has_a_problem]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
