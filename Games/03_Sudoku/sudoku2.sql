if object_id('dbo.sp_sudoku_solve_simple') is not null
	drop procedure dbo.sp_sudoku_solve_simple
go

create procedure dbo.sp_sudoku_solve_simple @PuzzleIn char(81) as

/*


-- Set of 10 simple puzzles 
exec sp_sudoku_solve_simple '023780460000620000060304080001000534280000097439000100010205040000036000056018370'
exec sp_sudoku_solve_simple '600050002010702040000346000084000590509000207032000480000165000020407060300090004'
exec sp_sudoku_solve_simple '800259004040010070000407000302080506580302091607040302000504000060090020700826009'
exec sp_sudoku_solve_simple '703200104054019380000500000070000805060000030308000090000001000035920460407008903'
exec sp_sudoku_solve_simple '700200008020405070004080300060508037009000800180607020001070600050903010600004003'
exec sp_sudoku_solve_simple '000400000004063200809000503090030005040658030600010070901000804005840100000007000'
exec sp_sudoku_solve_simple '007400803000206001000085700026000039004000100370000680908620000000108000630009200'
exec sp_sudoku_solve_simple '019600430000098000002005100098074001020000080700850620007500800000730000056001970'
exec sp_sudoku_solve_simple '280060079100007006070930080907000605008000700040000090090025060800600002650010047'
exec sp_sudoku_solve_simple '107608209840050036000000000300106004060000090200305007000000000430060052508209301'

*/

set nocount off




declare @SQL varchar(max) =''
declare @Select varchar(max) =''
declare @Exclusion varchar(max) =''
declare @PuzzleSolution char(81)


/* 81 long number table of row, column and block mapping */
create table #tGrid (CoordinateID int, RowNum int, ColumnNum int, BlockNum int)  
create clustered index IDX01_tGrid on #tGrid (CoordinateID)

/* output solutions - write to table so can display as 9x9 grids in final output */
create table #solutions (SolutionID int, [1] char(1), [2] char(1), [3] char(1), [4] char(1), [5] char(1), [6] char(1), [7] char(1), [8] char(1), [9] char(1), [10] char(1), [11] char(1), [12] char(1), [13] char(1), [14] char(1), [15] char(1), [16] char(1), [17] char(1), [18] char(1), [19] char(1), [20] char(1), [21] char(1), [22] char(1), [23] char(1), [24] char(1), [25] char(1), [26] char(1), [27] char(1), [28] char(1), [29] char(1), [30] char(1), [31] char(1), [32] char(1), [33] char(1), [34] char(1), [35] char(1), [36] char(1), [37] char(1), [38] char(1), [39] char(1), [40] char(1), [41] char(1), [42] char(1), [43] char(1), [44] char(1), [45] char(1), [46] char(1), [47] char(1), [48] char(1), [49] char(1), [50] char(1), [51] char(1), [52] char(1), [53] char(1), [54] char(1), [55] char(1), [56] char(1), [57] char(1), [58] char(1), [59] char(1), [60] char(1), [61] char(1), [62] char(1), [63] char(1), [64] char(1), [65] char(1), [66] char(1), [67] char(1), [68] char(1), [69] char(1), [70] char(1), [71] char(1), [72] char(1), [73] char(1), [74] char(1), [75] char(1), [76] char(1), [77] char(1), [78] char(1), [79] char(1), [80] char(1), [81] char(1))

/* Fixed puzzle values */
create table #tFixed (CoordinateID int, Value int)

/* options */
create table #tOption (CoordinateID int, Value int)
create clustered index IDX01_tOption on #tOption (CoordinateID)

/* Construct references for row, column and block CoordinateID logic */
insert into #tGrid (CoordinateID, RowNum, ColumnNum, BlockNum) values (1,1,1,1),(2,1,2,1),(3,1,3,1),(4,1,4,2),(5,1,5,2),(6,1,6,2),(7,1,7,3),(8,1,8,3),(9,1,9,3),(10,2,1,1),(11,2,2,1),(12,2,3,1),(13,2,4,2),(14,2,5,2),(15,2,6,2),(16,2,7,3),(17,2,8,3),(18,2,9,3),(19,3,1,1),(20,3,2,1),(21,3,3,1),(22,3,4,2),(23,3,5,2),(24,3,6,2),(25,3,7,3),(26,3,8,3),(27,3,9,3),(28,4,1,4),(29,4,2,4),(30,4,3,4),(31,4,4,5),(32,4,5,5),(33,4,6,5),(34,4,7,6),(35,4,8,6),(36,4,9,6),(37,5,1,4),(38,5,2,4),(39,5,3,4),(40,5,4,5),(41,5,5,5),(42,5,6,5),(43,5,7,6),(44,5,8,6),(45,5,9,6),(46,6,1,4),(47,6,2,4),(48,6,3,4),(49,6,4,5),(50,6,5,5),(51,6,6,5),(52,6,7,6),(53,6,8,6),(54,6,9,6),(55,7,1,7),(56,7,2,7),(57,7,3,7),(58,7,4,8),(59,7,5,8),(60,7,6,8),(61,7,7,9),(62,7,8,9),(63,7,9,9),(64,8,1,7),(65,8,2,7),(66,8,3,7),(67,8,4,8),(68,8,5,8),(69,8,6,8),(70,8,7,9),(71,8,8,9),(72,8,9,9),(73,9,1,7),(74,9,2,7),(75,9,3,7),(76,9,4,8),(77,9,5,8),(78,9,6,8),(79,9,7,9),(80,9,8,9),(81,9,9,9)


