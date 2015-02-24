#!/bin/bash

INSTANCE_ID=$1

if [ ! -d "ligar" ]; then
	mkdir -p ligar/logs/
fi

if [ ! -d "desligar" ]; then
	mkdir -p desligar/logs/
fi

touch ligar/logs/${INSTANCE_ID}.log
touch desligar/logs/${INSTANCE_ID}.log

cat > ligar/${INSTANCE_ID}.sh << EOF
date +"[%d/%m - %T]" >> ligar/logs/${INSTANCE_ID}.log
aws ec2 start-instances --instance-ids $INSTANCE_ID >> ligar/logs/${INSTANCE_ID}.log 2>&1
EOF

cat > desligar/${INSTANCE_ID}.sh << EOF
date +"[%d/%m - %T]" >> desligar/logs/${INSTANCE_ID}.log
aws ec2 stop-instances --instance-ids $INSTANCE_ID >> desligar/logs/${INSTANCE_ID}.log 2>&1
EOF
