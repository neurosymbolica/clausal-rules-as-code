% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_chapter_v_transfers_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_chapter_v_transfers_transfer, [decide_transfer/2, transfer_status/2, transfer_permitted/2, transfer_verdict/3, transfer_checklist/2, transfer_requirement/4, transfer_requirement_ids/1, transfer_outside_facts/2]).
:- use_module(m__eu_data_protection_gdpr_chapter_v_transfers_transfer_basis, [transfer_basis/2, transfer_basis_checklist/2]).
:- use_module(m__eu_data_protection_gdpr_chapter_v_transfers_fixtures, [gdpr_chapter_v_transfers_profile_for/2]).

test(stage_one_yields_exactly_one_status) :-
    gdpr_chapter_v_transfers_profile_for(adequacy_attested_true, Profile),
    findall(Status, transfer_status(Profile, Status), Statuses),
    Statuses == [eligible].
test(stage_one_requirement_and_basis) :-
    gdpr_chapter_v_transfers_profile_for(adequacy_attested_true_with_unsure_safeguard, Profile),
    findall(RequirementId - Verdict - Basis, transfer_requirement(Profile, RequirementId, Verdict, Basis), Answers),
    Answers == [art45_adequacy - eligible - art45_adequacy].
test(stage_two_safeguard_basis) :-
    gdpr_chapter_v_transfers_profile_for(safeguard_after_adequacy_refused, Profile),
    findall(Basis, transfer_basis(Profile, Basis), Bases),
    Bases == [art46_safeguards].
test(binding_corporate_rules_alone_are_the_art46_basis) :-
    gdpr_chapter_v_transfers_profile_for(binding_corporate_rules_alone, Profile),
    findall(Verdict - Basis, transfer_verdict(Profile, Verdict, Basis), Answers),
    Answers == [eligible - art46_safeguards].
test(refused_binding_corporate_rules_change_nothing) :-
    gdpr_chapter_v_transfers_profile_for(binding_corporate_rules_refused, Profile),
    findall(RequirementId - Verdict - Basis, transfer_requirement(Profile, RequirementId, Verdict, Basis), Answers),
    Answers == [art49_derogation - ineligible - none].
test(stage_three_verdict_and_checklist) :-
    gdpr_chapter_v_transfers_profile_for(explicit_consent_derogation, Profile),
    findall(Verdict - Basis, transfer_verdict(Profile, Verdict, Basis), Answers),
    Answers == [eligible - art49_derogation],
    findall(Items, transfer_checklist(Profile, Items), Checklists),
    Checklists == [[art49_derogation]].
test(an_empty_profile_ends_at_stage_two) :-
    findall(Verdict, decide_transfer([], Verdict), Verdicts),
    Verdicts == [indeterminate([safeguard_in_place])],
    findall(RequirementId, transfer_requirement([], RequirementId, _, _), RequirementIds),
    RequirementIds == [art46_safeguards].
test(the_cross_reference_referral_and_its_pairs) :-
    gdpr_chapter_v_transfers_profile_for(refused_safeguard_without_adequacy_fact, Profile),
    findall(Verdict, decide_transfer(Profile, Verdict), Verdicts),
    Verdicts == [needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_45), cite(eu_reg_2016_679_art_45_3)), [resolution(cite(eu_reg_2016_679_art_45_3), not_attempted), inputs_relied_on([derogation_claimed - art49_1_b, adequacy_decision_in_force - absent, safeguard_in_place - false])])].
test(permitted_carries_the_referral_compound) :-
    gdpr_chapter_v_transfers_profile_for(refused_safeguard_without_adequacy_fact, Profile),
    findall(Permitted, transfer_permitted(Profile, Permitted), Answers),
    Answers == [needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_45), cite(eu_reg_2016_679_art_45_3)), [resolution(cite(eu_reg_2016_679_art_45_3), not_attempted), inputs_relied_on([derogation_claimed - art49_1_b, adequacy_decision_in_force - absent, safeguard_in_place - false])])].
test(an_unsure_public_interest_refers_on_point_d) :-
    gdpr_chapter_v_transfers_profile_for(public_interest_unsure, Profile),
    findall(Verdict, decide_transfer(Profile, Verdict), Verdicts),
    Verdicts == [needs_legal_review(open_textured(important_public_interest, cite(eu_reg_2016_679_art_49_1_d)), [inputs_relied_on([derogation_claimed - art49_1_d, important_public_interest - unsure])])].
test(the_second_subparagraph_refers_on_the_first_unsure_point) :-
    gdpr_chapter_v_transfers_profile_for(second_subparagraph_with_unsure_contract, Profile),
    findall(Verdict, decide_transfer(Profile, Verdict), Verdicts),
    Verdicts == [needs_legal_review(open_textured(contract_necessity, cite(eu_reg_2016_679_art_49_1_b)), [inputs_relied_on([derogation_claimed - art49_1_second_subpara, contract_necessity - unsure, data_subject_interest_contract_necessity - false, important_public_interest - false, legal_claims_necessity - false, vital_interests_necessity - false, legitimate_interests_derogation - true])])].
test(the_second_subparagraph_names_an_absent_point_key) :-
    gdpr_chapter_v_transfers_profile_for(second_subparagraph_consent_not_stated, Profile),
    findall(Verdict, decide_transfer(Profile, Verdict), Verdicts),
    Verdicts == [indeterminate([explicit_consent_obtained])].
