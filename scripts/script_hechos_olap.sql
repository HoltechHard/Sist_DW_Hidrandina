
use HidrandinaOLAP_VF
go

use HidrandinaOLTP_VF
go


--------------------------------------- 1. HECHO_FACTURACION --------------------------------------------------------

use HidrandinaOLTP_VF
go

insert HidrandinaOLAP_VF.dbo.Hecho_Facturacion(KeyCliente,KeyConcepto,KeyConsumo,KeyTiempo,KeyParametro,
	MontoFacturado,MontoMeta,FactEmitidas,FactPendientes,FacAnuladas,FacTotal)
select DCL.KeyCliente,DCO.KeyConcepto,DCN.KeyConsumo,DTI.KeyTiempo,DPA.KeyParametro,
	df.MontoFacturado as MontoFacturado,f.MontoMeta as MontoMeta,
	FacEmitidas=case when f.EstadoDocumento='X' then count(distinct f.IdFactura) else 0 end,
	FacPendientes=case when f.EstadoDocumento='P' then count(distinct f.IdFactura) else 0 end,
	FacAnuladas=case when f.EstadoDocumento='A' then count(distinct f.IdFactura) else 0 end,
	FacTotal=count(distinct f.IdFactura)
from FACTURA f
left join DETALLE_FACTURA df
on f.IdFactura=df.IdFactura
inner join HidrandinaOLAP_VF.dbo.DimCliente DCL	
on DCL.IdCliente=df.IdCliente
inner join HidrandinaOLAP_VF.dbo.DimConcepto DCO
on DCO.idConcepto=df.IdConcepto
inner join HidrandinaOLAP_VF.dbo.DimConsumo DCN
on DCN.IdConsumo=df.IdConsumo
inner join HidrandinaOLAP_VF.dbo.DimTiempo DTI
on cast(DTI.Fecha as date)=cast(f.FechaVencimiento as date)
inner join HidrandinaOLAP_VF.dbo.DimParametro DPA
on DPA.IdParametro=df.IdParametro
group by DCL.KeyCliente,DCO.KeyConcepto,DCN.KeyConsumo,DTI.KeyTiempo,DPA.KeyParametro,df.MontoFacturado,f.MontoMeta,f.EstadoDocumento

use HidrandinaOLAP_VF
go
select * from Hecho_Facturacion

--------------------------------------- 2. HECHO_COBRANZA --------------------------------------------------------

use HidrandinaOLTP_VF	
go
select * from cobranza
select * from factura

insert HidrandinaOLAP_VF.dbo.Hecho_Cobranza(KeyMedioPago,KeyOrganizacion,KeyCliente,KeyTiempo,
	MontoCobrado,MontoTotal)
select DMP.KeyMedioPago,DOR.KeyOrganizacion,DCL.KeyCliente,DTI.KeyTiempo,
	MontoCobrado=case when c.EstadoCobranza='C' then c.MontoCobrado
					when c.EstadoCobranza='M' then 0 end,
	MontoTotal=f.MontoTotal
from cobranza c
inner join factura f
on c.IdFactura=f.IdFactura
inner join cliente cl
on f.IdFactura=cl.IdCliente
inner join HidrandinaOLAP_VF.dbo.DimMedioPago DMP
on DMP.IdPago=c.IdMedioPago
inner join HidrandinaOLAP_VF.dbo.DimOrganizacion DOR
on DOR.IdPersonal=c.IdPersonal
inner join HidrandinaOLAP_VF.dbo.DimCliente DCL
on DCL.IdCliente=cl.IdCliente
inner join HidrandinaOLAP_VF.dbo.DimTiempo DTI
on cast(DTI.Fecha as date)=cast(c.FechaCobranza as date)

use HidrandinaOLAP_VF
go
select * from Hecho_Cobranza
select sum(MontoCobrado) from Hecho_Cobranza
select sum(MontoTotal) from Hecho_Cobranza


--------------------------------------- 3. HECHO_METACONSUMO --------------------------------------------------------

use HidrandinaOLTP_VF
go

insert HidrandinaOLAP_VF.dbo.Hecho_MetaConsumo(KeyConsumo,KeyCliente,KeyTiempo,
	ConsumoKw,ConsumoMetaKw)
