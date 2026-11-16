% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_eprivacy_breach_traffic_location_marketing_eprivacy_breach_traffic_location_marketing, [decide_eprivacy_breach_traffic_location_marketing/2, eprivacy_breach_traffic_location_marketing_status/2, eprivacy_breach_traffic_location_marketing_checklist/2, eprivacy_breach_traffic_location_marketing_decision_resolvable/1, eprivacy_breach_traffic_location_marketing_status_values/1, personal_data_breach_notification_status/3, traffic_data_processing_status/3, location_data_processing_status/3, direct_marketing_communication_status/3, direct_marketing_email_practice_status/3]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(pairs), [pairs_values/2]).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(formalize_lib, [profile_get/3, profile_has/2, profile_lacks/2]).
:- use_module(m__eu_eprivacy_breach_traffic_location_marketing_kernel, [eprivacy_breach_traffic_location_marketing_input_problems/2]).
:- use_module(m__eu_eprivacy_breach_traffic_location_marketing_citations, [implements/1]).

eprivacy_breach_traffic_location_marketing_status_values([eligible, ineligible, national_law_decides, not_applicable]).

query_key_types(personal_data_breach_notification, [breach_provider_of_publicly_available_service - judgement, personal_data_breach_occurred - judgement, authority_required_individual_notification - boolean, breach_likely_to_adversely_affect_subscriber_or_individual - judgement, protection_measures_demonstrated_to_authority - boolean]).
query_key_types(traffic_data_processing, [traffic_provider_of_public_network_or_service - judgement, traffic_data_relating_to_subscribers_or_users - judgement, traffic_processing_purpose - traffic_processing_purpose, traffic_data_still_needed_for_transmission - judgement, traffic_data_necessary_for_billing_or_interconnection - judgement, traffic_billing_challenge_or_payment_period_running - judgement, traffic_marketing_provider_of_publicly_available_service - judgement, traffic_marketing_prior_consent_given - judgement, traffic_marketing_consent_withdrawn - boolean, traffic_marketing_processing_within_necessary_extent_and_duration - judgement]).
query_key_types(location_data_processing, [location_data_other_than_traffic_data_in_scope - judgement, location_data_made_anonymous - judgement, location_consent_given - judgement, location_consent_withdrawn - boolean, location_processing_within_necessary_extent_and_duration_for_value_added_service - judgement, location_processing_temporarily_refused - boolean]).
query_key_types(direct_marketing_communication, [marketing_communication_for_direct_marketing - judgement, marketing_subscriber_is_natural_person - boolean, marketing_communication_means - marketing_communication_means, marketing_prior_consent_given - judgement, marketing_contact_details_obtained_from_customer_in_sale - judgement, marketing_sender_obtained_the_contact_details - boolean, marketing_own_similar_products_or_services - judgement, marketing_objection_offered_at_collection - judgement, marketing_objection_offered_in_each_message - judgement, marketing_customer_refused_or_objected - boolean]).
query_key_types(direct_marketing_email_practice, [marketing_communication_for_direct_marketing - judgement, marketing_communication_means - marketing_communication_means, email_sender_identity_disguised_or_concealed - judgement, email_contravenes_electronic_commerce_directive_article_6 - judgement, email_valid_cessation_address_provided - judgement, email_encourages_visiting_contravening_websites - judgement]).

type_domain(judgement, [true, false]).
type_domain(boolean, [true, false]).
type_domain(traffic_processing_purpose, [transmission_of_communication, subscriber_billing_or_interconnection_payments, marketing_or_value_added_service, other_purpose]).
type_domain(marketing_communication_means, [automatic_calling_machine, fax, electronic_mail, other_means]).

article_13_means(automatic_calling_machine, consent_only, cite(eu_dir_2002_58_art_13_1)).
article_13_means(fax, consent_only, cite(eu_dir_2002_58_art_13_1)).
article_13_means(electronic_mail, consent_or_customer_exception, cite(eu_dir_2002_58_art_13_2)).
article_13_means(other_means, national_choice, cite(eu_dir_2002_58_art_13_3)).

