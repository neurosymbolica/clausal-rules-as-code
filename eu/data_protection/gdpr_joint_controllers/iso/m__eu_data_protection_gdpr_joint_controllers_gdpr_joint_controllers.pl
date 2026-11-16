% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_joint_controllers_gdpr_joint_controllers, [decide_gdpr_joint_controllers/2, gdpr_joint_controllers_status/2, gdpr_joint_controllers_checklist/2, gdpr_joint_controllers_decision_resolvable/1, gdpr_joint_controllers_status_values/1, rights_against_each_joint_controller/3, liability_for_the_entire_damage/4, recourse_after_full_compensation/4, not_joint_controllers/0, rights_exercisable_against_this_controller/0, not_responsible_for_the_damage/0, no_other_responsible_party/0, liable_for_the_entire_damage/0, not_entitled_to_claim_back/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_joint_controllers_kernel, [gdpr_joint_controllers_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_joint_controllers_citations, [implements/1]).
:- use_module(formalize_lib, [profile_get/3, profile_lacks/2, eval_requirements/4]).

not_joint_controllers.

rights_exercisable_against_this_controller.

not_responsible_for_the_damage.

no_other_responsible_party.

liable_for_the_entire_damage.

not_entitled_to_claim_back.

referral(joint_determination_unsure, needs_legal_review(open_textured(controllers_jointly_determine_purposes_and_means, cite(eu_reg_2016_679_art_26_3)), [inputs_relied_on([controllers_jointly_determine_purposes_and_means - unsure])])).
referral(full_compensation_unsure, needs_legal_review(open_textured(full_compensation_paid, cite(eu_reg_2016_679_art_82_5)), [inputs_relied_on([full_compensation_paid - unsure])])).
referral(responsibility_statement_not_shown_entire_damage, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_82_4), cite(responsibility_under_article_82_statement)), [resolution(cite(responsibility_under_article_82_statement), not_attempted), inputs_relied_on([responsible_under_article_82_2_and_3 - absent])])).
referral(responsibility_statement_not_shown_claim_back, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_82_4), cite(responsibility_under_article_82_statement)), [resolution(cite(responsibility_under_article_82_statement), not_attempted), inputs_relied_on([responsible_under_article_82_2_and_3 - absent])])).

judgement_state(Profile, Key, absent) :-
    profile_lacks(Profile, Key).
judgement_state(Profile, Key, Value) :-
    profile_get(Profile, Key, Value).

responsibility_state(Profile, absent) :-
    profile_lacks(Profile, responsible_under_article_82_2_and_3).
responsibility_state(Profile, stated(Truth, Attested)) :-
    profile_get(Profile, responsible_under_article_82_2_and_3, Attested),
    Attested = attested(Truth, _).

parties_state(Profile, absent) :-
    profile_lacks(Profile, other_responsible_parties).
parties_state(Profile, State) :-
    profile_get(Profile, other_responsible_parties, Parties),
    list_state(Parties, State).

list_state([], empty).
list_state([First|Others], listed([First|Others])).

statement_not_false(absent).
statement_not_false(stated(true, _)).

parties_not_empty(absent).
parties_not_empty(listed(_)).

payment_not_false(absent).
payment_not_false(true).
payment_not_false(unsure).

rights_against_each_joint_controller(Profile, input_problems([Problem|Problems]), []) :-
    gdpr_joint_controllers_input_problems(Profile, [Problem|Problems]).
rights_against_each_joint_controller(Profile, Result, Citations) :-
    gdpr_joint_controllers_input_problems(Profile, []),
    judgement_state(Profile, controllers_jointly_determine_purposes_and_means, Joint),
    rights_limb(Joint, Result, Citations).

rights_limb(false, not_joint_controllers, [cite(eu_reg_2016_679_art_26_3)]) :-
    implements(eu_reg_2016_679_art_26_3).
rights_limb(absent, indeterminate([controllers_jointly_determine_purposes_and_means]), []) :-
    implements(eu_reg_2016_679_art_26_3).
rights_limb(unsure, Referral, []) :-
    implements(eu_reg_2016_679_art_26_3),
    referral(joint_determination_unsure, Referral).
rights_limb(true, rights_exercisable_against_this_controller, [cite(eu_reg_2016_679_art_26_3), cite(eu_reg_2016_679_art_28_10)]) :-
    implements(eu_reg_2016_679_art_26_3),
    implements(eu_reg_2016_679_art_28_10).

