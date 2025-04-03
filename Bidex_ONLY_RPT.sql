SET nocount on
GO

delete scl_kill_bib2
go
delete md_disk2
go

/*
-- CHANGING TO BIB REFERENCE 
insert md_disk2
select distinct c.bib#
from auth a,  bib_auth c
where
a.auth# = c.auth#
and
a.tag = '040'
and
a.text like '%qlsp%'
go
*/

insert md_disk2
select distinct bib#
from BIB
where
 tag LIKE '6%'
and
( (text like '%qlsp%') or (text like '%bidex%') )
go

/*
-- CHANGING TO BIB REFERENCE 
insert md_disk2
select distinct c.bib#
from auth a,  bib_auth c
where
a.auth# = c.auth#
and
a.tag = '040'
and
a.text like '%bidex%'
go
*/

-- insert md_disk2
-- select distinct bib#
-- FROM bib
-- WHERE
-- tag LIKE '6%' 
-- AND 
-- text like '%bidex%'
-- go


insert scl_kill_bib2

select c.bib#
from 
bib_control c, bib b, bib d
WHERE
b.bib# IN (SELECT bib# FROM md_disk)
and
b.bib# = c.bib#
and
c.bib# = d.bib#
and
c.status = 'unp'
and
b.tag ='008'
and
substring (b.text,36,3) = 'spa'
and
d.tag = '001'
and
d.text like 'o%'
and
c.bib# NOT IN (select bib# from md_disk2)
go


select m.bib#,substring (b.text,1,50) AS '''001', n.text AS '''040', c.text AS '''245'
from scl_kill_bib2 m, bib b, bib c

left join bib n
on (c.bib# = n.bib# and n.tag = '040')

where
m.bib# = b.bib#
and
c.bib# = b.bib#
and
b.tag = '001'
and
c.tag = '245'

SET nocount off
GO
