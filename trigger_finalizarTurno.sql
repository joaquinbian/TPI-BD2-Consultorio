USE consultorio_db_v2
GO


CREATE TRIGGER t_FinalizarTurno ON Turno
AFTER UPDATE
AS BEGIN

    -- si no se cambio de estado a finalizado, no hacemos nada
    IF NOT EXISTS(
        SELECT 1 FROM deleted D INNER JOIN inserted I on D.id_turno = I.id_turno 
        WHERE D.estado != 'Finalzado' AND i.estado = 'Finalizado' 
    ) 
    BEGIN
        RETURN
    END


    --creamos la factura, insertamos:
        -- id del turno
        -- valor de la consulta (que viene del registro del profesional segun su especialidad)
        -- el porcentaje de cobertura que se aplico (que viene de la obra social)
        -- el descuento aplicado, que viene de la obra social, filtrando por la fecha
        -- monto total, valor de la consulta - el porcentaje de cobertura - descuento (si aplica)
        -- fecha de emision de la factura
    --volvemos a validar y filtrar que se haga solo sobre los finalizados y si no hay una factura de turno yas
     INSERT INTO Factura (
        id_turno,
        monto_base,
        cobertura_aplicada,
        descuento_aplicado,
        monto_total,
        fecha_emision
    )
    SELECT 
        I.id_turno,
        PE.valor_consulta AS monto_base,
        ISNULL(OS.porcentaje_cobertura, 0) AS cobertura_aplicada,
        ISNULL(DES.porcentaje_descuento, 0) AS descuento_aplicado,
        PE.valor_consulta 
        * (1 - ISNULL(OS.porcentaje_cobertura, 0) / 100.0)
        * (1 - ISNULL(DES.porcentaje_descuento, 0) / 100.0) AS monto_total,
        CAST(GETDATE() AS DATE) AS fecha_emision
    
    FROM inserted I
    INNER JOIN deleted D ON I.id_turno = D.id_turno
    INNER JOIN Paciente P ON I.id_paciente = P.id_paciente
    INNER JOIN HorarioAtencion HA ON I.id_horario = HA.id_horario
    INNER JOIN Profesional_Especialidad PE ON HA.id_profesional = PE.id_profesional 
                                            AND HA.id_especialidad = PE.id_especialidad
    LEFT JOIN ObraSocial OS ON I.id_obra_social = OS.id_obra_social
    LEFT JOIN Descuento DES ON I.id_obra_social = DES.id_obra_social
                             AND DATEDIFF(YEAR, P.fecha_nacimiento, I.fecha_turno) BETWEEN DES.edad_min AND DES.edad_max
    
    WHERE I.estado = 'Finalizado' 
      AND D.estado != 'Finalizado'
      AND NOT EXISTS (
          SELECT 1 FROM Factura F WHERE F.id_turno = I.id_turno
      );
    

END