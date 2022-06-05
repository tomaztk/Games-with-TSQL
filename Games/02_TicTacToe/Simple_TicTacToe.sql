USE test;
DROP TABLE IF EXISTS TicTacToe;

CREATE TABLE TicTacToe
    (
    ID INT NOT NULL,
    A VARCHAR(1) NULL,
    B VARCHAR(1) NULL,
    C VARCHAR(1) NULL
    );
INSERT INTO TicTacToe(ID,A,B,C)
VALUES
    (1,NULL,NULL,NULL),
    (2,NULL,NULL,NULL),
    (3,NULL,NULL,NULL);
SELECT * FROM TicTacToe;


DROP PROCEDURE IF EXISTS ttt_CheckVictory;

CREATE PROCEDURE ttt_CheckVictory AS
BEGIN
SET
    DECLARE @A1 CHAR(1) 
    SET @a1= (SELECT A FROM TicTacToe WHERE ID = 1)
    DECLARE @A2 CHAR(1) 
    SET @a2=  (SELECT A FROM TicTacToe WHERE ID = 2)
    DECLARE @A3 CHAR(1) 
    SET @a3=  (SELECT A FROM TicTacToe WHERE ID = 3)
    DECLARE @B1 CHAR(1) 
    SET @b1=  (SELECT B FROM TicTacToe WHERE ID = 1)
    DECLARE @B2 CHAR(1) 
    SET @b2=  (SELECT B FROM TicTacToe WHERE ID = 2)
    DECLARE @B3 CHAR(1) 
    SET @b3=  (SELECT B FROM TicTacToe WHERE ID = 3)
    DECLARE @C1 CHAR(1) 
    SET @c1=  (SELECT C FROM TicTacToe WHERE ID = 1)
    DECLARE @C2 CHAR(1) 
    SET @c2=  (SELECT C FROM TicTacToe WHERE ID = 2)
    DECLARE @C3 CHAR(1) 
    SET @c3=  (SELECT C FROM TicTacToe WHERE ID = 3)

    CASE 
    -- Horizontal wins
        -- Horizontal win on row 1
        WHEN 
            @A1 = @B1 AND @B1 = @C1
        THEN     (SELECT *, CONCAT('Player ', @A1, ' is victorious!') AS 'Result' FROM TicTacToe);
        -- Horizontal win on row 2
        WHEN 
            @A2 = @B2 AND @B2 = @C2
        THEN     (SELECT *, CONCAT('Player ', @A2, ' is victorious!') AS 'Result' FROM TicTacToe);
        -- Horizontal win on row 3
        WHEN 
            @A3 = @B3 AND @B3 = @C3
        THEN     (SELECT *, CONCAT('Player ', @A3, ' is victorious!') AS 'Result' FROM TicTacToe);
    -- Vertical wins
        -- Vertical win on column A
        WHEN 
            @A1 = @A2 AND @A2 = @A3
        THEN     (SELECT *, CONCAT('Player ', @A1, ' is victorious!') AS 'Result' FROM TicTacToe);
        -- Vertical win on column B
        WHEN 
            @B1 = @B2 AND @B2 = @B3
        THEN     (SELECT *, CONCAT('Player ', @B1, ' is victorious!') AS 'Result' FROM TicTacToe);
        -- Vertical win on column C
        WHEN 
            @C1 = @C2 AND @C2 = @C3
        THEN     (SELECT *, CONCAT('Player ', @C1, ' is victorious!') AS 'Result' FROM TicTacToe);
    -- Diagonal wins
        -- Diagonal win from A1
        WHEN 
            @A1 = @B2 AND @B2 = @C3
        THEN     (SELECT *, CONCAT('Player ', @A1, ' is victorious!') AS 'Result' FROM TicTacToe);
        -- Diagonal win from A3
        WHEN 
            @A3 = @B2 AND @B2 = @C1
        THEN     (SELECT *, CONCAT('Player ', @A3, ' is victorious!') AS 'Result' FROM TicTacToe);
    -- Game continues
        ELSE (SELECT *, 'Game is still ongoing'  AS 'Result' FROM TicTacToe);
    END CASE;
END;




DROP PROCEDURE IF EXISTS ttt_PlayerMove;

CREATE PROCEDURE ttt_PlayerMove(p_move VARCHAR(1), p_column VARCHAR(1), p_row INT)
BEGIN
    -- Check for valid player input
    IF     p_move NOT IN ('X', 'O')
        THEN (SELECT 'Move must be X or O');
    END IF;
    -- Check for valid column
    IF     p_column NOT IN ('A', 'B', 'C')
        THEN (SELECT 'Column must be A, B or C');
    END IF;
    -- Check for valid row
    IF     p_row NOT IN (1,2,3)
        THEN (SELECT 'Row must be 1, 2 or 3');
    END IF;
    -- Check for player turn and update player turn
    IF p_move = (SELECT turn FROM ttt_PlayerTurn)
        THEN (SELECT 
                CONCAT('This turn belongs to player ', (SELECT turn FROM ttt_PlayerTurn), '!')
        );
        ELSE
            UPDATE TicTacToe
            SET p_column = p_move
            WHERE ID = p_row;
            UPDATE ttt_PlayerTurn
            SET turn = 
                CASE
                WHEN turn = 'X' THEN 'O'
                WHEN turn = 'O' THEN 'X'
                END;
    END IF;
    -- Check if victory is achieved
    EXEC ttt_Check_Victory
END



DROP PROCEDURE IF EXISTS ttt_ResetBoard;

CREATE PROCEDURE ttt_ResetBoard AS
BEGIN
UPDATE TicTacToe 
SET A=NULL
,B=NULL
,C=NULL 
WHERE ID IN (1,2,3);

UPDATE ttt_PlayerTurn 
SET turn = 'X';
END


EXEC ttt_PlayerMove X,A,1;
EXEC ttt_PlayerMove O,C,2;

EXEC ttt_CheckVictory;
EXEC ttt_ResetBoard;