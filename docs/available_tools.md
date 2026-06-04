Here is a list of available tools that can be installed with self contained variables:

## forgejo-cli

[Forgejo repository](https://codeberg.org/forgejo-contrib/forgejo-cli)

```
- name: Install forgejo-cli
  hosts: all
  become: true
  tasks:
    - name: "Install forgejo-cli"
      ansible.builtin.include_role:
        name: sgaunet.forgejo_role_installer
        vars_from: forgejo-cli.yml
```
