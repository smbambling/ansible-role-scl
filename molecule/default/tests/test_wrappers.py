import os

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')


def test_file_scl_wrapper_ruby193(host):
    file = host.file('/usr/local/bin/scl-wrapper-ruby193')
    assert file.exists
    assert file.is_file
    assert 'root' == file.user
    assert 'root' == file.group
    assert '0755' == oct(file.mode)


def test_file_scl_shebang_ruby193(host):
    file = host.file('/usr/local/bin/scl-shebang-ruby193')
    assert file.exists
    assert file.is_file
    assert 'root' == file.user
    assert 'root' == file.group
    assert '0755' == oct(file.mode)


def test_file_scl_wrapper_python33(host):
    file = host.file('/usr/local/bin/scl-wrapper-python33')
    assert file.exists
    assert file.is_file
    assert 'root' == file.user
    assert 'root' == file.group
    assert '0755' == oct(file.mode)


def test_file_scl_shebang_python33(host):
    file = host.file('/usr/local/bin/scl-shebang-python33')
    assert file.exists
    assert file.is_file
    assert 'root' == file.user
    assert 'root' == file.group
    assert '0755' == oct(file.mode)
