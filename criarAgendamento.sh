#!/bin/bash

INSTANCE_ID=$1
INSTANCE_NAME=`aws ec2 describe-instances --instance-id $INSTANCE_ID --output text | grep Name | cut -f 3`

if [ ! -d "ligar" ]; then
	mkdir -p ligar/logs/
fi

if [ ! -d "desligar" ]; then
	mkdir -p desligar/logs/
fi

touch ligar/logs/${INSTANCE_ID}.log
touch desligar/logs/${INSTANCE_ID}.log
touch listaAgendamento.txt

cat > ligar/${INSTANCE_ID}.sh << EOF
date +"[%d/%m - %T]" >> ligar/logs/${INSTANCE_ID}.log
aws ec2 start-instances --instance-ids $INSTANCE_ID >> ligar/logs/${INSTANCE_ID}.log 2>&1
EOF

cat > desligar/${INSTANCE_ID}.sh << EOF
date +"[%d/%m - %T]" >> desligar/logs/${INSTANCE_ID}.log
aws ec2 stop-instances --instance-ids $INSTANCE_ID >> desligar/logs/${INSTANCE_ID}.log 2>&1
EOF

echo "$INSTANCE_ID - $INSTANCE_NAME" >> listaAgendamento.txt

chmod +x ligar/*.sh
chmod +x desligar/*.sh
