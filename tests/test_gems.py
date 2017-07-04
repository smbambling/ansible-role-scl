import testinfra.utils.ansible_runner
testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    '.molecule/ansible_inventory').get_hosts('all')


def test_gem_ruby193_fast_github(host):
    output = host.check_output('scl enable ruby193 -- gem list')
    assert 'fast_github' in output
