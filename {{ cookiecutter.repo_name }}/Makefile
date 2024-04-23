TEMPLATE_URL = https://github.com/diegocanales/cookiecutter-mlops

DOCKER_IMAGE = {{ cookiecutter.docker_image }}
CONDA_ENV_NAME = {{ cookiecutter.conda_env }}
PACKAGE_NAME = {{ cookiecutter.package_name }}

CONDA_DIR = $(shell dirname $(shell dirname $(shell which conda)))

define VSCODE_SETTINGS
{\n
\t"python.defaultInterpreterPath": "$(CONDA_DIR)/envs/$(CONDA_ENV_NAME)/bin/python",\n
\t"isort.interpreter": ["$(CONDA_DIR)/envs/$(CONDA_ENV_NAME)/bin/python"],\n
\t"isort.path": ["$(CONDA_DIR)/envs/$(CONDA_ENV_NAME)/bin/isort"],\n
\t"autopep8.interpreter": ["$(CONDA_DIR)/envs/$(CONDA_ENV_NAME)/bin/python"],\n
\t"autopep8.path": ["$(CONDA_DIR)/envs/$(CONDA_ENV_NAME)/bin/autopep8"],\n
\t"autoDocstring.docstringFormat": "google",\n
\t"[python]": {\n
\t\t"editor.defaultFormatter": "ms-python.autopep8",\n
\t},\n
\t"editor.rulers": [80,120],\n
\t"files.associations": {\n
\t\t"*.dvc": "yaml",\n
\t\t"dvc.lock": "yaml"\n
\t},\n
\t"dvc.pythonPath": "$(CONDA_DIR)/envs/$(CONDA_ENV_NAME)/bin/python",\n
}\n
endef

define VSCODE_EXTENSIONS_SETTINGS
{\n
"recommendations": [\n
\t"ms-python.python",\n
\t"ms-toolsai.jupyter",\n
\t"ms-python.vscode-pylance",\n
\t"njpwerner.autodocstring",\n
\t"ms-python.isort",\n
\t"ms-python.autopep8",\n
\t"Iterative.dvc",\n
\t"Gruntfuggly.todo-tree",\n
]\n
}\n
endef

define TAGS_COMMITS_MSG
Format: git commit -m "<TAG>: <COMMIT DESCRIPTION>"\n\n
- feat: a new feature.\n
- fix: a bug fix.\n
- docs: changes to documentation.\n
- data: data transformations or adding (DVCs repos).\n
- style: formatting, missing semi colons, etc; no code change.\n
- refactor: refactoring production code.\n
- test: adding tests, refactoring test; no production code change.\n
- chore: updating build tasks, package manager configs, etc; no production code change.\n
- env: update conda environment, requirements.txt, dockerfile.\n
- clean: remove unused files.\n
endef

PACKAGE_MANAGER = conda
ifeq (,$(shell which mamba))
	PACKAGE_MANAGER = conda
else
	PACKAGE_MANAGER = mamba
endif

##
## Conda environment
##

.PHONY: env
env: ## Create/update the environment.
ifeq (base,$(CONDA_DEFAULT_ENV))
	$(PACKAGE_MANAGER) env update -f environment.yaml --prune
	@echo "!!!RUN THE conda activate COMMAND ABOVE RIGHT NOW!!!"
else
	@echo "Activate the base environment: conda activate base"
endif

.PHONY: env-rm
env-rm: ## Remove the environment.
ifeq (base,$(CONDA_DEFAULT_ENV))
	$(PACKAGE_MANAGER) env remove --name $(CONDA_ENV_NAME)
else
	@echo "Activate the base environment: conda activate base"
endif

.PHONY: env-f
env-f: env-rm env ## Remove and create the environment.

##
## Documentation
##

