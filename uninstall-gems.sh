#!/bin/bash

GEMS=`gem list --no-versions`
for x in $GEMS ; do gem uninstall $x; done
