@_default:
    just --list --unsorted

# Run all recipes
run-all: clean install-package-dependencies document run-targets spell-check style test build-website check install-package

# Clean up auto-generated files
clean:
  #!/usr/bin/Rscript
  devtools::clean_vignettes()
  pkgdown::clean_site()

# Install package dependencies
install-package-dependencies:
  #!/usr/bin/Rscript
  pak::pak(
    dependencies = c(
      "all", 
      "Config/Needs/data", 
      "Config/Needs/website"
    ),
    ask = FALSE
  )

# Run document generators
document:
  #!/usr/bin/Rscript
  devtools::document()

# Run the pipeline to re-build the data objects
run-targets:
  #!/usr/bin/Rscript
  targets::tar_make()

# Run the package tests
test:
  #!/usr/bin/Rscript
  devtools::test()

# Check the spelling
spell-check:
  #!/usr/bin/Rscript
  devtools::spell_check()

# Check URLs based on CRAN requirements
url-check:
  #!/usr/bin/Rscript
  urlchecker::url_check()

# Style all R code in the package
style:
  #!/usr/bin/Rscript
  styler::style_pkg()

# Build the pkgdown website
build-website:
  #!/usr/bin/Rscript
  pkgdown::build_site()

# Run local CRAN checks
check:
  #!/usr/bin/Rscript
  devtools::check()

# Install the package itself
install-package:
  #!/usr/bin/Rscript
  devtools::install()

# Generate svg images from all PlantUML files
generate-puml-all:
  docker run --rm -v $(pwd):/puml -w /puml ghcr.io/plantuml/plantuml:1.2024.3 -tsvg "**/*.puml"

# Generate svg image from specific PlantUML file
generate-puml name:
  docker run --rm -v  $(pwd):/puml -w /puml ghcr.io/plantuml/plantuml:1.2024.3 -tsvg "**/{{name}}.puml"
