% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_information_duties_timing_information_timing_verdict, [decide_information_timing_verdict/2, information_timing_verdict_status/2, information_timing_verdict_checklist/2, information_timing_verdict_decision_resolvable/1, information_timing_verdict_status_values/1, information_timing_verdict/3]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(formalize_lib, [profile_get/3, profile_has/2, profile_lacks/2]).
:- use_module(m__eu_data_protection_gdpr_information_duties_timing_kernel, [gdpr_information_duties_timing_date_order/3]).
:- use_module(m__eu_data_protection_gdpr_information_duties_timing_citations, [implements/1]).
:- use_module(m__eu_data_protection_gdpr_information_duties_timing_information_deadline_basis, [information_deadline_basis_outcome/2]).

information_timing_verdict_status_values([timely, late]).

article_14_basis(art14_3_a, cite(eu_reg_2016_679_art_14_3_a)).
article_14_basis(art14_3_b, cite(eu_reg_2016_679_art_14_3_b)).
article_14_basis(art14_3_c, cite(eu_reg_2016_679_art_14_3_c)).

basis_citation(art13_1, cite(eu_reg_2016_679_art_13_1)).
basis_citation(art14_3_a, cite(eu_reg_2016_679_art_14_3_a)).
basis_citation(art14_3_b, cite(eu_reg_2016_679_art_14_3_b)).
basis_citation(art14_3_c, cite(eu_reg_2016_679_art_14_3_c)).

contract_position(personal_data_collected_from_data_subject, 1).
contract_position(obtaining_date, 10).
contract_position(provision_date, 11).
contract_position(data_used_for_communication_with_data_subject, 12).
contract_position(first_communication_date, 13).
contract_position(disclosure_to_another_recipient_envisaged, 14).
contract_position(first_disclosure_date, 15).
contract_position(provided_within_reasonable_period, 16).

order_standing(before, on_time).
order_standing(same, on_time).
order_standing(after, past_deadline).

timing_stage(Profile, Stage) :-
    information_deadline_basis_outcome(Profile, Outcome),
    outcome_stage(Outcome, Profile, Stage).

outcome_stage(input_problems(Problems), _, problems(Problems)).
outcome_stage(indeterminate(MissingKeys), Profile, deadline_open(AllMissingKeys)) :-
    provision_keys(Profile, MissingKeys, AllMissingKeys).
outcome_stage(deadline(DeadlineDate, Basis), Profile, Stage) :-
    provision_stage(Profile, DeadlineDate, Basis, Stage).

provision_keys(Profile, MissingKeys, MissingKeys) :-
    profile_has(Profile, provision_date).
provision_keys(Profile, MissingKeys, AllMissingKeys) :-
    profile_lacks(Profile, provision_date),
    insert_in_contract_order(MissingKeys, provision_date, AllMissingKeys).

insert_in_contract_order([], NewKey, [NewKey]).
insert_in_contract_order([ProfileKey|ProfileKeys], NewKey, Result) :-
    contract_position(ProfileKey, KeyPosition),
    contract_position(NewKey, NewPosition),
    compare(Order, KeyPosition, NewPosition),
    insert_step(Order, ProfileKey, ProfileKeys, NewKey, Result).

insert_step(<, ProfileKey, ProfileKeys, NewKey, [ProfileKey|Rest]) :-
    insert_in_contract_order(ProfileKeys, NewKey, Rest).
insert_step(>, ProfileKey, ProfileKeys, NewKey, [NewKey, ProfileKey|ProfileKeys]).

provision_stage(Profile, _, Basis, provision_open(Basis)) :-
    profile_lacks(Profile, provision_date).
provision_stage(Profile, DeadlineDate, Basis, Stage) :-
    profile_has(Profile, provision_date),
    profile_get(Profile, provision_date, ProvisionDate),
    gdpr_information_duties_timing_date_order(ProvisionDate, DeadlineDate, Order),
    order_standing(Order, Standing),
    standing_stage(Standing, Basis, Profile, Stage).

standing_stage(past_deadline, art13_1, _, past(art13_1)) :-
    implements(eu_reg_2016_679_art_13_1).
standing_stage(on_time, art13_1, _, on_time_article_13) :-
    implements(eu_reg_2016_679_art_13_1).
standing_stage(past_deadline, Basis, _, past(Basis)) :-
    implements(eu_reg_2016_679_art_14_3),
    article_14_basis(Basis, _).
