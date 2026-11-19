% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_information_duties_headline_verdict_queries, [gdpr_information_duties_headline_verdict_profile_keys/1, gdpr_information_duties_headline_verdict_what_if/4, gdpr_information_duties_headline_verdict_compliance_check/3, gdpr_information_duties_headline_verdict_obligations/2, gdpr_information_duties_headline_verdict_deadline/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(clpz)).
:- use_module(m__eu_data_protection_gdpr_information_duties_headline_verdict_kernel, [gdpr_information_duties_headline_verdict_input_problems/2, key_status/3]).
:- use_module(m__eu_data_protection_gdpr_information_duties_headline_verdict_information_duty_exemption, [information_duty_exemption_status/2]).
:- use_module(m__eu_data_protection_gdpr_information_duties_headline_verdict_information_duty_verdict, [information_duty_verdict_status/2, information_duty_verdict_checklist/2]).

gdpr_information_duties_headline_verdict_profile_keys([personal_data_collected_from_data_subject, items_provided, items_data_subject_already_has, data_protection_officer_designated, processing_based_on_legitimate_interests, recipients_exist, transfer_intended, processing_based_on_consent, automated_decision_making_under_article_22, obtaining_date, provision_date, data_used_for_communication_with_data_subject, first_communication_date, disclosure_to_another_recipient_envisaged, first_disclosure_date, provided_within_reasonable_period, provision_impossible_or_disproportionate_effort, protective_measures_taken, obtaining_or_disclosure_laid_down_by_law, professional_secrecy_obligation_by_law, further_processing_for_another_purpose_intended, further_processing_start_date, further_processing_information_date, further_processing_items_provided, paragraph_2_information_relevant_to_further_processing, public_holidays]).

override_attribute(Profile, Key, Value, Hypothesis) :-
    drop_attribute(Profile, Key, Kept),
    append(Kept, [attribute(Key, Value)], Hypothesis).

drop_attribute([], _, []).
drop_attribute([attribute(ElementKey, _)|Elements], Key, Kept) :-
    ElementKey == Key,
    drop_attribute(Elements, Key, Kept).
drop_attribute([attribute(ElementKey, ElementValue)|Elements], Key, [attribute(ElementKey, ElementValue)|Kept]) :-
    ElementKey \== Key,
    drop_attribute(Elements, Key, Kept).

gdpr_information_duties_headline_verdict_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    gdpr_information_duties_headline_verdict_input_problems(Profile, Problems),
    what_if_checked(Problems, Profile, OverriddenKey, NewValue, NewStatus).

what_if_checked([Problem|Problems], _, _, _, input_problems([Problem|Problems])).
what_if_checked([], Profile, OverriddenKey, NewValue, NewStatus) :-
    override_attribute(Profile, OverriddenKey, NewValue, Hypothesis),
    information_duty_verdict_status(Hypothesis, NewStatus).

gdpr_information_duties_headline_verdict_compliance_check(Profile, ProposedAction, Verdict) :-
    gdpr_information_duties_headline_verdict_input_problems(Profile, Problems),
    compliance_checked(Problems, Profile, ProposedAction, Verdict).

compliance_checked([Problem|Problems], _, _, input_problems([Problem|Problems])).
compliance_checked([], Profile, provide_information_on(ProvisionDate), Verdict) :-
    override_attribute(Profile, provision_date, ProvisionDate, Hypothesis),
    information_duty_verdict_status(Hypothesis, Status),
    compliance_from_verdict(Status, Verdict).
compliance_checked([], Profile, start_further_processing_on(StartDate), Verdict) :-
    override_attribute(Profile, further_processing_for_another_purpose_intended, true, IntendedHypothesis),
    override_attribute(IntendedHypothesis, further_processing_start_date, StartDate, Hypothesis),
    information_duty_verdict_status(Hypothesis, Status),
    compliance_from_verdict(Status, Verdict).

compliance_from_verdict(eligible, allowed).
compliance_from_verdict(ineligible, not_allowed).
compliance_from_verdict(indeterminate(MissingKeys), indeterminate(MissingKeys)).
compliance_from_verdict(needs_legal_review(Reason, Context), needs_legal_review(Reason, Context)).
compliance_from_verdict(input_problems(Problems), input_problems(Problems)).

gdpr_information_duties_headline_verdict_obligations(Profile, Obligations) :-
    gdpr_information_duties_headline_verdict_input_problems(Profile, Problems),
    obligations_checked(Problems, Profile, Obligations).

