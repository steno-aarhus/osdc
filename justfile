@_default:
    just --list --unsorted

# Run all recipes
run-all: clean install-package-dependencies document update-wordlist spell-check style test build-website check install-package

# Clean up auto-generated files
clean:
  #!/usr/bin/env Rscript
  devtools::clean_vignettes()
  pkgdown::clean_site()

# Install package dependencies
install-package-dependencies:
  #!/usr/bin/env Rscript
  pak::pak(
    dependencies = c(
      "all"
    ),
    ask = FALSE
  )

# Run document generators
document:
  #!/usr/bin/env Rscript
  devtools::document()

# Update wordlist
update-wordlist:
  #!/usr/bin/env Rscript
  spelling::update_wordlist()

# Run the package tests
test:
  #!/usr/bin/env Rscript
  devtools::test()

# Check the spelling
spell-check:
  #!/usr/bin/env Rscript
  devtools::spell_check()

# Check URLs based on CRAN requirements
url-check:
  #!/usr/bin/env Rscript
  urlchecker::url_check()

# Style all R code in the package
style:
  # Need to install air first.
  air format .

# Build the pkgdown website
build-website:
  #!/usr/bin/env Rscript
  pkgdown::build_site()

# Run local CRAN checks
check:
  #!/usr/bin/env Rscript
  devtools::check()

# Install the package itself
install-package:
  #!/usr/bin/env Rscript
  devtools::install()

# Generate svg images from all PlantUML files
generate-puml-all:
  docker run --rm -v $(pwd):/puml -w /puml ghcr.io/plantuml/plantuml:1.2024.3 -tsvg "**/*.puml"

# Generate svg image from specific PlantUML file
generate-puml name:
  docker run --rm -v  $(pwd):/puml -w /puml ghcr.io/plantuml/plantuml:1.2024.3 -tsvg "**/{{name}}.puml"
