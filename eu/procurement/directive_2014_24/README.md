# eu/procurement/directive_2014_24 — Shared Procurement Backbone Library

Shared vocabulary atoms and Art 4 threshold values for EU public procurement
(Directive 2014/24/EU). **Library modules — not a decision domain**: no
manifest.yaml, no oracle, no verdict predicate.

## Contents

| File | Role |
|------|------|
| `vocabulary.clausal` | Contracting-authority types, contract types, procedure types |
| `art4_thresholds.clausal` | Art 4 threshold facts (dated, euro-cents) + query predicates |
| `art4_thresholds-sources.yaml` | Source manifest for threshold figures |
| `tests/` | Module-level tests (no oracle) |

## Two modules, no package facade

Import the module you need, by its own dotted path:

    :- use_module(eu/procurement/directive_2014_24/vocabulary, [contract_type/1]).
    :- use_module(eu/procurement/directive_2014_24/art4_thresholds, [art4_threshold/4]).

Only predicates are imported; the vocabulary atoms (`works`, `services`, ...)
need no import in Clausal Prolog and are spelled directly.

There is deliberately **no `__init__.clausal`**. This directory used to carry
one that re-exported both modules, so a consumer could import the package root
instead; 48 of the 55 consumer files then declared a dependency on Art 4
figures they never used. The two halves also change on different clocks — the
Directive vocabulary is stable, the Art 4 figures are revised every two years
— so they are separate modules on purpose, and a caller says which one it
means. The ISO exporter additionally refuses a package import target, because
an emitted `use_module` resolves to a file and ISO has no reexport directive.

## Source: Art 4 Thresholds

Thresholds change biennially via Commission Delegated Regulations under
Art 6(1) of Directive 2014/24/EU (alignment with WTO GPA thresholds).

### 2022–2023 period
Commission Delegated Regulation (EU) 2021/1952 (CELEX 32021R1952),
effective 1 January 2022.

| Category | EUR | EUR-cents |
|----------|-----|-----------|
| Works (all contracting authorities) | 5,382,000 | 538,200,000 |
| Supplies + services, central government authorities | 140,000 | 14,000,000 |
| Supplies + services, sub-central contracting authorities | 215,000 | 21,500,000 |
| Social and other specific services (Art 74, Annex XIV) | 750,000 | 75,000,000 |

Sources verified from EUR-Lex CELEX:32021R1952 (fetched 2026-07-24):
the regulation replaces the prior Article 4 values with those listed above,
effective 1 January 2022.

### 2024–2025 period
Commission Delegated Regulation (EU) 2023/2495 (CELEX 32023R2495),
effective 1 January 2024.

| Category | EUR | EUR-cents |
|----------|-----|-----------|
| Works (all contracting authorities) | 5,538,000 | 553,800,000 |
| Supplies + services, central government authorities | 143,000 | 14,300,000 |
| Supplies + services, sub-central contracting authorities | 221,000 | 22,100,000 |
| Social and other specific services (Art 74, Annex XIV) | 750,000 | 75,000,000 |

Sources verified from EUR-Lex CELEX:32023R2495 (fetched 2026-07-24):
the regulation replaces "EUR 5 382 000" with "EUR 5 538 000", "EUR 140 000"
with "EUR 143 000", "EUR 215 000" with "EUR 221 000". Social services
threshold unchanged (confirmed: "thresholds for social services and other
special services have not been changed").

### 2026–2027 period
Commission Delegated Regulation (EU) 2025/2152 (CELEX 32025R2152),
effective 1 January 2026.

| Category | EUR | EUR-cents |
|----------|-----|-----------|
| Works (all contracting authorities) | 5,404,000 | 540,400,000 |
| Supplies + services, central government authorities | 140,000 | 14,000,000 |
| Supplies + services, sub-central contracting authorities | 216,000 | 21,600,000 |
| Social and other specific services (Art 74, Annex XIV) | 750,000 | 75,000,000 |

Source: Commission Delegated Regulation (EU) 2025/2152, effective 1 January 2026.
Verified via cuatrecasas.com summary (fetched 2026-07-24) and EUR-Lex search.

## Money encoding

All threshold amounts stored as plain integer **euro-cents** (no floats, no
strings). EUR 5,538,000 → `553800000`. Pattern follows
`eu/derivatives/emir_nfc_clearing/constants.clausal`.

## Social services note

The EUR 750,000 threshold is set directly in Art 74 of Directive 2014/24/EU
(light-touch regime), not in Art 4. It has remained unchanged across every
biennial revision since 2014. It is included here for completeness under
`social_and_other_specific_services` to give callers a single lookup point.
