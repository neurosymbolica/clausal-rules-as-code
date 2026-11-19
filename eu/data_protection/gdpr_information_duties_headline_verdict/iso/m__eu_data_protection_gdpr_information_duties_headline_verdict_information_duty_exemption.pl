% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_information_duties_headline_verdict_information_duty_exemption, [information_duty_exemption/2, decide_information_duty_exemption/2, information_duty_exemption_status/2, information_duty_exemption_checklist/2, information_duty_exemption_decision_resolvable/1, information_duty_exemption_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_information_duties_headline_verdict_kernel, [gdpr_information_duties_headline_verdict_input_problems/2, key_status/3, attested_status/3]).
:- use_module(m__eu_data_protection_gdpr_information_duties_headline_verdict_citations, [implements/1]).

information_duty_exemption_status_values([none, impossible_or_disproportionate_effort, law_lays_down_obtaining_or_disclosure, professional_secrecy_obligation]).

exemption_ground(impossible_or_disproportionate_effort, cite(eu_reg_2016_679_art_14_5_b)).
exemption_ground(law_lays_down_obtaining_or_disclosure, cite(eu_reg_2016_679_art_14_5_c)).
exemption_ground(professional_secrecy_obligation, cite(eu_reg_2016_679_art_14_5_d)).

information_duty_exemption(Profile, Exemption) :-
    decide_information_duty_exemption(Profile, information_duty_exemption_result(Exemption, _Citations)).

decide_information_duty_exemption(Profile, Result) :-
    gdpr_information_duties_headline_verdict_input_problems(Profile, Problems),
    decide_checked(Problems, Profile, Result).

decide_checked([Problem|Problems], _, information_duty_exemption_result(input_problems([Problem|Problems]), [])).
decide_checked([], Profile, Result) :-
    key_status(Profile, personal_data_collected_from_data_subject, RouteStatus),
    route_exemption(RouteStatus, Profile, Result).

route_exemption(unknown(MissingKeys), _, information_duty_exemption_result(indeterminate(MissingKeys), [])) :-
    implements(eu_reg_2016_679_art_14_1).
route_exemption(value(true), _, information_duty_exemption_result(none, [])) :-
    implements(eu_reg_2016_679_art_13_1).
route_exemption(value(false), Profile, information_duty_exemption_result(Exemption, Citations)) :-
    implements(eu_reg_2016_679_art_14_5),
    limb_statuses(Profile, EffortLimb, LawLimb, SecrecyLimb),
    exemption_from_limbs(EffortLimb, LawLimb, SecrecyLimb, Exemption, Citations).

limb_statuses(Profile, EffortLimb, LawLimb, SecrecyLimb) :-
    key_status(Profile, provision_impossible_or_disproportionate_effort, EffortStatus),
    key_status(Profile, protective_measures_taken, MeasuresStatus),
    effort_limb(EffortStatus, MeasuresStatus, EffortLimb),
    attested_status(Profile, obtaining_or_disclosure_laid_down_by_law, LawStatus),
    law_limb(LawStatus, LawLimb),
    attested_status(Profile, professional_secrecy_obligation_by_law, SecrecyStatus),
    secrecy_limb(SecrecyStatus, SecrecyLimb).

effort_limb(value(true), value(true), met) :-
    implements(eu_reg_2016_679_art_14_5_b).
effort_limb(value(false), _, unmet) :-
    implements(eu_reg_2016_679_art_14_5_b).
effort_limb(value(true), value(false), unmet) :-
    implements(eu_reg_2016_679_art_14_5_b).
effort_limb(value(unsure), value(false), unmet) :-
    implements(eu_reg_2016_679_art_14_5_b).
effort_limb(unknown(_), value(false), unmet) :-
    implements(eu_reg_2016_679_art_14_5_b).
effort_limb(unknown(_), value(true), missing([provision_impossible_or_disproportionate_effort])) :-
    implements(eu_reg_2016_679_art_14_5_b).
