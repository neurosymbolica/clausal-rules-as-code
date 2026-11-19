% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_consent_conditions_gdpr_consent_conditions, [decide_gdpr_consent_conditions/2, gdpr_consent_conditions_status/2, gdpr_consent_conditions_checklist/2, gdpr_consent_conditions_decision_resolvable/1, gdpr_consent_conditions_status_values/1, consent_conditions_status/4, consent_declaration_effect/3, consent_assessment_factors/2, identification_obligation/4, identification_information_duty/4, identification_rights_effect/4]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_consent_conditions_kernel, [gdpr_consent_conditions_input_problems/2, outside_fact_limb/4, crisp_limb/3]).
:- use_module(m__eu_data_protection_gdpr_consent_conditions_citations, [implements/1, outside_fact_entry/3]).

gdpr_consent_conditions_status_values([not_applicable, conditions_met, conditions_not_met]).

consent_limb(demonstration, cite(eu_reg_2016_679_art_7_1)).
consent_limb(request_presentation, cite(eu_reg_2016_679_art_7_2)).
consent_limb(withdrawal, cite(eu_reg_2016_679_art_7_3)).
consent_limb(freely_given, cite(eu_reg_2016_679_art_7_4)).

absent_referral(Key, cross_reference_unresolved(cite(Citation), cite(Target)), [resolution(cite(Target), not_attempted), inputs_relied_on([Key - absent])]) :-
    outside_fact_entry(Key, cite(Citation), cite(Target)).

single_fact_evaluation(met, Key, Attested, met([outside_fact(Key, Attested)])).
single_fact_evaluation(unmet, Key, Attested, unmet([outside_fact(Key, Attested)])).
single_fact_evaluation(absent, Key, _, open([], [Key])).

consent_conditions_status(Profile, Status, Basis, Citations) :-
    gdpr_consent_conditions_input_problems(Profile, Problems),
    consent_conditions_answer(Problems, Profile, Status, Basis, Citations).

consent_conditions_answer([Problem|Problems], _, input_problems([Problem|Problems]), [], []).
consent_conditions_answer([], Profile, Status, Basis, Citations) :-
    crisp_limb(Profile, processing_based_on_consent, ScopeLimb),
    consent_scope_answer(ScopeLimb, Profile, Status, Basis, Citations).

consent_scope_answer(absent, _, indeterminate([processing_based_on_consent]), [], []) :-
    implements(eu_reg_2016_679_art_7_1).
consent_scope_answer(unmet, _, not_applicable, [], []) :-
    implements(eu_reg_2016_679_art_7_1).
consent_scope_answer(met, Profile, Status, Basis, Citations) :-
    implements(eu_reg_2016_679_art_7_1),
    consent_limbs_assessed(Profile, Assessed),
    consent_limb_lists(Assessed, Lists),
    consent_conditions_outcome(Lists, Status, Basis, Citations).

consent_limbs_assessed(Profile, Assessed) :-
    findall(Limb - Citation, consent_limb(Limb, Citation), Limbs),
    maplist(assess_consent_limb(Profile), Limbs, Assessed).

assess_consent_limb(Profile, Limb - Citation, assessed(Limb, Citation, Evaluation)) :-
    consent_limb_evaluation(Limb, Profile, Evaluation).

consent_limb_evaluation(demonstration, Profile, Evaluation) :-
    implements(eu_reg_2016_679_art_7_1),
    outside_fact_limb(Profile, consent_demonstrable, Limb, Attested),
    single_fact_evaluation(Limb, consent_demonstrable, Attested, Evaluation).
consent_limb_evaluation(request_presentation, Profile, Evaluation) :-
    implements(eu_reg_2016_679_art_7_2),
    crisp_limb(Profile, consent_in_declaration_with_other_matters, DeclarationLimb),
    request_presentation_evaluation(DeclarationLimb, Profile, Evaluation).