.PHONY: docs-clean
docs-clean: ## Clean the documentation folders.
	rm -drf docs/html/
	rm -f docs/source/notebooks/*.ipynb
	rm -f docs/source/api/*

.PHONY: docs-nb
docs-nb: ## Add notebooks to documentation folder.
	cp notebooks/**.ipynb docs/source/notebooks/
	sed -i 6q docs/source/notebooks/index.rst
	ls -1 docs/source/notebooks/ | grep .ipynb | sed -e 's/\.ipynb$$//' | sed -e 's/^/   /' >> docs/source/notebooks/index.rst

.PHONY: docs-api
docs-api: ## Creates the package documentation.
	conda run --no-capture-output -n $(CONDA_ENV_NAME) sphinx-apidoc -f --separate --doc-project "Python API Reference" --tocfile "index" -o docs/source/api . setup.py --ext-viewcode --ext-todo --ext-autodoc

.PHONY: docs-build
docs-build: ## Build the HTML documentation files.
	conda run --no-capture-output -n $(CONDA_ENV_NAME) sphinx-build -b html docs/source docs/html/

.PHONY: docs
docs: docs-clean docs-api docs-nb docs-build  ## Create the Sphinx documentation.
	echo "Build finished"

.PHONY: docs-serve
docs-serve: ## Serve the documentation and rebuilt on changes.
	conda run --no-capture-output -n $(CONDA_ENV_NAME) sphinx-autobuild docs/source/ docs/html --watch $(PACKAGE_NAME) --pre-build 'sphinx-apidoc -f --separate --doc-project "Python API Reference" --tocfile "index" -o docs/source/api . setup.py --ext-viewcode --ext-todo  --ext-autodoc --extensions "sphinx.ext.autosummary"'

##
## Docker image
##

.PHONY: image
image: ## Create the docker image.
	@if [ -f conda-linux-64.lock ]; then \
		docker build -f Dockerfile -t $(DOCKER_IMAGE) . ; \
	else \
		echo "Error: conda-linux-64.lock does not exist. Run: make env-locked" ; \
		exit 1 ; \
	fi

.PHONY: image-rm
image-rm: ## Remove the docker image.
	docker rmi $(DOCKER_IMAGE)

##
## Conda lock environment
##

.PHONY: env-lock
env-lock: ## Resolve an environment and create a lock file.
ifeq (base,$(CONDA_DEFAULT_ENV))
	conda-lock --conda $(shell which $(PACKAGE_MANAGER)) \
			   --channel conda-forge \
			   --file environment.yaml \
			   --platform linux-64
	conda-lock render
	@echo "Commit the environment files!!"
	@echo ">> git add conda-lock.yml conda-linux-64.lock conda-win-64.lock conda-osx-64.lock conda-osx-arm64.lock && git commit -m 'env: update locked environment'"
else
	@echo "Activate the base environment: conda activate base"
endif

.PHONY: env-install-repo-pkg
env-install-repo-pkg: ## Install the package from the repository into the project environment.
ifeq (base,$(CONDA_DEFAULT_ENV))
	$(PACKAGE_MANAGER) run --no-capture-output -n $(CONDA_ENV_NAME) pip install -e .["dev"]
else
	@echo "Activate the base environment: conda activate base"
endif

.PHONY: env-fromlock-linux-64
env-fromlock-linux-64: ## Render and create an environment for linux from a lock file.
ifeq (base,$(CONDA_DEFAULT_ENV))
	$(PACKAGE_MANAGER) create --name $(CONDA_ENV_NAME) \
             	              --file conda-linux-64.lock \
             	              --yes
	make env-install-repo-pkg
	@echo "!!!RUN THE conda activate COMMAND ABOVE RIGHT NOW!!!"
else
	@echo "Activate the base environment: conda activate base"
endif

.PHONY: env-fromlock-win-64
env-fromlock-win-64: ## Render and create an environment for win from a lock file.
ifeq (base,$(CONDA_DEFAULT_ENV))
	$(PACKAGE_MANAGER) create --name $(CONDA_ENV_NAME) \
             	              --file conda-win-64.lock \
             	              --yes
	make env-install-repo-pkg
	@echo "!!!RUN THE conda activate COMMAND ABOVE RIGHT NOW!!!"
else
	@echo "Activate the base environment: conda activate base"
endif

.PHONY: env-fromlock-osx-64
env-fromlock-osx-64: ## Render and create an environment for osx intel from a lock file.
ifeq (base,$(CONDA_DEFAULT_ENV))
	$(PACKAGE_MANAGER) create --name $(CONDA_ENV_NAME) \
             	              --file conda-osx-64.lock \
             	              --yes
	make env-install-repo-pkg
	@echo "!!!RUN THE conda activate COMMAND ABOVE RIGHT NOW!!!"
else
	@echo "Activate the base environment: conda activate base"
endif

.PHONY: env-fromlock-osx-arm64
env-fromlock-osx-arm64: ## Render and create an environment for osx arm from a lock file.
ifeq (base,$(CONDA_DEFAULT_ENV))
	$(PACKAGE_MANAGER) create --name $(CONDA_ENV_NAME) \
             	              --file conda-osx-arm64.lock \
             	              --yes
	make env-install-repo-pkg
	@echo "!!!RUN THE conda activate COMMAND ABOVE RIGHT NOW!!!"
else
	@echo "Activate the base environment: conda activate base"
endif

.PHONY: env-locked
env-locked: env-lock env-fromlock-linux-64 env-install-repo-pkg ## Resolve, render and create an environment with conda lock for linux.

.PHONY: env-locked-win-64
env-locked-win-64: env-lock env-fromlock-win-64 env-install-repo-pkg ## Resolve, render and create an environment with conda lock for windows.

.PHONY: env-locked-osx-64
env-locked-osx-64: env-lock env-fromlock-osx-64 env-install-repo-pkg ## Resolve, render and create an environment with conda lock for osx intel.

.PHONY: env-locked-osx-arm64
env-locked-osx-arm64: env-lock env-fromlock-osx-arm64 env-install-repo-pkg ## Resolve, render and create an environment with conda for osx arm.

.PHONY: env-fromlock
env-fromlock: env-fromlock-linux-64 ## Resolve, render and create an environment with conda lock for linux.

##
## Tag Versions
##

.PHONY: update-micro-version
update-micro-version: ## Update micro version, commit and tag the new version
	@if [ -n "$$(git status --porcelain)" ]; then \
		echo "There are changes to commit. Please commit or stash your changes before continuing."; \
		exit 1; \
	else \
		sh ./ci/release/update_tag_version.sh $(PACKAGE_NAME)/__init__.py micro \
		git add $(PACKAGE_NAME)/__init__.py \
		grep -oP '(?<=__version__ = ")[^"]*' $(PACKAGE_NAME)/__init__.py | xargs -I {} git commit -m "feat: new version {}" && git tag {}; \
	fi

.PHONY: update-minor-version
update-minor-version: ## Update minor version, commit and tag the new version	
	@if [ -n "$$(git status --porcelain)" ]; then \
		echo "There are changes to commit. Please commit or stash your changes before continuing."; \
		exit 1; \
	else \
		sh ./ci/release/update_tag_version.sh $(PACKAGE_NAME)/__init__.py minor \
		git add $(PACKAGE_NAME)/__init__.py \
		grep -oP '(?<=__version__ = ")[^"]*' $(PACKAGE_NAME)/__init__.py | xargs -I {} git commit -m "feat: new version {}" && git tag {}; \
	fi

.PHONY: update-major-version
update-major-version: ## Update major version, commit and tag the new version
	@if [ -n "$$(git status --porcelain)" ]; then \
		echo "There are changes to commit. Please commit or stash your changes before continuing."; \
		exit 1; \
	else \
		sh ./ci/release/update_tag_version.sh $(PACKAGE_NAME)/__init__.py major \
		git add $(PACKAGE_NAME)/__init__.py \
		grep -oP '(?<=__version__ = ")[^"]*' $(PACKAGE_NAME)/__init__.py | xargs -I {} git commit -m "feat: new version {}" && git tag {}; \
	fi

##
## Others
##

.PHONY: help
help: ## List the command help.
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/:.*##/ ->/'

.PHONY: clean
clean: env-rm image-rm ## Clean project removing conda env, docker image, etc.
	echo "Cleaning process finished"

export VSCODE_SETTINGS
export VSCODE_EXTENSIONS_SETTINGS
.PHONY: vscode-settings
vscode-settings: ## Create the base VSCode settings file.
	mkdir -p .vscode/
	echo $${VSCODE_SETTINGS} > .vscode/settings.json
	echo $${VSCODE_EXTENSIONS_SETTINGS} > .vscode/extensions.json

export TAGS_COMMITS_MSG
.PHONY: tags-commits
tags-commits: ## Tags commits reminder.
	@echo $${TAGS_COMMITS_MSG}

.PHONY: show-version
show-version: ## Show the current package version.
	@echo "Current version: $$(grep -oP '(?<=__version__ = ")[^"]*' $(PACKAGE_NAME)/__init__.py)"

.PHONY: link-template
link-template: ## User cruft to link the cookiecutter to the project.
	$(PACKAGE_MANAGER) run --no-capture-output -n base cruft link $(TEMPLATE_URL)
