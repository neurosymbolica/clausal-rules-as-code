% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_complaints_and_judicial_remedies_gdpr_complaints_and_judicial_remedies, [complaint_right/3, authority_decision_remedy_right/3, authority_inaction_remedy_right/4, controller_processor_remedy_right/3, controller_processor_forum/3, complaint_right_exists/0, no_complaint_right/0, decision_remedy_right_exists/0, no_decision_remedy_right/0, inaction_remedy_right_exists/0, no_inaction_remedy_right/0, judicial_remedy_right_exists/0, no_judicial_remedy_right/0, forum_establishment_state_only/0, forum_establishment_or_habitual_residence_state/0, decide_gdpr_complaints_and_judicial_remedies/2, gdpr_complaints_and_judicial_remedies_status/2, gdpr_complaints_and_judicial_remedies_checklist/2, gdpr_complaints_and_judicial_remedies_decision_resolvable/1, gdpr_complaints_and_judicial_remedies_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_complaints_and_judicial_remedies_kernel, [gdpr_complaints_and_judicial_remedies_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_complaints_and_judicial_remedies_citations, [implements/1]).
:- use_module(formalize_lib, [profile_get/3, profile_has/2, profile_lacks/2, member_matching/2, not_member/2]).

complaint_right_exists.

no_complaint_right.

decision_remedy_right_exists.

no_decision_remedy_right.

inaction_remedy_right_exists.

no_inaction_remedy_right.

judicial_remedy_right_exists.

no_judicial_remedy_right.

forum_establishment_state_only.

forum_establishment_or_habitual_residence_state.

gdpr_complaints_and_judicial_remedies_status_values([remedy_available, no_remedy_available, remedy_open]).

profile_state(Profile, ProfileKey, absent) :-
    profile_lacks(Profile, ProfileKey).
profile_state(Profile, ProfileKey, Value) :-
    profile_has(Profile, ProfileKey),
    profile_get(Profile, ProfileKey, Value).

complaint_right(Profile, input_problems([Problem|Problems]), []) :-
    gdpr_complaints_and_judicial_remedies_input_problems(Profile, [Problem|Problems]).
complaint_right(Profile, Result, Citations) :-
    gdpr_complaints_and_judicial_remedies_input_problems(Profile, []),
    profile_state(Profile, is_data_subject, DataSubject),
    profile_state(Profile, data_subject_considers_processing_infringes_regulation, Considers),
    complaint_route(DataSubject, Considers, Result, Citations).

complaint_route(false, _, no_complaint_right, [cite(eu_reg_2016_679_art_77_1)]) :-
    implements(eu_reg_2016_679_art_77_1).
complaint_route(true, false, no_complaint_right, [cite(eu_reg_2016_679_art_77_1)]) :-
    implements(eu_reg_2016_679_art_77_1).
complaint_route(absent, false, no_complaint_right, [cite(eu_reg_2016_679_art_77_1)]) :-
    implements(eu_reg_2016_679_art_77_1).
complaint_route(absent, true, indeterminate([is_data_subject]), []) :-
    implements(eu_reg_2016_679_art_77_1).
complaint_route(absent, absent, indeterminate([is_data_subject]), []) :-
    implements(eu_reg_2016_679_art_77_1).
complaint_route(true, absent, indeterminate([data_subject_considers_processing_infringes_regulation]), []) :-
    implements(eu_reg_2016_679_art_77_1).
complaint_route(true, true, complaint_right_exists, [cite(eu_reg_2016_679_art_77_1)]) :-
    implements(eu_reg_2016_679_art_77_1).

authority_decision_remedy_right(Profile, input_problems([Problem|Problems]), []) :-
    gdpr_complaints_and_judicial_remedies_input_problems(Profile, [Problem|Problems]).
authority_decision_remedy_right(Profile, Result, Citations) :-
    gdpr_complaints_and_judicial_remedies_input_problems(Profile, []),
    profile_state(Profile, decision_is_legally_binding, Binding),
    profile_state(Profile, decision_concerns_the_caller, Concerns),
    decision_route(Binding, Concerns, Result, Citations).

judgement_answered(true).
judgement_answered(unsure).

decision_route(false, _, no_decision_remedy_right, [cite(eu_reg_2016_679_art_78_1)]) :-
    implements(eu_reg_2016_679_art_78_1).
decision_route(Binding, false, no_decision_remedy_right, [cite(eu_reg_2016_679_art_78_1)]) :-
    implements(eu_reg_2016_679_art_78_1),
    dif(Binding, false).
decision_route(absent, Concerns, indeterminate([decision_is_legally_binding]), []) :-
    implements(eu_reg_2016_679_art_78_1),
    dif(Concerns, false).
decision_route(Binding, absent, indeterminate([decision_concerns_the_caller]), []) :-
    implements(eu_reg_2016_679_art_78_1),
    judgement_answered(Binding).
decision_route(unsure, Concerns, needs_legal_review(open_textured(decision_is_legally_binding, cite(eu_reg_2016_679_art_78_1)), [inputs_relied_on([decision_is_legally_binding - unsure, decision_concerns_the_caller - Concerns])]), []) :-
    implements(eu_reg_2016_679_art_78_1),
    judgement_answered(Concerns).
decision_route(true, unsure, needs_legal_review(open_textured(decision_concerns_the_caller, cite(eu_reg_2016_679_art_78_1)), [inputs_relied_on([decision_is_legally_binding - true, decision_concerns_the_caller - unsure])]), []) :-
    implements(eu_reg_2016_679_art_78_1).
decision_route(true, true, decision_remedy_right_exists, [cite(eu_reg_2016_679_art_78_1)]) :-
    implements(eu_reg_2016_679_art_78_1).

authority_inaction_remedy_right(Profile, input_problems([Problem|Problems]), [], []) :-
    gdpr_complaints_and_judicial_remedies_input_problems(Profile, [Problem|Problems]).
authority_inaction_remedy_right(Profile, Result, Basis, Citations) :-
    gdpr_complaints_and_judicial_remedies_input_problems(Profile, []),
    profile_state(Profile, is_data_subject, DataSubject),
    profile_state(Profile, complaint_lodged_under_article_77, ComplaintLodged),
    profile_state(Profile, authority_competent_under_articles_55_and_56, CompetenceValue),
    profile_state(Profile, authority_handled_the_complaint, Handled),
    profile_state(Profile, three_months_from_the_complaint_have_passed, ThreeMonths),
    profile_state(Profile, authority_informed_on_progress_or_outcome, Informed),
    competence_state(CompetenceValue, Competence),
    failure_state(Handled, ThreeMonths, Informed, Failure),
    inaction_route(DataSubject, ComplaintLodged, Competence, Failure, Result, Basis, Citations).

competence_state(absent, absent) :-
    implements(competence_statement).
competence_state(attested(true, Attestation), stated_competent(attested(true, Attestation))) :-
    implements(competence_statement).
competence_state(attested(false, Attestation), stated_not_competent(attested(false, Attestation))) :-
    implements(competence_statement).

competence_not_denied(absent) :-
    implements(competence_statement).
competence_not_denied(stated_competent(_)) :-
    implements(competence_statement).

failure_state(false, _, _, holds) :-
    implements(eu_reg_2016_679_art_78_2).
failure_state(true, false, _, settled_absent) :-
    implements(eu_reg_2016_679_art_78_2).
failure_state(true, ThreeMonths, true, settled_absent) :-
    implements(eu_reg_2016_679_art_78_2),
    dif(ThreeMonths, false).
failure_state(true, true, false, holds) :-
    implements(eu_reg_2016_679_art_78_2).
failure_state(true, true, absent, missing(authority_informed_on_progress_or_outcome)) :-
    implements(eu_reg_2016_679_art_78_2).
failure_state(true, absent, Informed, missing(three_months_from_the_complaint_have_passed)) :-
    implements(eu_reg_2016_679_art_78_2),
    dif(Informed, true).
failure_state(absent, _, _, missing(authority_handled_the_complaint)) :-
    implements(eu_reg_2016_679_art_78_2).

failure_open(holds) :-
    implements(eu_reg_2016_679_art_78_2).
failure_open(missing(_)) :-
    implements(eu_reg_2016_679_art_78_2).

inaction_route(false, _, _, _, no_inaction_remedy_right, [], [cite(eu_reg_2016_679_art_78_2)]) :-
    implements(eu_reg_2016_679_art_78_2).
inaction_route(DataSubject, false, _, _, no_inaction_remedy_right, [], [cite(eu_reg_2016_679_art_78_2)]) :-
    implements(eu_reg_2016_679_art_78_2),
    dif(DataSubject, false).
inaction_route(DataSubject, ComplaintLodged, stated_not_competent(Attested), _, no_inaction_remedy_right, [outside_fact(authority_competent_under_articles_55_and_56, Attested)], [cite(eu_reg_2016_679_art_78_2)]) :-
    implements(eu_reg_2016_679_art_78_2),
    dif(DataSubject, false),
    dif(ComplaintLodged, false).
inaction_route(DataSubject, ComplaintLodged, Competence, settled_absent, no_inaction_remedy_right, [], [cite(eu_reg_2016_679_art_78_2)]) :-
    implements(eu_reg_2016_679_art_78_2),
    dif(DataSubject, false),
    dif(ComplaintLodged, false),
    competence_not_denied(Competence).
inaction_route(absent, ComplaintLodged, Competence, Failure, indeterminate([is_data_subject]), [], []) :-
    implements(eu_reg_2016_679_art_78_2),
    dif(ComplaintLodged, false),
    competence_not_denied(Competence),
    failure_open(Failure).
inaction_route(true, absent, Competence, Failure, indeterminate([complaint_lodged_under_article_77]), [], []) :-
    implements(eu_reg_2016_679_art_78_2),
    competence_not_denied(Competence),
    failure_open(Failure).
inaction_route(true, true, Competence, missing(MissingKey), indeterminate([MissingKey]), [], []) :-
    implements(eu_reg_2016_679_art_78_2),
    competence_not_denied(Competence).
inaction_route(true, true, absent, holds, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_78_2), cite(competence_statement)), [resolution(cite(competence_statement), not_attempted), inputs_relied_on([authority_competent_under_articles_55_and_56 - absent])]), [], []) :-
    implements(eu_reg_2016_679_art_78_2).
