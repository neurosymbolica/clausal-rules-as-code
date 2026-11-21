% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_chapter_v_extras_gdpr_chapter_v_extras, [second_subparagraph_duty/5, foreign_judgment_or_decision_recognition/4, onward_transfer_condition/4, decide_gdpr_chapter_v_extras/2, gdpr_chapter_v_extras_status/2, gdpr_chapter_v_extras_checklist/2, gdpr_chapter_v_extras_decision_resolvable/1, gdpr_chapter_v_extras_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(pairs), [pairs_values/2]).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(formalize_lib, [profile_get/3, profile_has/2, profile_lacks/2]).
:- use_module(m__eu_data_protection_gdpr_chapter_v_extras_kernel, [gdpr_chapter_v_extras_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_chapter_v_extras_citations, [implements/1]).

gdpr_chapter_v_extras_status_values([no_second_subparagraph_transfer, not_a_processor_duty, duty_met, duty_not_met, article_48_not_engaged, not_barred_by_article_48, not_recognisable_or_enforceable, not_an_onward_transfer, onward_transfer_may_take_place, onward_transfer_may_not_take_place]).

duty_atoms([inform_supervisory_authority, inform_data_subject, document_assessment_and_safeguards]).

duty_row(inform_supervisory_authority, duty_to_inform, [supervisory_authority_informed_of_transfer], cite(eu_reg_2016_679_art_49_1_second_subpara)).
duty_row(inform_data_subject, duty_to_inform, [data_subject_informed_of_transfer, data_subject_informed_of_compelling_legitimate_interests], cite(eu_reg_2016_679_art_49_1_second_subpara)).
duty_row(document_assessment_and_safeguards, duty_to_document, [assessment_documented_in_records, suitable_safeguards_documented_in_records], cite(eu_reg_2016_679_art_49_6)).

outside_fact_row(transfer_relies_on_article_49_1_second_subparagraph, cite(eu_reg_2016_679_art_49_1_second_subpara), cite(second_subparagraph_transfer_statement)).
outside_fact_row(third_country_judgment_or_decision_requires_transfer, cite(eu_reg_2016_679_art_48), cite(foreign_judgment_requires_transfer_statement)).
outside_fact_row(international_agreement_basis_for_judgment_or_decision, cite(eu_reg_2016_679_art_48), cite(international_agreement_basis_statement)).
outside_fact_row(transfer_is_onward_transfer, cite(eu_reg_2016_679_art_44), cite(onward_transfer_statement)).
outside_fact_row(onward_transfer_has_chapter_v_basis, cite(eu_reg_2016_679_art_44), cite(onward_transfer_chapter_v_basis_statement)).

key_state(Profile, ProfileKey, absent) :-
    profile_lacks(Profile, ProfileKey).
key_state(Profile, ProfileKey, present(Value)) :-
    profile_has(Profile, ProfileKey),
    profile_get(Profile, ProfileKey, Value).

absent_referral(OutsideKey, needs_legal_review(cross_reference_unresolved(Citation, Target), [resolution(Target, not_attempted), inputs_relied_on([OutsideKey - absent])])) :-
    outside_fact_row(OutsideKey, Citation, Target).

duty_input_problems(Profile, Duty, Problems) :-
    gdpr_chapter_v_extras_input_problems(Profile, ProfileProblems),
    duty_problems(Duty, DutyProblems),
    append(ProfileProblems, DutyProblems, Problems).

duty_problems(Duty, [wrong_type(duty)]) :-
    var(Duty).
duty_problems(Duty, DutyProblems) :-
    nonvar(Duty),
    duty_atoms(DutyAtoms),
    memberd_t(Duty, DutyAtoms, IsDuty),
    known_duty_problems(IsDuty, DutyProblems).

known_duty_problems(true, []).
known_duty_problems(false, [wrong_type(duty)]).

second_subparagraph_duty(Profile, Duty, Result, Basis, Citations) :-
    duty_input_problems(Profile, Duty, Problems),
    duty_answer(Problems, Profile, Duty, Result, Basis, Citations).

duty_answer([Problem|Problems], _, _, input_problems([Problem|Problems]), [], []).
duty_answer([], Profile, Duty, Result, Basis, Citations) :-
    duty_row(Duty, DutyKind, FulfilmentKeys, DutyCitation),
    key_state(Profile, party_role, RoleState),
    key_state(Profile, transfer_relies_on_article_49_1_second_subparagraph, TransferState),
    duty_step(DutyKind, RoleState, TransferState, Profile, FulfilmentKeys, DutyCitation, Result, Basis, Citations).

duty_step(duty_to_inform, present(processor), _, _, _, _, not_a_processor_duty, [], [cite(eu_reg_2016_679_art_49_1_second_subpara)]) :-
    implements(eu_reg_2016_679_art_49_1_second_subpara).
duty_step(duty_to_inform, absent, absent, _, _, _, Referral, [], []) :-
    implements(eu_reg_2016_679_art_49_1_second_subpara),
    absent_referral(transfer_relies_on_article_49_1_second_subparagraph, Referral).
duty_step(duty_to_inform, present(controller), absent, _, _, _, Referral, [], []) :-
    implements(eu_reg_2016_679_art_49_1_second_subpara),
    absent_referral(transfer_relies_on_article_49_1_second_subparagraph, Referral).
duty_step(duty_to_document, _, absent, _, _, _, Referral, [], []) :-
    implements(eu_reg_2016_679_art_49_6),
    absent_referral(transfer_relies_on_article_49_1_second_subparagraph, Referral).
duty_step(duty_to_inform, absent, present(_), _, _, _, indeterminate([party_role]), [], []) :-
    implements(eu_reg_2016_679_art_49_1_second_subpara).
duty_step(duty_to_inform, present(controller), present(attested(false, Attestation)), _, _, DutyCitation, no_second_subparagraph_transfer, [outside_fact(transfer_relies_on_article_49_1_second_subparagraph, attested(false, Attestation))], [DutyCitation]) :-
    implements(eu_reg_2016_679_art_49_1_second_subpara).
duty_step(duty_to_document, _, present(attested(false, Attestation)), _, _, DutyCitation, no_second_subparagraph_transfer, [outside_fact(transfer_relies_on_article_49_1_second_subparagraph, attested(false, Attestation))], [DutyCitation]) :-
    implements(eu_reg_2016_679_art_49_6).
duty_step(duty_to_inform, present(controller), present(attested(true, Attestation)), Profile, FulfilmentKeys, DutyCitation, Result, Basis, Citations) :-
    implements(eu_reg_2016_679_art_49_1_second_subpara),
    fulfilment(Profile, FulfilmentKeys, Outcome),
    fulfilment_answer(Outcome, attested(true, Attestation), DutyCitation, Result, Basis, Citations).
duty_step(duty_to_document, _, present(attested(true, Attestation)), Profile, FulfilmentKeys, DutyCitation, Result, Basis, Citations) :-
    implements(eu_reg_2016_679_art_49_6),
    implements(eu_reg_2016_679_art_30_1_e),
    implements(eu_reg_2016_679_art_30_2_c),
    implements(eu_reg_2016_679_art_30_5),
    fulfilment(Profile, FulfilmentKeys, Outcome),
    fulfilment_answer(Outcome, attested(true, Attestation), DutyCitation, Result, Basis, Citations).

fulfilment(Profile, FulfilmentKeys, Outcome) :-
    maplist(crisp_pair(Profile), FulfilmentKeys, KeyStates),
    pairs_values(KeyStates, States),
    memberd_t(false_value, States, HasFalse),
    fulfilment_outcome(HasFalse, KeyStates, Outcome).

crisp_pair(Profile, FulfilmentKey, FulfilmentKey - State) :-
    key_state(Profile, FulfilmentKey, KeyState),
    crisp_state(KeyState, State).

crisp_state(absent, absent).
crisp_state(present(true), true_value).
crisp_state(present(false), false_value).

fulfilment_outcome(true, _, not_met).
fulfilment_outcome(false, KeyStates, Outcome) :-
    first_absent(KeyStates, Outcome).

first_absent([], met).
first_absent([FulfilmentKey - absent|_], missing(FulfilmentKey)).
first_absent([_ - true_value|KeyStates], Outcome) :-
    first_absent(KeyStates, Outcome).

fulfilment_answer(not_met, Attested, DutyCitation, duty_not_met, [outside_fact(transfer_relies_on_article_49_1_second_subparagraph, Attested)], [DutyCitation]).
fulfilment_answer(missing(FulfilmentKey), _, _, indeterminate([FulfilmentKey]), [], []).
fulfilment_answer(met, Attested, DutyCitation, duty_met, [outside_fact(transfer_relies_on_article_49_1_second_subparagraph, Attested)], [DutyCitation]).

foreign_judgment_or_decision_recognition(Profile, Result, Basis, Citations) :-
    gdpr_chapter_v_extras_input_problems(Profile, Problems),
    article_48_answer(Problems, Profile, Result, Basis, Citations).

article_48_answer([Problem|Problems], _, input_problems([Problem|Problems]), [], []).
article_48_answer([], Profile, Result, Basis, Citations) :-
    key_state(Profile, third_country_judgment_or_decision_requires_transfer, JudgmentState),
    key_state(Profile, international_agreement_basis_for_judgment_or_decision, AgreementState),
    article_48_step(JudgmentState, AgreementState, Result, Basis, Citations).

article_48_step(absent, _, Referral, [], []) :-
    implements(eu_reg_2016_679_art_48),
    absent_referral(third_country_judgment_or_decision_requires_transfer, Referral).
article_48_step(present(attested(false, Attestation)), _, article_48_not_engaged, [outside_fact(third_country_judgment_or_decision_requires_transfer, attested(false, Attestation))], [cite(eu_reg_2016_679_art_48)]) :-
    implements(eu_reg_2016_679_art_48).
article_48_step(present(attested(true, _)), absent, Referral, [], []) :-
    implements(eu_reg_2016_679_art_48),
    absent_referral(international_agreement_basis_for_judgment_or_decision, Referral).
article_48_step(present(attested(true, JudgmentAttestation)), present(attested(true, AgreementAttestation)), not_barred_by_article_48, [outside_fact(third_country_judgment_or_decision_requires_transfer, attested(true, JudgmentAttestation)), outside_fact(international_agreement_basis_for_judgment_or_decision, attested(true, AgreementAttestation))], [cite(eu_reg_2016_679_art_48)]) :-
    implements(eu_reg_2016_679_art_48).
article_48_step(present(attested(true, JudgmentAttestation)), present(attested(false, AgreementAttestation)), not_recognisable_or_enforceable, [outside_fact(third_country_judgment_or_decision_requires_transfer, attested(true, JudgmentAttestation)), outside_fact(international_agreement_basis_for_judgment_or_decision, attested(false, AgreementAttestation))], [cite(eu_reg_2016_679_art_48)]) :-
    implements(eu_reg_2016_679_art_48).

onward_transfer_condition(Profile, Result, Basis, Citations) :-
    gdpr_chapter_v_extras_input_problems(Profile, Problems),
    onward_answer(Problems, Profile, Result, Basis, Citations).

onward_answer([Problem|Problems], _, input_problems([Problem|Problems]), [], []).
onward_answer([], Profile, Result, Basis, Citations) :-
    key_state(Profile, transfer_is_onward_transfer, OnwardState),
    key_state(Profile, onward_transfer_has_chapter_v_basis, ChapterState),
    onward_step(OnwardState, ChapterState, Result, Basis, Citations).

onward_step(absent, _, Referral, [], []) :-
    implements(eu_reg_2016_679_art_44),
    absent_referral(transfer_is_onward_transfer, Referral).
onward_step(present(attested(false, Attestation)), _, not_an_onward_transfer, [outside_fact(transfer_is_onward_transfer, attested(false, Attestation))], [cite(eu_reg_2016_679_art_44)]) :-
    implements(eu_reg_2016_679_art_44).
onward_step(present(attested(true, _)), absent, Referral, [], []) :-
    implements(eu_reg_2016_679_art_44),
    absent_referral(onward_transfer_has_chapter_v_basis, Referral).
onward_step(present(attested(true, OnwardAttestation)), present(attested(true, ChapterAttestation)), onward_transfer_may_take_place, [outside_fact(transfer_is_onward_transfer, attested(true, OnwardAttestation)), outside_fact(onward_transfer_has_chapter_v_basis, attested(true, ChapterAttestation))], [cite(eu_reg_2016_679_art_44)]) :-
    implements(eu_reg_2016_679_art_44).
onward_step(present(attested(true, OnwardAttestation)), present(attested(false, ChapterAttestation)), onward_transfer_may_not_take_place, [outside_fact(transfer_is_onward_transfer, attested(true, OnwardAttestation)), outside_fact(onward_transfer_has_chapter_v_basis, attested(false, ChapterAttestation))], [cite(eu_reg_2016_679_art_44)]) :-
    implements(eu_reg_2016_679_art_44).

decide_gdpr_chapter_v_extras(Profile, gdpr_chapter_v_extras_verdict(Result, Citations)) :-
    onward_transfer_condition(Profile, Result, _Basis, Citations).

gdpr_chapter_v_extras_status(Profile, Status) :-
    decide_gdpr_chapter_v_extras(Profile, gdpr_chapter_v_extras_verdict(Status, _Citations)).

gdpr_chapter_v_extras_checklist(Profile, [item(inform_supervisory_authority, SupervisoryResult, SupervisoryCitations), item(inform_data_subject, DataSubjectResult, DataSubjectCitations), item(document_assessment_and_safeguards, DocumentResult, DocumentCitations), item(article_48, JudgmentResult, JudgmentCitations), item(onward_transfer, OnwardResult, OnwardCitations)]) :-
    second_subparagraph_duty(Profile, inform_supervisory_authority, SupervisoryResult, _, SupervisoryCitations),
    second_subparagraph_duty(Profile, inform_data_subject, DataSubjectResult, _, DataSubjectCitations),
    second_subparagraph_duty(Profile, document_assessment_and_safeguards, DocumentResult, _, DocumentCitations),
    foreign_judgment_or_decision_recognition(Profile, JudgmentResult, _, JudgmentCitations),
    onward_transfer_condition(Profile, OnwardResult, _, OnwardCitations).

gdpr_chapter_v_extras_decision_resolvable(Profile) :-
    decide_gdpr_chapter_v_extras(Profile, _Verdict).

test(processor_duty_to_inform_whatever_the_transfer_fact) :-
    findall(Result - Basis - Citations, second_subparagraph_duty([attribute(party_role, processor)], inform_data_subject, Result, Basis, Citations), Answers),
    Answers == [not_a_processor_duty - [] - [cite(eu_reg_2016_679_art_49_1_second_subpara)]].
test(absent_transfer_fact_refers_before_party_role) :-
    findall(Result, second_subparagraph_duty([], inform_supervisory_authority, Result, _, _), Results),
    Results == [needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_49_1_second_subpara), cite(second_subparagraph_transfer_statement)), [resolution(cite(second_subparagraph_transfer_statement), not_attempted), inputs_relied_on([transfer_relies_on_article_49_1_second_subparagraph - absent])])].
