
-----------------------------------------------------------------
--SCRIPT PARA GENERACION DE DATOS ALEATORIOS HidrandinaOLTP_VF
-----------------------------------------------------------------

use HidrandinaOLTP_VF
go

----------------------------llenado dept-prov-dist-------------------------------

insert into departamento values('La Libertad',1)
select * from departamento

insert into provincia values('Trujillo',1,1)
insert into provincia values('Bolívar',1,1)
insert into provincia values('Sanchez Carrión',1,1)
insert into provincia values('Otuzco',1,1)
insert into provincia values('Pacasmayo',1,1)
insert into provincia values('Pataz',1,1)
insert into provincia values('Santiago de Chuco',1,1)
insert into provincia values('Ascope',1,1)
insert into provincia values('Chepén',1,1)
insert into provincia values('Julcán',1,1)
insert into provincia values('Gran Chimú',1,1)
insert into provincia values('Virú',1,1)

select * from provincia

insert into distrito values('Trujillo',1,1)
insert into distrito values('Huanchaco',1,1)
insert into distrito values('Laredo',1,1)
insert into distrito values('Moche',1,1)
insert into distrito values('Salaverry',1,1)
insert into distrito values('Simbal',1,1)
insert into distrito values('Víctor Larco Herrera',1,1)
insert into distrito values('Poroto',1,1)
insert into distrito values('El Porvenir',1,1)
insert into distrito values('La Esperanza',1,1)
insert into distrito values('Florencia de Mora',1,1)

insert into distrito values('Bolívar',1,2)
insert into distrito values('Bambamarca',1,2)
insert into distrito values('Condormarca',1,2)
insert into distrito values('Longotea',1,2)
insert into distrito values('Uchuncha',1,2)
insert into distrito values('Uchumarca',1,2)

insert into distrito values('Huamachuco',1,3)
insert into distrito values('Cochorco',1,3)
insert into distrito values('Curgos',1,3)
insert into distrito values('Chugay',1,3)
insert into distrito values('Marcabal',1,3)
insert into distrito values('Sanagoran',1,3)
insert into distrito values('Sarin',1,3)
insert into distrito values('Sartimbamba',1,3)

insert into distrito values('Otuzco',1,4)
insert into distrito values('Agallpampa',1,4)
insert into distrito values('Charat',1,4)
insert into distrito values('Huaranchal',1,4)
insert into distrito values('La Cuesta',1,4)
insert into distrito values('Paranday',1,4)
insert into distrito values('Salpo',1,4)
insert into distrito values('Sinsicap',1,4)
insert into distrito values('Usquil',1,4)
insert into distrito values('Mache',1,4)

insert into distrito values('San Pedro de Lloc',1,5)
insert into distrito values('Guadalupe',1,5)
insert into distrito values('Jequetepeque',1,5)
insert into distrito values('Pacasmayo',1,5)
insert into distrito values('San José',1,5)

insert into distrito values('Tayabamba',1,6)
insert into distrito values('Buldibuyo',1,6)
insert into distrito values('Chillia',1,6)
insert into distrito values('Huaylillas',1,6)
insert into distrito values('Huancaspata',1,6)
insert into distrito values('Huayo',1,6)
insert into distrito values('Ongón',1,6)
insert into distrito values('Parcoy',1,6)
insert into distrito values('Pataz',1,6)
insert into distrito values('Pias',1,6)
insert into distrito values('Taurija',1,6)
insert into distrito values('Urpay',1,6)
insert into distrito values('Santiago de Challas',1,6)

insert into distrito values('Santiago de Chuco',1,7)
insert into distrito values('Cachicadan',1,7)
insert into distrito values('Mollebamba',1,7)
insert into distrito values('Mollepata',1,7)
insert into distrito values('Quiruvilca',1,7)
insert into distrito values('Santa Cruz de Chuca',1,7)
insert into distrito values('Sitabamba',1,7)
insert into distrito values('Angasmarca',1,7)

insert into distrito values('Ascope',1,8)
insert into distrito values('Chicama',1,8)
insert into distrito values('Chocope',1,8)
insert into distrito values('Santiago de Cao',1,8)
insert into distrito values('Magdalena de Cao',1,8)
insert into distrito values('Paiján',1,8)
insert into distrito values('Rázuri',1,8)
insert into distrito values('Casa Grande',1,8)

insert into distrito values('Chepén',1,9)
insert into distrito values('Pacanga',1,9)
insert into distrito values('Pueblo Nuevo',1,9)

insert into distrito values('Julcán',1,10)
insert into distrito values('Carabamba',1,10)
insert into distrito values('Calamarca',1,10)
insert into distrito values('Huaso',1,10)

insert into distrito values('Cascas',1,11)
insert into distrito values('Lucma',1,11)
insert into distrito values('Marmot',1,11)
insert into distrito values('Sayapullo',1,11)

insert into distrito values('Virú',1,12)
insert into distrito values('Chao',1,12)
insert into distrito values('Guadalupito',1,12)

select * from distrito


----------------------------------llenaar sector: 500 datos---------------------------------------------------------------


select * from sector
select * from provincia
select * from departamento
select * from distrito
select * from sector

truncate table sector

declare @i int,
@max_dis int,@min_dis int

set @i=1
set @max_dis=84
set @min_dis=1

while @i<500
begin
	insert into sector(Descripcion,Estado,IdDistrito)
	values(('SECTOR '+CAST(@i as varchar)),1,ROUND(((@max_dis - @min_dis -1) * RAND() + @min_dis), 0))
	set @i=@i+1
end

insert into SECTOR(Descripcion,Estado,IdDistrito) values('SECTOR 500',1,1)

select * from sector

-----------------------------llenar tipo_cliente: 3 datos -----------------------------------------

insert into tipo_cliente(descripcion,estado) values('Comercial',1)
insert into tipo_cliente(descripcion,estado) values('Residencial',1)
insert into tipo_cliente(descripcion,estado) values('Empresa',1)

select * from tipo_cliente

-------------------------------------llenar cliente: 2 000 000 datos-----------------------------------------

use Reniec
go

select * from reniec

use HidrandinaOLTP_VF

select * from sector

select top 2000000 * from reniec

merge HidrandinaOLTP_VF.dbo.Cliente as dim using(
	select top 2000000 ape_pate,ape_mate,nombre,dni,fech_nac
	from reniec
) as oltp
on oltp.dni=dim.dni collate Modern_Spanish_CI_AS
when not matched then 
insert(ApellidoPaterno,ApellidoMaterno,Nombres,Dni,FechaNacimiento,IdSector,IdTipoCliente)
values(ape_pate,ape_mate,nombre,dni,fech_nac,1,ROUND(((4 - 1 -1) * RAND() + 1), 0));
go

select * from cliente

declare @i int,
@max_dis int,@min_dis int

set @i=1
set @max_dis=500
set @min_dis=1

while @i<2000000 
begin
	update cliente set IdSector=ROUND(((@max_dis - @min_dis -1) * RAND() + @min_dis), 0),
						IdTipoCliente=ROUND(((4 - 1 -1) * RAND() + 1), 0)
	where IdCliente=@i
	set @i=@i+1
