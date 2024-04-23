import re
import sys


def check_regex(string, regex, error_msg):
    if not re.match(regex, string):
        print(error_msg)
        # exits with status 1 to indicate failure
        sys.exit(1)

repo_name = '{{ cookiecutter.repo_name }}'
REPO_NAME_REGEX = r'^[\-_a-zA-Z][\-_a-zA-Z0-9]+$'
error_msg = f'ERROR: {repo_name} is not a valid repo_name!'
check_regex(repo_name, REPO_NAME_REGEX, error_msg)

package_name = '{{ cookiecutter.package_name }}'
PACKAGE_NAME_REGEX = r'^[\-_a-zA-Z][\-_a-zA-Z0-9]+$'
error_msg = f'ERROR: {package_name} is not a valid package_name!'
check_regex(package_name, PACKAGE_NAME_REGEX, error_msg)