result_citations(personal_data_breach_notification, authority_and_individual_notification_due, [cite(eu_dir_2002_58_art_4_3)]).
result_citations(personal_data_breach_notification, authority_notification_due, [cite(eu_dir_2002_58_art_4_3)]).
result_citations(personal_data_breach_notification, not_applicable, [cite(eu_dir_2002_58_art_4_3)]).
result_citations(traffic_data_processing, permitted, [cite(eu_dir_2002_58_art_6_1), cite(eu_dir_2002_58_art_6_2), cite(eu_dir_2002_58_art_6_3)]).
result_citations(traffic_data_processing, not_permitted, [cite(eu_dir_2002_58_art_6_1)]).
result_citations(traffic_data_processing, not_applicable, [cite(eu_dir_2002_58_art_6_1)]).
result_citations(location_data_processing, permitted, [cite(eu_dir_2002_58_art_9_1)]).
result_citations(location_data_processing, not_permitted, [cite(eu_dir_2002_58_art_9_1)]).
result_citations(location_data_processing, not_applicable, [cite(eu_dir_2002_58_art_9_1)]).
result_citations(direct_marketing_communication, not_applicable, [cite(eu_dir_2002_58_art_13_1)]).
result_citations(direct_marketing_communication, national_law_decides, [cite(eu_dir_2002_58_art_13_3), cite(eu_dir_2002_58_art_13_5)]).
result_citations(direct_marketing_communication, sending_permitted, [cite(eu_dir_2002_58_art_13_1), cite(eu_dir_2002_58_art_13_2)]).
result_citations(direct_marketing_communication, sending_not_permitted, [cite(eu_dir_2002_58_art_13_1), cite(eu_dir_2002_58_art_13_2)]).
result_citations(direct_marketing_email_practice, practice_prohibited, [cite(eu_dir_2002_58_art_13_4)]).
result_citations(direct_marketing_email_practice, practice_not_prohibited, [cite(eu_dir_2002_58_art_13_4)]).
result_citations(direct_marketing_email_practice, not_applicable, [cite(eu_dir_2002_58_art_13_4)]).

referral_citation(personal_data_breach_notification, breach_provider_of_publicly_available_service, cite(eu_dir_2002_58_art_4_3)).
referral_citation(personal_data_breach_notification, personal_data_breach_occurred, cite(eu_dir_2002_58_art_2_i)).
referral_citation(personal_data_breach_notification, breach_likely_to_adversely_affect_subscriber_or_individual, cite(eu_dir_2002_58_art_4_3)).
referral_citation(traffic_data_processing, traffic_provider_of_public_network_or_service, cite(eu_dir_2002_58_art_6_1)).
referral_citation(traffic_data_processing, traffic_data_relating_to_subscribers_or_users, cite(eu_dir_2002_58_art_2_b)).
referral_citation(traffic_data_processing, traffic_data_still_needed_for_transmission, cite(eu_dir_2002_58_art_6_1)).
referral_citation(traffic_data_processing, traffic_data_necessary_for_billing_or_interconnection, cite(eu_dir_2002_58_art_6_2)).
referral_citation(traffic_data_processing, traffic_billing_challenge_or_payment_period_running, cite(eu_dir_2002_58_art_6_2)).
referral_citation(traffic_data_processing, traffic_marketing_provider_of_publicly_available_service, cite(eu_dir_2002_58_art_6_3)).
referral_citation(traffic_data_processing, traffic_marketing_prior_consent_given, cite(eu_dir_2002_58_art_2_f)).
referral_citation(traffic_data_processing, traffic_marketing_processing_within_necessary_extent_and_duration, cite(eu_dir_2002_58_art_6_3)).
referral_citation(location_data_processing, location_data_other_than_traffic_data_in_scope, cite(eu_dir_2002_58_art_2_c)).
referral_citation(location_data_processing, location_data_made_anonymous, cite(eu_dir_2002_58_art_9_1)).
referral_citation(location_data_processing, location_consent_given, cite(eu_dir_2002_58_art_2_f)).
referral_citation(location_data_processing, location_processing_within_necessary_extent_and_duration_for_value_added_service, cite(eu_dir_2002_58_art_9_1)).
referral_citation(direct_marketing_communication, marketing_communication_for_direct_marketing, cite(eu_dir_2002_58_art_13_1)).
referral_citation(direct_marketing_communication, marketing_prior_consent_given, cite(eu_dir_2002_58_art_2_f)).
referral_citation(direct_marketing_communication, marketing_contact_details_obtained_from_customer_in_sale, cite(eu_dir_2002_58_art_13_2)).
referral_citation(direct_marketing_communication, marketing_own_similar_products_or_services, cite(eu_dir_2002_58_art_13_2)).
referral_citation(direct_marketing_communication, marketing_objection_offered_at_collection, cite(eu_dir_2002_58_art_13_2)).
referral_citation(direct_marketing_communication, marketing_objection_offered_in_each_message, cite(eu_dir_2002_58_art_13_2)).
referral_citation(direct_marketing_email_practice, marketing_communication_for_direct_marketing, cite(eu_dir_2002_58_art_13_4)).
referral_citation(direct_marketing_email_practice, email_sender_identity_disguised_or_concealed, cite(eu_dir_2002_58_art_13_4)).
referral_citation(direct_marketing_email_practice, email_contravenes_electronic_commerce_directive_article_6, cite(eu_dir_2002_58_art_13_4)).
referral_citation(direct_marketing_email_practice, email_valid_cessation_address_provided, cite(eu_dir_2002_58_art_13_4)).
referral_citation(direct_marketing_email_practice, email_encourages_visiting_contravening_websites, cite(eu_dir_2002_58_art_13_4)).

