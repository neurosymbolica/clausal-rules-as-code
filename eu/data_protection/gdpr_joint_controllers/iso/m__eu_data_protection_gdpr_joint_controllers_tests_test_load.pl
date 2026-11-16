% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_joint_controllers_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_joint_controllers_kernel, [gdpr_joint_controllers_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_joint_controllers_citations, [citation/2, implements/1]).

test(an_empty_profile_has_no_problem) :-
    findall(Problems, gdpr_joint_controllers_input_problems([], Problems), Answers),
    Answers == [[]].
test(a_well_formed_profile_has_no_problem) :-
    Profile = [attribute(controllers_jointly_determine_purposes_and_means, true), attribute(responsible_under_article_82_2_and_3, attested(true, attestation(by, at, reason, none))), attribute(other_responsible_parties, [processor_one, controller_two]), attribute(full_compensation_paid, unsure)],
    findall(Problems, gdpr_joint_controllers_input_problems(Profile, Problems), Answers),
    Answers == [[]].
test(an_empty_party_list_is_well_formed) :-
    gdpr_joint_controllers_input_problems([attribute(other_responsible_parties, [])], []).
test(a_bare_boolean_outside_fact_is_wrong_type) :-
    gdpr_joint_controllers_input_problems([attribute(responsible_under_article_82_2_and_3, true)], Problems),
    Problems == [wrong_type(responsible_under_article_82_2_and_3)].
test(a_number_in_the_party_list_is_wrong_type) :-
    gdpr_joint_controllers_input_problems([attribute(other_responsible_parties, [processor_one, 7])], Problems),
    Problems == [wrong_type(other_responsible_parties)].
test(an_unknown_key_is_named) :-
    gdpr_joint_controllers_input_problems([attribute(arrangement_names_contact_point, true)], Problems),
    Problems == [unknown_key(arrangement_names_contact_point)].
test(a_repeated_key_is_a_duplicate_only) :-
    gdpr_joint_controllers_input_problems([attribute(full_compensation_paid, true), attribute(full_compensation_paid, maybe)], Problems),
    Problems == [duplicate_key(full_compensation_paid)].
test(a_term_that_is_not_an_attribute_list_is_wrong_type) :-
    gdpr_joint_controllers_input_problems(not_a_profile, Problems),
    Problems == [wrong_type(profile)].
test(an_unbound_profile_is_wrong_type) :-
    findall(Problems, gdpr_joint_controllers_input_problems(_, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(the_claim_back_result_carries_the_parties) :-
    Result = entitled_to_claim_back([processor_one, controller_two]),
    Result = entitled_to_claim_back(Parties),
    Parties == [processor_one, controller_two].
test(the_basis_item_carries_the_attested_term) :-
    Attested = attested(true, attestation(by, at, reason, url(url, retrieved_at))),
    Basis = [outside_fact(responsible_under_article_82_2_and_3, Attested)],
    Basis = [outside_fact(Key, attested(Value, attestation(_, _, _, Evidence)))],
    Key == responsible_under_article_82_2_and_3,
    Value == true,
    Evidence == url(url, retrieved_at).
test(the_absent_referral_builds_and_destructures) :-
    Result = needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_82_4), cite(responsibility_under_article_82_statement)), [resolution(cite(responsibility_under_article_82_statement), not_attempted), inputs_relied_on([responsible_under_article_82_2_and_3 - absent])]),
    Result = needs_legal_review(cross_reference_unresolved(cite(Citation), cite(Target)), [resolution(cite(Target), Status), inputs_relied_on(Pairs)]),
    Citation == eu_reg_2016_679_art_82_4,
    Target == responsibility_under_article_82_statement,
    Status == not_attempted,
    Pairs == [responsible_under_article_82_2_and_3 - absent].
test(the_open_textured_referral_builds_and_destructures) :-
    Result = needs_legal_review(open_textured(full_compensation_paid, cite(eu_reg_2016_679_art_82_5)), [inputs_relied_on([full_compensation_paid - unsure])]),
    Result = needs_legal_review(open_textured(Input, cite(Citation)), [inputs_relied_on(Pairs)]),
    Input == full_compensation_paid,
    Citation == eu_reg_2016_679_art_82_5,
    Pairs == [full_compensation_paid - unsure].
test(the_missing_key_status_names_one_key) :-
    Result = indeterminate([other_responsible_parties]),
    Result = indeterminate([Key]),
    Key == other_responsible_parties.
test(the_input_problems_status_carries_its_list) :-
    Result = input_problems([unknown_key(foo), wrong_type(full_compensation_paid), duplicate_key(other_responsible_parties)]),
    Result = input_problems(Problems),
    length(Problems, 3).
test(the_rights_atoms_are_distinct) :-
    dif(not_joint_controllers, rights_exercisable_against_this_controller).
test(the_entire_damage_atoms_are_distinct) :-
    dif(not_responsible_for_the_damage, no_other_responsible_party),
    dif(not_responsible_for_the_damage, liable_for_the_entire_damage),
    dif(no_other_responsible_party, liable_for_the_entire_damage).
test(the_claim_back_answers_are_distinct) :-
    dif(not_entitled_to_claim_back, entitled_to_claim_back([processor_one])).
test(the_judgement_values_are_distinct) :-
    dif(true, unsure),
    dif(false, unsure),
    dif(absent, not_attempted).
test(the_rights_citation_is_recorded) :-
    citation(eu_reg_2016_679_art_26_3, Record),
    Record = [label - _, ref - _, verbatim - _].
test(every_result_citation_is_recorded) :-
    citation(eu_reg_2016_679_art_28_10, _),
    citation(eu_reg_2016_679_art_82_4, _),
    citation(eu_reg_2016_679_art_82_5, _).
test(the_referral_target_is_recorded) :-
    citation(responsibility_under_article_82_statement, _).
test(the_marker_credits_a_recorded_key) :-
    implements(eu_reg_2016_679_art_82_4).

test(a_bare_boolean_outside_fact_is_not_well_formed, fail) :-
    gdpr_joint_controllers_input_problems([attribute(responsible_under_article_82_2_and_3, true)], []).
test(the_atoms_do_not_unify, fail) :-
    liable_for_the_entire_damage = no_other_responsible_party.
test(the_placeholder_citation_is_gone, fail) :-
    citation(eu_todo_primary_source, _).
test(the_marker_refuses_a_shortened_key, fail) :-
    implements(art_82_4).

cp_test_names([an_empty_profile_has_no_problem, a_well_formed_profile_has_no_problem, an_empty_party_list_is_well_formed, a_bare_boolean_outside_fact_is_wrong_type, a_number_in_the_party_list_is_wrong_type, an_unknown_key_is_named, a_repeated_key_is_a_duplicate_only, a_term_that_is_not_an_attribute_list_is_wrong_type, an_unbound_profile_is_wrong_type, the_claim_back_result_carries_the_parties, the_basis_item_carries_the_attested_term, the_absent_referral_builds_and_destructures, the_open_textured_referral_builds_and_destructures, the_missing_key_status_names_one_key, the_input_problems_status_carries_its_list, the_rights_atoms_are_distinct, the_entire_damage_atoms_are_distinct, the_claim_back_answers_are_distinct, the_judgement_values_are_distinct, the_rights_citation_is_recorded, every_result_citation_is_recorded, the_referral_target_is_recorded, the_marker_credits_a_recorded_key]).
cp_test_fail_names([a_bare_boolean_outside_fact_is_not_well_formed, the_atoms_do_not_unify, the_placeholder_citation_is_gone, the_marker_refuses_a_shortened_key]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
