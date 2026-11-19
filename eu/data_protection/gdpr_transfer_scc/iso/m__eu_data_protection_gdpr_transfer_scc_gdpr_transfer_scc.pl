% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_transfer_scc_gdpr_transfer_scc, [standard_contractual_clauses_module/3, standard_contractual_clauses_availability/4, standard_contractual_clauses_safeguard/4, standard_contractual_clauses_appendix/3, decide_gdpr_transfer_scc/2, gdpr_transfer_scc_status/2, gdpr_transfer_scc_checklist/2, gdpr_transfer_scc_decision_resolvable/1, gdpr_transfer_scc_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(formalize_lib, [profile_get/3, profile_has/2, profile_lacks/2]).
:- use_module(m__eu_data_protection_gdpr_transfer_scc_kernel, [gdpr_transfer_scc_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_transfer_scc_citations, [implements/1]).

gdpr_transfer_scc_status_values([appropriate_safeguards_provided, appropriate_safeguards_not_provided]).

module_for_roles(controller, controller, module_one, cite(eu_dec_2021_914_annex_i)).
module_for_roles(controller, processor, module_two, cite(eu_dec_2021_914_annex_i)).
module_for_roles(processor, processor, module_three, cite(eu_dec_2021_914_annex_i)).
module_for_roles(processor, controller, module_four, cite(eu_dec_2021_914_annex_i)).

module_atom(module_one).
module_atom(module_two).
module_atom(module_three).
module_atom(module_four).

clause_14_application(module_one, _, applies, cite(eu_dec_2021_914_annex_cl_14_m1m2m3m4_t)).
clause_14_application(module_two, _, applies, cite(eu_dec_2021_914_annex_cl_14_m1m2m3m4_t)).
clause_14_application(module_three, _, applies, cite(eu_dec_2021_914_annex_cl_14_m1m2m3m4_t)).
clause_14_application(module_four, true, applies, cite(eu_dec_2021_914_annex_cl_14_m1m2m3m4_t)).
clause_14_application(module_four, false, does_not_apply, cite(eu_dec_2021_914_annex_cl_14_m1m2m3m4_t)).

authority_and_measures_requirement(module_one, required, cite(eu_dec_2021_914_annex_ii)).
authority_and_measures_requirement(module_two, required, cite(eu_dec_2021_914_annex_ii)).
authority_and_measures_requirement(module_three, required, cite(eu_dec_2021_914_annex_ii)).
authority_and_measures_requirement(module_four, not_required, cite(eu_dec_2021_914_annex_ii)).

sub_processor_list_requirement(module_one, not_required, cite(eu_dec_2021_914_annex_iii)).
sub_processor_list_requirement(module_two, option_dependent, cite(eu_dec_2021_914_annex_cl_9_m2_a)).
sub_processor_list_requirement(module_three, option_dependent, cite(eu_dec_2021_914_annex_cl_9_m3_a)).
sub_processor_list_requirement(module_four, not_required, cite(eu_dec_2021_914_annex_iii)).

query_keys(module, [exporter_role, importer_role]).
query_keys(availability, [standard_contractual_clauses_decision_in_force, exporter_processing_subject_to_gdpr, importer_processing_subject_to_gdpr]).
query_keys(safeguard, [standard_contractual_clauses_decision_in_force, exporter_processing_subject_to_gdpr, importer_processing_subject_to_gdpr, no_reason_to_believe_local_laws_prevent_compliance, exporter_role, importer_role, standard_contractual_clauses_concluded, module_selected, clauses_modified, added_clauses_contradict_clauses, local_laws_assessment_documented, processor_combines_received_data_with_data_collected_in_union]).
query_keys(appendix, [exporter_role, importer_role, annex_i_a_list_of_parties_completed, annex_i_b_description_of_transfer_completed, annex_i_c_competent_supervisory_authority_identified, annex_ii_measures_described_in_specific_terms, sub_processor_authorisation_option, annex_iii_list_of_sub_processors_completed]).

query_citations(module, [cite(eu_dec_2021_914_art_1), cite(eu_dec_2021_914_annex_i)]).
query_citations(availability, [cite(eu_dec_2021_914_art_1)]).
query_citations(safeguard, [cite(eu_dec_2021_914_art_1), cite(eu_dec_2021_914_annex_cl_1_b), cite(eu_dec_2021_914_annex_cl_1_b_i), cite(eu_dec_2021_914_annex_cl_1_b_ii), cite(eu_dec_2021_914_annex_cl_2_a), cite(eu_dec_2021_914_annex_cl_14_m1m2m3m4_t), cite(eu_dec_2021_914_annex_cl_14_m1m2m3m4_a), cite(eu_dec_2021_914_annex_cl_14_m1m2m3m4_b), cite(eu_dec_2021_914_annex_cl_14_m1m2m3m4_b_i), cite(eu_dec_2021_914_annex_cl_14_m1m2m3m4_b_ii), cite(eu_dec_2021_914_annex_cl_14_m1m2m3m4_b_iii), cite(eu_dec_2021_914_annex_cl_14_m1m2m3m4_d), cite(eu_reg_2016_679_art_46_2_c)]).
query_citations(appendix, [cite(eu_dec_2021_914_art_1), cite(eu_dec_2021_914_annex_cl_1_d), cite(eu_dec_2021_914_appendix), cite(eu_dec_2021_914_annex_i), cite(eu_dec_2021_914_annex_ii), cite(eu_dec_2021_914_annex_iii), cite(eu_dec_2021_914_annex_cl_9_m2_a), cite(eu_dec_2021_914_annex_cl_9_m3_a)]).

key_kind(standard_contractual_clauses_decision_in_force, outside_fact).
key_kind(exporter_processing_subject_to_gdpr, outside_fact).
key_kind(importer_processing_subject_to_gdpr, outside_fact).
key_kind(no_reason_to_believe_local_laws_prevent_compliance, outside_fact).
key_kind(exporter_role, plain).
key_kind(importer_role, plain).
key_kind(standard_contractual_clauses_concluded, plain).
key_kind(module_selected, plain).
key_kind(clauses_modified, plain).
key_kind(added_clauses_contradict_clauses, judgement).
key_kind(local_laws_assessment_documented, plain).
key_kind(processor_combines_received_data_with_data_collected_in_union, plain).
key_kind(annex_i_a_list_of_parties_completed, plain).
key_kind(annex_i_b_description_of_transfer_completed, plain).
key_kind(annex_i_c_competent_supervisory_authority_identified, plain).
key_kind(annex_ii_measures_described_in_specific_terms, judgement).
key_kind(sub_processor_authorisation_option, plain).
key_kind(annex_iii_list_of_sub_processors_completed, plain).

key_domain(standard_contractual_clauses_decision_in_force, [true, false]).
key_domain(exporter_processing_subject_to_gdpr, [true, false]).
key_domain(importer_processing_subject_to_gdpr, [true, false]).
key_domain(no_reason_to_believe_local_laws_prevent_compliance, [true, false]).
key_domain(exporter_role, [controller, processor]).
key_domain(importer_role, [controller, processor]).
key_domain(standard_contractual_clauses_concluded, [true, false]).
key_domain(module_selected, [module_one, module_two, module_three, module_four]).
key_domain(clauses_modified, [true, false]).
key_domain(added_clauses_contradict_clauses, [true, false]).
key_domain(local_laws_assessment_documented, [true, false]).
key_domain(processor_combines_received_data_with_data_collected_in_union, [true, false]).
key_domain(annex_i_a_list_of_parties_completed, [true, false]).
key_domain(annex_i_b_description_of_transfer_completed, [true, false]).
key_domain(annex_i_c_competent_supervisory_authority_identified, [true, false]).
key_domain(annex_ii_measures_described_in_specific_terms, [true, false]).
key_domain(sub_processor_authorisation_option, [specific_prior_authorisation, general_written_authorisation]).
key_domain(annex_iii_list_of_sub_processors_completed, [true, false]).

outside_fact_referral(standard_contractual_clauses_decision_in_force, cite(eu_dec_2021_914_art_1), cite(standard_contractual_clauses_decision_in_force_statement)).
outside_fact_referral(exporter_processing_subject_to_gdpr, cite(eu_dec_2021_914_art_1), cite(exporter_subject_to_gdpr_statement)).
outside_fact_referral(importer_processing_subject_to_gdpr, cite(eu_dec_2021_914_art_1), cite(importer_subject_to_gdpr_statement)).
outside_fact_referral(no_reason_to_believe_local_laws_prevent_compliance, cite(eu_dec_2021_914_annex_cl_14_m1m2m3m4_a), cite(local_laws_assessment_outcome_statement)).

open_textured_referral(added_clauses_contradict_clauses, cite(eu_dec_2021_914_annex_cl_2_a)).
open_textured_referral(annex_ii_measures_described_in_specific_terms, cite(eu_dec_2021_914_annex_ii)).

final_result(module, Values, Result) :-
    module_route(Values, Result).
final_result(availability, Values, Result) :-
    availability_route(Values, Result).
final_result(safeguard, Values, Result) :-
    safeguard_route(Values, Result).
final_result(appendix, Values, Result) :-
    appendix_route(Values, Result).

module_route([ExporterRole, ImporterRole], Module) :-
    implements(eu_dec_2021_914_annex_i),
    module_for_roles(ExporterRole, ImporterRole, Module, _Citation).

availability_route([false, _, _], clauses_not_available) :-
    implements(eu_dec_2021_914_art_1).
availability_route([true, false, _], clauses_not_available) :-
    implements(eu_dec_2021_914_art_1).
availability_route([true, true, true], clauses_not_available) :-
    implements(eu_dec_2021_914_art_1).
availability_route([true, true, false], clauses_available) :-
    implements(eu_dec_2021_914_art_1).

safeguard_route([false, _, _, _, _, _, _, _, _, _, _, _], appropriate_safeguards_not_provided) :-
    implements(eu_dec_2021_914_art_1).
safeguard_route([true, false, _, _, _, _, _, _, _, _, _, _], appropriate_safeguards_not_provided) :-
    implements(eu_dec_2021_914_art_1).
safeguard_route([true, true, true, _, _, _, _, _, _, _, _, _], appropriate_safeguards_not_provided) :-
    implements(eu_dec_2021_914_art_1).
safeguard_route([true, true, false, _, _, _, false, _, _, _, _, _], appropriate_safeguards_not_provided) :-
    implements(eu_dec_2021_914_annex_cl_1_b).
safeguard_route([true, true, false, NoReason, ExporterRole, ImporterRole, true, ModuleSelected, Modified, AddedContradict, Documented, Combines], Result) :-
    implements(eu_dec_2021_914_annex_cl_1_b),
    module_for_roles(ExporterRole, ImporterRole, Module, _Citation),
    module_selection(Module, ModuleSelected, Selection),
    selection_route(Selection, Module, NoReason, Modified, AddedContradict, Documented, Combines, Result).

module_selection(Module, Module, matching) :-
    implements(eu_dec_2021_914_annex_cl_2_a).
module_selection(Module, Selected, not_matching) :-
    implements(eu_dec_2021_914_annex_cl_2_a),
    module_atom(Selected),
    dif(Module, Selected).

selection_route(not_matching, _, _, _, _, _, _, appropriate_safeguards_not_provided) :-
    implements(eu_dec_2021_914_annex_cl_2_a).
selection_route(matching, Module, NoReason, Modified, AddedContradict, Documented, Combines, Result) :-
    implements(eu_dec_2021_914_annex_cl_2_a),
    modification_route(Modified, AddedContradict, Module, NoReason, Documented, Combines, Result).

modification_route(true, _, _, _, _, _, appropriate_safeguards_not_provided) :-
    implements(eu_dec_2021_914_annex_cl_2_a).
modification_route(false, true, _, _, _, _, appropriate_safeguards_not_provided) :-
    implements(eu_dec_2021_914_annex_cl_2_a).
modification_route(false, false, Module, NoReason, Documented, Combines, Result) :-
    implements(eu_dec_2021_914_annex_cl_2_a),
    clause_14_applies(Module, Combines, Application),
    clause_14_route(Application, NoReason, Documented, Result).

clause_14_applies(Module, Combines, Application) :-
    implements(eu_dec_2021_914_annex_cl_14_m1m2m3m4_t),
    clause_14_application(Module, Combines, Application, _Citation).

clause_14_route(does_not_apply, _, _, appropriate_safeguards_provided) :-
    implements(eu_dec_2021_914_annex_cl_14_m1m2m3m4_t).
clause_14_route(applies, false, _, appropriate_safeguards_not_provided) :-
    implements(eu_dec_2021_914_annex_cl_14_m1m2m3m4_a).
clause_14_route(applies, true, false, appropriate_safeguards_not_provided) :-
    implements(eu_dec_2021_914_annex_cl_14_m1m2m3m4_d).
clause_14_route(applies, true, true, appropriate_safeguards_provided) :-
    implements(eu_dec_2021_914_annex_cl_14_m1m2m3m4_d).

appendix_route([ExporterRole, ImporterRole, ListOfParties, Description, Authority, Measures, Option, SubProcessors], Result) :-
    implements(eu_dec_2021_914_annex_cl_1_d),
    module_for_roles(ExporterRole, ImporterRole, Module, _Citation),
    annex_i_route(ListOfParties, Description, Module, Authority, Measures, Option, SubProcessors, Result).

annex_i_route(false, _, _, _, _, _, _, appendix_incomplete) :-
    implements(eu_dec_2021_914_annex_i).
annex_i_route(true, false, _, _, _, _, _, appendix_incomplete) :-
    implements(eu_dec_2021_914_annex_i).
annex_i_route(true, true, Module, Authority, Measures, Option, SubProcessors, Result) :-
    implements(eu_dec_2021_914_annex_i),
    authority_and_measures_requirement(Module, Requirement, _Citation),
    authority_route(Requirement, Module, Authority, Measures, Option, SubProcessors, Result).

authority_route(not_required, Module, _, _, Option, SubProcessors, Result) :-
    implements(eu_dec_2021_914_annex_i),
    sub_processor_route(Module, Option, SubProcessors, Result).
authority_route(required, _, false, _, _, _, appendix_incomplete) :-
    implements(eu_dec_2021_914_annex_i).
authority_route(required, _, true, false, _, _, appendix_incomplete) :-
    implements(eu_dec_2021_914_annex_ii).
authority_route(required, Module, true, true, Option, SubProcessors, Result) :-
    implements(eu_dec_2021_914_annex_ii),
    sub_processor_route(Module, Option, SubProcessors, Result).

sub_processor_route(Module, Option, SubProcessors, Result) :-
    implements(eu_dec_2021_914_annex_iii),
    sub_processor_list_requirement(Module, Requirement, _Citation),
    sub_processor_requirement_route(Requirement, Option, SubProcessors, Result).

sub_processor_requirement_route(not_required, _, _, appendix_complete) :-
    implements(eu_dec_2021_914_annex_iii).
sub_processor_requirement_route(option_dependent, general_written_authorisation, _, appendix_complete) :-
    implements(eu_dec_2021_914_annex_cl_9_m2_a).
sub_processor_requirement_route(option_dependent, specific_prior_authorisation, false, appendix_incomplete) :-
    implements(eu_dec_2021_914_annex_iii).
sub_processor_requirement_route(option_dependent, specific_prior_authorisation, true, appendix_complete) :-
    implements(eu_dec_2021_914_annex_iii).

key_reading(Profile, Key, present(Value)) :-
    profile_has(Profile, Key),
    profile_get(Profile, Key, Value).
key_reading(Profile, Key, absent) :-
    profile_lacks(Profile, Key).

key_readings([], _, []).
key_readings([Key|Keys], Profile, [Key - Reading|Readings]) :-
    key_reading(Profile, Key, Reading),
    key_readings(Keys, Profile, Readings).

completion_values([], []).
completion_values([Key - Reading|Readings], [Value|Values]) :-
    key_kind(Key, Kind),
    completion_value(Kind, Reading, Value),
    completion_values(Readings, Values).

completion_value(outside_fact, present(attested(Value, _)), Value).
completion_value(outside_fact, absent, _Free).
completion_value(judgement, present(true), true).
completion_value(judgement, present(false), false).
completion_value(judgement, present(unsure), _Free).
completion_value(judgement, absent, _Free).
completion_value(plain, present(Value), Value).
completion_value(plain, absent, _Free).

absent_keys([], []).
absent_keys([Key - absent|Readings], [Key|Keys]) :-
    absent_keys(Readings, Keys).
absent_keys([_ - present(_)|Readings], Keys) :-
    absent_keys(Readings, Keys).

unsure_keys([], []).
unsure_keys([Key - present(unsure)|Readings], [Key|Keys]) :-
    unsure_keys(Readings, Keys).
unsure_keys([_ - present(Value)|Readings], Keys) :-
    dif(Value, unsure),
    unsure_keys(Readings, Keys).
unsure_keys([_ - absent|Readings], Keys) :-
    unsure_keys(Readings, Keys).

outside_fact_keys([], []).
outside_fact_keys([Key|Keys], Selected) :-
    key_kind(Key, Kind),
    keep_outside_fact(Kind, Key, Rest, Selected),
    outside_fact_keys(Keys, Rest).

keep_outside_fact(outside_fact, Key, Rest, [Key|Rest]).
keep_outside_fact(plain, _, Rest, Rest).
keep_outside_fact(judgement, _, Rest, Rest).

caller_value_keys([], []).
caller_value_keys([Key|Keys], Selected) :-
    key_kind(Key, Kind),
    keep_caller_value(Kind, Key, Rest, Selected),
    caller_value_keys(Keys, Rest).

keep_caller_value(outside_fact, _, Rest, Rest).
keep_caller_value(plain, Key, Rest, [Key|Rest]).
keep_caller_value(judgement, Key, Rest, [Key|Rest]).

replace_value([], [], _, _, []).
replace_value([Key|Keys], [_|Values], Key, NewValue, [NewValue|NewValues]) :-
    replace_value(Keys, Values, Key, NewValue, NewValues).
replace_value([Other|Keys], [Value|Values], Key, NewValue, [Value|NewValues]) :-
    dif(Other, Key),
    replace_value(Keys, Values, Key, NewValue, NewValues).

list_has_members_t([], false).
list_has_members_t([_|_], true).

determination(Query, Profile, Answer) :-
    query_keys(Query, Keys),
    key_readings(Keys, Profile, Readings),
    completion_values(Readings, Values),
    findall(Result, final_result(Query, Values, Result), Results),
    sort(Results, DistinctResults),
    settled_or_open(DistinctResults, Query, Keys, Readings, Values, Answer).

settled_or_open([Result], _, _, _, _, settled(Result)).
settled_or_open([_, _|_], Query, Keys, Readings, Values, Answer) :-
    absent_keys(Readings, AbsentKeys),
    outside_fact_keys(AbsentKeys, AbsentOutsideFacts),
    first_mattering(AbsentOutsideFacts, Query, Keys, Values, OutsideFound),
    after_outside_facts(OutsideFound, Query, Keys, Readings, Values, AbsentKeys, Answer).

after_outside_facts(found(Key), _, _, _, _, _, referral(Key)).
after_outside_facts(none, Query, Keys, Readings, Values, AbsentKeys, Answer) :-
    mattering_keys(AbsentKeys, Query, Keys, Values, MatteringKeys),
    caller_value_keys(MatteringKeys, Candidates),
    first_unblocked(Candidates, MatteringKeys, Query, Keys, Values, MissingFound),
    after_missing_keys(MissingFound, Query, Keys, Readings, Values, Answer).

after_missing_keys(found(Key), _, _, _, _, missing(Key)).
after_missing_keys(none, Query, Keys, Readings, Values, Answer) :-
    unsure_keys(Readings, UnsureKeys),
    first_mattering(UnsureKeys, Query, Keys, Values, UnsureFound),
    after_unsure(UnsureFound, Answer).

after_unsure(found(Key), open(Key)).

matters_t(Query, Keys, Values, Key, Matters) :-
    replace_value(Keys, Values, Key, _FirstValue, FirstValues),
    replace_value(Keys, Values, Key, _SecondValue, SecondValues),
    findall(witness, differing_results(Query, FirstValues, SecondValues), Witnesses),
    list_has_members_t(Witnesses, Matters).

differing_results(Query, FirstValues, SecondValues) :-
    final_result(Query, FirstValues, FirstResult),
    final_result(Query, SecondValues, SecondResult),
    dif(FirstResult, SecondResult).

first_mattering([], _, _, _, none).
first_mattering([Key|Keys], Query, AllKeys, Values, Found) :-
    matters_t(Query, AllKeys, Values, Key, Matters),
    first_mattering_continue(Matters, Key, Keys, Query, AllKeys, Values, Found).

first_mattering_continue(true, Key, _, _, _, _, found(Key)).
first_mattering_continue(false, _, Keys, Query, AllKeys, Values, Found) :-
    first_mattering(Keys, Query, AllKeys, Values, Found).

mattering_keys([], _, _, _, []).
mattering_keys([Key|Keys], Query, AllKeys, Values, Mattering) :-
    matters_t(Query, AllKeys, Values, Key, Matters),
    keep_when(Matters, Key, Rest, Mattering),
    mattering_keys(Keys, Query, AllKeys, Values, Rest).

keep_when(true, Key, Rest, [Key|Rest]).
keep_when(false, _, Rest, Rest).

first_unblocked([], _, _, _, _, none).
first_unblocked([Key|Keys], Mattering, Query, AllKeys, Values, Found) :-
    blocked_t(Mattering, Key, Query, AllKeys, Values, Blocked),
    first_unblocked_continue(Blocked, Key, Keys, Mattering, Query, AllKeys, Values, Found).

first_unblocked_continue(false, Key, _, _, _, _, _, found(Key)).
first_unblocked_continue(true, _, Keys, Mattering, Query, AllKeys, Values, Found) :-
    first_unblocked(Keys, Mattering, Query, AllKeys, Values, Found).

blocked_t([], _, _, _, _, false).
blocked_t([Key|Others], Key, Query, AllKeys, Values, Blocked) :-
    blocked_t(Others, Key, Query, AllKeys, Values, Blocked).
blocked_t([Other|Others], Key, Query, AllKeys, Values, Blocked) :-
    dif(Other, Key),
    behind_t(Key, Other, Query, AllKeys, Values, Behind),
    blocked_continue(Behind, Others, Key, Query, AllKeys, Values, Blocked).

blocked_continue(true, _, _, _, _, _, true).
blocked_continue(false, Others, Key, Query, AllKeys, Values, Blocked) :-
    blocked_t(Others, Key, Query, AllKeys, Values, Blocked).

behind_t(Key, Other, Query, AllKeys, Values, Behind) :-
    key_domain(Other, OtherDomain),
    some_value_silences_t(OtherDomain, Other, Key, Query, AllKeys, Values, Silences),
    behind_second_test(Silences, Key, Other, Query, AllKeys, Values, Behind).

behind_second_test(false, _, _, _, _, _, false).
behind_second_test(true, Key, Other, Query, AllKeys, Values, Behind) :-
    key_domain(Key, KeyDomain),
    every_value_keeps_t(KeyDomain, Key, Other, Query, AllKeys, Values, Behind).

some_value_silences_t([], _, _, _, _, _, false).
some_value_silences_t([OtherValue|OtherValues], Other, Key, Query, AllKeys, Values, Silences) :-
    replace_value(AllKeys, Values, Other, OtherValue, FixedValues),
    matters_t(Query, AllKeys, FixedValues, Key, Matters),
    silences_continue(Matters, OtherValues, Other, Key, Query, AllKeys, Values, Silences).

silences_continue(false, _, _, _, _, _, _, true).
silences_continue(true, OtherValues, Other, Key, Query, AllKeys, Values, Silences) :-
    some_value_silences_t(OtherValues, Other, Key, Query, AllKeys, Values, Silences).

every_value_keeps_t([], _, _, _, _, _, true).
every_value_keeps_t([KeyValue|KeyValues], Key, Other, Query, AllKeys, Values, Keeps) :-
    replace_value(AllKeys, Values, Key, KeyValue, FixedValues),
    matters_t(Query, AllKeys, FixedValues, Other, Matters),
    keeps_continue(Matters, KeyValues, Key, Other, Query, AllKeys, Values, Keeps).

keeps_continue(false, _, _, _, _, _, _, false).
keeps_continue(true, KeyValues, Key, Other, Query, AllKeys, Values, Keeps) :-
    every_value_keeps_t(KeyValues, Key, Other, Query, AllKeys, Values, Keeps).

query_answer([Problem|Problems], _, _, input_problems([Problem|Problems]), [], []).
query_answer([], Query, Profile, Result, Basis, Citations) :-
    determination(Query, Profile, Answer),
    answer_terms(Answer, Query, Profile, Result, Basis, Citations).

answer_terms(settled(Result), Query, Profile, Result, Basis, Citations) :-
    query_keys(Query, Keys),
    basis_items(Keys, Profile, Basis),
    query_citations(Query, Citations).
answer_terms(referral(Key), _, _, needs_legal_review(cross_reference_unresolved(Citation, Target), [resolution(Target, not_attempted), inputs_relied_on([Key - absent])]), [], []) :-
    outside_fact_referral(Key, Citation, Target).
answer_terms(missing(Key), _, _, indeterminate([Key]), [], []).
answer_terms(open(Key), Query, Profile, needs_legal_review(open_textured(Key, Citation), [inputs_relied_on(Pairs)]), [], []) :-
    open_textured_referral(Key, Citation),
    query_keys(Query, Keys),
    judgement_pairs(Keys, Profile, Pairs).

basis_items([], _, []).
basis_items([Key|Keys], Profile, Basis) :-
    key_kind(Key, Kind),
    key_reading(Profile, Key, Reading),
    basis_item(Kind, Reading, Key, Rest, Basis),
    basis_items(Keys, Profile, Rest).

basis_item(outside_fact, present(Attested), Key, Rest, [outside_fact(Key, Attested)|Rest]).
basis_item(outside_fact, absent, _, Rest, Rest).
basis_item(plain, _, _, Rest, Rest).
basis_item(judgement, _, _, Rest, Rest).

judgement_pairs([], _, []).
judgement_pairs([Key|Keys], Profile, Pairs) :-
    key_kind(Key, Kind),
    key_reading(Profile, Key, Reading),
    judgement_pair(Kind, Reading, Key, Rest, Pairs),
    judgement_pairs(Keys, Profile, Rest).

judgement_pair(judgement, present(Value), Key, Rest, [Key - Value|Rest]).
judgement_pair(judgement, absent, _, Rest, Rest).
judgement_pair(outside_fact, _, _, Rest, Rest).
judgement_pair(plain, _, _, Rest, Rest).

standard_contractual_clauses_module(Profile, Result, Citations) :-
    implements(eu_dec_2021_914_annex_i),
    gdpr_transfer_scc_input_problems(Profile, Problems),
    query_answer(Problems, module, Profile, Result, _Basis, Citations).

standard_contractual_clauses_availability(Profile, Result, Basis, Citations) :-
    implements(eu_dec_2021_914_art_1),
    gdpr_transfer_scc_input_problems(Profile, Problems),
    query_answer(Problems, availability, Profile, Result, Basis, Citations).

standard_contractual_clauses_safeguard(Profile, Result, Basis, Citations) :-
    implements(eu_reg_2016_679_art_46_2_c),
    gdpr_transfer_scc_input_problems(Profile, Problems),
    query_answer(Problems, safeguard, Profile, Result, Basis, Citations).

standard_contractual_clauses_appendix(Profile, Result, Citations) :-
    implements(eu_dec_2021_914_annex_cl_1_d),
    gdpr_transfer_scc_input_problems(Profile, Problems),
    query_answer(Problems, appendix, Profile, Result, _Basis, Citations).

decide_gdpr_transfer_scc(Profile, gdpr_transfer_scc_verdict(Status, Citations)) :-
    standard_contractual_clauses_safeguard(Profile, Status, _Basis, Citations).

gdpr_transfer_scc_status(Profile, Status) :-
    decide_gdpr_transfer_scc(Profile, gdpr_transfer_scc_verdict(Status, _Citations)).

gdpr_transfer_scc_decision_resolvable(Profile) :-
    decide_gdpr_transfer_scc(Profile, _Verdict).

gdpr_transfer_scc_checklist(Profile, Items) :-
    gdpr_transfer_scc_input_problems(Profile, Problems),
    checklist_for(Problems, Profile, Items).

checklist_for([Problem|Problems], _, [item(input_check, unmet(input_problems([Problem|Problems])), cite(eu_dec_2021_914_art_1))]).
checklist_for([], Profile, Items) :-
    checklist_requirements(Identifiers),
    requirement_items(Identifiers, Profile, Items).

checklist_requirements([decision_in_force, exporter_processing_subject_to_regulation, importer_processing_outside_regulation, clauses_concluded, module_selected_fits_roles, clauses_not_modified, added_clauses_do_not_contradict, clause_14_warranty_given, clause_14_assessment_documented]).

requirement_items([], _, []).
requirement_items([Identifier|Identifiers], Profile, [Item|Items]) :-
    requirement_item(Profile, Identifier, Item),
    requirement_items(Identifiers, Profile, Items).

requirement_item(Profile, decision_in_force, Item) :-
    implements(eu_dec_2021_914_art_1),
    boolean_item(Profile, decision_in_force, standard_contractual_clauses_decision_in_force, true, cite(eu_dec_2021_914_art_1), Item).
requirement_item(Profile, exporter_processing_subject_to_regulation, Item) :-
    implements(eu_dec_2021_914_art_1),
    boolean_item(Profile, exporter_processing_subject_to_regulation, exporter_processing_subject_to_gdpr, true, cite(eu_dec_2021_914_art_1), Item).
requirement_item(Profile, importer_processing_outside_regulation, Item) :-
    implements(eu_dec_2021_914_art_1),
    boolean_item(Profile, importer_processing_outside_regulation, importer_processing_subject_to_gdpr, false, cite(eu_dec_2021_914_art_1), Item).
requirement_item(Profile, clauses_concluded, Item) :-
    implements(eu_dec_2021_914_annex_cl_1_b),
    boolean_item(Profile, clauses_concluded, standard_contractual_clauses_concluded, true, cite(eu_dec_2021_914_annex_cl_1_b), Item).
requirement_item(Profile, module_selected_fits_roles, item(module_selected_fits_roles, Status, cite(eu_dec_2021_914_annex_cl_2_a))) :-
    implements(eu_dec_2021_914_annex_cl_2_a),
    checklist_value(Profile, exporter_role, ExporterRole),
    checklist_value(Profile, importer_role, ImporterRole),
    checklist_value(Profile, module_selected, ModuleSelected),
    module_fit_status(ExporterRole, ImporterRole, ModuleSelected, Status).
requirement_item(Profile, clauses_not_modified, Item) :-
    implements(eu_dec_2021_914_annex_cl_2_a),
    boolean_item(Profile, clauses_not_modified, clauses_modified, false, cite(eu_dec_2021_914_annex_cl_2_a), Item).
requirement_item(Profile, added_clauses_do_not_contradict, Item) :-
    implements(eu_dec_2021_914_annex_cl_2_a),
    boolean_item(Profile, added_clauses_do_not_contradict, added_clauses_contradict_clauses, false, cite(eu_dec_2021_914_annex_cl_2_a), Item).
requirement_item(Profile, clause_14_warranty_given, item(clause_14_warranty_given, Status, cite(eu_dec_2021_914_annex_cl_14_m1m2m3m4_a))) :-
    implements(eu_dec_2021_914_annex_cl_14_m1m2m3m4_a),
    clause_14_checklist_application(Profile, Application),
    checklist_value(Profile, no_reason_to_believe_local_laws_prevent_compliance, Value),
    clause_14_item_status(Application, Value, no_reason_to_believe_local_laws_prevent_compliance, Status).
requirement_item(Profile, clause_14_assessment_documented, item(clause_14_assessment_documented, Status, cite(eu_dec_2021_914_annex_cl_14_m1m2m3m4_d))) :-
    implements(eu_dec_2021_914_annex_cl_14_m1m2m3m4_d),
    clause_14_checklist_application(Profile, Application),
    checklist_value(Profile, local_laws_assessment_documented, Value),
    clause_14_item_status(Application, Value, local_laws_assessment_documented, Status).

boolean_item(Profile, Identifier, Key, Wanted, Citation, item(Identifier, Status, Citation)) :-
    checklist_value(Profile, Key, Value),
    value_status(Value, Wanted, Key, Status).

checklist_value(Profile, Key, Value) :-
    key_kind(Key, Kind),
    key_reading(Profile, Key, Reading),
    reading_value(Kind, Reading, Value).

reading_value(outside_fact, absent, absent).
reading_value(plain, absent, absent).
reading_value(judgement, absent, absent).
reading_value(outside_fact, present(attested(Value, _)), Value).
reading_value(plain, present(Value), Value).
reading_value(judgement, present(Value), Value).

boolean_value(true).
boolean_value(false).

value_status(absent, _, Key, unknown([Key])).
value_status(unsure, _, Key, unknown([Key])).
value_status(Wanted, Wanted, _, met).
value_status(Value, Wanted, Key, unmet(Key)) :-
    boolean_value(Value),
    dif(Value, Wanted).

module_fit_status(absent, _, _, unknown([exporter_role])).
module_fit_status(ExporterRole, absent, _, unknown([importer_role])) :-
    dif(ExporterRole, absent).
module_fit_status(ExporterRole, ImporterRole, absent, unknown([module_selected])) :-
    dif(ExporterRole, absent),
    dif(ImporterRole, absent).
module_fit_status(ExporterRole, ImporterRole, ModuleSelected, Status) :-
    dif(ExporterRole, absent),
    dif(ImporterRole, absent),
    dif(ModuleSelected, absent),
    module_for_roles(ExporterRole, ImporterRole, Module, _Citation),
    fit_status(Module, ModuleSelected, Status).

fit_status(Module, Module, met).
fit_status(Module, ModuleSelected, unmet(module_selected)) :-
    dif(Module, ModuleSelected).

clause_14_checklist_application(Profile, Application) :-
    implements(eu_dec_2021_914_annex_cl_14_m1m2m3m4_t),
    checklist_value(Profile, exporter_role, ExporterRole),
    checklist_value(Profile, importer_role, ImporterRole),
    checklist_value(Profile, processor_combines_received_data_with_data_collected_in_union, Combines),
    application_of(ExporterRole, ImporterRole, Combines, Application).

application_of(absent, _, _, unknown(exporter_role)).
application_of(ExporterRole, absent, _, unknown(importer_role)) :-
    dif(ExporterRole, absent).
application_of(ExporterRole, ImporterRole, Combines, Application) :-
    dif(ExporterRole, absent),
    dif(ImporterRole, absent),
    module_for_roles(ExporterRole, ImporterRole, Module, _Citation),
    module_application(Module, Combines, Application).

module_application(Module, Combines, Application) :-
    clause_14_application(Module, Combines, Application, _Citation).
module_application(module_four, absent, unknown(processor_combines_received_data_with_data_collected_in_union)).

clause_14_item_status(applies, Value, Key, Status) :-
    value_status(Value, true, Key, Status).
clause_14_item_status(does_not_apply, _, _, inapplicable).
clause_14_item_status(unknown(Missing), _, _, unknown([Missing])).

test_attested(Value, attested(Value, attestation(host, received_at, reason, none))).

safeguard_profile(ModuleSelected, AddedContradict, [attribute(standard_contractual_clauses_decision_in_force, InForce), attribute(exporter_processing_subject_to_gdpr, ExporterSubject), attribute(importer_processing_subject_to_gdpr, ImporterSubject), attribute(no_reason_to_believe_local_laws_prevent_compliance, NoReason), attribute(exporter_role, controller), attribute(importer_role, processor), attribute(standard_contractual_clauses_concluded, true), attribute(module_selected, ModuleSelected), attribute(clauses_modified, false), attribute(added_clauses_contradict_clauses, AddedContradict), attribute(local_laws_assessment_documented, true)]) :-
    test_attested(true, InForce),
    test_attested(true, ExporterSubject),
    test_attested(false, ImporterSubject),
    test_attested(true, NoReason).

module_four_profile([attribute(standard_contractual_clauses_decision_in_force, InForce), attribute(exporter_processing_subject_to_gdpr, ExporterSubject), attribute(importer_processing_subject_to_gdpr, ImporterSubject), attribute(exporter_role, processor), attribute(importer_role, controller), attribute(standard_contractual_clauses_concluded, true), attribute(module_selected, module_four), attribute(clauses_modified, false), attribute(added_clauses_contradict_clauses, false), attribute(processor_combines_received_data_with_data_collected_in_union, false)]) :-
    test_attested(true, InForce),
    test_attested(true, ExporterSubject),
    test_attested(false, ImporterSubject).

test(controller_to_processor_is_module_two) :-
    findall(Result, standard_contractual_clauses_module([attribute(exporter_role, controller), attribute(importer_role, processor)], Result, _Citations), Results),
    Results == [module_two].
test(processor_to_controller_is_module_four) :-
    standard_contractual_clauses_module([attribute(exporter_role, processor), attribute(importer_role, controller)], module_four, [cite(eu_dec_2021_914_art_1), cite(eu_dec_2021_914_annex_i)]).
test(missing_exporter_role_is_named) :-
    standard_contractual_clauses_module([attribute(importer_role, processor)], indeterminate([exporter_role]), []).
test(both_roles_missing_names_exporter_role) :-
    standard_contractual_clauses_module([], indeterminate([exporter_role]), []).
test(unknown_key_is_an_input_problem) :-
    standard_contractual_clauses_module([attribute(colour, red)], input_problems([unknown_key(colour)]), []).
test(clauses_available_on_good_facts) :-
    safeguard_profile(module_two, false, Profile),
    findall(Result - Basis, standard_contractual_clauses_availability(Profile, Result, Basis, _Citations), Answers),
    Answers = [clauses_available - Basis],
    length(Basis, 3).
test(importer_subject_settles_before_absent_decision) :-
    test_attested(true, Subject),
    standard_contractual_clauses_availability([attribute(importer_processing_subject_to_gdpr, Subject)], clauses_not_available, [outside_fact(importer_processing_subject_to_gdpr, Subject)], [cite(eu_dec_2021_914_art_1)]).
test(empty_profile_refers_decision_in_force) :-
    standard_contractual_clauses_availability([], needs_legal_review(cross_reference_unresolved(cite(eu_dec_2021_914_art_1), cite(standard_contractual_clauses_decision_in_force_statement)), [resolution(cite(standard_contractual_clauses_decision_in_force_statement), not_attempted), inputs_relied_on([standard_contractual_clauses_decision_in_force - absent])]), [], []).
test(good_profile_provides_safeguards_once) :-
    safeguard_profile(module_two, false, Profile),
    findall(Result, standard_contractual_clauses_safeguard(Profile, Result, _Basis, _Citations), Results),
    Results == [appropriate_safeguards_provided].
test(good_profile_basis_has_four_outside_facts) :-
    safeguard_profile(module_two, false, Profile),
    standard_contractual_clauses_safeguard(Profile, appropriate_safeguards_provided, Basis, _Citations),
    length(Basis, 4).
test(wrong_module_selected_does_not_provide) :-
    safeguard_profile(module_one, false, Profile),
    standard_contractual_clauses_safeguard(Profile, appropriate_safeguards_not_provided, _Basis, _Citations).
test(unsure_added_clauses_go_to_a_lawyer) :-
    safeguard_profile(module_two, unsure, Profile),
    standard_contractual_clauses_safeguard(Profile, needs_legal_review(open_textured(added_clauses_contradict_clauses, cite(eu_dec_2021_914_annex_cl_2_a)), [inputs_relied_on([added_clauses_contradict_clauses - unsure])]), [], []).
test(empty_profile_safeguard_refers_decision_in_force) :-
    standard_contractual_clauses_safeguard([], needs_legal_review(cross_reference_unresolved(cite(eu_dec_2021_914_art_1), cite(standard_contractual_clauses_decision_in_force_statement)), _Context), [], []).
test(module_four_without_combining_is_settled_without_clause_14) :-
    module_four_profile(Profile),
    standard_contractual_clauses_safeguard(Profile, appropriate_safeguards_provided, Basis, _Citations),
    length(Basis, 3).
test(module_four_appendix_needs_only_annex_i_a_and_b) :-
    standard_contractual_clauses_appendix([attribute(exporter_role, processor), attribute(importer_role, controller), attribute(annex_i_a_list_of_parties_completed, true), attribute(annex_i_b_description_of_transfer_completed, true)], appendix_complete, _Citations).
test(specific_authorisation_needs_annex_iii) :-
    standard_contractual_clauses_appendix([attribute(exporter_role, controller), attribute(importer_role, processor), attribute(annex_i_a_list_of_parties_completed, true), attribute(annex_i_b_description_of_transfer_completed, true), attribute(annex_i_c_competent_supervisory_authority_identified, true), attribute(annex_ii_measures_described_in_specific_terms, true), attribute(sub_processor_authorisation_option, specific_prior_authorisation)], indeterminate([annex_iii_list_of_sub_processors_completed]), []).
test(missing_list_of_parties_settles_incomplete) :-
    standard_contractual_clauses_appendix([attribute(annex_i_a_list_of_parties_completed, false)], appendix_incomplete, _Citations).
test(good_profile_checklist_has_every_row) :-
    safeguard_profile(module_two, false, Profile),
    gdpr_transfer_scc_checklist(Profile, Items),
    length(Items, 9),
    member(item(clause_14_warranty_given, met, cite(eu_dec_2021_914_annex_cl_14_m1m2m3m4_a)), Items).
test(facade_status_is_the_safeguard_result) :-
    safeguard_profile(module_two, false, Profile),
    gdpr_transfer_scc_status(Profile, appropriate_safeguards_provided).

test(processor_to_controller_is_not_module_two, fail) :-
    standard_contractual_clauses_module([attribute(exporter_role, processor), attribute(importer_role, controller)], module_two, _Citations).
test(importer_subject_is_not_available_only, fail) :-
    test_attested(true, Subject),
    standard_contractual_clauses_availability([attribute(importer_processing_subject_to_gdpr, Subject)], clauses_available, _Basis, _Citations).
test(wrong_module_selected_is_not_provided, fail) :-
    safeguard_profile(module_one, false, Profile),
    standard_contractual_clauses_safeguard(Profile, appropriate_safeguards_provided, _Basis, _Citations).
test(module_four_appendix_is_not_incomplete, fail) :-
    standard_contractual_clauses_appendix([attribute(exporter_role, processor), attribute(importer_role, controller), attribute(annex_i_a_list_of_parties_completed, true), attribute(annex_i_b_description_of_transfer_completed, true)], appendix_incomplete, _Citations).