standing_stage(on_time, Basis, Profile, on_time_article_14(Basis, Judgement)) :-
    implements(eu_reg_2016_679_art_14_3_a),
    article_14_basis(Basis, _),
    reasonable_period_judgement(Profile, Judgement).

reasonable_period_judgement(Profile, absent) :-
    profile_lacks(Profile, provided_within_reasonable_period).
reasonable_period_judgement(Profile, Judgement) :-
    profile_has(Profile, provided_within_reasonable_period),
    profile_get(Profile, provided_within_reasonable_period, Judgement).

stage_verdict(problems(Problems), input_problems(Problems), []).
stage_verdict(deadline_open(MissingKeys), indeterminate(MissingKeys), []).
stage_verdict(provision_open(_), indeterminate([provision_date]), []).
stage_verdict(past(art13_1), late, [cite(eu_reg_2016_679_art_13_1)]) :-
    implements(eu_reg_2016_679_art_13_1).
stage_verdict(past(Basis), late, [Citation]) :-
    implements(eu_reg_2016_679_art_14_3),
    article_14_basis(Basis, Citation).
stage_verdict(on_time_article_13, timely, [cite(eu_reg_2016_679_art_13_1)]) :-
    implements(eu_reg_2016_679_art_13_1).
stage_verdict(on_time_article_14(Basis, true), timely, [Citation]) :-
    implements(eu_reg_2016_679_art_14_3_a),
    article_14_basis(Basis, Citation).
stage_verdict(on_time_article_14(_, false), late, [cite(eu_reg_2016_679_art_14_3_a)]) :-
    implements(eu_reg_2016_679_art_14_3_a).
stage_verdict(on_time_article_14(_, unsure), needs_legal_review(open_textured(provided_within_reasonable_period, cite(eu_reg_2016_679_art_14_3_a)), [inputs_relied_on([provided_within_reasonable_period - unsure]), provenance(reasonable_period_for_art14_information, [cite(eu_reg_2016_679_art_14_3_a)])]), []) :-
    implements(eu_reg_2016_679_art_14_3_a).
stage_verdict(on_time_article_14(_, absent), indeterminate([provided_within_reasonable_period]), []).

information_timing_verdict(Profile, Verdict, Citations) :-
    timing_stage(Profile, Stage),
    stage_verdict(Stage, Verdict, Citations).

decide_information_timing_verdict(Profile, information_timing_verdict_verdict(Status, Citations)) :-
    information_timing_verdict(Profile, Status, Citations).

information_timing_verdict_status(Profile, Status) :-
    decide_information_timing_verdict(Profile, information_timing_verdict_verdict(Status, _Citations)).

information_timing_verdict_checklist(Profile, [item(provided_by_deadline, DeadlineStatus, DeadlineCitation), item(provided_within_reasonable_period, PeriodStatus, cite(eu_reg_2016_679_art_14_3_a))]) :-
    timing_stage(Profile, Stage),
    deadline_row_status(Stage, DeadlineStatus),
    stage_citation(Stage, Profile, DeadlineCitation),
    period_row_status(Stage, PeriodStatus).

deadline_row_status(problems(Problems), unmet(input_problems(Problems))).
deadline_row_status(deadline_open(MissingKeys), unknown(MissingKeys)).
deadline_row_status(provision_open(_), unknown([provision_date])).
deadline_row_status(past(_), unmet(provided_after_the_deadline)).
deadline_row_status(on_time_article_13, met).
deadline_row_status(on_time_article_14(_, _), met).

period_row_status(problems(Problems), unmet(input_problems(Problems))).
period_row_status(deadline_open(MissingKeys), unknown(MissingKeys)).
period_row_status(provision_open(art13_1), inapplicable).
period_row_status(provision_open(Basis), unknown([provision_date])) :-
    article_14_basis(Basis, _).
period_row_status(past(_), inapplicable).
period_row_status(on_time_article_13, inapplicable).
period_row_status(on_time_article_14(_, true), met).
period_row_status(on_time_article_14(_, false), unmet(not_within_a_reasonable_period)).
period_row_status(on_time_article_14(_, unsure), unknown([provided_within_reasonable_period])).
period_row_status(on_time_article_14(_, absent), unknown([provided_within_reasonable_period])).

