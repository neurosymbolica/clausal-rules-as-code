% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_cooperation_with_the_supervisory_authority_gdpr_cooperation_with_the_supervisory_authority, [cooperation_duty/4, gdpr_cooperation_with_the_supervisory_authority_cooperation_duty/4, decide_gdpr_cooperation_with_the_supervisory_authority/2, gdpr_cooperation_with_the_supervisory_authority_status/2, gdpr_cooperation_with_the_supervisory_authority_checklist/2, gdpr_cooperation_with_the_supervisory_authority_decision_resolvable/1, gdpr_cooperation_with_the_supervisory_authority_status_values/1, cooperation_not_required/0, cooperation_met/0, cooperation_not_met/0, indeterminate/1, needs_legal_review/2, open_textured/2, cross_reference_unresolved/2, resolution/2, inputs_relied_on/1, provenance/2, outside_fact/2, attested/2, attestation/4, url/2, document/2, input_problems/1, unknown_key/1, wrong_type/1, duplicate_key/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [is_list/1]).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(formalize_lib, [profile_get/3, profile_has/2, profile_lacks/2]).
:- use_module(m__eu_data_protection_gdpr_cooperation_with_the_supervisory_authority_kernel, [gdpr_cooperation_with_the_supervisory_authority_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_cooperation_with_the_supervisory_authority_citations, [implements/1]).

cooperation_not_required.

cooperation_met.

cooperation_not_met.

indeterminate(MissingKeys) :-
    nonvar(MissingKeys),
    MissingKeys = [MissingKey],
    atom(MissingKey).

needs_legal_review(Reason, Context) :-
    legal_review_reason(Reason),
    is_list(Context),
    Context = [_|_].

legal_review_reason(Reason) :-
    nonvar(Reason),
    Reason = open_textured(Input, Citation),
    open_textured(Input, Citation).
legal_review_reason(Reason) :-
    nonvar(Reason),
    Reason = cross_reference_unresolved(Citation, Target),
    cross_reference_unresolved(Citation, Target).

open_textured(Input, Citation) :-
    atom(Input),
    cite_term(Citation).

cross_reference_unresolved(Citation, Target) :-
    cite_term(Citation),
    cite_term(Target).

resolution(Target, Status) :-
    cite_term(Target),
    atom(Status),
    resolution_status(Status).

resolution_status(not_attempted).

cite_term(Term) :-
    nonvar(Term),
    Term = cite(CitationKey),
    atom(CitationKey).

inputs_relied_on(Pairs) :-
    is_list(Pairs),
    maplist(relied_pair, Pairs).

relied_pair(Pair) :-
    nonvar(Pair),
    Pair = PairKey - PairValue,
    atom(PairKey),
    ground(PairValue).

outside_fact(FactKey, Attested) :-
    atom(FactKey),
    nonvar(Attested),
    Attested = attested(Value, Attestation),
    attested(Value, Attestation).

attested(Value, Attestation) :-
    atom(Value),
    boolean_value(Value),
    nonvar(Attestation),
    Attestation = attestation(Attester, AttestedAt, Reason, Evidence),
    attestation(Attester, AttestedAt, Reason, Evidence).

boolean_value(true).
boolean_value(false).

attestation(Attester, AttestedAt, Reason, Evidence) :-
    ground(Attester),
    ground(AttestedAt),
    ground(Reason),
    nonvar(Evidence),
    evidence_shape(Evidence).

evidence_shape(none).
evidence_shape(Evidence) :-
    Evidence = url(Address, RetrievedAt),
    url(Address, RetrievedAt).
evidence_shape(Evidence) :-
    Evidence = document(UploadIdentifier, Digest),
    document(UploadIdentifier, Digest).

url(Address, RetrievedAt) :-
    ground(Address),
    ground(RetrievedAt).

document(UploadIdentifier, Digest) :-
    ground(UploadIdentifier),
    ground(Digest).

input_problems(Problems) :-
    is_list(Problems),
    Problems = [_|_],
    maplist(input_problem, Problems).

input_problem(Problem) :-
    nonvar(Problem),
    problem_shape(Problem).

problem_shape(unknown_key(ProblemKey)) :-
    unknown_key(ProblemKey).
problem_shape(wrong_type(ProblemKey)) :-
    wrong_type(ProblemKey).
problem_shape(duplicate_key(ProblemKey)) :-
    duplicate_key(ProblemKey).

unknown_key(ProblemKey) :-
    ground(ProblemKey).

wrong_type(ProblemKey) :-
    atom(ProblemKey).

duplicate_key(ProblemKey) :-
    atom(ProblemKey).

provenance(_Source, Detail) :-
    nonvar(Detail).
provenance(_Source, Detail) :-
    var(Detail),
    provenance_detail_default(Detail).

provenance_detail_default(not_recorded).

gdpr_cooperation_with_the_supervisory_authority_status_values([cooperation_not_required, cooperation_met, cooperation_not_met]).

role_keys([acts_as_controller, acts_as_processor, acts_as_representative_of_controller_or_processor], cite(eu_reg_2016_679_art_31)).

needed_keys(bound, [authority_request_made, request_is_in_performance_of_authority_tasks], cite(eu_reg_2016_679_art_31)).
needed_keys(unsettled, [acts_as_controller, acts_as_processor, acts_as_representative_of_controller_or_processor, authority_request_made, request_is_in_performance_of_authority_tasks], cite(eu_reg_2016_679_art_31)).

key_state(Profile, Key, present(Value)) :-
    profile_get(Profile, Key, Value).
key_state(Profile, Key, absent) :-
    profile_lacks(Profile, Key).

profile_states(Profile, states(Controller, Processor, Representative, Request, Tasks, Cooperation)) :-
    key_state(Profile, acts_as_controller, Controller),
    key_state(Profile, acts_as_processor, Processor),
    key_state(Profile, acts_as_representative_of_controller_or_processor, Representative),
    key_state(Profile, authority_request_made, Request),
    key_state(Profile, request_is_in_performance_of_authority_tasks, Tasks),
    key_state(Profile, cooperation_given, Cooperation).

absent_keys(_, [], []).
absent_keys(Profile, [Key|Keys], [Key|Absent]) :-
    profile_lacks(Profile, Key),
    absent_keys(Profile, Keys, Absent).
absent_keys(Profile, [Key|Keys], Absent) :-
    profile_has(Profile, Key),
    absent_keys(Profile, Keys, Absent).

request_gate(present(false), closed) :-
    implements(eu_reg_2016_679_art_31).
request_gate(present(true), open) :-
    implements(eu_reg_2016_679_art_31).
request_gate(absent, open) :-
    implements(eu_reg_2016_679_art_31).

tasks_gate(present(false), closed) :-
    implements(eu_reg_2016_679_art_31).
tasks_gate(present(true), open) :-
    implements(eu_reg_2016_679_art_31).
tasks_gate(present(unsure), open) :-
    implements(eu_reg_2016_679_art_31).
tasks_gate(absent, open) :-
    implements(eu_reg_2016_679_art_31).

role_summary(RoleStates, Summary) :-
    implements(eu_reg_2016_679_art_31),
    memberd_t(present(true), RoleStates, HasTrue),
    memberd_t(absent, RoleStates, HasAbsent),
    role_summary_of(HasTrue, HasAbsent, Summary).

role_summary_of(true, _, bound) :-
    implements(eu_reg_2016_679_art_31).
role_summary_of(false, false, unbound) :-
    implements(eu_reg_2016_679_art_31).
role_summary_of(false, true, unsettled) :-
    implements(eu_reg_2016_679_art_31).

cooperation_duty(Profile, input_problems([Problem|Problems]), [], []) :-
    gdpr_cooperation_with_the_supervisory_authority_input_problems(Profile, [Problem|Problems]).
cooperation_duty(Profile, Result, Basis, Citations) :-
    gdpr_cooperation_with_the_supervisory_authority_input_problems(Profile, []),
    profile_states(Profile, States),
    duty_answer(Profile, States, Result, Basis, Citations).

gdpr_cooperation_with_the_supervisory_authority_cooperation_duty(Profile, Result, Basis, Citations) :-
    cooperation_duty(Profile, Result, Basis, Citations).

duty_answer(Profile, States, Result, Basis, Citations) :-
    States = states(Controller, Processor, Representative, Request, Tasks, _Cooperation),
    request_gate(Request, RequestGate),
    tasks_gate(Tasks, TasksGate),
    role_summary([Controller, Processor, Representative], Roles),
    duty_step(RequestGate, TasksGate, Roles, Profile, States, Result, Basis, Citations).

duty_step(closed, _, _, _, _, cooperation_not_required, [], [cite(eu_reg_2016_679_art_31)]) :-
    implements(eu_reg_2016_679_art_31).
duty_step(open, closed, _, _, _, cooperation_not_required, [], [cite(eu_reg_2016_679_art_31)]) :-
    implements(eu_reg_2016_679_art_31).
duty_step(open, open, unbound, _, _, cooperation_not_required, [], [cite(eu_reg_2016_679_art_31)]) :-
    implements(eu_reg_2016_679_art_31).
duty_step(open, open, Roles, Profile, States, Result, Basis, Citations) :-
    implements(eu_reg_2016_679_art_31),
    needed_keys(Roles, Keys, _Citation),
    absent_keys(Profile, Keys, Absent),
    missing_answer(Absent, States, Result, Basis, Citations).

missing_answer([Key|_], _, indeterminate([Key]), [], []).
missing_answer([], States, Result, Basis, Citations) :-
    settled_answer(States, Result, Basis, Citations).

settled_answer(states(_, _, _, _, present(TasksValue), absent), needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_31), cite(cooperation_statement)), [resolution(cite(cooperation_statement), not_attempted), inputs_relied_on([request_is_in_performance_of_authority_tasks - TasksValue, cooperation_given - absent])]), [], []) :-
    implements(eu_reg_2016_679_art_31).
