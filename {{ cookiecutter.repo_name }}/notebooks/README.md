# Notebooks

## Workflow

1. Create a notebook for task prototyping (EDA, processing, train, etc)
2. Add the following comands in the first cell to autoreload the library.

    ```bash
    %load_ext autoreload
    %autoreload 2
    ```

3. When refactoring your notebook code, move the final functions to the `{{ cookiecutter.package_name }}/` directory.
4. Import the library and the new functions in the notebook.
5. Make changes in the functions from the `{{ cookiecutter.package_name }}` folder and the changes will be reflected thanks to the autoreload command.
6. (Recomended) Separate notebooks into smaller notebooks to make debugging easier.
