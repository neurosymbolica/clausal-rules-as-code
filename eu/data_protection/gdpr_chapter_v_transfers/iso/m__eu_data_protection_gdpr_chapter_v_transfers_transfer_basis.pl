% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_chapter_v_transfers_transfer_basis, [transfer_basis/2, decide_transfer_basis/2, transfer_basis_status/2, transfer_basis_checklist/2, transfer_basis_decision_resolvable/1, transfer_basis_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_chapter_v_transfers_kernel, [gdpr_chapter_v_transfers_input_problems/2, gdpr_chapter_v_transfers_cascade/5]).
:- use_module(m__eu_data_protection_gdpr_chapter_v_transfers_citations, [implements/1]).

transfer_basis_status_values([art45_adequacy, art46_safeguards, art49_derogation, none]).

basis_row(art45_adequacy, cite(eu_reg_2016_679_art_45_1)).
basis_row(art46_safeguards, cite(eu_reg_2016_679_art_46_1)).
basis_row(art49_derogation, cite(eu_reg_2016_679_art_49_1)).

decide_transfer_basis(Profile, transfer_basis_verdict(none, [])) :-
    gdpr_chapter_v_transfers_input_problems(Profile, [_|_]).
decide_transfer_basis(Profile, Verdict) :-
    implements(eu_reg_2016_679_art_44),
    gdpr_chapter_v_transfers_input_problems(Profile, []),
    gdpr_chapter_v_transfers_cascade(Profile, RequirementId, Outcome, _JudgementPairs, Citation),
    basis_verdict(Outcome, RequirementId, Citation, Verdict).

basis_verdict(met, RequirementId, Citation, transfer_basis_verdict(RequirementId, [Citation])) :-
    implements(eu_reg_2016_679_art_44),
    basis_row(RequirementId, _).
basis_verdict(unmet, _, Citation, transfer_basis_verdict(none, [Citation])) :-
    implements(eu_reg_2016_679_art_44).
basis_verdict(open_by_absence(_), _, Citation, transfer_basis_verdict(none, [Citation])) :-
    implements(eu_reg_2016_679_art_44).
basis_verdict(open_by_judgement(_), _, Citation, transfer_basis_verdict(none, [Citation])) :-
    implements(eu_reg_2016_679_art_44).
basis_verdict(open_by_outside_fact(_), _, Citation, transfer_basis_verdict(none, [Citation])) :-
    implements(eu_reg_2016_679_art_45_3).

transfer_basis(Profile, Basis) :-
    decide_transfer_basis(Profile, transfer_basis_verdict(Basis, _Citations)).

transfer_basis_status(Profile, Status) :-
    decide_transfer_basis(Profile, transfer_basis_verdict(Status, _Citations)).

transfer_basis_decision_resolvable(Profile) :-
    decide_transfer_basis(Profile, _Verdict).

transfer_basis_checklist(Profile, []) :-
    gdpr_chapter_v_transfers_input_problems(Profile, [_|_]).
transfer_basis_checklist(Profile, [item(RequirementId, ItemStatus, Citation)]) :-
    implements(eu_reg_2016_679_art_44),
    gdpr_chapter_v_transfers_input_problems(Profile, []),
    gdpr_chapter_v_transfers_cascade(Profile, RequirementId, Outcome, _JudgementPairs, Citation),
    item_status(Outcome, ItemStatus).

item_status(met, met).
item_status(unmet, unmet(stage_not_met)).
item_status(open_by_absence(MissingKeys), unknown(MissingKeys)).
item_status(open_by_judgement(InputKey), referred(open_textured(InputKey))).
item_status(open_by_outside_fact(Key), referred(cross_reference_unresolved(Key))).

test(an_empty_profile_has_no_basis) :-
    findall(Basis, transfer_basis([], Basis), Bases),
    Bases == [none].
test(an_attested_adequacy_decision_is_the_art45_basis) :-
    findall(Basis, transfer_basis([attribute(adequacy_decision_in_force, attested(true, attestation(test_host, test_time, test_reason, none)))], Basis), Bases),
    Bases == [art45_adequacy].
test(a_safeguard_in_place_is_the_art46_basis_whatever_the_adequacy_fact) :-
    findall(Basis, transfer_basis([attribute(safeguard_in_place, true)], Basis), Bases),
    Bases == [art46_safeguards].
test(approved_binding_corporate_rules_are_the_art46_basis) :-
    findall(Basis, transfer_basis([attribute(safeguard_in_place, false), attribute(binding_corporate_rules_approved, attested(true, attestation(test_host, test_time, test_reason, none)))], Basis), Bases),
    Bases == [art46_safeguards].
test(a_met_derogation_is_the_art49_basis) :-
    findall(Basis, transfer_basis([attribute(adequacy_decision_in_force, attested(false, attestation(test_host, test_time, test_reason, none))), attribute(safeguard_in_place, false), attribute(derogation_claimed, art49_1_a), attribute(explicit_consent_obtained, true)], Basis), Bases),
    Bases == [art49_derogation].
test(public_powers_leave_explicit_consent_without_basis) :-
    findall(Basis, transfer_basis([attribute(adequacy_decision_in_force, attested(false, attestation(test_host, test_time, test_reason, none))), attribute(safeguard_in_place, false), attribute(derogation_claimed, art49_1_a), attribute(explicit_consent_obtained, true), attribute(public_authority_public_powers, true)], Basis), Bases),
    Bases == [none].
test(a_referral_has_no_basis) :-
    findall(Basis, transfer_basis([attribute(safeguard_in_place, false), attribute(derogation_claimed, art49_1_a)], Basis), Bases),
    Bases == [none].
test(input_problems_have_no_basis_and_an_empty_checklist) :-
    findall(Basis, transfer_basis([attribute(colour, blue)], Basis), Bases),
    Bases == [none],
    findall(Items, transfer_basis_checklist([attribute(colour, blue)], Items), Checklists),
    Checklists == [[]].
test(the_checklist_cites_the_deciding_stage) :-
    findall(Items, transfer_basis_checklist([attribute(adequacy_decision_in_force, attested(true, attestation(test_host, test_time, test_reason, none)))], Items), Checklists),
    Checklists == [[item(art45_adequacy, met, cite(eu_reg_2016_679_art_45_1))]].
test(the_checklist_names_the_missing_safeguard_judgement) :-
    findall(Items, transfer_basis_checklist([], Items), Checklists),
    Checklists == [[item(art46_safeguards, unknown([safeguard_in_place]), cite(eu_reg_2016_679_art_46_1))]].

test(an_attested_adequacy_decision_is_not_without_basis, fail) :-
    transfer_basis([attribute(adequacy_decision_in_force, attested(true, attestation(test_host, test_time, test_reason, none)))], none).
test(public_powers_do_not_give_the_art49_basis, fail) :-
    transfer_basis([attribute(adequacy_decision_in_force, attested(false, attestation(test_host, test_time, test_reason, none))), attribute(safeguard_in_place, false), attribute(derogation_claimed, art49_1_a), attribute(explicit_consent_obtained, true), attribute(public_authority_public_powers, true)], art49_derogation).