test(party_role_named_when_transfer_fact_present) :-
    findall(Result, second_subparagraph_duty([attribute(transfer_relies_on_article_49_1_second_subparagraph, attested(false, attestation(by, at, reason, none)))], inform_data_subject, Result, _, _), Results),
    Results == [indeterminate([party_role])].
test(controller_no_second_subparagraph_transfer) :-
    findall(Result - Basis, second_subparagraph_duty([attribute(transfer_relies_on_article_49_1_second_subparagraph, attested(false, attestation(by, at, reason, none))), attribute(party_role, controller)], inform_supervisory_authority, Result, Basis, _), Answers),
    Answers == [no_second_subparagraph_transfer - [outside_fact(transfer_relies_on_article_49_1_second_subparagraph, attested(false, attestation(by, at, reason, none)))]].
test(false_key_decides_before_absent_key) :-
    findall(Result, second_subparagraph_duty([attribute(transfer_relies_on_article_49_1_second_subparagraph, attested(true, attestation(by, at, reason, none))), attribute(party_role, controller), attribute(data_subject_informed_of_compelling_legitimate_interests, false)], inform_data_subject, Result, _, _), Results),
    Results == [duty_not_met].
test(first_absent_fulfilment_key_named) :-
    findall(Result, second_subparagraph_duty([attribute(transfer_relies_on_article_49_1_second_subparagraph, attested(true, attestation(by, at, reason, none))), attribute(party_role, controller), attribute(data_subject_informed_of_compelling_legitimate_interests, true)], inform_data_subject, Result, _, _), Results),
    Results == [indeterminate([data_subject_informed_of_transfer])].
