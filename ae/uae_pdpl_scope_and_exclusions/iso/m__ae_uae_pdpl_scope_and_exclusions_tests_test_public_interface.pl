% SPDX-License-Identifier: EUPL-1.2
:- module(m__ae_uae_pdpl_scope_and_exclusions_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_msort/2]).
:- use_module(m__ae_uae_pdpl_scope_and_exclusions_uae_pdpl_scope_and_exclusions, [decide_uae_pdpl_scope_and_exclusions/2, uae_pdpl_scope_and_exclusions_status/2, uae_pdpl_scope_and_exclusions_checklist/2, uae_pdpl_scope_and_exclusions_decision_resolvable/1, uae_pdpl_scope_and_exclusions_status_values/1]).
:- use_module(m__ae_uae_pdpl_scope_and_exclusions_fixtures, [uae_pdpl_scope_and_exclusions_subject/1, uae_pdpl_scope_and_exclusions_profile_for/2, uae_pdpl_scope_and_exclusions_assess/2]).
:- use_module(m__ae_uae_pdpl_scope_and_exclusions_uae_pdpl_scope_and_exclusions, [pdpl_applies/3, pdpl_in_force/3]).
:- use_module(m__ae_uae_pdpl_scope_and_exclusions_kernel, [uae_pdpl_scope_and_exclusions_input_problems/2]).
:- use_module(m__ae_uae_pdpl_scope_and_exclusions_queries, [uae_pdpl_scope_and_exclusions_what_if/4]).

assessed_once(Subject, Status, Citations) :-
    findall(Status - Citations, uae_pdpl_scope_and_exclusions_assess(Subject, uae_pdpl_scope_and_exclusions_verdict(Status, Citations)), Answers),
    Answers = [Status - Citations].

assessed_once(Subject, Status) :-
    assessed_once(Subject, Status, _).

resolves_once(Subject) :-
    findall(Verdict, uae_pdpl_scope_and_exclusions_assess(Subject, Verdict), [_]).

cited_item(item(_, _, cite(CitationKey))) :-
    atom(CitationKey).

applies_citations([cite(uae_pdpl_art_1_personal_data), cite(uae_pdpl_art_1_processing), cite(uae_pdpl_art_2_1), cite(uae_pdpl_art_2_1_a), cite(uae_pdpl_art_2_1_b), cite(uae_pdpl_art_2_1_c), cite(uae_pdpl_art_2_2), cite(uae_pdpl_art_31)]).

same_citation_set(Citations, Expected) :-
    clausal_msort(Citations, SortedCitations),
    clausal_msort(Expected, SortedExpected),
    SortedCitations == SortedExpected.

test(every_subject_resolves_exactly_once) :-
    findall(Subject, uae_pdpl_scope_and_exclusions_subject(Subject), Subjects),
    length(Subjects, 27),
    maplist(resolves_once, Subjects).
test(the_commencement_day_applies) :-
    assessed_once(applies_on_commencement_day, applies, Citations),
    applies_citations(Expected),
    same_citation_set(Citations, Expected).
test(the_day_before_commencement_is_not_in_force) :-
    assessed_once(not_in_force_on_day_before_commencement, not_in_force, Citations),
    Citations == [cite(uae_pdpl_art_31)].
test(year_one_is_not_in_force) :-
    assessed_once(not_in_force_in_year_one, not_in_force).
test(the_last_contract_day_applies) :-
    assessed_once(applies_on_last_contract_day, applies).
test(not_processing_of_personal_data_does_not_apply) :-
    assessed_once(not_processing_of_personal_data, does_not_apply, Citations),
    Citations == [cite(uae_pdpl_art_2_1), cite(uae_pdpl_art_2_2)].
test(no_way_of_scope_does_not_apply) :-
    assessed_once(no_way_of_scope_met, does_not_apply, Citations),
    Citations == [cite(uae_pdpl_art_2_1), cite(uae_pdpl_art_2_2)].
test(a_foreign_controller_with_a_subject_inside_applies) :-
    assessed_once(foreign_controller_with_data_subject_inside_state, applies).
test(a_resident_controller_applies_whatever_the_subjects_place) :-
    assessed_once(resident_controller_with_data_subjects_abroad, applies).
