#!/usr/bin/env bash

echo "Inside build-conda.sh"

if [[ ${PLAT} == "x86_64" && ${UNICODE_WIDTH} == "32" && ${CONDA_BUILD} == true ]] || [[ ${TRAVIS_OS_NAME} == "osx" && ${CONDA_BUILD} == true ]]; then
    if [[ ${TRAVIS_OS_NAME} == "osx" ]]; then
        wget https://repo.continuum.io/miniconda/Miniconda3-latest-MacOSX-x86_64.sh -O miniconda3.sh -nv;
    fi
    if [[ ${TRAVIS_OS_NAME} == "linux" ]]; then
        wget http://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda3.sh -nv;
    fi
    chmod +x miniconda3.sh
    ./miniconda3.sh -b
    export PATH=${HOME}/miniconda3/bin:$PATH
    conda config --set always_yes true
    conda update --all --quiet
    conda install conda-build anaconda-client conda-verify
    echo cd ${TRAVIS_BUILD_DIR}
    cd ${TRAVIS_BUILD_DIR}
    if [[ ${CONDA_UPLOAD} == true ]]; then
        conda config --set anaconda_upload yes
    else
        conda config --set anaconda_upload no
    fi
    echo conda build ./conda-recipe
    conda build --user ${ANACONDA_USERNAME} --token ${ANACONDA_TOKEN} ./conda-recipe
    exit 0
else
  if [ -n "${CONDA_BUILD+1}" ]; then
    echo "conda build is disabled"
    exit 0
  fi
fi
