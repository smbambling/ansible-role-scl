#!/usr/bin/env bash

cmd_list=('ruby' 'bundle' 'virtualenv')

# Function to check if referenced command exists
cmd_exists() {
  if [ $# -eq 0 ]; then
    echo 'WARNING: No command argument was passed to verify exists'
  fi

  cmd=${1}
  hash "${cmd}" >&/dev/null # portable 'which'
  rc=$?
  if [ "${rc}" != "0" ]; then
    echo "${cmd} Unable to find bundle in your PATH"
    return 1
  fi
}

# Verify that referenced commands exist on the system
for cmd in ${cmd_list[@]}; do
  cmd_exists "$cmd"
done

echo " ------------------------------------------------------------------"
echo "                                                                   "
echo " You should be running this with "source ./setup.sh"               "
echo " Running this directly like:                                       "
echo " * ./setup.sh                                                      "
echo " * bash ./setup.sh                                                 "
echo " Will fail to set certain environment variables that may bite you. "
echo "                                                                   "
echo "                                                                   "
echo " Waiting 5 seconds for you make sure you have ran this correctly   "
echo " Cntrl-C to bail out...                                            "
echo "                                                                   "
echo " ------------------------------------------------------------------"

sleep 5 # Waits 5 seconds

# Use existing Python VirtualENV if avilable
virtualenv_path='.venv'
if [ ! -d "${virtualenv_path}" ]; then
    echo "Failed to find a virtualenv, creating one."
    virtualenv --no-site-packages ${virtualenv_path}
else
    echo "Found existing virtualenv, using that instead."
fi

# shellcheck disable=SC1091
# shellcheck source=./venv/bin/activate
source "${virtualenv_path}/bin/activate"
pip install -U pip
pip install -r requirements.txt --upgrade

bundle install --path .vendor/bundle

echo " ----------------------------------------------------------------------------"
echo ""
echo " You are now within a python virtualenv at ${virtualenv_path} "
echo " This means that all python packages installed will not affect your system. "
echo " To return _back_ to system python, run deactivate in your shell. "
echo ""
echo " To test your changes run bundle exec molecule test in your shell. "
echo " ----------------------------------------------------------------------------"
