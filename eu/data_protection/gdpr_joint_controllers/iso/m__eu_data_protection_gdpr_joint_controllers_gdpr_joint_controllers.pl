% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_joint_controllers_gdpr_joint_controllers, [rights_against_each_joint_controller/3, liability_for_the_entire_damage/4, recourse_after_full_compensation/4, decide_gdpr_joint_controllers/2, gdpr_joint_controllers_status/2, gdpr_joint_controllers_checklist/2, gdpr_joint_controllers_decision_resolvable/1, gdpr_joint_controllers_status_values/1, not_joint_controllers/0, rights_exercisable_against_this_controller/0, not_responsible_for_the_damage/0, no_other_responsible_party/0, liable_for_the_entire_damage/0, not_entitled_to_claim_back/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_msort/2]).
:- use_module(m__eu_data_protection_gdpr_joint_controllers_kernel, [gdpr_joint_controllers_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_joint_controllers_citations, [implements/1]).
:- use_module(formalize_lib, [profile_get/3, profile_has/2, profile_lacks/2, eval_requirements/4]).

not_joint_controllers.

rights_exercisable_against_this_controller.

not_responsible_for_the_damage.

no_other_responsible_party.

liable_for_the_entire_damage.

not_entitled_to_claim_back.

outside_fact_row(responsible_under_article_82_2_and_3, cite(eu_reg_2016_679_art_82_4), cite(responsibility_under_article_82_statement)).

referral_row(joint_determination_unsure, controllers_jointly_determine_purposes_and_means, cite(eu_reg_2016_679_art_26_3)).
referral_row(full_compensation_unsure, full_compensation_paid, cite(eu_reg_2016_679_art_82_5)).

open_textured_referral(Situation, needs_legal_review(open_textured(Input, Citation), [inputs_relied_on([Input - unsure])])) :-
    referral_row(Situation, Input, Citation).

absent_referral(Key, needs_legal_review(cross_reference_unresolved(Citation, Target), [resolution(Target, not_attempted), inputs_relied_on([Key - absent])])) :-
    outside_fact_row(Key, Citation, Target).

key_state(Profile, Key, absent) :-
    profile_lacks(Profile, Key).
key_state(Profile, Key, present(Value)) :-
    profile_has(Profile, Key),
    profile_get(Profile, Key, Value).

responsibility_class(absent, absent).
responsibility_class(present(attested(true, _)), true).
responsibility_class(present(attested(false, _)), false).

parties_class(absent, absent).
parties_class(present([]), empty).
parties_class(present([_|_]), listed).

payment_class(absent, absent).
payment_class(present(Value), Value).

open_or_true(absent).
open_or_true(true).

absent_or_listed(absent).
absent_or_listed(listed).

payment_not_false(absent).
payment_not_false(true).
payment_not_false(unsure).

rights_against_each_joint_controller(Profile, input_problems([Problem|Problems]), []) :-
    gdpr_joint_controllers_input_problems(Profile, [Problem|Problems]).
rights_against_each_joint_controller(Profile, Result, Citations) :-
    gdpr_joint_controllers_input_problems(Profile, []),
    key_state(Profile, controllers_jointly_determine_purposes_and_means, JointState),
    rights_route(JointState, Result, Citations).

rights_route(present(false), not_joint_controllers, [cite(eu_reg_2016_679_art_26_3)]) :-
    implements(eu_reg_2016_679_art_26_3).
rights_route(absent, indeterminate([controllers_jointly_determine_purposes_and_means]), []) :-
    implements(eu_reg_2016_679_art_26_3).
rights_route(present(unsure), Referral, []) :-
    implements(eu_reg_2016_679_art_26_3),
    open_textured_referral(joint_determination_unsure, Referral).
rights_route(present(true), rights_exercisable_against_this_controller, [cite(eu_reg_2016_679_art_26_3), cite(eu_reg_2016_679_art_28_10)]) :-
    implements(eu_reg_2016_679_art_26_3),
    implements(eu_reg_2016_679_art_28_10).

liability_for_the_entire_damage(Profile, input_problems([Problem|Problems]), [], []) :-
    gdpr_joint_controllers_input_problems(Profile, [Problem|Problems]).
liability_for_the_entire_damage(Profile, Result, Basis, Citations) :-
    gdpr_joint_controllers_input_problems(Profile, []),
    key_state(Profile, responsible_under_article_82_2_and_3, ResponsibilityState),
    key_state(Profile, other_responsible_parties, PartiesState),
    liability_route(ResponsibilityState, PartiesState, Result, Basis, Citations).

liability_route(present(attested(false, Attestation)), _, not_responsible_for_the_damage, [outside_fact(responsible_under_article_82_2_and_3, attested(false, Attestation))], [cite(eu_reg_2016_679_art_82_4)]) :-
    implements(eu_reg_2016_679_art_82_4).
liability_route(absent, _, Referral, [], []) :-
    implements(eu_reg_2016_679_art_82_4),
    absent_referral(responsible_under_article_82_2_and_3, Referral).
liability_route(present(attested(true, _)), absent, indeterminate([other_responsible_parties]), [], []) :-
    implements(eu_reg_2016_679_art_82_4).
liability_route(present(attested(true, Attestation)), present([]), no_other_responsible_party, [outside_fact(responsible_under_article_82_2_and_3, attested(true, Attestation))], [cite(eu_reg_2016_679_art_82_4)]) :-
    implements(eu_reg_2016_679_art_82_4).
liability_route(present(attested(true, Attestation)), present([_|_]), liable_for_the_entire_damage, [outside_fact(responsible_under_article_82_2_and_3, attested(true, Attestation))], [cite(eu_reg_2016_679_art_82_4)]) :-
    implements(eu_reg_2016_679_art_82_4).

recourse_after_full_compensation(Profile, input_problems([Problem|Problems]), [], []) :-
    gdpr_joint_controllers_input_problems(Profile, [Problem|Problems]).
recourse_after_full_compensation(Profile, Result, Basis, Citations) :-
    gdpr_joint_controllers_input_problems(Profile, []),
    key_state(Profile, responsible_under_article_82_2_and_3, ResponsibilityState),
    key_state(Profile, other_responsible_parties, PartiesState),
    key_state(Profile, full_compensation_paid, PaymentState),
    recourse_route(ResponsibilityState, PartiesState, PaymentState, Result, Basis, Citations).

recourse_route(present(attested(false, Attestation)), _, _, not_entitled_to_claim_back, [outside_fact(responsible_under_article_82_2_and_3, attested(false, Attestation))], [cite(eu_reg_2016_679_art_82_5)]) :-
    implements(eu_reg_2016_679_art_82_5).
recourse_route(ResponsibilityState, present([]), _, not_entitled_to_claim_back, [], [cite(eu_reg_2016_679_art_82_5)]) :-
    implements(eu_reg_2016_679_art_82_5),
    responsibility_class(ResponsibilityState, ResponsibilityClass),
    open_or_true(ResponsibilityClass).
recourse_route(ResponsibilityState, PartiesState, present(false), not_entitled_to_claim_back, [], [cite(eu_reg_2016_679_art_82_5)]) :-
    implements(eu_reg_2016_679_art_82_5),
    responsibility_class(ResponsibilityState, ResponsibilityClass),
    open_or_true(ResponsibilityClass),
    parties_class(PartiesState, PartiesClass),
    absent_or_listed(PartiesClass).
recourse_route(absent, PartiesState, PaymentState, Referral, [], []) :-
    implements(eu_reg_2016_679_art_82_4),
    parties_class(PartiesState, PartiesClass),
    absent_or_listed(PartiesClass),
    payment_class(PaymentState, PaymentClass),
    payment_not_false(PaymentClass),
    absent_referral(responsible_under_article_82_2_and_3, Referral).
recourse_route(present(attested(true, _)), absent, PaymentState, indeterminate([other_responsible_parties]), [], []) :-
    implements(eu_reg_2016_679_art_82_5),
    payment_class(PaymentState, PaymentClass),
    payment_not_false(PaymentClass).
recourse_route(present(attested(true, _)), present([_|_]), absent, indeterminate([full_compensation_paid]), [], []) :-
    implements(eu_reg_2016_679_art_82_5).
recourse_route(present(attested(true, _)), present([_|_]), present(unsure), Referral, [], []) :-
    implements(eu_reg_2016_679_art_82_5),
    open_textured_referral(full_compensation_unsure, Referral).
recourse_route(present(attested(true, Attestation)), present([FirstParty|LaterParties]), present(true), entitled_to_claim_back([FirstParty|LaterParties]), [outside_fact(responsible_under_article_82_2_and_3, attested(true, Attestation))], [cite(eu_reg_2016_679_art_82_5)]) :-
    implements(eu_reg_2016_679_art_82_5).

gdpr_joint_controllers_status_values([eligible, ineligible, indeterminate]).

decide_gdpr_joint_controllers(Profile, gdpr_joint_controllers_verdict(Status, Citations)) :-
    recourse_after_full_compensation(Profile, Result, _Basis, ResultCitations),
    verdict_of_recourse(Result, ResultCitations, Status, Citations).

verdict_of_recourse(entitled_to_claim_back(_), Citations, eligible, Citations).
verdict_of_recourse(not_entitled_to_claim_back, Citations, ineligible, Citations).
verdict_of_recourse(indeterminate(_), _, indeterminate, []).
verdict_of_recourse(needs_legal_review(_, _), _, indeterminate, []).
verdict_of_recourse(input_problems(_), _, indeterminate, []).

gdpr_joint_controllers_status(Profile, Status) :-
    decide_gdpr_joint_controllers(Profile, gdpr_joint_controllers_verdict(Status, _Citations)).

claim_back_requirements([responsible_under_article_82, other_responsible_party_listed, full_compensation_paid]).

gdpr_joint_controllers_checklist(Profile, Items) :-
    gdpr_joint_controllers_input_problems(Profile, []),
    claim_back_requirements(RequirementIdentifiers),
    eval_requirements(RequirementIdentifiers, Profile, claim_back_requirement, Items).
gdpr_joint_controllers_checklist(Profile, []) :-
    gdpr_joint_controllers_input_problems(Profile, [_|_]).

claim_back_requirement(responsible_under_article_82, Profile, Status, cite(eu_reg_2016_679_art_82_4)) :-
    implements(eu_reg_2016_679_art_82_4),
    key_state(Profile, responsible_under_article_82_2_and_3, State),
    responsibility_item_status(State, Status).
claim_back_requirement(other_responsible_party_listed, Profile, Status, cite(eu_reg_2016_679_art_82_4)) :-
    implements(eu_reg_2016_679_art_82_4),
    key_state(Profile, other_responsible_parties, State),
    parties_item_status(State, Status).
claim_back_requirement(full_compensation_paid, Profile, Status, cite(eu_reg_2016_679_art_82_5)) :-
    implements(eu_reg_2016_679_art_82_5),
    key_state(Profile, full_compensation_paid, State),
    payment_item_status(State, Status).

responsibility_item_status(present(attested(true, _)), met).
responsibility_item_status(present(attested(false, _)), unmet(not_responsible_under_article_82)).
responsibility_item_status(absent, unknown([responsible_under_article_82_2_and_3])).

parties_item_status(present([_|_]), met).
parties_item_status(present([]), unmet(no_other_responsible_party)).
parties_item_status(absent, unknown([other_responsible_parties])).

payment_item_status(present(true), met).
payment_item_status(present(false), unmet(full_compensation_not_paid)).
payment_item_status(present(unsure), unknown([full_compensation_paid])).
payment_item_status(absent, unknown([full_compensation_paid])).

gdpr_joint_controllers_decision_resolvable(Profile) :-
    decide_gdpr_joint_controllers(Profile, _Verdict).

stated_responsibility(Value, attested(Value, attestation(host_service, attested_moment, stated_reason, none))).

test(a_joint_controller_has_rights_exercised_against_it) :-
    rights_against_each_joint_controller([attribute(controllers_jointly_determine_purposes_and_means, true)], Result, Citations),
    Result == rights_exercisable_against_this_controller,
    clausal_msort(Citations, [cite(eu_reg_2016_679_art_26_3), cite(eu_reg_2016_679_art_28_10)]).
test(a_non_joint_controller_is_not_reached) :-
    rights_against_each_joint_controller([attribute(controllers_jointly_determine_purposes_and_means, false)], not_joint_controllers, [cite(eu_reg_2016_679_art_26_3)]).
test(an_absent_joint_determination_is_asked_for) :-
    rights_against_each_joint_controller([], indeterminate([controllers_jointly_determine_purposes_and_means]), []).
test(an_unsure_joint_determination_goes_to_a_lawyer) :-
    rights_against_each_joint_controller([attribute(controllers_jointly_determine_purposes_and_means, unsure)], Result, []),
    Result == needs_legal_review(open_textured(controllers_jointly_determine_purposes_and_means, cite(eu_reg_2016_679_art_26_3)), [inputs_relied_on([controllers_jointly_determine_purposes_and_means - unsure])]).
test(an_unknown_key_is_an_input_problem) :-
    rights_against_each_joint_controller([attribute(stray_key, true)], input_problems([unknown_key(stray_key)]), []).
test(a_bare_boolean_outside_fact_is_a_wrong_type) :-
    liability_for_the_entire_damage([attribute(responsible_under_article_82_2_and_3, true)], input_problems([wrong_type(responsible_under_article_82_2_and_3)]), [], []).
test(a_responsible_party_with_others_is_liable_for_the_entire_damage) :-
    stated_responsibility(true, Attested),
    liability_for_the_entire_damage([attribute(responsible_under_article_82_2_and_3, Attested), attribute(other_responsible_parties, [processor_beta])], liable_for_the_entire_damage, Basis, [cite(eu_reg_2016_679_art_82_4)]),
    Basis == [outside_fact(responsible_under_article_82_2_and_3, Attested)].
test(a_responsible_party_alone_has_no_other_responsible_party) :-
    stated_responsibility(true, Attested),
    liability_for_the_entire_damage([attribute(responsible_under_article_82_2_and_3, Attested), attribute(other_responsible_parties, [])], no_other_responsible_party, _, [cite(eu_reg_2016_679_art_82_4)]).
test(a_party_not_responsible_is_not_liable_whatever_the_list) :-
    stated_responsibility(false, Attested),
    liability_for_the_entire_damage([attribute(responsible_under_article_82_2_and_3, Attested)], not_responsible_for_the_damage, [outside_fact(responsible_under_article_82_2_and_3, Attested)], [cite(eu_reg_2016_679_art_82_4)]).
test(an_absent_statement_is_referred_in_liability) :-
    liability_for_the_entire_damage([attribute(other_responsible_parties, [controller_alpha])], Result, [], []),
    Result == needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_82_4), cite(responsibility_under_article_82_statement)), [resolution(cite(responsibility_under_article_82_statement), not_attempted), inputs_relied_on([responsible_under_article_82_2_and_3 - absent])]).