liability_for_the_entire_damage(Profile, input_problems([Problem|Problems]), [], []) :-
    gdpr_joint_controllers_input_problems(Profile, [Problem|Problems]).
liability_for_the_entire_damage(Profile, Result, Basis, Citations) :-
    gdpr_joint_controllers_input_problems(Profile, []),
    responsibility_state(Profile, Statement),
    parties_state(Profile, PartiesState),
    liability_limb(Statement, PartiesState, Result, Basis, Citations).

liability_limb(stated(false, Attested), _, not_responsible_for_the_damage, [outside_fact(responsible_under_article_82_2_and_3, Attested)], [cite(eu_reg_2016_679_art_82_4)]) :-
    implements(eu_reg_2016_679_art_82_4).
liability_limb(absent, _, Referral, [], []) :-
    implements(eu_reg_2016_679_art_82_4),
    referral(responsibility_statement_not_shown_entire_damage, Referral).
liability_limb(stated(true, _), absent, indeterminate([other_responsible_parties]), [], []) :-
    implements(eu_reg_2016_679_art_82_4).
liability_limb(stated(true, Attested), empty, no_other_responsible_party, [outside_fact(responsible_under_article_82_2_and_3, Attested)], [cite(eu_reg_2016_679_art_82_4)]) :-
    implements(eu_reg_2016_679_art_82_4).
liability_limb(stated(true, Attested), listed(_), liable_for_the_entire_damage, [outside_fact(responsible_under_article_82_2_and_3, Attested)], [cite(eu_reg_2016_679_art_82_4)]) :-
    implements(eu_reg_2016_679_art_82_4).

recourse_after_full_compensation(Profile, input_problems([Problem|Problems]), [], []) :-
    gdpr_joint_controllers_input_problems(Profile, [Problem|Problems]).
recourse_after_full_compensation(Profile, Result, Basis, Citations) :-
    gdpr_joint_controllers_input_problems(Profile, []),
    responsibility_state(Profile, Statement),
    parties_state(Profile, PartiesState),
    judgement_state(Profile, full_compensation_paid, Payment),
    recourse_limb(Statement, PartiesState, Payment, Result, Basis, Citations).

recourse_limb(stated(false, Attested), _, _, not_entitled_to_claim_back, [outside_fact(responsible_under_article_82_2_and_3, Attested)], [cite(eu_reg_2016_679_art_82_5)]) :-
    implements(eu_reg_2016_679_art_82_5).
recourse_limb(Statement, empty, _, not_entitled_to_claim_back, [], [cite(eu_reg_2016_679_art_82_5)]) :-
    implements(eu_reg_2016_679_art_82_5),
    statement_not_false(Statement).
recourse_limb(Statement, PartiesState, false, not_entitled_to_claim_back, [], [cite(eu_reg_2016_679_art_82_5)]) :-
    implements(eu_reg_2016_679_art_82_5),
    statement_not_false(Statement),
    parties_not_empty(PartiesState).
recourse_limb(absent, PartiesState, Payment, Referral, [], []) :-
    implements(eu_reg_2016_679_art_82_5),
    parties_not_empty(PartiesState),
    payment_not_false(Payment),
    referral(responsibility_statement_not_shown_claim_back, Referral).
recourse_limb(stated(true, _), absent, Payment, indeterminate([other_responsible_parties]), [], []) :-
    implements(eu_reg_2016_679_art_82_5),
    payment_not_false(Payment).
recourse_limb(stated(true, _), listed(_), absent, indeterminate([full_compensation_paid]), [], []) :-
    implements(eu_reg_2016_679_art_82_5).
recourse_limb(stated(true, _), listed(_), unsure, Referral, [], []) :-
    implements(eu_reg_2016_679_art_82_5),
    referral(full_compensation_unsure, Referral).
recourse_limb(stated(true, Attested), listed(Parties), true, entitled_to_claim_back(Parties), [outside_fact(responsible_under_article_82_2_and_3, Attested)], [cite(eu_reg_2016_679_art_82_5)]) :-
    implements(eu_reg_2016_679_art_82_5).

gdpr_joint_controllers_status_values([eligible, ineligible, unresolved, referred_for_legal_review, malformed_input]).

decide_gdpr_joint_controllers(Profile, gdpr_joint_controllers_verdict(eligible, Citations)) :-
    recourse_after_full_compensation(Profile, entitled_to_claim_back(_), _, Citations).