consent_limb_evaluation(withdrawal, Profile, Evaluation) :-
    implements(eu_reg_2016_679_art_7_3),
    implements(withdrawal_ease_statement),
    crisp_limb(Profile, informed_of_withdrawal_right_before_consent, InformedLimb),
    outside_fact_limb(Profile, withdrawal_as_easy_as_giving_consent, EaseLimb, Attested),
    withdrawal_evaluation(InformedLimb, EaseLimb, Attested, Evaluation).
consent_limb_evaluation(freely_given, Profile, Evaluation) :-
    implements(eu_reg_2016_679_art_7_4),
    implements(consent_freely_given_statement),
    outside_fact_limb(Profile, consent_freely_given, Limb, Attested),
    single_fact_evaluation(Limb, consent_freely_given, Attested, Evaluation).

request_presentation_evaluation(unmet, _, inapplicable) :-
    implements(eu_reg_2016_679_art_7_2).
request_presentation_evaluation(absent, _, open([consent_in_declaration_with_other_matters], [])) :-
    implements(eu_reg_2016_679_art_7_2).
request_presentation_evaluation(met, Profile, Evaluation) :-
    implements(eu_reg_2016_679_art_7_2),
    implements(consent_request_presentation_statement),
    outside_fact_limb(Profile, request_clearly_distinguishable_and_intelligible, Limb, Attested),
    single_fact_evaluation(Limb, request_clearly_distinguishable_and_intelligible, Attested, Evaluation).

withdrawal_evaluation(unmet, unmet, Attested, unmet([outside_fact(withdrawal_as_easy_as_giving_consent, Attested)])) :-
    implements(eu_reg_2016_679_art_7_3).
withdrawal_evaluation(unmet, met, _, unmet([])) :-
    implements(eu_reg_2016_679_art_7_3).
withdrawal_evaluation(unmet, absent, _, unmet([])) :-
    implements(eu_reg_2016_679_art_7_3).
withdrawal_evaluation(met, unmet, Attested, unmet([outside_fact(withdrawal_as_easy_as_giving_consent, Attested)])) :-
    implements(eu_reg_2016_679_art_7_3).
withdrawal_evaluation(absent, unmet, Attested, unmet([outside_fact(withdrawal_as_easy_as_giving_consent, Attested)])) :-
    implements(eu_reg_2016_679_art_7_3).
withdrawal_evaluation(met, met, Attested, met([outside_fact(withdrawal_as_easy_as_giving_consent, Attested)])) :-
    implements(eu_reg_2016_679_art_7_3).
withdrawal_evaluation(met, absent, _, open([], [withdrawal_as_easy_as_giving_consent])) :-
    implements(eu_reg_2016_679_art_7_3).
withdrawal_evaluation(absent, met, _, open([informed_of_withdrawal_right_before_consent], [])) :-
    implements(eu_reg_2016_679_art_7_3).
withdrawal_evaluation(absent, absent, _, open([informed_of_withdrawal_right_before_consent], [withdrawal_as_easy_as_giving_consent])) :-
    implements(eu_reg_2016_679_art_7_3).

consent_limb_lists(Assessed, lists(UnmetCitations, UnmetBasis, MissingKeys, AbsentKeys, MetCitations, MetBasis)) :-
    findall(Citation, member(assessed(_, Citation, unmet(_)), Assessed), UnmetCitations),
    findall(Items, member(assessed(_, _, unmet(Items)), Assessed), UnmetBasisLists),
    append(UnmetBasisLists, UnmetBasis),
    findall(Keys, member(assessed(_, _, open(Keys, _)), Assessed), MissingLists),
    append(MissingLists, MissingKeys),
    findall(Keys, member(assessed(_, _, open(_, Keys)), Assessed), AbsentLists),
    append(AbsentLists, AbsentKeys),
    findall(Citation, member(assessed(_, Citation, met(_)), Assessed), MetCitations),
    findall(Items, member(assessed(_, _, met(Items)), Assessed), MetBasisLists),
    append(MetBasisLists, MetBasis).

consent_conditions_outcome(lists([Citation|Citations], UnmetBasis, _, _, _, _), conditions_not_met, UnmetBasis, [Citation|Citations]) :-
    implements(eu_reg_2016_679_art_7_1).