test(an_absent_list_is_asked_for_in_liability) :-
    stated_responsibility(true, Attested),
    liability_for_the_entire_damage([attribute(responsible_under_article_82_2_and_3, Attested)], indeterminate([other_responsible_parties]), [], []).
test(full_compensation_by_a_responsible_party_gives_a_claim_back) :-
    stated_responsibility(true, Attested),
    recourse_after_full_compensation([attribute(responsible_under_article_82_2_and_3, Attested), attribute(other_responsible_parties, [processor_beta, controller_alpha, processor_beta]), attribute(full_compensation_paid, true)], Result, Basis, [cite(eu_reg_2016_679_art_82_5)]),
    Result == entitled_to_claim_back([processor_beta, controller_alpha, processor_beta]),
    Basis == [outside_fact(responsible_under_article_82_2_and_3, Attested)].
test(a_party_not_responsible_has_no_claim_back_even_if_unsure) :-
    stated_responsibility(false, Attested),
    recourse_after_full_compensation([attribute(responsible_under_article_82_2_and_3, Attested), attribute(full_compensation_paid, unsure)], not_entitled_to_claim_back, [outside_fact(responsible_under_article_82_2_and_3, Attested)], [cite(eu_reg_2016_679_art_82_5)]).
test(no_other_party_gives_no_claim_back_without_a_statement) :-
    recourse_after_full_compensation([attribute(other_responsible_parties, [])], not_entitled_to_claim_back, [], [cite(eu_reg_2016_679_art_82_5)]).
