% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_accountability_security_gdpr_accountability_security, [duty_status/5, non_binding_items/3, joint_controller_arrangement/3, joint_controller_arrangement_content/4, decide_gdpr_accountability_security/2, gdpr_accountability_security_status/2, gdpr_accountability_security_checklist/2, gdpr_accountability_security_decision_resolvable/1, gdpr_accountability_security_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_accountability_security_kernel, [gdpr_accountability_security_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_accountability_security_citations, [implements/1]).
:- use_module(formalize_lib, [profile_get/3, profile_lacks/2, member_matching/2, not_member/2]).

gdpr_accountability_security_status_values([compliant, review_required, not_compliant]).

duty_row(accountability, accountability_demonstrated, [cite(eu_reg_2016_679_art_5_2)], cite(controller_compliance_demonstration)).
duty_row(controller_measures, controller_measures_implemented_and_reviewed, [cite(eu_reg_2016_679_art_24_1)], cite(controller_measures_statement)).
duty_row(data_protection_policies, data_protection_policies_implemented, [cite(eu_reg_2016_679_art_24_2)], cite(data_protection_policies_statement)).
duty_row(data_protection_by_design, by_design_measures_implemented, [cite(eu_reg_2016_679_art_25_1)], cite(by_design_measures_statement)).
duty_row(data_protection_by_default, by_default_only_necessary_data_processed, [cite(eu_reg_2016_679_art_25_2)], cite(by_default_necessity_statement)).
duty_row(security_of_processing, security_level_appropriate_to_risk, [cite(eu_reg_2016_679_art_32_1), cite(eu_reg_2016_679_art_32_2)], cite(security_level_statement)).
duty_row(processing_on_instructions, authorised_persons_process_only_on_instructions, [cite(eu_reg_2016_679_art_32_4)], cite(processing_instructions_statement)).

duty_order([accountability, controller_measures, data_protection_policies, data_protection_by_design, data_protection_by_default, security_of_processing, processing_on_instructions]).

by_default_depth_row(by_default_amount_collected_limited_to_necessary, cite(eu_reg_2016_679_art_25_2)).
by_default_depth_row(by_default_extent_of_processing_limited_to_necessary, cite(eu_reg_2016_679_art_25_2)).
by_default_depth_row(by_default_storage_period_limited_to_necessary, cite(eu_reg_2016_679_art_25_2)).
by_default_depth_row(by_default_accessibility_limited_to_necessary, cite(eu_reg_2016_679_art_25_2)).
by_default_depth_row(by_default_not_accessible_to_indefinite_number_without_intervention, cite(eu_reg_2016_679_art_25_2)).

non_binding_row(accountability_principles, lawfulness_fairness_transparency, cite(eu_reg_2016_679_art_5_1_a)).
non_binding_row(accountability_principles, purpose_limitation, cite(eu_reg_2016_679_art_5_1_b)).
non_binding_row(accountability_principles, data_minimisation, cite(eu_reg_2016_679_art_5_1_c)).
non_binding_row(accountability_principles, accuracy, cite(eu_reg_2016_679_art_5_1_d)).
non_binding_row(accountability_principles, storage_limitation, cite(eu_reg_2016_679_art_5_1_e)).
non_binding_row(accountability_principles, integrity_and_confidentiality, cite(eu_reg_2016_679_art_5_1_f)).
non_binding_row(security_measures, pseudonymisation_and_encryption, cite(eu_reg_2016_679_art_32_1_a)).
non_binding_row(security_measures, confidentiality_integrity_availability_resilience, cite(eu_reg_2016_679_art_32_1_b)).
non_binding_row(security_measures, restore_availability_and_access, cite(eu_reg_2016_679_art_32_1_c)).
non_binding_row(security_measures, regular_testing_assessing_evaluating, cite(eu_reg_2016_679_art_32_1_d)).

key_value(Profile, Key, absent) :-
    profile_lacks(Profile, Key).
key_value(Profile, Key, present(Value)) :-
    profile_get(Profile, Key, Value).

duty_status(Profile, _, input_problems([Problem|Problems]), [], []) :-
    gdpr_accountability_security_input_problems(Profile, [Problem|Problems]).
duty_status(Profile, Duty, Result, Basis, Citations) :-
    gdpr_accountability_security_input_problems(Profile, []),
    duty_answer(Profile, Duty, Result, Basis, Citations).

duty_answer(Profile, accountability, Result, Basis, Citations) :-
    implements(eu_reg_2016_679_art_5_2),
    statement_duty(Profile, accountability, Result, Basis, Citations).
duty_answer(Profile, controller_measures, Result, Basis, Citations) :-
    implements(eu_reg_2016_679_art_24_1),
    statement_duty(Profile, controller_measures, Result, Basis, Citations).
duty_answer(Profile, data_protection_policies, Result, Basis, Citations) :-
    implements(eu_reg_2016_679_art_24_2),
    statement_duty(Profile, data_protection_policies, Result, Basis, Citations).
duty_answer(Profile, data_protection_by_design, Result, Basis, Citations) :-
    implements(eu_reg_2016_679_art_25_1),
    statement_duty(Profile, data_protection_by_design, Result, Basis, Citations).
duty_answer(Profile, security_of_processing, Result, Basis, Citations) :-
    implements(eu_reg_2016_679_art_32_1),
    statement_duty(Profile, security_of_processing, Result, Basis, Citations).
duty_answer(Profile, processing_on_instructions, Result, Basis, Citations) :-
    implements(eu_reg_2016_679_art_32_4),
    statement_duty(Profile, processing_on_instructions, Result, Basis, Citations).
duty_answer(Profile, data_protection_by_default, not_met, Basis, [cite(eu_reg_2016_679_art_25_2)]) :-
    implements(eu_reg_2016_679_art_25_2),
    by_default_depth_keys(Keys),
    by_default_depth_check(Keys, Profile, decided(_, Basis)).
duty_answer(Profile, data_protection_by_default, Result, Basis, Citations) :-
    implements(eu_reg_2016_679_art_25_2),
    by_default_depth_keys(Keys),
    by_default_depth_check(Keys, Profile, none),
    statement_duty(Profile, data_protection_by_default, Result, Basis, Citations).

by_default_depth_keys(Keys) :-
    findall(Key, by_default_depth_row(Key, _), Keys).

by_default_depth_check([], _, none).
by_default_depth_check([Key|Keys], Profile, Outcome) :-
    key_value(Profile, Key, Presence),
    by_default_depth_value(Presence, Key, Keys, Profile, Outcome).

by_default_depth_value(absent, _, Keys, Profile, Outcome) :-
    by_default_depth_check(Keys, Profile, Outcome).
by_default_depth_value(present(true), _, Keys, Profile, Outcome) :-
    by_default_depth_check(Keys, Profile, Outcome).
by_default_depth_value(present(attested(true, _)), _, Keys, Profile, Outcome) :-
    by_default_depth_check(Keys, Profile, Outcome).
by_default_depth_value(present(false), Key, _, _, decided(Key, [])) :-
    implements(eu_reg_2016_679_art_25_2).
by_default_depth_value(present(attested(false, Attestation)), Key, _, _, decided(Key, [outside_fact(Key, attested(false, Attestation))])) :-
    implements(eu_reg_2016_679_art_25_2).

statement_duty(Profile, Duty, Result, Basis, Citations) :-
    duty_row(Duty, Key, DutyCitations, Target),
    key_value(Profile, Key, Presence),
    statement_answer(Presence, Key, DutyCitations, Target, Result, Basis, Citations).

statement_answer(absent, Key, [cite(Citation)|_], cite(Target), needs_legal_review(cross_reference_unresolved(cite(Citation), cite(Target)), [resolution(cite(Target), not_attempted), inputs_relied_on([Key - absent])]), [], []).
statement_answer(present(attested(true, Attestation)), Key, Citations, _, met, [outside_fact(Key, attested(true, Attestation))], Citations).
statement_answer(present(attested(false, Attestation)), Key, Citations, _, not_met, [outside_fact(Key, attested(false, Attestation))], Citations).

non_binding_items(Profile, _, input_problems([Problem|Problems])) :-
    gdpr_accountability_security_input_problems(Profile, [Problem|Problems]).
non_binding_items(Profile, Topic, Items) :-
    gdpr_accountability_security_input_problems(Profile, []),
    topic_items(Topic, Items).

topic_items(accountability_principles, Items) :-
    implements(eu_reg_2016_679_art_5_1_a),
    findall(non_binding_item(Name, Citation), non_binding_row(accountability_principles, Name, Citation), Items).
topic_items(security_measures, Items) :-
    implements(eu_reg_2016_679_art_32_1_a),
    findall(non_binding_item(Name, Citation), non_binding_row(security_measures, Name, Citation), Items).

joint_controller_arrangement(Profile, input_problems([Problem|Problems]), []) :-
    gdpr_accountability_security_input_problems(Profile, [Problem|Problems]).
joint_controller_arrangement(Profile, Result, Citations) :-
    gdpr_accountability_security_input_problems(Profile, []),
    key_value(Profile, controllers_jointly_determine_purposes_and_means, Jointly),
    arrangement_from_jointly(Jointly, Profile, Result, Citations).

arrangement_from_jointly(absent, _, indeterminate([controllers_jointly_determine_purposes_and_means]), []) :-
    implements(eu_reg_2016_679_art_26_1).
arrangement_from_jointly(present(false), _, not_joint_controllers, [cite(eu_reg_2016_679_art_26_1)]) :-
    implements(eu_reg_2016_679_art_26_1).
arrangement_from_jointly(present(true), Profile, Result, Citations) :-
    implements(eu_reg_2016_679_art_26_1),
    key_value(Profile, responsibilities_set_by_union_or_member_state_law, Law),
    arrangement_from_law(Law, true, Profile, Result, Citations).
arrangement_from_jointly(present(unsure), Profile, Result, Citations) :-
    implements(eu_reg_2016_679_art_26_1),
    key_value(Profile, responsibilities_set_by_union_or_member_state_law, Law),
    arrangement_from_law(Law, unsure, Profile, Result, Citations).

arrangement_from_law(absent, _, _, indeterminate([responsibilities_set_by_union_or_member_state_law]), []) :-
    implements(eu_reg_2016_679_art_26_1).
arrangement_from_law(present(true), unsure, _, Result, []) :-
    implements(eu_reg_2016_679_art_26_1),
    jointly_unsure_referral(Result).
arrangement_from_law(present(true), true, _, arrangement_not_required, [cite(eu_reg_2016_679_art_26_1)]) :-
    implements(eu_reg_2016_679_art_26_1).
arrangement_from_law(present(false), Jointly, Profile, Result, Citations) :-
    implements(eu_reg_2016_679_art_26_1),
    key_value(Profile, arrangement_between_controllers_exists, Arrangement),
    arrangement_from_existence(Arrangement, Jointly, Result, Citations).

arrangement_from_existence(absent, _, indeterminate([arrangement_between_controllers_exists]), []) :-
    implements(eu_reg_2016_679_art_26_1).
arrangement_from_existence(present(_), unsure, Result, []) :-
    implements(eu_reg_2016_679_art_26_1),
    jointly_unsure_referral(Result).
arrangement_from_existence(present(true), true, arrangement_in_place, [cite(eu_reg_2016_679_art_26_1)]) :-
    implements(eu_reg_2016_679_art_26_1).
arrangement_from_existence(present(false), true, arrangement_missing, [cite(eu_reg_2016_679_art_26_1)]) :-
    implements(eu_reg_2016_679_art_26_1).

jointly_unsure_referral(needs_legal_review(open_textured(controllers_jointly_determine_purposes_and_means, cite(eu_reg_2016_679_art_26_1)), [inputs_relied_on([controllers_jointly_determine_purposes_and_means - unsure])])).

joint_controller_arrangement_content(Profile, input_problems([Problem|Problems]), [], []) :-
    gdpr_accountability_security_input_problems(Profile, [Problem|Problems]).
joint_controller_arrangement_content(Profile, Result, Basis, Citations) :-
    gdpr_accountability_security_input_problems(Profile, []),
    key_value(Profile, essence_of_arrangement_made_available, Essence),
    key_value(Profile, arrangement_reflects_roles_and_relationships, Reflects),
    content_answer(Essence, Reflects, Result, Basis, Citations).

content_answer(present(false), _, content_requirements_not_met, [], [cite(eu_reg_2016_679_art_26_2)]) :-
    implements(eu_reg_2016_679_art_26_2).
content_answer(present(true), present(attested(false, Attestation)), content_requirements_not_met, [outside_fact(arrangement_reflects_roles_and_relationships, attested(false, Attestation))], [cite(eu_reg_2016_679_art_26_2)]) :-
    implements(eu_reg_2016_679_art_26_2).
content_answer(absent, present(attested(false, Attestation)), content_requirements_not_met, [outside_fact(arrangement_reflects_roles_and_relationships, attested(false, Attestation))], [cite(eu_reg_2016_679_art_26_2)]) :-
    implements(eu_reg_2016_679_art_26_2).
content_answer(absent, absent, indeterminate([essence_of_arrangement_made_available]), [], []) :-
    implements(eu_reg_2016_679_art_26_2).
content_answer(absent, present(attested(true, _)), indeterminate([essence_of_arrangement_made_available]), [], []) :-
    implements(eu_reg_2016_679_art_26_2).
content_answer(present(true), absent, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_26_2), cite(arrangement_roles_statement)), [resolution(cite(arrangement_roles_statement), not_attempted), inputs_relied_on([arrangement_reflects_roles_and_relationships - absent])]), [], []) :-
    implements(eu_reg_2016_679_art_26_2).