test(government_data_does_not_apply) :-
    assessed_once(government_data_excluded, does_not_apply, Citations),
    Citations == [cite(uae_pdpl_art_2_1), cite(uae_pdpl_art_2_2)].
test(governmental_entity_does_not_apply) :-
    assessed_once(governmental_entity_excluded, does_not_apply).
test(security_or_judicial_authorities_do_not_apply) :-
    assessed_once(security_or_judicial_authorities_excluded, does_not_apply).
test(personal_purposes_do_not_apply) :-
    assessed_once(personal_purposes_excluded, does_not_apply).
test(health_data_with_own_legislation_does_not_apply) :-
    assessed_once(health_data_with_own_legislation_excluded, does_not_apply).
test(banking_or_credit_data_with_own_legislation_does_not_apply) :-
    assessed_once(banking_or_credit_data_with_own_legislation_excluded, does_not_apply).
test(free_zone_establishment_does_not_apply) :-
    assessed_once(free_zone_establishment_excluded, does_not_apply).
test(a_missing_date_is_named) :-
    assessed_once(processing_date_missing, indeterminate([processing_date]), Citations),
    Citations == [].
test(a_missing_processing_judgement_is_named) :-
    assessed_once(processing_judgement_missing, indeterminate([activity_is_processing_of_personal_data]), []).
test(a_missing_free_zone_judgement_is_named) :-
    assessed_once(free_zone_judgement_missing, indeterminate([free_zone_company_or_establishment_with_own_data_protection_legislation]), []).
test(missing_way_keys_name_the_first) :-
    assessed_once(way_keys_missing, indeterminate([data_subject_resides_or_has_place_of_business_in_state]), []).
test(a_missing_controller_residence_is_named) :-
    assessed_once(controller_residence_missing, indeterminate([controller_or_processor_resides_in_state]), []).
test(an_unsure_processing_judgement_is_referred) :-
    assessed_once(processing_judgement_unsure, Status, Citations),
    Citations == [],
    Status == needs_legal_review(open_textured(activity_is_processing_of_personal_data, cite(uae_pdpl_art_1_personal_data)), [inputs_relied_on([processing_date - date(2022, 1, 2), activity_is_processing_of_personal_data - unsure, personal_data_is_government_data - false, governmental_entity_controls_or_processes - false, personal_data_held_by_security_or_judicial_authorities - false, data_subject_processing_own_data_for_personal_purposes - false, personal_health_data_with_own_protection_legislation - false, personal_banking_or_credit_data_with_own_protection_legislation - false, free_zone_company_or_establishment_with_own_data_protection_legislation - false, data_subject_resides_or_has_place_of_business_in_state - true, controller_or_processor_resides_in_state - false, data_subject_inside_state - false])]).
test(an_unsure_free_zone_judgement_is_referred) :-
    assessed_once(free_zone_judgement_unsure, Status, []),
    Status == needs_legal_review(open_textured(free_zone_company_or_establishment_with_own_data_protection_legislation, cite(uae_pdpl_art_2_2_g)), [inputs_relied_on([processing_date - date(2022, 1, 2), activity_is_processing_of_personal_data - true, personal_data_is_government_data - false, governmental_entity_controls_or_processes - false, personal_data_held_by_security_or_judicial_authorities - false, data_subject_processing_own_data_for_personal_purposes - false, personal_health_data_with_own_protection_legislation - false, personal_banking_or_credit_data_with_own_protection_legislation - false, free_zone_company_or_establishment_with_own_data_protection_legislation - unsure, data_subject_resides_or_has_place_of_business_in_state - true, controller_or_processor_resides_in_state - false, data_subject_inside_state - false])]).
test(a_missing_key_is_named_before_a_referral) :-
    assessed_once(government_data_unsure_with_free_zone_missing, indeterminate([free_zone_company_or_establishment_with_own_data_protection_legislation]), []).
test(the_optional_provenance_item_follows_inputs_relied_on) :-
    Context = [inputs_relied_on([processing_date - date(2022, 1, 2)]), provenance(pdpl_applies_step_seventeen, [cite(uae_pdpl_art_1_personal_data)])],
    Context = [inputs_relied_on(Pairs), provenance(Clause, Citations)],
    Pairs == [processing_date - date(2022, 1, 2)],
    Clause == pdpl_applies_step_seventeen,
    Citations == [cite(uae_pdpl_art_1_personal_data)].
