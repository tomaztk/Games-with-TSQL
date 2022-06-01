USE [Battleship]
GO
/****** Object:  Table [dbo].[LU_Ship]    Script Date: 12/15/2007 19:43:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LU_Ship](
	[Id] [tinyint] NOT NULL,
	[Name] [nvarchar](20) NOT NULL,
	[Length] [tinyint] NOT NULL,
	[Points] [tinyint] NOT NULL,
 CONSTRAINT [PK_LU_Ship] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LU_Result]    Script Date: 12/15/2007 19:43:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LU_Result](
	[Id] [tinyint] NOT NULL,
	[Description] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_LU_Result] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Game]    Script Date: 12/15/2007 19:43:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Game](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DatePlayed] [date] NOT NULL,
	[TimePlayed] [time](7) NOT NULL,
	[WinnerPlayerId] [int] NULL,
 CONSTRAINT [PK_Game] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Player]    Script Date: 12/15/2007 19:43:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Player](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_Player] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GamePlayer]    Script Date: 12/15/2007 19:43:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GamePlayer](
	[GameId] [int] NOT NULL,
	[PlayerId] [int] NOT NULL,
	[Score] [tinyint] NOT NULL,
	[PlayOrder] [tinyint] NOT NULL,
 CONSTRAINT [PK_GamePlayer] PRIMARY KEY CLUSTERED 
(
	[GameId] ASC,
	[PlayerId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GamePlayerShot]    Script Date: 12/15/2007 19:43:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GamePlayerShot](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[GameId] [int] NOT NULL,
	[PlayerId] [int] NOT NULL,
	[Point] [geometry] NULL,
	[Result] [tinyint] NOT NULL,
 CONSTRAINT [PK_GamePlayerShot] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GamePlayerShip]    Script Date: 12/15/2007 19:43:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GamePlayerShip](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[GameId] [int] NOT NULL,
	[PlayerId] [int] NOT NULL,
	[ShipId] [tinyint] NOT NULL,
	[Line] [geometry] NOT NULL,
	[Hits] [tinyint] NOT NULL,
 CONSTRAINT [PK_GamePlayerShip] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[Shoot]    Script Date: 12/15/2007 19:43:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Shoot] (
  @GameId   INT
, @PlayerId INT
, @X TINYINT
, @Y TINYINT
) AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @NumberOfShips TINYINT
	SET @NumberOfShips = 5
	
	DECLARE @point geometry
	SET @point = geometry::STGeomFromText('POINT('+CAST(@X AS VARCHAR(2))+' '+CAST(@Y AS VARCHAR(2))+')',4326);

	DECLARE @GamePlayerShipId INT
	DECLARE @ShipId INT
	DECLARE @Result INT
	SET @Result = 0

	-- Already tried that point?
	SELECT @Result = COUNT(*) 
	FROM   GamePlayerShot 
	WHERE  Point.STIntersects(@point) = 1
	AND	   GameId = @GameId
	AND	   PlayerId = @PlayerId

	IF @Result > 0
	BEGIN -- already tried, we could tell Player, but instead we'll say "Miss"
	      -- and skip all other processing
		SET @Result = 0
		INSERT INTO GamePlayerShot VALUES (@GameId, @PlayerId, @point, @Result)
	END
	ELSE
	BEGIN
		-- Hit test: does the point intersect a ship 'line'?
		SELECT 	@GamePlayerShipId = Id
			,	@ShipId = ShipId
		FROM	GamePlayerShip
		WHERE	[Line].STIntersects(@point) = 1
		AND		GameId = @GameId
		AND		PlayerId = @PlayerId

		IF @GamePlayerShipId IS NOT NULL 
		BEGIN -- HIT!
			-- Update the Ship
			UPDATE GamePlayerShip
			SET    Hits = Hits + 1
			WHERE  GameId = @GameId
			AND    PlayerId = @PlayerId
			AND    ShipId = @ShipId
			
			-- Check if Ship is sunk
			SELECT @Result = CASE WHEN (GPS.Hits = LS.Length) THEN 2
					ELSE 1 END
			FROM   GamePlayerShip GPS
			INNER JOIN LU_Ship LS ON LS.Id = GPS.ShipId
			WHERE  GameId = @GameId
			AND    PlayerId = @PlayerId
			AND    ShipId = @ShipId
		END
		
		-- Save Shot record
		INSERT INTO GamePlayerShot VALUES (@GameId, @PlayerId, @point, @Result)

		IF @Result = 2
		BEGIN -- Sunk one, check all
			SELECT @Result = CASE 
				WHEN COUNT(GPS.Id) = @NumberOfShips THEN 3
				ELSE 2 
				END
			FROM    GamePlayerShip GPS
			INNER JOIN LU_Ship LS ON LS.Id = GPS.ShipId
				AND GPS.Hits = LS.Length -- sunk
			WHERE   GameId = @GameId
			AND     PlayerId = @PlayerId
		END
		
		IF @Result = 3
		BEGIN -- Game won, update score (useful in future for loser's score)
			UPDATE GamePlayer
			SET    Score = (SELECT SUM(LS.Points)
			FROM   GamePlayerShip GPS
			INNER JOIN LU_Ship LS 
				ON  LS.Id = GPS.ShipId
				AND LS.Length = GPS.Hits
			WHERE 	GPS.GameId = @GameId
			AND     GPS.PlayerId = @PlayerId)
			WHERE   GamePlayer.GameId = @GameId
			AND     GamePlayer.PlayerId = @PlayerId
			
			UPDATE Game
			SET    WinnerPlayerId = @PlayerId
				,  TimePlayed = GETDATE()
			WHERE  Id = @GameId
		END

	END -- already tried
	
	SELECT @Result AS [Result]
		 , Description
	FROM LU_Result WHERE Id = @Result

END
GO
/****** Object:  StoredProcedure [dbo].[ResetGame]    Script Date: 12/15/2007 19:43:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ResetGame] (
	@GameId INT	
) AS
BEGIN
	SET NOCOUNT ON;
	UPDATE Game
	SET WinnerPlayerId = NULL
	WHERE Id = @GameId

	UPDATE GamePlayer
	SET Score = 0
	WHERE GameId = @GameId
	
	UPDATE GamePlayerShip 
	SET Hits = 0 
	WHERE GameId = @GameId
	
	DELETE FROM GamePlayerShot 
	WHERE GameId = @GameId

END
GO
/****** Object:  StoredProcedure [dbo].[Cheat]    Script Date: 12/15/2007 19:43:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Cheat] (
	@GameId INT
,	@PlayerId INT
) AS
BEGIN
	SET NOCOUNT ON;
	SELECT	LS.Name   AS [Ship]
		,	LS.Length AS [ShipLength]
		,	GPS.Hits  AS [NumberOfHits]
		,	GPS.Line.STAsText() AS [Location] 
	FROM    GamePlayerShip GPS
	INNER JOIN LU_Ship LS ON LS.Id = GPS.ShipId
	WHERE	GPS.GameId = @GameId
	AND		GPS.PlayerId = @PlayerId
END
GO
/****** Object:  StoredProcedure [dbo].[AddShip]    Script Date: 12/15/2007 19:43:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddShip] (
  @GameId   INT
, @PlayerId INT
, @ShipId INT
, @StartX TINYINT
, @StartY TINYINT
, @EndX TINYINT
, @EndY TINYINT
) AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @line varchar(500);
	DECLARE @overlaps TINYINT
	
	SET @line = 'LINESTRING('+CAST(@StartX AS VARCHAR(2))+' '+CAST(@StartY AS VARCHAR(2))+
				','+CAST(@EndX AS VARCHAR(2))+' '+CAST(@EndY AS VARCHAR(2))+')'
	
	SELECT @overlaps = COUNT(ShipId) 
	FROM   GamePlayerShip
	WHERE  GameId = @GameId
	AND    PlayerId = @PlayerId
	AND    Line.STIntersects(geometry::STGeomFromText(@line, 4326)) = 1

	IF @overlaps = 0 
		INSERT INTO GamePlayerShip
		( GameId, PlayerId, ShipId, Line, Hits) 
		VALUES 
		(@GameId, @PlayerId, @ShipId, geometry::STGeomFromText(@line, 4326), 0) -- default hits: 0
	ELSE
		RAISERROR(N'Ship overlaps existing ships', 10, 10)
END
GO
/****** Object:  StoredProcedure [dbo].[NewGame]    Script Date: 12/15/2007 19:43:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[NewGame] (
	@Name NVARCHAR(100)
) AS
BEGIN
	--SET NOCOUNT ON;
	DECLARE @GameId   INT
	DECLARE @PlayerId INT
	DECLARE @BoardSize INT
	SET @BoardSize = 10

	INSERT INTO Game VALUES (GETDATE(), GETDATE(),NULL)
	SET @GameId = SCOPE_IDENTITY()

	SELECT @PlayerId = Id
	FROM   Player 
	WHERE Name = @Name
	IF @PlayerId IS NULL
	BEGIN
		INSERT INTO Player VALUES (@Name)
		SET @PlayerId = SCOPE_IDENTITY()
	END 
	
	INSERT INTO GamePlayer VALUES (@GameId, @PlayerId, 0, 0)

	DECLARE @StartX TINYINT
	DECLARE @StartY TINYINT
	DECLARE @EndX TINYINT
	DECLARE @EndY TINYINT
	DECLARE @Orientation BIT

	DECLARE ShipCursor CURSOR FOR
	SELECT Id, Length FROM LU_Ship ORDER BY Length DESC

	OPEN ShipCursor  --- (remember to CLOSE IT LATER)
	--- We need to make containers for the Cursor Info
	DECLARE @ShipId TINYINT; DECLARE @ShipLength TINYINT

	FETCH NEXT FROM ShipCursor INTO @ShipId, @ShipLength
	WHILE (@@FETCH_STATUS <> -1)
	BEGIN
		DECLARE @placed BIT
		SET @placed = 0
		WHILE (@placed = 0)
		BEGIN
			PRINT '--- Placing ship '+CAST (@ShipId AS VARCHAR(2))
			
			SET @Orientation = ROUND(RAND(),0)
			IF @Orientation = 0
			BEGIN -- 'Horizontal'
				SET @StartX = ROUND(RAND()*(@BoardSize-1-@ShipLength)+1,0)
				SET @StartY = ROUND(RAND()*(@BoardSize-1)+1,0)
				SET @EndX = @StartX + @ShipLength - 1
				SET @EndY = @StartY
			END
			ELSE
			BEGIN -- 'Vertical'
				SET @StartX = ROUND(RAND()*(@BoardSize-1)+1,0)
				SET @StartY = ROUND(RAND()*(@BoardSize-1-@ShipLength)+1,0)
				SET @EndX = @StartX 
				SET @EndY = @StartY + @ShipLength - 1
			END

			PRINT 'Start:'+CAST (@StartX AS VARCHAR(2)) +','+CAST(@StartY AS VARCHAR(2))
				+ ' End:'+CAST (@EndX AS VARCHAR(2)) +','+CAST(@EndY AS VARCHAR(2))

			EXEC AddShip @GameId, @PlayerId, @ShipId, @StartX, @StartY, @EndX, @EndY
				
			SELECT @placed  = COUNT(*)
			FROM   GamePlayerShip
			WHERE  GameId   = @GameId
			AND    PlayerId = @PlayerId
			AND    ShipId   = @ShipId
		END -- WHILE
		SET @placed = 0
	FETCH NEXT FROM ShipCursor INTO @ShipId, @ShipLength
	END
	CLOSE ShipCursor
	DEALLOCATE ShipCursor
	
	SELECT @GameId AS GameId
	,      @PlayerId AS PlayerId
	,      'Game ready to begin. Use EXEC Shoot ' 
			+ CAST(@GameId AS VARCHAR(10)) + ',' 
			+ CAST(@PlayerId AS VARCHAR(10)) + ',' 
			+ '[x],[y] -- to play'
END
GO
/****** Object:  Default [DF_LU_Ship_Length]    Script Date: 12/15/2007 19:43:50 ******/
ALTER TABLE [dbo].[LU_Ship] ADD  CONSTRAINT [DF_LU_Ship_Length]  DEFAULT ((0)) FOR [Length]
GO
/****** Object:  Default [DF_Game_DatePlayed]    Script Date: 12/15/2007 19:43:50 ******/
ALTER TABLE [dbo].[Game] ADD  CONSTRAINT [DF_Game_DatePlayed]  DEFAULT (getdate()) FOR [DatePlayed]
GO
/****** Object:  Default [DF_Game_TimePlayer]    Script Date: 12/15/2007 19:43:50 ******/
ALTER TABLE [dbo].[Game] ADD  CONSTRAINT [DF_Game_TimePlayer]  DEFAULT (getdate()) FOR [TimePlayed]
GO
/****** Object:  Default [DF_GamePlayer_Score]    Script Date: 12/15/2007 19:43:50 ******/
ALTER TABLE [dbo].[GamePlayer] ADD  CONSTRAINT [DF_GamePlayer_Score]  DEFAULT ((0)) FOR [Score]
GO
/****** Object:  Default [DF_GamePlayer_PlayOrder]    Script Date: 12/15/2007 19:43:50 ******/
ALTER TABLE [dbo].[GamePlayer] ADD  CONSTRAINT [DF_GamePlayer_PlayOrder]  DEFAULT ((0)) FOR [PlayOrder]
GO
/****** Object:  Default [DF_GamePlayerShot_Result]    Script Date: 12/15/2007 19:43:50 ******/
ALTER TABLE [dbo].[GamePlayerShot] ADD  CONSTRAINT [DF_GamePlayerShot_Result]  DEFAULT ((0)) FOR [Result]
GO
/****** Object:  Default [DF_GamePlayerShip_Hits]    Script Date: 12/15/2007 19:43:50 ******/
ALTER TABLE [dbo].[GamePlayerShip] ADD  CONSTRAINT [DF_GamePlayerShip_Hits]  DEFAULT ((0)) FOR [Hits]
GO
/****** Object:  ForeignKey [FK_GamePlayer_Game]    Script Date: 12/15/2007 19:43:50 ******/
ALTER TABLE [dbo].[GamePlayer]  WITH CHECK ADD  CONSTRAINT [FK_GamePlayer_Game] FOREIGN KEY([GameId])
REFERENCES [dbo].[Game] ([Id])
GO
ALTER TABLE [dbo].[GamePlayer] CHECK CONSTRAINT [FK_GamePlayer_Game]
GO
/****** Object:  ForeignKey [FK_GamePlayer_Player]    Script Date: 12/15/2007 19:43:50 ******/
ALTER TABLE [dbo].[GamePlayer]  WITH CHECK ADD  CONSTRAINT [FK_GamePlayer_Player] FOREIGN KEY([PlayerId])
REFERENCES [dbo].[Player] ([Id])
GO
ALTER TABLE [dbo].[GamePlayer] CHECK CONSTRAINT [FK_GamePlayer_Player]
GO
/****** Object:  ForeignKey [FK_GamePlayerShot_GamePlayer]    Script Date: 12/15/2007 19:43:50 ******/
ALTER TABLE [dbo].[GamePlayerShot]  WITH CHECK ADD  CONSTRAINT [FK_GamePlayerShot_GamePlayer] FOREIGN KEY([GameId], [PlayerId])
REFERENCES [dbo].[GamePlayer] ([GameId], [PlayerId])
GO
ALTER TABLE [dbo].[GamePlayerShot] CHECK CONSTRAINT [FK_GamePlayerShot_GamePlayer]
GO
/****** Object:  ForeignKey [FK_GamePlayerShot_LU_Result]    Script Date: 12/15/2007 19:43:50 ******/
ALTER TABLE [dbo].[GamePlayerShot]  WITH CHECK ADD  CONSTRAINT [FK_GamePlayerShot_LU_Result] FOREIGN KEY([Result])
REFERENCES [dbo].[LU_Result] ([Id])
GO
ALTER TABLE [dbo].[GamePlayerShot] CHECK CONSTRAINT [FK_GamePlayerShot_LU_Result]
GO
/****** Object:  ForeignKey [FK_GamePlayerShip_GamePlayer]    Script Date: 12/15/2007 19:43:50 ******/
ALTER TABLE [dbo].[GamePlayerShip]  WITH CHECK ADD  CONSTRAINT [FK_GamePlayerShip_GamePlayer] FOREIGN KEY([GameId], [PlayerId])
REFERENCES [dbo].[GamePlayer] ([GameId], [PlayerId])
GO
ALTER TABLE [dbo].[GamePlayerShip] CHECK CONSTRAINT [FK_GamePlayerShip_GamePlayer]
GO
/****** Object:  ForeignKey [FK_GamePlayerShip_LU_Ship]    Script Date: 12/15/2007 19:43:50 ******/
ALTER TABLE [dbo].[GamePlayerShip]  WITH CHECK ADD  CONSTRAINT [FK_GamePlayerShip_LU_Ship] FOREIGN KEY([ShipId])
REFERENCES [dbo].[LU_Ship] ([Id])
GO
ALTER TABLE [dbo].[GamePlayerShip] CHECK CONSTRAINT [FK_GamePlayerShip_LU_Ship]
GO
