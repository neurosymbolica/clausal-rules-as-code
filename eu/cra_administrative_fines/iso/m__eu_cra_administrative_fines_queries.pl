% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_cra_administrative_fines_queries, [cra_administrative_fines_profile_keys/1, cra_administrative_fines_what_if/4, not_yet_applicable/0, not_listed_in_article_64/0, date/3, infringed_provision/0, offender_is_open_source_software_steward/0, offender_is_undertaking/0, total_worldwide_annual_turnover_in_euros/0, annex_i_essential_cybersecurity_requirements/0, article_13/0, article_14/0, article_18/0, article_19/0, article_20/0, article_21/0, article_22/0, article_23/0, article_28/0, article_30_paragraphs_1_to_4/0, article_31_paragraphs_1_to_4/0, article_32_paragraphs_1_to_3/0, article_33_paragraph_5/0, article_39/0, article_41/0, article_47/0, article_49/0, article_53/0, incorrect_incomplete_or_misleading_information_in_reply_to_request/0, other_provision/0, unsure/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_cra_administrative_fines_kernel, [cra_administrative_fines_input_problems/2, cra_administrative_fines_contract_keys/1, cra_administrative_fines_calendar_day_t/2]).
:- use_module(m__eu_cra_administrative_fines_cra_administrative_fines, [cra_administrative_fines_status/2]).

not_yet_applicable.

not_listed_in_article_64.

date(Year, Month, Day) :-
    cra_administrative_fines_calendar_day_t(date(Year, Month, Day), true).

infringed_provision.

offender_is_open_source_software_steward.

offender_is_undertaking.

total_worldwide_annual_turnover_in_euros.

annex_i_essential_cybersecurity_requirements.

article_13.

article_14.

article_18.

article_19.

article_20.

article_21.

article_22.

article_23.

article_28.

article_30_paragraphs_1_to_4.

article_31_paragraphs_1_to_4.

article_32_paragraphs_1_to_3.

article_33_paragraph_5.

article_39.

article_41.

article_47.

article_49.

article_53.

incorrect_incomplete_or_misleading_information_in_reply_to_request.

other_provision.

unsure.

cra_administrative_fines_profile_keys(ProfileKeys) :-
    cra_administrative_fines_contract_keys(ProfileKeys).

cra_administrative_fines_what_if(infringement(Profile, _OriginalDate), infringement_date, NewDate, NewStatus) :-
    cra_administrative_fines_status(infringement(Profile, NewDate), NewStatus).
cra_administrative_fines_what_if(infringement(Profile, InfringementDate), OverriddenKey, NewValue, NewStatus) :-
    dif(OverriddenKey, infringement_date),
    profile_with_value(Profile, OverriddenKey, NewValue, HypotheticalProfile),
    cra_administrative_fines_status(infringement(HypotheticalProfile, InfringementDate), NewStatus).

profile_with_value(Profile, OverriddenKey, NewValue, HypotheticalProfile) :-
    profile_without_key(Profile, OverriddenKey, KeptElements),
    append(KeptElements, [attribute(OverriddenKey, NewValue)], HypotheticalProfile).

profile_without_key([], _, []).
profile_without_key([Element|Elements], OverriddenKey, KeptElements) :-
    nonvar(Element),
    Element = attribute(ElementKey, _),
    ElementKey == OverriddenKey,
    profile_without_key(Elements, OverriddenKey, KeptElements).
profile_without_key([Element|Elements], OverriddenKey, [Element|KeptElements]) :-
    nonvar(Element),
    Element = attribute(ElementKey, _),
    ElementKey \== OverriddenKey,
    profile_without_key(Elements, OverriddenKey, KeptElements).
profile_without_key([Element|Elements], OverriddenKey, [Element|KeptElements]) :-
    var(Element),
    profile_without_key(Elements, OverriddenKey, KeptElements).
profile_without_key([Element|Elements], OverriddenKey, [Element|KeptElements]) :-
    nonvar(Element),
    functor(Element, ElementName, ElementArity),
    dif(ElementName/ElementArity, attribute/2),
    profile_without_key(Elements, OverriddenKey, KeptElements).

