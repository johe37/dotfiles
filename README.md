# dotfiles

Init the dotfiles by running:

```shell
bash init.sh
```

Run only some steps, or skip some:

```shell
bash init.sh link                # only symlinks
bash init.sh --no-packages       # everything except package install
bash init.sh --dry-run           # show what would happen
bash init.sh --help
```

A failing step does not stop the others. Package install is skipped with a
warning when you have no sudo rights. Existing files are never overwritten;
only symlinks that point elsewhere are replaced.
