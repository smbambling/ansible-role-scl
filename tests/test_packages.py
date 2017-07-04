import testinfra.utils.ansible_runner
testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    '.molecule/ansible_inventory').get_hosts('all')


def test_ruby193_is_installed(host):
    ruby193 = host.package('ruby193')
    assert ruby193.is_installed


def test_python33_is_installed(host):
    python33 = host.package('python33')
    assert python33.is_installed
