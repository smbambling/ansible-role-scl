SCL (Software Collections Linux)
===
[![Ansible Galaxy](https://img.shields.io/badge/ansible--galaxy-smbambling.scl-blue.svg)](https://galaxy.ansible.com/smbambling/scl/)
[![Build Status](https://travis-ci.org/smbambling/ansible-role-scl.svg?branch=master)](https://travis-ci.org/smbambling/ansible-role-scl)
[![CodeClimate](https://codeclimate.com/github/smbambling/ansible-role-scl/badges/gpa.svg)](https://codeclimate.com/github/smbambling/ansible-role-scl)
[![IssueCount](https://codeclimate.com/github/smbambling/ansible-role-scl/badges/issue_count.svg)](https://codeclimate.com/github/smbambling/ansible-role-scl)

Table of Contents
-----------------
1. [Overview](#overview)
1. [Requirements](#requirements)
1. [Role Variables](#role-variables)
1. [Dependencies](#dependencies)
1. [Examples](#example-playbooks)
1. [Development / Contributing](#development--contributing)
1. [License](#license)
1. [Author Information](#author-information)

Overview
--------
This role installs and manages the SCL Software Collections repository, packages/collections for Fedora, CentOS, and Scientific Linux. Addtionally it can create wrapper wrapper scripts to make calling the SCL collections binaries

Requirements
------------
This role requires Ansible 2.1 or higher and platform requirements are listed in the [metadata](meta/main.yml) file.

Role Variables
--------------
The variables that can be passed to this role and a brief description about them are as follows. (For all variables, take a look at defaults/main.yml)

```yaml
# Toggle to enable creation/management
# of the SCL YUM repositories
scl_manage_repo: yes

# The Base URL location of the SCL sclo repository
scl_repo_sclo_sclo_baseurl:
  "http://mirror.centos.org/centos/{{ ansible_distribution_major_version }}/sclo/$basearch/sclo/"

# The Base URL location of the SCL rh repository
scl_repo_sclo_rh_baseurl:
  "http://mirror.centos.org/centos/{{ ansible_distribution_major_version }}/sclo/$basearch/rh"
  
# Array of wrapper scripts to create for SCL installed binaries
scl_wrappers:
  - {collection: 'ruby193', command: 'ruby'}
  - {collection: 'python33', command: 'python'}

# Array of Collections/Packages to install via SCL
scl_packages:
  - {name: 'ruby193', state: 'latest'}
  - {name: 'python33', state: 'latest'}

# Array (of hashes) of Ruby Gems to manage
scl_ruby_gems:
  - {
    ruby_ver: 'ruby193',
    name: 'fast_github',
    state: 'present',
    }

# Array (of hashes) of Python PIPs to manage
scl_python_pips:
  - {
    python_ver: 'python33',
    name: 'snakeoil',
    state: 'present',
    }
```

Dependencies
------------
None

Example Playbook(s)
-------------------
1. Management of the SCL YUM repositories
##### Disable repository management
  ```yaml
  roles:
    - role: ansible-role-scl
      scl_manage_repo: false
  ```
##### Modify YUM repository base URLs

  ```yaml
  roles:
    - role: ansible-role-scl
      scl_repo_sclo_sclo_baseurl:
        "http://mylocalmirror.local/centos/6/sclo/$basearch/sclo/"
  ```
1. Install wrapper scripts for SCL installed binaries

   The variable `scl_wrappers` generates wrapper/shebang scripts in `/usr/local/bin`:
   
   Each entry requires a hash with:
     - `collection`(required)
     - `command`(optional)
   
   > If the command key is omited an scl **wrapper** script will be created
   
   `scl-wrappper-[collection name]` that can be used to call any command with with the collection sourced via SCL. For example listsing all the PIPs installed under SCL python33
   
   ```shell
   scl-wrapper-python33 pip list
   ```
   
   > If the command key is set an scl **shebang** script will be created that points to the command/binary specified.
   
   `scl-shebang-[collection name]` that can be used for inclusion in scripts. For example put the following in the wrapper line of a script written in ruby 2.2
   
   ```shell
   #!/usr/local/bin/scl-shebang-rh-ruby22
   ```
   
   The script will properly source all necessary environment variables for the desired ruby environment without having to declare `scl enable rh-ruby22 -- ruby my_script.rb` each time `my_script.rb` is run

   ```yaml
   roles:
    - role: ansible-role-scl
      scl_wrappers:
        - {collection: 'rh-ruby22', command: 'ruby'}
        - {collection: 'python33', command: 'python'}
    ```

1. Install SCL collections/packages via [yum module](http://docs.ansible.com/ansible/yum_module.html)

   > Pre-compiled Gems/PIPs packages (RPMs) can be installed via the scl_packages variable.
   
   Each entry requires a hash with: 
     - `name`(required)
     - `state`(optional)[defaults: present]
   
   ```yaml
   roles:
    - role: ansible-role-scl
      scl_packages:
        - {name: 'rh-ruby22', state: 'latest'}
        - {name: 'python33', state: 'latest'}
   ```
1. Manage SCL Python PIPs via [pip module](http://docs.ansible.com/ansible/pip_module.html)

   Each entry requires a hash with:
     - `ruby_ver`(required)
     - `name`(required)
     - `state`(optional)[defaults: present]
     - `version`(optional)[defaults: omit]
    
   ```yaml
   roles:
    - role: ansible-role-scl
      scl_python_pips
        - {
          python_ver: 'python33',
          name: 'snakeoil',
          state: 'present',
        }
   ```
1. Manage SCL Ruby GEMs via [gem module](http://docs.ansible.com/ansible/gem_module.html)

   Each entry requires a hash with:
     - `python_ver`(required)
     - `name`(required)
     - `state`(optional)[defaults: present]
     - `version`(optional)[defaults: omit]
     - `source`(optoinal)[defaults: omit]
     - `pre_release`(optional)[defaults: no]
    
   ```yaml
   roles:
    - role: ansible-role-scl
      scl_ruby_gems
        - {
          ruby_ver: 'ruby193',
          name: 'fast_github',
          state: 'present',
        }
   ```
1. AIO Example

   ```yaml
   - role: ansible-role-scl
      scl_wrappers:
        - {collection: 'ruby193', command: 'ruby'}
        - {collection: 'python33', command: 'python'}
      scl_packages:
        - {name: 'ruby193', state: 'latest'}
        - {name: 'python33', state: 'latest'}
      scl_ruby_gems:
        - {
          ruby_ver: 'ruby193',
          name: 'fast_github',
          state: 'present',
        }
      scl_python_pips:
        - {
          python_ver: 'python33',
          name: 'snakeoil',
          state: 'present',
        }
   ```
1. Ansible `include_role` notation(s)

   Examples of including roles and tasks from the SCL Role using the new include_role module in Ansible 2.2+
   
   These examples give Ansible a more modular, class like feel which allows portions of a role to be included inside of additional playbooks with less duplication

   ```yaml
   tasks:
     - name: "Add wrapper script for rh-ruby22"
       include_role:
         name: ansible-role-scl
         tasks_from: wrappers
       vars:
         scl_wrappers:
           - {collection: 'rh-ruby22', command: 'ruby'}
   
     - name: "Install rh-ruby22 from SCL"
       include_role:
         name: ansible-role-scl
         tasks_from: packages
       vars:
         scl_packages:
           - {name: 'rh-ruby22'}
   
     - name: "Install gems for rh-ruby22"
       include_role:
         name: ansible-role-scl
         tasks_from: gems
       vars:
         scl_ruby_gems:
           - {
             ruby_ver: 'rh-ruby22',
             name: 'fast_github',
             state: 'present',
           }
   ```

Development / Contributing
--------------------------
See [Contributing](.github/CONTRIBUTING.md).

Note: This role is currently only tested against the following OS and Ansible versions:

#### Operating Systems / version
- CentOS 6.x
- CentOS 7.x

#### Ansible Versions
- 2.1.0
- 2.2.2
- latest

License
-------
Licensed under the MIT License. See the [LICENSE](./LICENSE) file for details.

Author Information
------------------
- Steven Bambling
