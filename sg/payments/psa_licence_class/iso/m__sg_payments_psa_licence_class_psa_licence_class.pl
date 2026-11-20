% SPDX-License-Identifier: EUPL-1.2
:- module(m__sg_payments_psa_licence_class_psa_licence_class, [psa_licence_class/2, psa_licence/4, volume/2, decide_psa_licence_class/2, psa_licence_class_status/2, psa_licence_class_checklist/2, psa_licence_class_decision_resolvable/1, psa_licence_class_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_dicts, [get/4]).
:- use_module(clausal_lists_extra, [clausal_is_list/1]).
:- use_module(library(clpz)).
:- use_module(m__sg_payments_psa_licence_class_citations, [implements/1]).

known_service(account_issuance, cite(sg_psa_2019_first_schedule_part_1)) :-
    implements(sg_psa_2019_first_schedule_part_1).
known_service(e_money_account_issuance, cite(sg_psa_2019_s6_17)) :-
    implements(sg_psa_2019_s6_17).
known_service(domestic_money_transfer, cite(sg_psa_2019_first_schedule_part_1)) :-
    implements(sg_psa_2019_first_schedule_part_1).
known_service(cross_border_money_transfer, cite(sg_psa_2019_first_schedule_part_1)) :-
    implements(sg_psa_2019_first_schedule_part_1).
known_service(merchant_acquisition, cite(sg_psa_2019_first_schedule_part_1)) :-
    implements(sg_psa_2019_first_schedule_part_1).
known_service(e_money_issuance, cite(sg_psa_2019_first_schedule_part_1)) :-
    implements(sg_psa_2019_first_schedule_part_1).
known_service(digital_payment_token, cite(sg_psa_2019_first_schedule_part_1)) :-
    implements(sg_psa_2019_first_schedule_part_1).
known_service(money_changing, cite(sg_psa_2019_first_schedule_part_1)) :-
    implements(sg_psa_2019_first_schedule_part_1).

volume_tested_service(account_issuance, cite(sg_psa_2019_s6_5_a_ii_a)) :-
    implements(sg_psa_2019_s6_5_a_ii_a).
volume_tested_service(domestic_money_transfer, cite(sg_psa_2019_s6_5_a_ii_a)) :-
    implements(sg_psa_2019_s6_5_a_ii_a).
volume_tested_service(cross_border_money_transfer, cite(sg_psa_2019_s6_5_a_ii_a)) :-
    implements(sg_psa_2019_s6_5_a_ii_a).
volume_tested_service(merchant_acquisition, cite(sg_psa_2019_s6_5_a_ii_a)) :-
    implements(sg_psa_2019_s6_5_a_ii_a).
volume_tested_service(digital_payment_token, cite(sg_psa_2019_s6_5_a_ii_a)) :-
    implements(sg_psa_2019_s6_5_a_ii_a).

licence_citation(no_licence_required, cite(sg_psa_2019_s5_1_a)) :-
    implements(sg_psa_2019_s5_1_a).
licence_citation(exempt_payment_service_provider, cite(sg_psa_2019_s5_1_b)) :-
    implements(sg_psa_2019_s5_1_b).
licence_citation(money_changing_licence, cite(sg_psa_2019_s6_3)) :-
    implements(sg_psa_2019_s6_2),
    implements(sg_psa_2019_s6_3).
licence_citation(standard_payment_institution_licence, cite(sg_psa_2019_s6_4)) :-
    implements(sg_psa_2019_s6_2),
    implements(sg_psa_2019_s6_4).
licence_citation(major_payment_institution_licence, cite(sg_psa_2019_s6_4)) :-
    implements(sg_psa_2019_s6_2),
    implements(sg_psa_2019_s6_4).
licence_citation(indeterminate, cite(sg_psa_2019_s5_1_a)) :-
    implements(sg_psa_2019_s5_1_a).

trigger_citation_record(single_service_volume, cite(sg_psa_2019_s6_5_a_ii_a)) :-
    implements(sg_psa_2019_s6_5_a_ii_a).
trigger_citation_record(multi_service_volume, cite(sg_psa_2019_s6_5_a_ii_b)) :-
    implements(sg_psa_2019_s6_5_a_ii_b).
trigger_citation_record(e_money_account_float, cite(sg_psa_2019_s6_5_b)) :-
    implements(sg_psa_2019_s6_5_b).
trigger_citation_record(e_money_issued, cite(sg_psa_2019_s6_5_c)) :-
    implements(sg_psa_2019_s6_5_c).

threshold_citation_record(single_service_volume_threshold_cents, cite(sg_psa_2019_s6_5_a_ii_a)) :-
    implements(sg_psa_2019_s6_5_a_ii_a).
threshold_citation_record(multi_service_volume_threshold_cents, cite(sg_psa_2019_s6_5_a_ii_b)) :-
    implements(sg_psa_2019_s6_5_a_ii_b).
threshold_citation_record(e_money_float_threshold_cents, cite(sg_psa_2019_s6_5_b)) :-
    implements(sg_psa_2019_s6_5_b).
threshold_citation_record(e_money_issued_threshold_cents, cite(sg_psa_2019_s6_5_c)) :-
    implements(sg_psa_2019_s6_5_c).

known_service(Service) :-
    known_service(Service, _CitationTerm).

volume_tested_service(Service) :-
    volume_tested_service(Service, _CitationTerm).

trigger_citation(single_service_volume, sg_psa_2019_s6_5_a_ii_a) :-
    implements(sg_psa_2019_s6_5_a_ii_a).
trigger_citation(multi_service_volume, sg_psa_2019_s6_5_a_ii_b) :-
    implements(sg_psa_2019_s6_5_a_ii_b).
trigger_citation(e_money_account_float, sg_psa_2019_s6_5_b) :-
    implements(sg_psa_2019_s6_5_b).
trigger_citation(e_money_issued, sg_psa_2019_s6_5_c) :-
    implements(sg_psa_2019_s6_5_c).

required_keys([services, exempt_payment_service_provider]).

key_absent(Profile, ProfileKey) :-
    get(Profile, ProfileKey, Value, absent_required_key),
    Value == absent_required_key.

required_key_absent_candidate(Profile, ProfileKey) :-
    required_keys(RequiredKeys),
    member(ProfileKey, RequiredKeys),
    key_absent(Profile, ProfileKey).

required_key_absent(Profile) :-
    findall(ProfileKey, required_key_absent_candidate(Profile, ProfileKey), AbsentKeys),
    length(AbsentKeys, AbsentCount),
    AbsentCount #> 0.

is_boolean(Value) :-
    Value == true.
is_boolean(Value) :-
    Value == false.

known_service_in_list(UnfilteredServices, Service) :-
    member(Service, UnfilteredServices),
    known_service(Service).

normalize_services(UnfilteredServices, Services) :-
    findall(Service, known_service_in_list(UnfilteredServices, Service), FilteredServices),
    sort(FilteredServices, Services).

volume_tested_service_in_list(Services, Service) :-
    member(Service, Services),
    volume_tested_service(Service).

volume_tested_services(Services, VolumeTestedServices) :-
    findall(Service, volume_tested_service_in_list(Services, Service), FilteredVolumeTestedServices),
    sort(FilteredVolumeTestedServices, VolumeTestedServices).

volume_for_service(Volumes, Service, 0) :-
    findall(EntryCents, member(volume(Service, EntryCents), Volumes), EntryList),
    length(EntryList, 0).
volume_for_service(Volumes, Service, Cents) :-
    findall(EntryCents, member(volume(Service, EntryCents), Volumes), EntryList),
    length(EntryList, EntryCount),
    EntryCount #> 0,
    nth0(0, EntryList, Cents).

volume_tested_service_cents(VolumeTestedServices, Volumes, Service, ServiceCents) :-
    member(Service, VolumeTestedServices),
    volume_for_service(Volumes, Service, ServiceCents).

volume_total_cents(VolumeTestedServices, Volumes, TotalCents) :-
    implements(sg_psa_2019_s6_5_a_ii_a),
    findall(ServiceCents, volume_tested_service_cents(VolumeTestedServices, Volumes, _Service, ServiceCents), ServiceCentsList),
    sum_list(ServiceCentsList, TotalCents).

prepare_required_profile(Profile, Services, Exempt, VolumeTestedServices, TotalCents, Volumes) :-
    get(Profile, services, UnfilteredServices, absent_required_key),
    UnfilteredServices \== absent_required_key,
    clausal_is_list(UnfilteredServices),
    get(Profile, exempt_payment_service_provider, UnfilteredExempt, absent_required_key),
    UnfilteredExempt \== absent_required_key,
    is_boolean(UnfilteredExempt),
    Exempt = UnfilteredExempt,
    normalize_services(UnfilteredServices, Services),
    volume_tested_services(Services, VolumeTestedServices),
    get(Profile, monthly_average_volumes, Volumes, []),
    volume_total_cents(VolumeTestedServices, Volumes, TotalCents).

service_list_has_items(ServiceList) :-
    length(ServiceList, Count),
    Count #> 0.

single_service_volume_match(VolumeTestedServices, Volumes, Service) :-
    member(Service, VolumeTestedServices),
    volume_for_service(Volumes, Service, ServiceCents),
    ServiceCents #> 300000000.

single_service_volume_trigger(VolumeTestedServices, Volumes) :-
    implements(sg_psa_2019_s6_5_a_ii_a),
    findall(Service, single_service_volume_match(VolumeTestedServices, Volumes, Service), MatchingServices),
    length(MatchingServices, MatchingCount),
    MatchingCount #> 0.

multi_service_volume_trigger(VolumeTestedServices, TotalCents) :-
    implements(sg_psa_2019_s6_5_a_ii_b),
    length(VolumeTestedServices, ServiceCount),
    ServiceCount #>= 2,
    TotalCents #> 600000000.

e_money_account_float_trigger(Services, Profile) :-
    implements(sg_psa_2019_s6_5_b),
    member(e_money_account_issuance, Services),
    get(Profile, resident_e_money_float_cents, ResidentFloatCents, 0),
    get(Profile, singapore_issued_other_e_money_float_cents, OtherFloatCents, 0),
    TotalFloatCents #= ResidentFloatCents + OtherFloatCents,
    TotalFloatCents #> 500000000.

e_money_issued_trigger(Services, Profile) :-
    implements(sg_psa_2019_s6_5_c),
    member(e_money_issuance, Services),
    get(Profile, specified_e_money_issued_cents, SpecifiedEMoneyCents, 0),
    SpecifiedEMoneyCents #> 500000000.

major_trigger_order([single_service_volume, multi_service_volume, e_money_account_float, e_money_issued]).

major_trigger_candidate(Trigger) :-
    major_trigger_order(OrderList),
    member(Trigger, OrderList).

trigger_holds(single_service_volume, _Services, VolumeTestedServices, _TotalCents, Volumes, _Profile) :-
    single_service_volume_trigger(VolumeTestedServices, Volumes).
trigger_holds(multi_service_volume, _Services, VolumeTestedServices, TotalCents, _Volumes, _Profile) :-
    multi_service_volume_trigger(VolumeTestedServices, TotalCents).
trigger_holds(e_money_account_float, Services, _VolumeTestedServices, _TotalCents, _Volumes, Profile) :-
    e_money_account_float_trigger(Services, Profile).
trigger_holds(e_money_issued, Services, _VolumeTestedServices, _TotalCents, _Volumes, Profile) :-
    e_money_issued_trigger(Services, Profile).

major_trigger_holds(Trigger, Services, VolumeTestedServices, TotalCents, Volumes, Profile) :-
    major_trigger_candidate(Trigger),
    trigger_holds(Trigger, Services, VolumeTestedServices, TotalCents, Volumes, Profile).

major_triggers(Services, VolumeTestedServices, TotalCents, Volumes, Profile, Triggers) :-
    findall(Trigger, major_trigger_holds(Trigger, Services, VolumeTestedServices, TotalCents, Volumes, Profile), Triggers).

major_citation_candidate(Triggers, Trigger, Citation) :-
    member(Trigger, Triggers),
    trigger_citation(Trigger, Citation).

major_citations(Triggers, Citations) :-
    findall(Citation, major_citation_candidate(Triggers, _Trigger, Citation), Citations).

psa_licence_class(Profile, psa_licence(indeterminate, [], n_a, [])) :-
    required_key_absent(Profile).
psa_licence_class(Profile, psa_licence(no_licence_required, [], 0, [])) :-
    implements(sg_psa_2019_s5_1_a),
    prepare_required_profile(Profile, Services, _Exempt, _VolumeTestedServices, _TotalCents, _Volumes),
    Services == [].
psa_licence_class(Profile, psa_licence(exempt_payment_service_provider, [], VolumeTotalCents, [sg_psa_2019_s5_1_b])) :-
    implements(sg_psa_2019_s5_1_b),
    prepare_required_profile(Profile, Services, Exempt, _VolumeTestedServices, VolumeTotalCents, _Volumes),
    service_list_has_items(Services),
    Exempt == true.
psa_licence_class(Profile, psa_licence(money_changing_licence, [], 0, [sg_psa_2019_s6_3])) :-
    implements(sg_psa_2019_s6_3),
    prepare_required_profile(Profile, Services, Exempt, _VolumeTestedServices, TotalCents, _Volumes),
    service_list_has_items(Services),
    Exempt == false,
    Services == [money_changing],
    TotalCents == 0.
psa_licence_class(Profile, psa_licence(major_payment_institution_licence, Triggers, VolumeTotalCents, Citations)) :-
    implements(sg_psa_2019_s6_4),
    prepare_required_profile(Profile, Services, Exempt, VolumeTestedServices, VolumeTotalCents, Volumes),
    service_list_has_items(Services),
    Exempt == false,
    Services \== [money_changing],
    major_triggers(Services, VolumeTestedServices, VolumeTotalCents, Volumes, Profile, Triggers),
    length(Triggers, TriggerCount),
    TriggerCount #> 0,
    major_citations(Triggers, TriggerCitations),
    Citations = [sg_psa_2019_s6_4|TriggerCitations].
psa_licence_class(Profile, psa_licence(standard_payment_institution_licence, [], VolumeTotalCents, [sg_psa_2019_s6_4])) :-
    implements(sg_psa_2019_s6_4),
    prepare_required_profile(Profile, Services, Exempt, VolumeTestedServices, VolumeTotalCents, Volumes),
    service_list_has_items(Services),
    Exempt == false,
    Services \== [money_changing],
    major_triggers(Services, VolumeTestedServices, VolumeTotalCents, Volumes, Profile, Triggers),
    length(Triggers, 0).

psa_licence(Licence, Triggers, VolumeTotalCents, Citations) :-
    ground(Licence),
    ground(Triggers),
    ground(VolumeTotalCents),
    ground(Citations),
    valid_licence(Licence),
    valid_major_triggers(Triggers, Licence),
    valid_volume_total(VolumeTotalCents, Licence),
    valid_citations(Citations).

volume(Service, Cents) :-
    ground(Service),
    ground(Cents),
    known_service(Service),
    integer(Cents),
    Cents #>= 0.

licence_vocabulary([no_licence_required, exempt_payment_service_provider, money_changing_licence, standard_payment_institution_licence, major_payment_institution_licence, indeterminate]).

valid_licence(Licence) :-
    licence_vocabulary(Vocabulary),
    member(Licence, Vocabulary).

valid_major_triggers([], Licence) :-
    Licence \== major_payment_institution_licence.
valid_major_triggers(Triggers, major_payment_institution_licence) :-
    clausal_is_list(Triggers),
    major_trigger_order(OrderList),
    ordered_subset(Triggers, OrderList),
    sort(Triggers, SortedTriggers),
    length(Triggers, TriggerCount),
    length(SortedTriggers, TriggerCount),
    TriggerCount #> 0.

ordered_subset([], _OrderList).
ordered_subset([HeadItem|TailItems], OrderList) :-
    member(HeadItem, OrderList),
    ordered_subset(TailItems, OrderList).

valid_volume_total(n_a, indeterminate).
valid_volume_total(VolumeTotalCents, Licence) :-
    Licence \== indeterminate,
    integer(VolumeTotalCents),
    VolumeTotalCents #>= 0.

valid_citations(Citations) :-
    clausal_is_list(Citations),
    all_citations_valid(Citations).

all_citations_valid([]).
all_citations_valid([Citation|TailCitations]) :-
    result_citation_vocabulary(Vocabulary),
    member(Citation, Vocabulary),
    all_citations_valid(TailCitations).

result_citation_vocabulary([sg_psa_2019_s5_1_b, sg_psa_2019_s6_3, sg_psa_2019_s6_4, sg_psa_2019_s6_5_a_ii_a, sg_psa_2019_s6_5_a_ii_b, sg_psa_2019_s6_5_b, sg_psa_2019_s6_5_c]).

decide_psa_licence_class(Profile, Result) :-
    psa_licence_class(Profile, Result).

psa_licence_class_status(Profile, Licence) :-
    psa_licence_class(Profile, psa_licence(Licence, _Triggers, _VolumeTotalCents, _Citations)).

psa_licence_class_checklist(Profile, Checklist) :-
    psa_licence_class(Profile, psa_licence(Licence, _Triggers, _VolumeTotalCents, _Citations)),
    licence_citation(Licence, CitationTerm),
    Checklist = [item(licence_class, Licence, CitationTerm)].

psa_licence_class_decision_resolvable(Profile) :-
    psa_licence_class(Profile, _Result).

psa_licence_class_status_values(LicenceValues) :-
    LicenceValues = [no_licence_required, exempt_payment_service_provider, money_changing_licence, standard_payment_institution_licence, major_payment_institution_licence, indeterminate].