consent_conditions_outcome(lists([], _, [MissingKey|MissingKeys], _, _, _), indeterminate([MissingKey|MissingKeys]), [], []) :-
    implements(eu_reg_2016_679_art_7_1).
consent_conditions_outcome(lists([], _, [], [AbsentKey|_], _, _), needs_legal_review(Reason, Context), [], []) :-
    implements(eu_reg_2016_679_art_7_1),
    absent_referral(AbsentKey, Reason, Context).
consent_conditions_outcome(lists([], _, [], [], MetCitations, MetBasis), conditions_met, MetBasis, MetCitations) :-
    implements(eu_reg_2016_679_art_7_1).

consent_declaration_effect(Profile, Status, Citations) :-
    gdpr_consent_conditions_input_problems(Profile, Problems),
    declaration_effect_answer(Problems, Profile, Status, Citations).

declaration_effect_answer([Problem|Problems], _, input_problems([Problem|Problems]), []).
declaration_effect_answer([], Profile, Status, Citations) :-
    crisp_limb(Profile, consent_in_declaration_with_other_matters, DeclarationLimb),
    declaration_effect_by_declaration(DeclarationLimb, Profile, Status, Citations).

declaration_effect_by_declaration(absent, _, indeterminate([consent_in_declaration_with_other_matters]), []) :-
    implements(eu_reg_2016_679_art_7_2).
declaration_effect_by_declaration(unmet, _, not_applicable, []) :-
    implements(eu_reg_2016_679_art_7_2).
declaration_effect_by_declaration(met, Profile, Status, Citations) :-
    implements(eu_reg_2016_679_art_7_2),
    crisp_limb(Profile, declaration_part_infringes_regulation, InfringementLimb),
    declaration_effect_by_infringement(InfringementLimb, Status, Citations).

declaration_effect_by_infringement(absent, indeterminate([declaration_part_infringes_regulation]), []) :-
    implements(eu_reg_2016_679_art_7_2).
declaration_effect_by_infringement(met, part_not_binding, [cite(eu_reg_2016_679_art_7_2)]) :-
    implements(eu_reg_2016_679_art_7_2).
declaration_effect_by_infringement(unmet, no_part_infringing, [cite(eu_reg_2016_679_art_7_2)]) :-
    implements(eu_reg_2016_679_art_7_2).

consent_assessment_factors(Profile, Factors) :-
    gdpr_consent_conditions_input_problems(Profile, Problems),
    assessment_factors_answer(Problems, Profile, Factors).

assessment_factors_answer([Problem|Problems], _, input_problems([Problem|Problems])).
assessment_factors_answer([], Profile, Factors) :-
    crisp_limb(Profile, contract_conditional_on_unneeded_consent, FactorLimb),
    assessment_factors_outcome(FactorLimb, Factors).

assessment_factors_outcome(absent, indeterminate([contract_conditional_on_unneeded_consent])) :-
    implements(eu_reg_2016_679_art_7_4).
assessment_factors_outcome(met, [factor(contract_conditional_on_unneeded_consent, cite(eu_reg_2016_679_art_7_4))]) :-
    implements(eu_reg_2016_679_art_7_4).
assessment_factors_outcome(unmet, []) :-
    implements(eu_reg_2016_679_art_7_4).

identification_obligation(Profile, Status, Basis, Citations) :-
    gdpr_consent_conditions_input_problems(Profile, Problems),
    identification_obligation_answer(Problems, Profile, Status, Basis, Citations).

identification_obligation_answer([Problem|Problems], _, input_problems([Problem|Problems]), [], []).
identification_obligation_answer([], Profile, Status, Basis, Citations) :-
    outside_fact_limb(Profile, purposes_do_not_require_identification, Limb, Attested),
    identification_obligation_outcome(Limb, Attested, Status, Basis, Citations).

identification_obligation_outcome(absent, _, needs_legal_review(Reason, Context), [], []) :-
    implements(eu_reg_2016_679_art_11_1),
    absent_referral(purposes_do_not_require_identification, Reason, Context).
