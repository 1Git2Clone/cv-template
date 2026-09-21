# work-cvs

[![CI Icon]][CI Status]&emsp;[![GitHub CI]][GitHub Status]

One knowledge base, one LaTeX template, and a reproducible build. The point is
to stop rewriting a CV from scratch for every posting: `PROFILE.md` holds
everything true about you, a job posting says which parts matter, and `cv.tex`
is the format that turns the selected subset into a one-page PDF an applicant
tracking system can actually read.

```text
PROFILE.md  ──┐
              ├──►  tailored cv.tex  ──►  latexmk  ──►  cv.pdf
job posting ──┘
```

## The files

<!-- markdownlint-disable MD013 -->

| File         | What it is                                                                          |
| ------------ | ----------------------------------------------------------------------------------- |
| `PROFILE.md` | The source of truth. Deliberately holds **more** detail than any one CV should show |
| `cv.tex`     | The template and the current baseline — style, spacing, section layout              |
| `cv.pdf`     | Committed on purpose: it is the artifact people are actually sent                   |
| `flake.nix`  | The LaTeX toolchain, so the build needs no system-wide TeX install                  |

<!-- markdownlint-enable MD013 -->

## Building

```sh
nix develop                          # then: latexmk -pdf cv.tex
nix develop -c latexmk -pdf cv.tex   # one-shot
nix develop -c latexmk -c            # drop the aux files, keep the PDF
```

A named subset of TeX Live rather than `scheme-full` — ten packages on top of
the small scheme, which is a fraction of the closure and still builds this
document unchanged. A `\usepackage` added to `cv.tex` may need a line in
`flake.nix`, and the error when it does says exactly which file is missing.

Two of those packages are not named after the file that needs them, which is
the only part that ever wastes anyone's time:

- `fullpage.sty` comes from **`preprint`**
- `tabularx.sty` comes from **`tools`**

> [!NOTE]
> Nix reads the flake through git, so a **newly created** file is invisible
> until it is at least `git add -N`-ed.
> `error: Path 'x' ... is not tracked by Git` means that, not a broken flake.

## Why this format, and what "ATS friendly" actually means here

Most CV templates lose text on the way into an applicant tracking system,
because the PDF stores glyph indices with no mapping back to characters — the
document looks right and extracts as mojibake, or as nothing. Two lines in
`cv.tex` are what prevent that:

```tex
\input{glyphtounicode}   % the glyph → Unicode mapping table
\pdfgentounicode=1       % emit it into the PDF
```

That embeds a ToUnicode CMap, so the text in the PDF is recoverable as text. It
is a real mechanism rather than a claim, and it is checkable in one command:

```sh
pdftotext cv.pdf - | head -20      # should read as your CV, not as symbols
```

One place it is imperfect, visible in that same extraction: the contact line
renders as `GitHub | LinkedIn`, so a parser reading text gets the words and not
the URLs behind them. Fine for a human, lossy for a machine. If a posting's
system is known to harvest links, spell the URLs out instead of hiding them
behind `\href` link text.

The rest of the ATS-friendliness is what the template does _not_ do — no multi-column
layout, no text inside images, no icon fonts standing in for words, no header/footer
carrying content. Section headings are plain words (`Experience`, `Education`,
`Technical Skills`) because that is what parsers look for.

Based on [Jake Gutierrez's resume template][jake], itself based on [sb2nov/resume][sb2nov].
MIT license.

[jake]: https://github.com/jakegut/resume
[sb2nov]: https://github.com/sb2nov/resume

## Writing a tailored version

`PROFILE.md` ends with a **CV Generation Notes** section — the rules live there
rather than here, so that an AI handed only that file still has them. In short:
pick the relevant subset, reword freely, invent nothing, keep it to one page,
and cut bullets rather than shrinking the margins.

The template's commands, so a tailored version matches the baseline instead of
inventing a layout:

| Command                          | Use                                |
| -------------------------------- | ---------------------------------- |
| `\resumeSubheading{a}{b}{c}{d}`  | A job: company, location, role, dates |
| `\resumeProjectHeading{a}{b}`    | A project: name + tech, dates      |
| `\resumeItem{...}`               | One bullet                         |
| `\resumeSubHeadingListStart/End` | Wraps subheadings                  |
| `\resumeItemListStart/End`       | Wraps bullets under one subheading |

Current sections: Summary, Experience, Contributions & Projects, Education, Technical
Skills, Languages.

Keep `cv.tex` as the general-purpose baseline.
Cut a version down for one application only if worth revisiting.

## Linting

This repo uses [markdownlint](https://github.com/DavidAnson/markdownlint)
to keep the Markdown files (`PROFILE.md`, `README.md`) consistent. The config is
in `.markdownlint.json`.

```sh
nix develop -c markdownlint .
```

## Git hooks

This repo uses [git-hooks.nix](https://github.com/cachix/git-hooks.nix) to run
hooks automatically before each commit. The hook configuration lies in
`flake.nix`:

- **markdownlint** — checks `.md` files against `.markdownlint.json`
- **latex-compile** — runs `latexmk -pdf cv.tex` on `.tex` changes to catch
  compilation errors before they reach the commit

Enter a development shell with hooks enabled:

```sh
nix develop
```

Run all hooks sandboxed (no internet, read-only filesystem):

```sh
nix flake check
```

Run hooks through the dev shell (recommended for formatting hooks):

```sh
nix develop -c pre-commit run --all-files
```

If you're using Neovim, the `markdownlint` CLI and `texlab` LSP
are both provided by `flake.nix` via the devShell packages.

[CI Icon]: https://git.hu-tao.dev/hutao/cv-template/badges/workflows/ci.yml/badge.svg
[CI Status]: https://git.hu-tao.dev/hutao/cv-template/actions
[GitHub CI]: https://github.com/hutao/cv-template/actions/workflows/ci.yml/badge.svg
[GitHub Status]: https://github.com/hutao/cv-template/actions
