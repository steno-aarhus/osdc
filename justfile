@_default:
    just --list --unsorted

# Generate PNG images from all PlantUML files
generate-puml-all:
  docker run --rm -v $(pwd):/puml -w /puml ghcr.io/plantuml/plantuml:1.2024.3 -tpng "**/*.puml"

# Generate PNG image from specific PlantUML file
generate-puml name:
  docker run --rm -v  $(pwd):/puml -w /puml ghcr.io/plantuml/plantuml:1.2024.3 -tpng "**/{{name}}.puml"
