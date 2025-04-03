SET nocount on
GO


DELETE md_disk2
GO
INSERT md_disk2
SELECT bib# FROM bib_control WHERE status = 'unp'
go

select 	i.bib#, 
			b.text AS '''001',
			n.text AS '''040',
			t.text AS '''245', 
			i.location,i.ibarcode,i.collection

from item i

RIGHT JOIN bib b
ON (i.bib# = b.bib#)

LEFT JOIN bib t
ON (i.bib# = t.bib# AND t.tag = '245')

left join bib n
on (i.bib# = n.bib# and n.tag = '040')

where

b.bib# = t.bib#
and
b.tag = '001'
and
b.text like 'o%'
AND
i.bib# IN (SELECT bib# FROM md_disk2)																	   
--datediff(dd,'1 jan 70',getdate()) - i.creation_date <= 30
AND
i.location in ('mvan','cent','clov','fore','ext','guer',
	'heal','nort','occi','peta','rinc',
	'rohn','rose','seba','sono','misc','wind','znbc')

order by location,i.bib#

SET nocount off
GO
