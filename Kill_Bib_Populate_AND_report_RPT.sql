SET NOCOUNT ON
GO


-- /* 
-- SET DATE BACK 3 MONTHS  in ALL 3 PLACES
--  */

-- *************************************************************************
-- use a temp table to store BASE SQL. #scl_base
-- Much more efficient and faster query


DECLARE @Jan1970 datetime = '1 Jan 1970';
DECLARE @FirstDay3MonthsPrior datetime;
SELECT @FirstDay3MonthsPrior = DATEADD(mm, DATEDIFF(m,0, getdate())-3,0) ;   

SELECT bib# INTO #scl_base FROM 
 bib_control
WHERE
	bib# NOT IN (select bib# from item) AND
	bib# NOT IN  (select bib# from bib where tag = '907') AND
	create_date < datediff(dd,@Jan1970, @FirstDay3MonthsPrior);
-- *************************************************************************

-- -- 1st sql
-- INSERT INTO scl_kill_bib
-- 	select bib#
-- 	from  #scl_base
-- 	where bib# not in (select bib# from copy)

-- GO

-- -- 2nd sql 
-- INSERT INTO scl_kill_bib
-- 	select bib#
-- 	from #scl_base
-- 	where bib# in (select bib# from bib where tag = '910' and text like '%CIP upgrade 2009-04%')
-- GO

-- -- 3rd sql
-- INSERT INTO scl_kill_bib
-- 	select bib#
-- 	from #scl_base
-- 	where bib# IN (SELECT bib# FROM title WHERE processed like '%illx%')

GO

delete from scl_kill_bib
go

-- COMBINED 3 SQL INTO 1
INSERT INTO scl_kill_bib
	select distinct bib#
	from  #scl_base
	where 
		( bib# not in (select bib# from copy) ) OR   -- sql #1
		( bib# in (select bib# from bib where tag = '910' and text like '%CIP upgrade 2009-04%') ) OR  -- sql #2
		( bib# IN (SELECT bib# FROM title WHERE processed like '%illx%') ) -- sql #3

GO
-- *************************************************************************
-- Original QUERIES
--

-- insert into scl_kill_bib
-- 	select count(bib#)
-- 	from bib_control
-- 	where 
-- 	create_date < datediff(dd,@Jan1970, @FirstDay3MonthsPrior)
-- 	and
-- 	bib# not in (select bib# from item)
-- 	and
-- 	bib# not in (select bib# from copy)
-- 	and 
-- 	bib# NOT IN  (select bib# from bib where tag = '907')
-- 	;


-- insert into scl_kill_bib
-- 	select bib#
-- 	from bib_control
-- 	where 
-- 	create_date < datediff(dd, @Jan1970, @FirstDay3MonthsPrior)
-- 	and
-- 	bib# not in (select bib# from item)
-- 	and
-- 	bib# in (select bib# from bib where tag = '910' and text like '%CIP upgrade 2009-04%')
-- 	and 
-- 	bib# NOT IN  (select bib# from bib where tag = '907')
-- 	;

--  insert scl_kill_bib
-- 	select bib#
-- 	from bib_control 
-- 	where 
-- 	create_date < datediff(dd,@Jan1970, @FirstDay3MonthsPrior)
-- 	and
-- 	bib# IN (SELECT bib# FROM title WHERE processed like '%illx%')
-- 	and
-- 	bib# NOT IN (select bib# from item)
-- 	and 
-- 	bib# NOT IN  (select bib# from bib where tag = '907')
-- 	GO
-- *************************************************************************


select 
	k.bib#, 
	substring(bbb.text,1,30) as '''000', 
	substring(e.text,1,30) as '''001', 
	substring(b.text,1,30) as '''010',  
	substring(bb.text,1,30) as '''020' ,
	 substring(h.text,1,50) as '''040', 
	 v.text AS '''245',
	substring(f.text,1,50) as '''856', 
	g.longtext as '856long'
from scl_kill_bib k

left join bib e
on
k.bib# = e.bib#
and 
e.tag = '001'


left join bib b
on
k.bib# = b.bib#
and 
b.tag = '010'

left join bib bb
on 
k.bib# = bb.bib#
and 
bb.tag = '020'

left join bib bbb
on k.bib# = bbb.bib#
and 
bbb.tag = '000'

left join bib v
on k.bib# = v.bib#
and 
v.tag = '245'

left join bib f
on k.bib# = f.bib#
and 
f.tag = '856'

left join bib_longtext g
on k.bib# = g.bib#
and 
g.tag = '856'

left join bib h
on k.bib# = h.bib#
and 
h.tag = '040'

order by k.bib#

GO
SET NOCOUNT OFF
GO
