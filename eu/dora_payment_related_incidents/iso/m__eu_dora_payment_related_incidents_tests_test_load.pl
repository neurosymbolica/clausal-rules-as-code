% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_payment_related_incidents_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_payment_related_incidents_kernel, [dora_payment_related_incidents_input_problems/2, dora_payment_related_incidents_contract_keys/1]).
:- use_module(m__eu_dora_payment_related_incidents_citations, [citation/2, implements/1]).

test(the_contract_keys_are_the_five_in_order) :-
    dora_payment_related_incidents_contract_keys(Keys),
    Keys == [dora_entity_type, incident_is_operational_or_security_payment_related, payment_related_incident_is_major, credit_institution_classified_as_significant, member_state_requires_reports_to_directive_2022_2555_authorities].
test(a_well_formed_profile_loads_with_no_problem) :-
    dora_payment_related_incidents_input_problems([attribute(dora_entity_type, payment_institution), attribute(incident_is_operational_or_security_payment_related, true), attribute(payment_related_incident_is_major, false)], Problems),
    Problems == [].
test(a_profile_that_is_not_a_list_is_wrong_type_profile) :-
    dora_payment_related_incidents_input_problems(not_a_list, Problems),
    Problems == [wrong_type(profile)].
test(an_unknown_key_is_named) :-
    dora_payment_related_incidents_input_problems([attribute(microenterprise, true)], Problems),
    Problems == [unknown_key(microenterprise)].
test(the_input_check_has_exactly_one_answer) :-
    findall(Problems, dora_payment_related_incidents_input_problems([attribute(dora_entity_type, credit_institution), attribute(dora_entity_type, payment_institution)], Problems), Answers),
    Answers == [[duplicate_key(dora_entity_type)]].
test(the_status_answer_carries_status_and_citations) :-
    Answer = answer(chapter_requirements_apply, [cite(eu_reg_2022_2554_art_23), cite(eu_reg_2022_2554_art_3_9), cite(eu_reg_2022_2554_art_3_11)]),
    Answer = answer(Status, Citations),
    Status == chapter_requirements_apply,
    length(Citations, 3).
test(the_recipients_term_destructures) :-
    Result = recipients([relevant_competent_authority, directive_2022_2555_competent_authority_or_csirt]),
    Result = recipients(List),
    List == [relevant_competent_authority, directive_2022_2555_competent_authority_or_csirt].
test(the_indeterminate_term_names_one_bare_key) :-
    Status = indeterminate([dora_entity_type]),
    Status = indeterminate([Key]),
    Key == dora_entity_type.
test(the_referral_term_destructures) :-
    Status = needs_legal_review(open_textured(payment_related_incident_is_major, cite(eu_reg_2022_2554_art_3_11)), [inputs_relied_on([dora_entity_type - credit_institution, incident_is_operational_or_security_payment_related - true, payment_related_incident_is_major - unsure])]),
    Status = needs_legal_review(open_textured(Input, cite(CitationKey)), [inputs_relied_on(Pairs)]),
    Input == payment_related_incident_is_major,
    CitationKey == eu_reg_2022_2554_art_3_11,
    length(Pairs, 3).
test(the_input_problems_term_destructures) :-
    Status = input_problems([wrong_type(dora_entity_type), unknown_key(colour)]),
    Status = input_problems(Problems),
    Problems == [wrong_type(dora_entity_type), unknown_key(colour)].
test(the_status_atoms_are_distinct) :-
    dif(chapter_requirements_and_article_19_reporting_apply, chapter_requirements_apply),
    dif(chapter_requirements_and_article_19_reporting_apply, not_a_payment_related_incident),
    dif(chapter_requirements_and_article_19_reporting_apply, not_an_article_23_entity),
    dif(chapter_requirements_apply, not_a_payment_related_incident),
    dif(chapter_requirements_apply, not_an_article_23_entity),
    dif(not_a_payment_related_incident, not_an_article_23_entity).
test(the_recipient_atoms_are_distinct) :-
    dif(relevant_competent_authority, national_competent_authority_designated_under_directive_2013_36),
    dif(relevant_competent_authority, directive_2022_2555_competent_authority_or_csirt),
    dif(national_competent_authority_designated_under_directive_2013_36, directive_2022_2555_competent_authority_or_csirt).
test(the_article_23_citation_is_recorded) :-
    citation(eu_reg_2022_2554_art_23, Record),
    Record = [label - _, ref - _, verbatim - _].
test(every_result_citation_is_recorded) :-
    citation(eu_reg_2022_2554_art_3_9, _),
    citation(eu_reg_2022_2554_art_3_11, _),
    citation(eu_reg_2022_2554_art_18_3_a, _),
    citation(eu_reg_2022_2554_art_19_1, _).
test(the_provenance_marker_succeeds_for_a_recorded_key) :-
    implements(eu_reg_2022_2554_art_19_1_third_subparagraph).

test(a_well_formed_profile_is_not_refused, fail) :-
    dora_payment_related_incidents_input_problems([attribute(dora_entity_type, credit_institution)], [_|_]).
test(the_same_status_atom_is_not_distinct, fail) :-
    dif(chapter_requirements_apply, chapter_requirements_apply).
test(a_shortened_citation_key_is_not_recorded, fail) :-
    citation(dora_art_23, _).

cp_test_names([the_contract_keys_are_the_five_in_order, a_well_formed_profile_loads_with_no_problem, a_profile_that_is_not_a_list_is_wrong_type_profile, an_unknown_key_is_named, the_input_check_has_exactly_one_answer, the_status_answer_carries_status_and_citations, the_recipients_term_destructures, the_indeterminate_term_names_one_bare_key, the_referral_term_destructures, the_input_problems_term_destructures, the_status_atoms_are_distinct, the_recipient_atoms_are_distinct, the_article_23_citation_is_recorded, every_result_citation_is_recorded, the_provenance_marker_succeeds_for_a_recorded_key]).
cp_test_fail_names([a_well_formed_profile_is_not_refused, the_same_status_atom_is_not_distinct, a_shortened_citation_key_is_not_recorded]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