test(a_referral_context_opens_with_inputs_relied_on) :-
    assessed_once(processing_judgement_unsure, needs_legal_review(_, [inputs_relied_on(_)|_]), []).
test(an_impossible_date_is_an_input_problem) :-
    assessed_once(impossible_processing_date, input_problems([wrong_type(processing_date)]), []).
test(the_leap_day_control_applies) :-
    assessed_once(leap_day_processing_date, applies).
test(a_duplicate_key_is_an_input_problem) :-
    assessed_once(duplicate_data_subject_inside_state, input_problems([duplicate_key(data_subject_inside_state)]), []).
test(an_unknown_key_is_an_input_problem) :-
    assessed_once(unknown_key_colour, input_problems([unknown_key(colour)]), []).
test(the_input_check_is_public) :-
    uae_pdpl_scope_and_exclusions_profile_for(applies_on_commencement_day, Profile),
    uae_pdpl_scope_and_exclusions_input_problems(Profile, []).
test(a_non_list_profile_is_one_problem) :-
    uae_pdpl_scope_and_exclusions_input_problems(profile, [wrong_type(profile)]).
test(pdpl_applies_matches_the_facade) :-
    uae_pdpl_scope_and_exclusions_profile_for(government_data_excluded, Profile),
    findall(Result - Citations, pdpl_applies(Profile, Result, Citations), Answers),
    Answers == [does_not_apply - [cite(uae_pdpl_art_2_1), cite(uae_pdpl_art_2_2)]].
test(in_force_on_the_commencement_day) :-
    uae_pdpl_scope_and_exclusions_profile_for(applies_on_commencement_day, Profile),
    findall(Result - Citations, pdpl_in_force(Profile, Result, Citations), Answers),
    Answers == [in_force - [cite(uae_pdpl_art_31)]].
test(not_in_force_on_the_day_before) :-
    uae_pdpl_scope_and_exclusions_profile_for(not_in_force_on_day_before_commencement, Profile),
    pdpl_in_force(Profile, not_in_force, [cite(uae_pdpl_art_31)]).
test(in_force_ignores_an_exclusion) :-
    uae_pdpl_scope_and_exclusions_profile_for(government_data_excluded, Profile),
    pdpl_in_force(Profile, in_force, _).
test(in_force_names_a_missing_date) :-
    uae_pdpl_scope_and_exclusions_profile_for(processing_date_missing, Profile),
    pdpl_in_force(Profile, indeterminate([processing_date]), []).
test(final_statuses_are_in_the_vocabulary) :-
    uae_pdpl_scope_and_exclusions_status_values(StatusValues),
    uae_pdpl_scope_and_exclusions_profile_for(applies_on_commencement_day, Profile),
    uae_pdpl_scope_and_exclusions_status(Profile, Status),
    Status == applies,
    member(Status, StatusValues).
test(the_decision_is_resolvable) :-
    uae_pdpl_scope_and_exclusions_profile_for(no_way_of_scope_met, Profile),
    uae_pdpl_scope_and_exclusions_decision_resolvable(Profile),
    decide_uae_pdpl_scope_and_exclusions(Profile, uae_pdpl_scope_and_exclusions_verdict(does_not_apply, _)).
test(the_checklist_cites_every_item) :-
    uae_pdpl_scope_and_exclusions_profile_for(applies_on_commencement_day, Profile),
    uae_pdpl_scope_and_exclusions_checklist(Profile, [FirstItem|OtherItems]),
    maplist(cited_item, [FirstItem|OtherItems]),
    member(item(in_force_on_processing_date, met, cite(uae_pdpl_art_31)), [FirstItem|OtherItems]).
test(the_checklist_shows_the_exclusion_that_holds) :-
    uae_pdpl_scope_and_exclusions_profile_for(government_data_excluded, Profile),
    uae_pdpl_scope_and_exclusions_checklist(Profile, Items),
    member(item(government_data_exclusion_does_not_hold, unmet(_), cite(uae_pdpl_art_2_2_a)), Items).
test(the_checklist_shows_the_day_before) :-
    uae_pdpl_scope_and_exclusions_profile_for(not_in_force_on_day_before_commencement, Profile),
    uae_pdpl_scope_and_exclusions_checklist(Profile, Items),
    member(item(in_force_on_processing_date, unmet(_), cite(uae_pdpl_art_31)), Items).
