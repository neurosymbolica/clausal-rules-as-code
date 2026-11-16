% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_common_definitions_data_and_processing_gdpr_common_definitions_data_and_processing, [decide_gdpr_common_definitions_data_and_processing/2, gdpr_common_definitions_data_and_processing_status/2, gdpr_common_definitions_data_and_processing_checklist/2, gdpr_common_definitions_data_and_processing_decision_resolvable/1, gdpr_common_definitions_data_and_processing_status_values/1, personal_data/2, processing/2, restriction_of_processing/2, profiling/2, pseudonymisation/2, filing_system/2, receiving_body_is_recipient/2, receiving_body_is_third_party/2, consent_elements/2, personal_data_breach/2, information_society_service/2, international_organisation/2, data_and_processing_outside_facts/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(formalize_lib, [profile_get/3, profile_lacks/2]).
:- use_module(m__eu_data_protection_gdpr_common_definitions_data_and_processing_kernel, [gdpr_common_definitions_data_and_processing_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_common_definitions_data_and_processing_citations, [implements/1]).

gdpr_common_definitions_data_and_processing_status_values([met, not_met, indeterminate, needs_legal_review, input_problems]).

root_keys([information_relates_to_natural_person, natural_person_identified, natural_person_identifiable, operation_performed_on_the_data, stored_data_marked_to_limit_future_processing, processing_automated, evaluates_personal_aspects_of_natural_person, attribution_needs_additional_information, additional_information_kept_separately, measures_prevent_attribution, structured_set_accessible_by_specific_criteria, data_disclosed_to_receiving_body, receiving_body_public_authority_in_particular_inquiry, receiving_body_is_data_subject, receiving_body_is_controller_or_processor, receiving_body_authorised_under_direct_authority, indication_freely_given, indication_specific, indication_informed, indication_unambiguous, agreement_by_statement_or_clear_affirmative_action, breach_of_security, breach_led_to_listed_outcome, service_is_information_society_service, organisation_governed_by_public_international_law, body_set_up_by_agreement_between_countries]).

consent_keys([indication_freely_given, indication_specific, indication_informed, indication_unambiguous, agreement_by_statement_or_clear_affirmative_action]).

relation_identifiers([personal_data, processing, restriction_of_processing, profiling, pseudonymisation, filing_system, receiving_body_is_recipient, receiving_body_is_third_party, consent_elements, personal_data_breach, information_society_service, international_organisation]).

referral(information_relates_to_natural_person, cite(eu_reg_2016_679_art_4_1), [information_relates_to_natural_person, natural_person_identified, natural_person_identifiable]).
referral(natural_person_identifiable, cite(eu_reg_2016_679_art_4_1), [information_relates_to_natural_person, natural_person_identified, natural_person_identifiable]).
referral(evaluates_personal_aspects_of_natural_person, cite(eu_reg_2016_679_art_4_4), [processing_automated, evaluates_personal_aspects_of_natural_person]).
referral(attribution_needs_additional_information, cite(eu_reg_2016_679_art_4_5), [attribution_needs_additional_information, additional_information_kept_separately, measures_prevent_attribution]).
referral(measures_prevent_attribution, cite(eu_reg_2016_679_art_4_5), [attribution_needs_additional_information, additional_information_kept_separately, measures_prevent_attribution]).
referral(structured_set_accessible_by_specific_criteria, cite(eu_reg_2016_679_art_4_6), [structured_set_accessible_by_specific_criteria]).
referral(indication_freely_given, cite(eu_reg_2016_679_art_4_11), [indication_freely_given, indication_specific, indication_informed, indication_unambiguous, agreement_by_statement_or_clear_affirmative_action]).
referral(indication_specific, cite(eu_reg_2016_679_art_4_11), [indication_freely_given, indication_specific, indication_informed, indication_unambiguous, agreement_by_statement_or_clear_affirmative_action]).
referral(indication_informed, cite(eu_reg_2016_679_art_4_11), [indication_freely_given, indication_specific, indication_informed, indication_unambiguous, agreement_by_statement_or_clear_affirmative_action]).
referral(indication_unambiguous, cite(eu_reg_2016_679_art_4_11), [indication_freely_given, indication_specific, indication_informed, indication_unambiguous, agreement_by_statement_or_clear_affirmative_action]).
referral(agreement_by_statement_or_clear_affirmative_action, cite(eu_reg_2016_679_art_4_11), [indication_freely_given, indication_specific, indication_informed, indication_unambiguous, agreement_by_statement_or_clear_affirmative_action]).
referral(breach_of_security, cite(eu_reg_2016_679_art_4_12), [breach_of_security, breach_led_to_listed_outcome]).

referral_outside(service_is_information_society_service, cite(eu_reg_2016_679_art_4_25), cite(eu_dir_2015_1535_art_1_1_b), []).
referral_outside(organisation_governed_by_public_international_law, cite(eu_reg_2016_679_art_4_26), cite(public_international_law_governing_organisation), [body_set_up_by_agreement_between_countries]).

personal_data_formula(and([key(information_relates_to_natural_person), or([key(natural_person_identified), key(natural_person_identifiable)])])) :-
    implements(eu_reg_2016_679_art_4_1).

processing_formula(and([PersonalData, key(operation_performed_on_the_data)])) :-
    implements(eu_reg_2016_679_art_4_2),
    personal_data_formula(PersonalData).

relation_formula(personal_data, Formula, eu_reg_2016_679_art_4_1) :-
    implements(eu_reg_2016_679_art_4_1),
    personal_data_formula(Formula).
relation_formula(processing, Formula, eu_reg_2016_679_art_4_2) :-
    implements(eu_reg_2016_679_art_4_2),
    processing_formula(Formula).
relation_formula(restriction_of_processing, and([PersonalData, key(stored_data_marked_to_limit_future_processing)]), eu_reg_2016_679_art_4_3) :-
    implements(eu_reg_2016_679_art_4_3),
    personal_data_formula(PersonalData).
relation_formula(profiling, and([Processing, key(processing_automated), key(evaluates_personal_aspects_of_natural_person)]), eu_reg_2016_679_art_4_4) :-
    implements(eu_reg_2016_679_art_4_4),
    processing_formula(Processing).
relation_formula(pseudonymisation, and([Processing, key(attribution_needs_additional_information), key(additional_information_kept_separately), key(measures_prevent_attribution)]), eu_reg_2016_679_art_4_5) :-
    implements(eu_reg_2016_679_art_4_5),
    processing_formula(Processing).
relation_formula(filing_system, and([PersonalData, key(structured_set_accessible_by_specific_criteria)]), eu_reg_2016_679_art_4_6) :-
    implements(eu_reg_2016_679_art_4_6),
    personal_data_formula(PersonalData).
relation_formula(receiving_body_is_recipient, and([PersonalData, key(data_disclosed_to_receiving_body), notkey(receiving_body_public_authority_in_particular_inquiry)]), eu_reg_2016_679_art_4_9) :-
    implements(eu_reg_2016_679_art_4_9),
    personal_data_formula(PersonalData).
relation_formula(receiving_body_is_third_party, and([notkey(receiving_body_is_data_subject), notkey(receiving_body_is_controller_or_processor), notkey(receiving_body_authorised_under_direct_authority)]), eu_reg_2016_679_art_4_10) :-
    implements(eu_reg_2016_679_art_4_10).
relation_formula(consent_elements, and([key(indication_freely_given), key(indication_specific), key(indication_informed), key(indication_unambiguous), key(agreement_by_statement_or_clear_affirmative_action)]), eu_reg_2016_679_art_4_11) :-
    implements(eu_reg_2016_679_art_4_11).
relation_formula(personal_data_breach, and([Processing, key(breach_of_security), key(breach_led_to_listed_outcome)]), eu_reg_2016_679_art_4_12) :-
    implements(eu_reg_2016_679_art_4_12),
    processing_formula(Processing).
relation_formula(information_society_service, outside(service_is_information_society_service), eu_reg_2016_679_art_4_25) :-
    implements(eu_reg_2016_679_art_4_25).
relation_formula(international_organisation, or([outside(organisation_governed_by_public_international_law), key(body_set_up_by_agreement_between_countries)]), eu_reg_2016_679_art_4_26) :-
    implements(eu_reg_2016_679_art_4_26).

key_state(Profile, Key, absent) :-
    profile_lacks(Profile, Key).
key_state(Profile, Key, Value) :-
    profile_get(Profile, Key, Value).

evaluate(Profile, key(Key), Outcome) :-
    key_state(Profile, Key, State),
    positive_outcome(State, Key, Outcome).
evaluate(Profile, notkey(Key), Outcome) :-
    key_state(Profile, Key, State),
    negative_outcome(State, Key, Outcome).
evaluate(Profile, outside(Key), Outcome) :-
    key_state(Profile, Key, State),
    outside_outcome(State, Key, Outcome).
evaluate(Profile, and(Children), Outcome) :-
    evaluate_all(Profile, Children, Outcomes),
    combine_and(Outcomes, Outcome).
evaluate(Profile, or(Children), Outcome) :-
    evaluate_all(Profile, Children, Outcomes),
    combine_or(Outcomes, Outcome).

evaluate_all(_, [], []).
evaluate_all(Profile, [Child|Children], [Outcome|Outcomes]) :-
    evaluate(Profile, Child, Outcome),
    evaluate_all(Profile, Children, Outcomes).

positive_outcome(absent, Key, outcome(open, [Key], [], [])).
positive_outcome(true, _, outcome(met, [], [], [])).
positive_outcome(false, _, outcome(unmet, [], [], [])).
positive_outcome(unsure, Key, outcome(open, [], [], [Key])).

negative_outcome(absent, Key, outcome(open, [Key], [], [])).
negative_outcome(true, _, outcome(unmet, [], [], [])).
negative_outcome(false, _, outcome(met, [], [], [])).
negative_outcome(unsure, Key, outcome(open, [], [], [Key])).

outside_outcome(absent, Key, outcome(open, [], [Key], [])).
outside_outcome(attested(true, _), _, outcome(met, [], [], [])).
outside_outcome(attested(false, _), _, outcome(unmet, [], [], [])).

outcome_values([], []).
outcome_values([outcome(Value, _, _, _)|Outcomes], [Value|Values]) :-
    outcome_values(Outcomes, Values).

combine_and(Outcomes, Outcome) :-
    outcome_values(Outcomes, Values),
    memberd_t(unmet, Values, HasUnmet),
    memberd_t(open, Values, HasOpen),
    and_outcome(HasUnmet, HasOpen, Outcomes, Outcome).

and_outcome(true, _, _, outcome(unmet, [], [], [])).
and_outcome(false, true, Outcomes, Outcome) :-
    merge_open(Outcomes, Outcome).
and_outcome(false, false, _, outcome(met, [], [], [])).

combine_or(Outcomes, Outcome) :-
    outcome_values(Outcomes, Values),
    memberd_t(met, Values, HasMet),
    memberd_t(open, Values, HasOpen),
    or_outcome(HasMet, HasOpen, Outcomes, Outcome).

or_outcome(true, _, _, outcome(met, [], [], [])).
or_outcome(false, true, Outcomes, Outcome) :-
    merge_open(Outcomes, Outcome).
or_outcome(false, false, _, outcome(unmet, [], [], [])).

merge_open([], outcome(open, [], [], [])).
merge_open([outcome(_, Missing, Outside, Unsure)|Outcomes], outcome(open, AllMissing, AllOutside, AllUnsure)) :-
    merge_open(Outcomes, outcome(open, RestMissing, RestOutside, RestUnsure)),
    append(Missing, RestMissing, AllMissing),
    append(Outside, RestOutside, AllOutside),
    append(Unsure, RestUnsure, AllUnsure).

order_keys([], _, []).
order_keys([Key|Keys], Present, Ordered) :-
    memberd_t(Key, Present, Occurs),
    order_step(Occurs, Key, Keys, Present, Ordered).

order_step(true, Key, Keys, Present, [Key|Ordered]) :-
    order_keys(Keys, Present, Ordered).
order_step(false, _, Keys, Present, Ordered) :-
    order_keys(Keys, Present, Ordered).

definition(Profile, Relation, Answer) :-
    gdpr_common_definitions_data_and_processing_input_problems(Profile, Problems),
    definition_by_problems(Problems, Profile, Relation, Answer).

definition_by_problems([Problem|Problems], _, _, definition_answer(input_problems([Problem|Problems]), none, [])).
definition_by_problems([], Profile, Relation, Answer) :-
    relation_formula(Relation, Formula, CitationKey),
    evaluate(Profile, Formula, Outcome),
    answer_from(Outcome, Relation, Profile, CitationKey, Answer).

answer_from(outcome(met, _, _, _), Relation, Profile, CitationKey, definition_answer(met, Ground, [cite(CitationKey)])) :-
    met_ground(Relation, Profile, Ground).
answer_from(outcome(unmet, _, _, _), Relation, Profile, CitationKey, definition_answer(not_met, Ground, [cite(CitationKey)])) :-
    unmet_ground(Relation, Profile, Ground).
answer_from(outcome(open, Missing, Outside, Unsure), _, Profile, CitationKey, Answer) :-
    root_keys(Order),
    order_keys(Order, Missing, OrderedMissing),
    order_keys(Order, Outside, OrderedOutside),
    order_keys(Order, Unsure, OrderedUnsure),
    open_answer(OrderedMissing, OrderedOutside, OrderedUnsure, Profile, CitationKey, Answer).

open_answer([Key|Keys], _, _, _, CitationKey, definition_answer(indeterminate([Key|Keys]), none, [cite(CitationKey)])).
open_answer([], [Key|_], _, Profile, _, definition_answer(needs_legal_review(cross_reference_unresolved(Citation, Target), [resolution(Target, not_attempted), inputs_relied_on(Pairs)]), none, [Citation, Target])) :-
    referral_outside(Key, Citation, Target, Inputs),
    present_pairs(Inputs, Profile, Pairs).
open_answer([], [], [Input|_], Profile, _, definition_answer(needs_legal_review(open_textured(Input, Citation), [inputs_relied_on(Pairs)]), none, [Citation])) :-
    referral(Input, Citation, Inputs),
    present_pairs(Inputs, Profile, Pairs).

present_pairs([], _, []).
present_pairs([Key|Keys], Profile, Pairs) :-
    key_state(Profile, Key, State),
    pairs_step(State, Key, Keys, Profile, Pairs).

pairs_step(absent, _, Keys, Profile, Pairs) :-
    present_pairs(Keys, Profile, Pairs).
pairs_step(Value, Key, Keys, Profile, [Key - Value|Pairs]) :-
    dif(Value, absent),
    present_pairs(Keys, Profile, Pairs).

met_ground(Relation, _, none) :-
    dif(Relation, international_organisation).
met_ground(international_organisation, Profile, Ground) :-
    key_state(Profile, organisation_governed_by_public_international_law, State),
    organisation_ground(State, Ground).

organisation_ground(attested(true, _), governed_by_public_international_law).
organisation_ground(attested(false, _), set_up_by_agreement_between_countries).
organisation_ground(absent, set_up_by_agreement_between_countries).

unmet_ground(consent_elements, Profile, unmet_elements(Keys)) :-
    consent_keys(AllKeys),
    false_keys(AllKeys, Profile, Keys).
unmet_ground(Relation, _, none) :-
    dif(Relation, consent_elements).

false_keys([], _, []).
false_keys([Key|Keys], Profile, Falsified) :-
    key_state(Profile, Key, State),
    false_step(State, Key, Keys, Profile, Falsified).

false_step(false, Key, Keys, Profile, [Key|Falsified]) :-
    false_keys(Keys, Profile, Falsified).
false_step(true, _, Keys, Profile, Falsified) :-
    false_keys(Keys, Profile, Falsified).
false_step(unsure, _, Keys, Profile, Falsified) :-
    false_keys(Keys, Profile, Falsified).
false_step(absent, _, Keys, Profile, Falsified) :-
    false_keys(Keys, Profile, Falsified).

personal_data(Profile, Answer) :-
    implements(eu_reg_2016_679_art_4_1),
    definition(Profile, personal_data, Answer).

processing(Profile, Answer) :-
    implements(eu_reg_2016_679_art_4_2),
    definition(Profile, processing, Answer).

restriction_of_processing(Profile, Answer) :-
    implements(eu_reg_2016_679_art_4_3),
    definition(Profile, restriction_of_processing, Answer).

profiling(Profile, Answer) :-
    implements(eu_reg_2016_679_art_4_4),
    definition(Profile, profiling, Answer).

pseudonymisation(Profile, Answer) :-
    implements(eu_reg_2016_679_art_4_5),
    definition(Profile, pseudonymisation, Answer).

filing_system(Profile, Answer) :-
    implements(eu_reg_2016_679_art_4_6),
    definition(Profile, filing_system, Answer).

receiving_body_is_recipient(Profile, Answer) :-
    implements(eu_reg_2016_679_art_4_9),
    definition(Profile, receiving_body_is_recipient, Answer).

receiving_body_is_third_party(Profile, Answer) :-
    implements(eu_reg_2016_679_art_4_10),
    definition(Profile, receiving_body_is_third_party, Answer).

consent_elements(Profile, Answer) :-
    implements(eu_reg_2016_679_art_4_11),
    definition(Profile, consent_elements, Answer).

personal_data_breach(Profile, Answer) :-
    implements(eu_reg_2016_679_art_4_12),
    definition(Profile, personal_data_breach, Answer).

information_society_service(Profile, Answer) :-
    implements(eu_reg_2016_679_art_4_25),
    definition(Profile, information_society_service, Answer).

international_organisation(Profile, Answer) :-
    implements(eu_reg_2016_679_art_4_26),
    definition(Profile, international_organisation, Answer).

data_and_processing_outside_facts(Profile, Answer) :-
    gdpr_common_definitions_data_and_processing_input_problems(Profile, Problems),
    outside_facts_by_problems(Problems, Profile, Answer).

outside_facts_by_problems([Problem|Problems], _, input_problems([Problem|Problems])).
outside_facts_by_problems([], Profile, [outside_fact(service_is_information_society_service, ServiceFact), outside_fact(organisation_governed_by_public_international_law, OrganisationFact)]) :-
    key_state(Profile, service_is_information_society_service, ServiceFact),
    key_state(Profile, organisation_governed_by_public_international_law, OrganisationFact).

decide_gdpr_common_definitions_data_and_processing(Profile, gdpr_common_definitions_data_and_processing_verdict(Status, Citations)) :-
    personal_data(Profile, definition_answer(Status, _, Citations)).

gdpr_common_definitions_data_and_processing_status(Profile, Status) :-
    decide_gdpr_common_definitions_data_and_processing(Profile, gdpr_common_definitions_data_and_processing_verdict(Status, _)).

gdpr_common_definitions_data_and_processing_checklist(Profile, Items) :-
    relation_identifiers(Identifiers),
    checklist_items(Identifiers, Profile, Items).

checklist_items([], _, []).
checklist_items([Identifier|Identifiers], Profile, [item(Identifier, Status, Citations)|Items]) :-
    definition(Profile, Identifier, definition_answer(Status, _, Citations)),
    checklist_items(Identifiers, Profile, Items).

gdpr_common_definitions_data_and_processing_decision_resolvable(Profile) :-
    decide_gdpr_common_definitions_data_and_processing(Profile, _).
