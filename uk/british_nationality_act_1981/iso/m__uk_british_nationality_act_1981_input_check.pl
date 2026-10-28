:- module(m__uk_british_nationality_act_1981_input_check, [british_nationality_input_problems/3, person_input_problems/2, date_argument_problems/3, determination/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_dicts, [dict_pairs/2, get/4, is_dict_t/2]).
:- use_module(library(clpz)).
:- use_module(m__uk_british_nationality_act_1981_kernel, [valid_date_t/2, date_day_number/2]).

determination(citizenship).
determination(registration).
determination(naturalisation).

british_nationality_input_problems(Determination, Profile, Problems) :-
    determination(Determination),
    contract_for(Determination, Contract),
    profile_problems(Contract, Profile, Problems).

date_argument_problems(Name, Value, [not_ground(Name)]) :-
    term_variables(Value, [_|_]).
date_argument_problems(Name, Value, Problems) :-
    term_variables(Value, []),
    value_t(date, Value, Truth),
    type_problem(Truth, Name, date, Problems).

person_input_problems(Profile, Problems) :-
    contract_for(citizenship, Contract),
    profile_problems(Contract, Profile, Problems).

contract_for(citizenship, Contract) :-
    person_contract(optional, Contract).
contract_for(registration, Contract) :-
    person_contract(optional, Contract).
contract_for(naturalisation, Contract) :-
    person_contract(required, Contract).

person_contract(NaturalisationKeys, [key(date_of_birth, date, required), key(place_of_birth, one_of([united_kingdom, outside_united_kingdom]), required), key(mother, person, optional), key(father, person, optional), key(born_legitimate, boolean, optional), key(legitimated_on, date_or_none, optional), key(born_stateless, boolean, optional), key(found_abandoned_in_united_kingdom_on, date_or_none, optional), key(contrary_shown_for_abandoned_infant, boolean, optional), key(citizenship_at_commencement, one_of([none, otherwise_than_by_descent, by_descent, would_have_become_but_for_death(otherwise_than_by_descent), would_have_become_but_for_death(by_descent)]), optional), key(registrations, list_of(registration), optional), key(naturalisations, list_of(naturalisation), optional), key(adoption_orders, list_of(adoption_order), optional), key(date_of_death, date_or_none, optional), key(service_outside_united_kingdom, list_of(service), optional), key(ordinarily_resident_in_united_kingdom, list_of(period), optional), key(immigration_restrictions_on_stay, list_of(period), optional), key(immigration_exemptions, list_of(exemption), optional), key(in_united_kingdom_in_breach_of_immigration_laws, list_of(period), optional), key(diplomatic_immunity, list_of(period), optional), key(absences_from_united_kingdom, list_of(period), optional), key(detentions, list_of(period), optional), key(parents_marriage_terminated_on, date_or_none, optional), key(parents_legally_separated_on, date_or_none, optional), key(consent_to_registration_signified_by, list_of(one_of([mother, father])), optional), key(british_nationality_other_than_citizenship, one_of([none, british_dependent_territories_citizen, british_overseas_citizen, british_subject_under_this_act, british_protected_person]), optional), key(crown_service_in_dependent_territory, boolean, optional), key(of_unsound_mind, boolean, optional), key(spouse, person_or_none, optional), key(good_character, boolean, NaturalisationKeys), key(sufficient_knowledge_of_language, boolean, NaturalisationKeys), key(intention_after_naturalisation, one_of([principal_home_in_united_kingdom, qualifying_service, other]), NaturalisationKeys)]).

profile_problems(_, Profile, [not_ground(profile)]) :-
    var(Profile).
profile_problems(Contract, Profile, Problems) :-
    nonvar(Profile),
    is_dict_t(Profile, IsDict),
    profile_problems_given(IsDict, Contract, Profile, Problems).

profile_problems_given(false, _, _, [not_a_profile]).
profile_problems_given(true, Contract, Profile, Problems) :-
    keys_problems(Contract, Profile, KeyProblems),
    dict_pairs(Profile, Pairs),
    contract_names(Contract, Names),
    unknown_key_problems(Pairs, Names, UnknownProblems),
    append(KeyProblems, UnknownProblems, Problems).

keys_problems([], _, []).
keys_problems([key(Key, Type, Requirement)|Keys], Profile, Problems) :-
    get(Profile, Key, Value, '$absent'),
    term_variables(Value, Variables),
    key_problems(Variables, Requirement, Key, Type, Value, Here),
    keys_problems(Keys, Profile, Rest),
    append(Here, Rest, Problems).

key_problems([_|_], _, Key, _, _, [not_ground(Key)]).
key_problems([], required, Key, _, '$absent', [missing_key(Key)]).
key_problems([], optional, _, _, '$absent', []).
key_problems([], _, Key, Type, Value, Problems) :-
    dif(Value, '$absent'),
    value_problems(Type, Key, Value, Problems).

contract_names([], []).
contract_names([key(Key, _, _)|Keys], [Key|Names]) :-
    contract_names(Keys, Names).

unknown_key_problems([], _, []).
unknown_key_problems([Key - _|Pairs], Names, Problems) :-
    member_t(Key, Names, Known),
    unknown_key_problem(Known, Key, Here),
    unknown_key_problems(Pairs, Names, Rest),
    append(Here, Rest, Problems).

unknown_key_problem(true, _, []).
unknown_key_problem(false, Key, [unknown_key(Key)]).

member_t(_, [], false).
member_t(Term, [Term|_], true).
member_t(Term, [Other|Others], Truth) :-
    dif(Term, Other),
    member_t(Term, Others, Truth).

value_problems(person, Key, Value, Problems) :-
    person_input_problems(Value, Inner),
    wrap_in(Inner, Key, Problems).
value_problems(person_or_none, _, none, []).
value_problems(person_or_none, Key, Value, Problems) :-
    dif(Value, none),
    value_problems(person, Key, Value, Problems).
value_problems(list_of(ItemType), Key, Value, Problems) :-
    list_problems(ItemType, Key, Value, Problems).
value_problems(Type, Key, Value, Problems) :-
    scalar_type(Type),
    value_t(Type, Value, Truth),
    type_problem(Truth, Key, Type, Problems).

scalar_type(date).
scalar_type(date_or_none).
scalar_type(boolean).
scalar_type(one_of(_)).

type_problem(true, _, _, []).
type_problem(false, Key, Type, [wrong_type(Key, Type)]).

wrap_in([], _, []).
wrap_in([Problem|Problems], Key, [in(Key, Problem)|Wrapped]) :-
    wrap_in(Problems, Key, Wrapped).

list_problems(_, _, [], []).
list_problems(ItemType, Key, [Item|Items], Problems) :-
    item_problems(ItemType, Key, Item, Here),
    list_problems(ItemType, Key, Items, Rest),
    append(Here, Rest, Problems).
list_problems(ItemType, Key, Value, [wrong_type(Key, list_of(ItemType))]) :-
    dict_t(Value, true).
list_problems(ItemType, Key, Value, [wrong_type(Key, list_of(ItemType))]) :-
    dict_t(Value, false),
    not_a_proper_list(Value).

item_problems(adoption_order, Key, Item, Problems) :-
    dict_t(Item, false),
    Item = adoption_order(Date, Court, Adopters),
    value_t(date, Date, DateOk),
    value_t(one_of([court_in_united_kingdom, court_outside_united_kingdom]), Court, CourtOk),
    and_t(DateOk, CourtOk, Ok),
    type_problem(Ok, Key, adoption_order, Here),
    list_problems(person, Key, Adopters, AdopterProblems),
    append(Here, AdopterProblems, Problems).
item_problems(adoption_order, Key, Item, [wrong_type(Key, adoption_order)]) :-
    dict_t(Item, true).
item_problems(adoption_order, Key, Item, [wrong_type(Key, adoption_order)]) :-
    dict_t(Item, false),
    functor(Item, Name, Arity),
    dif(Name/Arity, adoption_order/3).
item_problems(person, Key, Item, Problems) :-
    value_problems(person, Key, Item, Problems).
item_problems(ItemType, Key, Item, Problems) :-
    simple_item_type(ItemType),
    value_t(ItemType, Item, Truth),
    type_problem(Truth, Key, ItemType, Problems).

simple_item_type(period).
simple_item_type(exemption).
simple_item_type(service).
simple_item_type(registration).
simple_item_type(naturalisation).
simple_item_type(one_of(_)).

and_t(true, Truth, Truth).
and_t(false, _, false).

dict_t([], false).
dict_t(Term, Truth) :-
    dif(Term, []),
    is_dict_t(Term, Truth).

value_t(Type, Value, false) :-
    dict_t(Value, true),
    dif(Type, person).
value_t(Type, Value, Truth) :-
    dict_t(Value, false),
    plain_value_t(Type, Value, Truth).

plain_value_t(date, Value, Truth) :-
    date_t(Value, Truth).
plain_value_t(date_or_none, none, true).
plain_value_t(date_or_none, Value, Truth) :-
    dif(Value, none),
    date_t(Value, Truth).
plain_value_t(boolean, Value, Truth) :-
    member_t(Value, [true, false], Truth).
plain_value_t(one_of(Values), Value, Truth) :-
    member_t(Value, Values, Truth).
plain_value_t(period, Value, Truth) :-
    period_t(Value, Truth).
plain_value_t(exemption, exemption(Kind, From, To), Truth) :-
    member_t(Kind, [section_8_2, section_8_2_order_provides_otherwise, section_8_3, section_8_4_a, section_8_4_b, section_8_4_c], KindOk),
    period_t(period(From, To), PeriodOk),
    and_t(KindOk, PeriodOk, Truth).
plain_value_t(exemption, Value, false) :-
    functor(Value, Name, Arity),
    dif(Name/Arity, exemption/3).
plain_value_t(service, service(Kind, From, To, RecruitedIn), Truth) :-
    member_t(Kind, [crown_service_under_the_government_of_the_united_kingdom, designated_service, community_institution, other_service], KindOk),
    member_t(RecruitedIn, [united_kingdom, member_state_of_the_communities, other_country], RecruitedOk),
    period_t(period(From, To), PeriodOk),
    and_t(KindOk, RecruitedOk, Both),
    and_t(Both, PeriodOk, Truth).
plain_value_t(service, Value, false) :-
    functor(Value, Name, Arity),
    dif(Name/Arity, service/4).
plain_value_t(registration, registration(Provision, Date), Truth) :-
    member_t(Provision, [section_1_3, section_1_4, section_3_1, section_3_2, section_3_5, section_4_2, section_4_5], ProvisionOk),
    date_t(Date, DateOk),
    and_t(ProvisionOk, DateOk, Truth).
plain_value_t(registration, Value, false) :-
    functor(Value, Name, Arity),
    dif(Name/Arity, registration/2).
plain_value_t(naturalisation, naturalisation(Provision, Date), Truth) :-
    member_t(Provision, [section_6_1, section_6_2], ProvisionOk),
    date_t(Date, DateOk),
    and_t(ProvisionOk, DateOk, Truth).
plain_value_t(naturalisation, Value, false) :-
    functor(Value, Name, Arity),
    dif(Name/Arity, naturalisation/2).

period_t(period(From, ongoing), Truth) :-
    date_t(From, Truth).
period_t(period(From, To), Truth) :-
    dif(To, ongoing),
    date_t(From, FromOk),
    date_t(To, ToOk),
    and_t(FromOk, ToOk, Both),
    ordered_t(Both, From, To, Truth).
period_t(Value, false) :-
    functor(Value, Name, Arity),
    dif(Name/Arity, period/2).

ordered_t(false, _, _, false).
ordered_t(true, From, To, Truth) :-
    date_day_number(From, FromDay),
    date_day_number(To, ToDay),
    order_t(FromDay, ToDay, Truth).

order_t(FromDay, ToDay, true) :-
    FromDay #=< ToDay.
order_t(FromDay, ToDay, false) :-
    FromDay #> ToDay.

date_t(date(Year, Month, Day), Truth) :-
    integers_t([Year, Month, Day], Integers),
    calendar_date_t(Integers, date(Year, Month, Day), Truth).
date_t(Value, false) :-
    functor(Value, Name, Arity),
    dif(Name/Arity, date/3).

calendar_date_t(false, _, false).
calendar_date_t(true, Date, Truth) :-
    valid_date_t(Date, Truth).

integers_t([], true).
integers_t([Value|Values], Truth) :-
    integer_t(Value, Here),
    and_t(Here, Rest, Truth),
    integers_t(Values, Rest).

integer_t(Value, true) :-
    integer(Value).
integer_t(Value, false) :-
    atom(Value).
integer_t(Value, false) :-
    float(Value).
integer_t(Value, false) :-
    compound(Value).

not_a_proper_list(Term) :-
    functor([cell], CellName, CellArity),
    functor(Term, Name, Arity),
    dif(Name/Arity, CellName/CellArity),
    dif(Term, []).
not_a_proper_list([_|Tail]) :-
    not_a_proper_list(Tail).

no_statute("british_nationality_input_problems", 3, "computation_helper").
no_statute("person_input_problems", 2, "computation_helper").
no_statute("date_argument_problems", 3, "computation_helper").
no_statute("contract_for", 2, "computation_helper").
no_statute("profile_problems", 3, "computation_helper").
no_statute("profile_problems_given", 4, "computation_helper").
no_statute("keys_problems", 3, "computation_helper").
no_statute("key_problems", 6, "computation_helper").
no_statute("contract_names", 2, "computation_helper").
no_statute("unknown_key_problems", 3, "computation_helper").
no_statute("member_t", 3, "computation_helper").
no_statute("value_problems", 4, "computation_helper").
no_statute("wrap_in", 3, "computation_helper").
no_statute("list_problems", 4, "computation_helper").
no_statute("item_problems", 4, "computation_helper").
no_statute("value_t", 3, "computation_helper").
no_statute("plain_value_t", 3, "computation_helper").
no_statute("period_t", 2, "computation_helper").
no_statute("ordered_t", 4, "computation_helper").
no_statute("order_t", 3, "computation_helper").
no_statute("date_t", 2, "computation_helper").
no_statute("calendar_date_t", 3, "computation_helper").
no_statute("integers_t", 2, "computation_helper").
no_statute("integer_t", 2, "computation_helper").
no_statute("not_a_proper_list", 1, "computation_helper").
no_statute("dict_t", 2, "computation_helper").
