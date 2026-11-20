% SPDX-License-Identifier: EUPL-1.2
:- module(m__sg_securities_sfa_offer_exemptions_sfa_offer_exemptions, [sfa_offer_exemption/2, decide_sfa_offer_exemptions/2, sfa_offer_exemptions_status/2, sfa_offer_exemptions_checklist/2, sfa_offer_exemptions_decision_resolvable/1, sfa_offer_exemptions_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_dicts, [dict_keys/2, dict_pairs/2, get/3]).
:- use_module(library(clpz)).
:- use_module(clausal_datetime, [timedelta/3, date_add/3]).
:- use_module(m__sg_securities_sfa_offer_exemptions_citations, [implements/1]).
:- use_module(formalize_lib, [not_member/2]).

small_offer_amount_limit_cents(500000000, cite(sg_sfa_2001_s272a_1)).

private_placement_person_limit(50, cite(sg_sfa_2001_s272b_1)).

principal_minimum_consideration_cents(20000000, cite(sg_sfa_2001_s275_1a)).

small_offer_lookback_months(12, cite(sg_sfa_2001_s272a_1)).

private_placement_lookback_months(12, cite(sg_sfa_2001_s272b_1)).

prospectus_satisfied_275_1_state(none, cite(sg_sfa_2001_s275_1)).
prospectus_satisfied_275_1_state(expired, cite(sg_sfa_2001_s275_1)).
prospectus_satisfied_275_1_state(registered_authority_and_offerees_notified, cite(sg_sfa_2001_s275_1)).

prospectus_satisfied_272a_extra_state(registered_authority_notified, cite(sg_sfa_2001_s272a_1)).

prospectus_not_satisfied_state(registered_not_notified, cite(sg_sfa_2001_s275_1)).

required_profile_keys([offer_date, institutional_offerees, relevant_person_offerees, other_offerees, amount_raised_cents, advertisement, non_permitted_selling_expenses, prospectus_state]).

key_absent(Profile, ProfileKey) :-
    dict_keys(Profile, ProfileKeys),
    not_member(ProfileKey, ProfileKeys).

all_required_present(Profile) :-
    required_profile_keys(ProfileKeys),
    findall(ProfileKey, (member(ProfileKey, ProfileKeys), key_absent(Profile, ProfileKey)), Missing),
    length(Missing, MissingCount),
    MissingCount #= 0.

required_key_absent(Profile) :-
    required_profile_keys(ProfileKeys),
    findall(ProfileKey, (member(ProfileKey, ProfileKeys), key_absent(Profile, ProfileKey)), Missing),
    length(Missing, MissingCount),
    MissingCount #> 0.

optional_get(Profile, ProfileKey, _Default, ProfileValue) :-
    get(Profile, ProfileKey, ProfileValue).
optional_get(Profile, ProfileKey, Default, ProfileValue) :-
    key_absent(Profile, ProfileKey),
    ProfileValue = Default.

get_required(Profile, OfferDate, Institutional, Relevant, Other, AmountRaised, Advertisement, NonPermitted, ProspectusState) :-
    get(Profile, offer_date, OfferDate),
    get(Profile, institutional_offerees, Institutional),
    get(Profile, relevant_person_offerees, Relevant),
    get(Profile, other_offerees, Other),
    get(Profile, amount_raised_cents, AmountRaised),
    get(Profile, advertisement, Advertisement),
    get(Profile, non_permitted_selling_expenses, NonPermitted),
    get(Profile, prospectus_state, ProspectusState).

get_optional(Profile, PersonalOffer, Statement, Principal, MinConsideration, PriorSmall, PriorPrivate) :-
    optional_get(Profile, personal_offer, false, PersonalOffer),
    optional_get(Profile, statement_and_resale_notification_given, false, Statement),
    optional_get(Profile, acquires_as_principal, false, Principal),
    optional_get(Profile, minimum_consideration_per_transaction_cents, 0, MinConsideration),
    optional_get(Profile, prior_small_offers, [], PriorSmall),
    optional_get(Profile, prior_private_placement_offerees, [], PriorPrivate).

one_year_before_after_one_day(OfferDate, FirstDay) :-
    timedelta(1, 0, OneDayDelta),
    date_add(OfferDate, OneDayDelta, NextDay),
    one_year_before(NextDay, FirstDay).

one_year_before(NextDay, PreviousDate) :-
    NextDay = date(CalendarYear, CalendarMonth, CalendarDay),
    PreviousYear #= CalendarYear - 1,
    previous_year_date(PreviousYear, CalendarMonth, CalendarDay, PreviousDate).

previous_year_date(CalendarYear, 2, 29, ResultDate) :-
    leap_year(CalendarYear),
    ResultDate = date(CalendarYear, 2, 29).
previous_year_date(CalendarYear, 2, 29, ResultDate) :-
    not_leap_year(CalendarYear),
    ResultDate = date(CalendarYear, 3, 1).
previous_year_date(CalendarYear, 2, CalendarDay, ResultDate) :-
    CalendarDay \= 29,
    ResultDate = date(CalendarYear, 2, CalendarDay).
previous_year_date(CalendarYear, CalendarMonth, CalendarDay, ResultDate) :-
    CalendarMonth \= 2,
    ResultDate = date(CalendarYear, CalendarMonth, CalendarDay).

leap_year(CalendarYear) :-
    FebruaryTwentyEight = date(CalendarYear, 2, 28),
    timedelta(1, 0, OneDayDelta),
    date_add(FebruaryTwentyEight, OneDayDelta, NextDay),
    NextDay = date(_, 2, 29).

not_leap_year(CalendarYear) :-
    FebruaryTwentyEight = date(CalendarYear, 2, 28),
    timedelta(1, 0, OneDayDelta),
    date_add(FebruaryTwentyEight, OneDayDelta, NextDay),
    NextDay = date(_, 3, 1).

small_offer_window_first_day(OfferDate, FirstDay) :-
    implements(sg_sfa_2001_s272a_1),
    small_offer_lookback_months(LookbackMonths, _Citation),
    LookbackMonths #= 12,
    one_year_before_after_one_day(OfferDate, FirstDay).

private_placement_window_first_day(OfferDate, FirstDay) :-
    implements(sg_sfa_2001_s272b_1),
    private_placement_lookback_months(LookbackMonths, _Citation),
    LookbackMonths #= 12,
    one_year_before_after_one_day(OfferDate, FirstDay).

small_offer_in_window(FirstDay, OfferDate, EntryDate) :-
    implements(sg_sfa_2001_s272a_1),
    FirstDay @=< EntryDate,
    EntryDate @=< OfferDate.

private_placement_in_window(FirstDay, OfferDate, EntryDate) :-
    implements(sg_sfa_2001_s272b_1),
    FirstDay @=< EntryDate,
    EntryDate @=< OfferDate.

window_amount_cents(OfferDate, AmountRaised, PriorSmallOffers, WindowAmount) :-
    implements(sg_sfa_2001_s272a_1),
    small_offer_window_first_day(OfferDate, FirstDay),
    findall(Amount, (member(prior(EntryDate, Amount), PriorSmallOffers), small_offer_in_window(FirstDay, OfferDate, EntryDate)), Amounts),
    sum_list(Amounts, PriorAmounts),
    WindowAmount #= AmountRaised + PriorAmounts.

window_persons(OfferDate, Residual, PriorPrivatePlacementOfferees, WindowPersons) :-
    implements(sg_sfa_2001_s272b_1),
    private_placement_window_first_day(OfferDate, FirstDay),
    findall(Persons, (member(prior(EntryDate, Persons), PriorPrivatePlacementOfferees), private_placement_in_window(FirstDay, OfferDate, EntryDate)), PersonsList),
    sum_list(PersonsList, PriorPersons),
    WindowPersons #= Residual + PriorPersons.

prospectus_satisfied_275_1(ProspectusState) :-
    implements(sg_sfa_2001_s275_1),
    prospectus_satisfied_275_1_state(ProspectusState, _Citation).

prospectus_satisfied_272a(ProspectusState) :-
    implements(sg_sfa_2001_s272a_1),
    prospectus_satisfied_275_1_state(ProspectusState, _Citation).
prospectus_satisfied_272a(ProspectusState) :-
    implements(sg_sfa_2001_s272a_1),
    prospectus_satisfied_272a_extra_state(ProspectusState, _Citation).

s275_1_covers_relevant(Relevant, Advertisement, NonPermitted, ProspectusState, true) :-
    implements(sg_sfa_2001_s275_1),
    Relevant #> 0,
    Advertisement == false,
    NonPermitted == false,
    prospectus_satisfied_275_1(ProspectusState).
s275_1_covers_relevant(Relevant, Advertisement, NonPermitted, ProspectusState, false) :-
    implements(sg_sfa_2001_s275_1),
    s275_1_failure(Relevant, Advertisement, NonPermitted, ProspectusState).

s275_1_failure(Relevant, Advertisement, NonPermitted, ProspectusState) :-
    implements(sg_sfa_2001_s275_1),
    findall(Reason, (member(Reason, [zero_relevant, advertisement, non_permitted_expenses, prospectus_not_satisfied]), s275_1_failure_reason(Reason, Relevant, Advertisement, NonPermitted, ProspectusState)), Reasons),
    length(Reasons, ReasonCount),
    ReasonCount #> 0.

s275_1_failure_reason(zero_relevant, Relevant, _, _, _) :-
    implements(sg_sfa_2001_s275_1),
    Relevant #= 0.
s275_1_failure_reason(advertisement, _, Advertisement, _, _) :-
    implements(sg_sfa_2001_s275_1),
    Advertisement == true.
s275_1_failure_reason(non_permitted_expenses, _, _, NonPermitted, _) :-
    implements(sg_sfa_2001_s275_1),
    NonPermitted == true.
s275_1_failure_reason(prospectus_not_satisfied, _, _, _, ProspectusState) :-
    implements(sg_sfa_2001_s275_1),
    dif(ProspectusState, none),
    dif(ProspectusState, expired),
    dif(ProspectusState, registered_authority_and_offerees_notified).

residual_offerees(Relevant, Other, Advertisement, NonPermitted, ProspectusState, Residual) :-
    implements(sg_sfa_2001_s275_1),
    s275_1_covers_relevant(Relevant, Advertisement, NonPermitted, ProspectusState, true),
    Residual #= Other.
residual_offerees(Relevant, Other, Advertisement, NonPermitted, ProspectusState, Residual) :-
    implements(sg_sfa_2001_s275_1),
    s275_1_covers_relevant(Relevant, Advertisement, NonPermitted, ProspectusState, false),
    Residual #= Other + Relevant.

profile_context(Profile, context(OfferDate, Institutional, Relevant, Other, AmountRaised, Advertisement, NonPermitted, ProspectusState, PersonalOffer, Statement, Principal, MinConsideration, PriorSmall, PriorPrivate, Residual)) :-
    get_required(Profile, OfferDate, Institutional, Relevant, Other, AmountRaised, Advertisement, NonPermitted, ProspectusState),
    get_optional(Profile, PersonalOffer, Statement, Principal, MinConsideration, PriorSmall, PriorPrivate),
    residual_offerees(Relevant, Other, Advertisement, NonPermitted, ProspectusState, Residual).

exemption_applies(s274, Context) :-
    implements(sg_sfa_2001_s274),
    arg(2, Context, Institutional),
    Institutional #> 0.
exemption_applies(s275_1, Context) :-
    implements(sg_sfa_2001_s275_1),
    arg(3, Context, Relevant),
    arg(6, Context, Advertisement),
    arg(7, Context, NonPermitted),
    arg(8, Context, ProspectusState),
    Relevant #> 0,
    Advertisement == false,
    NonPermitted == false,
    prospectus_satisfied_275_1(ProspectusState).
exemption_applies(s275_1a, Context) :-
    implements(sg_sfa_2001_s275_1a),
    arg(15, Context, Residual),
    arg(11, Context, Principal),
    arg(12, Context, MinConsideration),
    arg(6, Context, Advertisement),
    arg(7, Context, NonPermitted),
    arg(8, Context, ProspectusState),
    Residual #> 0,
    Principal == true,
    principal_minimum_consideration_cents(Minimum, _Citation),
    MinConsideration #>= Minimum,
    Advertisement == false,
    NonPermitted == false,
    prospectus_satisfied_275_1(ProspectusState).
exemption_applies(s272a, Context) :-
    implements(sg_sfa_2001_s272a_1),
    arg(15, Context, Residual),
    arg(9, Context, PersonalOffer),
    arg(10, Context, Statement),
    arg(6, Context, Advertisement),
    arg(7, Context, NonPermitted),
    arg(8, Context, ProspectusState),
    arg(1, Context, OfferDate),
    arg(5, Context, AmountRaised),
    arg(13, Context, PriorSmall),
    Residual #> 0,
    PersonalOffer == true,
    Statement == true,
    Advertisement == false,
    NonPermitted == false,
    prospectus_satisfied_272a(ProspectusState),
    window_amount_cents(OfferDate, AmountRaised, PriorSmall, WindowAmount),
    small_offer_amount_limit_cents(Threshold, _Citation),
    WindowAmount #=< Threshold.
exemption_applies(s272b, Context) :-
    implements(sg_sfa_2001_s272b_1),
    arg(15, Context, Residual),
    arg(6, Context, Advertisement),
    arg(7, Context, NonPermitted),
    arg(8, Context, ProspectusState),
    arg(1, Context, OfferDate),
    arg(14, Context, PriorPrivate),
    Residual #> 0,
    Advertisement == false,
    NonPermitted == false,
    prospectus_satisfied_275_1(ProspectusState),
    window_persons(OfferDate, Residual, PriorPrivate, WindowPersons),
    private_placement_person_limit(Threshold, _Citation),
    WindowPersons #=< Threshold.

covered_by_list(Context, CoveredBy) :-
    findall(ExemptionAtom, (member(ExemptionAtom, [s274, s275_1, s275_1a, s272a, s272b]), exemption_applies(ExemptionAtom, Context)), CoveredBy).

residual_exemption_atoms(Context, ExemptionAtoms) :-
    findall(ExemptionAtom, (member(ExemptionAtom, [s275_1a, s272a, s272b]), exemption_applies(ExemptionAtom, Context)), ExemptionAtoms).

residual_covered_or_zero(Context) :-
    arg(15, Context, Residual),
    Residual #= 0.
residual_covered_or_zero(Context) :-
    arg(15, Context, Residual),
    Residual #> 0,
    residual_exemption_atoms(Context, ExemptionAtoms),
    length(ExemptionAtoms, ExemptionAtomCount),
    ExemptionAtomCount #> 0.

residual_uncovered(Context) :-
    arg(15, Context, Residual),
    Residual #> 0,
    residual_exemption_atoms(Context, ExemptionAtoms),
    length(ExemptionAtoms, ExemptionAtomCount),
    ExemptionAtomCount #= 0.

citations_for_covered([], []).
citations_for_covered([s274|RemainingList], [sg_sfa_2001_s274|RemainingCitations]) :-
    citations_for_covered(RemainingList, RemainingCitations).
citations_for_covered([s275_1|RemainingList], [sg_sfa_2001_s275_1|RemainingCitations]) :-
    citations_for_covered(RemainingList, RemainingCitations).
citations_for_covered([s275_1a|RemainingList], [sg_sfa_2001_s275_1a|RemainingCitations]) :-
    citations_for_covered(RemainingList, RemainingCitations).
citations_for_covered([s272a|RemainingList], [sg_sfa_2001_s272a_1|RemainingCitations]) :-
    citations_for_covered(RemainingList, RemainingCitations).
citations_for_covered([s272b|RemainingList], [sg_sfa_2001_s272b_1|RemainingCitations]) :-
    citations_for_covered(RemainingList, RemainingCitations).

profile_indeterminate(Profile) :-
    required_key_absent(Profile).
profile_indeterminate(Profile) :-
    all_required_present(Profile),
    get_required(Profile, _OfferDate, Institutional, Relevant, Other, _AmountRaised, _Advertisement, _NonPermitted, _ProspectusState),
    TotalOfferees #= Institutional + Relevant + Other,
    TotalOfferees #= 0.

profile_resolvable(Profile) :-
    all_required_present(Profile),
    get_required(Profile, _OfferDate, Institutional, Relevant, Other, _AmountRaised, _Advertisement, _NonPermitted, _ProspectusState),
    TotalOfferees #= Institutional + Relevant + Other,
    TotalOfferees #> 0.

indeterminate_unknown_keys(Profile, UnknownKeys) :-
    required_profile_keys(ProfileKeys),
    findall(ProfileKey, (member(ProfileKey, ProfileKeys), key_absent(Profile, ProfileKey)), Missing),
    length(Missing, MissingCount),
    MissingCount #> 0,
    UnknownKeys = Missing.
indeterminate_unknown_keys(Profile, []) :-
    all_required_present(Profile),
    get_required(Profile, _OfferDate, Institutional, Relevant, Other, _AmountRaised, _Advertisement, _NonPermitted, _ProspectusState),
    TotalOfferees #= Institutional + Relevant + Other,
    TotalOfferees #= 0.

sfa_offer_exemption(Profile, offer_exemption(indeterminate, [], n_a, n_a, [])) :-
    profile_indeterminate(Profile).
sfa_offer_exemption(Profile, offer_exemption(prospectus_required, [], WindowAmountCents, WindowPersons, [sg_sfa_2001_s240])) :-
    implements(sg_sfa_2001_s240),
    profile_resolvable(Profile),
    profile_context(Profile, Context),
    arg(1, Context, OfferDate),
    arg(5, Context, AmountRaised),
    arg(13, Context, PriorSmall),
    window_amount_cents(OfferDate, AmountRaised, PriorSmall, WindowAmountCents),
    arg(15, Context, Residual),
    arg(14, Context, PriorPrivate),
    window_persons(OfferDate, Residual, PriorPrivate, WindowPersons),
    residual_uncovered(Context).
sfa_offer_exemption(Profile, offer_exemption(exempt, CoveredBy, WindowAmountCents, WindowPersons, Citations)) :-
    profile_resolvable(Profile),
    profile_context(Profile, Context),
    arg(1, Context, OfferDate),
    arg(5, Context, AmountRaised),
    arg(13, Context, PriorSmall),
    window_amount_cents(OfferDate, AmountRaised, PriorSmall, WindowAmountCents),
    arg(15, Context, Residual),
    arg(14, Context, PriorPrivate),
    window_persons(OfferDate, Residual, PriorPrivate, WindowPersons),
    residual_covered_or_zero(Context),
    covered_by_list(Context, CoveredBy),
    citations_for_covered(CoveredBy, Citations).

decide_sfa_offer_exemptions(Profile, Result) :-
    sfa_offer_exemption(Profile, Result).

sfa_offer_exemptions_status(Profile, Status) :-
    sfa_offer_exemption(Profile, offer_exemption(Status, _CoveredBy, _WindowAmountCents, _WindowPersons, _Citations)).

sfa_offer_exemptions_decision_resolvable(Profile) :-
    sfa_offer_exemption(Profile, _Result).

sfa_offer_exemptions_status_values([exempt, prospectus_required, indeterminate]).

sfa_offer_exemptions_checklist(Profile, [item(offer_profile_complete, unknown(UnknownKeys), cite(sg_sfa_2001_s240))]) :-
    profile_indeterminate(Profile),
    indeterminate_unknown_keys(Profile, UnknownKeys).
sfa_offer_exemptions_checklist(Profile, [item(prospectus_required, unmet(no_exemption_applies), cite(sg_sfa_2001_s240))]) :-
    sfa_offer_exemption(Profile, offer_exemption(prospectus_required, _CoveredBy, _WindowAmountCents, _WindowPersons, _Citations)).
sfa_offer_exemptions_checklist(Profile, ChecklistItems) :-
    sfa_offer_exemption(Profile, offer_exemption(exempt, CoveredBy, _WindowAmountCents, _WindowPersons, _Citations)),
    checklist_items_for_covered(CoveredBy, ChecklistItems).

checklist_items_for_covered([], []).
checklist_items_for_covered([s274|RemainingList], [item(s274, met, cite(sg_sfa_2001_s274))|RemainingItems]) :-
    checklist_items_for_covered(RemainingList, RemainingItems).
checklist_items_for_covered([s275_1|RemainingList], [item(s275_1, met, cite(sg_sfa_2001_s275_1))|RemainingItems]) :-
    checklist_items_for_covered(RemainingList, RemainingItems).
checklist_items_for_covered([s275_1a|RemainingList], [item(s275_1a, met, cite(sg_sfa_2001_s275_1a))|RemainingItems]) :-
    checklist_items_for_covered(RemainingList, RemainingItems).
checklist_items_for_covered([s272a|RemainingList], [item(s272a, met, cite(sg_sfa_2001_s272a_1))|RemainingItems]) :-
    checklist_items_for_covered(RemainingList, RemainingItems).
checklist_items_for_covered([s272b|RemainingList], [item(s272b, met, cite(sg_sfa_2001_s272b_1))|RemainingItems]) :-
    checklist_items_for_covered(RemainingList, RemainingItems).

test(institutional_only_is_exempt) :-
    dict_pairs(Profile, [offer_date - date(2026, 6, 15), institutional_offerees - 1, relevant_person_offerees - 0, other_offerees - 0, amount_raised_cents - 1000000, advertisement - false, non_permitted_selling_expenses - false, prospectus_state - none]),
    sfa_offer_exemption(Profile, offer_exemption(exempt, [s274], 1000000, 0, [sg_sfa_2001_s274])).
test(relevant_person_is_exempt) :-
    dict_pairs(Profile, [offer_date - date(2026, 6, 15), institutional_offerees - 0, relevant_person_offerees - 2, other_offerees - 0, amount_raised_cents - 1000000, advertisement - false, non_permitted_selling_expenses - false, prospectus_state - none]),
    sfa_offer_exemption(Profile, offer_exemption(exempt, [s275_1], 1000000, 0, [sg_sfa_2001_s275_1])).
test(relevant_failure_without_residual_exemption_requires_prospectus) :-
    dict_pairs(Profile, [offer_date - date(2026, 6, 15), institutional_offerees - 0, relevant_person_offerees - 2, other_offerees - 0, amount_raised_cents - 1000000, advertisement - true, non_permitted_selling_expenses - false, prospectus_state - none]),
    sfa_offer_exemption(Profile, offer_exemption(prospectus_required, [], 1000000, 2, [sg_sfa_2001_s240])).
test(relevant_failure_is_rescued_by_small_offer_when_authority_notified) :-
    dict_pairs(Profile, [offer_date - date(2026, 6, 15), institutional_offerees - 0, relevant_person_offerees - 1, other_offerees - 0, amount_raised_cents - 1000000, advertisement - false, non_permitted_selling_expenses - false, prospectus_state - registered_authority_notified, personal_offer - true, statement_and_resale_notification_given - true, prior_private_placement_offerees - [prior(date(2025, 6, 16), 50)]]),
    sfa_offer_exemption(Profile, offer_exemption(exempt, [s272a], 1000000, 51, [sg_sfa_2001_s272a_1])).
test(other_offerees_are_covered_by_private_placement_at_the_limit) :-
    dict_pairs(Profile, [offer_date - date(2026, 6, 15), institutional_offerees - 0, relevant_person_offerees - 0, other_offerees - 45, amount_raised_cents - 1000000, advertisement - false, non_permitted_selling_expenses - false, prospectus_state - none, prior_private_placement_offerees - [prior(date(2025, 6, 16), 5)]]),
    sfa_offer_exemption(Profile, offer_exemption(exempt, [s272b], 1000000, 50, [sg_sfa_2001_s272b_1])).
test(other_offerees_are_not_covered_by_private_placement_over_the_limit) :-
    dict_pairs(Profile, [offer_date - date(2026, 6, 15), institutional_offerees - 0, relevant_person_offerees - 0, other_offerees - 46, amount_raised_cents - 1000000, advertisement - false, non_permitted_selling_expenses - false, prospectus_state - none, prior_private_placement_offerees - [prior(date(2025, 6, 16), 5)]]),
    sfa_offer_exemption(Profile, offer_exemption(prospectus_required, [], 1000000, 51, [sg_sfa_2001_s240])).
test(small_offer_at_the_amount_limit_is_exempt) :-
    dict_pairs(Profile, [offer_date - date(2026, 6, 15), institutional_offerees - 0, relevant_person_offerees - 0, other_offerees - 1, amount_raised_cents - 499999999, advertisement - false, non_permitted_selling_expenses - false, prospectus_state - none, personal_offer - true, statement_and_resale_notification_given - true, prior_small_offers - [prior(date(2025, 6, 16), 1)], prior_private_placement_offerees - [prior(date(2025, 6, 16), 50)]]),
    sfa_offer_exemption(Profile, offer_exemption(exempt, [s272a], 500000000, 51, [sg_sfa_2001_s272a_1])).
test(small_offer_over_the_amount_limit_requires_prospectus) :-
    dict_pairs(Profile, [offer_date - date(2026, 6, 15), institutional_offerees - 0, relevant_person_offerees - 0, other_offerees - 1, amount_raised_cents - 500000000, advertisement - false, non_permitted_selling_expenses - false, prospectus_state - none, personal_offer - true, statement_and_resale_notification_given - true, prior_small_offers - [prior(date(2025, 6, 16), 1)], prior_private_placement_offerees - [prior(date(2025, 6, 16), 50)]]),
    sfa_offer_exemption(Profile, offer_exemption(prospectus_required, [], 500000001, 51, [sg_sfa_2001_s240])).
test(principal_acquisition_at_the_minimum_is_exempt) :-
    dict_pairs(Profile, [offer_date - date(2026, 6, 15), institutional_offerees - 0, relevant_person_offerees - 0, other_offerees - 1, amount_raised_cents - 1000000, advertisement - false, non_permitted_selling_expenses - false, prospectus_state - none, acquires_as_principal - true, minimum_consideration_per_transaction_cents - 20000000, prior_private_placement_offerees - [prior(date(2025, 6, 16), 50)]]),
    sfa_offer_exemption(Profile, offer_exemption(exempt, [s275_1a], 1000000, 51, [sg_sfa_2001_s275_1a])).
test(principal_acquisition_below_the_minimum_requires_prospectus) :-
    dict_pairs(Profile, [offer_date - date(2026, 6, 15), institutional_offerees - 0, relevant_person_offerees - 0, other_offerees - 1, amount_raised_cents - 1000000, advertisement - false, non_permitted_selling_expenses - false, prospectus_state - none, acquires_as_principal - true, minimum_consideration_per_transaction_cents - 19999999, prior_private_placement_offerees - [prior(date(2025, 6, 16), 50)]]),
    sfa_offer_exemption(Profile, offer_exemption(prospectus_required, [], 1000000, 51, [sg_sfa_2001_s240])).
test(indeterminate_when_a_required_key_is_absent) :-
    dict_pairs(Profile, [offer_date - date(2026, 6, 15), institutional_offerees - 1, relevant_person_offerees - 0, other_offerees - 0, amount_raised_cents - 1000000, advertisement - false, non_permitted_selling_expenses - false]),
    sfa_offer_exemption(Profile, offer_exemption(indeterminate, [], n_a, n_a, [])).
test(indeterminate_when_there_are_no_offerees) :-
    dict_pairs(Profile, [offer_date - date(2026, 6, 15), institutional_offerees - 0, relevant_person_offerees - 0, other_offerees - 0, amount_raised_cents - 1000000, advertisement - false, non_permitted_selling_expenses - false, prospectus_state - none]),
    sfa_offer_exemption(Profile, offer_exemption(indeterminate, [], n_a, n_a, [])).
test(a_prior_entry_on_the_first_window_day_counts) :-
    dict_pairs(Profile, [offer_date - date(2026, 6, 15), institutional_offerees - 0, relevant_person_offerees - 0, other_offerees - 1, amount_raised_cents - 1000000, advertisement - false, non_permitted_selling_expenses - false, prospectus_state - none, prior_private_placement_offerees - [prior(date(2025, 6, 16), 49)]]),
    sfa_offer_exemption(Profile, offer_exemption(exempt, [s272b], 1000000, 50, [sg_sfa_2001_s272b_1])).
test(february_29_2028_window_starts_on_1_march_2027) :-
    dict_pairs(Profile, [offer_date - date(2028, 2, 29), institutional_offerees - 0, relevant_person_offerees - 0, other_offerees - 1, amount_raised_cents - 1000000, advertisement - false, non_permitted_selling_expenses - false, prospectus_state - none, prior_private_placement_offerees - [prior(date(2027, 3, 1), 49)]]),
    sfa_offer_exemption(Profile, offer_exemption(exempt, [s272b], 1000000, 50, [sg_sfa_2001_s272b_1])).
