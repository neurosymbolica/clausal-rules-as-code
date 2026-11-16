% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_labour_working_time_weekly_limit_fixtures, [working_time_weekly_limit_subject/1, working_time_weekly_limit_profile_for/2, working_time_weekly_limit_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_labour_working_time_weekly_limit_working_time_weekly_limit, [decide_working_time_weekly_limit/2]).

working_time_weekly_limit_subject(at_limit).
working_time_weekly_limit_subject(one_minute_over).
working_time_weekly_limit_subject(option_absent_over).
working_time_weekly_limit_subject(opt_out_agreed).
working_time_weekly_limit_subject(opt_out_without_agreement).
working_time_weekly_limit_subject(agreement_false_option_absent).
working_time_weekly_limit_subject(leave_day_at_limit).
working_time_weekly_limit_subject(leave_day_one_minute_over).
working_time_weekly_limit_subject(member_state_period_at_four_months).
working_time_weekly_limit_subject(member_state_period_one_day_over).
working_time_weekly_limit_subject(basis_absent_one_day_over).
working_time_weekly_limit_subject(derogation_period_at_six_months).
working_time_weekly_limit_subject(derogation_period_one_day_over).
working_time_weekly_limit_subject(collective_agreement_period_at_twelve_months).
working_time_weekly_limit_subject(offshore_period_at_twelve_months).
working_time_weekly_limit_subject(period_one_day_over_twelve_months).
working_time_weekly_limit_subject(all_sick_leave).
working_time_weekly_limit_subject(sick_leave_one_minute_short).
working_time_weekly_limit_subject(on_site_absent_matters).
working_time_weekly_limit_subject(on_site_absent_does_not_matter).
working_time_weekly_limit_subject(on_site_unsure_matters).
working_time_weekly_limit_subject(on_site_counted).
working_time_weekly_limit_subject(on_site_not_counted).
working_time_weekly_limit_subject(standby_absent_matters).
working_time_weekly_limit_subject(edge_shift_at_limit).
working_time_weekly_limit_subject(edge_shift_one_minute_over).
working_time_weekly_limit_subject(other_worker_ignored).
working_time_weekly_limit_subject(same_rota_own_worker).
working_time_weekly_limit_subject(bad_profile).
working_time_weekly_limit_subject(good_profile_control).

