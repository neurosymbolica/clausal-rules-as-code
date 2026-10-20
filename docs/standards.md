# Standards and openness

The project tries to conform to existing standards wherever one exists, and to keep everything
open where none does.

| Area | What is used |
|---|---|
| Identifying the law | CELEX numbers, consolidated-version identifiers and ELI URIs from EUR-Lex |
| The legal text itself | Formex 4 XML (the Official Journal's format) and XHTML, as published by the Publications Office, pinned by SHA-256 |
| Units of the text | Article, paragraph and point identifiers taken from the official document structure |
| Licence | European Union Public Licence, EUPL-1.2, for the whole repository |
| Execution | Clausal Prolog, an open-source engine directed at the ISO Prolog standard; the two core kit libraries also ship ISO Prolog (`.pl`) versions |
| Data formats | Plain text: YAML records, Markdown documentation, HTML reports; no proprietary formats |

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