content_answer(present(true), present(attested(true, Attestation)), content_requirements_met, [outside_fact(arrangement_reflects_roles_and_relationships, attested(true, Attestation))], [cite(eu_reg_2016_679_art_26_2)]) :-
    implements(eu_reg_2016_679_art_26_2).

gdpr_accountability_security_checklist(Profile, []) :-
    gdpr_accountability_security_input_problems(Profile, [_|_]).
gdpr_accountability_security_checklist(Profile, Items) :-
    gdpr_accountability_security_input_problems(Profile, []),
    duty_order(Duties),
    duty_items(Duties, Profile, Items).

duty_items([], _, []).
duty_items([Duty|Duties], Profile, [item(Duty, Status, Citation)|Items]) :-
    duty_status(Profile, Duty, Result, _, _),
    duty_row(Duty, Key, [Citation|_], _),
    item_status(Result, Key, Status),
    duty_items(Duties, Profile, Items).

item_status(met, _, met).
item_status(not_met, _, unmet(not_met)).
item_status(needs_legal_review(_, _), Key, unknown([Key])).

checklist_citations(Items, Citations) :-
    findall(Citation, member(item(_, _, Citation), Items), Collected),
    sort(Collected, Citations).

decide_gdpr_accountability_security(Profile, gdpr_accountability_security_verdict(input_problems([Problem|Problems]), [])) :-
    gdpr_accountability_security_input_problems(Profile, [Problem|Problems]).
