% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_information_duties_timing_information_timing_verdict, [decide_information_timing_verdict/2, information_timing_verdict_status/2, information_timing_verdict_checklist/2, information_timing_verdict_decision_resolvable/1, information_timing_verdict_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_information_duties_timing_kernel, [gdpr_information_duties_timing_input_problems/2, profile_key_status/3, keys_in_contract_order/2, calendar_date_relation/3, public_holidays_referral/2]).
:- use_module(m__eu_data_protection_gdpr_information_duties_timing_citations, [implements/1, limb_citation/2]).
:- use_module(m__eu_data_protection_gdpr_information_duties_timing_information_deadline_basis, [deadline_resolution/2, earliest_event_limb/2, limb_a_date/3]).

information_timing_verdict_status_values([timely, late]).

open_texture_referral(provided_within_reasonable_period, cite(eu_reg_2016_679_art_14_3_a)).

article_14_limb(art14_3_a).
article_14_limb(art14_3_b).
article_14_limb(art14_3_c).

timing_position(before, on_time).
timing_position(same, on_time).
timing_position(after, after_deadline).

decide_information_timing_verdict(Profile, Verdict) :-
    gdpr_information_duties_timing_input_problems(Profile, Problems),
    verdict_for_problems(Problems, Profile, Verdict).

verdict_for_problems([Problem|Problems], _, information_timing_verdict_verdict(input_problems([Problem|Problems]), [])).
verdict_for_problems([], Profile, Verdict) :-
    profile_key_status(Profile, personal_data_collected_from_data_subject, RouteStatus),
    route_verdict(RouteStatus, Profile, Verdict).

route_verdict(absent, Profile, information_timing_verdict_verdict(indeterminate(OrderedKeys), [])) :-
    absent_keys(Profile, [obtaining_date, provision_date], AbsentKeys),
    keys_in_contract_order([personal_data_collected_from_data_subject|AbsentKeys], OrderedKeys).
route_verdict(present(true), Profile, Verdict) :-
    implements(eu_reg_2016_679_art_13_1),
    deadline_resolution(Profile, Resolution),
    profile_key_status(Profile, provision_date, ProvisionStatus),
    resolution_verdict(Resolution, ProvisionStatus, Profile, Verdict).
route_verdict(present(false), Profile, Verdict) :-
    implements(eu_reg_2016_679_art_14_1),
    profile_key_status(Profile, provided_within_reasonable_period, JudgementStatus),
    reasonable_period_settles_t(JudgementStatus, Profile, Settles),
    article_14_route_verdict(Settles, Profile, Verdict).

absent_keys(_, [], []).
absent_keys(Profile, [Key|Keys], AbsentKeys) :-
    profile_key_status(Profile, Key, Status),
    absent_keys(Profile, Keys, LaterAbsentKeys),
    keep_absent_key(Status, Key, LaterAbsentKeys, AbsentKeys).

keep_absent_key(absent, Key, AbsentKeys, [Key|AbsentKeys]).
keep_absent_key(present(_), _, AbsentKeys, AbsentKeys).

reasonable_period_settles_t(present(false), Profile, Settles) :-
    implements(eu_reg_2016_679_art_14_3_a),
    earliest_event_limb(Profile, EventStatus),
    false_judgement_settles_t(EventStatus, Profile, Settles).
reasonable_period_settles_t(present(true), _, false).
reasonable_period_settles_t(present(unsure), _, false).
reasonable_period_settles_t(absent, _, false).

false_judgement_settles_t(known(no_event), _, true).
false_judgement_settles_t(missing(_), _, false).
false_judgement_settles_t(known(event(EventDate, _)), Profile, Settles) :-
    profile_key_status(Profile, provision_date, ProvisionStatus),
    provision_within_event_t(ProvisionStatus, EventDate, WithinEvent),
    profile_key_status(Profile, obtaining_date, ObtainingStatus),
    profile_key_status(Profile, public_holidays, HolidaysStatus),
    event_on_or_after_limb_a_t(ObtainingStatus, HolidaysStatus, EventDate, OnOrAfterLimbA),
    truth_or(WithinEvent, OnOrAfterLimbA, Settles).