stage_citation(problems(_), _, cite(eu_reg_2016_679_art_13_1)).
stage_citation(deadline_open(_), Profile, Citation) :-
    route_citation(Profile, Citation).
stage_citation(provision_open(Basis), _, Citation) :-
    basis_citation(Basis, Citation).
stage_citation(past(Basis), _, Citation) :-
    basis_citation(Basis, Citation).
stage_citation(on_time_article_13, _, cite(eu_reg_2016_679_art_13_1)).
stage_citation(on_time_article_14(Basis, _), _, Citation) :-
    basis_citation(Basis, Citation).

route_citation(Profile, cite(eu_reg_2016_679_art_13_1)) :-
    profile_lacks(Profile, personal_data_collected_from_data_subject).
route_citation(Profile, cite(eu_reg_2016_679_art_13_1)) :-
    profile_has(Profile, personal_data_collected_from_data_subject),
    profile_get(Profile, personal_data_collected_from_data_subject, true).
route_citation(Profile, cite(eu_reg_2016_679_art_14_3_a)) :-
    profile_has(Profile, personal_data_collected_from_data_subject),
    profile_get(Profile, personal_data_collected_from_data_subject, false).

information_timing_verdict_decision_resolvable(Profile) :-
    decide_information_timing_verdict(Profile, _Verdict).

test(art13_on_the_obtaining_day_is_timely) :-
    information_timing_verdict([attribute(personal_data_collected_from_data_subject, true), attribute(obtaining_date, date(2026, 3, 10)), attribute(provision_date, date(2026, 3, 10))], timely, [cite(eu_reg_2016_679_art_13_1)]).
test(art13_before_the_obtaining_day_is_timely) :-
    information_timing_verdict([attribute(personal_data_collected_from_data_subject, true), attribute(obtaining_date, date(2026, 3, 10)), attribute(provision_date, date(2026, 3, 1))], timely, [cite(eu_reg_2016_679_art_13_1)]).
test(art13_after_the_obtaining_day_is_late) :-
    information_timing_verdict([attribute(personal_data_collected_from_data_subject, true), attribute(obtaining_date, date(2026, 3, 10)), attribute(provision_date, date(2026, 3, 11))], late, [cite(eu_reg_2016_679_art_13_1)]).
test(art13_ignores_the_reasonable_period_judgement) :-
    information_timing_verdict([attribute(personal_data_collected_from_data_subject, true), attribute(obtaining_date, date(2026, 3, 10)), attribute(provision_date, date(2026, 3, 10)), attribute(provided_within_reasonable_period, false)], timely, [cite(eu_reg_2016_679_art_13_1)]).
test(art14_on_the_last_day_and_reasonable_is_timely) :-
    information_timing_verdict([attribute(personal_data_collected_from_data_subject, false), attribute(obtaining_date, date(2026, 1, 15)), attribute(provision_date, date(2026, 2, 16)), attribute(data_used_for_communication_with_data_subject, false), attribute(disclosure_to_another_recipient_envisaged, false), attribute(provided_within_reasonable_period, true)], timely, [cite(eu_reg_2016_679_art_14_3_a)]).
test(art14_after_the_month_is_late_whatever_the_judgement) :-
    information_timing_verdict([attribute(personal_data_collected_from_data_subject, false), attribute(obtaining_date, date(2026, 1, 15)), attribute(provision_date, date(2026, 2, 17)), attribute(data_used_for_communication_with_data_subject, false), attribute(disclosure_to_another_recipient_envisaged, false), attribute(provided_within_reasonable_period, true)], late, [cite(eu_reg_2016_679_art_14_3_a)]).
test(art14_late_needs_no_judgement) :-
    information_timing_verdict([attribute(personal_data_collected_from_data_subject, false), attribute(obtaining_date, date(2026, 1, 15)), attribute(provision_date, date(2026, 2, 17)), attribute(data_used_for_communication_with_data_subject, false), attribute(disclosure_to_another_recipient_envisaged, false)], late, [cite(eu_reg_2016_679_art_14_3_a)]).
test(art14_on_time_but_unreasonable_is_late) :-
    information_timing_verdict([attribute(personal_data_collected_from_data_subject, false), attribute(obtaining_date, date(2026, 1, 15)), attribute(provision_date, date(2026, 2, 10)), attribute(data_used_for_communication_with_data_subject, false), attribute(disclosure_to_another_recipient_envisaged, false), attribute(provided_within_reasonable_period, false)], late, [cite(eu_reg_2016_679_art_14_3_a)]).
