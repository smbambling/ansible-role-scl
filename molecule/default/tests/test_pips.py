import os

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')


def test_pip_rh_python35_travis(host):
    output = host.check_output('scl enable rh-python35 -- pip list')
    assert 'travis' in output