end


use HidrandinaOLTP_VF
go

select * from cliente


----------------------------------------llenado de factura 200 000 datos----------------------------------------

delete from factura
truncate table factura

declare @i int, @startdate datetime,@lim_cliente int,@down_cliente int,@lim_personal int,
	@low_fecha int=1,@up_fecha int=30,@rand_fecha int,
	@low_monto int=250,@up_monto int=5000,@rand_monto int
set @i=1
set @startdate='2001-01-01 12:00:00'
set @lim_personal=200
set @lim_cliente=2000000
set @down_cliente=1

--truncate table factura

while @i<=16800 --	X=EMITIDAS:157500 (30)	P=PENDIENTE:25700 (15)	 A=ANULADAS:16800 (5)
begin
	insert into factura(FechaEmision,FechaVencimiento, FechaReparto,
	IdCliente,EstadoDocumento,Observaciones,MontoTotal,NroRecibo,MontoMeta)
	values(dateadd(day,cast(round(@i/30,0) as int),@startdate),
		dateadd(day,cast(round(@i/30,0) as int)+ROUND(((@up_fecha - @low_fecha -1) * RAND() + @low_fecha), 0),@startdate),
		dateadd(day,cast(round(@i/30,0) as int)+ROUND(((@up_fecha - @low_fecha -1) * RAND() + @low_fecha), 0),@startdate),
		ROUND(((@lim_cliente -2) * RAND() + @down_cliente), 0),
		'A',null,0,null,1500000)
	set @i=@i+1
end

select * from factura

------------------------------------ llenado tipo_concepto: 4 datos -------------------------------------

insert into tipo_concepto(descripcion,estado) values('Cargos',1)
insert into tipo_concepto(descripcion,estado) values('Servicios',1)
insert into tipo_concepto(descripcion,estado) values('Intereses',1)
insert into tipo_concepto(descripcion,estado) values('Mantenimiento',1)

select * from tipo_concepto

------------------------------- llenado concepto: 6 datos -----------------------------------------------

insert into concepto(descripcion,estado,idTipoConcepto) values('Cargos Fijos',1,1)
insert into concepto(descripcion,estado,idTipoConcepto) values('Cargos Variados',1,1)
insert into concepto(descripcion,estado,idTipoConcepto) values('Alumbrado Público',1,2)
insert into concepto(descripcion,estado,idTipoConcepto) values('Energia Electrica',1,2)
insert into concepto(descripcion,estado,idTipoConcepto) values('Intereses Compensatorios',1,3)
insert into concepto(descripcion,estado,idTipoConcepto) values('Mantenimiento y Reposicion de Conexion',1,4)

select * from concepto

------------------------------- llenado parametro: 5 datos -----------------------------------------------
	
insert into parametro(descripcion,porcentaje,estado) values('IGV',18,1)
insert into parametro(descripcion,porcentaje,estado) values('Impuesto de Renta',18,1)
insert into parametro(descripcion,porcentaje,estado) values('ISC',8,1)
insert into parametro(descripcion,porcentaje,estado) values('Impuesto Importacion',11,1)
insert into parametro(descripcion,porcentaje,estado) values('Interes Moratorio',1.5,1)

select * from parametro

------------------------------ llenado tipo_consumo: 2 datos  -----------------------------------------------

insert into tipo_consumo(TipoConexion,OpcionTarifaria,CostoConsumoKW,ConsumoEstandar) 
values('Monofasica-Aerea','BT5B-Res',0.03,53.17)

insert into tipo_consumo(TipoConexion,OpcionTarifaria,CostoConsumoKW,ConsumoEstandar) 
values('Trifasica-Aerea','CCV8B',0.07,96.57)

select * from tipo_consumo

------------------------------ llenado tarifa: 6 datos -----------------------------------------------

insert into tarifa(IdTipoCliente,IdTipoConsumo,Tarifa,Estado) values(1,1,0.043,1)
insert into tarifa(IdTipoCliente,IdTipoConsumo,Tarifa,Estado) values(1,2,0.079,1)
insert into tarifa(IdTipoCliente,IdTipoConsumo,Tarifa,Estado) values(2,1,0.022,1)
insert into tarifa(IdTipoCliente,IdTipoConsumo,Tarifa,Estado) values(2,2,0.031,1)
insert into tarifa(IdTipoCliente,IdTipoConsumo,Tarifa,Estado) values(3,1,0.096,1)
insert into tarifa(IdTipoCliente,IdTipoConsumo,Tarifa,Estado) values(3,2,0.013,1)

select * from tarifa

------------------------ llenado medidor: 7 datos --------------------------------------------

insert into medidor(descripcion,tension,nrohilos) values('Medidor de Luz Electronico Monofasico',4,2)
insert into medidor(descripcion,tension,nrohilos) values('Medidor Monofasico Para Casa y Oficina',2,2)
insert into medidor(descripcion,tension,nrohilos) values('Medidor Electrico Stronger Monofasico',6,1)
insert into medidor(descripcion,tension,nrohilos) values('Medidor de Luz Interno Analogico Stronger',3,2)
insert into medidor(descripcion,tension,nrohilos) values('Medidor de Luz Iterno Digital Lux',3,2)
insert into medidor(descripcion,tension,nrohilos) values('Medidor de Luz Siemmens Digital',2,3)
insert into medidor(descripcion,tension,nrohilos) values('Medidor ded Luz Trifasico ElectroLux',1,3)

select * from medidor

--------------------------llenado de personal--------------------------

-- SUCURSAL

INSERT INTO [dbo].[SUCURSAL]([Descripcion],[Estado]) VALUES  ('Hidrandina Tujillo X',1);

select * from sucursal


-- AREA
INSERT INTO [dbo].[AREA]([Descripcion],[IdSucursal],[Estado]) VALUES  ('COBRANZAS',1,1);

select * from area


-- TIPO CARGO
INSERT INTO [dbo].[TIPO_CARGO] ([Descripcion],[Estado],[IdArea])VALUES ('ASISTENTE', 1, 1);
INSERT INTO [dbo].[TIPO_CARGO] ([Descripcion],[Estado],[IdArea])VALUES ('AUXILIAR', 1, 1);

select * from tipo_cargo

-- CARGO
INSERT INTO [dbo].[CARGO]([Descripcion] ,[Estado],[IdTipoCargo]) VALUES ('Asistente de Cobranzas', 1, 1);
INSERT INTO [dbo].[CARGO]([Descripcion] ,[Estado],[IdTipoCargo]) VALUES ('Asistente de Facturación', 1, 1);
INSERT INTO [dbo].[CARGO]([Descripcion] ,[Estado],[IdTipoCargo]) VALUES ('Asistente de Caja', 1, 1);
INSERT INTO [dbo].[CARGO]([Descripcion] ,[Estado],[IdTipoCargo]) VALUES ('Asistente de Recaudación', 1, 1);
INSERT INTO [dbo].[CARGO]([Descripcion] ,[Estado],[IdTipoCargo]) VALUES ('Asistente de Caja', 1, 1);