working_time_weekly_limit_profile_for(at_limit, case([], w1, [shift(w1, date_time(2026, 3, 2, 0, 0), date_time(2026, 3, 4, 0, 0), work)], date(2026, 3, 2), date(2026, 3, 8))).
working_time_weekly_limit_profile_for(one_minute_over, case([attribute(member_state_uses_article_22_option, false)], w1, [shift(w1, date_time(2026, 3, 2, 0, 0), date_time(2026, 3, 4, 0, 1), work)], date(2026, 3, 2), date(2026, 3, 8))).
working_time_weekly_limit_profile_for(option_absent_over, case([], w1, [shift(w1, date_time(2026, 3, 2, 0, 0), date_time(2026, 3, 4, 0, 1), work)], date(2026, 3, 2), date(2026, 3, 8))).
working_time_weekly_limit_profile_for(opt_out_agreed, case([attribute(member_state_uses_article_22_option, true), attribute(worker_agreement_to_exceed_obtained_first, true)], w1, [shift(w1, date_time(2026, 3, 2, 0, 0), date_time(2026, 3, 4, 0, 1), work)], date(2026, 3, 2), date(2026, 3, 8))).
working_time_weekly_limit_profile_for(opt_out_without_agreement, case([attribute(member_state_uses_article_22_option, true), attribute(worker_agreement_to_exceed_obtained_first, false)], w1, [shift(w1, date_time(2026, 3, 2, 0, 0), date_time(2026, 3, 4, 0, 1), work)], date(2026, 3, 2), date(2026, 3, 8))).
working_time_weekly_limit_profile_for(agreement_false_option_absent, case([attribute(worker_agreement_to_exceed_obtained_first, false)], w1, [shift(w1, date_time(2026, 3, 2, 0, 0), date_time(2026, 3, 4, 0, 1), work)], date(2026, 3, 2), date(2026, 3, 8))).
working_time_weekly_limit_profile_for(leave_day_at_limit, case([], w1, [shift(w1, date_time(2026, 3, 2, 0, 0), date_time(2026, 3, 3, 0, 0), paid_annual_leave), shift(w1, date_time(2026, 3, 3, 0, 0), date_time(2026, 3, 4, 17, 8), work)], date(2026, 3, 2), date(2026, 3, 8))).
working_time_weekly_limit_profile_for(leave_day_one_minute_over, case([attribute(member_state_uses_article_22_option, false)], w1, [shift(w1, date_time(2026, 3, 2, 0, 0), date_time(2026, 3, 3, 0, 0), paid_annual_leave), shift(w1, date_time(2026, 3, 3, 0, 0), date_time(2026, 3, 4, 17, 9), work)], date(2026, 3, 2), date(2026, 3, 8))).
working_time_weekly_limit_profile_for(member_state_period_at_four_months, case([attribute(reference_period_basis, member_state_reference_period)], w1, [], date(2026, 1, 31), date(2026, 5, 30))).
working_time_weekly_limit_profile_for(member_state_period_one_day_over, case([attribute(reference_period_basis, member_state_reference_period)], w1, [], date(2026, 1, 31), date(2026, 5, 31))).
working_time_weekly_limit_profile_for(basis_absent_one_day_over, case([], w1, [], date(2026, 1, 31), date(2026, 5, 31))).
working_time_weekly_limit_profile_for(derogation_period_at_six_months, case([attribute(reference_period_basis, derogation_under_article_17_3_or_article_18)], w1, [], date(2026, 1, 1), date(2026, 6, 30))).
working_time_weekly_limit_profile_for(derogation_period_one_day_over, case([attribute(reference_period_basis, derogation_under_article_17_3_or_article_18)], w1, [], date(2026, 1, 1), date(2026, 7, 1))).
working_time_weekly_limit_profile_for(collective_agreement_period_at_twelve_months, case([attribute(reference_period_basis, collective_agreement_under_article_19)], w1, [], date(2026, 1, 1), date(2026, 12, 31))).
working_time_weekly_limit_profile_for(offshore_period_at_twelve_months, case([attribute(reference_period_basis, offshore_work_under_article_20_2)], w1, [], date(2026, 1, 1), date(2026, 12, 31))).
working_time_weekly_limit_profile_for(period_one_day_over_twelve_months, case([attribute(reference_period_basis, collective_agreement_under_article_19)], w1, [], date(2026, 1, 1), date(2027, 1, 1))).
working_time_weekly_limit_profile_for(all_sick_leave, case([], w1, [shift(w1, date_time(2026, 3, 2, 0, 0), date_time(2026, 3, 9, 0, 0), sick_leave)], date(2026, 3, 2), date(2026, 3, 8))).
working_time_weekly_limit_profile_for(sick_leave_one_minute_short, case([], w1, [shift(w1, date_time(2026, 3, 2, 0, 0), date_time(2026, 3, 8, 23, 59), sick_leave)], date(2026, 3, 2), date(2026, 3, 8))).
working_time_weekly_limit_profile_for(on_site_absent_matters, case([], w1, [shift(w1, date_time(2026, 3, 2, 0, 0), date_time(2026, 3, 3, 9, 20), work), shift(w1, date_time(2026, 3, 4, 0, 0), date_time(2026, 3, 4, 16, 40), on_call_on_site)], date(2026, 3, 2), date(2026, 3, 8))).
working_time_weekly_limit_profile_for(on_site_absent_does_not_matter, case([], w1, [shift(w1, date_time(2026, 3, 2, 0, 0), date_time(2026, 3, 3, 9, 20), work), shift(w1, date_time(2026, 3, 4, 0, 0), date_time(2026, 3, 4, 14, 40), on_call_on_site)], date(2026, 3, 2), date(2026, 3, 8))).
working_time_weekly_limit_profile_for(on_site_unsure_matters, case([attribute(on_call_on_site_counts_as_working_time, unsure), attribute(member_state_uses_article_22_option, false)], w1, [shift(w1, date_time(2026, 3, 2, 0, 0), date_time(2026, 3, 3, 9, 20), work), shift(w1, date_time(2026, 3, 4, 0, 0), date_time(2026, 3, 4, 16, 40), on_call_on_site)], date(2026, 3, 2), date(2026, 3, 8))).
working_time_weekly_limit_profile_for(on_site_counted, case([attribute(on_call_on_site_counts_as_working_time, true), attribute(member_state_uses_article_22_option, false)], w1, [shift(w1, date_time(2026, 3, 2, 0, 0), date_time(2026, 3, 3, 9, 20), work), shift(w1, date_time(2026, 3, 4, 0, 0), date_time(2026, 3, 4, 16, 40), on_call_on_site)], date(2026, 3, 2), date(2026, 3, 8))).
working_time_weekly_limit_profile_for(on_site_not_counted, case([attribute(on_call_on_site_counts_as_working_time, false)], w1, [shift(w1, date_time(2026, 3, 2, 0, 0), date_time(2026, 3, 3, 9, 20), work), shift(w1, date_time(2026, 3, 4, 0, 0), date_time(2026, 3, 4, 16, 40), on_call_on_site)], date(2026, 3, 2), date(2026, 3, 8))).
working_time_weekly_limit_profile_for(standby_absent_matters, case([], w1, [shift(w1, date_time(2026, 3, 2, 0, 0), date_time(2026, 3, 3, 9, 20), work), shift(w1, date_time(2026, 3, 4, 0, 0), date_time(2026, 3, 4, 16, 40), on_call_standby)], date(2026, 3, 2), date(2026, 3, 8))).
working_time_weekly_limit_profile_for(edge_shift_at_limit, case([], w1, [shift(w1, date_time(2026, 3, 2, 0, 0), date_time(2026, 3, 3, 22, 0), work), shift(w1, date_time(2026, 3, 8, 22, 0), date_time(2026, 3, 9, 6, 0), work)], date(2026, 3, 2), date(2026, 3, 8))).
working_time_weekly_limit_profile_for(edge_shift_one_minute_over, case([attribute(member_state_uses_article_22_option, false)], w1, [shift(w1, date_time(2026, 3, 2, 0, 0), date_time(2026, 3, 3, 22, 0), work), shift(w1, date_time(2026, 3, 8, 21, 59), date_time(2026, 3, 9, 6, 0), work)], date(2026, 3, 2), date(2026, 3, 8))).
working_time_weekly_limit_profile_for(other_worker_ignored, case([attribute(member_state_uses_article_22_option, false)], w1, [shift(1, date_time(2026, 3, 2, 0, 0), date_time(2026, 3, 8, 0, 0), work)], date(2026, 3, 2), date(2026, 3, 8))).
working_time_weekly_limit_profile_for(same_rota_own_worker, case([attribute(member_state_uses_article_22_option, false)], 1, [shift(1, date_time(2026, 3, 2, 0, 0), date_time(2026, 3, 8, 0, 0), work)], date(2026, 3, 2), date(2026, 3, 8))).
working_time_weekly_limit_profile_for(bad_profile, case([attribute(reference_period_basis, x), attribute(foo, 1), attribute(foo, 2)], w1, [shift(w1, date_time(2026, 3, 2, 0, 0), date_time(2026, 3, 4, 0, 0), work)], date(2026, 3, 2), date(2026, 3, 8))).
working_time_weekly_limit_profile_for(good_profile_control, case([attribute(reference_period_basis, member_state_reference_period)], w1, [shift(w1, date_time(2026, 3, 2, 0, 0), date_time(2026, 3, 4, 0, 0), work)], date(2026, 3, 2), date(2026, 3, 8))).

working_time_weekly_limit_assess(Subject, Verdict) :-
    working_time_weekly_limit_profile_for(Subject, SubjectCase),
    decide_working_time_weekly_limit(SubjectCase, Verdict).