test(a_partial_payment_gives_no_claim_back_without_a_statement) :-
    recourse_after_full_compensation([attribute(full_compensation_paid, false)], not_entitled_to_claim_back, [], [cite(eu_reg_2016_679_art_82_5)]).
test(an_absent_statement_is_referred_before_an_unsure_payment) :-
    recourse_after_full_compensation([attribute(other_responsible_parties, [controller_alpha]), attribute(full_compensation_paid, unsure)], Result, [], []),
    Result == needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_82_4), cite(responsibility_under_article_82_statement)), [resolution(cite(responsibility_under_article_82_statement), not_attempted), inputs_relied_on([responsible_under_article_82_2_and_3 - absent])]).
test(a_missing_list_is_named_before_an_unsure_payment) :-
    stated_responsibility(true, Attested),
    recourse_after_full_compensation([attribute(responsible_under_article_82_2_and_3, Attested), attribute(full_compensation_paid, unsure)], indeterminate([other_responsible_parties]), [], []).
test(a_missing_payment_judgement_is_asked_for) :-
    stated_responsibility(true, Attested),
    recourse_after_full_compensation([attribute(responsible_under_article_82_2_and_3, Attested), attribute(other_responsible_parties, [controller_alpha])], indeterminate([full_compensation_paid]), [], []).
