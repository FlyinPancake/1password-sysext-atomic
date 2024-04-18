---
title: Docs
---

Just a little script to create documentation from the scripts. For actual documentation, see the other pages.

This little script:

1.  Converts the files
    -   Deletes the shebang
    -   <s>Indents all non-commented, non-empty lines</s>
    -   Strips "`# `" from the start of every line
4.  Saves the converted `*.md` files to `docs/`

^

```shell
  cd scripts
  for script in *.sh; do
      sed -E '/^#!/d; s/^([^#])/  \1/; s/^# //' "${script}" | tail -n +1 > "../docs/$(echo $script | cut -d. -f1).md"
  done
```

Old (and simpler) version:

```shell
cd scripts
for script in *.sh; do
    sed -E '/^#!/d; s/^([^#])/    \1/; s/^# //' "${script}" > "../docs/$(echo $script | cut -d. -f1).md"
done
```

And here is a concept of another potential '[literate](https://en.wikipedia.org/wiki/Literate_programming)' format.
Although this whole script is kind of the opposite.

```shell
: << DOC
This is a multi-line string that doesn't need to be prefixed by '#'.
Unfortunately backticks would be interpreted, which could be dangerous.
We'd also need some state in the conversion script above.
DOC
```