identification_obligation_outcome(met, Attested, not_obliged_to_acquire_identifying_information, [outside_fact(purposes_do_not_require_identification, Attested)], [cite(eu_reg_2016_679_art_11_1)]) :-
    implements(eu_reg_2016_679_art_11_1).
identification_obligation_outcome(unmet, Attested, art11_1_not_engaged, [outside_fact(purposes_do_not_require_identification, Attested)], [cite(eu_reg_2016_679_art_11_1)]) :-
    implements(eu_reg_2016_679_art_11_1).

art11_2_engagement(Profile, Engagement) :-
    implements(eu_reg_2016_679_art_11_2),
    implements(inability_to_identify_statement),
    outside_fact_limb(Profile, purposes_do_not_require_identification, PurposesLimb, PurposesAttested),
    outside_fact_limb(Profile, able_to_demonstrate_not_in_position_to_identify, InabilityLimb, InabilityAttested),
    engagement_of(PurposesLimb, PurposesAttested, InabilityLimb, InabilityAttested, Engagement).

engagement_of(unmet, PurposesAttested, unmet, InabilityAttested, not_engaged([outside_fact(purposes_do_not_require_identification, PurposesAttested), outside_fact(able_to_demonstrate_not_in_position_to_identify, InabilityAttested)])) :-
    implements(eu_reg_2016_679_art_11_2).
engagement_of(unmet, PurposesAttested, met, _, not_engaged([outside_fact(purposes_do_not_require_identification, PurposesAttested)])) :-
    implements(eu_reg_2016_679_art_11_2).
engagement_of(unmet, PurposesAttested, absent, _, not_engaged([outside_fact(purposes_do_not_require_identification, PurposesAttested)])) :-
    implements(eu_reg_2016_679_art_11_2).
engagement_of(met, _, unmet, InabilityAttested, not_engaged([outside_fact(able_to_demonstrate_not_in_position_to_identify, InabilityAttested)])) :-
    implements(eu_reg_2016_679_art_11_2).
engagement_of(absent, _, unmet, InabilityAttested, not_engaged([outside_fact(able_to_demonstrate_not_in_position_to_identify, InabilityAttested)])) :-
    implements(eu_reg_2016_679_art_11_2).
engagement_of(met, PurposesAttested, met, InabilityAttested, engaged([outside_fact(purposes_do_not_require_identification, PurposesAttested), outside_fact(able_to_demonstrate_not_in_position_to_identify, InabilityAttested)])) :-
    implements(eu_reg_2016_679_art_11_2).
engagement_of(met, _, absent, _, open([able_to_demonstrate_not_in_position_to_identify])) :-
    implements(eu_reg_2016_679_art_11_2).
engagement_of(absent, _, met, _, open([purposes_do_not_require_identification])) :-
    implements(eu_reg_2016_679_art_11_2).
engagement_of(absent, _, absent, _, open([purposes_do_not_require_identification, able_to_demonstrate_not_in_position_to_identify])) :-
    implements(eu_reg_2016_679_art_11_2).

identification_information_duty(Profile, Status, Basis, Citations) :-
    gdpr_consent_conditions_input_problems(Profile, Problems),
    information_duty_answer(Problems, Profile, Status, Basis, Citations).

information_duty_answer([Problem|Problems], _, input_problems([Problem|Problems]), [], []).
information_duty_answer([], Profile, Status, Basis, Citations) :-
    art11_2_engagement(Profile, Engagement),
    information_duty_outcome(Engagement, Profile, Status, Basis, Citations).

information_duty_outcome(not_engaged(Basis), _, art11_2_not_engaged, Basis, [cite(eu_reg_2016_679_art_11_2)]) :-
    implements(eu_reg_2016_679_art_11_2).
information_duty_outcome(open([AbsentKey|_]), _, needs_legal_review(Reason, Context), [], []) :-
    implements(eu_reg_2016_679_art_11_2),
    absent_referral(AbsentKey, Reason, Context).
