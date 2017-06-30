#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

ONCE="$1"
ALWAYS="$2"

echo "Vagrant: running scripts hooked to ${ONCE}"

if [ ! -f "/.vagrant/${ONCE}-ran" ]; then
    sudo touch "/.vagrant/${ONCE}-ran"
fi
find "/vagrant/provision/shell/hooks/${ONCE}" -maxdepth 1 -type f -name '*.sh' | sort | while read FILENAME; do
    SHA1=$(sha1sum "${FILENAME}")
    if [ ! grep -x -q "${SHA1}" "/.vagrant/${ONCE}-ran" ]; then
        sudo /bin/bash -c "echo \"${SHA1}\" >> \"/.vagrant/${ONCE}-ran\""
        chmod +x "${FILENAME}"
        echo "Vagrant: executing ${FILENAME}"
        /bin/bash "${FILENAME}"
    else
        echo "Vagrant: skipping executing ${FILENAME} as contents have not changed"
    fi
done

echo "Vagrant: finished running scripts hooked to ${ONCE}"
echo "Vagrant: delete hashes you want to rerun in /.vagrant/${ONCE}-ran or delete it to rerun all"

if [ -z ${ALWAYS} ]; then
    exit 0
fi

echo "Vagrant: running scripts hooked to ${ALWAYS}"

# Run provisioning scrips always running.
find "/vagrant/provision/shell/hooks/${ALWAYS}" -maxdepth 1 -type f -name '*.sh' | sort | while read FILENAME; do
    chmod +x "${FILENAME}"
    echo "Vagrant: executing ${FILENAME}"
    /bin/bash "${FILENAME}"
done

echo "Vagrant: finished running scripts hooked to ${ALWAYS}"