test(documentation_duty_ignores_party_role) :-
    findall(Result - Citations, second_subparagraph_duty([attribute(transfer_relies_on_article_49_1_second_subparagraph, attested(true, attestation(by, at, reason, none))), attribute(party_role, processor), attribute(assessment_documented_in_records, true), attribute(suitable_safeguards_documented_in_records, true)], document_assessment_and_safeguards, Result, _, Citations), Answers),
    Answers == [duty_met - [cite(eu_reg_2016_679_art_49_6)]].
test(bad_profile_and_bad_duty) :-
    findall(Result, second_subparagraph_duty(not_a_list, _, Result, _, _), Results),
    Results == [input_problems([wrong_type(profile), wrong_type(duty)])].
test(article_48_not_engaged) :-
    findall(Result, foreign_judgment_or_decision_recognition([attribute(third_country_judgment_or_decision_requires_transfer, attested(false, attestation(by, at, reason, none)))], Result, _, _), Results),
    Results == [article_48_not_engaged].
test(article_48_bars_without_agreement) :-
    findall(Result, foreign_judgment_or_decision_recognition([attribute(third_country_judgment_or_decision_requires_transfer, attested(true, attestation(by, at, reason, none))), attribute(international_agreement_basis_for_judgment_or_decision, attested(false, attestation(by, at, reason, none)))], Result, _, _), Results),
    Results == [not_recognisable_or_enforceable].
