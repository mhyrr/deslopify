# Deslopify

Deslopify is an agent skill that removes the machine accent from prose without
flattening the writer's voice. It works on READMEs, documentation,
announcements, landing pages, and other writing meant for people.

The skill edits structure, sentence shape, and wording. It preserves claims,
numbers, names, commands, and terms of art. It does not guess whether AI wrote
the text or invent facts to make weak copy sound specific.

`SKILL.md` contains the editing method. The `references/` directory contains
the pattern catalogs and supporting data.

## Sources

The 38 sentence patterns began with Simon Willison's
[LLM cliché highlighter](https://tools.simonwillison.net/llm-cliche-highlighter).
Deslopify adds editing tests and repair guidance for each pattern.

The ranked vocabulary begins with Louis Abraham's
[load-bearing](https://github.com/louisabraham/load-bearing) analysis of 461,121
GitHub pull request descriptions. Deslopify re-ranks its published lift list by
lift and rarity in general English.

Run the scanner to locate candidates for review:

```sh
bash scan.sh path/to/file.md
```

The scanner reports candidates, not automatic edits. Run the detector checks
after changing a pattern or score:

```sh
bash tests/check.sh
```