INSERT INTO [dbo].[CARGO]([Descripcion] ,[Estado],[IdTipoCargo]) VALUES ('Auxiliar de Cobranzas', 1, 2);
INSERT INTO [dbo].[CARGO]([Descripcion] ,[Estado],[IdTipoCargo]) VALUES ('Auxiliar de Facturación', 1, 2);
INSERT INTO [dbo].[CARGO]([Descripcion] ,[Estado],[IdTipoCargo]) VALUES ('Auxiliar de Caja', 1, 2);

select * from cargo

-- PERSONAL 200
INSERT INTO PERSONAL([ApellidoPaterno],[ApellidoMaterno],[Nombres],[Dni],[FechaIngreso],[CuotaFacturas],[TasaMinCobranza],[Salario],[IdCargo]) VALUES('Jenkins','Barber','Mannix',53795292,'02-12-15',42,5911,1720,7),('Acosta','Heath','Bertha',76363177,'07-01-15',97,7345,1655,2),('Meyer','Johnson','Ira',82506659,'01-01-16',82,5195,1807,7),('Pitts','Livingston','Logan',11587567,'02-02-15',37,9518,1846,4),('Atkinson','Boyle','Erasmus',45952477,'01-15-16',30,8181,1637,2),('Pugh','Larsen','Sybil',30127145,'04-22-16',80,5656,1656,7),('Hickman','Waller','Noble',12718295,'09-26-16',18,5575,1608,2),('Thornton','Fuller','Gage',60137904,'10-04-15',66,7651,1549,5),('Kline','Oconnor','Mariam',17397254,'01-14-15',92,8499,1622,1),('Barr','Cummings','Mariam',84155801,'04-27-16',18,8024,1552,2);
INSERT INTO PERSONAL([ApellidoPaterno],[ApellidoMaterno],[Nombres],[Dni],[FechaIngreso],[CuotaFacturas],[TasaMinCobranza],[Salario],[IdCargo]) VALUES('Wiggins','Porter','MacKenzie',73629507,'04-02-16',64,5434,1638,3),('Chase','Campbell','Emerald',42185929,'03-29-15',58,8590,1929,7),('Allen','Owens','Shay',13839179,'01-08-16',33,5355,1641,5),('Price','Velez','Mason',80099148,'03-07-16',23,9122,1833,5),('Winters','Mullins','Blair',43984928,'03-07-15',68,8893,1516,1),('Callahan','Miles','Laurel',34083574,'07-12-15',70,9068,1654,7),('Walker','Juarez','Ocean',13502496,'03-08-16',18,6809,1671,1),('Richardson','Vazquez','Dillon',38424804,'06-03-16',89,5815,1507,1),('Cooke','English','Shelly',23723159,'07-01-15',28,8709,1785,7),('Christian','Crane','Jarrod',83076102,'05-17-15',93,5320,1535,6);
INSERT INTO PERSONAL([ApellidoPaterno],[ApellidoMaterno],[Nombres],[Dni],[FechaIngreso],[CuotaFacturas],[TasaMinCobranza],[Salario],[IdCargo]) VALUES('Palmer','Gould','Renee',56908629,'08-23-16',14,9828,1526,2),('Case','Graham','Omar',31269414,'10-21-15',25,5896,1671,4),('Chaney','Ellison','Idola',32237598,'07-21-15',58,9047,1673,4),('Buchanan','Robinson','Oprah',27807191,'05-09-15',7,8116,1890,6),('Oliver','Lucas','Lev',65215506,'01-10-16',60,5659,1809,4),('Guerrero','Kirk','Caryn',47364383,'05-01-16',70,8727,1546,5),('Atkinson','Bell','Gregory',13533927,'09-15-15',21,5889,1500,6),('Powers','Abbott','Kuame',12932309,'12-30-14',12,6264,1526,5),('Spence','Gill','Hamilton',42936070,'02-05-16',33,7134,1895,4),('Bartlett','Scott','Emery',43462277,'08-16-15',27,9226,1982,3);
INSERT INTO PERSONAL([ApellidoPaterno],[ApellidoMaterno],[Nombres],[Dni],[FechaIngreso],[CuotaFacturas],[TasaMinCobranza],[Salario],[IdCargo]) VALUES('Graham','Daniels','Vance',85411029,'10-03-16',56,6288,1999,2),('Mcconnell','Barnes','Kennedy',67384019,'04-30-15',61,7600,1542,5),('Buckner','Carr','Veda',45147398,'10-02-15',78,8131,1659,5),('Blake','Landry','Gisela',21169736,'02-22-16',11,8387,1999,7),('Pacheco','Valencia','Imelda',38796777,'11-10-14',36,5073,1787,1),('Wallace','Mejia','Bert',10427032,'01-13-16',86,8048,1940,3),('Robles','Giles','Derek',33905360,'09-15-16',34,8747,1818,4),('Bass','Benton','Brandon',50984503,'03-19-16',34,9752,1980,6),('Cruz','Barton','Bertha',83960889,'12-21-14',32,5901,1777,3),('Cabrera','Oneill','Jena',18348649,'12-10-15',22,7055,1945,2);
INSERT INTO PERSONAL([ApellidoPaterno],[ApellidoMaterno],[Nombres],[Dni],[FechaIngreso],[CuotaFacturas],[TasaMinCobranza],[Salario],[IdCargo]) VALUES('Acevedo','Brewer','Rebekah',63190102,'06-02-16',48,9413,1677,6),('Michael','Pierce','Virginia',53653371,'08-15-16',25,8159,1549,2),('Bullock','Sharp','Nola',59981557,'02-05-16',36,5484,1575,5),('Hughes','Williamson','Laith',80618703,'05-10-16',13,8124,1772,1),('Black','Norris','Burton',68916867,'03-08-15',36,5412,1676,1),('Taylor','Best','Gretchen',16620317,'10-11-15',54,5725,1842,5),('Huff','Dillon','Marcia',68989215,'11-16-14',41,7357,1922,4),('Suarez','Gilbert','Maris',34136850,'12-05-15',19,8385,1771,4),('Franks','Brown','Leila',85304104,'07-12-16',27,9885,1548,3),('Summers','Cabrera','Buckminster',52212203,'11-13-15',79,9554,1523,1);
INSERT INTO PERSONAL([ApellidoPaterno],[ApellidoMaterno],[Nombres],[Dni],[FechaIngreso],[CuotaFacturas],[TasaMinCobranza],[Salario],[IdCargo]) VALUES('Knox','Howell','Lane',73833021,'11-30-14',19,7769,1775,1),('Dixon','Ballard','Xandra',59211150,'07-05-16',17,8161,1664,5),('Paul','Santos','Gisela',10687848,'07-08-16',51,7713,1947,5),('Mccormick','Huber','Keith',80644857,'03-15-16',33,6789,1540,3),('Garrison','Patrick','Kasper',26670321,'03-21-16',82,5914,1538,5),('Ellison','Schmidt','Griffin',70159532,'08-01-16',78,7615,1793,3),('Hicks','Hoover','Kameko',55610315,'03-20-15',18,6470,1872,2),('Velazquez','Villarreal','Clio',35130424,'09-06-15',96,9645,1682,5),('Hayes','Rhodes','Alexander',55324846,'07-19-16',57,5251,1933,7),('Kerr','Clements','Shad',68923209,'09-25-16',35,5291,1711,3);
INSERT INTO PERSONAL([ApellidoPaterno],[ApellidoMaterno],[Nombres],[Dni],[FechaIngreso],[CuotaFacturas],[TasaMinCobranza],[Salario],[IdCargo]) VALUES('Wright','Riddle','Cade',16742842,'09-22-16',50,9705,1964,6),('Campbell','Holcomb','Honorato',30136185,'09-24-15',88,8323,1557,4),('Cantrell','Pitts','Kylie',27855604,'08-01-15',48,5757,1753,2),('Holman','Hewitt','Leandra',46011013,'10-12-16',80,8728,1549,1),('Pena','Garrett','Iliana',37743070,'01-02-16',5,6687,1796,3),('Bell','Williams','Aurelia',76655437,'02-16-15',14,9299,1559,3),('Murray','Sheppard','Shoshana',76010962,'11-04-15',91,7637,1974,5),('Orr','Ryan','Beau',35797828,'05-13-16',43,9146,1650,6),('Bullock','Rowe','Leo',24007297,'10-22-15',57,6700,1995,5),('Phillips','Watkins','Rooney',34231395,'04-04-15',72,7138,1878,5);
INSERT INTO PERSONAL([ApellidoPaterno],[ApellidoMaterno],[Nombres],[Dni],[FechaIngreso],[CuotaFacturas],[TasaMinCobranza],[Salario],[IdCargo]) VALUES('Hudson','Glover','Samson',55721704,'11-04-15',67,8388,1980,2),('Morse','Diaz','Miranda',64798491,'01-27-15',46,9321,1791,7),('Hancock','Koch','Magee',66825782,'03-25-15',71,6184,1864,6),('Francis','Dillon','Simon',18730273,'11-29-15',34,7604,1651,1),('Kline','Barton','Meghan',78416477,'06-22-16',73,8237,1585,5),('Massey','Macdonald','Jarrod',47671450,'12-12-14',69,5152,1755,2),('Rollins','Bryant','Kaden',58967775,'05-28-16',81,7918,1584,7),('Anthony','Franks','Gail',82932223,'07-01-16',50,8559,1856,5),('James','Mclean','Eliana',65635005,'03-05-16',67,7025,1763,1),('Boyle','Durham','Rhona',30119834,'04-17-16',71,9821,1891,7);
INSERT INTO PERSONAL([ApellidoPaterno],[ApellidoMaterno],[Nombres],[Dni],[FechaIngreso],[CuotaFacturas],[TasaMinCobranza],[Salario],[IdCargo]) VALUES('Daniels','Mccullough','Geoffrey',66373984,'10-09-15',82,7655,1898,5),('Hooper','Zimmerman','Naomi',24023144,'07-15-15',5,6145,1912,4),('Ballard','Sullivan','Igor',42450121,'11-28-15',61,8952,1907,5),('Norton','Dejesus','Christen',39911013,'04-24-16',78,6703,1976,6),('Doyle','Sargent','Camden',16567506,'10-15-15',28,5827,1562,4),('Franks','Burris','Dominique',80273807,'07-13-16',47,9476,1782,6),('Bean','Kim','Alana',19634213,'11-14-15',62,5590,1506,4),('Herring','Cash','Lionel',63776505,'09-12-15',25,6239,1624,1),('Hanson','Carey','Moses',59516952,'04-27-16',26,6303,1841,3),('Shepard','Nielsen','Wynter',27760682,'06-13-16',44,7040,1679,3);
INSERT INTO PERSONAL([ApellidoPaterno],[ApellidoMaterno],[Nombres],[Dni],[FechaIngreso],[CuotaFacturas],[TasaMinCobranza],[Salario],[IdCargo]) VALUES('Holcomb','Pate','Aileen',40564918,'04-24-16',31,6394,1807,2),('Bishop','Lindsay','Christian',58016932,'04-21-16',39,6580,1702,4),('Lester','Oneal','Maxine',49142068,'05-02-16',61,8019,1680,4),('Malone','Reid','Evan',69969734,'08-04-16',4,8860,1818,3),('Knowles','Good','Ryan',76489488,'08-07-15',92,7056,1806,6),('Pope','Santiago','Kasper',24182406,'06-30-16',71,6651,1832,2),('Rosa','King','Honorato',41635634,'06-30-15',78,6210,1984,6),('Bates','Atkins','Alan',53951859,'10-15-16',6,7139,1559,7),('Morales','Rowland','Kennedy',47204729,'07-26-16',19,6693,1707,7),('Spears','Schmidt','Abraham',58630845,'02-23-15',49,7494,1621,2);