select DCO.KeyConsumo,DCL.KeyCliente,DTI.KeyTiempo,
	c.ConsumoKW as ConsumoKw, c.ConsumoMetaKW as ConsumoMetaKw
from consumo c
inner join HidrandinaOLAP_VF.dbo.DimConsumo DCO
on DCO.IdConsumo=c.IdConsumo
inner join HidrandinaOLAP_VF.dbo.DimCliente DCL
on DCL.IdCliente=c.IdCliente
inner join HidrandinaOLAP_VF.dbo.DimTiempo DTI
on cast(DTI.Fecha as date)=cast(c.FechaLectura as date)

use HidrandinaOLAP_VF 
go
select * from Hecho_MetaConsumo


--------------------------------------- 4. HECHO_AtendimientoReclamos --------------------------------------------------------

use HidrandinaOLTP_VF
go
select * from reclamo

insert into HidrandinaOLAP_VF.dbo.Hecho_AtendimientoReclamos(KeyReclamo,KeyCliente,KeyTiempo,
	RecAtendidos,RecTotal,CostoReclamo,PresupuestoReclamo)
select DRE.KeyReclamo,DCL.KeyCliente,DTI.KeyTiempo,
	RecAtendidos=case when r.Estado=1 then count(r.IdReclamo) else 0 end,
	RecTotal=count(r.IdReclamo),
	CostoReclamo=r.CostoReclamo,
	PresupuestoReclamo=r.PresupuestoReclamo
from reclamo r
inner join HidrandinaOLAP_VF.dbo.DimReclamo DRE
on DRE.IdReclamo=r.IdReclamo
inner join HidrandinaOLAP_VF.dbo.DimCliente DCL
on DCL.IdCliente=r.IdCliente
inner join HidrandinaOLAP_VF.dbo.DimTiempo DTI
on cast(DTI.Fecha as date)=cast(r.Fecha as date)
group by DRE.KeyReclamo,DCL.KeyCliente,DTI.KeyTiempo,r.Estado,r.CostoReclamo,r.PresupuestoReclamo

use HidrandinaOLAP_VF
go
select * from Hecho_AtendimientoReclamos


--------------------------------------- 5. HECHO_AtendimientoIncidencia --------------------------------------------------------

use HidrandinaOLTP_VF
go
select * from INCIDENCIA


insert into HidrandinaOLAP_VF.dbo.Hecho_AtendimientoIncidencia(KeyIncidencia,KeyTiempo,IncAtendidos,IncTotal)
select DIN.KeyIncidencia,DTI.KeyTiempo,
	IncAtendidos=case when di.Estado=1 then count(di.IdIncidencia) else 0 end,
	IncTotal=count(di.IdIncidencia)
from DETALLE_INCIDENCIA di
inner join INCIDENCIA i
on i.IdIncidencia=di.IdIncidencia
inner join HidrandinaOLAP_VF.dbo.DimIncidencia DIN
on DIN.IdIncidencia=di.IdIncidencia
inner join HidrandinaOLAP_VF.dbo.DimTiempo DTI
on cast(DTI.Fecha as date)=cast(i.FechaFin as date)
group by DIN.KeyIncidencia,DTI.KeyTiempo,di.Estado

use HidrandinaOLAP_VF
go
select * from Hecho_AtendimientoIncidencia


--------------------------------------- 6. HECHO_ImpactoMtto --------------------------------------------------------

use HidrandinaOLTP_VF
go
select * from mantenimiento

insert into HidrandinaOLAP_VF.dbo.Hecho_ImpactoMatto(KeyMantenimiento,KeyTiempo,CostoMtto,PresupuestoMtto)
select distinct DMA.KeyMantenimiento,DTI.KeyTiempo,
	CostoMtto=m.CostoTotal,PresupuestoMtto=m.PresupuestoMtto
from detalle_mtto dm
inner join mantenimiento m
on m.IdMantenimiento=dm.IdMantenimiento
inner join HidrandinaOLAP_VF.dbo.DimMantenimiento DMA
on DMA.IdMantenimiento=m.IdMantenimiento
inner join HidrandinaOLAP_VF.dbo.DimTiempo DTI
on cast(DTI.fecha as date)=cast(m.Fecha as date)


use HidrandinaOLAP_VF 
go
select * from Hecho_ImpactoMatto
go
