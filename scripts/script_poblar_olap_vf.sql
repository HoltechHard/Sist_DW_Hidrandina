use master
go

---------------------------------------------- 1. DIMESION CLIENTE ORACLE -------------------------------------------------

merge HidrandinaOLAP_VF.dbo.DimCliente as dim using(
  	select tc.Descripcion as TipoCliente,dp.Descripcion as Departamento,p.Descripcion as Provincia , d.Descripcion as Distrito, 
		s.Descripcion as Sector, (c.ApellidoPaterno+' '+c.ApellidoMaterno+' '+c.Nombres) as Cliente, 
		c.IdCliente as IdCliente
	from [HIDRA_XE_VF]..[RDELAROSA].[CLIENTE] c 
	inner join [HIDRA_XE_VF]..[RDELAROSA].[TIPO_CLIENTE] tc
	on c.IdTipoCliente=tc.IdTipoCliente
	inner join [HIDRA_XE_VF]..[RDELAROSA].[SECTOR] s
	on s.IdSector=c.idSector
	inner join [HIDRA_XE_VF]..[RDELAROSA].[DISTRITO] d
	on d.IdDistrito=s.idDistrito
	inner join [HIDRA_XE_VF]..[RDELAROSA].[PROVINCIA] p
	on p.IdProvincia=d.IdProvincia
	inner join [HIDRA_XE_VF]..[RDELAROSA].[DEPARTAMENTO] dp
	on dp.IdDepartamento=p.IdDepartamento
) as oltp
on oltp.IdCliente=dim.idCliente
when not matched then
	insert(TipoCliente,Departamento,Provincia,Distrito,Sector,Cliente,IdCliente)
	values(TipoCliente,Departamento,Provincia,Distrito,Sector,Cliente,IdCliente);
go

select * from HidrandinaOLAP_VF.dbo.DimCliente

----------------------------------------- 2. DIMENSION ORGANIZACION ORACLE ---------------------------------------------

MERGE HidrandinaOLAP_VF.dbo.DimOrganizacion AS dim using(
	select s.descripcion as Sucursal, a.descripcion as Area, tc.descripcion as TipoCargo, c.descripcion as Cargo,
	 p.Nombres+' '+p.ApellidoPaterno+' '+p.ApellidoMaterno as Personal,
	 p.IdPersonal as IdPersonal 
	from [HIDRA_XE_VF]..[RDELAROSA].[PERSONAL] p
	inner join [HIDRA_XE_VF]..[RDELAROSA].[CARGO] c
	on p.idCargo=c.idCargo
	inner join [HIDRA_XE_VF]..[RDELAROSA].[TIPO_CARGO] tc
	on tc.IdTipoCargo= c.IdTipoCargo
	inner join [HIDRA_XE_VF]..[RDELAROSA].[AREA] a
	on a.IdArea=tc.IdArea
	inner join [HIDRA_XE_VF]..[RDELAROSA].[SUCURSAL] s
	on s.IdSucursal=a.IdSucursal
) AS org
ON org.idPersonal = dim.idPersonal
WHEN NOT MATCHED THEN
	insert(Sucursal,Area,TipoCargo,Cargo,Personal,IdPersonal) 
	values(Sucursal,Area,TipoCargo,Cargo,Personal,IdPersonal);

select * from HidrandinaOLAP_VF.dbo.DimOrganizacion

----------------------------------------- 3. DIMENSION CONCEPTO POSTGRES ---------------------------------------------

MERGE HidrandinaOLAP_VF.dbo.DimConcepto AS dim
USING (
	SELECT  tc.Descripcion AS TipoConcepto , c.Descripcion AS Concepto, c.idconcepto as IdConcepto
	FROM [HIDRA_PG_VF].[PgsqlHidrandinaOLTP_VF].[public].[concepto] c 
	inner join [HIDRA_PG_VF].[PgsqlHidrandinaOLTP_VF].[public].[tipo_concepto] tc
	on c.idTipoConcepto=tc.idTipoConcepto
) AS oltp
ON oltp.idConcepto = dim.idConcepto
WHEN NOT MATCHED THEN
	INSERT (TipoConcepto, Concepto, IdConcepto)
	VALUES(TipoConcepto, Concepto, IdConcepto);

select * from HidrandinaOLAP_VF.dbo.DimConcepto

----------------------------------------- 4. DIMENSION MEDIOPAGO POSTGRES ---------------------------------------------

MERGE HidrandinaOLAP_VF.dbo.DimMedioPago AS dim
USING (
	SELECT Descripcion as MedioPago, IdMedioPago as IdPago
	FROM [HIDRA_PG_VF].[PgsqlHidrandinaOLTP_VF].[public].[medio_pago]
) AS oltp
   ON oltp.IdPago = dim.IdPago
WHEN NOT MATCHED THEN
	INSERT (MedioPago, IdPago) VALUES(MedioPago, IdPago);

select * from HidrandinaOLAP_VF.dbo.DimMedioPago

----------------------------------------- 5. DIMENSION CONSUMO ORACLE ---------------------------------------------

