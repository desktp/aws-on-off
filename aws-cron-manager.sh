#!/bin/bash
# jacques mouette
# script para criacao de agendamentos maquinas aws
# 
# v1.0
#
# TO-DO:
#	criar arquivo no cron diretamente;
#	aceitar diretório de cfg como argumento;


# Declaracao de variaveis globais
# FUNC define funcao (add/remove/on/off)
FUNC=$1
INSTANCE_ID=$2
LIGAR='aws ec2 start-instances --instance-id'
DESLIGAR='aws ec2 stop-instances --instance-id'

# Se foi passado ID de instancia, busca o nome
if [ ! -z $2 ]; then
	INSTANCE_NAME=`aws ec2 describe-instances --instance-id $INSTANCE_ID --output text | grep Name | cut -f 3`
fi

# Verifica existencia da lista e cria se necessario
if [ ! -e listaAgendamento.txt ]; then
	touch listaAgendamento.txt
fi

# Verificar (e cria) existencia do diretorio de cfg
if [ ! -d cfg ]; then
	mkdir cfg
fi

# Funcao de adicionar
# Recebe id da instancia, cria arquivo de cfg e insere linha na lista
function add(){
cat > cfg/${INSTANCE_ID}.cfg << EOF
INSTANCE_ID=${INSTANCE_ID}
INSTANCE_NAME=${INSTANCE_NAME}
EOF

echo "$INSTANCE_ID - $INSTANCE_NAME" >> listaAgendamento.txt
}

# Funcao de remover
# Remove arquivo de cfg e linha da lista
function remove(){
rm cfg/${INSTANCE_ID}.cfg

sed -i "/${INSTANCE_ID}/d" ./listaAgendamento.txt
}

# Funcao de ligar
function on(){
# Se nao foi passado ID de instancia, ligar todas as maquinas
if [ -z $2 ]; then
	for CFG_FILE in cfg/*.cfg
	do
		source $CFG_FILE
		echo "Ligando $INSTANCE_NAME" | logger -p local0.info -t [AWS-ON]
		$LIGAR $INSTANCE_ID | logger -p local0.info -t [AWS-ON]
	done
else # Senao, liga apenas maquina especificada
	echo "Ligando $INSTANCE_NAME" | logger -p local0.info -t [AWS-ON]
	$LIGAR $INSTANCE_ID | logger -p local0.info -t [AWS-ON]
fi
}

# Funcao de desligar
function off(){
# Se nao foi passado ID, desliga tudo
if [ -z $2 ]; then
        for CFG_FILE in cfg/*.cfg
        do
                source $CFG_FILE
		echo "Desligando $INSTANCE_NAME" | logger -p local0.info -t [AWS-OFF]
		$DESLIGAR $INSTANCE_ID | logger -p local0.info -t [AWS-OFF]
	done
else # Senao, desliga apenas especificada
	echo "Desligando $INSTANCE_NAME" | logger -p local0.info -t [AWS-OFF]
	$DESLIGAR $INSTANCE_ID | logger -p local0.info -t [AWS-OFF]
fi
}


case $FUNC in
	'add') add;;
	'remove') remove;;
	'on') on;;
	'off') off;;
	*) echo "Uso: ./aws-cron-manager {on/off/add/remove} instance_id
on/off sem instance_id liga/desliga todas as maquinas no agendamento";;
esac