query_outcome(personal_data_breach_notification, Values, Result) :-
    breach_outcome(Values, Result).
query_outcome(traffic_data_processing, Values, Result) :-
    traffic_outcome(Values, Result).
query_outcome(location_data_processing, Values, Result) :-
    location_outcome(Values, Result).
query_outcome(direct_marketing_communication, Values, Result) :-
    marketing_outcome(Values, Result).
query_outcome(direct_marketing_email_practice, Values, Result) :-
    email_practice_outcome(Values, Result).

breach_outcome([false, _, _, _, _], not_applicable) :-
    implements(eu_dir_2002_58_art_4_3).
breach_outcome([true, false, _, _, _], not_applicable) :-
    implements(eu_dir_2002_58_art_2_i).
breach_outcome([true, true, true, _, _], authority_and_individual_notification_due) :-
    implements(eu_dir_2002_58_art_4_3).
breach_outcome([true, true, false, true, false], authority_and_individual_notification_due) :-
    implements(eu_dir_2002_58_art_4_3).
breach_outcome([true, true, false, true, true], authority_notification_due) :-
    implements(eu_dir_2002_58_art_4_3).
breach_outcome([true, true, false, false, _], authority_notification_due) :-
    implements(eu_dir_2002_58_art_4_3).

traffic_outcome([false|_], not_applicable) :-
    implements(eu_dir_2002_58_art_6_1).
traffic_outcome([true, false|_], not_applicable) :-
    implements(eu_dir_2002_58_art_2_b).
traffic_outcome([true, true, transmission_of_communication, true|_], permitted) :-
    implements(eu_dir_2002_58_art_6_1).
traffic_outcome([true, true, transmission_of_communication, false|_], not_permitted) :-
    implements(eu_dir_2002_58_art_6_1).
traffic_outcome([true, true, subscriber_billing_or_interconnection_payments, _, true, true|_], permitted) :-
    implements(eu_dir_2002_58_art_6_2).
traffic_outcome([true, true, subscriber_billing_or_interconnection_payments, _, false, _|_], not_permitted) :-
    implements(eu_dir_2002_58_art_6_2).
traffic_outcome([true, true, subscriber_billing_or_interconnection_payments, _, true, false|_], not_permitted) :-
    implements(eu_dir_2002_58_art_6_2).
traffic_outcome([true, true, marketing_or_value_added_service, _, _, _, true, true, false, true], permitted) :-
    implements(eu_dir_2002_58_art_6_3),
    implements(eu_dir_2002_58_art_2_g),
    implements(eu_dir_2002_58_art_2_f).
traffic_outcome([true, true, marketing_or_value_added_service, _, _, _, false, _, _, _], not_permitted) :-
    implements(eu_dir_2002_58_art_6_3).
traffic_outcome([true, true, marketing_or_value_added_service, _, _, _, true, false, _, _], not_permitted) :-
    implements(eu_dir_2002_58_art_2_f).
traffic_outcome([true, true, marketing_or_value_added_service, _, _, _, true, true, true, _], not_permitted) :-
    implements(eu_dir_2002_58_art_6_3).
traffic_outcome([true, true, marketing_or_value_added_service, _, _, _, true, true, false, false], not_permitted) :-
    implements(eu_dir_2002_58_art_6_3).
traffic_outcome([true, true, other_purpose|_], not_permitted) :-
    implements(eu_dir_2002_58_art_6_1).

location_outcome([false|_], not_applicable) :-
    implements(eu_dir_2002_58_art_2_c).
location_outcome([true, true|_], permitted) :-
    implements(eu_dir_2002_58_art_9_1).
location_outcome([true, false, true, false, true, false], permitted) :-
    implements(eu_dir_2002_58_art_9_1),
    implements(eu_dir_2002_58_art_2_f).
location_outcome([true, false, false|_], not_permitted) :-
    implements(eu_dir_2002_58_art_2_f).
location_outcome([true, false, true, true|_], not_permitted) :-
    implements(eu_dir_2002_58_art_9_1).
location_outcome([true, false, true, false, false, _], not_permitted) :-
    implements(eu_dir_2002_58_art_9_1).
location_outcome([true, false, true, false, true, true], not_permitted) :-
    implements(eu_dir_2002_58_art_9_2).

named_in_article_13_1(Means) :-
    implements(eu_dir_2002_58_art_13_1),
    article_13_means(Means, Class, _),
    dif(Class, national_choice).

marketing_outcome([false|_], not_applicable) :-
    implements(eu_dir_2002_58_art_13_1).
marketing_outcome([true, _, other_means|_], national_law_decides) :-
    implements(eu_dir_2002_58_art_13_3).
