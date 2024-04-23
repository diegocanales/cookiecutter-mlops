import typer
# from {{ cookiecutter.package_name }}.my_module.my_submodule import my_cli_function
# from {{ cookiecutter.package_name }}.my_module2.my_submodule2 import my_cli_function2

app = typer.Typer()

# Add your commands here!
# app.command()(my_cli_function)
# app.command()(my_cli_function2)

def main():
    app()

if __name__ == "__main__":
    app()