test(art14_on_time_and_unsure_needs_legal_review) :-
    information_timing_verdict([attribute(personal_data_collected_from_data_subject, false), attribute(obtaining_date, date(2026, 1, 15)), attribute(provision_date, date(2026, 2, 10)), attribute(data_used_for_communication_with_data_subject, false), attribute(disclosure_to_another_recipient_envisaged, false), attribute(provided_within_reasonable_period, unsure)], needs_legal_review(open_textured(provided_within_reasonable_period, cite(eu_reg_2016_679_art_14_3_a)), [inputs_relied_on([provided_within_reasonable_period - unsure])|_]), []).
test(art14_on_time_without_judgement_is_indeterminate) :-
    information_timing_verdict([attribute(personal_data_collected_from_data_subject, false), attribute(obtaining_date, date(2026, 1, 15)), attribute(provision_date, date(2026, 2, 10)), attribute(data_used_for_communication_with_data_subject, false), attribute(disclosure_to_another_recipient_envisaged, false)], indeterminate([provided_within_reasonable_period]), []).
test(art14_first_communication_binds_late) :-
    information_timing_verdict([attribute(personal_data_collected_from_data_subject, false), attribute(obtaining_date, date(2026, 1, 15)), attribute(provision_date, date(2026, 1, 21)), attribute(data_used_for_communication_with_data_subject, true), attribute(first_communication_date, date(2026, 1, 20)), attribute(disclosure_to_another_recipient_envisaged, false), attribute(provided_within_reasonable_period, true)], late, [cite(eu_reg_2016_679_art_14_3_b)]).
test(art14_first_communication_binds_timely) :-
    information_timing_verdict([attribute(personal_data_collected_from_data_subject, false), attribute(obtaining_date, date(2026, 1, 15)), attribute(provision_date, date(2026, 1, 20)), attribute(data_used_for_communication_with_data_subject, true), attribute(first_communication_date, date(2026, 1, 20)), attribute(disclosure_to_another_recipient_envisaged, false), attribute(provided_within_reasonable_period, true)], timely, [cite(eu_reg_2016_679_art_14_3_b)]).
test(art14_unreasonable_under_a_shorter_limb_cites_limb_a) :-
    information_timing_verdict([attribute(personal_data_collected_from_data_subject, false), attribute(obtaining_date, date(2026, 1, 15)), attribute(provision_date, date(2026, 1, 20)), attribute(data_used_for_communication_with_data_subject, true), attribute(first_communication_date, date(2026, 1, 20)), attribute(disclosure_to_another_recipient_envisaged, false), attribute(provided_within_reasonable_period, false)], late, [cite(eu_reg_2016_679_art_14_3_a)]).
test(art14_first_disclosure_binds_late) :-
    information_timing_verdict([attribute(personal_data_collected_from_data_subject, false), attribute(obtaining_date, date(2026, 1, 15)), attribute(provision_date, date(2026, 1, 31)), attribute(data_used_for_communication_with_data_subject, false), attribute(disclosure_to_another_recipient_envisaged, true), attribute(first_disclosure_date, date(2026, 1, 30))], late, [cite(eu_reg_2016_679_art_14_3_c)]).
test(an_unknown_route_names_route_obtaining_and_provision) :-
    information_timing_verdict([], indeterminate([personal_data_collected_from_data_subject, obtaining_date, provision_date]), []).
test(an_unknown_route_never_names_the_article_14_flags) :-
    information_timing_verdict([attribute(obtaining_date, date(2026, 1, 15)), attribute(provision_date, date(2026, 1, 15))], indeterminate([personal_data_collected_from_data_subject]), []).
test(provision_date_is_merged_in_contract_order) :-
    information_timing_verdict([attribute(personal_data_collected_from_data_subject, false)], indeterminate([obtaining_date, provision_date, data_used_for_communication_with_data_subject, disclosure_to_another_recipient_envisaged]), []).
test(provision_date_after_the_obtaining_date_slot) :-
    information_timing_verdict([attribute(personal_data_collected_from_data_subject, false), attribute(obtaining_date, date(2026, 1, 15)), attribute(data_used_for_communication_with_data_subject, true), attribute(disclosure_to_another_recipient_envisaged, false)], indeterminate([provision_date, first_communication_date]), []).
