:- module(m__eu_procurement_directive_2014_24_tests_test_art4_thresholds, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(clpz)).
:- use_module(m__eu_procurement_directive_2014_24_art4_thresholds, [art4_threshold/4, current_art4_threshold/3]).

test('2024-2025 period: works all CA = EUR 5538000 (553800000 cents)') :-
    art4_threshold(works, central_government_authority, date(2024, 6, 1), 553800000),
    art4_threshold(works, sub_central_contracting_authority, date(2024, 6, 1), 553800000),
    art4_threshold(works, body_governed_by_public_law, date(2024, 6, 1), 553800000).
test('2024-2025 period: central gov supplies = EUR 143000 (14300000 cents)') :-
    art4_threshold(supplies, central_government_authority, date(2024, 6, 1), 14300000).
test('2024-2025 period: sub-central supplies = EUR 221000 (22100000 cents)') :-
    art4_threshold(supplies, sub_central_contracting_authority, date(2024, 6, 1), 22100000).
test('2024-2025 period: social services = EUR 750000 (75000000 cents)') :-
    art4_threshold(social_and_other_specific_services, central_government_authority, date(2024, 6, 1), 75000000),
    art4_threshold(social_and_other_specific_services, sub_central_contracting_authority, date(2024, 6, 1), 75000000).
test('2022-2023 period: works all CA = EUR 5382000 (538200000 cents)') :-
    art4_threshold(works, central_government_authority, date(2022, 6, 1), 538200000).
test('2022-2023 period: central gov supplies = EUR 140000 (14000000 cents)') :-
    art4_threshold(supplies, central_government_authority, date(2022, 6, 1), 14000000).
test('2022-2023 period: sub-central supplies = EUR 215000 (21500000 cents)') :-
    art4_threshold(supplies, sub_central_contracting_authority, date(2022, 6, 1), 21500000).
test('2022-2023 period: social services = EUR 750000 (75000000 cents)') :-
    art4_threshold(social_and_other_specific_services, central_government_authority, date(2022, 6, 1), 75000000).
test('2026-2027 period (current): works = EUR 5404000 (540400000 cents)') :-
    art4_threshold(works, central_government_authority, date(2026, 7, 24), 540400000).
test('2026-2027 period (current): central gov supplies = EUR 140000 (14000000 cents)') :-
    art4_threshold(supplies, central_government_authority, date(2026, 7, 24), 14000000).
test('current_art4_threshold resolves works for today') :-
    current_art4_threshold(works, central_government_authority, ThresholdEurCents),
    ThresholdEurCents #= 540400000.
test('current_art4_threshold resolves services for today') :-
    current_art4_threshold(services, central_government_authority, ThresholdEurCents),
    ThresholdEurCents #= 14000000.
test('no threshold AFTER the last known period') :-
    findall(Cents, art4_threshold(works, central_government_authority, date(2030, 1, 1), Cents), []).
test('2016-2017 period: works all CA = EUR 5225000 (522500000 cents)') :-
    art4_threshold(works, central_government_authority, date(2016, 6, 1), 522500000),
    art4_threshold(works, sub_central_contracting_authority, date(2016, 6, 1), 522500000),
    art4_threshold(works, body_governed_by_public_law, date(2016, 6, 1), 522500000).
test('2016-2017 period: central gov supplies = EUR 135000 (13500000 cents)') :-
    art4_threshold(supplies, central_government_authority, date(2016, 6, 1), 13500000),
    art4_threshold(services, central_government_authority, date(2016, 6, 1), 13500000).
test('2016-2017 period: sub-central supplies = EUR 209000 (20900000 cents)') :-
    art4_threshold(supplies, sub_central_contracting_authority, date(2016, 6, 1), 20900000),
    art4_threshold(supplies, body_governed_by_public_law, date(2016, 6, 1), 20900000).
test('2018-2019 period: works all CA = EUR 5548000 (554800000 cents)') :-
    art4_threshold(works, central_government_authority, date(2018, 6, 1), 554800000),
    art4_threshold(works, body_governed_by_public_law, date(2018, 6, 1), 554800000).