INSERT INTO PERSONAL([ApellidoPaterno],[ApellidoMaterno],[Nombres],[Dni],[FechaIngreso],[CuotaFacturas],[TasaMinCobranza],[Salario],[IdCargo]) VALUES('Spears','Joyce','Elton',29423168,'2016-04-26 17:20:04',7,6029,1884,7),('Stevens','Johnston','Randall',23898049,'2015-08-09 11:44:30',68,5692,1866,7),('Allison','Lott','Amos',82004216,'2015-10-02 11:30:25',54,9822,1784,8),('Ray','Faulkner','Rogan',43705346,'2016-09-18 19:05:44',56,9414,1600,6),('Jacobson','Curtis','Ima',78121891,'2016-03-08 13:30:09',50,9276,1970,8),('Mccormick','Maynard','Blake',11954716,'2016-07-25 21:27:30',12,7813,1555,7),('Cannon','Wallace','Patience',53726845,'2016-04-17 04:31:36',68,5426,1574,7),('Briggs','Sanders','Kibo',68998469,'2014-10-23 03:45:35',65,5703,1686,5),('Cummings','Fletcher','Seth',41346630,'2016-06-04 13:43:41',21,5165,1614,5),('Clements','Richards','Scarlett',55947570,'2016-08-31 23:48:44',5,6171,1687,8);
INSERT INTO PERSONAL([ApellidoPaterno],[ApellidoMaterno],[Nombres],[Dni],[FechaIngreso],[CuotaFacturas],[TasaMinCobranza],[Salario],[IdCargo]) VALUES('Sosa','Beck','Kimberley',46757466,'2016-02-07 16:09:09',93,8047,1596,5),('Delacruz','Mcfadden','Nita',46943972,'2015-12-22 21:11:17',43,5778,1669,7),('Weber','Mayo','Freya',63503180,'2015-03-30 22:52:48',82,8981,1847,7),('Mullen','Lee','Caryn',79142544,'2015-04-29 01:19:32',52,5613,1723,8),('Christensen','Herring','Raphael',50482387,'2016-09-10 00:56:53',32,9498,1728,5),('Moody','Greer','Penelope',58437213,'2015-04-06 01:53:36',79,7238,1619,8),('Norman','Cardenas','Maile',48336961,'2016-10-08 23:22:35',64,8954,1856,6),('Hatfield','Bender','Giacomo',32854443,'2015-12-03 10:16:44',47,8982,1858,8),('Cherry','Barrett','Hayes',10798242,'2016-04-21 14:53:04',87,8484,1673,6),('Carey','Casey','Ivory',63056603,'2014-12-17 16:34:27',38,9025,1546,7);
INSERT INTO PERSONAL([ApellidoPaterno],[ApellidoMaterno],[Nombres],[Dni],[FechaIngreso],[CuotaFacturas],[TasaMinCobranza],[Salario],[IdCargo]) VALUES('Barnett','Rose','Brenda',47024026,'2015-05-28 03:58:35',19,7107,1726,6),('Mcdowell','Gordon','Prescott',79624328,'2015-11-05 13:58:59',72,9212,1929,7),('Palmer','Shaffer','Erin',20483556,'2015-09-02 05:33:35',39,5072,1806,8),('Bullock','Short','Christian',77137547,'2016-07-11 22:52:30',98,5145,1781,8),('Wheeler','Dillard','Kimberley',72855321,'2015-10-16 02:21:04',24,9442,1564,7),('Higgins','Horn','Rae',73430174,'2016-03-15 03:01:42',70,7865,1982,8),('Stone','Stephenson','Mara',82599259,'2015-07-17 16:10:03',79,8789,1758,7),('Hall','Buckley','Calvin',79235146,'2016-06-17 17:52:58',19,8137,1974,5),('Chaney','Sheppard','Davis',24341721,'2014-11-18 07:43:53',69,6220,1754,8),('Suarez','Crane','Macey',20239446,'2015-06-24 00:15:58',25,6763,1908,5);
INSERT INTO PERSONAL([ApellidoPaterno],[ApellidoMaterno],[Nombres],[Dni],[FechaIngreso],[CuotaFacturas],[TasaMinCobranza],[Salario],[IdCargo]) VALUES('Stone','Baldwin','Arthur',70483650,'2015-05-30 06:14:13',2,8147,1739,8),('Conner','Forbes','Deirdre',33207621,'2014-12-12 06:56:03',10,9423,1547,8),('Pratt','Cantrell','Charles',28102294,'2016-05-16 14:49:45',8,7999,1986,5),('Park','Howard','Karly',55812099,'2015-07-24 14:47:12',31,7661,1978,5),('Fitzgerald','Shannon','Athena',25664534,'2015-10-18 11:39:40',18,6363,1973,6),('Boone','Morton','Kennan',79298220,'2015-06-11 02:31:01',85,6401,1504,7),('Mccall','Harding','Pamela',49578128,'2016-06-03 15:33:13',88,6830,1989,8),('Avila','Fuller','Rachel',61054358,'2015-02-26 01:42:41',51,8064,1670,5),('Hendricks','Santiago','Elaine',81462406,'2016-04-25 16:11:30',36,7790,1696,5),('Gaines','Wooten','Bevis',65054495,'2016-06-08 00:40:08',34,7073,1567,7);
INSERT INTO PERSONAL([ApellidoPaterno],[ApellidoMaterno],[Nombres],[Dni],[FechaIngreso],[CuotaFacturas],[TasaMinCobranza],[Salario],[IdCargo]) VALUES('Bentley','Cote','Kiara',32292701,'2015-02-12 17:55:45',15,8025,1756,8),('Conrad','Holden','Barrett',60089238,'2015-04-01 02:57:36',76,9366,1667,6),('Nolan','Watts','Danielle',31959292,'2015-03-28 13:53:30',74,7604,1934,8),('Duke','Barr','Kennan',29710675,'2016-06-03 09:27:04',47,5209,1780,7),('Norman','Talley','Gregory',12280761,'2015-01-31 18:38:36',54,8530,1594,6),('Navarro','Sweeney','Hashim',23724891,'2015-04-25 16:50:22',79,5935,1873,8),('Slater','Howell','David',72135630,'2015-09-15 14:42:49',65,5912,1969,5),('Potts','Pierce','Daniel',19947971,'2016-06-18 11:23:38',64,7558,1601,5),('Dickerson','Vang','Mercedes',18042566,'2014-12-09 12:09:39',76,9349,1939,5),('Hendricks','Christian','Leigh',22138509,'2015-03-25 10:22:01',78,8980,1995,6);
INSERT INTO PERSONAL([ApellidoPaterno],[ApellidoMaterno],[Nombres],[Dni],[FechaIngreso],[CuotaFacturas],[TasaMinCobranza],[Salario],[IdCargo]) VALUES('Summers','Dudley','Cailin',53524508,'2015-04-29 17:56:16',88,6834,1667,8),('Glenn','Diaz','Arden',81413312,'2016-05-07 18:04:19',84,7627,1799,5),('Mayo','Hampton','Hedy',41796537,'2015-01-16 02:56:49',98,8915,1997,5),('Barnes','Hurley','Bianca',37134621,'2015-03-30 08:21:37',23,9709,1685,6),('Gutierrez','Byrd','Gabriel',29411082,'2016-10-13 05:24:00',95,5772,1680,5),('Hyde','Daniels','Lucy',14956389,'2015-12-15 07:30:14',17,6943,1650,6),('Brock','Ingram','Donovan',52161072,'2014-11-18 18:30:48',81,10000,1998,8),('Best','Newton','Ariana',60951795,'2016-05-03 13:09:02',18,6623,1867,5),('Fletcher','Koch','Whitney',73503841,'2015-09-03 22:13:44',88,9051,1566,5),('Anthony','Murray','Quail',10586906,'2015-04-19 02:18:19',68,6075,1679,8);
INSERT INTO PERSONAL([ApellidoPaterno],[ApellidoMaterno],[Nombres],[Dni],[FechaIngreso],[CuotaFacturas],[TasaMinCobranza],[Salario],[IdCargo]) VALUES('Patterson','Barnes','Fitzgerald',69521322,'2016-03-31 16:27:47',88,9421,1919,8),('Day','Zamora','Shea',32565844,'2015-08-01 22:09:15',29,8441,1800,6),('Roth','Sanders','Britanney',30456826,'2015-05-05 07:55:23',72,8941,1514,8),('Bullock','Castro','Constance',66022682,'2016-04-17 16:38:14',89,9243,1946,8),('Newman','Holcomb','Chase',48390125,'2016-08-29 13:41:18',77,7045,1577,6),('Wagner','Holder','Brittany',27482716,'2016-06-15 05:38:17',82,9894,1987,6),('Gray','Hopkins','Bert',84393290,'2016-01-17 11:21:19',56,6904,1804,7),('Morrison','Moses','Adrian',68853907,'2016-05-28 03:21:44',67,5081,1515,7),('Mccullough','Gilmore','Tanner',63112823,'2016-04-19 18:49:24',59,6521,1960,7),('Maldonado','Cherry','Zachery',57307091,'2016-05-04 04:07:34',37,7515,1880,7);
INSERT INTO PERSONAL([ApellidoPaterno],[ApellidoMaterno],[Nombres],[Dni],[FechaIngreso],[CuotaFacturas],[TasaMinCobranza],[Salario],[IdCargo]) VALUES('Mcpherson','Hicks','Halee',38573006,'2016-07-10 10:16:51',7,9274,1644,6),('Buchanan','Alexander','Benedict',29328062,'2015-10-19 23:05:51',78,7926,1877,5),('Frye','Wilkinson','Winifred',37209250,'2015-06-16 15:36:52',54,8779,1588,7),('Lucas','Ratliff','Britanni',38053175,'2015-08-18 14:11:57',20,5094,1889,5),('Oneal','Morrison','Grace',36555718,'2016-06-06 15:54:29',38,8162,1950,7),('Pugh','Gonzalez','Adena',22249676,'2016-02-04 15:11:40',92,7170,1893,7),('Benjamin','Davenport','Allegra',57461032,'2014-10-31 20:47:03',44,7212,1500,6),('Kramer','Dawson','Mia',16421823,'2015-04-26 03:58:40',69,7713,1962,7),('Huber','Porter','Aubrey',49650116,'2016-05-11 14:39:09',89,5615,1729,6),('Kline','Mann','Kirestin',18402655,'2016-09-30 20:55:40',68,8114,1888,8);
INSERT INTO PERSONAL([ApellidoPaterno],[ApellidoMaterno],[Nombres],[Dni],[FechaIngreso],[CuotaFacturas],[TasaMinCobranza],[Salario],[IdCargo]) VALUES('Giles','Moreno','Maryam',69911316,'2016-10-14 05:37:28',47,8604,1891,5),('Whitaker','Padilla','Noble',24893916,'2016-10-02 04:12:59',53,8694,1606,8),('Morgan','Norton','Denton',42051101,'2015-01-10 04:00:57',10,5686,1598,5),('Dennis','Tate','Hillary',53425512,'2016-08-30 19:41:06',63,7551,1626,5),('Wagner','Serrano','Serena',50134772,'2015-03-13 00:48:39',53,7503,1793,6),('Blair','Stone','Quinlan',40381304,'2016-05-16 09:16:50',35,5255,1707,5),('Reynolds','Gregory','Rylee',67071520,'2015-05-03 11:54:45',97,8781,1633,5),('Olsen','Yang','Anjolie',40740345,'2016-03-02 21:13:07',74,6740,1755,7),('Ortega','Serrano','Amity',27676771,'2015-06-07 15:56:56',70,7097,1660,6),('Owen','Blevins','Eagan',16655288,'2015-12-10 16:23:24',65,9444,1741,6);
INSERT INTO PERSONAL([ApellidoPaterno],[ApellidoMaterno],[Nombres],[Dni],[FechaIngreso],[CuotaFacturas],[TasaMinCobranza],[Salario],[IdCargo]) VALUES('Booker','Buck','Ursula',49757209,'2015-04-19 05:27:25',53,8292,1811,6),('Schmidt','Aguilar','Sybil',73050127,'2014-12-04 03:02:28',19,7584,1891,8),('Dennis','Foreman','Vanna',81068562,'2016-06-21 02:23:34',65,8861,1719,7),('Jacobson','Mcleod','Whitney',61908195,'2016-08-09 21:17:56',57,6520,1675,8),('Byrd','Serrano','Madeson',41935062,'2015-12-24 21:06:52',89,6262,1585,5),('Chang','Serrano','Kay',33969048,'2016-05-27 03:20:06',44,5604,1526,5),('Olson','Petty','Rooney',38021619,'2015-05-01 18:55:28',93,8448,1800,8),('Finch','Burnett','Hayley',25858417,'2016-09-14 12:32:51',40,9218,1504,7),('Mosley','Watts','Dorian',80593969,'2015-04-13 14:42:46',79,7511,1966,6),('Conner','Haynes','Jeanette',52989930,'2014-12-24 06:06:25',55,5202,1651,8);

