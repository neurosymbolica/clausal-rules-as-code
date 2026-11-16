% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_information_duties_headline_verdict_information_duty_exemption, [decide_information_duty_exemption/2, information_duty_exemption/2, information_duty_exemption_status/2, information_duty_exemption_checklist/2, information_duty_exemption_decision_resolvable/1, information_duty_exemption_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_information_duties_headline_verdict_kernel, [gdpr_information_duties_headline_verdict_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_information_duties_headline_verdict_citations, [implements/1]).
:- use_module(formalize_lib, [profile_get/3, profile_lacks/2]).

information_duty_exemption_status_values([none, impossible_or_disproportionate_effort, law_lays_down_obtaining_or_disclosure, professional_secrecy_obligation]).

exemption_ground(impossible_or_disproportionate_effort, cite(eu_reg_2016_679_art_14_5_b)).
exemption_ground(law_lays_down_obtaining_or_disclosure, cite(eu_reg_2016_679_art_14_5_c)).
exemption_ground(professional_secrecy_obligation, cite(eu_reg_2016_679_art_14_5_d)).

value_or_absent(Profile, Key, Value) :-
    profile_get(Profile, Key, Value).
value_or_absent(Profile, Key, absent) :-
    profile_lacks(Profile, Key).

attested_truth(Profile, Key, Truth) :-
    profile_get(Profile, Key, attested(Truth, _Attestation)).
attested_truth(Profile, Key, false) :-
    profile_lacks(Profile, Key).

effort_limb(Profile, State) :-
    implements(eu_reg_2016_679_art_14_5_b),
    value_or_absent(Profile, provision_impossible_or_disproportionate_effort, EffortJudgement),
    value_or_absent(Profile, protective_measures_taken, MeasuresFlag),
    effort_state(EffortJudgement, MeasuresFlag, State).

effort_state(true, true, met) :-
    implements(eu_reg_2016_679_art_14_5_b).
effort_state(true, false, unmet) :-
    implements(eu_reg_2016_679_art_14_5_b).
effort_state(true, absent, open(absent([protective_measures_taken]))) :-
    implements(eu_reg_2016_679_art_14_5_b).
effort_state(false, _, unmet) :-
    implements(eu_reg_2016_679_art_14_5_b).
effort_state(absent, true, open(absent([provision_impossible_or_disproportionate_effort]))) :-
    implements(eu_reg_2016_679_art_14_5_b).
effort_state(absent, false, unmet) :-
    implements(eu_reg_2016_679_art_14_5_b).
effort_state(absent, absent, open(absent([provision_impossible_or_disproportionate_effort]))) :-
    implements(eu_reg_2016_679_art_14_5_b).
effort_state(unsure, false, unmet) :-
    implements(eu_reg_2016_679_art_14_5_b).
effort_state(unsure, true, open(unsure)) :-
    implements(eu_reg_2016_679_art_14_5_b).
effort_state(unsure, absent, open(unsure)) :-
    implements(eu_reg_2016_679_art_14_5_b).

combine(met, _, _, impossible_or_disproportionate_effort).
combine(unmet, true, _, law_lays_down_obtaining_or_disclosure).
combine(unmet, false, true, professional_secrecy_obligation).
combine(unmet, false, false, none).
combine(open(_), true, _, law_lays_down_obtaining_or_disclosure).
combine(open(_), false, true, professional_secrecy_obligation).
combine(open(absent(Keys)), false, false, indeterminate(Keys)).
combine(open(unsure), false, false, needs_legal_review(open_textured(provision_impossible_or_disproportionate_effort, cite(eu_reg_2016_679_art_14_5_b)), [inputs_relied_on([provision_impossible_or_disproportionate_effort - unsure])])).

art14_exemption(Profile, Exemption) :-
    implements(eu_reg_2016_679_art_14_5),
    implements(eu_reg_2016_679_art_14_5_c),
    implements(eu_reg_2016_679_art_14_5_d),
    effort_limb(Profile, EffortState),
    attested_truth(Profile, obtaining_or_disclosure_laid_down_by_law, LawTruth),
    attested_truth(Profile, professional_secrecy_obligation_by_law, SecrecyTruth),
    combine(EffortState, LawTruth, SecrecyTruth, Exemption).

route_exemption(true, _, none).
route_exemption(absent, _, indeterminate([personal_data_collected_from_data_subject])).
route_exemption(false, Profile, Exemption) :-
    art14_exemption(Profile, Exemption).

information_duty_exemption(Profile, Exemption) :-
    gdpr_information_duties_headline_verdict_input_problems(Profile, ProblemList),
    exemption_for(ProblemList, Profile, Exemption).

exemption_for([Problem|Problems], _, input_problems([Problem|Problems])).
exemption_for([], Profile, Exemption) :-
    value_or_absent(Profile, personal_data_collected_from_data_subject, RouteValue),
    route_exemption(RouteValue, Profile, Exemption).

decide_information_duty_exemption(Profile, information_duty_exemption_verdict(Status, Citations)) :-
    information_duty_exemption(Profile, Status),
    verdict_citations(Status, Citations).

verdict_citations(impossible_or_disproportionate_effort, [Citation]) :-
    exemption_ground(impossible_or_disproportionate_effort, Citation).
verdict_citations(law_lays_down_obtaining_or_disclosure, [Citation]) :-
    exemption_ground(law_lays_down_obtaining_or_disclosure, Citation).
verdict_citations(professional_secrecy_obligation, [Citation]) :-
    exemption_ground(professional_secrecy_obligation, Citation).
verdict_citations(none, []).
verdict_citations(indeterminate(_), []).
verdict_citations(needs_legal_review(_, _), []).
verdict_citations(input_problems(_), []).

information_duty_exemption_status(Profile, Status) :-
    decide_information_duty_exemption(Profile, information_duty_exemption_verdict(Status, _Citations)).

information_duty_exemption_checklist(Profile, Items) :-
    gdpr_information_duties_headline_verdict_input_problems(Profile, ProblemList),
    checklist_for(ProblemList, Profile, Items).

checklist_for([_|_], _, [item(overall, unknown([input_problems]), cite(eu_reg_2016_679_art_14_5))]).
checklist_for([], Profile, Items) :-
    value_or_absent(Profile, personal_data_collected_from_data_subject, RouteValue),
    checklist_route(RouteValue, Profile, Items).

checklist_route(true, _, [item(overall, unmet(art13_route_has_no_exemption), cite(eu_reg_2016_679_art_14_5))]).
checklist_route(absent, _, [item(overall, unknown([personal_data_collected_from_data_subject]), cite(eu_reg_2016_679_art_14_5))]).
checklist_route(false, Profile, [item(impossible_or_disproportionate_effort, EffortStatus, cite(eu_reg_2016_679_art_14_5_b)), item(law_lays_down_obtaining_or_disclosure, LawStatus, cite(eu_reg_2016_679_art_14_5_c)), item(professional_secrecy_obligation, SecrecyStatus, cite(eu_reg_2016_679_art_14_5_d))]) :-
    effort_limb(Profile, EffortState),
    state_status(EffortState, EffortStatus),
    attested_truth(Profile, obtaining_or_disclosure_laid_down_by_law, LawTruth),
    truth_status(LawTruth, LawStatus),
    attested_truth(Profile, professional_secrecy_obligation_by_law, SecrecyTruth),
    truth_status(SecrecyTruth, SecrecyStatus).

state_status(met, met).
state_status(unmet, unmet(not_met)).
state_status(open(absent(Keys)), unknown(Keys)).
state_status(open(unsure), unknown([provision_impossible_or_disproportionate_effort])).

truth_status(true, met).
truth_status(false, unmet(not_attested_true)).

information_duty_exemption_decision_resolvable(Profile) :-
    decide_information_duty_exemption(Profile, _Verdict).

test(art13_route_has_no_exemption) :-
    information_duty_exemption([attribute(personal_data_collected_from_data_subject, true)], none).
test(effort_with_measures_is_met) :-
    information_duty_exemption([attribute(personal_data_collected_from_data_subject, false), attribute(provision_impossible_or_disproportionate_effort, true), attribute(protective_measures_taken, true)], impossible_or_disproportionate_effort).
test(effort_without_measures_is_unmet) :-
    information_duty_exemption([attribute(personal_data_collected_from_data_subject, false), attribute(provision_impossible_or_disproportionate_effort, true), attribute(protective_measures_taken, false)], none).
test(effort_judgement_absent_is_indeterminate) :-
    information_duty_exemption([attribute(personal_data_collected_from_data_subject, false)], indeterminate([provision_impossible_or_disproportionate_effort])).
test(effort_true_measures_absent_names_measures) :-
    information_duty_exemption([attribute(personal_data_collected_from_data_subject, false), attribute(provision_impossible_or_disproportionate_effort, true)], indeterminate([protective_measures_taken])).
test(effort_unsure_is_referred) :-
    information_duty_exemption([attribute(personal_data_collected_from_data_subject, false), attribute(provision_impossible_or_disproportionate_effort, unsure)], needs_legal_review(open_textured(provision_impossible_or_disproportionate_effort, cite(eu_reg_2016_679_art_14_5_b)), [inputs_relied_on([provision_impossible_or_disproportionate_effort - unsure])])).
test(law_attested_true_wins_over_absent_effort) :-
    information_duty_exemption([attribute(personal_data_collected_from_data_subject, false), attribute(obtaining_or_disclosure_laid_down_by_law, attested(true, attestation(host, none, statute, none)))], law_lays_down_obtaining_or_disclosure).
test(secrecy_attested_true_is_met) :-
    information_duty_exemption([attribute(personal_data_collected_from_data_subject, false), attribute(provision_impossible_or_disproportionate_effort, false), attribute(professional_secrecy_obligation_by_law, attested(true, attestation(host, none, statute, none)))], professional_secrecy_obligation).
test(law_attested_false_is_unmet) :-
    information_duty_exemption([attribute(personal_data_collected_from_data_subject, false), attribute(provision_impossible_or_disproportionate_effort, false), attribute(obtaining_or_disclosure_laid_down_by_law, attested(false, attestation(host, none, statute, none)))], none).
test(route_absent_names_route) :-
    information_duty_exemption([], indeterminate([personal_data_collected_from_data_subject])).
test(input_problem_is_reported) :-
    information_duty_exemption([attribute(no_such_key, true)], input_problems([unknown_key(no_such_key)])).
test(verdict_carries_citation) :-
    decide_information_duty_exemption([attribute(personal_data_collected_from_data_subject, false), attribute(provision_impossible_or_disproportionate_effort, true), attribute(protective_measures_taken, true)], information_duty_exemption_verdict(impossible_or_disproportionate_effort, [cite(eu_reg_2016_679_art_14_5_b)])).
test(checklist_has_three_rows_on_art14) :-
    information_duty_exemption_checklist([attribute(personal_data_collected_from_data_subject, false)], Items),
    length(Items, 3).

test(art13_route_is_not_an_exemption, fail) :-
    information_duty_exemption([attribute(personal_data_collected_from_data_subject, true)], impossible_or_disproportionate_effort).
test(effort_without_measures_is_not_met, fail) :-
    information_duty_exemption([attribute(personal_data_collected_from_data_subject, false), attribute(provision_impossible_or_disproportionate_effort, true), attribute(protective_measures_taken, false)], impossible_or_disproportionate_effort).
