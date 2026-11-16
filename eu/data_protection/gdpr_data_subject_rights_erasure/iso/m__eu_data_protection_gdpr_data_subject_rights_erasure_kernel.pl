% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_erasure_kernel, [gdpr_data_subject_rights_erasure_input_problems/2, gdpr_data_subject_rights_erasure_request_type_route/2, gdpr_data_subject_rights_erasure_required_limb/3, gdpr_data_subject_rights_erasure_defeater_limb/3, gdpr_data_subject_rights_erasure_outside_fact_limb/4, gdpr_data_subject_rights_erasure_negated_limb/2, gdpr_data_subject_rights_erasure_conjunction/2, gdpr_data_subject_rights_erasure_disjunction/2, gdpr_data_subject_rights_erasure_first_met/2, gdpr_data_subject_rights_erasure_open_union/4, gdpr_data_subject_rights_erasure_keys_in_contract_order/2, gdpr_data_subject_rights_erasure_present_pairs/3]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(formalize_lib, [profile_get/3, profile_lacks/2]).

gdpr_data_subject_rights_erasure_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    Keys = [request_type, objection_ground_claimed, request_received_on, extension_claimed, controller_demonstrates_unable_to_identify_data_subject, identity_confirmed, personal_data_inaccurate, consent_is_the_basis_of_processing, consent_withdrawn, other_legal_ground_for_processing_exists, objection_under_art21_1_made, objection_under_art21_2_made, collected_in_relation_to_information_society_services_offer, accuracy_contested_by_data_subject, data_subject_opposes_erasure, data_required_by_data_subject_for_legal_claims, verification_of_overriding_grounds_pending, personal_data_provided_by_data_subject, processing_based_on_consent_or_contract, processing_carried_out_by_automated_means, processing_based_on_art6_1_e_or_f, processing_for_direct_marketing, processing_for_research_or_statistics_pursuant_to_art89_1, data_subject_gave_explicit_consent, decision_based_on_special_categories, special_category_condition_and_safeguards_met_for_decision, personal_data_disclosed_to_recipients, data_subject_asks_who_the_recipients_are, extension_necessary_for_complexity_and_number, reasonable_doubts_about_identity, request_manifestly_unfounded_or_excessive, personal_data_incomplete_in_light_of_purposes, data_no_longer_necessary_for_purposes, overriding_legitimate_grounds_exist, personal_data_unlawfully_processed, processing_necessary_for_freedom_of_expression_and_information, processing_necessary_for_public_task_or_official_authority, processing_necessary_for_public_health_in_accordance_with_art9_2_h_and_i, processing_for_archiving_research_or_statistics_in_accordance_with_art89_1, erasure_would_render_impossible_or_seriously_impair_processing_objectives, processing_necessary_for_legal_claims, controller_no_longer_needs_data_for_processing_purposes, transmission_would_adversely_affect_rights_and_freedoms_of_others, objection_grounds_relate_to_particular_situation, controller_demonstrates_compelling_legitimate_grounds, decision_based_solely_on_automated_processing, decision_produces_legal_or_similarly_significant_effects, decision_necessary_for_contract_with_data_subject, recipient_notification_impossible_or_disproportionate_effort, legislative_restriction_applies_to_the_right, erasure_required_by_union_or_member_state_law, processing_required_by_union_or_member_state_law, decision_authorised_by_union_or_member_state_law, public_holidays],
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(request_type, enum([access, rectification, erasure, restriction, portability, objection, automated_decision])).
key_type(objection_ground_claimed, enum([art21_1, art21_2, art21_6])).
key_type(request_received_on, date).
key_type(extension_claimed, boolean).
key_type(controller_demonstrates_unable_to_identify_data_subject, boolean).
key_type(identity_confirmed, boolean).
key_type(personal_data_inaccurate, boolean).
key_type(consent_is_the_basis_of_processing, boolean).
key_type(consent_withdrawn, boolean).
key_type(other_legal_ground_for_processing_exists, boolean).
key_type(objection_under_art21_1_made, boolean).
key_type(objection_under_art21_2_made, boolean).
key_type(collected_in_relation_to_information_society_services_offer, boolean).
key_type(accuracy_contested_by_data_subject, boolean).
key_type(data_subject_opposes_erasure, boolean).
key_type(data_required_by_data_subject_for_legal_claims, boolean).
key_type(verification_of_overriding_grounds_pending, boolean).
key_type(personal_data_provided_by_data_subject, boolean).
key_type(processing_based_on_consent_or_contract, boolean).
key_type(processing_carried_out_by_automated_means, boolean).
key_type(processing_based_on_art6_1_e_or_f, boolean).
key_type(processing_for_direct_marketing, boolean).
key_type(processing_for_research_or_statistics_pursuant_to_art89_1, boolean).
key_type(data_subject_gave_explicit_consent, boolean).
key_type(decision_based_on_special_categories, boolean).
key_type(special_category_condition_and_safeguards_met_for_decision, boolean).
key_type(personal_data_disclosed_to_recipients, boolean).
key_type(data_subject_asks_who_the_recipients_are, boolean).
key_type(extension_necessary_for_complexity_and_number, judgement).
key_type(reasonable_doubts_about_identity, judgement).
key_type(request_manifestly_unfounded_or_excessive, judgement).
key_type(personal_data_incomplete_in_light_of_purposes, judgement).
key_type(data_no_longer_necessary_for_purposes, judgement).
key_type(overriding_legitimate_grounds_exist, judgement).
key_type(personal_data_unlawfully_processed, judgement).
key_type(processing_necessary_for_freedom_of_expression_and_information, judgement).
key_type(processing_necessary_for_public_task_or_official_authority, judgement).
key_type(processing_necessary_for_public_health_in_accordance_with_art9_2_h_and_i, judgement).
key_type(processing_for_archiving_research_or_statistics_in_accordance_with_art89_1, judgement).
key_type(erasure_would_render_impossible_or_seriously_impair_processing_objectives, judgement).
key_type(processing_necessary_for_legal_claims, judgement).
key_type(controller_no_longer_needs_data_for_processing_purposes, judgement).
key_type(transmission_would_adversely_affect_rights_and_freedoms_of_others, judgement).
key_type(objection_grounds_relate_to_particular_situation, judgement).
key_type(controller_demonstrates_compelling_legitimate_grounds, judgement).
key_type(decision_based_solely_on_automated_processing, judgement).
key_type(decision_produces_legal_or_similarly_significant_effects, judgement).
key_type(decision_necessary_for_contract_with_data_subject, judgement).
key_type(recipient_notification_impossible_or_disproportionate_effort, judgement).
key_type(legislative_restriction_applies_to_the_right, outside_fact).
key_type(erasure_required_by_union_or_member_state_law, outside_fact).
key_type(processing_required_by_union_or_member_state_law, outside_fact).
key_type(decision_authorised_by_union_or_member_state_law, outside_fact).
key_type(public_holidays, public_holidays_fact).

