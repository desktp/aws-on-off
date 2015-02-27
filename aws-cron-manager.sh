#!/bin/bash

FUNC=$1
INSTANCE_ID=$2
INSTANCE_NAME=`aws ec2 describe-instances --instance-id $INSTANCE_ID --output text | grep Name | cut -f 3`
LIGAR=`aws ec2 start-instances --instance-ids`
DESLIGAR=`aws ec2 stop-instances --instance-ids`


if [ ! -e listaAgendamento.txt]; then
	touch listaAgendamento.txt
fi

function add(){
cat > cfg/${INSTANCE_ID}.cfg << EOF
INSTANCE_ID=${INSTANCE_ID}
INSTANCE_NAME=${INSTANCE_NAME}
EOF

echo "$INSTANCE_ID - $INSTANCE_NAME" >> listaAgendamento.txt
}

function remove(){
rm cfg/${INSTANCE_ID}.cfg

sed -i "/${INSTANCE_ID}/d" ./listaAgendamento.txt
}

function on(){
if [ -z $2 ]; then
	for CFG_FILE in cfg/*.cfg
	do
		source $CFG_FILE
		$LIGAR $INSTANCE_ID
		echo "Ligando $INSTANCE_NAME"
	done
else
	$LIGAR $INSTANCE_ID
	echo "Ligando $INSTANCE_NAME"
fi
}

function off(){
if [ -z $2 ]; then
        for CFG_FILE in cfg/*.cfg
        do
                source $CFG_FILE
                $DESLIGAR $INSTANCE_ID
                echo "Desligando $INSTANCE_NAME"
        done
else
        $DESLIGAR $INSTANCE_ID
        echo "Desligando $INSTANCE_NAME"
fi
}

case $FUNC in
	'add') add;;
	'remove') remove;;
	'on') on;;
	'off') off;;
	*) echo $"Uso: ./aws-cron-manager {on/off/add/remove} instance_id\non/off sem instance_id liga/desliga todas as maquinas no agendamento";;
esac
