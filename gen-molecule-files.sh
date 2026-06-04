#!/usr/bin/env bash

dir_name=$(dirname "$0")
cd "$dir_name" || exit 1

if [ ! -d docs ]; then
  echo "docs directory not found"
  exit 1
fi

find vars -name '*.yml' | sort | grep -vE 'vagrant' | while read -r doc
do
  f=$(basename "$doc")
  bin_name=$(echo "$f" | cut -d'.' -f1)
  echo "Generating molecule files for $f"

  test -d "molecule/${bin_name}" || mkdir -p "molecule/${bin_name}"
  output_file="molecule/${bin_name}/converge.yml"
  cp molecule/default/molecule.yml "molecule/${bin_name}/molecule.yml"

  (
    echo "---"
    echo "- name: Converge"
    echo "  hosts: all"
    echo "  become: true"
    echo "  tasks:"
    echo "    - name: \"Install ${bin_name}\""
    echo "      ansible.builtin.include_role:"
    echo "        name: \"sgaunet.forgejo_role_installer\""
    echo "        vars_from: \"$f\""
  ) > "$output_file"


  output_file="molecule/${bin_name}/verify.yml"
  (
    echo "---"
    echo ""
    echo "- name: Verify"
    echo "  hosts: all"
    echo "  gather_facts: true"
    echo "  tasks:"
    echo "    - name: Include default vars"
    echo "      ansible.builtin.include_vars:"
    echo "        file: '{{ lookup(\"env\", \"MOLECULE_PROJECT_DIRECTORY\") }}/vars/$f'"
    echo ""
    echo "    - name: Stat forgejo_role_installer {{ forgejo_role_installer_binary_name }}"
    echo "      ansible.builtin.stat:"
    echo "        path: \"{{ forgejo_role_installer_binary_path }}\""
    echo "      register: forgejo_role_installer_present"
    echo "    - name: Check binary is present {{ forgejo_role_installer_binary_name }}"
    echo "      ansible.builtin.assert:"
    echo "        that:"
    echo "          - forgejo_role_installer_present.stat.exists"
    echo "        fail_msg: \"forgejo_role_installer not setup\""
    echo "        success_msg: \"forgejo_role_installer is setup\""
  ) > "$output_file"

done
