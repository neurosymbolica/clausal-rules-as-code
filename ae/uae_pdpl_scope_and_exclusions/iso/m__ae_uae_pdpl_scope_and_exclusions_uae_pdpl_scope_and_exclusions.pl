% SPDX-License-Identifier: EUPL-1.2
:- module(m__ae_uae_pdpl_scope_and_exclusions_uae_pdpl_scope_and_exclusions, [pdpl_applies/3, pdpl_in_force/3, decide_uae_pdpl_scope_and_exclusions/2, uae_pdpl_scope_and_exclusions_status/2, uae_pdpl_scope_and_exclusions_checklist/2, uae_pdpl_scope_and_exclusions_decision_resolvable/1, uae_pdpl_scope_and_exclusions_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(formalize_lib, [profile_get/3, profile_lacks/2]).
:- use_module(m__ae_uae_pdpl_scope_and_exclusions_kernel, [uae_pdpl_scope_and_exclusions_input_problems/2]).
:- use_module(m__ae_uae_pdpl_scope_and_exclusions_citations, [implements/1]).

commencement_day(date(2022, 1, 2), cite(uae_pdpl_art_31)).

uae_pdpl_scope_and_exclusions_status_values([applies, does_not_apply, not_in_force]).

final_citations(not_in_force, [cite(uae_pdpl_art_31)]).
final_citations(does_not_apply, [cite(uae_pdpl_art_2_1), cite(uae_pdpl_art_2_2)]).
final_citations(applies, [cite(uae_pdpl_art_1_personal_data), cite(uae_pdpl_art_1_processing), cite(uae_pdpl_art_2_1), cite(uae_pdpl_art_2_1_a), cite(uae_pdpl_art_2_1_b), cite(uae_pdpl_art_2_1_c), cite(uae_pdpl_art_2_2), cite(uae_pdpl_art_31)]).

root_keys([processing_date, activity_is_processing_of_personal_data, personal_data_is_government_data, governmental_entity_controls_or_processes, personal_data_held_by_security_or_judicial_authorities, data_subject_processing_own_data_for_personal_purposes, personal_health_data_with_own_protection_legislation, personal_banking_or_credit_data_with_own_protection_legislation, free_zone_company_or_establishment_with_own_data_protection_legislation, data_subject_resides_or_has_place_of_business_in_state, controller_or_processor_resides_in_state, data_subject_inside_state]).

applies_ladder([row(cite(uae_pdpl_art_31), date_before, final(not_in_force)), row(cite(uae_pdpl_art_31), absent(processing_date), missing(processing_date)), row(cite(uae_pdpl_art_1_personal_data), value_is(activity_is_processing_of_personal_data, false), final(does_not_apply)), row(cite(uae_pdpl_art_2_1), all_false([data_subject_resides_or_has_place_of_business_in_state, controller_or_processor_resides_in_state, data_subject_inside_state]), final(does_not_apply)), row(cite(uae_pdpl_art_2_2), any_true([personal_data_is_government_data, governmental_entity_controls_or_processes, personal_data_held_by_security_or_judicial_authorities, data_subject_processing_own_data_for_personal_purposes, personal_health_data_with_own_protection_legislation, personal_banking_or_credit_data_with_own_protection_legislation, free_zone_company_or_establishment_with_own_data_protection_legislation]), final(does_not_apply)), row(cite(uae_pdpl_art_1_personal_data), absent(activity_is_processing_of_personal_data), missing(activity_is_processing_of_personal_data)), row(cite(uae_pdpl_art_2_2_a), absent(personal_data_is_government_data), missing(personal_data_is_government_data)), row(cite(uae_pdpl_art_2_2_b), absent(governmental_entity_controls_or_processes), missing(governmental_entity_controls_or_processes)), row(cite(uae_pdpl_art_2_2_c), absent(personal_data_held_by_security_or_judicial_authorities), missing(personal_data_held_by_security_or_judicial_authorities)), row(cite(uae_pdpl_art_2_2_d), absent(data_subject_processing_own_data_for_personal_purposes), missing(data_subject_processing_own_data_for_personal_purposes)), row(cite(uae_pdpl_art_2_2_e), absent(personal_health_data_with_own_protection_legislation), missing(personal_health_data_with_own_protection_legislation)), row(cite(uae_pdpl_art_2_2_f), absent(personal_banking_or_credit_data_with_own_protection_legislation), missing(personal_banking_or_credit_data_with_own_protection_legislation)), row(cite(uae_pdpl_art_2_2_g), absent(free_zone_company_or_establishment_with_own_data_protection_legislation), missing(free_zone_company_or_establishment_with_own_data_protection_legislation)), row(cite(uae_pdpl_art_2_1_a), none_true_and_absent([data_subject_resides_or_has_place_of_business_in_state, controller_or_processor_resides_in_state, data_subject_inside_state], data_subject_resides_or_has_place_of_business_in_state), missing(data_subject_resides_or_has_place_of_business_in_state)), row(cite(uae_pdpl_art_2_1_b), none_true_and_absent([data_subject_resides_or_has_place_of_business_in_state, controller_or_processor_resides_in_state, data_subject_inside_state], controller_or_processor_resides_in_state), missing(controller_or_processor_resides_in_state)), row(cite(uae_pdpl_art_2_1_c), none_true_and_absent([data_subject_resides_or_has_place_of_business_in_state, controller_or_processor_resides_in_state, data_subject_inside_state], data_subject_inside_state), missing(data_subject_inside_state)), row(cite(uae_pdpl_art_1_personal_data), value_is(activity_is_processing_of_personal_data, unsure), refer(activity_is_processing_of_personal_data, cite(uae_pdpl_art_1_personal_data))), row(cite(uae_pdpl_art_2_2_a), value_is(personal_data_is_government_data, unsure), refer(personal_data_is_government_data, cite(uae_pdpl_art_2_2_a))), row(cite(uae_pdpl_art_2_2_b), value_is(governmental_entity_controls_or_processes, unsure), refer(governmental_entity_controls_or_processes, cite(uae_pdpl_art_2_2_b))), row(cite(uae_pdpl_art_2_2_c), value_is(personal_data_held_by_security_or_judicial_authorities, unsure), refer(personal_data_held_by_security_or_judicial_authorities, cite(uae_pdpl_art_2_2_c))), row(cite(uae_pdpl_art_2_2_d), value_is(data_subject_processing_own_data_for_personal_purposes, unsure), refer(data_subject_processing_own_data_for_personal_purposes, cite(uae_pdpl_art_2_2_d))), row(cite(uae_pdpl_art_2_2_e), value_is(personal_health_data_with_own_protection_legislation, unsure), refer(personal_health_data_with_own_protection_legislation, cite(uae_pdpl_art_2_2_e))), row(cite(uae_pdpl_art_2_2_f), value_is(personal_banking_or_credit_data_with_own_protection_legislation, unsure), refer(personal_banking_or_credit_data_with_own_protection_legislation, cite(uae_pdpl_art_2_2_f))), row(cite(uae_pdpl_art_2_2_g), value_is(free_zone_company_or_establishment_with_own_data_protection_legislation, unsure), refer(free_zone_company_or_establishment_with_own_data_protection_legislation, cite(uae_pdpl_art_2_2_g))), row(cite(uae_pdpl_art_2_1), otherwise, final(applies))]).

key_state(Profile, AttributeKey, absent) :-
    profile_lacks(Profile, AttributeKey).
key_state(Profile, AttributeKey, value(AttributeValue)) :-
    profile_get(Profile, AttributeKey, AttributeValue).

key_state_pair(Profile, AttributeKey, AttributeKey - StateTerm) :-
    key_state(Profile, AttributeKey, StateTerm).

profile_states(Profile, States) :-
    root_keys(Keys),
    maplist(key_state_pair(Profile), Keys, States).

state_of(States, AttributeKey, StateTerm) :-
    member(AttributeKey - StateTerm, States).

present_pairs(States, Pairs) :-
    findall(AttributeKey - AttributeValue, member(AttributeKey - value(AttributeValue), States), Pairs).

truth_and(true, Truth, Truth).
truth_and(false, _, false).

truth_or(true, _, true).
truth_or(false, Truth, Truth).

truth_not(true, false).
truth_not(false, true).

state_value_t(absent, _, false).
state_value_t(value(AttributeValue), Wanted, Truth) :-
    memberd_t(AttributeValue, [Wanted], Truth).

state_is_t(States, AttributeKey, Wanted, Truth) :-
    state_of(States, AttributeKey, StateTerm),
    state_value_t(StateTerm, Wanted, Truth).

absent_state_t(absent, true).
absent_state_t(value(_), false).

any_true_t(_, [], false).
any_true_t(States, [AttributeKey|Keys], Truth) :-
    state_is_t(States, AttributeKey, true, HeadTruth),
    any_true_t(States, Keys, RestTruth),
    truth_or(HeadTruth, RestTruth, Truth).

all_false_t(_, [], true).
all_false_t(States, [AttributeKey|Keys], Truth) :-
    state_is_t(States, AttributeKey, false, HeadTruth),
    all_false_t(States, Keys, RestTruth),
    truth_and(HeadTruth, RestTruth, Truth).

day_order(date(Year, Month, DayNumber), date(OtherYear, OtherMonth, OtherDayNumber), DayOrder) :-
    compare(YearOrder, Year, OtherYear),
    year_order(YearOrder, Month, DayNumber, OtherMonth, OtherDayNumber, DayOrder).

year_order(<, _, _, _, _, <).
year_order(>, _, _, _, _, >).
year_order(=, Month, DayNumber, OtherMonth, OtherDayNumber, DayOrder) :-
    compare(MonthOrder, Month, OtherMonth),
    month_order(MonthOrder, DayNumber, OtherDayNumber, DayOrder).

month_order(<, _, _, <).
month_order(>, _, _, >).
month_order(=, DayNumber, OtherDayNumber, DayOrder) :-
    compare(DayOrder, DayNumber, OtherDayNumber).

order_before_t(<, true).
order_before_t(=, false).
order_before_t(>, false).

before_commencement_t(ProcessingDate, Truth) :-
    implements(uae_pdpl_art_31),
    commencement_day(CommencementDay, cite(uae_pdpl_art_31)),
    day_order(ProcessingDate, CommencementDay, DayOrder),
    order_before_t(DayOrder, Truth).

date_before_state_t(absent, false).
date_before_state_t(value(ProcessingDate), Truth) :-
    implements(uae_pdpl_art_31),
    before_commencement_t(ProcessingDate, Truth).

condition_t(date_before, States, Truth) :-
    implements(uae_pdpl_art_31),
    state_of(States, processing_date, StateTerm),
    date_before_state_t(StateTerm, Truth).
condition_t(absent(AttributeKey), States, Truth) :-
    state_of(States, AttributeKey, StateTerm),
    absent_state_t(StateTerm, Truth).
condition_t(value_is(AttributeKey, Wanted), States, Truth) :-
    state_is_t(States, AttributeKey, Wanted, Truth).
condition_t(all_false(Keys), States, Truth) :-
    implements(uae_pdpl_art_2_1),
    implements(uae_pdpl_art_1_state),
    implements(uae_pdpl_art_1_data_subject),
    implements(uae_pdpl_art_1_controller),
    implements(uae_pdpl_art_1_processor),
    all_false_t(States, Keys, Truth).
condition_t(any_true(Keys), States, Truth) :-
    implements(uae_pdpl_art_2_2),
    implements(uae_pdpl_art_1_establishment),
    any_true_t(States, Keys, Truth).
condition_t(none_true_and_absent(Keys, AttributeKey), States, Truth) :-
    implements(uae_pdpl_art_2_1),
    any_true_t(States, Keys, AnyTrue),
    truth_not(AnyTrue, NoneTrue),
    state_of(States, AttributeKey, StateTerm),
    absent_state_t(StateTerm, IsAbsent),
    truth_and(NoneTrue, IsAbsent, Truth).
condition_t(otherwise, _, true).

outcome(final(Status), _, Status, Citations) :-
    final_citations(Status, Citations).
outcome(missing(AttributeKey), _, indeterminate([AttributeKey]), []).
outcome(refer(AttributeKey, cite(Citation)), States, needs_legal_review(open_textured(AttributeKey, cite(Citation)), [inputs_relied_on(Pairs)]), []) :-
    present_pairs(States, Pairs).

walk_ladder([row(cite(_Provision), Condition, Outcome)|LadderRows], States, Result, Citations) :-
    condition_t(Condition, States, Truth),
    ladder_choice(Truth, Outcome, LadderRows, States, Result, Citations).

ladder_choice(true, Outcome, _, States, Result, Citations) :-
    outcome(Outcome, States, Result, Citations).
ladder_choice(false, _, LadderRows, States, Result, Citations) :-
    walk_ladder(LadderRows, States, Result, Citations).

pdpl_applies(Profile, input_problems([Problem|Problems]), []) :-
    uae_pdpl_scope_and_exclusions_input_problems(Profile, [Problem|Problems]).
pdpl_applies(Profile, Result, Citations) :-
    uae_pdpl_scope_and_exclusions_input_problems(Profile, []),
    implements(uae_pdpl_art_2_1),
    profile_states(Profile, States),
    applies_ladder(LadderRows),
    walk_ladder(LadderRows, States, Result, Citations).

pdpl_in_force(Profile, input_problems([Problem|Problems]), []) :-
    uae_pdpl_scope_and_exclusions_input_problems(Profile, [Problem|Problems]).
pdpl_in_force(Profile, Result, Citations) :-
    uae_pdpl_scope_and_exclusions_input_problems(Profile, []),
    implements(uae_pdpl_art_31),
    key_state(Profile, processing_date, StateTerm),
    in_force_from_state(StateTerm, Result, Citations).

in_force_from_state(absent, indeterminate([processing_date]), []).
in_force_from_state(value(ProcessingDate), Result, Citations) :-
    implements(uae_pdpl_art_31),
    before_commencement_t(ProcessingDate, Truth),
    in_force_by_day(Truth, Result, Citations).

in_force_by_day(true, not_in_force, [cite(uae_pdpl_art_31)]).
in_force_by_day(false, in_force, [cite(uae_pdpl_art_31)]).

decide_uae_pdpl_scope_and_exclusions(Profile, uae_pdpl_scope_and_exclusions_verdict(Status, Citations)) :-
    pdpl_applies(Profile, Status, Citations).

uae_pdpl_scope_and_exclusions_status(Profile, Status) :-
    decide_uae_pdpl_scope_and_exclusions(Profile, uae_pdpl_scope_and_exclusions_verdict(Status, _Citations)).

uae_pdpl_scope_and_exclusions_decision_resolvable(Profile) :-
    decide_uae_pdpl_scope_and_exclusions(Profile, _Verdict).

checklist_row(in_force_on_processing_date, cite(uae_pdpl_art_31), commencement).
checklist_row(processing_of_personal_data, cite(uae_pdpl_art_1_personal_data), positive(activity_is_processing_of_personal_data)).
checklist_row(way_of_article_2_1_met, cite(uae_pdpl_art_2_1), any_way([data_subject_resides_or_has_place_of_business_in_state, controller_or_processor_resides_in_state, data_subject_inside_state])).
checklist_row(government_data_exclusion_does_not_hold, cite(uae_pdpl_art_2_2_a), negative(personal_data_is_government_data)).
checklist_row(governmental_entity_exclusion_does_not_hold, cite(uae_pdpl_art_2_2_b), negative(governmental_entity_controls_or_processes)).
checklist_row(security_or_judicial_exclusion_does_not_hold, cite(uae_pdpl_art_2_2_c), negative(personal_data_held_by_security_or_judicial_authorities)).
checklist_row(personal_purposes_exclusion_does_not_hold, cite(uae_pdpl_art_2_2_d), negative(data_subject_processing_own_data_for_personal_purposes)).
checklist_row(health_data_exclusion_does_not_hold, cite(uae_pdpl_art_2_2_e), negative(personal_health_data_with_own_protection_legislation)).
checklist_row(banking_or_credit_data_exclusion_does_not_hold, cite(uae_pdpl_art_2_2_f), negative(personal_banking_or_credit_data_with_own_protection_legislation)).
checklist_row(free_zone_exclusion_does_not_hold, cite(uae_pdpl_art_2_2_g), negative(free_zone_company_or_establishment_with_own_data_protection_legislation)).

uae_pdpl_scope_and_exclusions_checklist(Profile, Items) :-
    uae_pdpl_scope_and_exclusions_input_problems(Profile, []),
    profile_states(Profile, States),
    findall(item(Identifier, Status, cite(Provision)), checklist_item(States, Identifier, Status, Provision), Items).

checklist_item(States, Identifier, Status, Provision) :-
    checklist_row(Identifier, cite(Provision), Test),
    row_status(Test, States, Status).

row_status(commencement, States, Status) :-
    implements(uae_pdpl_art_31),
    state_of(States, processing_date, StateTerm),
    commencement_status(StateTerm, Status).
row_status(positive(AttributeKey), States, Status) :-
    implements(uae_pdpl_art_1_personal_data),
    state_of(States, AttributeKey, StateTerm),
    positive_status(StateTerm, AttributeKey, Status).
row_status(negative(AttributeKey), States, Status) :-
    implements(uae_pdpl_art_2_2),
    state_of(States, AttributeKey, StateTerm),
    negative_status(StateTerm, AttributeKey, Status).
row_status(any_way(Keys), States, Status) :-
    implements(uae_pdpl_art_2_1),
    any_true_t(States, Keys, AnyTrue),
    way_status(AnyTrue, Keys, States, Status).

commencement_status(absent, unknown([processing_date])).
commencement_status(value(ProcessingDate), Status) :-
    before_commencement_t(ProcessingDate, Truth),
    commencement_truth_status(Truth, Status).

commencement_truth_status(true, unmet(processing_date_before_commencement)).
commencement_truth_status(false, met).

positive_status(absent, AttributeKey, unknown([AttributeKey])).
positive_status(value(true), _, met).
positive_status(value(false), AttributeKey, unmet(AttributeKey)).
positive_status(value(unsure), AttributeKey, unknown([AttributeKey])).

negative_status(absent, AttributeKey, unknown([AttributeKey])).
negative_status(value(false), _, met).
negative_status(value(true), AttributeKey, unmet(AttributeKey)).
negative_status(value(unsure), AttributeKey, unknown([AttributeKey])).

way_status(true, _, _, met).
way_status(false, Keys, States, Status) :-
    all_false_t(States, Keys, AllFalse),
    no_way_status(AllFalse, States, Status).

no_way_status(true, _, unmet(no_way_of_article_2_1_met)).
no_way_status(false, States, unknown(AbsentKeys)) :-
    findall(AttributeKey, (member(AttributeKey, [data_subject_resides_or_has_place_of_business_in_state, controller_or_processor_resides_in_state, data_subject_inside_state]), state_of(States, AttributeKey, absent)), AbsentKeys).

applying_profile([attribute(processing_date, date(2022, 1, 2)), attribute(activity_is_processing_of_personal_data, true), attribute(personal_data_is_government_data, false), attribute(governmental_entity_controls_or_processes, false), attribute(personal_data_held_by_security_or_judicial_authorities, false), attribute(data_subject_processing_own_data_for_personal_purposes, false), attribute(personal_health_data_with_own_protection_legislation, false), attribute(personal_banking_or_credit_data_with_own_protection_legislation, false), attribute(free_zone_company_or_establishment_with_own_data_protection_legislation, false), attribute(data_subject_resides_or_has_place_of_business_in_state, true), attribute(controller_or_processor_resides_in_state, false), attribute(data_subject_inside_state, false)]).

test(the_first_day_applies_once) :-
    applying_profile(Profile),
    findall(Result - Citations, pdpl_applies(Profile, Result, Citations), Answers),
    length(Answers, 1),
    Answers = [applies - _].
test(applies_cites_the_eight_provisions) :-
    applying_profile(Profile),
    pdpl_applies(Profile, applies, Citations),
    length(Citations, 8),
    member(cite(uae_pdpl_art_31), Citations).
test(the_day_before_is_not_in_force) :-
    findall(Result - Citations, pdpl_applies([attribute(processing_date, date(2022, 1, 1)), attribute(activity_is_processing_of_personal_data, true)], Result, Citations), Answers),
    Answers == [not_in_force - [cite(uae_pdpl_art_31)]].
test(an_absent_date_is_named_first) :-
    pdpl_applies([attribute(activity_is_processing_of_personal_data, false)], Result, Citations),
    Result == indeterminate([processing_date]),
    Citations == [].
test(not_processing_does_not_apply) :-
    findall(Result - Citations, pdpl_applies([attribute(processing_date, date(2023, 5, 1)), attribute(activity_is_processing_of_personal_data, false)], Result, Citations), Answers),
    Answers == [does_not_apply - [cite(uae_pdpl_art_2_1), cite(uae_pdpl_art_2_2)]].
test(no_way_does_not_apply) :-
    pdpl_applies([attribute(processing_date, date(2023, 5, 1)), attribute(data_subject_resides_or_has_place_of_business_in_state, false), attribute(controller_or_processor_resides_in_state, false), attribute(data_subject_inside_state, false)], does_not_apply, _).
test(one_exclusion_settles_with_others_absent) :-
    findall(Result, pdpl_applies([attribute(processing_date, date(2023, 5, 1)), attribute(free_zone_company_or_establishment_with_own_data_protection_legislation, true)], Result, _), Results),
    Results == [does_not_apply].
test(the_processing_judgement_is_named_before_exclusions) :-
    pdpl_applies([attribute(processing_date, date(2023, 5, 1))], indeterminate([activity_is_processing_of_personal_data]), []).
test(a_way_key_is_named_after_the_exclusions) :-
    pdpl_applies([attribute(processing_date, date(2023, 5, 1)), attribute(activity_is_processing_of_personal_data, true), attribute(personal_data_is_government_data, false), attribute(governmental_entity_controls_or_processes, false), attribute(personal_data_held_by_security_or_judicial_authorities, false), attribute(data_subject_processing_own_data_for_personal_purposes, false), attribute(personal_health_data_with_own_protection_legislation, false), attribute(personal_banking_or_credit_data_with_own_protection_legislation, false), attribute(free_zone_company_or_establishment_with_own_data_protection_legislation, false), attribute(data_subject_resides_or_has_place_of_business_in_state, false)], indeterminate([controller_or_processor_resides_in_state]), []).
test(one_true_way_needs_no_other_way_key) :-
    pdpl_applies([attribute(processing_date, date(2023, 5, 1)), attribute(activity_is_processing_of_personal_data, true), attribute(personal_data_is_government_data, false), attribute(governmental_entity_controls_or_processes, false), attribute(personal_data_held_by_security_or_judicial_authorities, false), attribute(data_subject_processing_own_data_for_personal_purposes, false), attribute(personal_health_data_with_own_protection_legislation, false), attribute(personal_banking_or_credit_data_with_own_protection_legislation, false), attribute(free_zone_company_or_establishment_with_own_data_protection_legislation, false), attribute(controller_or_processor_resides_in_state, true)], applies, _).
test(an_unsure_judgement_is_referred_with_present_pairs) :-
    findall(Result - Citations, pdpl_applies([attribute(data_subject_inside_state, true), attribute(processing_date, date(2024, 2, 29)), attribute(activity_is_processing_of_personal_data, true), attribute(personal_data_is_government_data, unsure), attribute(governmental_entity_controls_or_processes, false), attribute(personal_data_held_by_security_or_judicial_authorities, false), attribute(data_subject_processing_own_data_for_personal_purposes, false), attribute(personal_health_data_with_own_protection_legislation, false), attribute(personal_banking_or_credit_data_with_own_protection_legislation, false), attribute(free_zone_company_or_establishment_with_own_data_protection_legislation, false)], Result, Citations), Answers),
    Answers == [needs_legal_review(open_textured(personal_data_is_government_data, cite(uae_pdpl_art_2_2_a)), [inputs_relied_on([processing_date - date(2024, 2, 29), activity_is_processing_of_personal_data - true, personal_data_is_government_data - unsure, governmental_entity_controls_or_processes - false, personal_data_held_by_security_or_judicial_authorities - false, data_subject_processing_own_data_for_personal_purposes - false, personal_health_data_with_own_protection_legislation - false, personal_banking_or_credit_data_with_own_protection_legislation - false, free_zone_company_or_establishment_with_own_data_protection_legislation - false, data_subject_inside_state - true])]) - []].
test(a_missing_key_comes_before_a_referral) :-
    pdpl_applies([attribute(processing_date, date(2023, 5, 1)), attribute(activity_is_processing_of_personal_data, unsure)], indeterminate([personal_data_is_government_data]), []).
test(input_problems_come_first) :-
    findall(Result - Citations, pdpl_applies([attribute(processing_date, date(2021, 2, 29))], Result, Citations), Answers),
    Answers == [input_problems([wrong_type(processing_date)]) - []].
test(in_force_on_the_first_day) :-
    findall(Result - Citations, pdpl_in_force([attribute(processing_date, date(2022, 1, 2))], Result, Citations), Answers),
    Answers == [in_force - [cite(uae_pdpl_art_31)]].
test(not_in_force_on_the_last_day_of_2021) :-
    pdpl_in_force([attribute(processing_date, date(2021, 12, 31))], not_in_force, [cite(uae_pdpl_art_31)]).
test(in_force_ignores_other_keys) :-
    pdpl_in_force([attribute(processing_date, date(9999, 12, 31)), attribute(activity_is_processing_of_personal_data, unsure)], in_force, _).
test(in_force_names_an_absent_date) :-
    pdpl_in_force([], indeterminate([processing_date]), []).
test(in_force_reports_input_problems) :-
    pdpl_in_force(profile, input_problems([wrong_type(profile)]), []).
test(the_checklist_cites_every_item) :-
    applying_profile(Profile),
    uae_pdpl_scope_and_exclusions_checklist(Profile, Items),
    length(Items, 10),
    member(item(way_of_article_2_1_met, met, cite(uae_pdpl_art_2_1)), Items),
    member(item(in_force_on_processing_date, met, cite(uae_pdpl_art_31)), Items).
test(the_checklist_marks_an_unknown_way) :-
    uae_pdpl_scope_and_exclusions_checklist([attribute(data_subject_inside_state, false)], Items),
    member(item(way_of_article_2_1_met, unknown([data_subject_resides_or_has_place_of_business_in_state, controller_or_processor_resides_in_state]), cite(uae_pdpl_art_2_1)), Items).
test(the_status_projection) :-
    applying_profile(Profile),
    uae_pdpl_scope_and_exclusions_status(Profile, applies).

test(the_first_day_is_not_not_in_force, fail) :-
    applying_profile(Profile),
    pdpl_applies(Profile, not_in_force, _).
test(the_day_before_is_not_in_force_by_in_force_query, fail) :-
    pdpl_in_force([attribute(processing_date, date(2022, 1, 1))], in_force, _).
