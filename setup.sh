#!/usr/bin/env bash

cmd_list=(
  "virtualenv-2.7 virtualenv-2.5 virtualenv"
  "docker docker.io"
)

# Function to check if referenced command exists
cmd_exists() {
  if [ $# -eq 0 ]; then
    echo 'WARNING: No command argument was passed to verify exists'
  fi

  #cmds=($(echo "${1}"))
  cmds=($(printf '%s' "${1}"))
  fail_counter=0
  for cmd in "${cmds[@]}"; do
    command -v "${cmd}" >&/dev/null # portable 'which'
    rc=$?
    if [ "${rc}" != "0" ]; then
      fail_counter=$((fail_counter+1))
    fi
  done

  if [ "${fail_counter}" -ge "${#cmds[@]}" ]; then
    echo "Unable to find one of the required commands [${cmds[*]}] in your PATH"
    return 1
  fi
}

# Verify that referenced commands exist on the system
for cmd in "${cmd_list[@]}"; do
  cmd_exists "${cmd[@]}"
  # shellcheck disable=SC2181
  if [ $? -ne 0 ]; then
    return $?
  fi
done

# Test whether or not we can talk to the docker daemon
if [[ -z $ANSIBLE_SETUP_SKIP_DOCKER ]]; then
   docker ps > /dev/null
   rc=$?
   if [[ $rc -gt 0 ]]; then
       echo "One of the following cases may have happened:"
       echo "* You are missing docker."
       echo "* Your user is not part of the docker group."
       echo "* The docker daemon is not running."
       return $rc
   fi
fi

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

for n in {5..1}; do
  printf "\r%s " $n
  sleep 1
done
echo -e "\n"

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

echo " ----------------------------------------------------------------------------"
echo ""
echo " You are now within a python virtualenv at ${virtualenv_path} "
echo " This means that all python packages installed will not affect your system. "
echo " To return _back_ to system python, run deactivate in your shell. "
echo ""
echo " To test your changes run 'molecule test' in your shell. "
echo " ----------------------------------------------------------------------------"
