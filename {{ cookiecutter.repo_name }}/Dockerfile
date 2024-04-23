FROM mambaorg/micromamba:1.4.9-alpine as build

WORKDIR /project

COPY --chown=$MAMBA_USER:$MAMBA_USER conda-linux-64.lock conda-linux-64.lock

COPY --chown=$MAMBA_USER:$MAMBA_USER {{ cookiecutter.package_name }} {{ cookiecutter.package_name }}
COPY --chown=$MAMBA_USER:$MAMBA_USER requirements.txt requirements.txt
COPY --chown=$MAMBA_USER:$MAMBA_USER MANIFEST.in MANIFEST.in
COPY --chown=$MAMBA_USER:$MAMBA_USER setup.py setup.py
COPY --chown=$MAMBA_USER:$MAMBA_USER README.md README.md

RUN micromamba install -y -n base -f /project/conda-linux-64.lock && \
    micromamba clean --all --yes
RUN micromamba run -n base pip install .

FROM mambaorg/micromamba:1.4.9-alpine as final

COPY --from=build /opt/conda /opt/conda
COPY --chown=$MAMBA_USER:$MAMBA_USER .here /project/.here

WORKDIR /project

ENTRYPOINT ["/usr/local/bin/_entrypoint.sh", "{{ cookiecutter.package_name }}"]
