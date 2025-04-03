SET NOCOUNT ON
GO

DELETE scl_kill_bib2
GO

INSERT scl_kill_bib2
SELECT bib#
FROM bib
WHERE
tag = '001'
AND
( TEXT LIKE 'bk%' or 
TEXT LIKE 'BRDBD%' OR
TEXT LIKE 'cl%' OR
TEXT LIKE ' %' OR
TEXT LIKE '[1-9]%' or
TEXT LIKE 'mwt%' OR
TEXT LIKE 'in%'
)
AND 
bib# IN (SELECT bib# from item WHERE ibarcode LIKE '[1-3]%' AND n_ckos >=1)

GO


select 
	k.bib#, 
	substring(e.text,1,30) as '''001', 
	substring(b.text,1,30) as '''010',  
	substring(bb.text,1,30) as '''020' ,
	substring(bbb.text,1,30) as '''024',	
	 substring(h.text,1,50) as '''040', 
	 substring (v.text,1,75) AS '''245'


from scl_kill_bib2 k


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
bbb.tag = '024'

left join bib v
on k.bib# = v.bib#
and 
v.tag = '245'

left join bib h
on k.bib# = h.bib#
and 
h.tag = '040'


order by k.bib#


SET NOCOUNT OFF
GO