provision_within_event_t(absent, _, false).
provision_within_event_t(present(ProvisionDate), EventDate, Within) :-
    calendar_date_relation(ProvisionDate, EventDate, Relation),
    relation_on_or_before_t(Relation, Within).

event_on_or_after_limb_a_t(absent, _, _, false).
event_on_or_after_limb_a_t(present(_), absent, _, false).
event_on_or_after_limb_a_t(present(ObtainingDate), present(attested(Holidays, _)), EventDate, OnOrAfter) :-
    implements(eu_reg_2016_679_art_14_3_a),
    limb_a_date(ObtainingDate, Holidays, LimbADate),
    calendar_date_relation(EventDate, LimbADate, Relation),
    relation_on_or_after_t(Relation, OnOrAfter).

relation_on_or_before_t(before, true).
relation_on_or_before_t(same, true).
relation_on_or_before_t(after, false).

relation_on_or_after_t(before, false).
relation_on_or_after_t(same, true).
relation_on_or_after_t(after, true).

truth_or(true, _, true).
truth_or(false, Truth, Truth).

article_14_route_verdict(true, _, information_timing_verdict_verdict(late, [cite(eu_reg_2016_679_art_14_3_a)])) :-
    implements(eu_reg_2016_679_art_14_3_a).
article_14_route_verdict(false, Profile, Verdict) :-
    deadline_resolution(Profile, Resolution),
    profile_key_status(Profile, provision_date, ProvisionStatus),
    resolution_verdict(Resolution, ProvisionStatus, Profile, Verdict).

resolution_verdict(missing(MissingKeys), ProvisionStatus, _, information_timing_verdict_verdict(indeterminate(OrderedKeys), [])) :-
    provision_missing_keys(ProvisionStatus, MissingKeys, AllKeys),
    keys_in_contract_order(AllKeys, OrderedKeys).
resolution_verdict(fixed(_, _), absent, _, information_timing_verdict_verdict(indeterminate([provision_date]), [])).
resolution_verdict(holidays_unattested(_, _), absent, _, information_timing_verdict_verdict(indeterminate([provision_date]), [])).
resolution_verdict(fixed(DeadlineDate, Basis), present(ProvisionDate), Profile, Verdict) :-
    calendar_date_relation(ProvisionDate, DeadlineDate, Relation),
    timing_position(Relation, Position),
    fixed_timing(Position, Basis, Profile, Verdict).
resolution_verdict(holidays_unattested(LimbADateWithoutHolidays, Event), present(ProvisionDate), Profile, Verdict) :-
    implements(eu_reg_1971_1182_art_3_4),
    unattested_verdict(Event, LimbADateWithoutHolidays, ProvisionDate, Profile, Verdict).

provision_missing_keys(absent, MissingKeys, [provision_date|MissingKeys]).
provision_missing_keys(present(_), MissingKeys, MissingKeys).

fixed_timing(after_deadline, art13_1, _, information_timing_verdict_verdict(late, [cite(eu_reg_2016_679_art_13_1)])) :-
    implements(eu_reg_2016_679_art_13_1).
fixed_timing(after_deadline, art14_3_a, _, information_timing_verdict_verdict(late, [cite(eu_reg_2016_679_art_14_3_a)])) :-
    implements(eu_reg_2016_679_art_14_3_a).
fixed_timing(after_deadline, art14_3_b, _, information_timing_verdict_verdict(late, [cite(eu_reg_2016_679_art_14_3_b)])) :-
    implements(eu_reg_2016_679_art_14_3_b).
fixed_timing(after_deadline, art14_3_c, _, information_timing_verdict_verdict(late, [cite(eu_reg_2016_679_art_14_3_c)])) :-
    implements(eu_reg_2016_679_art_14_3_c).
