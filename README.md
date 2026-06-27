# homebrew-pipelines

## How do I install these formulae?

`brew install eso/pipelines/<formula>`

Or `brew tap eso/pipelines` and then `brew install <formula>`.

### Data Reduction Pipelines and Demo Data
The recommended install is the static package, which also includes recipes. Demo packages include recipes, static data, and demo data, and can be multi-gigabyte downloads.
DETMON only ships the `esopipe-detmon-recipes` formula.

| Pipeline | Recommended install (includes recipes) | Demo data (may be multi-gigabyte) | Notes |
| --- | --- | --- | --- |
| AMBER | `esopipe-amber` | `esopipe-amber-demo` | |
| CR2RES | `esopipe-cr2re` | `esopipe-cr2re-demo` | |
| CRIRES | `esopipe-crires` |  | |
| DETMON |  |  | recipes only (`esopipe-detmon-recipes`) |
| EFOSC | `esopipe-efosc` | `esopipe-efosc-demo` | |
| ERIS | `esopipe-eris` | `esopipe-eris-demo` | |
| ESOTK | `esopipe-esotk` | `esopipe-esotk-demo` | |
| ESPDA | `esopipe-espda` | `esopipe-espda-demo` | |
| ESPDR | `esopipe-espdr` | `esopipe-espdr-demo` | |
| FORS | `esopipe-fors` | `esopipe-fors-demo` | |
| GIRAFFE | `esopipe-giraf` | `esopipe-giraf-demo` | |
| GRAVITY | `esopipe-gravity` | `esopipe-gravity-demo` | |
| HARPS | `esopipe-harps` | `esopipe-harps-demo` | |
| HAWKI | `esopipe-hawki` | `esopipe-hawki-demo` | |
| IIINSTRUMENT | `esopipe-iiinstrument` | `esopipe-iiinstrument-demo` | test pipeline, not a real instrument |
| ISAAC | `esopipe-isaac` |  | |
| KMOS | `esopipe-kmos` | `esopipe-kmos-demo` | |
| MATISSE | `esopipe-matisse` | `esopipe-matisse-demo` | |
| MIDI | `esopipe-midi` |  | |
| MOLECFIT | `esopipe-molecfit` | `esopipe-molecfit-demo` | |
| MUSE | `esopipe-muse` | `esopipe-muse-demo` | |
| NACO | `esopipe-naco` |  | |
| NIRPS | `esopipe-nirps` | `esopipe-nirps-demo` | |
| SINFO | `esopipe-sinfo` | `esopipe-sinfo-demo` | |
| SOFI | `esopipe-sofi` |  | |
| SPHERE | `esopipe-spher` | `esopipe-spher-demo` | |
| UVES | `esopipe-uves` | `esopipe-uves-demo` | |
| VIRCAM | `esopipe-vcam` | `esopipe-vcam-demo` | |
| VIMOS | `esopipe-vimos` | `esopipe-vimos-demo` | |
| VISIR | `esopipe-visir` | `esopipe-visir-demo` | |
| XSHOOTER | `esopipe-xshoo` | `esopipe-xshoo-demo` | |

### Other formulae

| Formula | Description |
| --- | --- |
| adari | Astronomical DAta Reporting Infrastructure |
| cpl@7.4 | ISO-C libraries for developing astronomical data-reduction tasks |
| edps | ESO Data Processing System |
| erfa | Essential Routines for Fundamental Astronomy |
| esoreflex | Reflex environment to execute ESO pipelines |
| esorex | Execution Tool for European Southern Observatory pipelines |
| hdrl | ESO High-level Data Reduction Library |
| molecfit-third-party | 3rd party tools for the Molecfit library |
| pycpl | Python Language Bindings for CPL |
| pyesorex | ESO Recipe Executor Tool for CPL/PyCPL recipes |
| pyhdrl | Python Language Bindings for HDRL |
| telluriccorr | Telluric Correction |

## Documentation

`brew help`, `man brew` or check [Homebrew's documentation](https://docs.brew.sh).
