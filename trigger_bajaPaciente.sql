USE consultorio_db_v2;
GO



CREATE TRIGGER t_BajaPaciente ON Paciente
INSTEAD OF DELETE
AS BEGIN
    -- Si en la tabla deleted no encontramos ningun paciente activo, estan todos eliminados, no haremos nada
    IF NOT EXISTS(
        SELECT 1 FROM deleted D WHERE D.activo = 1
    )
    BEGIN
        PRINT('No hay pacientes a eliminar')
        ROLLBACK TRANSACTION
        RETURN
    END

    -- hacemos la baja logica de todos los pacientes a los que se quiera eliminar
    -- que estaban activos
    UPDATE P SET P.activo = 0 FROM Paciente P 
    INNER JOIN deleted D ON P.id_paciente = D.id_paciente
    WHERE D.activo = 1

    -- cambiamos sus turnos futuros que no estaban finalizados a cancelado
    UPDATE T
    SET T.estado = 'Cancelado'
    FROM Turno T
    INNER JOIN deleted D ON T.id_paciente = D.id_paciente
    WHERE D.activo = 1                              
      AND T.estado IN ('Pendiente', 'Confirmado')   
      AND T.fecha_turno >= CAST(GETDATE() AS DATE); 
    
END