fixed_timing(on_time, art13_1, _, information_timing_verdict_verdict(timely, [cite(eu_reg_2016_679_art_13_1)])) :-
    implements(eu_reg_2016_679_art_13_1).
fixed_timing(on_time, Basis, Profile, Verdict) :-
    implements(eu_reg_2016_679_art_14_3_a),
    article_14_limb(Basis),
    profile_key_status(Profile, provided_within_reasonable_period, JudgementStatus),
    reasonable_period_verdict(JudgementStatus, Basis, Verdict).

reasonable_period_verdict(present(true), Basis, information_timing_verdict_verdict(timely, [Citation])) :-
    implements(eu_reg_2016_679_art_14_3_a),
    limb_citation(Basis, Citation).
reasonable_period_verdict(present(false), _, information_timing_verdict_verdict(late, [cite(eu_reg_2016_679_art_14_3_a)])) :-
    implements(eu_reg_2016_679_art_14_3_a).
reasonable_period_verdict(present(unsure), _, information_timing_verdict_verdict(Review, [])) :-
    implements(eu_reg_2016_679_art_14_3_a),
    reasonable_period_review(Review).
reasonable_period_verdict(absent, _, information_timing_verdict_verdict(indeterminate([provided_within_reasonable_period]), [])).

reasonable_period_review(needs_legal_review(open_textured(Input, Citation), [inputs_relied_on([Input - unsure])])) :-
    open_texture_referral(Input, Citation).

unattested_verdict(no_event, LimbADateWithoutHolidays, ProvisionDate, Profile, Verdict) :-
    calendar_date_relation(ProvisionDate, LimbADateWithoutHolidays, Relation),
    unattested_window(Relation, Window),
    profile_key_status(Profile, provided_within_reasonable_period, JudgementStatus),
    unattested_judgement(Window, JudgementStatus, Verdict).
unattested_verdict(event(EventDate, _), _, ProvisionDate, Profile, Verdict) :-
    calendar_date_relation(ProvisionDate, EventDate, Relation),
    timing_position(Relation, Position),
    unattested_event_verdict(Position, Profile, Verdict).

unattested_window(before, settled_window).
unattested_window(same, settled_window).
unattested_window(after, open_window).

unattested_event_verdict(after_deadline, _, information_timing_verdict_verdict(Referral, [])) :-
    implements(eu_reg_1971_1182_art_3_4),
    public_holidays_referral([], Referral).
unattested_event_verdict(on_time, Profile, Verdict) :-
    profile_key_status(Profile, provided_within_reasonable_period, JudgementStatus),
    unattested_judgement(open_window, JudgementStatus, Verdict).

unattested_judgement(_, present(false), information_timing_verdict_verdict(late, [cite(eu_reg_2016_679_art_14_3_a)])) :-
    implements(eu_reg_2016_679_art_14_3_a).
unattested_judgement(_, absent, information_timing_verdict_verdict(indeterminate([provided_within_reasonable_period]), [])).
unattested_judgement(settled_window, present(true), information_timing_verdict_verdict(timely, [cite(eu_reg_2016_679_art_14_3_a)])) :-
    implements(eu_reg_2016_679_art_14_3_a).
unattested_judgement(open_window, present(true), information_timing_verdict_verdict(Referral, [])) :-
    implements(eu_reg_1971_1182_art_3_4),
    public_holidays_referral([provided_within_reasonable_period - true], Referral).
unattested_judgement(settled_window, present(unsure), information_timing_verdict_verdict(Review, [])) :-
    implements(eu_reg_2016_679_art_14_3_a),
    reasonable_period_review(Review).
unattested_judgement(open_window, present(unsure), information_timing_verdict_verdict(Referral, [])) :-
    implements(eu_reg_1971_1182_art_3_4),
    public_holidays_referral([provided_within_reasonable_period - unsure], Referral).