settled_answer(states(_, _, _, _, present(unsure), present(_)), needs_legal_review(open_textured(request_is_in_performance_of_authority_tasks, cite(eu_reg_2016_679_art_31)), [inputs_relied_on([request_is_in_performance_of_authority_tasks - unsure])]), [], []) :-
    implements(eu_reg_2016_679_art_31).
settled_answer(states(_, _, _, _, present(true), present(attested(true, Attestation))), cooperation_met, [outside_fact(cooperation_given, attested(true, Attestation))], [cite(eu_reg_2016_679_art_31)]) :-
    implements(eu_reg_2016_679_art_31).
settled_answer(states(_, _, _, _, present(true), present(attested(false, Attestation))), cooperation_not_met, [outside_fact(cooperation_given, attested(false, Attestation))], [cite(eu_reg_2016_679_art_31)]) :-
    implements(eu_reg_2016_679_art_31).

decide_gdpr_cooperation_with_the_supervisory_authority(Profile, gdpr_cooperation_with_the_supervisory_authority_verdict(Status, Citations)) :-
    cooperation_duty(Profile, Status, _Basis, Citations).

gdpr_cooperation_with_the_supervisory_authority_status(Profile, Status) :-
    decide_gdpr_cooperation_with_the_supervisory_authority(Profile, gdpr_cooperation_with_the_supervisory_authority_verdict(Status, _Citations)).

