#!/usr/bin/env bash

export QT_QPA_PLATFORM=offscreen
pytest --pyargs randomgen
