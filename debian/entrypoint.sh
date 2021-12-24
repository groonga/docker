#!/bin/bash

set -e
set -u
# set -x

: ${GROONGA_ARGS:=}
: ${GROONGA_CACHE_DIR:=}
: ${GROONGA_DB:=/var/lib/groonga/db/db}
: ${GROONGA_INITIALIZE_DIR:=/var/lib/groonga/initialize}
: ${GROONGA_LOG_DIR:=/var/log/groonga}
: ${GROONGA_LOG_LEVEL:=}
: ${GROONGA_PROTOCOL:=http}

GROONGA_DB_DIR="$(dirname "${GROONGA_DB}")"

if [ "$(id -u)" = "0" ]; then
  is_root=true
else
  is_root=false
fi

if [ -n "${GROONGA_CACHE_DIR}" ]; then
  if [ ! -d "${GROONGA_CACHE_DIR}" ]; then
    mkdir -p "${GROONGA_CACHE_DIR}"
    if [ "${is_root}" = "true" ]; then
      chown -R groonga: "${GROONGA_CACHE_DIR}"
    fi
  fi
fi

if [ ! -f "${GROONGA_DB}" ]; then
  if [ ! -d "${GROONGA_DB_DIR}" ]; then
    mkdir -p "${GROONGA_DB_DIR}"
    if [ "${is_root}" = "true" ]; then
      chown -R groonga: "${GROONGA_DB_DIR}"
    fi
  fi
fi

if [ ! -d "${GROONGA_LOG_DIR}" ]; then
  mkdir -p "${GROONGA_LOG_DIR}"
  if [ "${is_root}" = "true" ]; then
    chown -R groonga: "${GROONGA_LOG_DIR}"
  fi
fi

if [ -n "${GROONGA_CACHE_DIR}" ]; then
  original_cache_owner=$(stat --format %u "${GROONGA_CACHE_DIR}")
  original_cache_group=$(stat --format %g "${GROONGA_CACHE_DIR}")
  if [ "${is_root}" = "true" ]; then
    chown -R groonga: "${GROONGA_CACHE_DIR}"
  fi
fi
original_db_owner=$(stat --format %u "${GROONGA_DB_DIR}")
original_db_group=$(stat --format %g "${GROONGA_DB_DIR}")
if [ "${is_root}" = "true" ]; then
  chown -R groonga: "${GROONGA_DB_DIR}"
fi
original_log_owner=$(stat --format %u "${GROONGA_LOG_DIR}")
original_log_group=$(stat --format %g "${GROONGA_LOG_DIR}")
if [ "${is_root}" = "true" ]; then
  chown -R groonga: "${GROONGA_LOG_DIR}"
fi


GROONGA_COMMAND_LINE=()
if [ "${is_root}" = "true" ]; then
  GROONGA_COMMAND_LINE+=(sudo -u groonga -H)
fi
GROONGA_COMMAND_LINE+=(groonga)
if [ -n "${GROONGA_CACHE_DIR}" ]; then
  GROONGA_COMMAND_LINE+=(--cache-base-path "${GROONGA_CACHE_DIR}/cache")
fi
GROONGA_COMMAND_LINE+=(--protocol "${GROONGA_PROTOCOL}")
if [ -n "${GROONGA_LOG_LEVEL}" ]; then
  GROONGA_COMMAND_LINE+=(--log-level "${GROONGA_LOG_LEVEL}")
fi
GROONGA_COMMAND_LINE+=(--log-path "${GROONGA_LOG_DIR}/groonga.log")
GROONGA_COMMAND_LINE+=(--query-log-path "${GROONGA_LOG_DIR}/query.log")

if [ ! -e "${GROONGA_DB}" ]; then
  "${GROONGA_COMMAND_LINE[@]}" ${GROONGA_ARGS} -n "${GROONGA_DB}" shutdown
  if [ -d "${GROONGA_INITIALIZE_DIR}" ]; then
    find "${GROONGA_INITIALIZE_DIR}" -print0 | \
      sort --zero-terminated | \
      while read -d "$(echo -n -e '\x00')" path; do
        case "${path}" in
          *.gz)
            zcat "${path}" | \
              "${GROONGA_COMMAND_LINE[@]}" ${GROONGA_ARGS} "${GROONGA_DB}"
            ;;
          *.zst)
            zstdcat "${path}" | \
              "${GROONGA_COMMAND_LINE[@]}" ${GROONGA_ARGS} "${GROONGA_DB}"
            ;;
          *)
          cat "${path}" | \
            "${GROONGA_COMMAND_LINE[@]}" ${GROONGA_ARGS} "${GROONGA_DB}"
          ;;
        esac
      done
  fi
fi

set +e
"${GROONGA_COMMAND_LINE[@]}" ${GROONGA_ARGS} -s "${GROONGA_DB}"
exit_code=$?

if [ "${is_root}" = "true" ]; then
  if [ -n "${GROONGA_CACHE_DIR}" ]; then
    chown \
      -R ${original_cache_owner}:${original_cache_group} \
      "${GROONGA_CACHE_DIR}"
  fi
  chown -R ${original_db_owner}:${original_db_group} "${GROONGA_DB_DIR}"
  chown -R ${original_log_owner}:${original_log_group} "${GROONGA_LOG_DIR}"
fi

exit ${exit_code}
