SET NOCOUNT ON
Use Sonoma;
go

declare @rec SMALLINT;

print 'List of LOST SKIOSK items'
print 'call# ,item# ,ibarcode ,borrower# ,last-cko_date ';

select
    call_reconstructed, 
    item#,
    ibarcode,
    borrower#,
    convert( varchar, dateadd(dd,last_cko_date, '01Jan1970') ,1) 
 from 
item
where 
    itype='skiosk'
    AND item_status='l'
;

SET @rec = @@ROWCOUNT;

if @rec=0
    print 'NO RECORDS';


