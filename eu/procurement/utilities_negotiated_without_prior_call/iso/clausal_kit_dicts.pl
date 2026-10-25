% tools/iso_export/companion/clausal_kit_dicts.pl
% The vendored kit's dict tests on the Clausal Prolog (.clausal) export path.
% The kit reads a profile two ways: dict clauses guarded by is_dict/1, and
% attribute-list clauses. Exported, a non-empty dict IS an attribute list
% (companion/clausal_dicts.pl), so the list clauses read it and is_dict/1 must
% stay false for it, or a profile would be read twice. The one dict the list
% clauses cannot read is the empty dict, '{}' (it is not [], as on the
% engine), so is_dict/1 holds for '{}' alone, and dict_keys/2 gives its keys.
% attrs_put/3 (the translation of the kit's {**D, K: V}) and dict_size/2 read
% '{}' as the empty dict too, and otherwise are clausal_profiles' own.
% cp_export points the staged kit's imports of these four here; the seam path
% keeps clausal_profiles'. Cut-free, ->-free.
:- module(clausal_kit_dicts, [is_dict/1, dict_keys/2, attrs_put/3, dict_size/2]).
:- use_module(clausal_profiles, []).

is_dict(D) :- D == '{}'.

dict_keys(D, []) :- D == '{}'.

% attrs_put(+Dict, +Attrs, -Out): Dict updated by Attrs. Updating '{}' starts
% from no attributes, and an update by nothing leaves it '{}'.
attrs_put(D, U, Out) :- D == '{}', clausal_profiles:attrs_put([], U, O0), kit_dicts_as_dict(O0, Out).
attrs_put(D, U, Out) :- D \== '{}', clausal_profiles:attrs_put(D, U, Out).

dict_size(D, 0) :- D == '{}'.
dict_size(D, N) :- D \== '{}', clausal_profiles:dict_size(D, N).

kit_dicts_as_dict([], '{}').
kit_dicts_as_dict([A|T], [A|T]).
