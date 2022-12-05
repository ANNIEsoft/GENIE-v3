#! /usr/bin/env bash

#Application Paths

Gapp=/Genie

export LIBGL_ALWAYS_INDIRECT=1

export DISPLAY=:0

export ROOTSYS=${Gapp}/root-6.24.06/install/

export LD_LIBRARY_PATH=/lib:.:${Gapp}/log4cpp/install/lib:${Gapp}/Pythia6Support/v6_424/lib:${ROOTSYS}/lib:${Gapp}/LHAPDF-6.3.0/install/lib:${GENIE}/install/lib:${LD_LIBRARY_PATH}

export PYTHIA6_DIR=${Gapp}/Pythia6Support/v6_424/
export PYTHIA6_INCLUDE_DIR=${Gapp}/Pythia6Support/v6_424/inc/
export PYTHIA6_LIBRARY=${Gapp}/Pythia6Support/v6_424/lib/

export LHAPATH=${Gapp}/LHAPDF-6.3.0/install/share/LHAPDF:${LHAPATH}

export GENIE=${Gapp}/Generator-3_00_04_ub3-master

export PATH=.:${Gapp}/fsplit/:${ROOTSYS}/bin:${Gapp}/LHAPDF-6.3.0/install/bin:${GENIE}/install/bin:${PATH}

export MANPATH=${ROOTSYS}/bin:${MANPATH}

export PYTHONPATH=${ROOTSYS}/lib:${PYTHONPATH}

export GENIEXSECFILE=${GENIE}/annie/gxspl-FNALsmall.xml