inaction_route(true, true, stated_competent(Attested), holds, inaction_remedy_right_exists, [outside_fact(authority_competent_under_articles_55_and_56, Attested)], [cite(eu_reg_2016_679_art_78_2)]) :-
    implements(eu_reg_2016_679_art_78_2).

controller_processor_remedy_right(Profile, input_problems([Problem|Problems]), []) :-
    gdpr_complaints_and_judicial_remedies_input_problems(Profile, [Problem|Problems]).
controller_processor_remedy_right(Profile, Result, Citations) :-
    gdpr_complaints_and_judicial_remedies_input_problems(Profile, []),
    profile_state(Profile, is_data_subject, DataSubject),
    profile_state(Profile, data_subject_considers_rights_infringed_by_processing, Considers),
    judicial_remedy_route(DataSubject, Considers, Result, Citations).

judicial_remedy_route(false, _, no_judicial_remedy_right, [cite(eu_reg_2016_679_art_79_1)]) :-
    implements(eu_reg_2016_679_art_79_1).
judicial_remedy_route(true, false, no_judicial_remedy_right, [cite(eu_reg_2016_679_art_79_1)]) :-
    implements(eu_reg_2016_679_art_79_1).
judicial_remedy_route(absent, false, no_judicial_remedy_right, [cite(eu_reg_2016_679_art_79_1)]) :-
    implements(eu_reg_2016_679_art_79_1).