test(article_48_agreement_absent_refers) :-
    findall(Result, foreign_judgment_or_decision_recognition([attribute(third_country_judgment_or_decision_requires_transfer, attested(true, attestation(by, at, reason, none)))], Result, _, _), Results),
    Results == [needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_48), cite(international_agreement_basis_statement)), [resolution(cite(international_agreement_basis_statement), not_attempted), inputs_relied_on([international_agreement_basis_for_judgment_or_decision - absent])])].
test(onward_transfer_may_take_place) :-
    findall(Result, onward_transfer_condition([attribute(transfer_is_onward_transfer, attested(true, attestation(by, at, reason, none))), attribute(onward_transfer_has_chapter_v_basis, attested(true, attestation(by, at, reason, none)))], Result, _, _), Results),
    Results == [onward_transfer_may_take_place].
test(not_an_onward_transfer) :-
    findall(Result, onward_transfer_condition([attribute(transfer_is_onward_transfer, attested(false, attestation(by, at, reason, none)))], Result, _, _), Results),
    Results == [not_an_onward_transfer].
test(bare_boolean_outside_fact_is_wrong_type) :-
    findall(Result, onward_transfer_condition([attribute(transfer_is_onward_transfer, true)], Result, _, _), Results),
    Results == [input_problems([wrong_type(transfer_is_onward_transfer)])].

test(documentation_duty_met_is_not_a_processor_duty, fail) :-
    second_subparagraph_duty([attribute(transfer_relies_on_article_49_1_second_subparagraph, attested(true, attestation(by, at, reason, none))), attribute(party_role, processor), attribute(assessment_documented_in_records, true), attribute(suitable_safeguards_documented_in_records, true)], document_assessment_and_safeguards, not_a_processor_duty, _, _).