marketing_outcome([true, false, Means|_], national_law_decides) :-
    implements(eu_dir_2002_58_art_13_5),
    named_in_article_13_1(Means).
marketing_outcome([true, true, Means, true|_], sending_permitted) :-
    implements(eu_dir_2002_58_art_2_f),
    named_in_article_13_1(Means).
marketing_outcome([true, true, Means, false|_], sending_not_permitted) :-
    implements(eu_dir_2002_58_art_13_1),
    article_13_means(Means, consent_only, _).
marketing_outcome([true, true, electronic_mail, false, true, true, true, true, true, false], sending_permitted) :-
    implements(eu_dir_2002_58_art_13_2),
    implements(eu_dir_2002_58_art_2_h).
marketing_outcome([true, true, electronic_mail, false, false|_], sending_not_permitted) :-
    implements(eu_dir_2002_58_art_13_2).
marketing_outcome([true, true, electronic_mail, false, true, false|_], sending_not_permitted) :-
    implements(eu_dir_2002_58_art_13_2).
marketing_outcome([true, true, electronic_mail, false, true, true, false|_], sending_not_permitted) :-
    implements(eu_dir_2002_58_art_13_2).
marketing_outcome([true, true, electronic_mail, false, true, true, true, false|_], sending_not_permitted) :-
    implements(eu_dir_2002_58_art_13_2).
marketing_outcome([true, true, electronic_mail, false, true, true, true, true, false, _], sending_not_permitted) :-
    implements(eu_dir_2002_58_art_13_2).
marketing_outcome([true, true, electronic_mail, false, true, true, true, true, true, true], sending_not_permitted) :-
    implements(eu_dir_2002_58_art_13_2).

email_practice_outcome([false|_], not_applicable) :-
    implements(eu_dir_2002_58_art_13_4).
email_practice_outcome([true, Means|_], not_applicable) :-
    implements(eu_dir_2002_58_art_2_h),
    dif(Means, electronic_mail).
email_practice_outcome([true, electronic_mail, true|_], practice_prohibited) :-
    implements(eu_dir_2002_58_art_13_4).
email_practice_outcome([true, electronic_mail, false, true|_], practice_prohibited) :-
    implements(eu_dir_2002_58_art_13_4).
email_practice_outcome([true, electronic_mail, false, false, false, _], practice_prohibited) :-
    implements(eu_dir_2002_58_art_13_4).
email_practice_outcome([true, electronic_mail, false, false, true, true], practice_prohibited) :-
    implements(eu_dir_2002_58_art_13_4).
email_practice_outcome([true, electronic_mail, false, false, true, false], practice_not_prohibited) :-
    implements(eu_dir_2002_58_art_13_4).

determination(_Query, Profile, input_problems([Problem|Problems]), []) :-
    eprivacy_breach_traffic_location_marketing_input_problems(Profile, [Problem|Problems]).
determination(Query, Profile, Result, Citations) :-
    eprivacy_breach_traffic_location_marketing_input_problems(Profile, []),
    query_key_types(Query, KeyTypes),
    key_entries(KeyTypes, Profile, Entries, Domains),
    answer_table(Query, Domains, Table),
    pairs_values(Table, Answers),
    sort(Answers, DistinctAnswers),
    settled_or_open(DistinctAnswers, Query, Entries, Table, Result, Citations).

key_entries([], _, [], []).
key_entries([Key - Type|KeyTypes], Profile, [Key - State|Entries], [Domain|Domains]) :-
    key_state(Profile, Key, State),
    state_domain(State, Type, Domain),
    key_entries(KeyTypes, Profile, Entries, Domains).

key_state(Profile, Key, absent) :-
    profile_lacks(Profile, Key).
key_state(Profile, Key, State) :-
    profile_has(Profile, Key),
    profile_get(Profile, Key, Value),
    present_state(Value, State).

present_state(unsure, unsure).
present_state(Value, given(Value)) :-
    dif(Value, unsure).

state_domain(absent, Type, Domain) :-
    type_domain(Type, Domain).
state_domain(unsure, _, [true, false]).
state_domain(given(Value), _, [Value]).

answer_table(Query, Domains, Table) :-
    length(Domains, KeyCount),
    findall(Values - Answer, (length(Values, KeyCount), maplist(member, Values, Domains), query_outcome(Query, Values, Answer)), Table).

settled_or_open([Answer], Query, _, _, Answer, Citations) :-
    result_citations(Query, Answer, Citations).
settled_or_open([_, _|_], Query, Entries, Table, Result, []) :-
    first_mattering_key(Entries, absent, 0, Table, Found),
    open_result(Found, Query, Entries, Table, Result).

