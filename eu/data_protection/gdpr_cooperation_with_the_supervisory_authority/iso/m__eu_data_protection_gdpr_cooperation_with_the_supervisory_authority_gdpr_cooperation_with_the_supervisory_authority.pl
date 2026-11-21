% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_cooperation_with_the_supervisory_authority_gdpr_cooperation_with_the_supervisory_authority, [decide_gdpr_cooperation_with_the_supervisory_authority/2, gdpr_cooperation_with_the_supervisory_authority_status/2, gdpr_cooperation_with_the_supervisory_authority_checklist/2, gdpr_cooperation_with_the_supervisory_authority_decision_resolvable/1, gdpr_cooperation_with_the_supervisory_authority_status_values/1, cooperation_duty/4, cooperation_not_required/0, cooperation_met/0, cooperation_not_met/0, indeterminate/1, needs_legal_review/2, open_textured/2, cross_reference_unresolved/2, resolution/2, inputs_relied_on/1, outside_fact/2, attested/2, input_problems/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_is_list/1]).
:- use_module(m__eu_data_protection_gdpr_cooperation_with_the_supervisory_authority_kernel, [gdpr_cooperation_with_the_supervisory_authority_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_cooperation_with_the_supervisory_authority_citations, [implements/1]).
:- use_module(formalize_lib, [profile_get/3, profile_has/2, profile_lacks/2, eval_requirements/4]).
:- use_module(library(reif), [memberd_t/3]).

gdpr_cooperation_with_the_supervisory_authority_status_values([cooperation_not_required, cooperation_met, cooperation_not_met]).

cooperation_not_required.

cooperation_met.

cooperation_not_met.

indeterminate([_|_]).

needs_legal_review(_, [_|_]).

open_textured(_, cite(_)).

cross_reference_unresolved(cite(_), cite(_)).

resolution(cite(_), not_attempted).

inputs_relied_on(Pairs) :-
    clausal_is_list(Pairs).

outside_fact(cooperation_given, _).

attested(true, attestation(_, _, _, _)).
attested(false, attestation(_, _, _, _)).

input_problems([_|_]).

key_value(Profile, Key, absent) :-
    profile_lacks(Profile, Key).
key_value(Profile, Key, Value) :-
    profile_has(Profile, Key),
    profile_get(Profile, Key, Value).

clean_values(Profile, values(Controller, Processor, Representative, Request, Tasks, Statement)) :-
    gdpr_cooperation_with_the_supervisory_authority_input_problems(Profile, []),
    key_value(Profile, acts_as_controller, Controller),
    key_value(Profile, acts_as_processor, Processor),
    key_value(Profile, acts_as_representative_of_controller_or_processor, Representative),
    key_value(Profile, authority_request_made, Request),
    key_value(Profile, request_is_in_performance_of_authority_tasks, Tasks),
    key_value(Profile, cooperation_given, Statement).

first_absent([], none).
first_absent([Key - absent|_], key(Key)).
first_absent([_ - Value|Pairs], FirstGap) :-
    dif(Value, absent),
    first_absent(Pairs, FirstGap).

duty_route(Values, Route) :-
    Values = values(_, _, _, Request, _, _),
    request_route(Request, Values, Route).

request_route(false, _, not_required(no_request)) :-
    implements(eu_reg_2016_679_art_31).
request_route(true, Values, Route) :-
    Values = values(_, _, _, _, Tasks, _),
    tasks_route(Tasks, Values, Route).
request_route(absent, Values, Route) :-
    Values = values(_, _, _, _, Tasks, _),
    tasks_route(Tasks, Values, Route).

tasks_route(false, _, not_required(request_not_in_performance_of_tasks)) :-
    implements(eu_reg_2016_679_art_31).
tasks_route(true, Values, Route) :-
    roles_route(Values, Route).
tasks_route(unsure, Values, Route) :-
    roles_route(Values, Route).
tasks_route(absent, Values, Route) :-
    roles_route(Values, Route).

roles_route(Values, Route) :-
    Values = values(Controller, Processor, Representative, _, _, _),
    role_standing([Controller, Processor, Representative], Standing),
    standing_route(Standing, Values, Route).

role_standing(Roles, bound) :-
    implements(eu_reg_2016_679_art_31),
    memberd_t(true, Roles, true).
role_standing(Roles, not_bound) :-
    implements(eu_reg_2016_679_art_31),
    memberd_t(true, Roles, false),
    memberd_t(absent, Roles, false).
role_standing(Roles, open) :-
    implements(eu_reg_2016_679_art_31),
    memberd_t(true, Roles, false),
    memberd_t(absent, Roles, true).

standing_route(not_bound, _, not_required(not_bound)) :-
    implements(eu_reg_2016_679_art_31).
standing_route(bound, values(_, _, _, Request, Tasks, Statement), Route) :-
    first_absent([authority_request_made - Request, request_is_in_performance_of_authority_tasks - Tasks], FirstGap),
    gap_route(FirstGap, Tasks, Statement, Route).
standing_route(open, values(Controller, Processor, Representative, Request, Tasks, Statement), Route) :-
    first_absent([acts_as_controller - Controller, acts_as_processor - Processor, acts_as_representative_of_controller_or_processor - Representative, authority_request_made - Request, request_is_in_performance_of_authority_tasks - Tasks], FirstGap),
    gap_route(FirstGap, Tasks, Statement, Route).

gap_route(key(AbsentKey), _, _, missing(AbsentKey)).
gap_route(none, Tasks, Statement, Route) :-
    statement_route(Statement, Tasks, Route).

statement_route(absent, Tasks, cooperation_statement_absent(Tasks)) :-
    implements(eu_reg_2016_679_art_31).
statement_route(attested(Value, Attestation), Tasks, Route) :-
    attested_route(Tasks, Value, attested(Value, Attestation), Route).

attested_route(unsure, _, _, tasks_unsure) :-
    implements(eu_reg_2016_679_art_31).
attested_route(true, true, Statement, cooperation_attested(true, Statement)) :-
    implements(eu_reg_2016_679_art_31).
attested_route(true, false, Statement, cooperation_attested(false, Statement)) :-
    implements(eu_reg_2016_679_art_31).

cooperation_duty(Profile, input_problems([Problem|Problems]), [], []) :-
    gdpr_cooperation_with_the_supervisory_authority_input_problems(Profile, [Problem|Problems]).
cooperation_duty(Profile, cooperation_not_required, [], [cite(eu_reg_2016_679_art_31)]) :-
    implements(eu_reg_2016_679_art_31),
    clean_values(Profile, Values),
    duty_route(Values, not_required(_)).
cooperation_duty(Profile, indeterminate([AbsentKey]), [], []) :-
    clean_values(Profile, Values),
    duty_route(Values, missing(AbsentKey)).
cooperation_duty(Profile, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_31), cite(cooperation_statement)), [resolution(cite(cooperation_statement), not_attempted), inputs_relied_on([request_is_in_performance_of_authority_tasks - Tasks, cooperation_given - absent])]), [], []) :-
    implements(eu_reg_2016_679_art_31),
    clean_values(Profile, Values),
    duty_route(Values, cooperation_statement_absent(Tasks)).