effort_limb(unknown(_), unknown(_), missing([provision_impossible_or_disproportionate_effort, protective_measures_taken])) :-
    implements(eu_reg_2016_679_art_14_5_b).
effort_limb(value(true), unknown(_), missing([protective_measures_taken])) :-
    implements(eu_reg_2016_679_art_14_5_b).
effort_limb(value(unsure), unknown(_), missing([protective_measures_taken])) :-
    implements(eu_reg_2016_679_art_14_5_b).
effort_limb(value(unsure), value(true), unsure) :-
    implements(eu_reg_2016_679_art_14_5_b).

law_limb(value(true), met) :-
    implements(eu_reg_2016_679_art_14_5_c).
law_limb(value(false), unmet) :-
    implements(eu_reg_2016_679_art_14_5_c).
law_limb(absent, unmet) :-
    implements(eu_reg_2016_679_art_14_5_c).

secrecy_limb(value(true), met) :-
    implements(eu_reg_2016_679_art_14_5_d).
secrecy_limb(value(false), unmet) :-
    implements(eu_reg_2016_679_art_14_5_d).
secrecy_limb(absent, unmet) :-
    implements(eu_reg_2016_679_art_14_5_d).

exemption_from_limbs(met, _, _, impossible_or_disproportionate_effort, [Citation]) :-
    implements(eu_reg_2016_679_art_14_5_b),
    exemption_ground(impossible_or_disproportionate_effort, Citation).
exemption_from_limbs(EffortLimb, met, _, law_lays_down_obtaining_or_disclosure, [Citation]) :-
    implements(eu_reg_2016_679_art_14_5_c),
    limb_short_of_met(EffortLimb),
    exemption_ground(law_lays_down_obtaining_or_disclosure, Citation).
exemption_from_limbs(EffortLimb, unmet, met, professional_secrecy_obligation, [Citation]) :-
    implements(eu_reg_2016_679_art_14_5_d),
    limb_short_of_met(EffortLimb),
    exemption_ground(professional_secrecy_obligation, Citation).
exemption_from_limbs(unmet, unmet, unmet, none, []) :-
    implements(eu_reg_2016_679_art_14_5).
exemption_from_limbs(missing(MissingKeys), unmet, unmet, indeterminate(MissingKeys), []) :-
    implements(eu_reg_2016_679_art_14_5_b).
exemption_from_limbs(unsure, unmet, unmet, needs_legal_review(open_textured(provision_impossible_or_disproportionate_effort, cite(eu_reg_2016_679_art_14_5_b)), [inputs_relied_on([provision_impossible_or_disproportionate_effort - unsure])]), []) :-
    implements(eu_reg_2016_679_art_14_5_b).

limb_short_of_met(unmet).
limb_short_of_met(missing(_)).
limb_short_of_met(unsure).

information_duty_exemption_status(Profile, Status) :-
    decide_information_duty_exemption(Profile, information_duty_exemption_result(Status, _Citations)).

information_duty_exemption_checklist(Profile, Items) :-
    gdpr_information_duties_headline_verdict_input_problems(Profile, Problems),
    checklist_checked(Problems, Profile, Items).

checklist_checked([Problem|Problems], _, Items) :-
    ground_rows(unmet(input_problems([Problem|Problems])), unmet(input_problems([Problem|Problems])), unmet(input_problems([Problem|Problems])), Items).
checklist_checked([], Profile, Items) :-
    key_status(Profile, personal_data_collected_from_data_subject, RouteStatus),
    checklist_route(RouteStatus, Profile, Items).

checklist_route(unknown(MissingKeys), _, Items) :-
    ground_rows(unknown(MissingKeys), unknown(MissingKeys), unknown(MissingKeys), Items).
checklist_route(value(true), _, Items) :-
    ground_rows(unmet(article_13_route), unmet(article_13_route), unmet(article_13_route), Items).