information_duty_outcome(engaged(Basis), Profile, Status, FullBasis, Citations) :-
    implements(eu_reg_2016_679_art_11_2),
    implements(informing_possible_statement),
    outside_fact_limb(Profile, informing_data_subject_possible, Limb, Attested),
    informing_outcome(Limb, Attested, Basis, Status, FullBasis, Citations).

informing_outcome(absent, _, _, needs_legal_review(Reason, Context), [], []) :-
    implements(eu_reg_2016_679_art_11_2),
    absent_referral(informing_data_subject_possible, Reason, Context).
informing_outcome(met, Attested, Basis, must_inform_data_subject, FullBasis, [cite(eu_reg_2016_679_art_11_2)]) :-
    implements(eu_reg_2016_679_art_11_2),
    append(Basis, [outside_fact(informing_data_subject_possible, Attested)], FullBasis).
informing_outcome(unmet, Attested, Basis, need_not_inform_data_subject, FullBasis, [cite(eu_reg_2016_679_art_11_2)]) :-
    implements(eu_reg_2016_679_art_11_2),
    append(Basis, [outside_fact(informing_data_subject_possible, Attested)], FullBasis).

identification_rights_effect(Profile, Status, Basis, Citations) :-
    gdpr_consent_conditions_input_problems(Profile, Problems),
    rights_effect_answer(Problems, Profile, Status, Basis, Citations).

rights_effect_answer([Problem|Problems], _, input_problems([Problem|Problems]), [], []).
rights_effect_answer([], Profile, Status, Basis, Citations) :-
    art11_2_engagement(Profile, Engagement),
    rights_effect_outcome(Engagement, Profile, Status, Basis, Citations).

rights_effect_outcome(not_engaged(Basis), _, art11_2_not_engaged, Basis, [cite(eu_reg_2016_679_art_11_2)]) :-
    implements(eu_reg_2016_679_art_11_2).
rights_effect_outcome(open(AbsentKeys), Profile, Status, Basis, Citations) :-
    implements(eu_reg_2016_679_art_11_2),
    crisp_limb(Profile, additional_identifying_information_provided, InformationLimb),
    open_rights_outcome(InformationLimb, AbsentKeys, Status, Basis, Citations).
rights_effect_outcome(engaged(Basis), Profile, Status, FullBasis, Citations) :-
    implements(eu_reg_2016_679_art_11_2),
    crisp_limb(Profile, additional_identifying_information_provided, InformationLimb),
    engaged_rights_outcome(InformationLimb, Basis, Status, FullBasis, Citations).

open_rights_outcome(absent, _, indeterminate([additional_identifying_information_provided]), [], []) :-
    implements(eu_reg_2016_679_art_11_2).
open_rights_outcome(met, [AbsentKey|_], needs_legal_review(Reason, Context), [], []) :-
    implements(eu_reg_2016_679_art_11_2),
    absent_referral(AbsentKey, Reason, Context).
open_rights_outcome(unmet, [AbsentKey|_], needs_legal_review(Reason, Context), [], []) :-
    implements(eu_reg_2016_679_art_11_2),
    absent_referral(AbsentKey, Reason, Context).

engaged_rights_outcome(absent, _, indeterminate([additional_identifying_information_provided]), [], []) :-
    implements(eu_reg_2016_679_art_11_2).
engaged_rights_outcome(met, Basis, articles_15_to_20_apply, Basis, [cite(eu_reg_2016_679_art_11_2)]) :-
    implements(eu_reg_2016_679_art_11_2).
engaged_rights_outcome(unmet, Basis, articles_15_to_20_do_not_apply, Basis, [cite(eu_reg_2016_679_art_11_2)]) :-
    implements(eu_reg_2016_679_art_11_2).

decide_gdpr_consent_conditions(Profile, gdpr_consent_conditions_verdict(Status, Citations)) :-
    consent_conditions_status(Profile, Status, _, Citations).

gdpr_consent_conditions_status(Profile, Status) :-
    decide_gdpr_consent_conditions(Profile, gdpr_consent_conditions_verdict(Status, _)).

gdpr_consent_conditions_checklist(Profile, Items) :-
    gdpr_consent_conditions_input_problems(Profile, Problems),
    checklist_for(Problems, Profile, Items).

