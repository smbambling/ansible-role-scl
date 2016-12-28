SCL (Software Collections Linux)
===
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
This role installs and manages the SCL Software Collections repository, packages/collections for Fedora, CentOS, and Scientific Linux. Addtionally it can create shebang wrapper scripts to make calling the SCL collections binaries

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
  
# Array of Shebang scripts to create for SCL installed binaries
scl_shebangs:
  - ruby193
  - python33

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
1. Install Shebang scripts for SCL installed binaries
1. Install SCL collections/packages
1. Manage SCL Ruby GEMs
1. Manage SCL Python PIPs
1. AIO Example
1. Ansible `include_role` notation(s)

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