decide_gdpr_accountability_security(Profile, gdpr_accountability_security_verdict(not_compliant, Citations)) :-
    implements(eu_reg_2016_679_art_5_2),
    gdpr_accountability_security_input_problems(Profile, []),
    gdpr_accountability_security_checklist(Profile, Items),
    member_matching(item(_, unmet(_), _), Items),
    checklist_citations(Items, Citations).
decide_gdpr_accountability_security(Profile, gdpr_accountability_security_verdict(review_required, Citations)) :-
    implements(eu_reg_2016_679_art_5_2),
    gdpr_accountability_security_input_problems(Profile, []),
    gdpr_accountability_security_checklist(Profile, Items),
    not_member(item(_, unmet(_), _), Items),
    member_matching(item(_, unknown(_), _), Items),
    checklist_citations(Items, Citations).
decide_gdpr_accountability_security(Profile, gdpr_accountability_security_verdict(compliant, Citations)) :-
    implements(eu_reg_2016_679_art_5_2),
    gdpr_accountability_security_input_problems(Profile, []),
    gdpr_accountability_security_checklist(Profile, Items),
    not_member(item(_, unmet(_), _), Items),
    not_member(item(_, unknown(_), _), Items),
    checklist_citations(Items, Citations).

gdpr_accountability_security_status(Profile, Status) :-
    decide_gdpr_accountability_security(Profile, gdpr_accountability_security_verdict(Status, _Citations)).