cooperation_duty(Profile, needs_legal_review(open_textured(request_is_in_performance_of_authority_tasks, cite(eu_reg_2016_679_art_31)), [inputs_relied_on([request_is_in_performance_of_authority_tasks - unsure])]), [], []) :-
    implements(eu_reg_2016_679_art_31),
    clean_values(Profile, Values),
    duty_route(Values, tasks_unsure).
cooperation_duty(Profile, cooperation_met, [outside_fact(cooperation_given, Statement)], [cite(eu_reg_2016_679_art_31)]) :-
    implements(eu_reg_2016_679_art_31),
    clean_values(Profile, Values),
    duty_route(Values, cooperation_attested(true, Statement)).
cooperation_duty(Profile, cooperation_not_met, [outside_fact(cooperation_given, Statement)], [cite(eu_reg_2016_679_art_31)]) :-
    implements(eu_reg_2016_679_art_31),
    clean_values(Profile, Values),
    duty_route(Values, cooperation_attested(false, Statement)).

decide_gdpr_cooperation_with_the_supervisory_authority(Profile, gdpr_cooperation_with_the_supervisory_authority_verdict(Status, Citations)) :-
    cooperation_duty(Profile, Status, _Basis, Citations).

gdpr_cooperation_with_the_supervisory_authority_status(Profile, Status) :-
    decide_gdpr_cooperation_with_the_supervisory_authority(Profile, gdpr_cooperation_with_the_supervisory_authority_verdict(Status, _Citations)).

