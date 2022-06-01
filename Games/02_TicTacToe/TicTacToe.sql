/*Object: StoredProcedure [dbo].[usp_New_Game] Script Date: 02/23/2008 16:35:24 ******/IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_New_Game]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_New_Game]
GO
/****** Object: StoredProcedure [dbo].[usp_PlayTicTacToe] Script Date: 02/23/2008 16:35:25 ******/IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_PlayTicTacToe]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_PlayTicTacToe]
GO
/****** Object: StoredProcedure [dbo].[usp_OP_Move] Script Date: 02/23/2008 16:35:24 ******/IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_OP_Move]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_OP_Move]
GO
/****** Object: UserDefinedFunction [dbo].[udf_Op_AI] Script Date: 02/23/2008 16:35:28 ******/IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_Op_AI]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[udf_Op_AI]
GO
/****** Object: Table [dbo].[Quadrants] Script Date: 02/23/2008 16:35:28 ******/IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Quadrants]') AND type in (N'U'))
DROP TABLE [dbo].[Quadrants]
GO
/****** Object: UserDefinedFunction [dbo].[udf_Check_Victory] Script Date: 02/23/2008 16:35:28 ******/IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_Check_Victory]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[udf_Check_Victory]
GO
/****** Object: StoredProcedure [dbo].[usp_Redraw_Board] Script Date: 02/23/2008 16:35:25 ******/IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_Redraw_Board]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_Redraw_Board]
GO

--======================================================
-- TABLES
--======================================================
/****** Object: Table [dbo].[Quadrants] Script Date: 03/12/2008 16:36:06 ******/SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Quadrants](
[QuadrantID] [int] IDENTITY(1,1) NOT NULL,
[Quadrant] [char](2) NULL,
[Position] [int] NULL,
[IsUsed] [bit] NULL DEFAULT ((0)),
[Mark] [char](1) NULL,
CONSTRAINT [PK_Quadrants_IX] PRIMARY KEY CLUSTERED 
(
[QuadrantID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO

--==========================================
-- POPULATE TABLES
--==========================================
--POPULATE Quadrants
INSERT INTO Quadrants
SELECT 'A1', 1, 0, NULL UNION ALL
SELECT 'B1', 2, 0, NULL UNION ALL
SELECT 'C1', 3, 0, NULL UNION ALL
SELECT 'A2', 1, 0, NULL UNION ALL
SELECT 'B2', 2, 0, NULL UNION ALL
SELECT 'C2', 3, 0, NULL UNION ALL
SELECT 'A3', 1, 0, NULL UNION ALL
SELECT 'B3', 2, 0, NULL UNION ALL
SELECT 'C3', 3, 0, NULL ;
GO

--==========================================
--STORED PROCEDURES
--==========================================
/****** Object: StoredProcedure [dbo].[usp_Redraw_Board] Script Date: 03/12/2008 16:33:04 ******/SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_Redraw_Board]
AS
BEGIN
SET NOCOUNT ON;
--DECLARE VARIABLES
DECLARE @A1 CHAR(2),
@A2 CHAR(2),
@A3 CHAR(2),
@B1 CHAR(2),
@B2 CHAR(2),
@B3 CHAR(2),
@C1 CHAR(2),
@C2 CHAR(2),
@C3 CHAR(2)

/*
=========================================================================
REDRAW THE GRID:
=========================================================================
The logic is to go through each quadrant in the Quadrants table and
assign its value to a variable. If the quadrant is used then we assign
the mark; otherwise, we use the quadrant reference. After all quadrants
have been processed we draw the game board again, reflecting any new
changes.
=========================================================================
*/
SELECT 
@A1 =CASE WHEN IsUsed = 1 AND Quadrant = 'A1' THEN
Mark + space(1)
ELSE
'A1'
END
FROM Quadrants
WHERE Quadrant = 'A1'

SELECT 
@A2 =CASE WHEN IsUsed = 1 AND Quadrant = 'A2' THEN
Mark + space(1)
ELSE
'A2'
END
FROM Quadrants
WHERE Quadrant = 'A2'

SELECT 
@A3 =CASE WHEN IsUsed = 1 AND Quadrant = 'A3' THEN
Mark + space(1)
ELSE
'A3'
END
FROM Quadrants
WHERE Quadrant = 'A3'

SELECT 
@B1 =CASE WHEN IsUsed = 1 AND Quadrant = 'B1' THEN
Mark + space(1)
ELSE
'B1'
END
FROM Quadrants
WHERE Quadrant = 'B1'

SELECT 
@B2 =CASE WHEN IsUsed = 1 AND Quadrant = 'B2' THEN
Mark + space(1)
ELSE
'B2'
END
FROM Quadrants
WHERE Quadrant = 'B2'

SELECT 
@B3 =CASE WHEN IsUsed = 1 AND Quadrant = 'B3' THEN
Mark + space(1)
ELSE
'B3'
END
FROM Quadrants
WHERE Quadrant = 'B3'

SELECT 
@C1 =CASE WHEN IsUsed = 1 AND Quadrant = 'C1' THEN
Mark + space(1)
ELSE
'C1'
END
FROM Quadrants
WHERE Quadrant = 'C1'

SELECT 
@C2 =CASE WHEN IsUsed = 1 AND Quadrant = 'C2' THEN
Mark + space(1)
ELSE
'C2'
END
FROM Quadrants
WHERE Quadrant = 'C2'

SELECT 
@C3 =CASE WHEN IsUsed = 1 AND Quadrant = 'C3' THEN
Mark + space(1)
ELSE
'C3'
END
FROM Quadrants
WHERE Quadrant = 'C3'

SELECT space(4) + @A1 + space(5) + '|' + space(4) + @B1 + space(5) + '|' + space(4) +@C1 + space(5) AS [TIC TAC TOE] UNION ALL
SELECT '-------------|-------------|------------' UNION ALL
SELECT space(4) + @A2 + space(5) + '|' + space(4) + @B2 + space(5) + '|' + space(4) +@C2 + space(5) UNION ALL
SELECT '-------------|-------------|------------' UNION ALL
SELECT space(4) + @A3 + space(5) + '|' + space(4) + @B3 + space(5) + '|' + space(4) +@C3 + space(5) ;

END
GO

/****** Object: StoredProcedure [dbo].[usp_New_Game] Script Date: 03/12/2008 16:33:02 ******/SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_New_Game]
AS
BEGIN
SET NOCOUNT ON;
/*
=========================================================================
START A NEW GAME
=========================================================================
This resets the IsUsed and Mark columns in the Quadrants table. This 
resets the game.
=========================================================================
*/UPDATE Quadrants
SET IsUsed = 0,
Mark = NULL
END
GO
/****** Object: StoredProcedure [dbo].[usp_OP_Move] Script Date: 03/12/2008 16:33:03 ******/SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_OP_Move]
@quad CHAR(2),
@mark CHAR(1)
AS
BEGIN