obligations_checked([Problem|Problems], _, input_problems([Problem|Problems])).
obligations_checked([], Profile, Obligations) :-
    information_duty_exemption_status(Profile, Exemption),
    exemption_effect(Exemption, Effect),
    obligations_by_effect(Effect, Profile, Obligations).

exemption_effect(impossible_or_disproportionate_effort, disapplied(impossible_or_disproportionate_effort)).
exemption_effect(law_lays_down_obtaining_or_disclosure, disapplied(law_lays_down_obtaining_or_disclosure)).
exemption_effect(professional_secrecy_obligation, disapplied(professional_secrecy_obligation)).
exemption_effect(none, standing).
exemption_effect(indeterminate(_), standing).
exemption_effect(needs_legal_review(_, _), standing).

obligations_by_effect(disapplied(Exemption), _, [duty_disapplied(Exemption)]).
obligations_by_effect(standing, Profile, Obligations) :-
    information_duty_verdict_checklist(Profile, Items),
    findall(Duty, (member(Item, Items), row_duty(Item, Duty)), Duties),
    duties_or_none(Duties, Obligations).

row_duty(item(Row, unmet(Citations), _), must_remedy(Row, Citations)).
row_duty(item(Row, unknown(MissingKeys), Citation), to_determine(Row, MissingKeys, Citation)).

duties_or_none([], [no_outstanding_obligation]).
duties_or_none([Duty|Duties], [Duty|Duties]).

gdpr_information_duties_headline_verdict_deadline(Profile, Deadline) :-
    gdpr_information_duties_headline_verdict_input_problems(Profile, Problems),
    deadline_checked(Problems, Profile, Deadline).

deadline_checked([Problem|Problems], _, input_problems([Problem|Problems])).
deadline_checked([], Profile, Deadline) :-
    key_status(Profile, obtaining_date, ObtainingStatus),
    deadline_from_obtaining(ObtainingStatus, Profile, Deadline).

deadline_from_obtaining(unknown(MissingKeys), _, indeterminate(MissingKeys)).
deadline_from_obtaining(value(ObtainingDate), Profile, Deadline) :-
    override_attribute(Profile, provided_within_reasonable_period, true, Reasonable),
    timing_status_on(Reasonable, ObtainingDate, Status),
    deadline_scan(Status, Reasonable, ObtainingDate, 0, Deadline).

timing_status_on(Profile, ProvisionDate, Status) :-
    override_attribute(Profile, provision_date, ProvisionDate, Hypothesis),
    information_duty_verdict_checklist(Hypothesis, Items),
    member(item(timing, Status, _), Items).

deadline_scan(unknown(MissingKeys), _, _, _, indeterminate(MissingKeys)).
deadline_scan(unmet(Citations), _, CurrentDate, _, no_timely_day(CurrentDate, Citations)).
deadline_scan(met, Profile, CurrentDate, Count, Deadline) :-
    Count #< 400,
    next_calendar_day(CurrentDate, NextDate),
    timing_status_on(Profile, NextDate, NextStatus),
    NextCount #= Count + 1,
    deadline_step(NextStatus, Profile, CurrentDate, NextDate, NextCount, Deadline).
deadline_scan(met, _, CurrentDate, Count, no_deadline_within(CurrentDate)) :-
    Count #>= 400.

deadline_step(met, Profile, _, NextDate, NextCount, Deadline) :-
    deadline_scan(met, Profile, NextDate, NextCount, Deadline).
deadline_step(unmet(Citations), _, CurrentDate, _, _, deadline(CurrentDate, Citations, consequence(ineligible))).
deadline_step(unknown(MissingKeys), _, _, _, _, indeterminate(MissingKeys)).

next_calendar_day(date(YearNumber, Month, DayNumber), NextDate) :-
    days_in_month(YearNumber, Month, MonthLength),
    compare(Order, DayNumber, MonthLength),
    next_day_by_order(Order, YearNumber, Month, DayNumber, NextDate).

next_day_by_order(<, YearNumber, Month, DayNumber, date(YearNumber, Month, NextDay)) :-
    NextDay is DayNumber + 1.
next_day_by_order(=, YearNumber, 12, _, date(NextYear, 1, 1)) :-
    NextYear is YearNumber + 1.
next_day_by_order(=, YearNumber, Month, _, date(YearNumber, NextMonth, 1)) :-
    Month < 12,
    NextMonth is Month + 1.