judicial_remedy_route(absent, true, indeterminate([is_data_subject]), []) :-
    implements(eu_reg_2016_679_art_79_1).
judicial_remedy_route(absent, absent, indeterminate([is_data_subject]), []) :-
    implements(eu_reg_2016_679_art_79_1).
judicial_remedy_route(true, absent, indeterminate([data_subject_considers_rights_infringed_by_processing]), []) :-
    implements(eu_reg_2016_679_art_79_1).
judicial_remedy_route(true, true, judicial_remedy_right_exists, [cite(eu_reg_2016_679_art_79_1)]) :-
    implements(eu_reg_2016_679_art_79_1).

controller_processor_forum(Profile, input_problems([Problem|Problems]), []) :-
    gdpr_complaints_and_judicial_remedies_input_problems(Profile, [Problem|Problems]).
controller_processor_forum(Profile, Result, Citations) :-
    gdpr_complaints_and_judicial_remedies_input_problems(Profile, []),
    profile_state(Profile, defendant_is_member_state_public_authority_acting_in_public_powers, PublicAuthority),
    forum_route(PublicAuthority, Result, Citations).

forum_route(absent, indeterminate([defendant_is_member_state_public_authority_acting_in_public_powers]), []) :-
    implements(eu_reg_2016_679_art_79_2).
forum_route(true, forum_establishment_state_only, [cite(eu_reg_2016_679_art_79_2)]) :-
    implements(eu_reg_2016_679_art_79_2).
