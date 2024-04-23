from pathlib import Path
from setuptools import find_namespace_packages, setup
from {{ cookiecutter.package_name }} import __version__


BASE_DIR = Path(__file__).parent
long_description = (BASE_DIR / "README.md").read_text()

# Load packages from requirements.txt
with open(Path(BASE_DIR, "requirements.txt")) as file:
    required_packages = [ln.strip() for ln in file.readlines() if not ln.startswith("#")]


test_packages = [
    "pytest"
]

dev_packages = [
    "pylama",
    "isort",
    "autopep8",
    "ipykernel",
    "ipywidgets>=7.0,<8.0",
    "python-dotenv"
]

docs_packages = [
    "sphinx",
    "sphinx-rtd-theme",
    "rst-to-myst[sphinx]",
    "myst-parser",
    "sphinx-autobuild",
    "nbsphinx",
    "ipykernel"
]


setup(
    name='{{ cookiecutter.package_name }}',
    packages=find_namespace_packages(),
    version=__version__,
    description='{{ cookiecutter.description }}',
    long_description=long_description,
    long_description_content_type='text/markdown',
    author="{{ cookiecutter.author_name }}",
    python_requires=">=3.8",
    entry_points={
        'console_scripts': ['{{ cookiecutter.package_name }}={{ cookiecutter.package_name }}.cli:main'],
    },
    install_requires=[required_packages],
    extras_require={
        "test": test_packages,
        "dev": test_packages + dev_packages + docs_packages,
        "docs": docs_packages,
    }
)
