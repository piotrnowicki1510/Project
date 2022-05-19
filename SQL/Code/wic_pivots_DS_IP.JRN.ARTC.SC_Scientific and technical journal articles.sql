--wszystkie kraje, czyli waluta nie pusta
select 
	*
from country c2 
where c2.currencyunit!=''
;

--wszystkie roczniki odczyt�w dla wska�nika "Scientific and technical journal articles"
--do tabeli przestawnej
select distinct  
	i.rocznik  
from indicators i
join country c2 on i.countrycode = c2.countrycode 
where i.indicatorcode='IP.JRN.ARTC.SC' and c2.currencyunit!=''
order by i.rocznik 
;

--skrajne roczniki odczyt�w dla wska�nika "Scientific and technical journal articles"
select distinct 
	first_value (i.rocznik) over() as newrocznik
,	last_value (i.rocznik) over() as oldrocznik
from indicators i
join country c2 on i.countrycode = c2.countrycode 
where i.indicatorcode='IP.JRN.ARTC.SC' and c2.currencyunit!=''
group by i.rocznik
;

--jaki jest naj�wie�szy odczyt wska�nika? 
--wi�kszo�� kraj�w do 2011
select distinct 
	i.countryname 
,	max(i.rocznik) over (partition by i.countryname) as naj_rocznik 
from indicators i
join country c2 on i.countrycode = c2.countrycode 
where i.indicatorcode='IP.JRN.ARTC.SC' and c2.currencyunit!=''
group by i.countryname, i.rocznik
order by i.countryname 
;

--wszystkie odczyty dla wska�nika "Scientific and technical journal articles"
--wszystkie kraje, czyli currency nie r�wna si� ''
select 
	c2.currencyunit
,	i.countryname 
,	i.indicatorcode 
,	i.rocznik
,	i.value 
from indicators i
join country c2 on i.countrycode = c2.countrycode 
where i.indicatorcode='IP.JRN.ARTC.SC' 
	and c2.currencyunit!=''
--	and i.countryname = 'Latvia'
	and i.rocznik = '2011'
order by i.countryname, i.rocznik 
;

--najwy�sze 10 odczyt�w dla wska�nika "Scientific and technical journal articles" dla 2013 roku
--tylko kraje, czyli currency nie r�wna si� ''
select 
	c2.currencyunit
,	i.countryname 
,	i.indicatorcode 
,	i.rocznik
,	i.value 
from indicators i
join country c2 on i.countrycode = c2.countrycode 
where i.indicatorcode='IP.JRN.ARTC.SC' 
	and c2.currencyunit!=''
--	and i.countryname = 'Latvia'
	and i.rocznik = '2011'
order by i.value desc
limit 10
;

--najwy�sze 10 odczyt�w dla wska�nika "Scientific and technical journal articles" dla 2011 roku
--same nazwy kraj�w
select 
	i.countryname 
from indicators i
join country c2 on i.countrycode = c2.countrycode 
where i.indicatorcode='IP.JRN.ARTC.SC' 
	and c2.currencyunit!=''
	and i.rocznik = '2011'
order by i.value desc
limit 10
;

--dane dla kraj�w top 10
--w odst�pach co 5 lat (2011, 2006, 2001, 1996)

with krajetop as
(
select 
	i.countryname as kraj 
,	i.indicatorcode 
,	i.value 
,	dense_rank() over (order by i.value desc)
from indicators i
join country c2 on i.countrycode = c2.countrycode 
where i.indicatorcode='IP.JRN.ARTC.SC' 
	and c2.currencyunit!=''
	and i.rocznik = '2011'
--	and i.countryname in ('Austria', 'Denmark')
order by i.value desc
limit 10
)
select
	kt.kraj
,	(select i2.value 
	from indicators i2
	join country c2 on i2.countrycode = c2.countrycode 
	where i2.indicatorcode='IP.JRN.ARTC.SC' 
	and c2.currencyunit!=''
	and i2.rocznik = '2011'
--	and i2.value notnull
	and i2.countryname=kt.kraj) 
	/
	(select i2.value 
	from indicators i2
	join country c2 on i2.countrycode = c2.countrycode 
	where i2.indicatorcode='IP.JRN.ARTC.SC' 
	and c2.currencyunit!=''
	and i2.rocznik = '2001'
--	and i2.value notnull
	and i2.countryname=kt.kraj) as trend_2011_vs_2001