forum_route(false, forum_establishment_or_habitual_residence_state, [cite(eu_reg_2016_679_art_79_2)]) :-
    implements(eu_reg_2016_679_art_79_2).

gdpr_complaints_and_judicial_remedies_checklist(Profile, [item(complaint_right, ComplaintStatus, cite(eu_reg_2016_679_art_77_1)), item(authority_decision_remedy_right, DecisionStatus, cite(eu_reg_2016_679_art_78_1)), item(authority_inaction_remedy_right, InactionStatus, cite(eu_reg_2016_679_art_78_2)), item(controller_processor_remedy_right, JudicialStatus, cite(eu_reg_2016_679_art_79_1))]) :-
    gdpr_complaints_and_judicial_remedies_input_problems(Profile, []),
    complaint_right(Profile, ComplaintResult, _),
    item_status(ComplaintResult, complaint_right_exists, no_complaint_right, ComplaintStatus),
    authority_decision_remedy_right(Profile, DecisionResult, _),
    item_status(DecisionResult, decision_remedy_right_exists, no_decision_remedy_right, DecisionStatus),
    authority_inaction_remedy_right(Profile, InactionResult, _, _),
    item_status(InactionResult, inaction_remedy_right_exists, no_inaction_remedy_right, InactionStatus),
    controller_processor_remedy_right(Profile, JudicialResult, _),
    item_status(JudicialResult, judicial_remedy_right_exists, no_judicial_remedy_right, JudicialStatus).

item_status(Positive, Positive, _, met).
item_status(Negative, _, Negative, unmet(Negative)).
item_status(indeterminate(MissingKeys), _, _, unknown(MissingKeys)).
item_status(needs_legal_review(open_textured(Judgement, _), _), _, _, unknown([Judgement])).
item_status(needs_legal_review(cross_reference_unresolved(_, _), _), _, _, unknown([authority_competent_under_articles_55_and_56])).

decide_gdpr_complaints_and_judicial_remedies(Profile, gdpr_complaints_and_judicial_remedies_verdict(input_problems([Problem|Problems]), [])) :-
    gdpr_complaints_and_judicial_remedies_input_problems(Profile, [Problem|Problems]).
decide_gdpr_complaints_and_judicial_remedies(Profile, gdpr_complaints_and_judicial_remedies_verdict(remedy_available, Citations)) :-
    gdpr_complaints_and_judicial_remedies_checklist(Profile, Items),
    member_matching(item(_, met, _), Items),
    findall(Citation, member(item(_, met, Citation), Items), MetCitations),
    sort(MetCitations, Citations).
decide_gdpr_complaints_and_judicial_remedies(Profile, gdpr_complaints_and_judicial_remedies_verdict(no_remedy_available, Citations)) :-
    gdpr_complaints_and_judicial_remedies_checklist(Profile, Items),
    not_member(item(_, met, _), Items),
    not_member(item(_, unknown(_), _), Items),
    findall(Citation, member(item(_, _, Citation), Items), AllCitations),
    sort(AllCitations, Citations).
decide_gdpr_complaints_and_judicial_remedies(Profile, gdpr_complaints_and_judicial_remedies_verdict(remedy_open, [])) :-
    gdpr_complaints_and_judicial_remedies_checklist(Profile, Items),
    not_member(item(_, met, _), Items),
    member_matching(item(_, unknown(_), _), Items).

gdpr_complaints_and_judicial_remedies_status(Profile, Status) :-
    decide_gdpr_complaints_and_judicial_remedies(Profile, gdpr_complaints_and_judicial_remedies_verdict(Status, _Citations)).

gdpr_complaints_and_judicial_remedies_decision_resolvable(Profile) :-
    decide_gdpr_complaints_and_judicial_remedies(Profile, _Verdict).

test(the_result_atoms_are_defined) :-
    complaint_right_exists,
    no_complaint_right,
    decision_remedy_right_exists,
    no_decision_remedy_right,
    inaction_remedy_right_exists,
    no_inaction_remedy_right,
    judicial_remedy_right_exists,
    no_judicial_remedy_right,
    forum_establishment_state_only,
    forum_establishment_or_habitual_residence_state.
test(a_data_subject_who_considers_has_the_complaint_right) :-
    complaint_right([attribute(is_data_subject, true), attribute(data_subject_considers_processing_infringes_regulation, true)], complaint_right_exists, [cite(eu_reg_2016_679_art_77_1)]).