test(an_unsure_payment_goes_to_a_lawyer) :-
    stated_responsibility(true, Attested),
    recourse_after_full_compensation([attribute(responsible_under_article_82_2_and_3, Attested), attribute(other_responsible_parties, [controller_alpha]), attribute(full_compensation_paid, unsure)], Result, [], []),
    Result == needs_legal_review(open_textured(full_compensation_paid, cite(eu_reg_2016_679_art_82_5)), [inputs_relied_on([full_compensation_paid - unsure])]).
test(an_attestation_with_url_evidence_is_copied) :-
    Attested = attested(true, attestation(host_service, attested_moment, stated_reason, url(source_address, retrieved_moment))),
    liability_for_the_entire_damage([attribute(responsible_under_article_82_2_and_3, Attested), attribute(other_responsible_parties, [])], no_other_responsible_party, Basis, _),
    Basis == [outside_fact(responsible_under_article_82_2_and_3, Attested)].
test(every_query_yields_exactly_one_solution) :-
    stated_responsibility(true, Attested),
    Profile = [attribute(responsible_under_article_82_2_and_3, Attested), attribute(other_responsible_parties, [controller_alpha]), attribute(full_compensation_paid, true), attribute(controllers_jointly_determine_purposes_and_means, true)],
    findall(Result - Citations, rights_against_each_joint_controller(Profile, Result, Citations), RightsAnswers),
    length(RightsAnswers, 1),
    findall(Result - Basis - Citations, liability_for_the_entire_damage(Profile, Result, Basis, Citations), LiabilityAnswers),
    length(LiabilityAnswers, 1),
    findall(Result - Basis - Citations, recourse_after_full_compensation(Profile, Result, Basis, Citations), RecourseAnswers),
    length(RecourseAnswers, 1).