SET NOCOUNT ON;

--print the move that the computer is making
PRINT 'The computer moved to quadrant ' + @quad

/*
========================================================================
RETURN MESSAGE TO SSMS: THE QUADRANT HAS ALREADY BEEN MARKED
========================================================================
All quadrants can only be used once per game. Once a quadrant has been
marked, it is no longer valid.
========================================================================
*/
IF (SELECT IsUsed FROM Quadrants WHERE Quadrant = @quad) = 1 
AND (SELECT COUNT(IsUsed) FROM Quadrants WHERE IsUsed = 1) < 9
BEGIN
PRINT 'This quadrant has already been used. ' +
'Please select another move.'
PRINT 'You can redraw the boad by using EXEC usp_Redraw_Board'
RETURN --FAILED
END

/*
========================================================================
UPDATE THE STATUS OF A QUADRANT
========================================================================
This will update the quadrants table to reflect the new quadrant used
and the mark used.
========================================================================
*/
UPDATE Quadrants
SET IsUsed = 1,
Mark = @mark
WHERE Quadrant = @quad


/*
========================================================================
CHECK FOR VICTORY
========================================================================
This calls a function to check whether or not the player has met
winning conditions. If so, the human player is declared winner
and the game is ended.
========================================================================
*/
DECLARE @victory BIT
SELECT @victory = dbo.udf_Check_Victory(@Mark)