open_result(found(Key), _, _, _, indeterminate([Key])).
open_result(none, Query, Entries, Table, needs_legal_review(open_textured(Key, Citation), [inputs_relied_on(Pairs)])) :-
    first_mattering_key(Entries, unsure, 0, Table, found(Key)),
    referral_citation(Query, Key, Citation),
    present_pairs(Entries, Pairs).

first_mattering_key([], _, _, _, none).
first_mattering_key([Entry|Entries], Kind, Index, Table, Found) :-
    candidate_t(Entry, Kind, Index, Table, Truth),
    next_mattering_key(Truth, Entry, Entries, Kind, Index, Table, Found).

next_mattering_key(true, Key - _, _, _, _, _, found(Key)).
next_mattering_key(false, _, Entries, Kind, Index, Table, Found) :-
    succ(Index, NextIndex),
    first_mattering_key(Entries, Kind, NextIndex, Table, Found).

candidate_t(_ - State, Kind, Index, Table, Truth) :-
    state_kind_t(State, Kind, IsKind),
    candidate_matters_t(IsKind, Index, Table, Truth).

state_kind_t(absent, absent, true).
state_kind_t(absent, unsure, false).
state_kind_t(unsure, unsure, true).
state_kind_t(unsure, absent, false).
state_kind_t(given(_), _, false).

candidate_matters_t(false, _, _, false).
candidate_matters_t(true, Index, Table, Truth) :-
    key_matters_t(Index, Table, Truth).

key_matters_t(Index, Table, Truth) :-
    maplist(drop_position(Index), Table, Remainders),
    sort(Remainders, SortedRemainders),
    adjacent_conflict_t(SortedRemainders, Truth).

drop_position(Index, Values - Answer, Remainder - Answer) :-
    nth0(Index, Values, _, Remainder).

adjacent_conflict_t([], false).
adjacent_conflict_t([_], false).
adjacent_conflict_t([Remainder - _, Remainder - _|_], true).
adjacent_conflict_t([FirstRemainder - _, SecondRemainder - SecondAnswer|Others], Truth) :-
    dif(FirstRemainder, SecondRemainder),
    adjacent_conflict_t([SecondRemainder - SecondAnswer|Others], Truth).

present_pairs([], []).
present_pairs([Key - given(Value)|Entries], [Key - Value|Pairs]) :-
    present_pairs(Entries, Pairs).
present_pairs([Key - unsure|Entries], [Key - unsure|Pairs]) :-
    present_pairs(Entries, Pairs).
present_pairs([_ - absent|Entries], Pairs) :-
    present_pairs(Entries, Pairs).

personal_data_breach_notification_status(Profile, Result, Citations) :-
    determination(personal_data_breach_notification, Profile, Result, Citations).

traffic_data_processing_status(Profile, Result, Citations) :-
    determination(traffic_data_processing, Profile, Result, Citations).

location_data_processing_status(Profile, Result, Citations) :-
    determination(location_data_processing, Profile, Result, Citations).

direct_marketing_communication_status(Profile, Result, Citations) :-
    determination(direct_marketing_communication, Profile, Result, Citations).

direct_marketing_email_practice_status(Profile, Result, Citations) :-
    determination(direct_marketing_email_practice, Profile, Result, Citations).

eprivacy_breach_traffic_location_marketing_checklist(Profile, [item(personal_data_breach_notification, BreachResult, BreachCitations), item(traffic_data_processing, TrafficResult, TrafficCitations), item(location_data_processing, LocationResult, LocationCitations), item(direct_marketing_communication, MarketingResult, MarketingCitations), item(direct_marketing_email_practice, PracticeResult, PracticeCitations)]) :-
    personal_data_breach_notification_status(Profile, BreachResult, BreachCitations),
    traffic_data_processing_status(Profile, TrafficResult, TrafficCitations),
    location_data_processing_status(Profile, LocationResult, LocationCitations),
    direct_marketing_communication_status(Profile, MarketingResult, MarketingCitations),
    direct_marketing_email_practice_status(Profile, PracticeResult, PracticeCitations).

row_class(indeterminate(_), open).
row_class(needs_legal_review(_, _), open).
row_class(input_problems(_), problems).
row_class(authority_and_individual_notification_due, permissive).
row_class(authority_notification_due, permissive).
row_class(permitted, permissive).
row_class(sending_permitted, permissive).
row_class(practice_not_prohibited, permissive).
row_class(not_permitted, restrictive).
row_class(sending_not_permitted, restrictive).
row_class(practice_prohibited, restrictive).
row_class(national_law_decides, national).
row_class(not_applicable, inapplicable).

item_class(item(_, Result, _), Class) :-
    row_class(Result, Class).

decide_eprivacy_breach_traffic_location_marketing(Profile, eprivacy_breach_traffic_location_marketing_verdict(input_problems([Problem|Problems]), [])) :-
    eprivacy_breach_traffic_location_marketing_input_problems(Profile, [Problem|Problems]).