gdpr_accountability_security_decision_resolvable(Profile) :-
    decide_gdpr_accountability_security(Profile, _Verdict).

attested_true(attested(true, attestation(host, moment, statement, none))).

attested_false(attested(false, attestation(host, moment, statement, none))).

full_true_profile(Profile) :-
    attested_true(True),
    Profile = [attribute(accountability_demonstrated, True), attribute(controller_measures_implemented_and_reviewed, True), attribute(data_protection_policies_implemented, True), attribute(by_design_measures_implemented, True), attribute(by_default_only_necessary_data_processed, True), attribute(security_level_appropriate_to_risk, True), attribute(authorised_persons_process_only_on_instructions, True)].

test(accountability_true_is_met_once) :-
    attested_true(True),
    findall(Result - Basis - Citations, duty_status([attribute(accountability_demonstrated, True)], accountability, Result, Basis, Citations), Answers),
    Answers == [met - [outside_fact(accountability_demonstrated, True)] - [cite(eu_reg_2016_679_art_5_2)]].
test(security_false_is_not_met_with_both_citations) :-
    attested_false(False),
    findall(Result - Citations, duty_status([attribute(security_level_appropriate_to_risk, False)], security_of_processing, Result, _, Citations), Answers),
    Answers == [not_met - [cite(eu_reg_2016_679_art_32_1), cite(eu_reg_2016_679_art_32_2)]].