select * from personal


--------------------------------------------llenado de datos consumo: 200 000 datos ----------------------------------------------------


select * from CONSUMO
select * from FACTURA
go

declare @i int, @startdate datetime,@lim_cliente int,@down_cliente int,@lim_personal int,
	@low_fecha int=1,@up_fecha int=30,@rand_fecha int,
	@low_monto int=250,@up_monto int=10000,@rand_monto int
set @i=1
set @startdate='1999-01-01 12:00:00'
set @lim_cliente=2000000
set @down_cliente=1
declare @client int

while @i<=200000
begin

	set @client=(select idcliente from factura where idfactura=@i)
	insert into consumo(FechaInicio,FechaTermino,Factor,NroClientes,FechaLectura,
		ConsumoKW,IdMedidor,Estado,ConsumoMetaKW,
		IdTipoCliente,IdTipoConsumo,IdCliente)
	values(dateadd(day,cast(round(@i/30,0) as int),@startdate),
		dateadd(day,cast(round(@i/30,0) as int)+ROUND(((@up_fecha - @low_fecha -1) * RAND() + @low_fecha), 0),@startdate),
		ROUND(((4 - 2 -1) * RAND() + 1), 0),
		ROUND(((7 - 2 -1) * RAND() + 1), 0),
		dateadd(day,cast(round(@i/30,0) as int)+ROUND(((@up_fecha - @low_fecha -1) * RAND() + @low_fecha), 0),@startdate),
		ROUND(((6000 - 150 -1) * RAND() + 150), 0),ROUND(((7 - 2 -1) * RAND() + 1), 0),1,6000,
		ROUND(((4 - 1 -1) * RAND() + 1), 0), ROUND(((3 - 1 -1) * RAND() + 1), 0),@client)
	set @i=@i+1