checklist_for([Problem|Problems], _, [item(input_check, unmet(input_problems([Problem|Problems])), cite(eu_reg_2016_679_art_7_1))]).
checklist_for([], Profile, [ScopeItem|LimbItems]) :-
    crisp_limb(Profile, processing_based_on_consent, ScopeLimb),
    scope_item(ScopeLimb, ScopeItem),
    consent_limbs_assessed(Profile, Assessed),
    maplist(limb_item, Assessed, LimbItems).

scope_item(met, item(scope, met, cite(eu_reg_2016_679_art_7_1))) :-
    implements(eu_reg_2016_679_art_7_1).
scope_item(unmet, item(scope, inapplicable, cite(eu_reg_2016_679_art_7_1))) :-
    implements(eu_reg_2016_679_art_7_1).
scope_item(absent, item(scope, unknown([processing_based_on_consent]), cite(eu_reg_2016_679_art_7_1))) :-
    implements(eu_reg_2016_679_art_7_1).

limb_item(assessed(Limb, Citation, met(_)), item(Limb, met, Citation)).
limb_item(assessed(Limb, Citation, unmet(_)), item(Limb, unmet(condition_not_met), Citation)).
limb_item(assessed(Limb, Citation, inapplicable), item(Limb, inapplicable, Citation)).
limb_item(assessed(Limb, Citation, open(MissingKeys, AbsentKeys)), item(Limb, unknown(Keys), Citation)) :-
    append(MissingKeys, AbsentKeys, Keys).

gdpr_consent_conditions_decision_resolvable(Profile) :-
    decide_gdpr_consent_conditions(Profile, _).

true_statement(attested(true, attestation(by, at, reason, none))).

false_statement(attested(false, attestation(by, at, reason, none))).

all_met_consent_profile(Profile) :-
    true_statement(Yes),
    Profile = [attribute(processing_based_on_consent, true), attribute(consent_demonstrable, Yes), attribute(consent_in_declaration_with_other_matters, false), attribute(informed_of_withdrawal_right_before_consent, true), attribute(withdrawal_as_easy_as_giving_consent, Yes), attribute(consent_freely_given, Yes)].

test(all_limbs_met_gives_conditions_met) :-
    all_met_consent_profile(Profile),
    true_statement(Yes),
    consent_conditions_status(Profile, conditions_met, Basis, Citations),
    Basis == [outside_fact(consent_demonstrable, Yes), outside_fact(withdrawal_as_easy_as_giving_consent, Yes), outside_fact(consent_freely_given, Yes)],
    Citations == [cite(eu_reg_2016_679_art_7_1), cite(eu_reg_2016_679_art_7_3), cite(eu_reg_2016_679_art_7_4)].
test(the_consent_status_yields_one_solution) :-
    all_met_consent_profile(Profile),
    findall(Status - Basis - Citations, consent_conditions_status(Profile, Status, Basis, Citations), Answers),
    length(Answers, 1).
test(a_declaration_with_other_matters_adds_article_7_2) :-
    true_statement(Yes),
    consent_conditions_status([attribute(processing_based_on_consent, true), attribute(consent_demonstrable, Yes), attribute(consent_in_declaration_with_other_matters, true), attribute(request_clearly_distinguishable_and_intelligible, Yes), attribute(informed_of_withdrawal_right_before_consent, true), attribute(withdrawal_as_easy_as_giving_consent, Yes), attribute(consent_freely_given, Yes)], conditions_met, Basis, Citations),
    length(Basis, 4),
    Citations == [cite(eu_reg_2016_679_art_7_1), cite(eu_reg_2016_679_art_7_2), cite(eu_reg_2016_679_art_7_3), cite(eu_reg_2016_679_art_7_4)].
test(a_false_statement_decides_before_absent_keys) :-
    false_statement(No),
    consent_conditions_status([attribute(processing_based_on_consent, true), attribute(consent_demonstrable, No)], conditions_not_met, [outside_fact(consent_demonstrable, No)], [cite(eu_reg_2016_679_art_7_1)]).