test(an_absent_provision_date_is_indeterminate) :-
    information_timing_verdict([attribute(personal_data_collected_from_data_subject, true), attribute(obtaining_date, date(2026, 3, 10))], indeterminate([provision_date]), []).
test(input_problems_come_first) :-
    information_timing_verdict([attribute(personal_data_collected_from_data_subject, unsure), attribute(provision_date, date(2026, 3, 10))], input_problems([wrong_type(personal_data_collected_from_data_subject)]), []).
test(a_wrong_unread_key_is_still_an_input_problem) :-
    information_timing_verdict([attribute(personal_data_collected_from_data_subject, true), attribute(obtaining_date, date(2026, 3, 10)), attribute(provision_date, date(2026, 3, 10)), attribute(protective_measures_taken, unsure)], input_problems([wrong_type(protective_measures_taken)]), []).
test(an_unread_key_does_not_change_the_answer) :-
    information_timing_verdict([attribute(personal_data_collected_from_data_subject, true), attribute(obtaining_date, date(2026, 3, 10)), attribute(provision_date, date(2026, 3, 10)), attribute(items_provided, []), attribute(automated_decision_making_under_article_22, unsure)], timely, [cite(eu_reg_2016_679_art_13_1)]).
test(the_verdict_has_exactly_one_answer) :-
    findall(Verdict - Citations, information_timing_verdict([attribute(personal_data_collected_from_data_subject, false), attribute(obtaining_date, date(2026, 1, 31)), attribute(provision_date, date(2026, 3, 2)), attribute(data_used_for_communication_with_data_subject, true), attribute(first_communication_date, date(2026, 3, 2)), attribute(disclosure_to_another_recipient_envisaged, true), attribute(first_disclosure_date, date(2026, 3, 2)), attribute(provided_within_reasonable_period, true)], Verdict, Citations), Answers),
    Answers == [timely - [cite(eu_reg_2016_679_art_14_3_a)]].
test(the_decision_wraps_the_verdict) :-
    decide_information_timing_verdict([attribute(personal_data_collected_from_data_subject, true), attribute(obtaining_date, date(2026, 3, 10)), attribute(provision_date, date(2026, 3, 11))], information_timing_verdict_verdict(late, [cite(eu_reg_2016_679_art_13_1)])).
test(the_status_projection) :-
    information_timing_verdict_status([attribute(personal_data_collected_from_data_subject, true), attribute(obtaining_date, date(2026, 3, 10)), attribute(provision_date, date(2026, 3, 10))], timely).
test(the_checklist_on_the_article_14_route) :-
    information_timing_verdict_checklist([attribute(personal_data_collected_from_data_subject, false), attribute(obtaining_date, date(2026, 1, 15)), attribute(provision_date, date(2026, 1, 20)), attribute(data_used_for_communication_with_data_subject, true), attribute(first_communication_date, date(2026, 1, 20)), attribute(disclosure_to_another_recipient_envisaged, false), attribute(provided_within_reasonable_period, false)], [item(provided_by_deadline, met, cite(eu_reg_2016_679_art_14_3_b)), item(provided_within_reasonable_period, unmet(not_within_a_reasonable_period), cite(eu_reg_2016_679_art_14_3_a))]).
test(the_checklist_on_the_article_13_route) :-
    information_timing_verdict_checklist([attribute(personal_data_collected_from_data_subject, true), attribute(obtaining_date, date(2026, 3, 10)), attribute(provision_date, date(2026, 3, 11))], [item(provided_by_deadline, unmet(provided_after_the_deadline), cite(eu_reg_2016_679_art_13_1)), item(provided_within_reasonable_period, inapplicable, cite(eu_reg_2016_679_art_14_3_a))]).

test(art13_after_the_obtaining_day_is_not_timely, fail) :-
    information_timing_verdict([attribute(personal_data_collected_from_data_subject, true), attribute(obtaining_date, date(2026, 3, 10)), attribute(provision_date, date(2026, 3, 11))], timely, _).
test(art14_on_time_and_unsure_is_not_timely, fail) :-
    information_timing_verdict([attribute(personal_data_collected_from_data_subject, false), attribute(obtaining_date, date(2026, 1, 15)), attribute(provision_date, date(2026, 2, 10)), attribute(data_used_for_communication_with_data_subject, false), attribute(disclosure_to_another_recipient_envisaged, false), attribute(provided_within_reasonable_period, unsure)], timely, _).
