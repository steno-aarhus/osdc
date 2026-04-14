@_default:
    just --list --unsorted

# Run all recipes
run-all: clean install-deps document check-spelling check-urls format-r format-md lint test build-website check-local-cran install-package

# List all TODO items in the repository
list-todos:
  grep -R -n \
    --exclude-dir=.quarto \
    --exclude-dir=docs \
    --exclude=justfile \
    --exclude=*.csl \
    "TODO" *

# Clean up auto-generated files
clean: _cleanup-vignettes
  #!/usr/bin/env Rscript
  pkgdown::clean_site()

# Clean up generated HTML and R files from vignettes
@_cleanup-vignettes:
  rm vignettes/*.R vignettes/*.html vignettes/articles/*.R vignettes/articles/*.html


# Install package dependencies
install-deps:
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

# Run the package tests
test:
  #!/usr/bin/env Rscript
  devtools::test()

# Update wordlist
update-wordlist:
  #!/usr/bin/env Rscript
  spelling::update_wordlist()

# Check the spelling
check-spelling:
  #!/usr/bin/env Rscript
  devtools::spell_check()

# Check for any broken URLs
check-urls: _check-url-cran _check-url-lychee

# Check URLs based on CRAN requirements
@_check-url-cran:
  #!/usr/bin/env Rscript
  urlchecker::url_check()

# Install https://github.com/lycheeverse/lychee#installation
# Check URLs using lychee tool
@_check-url-lychee:
  lychee . --verbose

# Format all R code
format-r: _format-r-styler _format-r-air

# Air is better, but doesn't style Qmd files
@_format-r-air:
  uvx --from air-formatter air format .

# Styler formats Quarto files
@_format-r-styler:
  #!/usr/bin/Rscript
  styler::style_dir()

# Format Markdown files
format-md:
  uvx rumdl fmt --silent

# From https://jarl.etiennebacher.com/#installation
# Lint R code for any potential issues
lint:
  jarl check .

# Build the pkgdown website
build-website:
  #!/usr/bin/env Rscript
  pkgdown::build_site()

# Run local CRAN checks
check-local-cran:
  #!/usr/bin/env Rscript
  devtools::check(error_on = "note")

# Install the package itself
install-package:
  #!/usr/bin/env Rscript
  devtools::install()

# Preview website locally
preview-website:
  #!/usr/bin/env Rscript
  pkgdown::preview_site()