IF @victory = 1 
BEGIN
PRINT @Mark + '''s has won the game. You can start a new game by using EXEC usp_New_Game.'
RETURN --game over
END

/*
========================================================================
RETURN MESSAGE TO SSMS: THE GAME IS OVER AND ENDED IN A TIE
========================================================================
Once all quadrants have been used. The player must start a new game.
========================================================================
*/
IF (SELECT COUNT(IsUsed) FROM Quadrants WHERE IsUsed = 1) = 9
BEGIN
PRINT 'The game is over. There are no remaining moves. ' 
PRINT 'You can start a new game by using EXEC usp_New_Game.'
RETURN --FAILED
END

--redraw the grid
EXEC usp_Redraw_Board
--END PROCEDURE
END
GO
/****** Object: StoredProcedure [dbo].[usp_PlayTicTacToe] Script Date: 03/12/2008 16:33:03 ******/SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_PlayTicTacToe]
@quad CHAR(2),
@mark CHAR(1)
AS
BEGIN

SET NOCOUNT ON;

/*
========================================================================
RETURN MESSAGE TO SSMS IF THE QUADRANT IS INVALID
========================================================================
All quadrants must be valid for the game to work. Valid quadrants are
A1,A2,A3,B1,B2,B3,C1,C2,C3. Each of these quadrants is marked on the
game board.
========================================================================
*/
IF @quad NOT IN('A1','A2','A3','B1','B2','B3','C1','C2','C3')
BEGIN
PRINT 'The quadrant is invalid. Please provide a valid quadrant.'
RETURN --FAILED
END

/*
========================================================================
RETURN MESSAGE TO SSMS IF THE MARK IS INVALID
========================================================================
Only 'X' and 'O' are valid marks. Anything else is kicked back.
========================================================================
*/
IF @Mark <> 'X' AND @Mark <> 'O'
BEGIN
PRINT 'The mark is invalid. Please provide either "X" or "O".'
RETURN --FAILED
END

--Make the letter Capital
SET @Mark = UPPER(@Mark)

/*
========================================================================
RETURN MESSAGE TO SSMS: THE QUADRANT HAS ALREADY BEEN MARKED
========================================================================
All quadrants can only be used once per game. Once a quadrant has been
marked, it is no longer valid.
========================================================================
*/
IF (SELECT IsUsed FROM Quadrants WHERE Quadrant = @quad) = 1 
AND (SELECT COUNT(IsUsed) FROM Quadrants WHERE IsUsed = 1) < 9
BEGIN
PRINT 'This quadrant has already been used. ' +
'Please select another move.'
PRINT 'You can redraw the boad by using EXEC usp_Redraw_Board'
RETURN --FAILED
END

/*
========================================================================
UPDATE THE STATUS OF A QUADRANT
========================================================================
This will update the quadrants table to reflect the new quadrant used
and the mark used.
========================================================================
*/
UPDATE Quadrants
SET IsUsed = 1,
Mark = @mark
WHERE Quadrant = @quad

/*
========================================================================
CHECK FOR VICTORY
========================================================================
This calls a function to check whether or not the player has met
winning conditions. If so, the human player is declared winner
and the game is ended.
========================================================================
*/
DECLARE @victory BIT
SELECT @victory = dbo.udf_Check_Victory(@Mark)

IF @victory = 1 
BEGIN
PRINT @Mark + '''s has won the game. You can start a new game by using EXEC usp_New_Game.'
RETURN --game over
END

/*
========================================================================
RETURN MESSAGE TO SSMS: THE GAME IS OVER AND ENDED IN A TIE
========================================================================
Once all quadrants have been used. The player must start a new game.
========================================================================
*/
IF (SELECT COUNT(IsUsed) FROM Quadrants WHERE IsUsed = 1) = 9
BEGIN
PRINT 'The game is over. The outcome is a tie because there are no remaining moves. ' 
PRINT 'You can start a new game by using EXEC usp_New_Game.'
RETURN --FAILED
END

/*
========================================================================
COMPUTER AI
========================================================================
The basic steps here are to first switch the marks. So if the player
is X then the computer will be O and vice-versa. Next we calculate 
the best quadrant for the computer to use by using dbo.udf_Op_AI.
If the AI determines that there are no blocks or is no chance to win,
it will pick a random quadrant.
========================================================================
*/
DECLARE @OpQuadrant CHAR(2),
@nbr INT

--initialize variable
SET @OpQuadrant = ''
SELECT @Mark = CASE WHEN @Mark = 'X' THEN 'O' ELSE 'X' END

--use AI to determine what the best
--quadrant for the computer is.
SELECT @OpQuadrant = dbo.udf_Op_AI(@Mark)

--If a block or win is not an option then
--generate a random quadrant.
IF @OpQuadrant = 'NA'
BEGIN
SELECT TOP 1 @OpQuadrant = Quadrant 
FROM Quadrants
WHERE IsUsed = 0
ORDER BY CHECKSUM(NEWID()) 
END

--execute the computer's move
EXEC usp_OP_Move @OpQuadrant,@Mark