gdpr_cooperation_with_the_supervisory_authority_decision_resolvable(Profile) :-
    decide_gdpr_cooperation_with_the_supervisory_authority(Profile, _Verdict).

gdpr_cooperation_with_the_supervisory_authority_checklist(Profile, [item(input_check, unmet(input_problems([Problem|Problems])), cite(eu_reg_2016_679_art_31))]) :-
    gdpr_cooperation_with_the_supervisory_authority_input_problems(Profile, [Problem|Problems]).
gdpr_cooperation_with_the_supervisory_authority_checklist(Profile, Items) :-
    gdpr_cooperation_with_the_supervisory_authority_input_problems(Profile, []),
    profile_states(Profile, states(Controller, Processor, Representative, Request, Tasks, Cooperation)),
    role_summary([Controller, Processor, Representative], Roles),
    party_status(Roles, Profile, PartyStatus),
    request_status(Request, RequestStatus),
    tasks_status(Tasks, TasksStatus),
    cooperation_status(Cooperation, CooperationStatus),
    Items = [item(party_bound, PartyStatus, cite(eu_reg_2016_679_art_31)), item(request_made, RequestStatus, cite(eu_reg_2016_679_art_31)), item(request_in_performance_of_tasks, TasksStatus, cite(eu_reg_2016_679_art_31)), item(cooperation_given, CooperationStatus, cite(eu_reg_2016_679_art_31))].