,	(select i2.value 
	from indicators i2
	join country c2 on i2.countrycode = c2.countrycode 
	where i2.indicatorcode='IP.JRN.ARTC.SC' 
	and c2.currencyunit!=''
	and i2.rocznik = '2011'
	and i2.countryname=kt.kraj) as value2011
,	(select i2.value 
	from indicators i2
	join country c2 on i2.countrycode = c2.countrycode 
	where i2.indicatorcode='IP.JRN.ARTC.SC' 
	and c2.currencyunit!=''
	and i2.rocznik = '2006'
	and i2.countryname=kt.kraj) as value2006
,	(select i2.value 
	from indicators i2
	join country c2 on i2.countrycode = c2.countrycode 
	where i2.indicatorcode='IP.JRN.ARTC.SC' 
	and c2.currencyunit!=''
	and i2.rocznik = '2001'
	and i2.countryname=kt.kraj) as value2001
,	(select i2.value 
	from indicators i2
	join country c2 on i2.countrycode = c2.countrycode 
	where i2.indicatorcode='IP.JRN.ARTC.SC' 
	and c2.currencyunit!=''
	and i2.rocznik = '1996'
	and i2.countryname=kt.kraj) as value1996
from krajetop kt
order by 2 desc
;
/*wniosek: w�r�d kraj�w, kt�re maj� komplet odczyt�w w latach 2001-2011
najwi�cej artyku��w naukowych odnotowa�y kraje:
China
Korea, Rep.
India
Spain
Australia
*/


--najni�sze odczyty dla wska�nika "Scientific and technical journal articles" dla 2011 roku
--wszystkie kraje, czyli currency nie r�wna si� ''
select 
	c2.currencyunit
,	i.countryname 
,	i.indicatorcode 
,	i.rocznik
,	i.value 
from indicators i
join country c2 on i.countrycode = c2.countrycode 
where i.indicatorcode='IP.JRN.ARTC.SC' 
	and c2.currencyunit!=''
--	and i.countryname = 'Latvia'
	and i.rocznik = '2011'
order by i.value asc
limit 10
;

--najni�sze 10 odczyt�w dla wska�nika "Scientific and technical journal articles" dla 2011 roku
--same nazwy kraj�w
select 
	i.countryname 
from indicators i
join country c2 on i.countrycode = c2.countrycode 
where i.indicatorcode='IP.JRN.ARTC.SC' 
	and c2.currencyunit!=''
	and i.rocznik = '2011'
order by i.value asc
limit 10
;

--dane dla kraj�w bottom 10
--w odst�pach co 5 lat (2011, 2006, 2001, 1996)

with krajebottom as
(
select 
	i.countryname as kraj 
,	i.value 
from indicators i
join country c2 on i.countrycode = c2.countrycode 
where i.indicatorcode='IP.JRN.ARTC.SC' 
	and c2.currencyunit!=''
	and i.rocznik = '2011'
order by i.value asc
limit 10
)
select
	kb.kraj
,	(select i2.value 
	from indicators i2
	join country c2 on i2.countrycode = c2.countrycode 
	where i2.indicatorcode='IP.JRN.ARTC.SC' 
	and c2.currencyunit!=''
	and i2.rocznik = '2011'
	and i2.countryname=kb.kraj) as value2011
,	(select i2.value 
	from indicators i2
	join country c2 on i2.countrycode = c2.countrycode 
	where i2.indicatorcode='IP.JRN.ARTC.SC' 
	and c2.currencyunit!=''
	and i2.rocznik = '2006'
	and i2.countryname=kb.kraj) as value2006
,	(select i2.value 
	from indicators i2
	join country c2 on i2.countrycode = c2.countrycode 
	where i2.indicatorcode='IP.JRN.ARTC.SC' 
	and c2.currencyunit!=''
	and i2.rocznik = '2001'
	and i2.countryname=kb.kraj) as value2001
,	(select i2.value 
	from indicators i2
	join country c2 on i2.countrycode = c2.countrycode 
	where i2.indicatorcode='IP.JRN.ARTC.SC' 
	and c2.currencyunit!=''
	and i2.rocznik = '1996'
	and i2.countryname=kb.kraj) as value1996