decide_eprivacy_breach_traffic_location_marketing(Profile, eprivacy_breach_traffic_location_marketing_verdict(Status, Citations)) :-
    eprivacy_breach_traffic_location_marketing_input_problems(Profile, []),
    eprivacy_breach_traffic_location_marketing_checklist(Profile, Items),
    maplist(item_class, Items, Classes),
    memberd_t(open, Classes, Open),
    memberd_t(restrictive, Classes, Restrictive),
    memberd_t(national, Classes, National),
    memberd_t(permissive, Classes, Permissive),
    verdict_from(Open, Restrictive, National, Permissive, Items, Status, Citations).

verdict_from(true, _, _, _, Items, Status, []) :-
    first_open_row(Items, Status).
verdict_from(false, true, _, _, Items, ineligible, Citations) :-
    final_citations(Items, Citations).
verdict_from(false, false, true, _, Items, national_law_decides, Citations) :-
    final_citations(Items, Citations).
verdict_from(false, false, false, true, Items, eligible, Citations) :-
    final_citations(Items, Citations).
verdict_from(false, false, false, false, Items, not_applicable, Citations) :-
    final_citations(Items, Citations).

first_open_row([item(_, Result, _)|Items], Status) :-
    row_class(Result, Class),
    first_open_from(Class, Result, Items, Status).

first_open_from(open, Result, _, Result).
first_open_from(Class, _, Items, Status) :-
    dif(Class, open),
    first_open_row(Items, Status).

final_citations(Items, Citations) :-
    findall(Citation, (member(item(_, _, RowCitations), Items), member(Citation, RowCitations)), AllCitations),
    sort(AllCitations, Citations).

eprivacy_breach_traffic_location_marketing_status(Profile, Status) :-
    decide_eprivacy_breach_traffic_location_marketing(Profile, eprivacy_breach_traffic_location_marketing_verdict(Status, _Citations)).

eprivacy_breach_traffic_location_marketing_decision_resolvable(Profile) :-
    decide_eprivacy_breach_traffic_location_marketing(Profile, _Verdict).

test(breach_likely_adverse_without_protection_notifies_both) :-
    findall(Result - Citations, personal_data_breach_notification_status([attribute(breach_provider_of_publicly_available_service, true), attribute(personal_data_breach_occurred, true), attribute(authority_required_individual_notification, false), attribute(breach_likely_to_adversely_affect_subscriber_or_individual, true), attribute(protection_measures_demonstrated_to_authority, false)], Result, Citations), Answers),
    Answers == [authority_and_individual_notification_due - [cite(eu_dir_2002_58_art_4_3)]].
test(breach_demonstrated_protection_notifies_authority_only) :-
    personal_data_breach_notification_status([attribute(breach_provider_of_publicly_available_service, true), attribute(personal_data_breach_occurred, true), attribute(authority_required_individual_notification, false), attribute(breach_likely_to_adversely_affect_subscriber_or_individual, true), attribute(protection_measures_demonstrated_to_authority, true)], authority_notification_due, [cite(eu_dir_2002_58_art_4_3)]).
test(breach_not_a_provider_is_settled_not_applicable) :-
    personal_data_breach_notification_status([attribute(breach_provider_of_publicly_available_service, false)], not_applicable, [cite(eu_dir_2002_58_art_4_3)]).
test(breach_authority_requirement_settles_with_absent_keys) :-
    personal_data_breach_notification_status([attribute(breach_provider_of_publicly_available_service, true), attribute(personal_data_breach_occurred, true), attribute(authority_required_individual_notification, true)], authority_and_individual_notification_due, [cite(eu_dir_2002_58_art_4_3)]).
test(breach_unsure_likelihood_settled_by_authority_requirement) :-
    personal_data_breach_notification_status([attribute(breach_provider_of_publicly_available_service, true), attribute(personal_data_breach_occurred, true), attribute(authority_required_individual_notification, true), attribute(breach_likely_to_adversely_affect_subscriber_or_individual, unsure)], authority_and_individual_notification_due, _).
test(breach_empty_profile_names_the_first_key) :-
    findall(Result - Citations, personal_data_breach_notification_status([], Result, Citations), Answers),
    Answers == [indeterminate([breach_provider_of_publicly_available_service]) - []].
test(breach_names_the_likelihood_when_it_matters) :-
    personal_data_breach_notification_status([attribute(breach_provider_of_publicly_available_service, true), attribute(personal_data_breach_occurred, true), attribute(authority_required_individual_notification, false)], indeterminate([breach_likely_to_adversely_affect_subscriber_or_individual]), []).
test(breach_missing_key_before_unsure_judgement) :-
    personal_data_breach_notification_status([attribute(breach_provider_of_publicly_available_service, unsure)], indeterminate([personal_data_breach_occurred]), []).
