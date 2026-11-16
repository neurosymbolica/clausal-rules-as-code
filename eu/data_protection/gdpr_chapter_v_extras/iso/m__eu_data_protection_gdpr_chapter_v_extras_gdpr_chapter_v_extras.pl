% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_chapter_v_extras_gdpr_chapter_v_extras, [second_subparagraph_duty/5, foreign_judgment_or_decision_recognition/4, onward_transfer_condition/4, decide_gdpr_chapter_v_extras/2, gdpr_chapter_v_extras_status/2, gdpr_chapter_v_extras_checklist/2, gdpr_chapter_v_extras_decision_resolvable/1, gdpr_chapter_v_extras_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(pairs), [pairs_keys/2, pairs_values/2]).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(formalize_lib, [profile_get/3, profile_lacks/2]).
:- use_module(m__eu_data_protection_gdpr_chapter_v_extras_kernel, [gdpr_chapter_v_extras_input_problems/2, duty_argument_problems/2, absent_referral/2]).
:- use_module(m__eu_data_protection_gdpr_chapter_v_extras_citations, [implements/1]).

duty_row(inform_supervisory_authority, inform_duty, [supervisory_authority_informed_of_transfer], cite(eu_reg_2016_679_art_49_1_second_subpara)).
duty_row(inform_data_subject, inform_duty, [data_subject_informed_of_transfer, data_subject_informed_of_compelling_legitimate_interests], cite(eu_reg_2016_679_art_49_1_second_subpara)).
duty_row(document_assessment_and_safeguards, documentation_duty, [assessment_documented_in_records, suitable_safeguards_documented_in_records], cite(eu_reg_2016_679_art_49_6)).

gdpr_chapter_v_extras_status_values([no_condition_breached, more_input_needed, condition_breached]).

outside_reading(Profile, OutsideKey, Attested) :-
    profile_get(Profile, OutsideKey, Attested).
outside_reading(Profile, OutsideKey, absent) :-
    profile_lacks(Profile, OutsideKey).

crisp_reading(Profile, CrispKey, Value) :-
    profile_get(Profile, CrispKey, Value).
crisp_reading(Profile, CrispKey, absent) :-
    profile_lacks(Profile, CrispKey).

role_reading(Profile, Role) :-
    profile_get(Profile, party_role, Role).
role_reading(Profile, absent) :-
    profile_lacks(Profile, party_role).

second_subparagraph_duty(Profile, Duty, Result, Basis, Citations) :-
    gdpr_chapter_v_extras_input_problems(Profile, ProfileProblems),
    duty_argument_problems(Duty, DutyProblems),
    append(ProfileProblems, DutyProblems, Problems),
    duty_answer(Problems, Profile, Duty, Result, Basis, Citations).

duty_answer([FirstProblem|LaterProblems], _, _, input_problems([FirstProblem|LaterProblems]), [], []).
duty_answer([], Profile, Duty, Result, Basis, Citations) :-
    duty_row(Duty, Kind, _, _),
    role_status(Kind, Profile, RoleStatus),
    outside_reading(Profile, transfer_relies_on_article_49_1_second_subparagraph, TransferReading),
    duty_route(RoleStatus, TransferReading, Profile, Duty, Result, Basis, Citations).

role_status(inform_duty, Profile, RoleStatus) :-
    implements(eu_reg_2016_679_art_49_1_second_subpara),
    role_reading(Profile, RoleStatus).
role_status(documentation_duty, _, not_read) :-
    implements(eu_reg_2016_679_art_49_6).

role_continues(controller).
role_continues(absent).
role_continues(not_read).

duty_route(processor, _, _, _, not_a_processor_duty, [], [cite(eu_reg_2016_679_art_49_1_second_subpara)]) :-
    implements(eu_reg_2016_679_art_49_1_second_subpara).
duty_route(RoleStatus, absent, _, _, Result, [], []) :-
    implements(eu_reg_2016_679_art_49_1_second_subpara),
    role_continues(RoleStatus),
    absent_referral(transfer_relies_on_article_49_1_second_subparagraph, Result).
duty_route(absent, attested(_, _), _, _, indeterminate([party_role]), [], []) :-
    implements(eu_reg_2016_679_art_49_1_second_subpara).
duty_route(controller, attested(false, Attestation), _, Duty, no_second_subparagraph_transfer, [outside_fact(transfer_relies_on_article_49_1_second_subparagraph, attested(false, Attestation))], [DutyCitation]) :-
    implements(eu_reg_2016_679_art_49_1_second_subpara),
    duty_row(Duty, inform_duty, _, DutyCitation).