test(not_informed_of_withdrawal_fails_article_7_3_with_empty_basis) :-
    all_met_consent_profile(Base),
    Profile = [attribute(informed_of_withdrawal_right_before_consent, false)|Rest],
    select(attribute(informed_of_withdrawal_right_before_consent, true), Base, Rest),
    consent_conditions_status(Profile, conditions_not_met, [], [cite(eu_reg_2016_679_art_7_3)]).
test(not_freely_given_fails_article_7_4) :-
    all_met_consent_profile(Base),
    false_statement(No),
    true_statement(Yes),
    select(attribute(consent_freely_given, Yes), Base, Rest),
    consent_conditions_status([attribute(consent_freely_given, No)|Rest], conditions_not_met, [outside_fact(consent_freely_given, No)], [cite(eu_reg_2016_679_art_7_4)]).
test(absent_scope_is_indeterminate) :-
    consent_conditions_status([], indeterminate([processing_based_on_consent]), [], []).
test(processing_not_based_on_consent_is_not_applicable) :-
    consent_conditions_status([attribute(processing_based_on_consent, false)], not_applicable, [], []).
test(every_absent_needed_crisp_key_is_named) :-
    true_statement(Yes),
    consent_conditions_status([attribute(processing_based_on_consent, true), attribute(consent_demonstrable, Yes), attribute(withdrawal_as_easy_as_giving_consent, Yes), attribute(consent_freely_given, Yes)], indeterminate([consent_in_declaration_with_other_matters, informed_of_withdrawal_right_before_consent]), [], []).
test(an_absent_demonstration_statement_refers) :-
    all_met_consent_profile(Base),
    true_statement(Yes),
    select(attribute(consent_demonstrable, Yes), Base, Profile),
    consent_conditions_status(Profile, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_7_1), cite(consent_demonstration_statement)), [resolution(cite(consent_demonstration_statement), not_attempted), inputs_relied_on([consent_demonstrable - absent])]), [], []).
test(input_problems_come_first) :-
    consent_conditions_status([attribute(colour, red)], input_problems([unknown_key(colour)]), [], []).
test(an_infringing_part_is_not_binding) :-
    consent_declaration_effect([attribute(consent_in_declaration_with_other_matters, true), attribute(declaration_part_infringes_regulation, true)], part_not_binding, [cite(eu_reg_2016_679_art_7_2)]).
test(no_declaration_with_other_matters_is_not_applicable) :-
    consent_declaration_effect([attribute(consent_in_declaration_with_other_matters, false)], not_applicable, []).
test(the_factor_is_reported) :-
    consent_assessment_factors([attribute(contract_conditional_on_unneeded_consent, true)], [factor(contract_conditional_on_unneeded_consent, cite(eu_reg_2016_679_art_7_4))]).
test(an_absent_factor_is_indeterminate) :-
    consent_assessment_factors([], indeterminate([contract_conditional_on_unneeded_consent])).
test(factors_report_input_problems) :-
    consent_assessment_factors([attribute(colour, red)], input_problems([unknown_key(colour)])).
test(identification_not_required_relieves_the_obligation) :-
    true_statement(Yes),
    identification_obligation([attribute(purposes_do_not_require_identification, Yes)], not_obliged_to_acquire_identifying_information, [outside_fact(purposes_do_not_require_identification, Yes)], [cite(eu_reg_2016_679_art_11_1)]).
test(an_absent_identification_statement_refers) :-
    identification_obligation([], needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_11_1), cite(identification_not_required_statement)), [resolution(cite(identification_not_required_statement), not_attempted), inputs_relied_on([purposes_do_not_require_identification - absent])]), [], []).
test(engaged_and_informing_impossible_need_not_inform) :-
    true_statement(Yes),
    false_statement(No),
    identification_information_duty([attribute(purposes_do_not_require_identification, Yes), attribute(able_to_demonstrate_not_in_position_to_identify, Yes), attribute(informing_data_subject_possible, No)], need_not_inform_data_subject, [outside_fact(purposes_do_not_require_identification, Yes), outside_fact(able_to_demonstrate_not_in_position_to_identify, Yes), outside_fact(informing_data_subject_possible, No)], [cite(eu_reg_2016_679_art_11_2)]).
