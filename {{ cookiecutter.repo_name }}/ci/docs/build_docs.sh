#!/bin/sh

if [ "$#" -ne 1 ]; then
    echo "Error: Missing arguments. Usage: ./build_docs.sh OUTPUT_DIR"
    exit 1
fi

OUTPUT_DIR=$1

sphinx-apidoc -f --separate --doc-project "Python API Reference" --tocfile "index" -o docs/source/api . setup.py --ext-viewcode --ext-todo --ext-autodoc

cp notebooks/**.ipynb docs/source/notebooks/
sed -i 6q docs/source/notebooks/index.rst
ls -1 docs/source/notebooks/ | grep .ipynb | sed -e 's/\.ipynb$$//' | sed -e 's/^/   /' >> docs/source/notebooks/index.rst

sphinx-build -b html docs/source ${OUTPUT_DIR}
