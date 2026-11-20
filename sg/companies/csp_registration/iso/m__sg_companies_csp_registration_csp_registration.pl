% SPDX-License-Identifier: EUPL-1.2
:- module(m__sg_companies_csp_registration_csp_registration, [csp_assessment/2, csp/5, decide_csp_registration/2, csp_registration_status/2, csp_registration_checklist/2, csp_registration_decision_resolvable/1, csp_registration_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_dicts, [dict_pairs/2, get/3, get/4]).
:- use_module(clausal_lists_extra, [clausal_is_list/1]).
:- use_module(library(clpz)).
:- use_module(m__sg_companies_csp_registration_citations, [implements/1]).
:- use_module(formalize_lib, [memberd/2, not_member/2]).

csp_registration_status_values([no_corporate_service, not_carrying_on_business_in_singapore, registered, registration_required, indeterminate]).

service_type_order([formation, director_secretary, address, nominee_shareholder, designated_accounting, acra_transaction]).

activity_type(forms_legal_person_for_another, formation, cite(sg_cspa_2024_s2_1_corporate_service)).
activity_type(acts_as_director_or_secretary, director_secretary, cite(sg_cspa_2024_s2_1_corporate_service)).
activity_type(arranges_director_or_secretary, director_secretary, cite(sg_cspa_2024_s2_1_corporate_service)).
activity_type(acts_as_partner, director_secretary, cite(sg_cspa_2024_s2_1_corporate_service)).
activity_type(arranges_partner, director_secretary, cite(sg_cspa_2024_s2_1_corporate_service)).
activity_type(acts_in_similar_capacity_for_legal_person, director_secretary, cite(sg_cspa_2024_s2_1_corporate_service)).
activity_type(provides_registered_office_or_address, address, cite(sg_cspa_2024_s2_1_corporate_service)).
activity_type(nominee_shareholder_for_unlisted_corporation, nominee_shareholder, cite(sg_cspa_2024_s2_1_corporate_service)).
activity_type(nominee_shareholder_for_listed_corporation, no_type, cite(sg_cspa_2024_s2_1_corporate_service)).
activity_type(designated_activity_with_accounting_service, designated_accounting, cite(sg_cspa_2024_s2_1_corporate_service)).
activity_type(acra_transaction_for_another, acra_transaction, cite(sg_cspa_2024_s2_1_corporate_service)).
activity_type(acra_transaction_as_secretary_of_companies, acra_transaction, cite(sg_cspa_2024_s2_1_corporate_service)).

activity_maps_to_type(Activity, ServiceType) :-
    implements(sg_cspa_2024_s2_1_corporate_service),
    activity_type(Activity, ServiceType, _Citation),
    ServiceType \= no_type.

any_activity_maps_to_type(Activities, ServiceType) :-
    implements(sg_cspa_2024_s2_1_corporate_service),
    findall(Activity, (member(Activity, Activities), activity_maps_to_type(Activity, ServiceType)), Matches),
    Matches \= [].

director_secretary_engaged(_Activities, true) :-
    implements(sg_cspa_2024_s2_1_nominee_director).
director_secretary_engaged(Activities, false) :-
    implements(sg_cspa_2024_s2_1_corporate_service),
    any_activity_maps_to_type(Activities, director_secretary).

engaged_type(Activities, _ArrangesNomineeDirector, formation) :-
    any_activity_maps_to_type(Activities, formation).
engaged_type(Activities, ArrangesNomineeDirector, director_secretary) :-
    director_secretary_engaged(Activities, ArrangesNomineeDirector).
engaged_type(Activities, _ArrangesNomineeDirector, address) :-
    any_activity_maps_to_type(Activities, address).
engaged_type(Activities, _ArrangesNomineeDirector, nominee_shareholder) :-
    any_activity_maps_to_type(Activities, nominee_shareholder).
engaged_type(Activities, _ArrangesNomineeDirector, designated_accounting) :-
    any_activity_maps_to_type(Activities, designated_accounting).
engaged_type(Activities, _ArrangesNomineeDirector, acra_transaction) :-
    any_activity_maps_to_type(Activities, acra_transaction).

engaged_types(Activities, ArrangesNomineeDirector, EngagedTypes) :-
    implements(sg_cspa_2024_s2_1_corporate_service),
    service_type_order(Order),
    findall(ServiceType, (member(ServiceType, Order), engaged_type(Activities, ArrangesNomineeDirector, ServiceType)), EngagedTypes).

required_keys_present(Profile, PresentCount) :-
    RequiredKeys = [activities, carries_on_business_in_singapore, registered_service_types],
    findall(RequiredKey, (member(RequiredKey, RequiredKeys), get(Profile, RequiredKey, _PresentValue)), PresentKeys),
    length(PresentKeys, PresentCount).

optional_bool_default(Profile, ProfileKey, DefaultValue, OptionalValue) :-
    get(Profile, ProfileKey, OptionalValue, DefaultValue).

actual_registration_status(ServiceType, RegisteredServiceTypes, covered) :-
    implements(sg_cspa_2024_s7_1),
    memberd(ServiceType, RegisteredServiceTypes).
actual_registration_status(ServiceType, RegisteredServiceTypes, not_covered) :-
    implements(sg_cspa_2024_s7_1),
    not_member(ServiceType, RegisteredServiceTypes).

deemed_registration_status(ServiceType, _IsAccountingEntity, _AccountingServiceIsOwn, _DeemedSuspended, not_covered) :-
    implements(sg_cspa_2024_s7_2),
    ServiceType \= designated_accounting.
deemed_registration_status(designated_accounting, false, _AccountingServiceIsOwn, _DeemedSuspended, not_covered) :-
    implements(sg_cspa_2024_s7_2).
deemed_registration_status(designated_accounting, true, false, _DeemedSuspended, not_covered) :-
    implements(sg_cspa_2024_s7_2).
deemed_registration_status(designated_accounting, true, true, true, not_covered) :-
    implements(sg_cspa_2024_s7_2).
deemed_registration_status(designated_accounting, true, true, false, covered) :-
    implements(sg_cspa_2024_s7_2).

type_not_covered(ServiceType, RegisteredServiceTypes, IsAccountingEntity, AccountingServiceIsOwn, DeemedSuspended) :-
    implements(sg_cspa_2024_s7_1),
    actual_registration_status(ServiceType, RegisteredServiceTypes, not_covered),
    deemed_registration_status(ServiceType, IsAccountingEntity, AccountingServiceIsOwn, DeemedSuspended, not_covered).

missing_types(EngagedTypes, RegisteredServiceTypes, IsAccountingEntity, AccountingServiceIsOwn, DeemedSuspended, MissingTypes) :-
    findall(ServiceType, (member(ServiceType, EngagedTypes), type_not_covered(ServiceType, RegisteredServiceTypes, IsAccountingEntity, AccountingServiceIsOwn, DeemedSuspended)), MissingTypes).

designated_accounting_deemed_covered(ServiceTypes, RegisteredServiceTypes, IsAccountingEntity, AccountingServiceIsOwn, DeemedSuspended, true) :-
    implements(sg_cspa_2024_s7_2),
    memberd(designated_accounting, ServiceTypes),
    actual_registration_status(designated_accounting, RegisteredServiceTypes, not_covered),
    deemed_registration_status(designated_accounting, IsAccountingEntity, AccountingServiceIsOwn, DeemedSuspended, covered).
designated_accounting_deemed_covered(ServiceTypes, _RegisteredServiceTypes, _IsAccountingEntity, _AccountingServiceIsOwn, _DeemedSuspended, false) :-
    implements(sg_cspa_2024_s7_2),
    not_member(designated_accounting, ServiceTypes).
designated_accounting_deemed_covered(ServiceTypes, RegisteredServiceTypes, _IsAccountingEntity, _AccountingServiceIsOwn, _DeemedSuspended, false) :-
    implements(sg_cspa_2024_s7_2),
    memberd(designated_accounting, ServiceTypes),
    actual_registration_status(designated_accounting, RegisteredServiceTypes, covered).
designated_accounting_deemed_covered(ServiceTypes, RegisteredServiceTypes, IsAccountingEntity, AccountingServiceIsOwn, DeemedSuspended, false) :-
    implements(sg_cspa_2024_s7_2),
    memberd(designated_accounting, ServiceTypes),
    actual_registration_status(designated_accounting, RegisteredServiceTypes, not_covered),
    deemed_registration_status(designated_accounting, IsAccountingEntity, AccountingServiceIsOwn, DeemedSuspended, not_covered).

nominee_duty_applies(true, ServiceTypes, MissingTypes, true) :-
    implements(sg_cspa_2024_s16_1),
    memberd(director_secretary, ServiceTypes),
    not_member(director_secretary, MissingTypes).
nominee_duty_applies(true, ServiceTypes, _MissingTypes, false) :-
    implements(sg_cspa_2024_s16_1),
    not_member(director_secretary, ServiceTypes).
nominee_duty_applies(true, ServiceTypes, MissingTypes, false) :-
    implements(sg_cspa_2024_s16_1),
    memberd(director_secretary, ServiceTypes),
    memberd(director_secretary, MissingTypes).
nominee_duty_applies(false, _ServiceTypes, _MissingTypes, false) :-
    implements(sg_cspa_2024_s16_1).

nominee_duty_value(false, _SatisfiedFitAndProper, _TookReasonableSteps, _ConsideredPrescribedFactors, not_applicable) :-
    implements(sg_cspa_2024_s16_1).
nominee_duty_value(true, true, true, true, complied) :-
    implements(sg_cspa_2024_s16_2).
nominee_duty_value(true, false, _TookReasonableSteps, _ConsideredPrescribedFactors, breached) :-
    implements(sg_cspa_2024_s16_2).
nominee_duty_value(true, true, false, _ConsideredPrescribedFactors, breached) :-
    implements(sg_cspa_2024_s16_2).
nominee_duty_value(true, true, true, false, breached) :-
    implements(sg_cspa_2024_s16_2).

nominee_duty(ArrangesNomineeDirector, ServiceTypes, MissingTypes, SatisfiedFitAndProper, TookReasonableSteps, ConsideredPrescribedFactors, NomineeDuty) :-
    nominee_duty_applies(ArrangesNomineeDirector, ServiceTypes, MissingTypes, Applies),
    nominee_duty_value(Applies, SatisfiedFitAndProper, TookReasonableSteps, ConsideredPrescribedFactors, NomineeDuty).

csp_citations_value(false, false, [sg_cspa_2024_s7_1]) :-
    implements(sg_cspa_2024_s7_1).
csp_citations_value(true, false, [sg_cspa_2024_s7_1, sg_cspa_2024_s7_2]) :-
    implements(sg_cspa_2024_s7_2).
csp_citations_value(false, true, [sg_cspa_2024_s7_1, sg_cspa_2024_s16_1, sg_cspa_2024_s16_2]) :-
    implements(sg_cspa_2024_s16_1).
csp_citations_value(true, true, [sg_cspa_2024_s7_1, sg_cspa_2024_s7_2, sg_cspa_2024_s16_1, sg_cspa_2024_s16_2]) :-
    implements(sg_cspa_2024_s16_1).

csp_citations(ServiceTypes, MissingTypes, RegisteredServiceTypes, IsAccountingEntity, AccountingServiceIsOwn, DeemedSuspended, ArrangesNomineeDirector, Citations) :-
    implements(sg_cspa_2024_s7_1),
    designated_accounting_deemed_covered(ServiceTypes, RegisteredServiceTypes, IsAccountingEntity, AccountingServiceIsOwn, DeemedSuspended, DeemedCovered),
    nominee_duty_applies(ArrangesNomineeDirector, ServiceTypes, MissingTypes, NomineeApplies),
    csp_citations_value(DeemedCovered, NomineeApplies, Citations).

csp_assessment_body(Profile, ServiceTypes, MissingTypes, NomineeDuty, Citations) :-
    implements(sg_cspa_2024_s7_1),
    required_keys_present(Profile, 3),
    get(Profile, activities, Activities),
    get(Profile, carries_on_business_in_singapore, true),
    get(Profile, registered_service_types, RegisteredServiceTypes),
    optional_bool_default(Profile, is_accounting_entity, false, IsAccountingEntity),
    optional_bool_default(Profile, accounting_service_is_own, true, AccountingServiceIsOwn),
    optional_bool_default(Profile, deemed_registration_suspended_or_cancelled, false, DeemedSuspended),
    optional_bool_default(Profile, arranges_nominee_director, false, ArrangesNomineeDirector),
    optional_bool_default(Profile, satisfied_nominee_fit_and_proper, false, SatisfiedFitAndProper),
    optional_bool_default(Profile, took_reasonable_steps_on_disqualification, false, TookReasonableSteps),
    optional_bool_default(Profile, considered_prescribed_factors, false, ConsideredPrescribedFactors),
    engaged_types(Activities, ArrangesNomineeDirector, ServiceTypes),
    ServiceTypes \= [],
    missing_types(ServiceTypes, RegisteredServiceTypes, IsAccountingEntity, AccountingServiceIsOwn, DeemedSuspended, MissingTypes),
    csp_citations(ServiceTypes, MissingTypes, RegisteredServiceTypes, IsAccountingEntity, AccountingServiceIsOwn, DeemedSuspended, ArrangesNomineeDirector, Citations),
    nominee_duty(ArrangesNomineeDirector, ServiceTypes, MissingTypes, SatisfiedFitAndProper, TookReasonableSteps, ConsideredPrescribedFactors, NomineeDuty).

csp_assessment(Profile, csp(indeterminate, [], [], n_a, [])) :-
    required_keys_present(Profile, PresentCount),
    PresentCount #< 3.
csp_assessment(Profile, csp(no_corporate_service, [], [], not_applicable, [sg_cspa_2024_s2_1_corporate_service])) :-
    implements(sg_cspa_2024_s2_1_corporate_service),
    required_keys_present(Profile, 3),
    get(Profile, activities, Activities),
    optional_bool_default(Profile, arranges_nominee_director, false, ArrangesNomineeDirector),
    engaged_types(Activities, ArrangesNomineeDirector, []).
csp_assessment(Profile, csp(not_carrying_on_business_in_singapore, ServiceTypes, [], not_applicable, [sg_cspa_2024_s7_1])) :-
    implements(sg_cspa_2024_s7_1),
    required_keys_present(Profile, 3),
    get(Profile, activities, Activities),
    get(Profile, carries_on_business_in_singapore, false),
    optional_bool_default(Profile, arranges_nominee_director, false, ArrangesNomineeDirector),
    engaged_types(Activities, ArrangesNomineeDirector, ServiceTypes),
    ServiceTypes \= [].
csp_assessment(Profile, csp(registered, ServiceTypes, [], NomineeDuty, Citations)) :-
    implements(sg_cspa_2024_s7_1),
    csp_assessment_body(Profile, ServiceTypes, [], NomineeDuty, Citations).
csp_assessment(Profile, csp(registration_required, ServiceTypes, MissingTypes, NomineeDuty, Citations)) :-
    implements(sg_cspa_2024_s7_1),
    csp_assessment_body(Profile, ServiceTypes, MissingTypes, NomineeDuty, Citations),
    MissingTypes \= [].

csp(Decision, ServiceTypes, MissingTypes, NomineeDuty, Citations) :-
    ground(Decision),
    ground(ServiceTypes),
    ground(MissingTypes),
    ground(NomineeDuty),
    ground(Citations),
    csp_decision_value(Decision),
    csp_nominee_duty_value(NomineeDuty),
    clausal_is_list(ServiceTypes),
    clausal_is_list(MissingTypes),
    clausal_is_list(Citations).

csp_decision_value(no_corporate_service).
csp_decision_value(not_carrying_on_business_in_singapore).
csp_decision_value(registered).
csp_decision_value(registration_required).
csp_decision_value(indeterminate).

csp_nominee_duty_value(complied).
csp_nominee_duty_value(breached).
csp_nominee_duty_value(not_applicable).
csp_nominee_duty_value(n_a).

decide_csp_registration(Profile, csp_registration_verdict(Decision, Citations)) :-
    csp_assessment(Profile, csp(Decision, _ServiceTypes, _MissingTypes, _NomineeDuty, Citations)).

csp_registration_status(Profile, Decision) :-
    csp_assessment(Profile, csp(Decision, _ServiceTypes, _MissingTypes, _NomineeDuty, _Citations)).

csp_registration_decision_resolvable(Profile) :-
    csp_assessment(Profile, _Result).

corporate_service_status(PresentCount, ServiceTypes, unmet) :-
    PresentCount #= 3,
    ServiceTypes == [].
corporate_service_status(PresentCount, ServiceTypes, met) :-
    PresentCount #= 3,
    ServiceTypes \= [].
corporate_service_status(PresentCount, _ServiceTypes, unknown) :-
    PresentCount #< 3.

carries_status(Profile, PresentCount, met) :-
    PresentCount #= 3,
    get(Profile, carries_on_business_in_singapore, true).
carries_status(Profile, PresentCount, unmet) :-
    PresentCount #= 3,
    get(Profile, carries_on_business_in_singapore, false).
carries_status(_Profile, PresentCount, unknown) :-
    PresentCount #< 3.

registration_coverage_status(PresentCount, ServiceTypes, _MissingTypes, inapplicable) :-
    PresentCount #= 3,
    ServiceTypes == [].
registration_coverage_status(PresentCount, ServiceTypes, MissingTypes, met) :-
    PresentCount #= 3,
    ServiceTypes \= [],
    MissingTypes == [].
registration_coverage_status(PresentCount, ServiceTypes, MissingTypes, unmet) :-
    PresentCount #= 3,
    ServiceTypes \= [],
    MissingTypes \= [].
registration_coverage_status(PresentCount, _ServiceTypes, _MissingTypes, unknown) :-
    PresentCount #< 3.

nominee_duty_status(n_a, unknown).
nominee_duty_status(not_applicable, inapplicable).
nominee_duty_status(complied, met).
nominee_duty_status(breached, unmet).

csp_registration_checklist(Profile, Items) :-
    csp_assessment(Profile, csp(_Decision, ServiceTypes, MissingTypes, NomineeDuty, _Citations)),
    required_keys_present(Profile, PresentCount),
    corporate_service_status(PresentCount, ServiceTypes, CorporateServiceStatus),
    carries_status(Profile, PresentCount, CarriesStatus),
    registration_coverage_status(PresentCount, ServiceTypes, MissingTypes, RegistrationStatus),
    nominee_duty_status(NomineeDuty, NomineeStatus),
    Items = [item(corporate_service_engaged, CorporateServiceStatus, cite(sg_cspa_2024_s2_1_corporate_service)), item(carries_on_business_in_singapore, CarriesStatus, cite(sg_cspa_2024_s7_1)), item(registration_coverage, RegistrationStatus, cite(sg_cspa_2024_s7_1)), item(nominee_director_duty, NomineeStatus, cite(sg_cspa_2024_s16_1))].

test(missing_activities_is_indeterminate) :-
    dict_pairs(Profile, [carries_on_business_in_singapore - true, registered_service_types - []]),
    csp_assessment(Profile, csp(indeterminate, [], [], n_a, [])).
test(missing_carries_is_indeterminate) :-
    dict_pairs(Profile, [activities - [], registered_service_types - []]),
    csp_assessment(Profile, csp(indeterminate, [], [], n_a, [])).
test(missing_registered_is_indeterminate) :-
    dict_pairs(Profile, [activities - [], carries_on_business_in_singapore - true]),
    csp_assessment(Profile, csp(indeterminate, [], [], n_a, [])).
test(no_engaged_type_is_no_corporate_service) :-
    dict_pairs(Profile, [activities - [], carries_on_business_in_singapore - true, registered_service_types - []]),
    csp_assessment(Profile, csp(no_corporate_service, [], [], not_applicable, [sg_cspa_2024_s2_1_corporate_service])).
test(carries_false_is_not_carrying_on_business) :-
    dict_pairs(Profile, [activities - [forms_legal_person_for_another], carries_on_business_in_singapore - false, registered_service_types - []]),
    csp_assessment(Profile, csp(not_carrying_on_business_in_singapore, [formation], [], not_applicable, [sg_cspa_2024_s7_1])).
test(actual_registration_covers_engaged_type) :-
    dict_pairs(Profile, [activities - [forms_legal_person_for_another], carries_on_business_in_singapore - true, registered_service_types - [formation]]),
    csp_assessment(Profile, csp(registered, [formation], [], not_applicable, [sg_cspa_2024_s7_1])).
test(unregistered_engaged_type_is_registration_required) :-
    dict_pairs(Profile, [activities - [forms_legal_person_for_another], carries_on_business_in_singapore - true, registered_service_types - []]),
    csp_assessment(Profile, csp(registration_required, [formation], [formation], not_applicable, [sg_cspa_2024_s7_1])).
test(deemed_registration_covers_own_accounting) :-
    dict_pairs(Profile, [activities - [designated_activity_with_accounting_service], carries_on_business_in_singapore - true, registered_service_types - [], is_accounting_entity - true, accounting_service_is_own - true, deemed_registration_suspended_or_cancelled - false]),
    csp_assessment(Profile, csp(registered, [designated_accounting], [], not_applicable, [sg_cspa_2024_s7_1, sg_cspa_2024_s7_2])).
test(deemed_registration_does_not_cover_other_accounting) :-
    dict_pairs(Profile, [activities - [designated_activity_with_accounting_service], carries_on_business_in_singapore - true, registered_service_types - [], is_accounting_entity - true, accounting_service_is_own - false]),
    csp_assessment(Profile, csp(registration_required, [designated_accounting], [designated_accounting], not_applicable, [sg_cspa_2024_s7_1])).
test(nominee_director_duty_complied) :-
    dict_pairs(Profile, [activities - [], carries_on_business_in_singapore - true, registered_service_types - [director_secretary], arranges_nominee_director - true, satisfied_nominee_fit_and_proper - true, took_reasonable_steps_on_disqualification - true, considered_prescribed_factors - true]),
    csp_assessment(Profile, csp(registered, [director_secretary], [], complied, [sg_cspa_2024_s7_1, sg_cspa_2024_s16_1, sg_cspa_2024_s16_2])).
test(nominee_director_duty_breached_when_not_satisfied) :-
    dict_pairs(Profile, [activities - [], carries_on_business_in_singapore - true, registered_service_types - [director_secretary], arranges_nominee_director - true, satisfied_nominee_fit_and_proper - false, took_reasonable_steps_on_disqualification - true, considered_prescribed_factors - true]),
    csp_assessment(Profile, csp(registered, [director_secretary], [], breached, [sg_cspa_2024_s7_1, sg_cspa_2024_s16_1, sg_cspa_2024_s16_2])).
test(nominee_director_duty_not_applicable_when_unregistered) :-
    dict_pairs(Profile, [activities - [], carries_on_business_in_singapore - true, registered_service_types - [], arranges_nominee_director - true]),
    csp_assessment(Profile, csp(registration_required, [director_secretary], [director_secretary], not_applicable, [sg_cspa_2024_s7_1])).
test(listed_nominee_shareholder_is_not_a_service) :-
    dict_pairs(Profile, [activities - [nominee_shareholder_for_listed_corporation], carries_on_business_in_singapore - true, registered_service_types - []]),
    csp_assessment(Profile, csp(no_corporate_service, [], [], not_applicable, [sg_cspa_2024_s2_1_corporate_service])).
test(unlisted_nominee_shareholder_is_a_service) :-
    dict_pairs(Profile, [activities - [nominee_shareholder_for_unlisted_corporation], carries_on_business_in_singapore - true, registered_service_types - []]),
    csp_assessment(Profile, csp(registration_required, [nominee_shareholder], [nominee_shareholder], not_applicable, [sg_cspa_2024_s7_1])).
test(service_types_are_in_limb_order) :-
    dict_pairs(Profile, [activities - [acra_transaction_for_another, forms_legal_person_for_another, provides_registered_office_or_address], carries_on_business_in_singapore - true, registered_service_types - []]),
    csp_assessment(Profile, csp(registration_required, [formation, address, acra_transaction], [formation, address, acra_transaction], not_applicable, [sg_cspa_2024_s7_1])).

test(the_wrong_indeterminate_is_rejected, fail) :-
    dict_pairs(Profile, [carries_on_business_in_singapore - true, registered_service_types - []]),
    csp_assessment(Profile, csp(no_corporate_service, [], [], not_applicable, [sg_cspa_2024_s2_1_corporate_service])).