test(d180_names_the_missing_key_of_the_claim) :-
    gdpr_chapter_v_transfers_profile_for(unsure_safeguard_contract_not_stated, Profile),
    findall(RequirementId - Verdict - Basis, transfer_requirement(Profile, RequirementId, Verdict, Basis), Answers),
    Answers == [art46_safeguards - indeterminate([contract_necessity]) - none].
test(d180_refers_on_the_safeguard_when_the_claim_is_complete) :-
    gdpr_chapter_v_transfers_profile_for(unsure_safeguard_contract_stated, Profile),
    findall(Verdict, decide_transfer(Profile, Verdict), Verdicts),
    Verdicts == [needs_legal_review(open_textured(safeguard_in_place, cite(eu_reg_2016_679_art_46)), [inputs_relied_on([derogation_claimed - art49_1_b, safeguard_in_place - unsure])])].
test(a_register_not_public_by_law_is_ineligible) :-
    gdpr_chapter_v_transfers_profile_for(public_register_not_public, Profile),
    findall(Verdict, decide_transfer(Profile, Verdict), Verdicts),
    Verdicts == [ineligible].
test(the_recorded_outside_facts_are_listed_in_order) :-
    gdpr_chapter_v_transfers_profile_for(recorded_facts_with_safeguard, Profile),
    findall(Facts, transfer_outside_facts(Profile, Facts), Answers),
    Answers == [[outside_fact(adequacy_decision_in_force, attested(false, attestation(fixture_host, fixture_time, fixture_reason, none))), outside_fact(transfer_is_onward_transfer, attested(true, attestation(fixture_host, fixture_time, fixture_reason, none))), outside_fact(third_country_judgment_or_decision_requires_transfer, attested(true, attestation(fixture_host, fixture_time, fixture_reason, none))), outside_fact(international_agreement_basis_for_judgment_or_decision, attested(true, attestation(fixture_host, fixture_time, fixture_reason, none)))]].
test(an_absent_adequacy_fact_is_recorded_on_an_eligible_answer) :-
    gdpr_chapter_v_transfers_profile_for(safeguard_without_adequacy_fact, Profile),
    findall(Facts, transfer_outside_facts(Profile, Facts), Answers),
    Answers == [[outside_fact(adequacy_decision_in_force, absent)]].
test(duplicate_and_unknown_keys_come_first_everywhere) :-
    gdpr_chapter_v_transfers_profile_for(duplicate_safeguard_and_unknown_key, Profile),
    findall(Verdict, decide_transfer(Profile, Verdict), Verdicts),
    Verdicts == [input_problems([duplicate_key(safeguard_in_place), unknown_key(foo)])],
    findall(Basis, transfer_basis(Profile, Basis), Bases),
    Bases == [none],
    findall(Items, transfer_checklist(Profile, Items), Checklists),
    Checklists == [[]],
    findall(Facts, transfer_outside_facts(Profile, Facts), OutsideFacts),
    OutsideFacts == [input_problems([duplicate_key(safeguard_in_place), unknown_key(foo)])].
test(the_requirement_ids_enumerate_once_in_cascade_order) :-
    findall(RequirementIds, transfer_requirement_ids(RequirementIds), Answers),
    Answers == [[art45_adequacy, art46_safeguards, art49_derogation]].
test(the_justification_checklist_cites_the_met_point) :-
    gdpr_chapter_v_transfers_profile_for(explicit_consent_derogation, Profile),
    findall(Items, transfer_basis_checklist(Profile, Items), Checklists),
    Checklists == [[item(art49_derogation, met, cite(eu_reg_2016_679_art_49_1_a))]].
test(the_justification_checklist_cites_the_cross_reference) :-
    gdpr_chapter_v_transfers_profile_for(refused_safeguard_without_adequacy_fact, Profile),
    findall(Items, transfer_basis_checklist(Profile, Items), Checklists),
    Checklists == [[item(art46_safeguards, referred(cross_reference_unresolved(adequacy_decision_in_force)), cite(eu_reg_2016_679_art_45))]].

cp_test_names([stage_one_yields_exactly_one_status, stage_one_requirement_and_basis, stage_two_safeguard_basis, binding_corporate_rules_alone_are_the_art46_basis, refused_binding_corporate_rules_change_nothing, stage_three_verdict_and_checklist, an_empty_profile_ends_at_stage_two, the_cross_reference_referral_and_its_pairs, permitted_carries_the_referral_compound, an_unsure_public_interest_refers_on_point_d, the_second_subparagraph_refers_on_the_first_unsure_point, the_second_subparagraph_names_an_absent_point_key, d180_names_the_missing_key_of_the_claim, d180_refers_on_the_safeguard_when_the_claim_is_complete, a_register_not_public_by_law_is_ineligible, the_recorded_outside_facts_are_listed_in_order, an_absent_adequacy_fact_is_recorded_on_an_eligible_answer, duplicate_and_unknown_keys_come_first_everywhere, the_requirement_ids_enumerate_once_in_cascade_order, the_justification_checklist_cites_the_met_point, the_justification_checklist_cites_the_cross_reference]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
