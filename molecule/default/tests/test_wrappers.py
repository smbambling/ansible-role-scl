import os

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')


def test_file_scl_wrapper_rh_ruby23(host):
    file = host.file('/usr/local/bin/scl-wrapper-rh-ruby23')
    assert file.exists
    assert file.is_file
    assert 'root' == file.user
    assert 'root' == file.group
    assert '0755' == oct(file.mode)


def test_file_scl_shebang_rh_ruby23(host):
    file = host.file('/usr/local/bin/scl-shebang-rh-ruby23')
    assert file.exists
    assert file.is_file
    assert 'root' == file.user
    assert 'root' == file.group
    assert '0755' == oct(file.mode)


def test_file_scl_wrapper_rh_python35(host):
    file = host.file('/usr/local/bin/scl-wrapper-rh-python35')
    assert file.exists
    assert file.is_file
    assert 'root' == file.user
    assert 'root' == file.group
    assert '0755' == oct(file.mode)


def test_file_scl_shebang_rh_python35(host):
    file = host.file('/usr/local/bin/scl-shebang-rh-python35')
    assert file.exists
    assert file.is_file
    assert 'root' == file.user
    assert 'root' == file.group
    assert '0755' == oct(file.mode)
