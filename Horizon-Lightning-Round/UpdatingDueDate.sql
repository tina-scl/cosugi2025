DECLARE @item INTEGER;
DECLARE @ibarcode VARCHAR(50);
DECLARE @duedate integer;
DECLARE @call varchar(50);
DECLARE @bn INTEGER;
declare @Jan1970 date;

-- Declare variables used in error checking.  
DECLARE @ErrorVar INT;
DECLARE @RowCountVar INT;

set @jan1970 = '01Jan1970';
-- USE Sonoma;

DECLARE c1 CURSOR FOR 
select 
    call_reconstructed,
    item#,
    ibarcode,
    due_date,
    borrower#

 from 
item
where 
    itype='skiosk'
    AND item_status='o'
and 	datediff(dd, @jan1970, cast(getdate() as date)) - due_date >=0
and		datediff(mi, '00:00', CAST(getdate() AS time)) - due_time > 10;


OPEN c1;

-- get first record
FETCH next FROM c1 INTO @call,@item,@ibarcode,@duedate,@bn

IF @@FETCH_STATUS<>0
BEGIN
    PRINT 'No overdue SKIOSK items';
    PRINT 'NO RECORDS';
END;

IF @@FETCH_STATUS=0
BEGIN
    PRINT '*** OVERDUE SKIOSK ITEMS ***';
    PRINT ' ';
    PRINT 'trans ,call# ,item# ,ibarcode ,borrower# ';
END;

WHILE @@FETCH_STATUS=0 
BEGIN

        SET NOCOUNT ON
        UPDATE item 
        SET due_date = @duedate-43
        WHERE item#=@item;

        SELECT
            @ErrorVar = @@ERROR  
            ,@RowCountVar = @@ROWCOUNT;

        IF @ErrorVar <> 0  
        BEGIN

            PRINT N'ERROR: error '
                            + RTRIM
            (CAST
            (@ErrorVar AS NVARCHAR
            (10)))  
                    + N' occurred.';
        END;


        -- Check the row count. @RowCountVar is set to 0   
        IF @RowCountVar = 0  
        BEGIN
        
        PRINT '*** FAILED,'+ cast(@call as varchar)+','+cast(@item AS varchar) + ',' + @ibarcode + ',' + cast(@bn as varchar); 	
    END;
    
    ELSE
        BEGIN
           
        PRINT 'SUCCESS,'+cast(@call AS varchar)+','+cast(@item AS varchar) + ',' + @ibarcode + ',' + cast(@bn as varchar); 
        END;

        -- get next record
        FETCH next FROM c1 INTO @call,@item,@ibarcode,@duedate,@bn
END;

CLOSE c1;
DEALLOCATE c1;