end

--ROUND(((@lim_cliente - 1 -@down_cliente) * RAND() + @down_cliente), 0)
--medio de pago

select * from MEDIO_PAGO

insert into MEDIO_PAGO(Descripcion,estado) values('Efectivo',1);
insert into MEDIO_PAGO(Descripcion,estado) values('Tarjeta de Credito',1);
insert into MEDIO_PAGO(Descripcion,Estado) values('Cheque bancario',1);
go

---------------------------trigger sumarizable FACTURA -> MontoTotal--------------------------------------

create trigger trg_sumMontoTotal
on DETALLE_FACTURA
for insert
as
begin
	update f set f.MontoTotal=f.MontoTotal+i.MontoFacturado
	from inserted i
	inner join FACTURA f
	on f.IdFactura=i.IdFactura 
	where f.IdFactura=i.IdFactura 
end

----------------------------llenada de datos DETALLE_FACTURA: 507 194 datos ---------------------------------------------

--consumo: 1, 200 000
--factura: 1, 200 000

declare @i int=1,
	@low_monto int=250,@up_monto int=5000,@rand_monto int

while @i<=200000
begin
		declare @fac int
		declare @cli int
		declare @con int
		set @fac=@i --supongamos 1 se genero
		set @cli=(select idcliente from factura where idFactura=@fac) --611265
		set @con=(select idconsumo from consumo where idcliente=@cli) --1
		
		--detail nro1
		insert into DETALLE_FACTURA(IdFactura,IdConsumo,MontoFacturado,Estado,IdParametro,IdConcepto,IdCliente)
		values(@fac,@con,ROUND(((@up_monto - @low_monto -1) * RAND() + @low_monto), 0),1,
			ROUND(((5 - 1 -1) * RAND() + 1), 0),ROUND(((5 - 1 -1) * RAND() + 1), 0),@cli)
		--detail nro2
		insert into DETALLE_FACTURA(IdFactura,IdConsumo,MontoFacturado,Estado,IdParametro,IdConcepto,IdCliente)
		values(@fac,@con,ROUND(((@up_monto - @low_monto -1) * RAND() + @low_monto), 0),1,
			ROUND(((5 - 1 -1) * RAND() + 1), 0),ROUND(((5 - 1 -1) * RAND() + 1), 0),@cli)
		--detail nro3
		insert into DETALLE_FACTURA(IdFactura,IdConsumo,MontoFacturado,Estado,IdParametro,IdConcepto,IdCliente)
		values(@fac,@con,ROUND(((@up_monto - @low_monto -1) * RAND() + @low_monto), 0),1,
			ROUND(((5 - 1 -1) * RAND() + 1), 0),ROUND(((6 - 1 -1) * RAND() + 1), 0),@cli)
	set @i=@i+1