test(breach_unsure_provider_refers) :-
    personal_data_breach_notification_status([attribute(breach_provider_of_publicly_available_service, unsure), attribute(personal_data_breach_occurred, true), attribute(authority_required_individual_notification, true)], Result, Citations),
    Result == needs_legal_review(open_textured(breach_provider_of_publicly_available_service, cite(eu_dir_2002_58_art_4_3)), [inputs_relied_on([breach_provider_of_publicly_available_service - unsure, personal_data_breach_occurred - true, authority_required_individual_notification - true])]),
    Citations == [].
test(an_unknown_key_is_an_input_problem) :-
    personal_data_breach_notification_status([attribute(foo, true)], input_problems([unknown_key(foo)]), []).
test(a_non_list_profile_is_an_input_problem) :-
    traffic_data_processing_status(nothing, input_problems([wrong_type(profile)]), []).
test(an_unsure_boolean_is_wrong_type) :-
    location_data_processing_status([attribute(location_consent_withdrawn, unsure)], input_problems([wrong_type(location_consent_withdrawn)]), []).
test(traffic_other_purpose_not_permitted) :-
    traffic_data_processing_status([attribute(traffic_provider_of_public_network_or_service, true), attribute(traffic_data_relating_to_subscribers_or_users, true), attribute(traffic_processing_purpose, other_purpose)], not_permitted, [cite(eu_dir_2002_58_art_6_1)]).
test(traffic_marketing_with_consent_permitted) :-
    traffic_data_processing_status([attribute(traffic_provider_of_public_network_or_service, true), attribute(traffic_data_relating_to_subscribers_or_users, true), attribute(traffic_processing_purpose, marketing_or_value_added_service), attribute(traffic_marketing_provider_of_publicly_available_service, true), attribute(traffic_marketing_prior_consent_given, true), attribute(traffic_marketing_consent_withdrawn, false), attribute(traffic_marketing_processing_within_necessary_extent_and_duration, true)], permitted, [cite(eu_dir_2002_58_art_6_1), cite(eu_dir_2002_58_art_6_2), cite(eu_dir_2002_58_art_6_3)]).
test(traffic_billing_period_over_not_permitted) :-
    traffic_data_processing_status([attribute(traffic_provider_of_public_network_or_service, true), attribute(traffic_data_relating_to_subscribers_or_users, true), attribute(traffic_processing_purpose, subscriber_billing_or_interconnection_payments), attribute(traffic_data_necessary_for_billing_or_interconnection, true), attribute(traffic_billing_challenge_or_payment_period_running, false)], not_permitted, [cite(eu_dir_2002_58_art_6_1)]).
test(traffic_absent_purpose_is_named) :-
    traffic_data_processing_status([attribute(traffic_provider_of_public_network_or_service, true), attribute(traffic_data_relating_to_subscribers_or_users, true)], indeterminate([traffic_processing_purpose]), []).
test(traffic_empty_profile_has_one_answer) :-
    findall(Result - Citations, traffic_data_processing_status([], Result, Citations), Answers),
    Answers == [indeterminate([traffic_provider_of_public_network_or_service]) - []].
test(location_anonymous_permitted) :-
    location_data_processing_status([attribute(location_data_other_than_traffic_data_in_scope, true), attribute(location_data_made_anonymous, true)], permitted, [cite(eu_dir_2002_58_art_9_1)]).
test(location_both_ways_settle_permitted) :-
    location_data_processing_status([attribute(location_data_other_than_traffic_data_in_scope, true), attribute(location_consent_given, true), attribute(location_consent_withdrawn, false), attribute(location_processing_within_necessary_extent_and_duration_for_value_added_service, true), attribute(location_processing_temporarily_refused, false)], permitted, [cite(eu_dir_2002_58_art_9_1)]).
test(location_refused_not_permitted) :-
    location_data_processing_status([attribute(location_data_other_than_traffic_data_in_scope, true), attribute(location_data_made_anonymous, false), attribute(location_consent_given, true), attribute(location_consent_withdrawn, false), attribute(location_processing_within_necessary_extent_and_duration_for_value_added_service, true), attribute(location_processing_temporarily_refused, true)], not_permitted, [cite(eu_dir_2002_58_art_9_1)]).
test(location_absent_scope_is_named) :-
    location_data_processing_status([attribute(location_data_made_anonymous, true)], indeterminate([location_data_other_than_traffic_data_in_scope]), []).
test(location_unsure_scope_refers) :-
    location_data_processing_status([attribute(location_data_other_than_traffic_data_in_scope, unsure), attribute(location_data_made_anonymous, true)], Result, []),
    Result == needs_legal_review(open_textured(location_data_other_than_traffic_data_in_scope, cite(eu_dir_2002_58_art_2_c)), [inputs_relied_on([location_data_other_than_traffic_data_in_scope - unsure, location_data_made_anonymous - true])]).
