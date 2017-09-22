import testinfra.utils.ansible_runner
testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    '.molecule/ansible_inventory').get_hosts('all')


def test_pip_python33_travis(host):
    output = host.check_output('scl enable python33 -- pip list')
    assert 'travis' in output