end

select * from detalle_factura
GO

----------------------------tabla cobranza----------------------------------------

-- delete from cobranza
--truncate table cobranza
--alter table cobranza alter column EstadoCobranza char(1)
--go

declare @i int,@fecha date,@cobrado decimal(15,2)
set @i=1
while @i<=200000
begin
	set @fecha=(select FechaVencimiento from FACTURA where IdFactura=@i)
	
	if @i%7=0 
	begin
		insert into COBRANZA(Descripcion,FechaCobranza,EstadoCobranza,IdPersonal,IdFactura,MontoCobrado,IdMedioPago)
		values(null,dateadd(month,round(((4-1-1) * rand() + 1), 0),@fecha),
			'M',ROUND(((200 -2) * RAND() + 1), 0),@i,0,ROUND(((8-6) * RAND() + 6), 0))
		set @i=@i+1
	end
	else
		set @cobrado=(select MontoTotal from FACTURA where IdFactura=@i)

		insert into COBRANZA(Descripcion,FechaCobranza,EstadoCobranza,IdPersonal,IdFactura,MontoCobrado,IdMedioPago)
		values(null,datediff(day,round(((4-1-1) * rand() + 1), 0),@fecha),
		'C',ROUND(((200 -2) * RAND() + 1), 0),@i,@cobrado,ROUND(((8-6) * RAND() + 6), 0))
		set @i=@i+1
end

select  * from FACTURA
select * from COBRANZA
select * from MEDIO_PAGO


----------------------------llenado tabla tipo_reclamo -----------------------------------------

insert into TIPO_RECLAMO(Descripcion,Estado) values('Reclamo de Facturación',1)
insert into TIPO_RECLAMO(Descripcion,Estado) values('Reclamo de Medición',1)
insert into TIPO_RECLAMO(Descripcion,Estado) values('Reclamo de Atendimiento',1)
insert into TIPO_RECLAMO(Descripcion,Estado) values('Reclamo de Operación',1)
insert into TIPO_RECLAMO(Descripcion,Estado) values('Reclamo de Demora',1)
insert into TIPO_RECLAMO(Descripcion,Estado) values('Reclamo de Equipo',1)
insert into TIPO_RECLAMO(Descripcion,Estado) values('Reclamo de Suministro',1)
go

select * from TIPO_RECLAMO

------------------------------- llenado tabla reclamo -------------------------------------------

--GRAVEDAD: 
--	1->alto	riesgo		2-> riesgoso		3-> bajo riesgo		4-> inofensivo 
--NIVEL ATENDIMIENTO:
--	1->Experto	 2->Altamente profesional		3->Profesional		4->Técnico

declare @i int,@min_cli int,@max_cli int,@startdate date,
	@min_cost decimal(15,2),@max_cost decimal(15,2)
set @i=1
set @min_cli=1
set @max_cli=2000000
set @min_cost=500
set @max_cost=5000
set @startdate='2000-01-01 12:00:00'

while @i<=1500	
begin
	insert into RECLAMO(IdCliente,IdTipoReclamo,Fecha,Gravedad,NivelAtendimiento,CostoReclamo,Estado)
	values(ROUND(((@max_cli -@min_cli-1) * RAND() + @min_cli), 0),
		ROUND(((7-1) * RAND() + 1), 0),dateadd(day,cast(round(@i*3,0) as int),@startdate),
		ROUND(((4-1) * RAND() + 1), 0),ROUND(((4-1) * RAND() + 1), 0),
		ROUND(((@max_cost-@min_cost) * RAND() + @min_cost), 0),1)
	set @i=@i+1
end

select * from reclamo

declare @iz int
set @iz=1
while @iz<=1500
	if @iz%7=0
	begin
		update reclamo set Estado=0 where IdReclamo=@iz
		set @iz=@iz+1
	end
	else
		set @iz=@iz+1

--------------------------------- llenada de datos tipo_incidencia ---------------------------

insert into TIPO_INCIDENCIA(Descripcion,CostoxHora) values('Averia de Instalaciones',45)
insert into TIPO_INCIDENCIA(Descripcion,CostoxHora) values('Fallo de Equipos',30)
insert into TIPO_INCIDENCIA(Descripcion,CostoxHora) values('Corte de Suministro',60)
insert into TIPO_INCIDENCIA(Descripcion,CostoxHora) values('Apagon General',110)
insert into TIPO_INCIDENCIA(Descripcion,CostoxHora) values('Perdida Comunicaciones',65)

select * from TIPO_INCIDENCIA
go

--------------------------------- llenada de datos incidencia ---------------------

declare @i int,@startdate date,
	@min_cost decimal(15,2),@max_cost decimal(15,2)
set @i=1
set @min_cost=500
set @max_cost=5000
set @startdate='2000-01-01 12:00:00'

while @i<=1750	
begin
	insert into INCIDENCIA(IdTipoIncidencia,FechaInicio,HoraInicio,HoraFin,FechaFin,CostoTotalIncidencia,IdSector)
	values(ROUND(((5-1) * RAND() + 1), 0),dateadd(day,cast(round(@i*3,0) as int),@startdate),
		ROUND(((24-1-1) * RAND() + 1), 0),ROUND(((24-1-1) * RAND() + 1), 0),
		dateadd(day,cast(round(@i*3,0) as int)+ROUND(((3-1) * RAND() + 1), 0),@startdate),
		ROUND(((@max_cost-@min_cost-1) * RAND() + @min_cost), 0),ROUND(((500-1-1) * RAND() + 1), 0))
	set @i=@i+1
end