/*
------------------------------------------------------------------------------------------------------------------------------------
STORE PUZZLE
------------------------------------------------------------------------------------------------------------------------------------
*/

/* add fixed puzzle cells -- 0 for empty cells - row of first 9 values and so forth */
insert into #tFixed (CoordinateID, Value)
	select CoordinateID, substring(@PuzzleIn,CoordinateID,1) Value
	from #tGrid
	where substring(@PuzzleIn,CoordinateID,1) != 0


insert into #tOption (CoordinateID, Value)
		select CoordinateID, Num from #tGrid a cross join
			(select top 9 ROW_NUMBER() over (order by CoordinateID) Num from #tGrid) b
		/* exclude fixed coordinates*/
		where not exists
		(select 1 from #tFixed c where a.CoordinateID = c.CoordinateID)
		/* exclude row */
		and not exists
			(select 1 from #tFixed c inner join #tGrid d on c.CoordinateID = d.CoordinateID where a.RowNum = d.RowNum and b.Num = c.Value)
		/* exclude column */
		and not exists
			(select 1 from #tFixed c inner join #tGrid d on c.CoordinateID = d.CoordinateID where a.ColumnNum = d.ColumnNum and b.Num = c.Value)
		/* exclude value same BlockNum */
		and not exists
			(select 1 from #tFixed c inner join #tGrid d on c.CoordinateID = d.CoordinateID where a.BlockNum = d.BlockNum and b.Num = c.Value)
		/* add back fixed values */
		union
			select CoordinateID, Value from #tFixed




--------------------
/*	SOLVE	*/
--------------------
set @Select = ''
set @Exclusion = ''
set @SQL = ''


set @Select = ''
set @Exclusion = ''
set @SQL = ''

/*produces 81 values in row preference order a row is one permutation of possible values*/
SELECT @Select = stuff(
	(select 'cross join'+'(select Value ['+CoordinateID+'] from #tOption where CoordinateID = '+CoordinateID+') ['+CoordinateID+']' from 
	(select distinct cast(CoordinateID as varchar(3)) CoordinateID from #tOption) b 
FOR XML PATH('')), 1, 10, '') 


/* row, column or block exclusions - all one way permutations with the CoordinateID > other */
select @Exclusion = @Exclusion + ' and ['+cast(l.CoordinateID as varchar(5))+'] <> ['+cast(r.CoordinateID as varchar(5))+']'
from #tGrid l cross join #tGrid r
where (l.RowNum = r.RowNum or l.ColumnNum = r.ColumnNum or l.BlockNum = r.BlockNum) and r.CoordinateID > l.CoordinateID


/* run whole thing - insert into #solution*/

/* solve */
set @SQL =  'select ROW_NUMBER() over (order by [1] asc) SolutionID, *
from (select * from '+@Select+' where 1 = 1 '+@Exclusion+') x '


insert into #solutions
	exec (@SQL)


/* store solution in @PuzzleSolution */
select top 1 @PuzzleSolution = [1]+[2]+[3]+[4]+[5]+[6]+[7]+[8]+[9]+[10]+[11]+[12]+[13]+[14]+[15]+[16]+[17]+[18]+[19]+[20]+[21]+[22]+[23]+[24]+[25]+[26]+[27]+[28]+[29]+[30]+[31]+[32]+[33]+[34]+[35]+[36]+[37]+[38]+[39]+[40]+[41]+[42]+[43]+[44]+[45]+[46]+[47]+[48]+[49]+[50]+[51]+[52]+[53]+[54]+[55]+[56]+[57]+[58]+[59]+[60]+[61]+[62]+[63]+[64]+[65]+[66]+[67]+[68]+[69]+[70]+[71]+[72]+[73]+[74]+[75]+[76]+[77]+[78]+[79]+[80]+[81] from #solutions
	

/* show puzzle */
select RowNum, [1],[2],[3],[4],[5],[6],[7],[8],[9]
from
	(select RowNum, ColumnNum, case when substring(@PuzzleIn,CoordinateID,1) != 0 then substring(@PuzzleIn,CoordinateID,1) end Value from #tGrid) as base
pivot
(min(Value) for ColumnNum in ([1],[2],[3],[4],[5],[6],[7],[8],[9])) as pt

/* Show options */
select RowNum, [1],[2],[3],[4],[5],[6],[7],[8],[9]
from
	(select distinct RowNum, ColumnNum, 
		(SELECT stuff(
			(select ','+cast(Value as char(1)) from 
			#tOption b where a.CoordinateID = b.CoordinateID
		FOR XML PATH('')), 1, 1, '')) Value
		 from #tGrid a) as base
pivot (min(Value) for ColumnNum in ([1],[2],[3],[4],[5],[6],[7],[8],[9])) as pt

/* show solution */
select RowNum, [1],[2],[3],[4],[5],[6],[7],[8],[9]
from
	(select RowNum, ColumnNum, case when substring(@PuzzleSolution,CoordinateID,1) != 0 then substring(@PuzzleSolution,CoordinateID,1) end Value from #tGrid) as base
pivot (min(Value) for ColumnNum in ([1],[2],[3],[4],[5],[6],[7],[8],[9])) as pt
go




-- Run Solution
exec sp_sudoku_solve_simple '023780460000620000060304080001000534280000097439000100010205040000036000056018370'
