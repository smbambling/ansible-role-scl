#!/usr/bin/env bash

##########################################
#########    Variables    ################
##########################################

ansible_venv_dir=".venv"

cmd_list=(
  "python3 python3.8 python3.7 python3.6"
  "docker"
)

##########################################
#########    Functions    ################
##########################################

function deactivate_py() {
  echo -e "\nDeactivating Python Virtual Envrionment"
  deactivate
}

##########################################
#########   Warning Tasks  ###############
##########################################

if [[ -z $ANSIBLE_SETUP_SKIP_WARNING ]]; then
  cat <<EOF
---------------------------------------------------------------------
|                                                                   |
| You should be running this with "source ./setup.sh"               |
| Running this directly like:                                       |
| * ./setup.sh                                                      |
| * bash ./setup.sh                                                 |
| Will fail to set certain environment variables that may bite you. |
|                                                                   |
|                                                                   |
| Waiting 5 seconds for you make sure you have ran this correctly   |
| Cntrl-C to bail out...                                            |
|                                                                   |
| To supress this warning in the future, put the following in your  |
| shell's rc file:                                                  |
| export ANSIBLE_SETUP_SKIP_WARNING=1                               |
|                                                                   |
| To skip the check to verify that docker is installed and running, |
| put the following in your shell's rc file (similarly for Vagrant  |
| and Ruby:                                                         |
| export ANSIBLE_SETUP_SKIP_DOCKER=1                                |
|                                                                   |
| Docker won't automatically clean up after itself. If you want to  |
| have this happen, simply put the following in your shell's rc:    |
| export ANSIBLE_SETUP_DOCKER_CLEANUP=1                             |
|                                                                   |
---------------------------------------------------------------------
EOF
  for n in {5..1}; do
    printf "\r%s " $n
    sleep 1
  done
  echo
fi

##########################################
#########   Pre-Check Tasks  #############
##########################################

# Function to check if referenced command exists
cmd_exists() {
  if [ $# -eq 0 ]; then
    echo 'WARNING: No command argument was passed to verify exists'
  fi
  # shellcheck disable=SC2207
  cmds=($(printf '%s' "${1}"))
  fail_counter=0
  for cmd in "${cmds[@]}"; do
    if ! command -v "${cmd}" >&/dev/null; then  # portable 'which'
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
  if ! cmd_exists "${cmd[@]}"; then
    return 1
  fi
done

# Set Python3 Interpreter
for cmd in "${cmd_list[@]}"; do
  if [[ "${cmd[*]}" =~ "python" ]]; then
    for python in $(printf '%s' "${cmd[@]}"); do
      pythons+=("${python}")
    done
    for python in "${pythons[@]}"; do
      if command -v "${python}" > /dev/null 2>&1; then
        python3="${python}"
        break
      fi
    done
  fi
done

##########################################
#########   Docker Tasks  ################
##########################################

if [[ -z $ANSIBLE_SETUP_SKIP_DOCKER ]]; then
  echo -e "\n#################"
  echo "# Docker Tasks  #"
  echo "#################"
  # Verify nameserver entries for Docker resolution
  total_nameservers=$(grep -c 'nameserver' /etc/resolv.conf || :)
  total_local_nameservers=$(grep -c 'nameserver 127' /etc/resolv.conf || :)
  if [[ $total_local_nameservers -gt 0 && $total_nameservers -eq 1 ]]; then
      echo "Warning!"
      echo "It looks like you only have a loopback nameserver defined in /etc/resolv.conf"
      echo "DNS resolution inside Docker containers will fail."
      echo "You will need to set correct resolvers."
      echo "This is usually caused by NetworkManager using dnsmasq to handle"
      echo "setting up your resolvers."
      echo
      read -rp "Press any key to continue."
  fi

  # Verify that Docker is running and user has access
  echo -en "\nVerify that Docker is running and user has access..."
  if ! output=$(docker ps -q); then
    echo "FAILED"
    echo "One of the following cases may have happened:"
    echo "* You are missing docker."
    echo "* Your user is not part of the docker group."
    echo "* The docker daemon is not running."
    return 1
  else
    echo "Complete"
  fi

  if [[ -n $ANSIBLE_SETUP_DOCKER_CLEANUP ]]; then
    echo -en "Pruning unused Docker objects..."
    if ! output=$(docker system prune -f --volumes 2>&1); then
      echo "FAILED"
      echo "${output}"
      return 1
    else
      echo "Complete"
    fi
  fi
fi

##########################################
#########   Python Tasks  ################
##########################################

if [ ! -d "${ansible_venv_dir}" ]; then
  if ! ${python3} -m venv "${ansible_venv_dir}"; then
    echo "Failed to create Python3 virtual environment"
    return 1
  fi
fi

# shellcheck source=/dev/null
if ! . "${ansible_venv_dir}"/bin/activate; then
  echo "Failed to activate Python3 virtual environment"
  return 1
fi

echo -e "\n##################################"
echo "# Installing Python Requirements #"
echo "##################################"
echo -en "\nUpgrading pip..."
if ! output=$(${python3} -m pip install --upgrade pip 2>&1); then
  echo "FAILED"
  echo "${output}"
  deactivate_py
  return 1
else
  echo "Complete"
fi

echo -en "\nInstalling/Upgrading setuptools..."
if ! output=$(${python3} -m pip install --upgrade setuptools 2>&1); then
  echo "FAILED"
  echo "${output}"
  deactivate_py
  return 1
else
  echo "Complete"
fi

echo -en "\nInstalling Python modules from requirements.txt..."
if ! output=$(${python3} -m pip install -r requirements.txt 2>&1); then
  echo "FAILED"
  echo "${output}"
  deactivate_py
  return 1
else
  echo "Complete"
  echo "${output}"
fi

echo -e "\n\n"
cat <<EOF
------------------------------------------------------------------------------
|                                                                            |
|  You are now within a python3 virtual environment at .venv                 |
|  This means that all python packages installed will not affect your system |
|  Run _deactivate_ in your shell to return back to system python            |
|                                                                            |
------------------------------------------------------------------------------
EOF
