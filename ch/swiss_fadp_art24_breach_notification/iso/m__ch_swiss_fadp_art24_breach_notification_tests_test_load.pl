% SPDX-License-Identifier: EUPL-1.2
:- module(m__ch_swiss_fadp_art24_breach_notification_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__ch_swiss_fadp_art24_breach_notification_kernel, [swiss_fadp_art24_breach_notification_input_problems/2]).
:- use_module(m__ch_swiss_fadp_art24_breach_notification_citations, [citation/2, implements/1]).

test(a_well_formed_profile_has_no_problem) :-
    findall(Problems, swiss_fadp_art24_breach_notification_input_problems([attribute(breach_of_data_security, true), attribute(breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights, unsure), attribute(commissioner_requested_information_of_data_subject, false)], Problems), Answers),
    Answers == [[]].
test(the_empty_profile_has_no_problem) :-
    findall(Problems, swiss_fadp_art24_breach_notification_input_problems([], Problems), Answers),
    Answers == [[]].
test(a_key_outside_the_contract_is_unknown) :-
    findall(Problems, swiss_fadp_art24_breach_notification_input_problems([attribute(incident_reported_yesterday, true)], Problems), Answers),
    Answers == [[unknown_key(incident_reported_yesterday)]].
test(the_crisp_key_refuses_unsure) :-
    findall(Problems, swiss_fadp_art24_breach_notification_input_problems([attribute(commissioner_requested_information_of_data_subject, unsure)], Problems), Answers),
    Answers == [[wrong_type(commissioner_requested_information_of_data_subject)]].
test(a_judgement_key_accepts_unsure) :-
    swiss_fadp_art24_breach_notification_input_problems([attribute(breach_unlikely_to_result_in_risk, unsure)], []).
test(a_repeated_key_is_a_duplicate_only) :-
    findall(Problems, swiss_fadp_art24_breach_notification_input_problems([attribute(personal_data_breach, true), attribute(personal_data_breach, maybe)], Problems), Answers),
    Answers == [[duplicate_key(personal_data_breach)]].
test(contract_problems_come_before_unknown_keys) :-
    findall(Problems, swiss_fadp_art24_breach_notification_input_problems([attribute(incident_reported_yesterday, true), attribute(breach_of_data_security, yes)], Problems), Answers),
    Answers == [[wrong_type(breach_of_data_security), unknown_key(incident_reported_yesterday)]].
test(a_term_that_is_not_an_attribute_list_is_wrong_type_profile) :-
    findall(Problems, swiss_fadp_art24_breach_notification_input_problems([breach_of_data_security - true], Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(an_unbound_profile_is_wrong_type_profile) :-
    findall(Problems, swiss_fadp_art24_breach_notification_input_problems(_, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(the_authority_answers_are_distinct) :-
    dif(authority_notification_required, authority_notification_not_required).
test(the_processor_answers_are_distinct) :-
    dif(report_to_controller_required, report_to_controller_not_required).
test(the_information_answers_are_distinct) :-
    dif(information_of_data_subject_required, information_of_data_subject_not_required),
    dif(information_of_data_subject_required, information_of_data_subject_may_be_restricted_deferred_or_omitted),
    dif(information_of_data_subject_not_required, information_of_data_subject_may_be_restricted_deferred_or_omitted).
test(the_comparison_answers_are_distinct) :-
    dif(same, differs),
    dif(same, not_comparable),
    dif(differs, not_comparable).
test(the_verdict_term_carries_status_and_citations) :-
    Verdict = swiss_fadp_art24_breach_notification_verdict(authority_notification_required, [cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_1)]),
    Verdict = swiss_fadp_art24_breach_notification_verdict(Status, Citations),
    Status == authority_notification_required,
    Citations == [cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_1)].
test(the_indeterminate_status_holds_one_key) :-
    Result = indeterminate([breach_of_data_security]),
    Result = indeterminate(MissingKeys),
    MissingKeys = [Key],
    Key == breach_of_data_security.
test(the_referral_destructures) :-
    Result = needs_legal_review(open_textured(breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights, cite(ch_fadp_art_24_1)), [inputs_relied_on([breach_of_data_security - true, breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights - unsure])]),
    Result = needs_legal_review(open_textured(Key, cite(CitationKey)), [inputs_relied_on(Pairs)]),
    Key == breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights,
    CitationKey == ch_fadp_art_24_1,
    Pairs = [_ - true, _ - unsure].
test(the_input_problems_status_destructures) :-
    Result = input_problems([wrong_type(profile)]),
    Result = input_problems(Problems),
    Problems == [wrong_type(profile)].
test(the_swiss_report_citation_is_recorded) :-
    citation(ch_fadp_art_24_1, Record),
    Record = [label - _, ref - _, verbatim - _].
test(the_definition_citation_is_recorded) :-
    citation(ch_fadp_art_5_h, _).
test(the_exception_citations_are_recorded) :-
    citation(ch_fadp_art_24_5, _),
    citation(ch_fadp_art_24_5_a, _),
    citation(ch_fadp_art_24_5_b, _),
    citation(ch_fadp_art_24_5_c, _).
test(the_eu_citation_is_implemented) :-
    implements(eu_reg_2016_679_art_33_1).

test(a_well_formed_profile_is_not_reported_as_a_problem, fail) :-
    swiss_fadp_art24_breach_notification_input_problems([attribute(breach_of_data_security, true)], [_|_]).
test(two_distinct_atoms_are_not_equal, fail) :-
    authority_notification_required = authority_notification_not_required.
test(a_status_compound_is_not_a_final_atom, fail) :-
    indeterminate([breach_of_data_security]) = authority_notification_not_required.
test(an_invented_citation_is_not_recorded, fail) :-
    citation(ch_fadp_art_24, _).

cp_test_names([a_well_formed_profile_has_no_problem, the_empty_profile_has_no_problem, a_key_outside_the_contract_is_unknown, the_crisp_key_refuses_unsure, a_judgement_key_accepts_unsure, a_repeated_key_is_a_duplicate_only, contract_problems_come_before_unknown_keys, a_term_that_is_not_an_attribute_list_is_wrong_type_profile, an_unbound_profile_is_wrong_type_profile, the_authority_answers_are_distinct, the_processor_answers_are_distinct, the_information_answers_are_distinct, the_comparison_answers_are_distinct, the_verdict_term_carries_status_and_citations, the_indeterminate_status_holds_one_key, the_referral_destructures, the_input_problems_status_destructures, the_swiss_report_citation_is_recorded, the_definition_citation_is_recorded, the_exception_citations_are_recorded, the_eu_citation_is_implemented]).
cp_test_fail_names([a_well_formed_profile_is_not_reported_as_a_problem, two_distinct_atoms_are_not_equal, a_status_compound_is_not_a_final_atom, an_invented_citation_is_not_recorded]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