test(a_settled_false_decides_before_a_missing_key) :-
    complaint_right([attribute(data_subject_considers_processing_infringes_regulation, false)], no_complaint_right, [cite(eu_reg_2016_679_art_77_1)]).
test(an_empty_profile_names_the_first_missing_key) :-
    complaint_right([], indeterminate([is_data_subject]), []).
test(an_unknown_key_is_an_input_problem) :-
    complaint_right([attribute(colour, blue)], input_problems([unknown_key(colour)]), []).
test(the_complaint_right_has_one_answer) :-
    findall(Result, complaint_right([attribute(is_data_subject, true)], Result, _), Results),
    Results == [indeterminate([data_subject_considers_processing_infringes_regulation])].
test(a_binding_decision_concerning_the_caller_gives_the_remedy) :-
    authority_decision_remedy_right([attribute(decision_is_legally_binding, true), attribute(decision_concerns_the_caller, true)], decision_remedy_right_exists, [cite(eu_reg_2016_679_art_78_1)]).
test(a_false_judgement_refuses_the_decision_remedy) :-
    authority_decision_remedy_right([attribute(decision_is_legally_binding, unsure), attribute(decision_concerns_the_caller, false)], no_decision_remedy_right, [cite(eu_reg_2016_679_art_78_1)]).
test(an_unsure_judgement_still_names_a_missing_one) :-
    authority_decision_remedy_right([attribute(decision_is_legally_binding, unsure)], indeterminate([decision_concerns_the_caller]), []).
test(an_unsure_binding_goes_to_a_lawyer) :-
    authority_decision_remedy_right([attribute(decision_is_legally_binding, unsure), attribute(decision_concerns_the_caller, true)], needs_legal_review(open_textured(decision_is_legally_binding, cite(eu_reg_2016_679_art_78_1)), [inputs_relied_on([decision_is_legally_binding - unsure, decision_concerns_the_caller - true])]), []).
test(an_unsure_concern_goes_to_a_lawyer) :-
    authority_decision_remedy_right([attribute(decision_is_legally_binding, true), attribute(decision_concerns_the_caller, unsure)], needs_legal_review(open_textured(decision_concerns_the_caller, cite(eu_reg_2016_679_art_78_1)), [inputs_relied_on([decision_is_legally_binding - true, decision_concerns_the_caller - unsure])]), []).
test(an_unhandled_complaint_to_a_competent_authority_gives_the_remedy) :-
    Attested = attested(true, attestation(host, at, reason, none)),
    authority_inaction_remedy_right([attribute(is_data_subject, true), attribute(complaint_lodged_under_article_77, true), attribute(authority_competent_under_articles_55_and_56, Attested), attribute(authority_handled_the_complaint, false)], inaction_remedy_right_exists, [outside_fact(authority_competent_under_articles_55_and_56, Attested)], [cite(eu_reg_2016_679_art_78_2)]).
test(an_absent_competence_statement_refers) :-
    authority_inaction_remedy_right([attribute(is_data_subject, true), attribute(complaint_lodged_under_article_77, true), attribute(authority_handled_the_complaint, true), attribute(three_months_from_the_complaint_have_passed, true), attribute(authority_informed_on_progress_or_outcome, false)], needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_78_2), cite(competence_statement)), [resolution(cite(competence_statement), not_attempted), inputs_relied_on([authority_competent_under_articles_55_and_56 - absent])]), [], []).
test(an_attested_incompetent_authority_refuses_with_its_basis) :-
    Attested = attested(false, attestation(host, at, reason, none)),
    authority_inaction_remedy_right([attribute(authority_competent_under_articles_55_and_56, Attested)], no_inaction_remedy_right, [outside_fact(authority_competent_under_articles_55_and_56, Attested)], [cite(eu_reg_2016_679_art_78_2)]).
test(an_informing_settles_the_failure_whatever_the_period) :-
    authority_inaction_remedy_right([attribute(is_data_subject, true), attribute(complaint_lodged_under_article_77, true), attribute(authority_handled_the_complaint, true), attribute(authority_informed_on_progress_or_outcome, true)], no_inaction_remedy_right, [], [cite(eu_reg_2016_679_art_78_2)]).
test(the_informing_is_needed_only_after_the_period) :-
    authority_inaction_remedy_right([attribute(is_data_subject, true), attribute(complaint_lodged_under_article_77, true), attribute(authority_handled_the_complaint, true), attribute(three_months_from_the_complaint_have_passed, true)], indeterminate([authority_informed_on_progress_or_outcome]), [], []).
