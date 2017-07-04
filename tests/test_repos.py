import testinfra.utils.ansible_runner
testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    '.molecule/ansible_inventory').get_hosts('all')


def test_file_rpm_gpg_key_centos_sig_sclo(host):
    file = host.file('/etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-SCLo')
    file.exists
    file.is_file
    'root' == file.user
    'root' == file.group
    '644' == file.mode


def test_yumrepo_sclo(host):
    output = host.check_output('yum repolist all')
    assert 'centos-sclo-sclo' in output
    assert 'enabled' in output

    assert 'centos-sclo-rh' in output
    assert 'enabled' in output
