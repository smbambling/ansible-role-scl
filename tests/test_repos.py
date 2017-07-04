import testinfra.utils.ansible_runner
testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    '.molecule/ansible_inventory').get_hosts('all')


def test_file_rpm_gpg_key_centos_sig_sclo(host):
    file = host.file('/etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-SCLo')
    assert file.exists
    assert file.is_file
    assert 'root' == file.user
    assert 'root' == file.group
    assert '0644' == oct(file.mode)


def test_yumrepo_sclo_sclo(host):
    output = host.check_output('yum repolist all')
    assert 'centos-sclo-sclo' in output
    assert 'enabled' in output


def test_yumrepo_sclo_rh(host):
    output = host.check_output('yum repolist all')
    assert 'centos-sclo-rh' in output
    assert 'disabled' in output
