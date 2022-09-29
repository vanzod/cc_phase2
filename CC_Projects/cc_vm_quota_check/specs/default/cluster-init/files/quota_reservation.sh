#!/bin/bash

RES_NAME=SpareNodesPool
ACTIVE_POOL_SIZE=187
LOG_FILE=/sched/logs/quota_reservation.log
PARTITION=hpc-mid

[ -f ${LOG_FILE} ] || { touch ${LOG_FILE} && chmod 666 ${LOG_FILE}; }

# Collect nodes count by state
# - Cannot use "sinfo --summarized" since drained and reserved nodes
#   are folded into idle count
# - Mixed nodes are counted as allocated
NUM_ALLOC_NODES=$(sinfo -p ${PARTITION} -h -t allocated -o %D)
[ -z "${NUM_ALLOC_NODES}" ] && NUM_ALLOC_NODES=0

NUM_IDLE_NODES=$(sinfo -p ${PARTITION} -h -t idle -o %D)
[ -z "${NUM_IDLE_NODES}" ] && NUM_IDLE_NODES=0

NUM_DRAIN_NODES=$(sinfo -p ${PARTITION} -h -t drained -o %D)
[ -z "${NUM_DRAIN_NODES}" ] && NUM_DRAIN_NODES=0

NUM_RESV_NODES=$(scontrol show reservation=${RES_NAME} | grep -Po 'NodeCnt=\K[^ ]*')
[ -z "${NUM_RESV_NODES}" ] && NUM_RESV_NODES=0

NUM_ACTIVE_NODES=$((${NUM_ALLOC_NODES} + ${NUM_IDLE_NODES} - ${NUM_DRAIN_NODES} - ${NUM_RESV_NODES}))

NODES_DELTA=$((${NUM_ACTIVE_NODES} - ${ACTIVE_POOL_SIZE}))

# Generate some log
TIMESTAMP=$(/bin/date '+%Y%m%d %H:%M:%S')
STATE_STR="alloc:${NUM_ALLOC_NODES} idle:${NUM_IDLE_NODES} drain:${NUM_DRAIN_NODES} "
STATE_STR+="active:${NUM_ACTIVE_NODES} reserved:${NUM_RESV_NODES}"
echo -n "${TIMESTAMP} [$(whoami)] Cluster status: ${STATE_STR}" >> ${LOG_FILE}

if [ ${NODES_DELTA} != 0 ]; then

    RESV_NEW_SIZE=$((${NUM_RESV_NODES} + ${NODES_DELTA}))
    echo -n " new_res_size:${RESV_NEW_SIZE}" >> ${LOG_FILE}

    if [ ${RESV_NEW_SIZE} -gt 0 ]; then
        # Create reservation or increase its size to match desired active pool size
        if [ ${NUM_RESV_NODES} -eq 0 ]; then
        scontrol create Reservation=${RES_NAME} \
                        NodeCnt=${RESV_NEW_SIZE} \
                        Users=root \
                        StartTime=NOW \
                        Duration=UNLIMITED > /dev/null && \
        echo " - Created reservation ${RES_NAME} - Reserved nodes: ${RESV_NEW_SIZE}" >> ${LOG_FILE}
        else
            scontrol update Reservation=${RES_NAME} \
                            NodeCnt=${RESV_NEW_SIZE} > /dev/null && \
            echo " - Changed reservation ${RES_NAME} size : ${NUM_RESV_NODES} -> ${RESV_NEW_SIZE} " >> ${LOG_FILE}
        fi
    else
        # Not enough reserved nodes to reach desired active pool size
        # All reserved nodes must be released -> Delete reservation
        scontrol delete Reservation=${RES_NAME} > /dev/null && \
        echo " - Deleted reservation ${RES_NAME}" >> ${LOG_FILE}
    fi

else

    echo >> ${LOG_FILE}

fi

exit 0