test(what_if_the_exclusion_is_lifted) :-
    uae_pdpl_scope_and_exclusions_profile_for(government_data_excluded, Profile),
    uae_pdpl_scope_and_exclusions_what_if(Profile, personal_data_is_government_data, false, applies).
test(what_if_the_missing_date_is_given) :-
    uae_pdpl_scope_and_exclusions_profile_for(processing_date_missing, Profile),
    uae_pdpl_scope_and_exclusions_what_if(Profile, processing_date, date(2021, 12, 31), not_in_force).

test(the_commencement_day_is_not_not_in_force, fail) :-
    assessed_once(applies_on_commencement_day, not_in_force).
test(the_day_before_commencement_does_not_apply_as_applies, fail) :-
    assessed_once(not_in_force_on_day_before_commencement, applies).
test(not_processing_of_personal_data_is_not_applies, fail) :-
    assessed_once(not_processing_of_personal_data, applies).
test(no_way_of_scope_is_not_applies, fail) :-
    assessed_once(no_way_of_scope_met, applies).
test(an_excluded_processing_is_not_applies, fail) :-
    assessed_once(free_zone_establishment_excluded, applies).
test(a_missing_key_is_not_applies, fail) :-
    assessed_once(processing_date_missing, applies).
test(this_package_adds_no_provenance_item_to_a_referral, fail) :-
    assessed_once(processing_judgement_unsure, needs_legal_review(_, [_, provenance(_, _)]), _).
test(the_leap_day_control_has_no_input_problem, fail) :-
    assessed_once(leap_day_processing_date, input_problems(_)).
test(the_day_before_is_not_in_force_by_the_in_force_query, fail) :-
    uae_pdpl_scope_and_exclusions_profile_for(not_in_force_on_day_before_commencement, Profile),
    pdpl_in_force(Profile, in_force, _).

cp_test_names([every_subject_resolves_exactly_once, the_commencement_day_applies, the_day_before_commencement_is_not_in_force, year_one_is_not_in_force, the_last_contract_day_applies, not_processing_of_personal_data_does_not_apply, no_way_of_scope_does_not_apply, a_foreign_controller_with_a_subject_inside_applies, a_resident_controller_applies_whatever_the_subjects_place, government_data_does_not_apply, governmental_entity_does_not_apply, security_or_judicial_authorities_do_not_apply, personal_purposes_do_not_apply, health_data_with_own_legislation_does_not_apply, banking_or_credit_data_with_own_legislation_does_not_apply, free_zone_establishment_does_not_apply, a_missing_date_is_named, a_missing_processing_judgement_is_named, a_missing_free_zone_judgement_is_named, missing_way_keys_name_the_first, a_missing_controller_residence_is_named, an_unsure_processing_judgement_is_referred, an_unsure_free_zone_judgement_is_referred, a_missing_key_is_named_before_a_referral, the_optional_provenance_item_follows_inputs_relied_on, a_referral_context_opens_with_inputs_relied_on, an_impossible_date_is_an_input_problem, the_leap_day_control_applies, a_duplicate_key_is_an_input_problem, an_unknown_key_is_an_input_problem, the_input_check_is_public, a_non_list_profile_is_one_problem, pdpl_applies_matches_the_facade, in_force_on_the_commencement_day, not_in_force_on_the_day_before, in_force_ignores_an_exclusion, in_force_names_a_missing_date, final_statuses_are_in_the_vocabulary, the_decision_is_resolvable, the_checklist_cites_every_item, the_checklist_shows_the_exclusion_that_holds, the_checklist_shows_the_day_before, what_if_the_exclusion_is_lifted, what_if_the_missing_date_is_given]).
cp_test_fail_names([the_commencement_day_is_not_not_in_force, the_day_before_commencement_does_not_apply_as_applies, not_processing_of_personal_data_is_not_applies, no_way_of_scope_is_not_applies, an_excluded_processing_is_not_applies, a_missing_key_is_not_applies, this_package_adds_no_provenance_item_to_a_referral, the_leap_day_control_has_no_input_problem, the_day_before_is_not_in_force_by_the_in_force_query]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
