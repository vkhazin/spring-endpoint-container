#! /bin/bash

for SERVICE in $(echo docker nginx jenkins); do
    sh ${SERVICE}.sh
    sudo chkconfig ${SERVICE} on
done