from krajebottom kb
where (select i2.value 
	from indicators i2
	join country c2 on i2.countrycode = c2.countrycode 
	where i2.indicatorcode='IP.JRN.ARTC.SC' 
	and c2.currencyunit!=''
	and i2.rocznik = '1996'
--	and i2.value notnull
	and i2.countryname=kb.kraj) notnull
;

/*wniosek: w�r�d kraj�w, kt�re maj� komplet odczyt�w w latach 2001-2011
najmniej artykul�w naukowych opublikowano w krajach:
Kiribati
Samoa
St. Vincent and the Grenadines
Tuvalu
Antigua and Barbuda
*/


-- tabela przestawna dla 5 wiod�cych kraj�w
drop view v_danetop5_art;

create view v_Artic_top5 as
select 
	i.countryname as kraj
,	i.rocznik  as rocznik
,	i.value as wartosc
from indicators i 
where i.indicatorcode='IP.JRN.ARTC.SC' 
	and i.countryname in ('China', 'Korea, Rep.', 'India', 'Spain', 'Australia')
	and (i.rocznik)::numeric between 2000 and 2010
;

create view v_Artic_top5_pivot as
select *
from crosstab
(
'select 
	t5.kraj::text
,	t5.rocznik::numeric
,	t5.wartosc::numeric
from v_Artic_top5 t5 
'
)
as kraj_rocznikowo
(
	   "kraj"  text
,      "2000"  numeric
,      "2001"  numeric
,      "2002"  numeric
,      "2003"  numeric
,      "2004"  numeric
,      "2005"  numeric
,      "2006"  numeric
,      "2007"  numeric
,      "2008"  numeric
,      "2009"  numeric
,      "2010"  numeric
)
;

--�rednia liczba art naukowych w grupie 5 dominuj�cych pa�stw
with dane_top5 as
(
select 
	i.countryname as kraj
,	i.rocznik  as rocznik
,	i.value as wartosc
from indicators i 
where i.indicatorcode='IP.JRN.ARTC.SC' 
	and i.countryname in ('China', 'Korea, Rep.', 'India', 'Spain', 'Australia')
	and (i.rocznik)::numeric between 2001 and 2011
)
select
	dane_top5.rocznik
,	avg(dane_top5.wartosc) as srednia_akt
,	lag(avg(dane_top5.wartosc)) over() as srednia_old
from dane_top5
group by dane_top5.rocznik
;


--Tworz� widok z 10 krajami o najwi�kszj liczbie artyku��w w 2010 roku

drop view  v_Art_top10;

create view v_Art_top10 as
select 
	c2.currencyunit as waluta
,	i.countryname as kraj
,	i.indicatorcode as wskaznik 
,	i.rocznik as rocznik
,	i.value as articles
,	dense_rank() over (order by i.value desc) as ranking 
from indicators i
join country c2 on i.countrycode = c2.countrycode 
where i.indicatorcode='IP.JRN.ARTC.SC' 
	and c2.currencyunit!=''
	and i.rocznik = '2010'
--	and i.countryname not in ('Australia')
order by i.value desc
limit 10
;

-- Zestawiam dane za 2003-2010 dla najlepszych 10 kraj�w z v_RandD_top10
drop view  v_Art_top10_dane;

create view v_Art_top10_dane as
select 
	t10.ranking as ranking
,	i2.countryname as kraj 
,	i2.indicatorcode as wskaznik
,	i2.rocznik as rocznik
,	i2.value as articles
from indicators i2 
join v_Art_top10 t10 on t10.kraj = i2.countryname
where i2.indicatorcode ='IP.JRN.ARTC.SC' 
	and i2.rocznik ::numeric between 2000 and 2010
order by 1, 4
;

--Tworz� tabel� przestawn� dla v_Art_top10_dane

select *
from crosstab
(
'select 
	t10.kraj::text
,	t10.rocznik::numeric
,	t10.articles::numeric
from v_Art_top10_dane t10 
'
)
as kraj_rocznikowo
(
	   "kraj"  text
,      "2000"  numeric
,      "2001"  numeric
,      "2002"  numeric
,      "2003"  numeric
,      "2004"  numeric
,      "2005"  numeric
,      "2006"  numeric
,      "2007"  numeric
,      "2008"  numeric
,      "2009"  numeric
,      "2010"  numeric
)
;


