# Ansible Role: forgejo_role_installer

[![GitHub release](https://img.shields.io/github/release/sgaunet/ansible-role-forgejo-release-installer.svg)](https://github.com/sgaunet/ansible-role-forgejo-release-installer/releases/latest)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

An Ansible Role that installs releases from Forgejo (Codeberg by default). It has been created to install binaries from Forgejo releases. **It is designed to setup only simple binary (coded with Go or rust) and not to install complex software.**

You can use it to setup tools like:

* forgejo-cli
* ...

## Requirements

None.

## Role Variables

Available variables are listed below, only `forgejo_role_installer_url`, `forgejo_role_installer_tmp_directory` and `forgejo_role_installer_binary_path` are set by default:

    forgejo_role_installer_version: "latest"   # latest is a special value to get the latest release (forgejo api will be used to get the latest release)
    forgejo_role_installer_url: "https://codeberg.org"  # forgejo instance URL (defaults to codeberg.org)
    forgejo_role_installer_os: "linux"         # os name, used to download the release
    forgejo_role_installer_arch: "x86_64"      # architecture, used to download the release
    forgejo_role_installer_repository: "forgejo-contrib/forgejo-cli"
    # release url, used to download the release, be careful version_to_install is a special value that will be replaced by the version to install
    forgejo_role_installer_release: "{{ forgejo_role_installer_url }}/{{ forgejo_role_installer_repository }}/releases/download/v{{ version_to_install }}/forgejo-cli-{{ forgejo_role_installer_arch }}-{{ forgejo_role_installer_os }}.tar.gz"
    forgejo_role_installer_release_is_archive: true  # if true, the release is an archive, it will be downloaded and extracted
    forgejo_role_installer_binary_name: "forgejo-cli"     # binary name to install
    forgejo_role_installer_cmd_to_get_version: "forgejo-cli --version"  # command to get the version of the installed binary
    forgejo_role_installer_tmp_directory: "{{ lookup('env', 'TMPDIR') | default('/tmp', true) }}" # temporary directory to download the release
    forgejo_role_installer_binary_path: "/usr/local/bin/{{ forgejo_role_installer_binary_name }}"  # directory where the binary will be installed

If you need authenticated access to the Forgejo API (e.g. for self-hosted private instances), set the `FORGEJO_TOKEN` environment variable before running the role.

## Dependencies

None.

## Example Playbook

```yaml
- hosts: all
  roles:
    - role: sgaunet.forgejo_role_installer
      vars:
        forgejo_role_installer_version: "0.5.0"
        forgejo_role_installer_url: "https://codeberg.org"
        forgejo_role_installer_os: "linux"
        forgejo_role_installer_arch: "x86_64"
        forgejo_role_installer_repository: "forgejo-contrib/forgejo-cli"
        forgejo_role_installer_release: "{{ forgejo_role_installer_url }}/{{ forgejo_role_installer_repository }}/releases/download/v{{ version_to_install }}/forgejo-cli-{{ forgejo_role_installer_arch }}-{{ forgejo_role_installer_os }}.tar.gz"
        forgejo_role_installer_release_is_archive: true
        forgejo_role_installer_binary_name: "forgejo-cli"
        forgejo_role_installer_cmd_to_get_version: "forgejo-cli --version | awk '{print $2}'"
```

The role contains also variables to install miscellaneous tools. [See the list of available tools in this documentation.](docs/available_tools.md)

## Add a new tool

* Write the vars to setup the tool in `vars/toolname.yml`
* Generate the molecule test with `./gen-molecule-files.sh`
* Generate the documentation with `./gen-docs.sh`
* Generate the CI with `./gen-ci.sh`
* Generate the taskfile to test tool with `./gen-Taskfile-tests.sh`
* Test the tool with `task -t Taskfile-tests.yml test-toolname`

## Development environment

This project uses [mise](https://mise.jdx.dev/) to manage dev tools.

```bash
# install task and python defined in mise.toml
mise install
# install ansible/molecule into the project-local .venv
mise run install-deps
```

## Tests

All tools are tested with molecule. You can run the tests with the following command:

```bash
task -t Taskfile-tests.yml test-<tool-name>
```

## License

MIT