MERGE HidrandinaOLAP_VF.dbo.DimConsumo AS dim
USING (
	SELECT tc.TipoConexion as TipoConsumo, m.Descripcion as Consumo,  c.IdConsumo as IdConsumo
	FROM [HIDRA_XE_VF]..[RDELAROSA].[TIPO_CONSUMO] tc
	INNER JOIN [HIDRA_XE_VF]..[RDELAROSA].[CONSUMO] c
	ON tc.idTipoConsumo=c.idTipoConsumo
	inner join [HIDRA_XE_VF]..[RDELAROSA].[MEDIDOR] m
	on c.idMedidor=m.idMedidor
) AS org
   ON org.idConsumo = dim.idConsumo
WHEN NOT MATCHED THEN
	INSERT (TipoConsumo, Consumo, IdConsumo)
	values(TipoConsumo,Consumo,IdConsumo);

select * from HidrandinaOLAP_VF.dbo.DimConsumo

----------------------------------------- 6. DIMENSION TIEMPO ORACLE ---------------------------------------------

MERGE HidrandinaOLAP_VF.dbo.DimTiempo AS dim
USING (
	select distinct Anio=year(f.FechaVencimiento),
		Semestre=case
			when month(f.FechaVencimiento)<=6 then 'SEM-1'
			when month(f.FechaVencimiento)>6 then 'SEM-2' end,
		Trimestre='TRI-'+datename(qq,f.FechaVencimiento),
		Mes=datename(mm,f.FechaVencimiento),
		DiaSemana=datename(dw,f.FechaVencimiento),
		cast(f.FechaVencimiento as date) as Fecha
	from [HIDRA_XE_VF]..[RDELAROSA].[FACTURA] f

	UNION
	select distinct Anio=year(c.FechaCobranza),
		Semestre=case
			when month(c.FechaCobranza)<=6 then 'SEM-1'
			when month(c.FechaCobranza)>6 then 'SEM-2' end,
		Trimestre='TRI-'+datename(qq,c.FechaCobranza),
		Mes=datename(mm,c.FechaCobranza),
		DiaSemana=datename(dw,c.FechaCobranza),
		cast(c.FechaCobranza as date) as Fecha
	from [HIDRA_XE_VF]..[RDELAROSA].[COBRANZA] c
	where c.FechaCobranza is not null

	UNION
	select distinct Anio=year(co.FechaLectura),
		Semestre=case
			when month(co.FechaLectura)<=6 then 'SEM-1'
			when month(co.FechaLectura)>6 then 'SEM-2' end,
		Trimestre='TRI-'+datename(qq,co.FechaLectura),
		Mes=datename(mm,co.FechaLectura),
		DiaSemana=datename(dw,co.FechaLectura),
		cast(co.FechaLectura as date) as Fecha
	from [HIDRA_XE_VF]..[RDELAROSA].[CONSUMO] co
	where co.FechaLectura is not null

	UNION 
	select distinct Anio=year(r.Fecha),
		Semestre=case
			when month(r.Fecha)<=6 then 'SEM-1'
			when month(r.Fecha)>6 then 'SEM-2' end,
		Trimestre='TRI-'+datename(qq,r.Fecha),
		Mes=datename(mm,r.Fecha),
		DiaSemana=datename(dw,r.Fecha),
		cast(r.Fecha as date) as Fecha
	from [HIDRA_XE_VF]..[RDELAROSA].[RECLAMO] r
	where r.Fecha is not null

	UNION	
	select distinct Anio=year(m.Fecha),
		Semestre=case
			when month(m.Fecha)<=6 then 'SEM-1'
			when month(m.Fecha)>6 then 'SEM-2' end,
		Trimestre='TRI-'+datename(qq,m.Fecha),
		Mes=datename(mm,m.Fecha),
		DiaSemana=datename(dw,m.Fecha),
		cast(m.Fecha as date) as Fecha
	from [HIDRA_XE_VF]..[RDELAROSA].[MANTENIMIENTO] m
	where m.Fecha is not null

	UNION 
	select distinct Anio=year(i.FechaFin),
		Semestre=case
			when month(i.FechaFin)<=6 then 'SEM-1'
			when month(i.FechaFin)>6 then 'SEM-2' end,
		Trimestre='TRI-'+datename(qq,i.FechaFin),
		Mes=datename(mm,i.FechaFin),
		DiaSemana=datename(dw,i.FechaFin),
		cast(i.FechaFin as date) as Fecha
	from [HIDRA_XE_VF]..[RDELAROSA].[INCIDENCIA] i
	where i.FechaFin is not null
) AS org
   ON org.Fecha = dim.Fecha
WHEN NOT MATCHED THEN
	INSERT (Anio,Semestre,Trimestre,Mes,DiaSemana,Fecha)
	values(Anio,Semestre,Trimestre,Mes,DiaSemana,Fecha);

select * from HidrandinaOLAP_VF.dbo.DimTiempo

----------------------------------------- 7. DIMENSION INCIDENCIA ORACLE ---------------------------------------------

