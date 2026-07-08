# Maintaining the eso/pipelines Tap

This doc gives a quick overview of how the tap is structured and how to keep its formulae up to date.

## Tap Structure

Each instrument pipeline has **three formulae**:

| Formula | Contents | Update method |
| --- | --- | --- |
| `esopipe-<instrument>-recipes` | compiled pipeline code | PR workflow (bottles built by CI) |
| `esopipe-<instrument>` | static data package | commit directly to `main` |
| `esopipe-<instrument>-demo` | demo data package | commit directly to `main` |

> ⚠️ **Only `-recipes` formulae produce bottles.** Never open a PR for `-static` or `-demo` formulae.

The tap also maintains several shared libraries and tools:

- **Core:** `cpl@7.4`, `erfa`, `molecfit-third-party`, `hdrl`, `telluriccorr`
- **Tools:** `esorex`, `esoreflex`
- **Python:** `adari`, `edps`, `pycpl`, `pyesorex`, `pyhdrl`

The main third-party dependencies provided by homebrew-core are:

- `gsl`, `cfitsio`, `fftw`, `libcext`, `wcslib`

### CI/CD

Two GitHub Actions workflows live in `.github/workflows/`:

- **`tests.yaml`** — triggered by PRs; builds and tests formulae.
- **`publish.yaml`** — triggered by the `pr-pull` label on a merged PR; publishes bottles to the GitHub Packages registry.

Those workflows are created when a new tap is created with `brew tap-new`, and they can be adjusted by the tap maintainer
— for example, to change which GitHub runners build the packages.

### Supported platforms

| Platform | Runner |
| --- | --- |
| Linux x64 | `ubuntu-24.04` |
| macOS Intel x64 | `macos-14-large` |
| macOS arm64 | `macos-14`, `macos-15`, `macos-26` |

Linux arm64 may be supported in the future.

> Note: `macos-14-large` is not free like the other runners. GitHub bills its usage, and we have set a monthly budget
> limit for it.

---

## Update Order

When updating shared dependencies, always go bottom-up so each layer is built against the right version of its
dependencies:

- **Core libraries:** `cpl@7.4`, `erfa`, `molecfit-third-party`
- **Tools:** `esorex`, `hdrl`, `pycpl`, `telluriccorr`
- **Pipelines:** `-recipes`, `pyesorex`, `pyhdrl`

Formulae at the same level can be updated in parallel. Never update a higher level before its dependencies are fully
published.

The remaining formulae, such as `edps` and `adari`, can be updated at any time because nothing else depends on them.

---

## Updating Formulae

### PR workflow for `-recipes` formulae

1. Create a branch for the update.
2. Edit the formula: update `url` and `sha256`.
3. Validate locally (recommended):
   ```bash
   brew style esopipe-<instrument>-recipes
   brew audit esopipe-<instrument>-recipes
   brew install --build-from-source esopipe-<instrument>-recipes
   brew test esopipe-<instrument>-recipes
   ```
4. Push the branch and open a PR. CI will build the bottles.
5. Once checks pass, apply the **`pr-pull`** label to trigger bottle publishing and merge the branch.

Use one branch and one PR per formula. Multiple formulae can be updated simultaneously using separate branches/PRs.

### `-static` and `-demo` formulae — direct to `main`

Once the corresponding `-recipes` formula is published, copy its `url` and `sha256` (lines 4-5) into the static formula
and commit **directly to `main`**. Demo data changes much less frequently than recipes.

---

## Automation

### Check for new versions

```bash
brew livecheck --tap eso/pipelines --newer --autobump
```

### Bump one or more `-recipes` formulae

```bash
brew bump --no-fork --open-pr --formulae esopipe-<instrument>-recipes
```

This command opens a PR for each formula, but it does not publish bottles. As described above, apply the `pr-pull`
label to publish and merge the changes to `main` after all checks pass.

### Bump all autobump-eligible formulae

Formulae listed in `.github/autobump.txt` can be bumped automatically:

```bash
brew bump --no-fork --open-pr --auto --formulae --tap eso/pipelines
```

Again, apply the `pr-pull` label to publish and merge the changes to `main` after all checks pass.

### Rebuild bottles without a version change (revision bump)

Use `brew bump-revision` to increment the `revision` field, then open a PR manually. The script below handles a list of
formulae:

```bash
#!/bin/bash
for formula in "$@"; do
  branch="bump_revision_${formula}"
  title="Bump revision ${formula}"
  echo "Processing $formula"
  git checkout main && git pull
  git checkout -b "$branch"
  brew bump-revision "$formula"
  git push --set-upstream origin "$branch"
  gh pr create -t "$title" -b "$title"
done
```

Note that this script requires the GitHub CLI `gh` to be installed and authenticated. It also assumes the current
working directory is the root of the tap repository.

---

## Troubleshooting

### CI build fails

When a build fails, start by checking the CI logs and looking for the actual error message. That usually points to the
formula, dependency, or test that needs attention.

---

## Special Cases

### Python formulae

When updating `adari`, `edps`, `pycpl`, `pyesorex`, or `pyhdrl`, also refresh their Python dependency `resource` blocks:

```bash
brew update-python-resources <formula>
```

This updates all resource blocks to the latest versions on PyPI.

### Why `cpl@7.4` instead of homebrew-core's `cpl`

The pipelines are pinned to CPL 7.4. Keeping a versioned formula in this tap lets us control CPL upgrades independently
of homebrew-core and keeps all pipelines built against a known-good version.

### Test blocks and `esorex` dependency

Each `-recipes` formula has a test block that calls `esorex` to print a recipe's man page and check that the version is
the expected one.

This creates a build-time dependency on `esorex`. When updating `esorex` itself (for example, because of a new CPL
version), the build may fail because the test blocks of all recipe formulae run as part of the build.

A workaround is to remove the bottle blocks from all `-recipes` formulae, bump `esorex`, and then rebuild all
`-recipes` formulae to generate new bottles.

### Testing a development version of a pipeline before publication

Since the development version is not available on the public FTP, it is not possible to update the version in GitHub.

To test a development version, edit the formula and update lines 4 and 5 (`url` and `sha256`) so they point to the
development source kit tarball.

```bash
brew edit <formula>
```

`brew install -s <formula>` installs the formula from source:

```bash
brew install -s <formula>
```

To compute the sha256 of the development version, download the tarball from the FTP and run:

```bash
shasum -a 256 <tarball>
```
