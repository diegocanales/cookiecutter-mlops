"""Generate the code reference pages and navigation."""

from pathlib import Path
from {{ cookiecutter.package_name }} import paths

import mkdocs_gen_files

nav = mkdocs_gen_files.Nav()

root = paths.project_dir()

package_path = root / "{{ cookiecutter.package_name }}"

file_list = sorted(package_path.rglob("*.py"))

for path in file_list:
    module_path = path.relative_to(root).with_suffix("")
    doc_path = path.relative_to(root).with_suffix(".md")
    full_doc_path = Path("reference", doc_path)

    parts = tuple(module_path.parts)

    if parts[-1] == "__init__":
        parts = parts[:-1]
        doc_path = doc_path.with_name("index.md")
        full_doc_path = full_doc_path.with_name("index.md")
    elif parts[-1] == "__main__":
        continue

    nav[parts] = doc_path.as_posix()

    with mkdocs_gen_files.open(full_doc_path, "w") as fd:
        ident = ".".join(parts)
        fd.write(f"::: {ident}")

with mkdocs_gen_files.open("reference/SUMMARY.md", "w") as nav_file:
    nav_file.writelines(nav.build_literate_nav())