decide_gdpr_joint_controllers(Profile, gdpr_joint_controllers_verdict(ineligible, Citations)) :-
    recourse_after_full_compensation(Profile, not_entitled_to_claim_back, _, Citations).
decide_gdpr_joint_controllers(Profile, gdpr_joint_controllers_verdict(unresolved, Citations)) :-
    recourse_after_full_compensation(Profile, indeterminate(_), _, Citations).
decide_gdpr_joint_controllers(Profile, gdpr_joint_controllers_verdict(referred_for_legal_review, Citations)) :-
    recourse_after_full_compensation(Profile, needs_legal_review(_, _), _, Citations).
decide_gdpr_joint_controllers(Profile, gdpr_joint_controllers_verdict(malformed_input, Citations)) :-
    recourse_after_full_compensation(Profile, input_problems(_), _, Citations).

gdpr_joint_controllers_status(Profile, Status) :-
    decide_gdpr_joint_controllers(Profile, gdpr_joint_controllers_verdict(Status, _)).

gdpr_joint_controllers_decision_resolvable(Profile) :-
    decide_gdpr_joint_controllers(Profile, _).

recourse_requirement_ids([caller_responsible_for_the_damage, other_responsible_party_listed, full_compensation_paid]).

gdpr_joint_controllers_checklist(Profile, Items) :-
    gdpr_joint_controllers_input_problems(Profile, []),
    recourse_requirement_ids(RequirementIds),
    eval_requirements(RequirementIds, Profile, recourse_requirement, Items).
gdpr_joint_controllers_checklist(Profile, [item(input_check, unmet(input_problems([Problem|Problems])), cite(eu_reg_2016_679_art_82_5))]) :-
    gdpr_joint_controllers_input_problems(Profile, [Problem|Problems]).

recourse_requirement(caller_responsible_for_the_damage, Profile, Status, cite(eu_reg_2016_679_art_82_4)) :-
    implements(eu_reg_2016_679_art_82_4),
    responsibility_state(Profile, Statement),
    statement_item_status(Statement, Status).
recourse_requirement(other_responsible_party_listed, Profile, Status, cite(eu_reg_2016_679_art_82_4)) :-
    implements(eu_reg_2016_679_art_82_4),
    parties_state(Profile, PartiesState),
    parties_item_status(PartiesState, Status).
recourse_requirement(full_compensation_paid, Profile, Status, cite(eu_reg_2016_679_art_82_5)) :-
    implements(eu_reg_2016_679_art_82_5),
    judgement_state(Profile, full_compensation_paid, Payment),
    payment_item_status(Payment, Status).

statement_item_status(stated(true, _), met).
statement_item_status(stated(false, _), unmet(not_responsible_for_the_damage)).
statement_item_status(absent, unknown([responsible_under_article_82_2_and_3])).

parties_item_status(listed(_), met).
parties_item_status(empty, unmet(no_other_responsible_party)).
parties_item_status(absent, unknown([other_responsible_parties])).

payment_item_status(true, met).
payment_item_status(false, unmet(full_compensation_not_paid)).
payment_item_status(absent, unknown([full_compensation_paid])).
payment_item_status(unsure, unknown([full_compensation_paid])).

example_statement(Truth, attested(Truth, attestation(registry_host, moment, stated_reason, none))).

test(rights_joint_false_is_not_joint_controllers) :-
    findall(Result - Citations, rights_against_each_joint_controller([attribute(controllers_jointly_determine_purposes_and_means, false)], Result, Citations), Answers),
    Answers == [not_joint_controllers - [cite(eu_reg_2016_679_art_26_3)]].
test(rights_joint_absent_is_asked_for) :-
    findall(Result - Citations, rights_against_each_joint_controller([], Result, Citations), Answers),
    Answers == [indeterminate([controllers_jointly_determine_purposes_and_means]) - []].
test(rights_joint_unsure_goes_to_a_lawyer) :-
    findall(Result - Citations, rights_against_each_joint_controller([attribute(controllers_jointly_determine_purposes_and_means, unsure)], Result, Citations), Answers),
    Answers == [needs_legal_review(open_textured(controllers_jointly_determine_purposes_and_means, cite(eu_reg_2016_679_art_26_3)), [inputs_relied_on([controllers_jointly_determine_purposes_and_means - unsure])]) - []].
test(rights_joint_true_is_exercisable_once) :-
    findall(Result - Citations, rights_against_each_joint_controller([attribute(controllers_jointly_determine_purposes_and_means, true), attribute(full_compensation_paid, true)], Result, Citations), Answers),
    Answers == [rights_exercisable_against_this_controller - [cite(eu_reg_2016_679_art_26_3), cite(eu_reg_2016_679_art_28_10)]].