--END PROCEDURE
END

GO

--===========================================================
-- functions
--===========================================================
/****** Object: UserDefinedFunction [dbo].[udf_Check_Victory] Script Date: 03/12/2008 16:34:39 ******/SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[udf_Check_Victory]
(
@Mark CHAR(1)
)
RETURNS BIT
AS
BEGIN

DECLARE @victory BIT

/*
=========================================================================
CHECK FOR VICTORY:
=========================================================================
If the player has three of three key victory quadrants marked, he wins
the game. This is done by retrieving all the marks by the player
and comparing them against winning patterns.
=========================================================================
*/
IF EXISTS(SELECT 1 
FROM Quadrants
WHERE IsUsed = 1 AND
Mark = @Mark AND
(Quadrant = 'A1' OR Quadrant = 'A2' OR Quadrant = 'A3')
GROUP BY Mark
HAVING COUNT(QuadrantID) = 3)
BEGIN
SET @victory = 1
END

IF EXISTS(SELECT 1 
FROM Quadrants
WHERE IsUsed = 1 AND
Mark = @Mark AND
(Quadrant = 'A1' or Quadrant = 'B2' or Quadrant = 'C3')
GROUP BY Mark
HAVING COUNT(QuadrantID) = 3)
BEGIN
SET @victory = 1
END

IF EXISTS(SELECT 1 
FROM Quadrants
WHERE IsUsed = 1 AND
Mark = @Mark AND
(Quadrant = 'A3' or Quadrant = 'B2' or Quadrant = 'C1')
GROUP BY Mark
HAVING COUNT(QuadrantID) = 3)
BEGIN
SET @victory = 1
END

IF EXISTS(SELECT 1 
FROM Quadrants
WHERE IsUsed = 1 AND
Mark = @Mark AND
(Quadrant = 'A1' or Quadrant = 'B1' or Quadrant = 'C1')
GROUP BY Mark
HAVING COUNT(QuadrantID) = 3)
BEGIN
SET @victory = 1
END

IF EXISTS(SELECT 1 
FROM Quadrants
WHERE IsUsed = 1 AND
Mark = @Mark AND
(Quadrant = 'A2' or Quadrant = 'B2' or Quadrant = 'C2')
GROUP BY Mark
HAVING COUNT(QuadrantID) = 3)
BEGIN
SET @victory = 1
END

IF EXISTS(SELECT 1 
FROM Quadrants
WHERE IsUsed = 1 AND
Mark = @Mark AND
(Quadrant = 'A3' or Quadrant = 'B3' or Quadrant = 'C3')
GROUP BY Mark
HAVING COUNT(QuadrantID) = 3)
BEGIN
SET @victory = 1
END

IF EXISTS(SELECT 1 
FROM Quadrants
WHERE IsUsed = 1 AND
Mark = @Mark AND
(Quadrant = 'B1' or Quadrant = 'B2' or Quadrant = 'B3')
GROUP BY Mark
HAVING COUNT(QuadrantID) = 3)
BEGIN
SET @victory = 1
END

IF EXISTS(SELECT 1 
FROM Quadrants
WHERE IsUsed = 1 AND
Mark = @Mark AND
(Quadrant = 'C1' or Quadrant = 'C2' or Quadrant = 'C3')
GROUP BY Mark
HAVING COUNT(QuadrantID) = 3)
BEGIN
SET @victory = 1
END

RETURN @victory
END


GO
/****** Object: UserDefinedFunction [dbo].[udf_Op_AI] Script Date: 03/12/2008 16:34:40 ******/SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[udf_Op_AI]
(
@Mark CHAR(1)
)
RETURNS CHAR(2)
AS
BEGIN

DECLARE @quad CHAR(2)
SET @quad = ''

/*
=========================================================================
TELL THE OPPONENT TO BLOCK THE WIN:
=========================================================================
If the human player has two of three key victory quadrants marked, the 
computer will place his mark in the quadrant to prevent the human player
from winning the game. Note: If the computer has an opportunity
to win it will overide the block below.
=========================================================================
*/
IF EXISTS(SELECT 1 
FROM Quadrants
WHERE IsUsed = 1 AND
Mark <> @Mark AND
(Quadrant = 'A1' OR Quadrant = 'A2' OR Quadrant = 'A3')
GROUP BY Mark
HAVING COUNT(QuadrantID) = 2)
BEGIN
SELECT @quad = Quadrant 
FROM Quadrants
WHERE IsUsed = 0 AND
(Quadrant = 'A1' OR Quadrant = 'A2' OR Quadrant = 'A3')
END

