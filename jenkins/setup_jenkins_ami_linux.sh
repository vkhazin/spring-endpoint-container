#! /bin/bash

for SERVICE in $(echo docker nginx jenkins); do
    sh ${SERVICE}.sh
done

