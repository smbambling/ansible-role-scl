import os

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')


def test_rh_ruby23_is_installed(host):
    rh_ruby23 = host.package('rh-ruby23')
    assert rh_ruby23.is_installed


def test_rh_python35_is_installed(host):
    rh_python35 = host.package('rh-python35')
    assert rh_python35.is_installed