information_timing_verdict_status(Profile, Status) :-
    decide_information_timing_verdict(Profile, information_timing_verdict_verdict(Status, _Citations)).

information_timing_verdict_checklist(Profile, Items) :-
    gdpr_information_duties_timing_input_problems(Profile, Problems),
    checklist_for_problems(Problems, Profile, Items).

checklist_for_problems([Problem|Problems], _, [item(information_timing_verdict, input_problems([Problem|Problems]), [])]).
checklist_for_problems([], Profile, [item(article_13_route, RouteItemStatus, cite(eu_reg_2016_679_art_13_1)), item(article_14_3_a_reasonable_period, JudgementItemStatus, cite(eu_reg_2016_679_art_14_3_a)), item(information_timing_verdict, Verdict, Citations)]) :-
    profile_key_status(Profile, personal_data_collected_from_data_subject, RouteStatus),
    route_item_status(RouteStatus, RouteItemStatus),
    profile_key_status(Profile, provided_within_reasonable_period, JudgementStatus),
    judgement_item_status(JudgementStatus, JudgementItemStatus),
    decide_information_timing_verdict(Profile, information_timing_verdict_verdict(Verdict, Citations)).

route_item_status(present(true), met).
route_item_status(present(false), unmet(not_collected_from_data_subject)).
route_item_status(absent, unknown([personal_data_collected_from_data_subject])).

judgement_item_status(present(true), met).
judgement_item_status(present(false), unmet(not_within_reasonable_period)).
judgement_item_status(present(unsure), unknown([provided_within_reasonable_period])).
judgement_item_status(absent, unknown([provided_within_reasonable_period])).

information_timing_verdict_decision_resolvable(Profile) :-
    decide_information_timing_verdict(Profile, _Verdict).

test(article_13_on_the_obtaining_day_is_timely) :-
    Profile = [attribute(personal_data_collected_from_data_subject, true), attribute(obtaining_date, date(2026, 3, 10)), attribute(provision_date, date(2026, 3, 10))],
    findall(Verdict, decide_information_timing_verdict(Profile, Verdict), Verdicts),
    Verdicts == [information_timing_verdict_verdict(timely, [cite(eu_reg_2016_679_art_13_1)])].
test(article_13_after_the_obtaining_day_is_late) :-
    Profile = [attribute(personal_data_collected_from_data_subject, true), attribute(obtaining_date, date(2026, 3, 10)), attribute(provision_date, date(2026, 3, 11))],
    decide_information_timing_verdict(Profile, information_timing_verdict_verdict(late, [cite(eu_reg_2016_679_art_13_1)])).
test(article_14_limb_a_last_day_is_inclusive) :-
    Profile = [attribute(personal_data_collected_from_data_subject, false), attribute(obtaining_date, date(2026, 1, 15)), attribute(provision_date, date(2026, 2, 16)), attribute(data_used_for_communication_with_data_subject, false), attribute(disclosure_to_another_recipient_envisaged, false), attribute(provided_within_reasonable_period, true), attribute(public_holidays, attested([], attestation(by, at, reason, none)))],
    findall(Verdict, decide_information_timing_verdict(Profile, Verdict), Verdicts),
    Verdicts == [information_timing_verdict_verdict(timely, [cite(eu_reg_2016_679_art_14_3_a)])].
test(article_14_after_limb_a_is_late) :-
    Profile = [attribute(personal_data_collected_from_data_subject, false), attribute(obtaining_date, date(2026, 1, 15)), attribute(provision_date, date(2026, 2, 17)), attribute(data_used_for_communication_with_data_subject, false), attribute(disclosure_to_another_recipient_envisaged, false), attribute(provided_within_reasonable_period, true), attribute(public_holidays, attested([], attestation(by, at, reason, none)))],
    decide_information_timing_verdict(Profile, information_timing_verdict_verdict(late, [cite(eu_reg_2016_679_art_14_3_a)])).
