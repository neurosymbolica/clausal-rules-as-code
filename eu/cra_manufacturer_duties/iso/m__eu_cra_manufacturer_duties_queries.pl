% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_cra_manufacturer_duties_queries, [cra_manufacturer_duties_profile_keys/1, cra_manufacturer_duties_what_if/4, subject_to_requirements/0, article_14_only/0, not_yet_applicable/0, not_applicable_outside_support_period/0, placing_on_market_date/0, substantially_modified_on_or_after_application_date/0, expected_use_time_in_months/0, security_update_issue_date/0, support_period_end_date/0, technical_documentation_and_declaration_of_conformity/0, information_and_instructions_to_the_user/0, security_update/0, unsure/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(m__eu_cra_manufacturer_duties_kernel, [cra_manufacturer_duties_input_problems/2]).
:- use_module(m__eu_cra_manufacturer_duties_cra_manufacturer_duties, [decide_cra_manufacturer_duties/2]).

cra_manufacturer_duties_profile_keys([placing_on_market_date, substantially_modified_on_or_after_application_date, expected_use_time_in_months, security_update_issue_date, support_period_end_date]).

subject_to_requirements.

article_14_only.

not_yet_applicable.

not_applicable_outside_support_period.

placing_on_market_date.

substantially_modified_on_or_after_application_date.

expected_use_time_in_months.

security_update_issue_date.

support_period_end_date.

technical_documentation_and_declaration_of_conformity.

information_and_instructions_to_the_user.

security_update.

unsure.

cra_manufacturer_duties_what_if(Question, OverriddenKey, NewValue, NewVerdict) :-
    question_known_t(Question, IsKnownQuestion),
    what_if_answer(IsKnownQuestion, Question, OverriddenKey, NewValue, NewVerdict).

question_known_t(Question, false) :-
    var(Question).
question_known_t(Question, IsKnownQuestion) :-
    nonvar(Question),
    functor(Question, QuestionName, QuestionArity),
    memberd_t(QuestionName/QuestionArity, [requirements_applicability/2, support_period_minimum/2, retention_end_date/3], IsKnownQuestion).

what_if_answer(false, _, _, _, input_problems([wrong_type(question)])).
what_if_answer(true, Question, OverriddenKey, NewValue, NewVerdict) :-
    hypothetical_question(Question, OverriddenKey, NewValue, Hypothesis),
    decide_cra_manufacturer_duties(Hypothesis, cra_manufacturer_duties_verdict(NewVerdict, _)).

hypothetical_question(requirements_applicability(Profile, AssessmentDate), OverriddenKey, NewValue, requirements_applicability(NewProfile, AssessmentDate)) :-
    override_attribute(Profile, OverriddenKey, NewValue, NewProfile).
hypothetical_question(support_period_minimum(Profile, AssessmentDate), OverriddenKey, NewValue, support_period_minimum(NewProfile, AssessmentDate)) :-
    override_attribute(Profile, OverriddenKey, NewValue, NewProfile).
hypothetical_question(retention_end_date(Profile, AssessmentDate, RetentionItem), OverriddenKey, NewValue, retention_end_date(NewProfile, AssessmentDate, RetentionItem)) :-
    override_attribute(Profile, OverriddenKey, NewValue, NewProfile).

override_attribute(Profile, OverriddenKey, NewValue, [attribute(OverriddenKey, NewValue)|RemainingAttributes]) :-
    remove_key(Profile, OverriddenKey, RemainingAttributes).

remove_key(Profile, _, Profile) :-
    var(Profile).
remove_key([], _, []).
remove_key([Element|Elements], OverriddenKey, RemainingAttributes) :-
    element_matches_t(Element, OverriddenKey, Matches),
    remove_step(Matches, Element, Elements, OverriddenKey, RemainingAttributes).
remove_key(Profile, _, Profile) :-
    nonvar(Profile),
    Profile \== [],
    Profile \= [_|_].

remove_step(true, _, Elements, OverriddenKey, RemainingAttributes) :-
    remove_key(Elements, OverriddenKey, RemainingAttributes).
remove_step(false, Element, Elements, OverriddenKey, [Element|RemainingAttributes]) :-
    remove_key(Elements, OverriddenKey, RemainingAttributes).

element_matches_t(Element, _, false) :-
    var(Element).
element_matches_t(Element, OverriddenKey, true) :-
    nonvar(Element),
    Element = attribute(ElementKey, _),
    ElementKey == OverriddenKey.
element_matches_t(Element, OverriddenKey, false) :-
    nonvar(Element),
    Element = attribute(ElementKey, _),
    ElementKey \== OverriddenKey.
element_matches_t(Element, _, false) :-
    nonvar(Element),
    Element \= attribute(_, _).

test(what_if_a_legacy_product_is_modified) :-
    findall(Verdict, cra_manufacturer_duties_what_if(requirements_applicability([attribute(placing_on_market_date, date(2025, 5, 5)), attribute(substantially_modified_on_or_after_application_date, false)], date(2028, 3, 1)), substantially_modified_on_or_after_application_date, true, Verdict), Verdicts),
    Verdicts == [subject_to_requirements].
test(what_if_keeps_the_unmodified_answer_when_false_stays_false) :-
    cra_manufacturer_duties_what_if(requirements_applicability([attribute(placing_on_market_date, date(2025, 5, 5)), attribute(substantially_modified_on_or_after_application_date, true)], date(2028, 3, 1)), substantially_modified_on_or_after_application_date, false, Verdict),
    Verdict == article_14_only.
test(what_if_the_placing_date_moves_to_the_application_date) :-
    cra_manufacturer_duties_what_if(requirements_applicability([attribute(placing_on_market_date, date(2027, 12, 10))], date(2028, 3, 1)), placing_on_market_date, date(2027, 12, 11), Verdict),
    Verdict == subject_to_requirements.
test(what_if_a_shorter_use_time) :-
    cra_manufacturer_duties_what_if(support_period_minimum([attribute(expected_use_time_in_months, 72)], date(2028, 3, 1)), expected_use_time_in_months, 59, Verdict),
    Verdict == minimum_support_period(59).
test(what_if_a_later_support_period_end) :-
    cra_manufacturer_duties_what_if(retention_end_date([attribute(placing_on_market_date, date(2028, 2, 1)), attribute(support_period_end_date, date(2033, 2, 1))], date(2028, 3, 1), technical_documentation_and_declaration_of_conformity), support_period_end_date, date(2038, 2, 2), Verdict),
    Verdict == keep_until(date(2038, 2, 2)).
test(what_if_replaces_a_duplicated_key_once) :-
    findall(Verdict, cra_manufacturer_duties_what_if(support_period_minimum([attribute(expected_use_time_in_months, 10), attribute(expected_use_time_in_months, 20)], date(2028, 3, 1)), expected_use_time_in_months, 30, Verdict), Verdicts),
    Verdicts == [minimum_support_period(30)].
test(what_if_an_unknown_question_is_wrong_type) :-
    findall(Verdict, cra_manufacturer_duties_what_if(nonsense, expected_use_time_in_months, 30, Verdict), Verdicts),
    Verdicts == [input_problems([wrong_type(question)])].
test(what_if_an_unbound_question_is_wrong_type) :-
    findall(Verdict, cra_manufacturer_duties_what_if(_, expected_use_time_in_months, 30, Verdict), Verdicts),
    Verdicts == [input_problems([wrong_type(question)])].
test(what_if_on_a_partial_profile_is_refused) :-
    findall(Verdict, cra_manufacturer_duties_what_if(support_period_minimum([attribute(colour, red)|_], date(2028, 3, 1)), expected_use_time_in_months, 30, Verdict), Verdicts),
    Verdicts == [input_problems([wrong_type(profile)])].
test(the_profile_keys_are_the_five_contract_keys) :-
    cra_manufacturer_duties_profile_keys(Keys),
    length(Keys, 5).
test(the_root_atoms_hold) :-
    subject_to_requirements,
    article_14_only,
    not_yet_applicable,
    not_applicable_outside_support_period,
    placing_on_market_date,
    security_update,
    unsure.