duty_route(not_read, attested(false, Attestation), _, Duty, no_second_subparagraph_transfer, [outside_fact(transfer_relies_on_article_49_1_second_subparagraph, attested(false, Attestation))], [DutyCitation]) :-
    implements(eu_reg_2016_679_art_49_6),
    duty_row(Duty, documentation_duty, _, DutyCitation).
duty_route(controller, attested(true, Attestation), Profile, Duty, Result, Basis, Citations) :-
    implements(eu_reg_2016_679_art_49_1_second_subpara),
    duty_row(Duty, inform_duty, FulfilmentKeys, DutyCitation),
    fulfilment_outcome(Profile, FulfilmentKeys, Outcome),
    duty_result(Outcome, [outside_fact(transfer_relies_on_article_49_1_second_subparagraph, attested(true, Attestation))], DutyCitation, Result, Basis, Citations).
duty_route(not_read, attested(true, Attestation), Profile, Duty, Result, Basis, Citations) :-
    implements(eu_reg_2016_679_art_49_6),
    duty_row(Duty, documentation_duty, FulfilmentKeys, DutyCitation),
    fulfilment_outcome(Profile, FulfilmentKeys, Outcome),
    duty_result(Outcome, [outside_fact(transfer_relies_on_article_49_1_second_subparagraph, attested(true, Attestation))], DutyCitation, Result, Basis, Citations).

fulfilment_outcome(Profile, FulfilmentKeys, Outcome) :-
    maplist(crisp_pair(Profile), FulfilmentKeys, Pairs),
    pairs_values(Pairs, Readings),
    memberd_t(false, Readings, HasFalse),
    outcome_from(HasFalse, Pairs, Outcome).

crisp_pair(Profile, FulfilmentKey, FulfilmentKey - Reading) :-
    crisp_reading(Profile, FulfilmentKey, Reading).

outcome_from(true, _, not_met).
outcome_from(false, Pairs, Outcome) :-
    first_absent(Pairs, Outcome).

first_absent([], met).
first_absent([MissingKey - absent|_], missing(MissingKey)).
first_absent([_ - true|Pairs], Outcome) :-
    first_absent(Pairs, Outcome).

duty_result(not_met, TransferBasis, DutyCitation, duty_not_met, TransferBasis, [DutyCitation]).
duty_result(missing(MissingKey), _, _, indeterminate([MissingKey]), [], []).
duty_result(met, TransferBasis, DutyCitation, duty_met, TransferBasis, [DutyCitation]).

foreign_judgment_or_decision_recognition(Profile, Result, Basis, Citations) :-
    gdpr_chapter_v_extras_input_problems(Profile, Problems),
    recognition_answer(Problems, Profile, Result, Basis, Citations).

recognition_answer([FirstProblem|LaterProblems], _, input_problems([FirstProblem|LaterProblems]), [], []).
recognition_answer([], Profile, Result, Basis, Citations) :-
    outside_reading(Profile, third_country_judgment_or_decision_requires_transfer, JudgmentReading),
    recognition_route(JudgmentReading, Profile, Result, Basis, Citations).

recognition_route(absent, _, Result, [], []) :-
    implements(eu_reg_2016_679_art_48),
    absent_referral(third_country_judgment_or_decision_requires_transfer, Result).
recognition_route(attested(false, Attestation), _, article_48_not_engaged, [outside_fact(third_country_judgment_or_decision_requires_transfer, attested(false, Attestation))], [cite(eu_reg_2016_679_art_48)]) :-
    implements(eu_reg_2016_679_art_48).
recognition_route(attested(true, Attestation), Profile, Result, Basis, Citations) :-
    implements(eu_reg_2016_679_art_48),
    outside_reading(Profile, international_agreement_basis_for_judgment_or_decision, AgreementReading),
    agreement_route(AgreementReading, attested(true, Attestation), Result, Basis, Citations).

agreement_route(absent, _, Result, [], []) :-
    implements(eu_reg_2016_679_art_48),
    absent_referral(international_agreement_basis_for_judgment_or_decision, Result).
agreement_route(attested(true, Attestation), JudgmentAttested, not_barred_by_article_48, [outside_fact(third_country_judgment_or_decision_requires_transfer, JudgmentAttested), outside_fact(international_agreement_basis_for_judgment_or_decision, attested(true, Attestation))], [cite(eu_reg_2016_679_art_48)]) :-
    implements(eu_reg_2016_679_art_48).
agreement_route(attested(false, Attestation), JudgmentAttested, not_recognisable_or_enforceable, [outside_fact(third_country_judgment_or_decision_requires_transfer, JudgmentAttested), outside_fact(international_agreement_basis_for_judgment_or_decision, attested(false, Attestation))], [cite(eu_reg_2016_679_art_48)]) :-
    implements(eu_reg_2016_679_art_48).

