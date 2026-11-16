% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_erasure_request_exception, [decide_request_exception/2, request_exception_status/2, request_exception/2, request_exception_rows/2, request_exception_first_met/2, request_exception_suspension/2, request_exception_open_keys/4, request_exception_open_judgement_keys/2, request_exception_citations/2, request_exception_referral_citation/2, request_exception_checklist/2, request_exception_decision_resolvable/1, request_exception_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(pairs), [pairs_values/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_erasure_kernel, [gdpr_data_subject_rights_erasure_input_problems/2, gdpr_data_subject_rights_erasure_request_type_route/2, gdpr_data_subject_rights_erasure_required_limb/3, gdpr_data_subject_rights_erasure_defeater_limb/3, gdpr_data_subject_rights_erasure_outside_fact_limb/4, gdpr_data_subject_rights_erasure_negated_limb/2, gdpr_data_subject_rights_erasure_conjunction/2, gdpr_data_subject_rights_erasure_disjunction/2, gdpr_data_subject_rights_erasure_first_met/2, gdpr_data_subject_rights_erasure_open_union/4, gdpr_data_subject_rights_erasure_keys_in_contract_order/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_erasure_citations, [implements/1]).

request_exception_status_values([art17_3_a, art17_3_b, art17_3_c, art17_3_d, art17_3_e, art12_5_manifestly_unfounded_or_excessive, art12_2_unable_to_identify, art23_legislative_restriction, none]).

exception_ground(art17_3_a, specific, cite(eu_reg_2016_679_art_17_3_a), [cite(eu_reg_2016_679_art_17_3), cite(eu_reg_2016_679_art_17_3_a)]).
exception_ground(art17_3_b, specific, cite(eu_reg_2016_679_art_17_3_b), [cite(eu_reg_2016_679_art_17_3), cite(eu_reg_2016_679_art_17_3_b)]).
exception_ground(art17_3_c, specific, cite(eu_reg_2016_679_art_17_3_c), [cite(eu_reg_2016_679_art_17_3), cite(eu_reg_2016_679_art_17_3_c)]).
exception_ground(art17_3_d, specific, cite(eu_reg_2016_679_art_17_3_d), [cite(eu_reg_2016_679_art_17_3), cite(eu_reg_2016_679_art_17_3_d)]).
exception_ground(art17_3_e, specific, cite(eu_reg_2016_679_art_17_3_e), [cite(eu_reg_2016_679_art_17_3), cite(eu_reg_2016_679_art_17_3_e)]).
exception_ground(art12_5_manifestly_unfounded_or_excessive, common, cite(eu_reg_2016_679_art_12_5), [cite(eu_reg_2016_679_art_12_5)]).
exception_ground(art12_2_unable_to_identify, common, cite(eu_reg_2016_679_art_12_2), [cite(eu_reg_2016_679_art_12_2)]).
exception_ground(art23_legislative_restriction, common, cite(eu_reg_2016_679_art_23_1), [cite(eu_reg_2016_679_art_23_1)]).

exception_order([art17_3_a, art17_3_b, art17_3_c, art17_3_d, art17_3_e, art12_5_manifestly_unfounded_or_excessive, art12_2_unable_to_identify, art23_legislative_restriction]).

limb_judgement_keys(art17_3_a, [processing_necessary_for_freedom_of_expression_and_information]).
limb_judgement_keys(art17_3_b, [processing_necessary_for_public_task_or_official_authority]).
limb_judgement_keys(art17_3_c, [processing_necessary_for_public_health_in_accordance_with_art9_2_h_and_i]).
limb_judgement_keys(art17_3_d, [processing_for_archiving_research_or_statistics_in_accordance_with_art89_1, erasure_would_render_impossible_or_seriously_impair_processing_objectives]).
limb_judgement_keys(art17_3_e, [processing_necessary_for_legal_claims]).
limb_judgement_keys(art12_5_manifestly_unfounded_or_excessive, [request_manifestly_unfounded_or_excessive]).
limb_judgement_keys(art12_2_unable_to_identify, []).
limb_judgement_keys(art23_legislative_restriction, []).
limb_judgement_keys(art12_6_identity_not_confirmed, [reasonable_doubts_about_identity]).

request_exception_referral_citation(reasonable_doubts_about_identity, cite(eu_reg_2016_679_art_12_6)).
request_exception_referral_citation(request_manifestly_unfounded_or_excessive, cite(eu_reg_2016_679_art_12_5)).
request_exception_referral_citation(processing_necessary_for_freedom_of_expression_and_information, cite(eu_reg_2016_679_art_17_3_a)).
request_exception_referral_citation(processing_necessary_for_public_task_or_official_authority, cite(eu_reg_2016_679_art_17_3_b)).
request_exception_referral_citation(processing_necessary_for_public_health_in_accordance_with_art9_2_h_and_i, cite(eu_reg_2016_679_art_17_3_c)).
request_exception_referral_citation(processing_for_archiving_research_or_statistics_in_accordance_with_art89_1, cite(eu_reg_2016_679_art_17_3_d)).
request_exception_referral_citation(erasure_would_render_impossible_or_seriously_impair_processing_objectives, cite(eu_reg_2016_679_art_17_3_d)).
request_exception_referral_citation(processing_necessary_for_legal_claims, cite(eu_reg_2016_679_art_17_3_e)).

request_exception_citations(Exception, Citations) :-
    exception_ground(Exception, _, _, Citations).

exception_limb(art17_3_a, Profile, ExceptionLimb) :-
    implements(eu_reg_2016_679_art_17_3_a),
    gdpr_data_subject_rights_erasure_defeater_limb(Profile, processing_necessary_for_freedom_of_expression_and_information, ExceptionLimb).
exception_limb(art17_3_b, Profile, ExceptionLimb) :-
    implements(eu_reg_2016_679_art_17_3_b),
    implements(union_or_member_state_law_requiring_processing),
    gdpr_data_subject_rights_erasure_outside_fact_limb(Profile, processing_required_by_union_or_member_state_law, blocking, LegalObligationLimb),
    gdpr_data_subject_rights_erasure_defeater_limb(Profile, processing_necessary_for_public_task_or_official_authority, PublicTaskLimb),
    gdpr_data_subject_rights_erasure_disjunction([LegalObligationLimb, PublicTaskLimb], ExceptionLimb).
exception_limb(art17_3_c, Profile, ExceptionLimb) :-
    implements(eu_reg_2016_679_art_17_3_c),
    gdpr_data_subject_rights_erasure_defeater_limb(Profile, processing_necessary_for_public_health_in_accordance_with_art9_2_h_and_i, ExceptionLimb).
exception_limb(art17_3_d, Profile, ExceptionLimb) :-
    implements(eu_reg_2016_679_art_17_3_d),
    gdpr_data_subject_rights_erasure_defeater_limb(Profile, processing_for_archiving_research_or_statistics_in_accordance_with_art89_1, ArchivingLimb),
    gdpr_data_subject_rights_erasure_defeater_limb(Profile, erasure_would_render_impossible_or_seriously_impair_processing_objectives, ImpairmentLimb),
    gdpr_data_subject_rights_erasure_conjunction([ArchivingLimb, ImpairmentLimb], ExceptionLimb).
exception_limb(art17_3_e, Profile, ExceptionLimb) :-
    implements(eu_reg_2016_679_art_17_3_e),
    gdpr_data_subject_rights_erasure_defeater_limb(Profile, processing_necessary_for_legal_claims, ExceptionLimb).
exception_limb(art12_5_manifestly_unfounded_or_excessive, Profile, ExceptionLimb) :-
    implements(eu_reg_2016_679_art_12_5),
    gdpr_data_subject_rights_erasure_defeater_limb(Profile, request_manifestly_unfounded_or_excessive, ExceptionLimb).
exception_limb(art12_2_unable_to_identify, Profile, ExceptionLimb) :-
    implements(eu_reg_2016_679_art_12_2),
    gdpr_data_subject_rights_erasure_defeater_limb(Profile, controller_demonstrates_unable_to_identify_data_subject, ExceptionLimb).
exception_limb(art23_legislative_restriction, Profile, ExceptionLimb) :-
    implements(eu_reg_2016_679_art_23_1),
    implements(union_or_member_state_law_restricting_the_right),
    gdpr_data_subject_rights_erasure_outside_fact_limb(Profile, legislative_restriction_applies_to_the_right, blocking, ExceptionLimb).

request_exception_rows(Profile, ExceptionRows) :-
    exception_order(ExceptionIdentifiers),
    exception_rows(ExceptionIdentifiers, Profile, ExceptionRows).

exception_rows([], _, []).
exception_rows([ExceptionIdentifier|ExceptionIdentifiers], Profile, [ExceptionIdentifier - ExceptionLimb|ExceptionRows]) :-
    exception_limb(ExceptionIdentifier, Profile, ExceptionLimb),
    exception_rows(ExceptionIdentifiers, Profile, ExceptionRows).

request_exception_first_met(Profile, Exception) :-
    request_exception_rows(Profile, ExceptionRows),
    gdpr_data_subject_rights_erasure_first_met(ExceptionRows, Exception).

request_exception_suspension(Profile, SuspensionLimb) :-
    implements(eu_reg_2016_679_art_12_6),
    gdpr_data_subject_rights_erasure_defeater_limb(Profile, reasonable_doubts_about_identity, DoubtsLimb),
    gdpr_data_subject_rights_erasure_required_limb(Profile, identity_confirmed, ConfirmedLimb),
    gdpr_data_subject_rights_erasure_negated_limb(ConfirmedLimb, UnconfirmedLimb),
    gdpr_data_subject_rights_erasure_conjunction([DoubtsLimb, UnconfirmedLimb], SuspensionLimb).

suspension_not_met(unmet).
suspension_not_met(open(_, _, _)).

request_exception_open_keys(Profile, AbsentKeys, UnsureKeys, OutsideKeys) :-
    request_exception_rows(Profile, ExceptionRows),
    pairs_values(ExceptionRows, ExceptionLimbs),
    request_exception_suspension(Profile, SuspensionLimb),
    append(ExceptionLimbs, [SuspensionLimb], AllLimbs),
    gdpr_data_subject_rights_erasure_open_union(AllLimbs, AbsentKeys, UnsureKeys, OutsideKeys).

request_exception_open_judgement_keys(Profile, JudgementKeys) :-
    request_exception_rows(Profile, ExceptionRows),
    request_exception_suspension(Profile, SuspensionLimb),
    append(ExceptionRows, [art12_6_identity_not_confirmed - SuspensionLimb], AllRows),
    open_row_keys(AllRows, CollectedKeys),
    gdpr_data_subject_rights_erasure_keys_in_contract_order(CollectedKeys, JudgementKeys).

open_row_keys([], []).
open_row_keys([_ - met|AllRows], CollectedKeys) :-
    open_row_keys(AllRows, CollectedKeys).
open_row_keys([_ - unmet|AllRows], CollectedKeys) :-
    open_row_keys(AllRows, CollectedKeys).
open_row_keys([RowIdentifier - open(_, _, _)|AllRows], CollectedKeys) :-
    limb_judgement_keys(RowIdentifier, RowKeys),
    open_row_keys(AllRows, RemainingKeys),
    append(RowKeys, RemainingKeys, CollectedKeys).

decide_request_exception(Profile, request_exception_verdict(input_problems([Problem|Problems]), none, [], [])) :-
    gdpr_data_subject_rights_erasure_input_problems(Profile, [Problem|Problems]).
decide_request_exception(Profile, request_exception_verdict(indeterminate([request_type]), none, [], [])) :-
    gdpr_data_subject_rights_erasure_input_problems(Profile, []),
    gdpr_data_subject_rights_erasure_request_type_route(Profile, absent).
decide_request_exception(Profile, request_exception_verdict(outside_this_order(request_type), none, [], [])) :-
    gdpr_data_subject_rights_erasure_input_problems(Profile, []),
    gdpr_data_subject_rights_erasure_request_type_route(Profile, outside_this_order(_)).
decide_request_exception(Profile, request_exception_verdict(relieved(Exception), Exception, [], Citations)) :-
    implements(eu_reg_2016_679_art_17_3),
    gdpr_data_subject_rights_erasure_input_problems(Profile, []),
    gdpr_data_subject_rights_erasure_request_type_route(Profile, in_order),
    request_exception_first_met(Profile, Exception),
    exception_ground(Exception, specific, _, Citations).
decide_request_exception(Profile, request_exception_verdict(relieved(art12_5_manifestly_unfounded_or_excessive), art12_5_manifestly_unfounded_or_excessive, [reasonable_fee_may_be_charged], [cite(eu_reg_2016_679_art_12_5)])) :-
    implements(eu_reg_2016_679_art_12_5),
    gdpr_data_subject_rights_erasure_input_problems(Profile, []),
    gdpr_data_subject_rights_erasure_request_type_route(Profile, in_order),
    request_exception_first_met(Profile, art12_5_manifestly_unfounded_or_excessive).
decide_request_exception(Profile, request_exception_verdict(relieved(art12_2_unable_to_identify), art12_2_unable_to_identify, [], [cite(eu_reg_2016_679_art_12_2)])) :-
    implements(eu_reg_2016_679_art_12_2),
    gdpr_data_subject_rights_erasure_input_problems(Profile, []),
    gdpr_data_subject_rights_erasure_request_type_route(Profile, in_order),
    request_exception_first_met(Profile, art12_2_unable_to_identify).
decide_request_exception(Profile, request_exception_verdict(relieved(art23_legislative_restriction), art23_legislative_restriction, [], [cite(eu_reg_2016_679_art_23_1)])) :-
    implements(eu_reg_2016_679_art_23_1),
    gdpr_data_subject_rights_erasure_input_problems(Profile, []),
    gdpr_data_subject_rights_erasure_request_type_route(Profile, in_order),
    request_exception_first_met(Profile, art23_legislative_restriction).
decide_request_exception(Profile, request_exception_verdict(suspended(art12_6_identity_not_confirmed), none, [], [])) :-
    implements(eu_reg_2016_679_art_12_6),
    gdpr_data_subject_rights_erasure_input_problems(Profile, []),
    gdpr_data_subject_rights_erasure_request_type_route(Profile, in_order),
    request_exception_first_met(Profile, none),
    request_exception_suspension(Profile, met).
decide_request_exception(Profile, request_exception_verdict(not_relieved, none, [], [])) :-
    implements(eu_reg_2016_679_art_17_3),
    gdpr_data_subject_rights_erasure_input_problems(Profile, []),
    gdpr_data_subject_rights_erasure_request_type_route(Profile, in_order),
    request_exception_first_met(Profile, none),
    request_exception_suspension(Profile, SuspensionLimb),
    suspension_not_met(SuspensionLimb),
    request_exception_open_keys(Profile, [], [], []).
decide_request_exception(Profile, request_exception_verdict(open_by_absence([MissingKey|MissingKeys]), none, [], [])) :-
    implements(eu_reg_2016_679_art_17_3),
    gdpr_data_subject_rights_erasure_input_problems(Profile, []),
    gdpr_data_subject_rights_erasure_request_type_route(Profile, in_order),
    request_exception_first_met(Profile, none),
    request_exception_suspension(Profile, SuspensionLimb),
    suspension_not_met(SuspensionLimb),
    request_exception_open_keys(Profile, [MissingKey|MissingKeys], _, _).
decide_request_exception(Profile, request_exception_verdict(open_by_judgement([UnsureKey|UnsureKeys]), none, [], [])) :-
    implements(eu_reg_2016_679_art_17_3),
    gdpr_data_subject_rights_erasure_input_problems(Profile, []),
    gdpr_data_subject_rights_erasure_request_type_route(Profile, in_order),
    request_exception_first_met(Profile, none),
    request_exception_suspension(Profile, SuspensionLimb),
    suspension_not_met(SuspensionLimb),
    request_exception_open_keys(Profile, [], [UnsureKey|UnsureKeys], _).

request_exception_status(Profile, Status) :-
    decide_request_exception(Profile, request_exception_verdict(Status, _, _, _)).

request_exception(Profile, Exception) :-
    decide_request_exception(Profile, request_exception_verdict(_, Exception, _, _)).

request_exception_decision_resolvable(Profile) :-
    decide_request_exception(Profile, _).

request_exception_checklist(Profile, Items) :-
    gdpr_data_subject_rights_erasure_input_problems(Profile, []),
    gdpr_data_subject_rights_erasure_request_type_route(Profile, in_order),
    request_exception_rows(Profile, ExceptionRows),
    exception_items(ExceptionRows, ExceptionItems),
    request_exception_suspension(Profile, SuspensionLimb),
    limb_item_status(SuspensionLimb, identity_not_in_doubt_or_confirmed, SuspensionStatus),
    append(ExceptionItems, [item(art12_6_identity_not_confirmed, SuspensionStatus, cite(eu_reg_2016_679_art_12_6))], Items).
request_exception_checklist(Profile, []) :-
    gdpr_data_subject_rights_erasure_input_problems(Profile, [_|_]).
request_exception_checklist(Profile, []) :-
    gdpr_data_subject_rights_erasure_input_problems(Profile, []),
    gdpr_data_subject_rights_erasure_request_type_route(Profile, absent).
request_exception_checklist(Profile, []) :-
    gdpr_data_subject_rights_erasure_input_problems(Profile, []),
    gdpr_data_subject_rights_erasure_request_type_route(Profile, outside_this_order(_)).

exception_items([], []).
exception_items([ExceptionIdentifier - ExceptionLimb|ExceptionRows], [item(ExceptionIdentifier, ItemStatus, PointCitation)|Items]) :-
    exception_ground(ExceptionIdentifier, _, PointCitation, _),
    limb_item_status(ExceptionLimb, exception_not_established, ItemStatus),
    exception_items(ExceptionRows, Items).

limb_item_status(met, _, met).
limb_item_status(unmet, Reason, unmet(Reason)).
limb_item_status(open(AbsentKeys, UnsureKeys, OutsideKeys), _, unknown(OpenKeys)) :-
    append(AbsentKeys, UnsureKeys, FirstKeys),
    append(FirstKeys, OutsideKeys, OpenKeys).

example_profile(freedom_of_expression, [attribute(request_type, erasure), attribute(processing_necessary_for_freedom_of_expression_and_information, true)]).
example_profile(freedom_and_manifestly_excessive, [attribute(request_type, erasure), attribute(processing_necessary_for_freedom_of_expression_and_information, true), attribute(request_manifestly_unfounded_or_excessive, true)]).
example_profile(manifestly_excessive, [attribute(request_type, erasure), attribute(request_manifestly_unfounded_or_excessive, true)]).
example_profile(archiving_without_impairment, [attribute(request_type, erasure), attribute(processing_for_archiving_research_or_statistics_in_accordance_with_art89_1, true), attribute(erasure_would_render_impossible_or_seriously_impair_processing_objectives, false)]).
example_profile(archiving_impairment_unsure, [attribute(request_type, erasure), attribute(processing_necessary_for_freedom_of_expression_and_information, false), attribute(processing_for_archiving_research_or_statistics_in_accordance_with_art89_1, true), attribute(erasure_would_render_impossible_or_seriously_impair_processing_objectives, unsure)]).
example_profile(legal_obligation_requires_processing, [attribute(request_type, erasure), attribute(processing_necessary_for_public_task_or_official_authority, false), attribute(processing_required_by_union_or_member_state_law, attested(true, attestation(by, at, reason, none)))]).
example_profile(identity_not_confirmed, [attribute(request_type, erasure), attribute(reasonable_doubts_about_identity, true), attribute(identity_confirmed, false)]).
example_profile(identity_confirmation_missing, [attribute(request_type, erasure), attribute(reasonable_doubts_about_identity, true)]).
example_profile(identity_missing_but_freedom_of_expression, [attribute(request_type, erasure), attribute(reasonable_doubts_about_identity, true), attribute(processing_necessary_for_freedom_of_expression_and_information, true)]).
example_profile(legislative_restriction, [attribute(request_type, erasure), attribute(legislative_restriction_applies_to_the_right, attested(true, attestation(by, at, reason, none)))]).

test(freedom_of_expression_relieves_under_point_a) :-
    example_profile(freedom_of_expression, Profile),
    findall(Verdict, decide_request_exception(Profile, Verdict), Verdicts),
    Verdicts == [request_exception_verdict(relieved(art17_3_a), art17_3_a, [], [cite(eu_reg_2016_679_art_17_3), cite(eu_reg_2016_679_art_17_3_a)])].
test(a_specific_exception_comes_before_article_12_5) :-
    example_profile(freedom_and_manifestly_excessive, Profile),
    findall(Exception, request_exception(Profile, Exception), Exceptions),
    Exceptions == [art17_3_a].
test(a_manifestly_excessive_request_carries_the_fee_condition) :-
    example_profile(manifestly_excessive, Profile),
    findall(Verdict, decide_request_exception(Profile, Verdict), Verdicts),
    Verdicts == [request_exception_verdict(relieved(art12_5_manifestly_unfounded_or_excessive), art12_5_manifestly_unfounded_or_excessive, [reasonable_fee_may_be_charged], [cite(eu_reg_2016_679_art_12_5)])].
test(archiving_without_impairment_is_not_relieved) :-
    example_profile(archiving_without_impairment, Profile),
    findall(Verdict, decide_request_exception(Profile, Verdict), Verdicts),
    Verdicts == [request_exception_verdict(not_relieved, none, [], [])].
test(an_unsure_impairment_is_open_by_judgement) :-
    example_profile(archiving_impairment_unsure, Profile),
    findall(Status, request_exception_status(Profile, Status), Statuses),
    Statuses == [open_by_judgement([erasure_would_render_impossible_or_seriously_impair_processing_objectives])].
test(the_open_point_d_limb_reads_both_judgements) :-
    example_profile(archiving_impairment_unsure, Profile),
    request_exception_open_judgement_keys(Profile, [processing_for_archiving_research_or_statistics_in_accordance_with_art89_1, erasure_would_render_impossible_or_seriously_impair_processing_objectives]).
test(an_attested_legal_obligation_relieves_under_point_b) :-
    example_profile(legal_obligation_requires_processing, Profile),
    findall(Exception, request_exception(Profile, Exception), Exceptions),
    Exceptions == [art17_3_b].
test(an_unconfirmed_identity_suspends) :-
    example_profile(identity_not_confirmed, Profile),
    findall(Verdict, decide_request_exception(Profile, Verdict), Verdicts),
    Verdicts == [request_exception_verdict(suspended(art12_6_identity_not_confirmed), none, [], [])].
test(a_missing_identity_confirmation_is_open_by_absence) :-
    example_profile(identity_confirmation_missing, Profile),
    findall(Status, request_exception_status(Profile, Status), Statuses),
    Statuses == [open_by_absence([identity_confirmed])].
test(a_settled_relief_stands_over_an_open_suspension) :-
    example_profile(identity_missing_but_freedom_of_expression, Profile),
    findall(Status, request_exception_status(Profile, Status), Statuses),
    Statuses == [relieved(art17_3_a)].
test(an_attested_legislative_restriction_relieves) :-
    example_profile(legislative_restriction, Profile),
    findall(Verdict, decide_request_exception(Profile, Verdict), Verdicts),
    Verdicts == [request_exception_verdict(relieved(art23_legislative_restriction), art23_legislative_restriction, [], [cite(eu_reg_2016_679_art_23_1)])].
test(a_bare_erasure_request_is_not_relieved) :-
    findall(Status, request_exception_status([attribute(request_type, erasure)], Status), Statuses),
    Statuses == [not_relieved].
test(an_access_request_is_outside_this_order) :-
    findall(Verdict, decide_request_exception([attribute(request_type, access)], Verdict), Verdicts),
    Verdicts == [request_exception_verdict(outside_this_order(request_type), none, [], [])].
test(an_absent_request_type_is_indeterminate) :-
    findall(Verdict, decide_request_exception([], Verdict), Verdicts),
    Verdicts == [request_exception_verdict(indeterminate([request_type]), none, [], [])].
test(a_wrong_judgement_value_is_an_input_problem) :-
    findall(Status, request_exception_status([attribute(request_type, erasure), attribute(request_manifestly_unfounded_or_excessive, maybe)], Status), Statuses),
    Statuses == [input_problems([wrong_type(request_manifestly_unfounded_or_excessive)])].
test(the_checklist_carries_a_cite_per_row) :-
    example_profile(freedom_of_expression, Profile),
    request_exception_checklist(Profile, Items),
    length(Items, 9),
    member(item(art17_3_a, met, cite(eu_reg_2016_679_art_17_3_a)), Items),
    member(item(art12_6_identity_not_confirmed, unmet(identity_not_in_doubt_or_confirmed), cite(eu_reg_2016_679_art_12_6)), Items).
test(the_checklist_of_an_outside_type_is_empty) :-
    findall(Items, request_exception_checklist([attribute(request_type, access)], Items), Checklists),
    Checklists == [[]].
test(the_referral_row_of_the_identity_doubts) :-
    request_exception_referral_citation(reasonable_doubts_about_identity, cite(eu_reg_2016_679_art_12_6)).

test(freedom_of_expression_is_not_not_relieved, fail) :-
    example_profile(freedom_of_expression, Profile),
    request_exception_status(Profile, not_relieved).
test(archiving_without_impairment_is_not_point_d, fail) :-
    example_profile(archiving_without_impairment, Profile),
    request_exception(Profile, art17_3_d).
test(an_unconfirmed_identity_is_not_a_relief, fail) :-
    example_profile(identity_not_confirmed, Profile),
    request_exception_status(Profile, relieved(_)).
test(an_absent_restriction_is_not_a_relief, fail) :-
    request_exception([attribute(request_type, erasure)], art23_legislative_restriction).