merge HidrandinaOLAP_VF.dbo.DimIncidencia  AS dim
USING (
	SELECT
		TI.Descripcion AS TipoIncidencia,
		NivelGravedad = CASE WHEN DI.FactorGravedad =1 THEN 'RIESGO ALTO'
						WHEN DI.FactorGravedad = 2 THEN 'RIESGO MEDIO'
						ELSE 'RIESGO BAJO' END,
		I.IdIncidencia as IdIncidencia
		FROM
		[HIDRA_XE_VF]..[RDELAROSA].[INCIDENCIA] I
		INNER JOIN [HIDRA_XE_VF]..[RDELAROSA].[TIPO_INCIDENCIA] TI ON
		TI.IdTipoIncidencia = I.IdTipoIncidencia
		INNER JOIN [HIDRA_XE_VF]..[RDELAROSA].[DETALLE_INCIDENCIA] DI ON
		DI.IdIncidencia = I.IdIncidencia
) AS inc ON inc.IdIncidencia = dim.IdIncidencia
WHEN NOT MATCHED THEN	
INSERT (TipoIncidencia, NivelGravedad, IdIncidencia) 
VALUES (TipoIncidencia, NivelGravedad, IdIncidencia);

select * from HidrandinaOLAP_VF.dbo.DimIncidencia

----------------------------------------- 8. DIMENSION PARAMETRO POSTGRES ---------------------------------------------

merge HidrandinaOLAP_VF.dbo.DimParametro  AS dim
USING (
	SELECT
		P.Descripcion as Parametro,
		P.IdParametro as IdParametro
		FROM
		[HIDRA_PG_VF].[PgsqlHidrandinaOLTP_VF].[public].[parametro] P
) AS par ON par.IdParametro = dim.IdParametro
WHEN NOT MATCHED THEN	
INSERT (Parametro, IdParametro) 
VALUES (Parametro, IdParametro);

select * from HidrandinaOLAP_VF.dbo.DimParametro

----------------------------------------- 9. DIMENSION MANTENIMIENTO ORACLE ---------------------------------------------

MERGE HidrandinaOLAP_VF.dbo.DimMantenimiento as dim
using(
	SELECT
	TM.Descripcion AS TipoMantenimiento
	,F.Descripcion AS Fallo
	,NivelGravedad = CASE WHEN F.Gravedad=1 THEN 'ALTO'
					 WHEN F.Gravedad=2 THEN 'MEDIO'
					 ELSE 'BAJO' END,
	M.IdMantenimiento as IdMantenimiento
	from [HIDRA_XE_VF]..[RDELAROSA].[DETALLE_MTTO] DM 
	inner join [HIDRA_XE_VF]..[RDELAROSA].[MANTENIMIENTO] M ON
		DM.IdMantenimiento=M.IdMantenimiento
	INNER JOIN [HIDRA_XE_VF]..[RDELAROSA].[TIPO_MANTENIMIENTO] TM ON
	TM.IdTipoMantenimiento = M.IdTipoMantenimiento
	INNER JOIN [HIDRA_XE_VF]..[RDELAROSA].[FALLO] F ON
	F.IdFallo = DM.IdFallo
)AS man ON man.IdMantenimiento = dim.IdMantenimiento
WHEN NOT MATCHED THEN	
INSERT (TipoMantenimiento, Fallo, NivelGravedad, IdMantenimiento) 
VALUES (TipoMantenimiento, Fallo, NivelGravedad, IdMantenimiento);

select * from HidrandinaOLAP_VF.dbo.DimMantenimiento

----------------------------------------- 10. DIMENSION RECLAMO ORACLE ---------------------------------------------

MERGE HidrandinaOLAP_VF.dbo.DimReclamo as dim
using(
SELECT 
	TR.Descripcion AS TipoReclamo
	,NivelGravedad = CASE WHEN R.Gravedad=1 THEN 'ALTO RIESTO'
				WHEN R.Gravedad=2 THEN 'RIESGOSO'
				WHEN R.Gravedad=3 THEN 'BAJO RIESTO'
				ELSE 'INOFENSIVO' END
	,NivelAtendimiento=CASE WHEN R.NivelAtendimiento=1 THEN 'EXPERTO'
					   WHEN R.NivelAtendimiento=2 THEN 'ALTAMENTE PROFESIONAL'
					   WHEN R.NivelAtendimiento=3 THEN 'PROFESIONAL'
					   ELSE 'TECNICO' END
	,R.IdReclamo as IdReclamo
	FROM [HIDRA_XE_VF]..[RDELAROSA].[RECLAMO] R
	INNER JOIN [HIDRA_XE_VF]..[RDELAROSA].[TIPO_RECLAMO] TR ON
	TR.IdTipoReclamo = R.IdTipoReclamo
)AS rec ON rec.IdReclamo = dim.IdReclamo
WHEN NOT MATCHED THEN	
INSERT (TipoReclamo,NivelGravedad,NivelAtendimiento,IdReclamo) 
VALUES (TipoReclamo,NivelGravedad,NivelAtendimiento,IdReclamo);

select * from HidrandinaOLAP_VF.dbo.DimReclamo