test(rights_input_problem_comes_first) :-
    findall(Result - Citations, rights_against_each_joint_controller([attribute(controllers_jointly_determine_purposes_and_means, true), attribute(full_compensation_paid, yes)], Result, Citations), Answers),
    Answers == [input_problems([wrong_type(full_compensation_paid)]) - []].
test(rights_not_an_attribute_list) :-
    findall(Result - Citations, rights_against_each_joint_controller(not_a_profile, Result, Citations), Answers),
    Answers == [input_problems([wrong_type(profile)]) - []].
test(liability_stated_false_whatever_the_list) :-
    example_statement(false, Attested),
    findall(Result - Basis - Citations, liability_for_the_entire_damage([attribute(responsible_under_article_82_2_and_3, Attested)], Result, Basis, Citations), Answers),
    Answers == [not_responsible_for_the_damage - [outside_fact(responsible_under_article_82_2_and_3, Attested)] - [cite(eu_reg_2016_679_art_82_4)]].
test(liability_statement_absent_is_referred) :-
    findall(Result - Basis - Citations, liability_for_the_entire_damage([attribute(other_responsible_parties, [processor_b])], Result, Basis, Citations), Answers),
    Answers == [needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_82_4), cite(responsibility_under_article_82_statement)), [resolution(cite(responsibility_under_article_82_statement), not_attempted), inputs_relied_on([responsible_under_article_82_2_and_3 - absent])]) - [] - []].
test(liability_parties_absent_are_asked_for) :-
    example_statement(true, Attested),
    findall(Result - Basis - Citations, liability_for_the_entire_damage([attribute(responsible_under_article_82_2_and_3, Attested)], Result, Basis, Citations), Answers),
    Answers == [indeterminate([other_responsible_parties]) - [] - []].
test(liability_alone_is_no_other_responsible_party) :-
    example_statement(true, Attested),
    findall(Result, liability_for_the_entire_damage([attribute(responsible_under_article_82_2_and_3, Attested), attribute(other_responsible_parties, [])], Result, _, _), Results),
    Results == [no_other_responsible_party].
test(liability_with_another_is_the_entire_damage) :-
    example_statement(true, Attested),
    findall(Result - Basis, liability_for_the_entire_damage([attribute(responsible_under_article_82_2_and_3, Attested), attribute(other_responsible_parties, [controller_b])], Result, Basis, _), Answers),
    Answers == [liable_for_the_entire_damage - [outside_fact(responsible_under_article_82_2_and_3, Attested)]].
test(liability_bare_true_statement_is_wrong_type) :-
    findall(Result, liability_for_the_entire_damage([attribute(responsible_under_article_82_2_and_3, true)], Result, _, _), Results),
    Results == [input_problems([wrong_type(responsible_under_article_82_2_and_3)])].
test(recourse_stated_false_whatever_else) :-
    example_statement(false, Attested),
    findall(Result - Basis, recourse_after_full_compensation([attribute(responsible_under_article_82_2_and_3, Attested), attribute(full_compensation_paid, unsure)], Result, Basis, _), Answers),
    Answers == [not_entitled_to_claim_back - [outside_fact(responsible_under_article_82_2_and_3, Attested)]].
test(recourse_empty_list_with_statement_absent) :-
    findall(Result - Basis - Citations, recourse_after_full_compensation([attribute(other_responsible_parties, [])], Result, Basis, Citations), Answers),
    Answers == [not_entitled_to_claim_back - [] - [cite(eu_reg_2016_679_art_82_5)]].
test(recourse_payment_false_with_everything_else_absent) :-
    findall(Result - Basis - Citations, recourse_after_full_compensation([attribute(full_compensation_paid, false)], Result, Basis, Citations), Answers),
    Answers == [not_entitled_to_claim_back - [] - [cite(eu_reg_2016_679_art_82_5)]].
test(recourse_statement_absent_referred_before_unsure_payment) :-
    findall(Result, recourse_after_full_compensation([attribute(full_compensation_paid, unsure)], Result, _, _), Results),
    Results == [needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_82_4), cite(responsibility_under_article_82_statement)), [resolution(cite(responsibility_under_article_82_statement), not_attempted), inputs_relied_on([responsible_under_article_82_2_and_3 - absent])])].
