% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_common_definitions_data_and_processing_gdpr_common_definitions_data_and_processing, [decide_gdpr_common_definitions_data_and_processing/2, gdpr_common_definitions_data_and_processing_status/2, gdpr_common_definitions_data_and_processing_checklist/2, gdpr_common_definitions_data_and_processing_decision_resolvable/1, gdpr_common_definitions_data_and_processing_status_values/1, personal_data/2, processing/2, restriction_of_processing/2, profiling/2, pseudonymisation/2, filing_system/2, receiving_body_is_recipient/2, receiving_body_is_third_party/2, consent_elements/2, personal_data_breach/2, information_society_service/2, international_organisation/2, data_and_processing_outside_facts/2, definition_answer/3, unmet_elements/1, input_problems/1, wrong_type/1, duplicate_key/1, indeterminate/1, needs_legal_review/2, open_textured/2, cross_reference_unresolved/2, resolution/2, inputs_relied_on/1, provenance/2, outside_fact/2, attested/2, attestation/4, url/2, document/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(pairs), [pairs_values/2]).
:- use_module(clausal_lists_extra, [clausal_is_list/1]).
:- use_module(m__eu_data_protection_gdpr_common_definitions_data_and_processing_kernel, [gdpr_common_definitions_data_and_processing_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_common_definitions_data_and_processing_citations, [implements/1]).
:- use_module(formalize_lib, [profile_get/3, profile_has/2, profile_lacks/2]).

gdpr_common_definitions_data_and_processing_status_values([met, not_met, indeterminate, needs_legal_review, input_problems]).

relation_names([personal_data, processing, restriction_of_processing, profiling, pseudonymisation, filing_system, receiving_body_is_recipient, receiving_body_is_third_party, consent_elements, personal_data_breach, information_society_service, international_organisation]).

key_rank(information_relates_to_natural_person, 1).
key_rank(natural_person_identified, 2).
key_rank(natural_person_identifiable, 3).
key_rank(operation_performed_on_the_data, 4).
key_rank(stored_data_marked_to_limit_future_processing, 5).
key_rank(processing_automated, 6).
key_rank(evaluates_personal_aspects_of_natural_person, 7).
key_rank(attribution_needs_additional_information, 8).
key_rank(additional_information_kept_separately, 9).
key_rank(measures_prevent_attribution, 10).
key_rank(structured_set_accessible_by_specific_criteria, 11).
key_rank(data_disclosed_to_receiving_body, 12).
key_rank(receiving_body_public_authority_in_particular_inquiry, 13).
key_rank(receiving_body_is_data_subject, 14).
key_rank(receiving_body_is_controller_or_processor, 15).
key_rank(receiving_body_authorised_under_direct_authority, 16).
key_rank(indication_freely_given, 17).
key_rank(indication_specific, 18).
key_rank(indication_informed, 19).
key_rank(indication_unambiguous, 20).
key_rank(agreement_by_statement_or_clear_affirmative_action, 21).
key_rank(breach_of_security, 22).
key_rank(breach_led_to_listed_outcome, 23).
key_rank(service_is_information_society_service, 24).
key_rank(organisation_governed_by_public_international_law, 25).
key_rank(body_set_up_by_agreement_between_countries, 26).

citation_rank(cite(eu_reg_2016_679_art_4_1), 1).
citation_rank(cite(eu_reg_2016_679_art_4_2), 2).
citation_rank(cite(eu_reg_2016_679_art_4_3), 3).
citation_rank(cite(eu_reg_2016_679_art_4_4), 4).
citation_rank(cite(eu_reg_2016_679_art_4_5), 5).
citation_rank(cite(eu_reg_2016_679_art_4_6), 6).
citation_rank(cite(eu_reg_2016_679_art_4_9), 7).
citation_rank(cite(eu_reg_2016_679_art_4_10), 8).
citation_rank(cite(eu_reg_2016_679_art_4_11), 9).
citation_rank(cite(eu_reg_2016_679_art_4_12), 10).
citation_rank(cite(eu_reg_2016_679_art_4_25), 11).
citation_rank(cite(eu_reg_2016_679_art_4_26), 12).
citation_rank(cite(eu_dir_2015_1535_art_1_1_b), 13).
citation_rank(cite(public_international_law_governing_organisation), 14).

referral_row(information_relates_to_natural_person, cite(eu_reg_2016_679_art_4_1), [information_relates_to_natural_person, natural_person_identified, natural_person_identifiable]).
referral_row(natural_person_identifiable, cite(eu_reg_2016_679_art_4_1), [information_relates_to_natural_person, natural_person_identified, natural_person_identifiable]).
referral_row(evaluates_personal_aspects_of_natural_person, cite(eu_reg_2016_679_art_4_4), [processing_automated, evaluates_personal_aspects_of_natural_person]).
referral_row(attribution_needs_additional_information, cite(eu_reg_2016_679_art_4_5), [attribution_needs_additional_information, additional_information_kept_separately, measures_prevent_attribution]).
referral_row(measures_prevent_attribution, cite(eu_reg_2016_679_art_4_5), [attribution_needs_additional_information, additional_information_kept_separately, measures_prevent_attribution]).
referral_row(structured_set_accessible_by_specific_criteria, cite(eu_reg_2016_679_art_4_6), [structured_set_accessible_by_specific_criteria]).
referral_row(indication_freely_given, cite(eu_reg_2016_679_art_4_11), [indication_freely_given, indication_specific, indication_informed, indication_unambiguous, agreement_by_statement_or_clear_affirmative_action]).
referral_row(indication_specific, cite(eu_reg_2016_679_art_4_11), [indication_freely_given, indication_specific, indication_informed, indication_unambiguous, agreement_by_statement_or_clear_affirmative_action]).
referral_row(indication_informed, cite(eu_reg_2016_679_art_4_11), [indication_freely_given, indication_specific, indication_informed, indication_unambiguous, agreement_by_statement_or_clear_affirmative_action]).
referral_row(indication_unambiguous, cite(eu_reg_2016_679_art_4_11), [indication_freely_given, indication_specific, indication_informed, indication_unambiguous, agreement_by_statement_or_clear_affirmative_action]).
referral_row(agreement_by_statement_or_clear_affirmative_action, cite(eu_reg_2016_679_art_4_11), [indication_freely_given, indication_specific, indication_informed, indication_unambiguous, agreement_by_statement_or_clear_affirmative_action]).
referral_row(breach_of_security, cite(eu_reg_2016_679_art_4_12), [breach_of_security, breach_led_to_listed_outcome]).

outside_fact_row(service_is_information_society_service, cite(eu_reg_2016_679_art_4_25), cite(eu_dir_2015_1535_art_1_1_b), []).
outside_fact_row(organisation_governed_by_public_international_law, cite(eu_reg_2016_679_art_4_26), cite(public_international_law_governing_organisation), [body_set_up_by_agreement_between_countries]).

outside_fact_keys([service_is_information_society_service, organisation_governed_by_public_international_law]).

consent_element_keys([indication_freely_given, indication_specific, indication_informed, indication_unambiguous, agreement_by_statement_or_clear_affirmative_action]).

personal_data_formula(all_of([key(information_relates_to_natural_person), any_of([key(natural_person_identified), key(natural_person_identifiable)])])) :-
    implements(eu_reg_2016_679_art_4_1).

processing_formula(all_of([PersonalData, key(operation_performed_on_the_data)])) :-
    implements(eu_reg_2016_679_art_4_2),
    personal_data_formula(PersonalData).

relation_definition(personal_data, Formula, cite(eu_reg_2016_679_art_4_1)) :-
    implements(eu_reg_2016_679_art_4_1),
    personal_data_formula(Formula).
relation_definition(processing, Formula, cite(eu_reg_2016_679_art_4_2)) :-
    implements(eu_reg_2016_679_art_4_2),
    processing_formula(Formula).
relation_definition(restriction_of_processing, all_of([PersonalData, key(stored_data_marked_to_limit_future_processing)]), cite(eu_reg_2016_679_art_4_3)) :-
    implements(eu_reg_2016_679_art_4_3),
    personal_data_formula(PersonalData).
relation_definition(profiling, all_of([Processing, key(processing_automated), key(evaluates_personal_aspects_of_natural_person)]), cite(eu_reg_2016_679_art_4_4)) :-
    implements(eu_reg_2016_679_art_4_4),
    processing_formula(Processing).
relation_definition(pseudonymisation, all_of([Processing, key(attribution_needs_additional_information), key(additional_information_kept_separately), key(measures_prevent_attribution)]), cite(eu_reg_2016_679_art_4_5)) :-
    implements(eu_reg_2016_679_art_4_5),
    processing_formula(Processing).
relation_definition(filing_system, all_of([PersonalData, key(structured_set_accessible_by_specific_criteria)]), cite(eu_reg_2016_679_art_4_6)) :-
    implements(eu_reg_2016_679_art_4_6),
    personal_data_formula(PersonalData).
relation_definition(receiving_body_is_recipient, all_of([PersonalData, key(data_disclosed_to_receiving_body), negated(receiving_body_public_authority_in_particular_inquiry)]), cite(eu_reg_2016_679_art_4_9)) :-
    implements(eu_reg_2016_679_art_4_9),
    personal_data_formula(PersonalData).
relation_definition(receiving_body_is_third_party, all_of([negated(receiving_body_is_data_subject), negated(receiving_body_is_controller_or_processor), negated(receiving_body_authorised_under_direct_authority)]), cite(eu_reg_2016_679_art_4_10)) :-
    implements(eu_reg_2016_679_art_4_10).
relation_definition(consent_elements, all_of([key(indication_freely_given), key(indication_specific), key(indication_informed), key(indication_unambiguous), key(agreement_by_statement_or_clear_affirmative_action)]), cite(eu_reg_2016_679_art_4_11)) :-
    implements(eu_reg_2016_679_art_4_11).
relation_definition(personal_data_breach, all_of([Processing, key(breach_of_security), key(breach_led_to_listed_outcome)]), cite(eu_reg_2016_679_art_4_12)) :-
    implements(eu_reg_2016_679_art_4_12),
    processing_formula(Processing).
relation_definition(information_society_service, outside(service_is_information_society_service), cite(eu_reg_2016_679_art_4_25)) :-
    implements(eu_reg_2016_679_art_4_25).
relation_definition(international_organisation, any_of([outside(organisation_governed_by_public_international_law), key(body_set_up_by_agreement_between_countries)]), cite(eu_reg_2016_679_art_4_26)) :-
    implements(eu_reg_2016_679_art_4_26).

personal_data(Profile, Answer) :-
    implements(eu_reg_2016_679_art_4_1),
    answer_for(personal_data, Profile, Answer).

processing(Profile, Answer) :-
    implements(eu_reg_2016_679_art_4_2),
    answer_for(processing, Profile, Answer).

restriction_of_processing(Profile, Answer) :-
    implements(eu_reg_2016_679_art_4_3),
    answer_for(restriction_of_processing, Profile, Answer).

profiling(Profile, Answer) :-
    implements(eu_reg_2016_679_art_4_4),
    answer_for(profiling, Profile, Answer).

pseudonymisation(Profile, Answer) :-
    implements(eu_reg_2016_679_art_4_5),
    answer_for(pseudonymisation, Profile, Answer).

filing_system(Profile, Answer) :-
    implements(eu_reg_2016_679_art_4_6),
    answer_for(filing_system, Profile, Answer).

receiving_body_is_recipient(Profile, Answer) :-
    implements(eu_reg_2016_679_art_4_9),
    answer_for(receiving_body_is_recipient, Profile, Answer).

receiving_body_is_third_party(Profile, Answer) :-
    implements(eu_reg_2016_679_art_4_10),
    answer_for(receiving_body_is_third_party, Profile, Answer).

consent_elements(Profile, Answer) :-
    implements(eu_reg_2016_679_art_4_11),
    answer_for(consent_elements, Profile, Answer).

personal_data_breach(Profile, Answer) :-
    implements(eu_reg_2016_679_art_4_12),
    answer_for(personal_data_breach, Profile, Answer).

information_society_service(Profile, Answer) :-
    implements(eu_reg_2016_679_art_4_25),
    answer_for(information_society_service, Profile, Answer).

international_organisation(Profile, Answer) :-
    implements(eu_reg_2016_679_art_4_26),
    answer_for(international_organisation, Profile, Answer).

data_and_processing_outside_facts(Profile, OutsideFacts) :-
    gdpr_common_definitions_data_and_processing_input_problems(Profile, Problems),
    outside_facts_given_problems(Problems, Profile, OutsideFacts).

outside_facts_given_problems([Problem|Problems], _, input_problems([Problem|Problems])).
outside_facts_given_problems([], Profile, OutsideFacts) :-
    outside_fact_keys(Keys),
    maplist(outside_fact_as_given(Profile), Keys, OutsideFacts).

outside_fact_as_given(Profile, Key, outside_fact(Key, absent)) :-
    profile_lacks(Profile, Key).
outside_fact_as_given(Profile, Key, outside_fact(Key, Attested)) :-
    profile_has(Profile, Key),
    profile_get(Profile, Key, Attested).

answer_for(Relation, Profile, Answer) :-
    gdpr_common_definitions_data_and_processing_input_problems(Profile, Problems),
    answer_given_problems(Problems, Relation, Profile, Answer).

answer_given_problems([Problem|Problems], _, _, definition_answer(input_problems([Problem|Problems]), none, [])).
answer_given_problems([], Relation, Profile, Answer) :-
    relation_definition(Relation, Formula, Citation),
    evaluate(Formula, Profile, Value, Leaves),
    settle(Value, Leaves, Relation, Profile, Citation, Answer).

settle(met, _, Relation, Profile, Citation, definition_answer(met, Ground, [Citation])) :-
    met_ground(Relation, Profile, Ground).
settle(unmet, _, Relation, Profile, Citation, definition_answer(not_met, Ground, [Citation])) :-
    unmet_ground(Relation, Profile, Ground).
settle(open, Leaves, _, Profile, Citation, definition_answer(Status, none, Citations)) :-
    open_status(Leaves, Profile, Citation, Status, Citations).

met_ground(international_organisation, Profile, Ground) :-
    implements(eu_reg_2016_679_art_4_26),
    fact_reading(Profile, organisation_governed_by_public_international_law, Reading),
    organisation_ground(Reading, Ground).
met_ground(Relation, _, none) :-
    dif(Relation, international_organisation).

organisation_ground(met, governed_by_public_international_law).
organisation_ground(unmet, set_up_by_agreement_between_countries).
organisation_ground(absent, set_up_by_agreement_between_countries).

unmet_ground(consent_elements, Profile, unmet_elements(Keys)) :-
    implements(eu_reg_2016_679_art_4_11),
    consent_element_keys(ElementKeys),
    elements_given_false(ElementKeys, Profile, Keys).
unmet_ground(Relation, _, none) :-
    dif(Relation, consent_elements).

elements_given_false([], _, []).
elements_given_false([Key|Keys], Profile, FalseKeys) :-
    key_reading(Profile, Key, Reading),
    elements_given_false(Keys, Profile, LaterFalseKeys),
    keep_given_false(Reading, Key, LaterFalseKeys, FalseKeys).

keep_given_false(unmet, Key, FalseKeys, [Key|FalseKeys]).
keep_given_false(met, _, FalseKeys, FalseKeys).
keep_given_false(absent, _, FalseKeys, FalseKeys).
keep_given_false(unsure, _, FalseKeys, FalseKeys).

open_status(Leaves, Profile, Citation, Status, Citations) :-
    ranked_leaves(absent_key, Leaves, MissingKeys),
    open_by_missing(MissingKeys, Leaves, Profile, Citation, Status, Citations).

open_by_missing([MissingKey|MissingKeys], _, _, Citation, indeterminate([MissingKey|MissingKeys]), [Citation]).
open_by_missing([], Leaves, Profile, _, Status, Citations) :-
    ranked_leaves(absent_fact, Leaves, AbsentFacts),
    open_by_fact(AbsentFacts, Leaves, Profile, Status, Citations).

open_by_fact([FactKey|_], _, Profile, needs_legal_review(cross_reference_unresolved(Citation, Target), [resolution(Target, not_attempted), inputs_relied_on(Pairs)]), [Citation, Target]) :-
    outside_fact_row(FactKey, Citation, Target, Inputs),
    relied_pairs(Inputs, Profile, Pairs).
open_by_fact([], Leaves, Profile, needs_legal_review(open_textured(Input, Citation), [inputs_relied_on(Pairs)]), [Citation]) :-
    ranked_leaves(unsure_judgement, Leaves, [Input|_]),
    referral_row(Input, Citation, Inputs),
    relied_pairs(Inputs, Profile, Pairs).

ranked_leaves(Kind, Leaves, Keys) :-
    findall(Rank - Key, (member(leaf(Kind, Key), Leaves), key_rank(Key, Rank)), RankedPairs),
    sort(RankedPairs, SortedPairs),
    pairs_values(SortedPairs, Keys).

relied_pairs([], _, []).
relied_pairs([Key|Keys], Profile, Pairs) :-
    relied_pairs(Keys, Profile, LaterPairs),
    relied_pair(Profile, Key, LaterPairs, Pairs).

relied_pair(Profile, Key, LaterPairs, LaterPairs) :-
    profile_lacks(Profile, Key).
relied_pair(Profile, Key, LaterPairs, [Key - Value|LaterPairs]) :-
    profile_has(Profile, Key),
    profile_get(Profile, Key, Value).

evaluate(key(Key), Profile, Value, Leaves) :-
    key_reading(Profile, Key, Reading),
    leaf_value(Reading, Key, Value, Leaves).
evaluate(negated(Key), Profile, Value, Leaves) :-
    key_reading(Profile, Key, Reading),
    leaf_value(Reading, Key, PlainValue, Leaves),
    kleene_negation(PlainValue, Value).
evaluate(outside(Key), Profile, Value, Leaves) :-
    fact_reading(Profile, Key, Reading),
    fact_leaf_value(Reading, Key, Value, Leaves).
evaluate(all_of(Formulas), Profile, Value, Leaves) :-
    evaluate_children(Formulas, Profile, Values, ChildLeaves),
    foldl(kleene_and, Values, met, Value),
    gather_leaves(Value, ChildLeaves, Leaves).
evaluate(any_of(Formulas), Profile, Value, Leaves) :-
    evaluate_children(Formulas, Profile, Values, ChildLeaves),
    foldl(kleene_or, Values, unmet, Value),
    gather_leaves(Value, ChildLeaves, Leaves).

evaluate_children([], _, [], []).
evaluate_children([Formula|Formulas], Profile, [Value|Values], [Leaves|ChildLeaves]) :-
    evaluate(Formula, Profile, Value, Leaves),
    evaluate_children(Formulas, Profile, Values, ChildLeaves).

gather_leaves(open, ChildLeaves, Leaves) :-
    append(ChildLeaves, Leaves).
gather_leaves(met, _, []).
gather_leaves(unmet, _, []).

leaf_value(met, _, met, []).
leaf_value(unmet, _, unmet, []).
leaf_value(absent, Key, open, [leaf(absent_key, Key)]).
leaf_value(unsure, Key, open, [leaf(unsure_judgement, Key)]).

fact_leaf_value(met, _, met, []).
fact_leaf_value(unmet, _, unmet, []).
fact_leaf_value(absent, Key, open, [leaf(absent_fact, Key)]).

kleene_negation(met, unmet).
kleene_negation(unmet, met).
kleene_negation(open, open).

kleene_and(met, met, met).
kleene_and(met, open, open).
kleene_and(met, unmet, unmet).
kleene_and(open, met, open).
kleene_and(open, open, open).
kleene_and(open, unmet, unmet).
kleene_and(unmet, met, unmet).
kleene_and(unmet, open, unmet).
kleene_and(unmet, unmet, unmet).

kleene_or(met, met, met).
kleene_or(met, open, met).
kleene_or(met, unmet, met).
kleene_or(open, met, met).
kleene_or(open, open, open).
kleene_or(open, unmet, open).
kleene_or(unmet, met, met).
kleene_or(unmet, open, open).
kleene_or(unmet, unmet, unmet).

key_reading(Profile, Key, absent) :-
    profile_lacks(Profile, Key).
key_reading(Profile, Key, Reading) :-
    profile_has(Profile, Key),
    profile_get(Profile, Key, Value),
    value_reading(Value, Reading).

value_reading(true, met).
value_reading(false, unmet).
value_reading(unsure, unsure).

fact_reading(Profile, Key, absent) :-
    profile_lacks(Profile, Key).
fact_reading(Profile, Key, Reading) :-
    profile_has(Profile, Key),
    profile_get(Profile, Key, attested(Value, _)),
    value_reading(Value, Reading).

definition_answer(Status, Ground, Citations) :-
    nonvar(Status),
    nonvar(Ground),
    clausal_is_list(Citations).

unmet_elements(Keys) :-
    clausal_is_list(Keys).

input_problems(Problems) :-
    clausal_is_list(Problems).

wrong_type(Key) :-
    nonvar(Key).

duplicate_key(Key) :-
    atom(Key).

indeterminate(MissingKeys) :-
    clausal_is_list(MissingKeys).

needs_legal_review(Reason, Context) :-
    nonvar(Reason),
    clausal_is_list(Context).

open_textured(Input, Citation) :-
    atom(Input),
    nonvar(Citation).

cross_reference_unresolved(Citation, Target) :-
    nonvar(Citation),
    nonvar(Target).

resolution(Target, Resolution) :-
    nonvar(Target),
    atom(Resolution).

inputs_relied_on(Pairs) :-
    clausal_is_list(Pairs).

provenance(Clause, Citations) :-
    nonvar(Clause),
    clausal_is_list(Citations).

outside_fact(Key, Attested) :-
    atom(Key),
    nonvar(Attested).

attested(Value, Attestation) :-
    atom(Value),
    nonvar(Attestation).

attestation(By, At, Reason, Evidence) :-
    nonvar(By),
    nonvar(At),
    nonvar(Reason),
    nonvar(Evidence).

url(Address, RetrievedAt) :-
    nonvar(Address),
    nonvar(RetrievedAt).

document(UploadIdentifier, Digest) :-
    nonvar(UploadIdentifier),
    nonvar(Digest).

decide_gdpr_common_definitions_data_and_processing(Profile, gdpr_common_definitions_data_and_processing_verdict(Classification, Citations)) :-
    gdpr_common_definitions_data_and_processing_input_problems(Profile, Problems),
    facade_verdict(Problems, Profile, Classification, Citations).

facade_verdict([Problem|Problems], _, input_problems([Problem|Problems]), []).
facade_verdict([], Profile, classification(Rows), Citations) :-
    relation_names(Names),
    maplist(relation_row(Profile), Names, Rows),
    row_citations(Rows, Citations).

relation_row(Profile, Name, definition(Name, Answer)) :-
    answer_for(Name, Profile, Answer).

row_citations(Rows, Citations) :-
    findall(Rank - Citation, (member(definition(_, definition_answer(_, _, RowCitations)), Rows), member(Citation, RowCitations), citation_rank(Citation, Rank)), RankedCitations),
    sort(RankedCitations, SortedCitations),
    pairs_values(SortedCitations, Citations).

gdpr_common_definitions_data_and_processing_status(Profile, Status) :-
    decide_gdpr_common_definitions_data_and_processing(Profile, gdpr_common_definitions_data_and_processing_verdict(Status, _Citations)).

gdpr_common_definitions_data_and_processing_checklist(Profile, Items) :-
    decide_gdpr_common_definitions_data_and_processing(Profile, gdpr_common_definitions_data_and_processing_verdict(Classification, _Citations)),
    classification_items(Classification, Items).

classification_items(input_problems(Problems), [item(input_check, input_problems(Problems), [])]).
classification_items(classification(Rows), Items) :-
    maplist(row_item, Rows, Items).

row_item(definition(Name, definition_answer(Status, _, Citations)), item(Name, Status, Citations)).

gdpr_common_definitions_data_and_processing_decision_resolvable(Profile) :-
    decide_gdpr_common_definitions_data_and_processing(Profile, _Verdict).

single_answer_on(Profile, Name) :-
    findall(Answer, answer_for(Name, Profile, Answer), Answers),
    length(Answers, 1).

test(personal_data_met_when_identified) :-
    personal_data([attribute(information_relates_to_natural_person, true), attribute(natural_person_identified, true)], Answer),
    Answer == definition_answer(met, none, [cite(eu_reg_2016_679_art_4_1)]).
test(personal_data_not_met_when_unrelated) :-
    personal_data([attribute(information_relates_to_natural_person, false)], Answer),
    Answer == definition_answer(not_met, none, [cite(eu_reg_2016_679_art_4_1)]).
test(missing_keys_come_before_an_unsure_judgement) :-
    personal_data([attribute(information_relates_to_natural_person, unsure)], Answer),
    Answer == definition_answer(indeterminate([natural_person_identified, natural_person_identifiable]), none, [cite(eu_reg_2016_679_art_4_1)]).
test(personal_data_unsure_relation_refers) :-
    personal_data([attribute(information_relates_to_natural_person, unsure), attribute(natural_person_identified, true)], Answer),
    Answer == definition_answer(needs_legal_review(open_textured(information_relates_to_natural_person, cite(eu_reg_2016_679_art_4_1)), [inputs_relied_on([information_relates_to_natural_person - unsure, natural_person_identified - true])]), none, [cite(eu_reg_2016_679_art_4_1)]).
test(processing_met) :-
    processing([attribute(information_relates_to_natural_person, true), attribute(natural_person_identifiable, true), attribute(operation_performed_on_the_data, true)], Answer),
    Answer == definition_answer(met, none, [cite(eu_reg_2016_679_art_4_2)]).
test(restriction_not_met_without_marking) :-
    restriction_of_processing([attribute(information_relates_to_natural_person, true), attribute(natural_person_identified, true), attribute(stored_data_marked_to_limit_future_processing, false)], Answer),
    Answer == definition_answer(not_met, none, [cite(eu_reg_2016_679_art_4_3)]).
test(profiling_unsure_evaluation_refers_to_point_four) :-
    profiling([attribute(information_relates_to_natural_person, true), attribute(natural_person_identified, true), attribute(operation_performed_on_the_data, true), attribute(processing_automated, true), attribute(evaluates_personal_aspects_of_natural_person, unsure)], Answer),
    Answer == definition_answer(needs_legal_review(open_textured(evaluates_personal_aspects_of_natural_person, cite(eu_reg_2016_679_art_4_4)), [inputs_relied_on([processing_automated - true, evaluates_personal_aspects_of_natural_person - unsure])]), none, [cite(eu_reg_2016_679_art_4_4)]).
test(pseudonymisation_refers_identifiability_to_point_one) :-
    pseudonymisation([attribute(information_relates_to_natural_person, true), attribute(natural_person_identified, false), attribute(natural_person_identifiable, unsure), attribute(operation_performed_on_the_data, true), attribute(attribution_needs_additional_information, true), attribute(additional_information_kept_separately, true), attribute(measures_prevent_attribution, true)], Answer),
    Answer == definition_answer(needs_legal_review(open_textured(natural_person_identifiable, cite(eu_reg_2016_679_art_4_1)), [inputs_relied_on([information_relates_to_natural_person - true, natural_person_identified - false, natural_person_identifiable - unsure])]), none, [cite(eu_reg_2016_679_art_4_1)]).
test(pseudonymisation_lists_every_missing_key) :-
    pseudonymisation([], Answer),
    Answer == definition_answer(indeterminate([information_relates_to_natural_person, natural_person_identified, natural_person_identifiable, operation_performed_on_the_data, attribution_needs_additional_information, additional_information_kept_separately, measures_prevent_attribution]), none, [cite(eu_reg_2016_679_art_4_5)]).
test(filing_system_met) :-
    filing_system([attribute(information_relates_to_natural_person, true), attribute(natural_person_identified, true), attribute(structured_set_accessible_by_specific_criteria, true)], Answer),
    Answer == definition_answer(met, none, [cite(eu_reg_2016_679_art_4_6)]).
test(recipient_met) :-
    receiving_body_is_recipient([attribute(information_relates_to_natural_person, true), attribute(natural_person_identified, true), attribute(data_disclosed_to_receiving_body, true), attribute(receiving_body_public_authority_in_particular_inquiry, false)], Answer),
    Answer == definition_answer(met, none, [cite(eu_reg_2016_679_art_4_9)]).
test(inquiry_authority_is_not_a_recipient) :-
    receiving_body_is_recipient([attribute(information_relates_to_natural_person, true), attribute(natural_person_identified, true), attribute(data_disclosed_to_receiving_body, true), attribute(receiving_body_public_authority_in_particular_inquiry, true)], Answer),
    Answer == definition_answer(not_met, none, [cite(eu_reg_2016_679_art_4_9)]).
test(third_party_met) :-
    receiving_body_is_third_party([attribute(receiving_body_is_data_subject, false), attribute(receiving_body_is_controller_or_processor, false), attribute(receiving_body_authorised_under_direct_authority, false)], Answer),
    Answer == definition_answer(met, none, [cite(eu_reg_2016_679_art_4_10)]).
test(third_party_lists_missing_exclusions) :-
    receiving_body_is_third_party([], Answer),
    Answer == definition_answer(indeterminate([receiving_body_is_data_subject, receiving_body_is_controller_or_processor, receiving_body_authorised_under_direct_authority]), none, [cite(eu_reg_2016_679_art_4_10)]).
test(consent_names_the_elements_given_false) :-
    consent_elements([attribute(indication_freely_given, false), attribute(indication_specific, true), attribute(indication_informed, false), attribute(agreement_by_statement_or_clear_affirmative_action, true)], Answer),
    Answer == definition_answer(not_met, unmet_elements([indication_freely_given, indication_informed]), [cite(eu_reg_2016_679_art_4_11)]).
test(consent_unsure_specific_refers) :-
    consent_elements([attribute(indication_freely_given, true), attribute(indication_specific, unsure), attribute(indication_informed, true), attribute(indication_unambiguous, true), attribute(agreement_by_statement_or_clear_affirmative_action, true)], Answer),
    Answer == definition_answer(needs_legal_review(open_textured(indication_specific, cite(eu_reg_2016_679_art_4_11)), [inputs_relied_on([indication_freely_given - true, indication_specific - unsure, indication_informed - true, indication_unambiguous - true, agreement_by_statement_or_clear_affirmative_action - true])]), none, [cite(eu_reg_2016_679_art_4_11)]).
test(an_unread_key_does_not_change_consent) :-
    consent_elements([attribute(indication_freely_given, false), attribute(breach_of_security, false)], Answer),
    Answer == definition_answer(not_met, unmet_elements([indication_freely_given]), [cite(eu_reg_2016_679_art_4_11)]).
test(personal_data_breach_met) :-
    personal_data_breach([attribute(information_relates_to_natural_person, true), attribute(natural_person_identified, true), attribute(operation_performed_on_the_data, true), attribute(breach_of_security, true), attribute(breach_led_to_listed_outcome, true)], Answer),
    Answer == definition_answer(met, none, [cite(eu_reg_2016_679_art_4_12)]).
test(information_society_service_absent_fact_refers) :-
    information_society_service([], Answer),
    Answer == definition_answer(needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_4_25), cite(eu_dir_2015_1535_art_1_1_b)), [resolution(cite(eu_dir_2015_1535_art_1_1_b), not_attempted), inputs_relied_on([])]), none, [cite(eu_reg_2016_679_art_4_25), cite(eu_dir_2015_1535_art_1_1_b)]).