onward_transfer_condition(Profile, Result, Basis, Citations) :-
    gdpr_chapter_v_extras_input_problems(Profile, Problems),
    onward_answer(Problems, Profile, Result, Basis, Citations).

onward_answer([FirstProblem|LaterProblems], _, input_problems([FirstProblem|LaterProblems]), [], []).
onward_answer([], Profile, Result, Basis, Citations) :-
    outside_reading(Profile, transfer_is_onward_transfer, OnwardReading),
    onward_route(OnwardReading, Profile, Result, Basis, Citations).

onward_route(absent, _, Result, [], []) :-
    implements(eu_reg_2016_679_art_44),
    absent_referral(transfer_is_onward_transfer, Result).
onward_route(attested(false, Attestation), _, not_an_onward_transfer, [outside_fact(transfer_is_onward_transfer, attested(false, Attestation))], [cite(eu_reg_2016_679_art_44)]) :-
    implements(eu_reg_2016_679_art_44).
onward_route(attested(true, Attestation), Profile, Result, Basis, Citations) :-
    implements(eu_reg_2016_679_art_44),
    outside_reading(Profile, onward_transfer_has_chapter_v_basis, BasisReading),
    onward_basis_route(BasisReading, attested(true, Attestation), Result, Basis, Citations).

onward_basis_route(absent, _, Result, [], []) :-
    implements(eu_reg_2016_679_art_44),
    absent_referral(onward_transfer_has_chapter_v_basis, Result).
onward_basis_route(attested(true, Attestation), OnwardAttested, onward_transfer_may_take_place, [outside_fact(transfer_is_onward_transfer, OnwardAttested), outside_fact(onward_transfer_has_chapter_v_basis, attested(true, Attestation))], [cite(eu_reg_2016_679_art_44)]) :-
    implements(eu_reg_2016_679_art_44).
onward_basis_route(attested(false, Attestation), OnwardAttested, onward_transfer_may_not_take_place, [outside_fact(transfer_is_onward_transfer, OnwardAttested), outside_fact(onward_transfer_has_chapter_v_basis, attested(false, Attestation))], [cite(eu_reg_2016_679_art_44)]) :-
    implements(eu_reg_2016_679_art_44).

result_item_status(duty_met, met).
result_item_status(duty_not_met, unmet(duty_not_met)).
result_item_status(no_second_subparagraph_transfer, inapplicable).
result_item_status(not_a_processor_duty, inapplicable).
result_item_status(article_48_not_engaged, inapplicable).
result_item_status(not_barred_by_article_48, met).
result_item_status(not_recognisable_or_enforceable, unmet(not_recognisable_or_enforceable)).
result_item_status(not_an_onward_transfer, inapplicable).
result_item_status(onward_transfer_may_take_place, met).
result_item_status(onward_transfer_may_not_take_place, unmet(onward_transfer_may_not_take_place)).
result_item_status(indeterminate(MissingKeys), unknown(MissingKeys)).
result_item_status(needs_legal_review(_, [_, inputs_relied_on(Pairs)]), unknown(ReferredKeys)) :-
    pairs_keys(Pairs, ReferredKeys).

duty_item(Profile, Duty, item(Duty, Status, DutyCitation)) :-
    duty_row(Duty, _, _, DutyCitation),
    second_subparagraph_duty(Profile, Duty, Result, _, _),
    result_item_status(Result, Status).

recognition_item(Profile, item(article_48_recognition, Status, cite(eu_reg_2016_679_art_48))) :-
    foreign_judgment_or_decision_recognition(Profile, Result, _, _),
    result_item_status(Result, Status).

onward_item(Profile, item(onward_transfer, Status, cite(eu_reg_2016_679_art_44))) :-
    onward_transfer_condition(Profile, Result, _, _),
    result_item_status(Result, Status).

facade_items(Profile, [SupervisoryItem, DataSubjectItem, DocumentationItem, RecognitionItem, OnwardItem]) :-
    duty_item(Profile, inform_supervisory_authority, SupervisoryItem),
    duty_item(Profile, inform_data_subject, DataSubjectItem),
    duty_item(Profile, document_assessment_and_safeguards, DocumentationItem),
    recognition_item(Profile, RecognitionItem),
    onward_item(Profile, OnwardItem).

gdpr_chapter_v_extras_checklist(Profile, Items) :-
    gdpr_chapter_v_extras_input_problems(Profile, Problems),
    checklist_from(Problems, Profile, Items).

