% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_records_and_officer_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_records_and_officer_kernel, [gdpr_records_and_officer_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_records_and_officer_citations, [citation/2, implements/1]).

test(the_verdict_term_carries_status_and_citations) :-
    Verdict = gdpr_records_and_officer_verdict(keep_controller_record, [cite(eu_reg_2016_679_art_30_1)]),
    Verdict = gdpr_records_and_officer_verdict(Status, Citations),
    Status == keep_controller_record,
    Citations == [cite(eu_reg_2016_679_art_30_1)].
test(the_record_obligation_term_destructures) :-
    Obligation = [keep_controller_record(cite(eu_reg_2016_679_art_30_1)), keep_processor_record(cite(eu_reg_2016_679_art_30_2))],
    Obligation = [keep_controller_record(cite(ControllerKey)), keep_processor_record(cite(ProcessorKey))],
    ControllerKey == eu_reg_2016_679_art_30_1,
    ProcessorKey == eu_reg_2016_679_art_30_2.
test(the_missing_record_item_term_destructures) :-
    Item = missing_record_item(controller, erasure_time_limits, cite(eu_reg_2016_679_art_30_1_f)),
    Item = missing_record_item(Role, ItemName, cite(Key)),
    Role == controller,
    ItemName == erasure_time_limits,
    Key == eu_reg_2016_679_art_30_1_f.
test(the_referral_term_destructures) :-
    Referral = needs_legal_review(open_textured(processing_is_occasional, cite(eu_reg_2016_679_art_30_5)), [inputs_relied_on([persons_employed - 10, processing_is_occasional - unsure])]),
    Referral = needs_legal_review(open_textured(JudgementKey, cite(Provision)), [inputs_relied_on(Pairs)]),
    JudgementKey == processing_is_occasional,
    Provision == eu_reg_2016_679_art_30_5,
    Pairs == [persons_employed - 10, processing_is_occasional - unsure].
test(the_cross_reference_referral_destructures) :-
    Referral = needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_37_4), cite(eu_reg_2016_679_art_37_4)), [resolution(cite(eu_reg_2016_679_art_37_4), not_attempted), inputs_relied_on([union_or_member_state_law_requires_data_protection_officer - absent])]),
    Referral = needs_legal_review(cross_reference_unresolved(cite(Citation), cite(Target)), [resolution(cite(Target), ResolutionStatus), inputs_relied_on(Pairs)]),
    Citation == eu_reg_2016_679_art_37_4,
    ResolutionStatus == not_attempted,
    Pairs == [union_or_member_state_law_requires_data_protection_officer - absent].
test(the_indeterminate_term_destructures) :-
    Status = indeterminate([acts_as_controller, acts_as_processor]),
    Status = indeterminate(MissingKeys),
    MissingKeys == [acts_as_controller, acts_as_processor].
test(the_record_duty_atoms_are_distinct) :-
    dif(keep_controller_record, keep_processor_record),
    dif(keep_controller_record, no_record_required),
    dif(keep_processor_record, no_record_required).
test(the_designation_atoms_are_distinct) :-
    dif(designate_data_protection_officer, no_designation_required).
test(the_position_result_atoms_are_distinct) :-
    dif(met, not_met).
test(the_status_compounds_are_distinct) :-
    dif(indeterminate, needs_legal_review),
    dif(indeterminate, input_problems),
    dif(needs_legal_review, input_problems).
test(the_roles_are_distinct) :-
    dif(controller, processor).
test(the_exemption_citation_is_recorded) :-
    citation(eu_reg_2016_679_art_30_5, _Record).
test(the_designation_citation_is_recorded) :-
    citation(eu_reg_2016_679_art_37_1_a, _Record).
test(the_position_citation_is_recorded) :-
    citation(eu_reg_2016_679_art_38_6, _Record).
test(the_provenance_marker_succeeds_for_a_recorded_key) :-
    implements(eu_reg_2016_679_art_39_1_a).
test(an_empty_profile_has_no_problem) :-
    gdpr_records_and_officer_input_problems([], []).
test(a_well_typed_profile_has_no_problem) :-
    gdpr_records_and_officer_input_problems([attribute(acts_as_controller, true), attribute(persons_employed, 249), attribute(processing_is_occasional, unsure)], []).
test(an_atom_is_not_a_profile) :-
    gdpr_records_and_officer_input_problems(profile_atom, [wrong_type(profile)]).
test(a_negative_headcount_is_a_wrong_type) :-
    gdpr_records_and_officer_input_problems([attribute(persons_employed, -1)], [wrong_type(persons_employed)]).
test(a_key_outside_the_contract_is_unknown) :-
    gdpr_records_and_officer_input_problems([attribute(colour, red)], [unknown_key(colour)]).

test(the_placeholder_citation_is_not_recorded, fail) :-
    citation(eu_todo_primary_source, _Record).
test(the_provenance_marker_fails_for_an_unrecorded_key, fail) :-
    implements(eu_todo_primary_source).
test(a_well_typed_profile_is_not_a_wrong_type, fail) :-
    gdpr_records_and_officer_input_problems([attribute(persons_employed, 249)], [wrong_type(persons_employed)]).

cp_test_names([the_verdict_term_carries_status_and_citations, the_record_obligation_term_destructures, the_missing_record_item_term_destructures, the_referral_term_destructures, the_cross_reference_referral_destructures, the_indeterminate_term_destructures, the_record_duty_atoms_are_distinct, the_designation_atoms_are_distinct, the_position_result_atoms_are_distinct, the_status_compounds_are_distinct, the_roles_are_distinct, the_exemption_citation_is_recorded, the_designation_citation_is_recorded, the_position_citation_is_recorded, the_provenance_marker_succeeds_for_a_recorded_key, an_empty_profile_has_no_problem, a_well_typed_profile_has_no_problem, an_atom_is_not_a_profile, a_negative_headcount_is_a_wrong_type, a_key_outside_the_contract_is_unknown]).
cp_test_fail_names([the_placeholder_citation_is_not_recorded, the_provenance_marker_fails_for_an_unrecorded_key, a_well_typed_profile_is_not_a_wrong_type]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
