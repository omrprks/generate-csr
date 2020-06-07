.PHONY: all

SRC=$(abspath generate-csr.sh)
OUT=generate-csr
DIST=/usr/local/bin/${OUT}

all:
	@echo Nothing to see here

link:
	@ln -s ${SRC} ${HOME}/spells/${OUT}
	@chmod +x ${HOME}/spells/${OUT}

install:
	@cp ${SRC} ${DIST}
	@chmod +x ${DIST}
