# aws-on-off
Scripts para automatizar insercao de máquinas AWS num agendador crontab

Uso:

O script possui 4 funcoes:
	add instance_id: adiciona máquina ao agendamento
	remove instance_id: remove máquina do agendamento
	on {instance_id}: liga todas as máquinas, ou somente a máquina especificada
	off {instance_id: desliga todas as máquinas, ou somente a máquina especificada

To-do:

Implementar logar retorno no syslog - DONE
Implementar horários individuais e automatizar inserção no cron
Aceitar diretório de cfg como argumento

