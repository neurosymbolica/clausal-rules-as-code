% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_information_duties_headline_verdict_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_information_duties_headline_verdict_kernel, [gdpr_information_duties_headline_verdict_input_problems/2, contract_keys/1, key_status/3, attested_status/3]).
:- use_module(m__eu_data_protection_gdpr_information_duties_headline_verdict_citations, [citation/2, implements/1]).

test(the_verdict_result_carries_verdict_and_citations) :-
    Result = information_duty_verdict_result(eligible, [cite(eu_reg_2016_679_art_14_1)]),
    Result = information_duty_verdict_result(Verdict, Citations),
    Verdict == eligible,
    Citations == [cite(eu_reg_2016_679_art_14_1)].
test(the_exemption_result_carries_exemption_and_citations) :-
    Result = information_duty_exemption_result(professional_secrecy_obligation, [cite(eu_reg_2016_679_art_14_5_d)]),
    Result = information_duty_exemption_result(Exemption, Citations),
    Exemption == professional_secrecy_obligation,
    Citations == [cite(eu_reg_2016_679_art_14_5_d)].
test(a_referral_term_destructures) :-
    Referral = needs_legal_review(open_textured(provision_impossible_or_disproportionate_effort, cite(eu_reg_2016_679_art_14_5_b)), [inputs_relied_on([provision_impossible_or_disproportionate_effort - unsure])]),
    Referral = needs_legal_review(open_textured(Input, cite(Key)), [inputs_relied_on(Pairs)]),
    Input == provision_impossible_or_disproportionate_effort,
    Key == eu_reg_2016_679_art_14_5_b,
    Pairs == [provision_impossible_or_disproportionate_effort - unsure].
test(an_indeterminate_term_destructures) :-
    Status = indeterminate([personal_data_collected_from_data_subject]),
    Status = indeterminate(MissingKeys),
    MissingKeys == [personal_data_collected_from_data_subject].
test(an_outside_fact_term_destructures) :-
    Item = outside_fact(public_holidays, attested([date(2026, 12, 25)], attestation(by, at, reason, none))),
    Item = outside_fact(Key, attested(Holidays, attestation(_, _, _, Evidence))),
    Key == public_holidays,
    Holidays == [date(2026, 12, 25)],
    Evidence == none.
test(the_verdict_atoms_are_distinct) :-
    dif(eligible, ineligible).
test(the_exemption_atoms_are_distinct) :-
    dif(none, impossible_or_disproportionate_effort),
    dif(none, law_lays_down_obtaining_or_disclosure),
    dif(none, professional_secrecy_obligation),
    dif(impossible_or_disproportionate_effort, law_lays_down_obtaining_or_disclosure),
    dif(impossible_or_disproportionate_effort, professional_secrecy_obligation),
    dif(law_lays_down_obtaining_or_disclosure, professional_secrecy_obligation).
test(the_judgement_value_unsure_is_not_a_boolean) :-
    dif(unsure, true),
    dif(unsure, false).
test(the_art_14_1_citation_is_recorded) :-
    citation(eu_reg_2016_679_art_14_1, _Record).
test(the_art_13_1_citation_is_recorded) :-
    citation(eu_reg_2016_679_art_13_1, _Record).
test(the_exemption_citations_are_recorded) :-
    citation(eu_reg_2016_679_art_14_5_b, _RecordB),
    citation(eu_reg_2016_679_art_14_5_c, _RecordC),
    citation(eu_reg_2016_679_art_14_5_d, _RecordD).
test(a_citation_record_has_label_ref_verbatim) :-
    citation(eu_reg_2016_679_art_14_3_a, [label - _Label, ref - _Reference, verbatim - _Verbatim]).
test(the_calendar_rule_marker_is_recorded) :-
    implements(eu_reg_1971_1182_art_3_2_c).
test(the_contract_has_twenty_six_keys) :-
    contract_keys(Keys),
    length(Keys, 26).
test(a_clean_profile_has_no_problem) :-
    gdpr_information_duties_headline_verdict_input_problems([attribute(personal_data_collected_from_data_subject, false)], []).
test(a_non_list_is_not_a_profile) :-
    gdpr_information_duties_headline_verdict_input_problems(not_a_profile, [wrong_type(profile)]).
test(an_absent_key_reads_unknown) :-
    key_status([], recipients_exist, unknown([recipients_exist])).
test(an_absent_outside_fact_reads_absent) :-
    attested_status([], obtaining_or_disclosure_laid_down_by_law, absent).

test(an_invented_citation_is_not_recorded, fail) :-
    citation(eu_todo_primary_source, _Record).

cp_test_names([the_verdict_result_carries_verdict_and_citations, the_exemption_result_carries_exemption_and_citations, a_referral_term_destructures, an_indeterminate_term_destructures, an_outside_fact_term_destructures, the_verdict_atoms_are_distinct, the_exemption_atoms_are_distinct, the_judgement_value_unsure_is_not_a_boolean, the_art_14_1_citation_is_recorded, the_art_13_1_citation_is_recorded, the_exemption_citations_are_recorded, a_citation_record_has_label_ref_verbatim, the_calendar_rule_marker_is_recorded, the_contract_has_twenty_six_keys, a_clean_profile_has_no_problem, a_non_list_is_not_a_profile, an_absent_key_reads_unknown, an_absent_outside_fact_reads_absent]).
cp_test_fail_names([an_invented_citation_is_not_recorded]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