checklist_from([FirstProblem|LaterProblems], _, [item(input_check, unmet(input_problems([FirstProblem|LaterProblems])), [])]).
checklist_from([], Profile, Items) :-
    facade_items(Profile, Items).

status_flag(met, clear).
status_flag(inapplicable, clear).
status_flag(unmet(_), breached).
status_flag(unknown(_), open).

item_flag(item(_, Status, _), Flag) :-
    status_flag(Status, Flag).

items_status(Items, Status) :-
    maplist(item_flag, Items, Flags),
    memberd_t(breached, Flags, HasBreach),
    memberd_t(open, Flags, HasOpen),
    verdict_status(HasBreach, HasOpen, Status).

verdict_status(true, _, condition_breached).
verdict_status(false, true, more_input_needed).
verdict_status(false, false, no_condition_breached).

items_citations(Items, Citations) :-
    findall(Citation, member(item(_, _, Citation), Items), Collected),
    sort(Collected, Citations).

decide_gdpr_chapter_v_extras(Profile, gdpr_chapter_v_extras_verdict(Status, Citations)) :-
    gdpr_chapter_v_extras_input_problems(Profile, Problems),
    facade_verdict(Problems, Profile, Status, Citations).

facade_verdict([FirstProblem|LaterProblems], _, input_problems([FirstProblem|LaterProblems]), []).
facade_verdict([], Profile, Status, Citations) :-
    facade_items(Profile, Items),
    items_status(Items, Status),
    items_citations(Items, Citations).

gdpr_chapter_v_extras_status(Profile, Status) :-
    decide_gdpr_chapter_v_extras(Profile, gdpr_chapter_v_extras_verdict(Status, _)).

gdpr_chapter_v_extras_decision_resolvable(Profile) :-
    decide_gdpr_chapter_v_extras(Profile, _).

sample_attestation(attestation(host, stated_at, stated_reason, none)).

test(the_supervisory_authority_duty_is_met_once) :-
    sample_attestation(Attestation),
    Profile = [attribute(transfer_relies_on_article_49_1_second_subparagraph, attested(true, Attestation)), attribute(party_role, controller), attribute(supervisory_authority_informed_of_transfer, true)],
    findall(Result - Basis - Citations, second_subparagraph_duty(Profile, inform_supervisory_authority, Result, Basis, Citations), Answers),
    Answers == [duty_met - [outside_fact(transfer_relies_on_article_49_1_second_subparagraph, attested(true, Attestation))] - [cite(eu_reg_2016_679_art_49_1_second_subpara)]].
test(a_processor_is_told_a_duty_to_inform_is_not_its_duty) :-
    findall(Result - Basis - Citations, second_subparagraph_duty([attribute(party_role, processor)], inform_data_subject, Result, Basis, Citations), Answers),
    Answers == [not_a_processor_duty - [] - [cite(eu_reg_2016_679_art_49_1_second_subpara)]].
test(an_absent_fact_refers_before_party_role_is_named) :-
    findall(Result, second_subparagraph_duty([], inform_supervisory_authority, Result, _, _), Answers),
    Answers == [needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_49_1_second_subpara), cite(second_subparagraph_transfer_statement)), [resolution(cite(second_subparagraph_transfer_statement), not_attempted), inputs_relied_on([transfer_relies_on_article_49_1_second_subparagraph - absent])])].
test(party_role_is_named_before_the_fact_false_is_read) :-
    sample_attestation(Attestation),
    findall(Result - Basis - Citations, second_subparagraph_duty([attribute(transfer_relies_on_article_49_1_second_subparagraph, attested(false, Attestation))], inform_supervisory_authority, Result, Basis, Citations), Answers),
    Answers == [indeterminate([party_role]) - [] - []].
test(the_documentation_duty_ignores_party_role) :-
    sample_attestation(Attestation),
    findall(Result - Citations, second_subparagraph_duty([attribute(transfer_relies_on_article_49_1_second_subparagraph, attested(false, Attestation)), attribute(party_role, processor)], document_assessment_and_safeguards, Result, _, Citations), Answers),
    Answers == [no_second_subparagraph_transfer - [cite(eu_reg_2016_679_art_49_6)]].
test(a_false_key_decides_before_an_absent_one) :-
    sample_attestation(Attestation),
    Profile = [attribute(transfer_relies_on_article_49_1_second_subparagraph, attested(true, Attestation)), attribute(party_role, controller), attribute(data_subject_informed_of_compelling_legitimate_interests, false)],
    findall(Result, second_subparagraph_duty(Profile, inform_data_subject, Result, _, _), Answers),
    Answers == [duty_not_met].