party_status(bound, _, met) :-
    implements(eu_reg_2016_679_art_31).
party_status(unbound, _, unmet(not_controller_processor_or_representative)) :-
    implements(eu_reg_2016_679_art_31).
party_status(unsettled, Profile, unknown([First])) :-
    implements(eu_reg_2016_679_art_31),
    role_keys(RoleKeys, _Citation),
    absent_keys(Profile, RoleKeys, [First|_]).

request_status(present(true), met) :-
    implements(eu_reg_2016_679_art_31).
request_status(present(false), unmet(no_request)) :-
    implements(eu_reg_2016_679_art_31).
request_status(absent, unknown([authority_request_made])) :-
    implements(eu_reg_2016_679_art_31).

tasks_status(present(true), met) :-
    implements(eu_reg_2016_679_art_31).
tasks_status(present(false), unmet(not_in_performance_of_tasks)) :-
    implements(eu_reg_2016_679_art_31).
tasks_status(present(unsure), unknown([request_is_in_performance_of_authority_tasks])) :-
    implements(eu_reg_2016_679_art_31).
tasks_status(absent, unknown([request_is_in_performance_of_authority_tasks])) :-
    implements(eu_reg_2016_679_art_31).

cooperation_status(present(attested(true, _)), met) :-
    implements(eu_reg_2016_679_art_31).
cooperation_status(present(attested(false, _)), unmet(cooperation_not_given)) :-
    implements(eu_reg_2016_679_art_31).
cooperation_status(absent, unknown([cooperation_given])) :-
    implements(eu_reg_2016_679_art_31).

sample_part(Key, Values, [attribute(Key, Value)]) :-
    member(Value, Values).
sample_part(_, _, []).

sample_profile(Profile) :-
    sample_part(acts_as_controller, [true, false], ControllerPart),
    sample_part(acts_as_processor, [true, false], ProcessorPart),
    sample_part(acts_as_representative_of_controller_or_processor, [true, false], RepresentativePart),
    sample_part(authority_request_made, [true, false], RequestPart),
    sample_part(request_is_in_performance_of_authority_tasks, [true, false, unsure], TasksPart),
    sample_part(cooperation_given, [attested(true, attestation(by, at, reason, none)), attested(false, attestation(by, at, reason, none))], CooperationPart),
    append([ControllerPart, ProcessorPart, RepresentativePart, RequestPart, TasksPart, CooperationPart], Profile).

exactly_one_answer(Profile) :-
    findall(Result - Basis - Citations, cooperation_duty(Profile, Result, Basis, Citations), Answers),
    length(Answers, 1).

test(every_combination_has_exactly_one_answer) :-
    findall(Profile, sample_profile(Profile), Profiles),
    length(Profiles, 972),
    maplist(exactly_one_answer, Profiles).
test(empty_profile_names_the_first_role_key) :-
    cooperation_duty([], Result, Basis, Citations),
    Result == indeterminate([acts_as_controller]),
    Basis == [],
    Citations == [].
test(no_request_is_not_required) :-
    cooperation_duty([attribute(acts_as_controller, true), attribute(authority_request_made, false)], Result, Basis, Citations),
    Result == cooperation_not_required,
    Basis == [],
    Citations == [cite(eu_reg_2016_679_art_31)].
test(request_outside_tasks_is_not_required) :-
    cooperation_duty([attribute(authority_request_made, true), attribute(request_is_in_performance_of_authority_tasks, false)], cooperation_not_required, [], [cite(eu_reg_2016_679_art_31)]).
test(unbound_caller_is_not_required) :-
    cooperation_duty([attribute(acts_as_controller, false), attribute(acts_as_processor, false), attribute(acts_as_representative_of_controller_or_processor, false), attribute(authority_request_made, true), attribute(request_is_in_performance_of_authority_tasks, true)], cooperation_not_required, [], [cite(eu_reg_2016_679_art_31)]).
test(bound_caller_without_request_key_is_indeterminate) :-
    cooperation_duty([attribute(acts_as_processor, true)], Result, [], []),
    Result == indeterminate([authority_request_made]).
