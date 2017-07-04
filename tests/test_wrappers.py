import testinfra.utils.ansible_runner
testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    '.molecule/ansible_inventory').get_hosts('all')


def test_file_scl_wrapper_ruby193(host):
    file = host.file('/usr/local/bin/scl-wrapper-ruby193')
    file.exists
    file.is_file
    'root' == file.user
    'root' == file.group
    '755' == file.mode


def test_file_scl_shebang_ruby193(host):
    file = host.file('/usr/local/bin/scl-shebang-ruby193')
    file.exists
    file.is_file
    'root' == file.user
    'root' == file.group
    '755' == file.mode


def test_file_scl_wrapper_python33(host):
    file = host.file('/usr/local/bin/scl-wrapper-python33')
    file.exists
    file.is_file
    'root' == file.user
    'root' == file.group
    '755' == file.mode


def test_file_scl_shebang_python33(host):
    file = host.file('/usr/local/bin/scl-shebang-python33')
    file.exists
    file.is_file
    'root' == file.user
    'root' == file.group
    '755' == file.mode
