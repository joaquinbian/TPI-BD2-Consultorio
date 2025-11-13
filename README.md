# TPI-BD2-Consultorio
## Explicacion del sistema
El sistema desarrollado permite gestionar de manera integral la administración de turnos médicos en un consultorio que trabaja con múltiples profesionales de la salud y obras sociales.
 Su objetivo principal es organizar y centralizar la información relacionada con pacientes, profesionales, coberturas, horarios de atención y turnos, garantizando un funcionamiento ordenado y eficiente del consultorio.
La base de datos almacena toda la información necesaria para el registro de pacientes, la asignación de turnos según disponibilidad, la gestión de convenios con obras sociales y el cálculo automático de montos a abonar.
 Está orientado al uso del personal administrativo, aunque también puede ser extendido para uso directo de los pacientes a través de una interfaz web.
El sistema evita superposición de horarios, mantiene un historial de turnos y cobros, y permite aplicar descuentos automáticos según edad, cobertura o promociones especiales.
 De esta forma, se busca optimizar los procesos de atención y garantizar la trazabilidad de cada turno y paciente dentro del consultorio.

## Funcionalidades principales
- Gestión de pacientes:
 Permite registrar los datos personales de cada paciente, incluyendo su obra social, edad y contacto. Los pacientes pueden solicitar turnos con un profesional determinado y conocer el monto a abonar según su cobertura.
- Gestión de profesionales:
 Cada profesional puede definir su especialidad médica, su valor base de consulta y sus horarios de atención en uno o varios consultorios.
 Además, puede asociarse a distintas obras sociales mediante convenios con porcentajes de cobertura personalizados.
- Gestión de obras sociales:
 El sistema registra las obras sociales con las que trabaja el consultorio, incluyendo porcentajes de cobertura y descuentos fijos.
 Se contemplan reglas adicionales para descuentos por edad o promociones configurables en una tabla especial.
- Gestión de turnos:
 Permite registrar, modificar y cancelar turnos, evitando superposición de horarios para un mismo profesional o consultorio.
 Cada turno posee un estado (pendiente, confirmado, cancelado o finalizado) y mantiene trazabilidad de su fecha, hora, paciente y profesional.
- Gestión de consultorios:
 Registra la información física de los consultorios (ubicación, piso, número de sala) y su asignación a profesionales en determinados horarios.
Cálculo de montos y coberturas:
 El sistema calcula automáticamente el costo final del turno combinando el valor base del profesional, el porcentaje cubierto por la obra social y los descuentos aplicables según la edad o reglas especiales.
- Gestión de Facturas:
El sistema tendría guardado un historial de facturas con sus montos correspondientes para gestionar la contabilidad de los turnos 
