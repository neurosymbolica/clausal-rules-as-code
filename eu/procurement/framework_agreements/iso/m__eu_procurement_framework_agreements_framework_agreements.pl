:- module(m__eu_procurement_framework_agreements_framework_agreements, [decide_framework_term/2, framework_term_limit_date/2, framework_term_within_limit/3, decide_call_off/2, call_off_route/2, call_off_award_window_status/4, framework_agreements_input_problem/2, decide_framework_agreements/2, framework_agreements_status/2, framework_agreements_checklist/2, framework_agreements_decision_resolvable/1, framework_agreements_status_values/1, framework_term_limit_years/1, call_off_method/1, call_off_route_id/1, call_off_defect_id/1, framework_term_defect_id/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_dicts, [dict_keys/2, get/3]).
:- use_module(library(clpz)).
:- use_module(m__eu_procurement_framework_agreements_citations, [implements/1]).
:- use_module(deadline_lib, [date_before/2, date_after/2, date_on_or_before/2, date_on_or_after/2]).
:- use_module(date_guard, [must_be_date/1]).
:- use_module(formalize_lib, [profile_lacks/2, not_member/2]).

framework_term_limit_years(4).

call_off_method(without_reopening_competition).
call_off_method(with_reopening_competition).

call_off_route_id(single_operator_direct_award).
call_off_route_id(multi_operator_direct_award_all_terms_set_out).
call_off_route_id(multi_operator_direct_award_under_split_framework).
call_off_route_id(multi_operator_reopened_competition).
call_off_route_id(no_lawful_route).

call_off_defect_id(call_off_awarded_outside_framework_term).
call_off_defect_id(contracting_authority_not_identified_in_call_for_competition).
call_off_defect_id(economic_operator_not_party_to_framework).
call_off_defect_id(substantial_modification_of_framework_terms).
call_off_defect_id(call_off_outside_limits_of_framework_terms).
call_off_defect_id(reopening_competition_in_single_operator_framework).
call_off_defect_id(direct_award_without_all_terms_set_out).
call_off_defect_id(objective_conditions_for_determining_performer_not_indicated).
call_off_defect_id(objective_criteria_for_choice_of_route_not_stated).
call_off_defect_id(terms_subject_to_reopening_not_specified).
call_off_defect_id(reopening_not_available_where_framework_sets_out_all_terms).
call_off_defect_id(reopened_competition_not_based_on_framework_terms).
call_off_defect_id(capable_operators_not_all_consulted_in_writing).
call_off_defect_id(time_limit_not_sufficiently_long).
call_off_defect_id(tenders_not_submitted_in_writing).
call_off_defect_id(tender_contents_opened_before_time_limit_expired).
call_off_defect_id(award_not_made_on_framework_award_criteria).

framework_term_defect_id(framework_end_date_precedes_start_date).
framework_term_defect_id(framework_term_exceeds_four_years).

framework_term_limb_ids([framework_end_date_precedes_start_date, framework_term_exceeds_four_years]).

call_off_limb_ids([call_off_awarded_outside_framework_term, contracting_authority_not_identified_in_call_for_competition, economic_operator_not_party_to_framework, substantial_modification_of_framework_terms, call_off_outside_limits_of_framework_terms, reopening_competition_in_single_operator_framework, direct_award_without_all_terms_set_out, objective_conditions_for_determining_performer_not_indicated, objective_criteria_for_choice_of_route_not_stated, terms_subject_to_reopening_not_specified, reopening_not_available_where_framework_sets_out_all_terms, reopened_competition_not_based_on_framework_terms, capable_operators_not_all_consulted_in_writing, time_limit_not_sufficiently_long, tenders_not_submitted_in_writing, tender_contents_opened_before_time_limit_expired, award_not_made_on_framework_award_criteria]).

framework_term_citation(framework_end_date_precedes_start_date, cite(eu_dir_2014_24_art_33_1)).
framework_term_citation(framework_term_exceeds_four_years, cite(eu_dir_2014_24_art_33_1)).

call_off_citation(call_off_awarded_outside_framework_term, cite(eu_dir_2014_24_art_33_2)).
call_off_citation(contracting_authority_not_identified_in_call_for_competition, cite(eu_dir_2014_24_art_33_2)).
call_off_citation(economic_operator_not_party_to_framework, cite(eu_dir_2014_24_art_33_2)).
call_off_citation(substantial_modification_of_framework_terms, cite(eu_dir_2014_24_art_33_2)).
call_off_citation(call_off_outside_limits_of_framework_terms, cite(eu_dir_2014_24_art_33_3)).
call_off_citation(reopening_competition_in_single_operator_framework, cite(eu_dir_2014_24_art_33_4)).
call_off_citation(direct_award_without_all_terms_set_out, cite(eu_dir_2014_24_art_33_4)).
call_off_citation(objective_conditions_for_determining_performer_not_indicated, cite(eu_dir_2014_24_art_33_4)).
call_off_citation(objective_criteria_for_choice_of_route_not_stated, cite(eu_dir_2014_24_art_33_4)).
call_off_citation(terms_subject_to_reopening_not_specified, cite(eu_dir_2014_24_art_33_4)).
call_off_citation(reopening_not_available_where_framework_sets_out_all_terms, cite(eu_dir_2014_24_art_33_4)).
call_off_citation(reopened_competition_not_based_on_framework_terms, cite(eu_dir_2014_24_art_33_5)).
call_off_citation(capable_operators_not_all_consulted_in_writing, cite(eu_dir_2014_24_art_33_5)).
call_off_citation(time_limit_not_sufficiently_long, cite(eu_dir_2014_24_art_33_5)).
call_off_citation(tenders_not_submitted_in_writing, cite(eu_dir_2014_24_art_33_5)).
call_off_citation(tender_contents_opened_before_time_limit_expired, cite(eu_dir_2014_24_art_33_5)).
call_off_citation(award_not_made_on_framework_award_criteria, cite(eu_dir_2014_24_art_33_5)).

framework_term_limit_date(StartDate, LimitDate) :-
    date(StartYear, StartMonth, StartDay) = StartDate,
    framework_term_limit_years(Years),
    LimitYear #= StartYear + Years,
    term_anniversary(LimitYear, StartMonth, StartDay, LimitDate).

term_anniversary(LimitYear, Month, Day, date(LimitYear, Month, Day)) :-
    dif(Month - Day, 2 - 29).
term_anniversary(LimitYear, 2, 29, date(LimitYear, 2, 29)) :-
    leap_year(LimitYear).
term_anniversary(LimitYear, 2, 29, date(LimitYear, 2, 28)) :-
    common_year(LimitYear).

leap_year(Year) :-
    Year mod 4 #= 0,
    Year mod 100 #\= 0.
leap_year(Year) :-
    Year mod 400 #= 0.

common_year(Year) :-
    Year mod 4 #\= 0.
common_year(Year) :-
    Year mod 100 #= 0,
    Year mod 400 #\= 0.

framework_term_within_limit(StartDate, EndDate, within_four_year_limit) :-
    framework_term_limit_date(StartDate, LimitDate),
    date_on_or_before(EndDate, LimitDate).
framework_term_within_limit(StartDate, EndDate, exceeds_four_year_limit) :-
    framework_term_limit_date(StartDate, LimitDate),
    date_after(EndDate, LimitDate).

call_off_award_window_status(StartDate, EndDate, AwardDate, award_date_within_framework_term) :-
    date_on_or_before(StartDate, AwardDate),
    date_on_or_before(AwardDate, EndDate).
call_off_award_window_status(StartDate, _EndDate, AwardDate, award_date_outside_framework_term) :-
    date_before(AwardDate, StartDate).
call_off_award_window_status(StartDate, EndDate, AwardDate, award_date_outside_framework_term) :-
    date_on_or_after(AwardDate, StartDate),
    date_after(AwardDate, EndDate).

framework_agreements_input_problem(Profile, Problem) :-
    input_problem_in_scope(whole_profile, Profile, Problem).

input_problems_in_scope(Scope, Profile, Problems) :-
    findall(Candidate, input_problem_candidate(Scope, Profile, Candidate), Problems).

input_problem_in_scope(Scope, Profile, Problem) :-
    input_problems_in_scope(Scope, Profile, [Problem|_]).

input_acceptable_in_scope(Scope, Profile) :-
    input_problems_in_scope(Scope, Profile, []).

input_problem_candidate(_, Profile, not_ground(profile)) :-
    term_variables(Profile, [_|_]).
input_problem_candidate(_, Profile, not_a_dict(profile)) :-
    ground(Profile),
    \+ dict_keys(Profile, _).
input_problem_candidate(_, Profile, wrong_type(Key, Expected)) :-
    checkable_profile(Profile),
    framework_agreements_profile_key_list(Keys),
    member(Key, Keys),
    get(Profile, Key, Value),
    profile_key_type(Key, Type),
    value_lacks_type(Type, Value),
    expected_type_name(Type, Expected).
input_problem_candidate(_, Profile, out_of_range(framework_operator_count, expected_at_least_one)) :-
    checkable_profile(Profile),
    get(Profile, framework_operator_count, OperatorCount),
    is_integer_value(OperatorCount),
    OperatorCount #< 1.
input_problem_candidate(Scope, Profile, missing_key(Key)) :-
    checkable_profile(Profile),
    framework_agreements_profile_key_list(Keys),
    member(Key, Keys),
    key_required(Scope, Profile, Key),
    profile_lacks(Profile, Key).

checkable_profile(Profile) :-
    ground(Profile),
    dict_keys(Profile, _).

framework_agreements_profile_key_list([framework_start_date, framework_end_date, call_off_award_date, framework_operator_count, call_off_method_key, exceptional_case_duly_justified, contracting_authority_identified_in_call_for_competition, economic_operator_party_to_framework, call_off_entails_substantial_modification, call_off_within_limits_of_framework_terms, framework_sets_out_all_terms, objective_conditions_for_determining_performer_indicated, partly_with_partly_without_reopening_stipulated, objective_criteria_for_choice_of_route_stated, terms_subject_to_reopening_specified, reopened_competition_based_on_framework_terms, capable_operators_consulted_in_writing, time_limit_sufficiently_long, tenders_submitted_in_writing, tender_contents_confidential_until_time_limit_expired, award_made_on_framework_award_criteria]).

profile_key_type(framework_start_date, date_value).
profile_key_type(framework_end_date, date_value).
profile_key_type(call_off_award_date, date_value).
profile_key_type(framework_operator_count, integer_value).
profile_key_type(call_off_method_key, call_off_method_value).
profile_key_type(exceptional_case_duly_justified, boolean_flag).
profile_key_type(contracting_authority_identified_in_call_for_competition, boolean_flag).
profile_key_type(economic_operator_party_to_framework, boolean_flag).
profile_key_type(call_off_entails_substantial_modification, boolean_flag).
profile_key_type(call_off_within_limits_of_framework_terms, boolean_flag).
profile_key_type(framework_sets_out_all_terms, boolean_flag).
profile_key_type(objective_conditions_for_determining_performer_indicated, boolean_flag).
profile_key_type(partly_with_partly_without_reopening_stipulated, boolean_flag).
profile_key_type(objective_criteria_for_choice_of_route_stated, boolean_flag).
profile_key_type(terms_subject_to_reopening_specified, boolean_flag).
profile_key_type(reopened_competition_based_on_framework_terms, boolean_flag).
profile_key_type(capable_operators_consulted_in_writing, boolean_flag).
profile_key_type(time_limit_sufficiently_long, boolean_flag).
profile_key_type(tenders_submitted_in_writing, boolean_flag).
profile_key_type(tender_contents_confidential_until_time_limit_expired, boolean_flag).
profile_key_type(award_made_on_framework_award_criteria, boolean_flag).

expected_type_name(date_value, expected_date).
expected_type_name(integer_value, expected_integer).
expected_type_name(boolean_flag, expected_boolean).
expected_type_name(call_off_method_value, expected_call_off_method).

value_has_type(date_value, Value) :-
    is_date_value(Value).
value_has_type(integer_value, Value) :-
    is_integer_value(Value).
value_has_type(boolean_flag, Value) :-
    boolean_value(Value).
value_has_type(call_off_method_value, Value) :-
    call_off_method(Value).

value_lacks_type(date_value, Value) :-
    date_value_check(Value, not_a_date).
value_lacks_type(integer_value, Value) :-
    not_an_integer(Value).
value_lacks_type(boolean_flag, Value) :-
    dif(Value, true),
    dif(Value, false).
value_lacks_type(call_off_method_value, Value) :-
    findall(Method, call_off_method(Method), Methods),
    not_member(Value, Methods).

boolean_value(true).
boolean_value(false).

is_integer_value(Value) :-
    integer(Value).

not_an_integer(Value) :-
    atom(Value).
not_an_integer(Value) :-
    float(Value).
not_an_integer(Value) :-
    compound(Value).
not_an_integer(Value) :-
    dict_keys(Value, _).

is_date_value(Value) :-
    date_value_check(Value, date_value).

date_value_check(Value, Class) :-
    catch((must_be_date(Value), Class = date_value), error(type_error(_, _), _), Class = not_a_date).

key_required(framework_term, _, framework_start_date).
key_required(framework_term, _, framework_end_date).
key_required(framework_term, Profile, exceptional_case_duly_justified) :-
    term_exceeds_limit(Profile).
key_required(call_off, _, framework_start_date).
key_required(call_off, _, framework_end_date).
key_required(call_off, _, call_off_award_date).
key_required(call_off, _, framework_operator_count).
key_required(call_off, _, call_off_method_key).
key_required(call_off, _, contracting_authority_identified_in_call_for_competition).
key_required(call_off, _, economic_operator_party_to_framework).
key_required(call_off, _, call_off_entails_substantial_modification).
key_required(call_off, Profile, call_off_within_limits_of_framework_terms) :-
    operator_count_value(Profile, OperatorCount),
    OperatorCount #< 2.
key_required(call_off, Profile, framework_sets_out_all_terms) :-
    operator_count_value(Profile, OperatorCount),
    OperatorCount #>= 2.
key_required(call_off, Profile, partly_with_partly_without_reopening_stipulated) :-
    operator_count_value(Profile, OperatorCount),
    OperatorCount #>= 2.
key_required(call_off, Profile, objective_conditions_for_determining_performer_indicated) :-
    operator_count_value(Profile, OperatorCount),
    OperatorCount #>= 2,
    get(Profile, call_off_method_key, without_reopening_competition).
key_required(call_off, Profile, objective_criteria_for_choice_of_route_stated) :-
    operator_count_value(Profile, OperatorCount),
    OperatorCount #>= 2,
    get(Profile, partly_with_partly_without_reopening_stipulated, true).
key_required(call_off, Profile, terms_subject_to_reopening_specified) :-
    operator_count_value(Profile, OperatorCount),
    OperatorCount #>= 2,
    get(Profile, partly_with_partly_without_reopening_stipulated, true).
key_required(call_off, Profile, Key) :-
    member(Key, [reopened_competition_based_on_framework_terms, capable_operators_consulted_in_writing, time_limit_sufficiently_long, tenders_submitted_in_writing, tender_contents_confidential_until_time_limit_expired, award_made_on_framework_award_criteria]),
    route_is_reopened_competition(Profile).
key_required(whole_profile, Profile, Key) :-
    key_required(framework_term, Profile, Key).
key_required(whole_profile, Profile, Key) :-
    key_required(call_off, Profile, Key).

operator_count_value(Profile, OperatorCount) :-
    get(Profile, framework_operator_count, OperatorCount),
    is_integer_value(OperatorCount).

route_is_reopened_competition(Profile) :-
    operator_count_value(Profile, OperatorCount),
    OperatorCount #>= 2,
    get(Profile, call_off_method_key, with_reopening_competition),
    get(Profile, framework_sets_out_all_terms, false).
route_is_reopened_competition(Profile) :-
    operator_count_value(Profile, OperatorCount),
    OperatorCount #>= 2,
    get(Profile, call_off_method_key, with_reopening_competition),
    get(Profile, partly_with_partly_without_reopening_stipulated, true).

term_exceeds_limit(Profile) :-
    get(Profile, framework_start_date, StartDate),
    get(Profile, framework_end_date, EndDate),
    is_date_value(StartDate),
    is_date_value(EndDate),
    date_on_or_after(EndDate, StartDate),
    framework_term_within_limit(StartDate, EndDate, exceeds_four_year_limit).

call_off_route(Profile, Route) :-
    input_acceptable_in_scope(call_off, Profile),
    route_for_profile(Profile, Route).

route_for_profile(Profile, single_operator_direct_award) :-
    get(Profile, framework_operator_count, OperatorCount),
    OperatorCount #< 2,
    get(Profile, call_off_method_key, without_reopening_competition).
route_for_profile(Profile, no_lawful_route) :-
    get(Profile, framework_operator_count, OperatorCount),
    OperatorCount #< 2,
    get(Profile, call_off_method_key, with_reopening_competition).
route_for_profile(Profile, multi_operator_direct_award_under_split_framework) :-
    get(Profile, framework_operator_count, OperatorCount),
    OperatorCount #>= 2,
    get(Profile, call_off_method_key, without_reopening_competition),
    get(Profile, partly_with_partly_without_reopening_stipulated, true).
route_for_profile(Profile, multi_operator_direct_award_all_terms_set_out) :-
    get(Profile, framework_operator_count, OperatorCount),
    OperatorCount #>= 2,
    get(Profile, call_off_method_key, without_reopening_competition),
    get(Profile, partly_with_partly_without_reopening_stipulated, false).
route_for_profile(Profile, multi_operator_reopened_competition) :-
    get(Profile, framework_operator_count, OperatorCount),
    OperatorCount #>= 2,
    get(Profile, call_off_method_key, with_reopening_competition),
    get(Profile, framework_sets_out_all_terms, false).
route_for_profile(Profile, multi_operator_reopened_competition) :-
    get(Profile, framework_operator_count, OperatorCount),
    OperatorCount #>= 2,
    get(Profile, call_off_method_key, with_reopening_competition),
    get(Profile, framework_sets_out_all_terms, true),
    get(Profile, partly_with_partly_without_reopening_stipulated, true).
route_for_profile(Profile, no_lawful_route) :-
    get(Profile, framework_operator_count, OperatorCount),
    OperatorCount #>= 2,
    get(Profile, call_off_method_key, with_reopening_competition),
    get(Profile, framework_sets_out_all_terms, true),
    get(Profile, partly_with_partly_without_reopening_stipulated, false).

framework_term_defect_fires(framework_end_date_precedes_start_date, Profile) :-
    implements(eu_dir_2014_24_art_33_1),
    get(Profile, framework_start_date, StartDate),
    get(Profile, framework_end_date, EndDate),
    date_before(EndDate, StartDate).
framework_term_defect_fires(framework_term_exceeds_four_years, Profile) :-
    implements(eu_dir_2014_24_art_33_1),
    get(Profile, framework_start_date, StartDate),
    get(Profile, framework_end_date, EndDate),
    date_on_or_after(EndDate, StartDate),
    get(Profile, exceptional_case_duly_justified, false),
    framework_term_within_limit(StartDate, EndDate, exceeds_four_year_limit).

call_off_defect_fires(call_off_awarded_outside_framework_term, Profile, _) :-
    implements(eu_dir_2014_24_art_33_2),
    get(Profile, framework_start_date, StartDate),
    get(Profile, framework_end_date, EndDate),
    get(Profile, call_off_award_date, AwardDate),
    call_off_award_window_status(StartDate, EndDate, AwardDate, award_date_outside_framework_term).
call_off_defect_fires(contracting_authority_not_identified_in_call_for_competition, Profile, _) :-
    implements(eu_dir_2014_24_art_33_2),
    get(Profile, contracting_authority_identified_in_call_for_competition, false).
call_off_defect_fires(economic_operator_not_party_to_framework, Profile, _) :-
    implements(eu_dir_2014_24_art_33_2),
    get(Profile, economic_operator_party_to_framework, false).
call_off_defect_fires(substantial_modification_of_framework_terms, Profile, _) :-
    implements(eu_dir_2014_24_art_33_2),
    get(Profile, call_off_entails_substantial_modification, true).
call_off_defect_fires(call_off_outside_limits_of_framework_terms, Profile, _) :-
    implements(eu_dir_2014_24_art_33_3),
    get(Profile, framework_operator_count, OperatorCount),
    OperatorCount #< 2,
    get(Profile, call_off_within_limits_of_framework_terms, false).
call_off_defect_fires(reopening_competition_in_single_operator_framework, Profile, _) :-
    implements(eu_dir_2014_24_art_33_4),
    get(Profile, framework_operator_count, OperatorCount),
    OperatorCount #< 2,
    get(Profile, call_off_method_key, with_reopening_competition).
call_off_defect_fires(direct_award_without_all_terms_set_out, Profile, Route) :-
    implements(eu_dir_2014_24_art_33_4),
    member(Route, [multi_operator_direct_award_all_terms_set_out, multi_operator_direct_award_under_split_framework]),
    get(Profile, framework_sets_out_all_terms, false).
call_off_defect_fires(objective_conditions_for_determining_performer_not_indicated, Profile, Route) :-
    implements(eu_dir_2014_24_art_33_4),
    member(Route, [multi_operator_direct_award_all_terms_set_out, multi_operator_direct_award_under_split_framework]),
    get(Profile, objective_conditions_for_determining_performer_indicated, false).
call_off_defect_fires(objective_criteria_for_choice_of_route_not_stated, Profile, _Route) :-
    implements(eu_dir_2014_24_art_33_4),
    get(Profile, framework_operator_count, OperatorCount),
    OperatorCount #>= 2,
    get(Profile, partly_with_partly_without_reopening_stipulated, true),
    get(Profile, objective_criteria_for_choice_of_route_stated, false).
call_off_defect_fires(terms_subject_to_reopening_not_specified, Profile, _Route) :-
    implements(eu_dir_2014_24_art_33_4),
    get(Profile, framework_operator_count, OperatorCount),
    OperatorCount #>= 2,
    get(Profile, partly_with_partly_without_reopening_stipulated, true),
    get(Profile, terms_subject_to_reopening_specified, false).
call_off_defect_fires(reopening_not_available_where_framework_sets_out_all_terms, Profile, no_lawful_route) :-
    implements(eu_dir_2014_24_art_33_4),
    get(Profile, framework_operator_count, OperatorCount),
    OperatorCount #>= 2.
call_off_defect_fires(reopened_competition_not_based_on_framework_terms, Profile, multi_operator_reopened_competition) :-
    implements(eu_dir_2014_24_art_33_5),
    get(Profile, reopened_competition_based_on_framework_terms, false).
call_off_defect_fires(capable_operators_not_all_consulted_in_writing, Profile, multi_operator_reopened_competition) :-
    implements(eu_dir_2014_24_art_33_5),
    get(Profile, capable_operators_consulted_in_writing, false).
call_off_defect_fires(time_limit_not_sufficiently_long, Profile, multi_operator_reopened_competition) :-
    implements(eu_dir_2014_24_art_33_5),
    get(Profile, time_limit_sufficiently_long, false).
call_off_defect_fires(tenders_not_submitted_in_writing, Profile, multi_operator_reopened_competition) :-
    implements(eu_dir_2014_24_art_33_5),
    get(Profile, tenders_submitted_in_writing, false).
call_off_defect_fires(tender_contents_opened_before_time_limit_expired, Profile, multi_operator_reopened_competition) :-
    implements(eu_dir_2014_24_art_33_5),
    get(Profile, tender_contents_confidential_until_time_limit_expired, false).
call_off_defect_fires(award_not_made_on_framework_award_criteria, Profile, multi_operator_reopened_competition) :-
    implements(eu_dir_2014_24_art_33_5),
    get(Profile, award_made_on_framework_award_criteria, false).

framework_term_defect_clear(framework_end_date_precedes_start_date, Profile) :-
    get(Profile, framework_start_date, StartDate),
    get(Profile, framework_end_date, EndDate),
    date_on_or_after(EndDate, StartDate).
framework_term_defect_clear(framework_term_exceeds_four_years, Profile) :-
    get(Profile, framework_start_date, StartDate),
    get(Profile, framework_end_date, EndDate),
    date_before(EndDate, StartDate).
framework_term_defect_clear(framework_term_exceeds_four_years, Profile) :-
    get(Profile, framework_start_date, StartDate),
    get(Profile, framework_end_date, EndDate),
    date_on_or_after(EndDate, StartDate),
    framework_term_within_limit(StartDate, EndDate, within_four_year_limit).
framework_term_defect_clear(framework_term_exceeds_four_years, Profile) :-
    get(Profile, framework_start_date, StartDate),
    get(Profile, framework_end_date, EndDate),
    date_on_or_after(EndDate, StartDate),
    framework_term_within_limit(StartDate, EndDate, exceeds_four_year_limit),
    get(Profile, exceptional_case_duly_justified, true).

call_off_defect_clear(call_off_awarded_outside_framework_term, Profile, _) :-
    get(Profile, framework_start_date, StartDate),
    get(Profile, framework_end_date, EndDate),
    get(Profile, call_off_award_date, AwardDate),
    call_off_award_window_status(StartDate, EndDate, AwardDate, award_date_within_framework_term).
call_off_defect_clear(contracting_authority_not_identified_in_call_for_competition, Profile, _) :-
    get(Profile, contracting_authority_identified_in_call_for_competition, true).
call_off_defect_clear(economic_operator_not_party_to_framework, Profile, _) :-
    get(Profile, economic_operator_party_to_framework, true).
call_off_defect_clear(substantial_modification_of_framework_terms, Profile, _) :-
    get(Profile, call_off_entails_substantial_modification, false).
call_off_defect_clear(call_off_outside_limits_of_framework_terms, Profile, _) :-
    get(Profile, framework_operator_count, OperatorCount),
    OperatorCount #< 2,
    get(Profile, call_off_within_limits_of_framework_terms, true).
call_off_defect_clear(reopening_competition_in_single_operator_framework, Profile, _) :-
    get(Profile, framework_operator_count, OperatorCount),
    OperatorCount #< 2,
    get(Profile, call_off_method_key, without_reopening_competition).
call_off_defect_clear(direct_award_without_all_terms_set_out, Profile, Route) :-
    member(Route, [multi_operator_direct_award_all_terms_set_out, multi_operator_direct_award_under_split_framework]),
    get(Profile, framework_sets_out_all_terms, true).
call_off_defect_clear(objective_conditions_for_determining_performer_not_indicated, Profile, Route) :-
    member(Route, [multi_operator_direct_award_all_terms_set_out, multi_operator_direct_award_under_split_framework]),
    get(Profile, objective_conditions_for_determining_performer_indicated, true).
call_off_defect_clear(objective_criteria_for_choice_of_route_not_stated, Profile, _) :-
    get(Profile, framework_operator_count, OperatorCount),
    OperatorCount #>= 2,
    get(Profile, partly_with_partly_without_reopening_stipulated, true),
    get(Profile, objective_criteria_for_choice_of_route_stated, true).
call_off_defect_clear(terms_subject_to_reopening_not_specified, Profile, _) :-
    get(Profile, framework_operator_count, OperatorCount),
    OperatorCount #>= 2,
    get(Profile, partly_with_partly_without_reopening_stipulated, true),
    get(Profile, terms_subject_to_reopening_specified, true).
call_off_defect_clear(reopening_not_available_where_framework_sets_out_all_terms, Profile, Route) :-
    get(Profile, framework_operator_count, OperatorCount),
    OperatorCount #>= 2,
    dif(Route, no_lawful_route).
call_off_defect_clear(reopened_competition_not_based_on_framework_terms, Profile, multi_operator_reopened_competition) :-
    get(Profile, reopened_competition_based_on_framework_terms, true).
call_off_defect_clear(capable_operators_not_all_consulted_in_writing, Profile, multi_operator_reopened_competition) :-
    get(Profile, capable_operators_consulted_in_writing, true).
call_off_defect_clear(time_limit_not_sufficiently_long, Profile, multi_operator_reopened_competition) :-
    get(Profile, time_limit_sufficiently_long, true).
call_off_defect_clear(tenders_not_submitted_in_writing, Profile, multi_operator_reopened_competition) :-
    get(Profile, tenders_submitted_in_writing, true).
call_off_defect_clear(tender_contents_opened_before_time_limit_expired, Profile, multi_operator_reopened_competition) :-
    get(Profile, tender_contents_confidential_until_time_limit_expired, true).
call_off_defect_clear(award_not_made_on_framework_award_criteria, Profile, multi_operator_reopened_competition) :-
    get(Profile, award_made_on_framework_award_criteria, true).

decide_framework_term(Profile, Verdict) :-
    input_acceptable_in_scope(framework_term, Profile),
    framework_term_decision(Profile, Verdict).

framework_term_decision(Profile, framework_term_verdict(lawful_framework_term, [], [])) :-
    get(Profile, framework_start_date, StartDate),
    get(Profile, framework_end_date, EndDate),
    date_on_or_after(EndDate, StartDate),
    framework_term_within_limit(StartDate, EndDate, within_four_year_limit).
framework_term_decision(Profile, framework_term_verdict(lawful_framework_term, [], [])) :-
    get(Profile, framework_start_date, StartDate),
    get(Profile, framework_end_date, EndDate),
    date_on_or_after(EndDate, StartDate),
    framework_term_within_limit(StartDate, EndDate, exceeds_four_year_limit),
    get(Profile, exceptional_case_duly_justified, true).
framework_term_decision(Profile, framework_term_verdict(unlawful_framework_term, [framework_end_date_precedes_start_date], [cite(eu_dir_2014_24_art_33_1)])) :-
    get(Profile, framework_start_date, StartDate),
    get(Profile, framework_end_date, EndDate),
    date_before(EndDate, StartDate).
framework_term_decision(Profile, framework_term_verdict(unlawful_framework_term, [framework_term_exceeds_four_years], [cite(eu_dir_2014_24_art_33_1)])) :-
    get(Profile, framework_start_date, StartDate),
    get(Profile, framework_end_date, EndDate),
    date_on_or_after(EndDate, StartDate),
    framework_term_within_limit(StartDate, EndDate, exceeds_four_year_limit),
    get(Profile, exceptional_case_duly_justified, false).

decide_call_off(Profile, call_off_verdict(Status, Route, DefectIds, Citations)) :-
    input_acceptable_in_scope(call_off, Profile),
    route_for_profile(Profile, Route),
    call_off_limb_ids(LimbIds),
    findall(LimbId, (member(LimbId, LimbIds), call_off_defect_fires(LimbId, Profile, Route)), DefectIds),
    findall(Citation, (member(LimbId, DefectIds), call_off_citation(LimbId, Citation)), Citations),
    call_off_status(DefectIds, Status).

call_off_status([], call_off_lawful).
call_off_status([_|_], call_off_unlawful).

decide_framework_agreements(Profile, framework_agreements_verdict(framework_term_unlawful, [cite(eu_dir_2014_24_art_33_1)])) :-
    decide_framework_term(Profile, framework_term_verdict(unlawful_framework_term, _, _)).
decide_framework_agreements(Profile, framework_agreements_verdict(call_off_unlawful, Citations)) :-
    decide_framework_term(Profile, framework_term_verdict(lawful_framework_term, _, _)),
    decide_call_off(Profile, call_off_verdict(call_off_unlawful, _, _, Citations)).
decide_framework_agreements(Profile, framework_agreements_verdict(framework_term_lawful, [])) :-
    decide_framework_term(Profile, framework_term_verdict(lawful_framework_term, _, _)),
    decide_call_off(Profile, call_off_verdict(call_off_lawful, _, _, _)).

framework_agreements_status(Profile, Route) :-
    call_off_route(Profile, Route).

framework_agreements_checklist(Profile, Checklist) :-
    input_acceptable_in_scope(whole_profile, Profile),
    route_for_profile(Profile, Route),
    framework_term_checklist(Profile, TermChecklist),
    call_off_checklist(Profile, Route, CallOffChecklist),
    append(TermChecklist, CallOffChecklist, Checklist).

framework_term_checklist(Profile, Checklist) :-
    framework_term_limb_ids(LimbIds),
    findall(item(LimbId, Status, Citation), (member(LimbId, LimbIds), framework_term_citation(LimbId, Citation), framework_term_limb_status(LimbId, Profile, Status)), Checklist).

framework_term_limb_status(LimbId, Profile, unmet(LimbId)) :-
    framework_term_defect_fires(LimbId, Profile).
framework_term_limb_status(LimbId, Profile, met) :-
    framework_term_defect_clear(LimbId, Profile).

call_off_checklist(Profile, Route, Checklist) :-
    call_off_limb_ids(LimbIds),
    findall(item(LimbId, Status, Citation), (member(LimbId, LimbIds), call_off_citation(LimbId, Citation), call_off_limb_in_scope(LimbId, Profile, Route), call_off_limb_status(LimbId, Profile, Route, Status)), Checklist).

call_off_limb_in_scope(call_off_awarded_outside_framework_term, _, _).
call_off_limb_in_scope(contracting_authority_not_identified_in_call_for_competition, _, _).
call_off_limb_in_scope(economic_operator_not_party_to_framework, _, _).
call_off_limb_in_scope(substantial_modification_of_framework_terms, _, _).
call_off_limb_in_scope(call_off_outside_limits_of_framework_terms, Profile, _) :-
    get(Profile, framework_operator_count, OperatorCount),
    OperatorCount #< 2.
call_off_limb_in_scope(reopening_competition_in_single_operator_framework, Profile, _) :-
    get(Profile, framework_operator_count, OperatorCount),
    OperatorCount #< 2.
call_off_limb_in_scope(direct_award_without_all_terms_set_out, _, Route) :-
    member(Route, [multi_operator_direct_award_all_terms_set_out, multi_operator_direct_award_under_split_framework]).
call_off_limb_in_scope(objective_conditions_for_determining_performer_not_indicated, _, Route) :-
    member(Route, [multi_operator_direct_award_all_terms_set_out, multi_operator_direct_award_under_split_framework]).
call_off_limb_in_scope(objective_criteria_for_choice_of_route_not_stated, Profile, _) :-
    get(Profile, framework_operator_count, OperatorCount),
    OperatorCount #>= 2,
    get(Profile, partly_with_partly_without_reopening_stipulated, true).
call_off_limb_in_scope(terms_subject_to_reopening_not_specified, Profile, _) :-
    get(Profile, framework_operator_count, OperatorCount),
    OperatorCount #>= 2,
    get(Profile, partly_with_partly_without_reopening_stipulated, true).
call_off_limb_in_scope(reopening_not_available_where_framework_sets_out_all_terms, Profile, _) :-
    get(Profile, framework_operator_count, OperatorCount),
    OperatorCount #>= 2.
call_off_limb_in_scope(reopened_competition_not_based_on_framework_terms, _, multi_operator_reopened_competition).
call_off_limb_in_scope(capable_operators_not_all_consulted_in_writing, _, multi_operator_reopened_competition).
call_off_limb_in_scope(time_limit_not_sufficiently_long, _, multi_operator_reopened_competition).
call_off_limb_in_scope(tenders_not_submitted_in_writing, _, multi_operator_reopened_competition).
call_off_limb_in_scope(tender_contents_opened_before_time_limit_expired, _, multi_operator_reopened_competition).
call_off_limb_in_scope(award_not_made_on_framework_award_criteria, _, multi_operator_reopened_competition).

call_off_limb_status(LimbId, Profile, Route, unmet(LimbId)) :-
    call_off_defect_fires(LimbId, Profile, Route).
call_off_limb_status(LimbId, Profile, Route, met) :-
    call_off_defect_clear(LimbId, Profile, Route).

framework_agreements_decision_resolvable(Profile) :-
    decide_framework_agreements(Profile, _).

framework_agreements_status_values([framework_term_lawful, framework_term_unlawful, call_off_lawful, call_off_unlawful]).

no_statute("term_anniversary", 4, "computation_helper").
no_statute("leap_year", 1, "computation_helper").
no_statute("common_year", 1, "computation_helper").
no_statute("input_problems_in_scope", 3, "computation_helper").
no_statute("input_acceptable_in_scope", 2, "computation_helper").
no_statute("value_lacks_type", 2, "computation_helper").
no_statute("not_an_integer", 1, "computation_helper").
no_statute("date_value_check", 2, "computation_helper").
no_statute("framework_term_defect_clear", 2, "computation_helper").
no_statute("call_off_defect_clear", 3, "computation_helper").