attribute_list_t(Term, false) :-
    var(Term).
attribute_list_t(Term, true) :-
    Term == [].
attribute_list_t(Term, T) :-
    nonvar(Term),
    Term = [Element|Elements],
    attribute_t(Element, ElementIsAttribute),
    attribute_list_t(Elements, ElementsAreAttributes),
    truth_and(ElementIsAttribute, ElementsAreAttributes, T).
attribute_list_t(Term, false) :-
    nonvar(Term),
    Term \== [],
    Term \= [_|_].

attribute_t(Element, false) :-
    var(Element).
attribute_t(Element, T) :-
    nonvar(Element),
    Element = attribute(Key, _),
    term_variables(Key, Variables),
    no_variables_t(Variables, T).
attribute_t(Element, false) :-
    nonvar(Element),
    Element \= attribute(_, _).

no_variables_t([], true).
no_variables_t([_|_], false).

unknown_keys([], _, []).
unknown_keys([attribute(Key, _)|Elements], Known, Problems) :-
    memberd_t(Key, Known, IsKnown),
    name_unknown_key(IsKnown, Key, Known, Elements, Problems).

name_unknown_key(true, _, Known, Elements, Problems) :-
    unknown_keys(Elements, Known, Problems).
name_unknown_key(false, Key, Known, Elements, [unknown_key(Key)|Problems]) :-
    unknown_keys(Elements, [Key|Known], Problems).

key_problems([], _, Problems, Problems).
key_problems([Key|Keys], Profile, LaterProblems, Problems) :-
    key_type(Key, Type),
    key_occurrences(Profile, Key, Occurrences),
    key_problems(Keys, Profile, LaterProblems, KeyProblems),
    name_key_problem(Occurrences, Key, Type, Profile, KeyProblems, Problems).