test(absent_statement_refers) :-
    findall(Result - Basis - Citations, duty_status([], controller_measures, Result, Basis, Citations), Answers),
    Answers == [needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_24_1), cite(controller_measures_statement)), [resolution(cite(controller_measures_statement), not_attempted), inputs_relied_on([controller_measures_implemented_and_reviewed - absent])]) - [] - []].
test(by_default_first_false_aspect_decides) :-
    attested_true(True),
    attested_false(False),
    Profile = [attribute(by_default_only_necessary_data_processed, True), attribute(by_default_storage_period_limited_to_necessary, False), attribute(by_default_not_accessible_to_indefinite_number_without_intervention, false)],
    findall(Result - Basis - Citations, duty_status(Profile, data_protection_by_default, Result, Basis, Citations), Answers),
    Answers == [not_met - [outside_fact(by_default_storage_period_limited_to_necessary, False)] - [cite(eu_reg_2016_679_art_25_2)]].
test(by_default_crisp_false_has_empty_basis) :-
    findall(Result - Basis, duty_status([attribute(by_default_not_accessible_to_indefinite_number_without_intervention, false)], data_protection_by_default, Result, Basis, _), Answers),
    Answers == [not_met - []].
test(by_default_true_aspects_without_overall_still_refer) :-
    attested_true(True),
    Profile = [attribute(by_default_amount_collected_limited_to_necessary, True), attribute(by_default_extent_of_processing_limited_to_necessary, True), attribute(by_default_storage_period_limited_to_necessary, True), attribute(by_default_accessibility_limited_to_necessary, True), attribute(by_default_not_accessible_to_indefinite_number_without_intervention, true)],
    findall(Result, duty_status(Profile, data_protection_by_default, Result, _, _), Answers),
    Answers == [needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_25_2), cite(by_default_necessity_statement)), [resolution(cite(by_default_necessity_statement), not_attempted), inputs_relied_on([by_default_only_necessary_data_processed - absent])])].
test(by_default_overall_true_is_met) :-
    attested_true(True),
    duty_status([attribute(by_default_only_necessary_data_processed, True)], data_protection_by_default, met, _, _).
test(wrong_type_is_an_input_problem) :-
    findall(Result - Basis - Citations, duty_status([attribute(controllers_jointly_determine_purposes_and_means, maybe)], accountability, Result, Basis, Citations), Answers),
    Answers == [input_problems([wrong_type(controllers_jointly_determine_purposes_and_means)]) - [] - []].