test(representative_missing_judgement_is_indeterminate) :-
    cooperation_duty([attribute(acts_as_representative_of_controller_or_processor, true), attribute(authority_request_made, true)], Result, [], []),
    Result == indeterminate([request_is_in_performance_of_authority_tasks]).
test(absent_statement_refers_with_both_pairs) :-
    cooperation_duty([attribute(acts_as_controller, true), attribute(authority_request_made, true), attribute(request_is_in_performance_of_authority_tasks, true)], Result, Basis, Citations),
    Result == needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_31), cite(cooperation_statement)), [resolution(cite(cooperation_statement), not_attempted), inputs_relied_on([request_is_in_performance_of_authority_tasks - true, cooperation_given - absent])]),
    Basis == [],
    Citations == [].
test(absent_statement_refers_before_unsure_judgement) :-
    cooperation_duty([attribute(acts_as_controller, true), attribute(authority_request_made, true), attribute(request_is_in_performance_of_authority_tasks, unsure)], Result, [], []),
    Result == needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_31), cite(cooperation_statement)), [resolution(cite(cooperation_statement), not_attempted), inputs_relied_on([request_is_in_performance_of_authority_tasks - unsure, cooperation_given - absent])]).
test(unsure_judgement_is_open_textured) :-
    cooperation_duty([attribute(acts_as_controller, true), attribute(authority_request_made, true), attribute(request_is_in_performance_of_authority_tasks, unsure), attribute(cooperation_given, attested(true, attestation(by, at, reason, none)))], Result, [], []),
    Result == needs_legal_review(open_textured(request_is_in_performance_of_authority_tasks, cite(eu_reg_2016_679_art_31)), [inputs_relied_on([request_is_in_performance_of_authority_tasks - unsure])]).
test(attested_true_is_met_and_copied) :-
    cooperation_duty([attribute(acts_as_controller, true), attribute(authority_request_made, true), attribute(request_is_in_performance_of_authority_tasks, true), attribute(cooperation_given, attested(true, attestation(by, at, reason, url(address, retrieved))))], Result, Basis, Citations),
    Result == cooperation_met,
    Basis == [outside_fact(cooperation_given, attested(true, attestation(by, at, reason, url(address, retrieved))))],
    Citations == [cite(eu_reg_2016_679_art_31)].
test(attested_false_is_not_met) :-
    cooperation_duty([attribute(acts_as_processor, true), attribute(authority_request_made, true), attribute(request_is_in_performance_of_authority_tasks, true), attribute(cooperation_given, attested(false, attestation(by, at, reason, none)))], Result, Basis, _),
    Result == cooperation_not_met,
    Basis == [outside_fact(cooperation_given, attested(false, attestation(by, at, reason, none)))].
test(wrong_type_is_an_input_problem) :-
    cooperation_duty([attribute(acts_as_controller, unsure)], Result, Basis, Citations),
    Result == input_problems([wrong_type(acts_as_controller)]),
    Basis == [],
    Citations == [].
test(non_list_profile_is_an_input_problem) :-
    cooperation_duty(profile, input_problems([wrong_type(profile)]), [], []).
test(verdict_projection_gives_the_result) :-
    gdpr_cooperation_with_the_supervisory_authority_status([attribute(authority_request_made, false)], cooperation_not_required).
test(checklist_carries_cites_per_item) :-
    gdpr_cooperation_with_the_supervisory_authority_checklist([attribute(acts_as_controller, true), attribute(authority_request_made, true), attribute(request_is_in_performance_of_authority_tasks, unsure)], Items),
    Items == [item(party_bound, met, cite(eu_reg_2016_679_art_31)), item(request_made, met, cite(eu_reg_2016_679_art_31)), item(request_in_performance_of_tasks, unknown([request_is_in_performance_of_authority_tasks]), cite(eu_reg_2016_679_art_31)), item(cooperation_given, unknown([cooperation_given]), cite(eu_reg_2016_679_art_31))].
test(checklist_names_first_absent_role) :-
    gdpr_cooperation_with_the_supervisory_authority_checklist([attribute(acts_as_controller, false)], Items),
    Items = [item(party_bound, Status, _)|_],
    Status == unknown([acts_as_processor]).
test(provenance_with_free_detail_is_ground) :-
    findall(Detail, provenance(cite(eu_reg_2016_679_art_31), Detail), Details),
    Details == [not_recorded].
