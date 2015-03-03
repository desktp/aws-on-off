# aws-on-off
Scripts para automatizar insercao de máquinas AWS num agendador crontab

Uso:

O script possui 4 funcoes:

add instance_id: adiciona máquina ao agendamento <br>
remove instance_id: remove máquina do agendamento <br>
on {instance_id}: liga todas as máquinas, ou somente a máquina especificada <br>
off {instance_id: desliga todas as máquinas, ou somente a máquina especificada <br>

To-do:

Implementar logar retorno no syslog - DONE <br>
Implementar horários individuais e automatizar inserção no cron <br>
Aceitar diretório de cfg como argumento <br>