test(principles_listed_once) :-
    findall(Items, non_binding_items([], accountability_principles, Items), [Items]),
    length(Items, 6).
test(security_examples_in_order) :-
    non_binding_items([], security_measures, [non_binding_item(pseudonymisation_and_encryption, cite(eu_reg_2016_679_art_32_1_a))|_]).
test(non_binding_items_with_problem) :-
    non_binding_items([attribute(stray, true)], security_measures, input_problems([unknown_key(stray)])).
test(joint_absent_is_indeterminate) :-
    findall(Result - Citations, joint_controller_arrangement([], Result, Citations), Answers),
    Answers == [indeterminate([controllers_jointly_determine_purposes_and_means]) - []].
test(joint_false_is_not_joint) :-
    joint_controller_arrangement([attribute(controllers_jointly_determine_purposes_and_means, false)], not_joint_controllers, [cite(eu_reg_2016_679_art_26_1)]).
test(joint_unsure_law_absent_names_law) :-
    joint_controller_arrangement([attribute(controllers_jointly_determine_purposes_and_means, unsure)], indeterminate([responsibilities_set_by_union_or_member_state_law]), []).
test(joint_unsure_with_facts_goes_to_lawyer) :-
    findall(Result, joint_controller_arrangement([attribute(controllers_jointly_determine_purposes_and_means, unsure), attribute(responsibilities_set_by_union_or_member_state_law, false), attribute(arrangement_between_controllers_exists, true)], Result, _), Answers),
    Answers == [needs_legal_review(open_textured(controllers_jointly_determine_purposes_and_means, cite(eu_reg_2016_679_art_26_1)), [inputs_relied_on([controllers_jointly_determine_purposes_and_means - unsure])])].
test(joint_true_without_arrangement_is_missing) :-
    findall(Result, joint_controller_arrangement([attribute(controllers_jointly_determine_purposes_and_means, true), attribute(responsibilities_set_by_union_or_member_state_law, false), attribute(arrangement_between_controllers_exists, false)], Result, _), Answers),
    Answers == [arrangement_missing].
test(joint_true_law_true_not_required) :-
    joint_controller_arrangement([attribute(controllers_jointly_determine_purposes_and_means, true), attribute(responsibilities_set_by_union_or_member_state_law, true)], arrangement_not_required, _).
test(content_essence_false_not_met) :-
    findall(Result - Basis, joint_controller_arrangement_content([attribute(essence_of_arrangement_made_available, false)], Result, Basis, _), Answers),
    Answers == [content_requirements_not_met - []].
test(content_false_roles_decides_before_absent_essence) :-
    attested_false(False),
    joint_controller_arrangement_content([attribute(arrangement_reflects_roles_and_relationships, False)], content_requirements_not_met, [outside_fact(arrangement_reflects_roles_and_relationships, False)], [cite(eu_reg_2016_679_art_26_2)]).
test(content_roles_absent_refers) :-
    joint_controller_arrangement_content([attribute(essence_of_arrangement_made_available, true)], needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_26_2), cite(arrangement_roles_statement)), _), [], []).
test(content_met) :-
    attested_true(True),
    findall(Result, joint_controller_arrangement_content([attribute(essence_of_arrangement_made_available, true), attribute(arrangement_reflects_roles_and_relationships, True)], Result, _, _), Answers),
    Answers == [content_requirements_met].
test(facade_all_true_is_compliant) :-
    full_true_profile(Profile),
    findall(Status, gdpr_accountability_security_status(Profile, Status), Statuses),
    Statuses == [compliant].
test(facade_empty_is_review_required) :-
    gdpr_accountability_security_status([], review_required).
test(facade_false_is_not_compliant) :-
    attested_false(False),
    gdpr_accountability_security_status([attribute(accountability_demonstrated, False)], not_compliant).

test(content_met_is_not_not_met, fail) :-
    attested_true(True),
    joint_controller_arrangement_content([attribute(essence_of_arrangement_made_available, true), attribute(arrangement_reflects_roles_and_relationships, True)], content_requirements_not_met, _, _).
test(facade_empty_is_not_compliant, fail) :-
    gdpr_accountability_security_status([], compliant).