test(article_14_after_first_communication_cites_limb_b) :-
    Profile = [attribute(personal_data_collected_from_data_subject, false), attribute(obtaining_date, date(2026, 1, 15)), attribute(provision_date, date(2026, 1, 21)), attribute(data_used_for_communication_with_data_subject, true), attribute(first_communication_date, date(2026, 1, 20)), attribute(disclosure_to_another_recipient_envisaged, false), attribute(provided_within_reasonable_period, true), attribute(public_holidays, attested([], attestation(by, at, reason, none)))],
    findall(Verdict, decide_information_timing_verdict(Profile, Verdict), Verdicts),
    Verdicts == [information_timing_verdict_verdict(late, [cite(eu_reg_2016_679_art_14_3_b)])].
test(article_14_unsure_judgement_is_handed_to_the_user) :-
    Profile = [attribute(personal_data_collected_from_data_subject, false), attribute(obtaining_date, date(2026, 1, 15)), attribute(provision_date, date(2026, 1, 20)), attribute(data_used_for_communication_with_data_subject, false), attribute(disclosure_to_another_recipient_envisaged, false), attribute(provided_within_reasonable_period, unsure), attribute(public_holidays, attested([], attestation(by, at, reason, none)))],
    findall(Verdict, decide_information_timing_verdict(Profile, Verdict), Verdicts),
    Verdicts == [information_timing_verdict_verdict(needs_legal_review(open_textured(provided_within_reasonable_period, cite(eu_reg_2016_679_art_14_3_a)), [inputs_relied_on([provided_within_reasonable_period - unsure])]), [])].
test(article_14_absent_judgement_on_time_is_named) :-
    Profile = [attribute(personal_data_collected_from_data_subject, false), attribute(obtaining_date, date(2026, 1, 15)), attribute(provision_date, date(2026, 1, 20)), attribute(data_used_for_communication_with_data_subject, false), attribute(disclosure_to_another_recipient_envisaged, false), attribute(public_holidays, attested([], attestation(by, at, reason, none)))],
    information_timing_verdict_status(Profile, indeterminate([provided_within_reasonable_period])).
test(holidays_absent_no_x_within_a0_is_timely) :-
    Profile = [attribute(personal_data_collected_from_data_subject, false), attribute(obtaining_date, date(2026, 1, 15)), attribute(provision_date, date(2026, 2, 16)), attribute(data_used_for_communication_with_data_subject, false), attribute(disclosure_to_another_recipient_envisaged, false), attribute(provided_within_reasonable_period, true)],
    findall(Verdict, decide_information_timing_verdict(Profile, Verdict), Verdicts),
    Verdicts == [information_timing_verdict_verdict(timely, [cite(eu_reg_2016_679_art_14_3_a)])].
test(holidays_absent_no_x_after_a0_refers_with_the_judgement) :-
    Profile = [attribute(personal_data_collected_from_data_subject, false), attribute(obtaining_date, date(2026, 1, 15)), attribute(provision_date, date(2026, 2, 17)), attribute(data_used_for_communication_with_data_subject, false), attribute(disclosure_to_another_recipient_envisaged, false), attribute(provided_within_reasonable_period, true)],
    findall(Verdict, decide_information_timing_verdict(Profile, Verdict), Verdicts),
    Verdicts == [information_timing_verdict_verdict(needs_legal_review(cross_reference_unresolved(cite(eu_reg_1971_1182_art_3_4), cite(public_holidays_applicable_to_the_period)), [resolution(cite(public_holidays_applicable_to_the_period), not_attempted), inputs_relied_on([provided_within_reasonable_period - true])]), [])].
