USE consultorio_db_v2;
GO



CREATE TRIGGER t_BajaPaciente ON Paciente
INSTEAD OF DELETE
AS BEGIN
    IF NOT EXISTS(
        SELECT 1 FROM deleted D WHERE D.activo = 1
    )
    BEGIN
        PRINT('No hay pacientes a eliminar')
        ROLLBACK TRANSACTION
        RETURN
    END

    UPDATE P SET P.activo = 0 FROM Paciente P 
    INNER JOIN deleted D ON P.id_paciente = D.id_paciente
    WHERE D.activo = 1

    UPDATE T
    SET T.estado = 'Cancelado'
    FROM Turno T
    INNER JOIN deleted D ON T.id_paciente = D.id_paciente
    WHERE D.activo = 1                              
      AND T.estado IN ('Pendiente', 'Confirmado')   
      AND T.fecha_turno >= CAST(GETDATE() AS DATE); 
    
END