test(a_handled_complaint_needs_the_period) :-
    authority_inaction_remedy_right([attribute(is_data_subject, true), attribute(complaint_lodged_under_article_77, true), attribute(authority_handled_the_complaint, true)], indeterminate([three_months_from_the_complaint_have_passed]), [], []).
test(an_empty_inaction_profile_names_the_data_subject) :-
    authority_inaction_remedy_right([], indeterminate([is_data_subject]), [], []).
test(an_inaction_input_problem_has_empty_basis) :-
    authority_inaction_remedy_right([attribute(authority_competent_under_articles_55_and_56, true)], input_problems([wrong_type(authority_competent_under_articles_55_and_56)]), [], []).
test(a_data_subject_who_considers_rights_infringed_has_the_remedy) :-
    controller_processor_remedy_right([attribute(is_data_subject, true), attribute(data_subject_considers_rights_infringed_by_processing, true)], judicial_remedy_right_exists, [cite(eu_reg_2016_679_art_79_1)]).
test(a_non_data_subject_has_no_judicial_remedy) :-
    controller_processor_remedy_right([attribute(is_data_subject, false)], no_judicial_remedy_right, [cite(eu_reg_2016_679_art_79_1)]).
test(a_public_authority_defendant_gives_the_establishment_courts_only) :-
    controller_processor_forum([attribute(defendant_is_member_state_public_authority_acting_in_public_powers, true)], forum_establishment_state_only, [cite(eu_reg_2016_679_art_79_2)]).
test(another_defendant_gives_both_courts) :-
    controller_processor_forum([attribute(defendant_is_member_state_public_authority_acting_in_public_powers, false)], forum_establishment_or_habitual_residence_state, [cite(eu_reg_2016_679_art_79_2)]).
test(an_absent_exception_statement_is_named) :-
    controller_processor_forum([], indeterminate([defendant_is_member_state_public_authority_acting_in_public_powers]), []).
test(a_complaint_right_makes_a_remedy_available) :-
    decide_gdpr_complaints_and_judicial_remedies([attribute(is_data_subject, true), attribute(data_subject_considers_processing_infringes_regulation, true)], gdpr_complaints_and_judicial_remedies_verdict(remedy_available, [cite(eu_reg_2016_679_art_77_1)])).
test(a_non_data_subject_with_no_binding_decision_has_no_remedy) :-
    gdpr_complaints_and_judicial_remedies_status([attribute(is_data_subject, false), attribute(decision_is_legally_binding, false)], no_remedy_available).
test(an_empty_profile_is_open) :-
    gdpr_complaints_and_judicial_remedies_status([], remedy_open).
test(every_checklist_item_is_cited) :-
    gdpr_complaints_and_judicial_remedies_checklist([], Items),
    findall(Citation, member(item(_, _, Citation), Items), Citations),
    Citations == [cite(eu_reg_2016_679_art_77_1), cite(eu_reg_2016_679_art_78_1), cite(eu_reg_2016_679_art_78_2), cite(eu_reg_2016_679_art_79_1)].

test(a_data_subject_who_considers_is_not_refused, fail) :-
    complaint_right([attribute(is_data_subject, true), attribute(data_subject_considers_processing_infringes_regulation, true)], no_complaint_right, _).
test(an_unsure_concern_is_not_a_remedy, fail) :-
    authority_decision_remedy_right([attribute(decision_is_legally_binding, true), attribute(decision_concerns_the_caller, unsure)], decision_remedy_right_exists, _).
test(an_unhandled_complaint_is_not_refused, fail) :-
    authority_inaction_remedy_right([attribute(is_data_subject, true), attribute(complaint_lodged_under_article_77, true), attribute(authority_competent_under_articles_55_and_56, attested(true, attestation(host, at, reason, none))), attribute(authority_handled_the_complaint, false)], no_inaction_remedy_right, _, _).
test(a_non_data_subject_is_not_granted_the_judicial_remedy, fail) :-
    controller_processor_remedy_right([attribute(is_data_subject, false)], judicial_remedy_right_exists, _).
test(another_defendant_is_not_establishment_only, fail) :-
    controller_processor_forum([attribute(defendant_is_member_state_public_authority_acting_in_public_powers, false)], forum_establishment_state_only, _).
test(an_empty_profile_is_not_a_remedy, fail) :-
    gdpr_complaints_and_judicial_remedies_status([], remedy_available).
