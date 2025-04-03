-- Bibs without 996 tags
-- See IT TICKET LOG# 56452

SET NOCOUNT ON
GO

truncate table scl_kill_bib2
go

WITH bib_cte( bib# ) 
AS
(
select t001.bib# from 
bib t001
join bib_control bc on t001.bib# = bc.bib# and bc.status in ('bb','cc','unp')
WHERE
t001.tag='001' and ( t001.text not like '%bl%' and  t001.text not like '%bc%' and t001.text not like '%mwt%' )
)
insert into scl_kill_bib2
    select distinct bib#
    from 
    bib_cte
    where bib# not in (select distinct bib# from bib where tag='996') ;

GO