test(information_society_service_attested_true_is_met) :-
    information_society_service([attribute(service_is_information_society_service, attested(true, attestation(by, at, reason, none)))], Answer),
    Answer == definition_answer(met, none, [cite(eu_reg_2016_679_art_4_25)]).
test(international_organisation_by_agreement) :-
    international_organisation([attribute(body_set_up_by_agreement_between_countries, true)], Answer),
    Answer == definition_answer(met, set_up_by_agreement_between_countries, [cite(eu_reg_2016_679_art_4_26)]).
test(international_organisation_governed_by_public_international_law) :-
    international_organisation([attribute(organisation_governed_by_public_international_law, attested(true, attestation(by, at, reason, none)))], Answer),
    Answer == definition_answer(met, governed_by_public_international_law, [cite(eu_reg_2016_679_art_4_26)]).
test(international_organisation_absent_fact_refers) :-
    international_organisation([attribute(body_set_up_by_agreement_between_countries, false)], Answer),
    Answer == definition_answer(needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_4_26), cite(public_international_law_governing_organisation)), [resolution(cite(public_international_law_governing_organisation), not_attempted), inputs_relied_on([body_set_up_by_agreement_between_countries - false])]), none, [cite(eu_reg_2016_679_art_4_26), cite(public_international_law_governing_organisation)]).
