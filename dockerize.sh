#!/bin/sh
SCRIPT=$1

set -a

# eval the script until the second hashbang
SCRIPT_F=$(cat ${SCRIPT} | sed '1d;/#!/q')
export1_f=$(mktemp)
export2_f=$(mktemp)
export -p | sort > ${export1_f}
eval "${SCRIPT_F}"
export -p | sort > ${export2_f}
EXPORTS=$(
  comm -13 ${export1_f} ${export2_f} \
  | sed '/FROM/d' \
  | sed '/TAG/d' \
  | sed '/EXPOSE/d' \
  | sed '/VOLUME/d' \
  | sed '/RUNDIR/d' \
  | sed '/CMD/d'
)
rm -f ${export1_f} ${export2_f}

# Value of second hashbang
SH=$(sed -n '1d;/#!/s/#!//p' ${SCRIPT})
# Script from the second hashbang
SH_SCRIPT=$(sed '1,/#!/d' ${SCRIPT})

# Add VOLUME and WORKDIR to docker run
VOLUME_S=$(test -n "${VOLUME:=}" && echo ${VOLUME} | tr '\n' ' ' | xargs -n 1 printf '-v %s ')
RUNDIR_S=$(test -n "${RUNDIR:=}" && echo -w ${RUNDIR})

# Add all other added variables as -e
ENV_S=$(echo ${EXPORTS} | sed 's/export/-e/g' | tr '\n' ' ' | sed "s/'//g")

# Add Dockerfile parameters to docker commit
EXPOSE_S=$(test -n "${EXPOSE:=}" && echo --change=\"EXPOSE ${EXPOSE}\")
WORKDIR_S=$(test -n "${WORKDIR:=}" && echo --change=\"WORKDIR ${WORKDIR}\")
CMD_S=$(test -n "${CMD:=}" && echo --change=\'CMD ${CMD}\')

# Ensure container is stopped/removed when script finishes/aborts
CID=$(mktemp -u)
trap 'docker rm -f $(cat ${CID}) > /dev/null 2>&1' EXIT INT TERM HUP

docker run -t --cidfile=${CID} \
  ${ENV_S} \
  ${VOLUME_S} \
  ${RUNDIR_S} \
  ${FROM:-scratch} \
  /bin/sh -c "echo \"${SH_SCRIPT}\" | ${SH}" && \
  /bin/sh -c "docker commit ${WORKDIR_S} ${EXPOSE_S} ${CMD_S} $(cat ${CID}) ${TAG:-}"