test('2018-2019 period: central gov supplies = EUR 144000 (14400000 cents)') :-
    art4_threshold(supplies, central_government_authority, date(2018, 6, 1), 14400000).
test('2018-2019 period: sub-central supplies = EUR 221000 (22100000 cents)') :-
    art4_threshold(supplies, sub_central_contracting_authority, date(2018, 6, 1), 22100000).
test('2020-2021 period: works all CA = EUR 5350000 (535000000 cents)') :-
    art4_threshold(works, central_government_authority, date(2020, 6, 1), 535000000),
    art4_threshold(works, body_governed_by_public_law, date(2020, 6, 1), 535000000).
test('2020-2021 period: central gov supplies = EUR 139000 (13900000 cents)') :-
    art4_threshold(supplies, central_government_authority, date(2020, 6, 1), 13900000).
test('2020-2021 period: sub-central supplies = EUR 214000 (21400000 cents)') :-
    art4_threshold(supplies, sub_central_contracting_authority, date(2020, 6, 1), 21400000).
test('social services stay EUR 750000 across every pre-2022 period') :-
    art4_threshold(social_and_other_specific_services, central_government_authority, date(2016, 6, 1), 75000000),
    art4_threshold(social_and_other_specific_services, central_government_authority, date(2018, 6, 1), 75000000),
    art4_threshold(social_and_other_specific_services, sub_central_contracting_authority, date(2020, 6, 1), 75000000).
test('period boundary: 31 Dec 2017 is the old figure, 1 Jan 2018 the new') :-
    art4_threshold(supplies, central_government_authority, date(2017, 12, 31), 13500000),
    art4_threshold(supplies, central_government_authority, date(2018, 1, 1), 14400000).
test('period boundary: 31 Dec 2021 is the old figure, 1 Jan 2022 the new') :-
    art4_threshold(supplies, central_government_authority, date(2021, 12, 31), 13900000),
    art4_threshold(supplies, central_government_authority, date(2022, 1, 1), 14000000).
test('no threshold before 2016: a 2015 date yields nothing') :-
    findall(Cents, art4_threshold(works, central_government_authority, date(2015, 6, 1), Cents), []).

cp_test_names(['2024-2025 period: works all CA = EUR 5538000 (553800000 cents)', '2024-2025 period: central gov supplies = EUR 143000 (14300000 cents)', '2024-2025 period: sub-central supplies = EUR 221000 (22100000 cents)', '2024-2025 period: social services = EUR 750000 (75000000 cents)', '2022-2023 period: works all CA = EUR 5382000 (538200000 cents)', '2022-2023 period: central gov supplies = EUR 140000 (14000000 cents)', '2022-2023 period: sub-central supplies = EUR 215000 (21500000 cents)', '2022-2023 period: social services = EUR 750000 (75000000 cents)', '2026-2027 period (current): works = EUR 5404000 (540400000 cents)', '2026-2027 period (current): central gov supplies = EUR 140000 (14000000 cents)', 'current_art4_threshold resolves works for today', 'current_art4_threshold resolves services for today', 'no threshold AFTER the last known period', '2016-2017 period: works all CA = EUR 5225000 (522500000 cents)', '2016-2017 period: central gov supplies = EUR 135000 (13500000 cents)', '2016-2017 period: sub-central supplies = EUR 209000 (20900000 cents)', '2018-2019 period: works all CA = EUR 5548000 (554800000 cents)', '2018-2019 period: central gov supplies = EUR 144000 (14400000 cents)', '2018-2019 period: sub-central supplies = EUR 221000 (22100000 cents)', '2020-2021 period: works all CA = EUR 5350000 (535000000 cents)', '2020-2021 period: central gov supplies = EUR 139000 (13900000 cents)', '2020-2021 period: sub-central supplies = EUR 214000 (21400000 cents)', 'social services stay EUR 750000 across every pre-2022 period', 'period boundary: 31 Dec 2017 is the old figure, 1 Jan 2018 the new', 'period boundary: 31 Dec 2021 is the old figure, 1 Jan 2022 the new', 'no threshold before 2016: a 2015 date yields nothing']).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