select * from INCIDENCIA
go

-------------------------------- llenada de datos detalle_incidencia -----------------------------------

--GRAVEDAD: 1-> Riesgo Alto		2-> Riesgo Medio		3-> Riesgo Bajo		4-> Riesgo Nulo

declare @i int,@startdate date, @inc int,
	@min_cost decimal(15,2),@max_cost decimal(15,2)
set @i=1

while @i<=1750	
begin
	set @inc=(select CostoTotalIncidencia from INCIDENCIA where IdIncidencia=@i)

	insert into DETALLE_INCIDENCIA(IdIncidencia,FactorGravedad,Observacion,CostoIncidencia,Estado,Descripcion,PerdidaEnergiaKW,IdSucursal)
	values(@i,ROUND(((4-1) * RAND() + 1), 0),null,@inc,1,null,
		ROUND(((5000-250) * RAND() + 250), 0),1)
	set @i=@i+1
end

select * from DETALLE_INCIDENCIA

declare @iz int
set @iz=1
while @iz<=1750
	if @iz%9=0
	begin
		update DETALLE_INCIDENCIA set Estado=0 where IdIncidencia=@iz
		set @iz=@iz+1
	end
	else
		set @iz=@iz+1

-----------------------------llenada de datos tipo_matto ---------------------------

insert into TIPO_MANTENIMIENTO(Descripcion,Estado) values('Mantenimiento Instalaciones Electricas',1)
insert into TIPO_MANTENIMIENTO(Descripcion,Estado) values('Mantenimiento Equipos Electricos',1)
insert into TIPO_MANTENIMIENTO(Descripcion,Estado) values('Mantenimiento Estacion Central',1)
insert into TIPO_MANTENIMIENTO(Descripcion,Estado) values('Mantenimiento Redes y Transformadores',1)

select * from TIPO_MANTENIMIENTO

---------------------------- llenada de datos fallo -----------------------------------

insert into FALLO(Descripcion,Gravedad) values('Sobrecarga de conductor',3)
insert into FALLO(Descripcion,Gravedad) values('Cortocircuito',2)
insert into FALLO(Descripcion,Gravedad) values('Perdida de aislamiento',1)
insert into FALLO(Descripcion,Gravedad) values('Sobreintensidad',2)
insert into FALLO(Descripcion,Gravedad) values('Sobretensión',2)
insert into FALLO(Descripcion,Gravedad) values('Fallo de Lubricación',1)

select * from FALLO
go

---------------------------- llenada de datos mantenimiento ------------------------------

declare @i int,@startdate date
set @i=1
set @startdate='1998-01-01 12:00:00'

while @i<=2250	
begin
	
	insert into MANTENIMIENTO(IdSector,Fecha,CostoTotal,IdTipoMantenimiento,PresupuestoMtto)
	values(ROUND(((500-1) * RAND() + 1), 0),dateadd(day,cast(round(@i*3,0) as int),@startdate),0,
		ROUND(((4-1) * RAND() + 1), 0),7500)
	set @i=@i+1
end

select * from MANTENIMIENTO
go

------------------------------- llenada datos detalle_mtto --------------------------

create trigger trg_sumMttoTotal
on DETALLE_MTTO
for insert
as
begin
	update m set m.CostoTotal=m.CostoTotal+i.CostoMtto
	from inserted i
	inner join MANTENIMIENTO m
	on m.IdMantenimiento=i.IdMantenimiento
	where m.IdMantenimiento=i.IdMantenimiento 
end


declare @i int
set @i=1

while @i<=2100	
begin
	
	if @i%5=0
	begin
		--detail 1
		insert into DETALLE_MTTO(IdMantenimiento,IdFallo,CostoMtto)
		values(@i,2,ROUND(((1500-250) * RAND() + 250), 0))
		--detail 2
		insert into DETALLE_MTTO(IdMantenimiento,IdFallo,CostoMtto)
		values(@i,4,ROUND(((1500-250) * RAND() + 250), 0)) 
		--detail 3
		insert into DETALLE_MTTO(IdMantenimiento,IdFallo,CostoMtto)
		values(@i,5,ROUND(((1500-250) * RAND() + 250), 0))
		set @i=@i+1
	end

	if @i%3=0
	begin
		--detail 1
		insert into DETALLE_MTTO(IdMantenimiento,IdFallo,CostoMtto)
		values(@i,1,ROUND(((1500-250) * RAND() + 250), 0))
		--detail 2
		insert into DETALLE_MTTO(IdMantenimiento,IdFallo,CostoMtto)
		values(@i,3,ROUND(((1500-250) * RAND() + 250), 0)) 
		--detail 3
		insert into DETALLE_MTTO(IdMantenimiento,IdFallo,CostoMtto)
		values(@i,6,ROUND(((1500-250) * RAND() + 250), 0))
		set @i=@i+1
	end

	else
		--detail 1
		insert into DETALLE_MTTO(IdMantenimiento,IdFallo,CostoMtto)
		values(@i,2,ROUND(((1500-250) * RAND() + 250), 0)) 
		--detail 2
		insert into DETALLE_MTTO(IdMantenimiento,IdFallo,CostoMtto)
		values(@i,5,ROUND(((1500-250) * RAND() + 250), 0))
		set @i=@i+1
end


select * from MANTENIMIENTO
select * from DETALLE_MTTO
go

--VISTA FACTURA_GLOBAL

create view factura_global as
select f.IdFactura as fac,f.FechaEmision,f.FechaVencimiento,f.FechaReparto,f.IdCliente,f.EstadoDocumento,
	df.IdConsumo,df.IdParametro,df.IdConcepto,df.MontoFacturado,f.MontoMeta
from factura f
left join detalle_factura df
on f.IdFactura=df.IdFactura

select * from factura_global
go

create function fn_totalFacturas()
	returns int
as
begin
	declare @x int
	set @x=(select count(distinct gf.fac)
	from factura_global gf)
	return @x
end
go

select HidrandinaOLTP_VF.dbo.fn_totalFacturas() as 'x'
go

create function fn_emitidasFacturas()
	returns int
as
begin
	declare @x int 
	set @x=(select count(distinct gf.fac) 
	from factura_global gf
	group by gf.EstadoDocumento
	having gf.EstadoDocumento='X')
	return @x
end
go

select HidrandinaOLTP_VF.dbo.fn_emitidasFacturas() as 'x'
go

create function fn_pendientesFacturas()
	returns int
as 
begin
	declare @x int 
	set @x=(select count(distinct gf.fac)
	from factura_global gf
	group by gf.EstadoDocumento
	having gf.EstadoDocumento='P')
	return @x
end
go

select HidrandinaOLTP_VF.dbo.fn_pendientesFacturas() as 'X'
go

create function fn_anuladasFacturas()
	returns int
as
begin
	declare @x int
	set @x=(select count(distinct gf.fac)
	from factura_global gf 
	group by gf.EstadoDocumento
	having gf.EstadoDocumento='A')
	return @x
end
go

select HidrandinaOLTP_VF.dbo.fn_anuladasFacturas()
go
