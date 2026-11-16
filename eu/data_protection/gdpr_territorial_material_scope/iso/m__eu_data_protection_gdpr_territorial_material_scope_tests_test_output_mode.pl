% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_territorial_material_scope_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_territorial_material_scope_gdpr_applies, [decide_gdpr_applies/2, gdpr_applies/2, gdpr_applies_status/2, scope_outside_facts/2]).
:- use_module(m__eu_data_protection_gdpr_territorial_material_scope_gdpr_scope_ground, [gdpr_scope_ground/2]).
:- use_module(m__eu_data_protection_gdpr_territorial_material_scope_representative_requirement, [representative_requirement/2]).
:- use_module(m__eu_data_protection_gdpr_territorial_material_scope_fixtures, [gdpr_territorial_material_scope_profile_for/2, gdpr_territorial_material_scope_assess/2]).

test(applies_yields_exactly_one_status) :-
    gdpr_territorial_material_scope_profile_for(eu_controller_in_context, Profile),
    findall(Status, gdpr_applies_status(Profile, Status), Statuses),
    Statuses == [applies].
test(gdpr_applies_yields_exactly_one_answer) :-
    gdpr_territorial_material_scope_profile_for(non_eu_offering, Profile),
    findall(Applies, gdpr_applies(Profile, Applies), Answers),
    Answers == [applies].
test(ground_yields_exactly_one_answer) :-
    gdpr_territorial_material_scope_profile_for(non_eu_offering, Profile),
    findall(Ground, gdpr_scope_ground(Profile, Ground), Answers),
    Answers == [art3_2_a].
test(representative_yields_exactly_one_answer) :-
    gdpr_territorial_material_scope_profile_for(non_eu_offering, Profile),
    findall(Representative, representative_requirement(Profile, Representative), Answers),
    Answers == [required].
test(outside_facts_yields_exactly_one_answer) :-
    gdpr_territorial_material_scope_profile_for(public_international_law_not_attested, Profile),
    findall(Facts, scope_outside_facts(Profile, Facts), Answers),
    Answers == [[outside_fact(member_state_law_applies_by_public_international_law, absent)]].
test(the_verdict_carries_a_citation) :-
    gdpr_territorial_material_scope_profile_for(eu_controller_in_context, Profile),
    decide_gdpr_applies(Profile, gdpr_applies_verdict(_Status, [_FirstCitation|_OtherCitations])).
test(art3_1_route) :-
    findall(V, gdpr_territorial_material_scope_assess(eu_controller_in_context, V), Vs),
    Vs == [gdpr_scope_verdict(applies, art3_1, not_applicable, [cite(eu_reg_2016_679_art_2_1), cite(eu_reg_2016_679_art_3_1)])].
test(art3_not_met_route) :-
    findall(V, gdpr_territorial_material_scope_assess(eu_controller_context_lacking, V), Vs),
    Vs == [gdpr_scope_verdict(does_not_apply, art3_not_met, not_applicable, [cite(eu_reg_2016_679_art_3_1), cite(eu_reg_2016_679_art_3_2_a), cite(eu_reg_2016_679_art_3_2_b), cite(eu_reg_2016_679_art_3_3)])].
test(art3_2_a_route_requires_a_representative) :-
    findall(V, gdpr_territorial_material_scope_assess(non_eu_offering, V), Vs),
    Vs == [gdpr_scope_verdict(applies, art3_2_a, required, [cite(eu_reg_2016_679_art_2_1), cite(eu_reg_2016_679_art_3_2_a), cite(eu_reg_2016_679_art_27_1)])].
test(art3_2_b_route_requires_a_representative) :-
    findall(V, gdpr_territorial_material_scope_assess(non_eu_monitoring, V), Vs),
    Vs == [gdpr_scope_verdict(applies, art3_2_b, required, [cite(eu_reg_2016_679_art_2_1), cite(eu_reg_2016_679_art_3_2_b), cite(eu_reg_2016_679_art_27_1)])].
test(art3_3_route_carries_no_representative_duty) :-
    findall(V, gdpr_territorial_material_scope_assess(public_international_law_place, V), Vs),
    Vs == [gdpr_scope_verdict(applies, art3_3, not_applicable, [cite(eu_reg_2016_679_art_2_1), cite(eu_reg_2016_679_art_3_3)])].
