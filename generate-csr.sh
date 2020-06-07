#!/usr/bin/env bash

NUMBITS=4096

COUNTRY=${COUNTRY:-MY}
STATE=${STATE:-KL}
LOCALITY=${LOCALITY:-KL}

HOST_NAME=${1}
DOMAIN=${2}
ORGANIZATION=${3}

function create_enter_directory {
  echo ${1}
  mkdir -p ${1} && cd ${1} || exit 1
}

function generate_key {
  openssl genrsa -out ${1}.key ${NUMBITS} && \
  chmod 600 ${1}.key
}

function generate_csr {
  openssl req -new -sha256 \
    -subj "/C=${COUNTRY}/ST=${STATE}/L=${LOCALITY}/O=${3}/CN=${2}" \
    -reqexts SAN \
    -config <(cat /etc/ssl/openssl.cnf \
      <(printf "\n[SAN]\nsubjectAltName=DNS:${1},DNS:${2}")) \
    -key ${2}.key \
    -out ${2}.csr

  [ -f ${2}.csr ] && \
    openssl req -noout -text -in ${2}.csr || \
    exit 1
}

[ -z "${HOST_NAME}" ] && read -p "Enter hostname for server to be requested (e.g. server): " HOST_NAME
[ -z "${DOMAIN}" ] && read -p "Enter domain (e.g. domain.com): " DOMAIN
[ -z "${ORGANIZATION}" ] && read -p "Enter organization name: " ORGANIZATION

FQDN=${HOST_NAME}.${DOMAIN}

create_enter_directory ${FQDN}
[ ! -f ${FQDN}.key ] && generate_key ${FQDN}
generate_csr ${HOST_NAME} ${FQDN} ${ORGANIZATION}

echo OK