gdpr_cooperation_with_the_supervisory_authority_decision_resolvable(Profile) :-
    decide_gdpr_cooperation_with_the_supervisory_authority(Profile, _Verdict).

gdpr_cooperation_with_the_supervisory_authority_checklist(Profile, Items) :-
    gdpr_cooperation_with_the_supervisory_authority_input_problems(Profile, []),
    eval_requirements([bound_by_article_31, request_made, request_in_performance_of_tasks, cooperation_given], Profile, requirement, Items).
gdpr_cooperation_with_the_supervisory_authority_checklist(Profile, [item(input_check, unmet(input_problems([Problem|Problems])), cite(eu_reg_2016_679_art_31))]) :-
    gdpr_cooperation_with_the_supervisory_authority_input_problems(Profile, [Problem|Problems]).

requirement(bound_by_article_31, Profile, Status, cite(eu_reg_2016_679_art_31)) :-
    implements(eu_reg_2016_679_art_31),
    key_value(Profile, acts_as_controller, Controller),
    key_value(Profile, acts_as_processor, Processor),
    key_value(Profile, acts_as_representative_of_controller_or_processor, Representative),
    role_standing([Controller, Processor, Representative], Standing),
    standing_status(Standing, [acts_as_controller - Controller, acts_as_processor - Processor, acts_as_representative_of_controller_or_processor - Representative], Status).
requirement(request_made, Profile, Status, cite(eu_reg_2016_679_art_31)) :-
    implements(eu_reg_2016_679_art_31),
    key_value(Profile, authority_request_made, Request),
    request_status(Request, Status).
requirement(request_in_performance_of_tasks, Profile, Status, cite(eu_reg_2016_679_art_31)) :-
    implements(eu_reg_2016_679_art_31),
    key_value(Profile, request_is_in_performance_of_authority_tasks, Tasks),
    tasks_status(Tasks, Status).
requirement(cooperation_given, Profile, Status, cite(eu_reg_2016_679_art_31)) :-
    implements(eu_reg_2016_679_art_31),
    key_value(Profile, cooperation_given, Statement),
    statement_status(Statement, Status).

standing_status(bound, _, met).
standing_status(not_bound, _, unmet(not_bound)).
standing_status(open, RolePairs, unknown([AbsentKey])) :-
    first_absent(RolePairs, key(AbsentKey)).

request_status(true, met).
request_status(false, unmet(no_request)).
request_status(absent, unknown([authority_request_made])).

tasks_status(true, met).
tasks_status(false, unmet(request_not_in_performance_of_tasks)).
tasks_status(unsure, unknown([request_is_in_performance_of_authority_tasks])).
tasks_status(absent, unknown([request_is_in_performance_of_authority_tasks])).

statement_status(absent, unknown([cooperation_given])).
statement_status(attested(true, _), met).
statement_status(attested(false, _), unmet(cooperation_not_given)).

test(an_attested_cooperating_controller_has_met_the_duty) :-
    Statement = attested(true, attestation(host, at_time, reason, none)),
    Profile = [attribute(acts_as_controller, true), attribute(authority_request_made, true), attribute(request_is_in_performance_of_authority_tasks, true), attribute(cooperation_given, Statement)],
    cooperation_duty(Profile, cooperation_met, [outside_fact(cooperation_given, Statement)], [cite(eu_reg_2016_679_art_31)]).
