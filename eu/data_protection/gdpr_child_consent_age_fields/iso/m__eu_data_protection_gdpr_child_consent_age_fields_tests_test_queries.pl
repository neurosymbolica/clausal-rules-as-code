% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_child_consent_age_fields_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_child_consent_age_fields_queries, [gdpr_child_consent_age_fields_profile_keys/1, gdpr_child_consent_age_fields_what_if/4, gdpr_child_consent_age_fields_compliance_check/3, gdpr_child_consent_age_fields_justification/2]).
:- use_module(m__eu_data_protection_gdpr_child_consent_age_fields_kernel, [gdpr_child_consent_age_fields_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_child_consent_age_fields_child_consent_status, [child_consent_status_status/2]).
:- use_module(m__eu_data_protection_gdpr_child_consent_age_fields_fixtures, [gdpr_child_consent_age_fields_profile_for/2]).

cited([]).
cited([item(_, _, cite(_))|Items]) :-
    cited(Items).

test(profile_keys_are_the_contract_keys) :-
    gdpr_child_consent_age_fields_profile_keys(ProfileKeys),
    ProfileKeys == [processing_rests_on_consent, information_society_service, offered_directly_to_child, child_age_years, parental_consent_given, member_state, member_state_selection_test, consent_date, member_state_digital_consent_age, verification_efforts_reasonable].
test(input_problems_is_served_through_queries) :-
    gdpr_child_consent_age_fields_profile_for(invalid_age, Profile),
    gdpr_child_consent_age_fields_input_problems(Profile, [wrong_type(child_age_years)]).
test(status_determination_age_16) :-
    gdpr_child_consent_age_fields_profile_for(age_16_own_consent, Profile),
    child_consent_status_status(Profile, eligible).
test(status_determination_age_12_no_parent) :-
    gdpr_child_consent_age_fields_profile_for(age_12_no_parent, Profile),
    child_consent_status_status(Profile, ineligible).
test(what_if_age_16_makes_eligible) :-
    gdpr_child_consent_age_fields_profile_for(age_15_national_16, Profile),
    findall(Status, gdpr_child_consent_age_fields_what_if(Profile, child_age_years, 16, Status), Statuses),
    Statuses == [eligible].
test(what_if_keeps_the_original_ineligible) :-
    gdpr_child_consent_age_fields_profile_for(age_15_national_16, Profile),
    child_consent_status_status(Profile, ineligible).
test(what_if_parental_consent_makes_eligible) :-
    gdpr_child_consent_age_fields_profile_for(age_15_national_16, Profile),
    gdpr_child_consent_age_fields_what_if(Profile, parental_consent_given, true, eligible).
test(what_if_adds_an_absent_key) :-
    gdpr_child_consent_age_fields_profile_for(age_missing, Profile),
    findall(Status, gdpr_child_consent_age_fields_what_if(Profile, child_age_years, 16, Status), Statuses),
    Statuses == [eligible].
test(what_if_member_state_applies_the_attested_age) :-
    gdpr_child_consent_age_fields_profile_for(age_14_other_state_fact, Profile),
    findall(Status, gdpr_child_consent_age_fields_what_if(Profile, member_state, germany, Status), Statuses),
    Statuses == [ineligible].
test(what_if_a_bad_value_gives_input_problems) :-
    gdpr_child_consent_age_fields_profile_for(age_16_own_consent, Profile),
    gdpr_child_consent_age_fields_what_if(Profile, child_age_years, -1, input_problems([wrong_type(child_age_years)])).
test(compliance_permitted) :-
    gdpr_child_consent_age_fields_profile_for(age_16_own_consent, Profile),
    findall(Verdict, gdpr_child_consent_age_fields_compliance_check(Profile, process_on_consent, Verdict), Verdicts),
    Verdicts == [permitted(cite(eu_reg_2016_679_art_8_1))].
test(compliance_forbidden) :-
    gdpr_child_consent_age_fields_profile_for(age_12_no_parent, Profile),
    findall(Verdict, gdpr_child_consent_age_fields_compliance_check(Profile, process_on_consent, Verdict), Verdicts),
    Verdicts == [forbidden(cite(eu_reg_2016_679_art_8_1))].
test(compliance_undetermined_on_referral) :-
    gdpr_child_consent_age_fields_profile_for(age_14_national_absent, Profile),
    gdpr_child_consent_age_fields_compliance_check(Profile, process_on_consent, undetermined(needs_legal_review(cross_reference_unresolved(_, _), _))).
test(compliance_undetermined_on_missing_key) :-
    gdpr_child_consent_age_fields_profile_for(age_missing, Profile),
    gdpr_child_consent_age_fields_compliance_check(Profile, process_on_consent, undetermined(indeterminate([child_age_years]))).
test(compliance_undetermined_on_input_problems) :-
    gdpr_child_consent_age_fields_profile_for(invalid_age, Profile),
    gdpr_child_consent_age_fields_compliance_check(Profile, process_on_consent, undetermined(input_problems([wrong_type(child_age_years)]))).
test(compliance_not_engaged_is_permitted) :-
    gdpr_child_consent_age_fields_profile_for(not_engaged_not_directed, Profile),
    gdpr_child_consent_age_fields_compliance_check(Profile, process_on_consent, permitted(_)).
test(justification_for_age_16) :-
    gdpr_child_consent_age_fields_profile_for(age_16_own_consent, Profile),
    gdpr_child_consent_age_fields_justification(Profile, [item(engagement, met, cite(eu_reg_2016_679_art_8_1)), item(age_at_least_16, met, cite(eu_reg_2016_679_art_8_1)), item(parental_consent, not_reached, cite(eu_reg_2016_679_art_8_1)), item(national_age_reached, not_reached, cite(eu_reg_2016_679_art_8_1_second_subpara))]).
test(justification_below_the_national_age) :-
    gdpr_child_consent_age_fields_profile_for(age_15_national_16, Profile),
    gdpr_child_consent_age_fields_justification(Profile, [item(engagement, met, _), item(age_at_least_16, unmet, _), item(parental_consent, unmet, _), item(national_age_reached, unmet, _)]).
test(justification_not_engaged) :-
    gdpr_child_consent_age_fields_profile_for(not_engaged_not_directed, Profile),
    gdpr_child_consent_age_fields_justification(Profile, [item(engagement, unmet, _), item(age_at_least_16, not_reached, _), item(parental_consent, not_reached, _), item(national_age_reached, not_reached, _)]).
test(justification_every_item_carries_a_citation) :-
    gdpr_child_consent_age_fields_profile_for(age_15_national_15, Profile),
    gdpr_child_consent_age_fields_justification(Profile, Checklist),
    cited(Checklist).
test(justification_of_an_undecided_profile_is_unknown) :-
    gdpr_child_consent_age_fields_profile_for(age_missing, Profile),
    gdpr_child_consent_age_fields_justification(Profile, [item(engagement, unknown, _), item(age_at_least_16, unknown, _), item(parental_consent, unknown, _), item(national_age_reached, unknown, _)]).
test(justification_is_answered_once) :-
    gdpr_child_consent_age_fields_profile_for(age_16_own_consent, Profile),
    findall(Checklist, gdpr_child_consent_age_fields_justification(Profile, Checklist), Checklists),
    length(Checklists, 1).

test(what_if_age_15_stays_ineligible, fail) :-
    gdpr_child_consent_age_fields_profile_for(age_15_national_16, Profile),
    gdpr_child_consent_age_fields_what_if(Profile, child_age_years, 15, eligible).
test(compliance_forbidden_is_not_permitted, fail) :-
    gdpr_child_consent_age_fields_profile_for(age_12_no_parent, Profile),
    gdpr_child_consent_age_fields_compliance_check(Profile, process_on_consent, permitted(_)).

cp_test_names([profile_keys_are_the_contract_keys, input_problems_is_served_through_queries, status_determination_age_16, status_determination_age_12_no_parent, what_if_age_16_makes_eligible, what_if_keeps_the_original_ineligible, what_if_parental_consent_makes_eligible, what_if_adds_an_absent_key, what_if_member_state_applies_the_attested_age, what_if_a_bad_value_gives_input_problems, compliance_permitted, compliance_forbidden, compliance_undetermined_on_referral, compliance_undetermined_on_missing_key, compliance_undetermined_on_input_problems, compliance_not_engaged_is_permitted, justification_for_age_16, justification_below_the_national_age, justification_not_engaged, justification_every_item_carries_a_citation, justification_of_an_undecided_profile_is_unknown, justification_is_answered_once]).
cp_test_fail_names([what_if_age_15_stays_ineligible, compliance_forbidden_is_not_permitted]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
