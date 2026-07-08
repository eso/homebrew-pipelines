# Maintaining the eso/pipelines Tap

This document covers how the tap is structured and how to keep its formulae up to date.

## Tap Structure

Each instrument pipeline has **three formulae**:

| Formula | Contents | Update method |
|---|---|---|
| `esopipe-<instrument>-recipes` | compiled pipeline code | PR workflow (bottles built by CI) |
| `esopipe-<instrument>` | static data package | commit directly to `main` |
| `esopipe-<instrument>-demo` | static + demo data | commit directly to `main` |

> ⚠️ **Only `-recipes` formulae produce bottles.** Never open a PR for `-static` or `-demo` formulae — it wastes CI resources building bottles that don't exist.

The tap also maintains several shared libraries and tools:

- **Core:** `cpl@7.4`, `erfa`, `molecfit-third-party`
- **Tools:** `esorex`, `esoreflex`, `hdrl`, `telluriccorr`
- **Python:** `adari`, `edps`, `pycpl`, `pyesorex`, `pyhdrl`
- **Third-party deps:** `gsl`, `cfitsio`, `fftw`, `libcext`, `wcslib`

### CI/CD

Two GitHub Actions workflows live in `.github/workflows/`:

- **`tests.yaml`** — triggered by PRs; builds and tests formulae.
- **`publish.yaml`** — triggered by the `pr-pull` label on a merged PR; publishes bottles to the GitHub Packages registry.

---

## Update Order

When updating shared dependencies, always go bottom-up so each layer is built against the correct version of its dependencies:

1. `cpl@7.4`, `erfa`, `molecfit-third-party`
2. `esorex`, `hdrl`, `pycpl`, `telluriccorr`
3. pipeline `-recipes` formulae, `pyesorex`, `pyhdrl`

Formulae at the same level can be updated in parallel; never update a higher level before its dependencies are fully published.

---

## Updating Formulae

### `-recipes` formulae — PR workflow

1. Create a branch for the update.
2. Edit the formula: update `version` and `sha256`.
3. Validate locally (recommended):
   ```bash
   brew style esopipe-<instrument>-recipes
   brew audit esopipe-<instrument>-recipes
   brew install --build-from-source esopipe-<instrument>-recipes
   brew test esopipe-<instrument>-recipes
   ```
4. Push the branch and open a PR. CI will build the bottles.
5. Once tests pass, merge the PR, then apply the **`pr-pull`** label to trigger bottle publishing.

Use one branch and one PR per formula. Multiple formulae can be updated simultaneously using separate branches/PRs.

### `-static` and `-demo` formulae — direct to `main`

Once the corresponding `-recipes` formula is published, copy its `url` and `sha256` into the static formula and commit **directly to `main`**. Demo data changes much less frequently than recipes.

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

After the PR is merged, apply the `pr-pull` label to publish.

### Bump all autobump-eligible formulae

Formulae listed in `.github/autobump.txt` can be bumped automatically:

```bash
brew bump --no-fork --open-pr --auto --formulae --tap eso/pipelines
```

### Rebuild bottles without a version change (revision bump)

Use `brew bump-revision` to increment the `revision` field, then open a PR manually. The script below handles a list of formulae:

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

---

## Special Cases

### Python formulae

When updating `adari`, `edps`, `pycpl`, `pyesorex`, or `pyhdrl`, also refresh their Python dependency `resource` blocks:

```bash
brew update-python-resources <formula>
```

This updates all resource blocks to the latest versions on PyPI.

### Why `cpl@7.4` instead of homebrew-core's `cpl`

The pipelines are pinned to CPL 7.4. Maintaining a versioned formula in this tap lets us control CPL upgrades independently of homebrew-core and ensures all pipelines are always built against a known-good version.

### Test blocks and `esorex` dependency

Each `-recipes` formula has a test block that calls `esorex` to print a recipe's man page. This creates a build-time dependency on `esorex`. When updating `esorex` itself (e.g. because of a new CPL version), the build may fail because the test blocks of all recipe formulae run as part of the build. Be aware of this circular dependency and disable or skip tests as needed when bumping `esorex`.