test(recourse_parties_named_before_unsure_payment) :-
    example_statement(true, Attested),
    findall(Result, recourse_after_full_compensation([attribute(responsible_under_article_82_2_and_3, Attested), attribute(full_compensation_paid, unsure)], Result, _, _), Results),
    Results == [indeterminate([other_responsible_parties])].
test(recourse_payment_absent_is_asked_for) :-
    example_statement(true, Attested),
    findall(Result, recourse_after_full_compensation([attribute(responsible_under_article_82_2_and_3, Attested), attribute(other_responsible_parties, [controller_b])], Result, _, _), Results),
    Results == [indeterminate([full_compensation_paid])].
test(recourse_payment_unsure_goes_to_a_lawyer) :-
    example_statement(true, Attested),
    findall(Result - Citations, recourse_after_full_compensation([attribute(responsible_under_article_82_2_and_3, Attested), attribute(other_responsible_parties, [controller_b]), attribute(full_compensation_paid, unsure)], Result, _, Citations), Answers),
    Answers == [needs_legal_review(open_textured(full_compensation_paid, cite(eu_reg_2016_679_art_82_5)), [inputs_relied_on([full_compensation_paid - unsure])]) - []].
test(recourse_entitled_keeps_the_list_as_given) :-
    example_statement(true, Attested),
    findall(Result - Basis - Citations, recourse_after_full_compensation([attribute(full_compensation_paid, true), attribute(other_responsible_parties, [processor_b, controller_c, processor_b]), attribute(responsible_under_article_82_2_and_3, Attested)], Result, Basis, Citations), Answers),
    Answers == [entitled_to_claim_back([processor_b, controller_c, processor_b]) - [outside_fact(responsible_under_article_82_2_and_3, Attested)] - [cite(eu_reg_2016_679_art_82_5)]].
test(recourse_unpaid_is_not_entitled_positive) :-
    example_statement(true, Attested),
    recourse_after_full_compensation([attribute(responsible_under_article_82_2_and_3, Attested), attribute(other_responsible_parties, [controller_b]), attribute(full_compensation_paid, false)], not_entitled_to_claim_back, [], [cite(eu_reg_2016_679_art_82_5)]).
test(recourse_duplicate_and_unknown_keys) :-
    findall(Result, recourse_after_full_compensation([attribute(extra_key, x), attribute(full_compensation_paid, true), attribute(full_compensation_paid, true)], Result, _, _), Results),
    Results == [input_problems([duplicate_key(full_compensation_paid), unknown_key(extra_key)])].
test(facade_entitled_is_eligible) :-
    example_statement(true, Attested),
    findall(Status, gdpr_joint_controllers_status([attribute(responsible_under_article_82_2_and_3, Attested), attribute(other_responsible_parties, [controller_b]), attribute(full_compensation_paid, true)], Status), Statuses),
    Statuses == [eligible].
test(facade_absent_statement_is_referred) :-
    gdpr_joint_controllers_status([], referred_for_legal_review).
test(checklist_rows_are_cited) :-
    example_statement(true, Attested),
    gdpr_joint_controllers_checklist([attribute(responsible_under_article_82_2_and_3, Attested), attribute(other_responsible_parties, []), attribute(full_compensation_paid, true)], Items),
    member(item(caller_responsible_for_the_damage, met, cite(eu_reg_2016_679_art_82_4)), Items),
    member(item(other_responsible_party_listed, unmet(no_other_responsible_party), cite(eu_reg_2016_679_art_82_4)), Items),
    member(item(full_compensation_paid, met, cite(eu_reg_2016_679_art_82_5)), Items).

test(rights_joint_false_is_not_exercisable, fail) :-
    rights_against_each_joint_controller([attribute(controllers_jointly_determine_purposes_and_means, false)], rights_exercisable_against_this_controller, _).
test(liability_alone_is_not_the_entire_damage, fail) :-
    example_statement(true, Attested),
    liability_for_the_entire_damage([attribute(responsible_under_article_82_2_and_3, Attested), attribute(other_responsible_parties, [])], liable_for_the_entire_damage, _, _).
test(recourse_unpaid_is_not_entitled, fail) :-
    example_statement(true, Attested),
    recourse_after_full_compensation([attribute(responsible_under_article_82_2_and_3, Attested), attribute(other_responsible_parties, [controller_b]), attribute(full_compensation_paid, false)], entitled_to_claim_back(_), _, _).
test(facade_absent_statement_is_not_eligible, fail) :-
    gdpr_joint_controllers_status([], eligible).