test(provenance_holds_for_a_given_detail) :-
    findall(given, provenance(cite(cooperation_statement), some_detail), Answers),
    Answers == [given].
test(indeterminate_holds_for_one_key) :-
    findall(given, indeterminate([authority_request_made]), Answers),
    Answers == [given].
test(needs_legal_review_holds_for_the_cross_reference) :-
    findall(given, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_31), cite(cooperation_statement)), [resolution(cite(cooperation_statement), not_attempted), inputs_relied_on([request_is_in_performance_of_authority_tasks - true, cooperation_given - absent])]), Answers),
    Answers == [given].
test(needs_legal_review_holds_for_the_open_texture) :-
    findall(given, needs_legal_review(open_textured(request_is_in_performance_of_authority_tasks, cite(eu_reg_2016_679_art_31)), [inputs_relied_on([request_is_in_performance_of_authority_tasks - unsure])]), Answers),
    Answers == [given].
test(open_textured_holds) :-
    open_textured(request_is_in_performance_of_authority_tasks, cite(eu_reg_2016_679_art_31)).
test(cross_reference_unresolved_holds) :-
    cross_reference_unresolved(cite(eu_reg_2016_679_art_31), cite(cooperation_statement)).
test(resolution_holds_for_not_attempted) :-
    findall(given, resolution(cite(cooperation_statement), not_attempted), Answers),
    Answers == [given].
test(inputs_relied_on_holds) :-
    inputs_relied_on([request_is_in_performance_of_authority_tasks - unsure, cooperation_given - absent]).
test(outside_fact_holds) :-
    findall(given, outside_fact(cooperation_given, attested(true, attestation(by, at, reason, none))), Answers),
    Answers == [given].
test(attested_holds) :-
    findall(given, attested(false, attestation(by, at, reason, document(upload, digest))), Answers),
    Answers == [given].
test(attestation_holds) :-
    attestation(by, at, reason, url(address, retrieved)).
test(url_holds) :-
    findall(given, url(address, retrieved), Answers),
    Answers == [given].
test(document_holds) :-
    findall(given, document(upload, digest), Answers),
    Answers == [given].
test(input_problems_holds) :-
    findall(given, input_problems([duplicate_key(acts_as_controller), wrong_type(acts_as_processor), unknown_key(colour)]), Answers),
    Answers == [given].
test(unknown_key_holds) :-
    unknown_key(key(seven)).
test(wrong_type_holds) :-
    wrong_type(profile).
test(duplicate_key_holds) :-
    duplicate_key(acts_as_controller).
test(the_query_answers_are_well_formed_constructors) :-
    cooperation_duty([attribute(acts_as_controller, true), attribute(authority_request_made, true), attribute(request_is_in_performance_of_authority_tasks, true)], needs_legal_review(Reason, Context), [], []),
    needs_legal_review(Reason, Context).

test(no_request_is_not_met, fail) :-
    cooperation_duty([attribute(acts_as_controller, true), attribute(authority_request_made, false)], cooperation_not_met, _, _).
test(attested_false_is_not_met_not_met, fail) :-
    cooperation_duty([attribute(acts_as_processor, true), attribute(authority_request_made, true), attribute(request_is_in_performance_of_authority_tasks, true), attribute(cooperation_given, attested(false, attestation(by, at, reason, none)))], cooperation_met, _, _).
test(indeterminate_refuses_an_empty_list, fail) :-
    indeterminate([]).
test(needs_legal_review_refuses_an_unknown_reason, fail) :-
    needs_legal_review(no_reason, [inputs_relied_on([])]).
test(open_textured_refuses_a_bare_citation, fail) :-
    open_textured(request_is_in_performance_of_authority_tasks, eu_reg_2016_679_art_31).
test(resolution_refuses_another_status, fail) :-
    resolution(cite(cooperation_statement), attempted).
test(outside_fact_refuses_a_plain_value, fail) :-
    outside_fact(cooperation_given, true).
test(attested_refuses_a_value_outside_the_booleans, fail) :-
    attested(maybe, attestation(by, at, reason, none)).
test(input_problems_refuses_an_empty_list, fail) :-
    input_problems([]).
test(duplicate_key_refuses_a_compound, fail) :-
    duplicate_key(key(seven)).