test(marketing_other_means_national_law_decides) :-
    direct_marketing_communication_status([attribute(marketing_communication_for_direct_marketing, true), attribute(marketing_communication_means, other_means)], national_law_decides, [cite(eu_dir_2002_58_art_13_3), cite(eu_dir_2002_58_art_13_5)]).
test(marketing_legal_person_national_law_decides) :-
    direct_marketing_communication_status([attribute(marketing_communication_for_direct_marketing, true), attribute(marketing_subscriber_is_natural_person, false), attribute(marketing_communication_means, fax)], national_law_decides, _).
test(marketing_customer_exception_permits_email) :-
    direct_marketing_communication_status([attribute(marketing_communication_for_direct_marketing, true), attribute(marketing_subscriber_is_natural_person, true), attribute(marketing_communication_means, electronic_mail), attribute(marketing_prior_consent_given, false), attribute(marketing_contact_details_obtained_from_customer_in_sale, true), attribute(marketing_sender_obtained_the_contact_details, true), attribute(marketing_own_similar_products_or_services, true), attribute(marketing_objection_offered_at_collection, true), attribute(marketing_objection_offered_in_each_message, true), attribute(marketing_customer_refused_or_objected, false)], sending_permitted, [cite(eu_dir_2002_58_art_13_1), cite(eu_dir_2002_58_art_13_2)]).
test(marketing_fax_without_consent_not_permitted) :-
    direct_marketing_communication_status([attribute(marketing_communication_for_direct_marketing, true), attribute(marketing_subscriber_is_natural_person, true), attribute(marketing_communication_means, fax), attribute(marketing_prior_consent_given, false)], sending_not_permitted, [cite(eu_dir_2002_58_art_13_1), cite(eu_dir_2002_58_art_13_2)]).
test(marketing_absent_consent_is_named) :-
    direct_marketing_communication_status([attribute(marketing_communication_for_direct_marketing, true), attribute(marketing_subscriber_is_natural_person, true), attribute(marketing_communication_means, electronic_mail)], indeterminate([marketing_prior_consent_given]), []).
test(email_disguised_sender_prohibited) :-
    direct_marketing_email_practice_status([attribute(marketing_communication_for_direct_marketing, true), attribute(marketing_communication_means, electronic_mail), attribute(email_sender_identity_disguised_or_concealed, true)], practice_prohibited, [cite(eu_dir_2002_58_art_13_4)]).
test(email_practice_fax_not_applicable) :-
    direct_marketing_email_practice_status([attribute(marketing_communication_means, fax)], not_applicable, [cite(eu_dir_2002_58_art_13_4)]).
test(email_clean_practice_not_prohibited) :-
    direct_marketing_email_practice_status([attribute(marketing_communication_for_direct_marketing, true), attribute(marketing_communication_means, electronic_mail), attribute(email_sender_identity_disguised_or_concealed, false), attribute(email_contravenes_electronic_commerce_directive_article_6, false), attribute(email_valid_cessation_address_provided, true), attribute(email_encourages_visiting_contravening_websites, false)], practice_not_prohibited, [cite(eu_dir_2002_58_art_13_4)]).
test(facade_everything_out_of_scope_is_not_applicable) :-
    eprivacy_breach_traffic_location_marketing_status([attribute(breach_provider_of_publicly_available_service, false), attribute(traffic_provider_of_public_network_or_service, false), attribute(location_data_other_than_traffic_data_in_scope, false), attribute(marketing_communication_for_direct_marketing, false)], not_applicable).
test(facade_empty_profile_is_open) :-
    findall(Status, eprivacy_breach_traffic_location_marketing_status([], Status), Statuses),
    Statuses == [indeterminate([breach_provider_of_publicly_available_service])].

test(breach_likely_adverse_without_protection_is_not_authority_only, fail) :-
    personal_data_breach_notification_status([attribute(breach_provider_of_publicly_available_service, true), attribute(personal_data_breach_occurred, true), attribute(authority_required_individual_notification, false), attribute(breach_likely_to_adversely_affect_subscriber_or_individual, true), attribute(protection_measures_demonstrated_to_authority, false)], authority_notification_due, _).
test(traffic_other_purpose_is_not_permitted_answer_only, fail) :-
    traffic_data_processing_status([attribute(traffic_provider_of_public_network_or_service, true), attribute(traffic_data_relating_to_subscribers_or_users, true), attribute(traffic_processing_purpose, other_purpose)], permitted, _).
test(marketing_fax_without_consent_is_not_permitted_only, fail) :-
    direct_marketing_communication_status([attribute(marketing_communication_for_direct_marketing, true), attribute(marketing_subscriber_is_natural_person, true), attribute(marketing_communication_means, fax), attribute(marketing_prior_consent_given, false)], sending_permitted, _).