IF EXISTS(SELECT 1 
FROM Quadrants
WHERE IsUsed = 1 AND
Mark <> @Mark AND
(Quadrant = 'A1' or Quadrant = 'B2' or Quadrant = 'C3')
GROUP BY Mark
HAVING COUNT(QuadrantID) = 2)
BEGIN
SELECT @quad = Quadrant 
FROM Quadrants
WHERE IsUsed = 0 AND
(Quadrant = 'A1' or Quadrant = 'B2' or Quadrant = 'C3')
END

IF EXISTS(SELECT 1 
FROM Quadrants
WHERE IsUsed = 1 AND
Mark <> @Mark AND
(Quadrant = 'A3' or Quadrant = 'B2' or Quadrant = 'C1')
GROUP BY Mark
HAVING COUNT(QuadrantID) = 2)
BEGIN
SELECT @quad = Quadrant 
FROM Quadrants
WHERE IsUsed = 0 AND
(Quadrant = 'A3' or Quadrant = 'B2' or Quadrant = 'C1')
END

IF EXISTS(SELECT 1 
FROM Quadrants
WHERE IsUsed = 1 AND
Mark <> @Mark AND
(Quadrant = 'A1' or Quadrant = 'B1' or Quadrant = 'C1')
GROUP BY Mark
HAVING COUNT(QuadrantID) = 2)
BEGIN
SELECT @quad = Quadrant 
FROM Quadrants
WHERE IsUsed = 0 AND
(Quadrant = 'A1' or Quadrant = 'B1' or Quadrant = 'C1')
END

IF EXISTS(SELECT 1 
FROM Quadrants
WHERE IsUsed = 1 AND
Mark <> @Mark AND
(Quadrant = 'A2' or Quadrant = 'B2' or Quadrant = 'C2')
GROUP BY Mark
HAVING COUNT(QuadrantID) = 2)
BEGIN
SELECT @quad = Quadrant 
FROM Quadrants
WHERE IsUsed = 0 AND
(Quadrant = 'A2' or Quadrant = 'B2' or Quadrant = 'C2')
END

IF EXISTS(SELECT 1 
FROM Quadrants
WHERE IsUsed = 1 AND
Mark <> @Mark AND
(Quadrant = 'A3' or Quadrant = 'B3' or Quadrant = 'C3')
GROUP BY Mark
HAVING COUNT(QuadrantID) = 2)
BEGIN
SELECT @quad = Quadrant 
FROM Quadrants
WHERE IsUsed = 0 AND
(Quadrant = 'A3' or Quadrant = 'B3' or Quadrant = 'C3')
END

IF EXISTS(SELECT 1 
FROM Quadrants
WHERE IsUsed = 1 AND
Mark <> @Mark AND
(Quadrant = 'B1' or Quadrant = 'B2' or Quadrant = 'B3')
GROUP BY Mark
HAVING COUNT(QuadrantID) = 2)
BEGIN
SELECT @quad = Quadrant 
FROM Quadrants
WHERE IsUsed = 0 AND
(Quadrant = 'B1' or Quadrant = 'B2' or Quadrant = 'B3')
END

IF EXISTS(SELECT 1 
FROM Quadrants
WHERE IsUsed = 1 AND
Mark <> @Mark AND
(Quadrant = 'C1' or Quadrant = 'C2' or Quadrant = 'C3')
GROUP BY Mark
HAVING COUNT(QuadrantID) = 2)
BEGIN
SELECT @quad = Quadrant 
FROM Quadrants
WHERE IsUsed = 0 AND
(Quadrant = 'C1' or Quadrant = 'C2' or Quadrant = 'C3')
END

/*
=========================================================================
TELL THE OPPONENT TO WIN THE GAME:
=========================================================================
If the computer has two of three key victory quadrants marked, the 
computer will place his mark in the quadrant to win the game. 
The win overides the block.
=========================================================================
*/
IF EXISTS(SELECT 1 
FROM Quadrants
WHERE IsUsed = 1 AND
Mark = @Mark AND
(Quadrant = 'A1' OR Quadrant = 'A2' OR Quadrant = 'A3')
GROUP BY Mark
HAVING COUNT(QuadrantID) = 2)
BEGIN
SELECT @quad = Quadrant 
FROM Quadrants
WHERE IsUsed = 0 AND
(Quadrant = 'A1' OR Quadrant = 'A2' OR Quadrant = 'A3')
END