test(outside_fact_absent_refers) :-
    findall(V, gdpr_territorial_material_scope_assess(public_international_law_not_attested, V), Vs),
    Vs == [gdpr_scope_verdict(needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_3_3), cite(public_international_law_member_state_law_applies)), [resolution(cite(public_international_law_member_state_law_applies), not_attempted), inputs_relied_on([party_role - controller, established_in_union - false])]), none, not_reached, [cite(eu_reg_2016_679_art_3_3), cite(public_international_law_member_state_law_applies)])].
test(exemption_a_route) :-
    findall(V, gdpr_territorial_material_scope_assess(non_eu_offering_occasional_exempt, V), Vs),
    Vs == [gdpr_scope_verdict(applies, art3_2_a, exempt_art27_2_a, [cite(eu_reg_2016_679_art_2_1), cite(eu_reg_2016_679_art_3_2_a), cite(eu_reg_2016_679_art_27_1), cite(eu_reg_2016_679_art_27_2_a)])].
test(exemption_b_route) :-
    findall(V, gdpr_territorial_material_scope_assess(non_eu_offering_public_authority, V), Vs),
    Vs == [gdpr_scope_verdict(applies, art3_2_a, exempt_art27_2_b, [cite(eu_reg_2016_679_art_2_1), cite(eu_reg_2016_679_art_3_2_a), cite(eu_reg_2016_679_art_27_1), cite(eu_reg_2016_679_art_27_2_b)])].
test(open_exemption_judgement_refers_while_applies_stands) :-
    findall(V, gdpr_territorial_material_scope_assess(non_eu_offering_occasional_unsure, V), Vs),
    Vs == [gdpr_scope_verdict(applies, art3_2_a, needs_legal_review(open_textured(occasional_processing, cite(eu_reg_2016_679_art_27_2_a)), [inputs_relied_on([occasional_processing - unsure, special_or_criminal_data_on_large_scale - false, unlikely_to_result_in_risk - true])]), [cite(eu_reg_2016_679_art_2_1), cite(eu_reg_2016_679_art_3_2_a), cite(eu_reg_2016_679_art_27_2_a)])].
test(household_judgement_unsure_refers) :-
    findall(V, gdpr_territorial_material_scope_assess(household_processing_unsure, V), Vs),
    Vs == [gdpr_scope_verdict(needs_legal_review(open_textured(purely_personal_or_household_activity, cite(eu_reg_2016_679_art_2_2_c)), [inputs_relied_on([purely_personal_or_household_activity - unsure])]), none, not_reached, [cite(eu_reg_2016_679_art_2_2_c)])].
test(missing_exclusion_flag_is_indeterminate) :-
    findall(V, gdpr_territorial_material_scope_assess(exclusion_flag_missing, V), Vs),
    Vs == [gdpr_scope_verdict(indeterminate([activity_outside_union_law]), none, not_reached, [cite(eu_reg_2016_679_art_2_2_a), cite(eu_reg_2016_679_art_2_2_b), cite(eu_reg_2016_679_art_2_2_c), cite(eu_reg_2016_679_art_2_2_d), cite(eu_reg_2016_679_art_2_3)])].
test(stage_one_failure_names_art2_1) :-
    findall(V, gdpr_territorial_material_scope_assess(no_personal_data, V), Vs),
    Vs == [gdpr_scope_verdict(does_not_apply, art2_1_not_met, not_applicable, [cite(eu_reg_2016_679_art_2_1)])].
test(union_institution_names_art2_3) :-
    findall(V, gdpr_territorial_material_scope_assess(union_institution, V), Vs),
    Vs == [gdpr_scope_verdict(does_not_apply, art2_3, not_applicable, [cite(eu_reg_2016_679_art_2_3)])].

cp_test_names([applies_yields_exactly_one_status, gdpr_applies_yields_exactly_one_answer, ground_yields_exactly_one_answer, representative_yields_exactly_one_answer, outside_facts_yields_exactly_one_answer, the_verdict_carries_a_citation, art3_1_route, art3_not_met_route, art3_2_a_route_requires_a_representative, art3_2_b_route_requires_a_representative, art3_3_route_carries_no_representative_duty, outside_fact_absent_refers, exemption_a_route, exemption_b_route, open_exemption_judgement_refers_while_applies_stands, household_judgement_unsure_refers, missing_exclusion_flag_is_indeterminate, stage_one_failure_names_art2_1, union_institution_names_art2_3]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