key_occurrences([], _, none).
key_occurrences([attribute(ElementKey, _)|Elements], Key, Occurrences) :-
    ElementKey == Key,
    key_occurrences(Elements, Key, RestOccurrences),
    one_more_occurrence(RestOccurrences, Occurrences).
key_occurrences([attribute(ElementKey, _)|Elements], Key, Occurrences) :-
    ElementKey \== Key,
    key_occurrences(Elements, Key, Occurrences).

one_more_occurrence(none, one).
one_more_occurrence(one, many).
one_more_occurrence(many, many).

name_key_problem(none, _, _, _, Problems, Problems).
name_key_problem(many, Key, _, _, Problems, [duplicate_key(Key)|Problems]).
name_key_problem(one, Key, Type, Profile, KeyProblems, Problems) :-
    values_in_type_t(Profile, Key, Type, InType),
    name_wrong_type(InType, Key, KeyProblems, Problems).

name_wrong_type(true, _, Problems, Problems).
name_wrong_type(false, Key, Problems, [wrong_type(Key)|Problems]).

values_in_type_t([], _, _, true).
values_in_type_t([attribute(ElementKey, Value)|Elements], Key, Type, T) :-
    ElementKey == Key,
    value_in_type_t(Type, Value, ValueInType),
    values_in_type_t(Elements, Key, Type, RestInType),
    truth_and(ValueInType, RestInType, T).
values_in_type_t([attribute(ElementKey, _)|Elements], Key, Type, T) :-
    ElementKey \== Key,
    values_in_type_t(Elements, Key, Type, T).

value_in_type_t(Type, Value, T) :-
    term_variables(Value, Variables),
    ground_value_in_type_t(Variables, Type, Value, T).

ground_value_in_type_t([_|_], _, _, false).
ground_value_in_type_t([], Type, Value, T) :-
    in_type_t(Type, Value, T).

in_type_t(judgement, Value, T) :-
    in_type_t(one_of([boolean, enum([unsure])]), Value, T).
in_type_t(outside_fact, Value, T) :-
    in_type_t(attested(boolean), Value, T).
in_type_t(public_holidays_fact, Value, T) :-
    in_type_t(attested(list(date)), Value, T).
in_type_t(boolean, Value, T) :-
    memberd_t(Value, [true, false], T).
in_type_t(date, Value, T) :-
    calendar_date_t(Value, T).
in_type_t(enum(Values), Value, T) :-
    memberd_t(Value, Values, T).
in_type_t(one_of(Types), Value, T) :-
    in_some_type_t(Types, Value, T).
in_type_t(list(Type), Value, T) :-
    list_in_type_t(Value, Type, T).
in_type_t(attested(Type), Value, T) :-
    attested_t(Value, Type, T).

truth_and(true, T, T).
truth_and(false, _, false).

in_some_type_t([], _, false).
in_some_type_t([Type|Types], Value, T) :-
    in_type_t(Type, Value, InType),
    in_some_type_t(Types, Value, InAnother),
    truth_or(InType, InAnother, T).

truth_or(true, _, true).
truth_or(false, T, T).

list_in_type_t(Value, _, true) :-
    Value == [].
list_in_type_t([Element|Elements], Type, T) :-
    in_type_t(Type, Element, ElementInType),
    list_in_type_t(Elements, Type, ElementsInType),
    truth_and(ElementInType, ElementsInType, T).
list_in_type_t(Value, _, false) :-
    Value \== [],
    Value \= [_|_].

attested_t(attested(AttestedValue, Attestation), Type, T) :-
    attestation_t(Attestation, IsAttestation),
    attested_value_t(IsAttestation, Type, AttestedValue, T).
attested_t(Value, _, false) :-
    Value \= attested(_, _).

attestation_t(attestation(_, _, _, _), true).
attestation_t(Value, false) :-
    Value \= attestation(_, _, _, _).

attested_value_t(false, _, _, false).
attested_value_t(true, Type, AttestedValue, T) :-
    in_type_t(Type, AttestedValue, T).

integer_t(Value, true) :-
    integer(Value).
integer_t(Value, false) :-
    float(Value).
integer_t(Value, false) :-
    atom(Value).
integer_t(Value, false) :-
    compound(Value).

