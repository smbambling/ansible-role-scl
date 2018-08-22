import os

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')


def test_gem_rh_ruby23_fast_github(host):
    output = host.check_output('scl enable rh-ruby23 -- gem list')
    assert 'fast_github' in output
