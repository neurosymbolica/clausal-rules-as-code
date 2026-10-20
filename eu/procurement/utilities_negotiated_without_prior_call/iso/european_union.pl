% european_union — vendored so an exported domain's `-import_from(european_union, [euro, eur_cent])` resolves.
%
% EMPTY EXPORT LIST, ON PURPOSE. Same shape and same reason as
% united_states.pl and thailand.pl; that header carries the full rationale.
%
% In brief: the export is LOSSY BY RULING, so currency tags survive into the
% exported program only as ATOMS in data positions — never callable, never an
% arithmetic operand — and a Prolog atom needs no definition. What this file
% is for is the PATH: the import emits a use_module directive naming this file
% at the staging root, and with no file there the CONSUMING module does not
% load at all. That was the measured failure, not anything about the atoms.
%
% Vendored 2026-09-13, completing the country/vocabulary set be454bb started.
% Found by a structural sweep of every single-segment import target across the
% roster, split by HOW each is supplied. 9 domains import this one, and it was the only one of the three with any STAGED importer — the other two were invisible because every module importing them is dropped before the exporter reaches its imports.
:- module(european_union, []).
