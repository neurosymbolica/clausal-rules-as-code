# Standards and openness

The project tries to conform to existing standards wherever one exists, and to keep everything
open where none does.

| Area | What is used |
|---|---|
| Identifying the law | CELEX numbers, consolidated-version identifiers and ELI URIs from EUR-Lex |
| The legal text itself | Formex 4 XML (the Official Journal's format) and XHTML, as published by the Publications Office, pinned by SHA-256 |
| Units of the text | Article, paragraph and point identifiers taken from the official document structure |
| Licence | European Union Public Licence, EUPL-1.2, for the whole repository |
| Language | Clausal Prolog (`.clausal`), a restricted subset of ISO Prolog, meant to run on ordinary ISO-conforming Prolog engines; see below |
| Data formats | Plain text: YAML records, Markdown documentation, HTML reports; no proprietary formats |

## The language: a restricted subset of ISO Prolog

The rules are written in **Clausal Prolog** (`.clausal` files), a deliberately **restricted
subset of ISO Prolog** (ISO/IEC 13211-1). The restriction is the point:

- **Cut-free, so easier to reason about.** Clausal Prolog refuses the cut (`!`) and if-then-else
  (`->`), the constructs that let a Prolog program silently discard answers depending on the
  order in which its clauses are tried. Without them, each clause is a plain logical statement
  that can be read and checked on its own, against the provision it implements: its meaning does
  not depend on what comes before it in the file or on how it happens to be executed. The same
  rule then answers every kind of question soundly, such as *is this lawful?*, *what is missing?*
  and *which facts would change the answer?*, which is what makes the rules reviewable by a
  lawyer and checkable by machine. The remaining cut-like constructs, such as negation as
  failure, are being phased out in favour of their pure equivalents.
- **It runs on standard engines.** Because every Clausal Prolog program is ISO Prolog, it is meant
  to run on ordinary ISO-conforming engines, such as Scryer Prolog and Trealla Prolog, as well as
  on the Clausal engine, with small companion libraries for what ISO leaves open (dictionaries,
  dates). Plain ISO Prolog (`.pl`) versions are generated from the same source. No one engine,
  and no one vendor, is needed to run the law.
- **It is a standard others already know.** ISO Prolog is an international standard with several
  independent open-source implementations and decades of use in legal and expert systems.

The domains in this preview are being converted from the engine's earlier Python-like syntax
(`.seam`) to `.clausal`, with each domain's own tests required to pass unchanged on the Clausal
engine and on independent ISO engines.

## Interoperability by design

- **No lock-in.** The engine is open source, the formalizations are text files, and the checks
  are ordinary Python scripts that run on any computer.
- **Determinism.** The same input always gives the same answer; nothing depends on a network
  service or a statistical model at run time.
- **Shared interfaces.** Domains follow common conventions for their inputs, their verdicts and
  their citations, catalogued in `_index/interface-catalog/` and checked by
  `_tools/check_interface_conformance.py`, so that one domain can be combined with another.
- **Legal document standards.** The Publications Office is moving EU legislation towards Akoma
  Ntoso (AKN4EU). The citation records already refer to official structural units, which is
  what a mapping to AKN4EU identifiers would build on.

## Licence and contributions

Everything is published under the EUPL-1.2, the open-source licence created by the European
Commission and available in all official languages of the EU. Outside contributions will be
accepted once a contributor licence agreement is in place; it is being prepared.