IF EXISTS(SELECT 1 
FROM Quadrants
WHERE IsUsed = 1 AND
Mark = @Mark AND
(Quadrant = 'A1' or Quadrant = 'B2' or Quadrant = 'C3')
GROUP BY Mark
HAVING COUNT(QuadrantID) = 2)
BEGIN
SELECT @quad = Quadrant 
FROM Quadrants
WHERE IsUsed = 0 AND
(Quadrant = 'A1' or Quadrant = 'B2' or Quadrant = 'C3')
END

IF EXISTS(SELECT 1 
FROM Quadrants
WHERE IsUsed = 1 AND
Mark = @Mark AND
(Quadrant = 'A3' or Quadrant = 'B2' or Quadrant = 'C1')
GROUP BY Mark
HAVING COUNT(QuadrantID) = 2)
BEGIN
SELECT @quad = Quadrant 
FROM Quadrants
WHERE IsUsed = 0 AND
(Quadrant = 'A3' or Quadrant = 'B2' or Quadrant = 'C1')
END

IF EXISTS(SELECT 1 
FROM Quadrants
WHERE IsUsed = 1 AND
Mark = @Mark AND
(Quadrant = 'A1' or Quadrant = 'B1' or Quadrant = 'C1')
GROUP BY Mark
HAVING COUNT(QuadrantID) = 2)
BEGIN
SELECT @quad = Quadrant 
FROM Quadrants
WHERE IsUsed = 0 AND
(Quadrant = 'A1' or Quadrant = 'B1' or Quadrant = 'C1')
END

IF EXISTS(SELECT 1 
FROM Quadrants
WHERE IsUsed = 1 AND
Mark = @Mark AND
(Quadrant = 'A2' or Quadrant = 'B2' or Quadrant = 'C2')
GROUP BY Mark
HAVING COUNT(QuadrantID) = 2)
BEGIN
SELECT @quad = Quadrant 
FROM Quadrants
WHERE IsUsed = 0 AND
(Quadrant = 'A2' or Quadrant = 'B2' or Quadrant = 'C2')
END

IF EXISTS(SELECT 1 
FROM Quadrants
WHERE IsUsed = 1 AND
Mark = @Mark AND
(Quadrant = 'A3' or Quadrant = 'B3' or Quadrant = 'C3')
GROUP BY Mark
HAVING COUNT(QuadrantID) = 2)
BEGIN
SELECT @quad = Quadrant 
FROM Quadrants
WHERE IsUsed = 0 AND
(Quadrant = 'A3' or Quadrant = 'B3' or Quadrant = 'C3')
END

IF EXISTS(SELECT 1 
FROM Quadrants
WHERE IsUsed = 1 AND
Mark = @Mark AND
(Quadrant = 'B1' or Quadrant = 'B2' or Quadrant = 'B3')
GROUP BY Mark
HAVING COUNT(QuadrantID) = 2)
BEGIN
SELECT @quad = Quadrant 
FROM Quadrants
WHERE IsUsed = 0 AND
(Quadrant = 'B1' or Quadrant = 'B2' or Quadrant = 'B3')
END

IF EXISTS(SELECT 1 
FROM Quadrants
WHERE IsUsed = 1 AND
Mark = @Mark AND
(Quadrant = 'C1' or Quadrant = 'C2' or Quadrant = 'C3')
GROUP BY Mark
HAVING COUNT(QuadrantID) = 2)
BEGIN
SELECT @quad = Quadrant 
FROM Quadrants
WHERE IsUsed = 0 AND
(Quadrant = 'C1' or Quadrant = 'C2' or Quadrant = 'C3')
END

/*
=========================================================================
SET THE QUADRANT TO NA SO THE RETURN WILL GENERATE A RANDOM QUADRANT
=========================================================================
if a block or win is not available, pick a random quadrant.
the random quadrant is created by the return of NA (Not Applicable).
This is because function do not allow non-determenistic values.
=========================================================================
*/IF @quad = '' 
BEGIN
SET @quad = 'NA'
END

RETURN @quad
END
GO

--========================
-- PLAY THE GAME
--========================
--EXEC usp_PlayTicTacToe 'c2', 'x'

--========================
-- TO START A NEW GAME
--========================
--exec usp_New_Game

--=========================
-- TO REDRAW THE GAME BOARD
--=========================
--EXEC usp_Redraw_Board