calendar_date_t(date(Year, Month, DayNumber), T) :-
    integer_t(Year, YearIsInteger),
    integer_t(Month, MonthIsInteger),
    integer_t(DayNumber, DayNumberIsInteger),
    truth_and(YearIsInteger, MonthIsInteger, YearAndMonthAreIntegers),
    truth_and(YearAndMonthAreIntegers, DayNumberIsInteger, AllAreIntegers),
    calendar_day_t(AllAreIntegers, Year, Month, DayNumber, T).
calendar_date_t(Value, false) :-
    Value \= date(_, _, _).

calendar_day_t(false, _, _, _, false).
calendar_day_t(true, Year, Month, DayNumber, T) :-
    between_t(1, 12, Month, IsMonth),
    day_of_month_t(IsMonth, Year, Month, DayNumber, T).

day_of_month_t(false, _, _, _, false).
day_of_month_t(true, Year, Month, DayNumber, T) :-
    month_length(Year, Month, Length),
    between_t(1, Length, DayNumber, T).

between_t(Lowest, Highest, Number, true) :-
    Number >= Lowest,
    Number =< Highest.
between_t(Lowest, _, Number, false) :-
    Number < Lowest.
between_t(_, Highest, Number, false) :-
    Number > Highest.

month_length(_, 1, 31).
month_length(Year, 2, Length) :-
    leap_year_t(Year, IsLeapYear),
    february_length(IsLeapYear, Length).
month_length(_, 3, 31).
month_length(_, 4, 30).
month_length(_, 5, 31).
month_length(_, 6, 30).
month_length(_, 7, 31).
month_length(_, 8, 31).
month_length(_, 9, 30).
month_length(_, 10, 31).
month_length(_, 11, 30).
month_length(_, 12, 31).

february_length(true, 29).
february_length(false, 28).

leap_year_t(Year, IsLeapYear) :-
    FourYearRemainder is Year mod 4,
    CenturyRemainder is Year mod 100,
    FourCenturyRemainder is Year mod 400,
    gregorian_leap_year_t(FourYearRemainder, CenturyRemainder, FourCenturyRemainder, IsLeapYear).

gregorian_leap_year_t(_, _, 0, true).
gregorian_leap_year_t(0, CenturyRemainder, _, true) :-
    CenturyRemainder =\= 0.
gregorian_leap_year_t(_, 0, FourCenturyRemainder, false) :-
    FourCenturyRemainder =\= 0.
gregorian_leap_year_t(FourYearRemainder, _, _, false) :-
    FourYearRemainder =\= 0.

gdpr_data_subject_rights_erasure_request_type_route(Profile, absent) :-
    profile_lacks(Profile, request_type).
gdpr_data_subject_rights_erasure_request_type_route(Profile, Route) :-
    profile_get(Profile, request_type, RequestType),
    request_type_route(RequestType, Route).

request_type_route(erasure, in_order).
request_type_route(RequestType, outside_this_order(RequestType)) :-
    dif(RequestType, erasure).

gdpr_data_subject_rights_erasure_required_limb(Profile, Key, open([Key], [], [])) :-
    profile_lacks(Profile, Key).
gdpr_data_subject_rights_erasure_required_limb(Profile, Key, Limb) :-
    profile_get(Profile, Key, Value),
    value_limb(Value, Key, Limb).

gdpr_data_subject_rights_erasure_defeater_limb(Profile, Key, unmet) :-
    profile_lacks(Profile, Key).
gdpr_data_subject_rights_erasure_defeater_limb(Profile, Key, Limb) :-
    profile_get(Profile, Key, Value),
    value_limb(Value, Key, Limb).

value_limb(true, _, met).
value_limb(false, _, unmet).
value_limb(unsure, Key, open([], [Key], [])).

gdpr_data_subject_rights_erasure_outside_fact_limb(Profile, Key, Direction, Limb) :-
    profile_lacks(Profile, Key),
    absent_outside_fact_limb(Direction, Key, Limb).
gdpr_data_subject_rights_erasure_outside_fact_limb(Profile, Key, _, Limb) :-
    profile_get(Profile, Key, attested(Value, _)),
    attested_limb(Value, Limb).

absent_outside_fact_limb(enabling, Key, open([], [], [Key])).
absent_outside_fact_limb(blocking, _, unmet).

attested_limb(true, met).
attested_limb(false, unmet).

gdpr_data_subject_rights_erasure_negated_limb(met, unmet).
gdpr_data_subject_rights_erasure_negated_limb(unmet, met).
gdpr_data_subject_rights_erasure_negated_limb(open(Absent, Unsure, Outside), open(Absent, Unsure, Outside)).

