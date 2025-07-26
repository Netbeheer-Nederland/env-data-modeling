set dotenv-required
set dotenv-load
set shell := ["bash", "-uc"]
set windows-shell := ["bash", "-uc"]

ref_name := "git rev-parse --abbrev-ref HEAD"
major_branch_name := "git rev-parse --abbrev-ref HEAD | cut -d . -f 1"


_default:
    @just --list --unsorted --justfile {{justfile()}}

# Build the project
[group("project")]
build: clean _post-process-linkml-schema generate-json-schema generate-documentation generate-example-data validate-example-data
    @echo "Building project…"
    @echo
    cp -r "artifacts/information_models" "artifacts/documentation/modules/schema/attachments/"
    cp -r "artifacts/schemas" "artifacts/documentation/modules/schema/attachments/"
    cp -r "artifacts/examples" "artifacts/documentation/modules/schema/attachments/"
    @echo "… OK."
    @echo
    @echo "All project artifacts have been generated and post-processed, and can found in: artifacts/"
    @echo

# Clean up the output directory
[group("project")]
clean:
    @echo "Cleaning up generated artifacts…"
    @echo
    @if [ -d "artifacts" ]; then \
        rm -rf "artifacts"; \
    fi
    mkdir -p "artifacts"
    @echo "… OK."
    @echo

# Post-process LinkML schema for preview or releasing
_post-process-linkml-schema:
    @echo "Copying source files to artifacts directory…"
    @echo
    mkdir -p "artifacts/information_models"
    cp "information_models/${NBNL_PROJ_FNAME}.schema.linkml.yml" "artifacts/information_models/"
    @echo
    @echo "Setting version in LinkML schema…"
    @echo
    sed -i '/^version: .*$/d' "artifacts/information_models/${NBNL_PROJ_FNAME}.schema.linkml.yml"
    @if [ -z ${VERSION:-} ]; then \
        sed -i "/^name: .*$/a version: {{shell(ref_name)}}" "artifacts/information_models/${NBNL_PROJ_FNAME}.schema.linkml.yml"; \
    else \
        sed -i "/^name: .*$/a version: ${VERSION}" "artifacts/information_models/${NBNL_PROJ_FNAME}.schema.linkml.yml"; \
    fi
    @echo "… OK."
    @echo

# Create new draft
[group("version-control")]
create-draft name:
    @echo "Creating new draft…"
    @echo
    @echo "Creating and tracking new draft branch…"
    @echo
    git checkout -b {{shell(major_branch_name) + "." + name}}
    git commit --allow-empty -m "Start working on draft"
    git push -u origin {{shell(major_branch_name) + "." + name}}
    @echo
    @echo "Creating new draft pull request…"
    @echo
    gh pr create --base {{shell(major_branch_name)}} --draft --editor
    @echo "… OK."
    @echo

# Finish draft
[group("version-control")]
finish-draft:
    @echo "Finishing draft…"
    @echo
    @echo "Marking draft pull request as ready for review…"
    @echo
    gh pr ready
    @echo "… OK."
    @echo

# Preview version
[group("version-control")]
preview-version:
    @echo "Generating preview of version…"
    @echo
    gh workflow run preview_release.yml --ref {{shell(ref_name)}}
    @echo "… OK."
    @echo

# Check if currently checked out branch is a major version branch
_on-major-branch:
    @echo "Checking if currently checked out branch is a major version branch…"
    @echo
    @if [ ! {{shell(ref_name)}} == {{shell(major_branch_name)}}  ]; then \
        echo "Releases can only be done from major branches. Please check out the major branch you wish to release from."; \
        exit 1; \
    fi

# Release new major version
[group("version-control")]
release-major-version: _on-major-branch
    @echo "Releasing new major version…"
    @echo
    gh workflow run release_major_version.yml --ref {{shell(ref_name)}}
    @echo "… OK."
    @echo

# Release new minor version
[group("version-control")]
release-minor-version: _on-major-branch
    @echo "Releasing new minor version…"
    @echo
    gh workflow run release_minor_version.yml --ref {{shell(ref_name)}}
    @echo "… OK."
    @echo

# Release new patch version
[group("version-control")]
release-patch-version: _on-major-branch
    @echo "Releasing new patch version…"
    @echo
    gh workflow run release_patch_version.yml --ref {{shell(ref_name)}}
    @echo "… OK."
    @echo

# Generate documentation
[group("generators")]
generate-documentation: _post-process-linkml-schema
    @echo "Generating documentation…"
    @echo
    cp -r "documentation" "artifacts"
    mkdir -p "artifacts/documentation/modules/schema"
    uv run python -m linkml_asciidoc_generator.main \
        "artifacts/information_models/${NBNL_PROJ_FNAME}.schema.linkml.yml" \
        "artifacts/documentation/modules/schema"
    echo "- modules/schema/nav.adoc" >> artifacts/documentation/antora.yml
    @echo "… OK."
    @echo
    @echo -e "Generated documentation files at: artifacts/documentation"
    @echo

# Generate example data
[group("generators")]
generate-example-data: _post-process-linkml-schema
    @echo "Generating JSON example data…"
    @echo
    mkdir -p "artifacts/examples"
    for example_file in examples/*.yml; do \
        [ -f "$example_file" ] || continue; \
        uv run gen-linkml-profile  \
            convert \
            "$example_file" \
            --out "artifacts/${example_file%.*}.json"; \
    done
    @echo "… OK."
    @echo
    @echo -e "Generated example JSON data at: artifacts/examples"
    @echo

# Generate JSON Schema
[group("generators")]
generate-json-schema: _post-process-linkml-schema
    @echo "Generating JSON Schema…"
    @echo
    mkdir -p "artifacts/schemas/json_schema"
    uv run gen-json-schema \
        --not-closed \
        "artifacts/information_models/${NBNL_PROJ_FNAME}.schema.linkml.yml" \
        > "artifacts/schemas/json_schema/${NBNL_PROJ_FNAME}.json_schema.json"
    @echo "… OK."
    @echo
    @echo "Generated JSON Schema at: artifacts/schemas/json_schema/${NBNL_PROJ_FNAME}.json_schema.json"
    @echo

# Validate example data
[group("validate")]
validate-example-data: generate-json-schema generate-example-data
    @echo "Validating example data against JSON schema…"
    @echo
    for example_file in artifacts/examples/*.json; do \
        [ -f "$example_file" ] || continue; \
        uv run check-jsonschema --schemafile "artifacts/schemas/json_schema/${NBNL_PROJ_FNAME}.json_schema.json" $example_file; \
    done
    @echo "… OK."
    @echo