test(an_attested_refusal_has_not_met_the_duty) :-
    Statement = attested(false, attestation(host, at_time, reason, none)),
    Profile = [attribute(acts_as_processor, true), attribute(authority_request_made, true), attribute(request_is_in_performance_of_authority_tasks, true), attribute(cooperation_given, Statement)],
    cooperation_duty(Profile, cooperation_not_met, [outside_fact(cooperation_given, Statement)], [cite(eu_reg_2016_679_art_31)]).
test(no_request_needs_no_other_key) :-
    Profile = [attribute(authority_request_made, false)],
    findall(Result, cooperation_duty(Profile, Result, _, _), Results),
    Results == [cooperation_not_required].
test(a_request_outside_the_tasks_needs_no_cooperation) :-
    Profile = [attribute(authority_request_made, true), attribute(request_is_in_performance_of_authority_tasks, false)],
    cooperation_duty(Profile, cooperation_not_required, [], [cite(eu_reg_2016_679_art_31)]).
test(a_caller_in_no_role_is_not_bound) :-
    Profile = [attribute(acts_as_controller, false), attribute(acts_as_processor, false), attribute(acts_as_representative_of_controller_or_processor, false)],
    cooperation_duty(Profile, cooperation_not_required, [], [cite(eu_reg_2016_679_art_31)]).
test(an_empty_profile_names_the_first_role_key) :-
    findall(Result, cooperation_duty([], Result, _, _), Results),
    Results == [indeterminate([acts_as_controller])].
test(a_bound_caller_needs_the_request_key) :-
    Profile = [attribute(acts_as_representative_of_controller_or_processor, true)],
    cooperation_duty(Profile, indeterminate([authority_request_made]), [], []).
test(an_absent_statement_refers_before_the_unsure_judgement) :-
    Profile = [attribute(acts_as_controller, true), attribute(authority_request_made, true), attribute(request_is_in_performance_of_authority_tasks, unsure)],
    cooperation_duty(Profile, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_31), cite(cooperation_statement)), [resolution(cite(cooperation_statement), not_attempted), inputs_relied_on([request_is_in_performance_of_authority_tasks - unsure, cooperation_given - absent])]), [], []).
test(an_unsure_judgement_goes_to_a_lawyer) :-
    Profile = [attribute(acts_as_controller, true), attribute(authority_request_made, true), attribute(request_is_in_performance_of_authority_tasks, unsure), attribute(cooperation_given, attested(true, attestation(host, at_time, reason, none)))],
    findall(Result, cooperation_duty(Profile, Result, _, _), Results),
    Results == [needs_legal_review(open_textured(request_is_in_performance_of_authority_tasks, cite(eu_reg_2016_679_art_31)), [inputs_relied_on([request_is_in_performance_of_authority_tasks - unsure])])].
test(an_unknown_key_is_an_input_problem) :-
    Profile = [attribute(colour, blue)],
    cooperation_duty(Profile, input_problems([unknown_key(colour)]), [], []).
test(the_checklist_cites_every_row) :-
    Profile = [attribute(acts_as_controller, true), attribute(authority_request_made, true), attribute(request_is_in_performance_of_authority_tasks, true)],
    gdpr_cooperation_with_the_supervisory_authority_checklist(Profile, Items),
    Items == [item(bound_by_article_31, met, cite(eu_reg_2016_679_art_31)), item(request_made, met, cite(eu_reg_2016_679_art_31)), item(request_in_performance_of_tasks, met, cite(eu_reg_2016_679_art_31)), item(cooperation_given, unknown([cooperation_given]), cite(eu_reg_2016_679_art_31))].

test(an_attested_refusal_is_not_met, fail) :-
    Statement = attested(false, attestation(host, at_time, reason, none)),
    Profile = [attribute(acts_as_processor, true), attribute(authority_request_made, true), attribute(request_is_in_performance_of_authority_tasks, true), attribute(cooperation_given, Statement)],
    cooperation_duty(Profile, cooperation_met, _, _).
