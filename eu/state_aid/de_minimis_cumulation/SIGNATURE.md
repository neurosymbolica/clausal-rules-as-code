# Predicate Signatures — eu/state_aid/de_minimis_cumulation

Source authority: Commission Regulation (EU) 2023/2831 Art 3(2).

---

## Public Predicates

**Query type #6 — threshold**

`de_minimis_threshold(THRESHOLD_CENTS)`: unifies THRESHOLD_CENTS with the integer
    30,000,000 (EUR 300,000 expressed in euro-cents), the per-undertaking ceiling
    imposed by Reg (EU) 2023/2831 Art 3(2) over any rolling three-year window.

**Query type #23 — calculation**

`de_minimis_aid_in_window(GRANTS, REF_ISO, TOTAL_CENTS)`: given GRANTS — a list of
    [DATE_ISO, AMOUNT_CENTS] pairs representing prior de minimis grants to a single
    undertaking — and REF_ISO (ISO YYYY-MM-DD string for the proposed new grant date),
    unifies TOTAL_CENTS with the integer sum of AMOUNT_CENTS for every grant whose
    DATE_ISO falls in the rolling three-year window ending REF_ISO, defined as
    window_start(REF_ISO, START) where START < DATE_ISO ≤ REF_ISO (lower bound
    exclusive, upper bound inclusive). All amounts must be supplied in integer
    euro-cents; TOTAL_CENTS is likewise an integer.

**Query type #2 — eligibility**

`de_minimis_verdict(GRANTS, REF_ISO, VERDICT)`: given GRANTS and REF_ISO as above,
    calls de_minimis_aid_in_window/3 to obtain TOTAL_CENTS, then unifies VERDICT with
    'eligible' when TOTAL_CENTS =< 30,000,000, or 'ineligible' otherwise.
    The proposed new grant amount is NOT included in GRANTS; callers must add it
    separately if they wish to test the post-grant position.

---

## Support Predicates

`window_start(REF_ISO, START_ISO)`: given REF_ISO (ISO YYYY-MM-DD), unifies START_ISO
    with the ISO date exactly three calendar years earlier — same month and day,
    year − 3 — representing the exclusive lower bound of the rolling window.
    If REF_ISO is 29 February on a leap year, START_ISO is clamped to 28 February of
    year − 3 (which is never a leap year for that offset) to avoid an invalid date.

`grant_in_window(DATE_ISO, REF_ISO)`: succeeds when the grant on DATE_ISO falls within
    the rolling window ending REF_ISO: window_start(REF_ISO, START) holds and
    START @< DATE_ISO @=< REF_ISO (ISO string lexicographic order, which coincides with
    chronological order for zero-padded YYYY-MM-DD). Used internally by
    de_minimis_aid_in_window/3 to filter GRANTS.
