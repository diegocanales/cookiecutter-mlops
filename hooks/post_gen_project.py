import shutil

def remove_folder(dir):
    try:
        shutil.rmtree(dir)
    except OSError as e:
        print("Error: %s - %s." % (e.filename, e.strerror))

if __name__ == "__main__":
    if "{{ cookiecutter.ml_project }}" == "no":
        #remove_folder(".dvc/")
        remove_folder("models/")
        remove_folder("reports/")
        remove_folder("{{ cookiecutter.package_name}}/data")
        remove_folder("{{ cookiecutter.package_name}}/models")
        remove_folder("{{ cookiecutter.package_name}}/features")
        remove_folder("{{ cookiecutter.package_name}}/visualization")