checklist_route(value(false), Profile, Items) :-
    limb_statuses(Profile, EffortLimb, LawLimb, SecrecyLimb),
    item_status(EffortLimb, EffortStatus),
    item_status(LawLimb, LawStatus),
    item_status(SecrecyLimb, SecrecyStatus),
    ground_rows(EffortStatus, LawStatus, SecrecyStatus, Items).

ground_rows(EffortStatus, LawStatus, SecrecyStatus, [item(impossible_or_disproportionate_effort, EffortStatus, EffortCitation), item(law_lays_down_obtaining_or_disclosure, LawStatus, LawCitation), item(professional_secrecy_obligation, SecrecyStatus, SecrecyCitation)]) :-
    exemption_ground(impossible_or_disproportionate_effort, EffortCitation),
    exemption_ground(law_lays_down_obtaining_or_disclosure, LawCitation),
    exemption_ground(professional_secrecy_obligation, SecrecyCitation).

item_status(met, met).
item_status(unmet, unmet(exemption_condition_not_met)).
item_status(missing(MissingKeys), unknown(MissingKeys)).
item_status(unsure, unknown([provision_impossible_or_disproportionate_effort])).

information_duty_exemption_decision_resolvable(Profile) :-
    decide_information_duty_exemption(Profile, _Result).

attested_true(attested(true, attestation(by, at, reason, none))).

attested_false(attested(false, attestation(by, at, reason, none))).

test(article_13_route_is_none) :-
    attested_true(Fact),
    information_duty_exemption([attribute(personal_data_collected_from_data_subject, true), attribute(professional_secrecy_obligation_by_law, Fact)], none).
test(route_unknown_names_the_route_key) :-
    attested_true(Fact),
    information_duty_exemption([attribute(obtaining_or_disclosure_laid_down_by_law, Fact), attribute(provision_impossible_or_disproportionate_effort, true), attribute(protective_measures_taken, true)], indeterminate([personal_data_collected_from_data_subject])).
test(effort_and_measures_meet_limb_b) :-
    information_duty_exemption([attribute(personal_data_collected_from_data_subject, false), attribute(provision_impossible_or_disproportionate_effort, true), attribute(protective_measures_taken, true)], impossible_or_disproportionate_effort).
test(effort_and_measures_cite_limb_b) :-
    decide_information_duty_exemption([attribute(personal_data_collected_from_data_subject, false), attribute(provision_impossible_or_disproportionate_effort, true), attribute(protective_measures_taken, true)], information_duty_exemption_result(impossible_or_disproportionate_effort, [cite(eu_reg_2016_679_art_14_5_b)])).
test(effort_without_measures_is_none) :-
    information_duty_exemption([attribute(personal_data_collected_from_data_subject, false), attribute(provision_impossible_or_disproportionate_effort, true), attribute(protective_measures_taken, false)], none).
test(law_attested_true_wins_over_absent_limb_b) :-
    attested_true(Fact),
    information_duty_exemption([attribute(personal_data_collected_from_data_subject, false), attribute(obtaining_or_disclosure_laid_down_by_law, Fact)], law_lays_down_obtaining_or_disclosure).
test(secrecy_attested_true_after_law_false) :-
    attested_true(TrueFact),
    attested_false(FalseFact),
    information_duty_exemption([attribute(personal_data_collected_from_data_subject, false), attribute(provision_impossible_or_disproportionate_effort, false), attribute(obtaining_or_disclosure_laid_down_by_law, FalseFact), attribute(professional_secrecy_obligation_by_law, TrueFact)], professional_secrecy_obligation).
test(limb_b_first_when_all_met) :-
    attested_true(Fact),
    findall(Exemption, information_duty_exemption([attribute(personal_data_collected_from_data_subject, false), attribute(provision_impossible_or_disproportionate_effort, true), attribute(protective_measures_taken, true), attribute(obtaining_or_disclosure_laid_down_by_law, Fact), attribute(professional_secrecy_obligation_by_law, Fact)], Exemption), Exemptions),
    Exemptions == [impossible_or_disproportionate_effort].