gdpr_data_subject_rights_erasure_conjunction(Limbs, Limb) :-
    conjunction_from(Limbs, met, Limb).

conjunction_from([], Limb, Limb).
conjunction_from([Next|Limbs], Accumulated, Limb) :-
    conjunction_pair(Accumulated, Next, Combined),
    conjunction_from(Limbs, Combined, Limb).

conjunction_pair(unmet, _, unmet).
conjunction_pair(met, Next, Next).
conjunction_pair(open(_, _, _), unmet, unmet).
conjunction_pair(open(Absent, Unsure, Outside), met, open(Absent, Unsure, Outside)).
conjunction_pair(open(FirstAbsent, FirstUnsure, FirstOutside), open(SecondAbsent, SecondUnsure, SecondOutside), open(Absent, Unsure, Outside)) :-
    merge_keys(FirstAbsent, SecondAbsent, Absent),
    merge_keys(FirstUnsure, SecondUnsure, Unsure),
    merge_keys(FirstOutside, SecondOutside, Outside).

gdpr_data_subject_rights_erasure_disjunction(Limbs, Limb) :-
    disjunction_from(Limbs, unmet, Limb).

disjunction_from([], Limb, Limb).
disjunction_from([Next|Limbs], Accumulated, Limb) :-
    disjunction_pair(Accumulated, Next, Combined),
    disjunction_from(Limbs, Combined, Limb).

disjunction_pair(met, _, met).
disjunction_pair(unmet, Next, Next).
disjunction_pair(open(_, _, _), met, met).
disjunction_pair(open(Absent, Unsure, Outside), unmet, open(Absent, Unsure, Outside)).
disjunction_pair(open(FirstAbsent, FirstUnsure, FirstOutside), open(SecondAbsent, SecondUnsure, SecondOutside), open(Absent, Unsure, Outside)) :-
    merge_keys(FirstAbsent, SecondAbsent, Absent),
    merge_keys(FirstUnsure, SecondUnsure, Unsure),
    merge_keys(FirstOutside, SecondOutside, Outside).

merge_keys(FirstKeys, SecondKeys, Merged) :-
    append(FirstKeys, SecondKeys, AllKeys),
    gdpr_data_subject_rights_erasure_keys_in_contract_order(AllKeys, Merged).

gdpr_data_subject_rights_erasure_first_met([], none).
gdpr_data_subject_rights_erasure_first_met([Identifier - met|_], Identifier).
gdpr_data_subject_rights_erasure_first_met([_ - unmet|Rows], Identifier) :-
    gdpr_data_subject_rights_erasure_first_met(Rows, Identifier).
gdpr_data_subject_rights_erasure_first_met([_ - open(_, _, _)|Rows], Identifier) :-
    gdpr_data_subject_rights_erasure_first_met(Rows, Identifier).

gdpr_data_subject_rights_erasure_open_union([], [], [], []).
gdpr_data_subject_rights_erasure_open_union([met|Limbs], Absent, Unsure, Outside) :-
    gdpr_data_subject_rights_erasure_open_union(Limbs, Absent, Unsure, Outside).
gdpr_data_subject_rights_erasure_open_union([unmet|Limbs], Absent, Unsure, Outside) :-
    gdpr_data_subject_rights_erasure_open_union(Limbs, Absent, Unsure, Outside).
gdpr_data_subject_rights_erasure_open_union([open(LimbAbsent, LimbUnsure, LimbOutside)|Limbs], Absent, Unsure, Outside) :-
    gdpr_data_subject_rights_erasure_open_union(Limbs, RestAbsent, RestUnsure, RestOutside),
    merge_keys(LimbAbsent, RestAbsent, Absent),
    merge_keys(LimbUnsure, RestUnsure, Unsure),
    merge_keys(LimbOutside, RestOutside, Outside).

contract_key_order(ContractKeys) :-
    findall(Key, key_type(Key, _), ContractKeys).

gdpr_data_subject_rights_erasure_keys_in_contract_order(Keys, Ordered) :-
    contract_key_order(ContractKeys),
    keep_wanted(ContractKeys, Keys, Ordered).

keep_wanted([], _, []).
keep_wanted([Key|ContractKeys], Wanted, Ordered) :-
    memberd_t(Key, Wanted, IsWanted),
    keep_key(IsWanted, Key, Rest, Ordered),
    keep_wanted(ContractKeys, Wanted, Rest).