test(a_malformed_profile_yields_exactly_one_solution) :-
    findall(Result - Basis - Citations, recourse_after_full_compensation(not_a_profile, Result, Basis, Citations), Answers),
    Answers == [input_problems([wrong_type(profile)]) - [] - []].
test(the_verdict_is_eligible_for_a_claim_back) :-
    stated_responsibility(true, Attested),
    gdpr_joint_controllers_status([attribute(responsible_under_article_82_2_and_3, Attested), attribute(other_responsible_parties, [controller_alpha]), attribute(full_compensation_paid, true)], eligible).
test(the_verdict_is_ineligible_without_full_payment) :-
    stated_responsibility(true, Attested),
    gdpr_joint_controllers_status([attribute(responsible_under_article_82_2_and_3, Attested), attribute(other_responsible_parties, [controller_alpha]), attribute(full_compensation_paid, false)], ineligible).
test(the_verdict_is_indeterminate_without_input) :-
    decide_gdpr_joint_controllers([], gdpr_joint_controllers_verdict(indeterminate, [])).
test(the_checklist_has_one_cited_row_per_condition) :-
    stated_responsibility(true, Attested),
    gdpr_joint_controllers_checklist([attribute(responsible_under_article_82_2_and_3, Attested), attribute(other_responsible_parties, [])], Items),
    Items == [item(responsible_under_article_82, met, cite(eu_reg_2016_679_art_82_4)), item(other_responsible_party_listed, unmet(no_other_responsible_party), cite(eu_reg_2016_679_art_82_4)), item(full_compensation_paid, unknown([full_compensation_paid]), cite(eu_reg_2016_679_art_82_5))].

test(a_joint_controller_is_not_answered_not_joint, fail) :-
    rights_against_each_joint_controller([attribute(controllers_jointly_determine_purposes_and_means, true)], not_joint_controllers, _).
test(full_compensation_by_a_responsible_party_is_not_refused, fail) :-
    stated_responsibility(true, Attested),
    recourse_after_full_compensation([attribute(responsible_under_article_82_2_and_3, Attested), attribute(other_responsible_parties, [processor_beta]), attribute(full_compensation_paid, true)], not_entitled_to_claim_back, _, _).
test(the_verdict_without_input_is_not_eligible, fail) :-
    gdpr_joint_controllers_status([], eligible).
