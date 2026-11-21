% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_chapter_v_extras_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_chapter_v_extras_gdpr_chapter_v_extras, [second_subparagraph_duty/5, foreign_judgment_or_decision_recognition/4, onward_transfer_condition/4, decide_gdpr_chapter_v_extras/2, gdpr_chapter_v_extras_status/2, gdpr_chapter_v_extras_checklist/2]).
:- use_module(m__eu_data_protection_gdpr_chapter_v_extras_fixtures, [gdpr_chapter_v_extras_profile_for/2]).

query_answer(Profile, duty(AskedDuty), Result) :-
    second_subparagraph_duty(Profile, AskedDuty, Result, _Basis, _Citations).
query_answer(Profile, article_48, Result) :-
    foreign_judgment_or_decision_recognition(Profile, Result, _Basis, _Citations).
query_answer(Profile, onward_transfer, Result) :-
    onward_transfer_condition(Profile, Result, _Basis, _Citations).

referral_row(transfer_relies_on_article_49_1_second_subparagraph, eu_reg_2016_679_art_49_1_second_subpara, second_subparagraph_transfer_statement).
referral_row(third_country_judgment_or_decision_requires_transfer, eu_reg_2016_679_art_48, foreign_judgment_requires_transfer_statement).
referral_row(international_agreement_basis_for_judgment_or_decision, eu_reg_2016_679_art_48, international_agreement_basis_statement).
referral_row(transfer_is_onward_transfer, eu_reg_2016_679_art_44, onward_transfer_statement).
referral_row(onward_transfer_has_chapter_v_basis, eu_reg_2016_679_art_44, onward_transfer_chapter_v_basis_statement).

resolve(plain(Result), Result).
resolve(referral(OutsideKey), needs_legal_review(cross_reference_unresolved(cite(Citation), cite(Target)), [resolution(cite(Target), not_attempted), inputs_relied_on([OutsideKey - absent])])) :-
    referral_row(OutsideKey, Citation, Target).

expected(supervisory_authority_informed, duty(inform_supervisory_authority), plain(duty_met)).
expected(supervisory_authority_not_informed, duty(inform_supervisory_authority), plain(duty_not_met)).
expected(supervisory_authority_information_unstated, duty(inform_supervisory_authority), plain(indeterminate([supervisory_authority_informed_of_transfer]))).
expected(processor_asks_about_informing, duty(inform_supervisory_authority), plain(not_a_processor_duty)).
expected(processor_asks_about_informing, duty(inform_data_subject), plain(not_a_processor_duty)).
expected(processor_asks_with_transfer_fact_absent, duty(inform_supervisory_authority), plain(not_a_processor_duty)).
expected(processor_asks_with_transfer_fact_absent, duty(document_assessment_and_safeguards), referral(transfer_relies_on_article_49_1_second_subparagraph)).
expected(controller_asks_with_transfer_fact_absent, duty(inform_supervisory_authority), referral(transfer_relies_on_article_49_1_second_subparagraph)).
expected(party_role_unstated, duty(inform_supervisory_authority), plain(indeterminate([party_role]))).
expected(transfer_not_under_second_subparagraph, duty(inform_supervisory_authority), plain(no_second_subparagraph_transfer)).
expected(transfer_not_under_second_subparagraph, duty(document_assessment_and_safeguards), plain(no_second_subparagraph_transfer)).
expected(transfer_not_under_second_subparagraph_role_unstated, duty(inform_data_subject), plain(indeterminate([party_role]))).
expected(transfer_not_under_second_subparagraph_role_unstated, duty(document_assessment_and_safeguards), plain(no_second_subparagraph_transfer)).
expected(data_subject_fully_informed, duty(inform_data_subject), plain(duty_met)).
expected(data_subject_not_told_of_interests, duty(inform_data_subject), plain(duty_not_met)).
expected(data_subject_interests_refused_transfer_unstated, duty(inform_data_subject), plain(duty_not_met)).
expected(data_subject_transfer_information_unstated, duty(inform_data_subject), plain(indeterminate([data_subject_informed_of_transfer]))).
expected(records_complete_for_processor, duty(document_assessment_and_safeguards), plain(duty_met)).
expected(records_lack_safeguards, duty(document_assessment_and_safeguards), plain(duty_not_met)).
expected(records_lack_assessment_safeguards_unstated, duty(document_assessment_and_safeguards), plain(duty_not_met)).
expected(records_safeguards_unstated, duty(document_assessment_and_safeguards), plain(indeterminate([suitable_safeguards_documented_in_records]))).
expected(judgment_not_requiring_transfer, article_48, plain(article_48_not_engaged)).
expected(judgment_with_international_agreement, article_48, plain(not_barred_by_article_48)).
expected(judgment_without_international_agreement, article_48, plain(not_recognisable_or_enforceable)).
expected(judgment_agreement_unstated, article_48, referral(international_agreement_basis_for_judgment_or_decision)).
expected(judgment_unstated_agreement_stated, article_48, referral(third_country_judgment_or_decision_requires_transfer)).
expected(onward_transfer_with_chapter_v_basis, onward_transfer, plain(onward_transfer_may_take_place)).
expected(onward_transfer_without_chapter_v_basis, onward_transfer, plain(onward_transfer_may_not_take_place)).
expected(onward_transfer_basis_unstated, onward_transfer, referral(onward_transfer_has_chapter_v_basis)).
expected(transfer_not_onward, onward_transfer, plain(not_an_onward_transfer)).
expected(transfer_not_onward_with_link_evidence, onward_transfer, plain(not_an_onward_transfer)).
expected(onward_status_unstated_basis_stated, onward_transfer, referral(transfer_is_onward_transfer)).
expected(duplicated_party_role, duty(inform_supervisory_authority), plain(input_problems([duplicate_key(party_role)]))).
expected(bare_boolean_outside_fact, onward_transfer, plain(input_problems([wrong_type(transfer_is_onward_transfer)]))).
expected(unknown_key_supplied, article_48, plain(input_problems([unknown_key(transfer_date)]))).
expected(empty_profile, duty(inform_data_subject), referral(transfer_relies_on_article_49_1_second_subparagraph)).
expected(empty_profile, article_48, referral(third_country_judgment_or_decision_requires_transfer)).
expected(empty_profile, onward_transfer, referral(transfer_is_onward_transfer)).
expected(complete_transfer_file, duty(inform_supervisory_authority), plain(duty_met)).
expected(complete_transfer_file, duty(inform_data_subject), plain(duty_met)).
expected(complete_transfer_file, duty(document_assessment_and_safeguards), plain(duty_met)).
expected(complete_transfer_file, article_48, plain(not_barred_by_article_48)).
expected(complete_transfer_file, onward_transfer, plain(onward_transfer_may_take_place)).