keep_key(true, Key, Rest, [Key|Rest]).
keep_key(false, _, Rest, Rest).

gdpr_data_subject_rights_erasure_present_pairs(Profile, Keys, Pairs) :-
    gdpr_data_subject_rights_erasure_keys_in_contract_order(Keys, Ordered),
    present_pairs_of(Ordered, Profile, Pairs).

present_pairs_of([], _, []).
present_pairs_of([Key|Keys], Profile, Pairs) :-
    profile_lacks(Profile, Key),
    present_pairs_of(Keys, Profile, Pairs).
present_pairs_of([Key|Keys], Profile, [Key - Value|Pairs]) :-
    profile_get(Profile, Key, Value),
    present_pairs_of(Keys, Profile, Pairs).

test(an_absent_required_key_is_open_by_absence) :-
    gdpr_data_subject_rights_erasure_required_limb([attribute(request_type, erasure)], consent_withdrawn, open([consent_withdrawn], [], [])).
test(an_unsure_judgement_is_open_by_judgement) :-
    gdpr_data_subject_rights_erasure_required_limb([attribute(personal_data_unlawfully_processed, unsure)], personal_data_unlawfully_processed, open([], [personal_data_unlawfully_processed], [])).
test(an_absent_defeater_is_unmet) :-
    gdpr_data_subject_rights_erasure_defeater_limb([], request_manifestly_unfounded_or_excessive, unmet).
test(an_absent_enabling_fact_is_open_by_outside_fact) :-
    gdpr_data_subject_rights_erasure_outside_fact_limb([], erasure_required_by_union_or_member_state_law, enabling, open([], [], [erasure_required_by_union_or_member_state_law])).
test(an_absent_blocking_fact_is_unmet) :-
    gdpr_data_subject_rights_erasure_outside_fact_limb([], legislative_restriction_applies_to_the_right, blocking, unmet).
test(an_attested_true_fact_is_met) :-
    gdpr_data_subject_rights_erasure_outside_fact_limb([attribute(legislative_restriction_applies_to_the_right, attested(true, attestation(by, at, reason, none)))], legislative_restriction_applies_to_the_right, blocking, met).
test(unmet_dominates_a_conjunction) :-
    gdpr_data_subject_rights_erasure_conjunction([met, open([consent_withdrawn], [], []), unmet], unmet).
test(open_children_union_in_a_disjunction) :-
    gdpr_data_subject_rights_erasure_disjunction([open([consent_withdrawn], [], []), unmet, open([], [personal_data_unlawfully_processed], [])], open([consent_withdrawn], [personal_data_unlawfully_processed], [])).
test(met_dominates_a_disjunction) :-
    gdpr_data_subject_rights_erasure_disjunction([open([consent_withdrawn], [], []), met], met).
test(the_first_met_row_wins) :-
    findall(Identifier, gdpr_data_subject_rights_erasure_first_met([art17_1_a - unmet, art17_1_b - open([], [], []), art17_1_c - met, art17_1_d - met], Identifier), Identifiers),
    Identifiers == [art17_1_c].
test(no_met_row_gives_none) :-
    gdpr_data_subject_rights_erasure_first_met([art17_1_a - unmet], none).
test(keys_come_in_contract_order) :-
    gdpr_data_subject_rights_erasure_keys_in_contract_order([consent_withdrawn, request_type, consent_withdrawn], [request_type, consent_withdrawn]).
test(the_erasure_type_is_in_this_order) :-
    gdpr_data_subject_rights_erasure_request_type_route([attribute(request_type, erasure)], in_order).
test(an_access_type_is_outside_this_order) :-
    gdpr_data_subject_rights_erasure_request_type_route([attribute(request_type, access)], outside_this_order(access)).

test(an_absent_required_key_is_not_unmet, fail) :-
    gdpr_data_subject_rights_erasure_required_limb([attribute(request_type, erasure)], consent_withdrawn, unmet).
test(an_absent_defeater_is_not_open, fail) :-
    gdpr_data_subject_rights_erasure_defeater_limb([], request_manifestly_unfounded_or_excessive, open(_, _, _)).
test(an_access_type_is_not_in_this_order, fail) :-
    gdpr_data_subject_rights_erasure_request_type_route([attribute(request_type, access)], in_order).