test(holidays_absent_provision_after_x_refers_without_pairs) :-
    Profile = [attribute(personal_data_collected_from_data_subject, false), attribute(obtaining_date, date(2026, 1, 15)), attribute(provision_date, date(2026, 2, 20)), attribute(data_used_for_communication_with_data_subject, true), attribute(first_communication_date, date(2026, 2, 16)), attribute(disclosure_to_another_recipient_envisaged, false), attribute(provided_within_reasonable_period, true)],
    information_timing_verdict_status(Profile, needs_legal_review(cross_reference_unresolved(_, _), [resolution(_, not_attempted), inputs_relied_on([])])).
test(holidays_absent_x_before_a0_is_decided) :-
    Profile = [attribute(personal_data_collected_from_data_subject, false), attribute(obtaining_date, date(2026, 1, 15)), attribute(provision_date, date(2026, 2, 3)), attribute(data_used_for_communication_with_data_subject, false), attribute(disclosure_to_another_recipient_envisaged, true), attribute(first_disclosure_date, date(2026, 2, 1)), attribute(provided_within_reasonable_period, true)],
    decide_information_timing_verdict(Profile, information_timing_verdict_verdict(late, [cite(eu_reg_2016_679_art_14_3_c)])).
test(a_false_judgement_with_no_x_settles_late) :-
    Profile = [attribute(personal_data_collected_from_data_subject, false), attribute(data_used_for_communication_with_data_subject, false), attribute(disclosure_to_another_recipient_envisaged, false), attribute(provided_within_reasonable_period, false)],
    findall(Verdict, decide_information_timing_verdict(Profile, Verdict), Verdicts),
    Verdicts == [information_timing_verdict_verdict(late, [cite(eu_reg_2016_679_art_14_3_a)])].
test(a_false_judgement_with_provision_before_x_settles_late) :-
    Profile = [attribute(personal_data_collected_from_data_subject, false), attribute(provision_date, date(2026, 1, 18)), attribute(data_used_for_communication_with_data_subject, true), attribute(first_communication_date, date(2026, 1, 20)), attribute(disclosure_to_another_recipient_envisaged, false), attribute(provided_within_reasonable_period, false)],
    information_timing_verdict_status(Profile, late).
test(route_unknown_names_the_route_and_both_dates) :-
    Profile = [attribute(provided_within_reasonable_period, true)],
    findall(Status, information_timing_verdict_status(Profile, Status), Statuses),
    Statuses == [indeterminate([personal_data_collected_from_data_subject, obtaining_date, provision_date])].
test(article_14_missing_keys_in_contract_order) :-
    Profile = [attribute(personal_data_collected_from_data_subject, false), attribute(provided_within_reasonable_period, true)],
    information_timing_verdict_status(Profile, Status),
    Status == indeterminate([obtaining_date, provision_date, data_used_for_communication_with_data_subject, disclosure_to_another_recipient_envisaged]).
test(an_unknown_key_is_an_input_problem) :-
    findall(Verdict, decide_information_timing_verdict([attribute(colour, blue)], Verdict), Verdicts),
    Verdicts == [information_timing_verdict_verdict(input_problems([unknown_key(colour)]), [])].
test(the_checklist_has_one_row_per_ground) :-
    information_timing_verdict_checklist([attribute(personal_data_collected_from_data_subject, true)], Items),
    length(Items, 3).

test(article_13_after_the_obtaining_day_is_not_timely, fail) :-
    Profile = [attribute(personal_data_collected_from_data_subject, true), attribute(obtaining_date, date(2026, 3, 10)), attribute(provision_date, date(2026, 3, 11))],
    information_timing_verdict_status(Profile, timely).
test(a_false_judgement_with_provision_before_x_is_not_timely, fail) :-
    Profile = [attribute(personal_data_collected_from_data_subject, false), attribute(provision_date, date(2026, 1, 18)), attribute(data_used_for_communication_with_data_subject, true), attribute(first_communication_date, date(2026, 1, 20)), attribute(disclosure_to_another_recipient_envisaged, false), attribute(provided_within_reasonable_period, false)],
    information_timing_verdict_status(Profile, timely).