test(a_false_engagement_fact_decides_before_an_absent_one) :-
    false_statement(No),
    identification_rights_effect([attribute(able_to_demonstrate_not_in_position_to_identify, No)], art11_2_not_engaged, [outside_fact(able_to_demonstrate_not_in_position_to_identify, No)], [cite(eu_reg_2016_679_art_11_2)]).
test(the_missing_crisp_key_is_named_before_the_referral) :-
    true_statement(Yes),
    identification_rights_effect([attribute(able_to_demonstrate_not_in_position_to_identify, Yes)], indeterminate([additional_identifying_information_provided]), [], []).
test(with_the_crisp_key_present_the_absent_fact_refers) :-
    true_statement(Yes),
    identification_rights_effect([attribute(able_to_demonstrate_not_in_position_to_identify, Yes), attribute(additional_identifying_information_provided, true)], needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_11_1), cite(identification_not_required_statement)), [resolution(cite(identification_not_required_statement), not_attempted), inputs_relied_on([purposes_do_not_require_identification - absent])]), [], []).
test(identifying_information_provided_restores_articles_15_to_20) :-
    true_statement(Yes),
    identification_rights_effect([attribute(purposes_do_not_require_identification, Yes), attribute(able_to_demonstrate_not_in_position_to_identify, Yes), attribute(additional_identifying_information_provided, true)], articles_15_to_20_apply, [outside_fact(purposes_do_not_require_identification, Yes), outside_fact(able_to_demonstrate_not_in_position_to_identify, Yes)], [cite(eu_reg_2016_679_art_11_2)]).
test(no_identifying_information_disapplies_articles_15_to_20) :-
    true_statement(Yes),
    identification_rights_effect([attribute(purposes_do_not_require_identification, Yes), attribute(able_to_demonstrate_not_in_position_to_identify, Yes), attribute(additional_identifying_information_provided, false)], articles_15_to_20_do_not_apply, _, _).
test(the_rights_effect_yields_one_solution) :-
    findall(Status, identification_rights_effect([], Status, _, _), Answers),
    Answers == [indeterminate([additional_identifying_information_provided])].
test(the_facade_verdict_projects_the_status) :-
    all_met_consent_profile(Profile),
    decide_gdpr_consent_conditions(Profile, gdpr_consent_conditions_verdict(conditions_met, _)),
    gdpr_consent_conditions_status(Profile, conditions_met).
test(the_checklist_cites_every_row) :-
    all_met_consent_profile(Profile),
    gdpr_consent_conditions_checklist(Profile, Items),
    Items == [item(scope, met, cite(eu_reg_2016_679_art_7_1)), item(demonstration, met, cite(eu_reg_2016_679_art_7_1)), item(request_presentation, inapplicable, cite(eu_reg_2016_679_art_7_2)), item(withdrawal, met, cite(eu_reg_2016_679_art_7_3)), item(freely_given, met, cite(eu_reg_2016_679_art_7_4))].
test(the_decision_is_resolvable) :-
    gdpr_consent_conditions_decision_resolvable([]).

test(all_limbs_met_is_not_conditions_not_met, fail) :-
    all_met_consent_profile(Profile),
    consent_conditions_status(Profile, conditions_not_met, _, _).
test(an_infringing_part_is_not_no_part_infringing, fail) :-
    consent_declaration_effect([attribute(consent_in_declaration_with_other_matters, true), attribute(declaration_part_infringes_regulation, true)], no_part_infringing, _).
test(engaged_and_informing_impossible_is_not_must_inform, fail) :-
    true_statement(Yes),
    false_statement(No),
    identification_information_duty([attribute(purposes_do_not_require_identification, Yes), attribute(able_to_demonstrate_not_in_position_to_identify, Yes), attribute(informing_data_subject_possible, No)], must_inform_data_subject, _, _).