test(both_limb_b_keys_absent_are_both_named) :-
    information_duty_exemption([attribute(personal_data_collected_from_data_subject, false)], indeterminate([provision_impossible_or_disproportionate_effort, protective_measures_taken])).
test(effort_absent_with_measures_names_effort) :-
    information_duty_exemption([attribute(personal_data_collected_from_data_subject, false), attribute(protective_measures_taken, true)], indeterminate([provision_impossible_or_disproportionate_effort])).
test(effort_absent_with_measures_false_is_none) :-
    information_duty_exemption([attribute(personal_data_collected_from_data_subject, false), attribute(protective_measures_taken, false)], none).
test(unsure_effort_without_measures_names_measures) :-
    information_duty_exemption([attribute(personal_data_collected_from_data_subject, false), attribute(provision_impossible_or_disproportionate_effort, unsure)], indeterminate([protective_measures_taken])).
test(unsure_effort_with_measures_refers) :-
    information_duty_exemption([attribute(personal_data_collected_from_data_subject, false), attribute(provision_impossible_or_disproportionate_effort, unsure), attribute(protective_measures_taken, true)], needs_legal_review(open_textured(provision_impossible_or_disproportionate_effort, cite(eu_reg_2016_679_art_14_5_b)), [inputs_relied_on([provision_impossible_or_disproportionate_effort - unsure])])).
test(absent_facts_never_open_the_answer) :-
    information_duty_exemption([attribute(personal_data_collected_from_data_subject, false), attribute(provision_impossible_or_disproportionate_effort, false)], none).
test(input_problems_come_first) :-
    information_duty_exemption([attribute(personal_data_collected_from_data_subject, false), attribute(colour, red)], input_problems([unknown_key(colour)])).
test(not_a_profile_is_an_input_problem) :-
    information_duty_exemption(foo, input_problems([wrong_type(profile)])).
test(one_solution_per_query) :-
    findall(Exemption, information_duty_exemption([attribute(personal_data_collected_from_data_subject, false), attribute(provision_impossible_or_disproportionate_effort, false), attribute(protective_measures_taken, false)], Exemption), Exemptions),
    Exemptions == [none].
test(checklist_has_one_row_per_ground) :-
    information_duty_exemption_checklist([attribute(personal_data_collected_from_data_subject, false), attribute(provision_impossible_or_disproportionate_effort, true), attribute(protective_measures_taken, true)], [item(impossible_or_disproportionate_effort, met, cite(eu_reg_2016_679_art_14_5_b)), item(law_lays_down_obtaining_or_disclosure, unmet(exemption_condition_not_met), cite(eu_reg_2016_679_art_14_5_c)), item(professional_secrecy_obligation, unmet(exemption_condition_not_met), cite(eu_reg_2016_679_art_14_5_d))]).
test(status_projection) :-
    information_duty_exemption_status([attribute(personal_data_collected_from_data_subject, true)], none).
test(every_profile_resolves) :-
    information_duty_exemption_decision_resolvable([]).

test(article_13_route_is_not_secrecy, fail) :-
    attested_true(Fact),
    information_duty_exemption([attribute(personal_data_collected_from_data_subject, true), attribute(professional_secrecy_obligation_by_law, Fact)], professional_secrecy_obligation).
test(effort_without_measures_is_not_exempt, fail) :-
    information_duty_exemption([attribute(personal_data_collected_from_data_subject, false), attribute(provision_impossible_or_disproportionate_effort, true), attribute(protective_measures_taken, false)], impossible_or_disproportionate_effort).
test(unsure_effort_with_measures_is_not_none, fail) :-
    information_duty_exemption([attribute(personal_data_collected_from_data_subject, false), attribute(provision_impossible_or_disproportionate_effort, unsure), attribute(protective_measures_taken, true)], none).