test(international_organisation_missing_key_first) :-
    international_organisation([], Answer),
    Answer == definition_answer(indeterminate([body_set_up_by_agreement_between_countries]), none, [cite(eu_reg_2016_679_art_4_26)]).
test(international_organisation_attested_false_is_not_met) :-
    international_organisation([attribute(organisation_governed_by_public_international_law, attested(false, attestation(by, at, reason, none))), attribute(body_set_up_by_agreement_between_countries, false)], Answer),
    Answer == definition_answer(not_met, none, [cite(eu_reg_2016_679_art_4_26)]).
test(input_problems_answer_every_relation) :-
    consent_elements([attribute(natural_person_identified, unsure)], Answer),
    Answer == definition_answer(input_problems([wrong_type(natural_person_identified)]), none, []).
test(outside_facts_as_given) :-
    data_and_processing_outside_facts([attribute(service_is_information_society_service, attested(false, attestation(by, at, reason, none)))], OutsideFacts),
    OutsideFacts == [outside_fact(service_is_information_society_service, attested(false, attestation(by, at, reason, none))), outside_fact(organisation_governed_by_public_international_law, absent)].
test(outside_facts_input_problems) :-
    data_and_processing_outside_facts(nothing, OutsideFacts),
    OutsideFacts == input_problems([wrong_type(profile)]).
