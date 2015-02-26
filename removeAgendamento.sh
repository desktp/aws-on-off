#!/bin/bash

INSTANCE_ID=$1

rm ligar/${INSTANCE_ID}.sh
rm desligar/${INSTANCE_ID}.sh

sed -i "/${INSTANCE_ID}/d" ./listaAgendamento.txt
