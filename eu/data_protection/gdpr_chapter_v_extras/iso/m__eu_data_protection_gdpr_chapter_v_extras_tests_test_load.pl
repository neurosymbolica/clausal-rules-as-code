% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_chapter_v_extras_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_chapter_v_extras_kernel, [gdpr_chapter_v_extras_input_problems/2, duty_argument_problems/2, outside_fact_reference/3, absent_referral/2]).
:- use_module(m__eu_data_protection_gdpr_chapter_v_extras_citations, [citation/2, implements/1]).

test(an_empty_profile_has_no_problem) :-
    findall(Problems, gdpr_chapter_v_extras_input_problems([], Problems), All),
    All == [[]].
test(a_well_formed_profile_has_no_problem) :-
    Attested = attested(true, attestation(by, at, reason, none)),
    gdpr_chapter_v_extras_input_problems([attribute(transfer_relies_on_article_49_1_second_subparagraph, Attested), attribute(party_role, controller), attribute(supervisory_authority_informed_of_transfer, true)], []).
test(a_non_list_profile_is_wrong_type) :-
    findall(Problems, gdpr_chapter_v_extras_input_problems(not_a_list, Problems), All),
    All == [[wrong_type(profile)]].
test(an_unbound_profile_is_wrong_type) :-
    findall(Problems, gdpr_chapter_v_extras_input_problems(_, Problems), All),
    All == [[wrong_type(profile)]].
test(a_duplicate_and_an_unknown_key_are_named_in_order) :-
    gdpr_chapter_v_extras_input_problems([attribute(stray_key, 1), attribute(party_role, controller), attribute(party_role, processor)], [duplicate_key(party_role), unknown_key(stray_key)]).
test(a_crisp_key_given_an_attested_term_is_wrong_type) :-
    gdpr_chapter_v_extras_input_problems([attribute(assessment_documented_in_records, attested(true, attestation(by, at, reason, none)))], [wrong_type(assessment_documented_in_records)]).
test(each_duty_atom_has_no_problem) :-
    duty_argument_problems(inform_supervisory_authority, []),
    duty_argument_problems(inform_data_subject, []),
    duty_argument_problems(document_assessment_and_safeguards, []).
test(an_unknown_duty_is_wrong_type) :-
    duty_argument_problems(inform_everyone, [wrong_type(duty)]).
test(the_absent_referral_builds_and_destructures) :-
    findall(Result, absent_referral(transfer_relies_on_article_49_1_second_subparagraph, Result), [Result]),
    Result = needs_legal_review(cross_reference_unresolved(Citation, Target), [resolution(ResolvedTarget, Status), inputs_relied_on(Pairs)]),
    Citation == cite(eu_reg_2016_679_art_49_1_second_subpara),
    Target == cite(second_subparagraph_transfer_statement),
    ResolvedTarget == Target,
    Status == not_attempted,
    Pairs == [transfer_relies_on_article_49_1_second_subparagraph - absent].
test(every_outside_fact_has_one_reference) :-
    findall(Key, outside_fact_reference(Key, _, _), Keys),
    Keys == [transfer_relies_on_article_49_1_second_subparagraph, third_country_judgment_or_decision_requires_transfer, international_agreement_basis_for_judgment_or_decision, transfer_is_onward_transfer, onward_transfer_has_chapter_v_basis].
test(the_basis_item_carries_the_attested_term_as_supplied) :-
    Attested = attested(false, attestation(by, at, reason, none)),
    Item = outside_fact(transfer_is_onward_transfer, Attested),
    Item = outside_fact(Key, attested(Value, attestation(_, _, _, Evidence))),
    Key == transfer_is_onward_transfer,
    Value == false,
    Evidence == none.
test(the_status_compounds_build_and_destructure) :-
    Missing = indeterminate([party_role]),
    Missing = indeterminate([MissingKey]),
    MissingKey == party_role,
    Refused = input_problems([wrong_type(duty)]),
    Refused = input_problems([wrong_type(BadArgument)]),
    BadArgument == duty.
test(the_duty_results_are_distinct) :-
    dif(no_second_subparagraph_transfer, not_a_processor_duty),
    dif(no_second_subparagraph_transfer, duty_met),
    dif(no_second_subparagraph_transfer, duty_not_met),
    dif(not_a_processor_duty, duty_met),
    dif(not_a_processor_duty, duty_not_met),
    dif(duty_met, duty_not_met).
test(the_article_48_results_are_distinct) :-
    dif(article_48_not_engaged, not_barred_by_article_48),
    dif(article_48_not_engaged, not_recognisable_or_enforceable),
    dif(not_barred_by_article_48, not_recognisable_or_enforceable).
test(the_onward_transfer_results_are_distinct) :-
    dif(not_an_onward_transfer, onward_transfer_may_take_place),
    dif(not_an_onward_transfer, onward_transfer_may_not_take_place),
    dif(onward_transfer_may_take_place, onward_transfer_may_not_take_place).
test(the_load_bearing_citations_are_recorded) :-
    citation(eu_reg_2016_679_art_44, _),
    citation(eu_reg_2016_679_art_48, _),
    citation(eu_reg_2016_679_art_49_1_second_subpara, _),
    citation(eu_reg_2016_679_art_49_6, _).
test(every_referral_target_is_recorded) :-
    findall(Target, outside_fact_reference(_, _, cite(Target)), Targets),
    maplist(implements, Targets).

test(a_well_formed_profile_has_no_problem_listed, fail) :-
    Attested = attested(true, attestation(by, at, reason, none)),
    gdpr_chapter_v_extras_input_problems([attribute(transfer_relies_on_article_49_1_second_subparagraph, Attested)], [_|_]).
test(an_unknown_duty_has_no_empty_problem_list, fail) :-
    duty_argument_problems(inform_everyone, []).
test(a_crisp_key_has_no_referral, fail) :-
    absent_referral(supervisory_authority_informed_of_transfer, _).
test(a_shortened_citation_is_not_recorded, fail) :-
    citation(eu_reg_2016_679_art_49_1, _).

cp_test_names([an_empty_profile_has_no_problem, a_well_formed_profile_has_no_problem, a_non_list_profile_is_wrong_type, an_unbound_profile_is_wrong_type, a_duplicate_and_an_unknown_key_are_named_in_order, a_crisp_key_given_an_attested_term_is_wrong_type, each_duty_atom_has_no_problem, an_unknown_duty_is_wrong_type, the_absent_referral_builds_and_destructures, every_outside_fact_has_one_reference, the_basis_item_carries_the_attested_term_as_supplied, the_status_compounds_build_and_destructure, the_duty_results_are_distinct, the_article_48_results_are_distinct, the_onward_transfer_results_are_distinct, the_load_bearing_citations_are_recorded, every_referral_target_is_recorded]).
cp_test_fail_names([a_well_formed_profile_has_no_problem_listed, an_unknown_duty_has_no_empty_problem_list, a_crisp_key_has_no_referral, a_shortened_citation_is_not_recorded]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
