:- module(m__eu_procurement_shortlisting_shortlisting, [decide_shortlisting/2, shortlisting_status/2, shortlisting_checklist/2, shortlisting_decision_resolvable/1, shortlisting_status_values/1, statutory_minimum_candidates/2, shortlisting_limitation_modality/4, shortlisting_invitation_floor/4, shortlisting_inclusion_modality/2, shortlisting_what_if/4, shortlisting_profile_keys/1, shortlisting_input_problem/2, shortlisting_input_acceptable/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_dicts, [dict_keys/2, get/3]).
:- use_module(library(clpz)).
:- use_module(m__eu_procurement_shortlisting_citations, [implements/1]).
:- use_module(formalize_lib, [profile_get/3, profile_lacks/2, not_member/2]).
:- use_module(query_combinators, [override_key/4]).
:- use_module(m__eu_procurement_directive_2014_24_vocabulary, [procedure_type/1]).

statutory_minimum_fact(restricted_procedure, 5, cite(eu_dir_2014_24_art_65_2_minima)).
statutory_minimum_fact(competitive_procedure_with_negotiation, 3, cite(eu_dir_2014_24_art_65_2_minima)).
statutory_minimum_fact(competitive_dialogue, 3, cite(eu_dir_2014_24_art_65_2_minima)).
statutory_minimum_fact(innovation_partnership, 3, cite(eu_dir_2014_24_art_65_2_minima)).

is_article_65_procedure(restricted_procedure).
is_article_65_procedure(competitive_procedure_with_negotiation).
is_article_65_procedure(competitive_dialogue).
is_article_65_procedure(innovation_partnership).

is_outside_article_65_procedure(open_procedure).
is_outside_article_65_procedure(negotiated_procedure_without_prior_publication).

statutory_minimum_candidates(ProcedureType, MinimumCandidates) :-
    statutory_minimum_fact(ProcedureType, MinimumCandidates, _).

shortlisting_invitation_floor(ProcedureType, _DeclaredMinimumCandidates, _QualifiedCandidates, 0) :-
    ground(ProcedureType),
    procedure_type(ProcedureType),
    is_outside_article_65_procedure(ProcedureType).
shortlisting_invitation_floor(ProcedureType, DeclaredMinimumCandidates, QualifiedCandidates, QualifiedCandidates) :-
    ground(ProcedureType),
    procedure_type(ProcedureType),
    is_article_65_procedure(ProcedureType),
    shortlisting_count(DeclaredMinimumCandidates),
    shortlisting_count(QualifiedCandidates),
    statutory_minimum_candidates(ProcedureType, StatutoryMinimum),
    DeclaredMinimumCandidates #< StatutoryMinimum.
shortlisting_invitation_floor(ProcedureType, DeclaredMinimumCandidates, QualifiedCandidates, QualifiedCandidates) :-
    ground(ProcedureType),
    procedure_type(ProcedureType),
    is_article_65_procedure(ProcedureType),
    shortlisting_count(DeclaredMinimumCandidates),
    shortlisting_count(QualifiedCandidates),
    statutory_minimum_candidates(ProcedureType, StatutoryMinimum),
    DeclaredMinimumCandidates #>= StatutoryMinimum,
    QualifiedCandidates #< DeclaredMinimumCandidates.
shortlisting_invitation_floor(ProcedureType, DeclaredMinimumCandidates, QualifiedCandidates, DeclaredMinimumCandidates) :-
    ground(ProcedureType),
    procedure_type(ProcedureType),
    is_article_65_procedure(ProcedureType),
    shortlisting_count(DeclaredMinimumCandidates),
    shortlisting_count(QualifiedCandidates),
    statutory_minimum_candidates(ProcedureType, StatutoryMinimum),
    DeclaredMinimumCandidates #>= StatutoryMinimum,
    QualifiedCandidates #>= DeclaredMinimumCandidates.

shortlisting_limitation_modality(ProcedureType, _DeclaredMinimumCandidates, _QualifiedCandidates, limitation_not_available) :-
    ground(ProcedureType),
    procedure_type(ProcedureType),
    is_outside_article_65_procedure(ProcedureType).
shortlisting_limitation_modality(ProcedureType, DeclaredMinimumCandidates, QualifiedCandidates, limitation_prohibited) :-
    ground(ProcedureType),
    procedure_type(ProcedureType),
    is_article_65_procedure(ProcedureType),
    shortlisting_count(DeclaredMinimumCandidates),
    shortlisting_count(QualifiedCandidates),
    statutory_minimum_candidates(ProcedureType, StatutoryMinimum),
    DeclaredMinimumCandidates #< StatutoryMinimum.
shortlisting_limitation_modality(ProcedureType, DeclaredMinimumCandidates, QualifiedCandidates, continuation_permitted) :-
    ground(ProcedureType),
    procedure_type(ProcedureType),
    is_article_65_procedure(ProcedureType),
    shortlisting_count(DeclaredMinimumCandidates),
    shortlisting_count(QualifiedCandidates),
    statutory_minimum_candidates(ProcedureType, StatutoryMinimum),
    DeclaredMinimumCandidates #>= StatutoryMinimum,
    QualifiedCandidates #< DeclaredMinimumCandidates.
shortlisting_limitation_modality(ProcedureType, DeclaredMinimumCandidates, QualifiedCandidates, limitation_permitted) :-
    ground(ProcedureType),
    procedure_type(ProcedureType),
    is_article_65_procedure(ProcedureType),
    shortlisting_count(DeclaredMinimumCandidates),
    shortlisting_count(QualifiedCandidates),
    statutory_minimum_candidates(ProcedureType, StatutoryMinimum),
    DeclaredMinimumCandidates #>= StatutoryMinimum,
    QualifiedCandidates #>= DeclaredMinimumCandidates.

shortlisting_inclusion_modality(requested_and_has_required_capabilities, inclusion_permitted).
shortlisting_inclusion_modality(requested_without_required_capabilities, inclusion_prohibited).
shortlisting_inclusion_modality(did_not_request_to_participate, inclusion_prohibited).

shortlisting_status_values([limitation_not_available, limitation_prohibited, continuation_permitted, limitation_permitted]).

defect_limb(false, _MinimumIndicated, _DeclaredMinimum, _DeclaredMaximum, _StatutoryMinimum, _Floor, _Invited, _Sufficient, _NonRequesting, _NoCapabilities, objective_and_non_discriminatory_criteria_not_indicated) :-
    implements(eu_dir_2014_24_art_65_2_indication).
defect_limb(_CriteriaIndicated, false, _DeclaredMinimum, _DeclaredMaximum, _StatutoryMinimum, _Floor, _Invited, _Sufficient, _NonRequesting, _NoCapabilities, minimum_number_not_indicated) :-
    implements(eu_dir_2014_24_art_65_2_indication).
defect_limb(_CriteriaIndicated, _MinimumIndicated, DeclaredMinimum, _DeclaredMaximum, StatutoryMinimum, _Floor, _Invited, _Sufficient, _NonRequesting, _NoCapabilities, declared_minimum_below_statutory_minimum) :-
    implements(eu_dir_2014_24_art_65_2_minima),
    DeclaredMinimum #< StatutoryMinimum.
defect_limb(_CriteriaIndicated, _MinimumIndicated, DeclaredMinimum, DeclaredMaximum, _StatutoryMinimum, _Floor, _Invited, _Sufficient, _NonRequesting, _NoCapabilities, declared_maximum_below_declared_minimum) :-
    implements(eu_dir_2014_24_art_65_2_indication),
    DeclaredMaximum #> 0,
    DeclaredMaximum #< DeclaredMinimum.
defect_limb(_CriteriaIndicated, _MinimumIndicated, _DeclaredMinimum, _DeclaredMaximum, _StatutoryMinimum, _Floor, _Invited, false, _NonRequesting, _NoCapabilities, genuine_competition_not_ensured) :-
    implements(eu_dir_2014_24_art_65_2_genuine_competition).
defect_limb(_CriteriaIndicated, _MinimumIndicated, _DeclaredMinimum, _DeclaredMaximum, _StatutoryMinimum, Floor, Invited, _Sufficient, _NonRequesting, _NoCapabilities, fewer_invited_than_minimum_number) :-
    implements(eu_dir_2014_24_art_65_2_invitation_floor),
    Invited #< Floor.
defect_limb(_CriteriaIndicated, _MinimumIndicated, _DeclaredMinimum, _DeclaredMaximum, _StatutoryMinimum, _Floor, _Invited, _Sufficient, true, _NoCapabilities, non_requesting_economic_operator_included) :-
    implements(eu_dir_2014_24_art_65_2_prohibition).
defect_limb(_CriteriaIndicated, _MinimumIndicated, _DeclaredMinimum, _DeclaredMaximum, _StatutoryMinimum, _Floor, _Invited, _Sufficient, _NonRequesting, true, candidate_without_required_capabilities_included) :-
    implements(eu_dir_2014_24_art_65_2_prohibition).

limb_citation(objective_and_non_discriminatory_criteria_not_indicated, cite(eu_dir_2014_24_art_65_2_indication)).
limb_citation(minimum_number_not_indicated, cite(eu_dir_2014_24_art_65_2_indication)).
limb_citation(declared_minimum_below_statutory_minimum, cite(eu_dir_2014_24_art_65_2_minima)).
limb_citation(declared_maximum_below_declared_minimum, cite(eu_dir_2014_24_art_65_2_indication)).
limb_citation(genuine_competition_not_ensured, cite(eu_dir_2014_24_art_65_2_genuine_competition)).
limb_citation(fewer_invited_than_minimum_number, cite(eu_dir_2014_24_art_65_2_invitation_floor)).
limb_citation(non_requesting_economic_operator_included, cite(eu_dir_2014_24_art_65_2_prohibition)).
limb_citation(candidate_without_required_capabilities_included, cite(eu_dir_2014_24_art_65_2_prohibition)).

determine_status(DefectIds, _Qualified, _DeclaredMinimum, Floor, limitation_prohibited, Floor) :-
    DefectIds = [_|_].
determine_status([], Qualified, DeclaredMinimum, Floor, continuation_permitted, Floor) :-
    Qualified #< DeclaredMinimum.
determine_status([], Qualified, DeclaredMinimum, Floor, limitation_permitted, Floor) :-
    Qualified #>= DeclaredMinimum.

shortlisting_decide(Profile, shortlisting_verdict(limitation_not_available, [], 0, [])) :-
    implements(eu_dir_2014_24_art_65_1),
    profile_get(Profile, procedure_type_key, ProcedureType),
    procedure_type(ProcedureType),
    is_outside_article_65_procedure(ProcedureType).
shortlisting_decide(Profile, shortlisting_verdict(Status, DefectIds, NumberToInvite, Citations)) :-
    implements(eu_dir_2014_24_art_65_1),
    profile_get(Profile, procedure_type_key, ProcedureType),
    procedure_type(ProcedureType),
    is_article_65_procedure(ProcedureType),
    profile_get(Profile, objective_and_non_discriminatory_criteria_indicated, CriteriaIndicated),
    profile_get(Profile, minimum_number_indicated, MinimumIndicated),
    profile_get(Profile, declared_minimum_candidates, DeclaredMinimum),
    profile_get(Profile, declared_maximum_candidates, DeclaredMaximum),
    profile_get(Profile, qualified_candidates, Qualified),
    profile_get(Profile, invited_candidates, Invited),
    profile_get(Profile, number_invited_sufficient_for_genuine_competition, Sufficient),
    profile_get(Profile, invited_include_non_requesting_economic_operators, NonRequesting),
    profile_get(Profile, invited_include_candidates_without_required_capabilities, NoCapabilities),
    statutory_minimum_candidates(ProcedureType, StatutoryMinimum),
    shortlisting_invitation_floor(ProcedureType, DeclaredMinimum, Qualified, Floor),
    findall(LimbAtom, defect_limb(CriteriaIndicated, MinimumIndicated, DeclaredMinimum, DeclaredMaximum, StatutoryMinimum, Floor, Invited, Sufficient, NonRequesting, NoCapabilities, LimbAtom), DefectIds),
    findall(Citation, (member(EachLimb, DefectIds), limb_citation(EachLimb, Citation)), Citations),
    determine_status(DefectIds, Qualified, DeclaredMinimum, Floor, Status, NumberToInvite).

shortlisting_status(Profile, Status) :-
    decide_shortlisting(Profile, shortlisting_verdict(Status, _, _, _)).

shortlisting_checklist(Profile, [item(Status, met, cite(eu_dir_2014_24_art_65_1))]) :-
    decide_shortlisting(Profile, shortlisting_verdict(Status, DefectIds, _NumberToInvite, _Citations)),
    DefectIds = [].
shortlisting_checklist(Profile, Checklist) :-
    decide_shortlisting(Profile, shortlisting_verdict(_Status, DefectIds, _NumberToInvite, _Citations)),
    DefectIds = [_|_],
    findall(ChecklistItem, (member(EachLimb, DefectIds), limb_citation(EachLimb, Citation), ChecklistItem = item(EachLimb, unmet(EachLimb), Citation)), Checklist).

shortlisting_decision_resolvable(Profile) :-
    decide_shortlisting(Profile, _).

shortlisting_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    shortlisting_input_acceptable(Profile),
    ground(OverriddenKey),
    override_key(Profile, OverriddenKey, NewValue, ModifiedProfile),
    decide_shortlisting(ModifiedProfile, shortlisting_verdict(NewStatus, _, _, _)).

shortlisting_profile_keys([procedure_type_key, objective_and_non_discriminatory_criteria_indicated, minimum_number_indicated, declared_minimum_candidates, declared_maximum_candidates, qualified_candidates, invited_candidates, number_invited_sufficient_for_genuine_competition, invited_include_non_requesting_economic_operators, invited_include_candidates_without_required_capabilities]).

shortlisting_input_problem(Profile, Problem) :-
    shortlisting_input_problems(Profile, [Problem|_]).

shortlisting_input_acceptable(Profile) :-
    shortlisting_input_problems(Profile, []).

shortlisting_input_problems(Profile, [not_ground]) :-
    term_variables(Profile, [_|_]).
shortlisting_input_problems(Profile, [wrong_type(profile, expected_dict)]) :-
    ground(Profile),
    \+ dict_keys(Profile, _).
shortlisting_input_problems(Profile, Problems) :-
    ground(Profile),
    dict_keys(Profile, _),
    findall(Problem, shortlisting_profile_problem(Profile, Problem), Problems).

shortlisting_boolean_key(objective_and_non_discriminatory_criteria_indicated).
shortlisting_boolean_key(minimum_number_indicated).
shortlisting_boolean_key(number_invited_sufficient_for_genuine_competition).
shortlisting_boolean_key(invited_include_non_requesting_economic_operators).
shortlisting_boolean_key(invited_include_candidates_without_required_capabilities).

shortlisting_count_key(declared_minimum_candidates).
shortlisting_count_key(declared_maximum_candidates).
shortlisting_count_key(qualified_candidates).
shortlisting_count_key(invited_candidates).

shortlisting_article_65_key(objective_and_non_discriminatory_criteria_indicated).
shortlisting_article_65_key(minimum_number_indicated).
shortlisting_article_65_key(declared_minimum_candidates).
shortlisting_article_65_key(declared_maximum_candidates).
shortlisting_article_65_key(qualified_candidates).
shortlisting_article_65_key(invited_candidates).
shortlisting_article_65_key(number_invited_sufficient_for_genuine_competition).
shortlisting_article_65_key(invited_include_non_requesting_economic_operators).
shortlisting_article_65_key(invited_include_candidates_without_required_capabilities).

shortlisting_count(Value) :-
    integer(Value),
    Value #>= 0.

shortlisting_profile_problem(Profile, missing_key(procedure_type_key)) :-
    profile_lacks(Profile, procedure_type_key).
shortlisting_profile_problem(Profile, wrong_value(procedure_type_key, expected_procedure_type_atom)) :-
    get(Profile, procedure_type_key, ProcedureType),
    unrecognised_procedure_type(ProcedureType).
shortlisting_profile_problem(Profile, missing_key(Key)) :-
    get(Profile, procedure_type_key, ProcedureType),
    is_article_65_procedure(ProcedureType),
    shortlisting_article_65_key(Key),
    profile_lacks(Profile, Key).
shortlisting_profile_problem(Profile, wrong_type(Key, expected_boolean)) :-
    shortlisting_boolean_key(Key),
    get(Profile, Key, Value),
    dif(Value, true),
    dif(Value, false).
shortlisting_profile_problem(Profile, wrong_type(Key, expected_integer_count)) :-
    shortlisting_count_key(Key),
    get(Profile, Key, Value),
    not_an_integer(Value).
shortlisting_profile_problem(Profile, negative_count(Key)) :-
    shortlisting_count_key(Key),
    get(Profile, Key, Value),
    integer(Value),
    Value #< 0.

unrecognised_procedure_type(ProcedureType) :-
    findall(Known, procedure_type(Known), KnownTypes),
    not_member(ProcedureType, KnownTypes).

not_an_integer(Value) :-
    atom(Value).
not_an_integer(Value) :-
    float(Value).
not_an_integer(Value) :-
    compound(Value).
not_an_integer(Value) :-
    dict_keys(Value, _).

no_statute("shortlisting_input_acceptable", 1, "computation_helper").
no_statute("unrecognised_procedure_type", 1, "computation_helper").
no_statute("not_an_integer", 1, "computation_helper").

decide_shortlisting(Profile, Verdict) :-
    shortlisting_input_acceptable(Profile),
    shortlisting_decide(Profile, Verdict).
