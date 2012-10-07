.PHONY: all proposal clean biosketches data_management_plan output_dir

SHORT_NAME=proposal
OUTPUT_DIR=output
SCRATCH_DIR=scratch
PDFVIEW?=open

BIOSKETCH_FILES=${wildcard supporting_documents/biosketches/*.tex}
BIOSKETCH_NAMES=${patsubst supporting_documents/biosketches/%.tex, %, ${BIOSKETCH_FILES}}

COXLAB_SPECIFIC_FILES=${wildcard supporting_documents/coxlab-specific/*.tex}
COXLAB_SPECIFIC_NAMES=${patsubst supporting_documents/coxlab-specific/%.tex, %, ${COXLAB_SPECIFIC_FILES}}

PDFLATEX_OPTIONS=--output-directory ${OUTPUT_DIR}
QUIET=0

ifeq (${QUIET}, 1)
	PIPING=2>&1 >/dev/null
endif

all:  biosketches harvard proposal data_management_plan clean

output_dir:
	mkdir -p ${OUTPUT_DIR}

proposal: output_dir ${SHORT_NAME}.tex
	- pdflatex ${SHORT_NAME}.tex ${PIPING}
	- bibtex ${SHORT_NAME} 2>&1 ${PIPING}
	- pdflatex ${SHORT_NAME}.tex ${PIPING}
	- pdflatex ${SHORT_NAME}.tex ${PIPING}
	- pdflatex ${PDFLATEX_OPTIONS} ${SHORT_NAME}.tex ${PIPING}

DMP=supporting_documents/data_management_plan.tex

data_management_plan: output_dir ${DMP}
	- pdflatex ${PDFLATEX_OPTIONS} ${DMP} ${PIPING}

view: ${OUTPUT_DIR}/${SHORT_NAME}.pdf
	${PDFVIEW} ${OUTPUT_DIR}/${SHORT_NAME}.pdf

clean:
	${foreach NAME, ${SHORT_NAME} ${BIOSKETCH_NAMES} ${COXLAB_SPECIFIC_NAMES}, rm -vf $$(ls ${NAME}.??? | grep -v tex | grep -v bib )}
	rm -rf ${OUTPUT_DIR}/*.log ${OUTPUT_DIR}/*.aux


biosketches: output_dir
	for FILE in ${BIOSKETCH_FILES}; do \
		pdflatex ${PDFLATEX_OPTIONS} $$FILE ${PIPING}; \
	done

harvard: output_dir
	for FILE in ${COXLAB_SPECIFIC_FILES}; do \
		pdflatex ${PDFLATEX_OPTIONS} $$FILE ${PIPING}; \
	done
