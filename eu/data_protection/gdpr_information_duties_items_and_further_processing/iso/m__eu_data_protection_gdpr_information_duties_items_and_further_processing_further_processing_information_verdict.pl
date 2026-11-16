% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_information_duties_items_and_further_processing_further_processing_information_verdict, [further_processing_information_verdict/3, decide_further_processing_information_verdict/2, further_processing_information_verdict_status/2, further_processing_information_verdict_checklist/2, further_processing_information_verdict_decision_resolvable/1, further_processing_information_verdict_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(formalize_lib, [profile_get/3, profile_lacks/2]).
:- use_module(m__eu_data_protection_gdpr_information_duties_items_and_further_processing_kernel, [gdpr_information_duties_items_and_further_processing_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_information_duties_items_and_further_processing_citations, [implements/1]).
:- use_module(m__eu_data_protection_gdpr_information_duties_items_and_further_processing_information_route, [information_item_row/5, information_route_for_flag/2, information_absent_keys/3]).

further_processing_information_verdict_status_values([eligible, ineligible, not_applicable]).

prior_citation_key(art13, eu_reg_2016_679_art_13_3) :-
    implements(eu_reg_2016_679_art_13_3).
prior_citation_key(art14, eu_reg_2016_679_art_14_4) :-
    implements(eu_reg_2016_679_art_14_4).

decision_citation_key(art13, eu_reg_2016_679_art_13_2_f).
decision_citation_key(art14, eu_reg_2016_679_art_14_2_g).

open_key_order([personal_data_collected_from_data_subject, items_data_subject_already_has, processing_based_on_legitimate_interests, processing_based_on_consent, automated_decision_making_under_article_22, further_processing_start_date, further_processing_information_date, further_processing_items_provided, paragraph_2_information_relevant_to_further_processing]).

further_processing_information_verdict(Profile, Verdict, Cites) :-
    gdpr_information_duties_items_and_further_processing_input_problems(Profile, Problems),
    further_with_problems(Problems, Profile, Verdict, Cites).

further_with_problems([Problem|Problems], _, input_problems([Problem|Problems]), []).
further_with_problems([], Profile, Verdict, Cites) :-
    information_absent_keys(Profile, [personal_data_collected_from_data_subject, further_processing_for_another_purpose_intended], Absent),
    further_after_gate(Absent, Profile, Verdict, Cites).

further_after_gate([Key|Keys], _, indeterminate([Key|Keys]), []).
further_after_gate([], Profile, Verdict, Cites) :-
    profile_get(Profile, further_processing_for_another_purpose_intended, Intended),
    further_by_intention(Intended, Profile, Verdict, Cites).

further_by_intention(false, _, not_applicable, []).
further_by_intention(true, Profile, Verdict, Cites) :-
    profile_get(Profile, personal_data_collected_from_data_subject, Collected),
    information_route_for_flag(Collected, Route),
    requirement_outcome(Profile, Route, Outcome),
    further_verdict(Outcome, Route, Profile, Verdict, Cites).

further_verdict(true, Route, _, eligible, [cite(Key)]) :-
    prior_citation_key(Route, Key).
further_verdict(false, Route, _, ineligible, [cite(Key)]) :-
    prior_citation_key(Route, Key).
further_verdict(unknown(Absent, Unsure), Route, Profile, Verdict, []) :-
    open_key_order(Order),
    order_keys(Order, Absent, OrderedAbsent),
    order_keys(Order, Unsure, OrderedUnsure),
    open_verdict(OrderedAbsent, OrderedUnsure, Route, Profile, Verdict).

open_verdict([Key|Keys], _, _, _, indeterminate([Key|Keys])).
open_verdict([], [Key|_], Route, Profile, needs_legal_review(open_textured(Key, cite(CiteKey)), [inputs_relied_on(Pairs)])) :-
    judgement_citation_key(Key, Route, CiteKey),
    relied_pairs(Profile, Pairs).

judgement_citation_key(paragraph_2_information_relevant_to_further_processing, Route, CiteKey) :-
    prior_citation_key(Route, CiteKey).
judgement_citation_key(automated_decision_making_under_article_22, Route, CiteKey) :-
    decision_citation_key(Route, CiteKey).

relied_pairs(Profile, Pairs) :-
    read_key(Profile, further_processing_items_provided, Provided),
    read_key(Profile, items_data_subject_already_has, AlreadyHas),
    coverage_outcome(automated_decision_making_information, Provided, AlreadyHas, Coverage),
    decision_making_pairs(Coverage, Profile, DecisionMakingPairs),
    key_pairs(Profile, paragraph_2_information_relevant_to_further_processing, RelevancePairs),
    append(DecisionMakingPairs, RelevancePairs, Pairs).

decision_making_pairs(true, _, []).
decision_making_pairs(false, Profile, Pairs) :-
    key_pairs(Profile, automated_decision_making_under_article_22, Pairs).
decision_making_pairs(unknown(_, _), Profile, Pairs) :-
    key_pairs(Profile, automated_decision_making_under_article_22, Pairs).

key_pairs(Profile, Key, [Key - Value]) :-
    profile_get(Profile, Key, Value).
key_pairs(Profile, Key, []) :-
    profile_lacks(Profile, Key).

order_keys([], _, []).
order_keys([Key|Keys], Present, Ordered) :-
    memberd_t(Key, Present, IsPresent),
    order_step(IsPresent, Key, Keys, Present, Ordered).

order_step(true, Key, Keys, Present, [Key|Ordered]) :-
    order_keys(Keys, Present, Ordered).
order_step(false, _, Keys, Present, Ordered) :-
    order_keys(Keys, Present, Ordered).

requirement_outcome(Profile, Route, Outcome) :-
    read_key(Profile, further_processing_start_date, Start),
    read_key(Profile, further_processing_information_date, Information),
    date_outcome(Start, Information, DateOutcome),
    read_key(Profile, further_processing_items_provided, Provided),
    read_key(Profile, items_data_subject_already_has, AlreadyHas),
    coverage_outcome(other_purpose_information, Provided, AlreadyHas, OtherPurposeOutcome),
    read_key(Profile, paragraph_2_information_relevant_to_further_processing, RelevanceReading),
    reading_outcome(RelevanceReading, paragraph_2_information_relevant_to_further_processing, Relevance),
    findall(ItemOutcome, paragraph_2_outcome(Profile, Route, Relevance, Provided, AlreadyHas, ItemOutcome), ItemOutcomes),
    conjoin_all([DateOutcome, OtherPurposeOutcome|ItemOutcomes], Outcome).

paragraph_2_outcome(Profile, Route, Relevance, Provided, AlreadyHas, Outcome) :-
    information_item_row(Item, Route, paragraph_2, _Citation, Condition),
    condition_outcome(Profile, Condition, ConditionOutcome),
    conjoin_outcomes(Relevance, ConditionOutcome, OwedOutcome),
    coverage_outcome(Item, Provided, AlreadyHas, CoverageOutcome),
    negate_outcome(OwedOutcome, NotOwedOutcome),
    disjoin_outcomes(NotOwedOutcome, CoverageOutcome, Outcome).

condition_outcome(_, always, true).
condition_outcome(Profile, Key, Outcome) :-
    dif(Key, always),
    read_key(Profile, Key, Reading),
    reading_outcome(Reading, Key, Outcome).

date_outcome(supplied(Start), supplied(Information), true) :-
    Information @< Start.
date_outcome(supplied(Start), supplied(Information), false) :-
    Information @>= Start.
date_outcome(not_supplied, supplied(_), unknown([further_processing_start_date], [])).
date_outcome(supplied(_), not_supplied, unknown([further_processing_information_date], [])).
date_outcome(not_supplied, not_supplied, unknown([further_processing_start_date, further_processing_information_date], [])).

coverage_outcome(Item, Provided, AlreadyHas, Outcome) :-
    list_outcome(Provided, Item, further_processing_items_provided, ProvidedOutcome),
    list_outcome(AlreadyHas, Item, items_data_subject_already_has, AlreadyHasOutcome),
    disjoin_outcomes(ProvidedOutcome, AlreadyHasOutcome, Outcome).

list_outcome(not_supplied, _, Key, unknown([Key], [])).
list_outcome(supplied(List), Item, _, Outcome) :-
    memberd_t(Item, List, Outcome).

reading_outcome(not_supplied, Key, unknown([Key], [])).
reading_outcome(supplied(true), _, true).
reading_outcome(supplied(false), _, false).
reading_outcome(supplied(unsure), Key, unknown([], [Key])).

read_key(Profile, Key, supplied(Value)) :-
    profile_get(Profile, Key, Value).
read_key(Profile, Key, not_supplied) :-
    profile_lacks(Profile, Key).

conjoin_outcomes(false, _, false).
conjoin_outcomes(true, RightOutcome, RightOutcome).
conjoin_outcomes(unknown(_, _), false, false).
conjoin_outcomes(unknown(Absent, Unsure), true, unknown(Absent, Unsure)).
conjoin_outcomes(unknown(LeftAbsent, LeftUnsure), unknown(RightAbsent, RightUnsure), unknown(Absent, Unsure)) :-
    append(LeftAbsent, RightAbsent, Absent),
    append(LeftUnsure, RightUnsure, Unsure).

disjoin_outcomes(true, _, true).
disjoin_outcomes(false, RightOutcome, RightOutcome).
disjoin_outcomes(unknown(_, _), true, true).
disjoin_outcomes(unknown(Absent, Unsure), false, unknown(Absent, Unsure)).
disjoin_outcomes(unknown(LeftAbsent, LeftUnsure), unknown(RightAbsent, RightUnsure), unknown(Absent, Unsure)) :-
    append(LeftAbsent, RightAbsent, Absent),
    append(LeftUnsure, RightUnsure, Unsure).

negate_outcome(true, false).
negate_outcome(false, true).
negate_outcome(unknown(Absent, Unsure), unknown(Absent, Unsure)).

conjoin_all([], true).
conjoin_all([Outcome|Outcomes], Result) :-
    conjoin_all(Outcomes, RestResult),
    conjoin_outcomes(Outcome, RestResult, Result).

decide_further_processing_information_verdict(Profile, further_processing_information_verdict_verdict(Status, Citations)) :-
    further_processing_information_verdict(Profile, Status, Citations).

further_processing_information_verdict_status(Profile, Status) :-
    further_processing_information_verdict(Profile, Status, _Citations).

further_processing_information_verdict_checklist(Profile, [item(information_before_further_processing, ItemStatus, Citation)]) :-
    further_processing_information_verdict(Profile, Verdict, Cites),
    checklist_status(Verdict, Cites, ItemStatus, Citation).

checklist_status(eligible, [Cite], met, Cite).
checklist_status(ineligible, [Cite], unmet(information_not_provided_before_further_processing), Cite).
checklist_status(not_applicable, [], inapplicable, cite(eu_reg_2016_679_art_13_3)).
checklist_status(indeterminate(Keys), [], unknown(Keys), cite(eu_reg_2016_679_art_13_3)).
checklist_status(needs_legal_review(_, _), [], unknown([judgement]), cite(eu_reg_2016_679_art_13_3)).
checklist_status(input_problems(_), [], unmet(input_problems), cite(eu_reg_2016_679_art_13_3)).

further_processing_information_verdict_decision_resolvable(Profile) :-
    further_processing_information_verdict(Profile, Verdict, _Citations),
    resolved_verdict(Verdict).

resolved_verdict(eligible).
resolved_verdict(ineligible).
resolved_verdict(not_applicable).

test(the_same_day_is_not_prior, fail) :-
    date_outcome(supplied(date(2026, 6, 1)), supplied(date(2026, 6, 1)), true).

test(the_day_before_is_prior) :-
    date_outcome(supplied(date(2026, 6, 1)), supplied(date(2026, 5, 31)), true).
test(false_dominates_unknown) :-
    conjoin_all([unknown([items_data_subject_already_has], []), false], false).
test(open_keys_follow_the_contract_order) :-
    open_key_order(Order),
    order_keys(Order, [further_processing_items_provided, items_data_subject_already_has, items_data_subject_already_has], [items_data_subject_already_has, further_processing_items_provided]).
