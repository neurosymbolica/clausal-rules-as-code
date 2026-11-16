% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_chapter_v_transfers_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(formalize_lib, [profile_lacks/2]).
:- use_module(m__eu_data_protection_gdpr_chapter_v_transfers_transfer, [decide_transfer/2, transfer_permitted/2, transfer_verdict/3, transfer_checklist/2, transfer_requirement/4, transfer_outside_facts/2]).
:- use_module(m__eu_data_protection_gdpr_chapter_v_transfers_transfer_basis, [transfer_basis/2]).
:- use_module(m__eu_data_protection_gdpr_chapter_v_transfers_kernel, [gdpr_chapter_v_transfers_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_chapter_v_transfers_fixtures, [gdpr_chapter_v_transfers_subject/1, gdpr_chapter_v_transfers_profile_for/2]).

all_subjects(SubjectSet) :-
    findall(Subject, gdpr_chapter_v_transfers_subject(Subject), Subjects),
    sort(Subjects, SubjectSet).

subject_classifies(Subject) :-
    gdpr_chapter_v_transfers_subject(Subject),
    gdpr_chapter_v_transfers_profile_for(Subject, Profile),
    decide_transfer(Profile, _Verdict).

subject_answers_once(Subject) :-
    gdpr_chapter_v_transfers_subject(Subject),
    gdpr_chapter_v_transfers_profile_for(Subject, Profile),
    findall(Verdict, decide_transfer(Profile, Verdict), Verdicts),
    length(Verdicts, 1),
    findall(Basis, transfer_basis(Profile, Basis), Bases),
    length(Bases, 1),
    findall(Permitted, transfer_permitted(Profile, Permitted), PermittedAnswers),
    length(PermittedAnswers, 1),
    findall(VerdictAnswer - BasisAnswer, transfer_verdict(Profile, VerdictAnswer, BasisAnswer), VerdictPairs),
    length(VerdictPairs, 1),
    findall(Items, transfer_checklist(Profile, Items), Checklists),
    length(Checklists, 1),
    findall(RequirementId - RequirementVerdict - RequirementBasis, transfer_requirement(Profile, RequirementId, RequirementVerdict, RequirementBasis), Requirements),
    length(Requirements, 1),
    findall(Facts, transfer_outside_facts(Profile, Facts), OutsideFacts),
    length(OutsideFacts, 1).

basis_agrees(eligible, Basis) :-
    member(Basis, [art45_adequacy, art46_safeguards, art49_derogation]).
basis_agrees(ineligible, none).
basis_agrees(indeterminate(_), none).
basis_agrees(needs_legal_review(_, _), none).
basis_agrees(input_problems(_), none).

permitted_agrees(eligible, true).
permitted_agrees(ineligible, false).
permitted_agrees(indeterminate(MissingKeys), indeterminate(MissingKeys)).
permitted_agrees(needs_legal_review(Reason, Context), needs_legal_review(Reason, Context)).
permitted_agrees(input_problems(Problems), input_problems(Problems)).

checklist_agrees(eligible, Basis, [Basis]).
checklist_agrees(ineligible, _, []).
checklist_agrees(indeterminate(_), _, []).
checklist_agrees(needs_legal_review(_, _), _, []).
checklist_agrees(input_problems(_), _, []).

requirement_agrees(input_problems(_), none).
requirement_agrees(eligible, RequirementId) :-
    member(RequirementId, [art45_adequacy, art46_safeguards, art49_derogation]).
requirement_agrees(ineligible, RequirementId) :-
    member(RequirementId, [art45_adequacy, art46_safeguards, art49_derogation]).
requirement_agrees(indeterminate(_), RequirementId) :-
    member(RequirementId, [art45_adequacy, art46_safeguards, art49_derogation]).
requirement_agrees(needs_legal_review(_, _), RequirementId) :-
    member(RequirementId, [art45_adequacy, art46_safeguards, art49_derogation]).

outside_facts_agree(input_problems(Problems), input_problems(Problems)).
outside_facts_agree(eligible, [outside_fact(adequacy_decision_in_force, _)|_]).
outside_facts_agree(ineligible, [outside_fact(adequacy_decision_in_force, _)|_]).
outside_facts_agree(indeterminate(_), [outside_fact(adequacy_decision_in_force, _)|_]).
outside_facts_agree(needs_legal_review(_, _), [outside_fact(adequacy_decision_in_force, _)|_]).

subject_projections_agree(Subject) :-
    gdpr_chapter_v_transfers_subject(Subject),
    gdpr_chapter_v_transfers_profile_for(Subject, Profile),
    decide_transfer(Profile, Verdict),
    transfer_basis(Profile, Basis),
    basis_agrees(Verdict, Basis),
    transfer_verdict(Profile, Verdict, Basis),
    transfer_permitted(Profile, Permitted),
    permitted_agrees(Verdict, Permitted),
    transfer_checklist(Profile, Items),
    checklist_agrees(Verdict, Basis, Items),
    transfer_requirement(Profile, RequirementId, Verdict, Basis),
    requirement_agrees(Verdict, RequirementId),
    transfer_outside_facts(Profile, Facts),
    outside_facts_agree(Verdict, Facts).

property_attested(Value, attested(Value, attestation(property_host, property_time, property_reason, none))).

clean_subject_lacking(Key, Subject) :-
    gdpr_chapter_v_transfers_subject(Subject),
    gdpr_chapter_v_transfers_profile_for(Subject, Profile),
    gdpr_chapter_v_transfers_input_problems(Profile, []),
    profile_lacks(Profile, Key).

recording_changes_nothing(Key, Value, Subject) :-
    clean_subject_lacking(Key, Subject),
    gdpr_chapter_v_transfers_profile_for(Subject, Profile),
    decide_transfer(Profile, Verdict),
    property_attested(Value, Attested),
    append(Profile, [attribute(Key, Attested)], RecordedProfile),
    decide_transfer(RecordedProfile, Verdict).

recording_invariant_holds(Key, Value) :-
    findall(Subject, clean_subject_lacking(Key, Subject), LackingSubjects),
    LackingSubjects = [_|_],
    findall(Subject, recording_changes_nothing(Key, Value, Subject), UnchangedSubjects),
    LackingSubjects == UnchangedSubjects.

test(the_subject_registry_has_no_duplicates) :-
    findall(Subject, gdpr_chapter_v_transfers_subject(Subject), Subjects),
    all_subjects(SubjectSet),
    length(Subjects, Count),
    length(SubjectSet, Count).
test(totality_every_subject_classifies) :-
    all_subjects(SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_relation_answers_exactly_once) :-
    all_subjects(SubjectSet),
    findall(Subject, subject_answers_once(Subject), OnceSubjects),
    length(SubjectSet, Count),
    length(OnceSubjects, Count),
    sort(OnceSubjects, SubjectSet).
test(every_projection_agrees_with_the_main_verdict) :-
    all_subjects(SubjectSet),
    findall(Subject, subject_projections_agree(Subject), AgreeingSubjects),
    sort(AgreeingSubjects, SubjectSet).
test(the_compound_indeterminate_is_a_verdict) :-
    gdpr_chapter_v_transfers_profile_for(empty_profile, Profile),
    decide_transfer(Profile, indeterminate([_|_])).
test(a_recorded_onward_transfer_changes_no_verdict) :-
    recording_invariant_holds(transfer_is_onward_transfer, true).
test(a_recorded_foreign_judgment_changes_no_verdict) :-
    recording_invariant_holds(third_country_judgment_or_decision_requires_transfer, true).
test(a_recorded_international_agreement_changes_no_verdict) :-
    recording_invariant_holds(international_agreement_basis_for_judgment_or_decision, true).
test(refused_binding_corporate_rules_change_no_verdict) :-
    recording_invariant_holds(binding_corporate_rules_approved, false).

test(the_bare_atom_indeterminate_is_never_a_verdict, fail) :-
    gdpr_chapter_v_transfers_subject(Subject),
    gdpr_chapter_v_transfers_profile_for(Subject, Profile),
    decide_transfer(Profile, indeterminate).
test(the_atom_unknown_is_never_a_verdict, fail) :-
    gdpr_chapter_v_transfers_subject(Subject),
    gdpr_chapter_v_transfers_profile_for(Subject, Profile),
    decide_transfer(Profile, unknown).

cp_test_names([the_subject_registry_has_no_duplicates, totality_every_subject_classifies, determinism_every_relation_answers_exactly_once, every_projection_agrees_with_the_main_verdict, the_compound_indeterminate_is_a_verdict, a_recorded_onward_transfer_changes_no_verdict, a_recorded_foreign_judgment_changes_no_verdict, a_recorded_international_agreement_changes_no_verdict, refused_binding_corporate_rules_change_no_verdict]).
cp_test_fail_names([the_bare_atom_indeterminate_is_never_a_verdict, the_atom_unknown_is_never_a_verdict]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