test(the_profile_keys_in_contract_order) :-
    cra_administrative_fines_profile_keys([infringed_provision, offender_is_open_source_software_steward, offender_is_undertaking, total_worldwide_annual_turnover_in_euros]).
test(the_input_check_is_re_exported) :-
    cra_administrative_fines_input_problems([attribute(colour, red)], [unknown_key(colour)]).
test(the_result_constructors_build_as_data) :-
    not_yet_applicable,
    not_listed_in_article_64,
    Verdict = fine_maximum(highest_maximum_tier, fixed_amount, 1500000000),
    functor(Verdict, fine_maximum, 3),
    Exclusion = fine_excluded(open_source_software_steward),
    functor(Exclusion, fine_excluded, 1),
    Missing = indeterminate([infringed_provision]),
    functor(Missing, indeterminate, 1),
    Refusal = input_problems([wrong_type(profile)]),
    functor(Refusal, input_problems, 1).
test(the_root_atoms_are_defined) :-
    infringed_provision,
    article_13,
    incorrect_incomplete_or_misleading_information_in_reply_to_request,
    other_provision,
    unsure.
test(a_leap_day_is_a_date) :-
    date(2028, 2, 29).
test(moving_the_date_to_the_application_day_reads_the_provision) :-
    cra_administrative_fines_status(infringement([attribute(infringed_provision, article_14), attribute(offender_is_undertaking, false)], date(2027, 12, 10)), not_yet_applicable),
    findall(Status, cra_administrative_fines_what_if(infringement([attribute(infringed_provision, article_14), attribute(offender_is_undertaking, false)], date(2027, 12, 10)), infringement_date, date(2027, 12, 11), Status), Statuses),
    Statuses = [fine_maximum(highest_maximum_tier, fixed_amount_for_non_undertaking, CapInEuroCents)],
    CapInEuroCents =:= 1500000000.
test(one_euro_more_turnover_flips_the_basis_at_the_highest_tie) :-
    cra_administrative_fines_status(infringement([attribute(infringed_provision, article_14), attribute(offender_is_undertaking, true), attribute(total_worldwide_annual_turnover_in_euros, 600000000)], date(2028, 1, 1)), fine_maximum(highest_maximum_tier, fixed_amount, FixedInEuroCents)),
    FixedInEuroCents =:= 1500000000,
    cra_administrative_fines_what_if(infringement([attribute(infringed_provision, article_14), attribute(offender_is_undertaking, true), attribute(total_worldwide_annual_turnover_in_euros, 600000000)], date(2028, 1, 1)), total_worldwide_annual_turnover_in_euros, 600000001, fine_maximum(highest_maximum_tier, percentage_of_turnover, PercentageInEuroCents)),
    PercentageInEuroCents =:= 1500000002.
test(a_steward_edit_in_the_middle_tier_excludes_the_fine) :-
    findall(Status, cra_administrative_fines_what_if(infringement([attribute(infringed_provision, article_28), attribute(offender_is_open_source_software_steward, false), attribute(offender_is_undertaking, false)], date(2028, 1, 1)), offender_is_open_source_software_steward, true, Status), Statuses),
    Statuses == [fine_excluded(open_source_software_steward)].
test(an_edit_replaces_the_attribute_and_adds_no_duplicate) :-
    findall(Status, cra_administrative_fines_what_if(infringement([attribute(infringed_provision, article_14), attribute(offender_is_undertaking, false)], date(2028, 1, 1)), offender_is_undertaking, true, Status), Statuses),
    Statuses == [indeterminate([total_worldwide_annual_turnover_in_euros])].
test(an_edit_outside_the_contract_is_an_input_problem) :-
    cra_administrative_fines_what_if(infringement([], date(2028, 1, 1)), colour, red, input_problems([unknown_key(colour)])).

test(a_non_leap_day_is_no_date, fail) :-
    date(2027, 2, 29).
test(the_tie_is_not_the_percentage_basis, fail) :-
    cra_administrative_fines_what_if(infringement([attribute(infringed_provision, article_14), attribute(offender_is_undertaking, true), attribute(total_worldwide_annual_turnover_in_euros, 1)], date(2028, 1, 1)), total_worldwide_annual_turnover_in_euros, 600000000, fine_maximum(_, percentage_of_turnover, _)).