expected_row_holds(Subject - Query - Expected) :-
    gdpr_chapter_v_extras_profile_for(Subject, Profile),
    resolve(Expected, Result),
    findall(Answer, query_answer(Profile, Query, Answer), Answers),
    Answers == [Result].

test(every_expected_row_is_the_one_answer) :-
    findall(Subject - Query - Expected, expected(Subject, Query, Expected), ExpectedRows),
    ExpectedRows = [_|_],
    maplist(expected_row_holds, ExpectedRows).
test(duty_not_met_reads_out_basis_and_citation) :-
    gdpr_chapter_v_extras_profile_for(records_lack_safeguards, Profile),
    findall(Result - Basis - Citations, second_subparagraph_duty(Profile, document_assessment_and_safeguards, Result, Basis, Citations), Answers),
    Answers == [duty_not_met - [outside_fact(transfer_relies_on_article_49_1_second_subparagraph, attested(true, attestation(by, at, reason, none)))] - [cite(eu_reg_2016_679_art_49_6)]].
test(article_48_not_engaged_reads_out_one_basis_item) :-
    gdpr_chapter_v_extras_profile_for(judgment_not_requiring_transfer, Profile),
    findall(Result - Basis - Citations, foreign_judgment_or_decision_recognition(Profile, Result, Basis, Citations), Answers),
    Answers == [article_48_not_engaged - [outside_fact(third_country_judgment_or_decision_requires_transfer, attested(false, attestation(by, at, reason, none)))] - [cite(eu_reg_2016_679_art_48)]].
test(the_attestation_is_copied_whole) :-
    gdpr_chapter_v_extras_profile_for(transfer_not_onward_with_link_evidence, Profile),
    findall(Basis, onward_transfer_condition(Profile, _, Basis, _), Bases),
    Bases == [[outside_fact(transfer_is_onward_transfer, attested(false, attestation(by, at, reason, url(source_location, retrieved_at))))]].
test(onward_may_not_take_place_reads_out_two_basis_items) :-
    gdpr_chapter_v_extras_profile_for(onward_transfer_without_chapter_v_basis, Profile),
    findall(Result - Basis - Citations, onward_transfer_condition(Profile, Result, Basis, Citations), Answers),
    Answers == [onward_transfer_may_not_take_place - [outside_fact(transfer_is_onward_transfer, attested(true, attestation(by, at, reason, none))), outside_fact(onward_transfer_has_chapter_v_basis, attested(false, attestation(by, at, reason, none)))] - [cite(eu_reg_2016_679_art_44)]].
test(the_baseline_profile_yields_exactly_one_status) :-
    gdpr_chapter_v_extras_profile_for(todo_baseline_subject, Profile),
    findall(Status, gdpr_chapter_v_extras_status(Profile, Status), Statuses),
    Statuses == [onward_transfer_may_take_place].
test(the_verdict_carries_a_citation) :-
    gdpr_chapter_v_extras_profile_for(todo_baseline_subject, Profile),
    findall(Verdict, decide_gdpr_chapter_v_extras(Profile, Verdict), Verdicts),
    Verdicts == [gdpr_chapter_v_extras_verdict(onward_transfer_may_take_place, [cite(eu_reg_2016_679_art_44)])].
test(the_checklist_reads_every_limb) :-
    gdpr_chapter_v_extras_profile_for(complete_transfer_file, Profile),
    findall(Checklist, gdpr_chapter_v_extras_checklist(Profile, Checklist), Checklists),
    Checklists == [[item(inform_supervisory_authority, duty_met, [cite(eu_reg_2016_679_art_49_1_second_subpara)]), item(inform_data_subject, duty_met, [cite(eu_reg_2016_679_art_49_1_second_subpara)]), item(document_assessment_and_safeguards, duty_met, [cite(eu_reg_2016_679_art_49_6)]), item(article_48, not_barred_by_article_48, [cite(eu_reg_2016_679_art_48)]), item(onward_transfer, onward_transfer_may_take_place, [cite(eu_reg_2016_679_art_44)])]].

cp_test_names([every_expected_row_is_the_one_answer, duty_not_met_reads_out_basis_and_citation, article_48_not_engaged_reads_out_one_basis_item, the_attestation_is_copied_whole, onward_may_not_take_place_reads_out_two_basis_items, the_baseline_profile_yields_exactly_one_status, the_verdict_carries_a_citation, the_checklist_reads_every_limb]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