test(the_first_absent_fulfilment_key_is_named) :-
    sample_attestation(Attestation),
    findall(Result - Basis, second_subparagraph_duty([attribute(transfer_relies_on_article_49_1_second_subparagraph, attested(true, Attestation))], document_assessment_and_safeguards, Result, Basis, _), Answers),
    Answers == [indeterminate([assessment_documented_in_records]) - []].
test(a_bad_profile_and_a_bad_duty_are_both_named) :-
    findall(Result - Basis - Citations, second_subparagraph_duty(not_a_profile, _, Result, Basis, Citations), Answers),
    Answers == [input_problems([wrong_type(profile), wrong_type(duty)]) - [] - []].
test(article_48_is_not_engaged) :-
    sample_attestation(Attestation),
    findall(Result - Basis, foreign_judgment_or_decision_recognition([attribute(third_country_judgment_or_decision_requires_transfer, attested(false, Attestation))], Result, Basis, _), Answers),
    Answers == [article_48_not_engaged - [outside_fact(third_country_judgment_or_decision_requires_transfer, attested(false, Attestation))]].
test(article_48_bars_without_an_agreement) :-
    sample_attestation(Attestation),
    Profile = [attribute(third_country_judgment_or_decision_requires_transfer, attested(true, Attestation)), attribute(international_agreement_basis_for_judgment_or_decision, attested(false, Attestation))],
    findall(Result - Citations, foreign_judgment_or_decision_recognition(Profile, Result, _, Citations), Answers),
    Answers == [not_recognisable_or_enforceable - [cite(eu_reg_2016_679_art_48)]].
test(article_48_agreement_absent_is_referred) :-
    sample_attestation(Attestation),
    findall(Result, foreign_judgment_or_decision_recognition([attribute(third_country_judgment_or_decision_requires_transfer, attested(true, Attestation))], Result, _, _), Answers),
    Answers == [needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_48), cite(international_agreement_basis_statement)), [resolution(cite(international_agreement_basis_statement), not_attempted), inputs_relied_on([international_agreement_basis_for_judgment_or_decision - absent])])].
test(an_onward_transfer_with_a_basis_may_take_place) :-
    sample_attestation(Attestation),
    Profile = [attribute(transfer_is_onward_transfer, attested(true, Attestation)), attribute(onward_transfer_has_chapter_v_basis, attested(true, Attestation))],
    findall(Result - Basis - Citations, onward_transfer_condition(Profile, Result, Basis, Citations), Answers),
    Answers == [onward_transfer_may_take_place - [outside_fact(transfer_is_onward_transfer, attested(true, Attestation)), outside_fact(onward_transfer_has_chapter_v_basis, attested(true, Attestation))] - [cite(eu_reg_2016_679_art_44)]].
test(a_transfer_that_is_not_onward) :-
    sample_attestation(Attestation),
    findall(Result, onward_transfer_condition([attribute(transfer_is_onward_transfer, attested(false, Attestation)), attribute(onward_transfer_has_chapter_v_basis, attested(false, Attestation))], Result, _, _), Answers),
    Answers == [not_an_onward_transfer].
test(an_empty_profile_needs_more_input) :-
    findall(Status, gdpr_chapter_v_extras_status([], Status), Statuses),
    Statuses == [more_input_needed].
test(a_breached_condition_is_reported) :-
    sample_attestation(Attestation),
    gdpr_chapter_v_extras_status([attribute(transfer_is_onward_transfer, attested(true, Attestation)), attribute(onward_transfer_has_chapter_v_basis, attested(false, Attestation))], condition_breached).
test(a_bad_profile_gets_input_problems_in_the_facade) :-
    decide_gdpr_chapter_v_extras([attribute(party_role, owner)], gdpr_chapter_v_extras_verdict(input_problems([wrong_type(party_role)]), [])).

test(the_supervisory_authority_duty_is_not_unmet, fail) :-
    sample_attestation(Attestation),
    Profile = [attribute(transfer_relies_on_article_49_1_second_subparagraph, attested(true, Attestation)), attribute(party_role, controller), attribute(supervisory_authority_informed_of_transfer, true)],
    second_subparagraph_duty(Profile, inform_supervisory_authority, duty_not_met, _, _).
test(article_48_does_not_bar_with_an_agreement, fail) :-
    sample_attestation(Attestation),
    Profile = [attribute(third_country_judgment_or_decision_requires_transfer, attested(true, Attestation)), attribute(international_agreement_basis_for_judgment_or_decision, attested(true, Attestation))],
    foreign_judgment_or_decision_recognition(Profile, not_recognisable_or_enforceable, _, _).