days_in_month(_, 1, 31).
days_in_month(YearNumber, 2, MonthLength) :-
    FourYearRemainder is YearNumber mod 4,
    CenturyRemainder is YearNumber mod 100,
    FourCenturyRemainder is YearNumber mod 400,
    february_days(FourYearRemainder, CenturyRemainder, FourCenturyRemainder, MonthLength).
days_in_month(_, 3, 31).
days_in_month(_, 4, 30).
days_in_month(_, 5, 31).
days_in_month(_, 6, 30).
days_in_month(_, 7, 31).
days_in_month(_, 8, 31).
days_in_month(_, 9, 30).
days_in_month(_, 10, 31).
days_in_month(_, 11, 30).
days_in_month(_, 12, 31).

february_days(_, _, 0, 29).
february_days(0, CenturyRemainder, _, 29) :-
    CenturyRemainder =\= 0.
february_days(_, 0, FourCenturyRemainder, 28) :-
    FourCenturyRemainder =\= 0.
february_days(FourYearRemainder, _, _, 28) :-
    FourYearRemainder =\= 0.

query_article_13_profile(ProvisionDate, [attribute(personal_data_collected_from_data_subject, true), attribute(items_provided, [controller_identity_and_contact_details, purposes_and_legal_basis, storage_period_or_criteria, data_subject_rights, right_to_lodge_complaint, statutory_or_contractual_requirement]), attribute(items_data_subject_already_has, []), attribute(data_protection_officer_designated, false), attribute(processing_based_on_legitimate_interests, false), attribute(recipients_exist, false), attribute(transfer_intended, false), attribute(processing_based_on_consent, false), attribute(automated_decision_making_under_article_22, false), attribute(obtaining_date, date(2026, 3, 2)), attribute(provision_date, ProvisionDate), attribute(further_processing_for_another_purpose_intended, false)]).

test(the_profile_schema_has_twenty_six_keys) :-
    gdpr_information_duties_headline_verdict_profile_keys(Keys),
    length(Keys, 26).
test(override_replaces_the_one_attribute) :-
    override_attribute([attribute(recipients_exist, true), attribute(transfer_intended, false)], recipients_exist, false, [attribute(transfer_intended, false), attribute(recipients_exist, false)]).
test(a_non_profile_is_refused_by_the_what_if) :-
    gdpr_information_duties_headline_verdict_what_if(foo, provision_date, date(2026, 1, 1), input_problems([wrong_type(profile)])).
test(a_non_profile_is_refused_by_the_compliance_check) :-
    gdpr_information_duties_headline_verdict_compliance_check(foo, provide_information_on(date(2026, 1, 1)), input_problems([wrong_type(profile)])).
test(a_non_profile_has_no_deadline) :-
    gdpr_information_duties_headline_verdict_deadline(foo, input_problems([wrong_type(profile)])).
test(an_absent_obtaining_date_leaves_the_deadline_open) :-
    gdpr_information_duties_headline_verdict_deadline([attribute(personal_data_collected_from_data_subject, true)], indeterminate([obtaining_date])).
test(an_exemption_disapplies_every_obligation) :-
    gdpr_information_duties_headline_verdict_obligations([attribute(personal_data_collected_from_data_subject, false), attribute(provision_impossible_or_disproportionate_effort, true), attribute(protective_measures_taken, true)], [duty_disapplied(impossible_or_disproportionate_effort)]).
test(a_complete_timely_notice_owes_nothing_more) :-
    query_article_13_profile(date(2026, 3, 2), Profile),
    gdpr_information_duties_headline_verdict_obligations(Profile, [no_outstanding_obligation]).
test(a_late_notice_surfaces_the_timing_duty) :-
    query_article_13_profile(date(2026, 3, 3), Profile),
    gdpr_information_duties_headline_verdict_obligations(Profile, [must_remedy(timing, [cite(eu_reg_2016_679_art_13_1)])]).
test(a_non_profile_has_no_obligations_list) :-
    gdpr_information_duties_headline_verdict_obligations(foo, input_problems([wrong_type(profile)])).

test(a_non_profile_is_not_allowed_silently, fail) :-
    gdpr_information_duties_headline_verdict_compliance_check(foo, provide_information_on(date(2026, 1, 1)), allowed).
test(a_late_notice_is_not_free_of_obligations, fail) :-
    query_article_13_profile(date(2026, 3, 3), Profile),
    gdpr_information_duties_headline_verdict_obligations(Profile, [no_outstanding_obligation]).
