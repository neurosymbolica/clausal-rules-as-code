% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_churches_and_religious_associations_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_churches_and_religious_associations_queries, [gdpr_churches_and_religious_associations_profile_keys/1, gdpr_churches_and_religious_associations_what_if/4, gdpr_churches_and_religious_associations_eligibility/2, unsure/0, body_is_church_or_religious_association_or_community/0]).
:- use_module(m__eu_data_protection_gdpr_churches_and_religious_associations_kernel, [gdpr_churches_and_religious_associations_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_churches_and_religious_associations_fixtures, [gdpr_churches_and_religious_associations_profile_for/2]).

cited_item(item(_Key, _Status, cite(_Citation))).

test(profile_keys_are_the_contract_keys) :-
    gdpr_churches_and_religious_associations_profile_keys(ProfileKeys),
    ProfileKeys == [body_is_church_or_religious_association_or_community, rules_applied_in_a_member_state, comprehensive_rules_relating_to_protection_with_regard_to_processing, rules_applied_at_entry_into_force_of_the_regulation, rules_brought_into_line_with_the_regulation, supervisory_authority_is_specific, specific_authority_fulfils_chapter_vi_conditions].
test(the_root_atoms_are_served) :-
    unsure,
    body_is_church_or_religious_association_or_community.
test(the_input_check_accepts_a_fixture_profile) :-
    gdpr_churches_and_religious_associations_profile_for(rules_continue_authority_not_specific, Profile),
    gdpr_churches_and_religious_associations_input_problems(Profile, Problems),
    Problems == [].
test(the_input_check_names_a_crisp_key_given_unsure) :-
    gdpr_churches_and_religious_associations_profile_for(crisp_key_given_unsure, Profile),
    gdpr_churches_and_religious_associations_input_problems(Profile, Problems),
    Problems == [wrong_type(rules_applied_in_a_member_state)].
test(eligibility_holding_rules_are_eligible_with_five_met_items) :-
    gdpr_churches_and_religious_associations_profile_for(rules_continue_authority_not_specific, Profile),
    gdpr_churches_and_religious_associations_eligibility(Profile, assessment(_, Label, Items)),
    Label == eligible,
    Items == [item(body_is_church_or_religious_association_or_community, met, cite(eu_reg_2016_679_art_91_1)), item(rules_applied_in_a_member_state, met, cite(eu_reg_2016_679_art_91_1)), item(comprehensive_rules_relating_to_protection_with_regard_to_processing, met, cite(eu_reg_2016_679_art_91_1)), item(rules_applied_at_entry_into_force_of_the_regulation, met, cite(eu_reg_2016_679_art_91_1)), item(rules_brought_into_line_with_the_regulation, met, cite(eu_reg_2016_679_art_91_1))].
test(eligibility_yields_one_assessment) :-
    gdpr_churches_and_religious_associations_profile_for(specific_authority_fulfils_chapter_vi, Profile),
    findall(Assessment, gdpr_churches_and_religious_associations_eligibility(Profile, Assessment), Assessments),
    length(Assessments, 1).
test(eligibility_a_body_not_a_church_is_ineligible_with_its_unmet_item) :-
    gdpr_churches_and_religious_associations_profile_for(body_not_a_church, Profile),
    gdpr_churches_and_religious_associations_eligibility(Profile, assessment(_, Label, Items)),
    Label == ineligible,
    member(item(body_is_church_or_religious_association_or_community, unmet(body_is_church_or_religious_association_or_community), cite(eu_reg_2016_679_art_91_1)), Items).
test(eligibility_an_unsure_judgement_stays_unknown) :-
    gdpr_churches_and_religious_associations_profile_for(comprehensive_rules_unsure, Profile),
    gdpr_churches_and_religious_associations_eligibility(Profile, assessment(_, Label, Items)),
    Label == indeterminate,
    member(item(comprehensive_rules_relating_to_protection_with_regard_to_processing, unknown([comprehensive_rules_relating_to_protection_with_regard_to_processing]), cite(eu_reg_2016_679_art_91_1)), Items).
test(justification_every_checklist_item_is_cited) :-
    gdpr_churches_and_religious_associations_profile_for(rules_not_applied_at_entry_into_force, Profile),
    gdpr_churches_and_religious_associations_eligibility(Profile, assessment(_, _, Items)),
    length(Items, 5),
    maplist(cited_item, Items).
test(eligibility_a_malformed_profile_has_no_checklist) :-
    gdpr_churches_and_religious_associations_profile_for(crisp_key_given_unsure, Profile),
    gdpr_churches_and_religious_associations_eligibility(Profile, assessment(_, Label, Items)),
    Label == indeterminate,
    Items == [].
test(what_if_a_body_not_a_church_is_not_covered) :-
    gdpr_churches_and_religious_associations_profile_for(rules_continue_authority_not_specific, Profile),
    gdpr_churches_and_religious_associations_what_if(Profile, body_is_church_or_religious_association_or_community, false, Status),
    Status == church_rules_not_covered_by_article_91_1.
test(what_if_restoring_the_body_lets_the_rules_continue) :-
    gdpr_churches_and_religious_associations_profile_for(body_not_a_church, Profile),
    gdpr_churches_and_religious_associations_what_if(Profile, body_is_church_or_religious_association_or_community, true, Status),
    Status == church_rules_may_continue_to_apply.
test(what_if_an_attested_false_entry_is_not_covered) :-
    gdpr_churches_and_religious_associations_profile_for(rules_continue_authority_not_specific, Profile),
    gdpr_churches_and_religious_associations_what_if(Profile, rules_applied_at_entry_into_force_of_the_regulation, attested(false, attestation(host, moment, reason, none)), Status),
    Status == church_rules_not_covered_by_article_91_1.
test(what_if_an_unsure_bringing_into_line_is_referred) :-
    gdpr_churches_and_religious_associations_profile_for(rules_continue_authority_not_specific, Profile),
    gdpr_churches_and_religious_associations_what_if(Profile, rules_brought_into_line_with_the_regulation, unsure, Status),
    Status == needs_legal_review(open_textured(rules_brought_into_line_with_the_regulation, cite(eu_reg_2016_679_art_91_1)), [inputs_relied_on([comprehensive_rules_relating_to_protection_with_regard_to_processing - true, rules_brought_into_line_with_the_regulation - unsure])]).
test(what_if_yields_one_status) :-
    gdpr_churches_and_religious_associations_profile_for(rules_continue_authority_not_specific, Profile),
    findall(Status, gdpr_churches_and_religious_associations_what_if(Profile, rules_applied_in_a_member_state, false, Status), Statuses),
    Statuses == [church_rules_not_covered_by_article_91_1].

test(eligibility_an_unsure_judgement_is_not_eligible, fail) :-
    gdpr_churches_and_religious_associations_profile_for(comprehensive_rules_unsure, Profile),
    gdpr_churches_and_religious_associations_eligibility(Profile, assessment(_, eligible, _)).

cp_test_names([profile_keys_are_the_contract_keys, the_root_atoms_are_served, the_input_check_accepts_a_fixture_profile, the_input_check_names_a_crisp_key_given_unsure, eligibility_holding_rules_are_eligible_with_five_met_items, eligibility_yields_one_assessment, eligibility_a_body_not_a_church_is_ineligible_with_its_unmet_item, eligibility_an_unsure_judgement_stays_unknown, justification_every_checklist_item_is_cited, eligibility_a_malformed_profile_has_no_checklist, what_if_a_body_not_a_church_is_not_covered, what_if_restoring_the_body_lets_the_rules_continue, what_if_an_attested_false_entry_is_not_covered, what_if_an_unsure_bringing_into_line_is_referred, what_if_yields_one_status]).
cp_test_fail_names([eligibility_an_unsure_judgement_is_not_eligible]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