test(every_relation_gives_exactly_one_answer) :-
    relation_names(Names),
    maplist(single_answer_on([]), Names),
    maplist(single_answer_on([attribute(information_relates_to_natural_person, unsure), attribute(natural_person_identifiable, unsure)]), Names).
test(facade_classifies_every_relation) :-
    decide_gdpr_common_definitions_data_and_processing([], gdpr_common_definitions_data_and_processing_verdict(classification(Rows), Citations)),
    length(Rows, 12),
    Citations = [cite(eu_reg_2016_679_art_4_1)|_].
test(checklist_items_carry_citations) :-
    gdpr_common_definitions_data_and_processing_checklist([attribute(receiving_body_is_data_subject, true)], Items),
    member(item(receiving_body_is_third_party, not_met, [cite(eu_reg_2016_679_art_4_10)]), Items).
test(checklist_of_a_bad_profile) :-
    gdpr_common_definitions_data_and_processing_checklist(nothing, Items),
    Items == [item(input_check, input_problems([wrong_type(profile)]), [])].

test(personal_data_unrelated_is_not_met_answer, fail) :-
    personal_data([attribute(information_relates_to_natural_person, false)], definition_answer(met, _, _)).
test(input_problems_give_no_met_answer, fail) :-
    consent_elements([attribute(natural_person_identified, unsure)], definition_answer(met, _, _)).
