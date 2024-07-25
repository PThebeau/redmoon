USE [redmoon]
GO
/****** Object:  Table [dbo].[tblConnectionLog]    Script Date: 07/25/2024 12:01:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblConnectionLog](
	[LogID] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [varchar](50) NOT NULL,
	[LoginTime] [datetime] NOT NULL,
	[IPAddress] [varchar](50) NOT NULL,
	[SessionID] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[LogID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[sp_LogConnection]    Script Date: 07/25/2024 12:01:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_LogConnection]
    @UserName VARCHAR(50),
    @LoginTime DATETIME,
    @IPAddress VARCHAR(50),
    @SessionID VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO tblConnectionLog (UserName, LoginTime, IPAddress, SessionID)
    VALUES (@UserName, @LoginTime, @IPAddress, @SessionID);
END
GO
/****** Object:  Table [dbo].[tblOccupiedBillID]    Script Date: 07/25/2024 12:01:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblOccupiedBillID](
	[BillID] [varchar](14) NOT NULL,
	[ServerIndex] [int] NOT NULL,
	[IPNumber] [int] NOT NULL,
	[LoginTime] [datetime] NOT NULL,
	[KillBillID] [bit] NOT NULL,
	[GameID] [varchar](50) NULL,
 CONSTRAINT [PK_tblOccupiedBillID] PRIMARY KEY CLUSTERED 
(
	[BillID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblBillID]    Script Date: 07/25/2024 12:01:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblBillID](
	[Version2] [int] NOT NULL,
	[BillID] [varchar](14) NOT NULL,
	[Password] [varchar](28) NOT NULL,
	[FirstLogin] [datetime] NULL,
	[LastLogin] [datetime] NULL,
	[LastLogout] [datetime] NULL,
	[TotalRunTime] [int] NULL,
	[ThisMonthTime] [int] NULL,
	[FreeLevel] [int] NULL,
	[FreeTimer] [int] NULL,
	[FreeDate] [datetime] NULL,
	[TempFreeDate] [datetime] NULL,
	[TempModifyDate] [datetime] NULL,
	[SecurityNum1] [int] NOT NULL,
	[SecurityNum2] [int] NOT NULL,
	[EMail] [char](80) NULL,
	[Address] [char](120) NULL,
	[Name] [char](40) NULL,
	[TelephoneNumber] [char](40) NULL,
	[Profile] [char](92) NULL,
	[Memo] [char](512) NULL,
	[BillState] [char](20) NULL,
	[FirstLoginMethod] [char](2) NULL,
	[Note1] [char](50) NULL,
	[Note2] [char](50) NULL,
	[Note3] [char](50) NULL,
	[Note4] [char](50) NULL,
	[Note5] [char](50) NULL,
	[Note6] [char](50) NULL,
	[Note7] [char](50) NULL,
	[Note8] [char](50) NULL,
	[Note9] [char](50) NULL,
	[Note10] [char](50) NULL,
	[is_hardcore] [bit] NOT NULL,
 CONSTRAINT [PK_tblBillID] PRIMARY KEY NONCLUSTERED 
(
	[BillID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblHardcoreCharacters]    Script Date: 07/25/2024 12:01:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblHardcoreCharacters](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[GameID] [varchar](255) NOT NULL,
	[Lvl] [int] NOT NULL,
	[SubQuestGiftFame] [int] NOT NULL,
	[CreatedAt] [datetime] NULL,
	[LastLogin] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[UpdateLog]    Script Date: 07/25/2024 12:01:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UpdateLog](
	[LogID] [int] IDENTITY(1,1) NOT NULL,
	[LogTime] [datetime] NULL,
	[Message] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[LogID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[AdjustSTotalBonus]    Script Date: 07/25/2024 12:01:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Create a stored procedure to adjust STotalBonus based on SubQuestGiftFame
CREATE PROCEDURE [dbo].[AdjustSTotalBonus]
    @playerName VARCHAR(255)
AS
BEGIN
    DECLARE @maxRebirths INT
    DECLARE @maxBonusPerRebirth INT
    DECLARE @adjustedBonus INT

    -- Set the maximum allowed rebirths and maximum bonus per rebirth
    SET @maxRebirths = 10
    SET @maxBonusPerRebirth = 2000 -- Adjust this value based on your game's rules

    -- Calculate the adjusted bonus
    SELECT @adjustedBonus = 
        CASE 
            WHEN (SELECT SubQuestGiftFame FROM tblGameID1 WHERE GameID = @playerName) * @maxBonusPerRebirth <= @maxRebirths * @maxBonusPerRebirth 
            THEN (SELECT SubQuestGiftFame FROM tblGameID1 WHERE GameID = @playerName) * @maxBonusPerRebirth 
            ELSE @maxRebirths * @maxBonusPerRebirth 
        END

    -- Update the STotalBonus for the player
    UPDATE tblGameID1 SET STotalBonus = @adjustedBonus WHERE GameID = @playerName
END
GO
/****** Object:  Table [dbo].[tblGameID1]    Script Date: 07/25/2024 12:01:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblGameID1](
	[Version] [int] NOT NULL,
	[GameID] [varchar](14) NOT NULL,
	[BillID] [varchar](14) NOT NULL,
	[Lvl] [int] NOT NULL,
	[Face] [tinyint] NOT NULL,
	[Map] [int] NOT NULL,
	[X] [int] NOT NULL,
	[Y] [int] NOT NULL,
	[TileKind] [bit] NOT NULL,
	[Item] [varchar](2000) NOT NULL,
	[Equipment] [varchar](280) NOT NULL,
	[Skill] [varchar](120) NOT NULL,
	[SpecialSkill] [varchar](20) NOT NULL,
	[Strength] [int] NOT NULL,
	[Spirit] [int] NOT NULL,
	[Dexterity] [int] NOT NULL,
	[Power] [int] NOT NULL,
	[Fame] [int] NOT NULL,
	[Experiment] [int] NULL,
	[HP] [int] NOT NULL,
	[MP] [int] NOT NULL,
	[SP] [int] NOT NULL,
	[DP] [int] NOT NULL,
	[Bonus] [int] NOT NULL,
	[Money] [int] NOT NULL,
	[QuickItem] [varchar](160) NOT NULL,
	[QuickSkill] [int] NOT NULL,
	[QuickSpecialSkill] [int] NOT NULL,
	[BankMoney] [int] NOT NULL,
	[BankItem] [varchar](400) NOT NULL,
	[SETimer] [varchar](400) NOT NULL,
	[PKTimer] [int] NOT NULL,
	[Color1] [int] NULL,
	[Color2] [int] NULL,
	[PoisonUsedDate] [datetime] NOT NULL,
	[LovePoint] [int] NOT NULL,
	[ArmyHired] [int] NOT NULL,
	[ArmyMarkIndex] [int] NOT NULL,
	[Permission] [int] NOT NULL,
	[BonusInitCount] [int] NOT NULL,
	[StoryQuestState] [int] NULL,
	[QuestItem] [varchar](100) NOT NULL,
	[SubQuestKind] [int] NOT NULL,
	[SubQuestDone] [int] NOT NULL,
	[SubQuestClientNPCID] [varchar](14) NOT NULL,
	[SubQuestClientNPCFace] [int] NOT NULL,
	[SubQuestClientNPCMap] [int] NOT NULL,
	[SubQuestItem] [varchar](20) NOT NULL,
	[SubQuestDestFace] [int] NOT NULL,
	[SubQuestDestMap] [int] NOT NULL,
	[SubQuestTimer] [int] NOT NULL,
	[SubQuestGiftExperience] [int] NOT NULL,
	[SubQuestGiftFame] [int] NOT NULL,
	[SubQuestGiftItem] [varchar](20) NOT NULL,
	[OPArmy] [int] NOT NULL,
	[OPPKTimer] [int] NOT NULL,
	[SurvivalEvent] [int] NOT NULL,
	[SurvivalTime] [int] NOT NULL,
	[Bonus2] [int] NOT NULL,
	[SBonus] [int] NOT NULL,
	[STotalBonus] [int] NOT NULL,
	[PKPenaltyCount] [int] NOT NULL,
	[PKPenaltyDecreaseTimer] [int] NOT NULL,
	[SigMoney] [int] NOT NULL,
	[BankSigMoney] [int] NOT NULL,
	[BankItem2] [varchar](400) NOT NULL,
	[TLETimer] [varchar](400) NOT NULL,
 CONSTRAINT [PK_tblGameID] PRIMARY KEY NONCLUSTERED 
(
	[GameID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[UpdateLevelOnRebirth]    Script Date: 07/25/2024 12:01:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Assuming SubQuestGiftFame and Lvl columns are of INT type

CREATE PROCEDURE [dbo].[UpdateLevelOnRebirth]
    @playerName VARCHAR(255)
AS
BEGIN
    DECLARE @rebirthCount INT
    DECLARE @currentLevel INT

    -- Get the rebirth count and current level for the player
    SELECT @rebirthCount = SubQuestGiftFame,
           @currentLevel = Lvl
    FROM tblGameID1
    WHERE GameID = @playerName;

    -- Check if the rebirth count is now 10 and current level is 1000
    IF @rebirthCount = 10 AND @currentLevel = 1000
    BEGIN
        -- Update the Lvl column to 1010
        UPDATE tblGameID1
        SET Lvl = 1010
        WHERE GameID = @playerName;
    END
END;
GO
/****** Object:  StoredProcedure [dbo].[RMS_INITBONUS2]    Script Date: 07/25/2024 12:01:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_INITBONUS2]
    @GameID varchar(14)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION;

    UPDATE tblGameID1
    SET Bonus2 = 0
    WHERE GameID = @GameID AND SBonus > STotalBonus;

    UPDATE tblGameID1
    SET SBonus = STotalBonus, STotalBonus = STotalBonus
    WHERE GameID = @GameID AND STotalBonus >= SBonus;

    COMMIT TRANSACTION;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_MAX_LVL]    Script Date: 07/25/2024 12:01:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_MAX_LVL]
    @GameID varchar(14),
    @STotalBonus int
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @update_lvl_error int;

    BEGIN TRANSACTION RMS_MAX_LVL;

    SELECT @STotalBonus = STotalBonus 
    FROM tblGameID1 
    WHERE GameID = @GameID;

    IF @STotalBonus >= 20001
    BEGIN
        UPDATE tblGameID1 
        SET Experiment = 0 
        WHERE GameID = @GameID;

        SET @update_lvl_error = @@ERROR;

        IF @update_lvl_error = 0
        BEGIN
            COMMIT TRANSACTION RMS_MAX_LVL;
        END
        ELSE
        BEGIN
            ROLLBACK TRANSACTION RMS_MAX_LVL;
        END
    END
    ELSE
    BEGIN
        ROLLBACK TRANSACTION RMS_MAX_LVL;
    END
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_USERDB_SETUSERLEVELUP]    Script Date: 07/25/2024 12:01:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_USERDB_SETUSERLEVELUP]
    @Level int,
    @Experience int,
    @HP int,
    @MP int,
    @SP int,
    @DP int,
    @BONUS int,
    @StoryQuestState int,
    @QuestItem varchar(100),
    @GameID varchar(14)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @update_levelup_error int;

    BEGIN TRANSACTION RMS_USERDB_SETUSERLEVELUP;

    -- Set user level up
    UPDATE tblGameID1
    SET lvl = @Level, experiment = @Experience, HP = @HP, MP = @MP, SP = @SP, DP = @DP, BONUS = @BONUS, 
        StoryQuestState = @StoryQuestState, QuestItem = @QuestItem
    WHERE GameID = @GameID;

    SET @update_levelup_error = @@ERROR;

    -- Commit or rollback transaction based on error
    IF @update_levelup_error = 0
    BEGIN
        COMMIT TRANSACTION RMS_USERDB_SETUSERLEVELUP;
    END
    ELSE
    BEGIN
        ROLLBACK TRANSACTION RMS_USERDB_SETUSERLEVELUP;
    END
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_USERDB_SETUSERITEM]    Script Date: 07/25/2024 12:01:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RMS_USERDB_SETUSERITEM]
    @Item varchar(2000),
    @QuickItem varchar(160),
    @Equipment varchar(280),
    @Money int,
    @SigMoney int,
    @GameID varchar(14)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @update_item_error int;

    BEGIN TRANSACTION RMS_USERDB_SETUSERITEM;

    -- Set user item
    UPDATE tblGameID1
    SET item = @Item, quickitem = @QuickItem, equipment = @Equipment, money = @Money, sigmoney = @SigMoney
    WHERE GameID = @GameID;

    SET @update_item_error = @@ERROR;

    -- Commit or rollback transaction based on error
    IF @update_item_error = 0
    BEGIN
        COMMIT TRANSACTION RMS_USERDB_SETUSERITEM;
    END
    ELSE
    BEGIN
        ROLLBACK TRANSACTION RMS_USERDB_SETUSERITEM;
    END
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_USERDB_SETUSEREXP]    Script Date: 07/25/2024 12:01:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_USERDB_SETUSEREXP]
    @Experience int,
    @GameID varchar(14)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @update_exp_error int;

    BEGIN TRANSACTION RMS_USERDB_SETUSEREXP;

    -- Set user experience
    UPDATE tblGameID1
    SET experiment = @Experience
    WHERE GameID = @GameID;

    SET @update_exp_error = @@ERROR;

    -- Commit or rollback transaction based on error
    IF @update_exp_error = 0
    BEGIN
        COMMIT TRANSACTION RMS_USERDB_SETUSEREXP;
    END
    ELSE
    BEGIN
        ROLLBACK TRANSACTION RMS_USERDB_SETUSEREXP;
    END
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_REMOVEMAPITEM]    Script Date: 07/25/2024 12:01:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_REMOVEMAPITEM]
    @ItemKind int,
    @ItemIndex int,
    @ItemDurability int,
    @ItemAttackGrade int,
    @ItemStrengthGrade int,
    @ItemSpiritGrade int,
    @ItemDexterityGrade int,
    @ItemPowerGrade int,
    @ItemCount int,
    @Position int,
    @Map int,
    @X int,
    @Y int,
    @TileKind int
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION;

    IF @ItemIndex NOT IN (69, 70, 71, 72)
    BEGIN
        DECLARE @SQLStatement varchar(1024);
        SET @SQLStatement = 'DELETE FROM tblSpecialItem1 
                             WHERE ID IN (SELECT TOP ' + CONVERT(varchar, @ItemCount) + ' ID 
                             FROM tblSpecialItem1 
                             WHERE Position = ' + CONVERT(varchar, @Position) +
                             ' AND ItemKind = ' + CONVERT(varchar, @ItemKind) +
                             ' AND ItemIndex = ' + CONVERT(varchar, @ItemIndex) +
                             ' AND ItemDurability = ' + CONVERT(varchar, @ItemDurability) +
                             ' AND AttackGrade = ' + CONVERT(varchar, @ItemAttackGrade) +
                             ' AND StrengthGrade = ' + CONVERT(varchar, @ItemStrengthGrade) +
                             ' AND SpiritGrade = ' + CONVERT(varchar, @ItemSpiritGrade) +
                             ' AND DexterityGrade = ' + CONVERT(varchar, @ItemDexterityGrade) +
                             ' AND PowerGrade = ' + CONVERT(varchar, @ItemPowerGrade) +
                             ' AND Map = ' + CONVERT(varchar, @Map) +
                             ' AND X = ' + CONVERT(varchar, @X) +
                             ' AND Y = ' + CONVERT(varchar, @Y) +
                             ' AND TileKind = ' + CONVERT(varchar, @TileKind) + ')';
        EXEC (@SQLStatement);

        -- Uncomment the following lines if you want to log the deletion
        -- IF @@ROWCOUNT > 0
        -- BEGIN
        --     INSERT INTO tblSpecialItemLog1 (LogKind, ItemKind, ItemIndex, ItemDurability, Position, Map, X, Y, TileKind, LogItemCount, AttackGrade, StrengthGrade, SpiritGrade, DexterityGrade, PowerGrade) 
        --     VALUES (101, @ItemKind, @ItemIndex, @ItemDurability, @Position, @Map, @X, @Y, @TileKind, @@ROWCOUNT, @ItemAttackGrade, @ItemStrengthGrade, @ItemSpiritGrade, @ItemDexterityGrade, @ItemPowerGrade);
        -- END
    END

    COMMIT TRANSACTION;
END
GO
/****** Object:  Table [dbo].[tblShopTimeUseLog]    Script Date: 07/25/2024 12:01:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblShopTimeUseLog](
	[RegNumber] [varchar](12) NOT NULL,
	[ShopTimeLimit] [int] NOT NULL,
	[LoginTime] [datetime] NOT NULL,
	[ConnTime] [datetime] NOT NULL,
	[UseTime] [int] NOT NULL,
	[TimeDiff] [int] NOT NULL,
	[IPAddress] [varchar](15) NOT NULL,
	[BillID] [varchar](14) NOT NULL,
	[ServerNumber] [int] NOT NULL,
 CONSTRAINT [PK_tblShopTimeUseLog] PRIMARY KEY NONCLUSTERED 
(
	[RegNumber] ASC,
	[ConnTime] ASC,
	[BillID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblShopStatistics]    Script Date: 07/25/2024 12:01:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblShopStatistics](
	[Time] [datetime] NOT NULL,
	[TotalShopCount] [int] NOT NULL,
	[TotalTimeUseCount] [int] NOT NULL,
	[TotalDateUseCount] [int] NOT NULL,
	[TotalTimeDateUseCount] [int] NOT NULL,
	[TotalNotUseCount] [int] NOT NULL,
	[TotalUseCount] [int] NOT NULL,
	[TotalNotRegisterCount] [int] NOT NULL,
	[TotalRegisterCount] [int] NOT NULL,
	[TotalEventCount] [int] NOT NULL,
	[TotalRegisterEventCount] [int] NOT NULL,
	[TotalNotRegisterEventCount] [int] NOT NULL,
	[TotalNotRegisterNotEventCount] [int] NOT NULL,
	[TotalNotRegisterNotEventUseCount] [int] NOT NULL,
	[OnlyEventCount] [int] NOT NULL,
	[OddServiceCount] [int] NOT NULL,
	[EventToTimeMoneyCount] [int] NOT NULL,
	[EventToDateMoneyCount] [int] NOT NULL,
	[EventToTimeDateMoneyCount] [int] NOT NULL,
	[EventTimeMoneyCount] [int] NOT NULL,
	[EventDateMoneyCount] [int] NOT NULL,
	[EventTimeDateMoneyCount] [int] NOT NULL,
	[TimeMoneyToXToEventCount] [int] NOT NULL,
	[DateMoneyToXToEventCount] [int] NOT NULL,
	[TimeDateMoneyToXToEventCount] [int] NOT NULL,
	[TimeMoneyCount] [int] NOT NULL,
	[DateMoneyCount] [int] NOT NULL,
	[TimeDateMoney] [int] NOT NULL,
	[EventToXCount] [int] NOT NULL,
	[OnlyRegisterCount] [int] NOT NULL,
	[EventTimeMoneyToXCount] [int] NOT NULL,
	[EventDateMoneyToXCount] [int] NOT NULL,
	[EventTimeDateMoneyToXCount] [int] NOT NULL,
	[EventToTimeMoneyToXCount] [int] NOT NULL,
	[EventToDateMoneyToXCount] [int] NOT NULL,
	[EventToTimeDateMoneyToXCount] [int] NOT NULL,
	[TimeMoneyToXCount] [int] NOT NULL,
	[DateMoneyToXCount] [int] NOT NULL,
	[TimeDateMoneyToXCount] [int] NOT NULL,
 CONSTRAINT [PK_tblShopStatistics] PRIMARY KEY NONCLUSTERED 
(
	[Time] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblShopIP]    Script Date: 07/25/2024 12:01:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblShopIP](
	[IPAddress] [varchar](15) NOT NULL,
	[RegNumber] [varchar](12) NOT NULL,
	[FirstLogin] [datetime] NULL,
	[RecentLogin] [datetime] NULL,
	[RecentLogout] [datetime] NULL,
	[TotalUseTime] [int] NULL,
	[Using] [smallint] NULL,
	[IPServerIndex] [int] NULL,
	[ConnKind] [int] NOT NULL,
 CONSTRAINT [PK_tblIPInfo] PRIMARY KEY NONCLUSTERED 
(
	[IPAddress] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblShopEventLog]    Script Date: 07/25/2024 12:01:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblShopEventLog](
	[OperatorID] [char](14) NOT NULL,
	[Time] [datetime] NOT NULL,
	[RegNumber] [char](12) NOT NULL,
	[EventNum] [int] NOT NULL,
	[Content] [char](1000) NOT NULL,
	[EndTime] [datetime] NOT NULL,
	[Hour] [int] NOT NULL,
 CONSTRAINT [PK_tblShopEventLog] PRIMARY KEY NONCLUSTERED 
(
	[RegNumber] ASC,
	[EventNum] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblShopEventCfg]    Script Date: 07/25/2024 12:01:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblShopEventCfg](
	[EventNum] [int] IDENTITY(1,1) NOT NULL,
	[EventName] [char](100) NOT NULL,
	[Type] [int] NOT NULL,
	[Term] [int] NOT NULL,
	[Hour] [int] NOT NULL,
	[Condition] [int] NOT NULL,
	[EndOption] [int] NOT NULL,
 CONSTRAINT [PK_tblShopEventCfg] PRIMARY KEY NONCLUSTERED 
(
	[EventNum] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblShopEvent]    Script Date: 07/25/2024 12:01:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblShopEvent](
	[RegNumber] [char](12) NOT NULL,
	[EventNum] [int] NOT NULL,
	[StartTime] [datetime] NOT NULL,
	[EndTime] [datetime] NOT NULL,
	[Type] [int] NOT NULL,
	[Condition] [int] NOT NULL,
	[EndOption] [int] NOT NULL,
 CONSTRAINT [PK_tblShopEvent] PRIMARY KEY NONCLUSTERED 
(
	[RegNumber] ASC,
	[EventNum] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblShopBillLog2]    Script Date: 07/25/2024 12:01:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblShopBillLog2](
	[Idx] [int] IDENTITY(1,1) NOT NULL,
	[RegNumber] [char](12) NOT NULL,
	[RequestTime] [datetime] NOT NULL,
	[Tick] [int] NOT NULL,
	[IsPaid] [int] NOT NULL,
	[PayKind] [int] NOT NULL,
	[Amount] [int] NOT NULL,
	[Purpose] [int] NOT NULL,
	[Term] [int] NOT NULL,
	[Minute] [int] NOT NULL,
	[Bonus] [int] NOT NULL,
	[BillName] [char](40) NOT NULL,
	[BankName] [char](40) NOT NULL,
	[Telephone] [char](40) NULL,
	[OperatorID] [varchar](14) NOT NULL,
	[Note] [char](100) NOT NULL,
 CONSTRAINT [PK_tblShopBillLog2] PRIMARY KEY NONCLUSTERED 
(
	[Idx] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblShopBillLog]    Script Date: 07/25/2024 12:01:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblShopBillLog](
	[OperatorID] [varchar](14) NOT NULL,
	[Time] [datetime] NOT NULL,
	[Tick] [int] NOT NULL,
	[IsPaid] [int] NOT NULL,
	[PayKind] [int] NOT NULL,
	[RegNumber] [char](12) NOT NULL,
	[WarbibleIP] [int] NOT NULL,
	[RedMoonIP] [int] NOT NULL,
	[Term] [int] NOT NULL,
	[ConfirmDate] [datetime] NOT NULL,
	[BillName] [char](40) NOT NULL,
	[BankName] [char](40) NOT NULL,
	[Note] [char](100) NOT NULL,
	[Amount] [int] NOT NULL,
	[Kind] [char](10) NULL,
	[Minute] [int] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblShop]    Script Date: 07/25/2024 12:01:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblShop](
	[RegNumber] [varchar](12) NOT NULL,
	[ShopName] [varchar](40) NOT NULL,
	[PresidentName] [varchar](40) NOT NULL,
	[Telephone] [varchar](40) NOT NULL,
	[Fax] [varchar](40) NULL,
	[Address] [varchar](120) NULL,
	[EMail] [varchar](50) NULL,
	[ISP] [char](40) NULL,
	[DateLimit] [datetime] NOT NULL,
	[TempDateLimit] [datetime] NULL,
	[TimeLimit] [int] NOT NULL,
	[TimeLimitModifyDate] [datetime] NOT NULL,
	[ConcurrentIPCount] [int] NOT NULL,
	[TempConcurrentIPCount] [int] NOT NULL,
	[TempModifyDate] [datetime] NOT NULL,
	[RegDate] [datetime] NOT NULL,
	[WarbibleIP] [int] NULL,
	[RedMoonIP] [int] NULL,
	[MonthPay] [int] NULL,
	[Memo] [char](512) NULL,
	[SSN1] [int] NOT NULL,
	[SSN2] [int] NOT NULL,
	[DueName] [varchar](40) NULL,
	[Condition] [varchar](40) NULL,
	[Kind] [varchar](20) NULL,
	[BillState] [varchar](20) NOT NULL,
	[Note1] [varchar](50) NOT NULL,
	[Note2] [varchar](50) NOT NULL,
	[Note3] [varchar](50) NOT NULL,
	[Note4] [varchar](50) NOT NULL,
	[Note5] [varchar](50) NOT NULL,
	[Note6] [varchar](50) NOT NULL,
	[Note7] [varchar](50) NOT NULL,
	[Note8] [varchar](50) NOT NULL,
	[Note9] [varchar](50) NOT NULL,
	[Note10] [varchar](50) NOT NULL,
	[TempTimeLimit] [int] NULL,
 CONSTRAINT [PK_tblPCShop] PRIMARY KEY NONCLUSTERED 
(
	[RegNumber] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblRiceRank]    Script Date: 07/25/2024 12:01:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblRiceRank](
	[ID] [char](15) NOT NULL,
	[RiceCount] [int] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblRedmoonEvent]    Script Date: 07/25/2024 12:01:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblRedmoonEvent](
	[RegID] [int] IDENTITY(1,1) NOT NULL,
	[BillID] [varchar](14) NOT NULL,
	[GameID] [varchar](14) NOT NULL,
	[RegDate] [datetime] NOT NULL,
	[EventID] [int] NOT NULL,
	[ItemID] [int] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblPPPCorpIP]    Script Date: 07/25/2024 12:01:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblPPPCorpIP](
	[IPAddress] [varchar](15) NOT NULL,
	[CorpID] [int] NOT NULL,
	[FirstLogin] [datetime] NULL,
	[RecentLogin] [datetime] NULL,
	[RecentLogout] [datetime] NULL,
	[TotalUseTime] [int] NOT NULL,
 CONSTRAINT [PK_tblPPPCorpIP] PRIMARY KEY NONCLUSTERED 
(
	[IPAddress] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblPlayerIPLog]    Script Date: 07/25/2024 12:01:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblPlayerIPLog](
	[LogID] [int] IDENTITY(1,1) NOT NULL,
	[GameID] [varchar](14) NOT NULL,
	[IPAddress] [varchar](50) NOT NULL,
	[LogTime] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[LogID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblPayLog]    Script Date: 07/25/2024 12:01:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblPayLog](
	[Idx] [int] IDENTITY(1,1) NOT NULL,
	[ID] [char](20) NOT NULL,
	[Time] [datetime] NOT NULL,
	[Amount] [int] NOT NULL,
	[Purpose] [int] NOT NULL,
	[PayKind] [int] NOT NULL,
	[BillName] [char](20) NOT NULL,
	[BankName] [char](20) NOT NULL,
	[OperatorID] [char](20) NOT NULL,
	[OldTimeLimit] [datetime] NOT NULL,
	[OldMinute] [int] NOT NULL,
	[NewTimeLimit] [datetime] NOT NULL,
	[NewMinute] [int] NOT NULL,
	[Note] [char](100) NULL,
 CONSTRAINT [PK_tblPayLog] PRIMARY KEY NONCLUSTERED 
(
	[Idx] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblPasswordLog]    Script Date: 07/25/2024 12:01:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblPasswordLog](
	[BillID] [char](14) NOT NULL,
	[SecurityNum1] [int] NOT NULL,
	[SecurityNum2] [int] NOT NULL,
	[Name] [char](20) NOT NULL,
	[Phone] [char](14) NOT NULL,
	[Time] [datetime] NOT NULL,
	[Type] [int] NOT NULL,
	[oldPass] [char](10) NOT NULL,
	[newPass] [char](10) NOT NULL,
	[Remote_Host] [char](15) NOT NULL,
	[Remote_Addr] [char](15) NOT NULL,
 CONSTRAINT [PK_tblPasswordLog] PRIMARY KEY NONCLUSTERED 
(
	[BillID] ASC,
	[Time] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblOperatorLog]    Script Date: 07/25/2024 12:01:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblOperatorLog](
	[OperatorID] [varchar](14) NOT NULL,
	[Time] [datetime] NOT NULL,
	[BillID] [varchar](14) NOT NULL,
	[GameID] [varchar](14) NULL,
	[OperatorLog] [varchar](1000) NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblOperatorID]    Script Date: 07/25/2024 12:01:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblOperatorID](
	[OperatorID] [varchar](14) NOT NULL,
	[Name] [varchar](40) NOT NULL,
	[Password] [varchar](20) NOT NULL,
 CONSTRAINT [PK_tblOperatorID] PRIMARY KEY NONCLUSTERED 
(
	[OperatorID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblOperatorConnectionLog]    Script Date: 07/25/2024 12:01:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblOperatorConnectionLog](
	[Time] [datetime] NOT NULL,
	[OperatorID] [varchar](14) NOT NULL,
	[Kind] [int] NOT NULL,
	[IP] [char](15) NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblOccupiedGameID1]    Script Date: 07/25/2024 12:01:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblOccupiedGameID1](
	[GameID] [varchar](14) NULL,
	[ServerIndex] [int] NULL,
	[IPNumber] [int] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblOccupiedGameID]    Script Date: 07/25/2024 12:01:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblOccupiedGameID](
	[GameID] [varchar](14) NOT NULL,
	[ServerIndex] [int] NOT NULL,
	[IPNumber] [int] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblOccupiedBillID1]    Script Date: 07/25/2024 12:01:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblOccupiedBillID1](
	[BillID] [varchar](14) NOT NULL,
	[ServerIndex] [int] NOT NULL,
	[IPNumber] [int] NOT NULL,
	[LoginTime] [datetime] NOT NULL,
	[KillBillID] [bit] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[RMS_ARMY_SENDEXPIRATIONNOTICE]    Script Date: 07/25/2024 12:01:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Create a dummy stored procedure to handle RMS_ARMY_SENDEXPIRATIONNOTICE errors
CREATE PROCEDURE [dbo].[RMS_ARMY_SENDEXPIRATIONNOTICE]
AS
BEGIN
    RETURN;
END
GO
/****** Object:  StoredProcedure [dbo].[10k_Sign]    Script Date: 07/25/2024 12:01:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[10k_Sign]
AS
set nocount on
declare @GameID varchar(14), @SubQuestGiftFame int
BEGIN
select @GameID=GameID, @SubQuestGiftFame=SubQuestGiftFame FROM INSERTED
IF @SubQuestGiftFame = 10
BEGIN
UPDATE tblGameID1 set OPArmy = 1 WHERE GameID = @GameID
END
END
GO
/****** Object:  StoredProcedure [dbo].[CreateUserLogTable]    Script Date: 07/25/2024 12:01:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CreateUserLogTable]  
AS  
BEGIN  
    DECLARE @tableName NVARCHAR(128) = 'tblUserLog1_' + CONVERT(VARCHAR(6), GETDATE(), 112);  
    IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(@tableName) AND type in (N'U'))  
    BEGIN  
        EXEC('CREATE TABLE ' + @tableName + '(  
            UserName VARCHAR(50),  
            LoginTime DATETIME,  
            LogoutTime DATETIME,  
            Status INT,  
            SessionID INT,  
            Extra1 VARCHAR(50),  
            Extra2 VARCHAR(50),  
            IPAddress VARCHAR(50)  
        )');  
    END;  
END;
GO
/****** Object:  StoredProcedure [dbo].[CreateUserCountLogTable]    Script Date: 07/25/2024 12:01:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CreateUserCountLogTable]
AS
BEGIN
    DECLARE @tableName NVARCHAR(128) = 'tblUserCountLog1_' + CONVERT(VARCHAR(6), GETDATE(), 112)
    IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(@tableName) AND type in (N'U'))
    BEGIN
        EXEC('CREATE TABLE ' + @tableName + '(
            Time DATETIME,
            ServerName VARCHAR(255),
            UserCount INT,
            First INT
        )')
    END
END
GO
/****** Object:  StoredProcedure [dbo].[CreateMailLogTable]    Script Date: 07/25/2024 12:01:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CreateMailLogTable]
AS
BEGIN
    DECLARE @tableName NVARCHAR(128) = 'tblMailLog1_' + CONVERT(VARCHAR(6), GETDATE(), 112);
    IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(@tableName) AND type in (N'U'))
    BEGIN
        EXEC('CREATE TABLE ' + @tableName + '(
            LogTime DATETIME,
            ActionType VARCHAR(50),
            Status VARCHAR(50),
            EventTime DATETIME,
            Sender VARCHAR(50),
            Recipient VARCHAR(50),
            ItemList VARCHAR(MAX),
            Location VARCHAR(MAX),
            Notes VARCHAR(MAX),
            AdditionalInfo VARCHAR(MAX),
            Amount INT
        )')
    END
END
GO
/****** Object:  StoredProcedure [dbo].[CreateLevelLogTable]    Script Date: 07/25/2024 12:01:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CreateLevelLogTable]
AS
BEGIN
    DECLARE @tableName NVARCHAR(128) = 'tblLevelLog1_' + CONVERT(VARCHAR(6), GETDATE(), 112)
    IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(@tableName) AND type in (N'U'))
    BEGIN
        EXEC('CREATE TABLE ' + @tableName + '(
            GameID VARCHAR(50),
            BillID VARCHAR(50),
            Lvl INT,
            Face INT,
            Time DATETIME,
            Strength INT,
            Spirit INT,
            Dexterity INT,
            Power INT,
            Fame INT,
            BonusInitCount INT,
            StoryQuestState INT,
            QuestItem VARCHAR(MAX),
            OPPKTimer INT
        )')
    END
END
GO
/****** Object:  StoredProcedure [dbo].[CreateItemLogTable]    Script Date: 07/25/2024 12:01:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CreateItemLogTable]
AS
BEGIN
    DECLARE @tableName NVARCHAR(128) = 'tblItemLog1_' + CONVERT(VARCHAR(6), GETDATE(), 112)
    IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(@tableName) AND type in (N'U'))
    BEGIN
        EXEC('CREATE TABLE ' + @tableName + '(
            LogKind VARCHAR(50),
            MapNumber INT,
            FromID VARCHAR(50),
            ToID VARCHAR(50),
            ItemKind INT,
            ItemIndex INT,
            ItemCount INT
        )')
    END
END
GO
/****** Object:  StoredProcedure [dbo].[CreateDeathLogTable]    Script Date: 07/25/2024 12:01:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CreateDeathLogTable]
AS
BEGIN
    DECLARE @tableName NVARCHAR(128) = 'tblDeathLog1_' + CONVERT(VARCHAR(6), GETDATE(), 112)
    IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(@tableName) AND type in (N'U'))
    BEGIN
        EXEC('CREATE TABLE ' + @tableName + '(
            GameID VARCHAR(50),
            BillID VARCHAR(50),
            Time DATETIME,
            Map INT,
            X INT,
            Y INT,
            TileKind INT,
            Item VARCHAR(MAX),
            Equipment VARCHAR(MAX),
            Experience INT,
            Money INT,
            SigMoney INT,
            QuickItem VARCHAR(MAX),
            Fame INT,
            KillerID VARCHAR(50),
            KillerFame INT,
            Dead INT,
            KillerLevel INT,
            KillerStrength INT,
            KillerSpirit INT,
            KillerDexterity INT,
            KillerPower INT
        )')
    END
END
GO
/****** Object:  Table [dbo].[BlockedIPs]    Script Date: 07/25/2024 12:01:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[BlockedIPs](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[ip_address] [varchar](45) NULL,
	[blocked_until] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PurchaseLog]    Script Date: 07/25/2024 12:01:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PurchaseLog](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[GameID] [varchar](14) NOT NULL,
	[Item] [varchar](255) NOT NULL,
	[ItemKind] [int] NOT NULL,
	[ItemIndex] [int] NOT NULL,
	[Price] [decimal](10, 2) NOT NULL,
	[PurchaseTime] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PlayerIPLog]    Script Date: 07/25/2024 12:01:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PlayerIPLog](
	[LogID] [int] IDENTITY(1,1) NOT NULL,
	[BillID] [varchar](14) NOT NULL,
	[ServerIndex] [int] NOT NULL,
	[IPAddress] [varchar](45) NOT NULL,
	[LoginTime] [datetime] NOT NULL,
	[GameID] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[LogID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[LogMailActivity]    Script Date: 07/25/2024 12:01:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[LogMailActivity]
    @ActivityTime DATETIME,
    @Event VARCHAR(50),
    @Status VARCHAR(50),
    @EventTime DATETIME,
    @Recipient VARCHAR(50),
    @Sender VARCHAR(50),
    @Content1 VARCHAR(200),
    @Content2 VARCHAR(200),
    @Content3 VARCHAR(200),
    @Content4 VARCHAR(200),
    @Value INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @TableName NVARCHAR(128);
    DECLARE @SQL NVARCHAR(MAX);

    -- Generate the table name based on the current month
    SET @TableName = 'tblMailLog1_' + CONVERT(VARCHAR(6), GETDATE(), 112);

    -- Check if the table exists, if not, create it
    IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = @TableName)
    BEGIN
        SET @SQL = 'CREATE TABLE ' + @TableName + ' (
                        ActivityTime DATETIME,
                        Event VARCHAR(50),
                        Status VARCHAR(50),
                        EventTime DATETIME,
                        Recipient VARCHAR(50),
                        Sender VARCHAR(50),
                        Content1 VARCHAR(200),
                        Content2 VARCHAR(200),
                        Content3 VARCHAR(200),
                        Content4 VARCHAR(200),
                        Value INT
                    )';
        EXEC sp_executesql @SQL;
    END

    -- Insert data into the dynamically generated table
    SET @SQL = 'INSERT INTO ' + @TableName + ' (ActivityTime, Event, Status, EventTime, Recipient, Sender, Content1, Content2, Content3, Content4, Value) 
                VALUES (@ActivityTime, @Event, @Status, @EventTime, @Recipient, @Sender, @Content1, @Content2, @Content3, @Content4, @Value)';
    EXEC sp_executesql @SQL, 
                       N'@ActivityTime DATETIME, @Event VARCHAR(50), @Status VARCHAR(50), @EventTime DATETIME, @Recipient VARCHAR(50), @Sender VARCHAR(50), @Content1 VARCHAR(200), @Content2 VARCHAR(200), @Content3 VARCHAR(200), @Content4 VARCHAR(200), @Value INT',
                       @ActivityTime, @Event, @Status, @EventTime, @Recipient, @Sender, @Content1, @Content2, @Content3, @Content4, @Value;
END
GO
/****** Object:  StoredProcedure [dbo].[LogErrorToFile]    Script Date: 07/25/2024 12:01:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[LogErrorToFile]
    @ErrorMessage NVARCHAR(MAX)
AS
BEGIN
    DECLARE @cmd NVARCHAR(4000);
    SET @cmd = 'bcp "SELECT ''' + REPLACE(@ErrorMessage, '''', '''''') + '''" queryout "C:\Redmoon3.8\Bin\Log\errorlog.txt" -c -T';
    
    -- Print the command for debugging
    PRINT @cmd;

    -- Execute the command
    EXEC xp_cmdshell @cmd;
END
GO
/****** Object:  StoredProcedure [dbo].[LogDisconnectRequest]    Script Date: 07/25/2024 12:01:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Create the stored procedure to log disconnect requests
CREATE PROCEDURE [dbo].[LogDisconnectRequest]
    @GameID VARCHAR(14)
AS
BEGIN
    INSERT INTO DisconnectRequests (GameID) VALUES (@GameID);
END
GO
/****** Object:  StoredProcedure [dbo].[LogAction]    Script Date: 07/25/2024 12:01:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[LogAction]
    @UserID VARCHAR(14),
    @ActionType VARCHAR(50),
    @Details VARCHAR(MAX)
AS
BEGIN
    INSERT INTO ActionLog (UserID, ActionType, Details) 
    VALUES (@UserID, @ActionType, @Details);
END
GO
/****** Object:  Table [dbo].[ItemLotteryLog]    Script Date: 07/25/2024 12:01:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ItemLotteryLog](
	[LogID] [int] IDENTITY(1,1) NOT NULL,
	[GameID] [varchar](14) NULL,
	[ItemKind] [int] NULL,
	[ItemIndex] [int] NULL,
	[AwardedAt] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[LogID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[InsertUserLog]    Script Date: 07/25/2024 12:01:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertUserLog]  
    @UserName VARCHAR(50),  
    @LoginTime DATETIME,  
    @LogoutTime DATETIME,  
    @Status INT,  
    @SessionID INT,  
    @Extra1 VARCHAR(50) = '',  
    @Extra2 VARCHAR(50) = '',  
    @IPAddress VARCHAR(50)
AS  
BEGIN  
    SET NOCOUNT ON;  
  
    DECLARE @tableName NVARCHAR(128);  
    SET @tableName = 'tblUserLog1_' + CONVERT(VARCHAR(6), GETDATE(), 112);  
  
    -- Construct the dynamic SQL for the INSERT statement  
    DECLARE @sql NVARCHAR(MAX);  
    SET @sql = 'INSERT INTO ' + @tableName + ' (UserName, LoginTime, LogoutTime, Status, SessionID, Extra1, Extra2, IPAddress)   
                VALUES (@UserName, @LoginTime, @LogoutTime, @Status, @SessionID, @Extra1, @Extra2, @IPAddress)';  
  
    -- Execute the dynamic SQL  
    EXEC sp_executesql @sql,  
        N'@UserName VARCHAR(50), @LoginTime DATETIME, @LogoutTime DATETIME, @Status INT, @SessionID INT, @Extra1 VARCHAR(50), @Extra2 VARCHAR(50), @IPAddress VARCHAR(50)',  
        @UserName, @LoginTime, @LogoutTime, @Status, @SessionID, @Extra1, @Extra2, @IPAddress;  
END;
GO
/****** Object:  Table [dbo].[tblMysteryPillLimit]    Script Date: 07/25/2024 12:01:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblMysteryPillLimit](
	[GameID] [varchar](16) NOT NULL,
	[LMCount] [int] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblMegaPassLog]    Script Date: 07/25/2024 12:01:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblMegaPassLog](
	[Idx] [int] IDENTITY(1,1) NOT NULL,
	[Time] [datetime] NOT NULL,
	[FreeDateFrom] [datetime] NOT NULL,
	[FreeDateTo] [datetime] NOT NULL,
	[BixelID] [char](20) NOT NULL,
	[MegaPassID] [char](20) NOT NULL,
	[LoginID] [char](20) NOT NULL,
	[Option1] [int] NULL,
	[Option2] [int] NULL,
	[Option] [char](20) NULL,
 CONSTRAINT [PK_tblMegaPassLog] PRIMARY KEY NONCLUSTERED 
(
	[Idx] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblMedalResult1]    Script Date: 07/25/2024 12:01:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblMedalResult1](
	[GameID] [varchar](16) NOT NULL,
	[GoldMedal] [int] NOT NULL,
	[SilverMedal] [int] NOT NULL,
	[BronzeMedal] [int] NOT NULL,
 CONSTRAINT [PK_tblMedalResult1] PRIMARY KEY CLUSTERED 
(
	[GameID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblMaxLMCount]    Script Date: 07/25/2024 12:01:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblMaxLMCount](
	[GameID] [varchar](14) NOT NULL,
	[MaxLM] [int] NOT NULL,
	[GambledBP] [int] NOT NULL,
	[BPFromLM] [int] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblMailLog1_202407]    Script Date: 07/25/2024 12:01:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblMailLog1_202407](
	[Time] [datetime] NOT NULL,
	[Kind] [char](17) NOT NULL,
	[State] [char](14) NOT NULL,
	[RecvTime] [datetime] NOT NULL,
	[Recipient] [varchar](14) NOT NULL,
	[Sender] [varchar](14) NOT NULL,
	[MailItem] [varchar](100) NOT NULL,
	[Item] [varchar](1200) NOT NULL,
	[Equipment] [varchar](160) NOT NULL,
	[QuickItem] [varchar](90) NOT NULL,
	[Money] [int] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblMail1]    Script Date: 07/25/2024 12:01:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblMail1](
	[Time] [datetime] NOT NULL,
	[Recipient] [varchar](16) NOT NULL,
	[Sender] [varchar](16) NOT NULL,
	[ReadOrNot] [int] NOT NULL,
	[Title] [char](80) NOT NULL,
	[Line] [int] NOT NULL,
	[Content] [varchar](1000) NOT NULL,
	[Item] [varchar](100) NOT NULL,
 CONSTRAINT [PK_tblMail] PRIMARY KEY NONCLUSTERED 
(
	[Time] ASC,
	[Recipient] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[RMS_KASAMSPACESHIPMAIL]    Script Date: 07/25/2024 12:01:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_KASAMSPACESHIPMAIL]
    @GameID varchar(14),
    @Time datetime
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @updatestoryqueststate_error int, @insertmail_error int;

    BEGIN TRANSACTION;

    UPDATE tblGameID1
    SET StoryQuestState = StoryQuestState | 16384
    WHERE GameID = @GameID;

    SELECT @updatestoryqueststate_error = @@ERROR;

    INSERT INTO tblMail1 (Time, Recipient, Sender, ReadOrNot, Title, Line, Content, Item)
    VALUES (@Time, @GameID, '[Kasham]', 0, 'Leaving for Signus', 14,
    'This is Kasham.

Hopefully you have succeeded with the test
that you faced in the Himalayas.

Time is short! I have repaired the space ship
as best I could and believe it will be able to
take you to Signus, but only if you leave soon.

So, please contact me as soon as possible
so that you can make the journey to Signus
and put an end to the evil Aguilas...

The fight goes on!', '');

    SELECT @insertmail_error = @@ERROR;

    IF @updatestoryqueststate_error = 0 AND @insertmail_error = 0
    BEGIN
        COMMIT TRANSACTION;
    END
    ELSE
    BEGIN
        ROLLBACK TRANSACTION;
    END
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_BEGINSPYQUEST]    Script Date: 07/25/2024 12:01:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_BEGINSPYQUEST]
	@GameID varchar(14),
	@Time datetime
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @updatestoryqueststate_error int, @insertmail_error int;

	BEGIN TRANSACTION;

	UPDATE tblGameID1 
	SET StoryQuestState = StoryQuestState | 1 
	WHERE GameID = @GameID;

	SET @updatestoryqueststate_error = @@ERROR;

	INSERT INTO tblMail1 
		(Time, Recipient, Sender, ReadOrNot, Title, Line, Content, Item) 
	VALUES 
		(@Time, @GameID, 'Kasham', 0, 'Find Aguilas Spy', 28, 
		'I am Kasham. Sorry for this urgent mail.

But, I have to hurry because this is really
important.  You know, after the Great Disaster in
Signus, Signus had fallen under the control of
the traitor Aguilas and he began to suppress all
his opponents.

According to my secret agent, he started to
reach his hands on Earth. He is eager to
conquer the Earth for abundant resources unlike
exhausted Signus.

Also, they have a plan to eliminate you because
they think you might be a genuine SUN, our
savior.

Hurry up to find their base station. According to
my agent, a spy of Aguilas leads you a chase.
You have to discover their secrets. If you get
it, go to our agent and give it to him. He
disguises himself as an archaeologist.

Regards.

P.S.: According to my agent, the spy hides in the
upper right side of Street 1.', '');

	SET @insertmail_error = @@ERROR;

	IF @updatestoryqueststate_error = 0 AND @insertmail_error = 0
	BEGIN
		COMMIT TRANSACTION;
	END
	ELSE
	BEGIN
		ROLLBACK TRANSACTION;
	END
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_BEGINCAPTAINYQUEST]    Script Date: 07/25/2024 12:01:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_BEGINCAPTAINYQUEST]
	@GameID varchar(14),
	@Time datetime
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @updatestoryqueststate_error int, @insertmail_error int;

	BEGIN TRANSACTION;

	UPDATE tblGameID1 
	SET StoryQuestState = StoryQuestState | 128 
	WHERE GameID = @GameID;

	SET @updatestoryqueststate_error = @@ERROR;

	INSERT INTO tblMail1 
		(Time, Recipient, Sender, ReadOrNot, Title, Line, Content, Item) 
	VALUES 
		(@Time, @GameID, 'Kasham', 0, 'Locating Aguilas Base', 22, 
		'Hello. This is Kasham. I have to contact you for an urgent problem.

I''ve heard strange reports about Sahara these days.
My agents witnessed, in near a shrine of Sahara,
Aguilas spies working suspiciously. Although, you
destroyed Aguila''s post base, this seems not safe
for the rest of us.

According to one of our spies, there are many Aguilas
bases on Earth and an Earth Commander of Aguilas
is controlling all those bases from that shrine.

People will not be suspicious if their commander hides
in that shrine in the middle of Sahara and no one knows how
to get inside.

You have to unmask a conspiracy that Aguilas tries to
kill the Sun.

I wish you accomplish this mission soon.', '');

	SET @insertmail_error = @@ERROR;

	IF @updatestoryqueststate_error = 0 AND @insertmail_error = 0
	BEGIN
		COMMIT TRANSACTION;
	END
	ELSE
	BEGIN
		ROLLBACK TRANSACTION;
	END
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_ADDBONUSINITQUEST]    Script Date: 07/25/2024 12:01:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_ADDBONUSINITQUEST]
	@GameID varchar(14),
	@Time datetime
AS

	set nocount on

declare @increasebonusinitcount_error int, @insertmail_error int

	begin transaction

	update tblGameID1 set BonusInitCount = BonusInitCount + 1 where GameID = @GameID

	select @increasebonusinitcount_error = @@ERROR

	insert tblMail1 (Time, Recipient, Sender, ReadOrNot, Title, Line, Content, Item) values(@Time, @GameID, '[Kasham]', 0, 'Urgent Message from Kasham', 11, 'I am Kasham. You may remember me from the last
quest. I am one of the scientists from the
state-of-the-art lab in Signus. I have been
sent to help you out.

I heard that you are suffering from wrong
distribution of your attributes. Visit our agent
disguising as a doctor. Our adavanced medical
art will solve your problem.

I will contact you again if something happens.
Please take care of yourself.', '')

	select @insertmail_error = @@ERROR

	if @increasebonusinitcount_error = 0 AND @insertmail_error = 0
	begin

		commit transaction

	end
	else
	begin

		rollback transaction

	end
GO
/****** Object:  Table [dbo].[tblLMTrackingLog]    Script Date: 07/25/2024 12:01:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblLMTrackingLog](
	[Creator] [varchar](50) NOT NULL,
	[TimeCreate] [datetime] NOT NULL,
	[Consumer] [varchar](50) NOT NULL,
	[TimeConsume] [datetime] NULL,
	[BPGiven] [int] NOT NULL,
	[ItemID] [int] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblLevelLog1_202407]    Script Date: 07/25/2024 12:01:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[tblLevelLog1_202407](
	[GameID] [varchar](50) NOT NULL,
	[BillID] [varchar](50) NOT NULL,
	[Lvl] [int] NOT NULL,
	[Face] [int] NOT NULL,
	[Time] [datetime] NOT NULL,
	[Strength] [int] NOT NULL,
	[Spirit] [int] NOT NULL,
	[Dexterity] [int] NOT NULL,
	[Power] [int] NOT NULL,
	[Fame] [int] NOT NULL,
	[BonusInitCount] [int] NOT NULL,
	[StoryQuestState] [int] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
SET ANSI_PADDING ON
ALTER TABLE [dbo].[tblLevelLog1_202407] ADD [QuestItem] [varchar](max) NULL
ALTER TABLE [dbo].[tblLevelLog1_202407] ADD [OPPKTimer] [int] NOT NULL
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblLegalProtection1]    Script Date: 07/25/2024 12:01:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblLegalProtection1](
	[Protector] [varchar](14) NOT NULL,
	[Assaulter] [varchar](14) NOT NULL,
	[LegalDefenseTimer] [int] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblItemLotteryList1]    Script Date: 07/25/2024 12:01:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblItemLotteryList1](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[GameID] [varchar](14) NOT NULL,
	[ItemKind] [int] NOT NULL,
	[ItemIndex] [int] NOT NULL,
	[LotteryNumber] [char](29) NOT NULL,
	[UseTime] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblItemLog1_202407]    Script Date: 07/25/2024 12:01:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[tblItemLog1_202407](
	[LogKind] [varchar](50) NOT NULL,
	[MapNumber] [int] NOT NULL,
	[FromID] [varchar](50) NOT NULL,
	[ToID] [varchar](50) NOT NULL,
	[ItemKind] [int] NOT NULL,
	[ItemIndex] [int] NOT NULL,
	[ItemCount] [int] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblItemDreamBoxListLog1]    Script Date: 07/25/2024 12:01:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblItemDreamBoxListLog1](
	[DreamBoxNumber] [char](36) NOT NULL,
	[ItemKind] [int] NOT NULL,
	[ItemIndex] [int] NOT NULL,
	[ItemDurability] [int] NOT NULL,
	[ItemName] [varchar](50) NOT NULL,
	[GameID] [varchar](14) NOT NULL,
	[UseTime] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[DreamBoxNumber] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblIndependenceDayEvent1]    Script Date: 07/25/2024 12:01:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblIndependenceDayEvent1](
	[GameID] [varchar](14) NOT NULL,
	[BillID] [varchar](14) NOT NULL,
	[Time] [datetime] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblHiredSoldierList1]    Script Date: 07/25/2024 12:01:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblHiredSoldierList1](
	[ArmyID] [int] NOT NULL,
	[HiredSoldier] [varchar](14) NOT NULL,
 CONSTRAINT [PK_tblHiredSoldierList1] PRIMARY KEY NONCLUSTERED 
(
	[HiredSoldier] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblGroupInfo1]    Script Date: 07/25/2024 12:01:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblGroupInfo1](
	[GroupNum] [int] NOT NULL,
	[bGroupMaster] [bit] NOT NULL,
	[UserID] [varchar](16) NOT NULL,
	[Face] [tinyint] NOT NULL,
	[MapNumber] [int] NOT NULL,
 CONSTRAINT [PK_tblGroupInfo6] PRIMARY KEY NONCLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblGMCommandLog1]    Script Date: 07/25/2024 12:01:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblGMCommandLog1](
	[Time] [datetime] NOT NULL,
	[GameMaster] [varchar](16) NOT NULL,
	[Target] [varchar](16) NOT NULL,
	[Command] [int] NOT NULL,
	[Kind1] [int] NOT NULL,
	[Kind2] [int] NOT NULL,
	[Kind3] [int] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblGamePartyResult1]    Script Date: 07/25/2024 12:01:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblGamePartyResult1](
	[BillID] [varchar](14) NOT NULL,
	[GameID] [varchar](16) NOT NULL,
	[BeginLevel] [int] NULL,
	[EndLevel] [int] NULL,
	[UseTime] [int] NULL,
 CONSTRAINT [PK_tblGamePartyResult1] PRIMARY KEY NONCLUSTERED 
(
	[BillID] ASC,
	[GameID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblGameParty]    Script Date: 07/25/2024 12:01:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblGameParty](
	[Idx] [int] IDENTITY(1,1) NOT NULL,
	[Time] [datetime] NOT NULL,
	[BillID] [char](15) NOT NULL,
	[ServerNum] [int] NOT NULL,
	[GameID] [char](15) NOT NULL,
	[Phone] [char](14) NOT NULL,
	[City] [char](10) NOT NULL,
	[State] [char](10) NOT NULL,
 CONSTRAINT [PK_tblGameParty] PRIMARY KEY NONCLUSTERED 
(
	[Idx] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblGameIDRebirth]    Script Date: 07/25/2024 12:01:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblGameIDRebirth](
	[GameID] [varchar](14) NOT NULL,
	[RebirthCount] [int] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblGameIDExpand]    Script Date: 07/25/2024 12:01:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblGameIDExpand](
	[GameID] [varchar](14) NOT NULL,
	[AddMarkCount] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[GameID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblVersion]    Script Date: 07/25/2024 12:01:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblVersion](
	[Title] [char](40) NOT NULL,
	[Version] [int] NOT NULL,
	[ErrMsg] [char](1000) NULL,
 CONSTRAINT [PK_tblVersion] PRIMARY KEY NONCLUSTERED 
(
	[Title] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblVerifyLog]    Script Date: 07/25/2024 12:01:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblVerifyLog](
	[ID] [char](15) NOT NULL,
	[BILLNAME] [char](20) NOT NULL,
	[BANKNAME] [char](20) NOT NULL,
	[TELEPHONENMBE] [char](20) NOT NULL,
	[REQUESTTIME] [datetime] NOT NULL,
	[CONFIRMTIME] [datetime] NOT NULL,
	[TERM] [int] NOT NULL,
	[AMOUNT] [int] NOT NULL,
	[STATE] [int] NOT NULL,
	[NOTE] [char](100) NULL,
	[MINUTE] [int] NOT NULL,
 CONSTRAINT [PK_tblVerifyLog] PRIMARY KEY NONCLUSTERED 
(
	[ID] ASC,
	[REQUESTTIME] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [IX_tblVerifyLog] UNIQUE NONCLUSTERED 
(
	[ID] ASC,
	[REQUESTTIME] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblUSRMAdmin]    Script Date: 07/25/2024 12:01:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblUSRMAdmin](
	[AdminID] [varchar](14) NOT NULL,
	[Password] [varchar](14) NOT NULL,
	[AdminName] [varchar](20) NOT NULL,
	[AdminLvl] [int] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblUserStat1]    Script Date: 07/25/2024 12:01:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblUserStat1](
	[Time] [datetime] NOT NULL,
	[Total] [int] NOT NULL,
	[TotalMax] [int] NOT NULL,
	[Eval] [int] NOT NULL,
	[UserDate] [int] NOT NULL,
	[UserTime] [int] NOT NULL,
	[ShopDate] [int] NOT NULL,
	[ShopTime] [int] NOT NULL,
	[Event1] [int] NOT NULL,
	[Event2] [int] NOT NULL,
	[Event3] [int] NOT NULL,
	[Event4] [int] NOT NULL,
	[Event5] [int] NOT NULL,
	[Event6] [int] NOT NULL,
	[Event7] [int] NOT NULL,
	[Event8] [int] NOT NULL,
	[Event9] [int] NOT NULL,
	[Event10] [int] NOT NULL,
	[BBS1] [int] NOT NULL,
	[BBS2] [int] NOT NULL,
	[BBS3] [int] NOT NULL,
	[BBS4] [int] NOT NULL,
	[BBS5] [int] NOT NULL,
	[BBS6] [int] NOT NULL,
	[BBS7] [int] NOT NULL,
	[BBS8] [int] NOT NULL,
	[BBS9] [int] NOT NULL,
	[BBS10] [int] NOT NULL,
 CONSTRAINT [PK_tblUserStat1] PRIMARY KEY NONCLUSTERED 
(
	[Time] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblUserSanctionList1]    Script Date: 07/25/2024 12:01:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblUserSanctionList1](
	[GameID] [varchar](14) NOT NULL,
	[DueTime] [datetime] NOT NULL,
 CONSTRAINT [PK_tblUserSanctionList1] PRIMARY KEY CLUSTERED 
(
	[GameID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblUserLog1_202407]    Script Date: 07/25/2024 12:01:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblUserLog1_202407](
	[UserName] [varchar](50) NULL,
	[LoginTime] [datetime] NULL,
	[LogoutTime] [datetime] NULL,
	[Status] [int] NULL,
	[SessionID] [int] NULL,
	[Extra1] [varchar](50) NULL,
	[Extra2] [varchar](50) NULL,
	[IPAddress] [varchar](50) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblUserCountLog1_202407]    Script Date: 07/25/2024 12:01:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblUserCountLog1_202407](
	[Time] [datetime] NULL,
	[ServerName] [varchar](255) NULL,
	[UserCount] [int] NULL,
	[First] [int] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblUserCountLog1]    Script Date: 07/25/2024 12:01:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblUserCountLog1](
	[Time] [datetime] NOT NULL,
	[ServerName] [varchar](30) NOT NULL,
	[UserCount] [int] NOT NULL,
	[First] [int] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblUserBillLog]    Script Date: 07/25/2024 12:01:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblUserBillLog](
	[OperatorID] [varchar](14) NULL,
	[Time] [datetime] NOT NULL,
	[Tick] [int] NOT NULL,
	[IsPaid] [int] NOT NULL,
	[PayKind] [int] NOT NULL,
	[BillID] [varchar](14) NOT NULL,
	[UserName] [varchar](40) NOT NULL,
	[BillName] [char](40) NOT NULL,
	[BankName] [char](40) NOT NULL,
	[Telephone] [char](40) NOT NULL,
	[GameKind] [int] NOT NULL,
	[Term] [int] NOT NULL,
	[Note] [char](100) NOT NULL,
	[Amount] [int] NOT NULL,
	[Kind] [char](10) NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblSubArmyList1]    Script Date: 07/25/2024 12:01:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblSubArmyList1](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ArmyID] [int] NOT NULL,
	[Name] [varchar](14) NOT NULL,
	[SubCommander] [varchar](14) NOT NULL,
	[Password] [varchar](20) NOT NULL,
	[Permission] [int] NOT NULL,
	[Notice] [varchar](166) NOT NULL,
 CONSTRAINT [PK_tblSubArmyList1] PRIMARY KEY NONCLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblSpecialItemShopLog1]    Script Date: 07/25/2024 12:01:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblSpecialItemShopLog1](
	[Time] [datetime] NOT NULL,
	[GameID] [varchar](14) NOT NULL,
	[LogKind] [varchar](10) NOT NULL,
	[ShopNumber] [int] NOT NULL,
	[ItemKind] [int] NOT NULL,
	[ItemIndex] [int] NOT NULL,
	[ItemDurability] [int] NOT NULL,
	[ItemCount] [int] NOT NULL,
	[TotalItemCost] [int] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblSpecialItemShop1]    Script Date: 07/25/2024 12:01:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblSpecialItemShop1](
	[ShopNumber] [int] NOT NULL,
	[ItemKind] [int] NOT NULL,
	[ItemIndex] [int] NOT NULL,
	[ItemDurability] [int] NOT NULL,
	[ItemCount] [int] NOT NULL,
	[Price] [int] NOT NULL,
	[InstantItem] [int] NOT NULL,
 CONSTRAINT [PK_tblSpecialItemShop1] PRIMARY KEY NONCLUSTERED 
(
	[ShopNumber] ASC,
	[ItemKind] ASC,
	[ItemIndex] ASC,
	[ItemDurability] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblSpecialItemLog1]    Script Date: 07/25/2024 12:01:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblSpecialItemLog1](
	[LogID] [decimal](18, 0) IDENTITY(1,1) NOT NULL,
	[Time] [datetime] NOT NULL,
	[LogKind] [int] NOT NULL,
	[LogItemCount] [int] NOT NULL,
	[ID] [int] NOT NULL,
	[ItemKind] [int] NOT NULL,
	[ItemIndex] [int] NOT NULL,
	[ItemDurability] [int] NOT NULL,
	[Position] [int] NOT NULL,
	[Map] [int] NOT NULL,
	[X] [int] NOT NULL,
	[Y] [int] NOT NULL,
	[TileKind] [int] NOT NULL,
	[GameID] [varchar](16) NOT NULL,
	[WindowKind] [int] NOT NULL,
	[WindowIndex] [int] NOT NULL,
	[MiscTime] [datetime] NOT NULL,
	[AttackGrade] [int] NOT NULL,
	[StrengthGrade] [int] NOT NULL,
	[SpiritGrade] [int] NOT NULL,
	[DexterityGrade] [int] NOT NULL,
	[PowerGrade] [int] NOT NULL,
	[CNT] [int] NULL,
 CONSTRAINT [PK_tblSpecialItemLog1] PRIMARY KEY NONCLUSTERED 
(
	[LogID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblSpecialItemLimit1]    Script Date: 07/25/2024 12:01:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblSpecialItemLimit1](
	[ItemKind] [int] NOT NULL,
	[ItemIndex] [int] NOT NULL,
	[ItemCountLimit] [int] NOT NULL,
 CONSTRAINT [PK_tblSpecialItemLimit] PRIMARY KEY NONCLUSTERED 
(
	[ItemKind] ASC,
	[ItemIndex] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblSpecialItemGrowthLog1]    Script Date: 07/25/2024 12:01:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblSpecialItemGrowthLog1](
	[Time] [datetime] NOT NULL,
	[LogKind] [int] NOT NULL,
	[ResultLog] [int] NOT NULL,
	[GameID] [varchar](14) NOT NULL,
	[ItemKind] [int] NOT NULL,
	[ItemIndex] [int] NOT NULL,
	[ItemDurability] [int] NOT NULL,
	[ItemAttackGrade] [int] NOT NULL,
	[ItemStrengthGrade] [int] NOT NULL,
	[ItemSpiritGrade] [int] NOT NULL,
	[ItemDexterityGrade] [int] NOT NULL,
	[ItemPowerGrade] [int] NOT NULL,
	[UserExperience] [int] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblGambleResets]    Script Date: 07/25/2024 12:01:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblGambleResets](
	[GameID] [varchar](14) NOT NULL,
	[ResetsLeft] [int] NOT NULL,
	[ResetsUsed] [int] NOT NULL,
	[TimeUsed] [datetime] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblGambleResetPPills]    Script Date: 07/25/2024 12:01:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblGambleResetPPills](
	[ItemID] [int] NOT NULL,
	[GameID] [varchar](14) NOT NULL,
	[UseFlag] [int] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblFreeID]    Script Date: 07/25/2024 12:01:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblFreeID](
	[PortalID] [varchar](50) NOT NULL,
	[BillID] [varchar](50) NOT NULL,
	[State] [int] NOT NULL,
	[MakeTime] [datetime] NOT NULL,
	[CancelTime] [datetime] NULL,
	[Kind] [int] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblExciteGame]    Script Date: 07/25/2024 12:01:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblExciteGame](
	[PortalID] [char](20) NOT NULL,
	[BillID] [char](20) NOT NULL,
	[State] [int] NOT NULL,
	[MakeTime] [datetime] NOT NULL,
	[CancelTime] [datetime] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblExchange1_001]    Script Date: 07/25/2024 12:01:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblExchange1_001](
	[Time] [datetime] NOT NULL,
	[ItemKind] [int] NOT NULL,
	[ItemIndex] [int] NOT NULL,
	[ItemCount] [int] NOT NULL,
	[ItemPrice] [int] NOT NULL,
	[Seller] [varchar](16) NOT NULL,
	[Buyer] [varchar](16) NOT NULL,
	[SoldItemCount] [int] NOT NULL,
 CONSTRAINT [PK_tblExchange1_002] PRIMARY KEY NONCLUSTERED 
(
	[Time] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblEventLog]    Script Date: 07/25/2024 12:01:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblEventLog](
	[BillID] [varchar](14) NOT NULL,
	[Corp_code] [int] NULL,
	[GameName] [varchar](10) NULL,
	[Regdate] [datetime] NULL,
	[Startdate] [datetime] NULL,
	[EventName] [varchar](50) NULL,
	[IPAddress] [varchar](15) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblEggCapsle]    Script Date: 07/25/2024 12:01:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblEggCapsle](
	[GameID] [char](30) NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblDumbList1]    Script Date: 07/25/2024 12:01:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblDumbList1](
	[GameID] [varchar](16) NOT NULL,
	[DueTime] [datetime] NOT NULL,
 CONSTRAINT [PK_tblDumbList1] PRIMARY KEY NONCLUSTERED 
(
	[GameID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblDonationLog]    Script Date: 07/25/2024 12:01:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblDonationLog](
	[DonationID] [int] IDENTITY(1,1) NOT NULL,
	[DonorEmail] [varchar](255) NULL,
	[Amount] [decimal](18, 2) NULL,
	[Currency] [varchar](10) NULL,
	[DonationDate] [datetime] NULL,
	[GameID] [varchar](14) NULL,
	[BillID] [varchar](14) NULL,
PRIMARY KEY CLUSTERED 
(
	[DonationID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblDeletedGameID1]    Script Date: 07/25/2024 12:01:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblDeletedGameID1](
	[LogID] [int] IDENTITY(1,1) NOT NULL,
	[Time] [datetime] NOT NULL,
	[GameID] [varchar](16) NOT NULL,
	[BillID] [varchar](14) NOT NULL,
	[Lvl] [int] NOT NULL,
	[Face] [tinyint] NOT NULL,
	[Map] [int] NOT NULL,
	[X] [int] NOT NULL,
	[Y] [int] NOT NULL,
	[TileKind] [bit] NOT NULL,
	[Item] [varchar](2000) NOT NULL,
	[Equipment] [varchar](280) NOT NULL,
	[Skill] [varchar](120) NOT NULL,
	[SpecialSkill] [varchar](20) NOT NULL,
	[Strength] [int] NOT NULL,
	[Spirit] [int] NOT NULL,
	[Dexterity] [int] NOT NULL,
	[Power] [int] NOT NULL,
	[Fame] [int] NOT NULL,
	[Experiment] [int] NOT NULL,
	[HP] [int] NOT NULL,
	[MP] [int] NOT NULL,
	[SP] [int] NOT NULL,
	[DP] [int] NOT NULL,
	[Bonus] [int] NOT NULL,
	[Money] [int] NOT NULL,
	[QuickItem] [varchar](160) NOT NULL,
	[QuickSkill] [int] NOT NULL,
	[QuickSpecialSkill] [int] NOT NULL,
	[BankMoney] [int] NOT NULL,
	[BankItem] [varchar](400) NOT NULL,
	[SETimer] [varchar](400) NOT NULL,
	[PKTimer] [int] NOT NULL,
	[Color1] [int] NOT NULL,
	[Color2] [int] NOT NULL,
	[PoisonUsedDate] [datetime] NOT NULL,
	[LovePoint] [int] NOT NULL,
	[ArmyHired] [int] NOT NULL,
	[ArmyMarkIndex] [int] NOT NULL,
	[Permission] [int] NOT NULL,
	[BonusInitCount] [int] NOT NULL,
	[StoryQuestState] [int] NOT NULL,
	[QuestItem] [varchar](100) NOT NULL,
	[SubQuestKind] [int] NOT NULL,
	[SubQuestDone] [int] NOT NULL,
	[SubQuestClientNPCID] [varchar](14) NOT NULL,
	[SubQuestClientNPCFace] [int] NOT NULL,
	[SubQuestClientNPCMap] [int] NOT NULL,
	[SubQuestItem] [varchar](20) NOT NULL,
	[SubQuestDestFace] [int] NOT NULL,
	[SubQuestDestMap] [int] NOT NULL,
	[SubQuestTimer] [int] NOT NULL,
	[SubQuestGiftExperience] [int] NOT NULL,
	[SubQuestGiftFame] [int] NOT NULL,
	[SubQuestGiftItem] [varchar](20) NOT NULL,
	[OPArmy] [int] NOT NULL,
	[OPPKTimer] [int] NOT NULL,
	[SurvivalEvent] [int] NOT NULL,
	[SurvivalTime] [int] NOT NULL,
	[Bonus2] [int] NOT NULL,
	[SBonus] [int] NOT NULL,
	[STotalBonus] [int] NOT NULL,
	[PKPenaltyCount] [int] NOT NULL,
	[PKPenaltyDecreaseTimer] [int] NOT NULL,
	[SigMoney] [int] NOT NULL,
	[BankSigMoney] [int] NOT NULL,
	[BankItem2] [varchar](400) NOT NULL,
	[TLETimer] [varchar](400) NOT NULL,
 CONSTRAINT [PK_tblDeletedGameID1] PRIMARY KEY CLUSTERED 
(
	[LogID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblDeathLog1_202407]    Script Date: 07/25/2024 12:01:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblDeathLog1_202407](
	[GameID] [varchar](14) NOT NULL,
	[BillID] [varchar](14) NOT NULL,
	[Time] [datetime] NOT NULL,
	[Map] [int] NOT NULL,
	[X] [int] NOT NULL,
	[Y] [int] NOT NULL,
	[TileKind] [int] NOT NULL,
	[Item] [varchar](500) NULL,
	[Equipment] [varchar](255) NOT NULL,
	[Experience] [int] NOT NULL,
	[Money] [int] NOT NULL,
	[SigMoney] [int] NOT NULL,
	[QuickItem] [varchar](255) NOT NULL,
	[Fame] [int] NOT NULL,
	[KillerID] [varchar](14) NOT NULL,
	[KillerFame] [int] NOT NULL,
	[Dead] [int] NOT NULL,
	[KillerLevel] [int] NOT NULL,
	[KillerStrength] [int] NOT NULL,
	[KillerSpirit] [int] NOT NULL,
	[KillerDexterity] [int] NOT NULL,
	[KillerPower] [int] NOT NULL,
 CONSTRAINT [PK_tblDeathLog1_202407] PRIMARY KEY CLUSTERED 
(
	[GameID] ASC,
	[BillID] ASC,
	[Time] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbldailyconnectlog1]    Script Date: 07/25/2024 12:01:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbldailyconnectlog1](
	[Column1] [int] NULL,
	[Column2] [int] NULL,
	[Column3] [int] NULL,
	[Column4] [int] NULL,
	[Column5] [datetime] NULL,
	[Column6] [int] NULL,
	[Column7] [int] NULL,
	[Column8] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblCurrentBattleZoneScore]    Script Date: 07/25/2024 12:01:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblCurrentBattleZoneScore](
	[ZoneIndex] [int] NOT NULL,
	[GameID] [varchar](14) NOT NULL,
	[BillID] [varchar](14) NOT NULL,
	[ServerIndex] [int] NOT NULL,
	[Win] [int] NOT NULL,
	[Lose] [int] NOT NULL,
	[Score] [int] NOT NULL,
	[NormalEnd] [int] NOT NULL,
	[EndLevel] [int] NOT NULL,
	[EndExperience] [int] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblCurrentBattleMatchInfo]    Script Date: 07/25/2024 12:01:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblCurrentBattleMatchInfo](
	[TeamID] [int] NOT NULL,
	[TeamName] [varchar](10) NOT NULL,
	[MemberCount] [int] NOT NULL,
	[Score] [int] NOT NULL,
	[SmashedTower] [int] NOT NULL,
	[StartTime] [datetime] NOT NULL,
	[TotalScore] [int] NOT NULL,
	[AvgMemberLevel] [int] NOT NULL,
	[bWin] [bit] NOT NULL,
 CONSTRAINT [PK_tblCurrentBattleMatchInfo] PRIMARY KEY CLUSTERED 
(
	[TeamID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblCurrentBattleMatchEntry]    Script Date: 07/25/2024 12:01:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblCurrentBattleMatchEntry](
	[ServerIndex] [int] NOT NULL,
	[GameID] [varchar](14) NOT NULL,
	[BillID] [varchar](14) NOT NULL,
	[TeamID] [int] NOT NULL,
	[PayKind] [int] NOT NULL,
	[StartTime] [datetime] NOT NULL,
	[EndTime] [datetime] NOT NULL,
	[JoinState] [int] NOT NULL,
 CONSTRAINT [PK_tblCurrentBattleMatchEntry] PRIMARY KEY CLUSTERED 
(
	[ServerIndex] ASC,
	[GameID] ASC,
	[BillID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblCurrentBattleArenaScore]    Script Date: 07/25/2024 12:01:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblCurrentBattleArenaScore](
	[GameID] [varchar](14) NOT NULL,
	[BillID] [varchar](14) NOT NULL,
	[ServerIndex] [int] NOT NULL,
	[Win] [int] NOT NULL,
	[Lose] [int] NOT NULL,
	[Score] [int] NOT NULL,
	[NormalEnd] [int] NOT NULL,
	[EndLevel] [int] NOT NULL,
	[EndExperience] [int] NOT NULL,
	[ZoneIndex] [int] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblChatLogList1]    Script Date: 07/25/2024 12:01:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblChatLogList1](
	[GameID] [varchar](14) NOT NULL,
	[DueTime] [datetime] NOT NULL,
 CONSTRAINT [PK_tblChatLogList1] PRIMARY KEY NONCLUSTERED 
(
	[GameID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblChatLog1]    Script Date: 07/25/2024 12:01:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblChatLog1](
	[Time] [datetime] NOT NULL,
	[GameID] [varchar](16) NOT NULL,
	[ChatKind] [varchar](10) NOT NULL,
	[Chat] [varchar](250) NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblChangeLog]    Script Date: 07/25/2024 12:01:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblChangeLog](
	[ChangeID] [int] IDENTITY(1,1) NOT NULL,
	[FromGameID] [varchar](14) NULL,
	[ToGameID] [varchar](14) NULL,
	[ChangeDate] [datetime] NULL,
	[ChangedBy] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[ChangeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblBonus2Log1]    Script Date: 07/25/2024 12:01:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblBonus2Log1](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Time] [datetime] NOT NULL,
	[GameID] [varchar](16) NOT NULL,
	[STotalBonus] [int] NOT NULL,
	[Kind] [tinyint] NOT NULL,
 CONSTRAINT [PK_tblBonus2Log1] PRIMARY KEY NONCLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[RMS_INCREASEBONUSQUESTCOUNT]    Script Date: 07/25/2024 12:01:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_INCREASEBONUSQUESTCOUNT]
    @GameID varchar(14)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @IncreaseBonusError int, @InsertLogError int, @STotalBonus int;
    SET @IncreaseBonusError = 1;
    SET @InsertLogError = 1;
    SET @STotalBonus = 0;

    BEGIN TRANSACTION;

    UPDATE tblGameID1
    SET SBonus = SBonus + 1, STotalBonus = STotalBonus + 1
    WHERE GameID = @GameID;
    SET @IncreaseBonusError = @@ERROR;

    SELECT @STotalBonus = STotalBonus
    FROM tblGameID1
    WHERE GameID = @GameID;

    INSERT INTO tblBonus2Log1 (GameID, STotalBonus, Kind)
    VALUES (@GameID, @STotalBonus, 1);
    SET @InsertLogError = @@ERROR;

    IF @IncreaseBonusError = 0 AND @InsertLogError = 0
    BEGIN
        COMMIT TRANSACTION;
    END
    ELSE
    BEGIN
        ROLLBACK TRANSACTION;
    END
END
GO
/****** Object:  Table [dbo].[tblBattleZoneScoreLog]    Script Date: 07/25/2024 12:01:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblBattleZoneScoreLog](
	[LogID] [int] IDENTITY(1,1) NOT NULL,
	[Time] [datetime] NOT NULL,
	[ZoneIndex] [int] NOT NULL,
	[GameID] [varchar](14) NOT NULL,
	[BillID] [varchar](14) NOT NULL,
	[ServerIndex] [int] NOT NULL,
	[Win] [int] NOT NULL,
	[Lose] [int] NOT NULL,
	[Score] [int] NOT NULL,
	[NormalEnd] [int] NOT NULL,
	[EndLevel] [int] NOT NULL,
	[EndExperience] [int] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblBattleZoneScore]    Script Date: 07/25/2024 12:01:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblBattleZoneScore](
	[GameID] [varchar](14) NOT NULL,
	[BillID] [varchar](14) NOT NULL,
	[ServerIndex] [int] NOT NULL,
	[Win] [int] NOT NULL,
	[Lose] [int] NOT NULL,
	[Score] [int] NOT NULL,
	[ZoneIndex] [int] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblBattleZonePayLog1]    Script Date: 07/25/2024 12:01:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblBattleZonePayLog1](
	[GameID] [varchar](14) NOT NULL,
	[BillID] [varchar](14) NOT NULL,
	[PayKind] [int] NOT NULL,
	[BattleStartTime] [datetime] NOT NULL,
	[PayTime] [datetime] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblBattleZonePayLog]    Script Date: 07/25/2024 12:01:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblBattleZonePayLog](
	[GameID] [varchar](14) NOT NULL,
	[BillID] [varchar](14) NOT NULL,
	[ServerIndex] [int] NOT NULL,
	[PayKind] [int] NOT NULL,
	[Time] [datetime] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblBattleZonePay1]    Script Date: 07/25/2024 12:01:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblBattleZonePay1](
	[GameID] [varchar](14) NOT NULL,
	[BillID] [varchar](14) NOT NULL,
	[PayKind] [int] NOT NULL,
	[BattleStartTime] [datetime] NOT NULL,
 CONSTRAINT [PK_tblBattleZonePay1] PRIMARY KEY CLUSTERED 
(
	[GameID] ASC,
	[BillID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblBattleZonePay]    Script Date: 07/25/2024 12:01:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblBattleZonePay](
	[GameID] [varchar](14) NOT NULL,
	[BillID] [varchar](14) NOT NULL,
	[ServerIndex] [int] NOT NULL,
	[PayKind] [int] NOT NULL,
	[Used] [int] NOT NULL,
 CONSTRAINT [PK_tblBattleZonePay] PRIMARY KEY CLUSTERED 
(
	[GameID] ASC,
	[BillID] ASC,
	[ServerIndex] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblBattleZoneChampionLog]    Script Date: 07/25/2024 12:01:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblBattleZoneChampionLog](
	[LogID] [int] IDENTITY(1,1) NOT NULL,
	[ZoneIndex] [int] NOT NULL,
	[Time] [datetime] NOT NULL,
	[GameID] [varchar](14) NOT NULL,
	[BillID] [varchar](14) NOT NULL,
	[ServerIndex] [int] NOT NULL,
	[SendItem] [int] NOT NULL,
	[MailSent] [int] NOT NULL,
 CONSTRAINT [PK_tblBattleZoneChampionLog] PRIMARY KEY CLUSTERED 
(
	[LogID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [IX_tblBattleZoneChampionLogZoneIndexTime] UNIQUE NONCLUSTERED 
(
	[ZoneIndex] ASC,
	[Time] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblBattlePointLog]    Script Date: 07/25/2024 12:01:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblBattlePointLog](
	[idx] [int] IDENTITY(1,1) NOT NULL,
	[logtime] [datetime] NOT NULL,
	[billid] [char](20) NOT NULL,
	[gameid] [char](20) NOT NULL,
	[serverindex] [smallint] NOT NULL,
	[buyitem] [varchar](80) NOT NULL,
	[beforePoint] [int] NOT NULL,
	[afterPoint] [int] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblBattleMatchUserPointLog]    Script Date: 07/25/2024 12:01:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblBattleMatchUserPointLog](
	[Time] [datetime] NOT NULL,
	[ServerIndex] [int] NOT NULL,
	[GameID] [varchar](14) NOT NULL,
	[BillID] [varchar](14) NOT NULL,
	[UsablePoint] [int] NOT NULL,
	[TotalPoint] [int] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblBattleMatchUserPoint]    Script Date: 07/25/2024 12:01:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblBattleMatchUserPoint](
	[ServerIndex] [int] NOT NULL,
	[GameID] [varchar](14) NOT NULL,
	[BillID] [varchar](14) NOT NULL,
	[UsablePoint] [int] NOT NULL,
	[TotalPoint] [int] NOT NULL,
 CONSTRAINT [PK_tblBattleMatchUserPoint] PRIMARY KEY CLUSTERED 
(
	[ServerIndex] ASC,
	[GameID] ASC,
	[BillID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblBattleMatchServerEntry]    Script Date: 07/25/2024 12:01:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblBattleMatchServerEntry](
	[ServerIndex] [int] NOT NULL,
	[PossibleJoin] [bit] NOT NULL,
 CONSTRAINT [PK_tblBattleMatchServerEntry] PRIMARY KEY CLUSTERED 
(
	[ServerIndex] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblBattleMatchInfoLog]    Script Date: 07/25/2024 12:01:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblBattleMatchInfoLog](
	[TeamID] [int] NOT NULL,
	[TeamName] [varchar](10) NOT NULL,
	[MemberCount] [int] NOT NULL,
	[Score] [int] NOT NULL,
	[SmashedTower] [int] NOT NULL,
	[TotalScore] [int] NOT NULL,
	[AvgMemberLevel] [int] NOT NULL,
	[StartTime] [datetime] NOT NULL,
	[EndTime] [datetime] NOT NULL,
	[bWin] [bit] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblBattleMatchEntry]    Script Date: 07/25/2024 12:01:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblBattleMatchEntry](
	[ServerIndex] [int] NOT NULL,
	[GameID] [varchar](14) NOT NULL,
	[BillID] [varchar](14) NOT NULL,
	[JoinState] [char](10) NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblBattleLeagueEntry]    Script Date: 07/25/2024 12:01:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblBattleLeagueEntry](
	[BillID] [varchar](15) NOT NULL,
	[PossibleJoin] [bit] NOT NULL,
 CONSTRAINT [PK_tblBattleLeagueEntry] PRIMARY KEY NONCLUSTERED 
(
	[BillID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblBattleID]    Script Date: 07/25/2024 12:01:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblBattleID](
	[GameID] [char](10) NULL,
	[BillID] [char](10) NULL,
	[Face] [int] NULL,
	[Color1] [int] NULL,
	[Color2] [int] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblBattleEntry1]    Script Date: 07/25/2024 12:01:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblBattleEntry1](
	[Entry] [varchar](20) NOT NULL,
	[Team] [int] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblBattleArenaScoreLog]    Script Date: 07/25/2024 12:01:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblBattleArenaScoreLog](
	[LogID] [int] NOT NULL,
	[Time] [datetime] NULL,
	[ZoneIndex] [int] NULL,
	[GameID] [varchar](14) NULL,
	[BillID] [varchar](14) NULL,
	[ServerIndex] [int] NOT NULL,
	[Win] [int] NULL,
	[Lose] [int] NULL,
	[Score] [int] NULL,
	[NormalEnd] [int] NULL,
	[EndLevel] [int] NULL,
	[EndExperience] [int] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblBattleArenaScore]    Script Date: 07/25/2024 12:01:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblBattleArenaScore](
	[GameID] [varchar](14) NOT NULL,
	[BillID] [varchar](14) NOT NULL,
	[ServerIndex] [int] NOT NULL,
	[Win] [int] NOT NULL,
	[Lose] [int] NOT NULL,
	[Score] [int] NOT NULL,
	[ZoneIndex] [int] NOT NULL,
	[EndExperience] [int] NOT NULL,
	[EndLevel] [int] NOT NULL,
	[NormalEnd] [int] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblBattleArenaPayLog]    Script Date: 07/25/2024 12:01:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblBattleArenaPayLog](
	[GameID] [varchar](14) NOT NULL,
	[BillID] [varchar](14) NOT NULL,
	[ServerIndex] [int] NOT NULL,
	[PayKind] [int] NOT NULL,
	[Time] [datetime] NOT NULL,
	[Used] [int] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblBattleArenaPay]    Script Date: 07/25/2024 12:01:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblBattleArenaPay](
	[GameID] [varchar](14) NOT NULL,
	[BillID] [varchar](14) NOT NULL,
	[ServerIndex] [int] NOT NULL,
	[PayKind] [int] NOT NULL,
	[Used] [int] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblBattleArenaChampionLog]    Script Date: 07/25/2024 12:01:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblBattleArenaChampionLog](
	[LogID] [int] IDENTITY(1,1) NOT NULL,
	[Time] [datetime] NOT NULL,
	[GameID] [varchar](14) NOT NULL,
	[BillID] [varchar](14) NOT NULL,
	[ServerIndex] [int] NOT NULL,
	[SendItem] [int] NULL,
	[MailSent] [int] NULL,
	[ZoneIndex] [int] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblArmyWarListLog1]    Script Date: 07/25/2024 12:01:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblArmyWarListLog1](
	[Time] [datetime] NOT NULL,
	[LogKind] [varchar](220) NOT NULL,
	[ArmyID1] [int] NOT NULL,
	[ArmyID2] [int] NOT NULL,
	[WarBeginTime] [datetime] NOT NULL,
	[WarEndTime] [datetime] NOT NULL,
	[WarScore1] [int] NOT NULL,
	[WarScore2] [int] NOT NULL,
	[WarKind1] [int] NOT NULL,
	[WarKind2] [int] NOT NULL,
	[WarPlace] [int] NOT NULL,
	[HostArmyID1] [int] NOT NULL,
	[AllianceArmyID11] [int] NOT NULL,
	[AllianceArmyID12] [int] NOT NULL,
	[AllianceArmyID13] [int] NOT NULL,
	[AllianceArmyID14] [int] NOT NULL,
	[HostArmyID2] [int] NOT NULL,
	[AllianceArmyID21] [int] NOT NULL,
	[AllianceArmyID22] [int] NOT NULL,
	[AllianceArmyID23] [int] NOT NULL,
	[AllianceArmyID24] [int] NOT NULL,
 CONSTRAINT [PK_tblArmyWarListLog1] PRIMARY KEY NONCLUSTERED 
(
	[Time] ASC,
	[ArmyID1] ASC,
	[ArmyID2] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblArmyWarList1]    Script Date: 07/25/2024 12:01:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblArmyWarList1](
	[ArmyID] [int] NOT NULL,
	[OppArmyID] [int] NOT NULL,
	[WarBeginTime] [datetime] NOT NULL,
	[WarEndTime] [datetime] NOT NULL,
	[WarKind] [int] NOT NULL,
	[WarPlace] [int] NOT NULL,
	[WarState] [int] NOT NULL,
	[WarScore] [int] NOT NULL,
	[EntranceCode] [varchar](50) NOT NULL,
	[ManagementCode] [varchar](50) NOT NULL,
	[WarehouseCode] [varchar](50) NOT NULL,
	[BulletinCode] [varchar](50) NOT NULL,
	[InputCodeState] [int] NOT NULL,
 CONSTRAINT [PK_tblArmyWarList1] PRIMARY KEY NONCLUSTERED 
(
	[ArmyID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblArmyShopListLog1]    Script Date: 07/25/2024 12:01:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblArmyShopListLog1](
	[Time] [datetime] NOT NULL,
	[LogKind] [varchar](40) NOT NULL,
	[ShopNumber] [int] NOT NULL,
	[ArmyID] [int] NOT NULL,
	[Tax] [int] NOT NULL,
	[ArmyGain] [int] NOT NULL,
	[BeginControl] [datetime] NOT NULL,
	[TaxChanged] [datetime] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblArmyShopList1]    Script Date: 07/25/2024 12:01:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblArmyShopList1](
	[ShopNumber] [int] NOT NULL,
	[ArmyID] [int] NOT NULL,
	[Tax] [int] NOT NULL,
	[ArmyGain] [int] NOT NULL,
	[BeginControl] [datetime] NOT NULL,
	[TaxChanged] [datetime] NOT NULL,
 CONSTRAINT [PK_tblArmyShopList1] PRIMARY KEY CLUSTERED 
(
	[ShopNumber] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblArmyReconEvent]    Script Date: 07/25/2024 12:01:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblArmyReconEvent](
	[RegID] [int] IDENTITY(1,1) NOT NULL,
	[RegDate] [datetime] NOT NULL,
	[GameID] [varchar](14) NOT NULL,
	[ArmyID] [varchar](20) NOT NULL,
	[ArmyName] [varchar](20) NOT NULL,
	[ItemID] [int] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblArmyMemberList1]    Script Date: 07/25/2024 12:01:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblArmyMemberList1](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[RegularSoldier] [varchar](14) NOT NULL,
	[ArmyID] [int] NOT NULL,
	[SubArmyID] [int] NOT NULL,
	[JoinTime] [datetime] NOT NULL,
 CONSTRAINT [PK_tblArmyMemberList1] PRIMARY KEY NONCLUSTERED 
(
	[RegularSoldier] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblArmyListLog1]    Script Date: 07/25/2024 12:01:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblArmyListLog1](
	[Time] [datetime] NOT NULL,
	[LogKind] [varchar](40) NOT NULL,
	[ID] [int] NOT NULL,
	[Mark] [int] NOT NULL,
	[State] [int] NOT NULL,
	[Camp] [tinyint] NOT NULL,
	[Name] [varchar](10) NOT NULL,
	[Commander] [varchar](14) NOT NULL,
	[Password] [varchar](10) NOT NULL,
	[CreateTime] [datetime] NOT NULL,
	[ActivePeriod] [datetime] NOT NULL,
	[ActivityPeriod] [datetime] NULL,
 CONSTRAINT [PK_tblArmyListLog1] PRIMARY KEY NONCLUSTERED 
(
	[Time] ASC,
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblArmyList1]    Script Date: 07/25/2024 12:01:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblArmyList1](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Mark] [int] NOT NULL,
	[State] [int] NOT NULL,
	[Camp] [tinyint] NOT NULL,
	[Name] [varchar](10) NOT NULL,
	[Commander] [varchar](14) NOT NULL,
	[Password] [varchar](20) NOT NULL,
	[CreateTime] [datetime] NOT NULL,
	[ActivityPeriod] [datetime] NOT NULL,
	[Notice] [varchar](166) NOT NULL,
	[ArmyBaseScore] [int] NOT NULL,
 CONSTRAINT [PK_tblArmyList1] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [IX_tblArmyList1] UNIQUE NONCLUSTERED 
(
	[Commander] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblArmyJoinSanctionList1]    Script Date: 07/25/2024 12:01:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblArmyJoinSanctionList1](
	[GameID] [varchar](14) NOT NULL,
	[SanctionTime] [datetime] NOT NULL,
 CONSTRAINT [PK_tblArmyJoinSanctionList1] PRIMARY KEY CLUSTERED 
(
	[GameID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblArmyBaseLog1]    Script Date: 07/25/2024 12:01:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblArmyBaseLog1](
	[Time] [datetime] NOT NULL,
	[LogKind] [varchar](40) NOT NULL,
	[ArmyID] [int] NOT NULL,
	[AgitTaxRate] [int] NOT NULL,
	[ControlBeginDate] [datetime] NOT NULL,
 CONSTRAINT [PK_tblArmyBaseLog1] PRIMARY KEY CLUSTERED 
(
	[Time] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblArmyBaseGuardList1]    Script Date: 07/25/2024 12:01:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblArmyBaseGuardList1](
	[GuardNumber] [int] NOT NULL,
	[GuardKind] [int] NOT NULL,
	[X] [int] NOT NULL,
	[Y] [int] NOT NULL,
	[HP] [int] NOT NULL,
 CONSTRAINT [PK_tblArmyBaseGuardList1] PRIMARY KEY CLUSTERED 
(
	[GuardNumber] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblArmyBase1]    Script Date: 07/25/2024 12:01:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblArmyBase1](
	[ArmyID] [int] NOT NULL,
	[ControlBeginDate] [datetime] NOT NULL,
	[AgitTaxRate] [int] NOT NULL,
	[ArmyGain] [int] NOT NULL,
	[SafeMoney1] [int] NOT NULL,
	[SafeMoney2] [int] NOT NULL,
	[SafeMoney3] [int] NOT NULL,
	[SafeMoney4] [int] NOT NULL,
	[SafeMoney5] [int] NOT NULL,
	[SafeMoney6] [int] NOT NULL,
	[SafeMoney7] [int] NOT NULL,
	[SafeMoney8] [int] NOT NULL,
	[SafeMoney9] [int] NOT NULL,
	[SafeMoney10] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblArmyAllianceList1]    Script Date: 07/25/2024 12:01:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblArmyAllianceList1](
	[AllianceID] [int] NOT NULL,
	[bHost] [bit] NOT NULL,
	[ArmyID] [int] NOT NULL,
 CONSTRAINT [PK_tblArmyAllianceList1] PRIMARY KEY NONCLUSTERED 
(
	[ArmyID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblArmy1]    Script Date: 07/25/2024 12:01:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblArmy1](
	[Mark] [int] NOT NULL,
	[Name] [varchar](10) NOT NULL,
	[Commander] [varchar](16) NOT NULL,
	[Password] [varchar](10) NOT NULL,
	[Notice] [varchar](81) NOT NULL,
	[Agit] [int] NULL,
	[AgitLimitDate] [datetime] NOT NULL,
	[SafeMoney] [int] NOT NULL,
	[SafeItem] [varchar](2100) NOT NULL,
	[WarBegin] [datetime] NOT NULL,
	[WarEnd] [datetime] NOT NULL,
	[WarOpp] [int] NOT NULL,
	[WarScore] [int] NOT NULL,
	[Attack] [int] NOT NULL,
	[Alliance] [int] NOT NULL,
	[WarState] [int] NOT NULL,
 CONSTRAINT [PK_tblArmy1] PRIMARY KEY NONCLUSTERED 
(
	[Mark] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [IX_tblArmy1] UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [IX_tblArmy1_2] UNIQUE NONCLUSTERED 
(
	[Commander] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblAgitSafeList1]    Script Date: 07/25/2024 12:01:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblAgitSafeList1](
	[AgitNumber] [int] NOT NULL,
	[SafeIndex] [int] NOT NULL,
	[ItemKind] [int] NOT NULL,
	[ItemIndex] [int] NOT NULL,
	[ItemCount] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblAgitListLog1]    Script Date: 07/25/2024 12:01:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblAgitListLog1](
	[Time] [datetime] NOT NULL,
	[LogKind] [varchar](40) NOT NULL,
	[AgitNumber] [int] NOT NULL,
	[ArmyID] [int] NOT NULL,
	[RentBeginDate] [datetime] NOT NULL,
	[ExpirationDate] [datetime] NOT NULL,
 CONSTRAINT [PK_tblAgitListLog1] PRIMARY KEY NONCLUSTERED 
(
	[Time] ASC,
	[AgitNumber] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblAgitList1]    Script Date: 07/25/2024 12:01:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblAgitList1](
	[AgitNumber] [int] NOT NULL,
	[ArmyID] [int] NOT NULL,
	[RentBeginDate] [datetime] NOT NULL,
	[ExpirationDate] [datetime] NOT NULL,
	[SafeMoney1] [int] NOT NULL,
	[SafeMoney2] [int] NOT NULL,
	[SafeMoney3] [int] NOT NULL,
 CONSTRAINT [PK_tblAgitList1] PRIMARY KEY NONCLUSTERED 
(
	[AgitNumber] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblAgency]    Script Date: 07/25/2024 12:01:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblAgency](
	[ID] [varchar](50) NOT NULL,
	[Password] [varchar](50) NOT NULL,
	[AgencyCode] [varchar](50) NOT NULL,
	[Grade] [int] NOT NULL,
 CONSTRAINT [PK_tblAgency] PRIMARY KEY NONCLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblAccountsStatsLog]    Script Date: 07/25/2024 12:01:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblAccountsStatsLog](
	[LogID] [int] IDENTITY(1,1) NOT NULL,
	[LogDate] [datetime] NOT NULL,
	[ValidAccts] [int] NOT NULL,
	[PaidAccts] [int] NOT NULL,
	[ExpAccts] [int] NOT NULL,
	[NewAccts] [int] NOT NULL,
	[TotalAccts] [int] NOT NULL,
	[ServerID] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[T_SYS_VER]    Script Date: 07/25/2024 12:01:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[T_SYS_VER](
	[VER_NO] [char](10) NOT NULL,
	[COMP_NO] [int] NOT NULL,
	[UPDATE_INDEX] [int] NOT NULL,
	[FILE_NAME] [char](255) NOT NULL,
	[FILE_BLOB] [image] NULL,
 CONSTRAINT [PK_T_SYS_VER] PRIMARY KEY CLUSTERED 
(
	[VER_NO] ASC,
	[COMP_NO] ASC,
	[UPDATE_INDEX] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[T_SYS_MENU]    Script Date: 07/25/2024 12:01:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[T_SYS_MENU](
	[item_order] [numeric](5, 2) NULL,
	[item_index] [int] NOT NULL,
	[parent_index] [int] NOT NULL,
	[item_name] [char](50) NULL,
	[lang_id] [char](20) NOT NULL,
	[object_name] [char](50) NULL,
	[open_parm] [char](20) NULL,
	[children] [char](1) NOT NULL,
 CONSTRAINT [PK_T_SYS_MENU] PRIMARY KEY CLUSTERED 
(
	[item_index] ASC,
	[parent_index] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[T_SYS_CONFIG]    Script Date: 07/25/2024 12:01:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[T_SYS_CONFIG](
	[Conf_type] [char](10) NOT NULL,
	[conf_value] [char](255) NULL,
	[conf_remark] [char](255) NULL,
 CONSTRAINT [PK_T_SYS_CONFIG] PRIMARY KEY CLUSTERED 
(
	[Conf_type] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SuspiciousActivityLog]    Script Date: 07/25/2024 12:01:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SuspiciousActivityLog](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[ip_address] [varchar](45) NULL,
	[details] [text] NULL,
	[timestamp] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblSpecialItem1]    Script Date: 07/25/2024 12:01:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblSpecialItem1](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ItemKind] [int] NOT NULL,
	[ItemIndex] [int] NOT NULL,
	[ItemDurability] [int] NULL,
	[Position] [int] NOT NULL,
	[Map] [int] NOT NULL,
	[X] [int] NOT NULL,
	[Y] [int] NOT NULL,
	[TileKind] [int] NOT NULL,
	[GameID] [varchar](16) NULL,
	[WindowKind] [int] NULL,
	[WindowIndex] [int] NULL,
	[MiscTime] [datetime] NULL,
	[AttackGrade] [int] NULL,
	[StrengthGrade] [int] NULL,
	[SpiritGrade] [int] NULL,
	[DexterityGrade] [int] NULL,
	[PowerGrade] [int] NULL,
	[CNT] [int] NULL,
 CONSTRAINT [PK_tblSpecialItem] PRIMARY KEY NONCLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[RMS_USERDB_INSERTBATTLEMATCHID]    Script Date: 07/25/2024 12:01:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RMS_USERDB_INSERTBATTLEMATCHID]
    @GameID varchar(14),
    @BillID varchar(14),
    @Face int,
    @Color1 int,
    @Color2 int,
    @MapNumber int
AS
SET NOCOUNT ON

BEGIN TRANSACTION RMS_USERDB_INSERTBATTLEMATCHID

DELETE FROM tblGameID1 
WHERE GameID = @GameID AND BillID = @BillID

INSERT INTO tblGameID1 (
    Version, GameID, BillID, Lvl, Face, Map, X, Y, TileKind, Item, Equipment, Skill, 
    SpecialSkill, Strength, Spirit, Dexterity, Power, Fame, Experiment, HP, MP, SP, DP, 
    Bonus, Money, QuickItem, QuickSkill, QuickSpecialSkill, BankMoney, BankItem, 
    SETimer, PKTimer, Color1, Color2, PoisonUsedDate, LovePoint, ArmyHired, ArmyMarkIndex, 
    Permission, BonusInitCount, StoryQuestState, QuestItem, SubQuestKind, SubQuestDone, 
    SubQuestClientNPCID, SubQuestClientNPCFace, SubQuestClientNPCMap, SubQuestItem, 
    SubQuestDestFace, SubQuestDestMap, SubQuestTimer, SubQuestGiftExperience, SubQuestGiftFame, 
    SubQuestGiftItem, OPArmy, OPPKTimer, SurvivalEvent, SurvivalTime, Bonus2, SBonus, 
    STotalBonus, PKPenaltyCount, PKPenaltyDecreaseTimer, SigMoney, BankSigMoney, BankItem2, 
    TLETimer) 
VALUES (
    100, @GameID, @BillID, 1, @Face, @MapNumber, 57, 16, 1, '', '', '', 
    '', 10, 10, 10, 10, 0, 0, 2000, 2000, 2000, 0, 
    2, 200000000, '', 0, 0, 20000000, '', '', 0, @Color1, @Color2, '2005-02-02', 0, 0, 
    0, 0, 0, 0, 0, '', 0, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '')

DELETE FROM tblSpecialItem1 
WHERE GameID = @GameID

IF @@ERROR = 0
BEGIN
    COMMIT TRANSACTION RMS_USERDB_INSERTBATTLEMATCHID
END
ELSE
BEGIN
    ROLLBACK TRANSACTION RMS_USERDB_INSERTBATTLEMATCHID
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_USERDB_INSERTBATTLEID]    Script Date: 07/25/2024 12:01:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RMS_USERDB_INSERTBATTLEID]
    @GameID varchar(14),
    @BillID varchar(14),
    @Face int,
    @Color1 int,
    @Color2 int,
    @MapNumber int
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION RMS_USERDB_INSERTBATTLEID;

    -- Insert battle ID
    DELETE FROM tblGameID1 WHERE GameID = @GameID AND BillID = @BillID;
    INSERT INTO tblGameID1 (
        Version, GameID, BillID, Lvl, Face, Map, X, Y, TileKind, Item, Equipment, Skill, 
        SpecialSkill, Strength, Spirit, Dexterity, Power, Fame, Experiment, HP, MP, SP, DP, 
        Bonus, Money, QuickItem, QuickSkill, QuickSpecialSkill, BankMoney, BankItem, 
        SETimer, PKTimer, Color1, Color2, PoisonUsedDate, LovePoint, ArmyHired, ArmyMarkIndex, 
        Permission, BonusInitCount, StoryQuestState, QuestItem, SubQuestKind, SubQuestDone, 
        SubQuestClientNPCID, SubQuestClientNPCFace, SubQuestClientNPCMap, SubQuestItem, 
        SubQuestDestFace, SubQuestDestMap, SubQuestTimer, SubQuestGiftExperience, SubQuestGiftFame, 
        SubQuestGiftItem, OPArmy, OPPKTimer, SurvivalEvent, SurvivalTime, Bonus2, SBonus, 
        STotalBonus, PKPenaltyCount, PKPenaltyDecreaseTimer, SigMoney, BankSigMoney, BankItem2, 
        TLETimer) 
    VALUES (
        100, @GameID, @BillID, 1, @Face, @MapNumber, 57, 16, 1, '', '', '', 
        '', 10, 10, 10, 10, 0, 0, 2000, 2000, 2000, 0, 
        2, 200000000, '', 0, 0, 20000000, '', '', 0, @Color1, @Color2, '2005-02-02', 0, 0, 
        0, 0, 0, 0, 0, '', 0, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '');

    DELETE FROM tblSpecialItem1 WHERE GameID = @GameID;

    -- Commit or rollback transaction based on error
    IF @@ERROR = 0
    BEGIN
        COMMIT TRANSACTION RMS_USERDB_INSERTBATTLEID;
    END
    ELSE
    BEGIN
        ROLLBACK TRANSACTION RMS_USERDB_INSERTBATTLEID;
    END
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_USEMYSTERYPILL]    Script Date: 07/25/2024 12:01:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RMS_USEMYSTERYPILL]
    @GameID varchar(14),
    @WindowKind int,
    @WindowIndex int
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @RemoveMysteryPillError int, 
            @IncreaseBonusError int, 
            @InsertLogError int, 
            @Level int, 
            @LMBPValue int, 
            @RandNum int;

    SET @RemoveMysteryPillError = 1;
    SET @IncreaseBonusError = 1;
    SET @InsertLogError = 1;

    BEGIN TRANSACTION;

    -- Retrieve level
    SELECT @Level = Lvl FROM tblGameID1 WHERE GameID = @GameID;

    IF @Level > 1
    BEGIN
        -- Remove the mystery pill
        DELETE FROM tblSpecialItem1 
        WHERE ID IN (
            SELECT TOP 1 ID 
            FROM tblSpecialItem1 
            WHERE ItemKind = 6 
              AND ItemIndex = 74 
              AND Position = 1 
              AND GameID = @GameID 
              AND WindowKind = @WindowKind 
              AND WindowIndex = @WindowIndex
        );

        IF @@ROWCOUNT > 0 AND @@ERROR = 0
        BEGIN
            SET @RemoveMysteryPillError = 0;
        END

        -- Update bonuses
        UPDATE tblGameID1 
        SET Bonus2 = Bonus2 + 4, STotalBonus = STotalBonus + 4 
        WHERE GameID = @GameID;

        UPDATE tblSpecialBPs 
        SET LMPPPoints = LMPPPoints + 4 
        WHERE GameID = @GameID;

        SET @IncreaseBonusError = @@ERROR;

        -- Log bonus update
        DECLARE @STotalBonus int;
        SET @STotalBonus = 0;

        SELECT @STotalBonus = STotalBonus FROM tblGameID1 WHERE GameID = @GameID;

        INSERT INTO tblBonus2Log1 (GameID, STotalBonus, Kind) 
        VALUES (@GameID, @STotalBonus, 4);

        SET @InsertLogError = @@ERROR;

        IF @RemoveMysteryPillError = 0 AND @IncreaseBonusError = 0 AND @InsertLogError = 0
        BEGIN
            COMMIT TRANSACTION;
        END
        ELSE
        BEGIN
            ROLLBACK TRANSACTION;
        END
    END
    ELSE
    BEGIN
        ROLLBACK TRANSACTION;
    END
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_SENDSPECIALITEMMAIL]    Script Date: 07/25/2024 12:01:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_SENDSPECIALITEMMAIL]
    @Sender         VARCHAR(14),
    @Recipient      VARCHAR(14),
    @Title          VARCHAR(80),
    @Content        VARCHAR(5000),
    @ItemKind       INT,
    @ItemIndex      INT,
    @ItemCount      INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @MailCount INT;
    DECLARE @Time DATETIME;
    DECLARE @nTmp INT;
    DECLARE @AttackGrade INT;

    SET @MailCount = 0;
    SET @Time = CAST(CONVERT(VARCHAR, GETDATE(), 120) AS DATETIME);

    IF @ItemKind != 6
    BEGIN
        SET @ItemCount = 0;
    END

    BEGIN TRANSACTION;

    SET @nTmp = (SELECT COUNT(*) FROM tblGameid1 WHERE gameid = @Recipient);

    IF @ItemKind = 6 AND @ItemIndex BETWEEN 120 AND 134
        SET @AttackGrade = 1;
    ELSE IF @ItemKind = 6 AND @ItemIndex BETWEEN 140 AND 154
        SET @AttackGrade = 2;
    ELSE IF @ItemKind = 6 AND @ItemIndex BETWEEN 160 AND 174
        SET @AttackGrade = 3;
    ELSE IF @ItemKind = 6 AND @ItemIndex BETWEEN 180 AND 194
        SET @AttackGrade = 4;
    ELSE
        SET @AttackGrade = 0;

    IF @nTmp > 0
    BEGIN 
        WHILE (SELECT COUNT(*) FROM RedMoon.dbo.tblMail1 WHERE Recipient = @Recipient AND Time = @Time) > 0
        BEGIN
            SET @Time = DATEADD(SECOND, 1, @Time);
        END

        INSERT INTO tblSpecialItem1 (ItemKind, ItemIndex, ItemDurability, Position, Map, X, Y, TileKind, GameID, WindowKind, WindowIndex, MiscTime, AttackGrade, CNT)
        VALUES (@ItemKind, @ItemIndex, 4, 2, 1, 100, 100, 1, @Recipient, 100, 0, @Time, @AttackGrade, @ItemCount);

        INSERT INTO tblMail1 (Time, Recipient, Sender, ReadOrNot, Title, Line, Content, Item)
        VALUES (@Time, @Recipient, @Sender, 0, @Title, 20, @Content, '');
    END

    COMMIT TRANSACTION;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_USELINKITEM]    Script Date: 07/25/2024 12:01:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RMS_USELINKITEM]
    @GameID varchar(14),
    @ItemIndex int,
    @WindowKind int,
    @WindowIndex int
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @DeleteItemError int, 
            @UpdateError int, 
            @Magic varchar(20), 
            @Time int, 
            @SETimer varchar(1000), 
            @Overtime int, 
            @tmp_str varchar(500), 
            @AddMarkCount int,
            @Face int, 
            @Fame int,
            @RandItemIndex int,
            @ItemKind int,
            @ItemName varchar(14),
            @RandNumber char(36),
            @GiftItemText varchar(50),
            @MailContent varchar(1000);

    SET @DeleteItemError = 1;
    SET @UpdateError = 1;

    BEGIN TRANSACTION;

    -- Delete the item
    DELETE FROM tblSpecialItem1 
    WHERE ID IN (
        SELECT TOP 1 ID 
        FROM tblSpecialItem1 
        WHERE ItemKind = 6 
          AND ItemIndex = @ItemIndex 
          AND Position = 1 
          AND GameID = @GameID 
          AND WindowKind = @WindowKind 
          AND WindowIndex = @WindowIndex
    );

    IF @@ROWCOUNT > 0 AND @@ERROR = 0
    BEGIN
        SET @DeleteItemError = 0;
        SET @Time = 60;  -- Default time value

        -- Determine Magic value
        SELECT @Magic = CASE @ItemIndex
            WHEN 204 THEN '3'
            WHEN 205 THEN '60'
            WHEN 206 THEN '42'
            WHEN 207 THEN '62'
            WHEN 226 THEN '金色面具'
            WHEN 227 THEN '白色面具'
            WHEN 213 THEN '宝石箱'
            ELSE '8'
        END;

        -- Update SETimer based on Magic value
        SELECT @SETimer = SETimer 
        FROM tblGameID1 
        WHERE GameID = @GameID;

        SET @SETimer = '.' + @SETimer;
        SELECT @tmp_str = RIGHT(@SETimer, LEN(@SETimer) - CHARINDEX('.' + @Magic + ':', @SETimer));

        IF @Magic = '42'
        BEGIN
            SELECT @Overtime = CHARINDEX(':50:', @tmp_str);
            IF @Overtime > 0
            BEGIN
                SELECT @Overtime = CAST(REPLACE(LEFT(@tmp_str, CHARINDEX(':50:', @tmp_str) - 1), @Magic + ':', '') AS INT);
                SELECT @SETimer = REPLACE(RIGHT(@SETimer, LEN(@SETimer) - 1), @Magic + ':' + CAST(@Overtime AS varchar), @Magic + ':' + CAST(@Overtime + @Time * 60000 AS varchar));
            END
            ELSE
            BEGIN
                SELECT @SETimer = RIGHT(@SETimer, LEN(@SETimer) - 1) + @Magic + ':' + CAST(@Time * 60000 AS varchar) + ':50:0.';
            END

            SET @UpdateError = 0;
            UPDATE tblGameID1 SET SETimer = @SETimer WHERE GameID = @GameID;
        END
        ELSE IF @Magic IN ('3', '8', '60', '62')
        BEGIN
            SELECT @Overtime = CAST(REPLACE(LEFT(@tmp_str, CHARINDEX('.', @tmp_str) - 1), @Magic + ':', '') AS INT);
            IF @Overtime > 0
            BEGIN
                SELECT @SETimer = REPLACE(RIGHT(@SETimer, LEN(@SETimer) - 1), @Magic + ':' + CAST(@Overtime AS varchar), @Magic + ':' + CAST(@Overtime + @Time * 60000 AS varchar));
            END
            ELSE
            BEGIN
                SELECT @SETimer = RIGHT(@SETimer, LEN(@SETimer) - 1) + @Magic + ':' + CAST(@Time * 60000 AS varchar) + '.';
            END

            SET @UpdateError = 0;
            UPDATE tblGameID1 SET SETimer = @SETimer WHERE GameID = @GameID;
        END
        ELSE IF @Magic = '金色面具'
        BEGIN
            SELECT @AddMarkCount = AddMarkCount FROM tblGameIDExpand WHERE GameID = @GameID;

            IF @AddMarkCount < 1
            BEGIN
                SELECT @Face = CAST(ABS(CHECKSUM(NEWID())) % 9 AS INT);
                SET @UpdateError = 0;
            END
            ELSE
            BEGIN
                SET @UpdateError = 1;
            END

            UPDATE tblGameID1 SET Face = @Face WHERE GameID = @GameID;
            UPDATE tblGameIDExpand SET AddMarkCount = @AddMarkCount + 1;
        END
        ELSE IF @Magic = '白色面具'
        BEGIN
            SELECT @Fame = Fame FROM tblGameID1 WHERE GameID = @GameID;

            IF @Fame = 0
            BEGIN
                SET @UpdateError = 1;
            END
            ELSE
            BEGIN
                SET @Fame = -1 * @Fame;
                SET @UpdateError = 0;
            END

            UPDATE tblGameID1 SET Fame = @Fame WHERE GameID = @GameID;
        END
        ELSE IF @Magic = '宝石箱'
        BEGIN
            SET @RandItemIndex = CAST(FLOOR(RAND() * 200) AS INT);
            SET @RandNumber = 'RMBOX-' + CHAR(65 + CEILING(RAND() * 24)) +
                              STR(FLOOR(RAND() * 10), 1, 5) +
                              CHAR(65 + CEILING(RAND() * 25)) +
                              STR(FLOOR(RAND() * 10), 1, 5) +
                              CHAR(65 + CEILING(RAND() * 25)) + '-' +
                              CONVERT(VARCHAR(5), REPLACE(NEWID(), '0', '0')) + '-' +
                              LEFT(ABS(CHECKSUM(NEWID())), 5) +
                              CHAR(65 + CEILING(RAND() * 25)) +
                              CHAR(65 + CEILING(RAND() * 25)) +
                              STR(FLOOR(RAND() * 10), 1, 5) +
                              CHAR(65 + CEILING(RAND() * 25)) +
                              CHAR(65 + CEILING(RAND() * 25));

            SELECT @ItemName = CASE @RandItemIndex
                WHEN 100 THEN '生化头盔'
                WHEN 101 THEN '生化战甲'
                WHEN 102 THEN '生化裤子'
                WHEN 103 THEN '生化长靴'
                WHEN 104 THEN '生化盾牌'
                WHEN 105 THEN '生化手套'
                WHEN 106 THEN '生化腰带'
                WHEN 107 THEN '皇族戒指'
                WHEN 108 THEN '皇族项链'
                WHEN 110 THEN '维真之剑'
                WHEN 111 THEN '教皇手杖'
                WHEN 112 THEN '毁灭之矛'
                WHEN 113 THEN '虚无之弓'
                WHEN 114 THEN '重生之枪'
                WHEN 196 THEN '献祭之石'
                ELSE '生命水'
            END;

            IF @ItemName = '生命水'
            BEGIN
                SET @GiftItemText = '0:' + CAST(@ItemKind AS varchar) + '-' + CAST(@ItemIndex AS varchar) + '/1.';
                SET @MailContent = '恭喜您中得奖品【' + CAST(@ItemName AS varchar) + '】';
                SET @UpdateError = 0;

                EXEC RMS_SENDSPECIALITEMMAIL 
                    @Sender = '宝石箱',
                    @Recipient = @GameID,
                    @Title = @MailContent,
                    @Content = @MailContent,
                    @ItemKind = 6,
                    @ItemIndex = 200,
                    @ItemDurability = 4,
                    @ItemCount = 1;

                INSERT INTO tblItemDreamBoxListLog1 
                (DreamBoxNumber, ItemKind, ItemIndex, ItemDurability, ItemName, GameID, UseTime) 
                VALUES (@RandNumber, 6, 200, 4, @ItemName, @GameID, GETDATE());
            END
            ELSE
            BEGIN
                SET @GiftItemText = '0:' + CAST(@ItemKind AS varchar) + '-' + CAST(@ItemIndex AS varchar) + '/1.';
                SET @MailContent = '恭喜您中得奖品【' + CAST(@ItemName AS varchar) + '】';
                SET @UpdateError = 0;

                EXEC RMS_SENDSPECIALITEMMAIL 
                    @Sender = '宝石箱',
                    @Recipient = @GameID,
                    @Title = @MailContent,
                    @Content = @MailContent,
                    @ItemKind = 6,
                    @ItemIndex = @RandItemIndex,
                    @ItemDurability = 4,
                    @ItemCount = 1;

                INSERT INTO tblItemDreamBoxListLog1 
                (DreamBoxNumber, ItemKind, ItemIndex, ItemDurability, ItemName, GameID, UseTime) 
                VALUES (@RandNumber, 6, @RandItemIndex, 4, @ItemName, @GameID, GETDATE());
            END
        END
    END

    IF @DeleteItemError = 0 AND @UpdateError = 0
    BEGIN
        COMMIT TRANSACTION;
    END
    ELSE
    BEGIN
        ROLLBACK TRANSACTION;
    END
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_USEARTIFICIALMYSTERYPILL]    Script Date: 07/25/2024 12:01:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RMS_USEARTIFICIALMYSTERYPILL]
    @GameID varchar(14),
    @WindowKind int,
    @WindowIndex int
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @RemoveMysteryPillError INT, @IncreaseBonusError INT, @InsertLogError INT;
    SET @RemoveMysteryPillError = 1;
    SET @IncreaseBonusError = 1;
    SET @InsertLogError = 1;

    BEGIN TRANSACTION;

    -- Remove the mystery pill
    DELETE FROM tblSpecialItem1 
    WHERE ID IN (SELECT TOP 1 ID 
                 FROM tblSpecialItem1 
                 WHERE ItemKind = 6 AND ItemIndex = 74 AND Position = 1 
                 AND GameID = @GameID AND WindowKind = @WindowKind AND WindowIndex = @WindowIndex);

    IF @@ROWCOUNT > 0 AND @@ERROR = 0
    BEGIN
        SET @RemoveMysteryPillError = 0;
    END

    -- Update game bonus
    UPDATE tblGameID1 
    SET Bonus2 = Bonus2 + 2, STotalBonus = STotalBonus + 2 
    WHERE GameID = @GameID AND STotalBonus < 200;

    SET @IncreaseBonusError = @@ERROR;

    -- Log bonus update
    DECLARE @STotalBonus INT;
    SET @STotalBonus = 0;
    SELECT @STotalBonus = STotalBonus FROM tblGameID1 WHERE GameID = @GameID;

    INSERT INTO tblBonus2Log1 (GameID, STotalBonus, Kind) 
    VALUES (@GameID, @STotalBonus, 4);

    SET @InsertLogError = @@ERROR;

    IF @RemoveMysteryPillError = 0 AND @IncreaseBonusError = 0 AND @InsertLogError = 0
    BEGIN
        COMMIT TRANSACTION;
    END
    ELSE
    BEGIN
        ROLLBACK TRANSACTION;
    END
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_TRYMAKEMYSTERYPILL]    Script Date: 07/25/2024 12:01:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RMS_TRYMAKEMYSTERYPILL]
    @GameID varchar(14),
    @WindowKind int,
    @WindowIndex int,
    @RandomNumber int
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ItemCountLimit INT, @CurrentItemCount INT, @Bonus INT;
    SET @ItemCountLimit = 0;

    BEGIN TRANSACTION;

    -- Fetch current bonus and item limits
    SELECT @Bonus = SBonus 
    FROM tblGameID1 
    WHERE GameID = @GameID;

    SELECT @ItemCountLimit = ItemCountLimit 
    FROM tblSpecialItemLimit1 
    WHERE ItemKind = 6 AND ItemIndex = 74;

    SET @CurrentItemCount = @ItemCountLimit;

    -- Generate a random number if not provided
    IF @RandomNumber IS NULL
    BEGIN
        SET @RandomNumber = CAST(FLOOR(RAND(CAST(CAST(NEWID() AS BINARY(4)) AS INT)) * 100) AS INT);
    END

    -- Check validity and insert mystery pills
    IF ((@WindowKind = 1 AND @WindowIndex >= 0 AND @WindowIndex < 100) 
        OR (@WindowKind = 3 AND @WindowIndex >= 0 AND @WindowIndex < 8)) 
        AND (@Bonus > 9)
    BEGIN
        DECLARE @MakeMysteryPillError INT;
        SET @MakeMysteryPillError = 1;

        -- Update game bonus
        UPDATE tblGameID1 
        SET SBonus = SBonus - 10, STotalBonus = STotalBonus - 10 
        WHERE GameID = @GameID AND SBonus >= 1 AND STotalBonus >= 1;

        IF @@ROWCOUNT = 1 AND @@ERROR = 0
        BEGIN
            -- Insert mystery pills based on random number
            IF @RandomNumber >= 75
            BEGIN
                INSERT INTO tblSpecialItem1 (ItemKind, ItemIndex, Position, Map, X, Y, TileKind, GameID, WindowKind, WindowIndex)
                VALUES (6, 74, 1, 1, 100, 100, 0, @GameID, @WindowKind, @WindowIndex),
                       (6, 74, 1, 1, 100, 100, 0, @GameID, @WindowKind, @WindowIndex),
                       (6, 74, 1, 1, 100, 100, 0, @GameID, @WindowKind, @WindowIndex),
                       (6, 74, 1, 1, 100, 100, 0, @GameID, @WindowKind, @WindowIndex),
                       (6, 74, 1, 1, 100, 100, 0, @GameID, @WindowKind, @WindowIndex);
                SET @MakeMysteryPillError = @@ERROR;
            END
            ELSE IF @RandomNumber >= 50
            BEGIN
                INSERT INTO tblSpecialItem1 (ItemKind, ItemIndex, Position, Map, X, Y, TileKind, GameID, WindowKind, WindowIndex)
                VALUES (6, 74, 1, 1, 100, 100, 0, @GameID, @WindowKind, @WindowIndex),
                       (6, 74, 1, 1, 100, 100, 0, @GameID, @WindowKind, @WindowIndex),
                       (6, 74, 1, 1, 100, 100, 0, @GameID, @WindowKind, @WindowIndex),
                       (6, 74, 1, 1, 100, 100, 0, @GameID, @WindowKind, @WindowIndex);
                SET @MakeMysteryPillError = @@ERROR;
            END
            ELSE IF @RandomNumber >= 35
            BEGIN
                INSERT INTO tblSpecialItem1 (ItemKind, ItemIndex, Position, Map, X, Y, TileKind, GameID, WindowKind, WindowIndex)
                VALUES (6, 74, 1, 1, 100, 100, 0, @GameID, @WindowKind, @WindowIndex),
                       (6, 74, 1, 1, 100, 100, 0, @GameID, @WindowKind, @WindowIndex),
                       (6, 74, 1, 1, 100, 100, 0, @GameID, @WindowKind, @WindowIndex);
                SET @MakeMysteryPillError = @@ERROR;
            END
            ELSE IF @RandomNumber >= 25
            BEGIN
                INSERT INTO tblSpecialItem1 (ItemKind, ItemIndex, Position, Map, X, Y, TileKind, GameID, WindowKind, WindowIndex)
                VALUES (6, 74, 1, 1, 100, 100, 0, @GameID, @WindowKind, @WindowIndex),
                       (6, 74, 1, 1, 100, 100, 0, @GameID, @WindowKind, @WindowIndex);
                SET @MakeMysteryPillError = @@ERROR;
            END
            ELSE IF @RandomNumber >= 10
            BEGIN
                INSERT INTO tblSpecialItem1 (ItemKind, ItemIndex, Position, Map, X, Y, TileKind, GameID, WindowKind, WindowIndex)
                VALUES (6, 74, 1, 1, 100, 100, 0, @GameID, @WindowKind, @WindowIndex);
                SET @MakeMysteryPillError = @@ERROR;
            END
        END

        -- Log bonus update
        DECLARE @STotalBonus INT;
        SELECT @STotalBonus = STotalBonus FROM tblGameID1 WHERE GameID = @GameID;

        IF @MakeMysteryPillError = 0
        BEGIN
            INSERT INTO tblBonus2Log1 (GameID, STotalBonus, Kind) VALUES (@GameID, @STotalBonus, 2);
        END
        ELSE
        BEGIN
            INSERT INTO tblBonus2Log1 (GameID, STotalBonus, Kind) VALUES (@GameID, @STotalBonus, 3);
        END
    END

    IF @MakeMysteryPillError = 0
    BEGIN
        COMMIT TRANSACTION;
    END
    ELSE
    BEGIN
        ROLLBACK TRANSACTION;
    END
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_REMOVEONEITEM]    Script Date: 07/25/2024 12:01:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_REMOVEONEITEM]
    @ItemKind int,
    @ItemIndex int,
    @ItemDurability int,
    @ItemAttackGrade int,
    @ItemStrengthGrade int,
    @ItemSpiritGrade int,
    @ItemDexterityGrade int,
    @ItemPowerGrade int,
    @Position int,
    @GameID varchar(14),
    @WindowKind int,
    @WindowIndex int
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION;

    DECLARE @level int;
    DECLARE @MaxLM int;
    DECLARE @LMCount int;
    DECLARE @ItemID int;

    SELECT @LMCount = LMCount 
    FROM tblMysteryPillLimit 
    WHERE GameID = @GameID;

    SELECT @level = Lvl 
    FROM tblGameID1 
    WHERE GameID = @GameID;

    SELECT @MaxLM = MaxLM 
    FROM tblMaxLMCount 
    WHERE GameID = @GameID;

    SELECT TOP 1 @ItemID = ID 
    FROM redmoon.dbo.tblSpecialItem1 
    WHERE GameID = @GameID 
      AND Position = @Position 
      AND WindowKind = @WindowKind 
      AND WindowIndex = @WindowIndex 
      AND ItemKind = @ItemKind 
      AND ItemIndex = @ItemIndex 
      AND ItemDurability = @ItemDurability 
      AND AttackGrade = @ItemAttackGrade  
      AND StrengthGrade = @ItemStrengthGrade  
      AND SpiritGrade = @ItemSpiritGrade  
      AND DexterityGrade = @ItemDexterityGrade  
      AND PowerGrade = @ItemPowerGrade;

    IF @ItemIndex = 66 
    BEGIN
        IF @level > 2499 AND @LMCount < @MaxLM
        BEGIN
            UPDATE tblLMTrackingLog 
            SET Consumer = @GameID, TimeConsume = GETDATE() 
            WHERE ItemID = @ItemID;

            DELETE FROM redmoon.dbo.tblSpecialItem1 
            WHERE ID = @ItemID;
        END
    END
    ELSE IF @ItemIndex = 67
    BEGIN
        DECLARE @Creator varchar(14);

        SELECT @Creator = GameID 
        FROM tblGambleResetPPills 
        WHERE ItemID = @ItemID;

        IF @@ROWCOUNT = 0
        BEGIN
            DELETE FROM redmoon.dbo.tblSpecialItem1 
            WHERE ID = @ItemID;
        END
        ELSE IF @GameID = @Creator
        BEGIN
            UPDATE tblGambleResetPPills 
            SET UseFlag = 1 
            WHERE ItemID = @ItemID;

            UPDATE tblGambleResets 
            SET ResetsUsed = ResetsUsed + 1, TimeUsed = GETDATE() 
            WHERE GameID = @Creator;

            DELETE FROM redmoon.dbo.tblSpecialItem1 
            WHERE ID = @ItemID;
        END
    END
    ELSE
    BEGIN
        IF @ItemIndex = 45
        BEGIN
            INSERT INTO tblEggCapsle (GameID) 
            VALUES (@GameID);
        END

        IF @ItemIndex >= 100 AND @ItemIndex <= 174
        BEGIN
            DECLARE @rand float;
            SET @rand = RAND(CAST(CAST(NEWID() AS binary(4)) AS int));

            IF @rand < 0.5
            BEGIN
                DELETE FROM redmoon.dbo.tblSpecialItem1 
                WHERE ID = @ItemID;

                -- Uncomment the following lines if you want to log the deletion
                -- IF @@ROWCOUNT > 0
                -- BEGIN
                INSERT INTO redmoon.dbo.tblSpecialItemLog1 (LogKind, ItemKind, ItemIndex, ItemDurability, Position, GameID, WindowKind, WindowIndex, LogItemCount, AttackGrade, StrengthGrade, SpiritGrade, DexterityGrade, PowerGrade) 
                VALUES (102, @ItemKind, @ItemIndex, @ItemDurability, @Position, @GameID, @WindowKind, @WindowIndex, @@ROWCOUNT, @ItemAttackGrade, @ItemStrengthGrade, @ItemSpiritGrade, @ItemDexterityGrade, @ItemPowerGrade);
                -- END
            END
        END
        ELSE
        BEGIN
            DELETE FROM redmoon.dbo.tblSpecialItem1 
            WHERE ID = @ItemID;

            -- Uncomment the following lines if you want to log the deletion
            -- IF @@ROWCOUNT > 0
            -- BEGIN
            INSERT INTO redmoon.dbo.tblSpecialItemLog1 (LogKind, ItemKind, ItemIndex, ItemDurability, Position, GameID, WindowKind, WindowIndex, LogItemCount, AttackGrade, StrengthGrade, SpiritGrade, DexterityGrade, PowerGrade) 
            VALUES (102, @ItemKind, @ItemIndex, @ItemDurability, @Position, @GameID, @WindowKind, @WindowIndex, @@ROWCOUNT, @ItemAttackGrade, @ItemStrengthGrade, @ItemSpiritGrade, @ItemDexterityGrade, @ItemPowerGrade);
            -- END
        END
    END

    COMMIT TRANSACTION;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_REBIRTH]    Script Date: 07/25/2024 12:01:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Create the stored procedure to handle rebirth
CREATE PROCEDURE [dbo].[RMS_REBIRTH]
    @GameID varchar(14)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @CurrentLevel int;
    DECLARE @ItemCount int;

    -- Get the current level of the character
    SELECT @CurrentLevel = lvl 
    FROM tblgameid1 
    WHERE GameID = @GameID;

    -- Check if the level is 1000 or more
    IF @CurrentLevel >= 1000
    BEGIN
        -- Check if the character has the special item
        SELECT @ItemCount = COUNT(*) 
        FROM tblSpecialItem1 
        WHERE GameID = @GameID AND ItemKind = 6 AND ItemIndex = 215 AND Position = 1;

        IF @ItemCount > 0
        BEGIN
            BEGIN TRANSACTION;
            BEGIN TRY
                -- Update the character's level and bonus points
                UPDATE tblgameid1
                SET lvl = 1, stotalbonus = stotalbonus + 500
                WHERE GameID = @GameID;

                -- Update the rebirth count
                UPDATE tblGameIDRebirth
                SET RebirthCount = RebirthCount + 1
                WHERE GameID = @GameID;

                COMMIT TRANSACTION;
            END TRY
            BEGIN CATCH
                ROLLBACK TRANSACTION;
                -- Log the error and raise it
                DECLARE @ErrorMessage NVARCHAR(4000), @ErrorSeverity INT, @ErrorState INT;
                SELECT 
                    @ErrorMessage = ERROR_MESSAGE(),
                    @ErrorSeverity = ERROR_SEVERITY(),
                    @ErrorState = ERROR_STATE();
                
                RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
            END CATCH
        END
    END
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_ITEMLOTTERY_USEITEM]    Script Date: 07/25/2024 12:01:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_ITEMLOTTERY_USEITEM]

@GameID varchar(14),

@WindowKind Int,

@WindowIndex int

AS

set nocount on

begin transaction RMS_ITEMLOTTERY_USEITEM

DECLARE @LotteryID INT

DECLARE @ItemKind int

DECLARE @ItemIndex int

DECLARE @LotteryNumber CHAR(29)

DECLARE @I_Kind INT

DECLARE @ItemCount INT

SET @I_Kind = 6

SET @ItemKind = 6

If(OBJECT_ID('tempdb..#TmpLottery') Is Not Null)
Begin
    Drop Table #TmpLottery
End

create table #TmpLottery
(
	ItemType int,
	ItemID int
)

INSERT INTO #TmpLottery
SELECT 1,1
 UNION ALL 
SELECT 1,2
 UNION ALL 
SELECT 1,8
 UNION ALL 
SELECT 1,10
 UNION ALL 
SELECT 1,11
 UNION ALL 
SELECT 1,12
 UNION ALL 
SELECT 1,14
 UNION ALL 
SELECT 1,15
 UNION ALL 
SELECT 1,17
 UNION ALL 
SELECT 1,18
 UNION ALL 
SELECT 1,24
 UNION ALL 
SELECT 1,23
 UNION ALL 
SELECT 1,26
 UNION ALL 
SELECT 1,28
 UNION ALL 
SELECT 1,35
 UNION ALL 
SELECT 1,36
 UNION ALL 
SELECT 1,37
 UNION ALL 
SELECT 1,80
 UNION ALL 
SELECT 1,81
 UNION ALL 
SELECT 1,82
 UNION ALL 
SELECT 1,83
 UNION ALL 
SELECT 1,84
 UNION ALL 
SELECT 1,90
 UNION ALL 
SELECT 1,91
 UNION ALL 
SELECT 1,92
 UNION ALL 
SELECT 1,93
 UNION ALL 
SELECT 1,94
 UNION ALL 
SELECT 1,95
 UNION ALL 
SELECT 1,96
 UNION ALL 
SELECT 1,97
 UNION ALL 
SELECT 1,98
 UNION ALL 
SELECT 1,100
 UNION ALL 
SELECT 1,101
 UNION ALL 
SELECT 1,102
 UNION ALL 
SELECT 1,103
 UNION ALL 
SELECT 1,104
 UNION ALL 
SELECT 1,105
 UNION ALL 
SELECT 1,106
 UNION ALL 
SELECT 1,107
 UNION ALL 
SELECT 1,108
 UNION ALL 
SELECT 1,110
 UNION ALL 
SELECT 1,111
 UNION ALL 
SELECT 1,112
 UNION ALL 
SELECT 1,113
 UNION ALL 
SELECT 1,114
 UNION ALL 
SELECT 1,120
 UNION ALL 
SELECT 1,121
 UNION ALL 
SELECT 1,122
 UNION ALL 
SELECT 1,123
 UNION ALL 
SELECT 1,124
 UNION ALL 
SELECT 1,125
 UNION ALL 
SELECT 1,126
 UNION ALL 
SELECT 1,127
 UNION ALL 
SELECT 1,128
 UNION ALL 
SELECT 1,130
 UNION ALL 
SELECT 1,131
 UNION ALL 
SELECT 1,132
 UNION ALL 
SELECT 1,133
 UNION ALL 
SELECT 1,134
 UNION ALL 
SELECT 1,140
 UNION ALL 
SELECT 1,141
 UNION ALL 
SELECT 1,142
 UNION ALL 
SELECT 1,143
 UNION ALL 
SELECT 1,144
 UNION ALL 
SELECT 1,145
 UNION ALL 
SELECT 1,146
 UNION ALL 
SELECT 1,147
 UNION ALL 
SELECT 1,148
 UNION ALL 
SELECT 1,150
 UNION ALL 
SELECT 1,151
 UNION ALL 
SELECT 1,152
 UNION ALL 
SELECT 1,153
 UNION ALL 
SELECT 1,154
 UNION ALL 
SELECT 1,160
 UNION ALL 
SELECT 1,161
 UNION ALL 
SELECT 1,162
 UNION ALL 
SELECT 1,163
 UNION ALL 
SELECT 1,164
 UNION ALL 
SELECT 1,165
 UNION ALL 
SELECT 1,166
 UNION ALL 
SELECT 1,167
 UNION ALL 
SELECT 1,168
 UNION ALL 
SELECT 1,170
 UNION ALL 
SELECT 1,171
 UNION ALL 
SELECT 1,172
 UNION ALL 
SELECT 1,173
 UNION ALL 
SELECT 1,174
 UNION ALL 
SELECT 1,180
 UNION ALL 
SELECT 1,181
 UNION ALL 
SELECT 1,182
 UNION ALL 
SELECT 1,183
 UNION ALL 
SELECT 1,184
 UNION ALL 
SELECT 1,185
 UNION ALL 
SELECT 1,186
 UNION ALL 
SELECT 1,187
 UNION ALL 
SELECT 1,188
 UNION ALL 
SELECT 1,190
 UNION ALL 
SELECT 1,191
 UNION ALL 
SELECT 1,192
 UNION ALL 
SELECT 1,193
 UNION ALL 
SELECT 1,194
 UNION ALL 
SELECT 1,204
 UNION ALL 
SELECT 1,205
 UNION ALL 
SELECT 1,206
 UNION ALL 
SELECT 1,207
 UNION ALL 
SELECT 1,211
 UNION ALL 
SELECT 1,212
 UNION ALL 
SELECT 1,216
 UNION ALL 
SELECT 1,219
 UNION ALL 
SELECT 1,221
 UNION ALL 
SELECT 1,223
 UNION ALL 
SELECT 1,237
 UNION ALL 
SELECT 1,230

BEGIN

	SET @I_Kind=RAND() * 100000000

	SET @I_Kind=@I_Kind%100

	IF @I_Kind <97

	BEGIN

		SET @itemindex = (select top 1 ItemID from #TmpLottery where ItemType = 1 order by NEWID())

	END

END

BEGIN
DELETE tblSpecialItem1 where ID in (select top 1 ID from RedMoon.dbo.tblSpecialItem1 where ItemKind = 6 AND ItemIndex = 197 AND Position = 1 AND GameID = @GameID AND WindowKind = @WindowKind AND WindowIndex = @WindowIndex)

IF @@ROWCOUNT > 0 and @@ERROR = 0
BEGIN

UPDATE tblItemLotteryList1 SET GameID=@GameID,UseTime=Getdate() WHERE ID=@LotteryID

DECLARE @GiftItemText varchar(50)

SET @GiftItemText = '0:'+CAST(@ItemKind As varchar)+'-'+CAST(@ItemIndex As varchar)+'/1.'

DECLARE @MailContent varchar(1000)

SET @MailContent = 'Congratulations on winning.'

IF @ItemKind = 6

BEGIN

EXEC RMS_SENDSPECIALITEMMAIL @Sender='lottery claims center',@Recipient=@GameID,@Title='[Congratulations, you won the lottery!]',@Content=@MailContent,@ItemKind=@ItemKind,@ItemIndex=@ItemIndex,@ItemCount=1

END

END

END

commit transaction RMS_ITEMLOTTERY_USEITEM
GO
/****** Object:  StoredProcedure [dbo].[RMS_DOITEMGROWTH]    Script Date: 07/25/2024 12:01:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_DOITEMGROWTH]
    @GameID varchar(14),
    @WindowKind int,
    @WindowIndex int,
    @ItemKind int,
    @ItemIndex int,
    @AttackGrade int,
    @StrengthGrade int,
    @SpiritGrade int,
    @DexterityGrade int,
    @PowerGrade int,
    @NextItemKind int,
    @NextItemIndex int,
    @NextAttackGrade int,
    @NextStrengthGrade int,
    @NextSpiritGrade int,
    @NextDexterityGrade int,
    @NextPowerGrade int
WITH RECOMPILE
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION;

    DECLARE @ItemID int;
    DECLARE @Stage int;
    DECLARE @Stats int;
    DECLARE @ItemStatPref int;
    DECLARE @Point1 int;
    DECLARE @Point2 int;
    DECLARE @Point3 int;

    SET @ItemID = 0;
    SET @Stage = CAST(FLOOR(RAND(CAST(CAST(NEWID() AS binary(4)) AS int)) * 100) AS int);
    SET @Stats = CAST(FLOOR(RAND(CAST(CAST(NEWID() AS binary(4)) AS int)) * 100) AS int);
    SET @ItemStatPref = @ItemIndex - (100 + (@AttackGrade * 20));

    SELECT TOP 1 @ItemID = ID 
    FROM RedMoon.dbo.tblSpecialItem1 
    WHERE GameID = @GameID 
      AND WindowKind = @WindowKind 
      AND WindowIndex = @WindowIndex 
      AND ItemKind = @ItemKind 
      AND ItemIndex = @ItemIndex 
      AND AttackGrade = @AttackGrade 
      AND StrengthGrade = @StrengthGrade 
      AND SpiritGrade = @SpiritGrade 
      AND DexterityGrade = @DexterityGrade 
      AND PowerGrade = @PowerGrade 
      AND Position = 1;

    IF @ItemID > 0
    BEGIN
        IF (@Stage > 90 AND @AttackGrade < 2) OR 
           (@Stage > 94 AND @AttackGrade = 2) OR 
           (@Stage > 96 AND @AttackGrade = 3)
        BEGIN
            UPDATE RedMoon.dbo.tblSpecialItem1 
            SET ItemIndex = @ItemIndex + 20, AttackGrade = @AttackGrade + 1 
            WHERE ID = @ItemID;
        END
        ELSE
        BEGIN
            IF @ItemStatPref IN (7, 8, 11)
            BEGIN
                SET @Point1 = 20;
                SET @Point2 = 60;
                SET @Point3 = 80;
            END
            ELSE IF @ItemStatPref IN (10, 12)
            BEGIN
                SET @Point1 = 40;
                SET @Point2 = 60;
                SET @Point3 = 80;
            END
            ELSE IF @ItemStatPref IN (13, 14)
            BEGIN
                SET @Point1 = 20;
                SET @Point2 = 40;
                SET @Point3 = 80;
            END
            ELSE
            BEGIN
                DECLARE @Dex int;
                DECLARE @Spr int;
                DECLARE @Str int;

                SELECT @Str = Strength, @Spr = Spirit, @Dex = Dexterity 
                FROM tblGameID1 
                WHERE GameID = @GameID;

                IF (@Spr > @Dex AND @Spr > @Str)
                BEGIN
                    SET @Point1 = 20;
                    SET @Point2 = 50;
                    SET @Point3 = 70;
                END
                ELSE IF (@Str > @Dex AND @Str > @Spr)
                BEGIN
                    SET @Point1 = 30;
                    SET @Point2 = 50;
                    SET @Point3 = 70;
                END
                ELSE IF (@Dex > @Str AND @Dex > @Spr)
                BEGIN
                    SET @Point1 = 20;
                    SET @Point2 = 40;
                    SET @Point3 = 70;
                END
                ELSE
                BEGIN
                    SET @Point1 = 25;
                    SET @Point2 = 50;
                    SET @Point3 = 75;
                END
            END

            IF @Stats < @Point1
            BEGIN
                UPDATE RedMoon.dbo.tblSpecialItem1 
                SET StrengthGrade = @StrengthGrade + 1 
                WHERE ID = @ItemID;
            END
            ELSE IF @Stats >= @Point1 AND @Stats < @Point2
            BEGIN
                UPDATE RedMoon.dbo.tblSpecialItem1 
                SET SpiritGrade = @SpiritGrade + 1 
                WHERE ID = @ItemID;
            END
            ELSE IF @Stats >= @Point2 AND @Stats < @Point3
            BEGIN
                UPDATE RedMoon.dbo.tblSpecialItem1 
                SET DexterityGrade = @DexterityGrade + 1 
                WHERE ID = @ItemID;
            END
            ELSE
            BEGIN
                UPDATE RedMoon.dbo.tblSpecialItem1 
                SET PowerGrade = @PowerGrade + 1 
                WHERE ID = @ItemID;
            END
        END
    END

    COMMIT TRANSACTION;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_CLEANUPGAMEBATTLE]    Script Date: 07/25/2024 12:01:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_CLEANUPGAMEBATTLE] 
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION;

    -- Cleanup tables
    DELETE FROM tblBattleArenaScoreLog;
    DELETE FROM tblBattleArenaScore;
    DELETE FROM tblCurrentBattleZoneScore;
    DELETE FROM tblGameID1;
    DELETE FROM tblSpecialItem1;
    DELETE FROM tblCurrentBattleMatchInfo;

    -- Initialize teams
    INSERT INTO tblCurrentBattleMatchInfo (TeamID, TeamName, MemberCount) VALUES (1, 'RED', 0);
    INSERT INTO tblCurrentBattleMatchInfo (TeamID, TeamName, MemberCount) VALUES (2, 'BLUE', 0);

    COMMIT TRANSACTION;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_CHANGEGAMEID]    Script Date: 07/25/2024 12:01:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_CHANGEGAMEID]
    @FromGameID varchar(14),
    @ToGameID varchar(14),
    @ChangedBy varchar(50)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @RowCount1 int, @RowCount2 int;

    BEGIN TRANSACTION RMS_CHANGEGAMEID;

    -- Check existing GameIDs
    SELECT @RowCount1 = COUNT(*) FROM tblGameID1 WHERE GameID = @FromGameID;
    SELECT @RowCount2 = COUNT(*) FROM tblGameID1 WHERE GameID = @ToGameID;

    IF @RowCount1 > 0 AND @RowCount2 = 0
    BEGIN
        -- Update GameID in various tables
        UPDATE tblGameID1 SET GameID = @ToGameID WHERE GameID = @FromGameID;
        UPDATE tblMail1 SET Recipient = @ToGameID WHERE Recipient = @FromGameID;
        UPDATE tblSpecialItem1 SET GameID = @ToGameID WHERE GameID = @FromGameID;
        UPDATE tblArmyList1 SET Commander = @ToGameID WHERE Commander = @FromGameID;
        UPDATE tblArmyMemberList1 SET RegularSoldier = @ToGameID WHERE RegularSoldier = @FromGameID;
        UPDATE tblBattleZonePay1 SET GameID = @ToGameID WHERE GameID = @FromGameID;
        UPDATE tblDumbList1 SET GameID = @ToGameID WHERE GameID = @FromGameID;
        UPDATE tblUserSanctionList1 SET GameID = @ToGameID WHERE GameID = @FromGameID;
        UPDATE tblHiredSoldierList1 SET HiredSoldier = @ToGameID WHERE HiredSoldier = @FromGameID;

        -- Log the change
        INSERT INTO tblChangeLog (FromGameID, ToGameID, ChangedBy)
        VALUES (@FromGameID, @ToGameID, @ChangedBy);
    END

    COMMIT TRANSACTION RMS_CHANGEGAMEID;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_LEVEL1000MAIL]    Script Date: 07/25/2024 12:01:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_LEVEL1000MAIL]
	@GameID varchar(14),
	@Time datetime
AS

set nocount on

declare @updatestoryqueststate_error int, @insertmail_error int

insert tblMail1 (Time, Recipient, Sender, ReadOrNot, Title, Line, Content, Item) values(@Time, @GameID, '[Kasham]', 0, 'Legendary Medicine', 13, '
You have struggled through an arduous journey
of self-discovery and personal development that
has honed your skills to a Level of perfection.
But now you must focus your body and spirit into
finding what can only be described as "Legendary
Medicine"; a pill that when taken by one
enlightened as you allows you to develop your
attributes even further. Who knows what you
can achieve!

You know where I am if you need me.

Kasham', '')


	select @insertmail_error = @@ERROR

	if @updatestoryqueststate_error = 0 AND @insertmail_error = 0
	begin

		commit transaction

	end
	else
	begin

		rollback transaction

	end
GO
/****** Object:  StoredProcedure [dbo].[RMS_LEGALPROTECT_SAVE]    Script Date: 07/25/2024 12:01:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_LEGALPROTECT_SAVE]
    @Protector varchar(14),
    @Assaulter varchar(14),
    @LegalDefenseTimer int
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION RMS_LEGALPROTECT_SAVE;

    DELETE FROM tblLegalProtection1
    WHERE Protector = @Protector AND Assaulter = @Assaulter;

    INSERT INTO tblLegalProtection1 (Protector, Assaulter, LegalDefenseTimer)
    VALUES (@Protector, @Assaulter, @LegalDefenseTimer);

    COMMIT TRANSACTION RMS_LEGALPROTECT_SAVE;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_LEGALPROTECT_DELETE]    Script Date: 07/25/2024 12:01:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_LEGALPROTECT_DELETE]
    @Protector varchar(14),
    @Assaulter varchar(14)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION RMS_LEGALPROTECT_DELETE;

    DELETE FROM tblLegalProtection1
    WHERE Protector = @Protector AND Assaulter = @Assaulter;

    COMMIT TRANSACTION RMS_LEGALPROTECT_DELETE;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_INSERTBATTLEMATCHENTRY]    Script Date: 07/25/2024 12:01:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_INSERTBATTLEMATCHENTRY]
    @ServerIndex int,
    @GameID varchar(14),
    @BillID varchar(14),
    @TeamID int,
    @PayKind int
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION RMS_INSERTBATTLEMATCHENTRY;

    -- Insert battle match entry
    DELETE FROM tblCurrentBattleMatchEntry WHERE ServerIndex = @ServerIndex AND GameID = @GameID AND BillID = @BillID;
    INSERT INTO tblCurrentBattleMatchEntry (ServerIndex, GameID, BillID, TeamID, PayKind)
    VALUES (@ServerIndex, @GameID, @BillID, @TeamID, @PayKind);

    COMMIT TRANSACTION RMS_INSERTBATTLEMATCHENTRY;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_INITIALIZEBILLBATTLEZONE]    Script Date: 07/25/2024 12:01:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_INITIALIZEBILLBATTLEZONE]
    @ZoneIndex int
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @Error int;

    BEGIN TRANSACTION;

    DELETE FROM tblCurrentBattleZoneScore 
    WHERE ZoneIndex = @ZoneIndex;

    SET @Error = @@ERROR;

    IF @Error = 0
    BEGIN
        COMMIT TRANSACTION;
    END
    ELSE
    BEGIN
        ROLLBACK TRANSACTION;
    END
END;
GO
/****** Object:  StoredProcedure [dbo].[RMS_INITIALIZEBILLBATTLEMATCH]    Script Date: 07/25/2024 12:01:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_INITIALIZEBILLBATTLEMATCH]
    @TeamID int,
    @InitEntry int
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION RMS_INITIALIZEBILLBATTLEMATCH;

    DECLARE @Error INT, @TeamName AS VARCHAR(10), @MemberCount AS INT;

    SET @Error = 0;

    IF @InitEntry = 1
    BEGIN
        DELETE FROM tblCurrentBattleMatchEntry WHERE TeamID = @TeamID;
        SET @Error = @@ERROR;
    END

    IF @Error = 0
    BEGIN
        IF @TeamID = 1
        BEGIN
            SET @TeamName = 'RED';
            SELECT @MemberCount = COUNT(*) FROM tblCurrentBattleMatchEntry WHERE TeamID = @TeamID AND JoinState = 1;
            SET @Error = @@ERROR;
        END
        ELSE IF @TeamID = 2
        BEGIN
            SET @TeamName = 'BLUE';
            SELECT @MemberCount = COUNT(*) FROM tblCurrentBattleMatchEntry WHERE TeamID = @TeamID AND JoinState = 1;
            SET @Error = @@ERROR;
        END
        ELSE
        BEGIN
            SET @TeamName = '';
        END
    END

    IF @Error = 0
    BEGIN
        DECLARE @RowCount INT;
        SELECT @RowCount = COUNT(*) FROM tblCurrentBattleMatchInfo WITH (TABLOCKX) WHERE TeamID = @TeamID;
        IF @RowCount = 0
        BEGIN
            INSERT INTO tblCurrentBattleMatchInfo (TeamID, TeamName, MemberCount, StartTime)
            VALUES (@TeamID, @TeamName, @MemberCount, GETDATE());
            SET @Error = @@ERROR;
        END
        ELSE
        BEGIN
            UPDATE tblCurrentBattleMatchInfo
            SET TeamName = @TeamName, MemberCount = @MemberCount, StartTime = GETDATE(), Score = 0, TotalScore = 0, SmashedTower = 0, AvgMemberLevel = 0, bWin = 0
            WHERE TeamID = @TeamID;
            SET @Error = @@ERROR;
        END
    END

    -- Commit or rollback transaction based on error
    IF @Error = 0
    BEGIN
        COMMIT TRANSACTION RMS_INITIALIZEBILLBATTLEMATCH;
    END
    ELSE
    BEGIN
        ROLLBACK TRANSACTION RMS_INITIALIZEBILLBATTLEMATCH;
    END
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_INITIALIZEBILLBATTLEARENA]    Script Date: 07/25/2024 12:01:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_INITIALIZEBILLBATTLEARENA] AS

set nocount on

declare @Error int

set @Error = 1

begin transaction

delete tblCurrentBattleArenaScore
select @Error = @@ERROR

--if 0 = @Error
--begin
--	delete tblBattleArenaPay where Used = 0
--	select @Error = @@ERROR
--end

if 0 = @Error
begin
	commit transaction
end
else
begin
	rollback transaction
end
GO
/****** Object:  StoredProcedure [dbo].[RMS_INCREASEBATTLEZONESCORE]    Script Date: 07/25/2024 12:01:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RMS_INCREASEBATTLEZONESCORE]
    @ZoneIndex int,
    @WinnerGameID varchar(14),
    @WinnerBillID varchar(14),
    @WinnerServerIndex int,
    @LoserGameID varchar(14),
    @LoserBillID varchar(14),
    @LoserServerIndex int,
    @Score int
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @WinnerCount int, @LoserCount int, @WinnerUpdateError int, @LoserUpdateError int;

    SET @WinnerCount = 0;
    SET @LoserCount = 0;
    SET @WinnerUpdateError = 1;
    SET @LoserUpdateError = 1;

    BEGIN TRANSACTION;

    -- Insert or update winner scores
    SELECT @WinnerCount = COUNT(*)
    FROM tblCurrentBattleZoneScore
    WHERE GameID = @WinnerGameID AND BillID = @WinnerBillID AND ServerIndex = @WinnerServerIndex;

    IF @WinnerCount = 0
    BEGIN
        INSERT INTO tblCurrentBattleZoneScore (ZoneIndex, GameID, BillID, ServerIndex)
        VALUES (@ZoneIndex, @WinnerGameID, @WinnerBillID, @WinnerServerIndex);

        INSERT INTO redmoon.dbo.tblCurrentBattleArenaScore (ZoneIndex, GameID, BillID, ServerIndex)
        VALUES (@ZoneIndex, @WinnerGameID, @WinnerBillID, @WinnerServerIndex);

        INSERT INTO redmoon.dbo.tblBattleArenaScore (ZoneIndex, GameID, BillID, ServerIndex)
        VALUES (@ZoneIndex, @WinnerGameID, @WinnerBillID, @WinnerServerIndex);

        INSERT INTO tblBattleZoneScore (ZoneIndex, GameID, BillID, ServerIndex)
        VALUES (@ZoneIndex, @WinnerGameID, @WinnerBillID, @WinnerServerIndex);

        INSERT INTO tblBattleArenaScore (ZoneIndex, GameID, BillID, ServerIndex)
        VALUES (1, @WinnerGameID, @WinnerBillID, @WinnerServerIndex);
    END

    -- Insert or update loser scores
    SELECT @LoserCount = COUNT(*)
    FROM tblCurrentBattleZoneScore
    WHERE GameID = @LoserGameID AND BillID = @LoserBillID AND ServerIndex = @LoserServerIndex;

    IF @LoserCount = 0
    BEGIN
        INSERT INTO tblCurrentBattleZoneScore (ZoneIndex, GameID, BillID, ServerIndex)
        VALUES (@ZoneIndex, @LoserGameID, @LoserBillID, @LoserServerIndex);

        INSERT INTO redmoon.dbo.tblCurrentBattleArenaScore (ZoneIndex, GameID, BillID, ServerIndex)
        VALUES (@ZoneIndex, @LoserGameID, @LoserBillID, @LoserServerIndex);

        INSERT INTO tblBattleZoneScore (ZoneIndex, GameID, BillID, ServerIndex)
        VALUES (@ZoneIndex, @LoserGameID, @LoserBillID, @LoserServerIndex);

        INSERT INTO redmoon.dbo.tblBattleArenaScore (ZoneIndex, GameID, BillID, ServerIndex)
        VALUES (@ZoneIndex, @LoserGameID, @LoserBillID, @LoserServerIndex);

        INSERT INTO tblBattleArenaScore (ZoneIndex, GameID, BillID, ServerIndex)
        VALUES (1, @LoserGameID, @LoserBillID, @LoserServerIndex);
    END

    -- Update winner scores
    UPDATE tblCurrentBattleZoneScore
    SET Win = Win + 1, Score = Score + @Score
    WHERE GameID = @WinnerGameID AND BillID = @WinnerBillID AND ServerIndex = @WinnerServerIndex;

    UPDATE redmoon.dbo.tblCurrentBattleArenaScore
    SET Win = Win + 1, Score = Score + @Score
    WHERE GameID = @WinnerGameID AND BillID = @WinnerBillID AND ServerIndex = @WinnerServerIndex;

    UPDATE tblBattleZoneScore
    SET Win = Win + 1, Score = Score + @Score
    WHERE GameID = @WinnerGameID AND BillID = @WinnerBillID AND ServerIndex = @WinnerServerIndex;

    UPDATE tblBattleArenaScore
    SET Win = Win + 1, Score = Score + @Score
    WHERE GameID = @WinnerGameID AND BillID = @WinnerBillID AND ServerIndex = @WinnerServerIndex;

    UPDATE redmoon.dbo.tblBattleArenaScore
    SET Win = Win + 1, Score = Score + @Score
    WHERE GameID = @WinnerGameID AND BillID = @WinnerBillID AND ServerIndex = @WinnerServerIndex;
    SET @WinnerUpdateError = @@ERROR;

    -- Update loser scores
    UPDATE tblCurrentBattleZoneScore
    SET Lose = Lose + 1
    WHERE GameID = @LoserGameID AND BillID = @LoserBillID AND ServerIndex = @LoserServerIndex;

    UPDATE redmoon.dbo.tblCurrentBattleArenaScore
    SET Lose = Lose + 1
    WHERE GameID = @LoserGameID AND BillID = @LoserBillID AND ServerIndex = @LoserServerIndex;

    UPDATE tblBattleZoneScore
    SET Lose = Lose + 1
    WHERE GameID = @LoserGameID AND BillID = @LoserBillID AND ServerIndex = @LoserServerIndex;

    UPDATE redmoon.dbo.tblBattleArenaScore
    SET Lose = Lose + 1
    WHERE GameID = @LoserGameID AND BillID = @LoserBillID AND ServerIndex = @LoserServerIndex;

    UPDATE tblBattleArenaScore
    SET Lose = Lose + 1
    WHERE GameID = @LoserGameID AND BillID = @LoserBillID AND ServerIndex = @LoserServerIndex;
    SET @LoserUpdateError = @@ERROR;

    -- Commit or rollback transaction based on error
    IF @WinnerUpdateError = 0 AND @LoserUpdateError = 0
    BEGIN
        COMMIT TRANSACTION;
    END
    ELSE
    BEGIN
        ROLLBACK TRANSACTION;
    END
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_INCREASEBATTLEMATCHSCORE]    Script Date: 07/25/2024 12:01:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_INCREASEBATTLEMATCHSCORE] 
    @TeamID int,
    @ScoreDiff int,
    @SmashedGuardTower int
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION RMS_INCREASEBATTLEMATCHSCORE;

    -- Increase score and update smashed tower status
    UPDATE tblCurrentBattleMatchInfo 
    SET Score = Score + @ScoreDiff, SmashedTower = SmashedTower | @SmashedGuardTower
    WHERE TeamID = @TeamID;

    COMMIT TRANSACTION RMS_INCREASEBATTLEMATCHSCORE;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_GROUP_DELETEMAPMEMBER]    Script Date: 07/25/2024 12:01:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_GROUP_DELETEMAPMEMBER]
    @MapNumber int
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION RMS_GROUP_DELETEMAPMEMBER;

    DELETE FROM tblGroupInfo1 
    WHERE MapNumber = @MapNumber;

    COMMIT TRANSACTION RMS_GROUP_DELETEMAPMEMBER;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_GROUP_DELETEGROUPMEMBER]    Script Date: 07/25/2024 12:01:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_GROUP_DELETEGROUPMEMBER]
    @UserID varchar(14)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION RMS_GROUP_DELETEGROUPMEMBER;

    DECLARE @GroupNum int;
    SET @GroupNum = -1;

    SELECT @GroupNum = GroupNum 
    FROM tblGroupInfo1 
    WHERE UserID = @UserID;

    IF @GroupNum != -1
    BEGIN
        DELETE FROM tblGroupInfo1 
        WHERE UserID = @UserID;
    END

    COMMIT TRANSACTION RMS_GROUP_DELETEGROUPMEMBER;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_GROUP_DELETEGROUP]    Script Date: 07/25/2024 12:01:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_GROUP_DELETEGROUP]
    @GroupNum int
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION RMS_GROUP_DELETEGROUP;

    IF @GroupNum > 0
    BEGIN
        DELETE FROM tblGroupInfo1 WHERE GroupNum = @GroupNum;
    END

    COMMIT TRANSACTION RMS_GROUP_DELETEGROUP;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_GROUP_CREATENEWGROUP]    Script Date: 07/25/2024 12:01:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_GROUP_CREATENEWGROUP]
    @UserID varchar(14),
    @Face tinyint,
    @MapNumber int
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION RMS_GROUP_CREATENEWGROUP;

    DECLARE @FindUserGroup int;
    DECLARE @GroupNum int;

    SET @FindUserGroup = -1;

    SELECT @FindUserGroup = GroupNum
    FROM tblGroupInfo1
    WHERE UserID = @UserID;

    IF @FindUserGroup = -1
    BEGIN
        SELECT @GroupNum = MAX(GroupNum) + 1
        FROM tblGroupInfo1;

        SET @GroupNum = ISNULL(@GroupNum, 1);

        INSERT INTO tblGroupInfo1 (GroupNum, bGroupMaster, UserID, Face, MapNumber)
        VALUES (@GroupNum, 1, @UserID, @Face, @MapNumber);
    END

    COMMIT TRANSACTION RMS_GROUP_CREATENEWGROUP;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_GROUP_CHANGEUSERMAPNUMBER]    Script Date: 07/25/2024 12:01:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_GROUP_CHANGEUSERMAPNUMBER]
    @UserID varchar(14),
    @MapNumber int
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION RMS_GROUP_CHANGEUSERMAPNUMBER;

    DECLARE @FindUserMapNum int;
    SET @FindUserMapNum = -1;

    SELECT @FindUserMapNum = MapNumber
    FROM tblGroupInfo1
    WHERE UserID = @UserID;

    IF @FindUserMapNum != -1
    BEGIN
        UPDATE tblGroupInfo1
        SET MapNumber = @MapNumber
        WHERE UserID = @UserID;
    END

    COMMIT TRANSACTION RMS_GROUP_CHANGEUSERMAPNUMBER;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_GROUP_ADDGROUPMEMBER]    Script Date: 07/25/2024 12:01:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_GROUP_ADDGROUPMEMBER]
    @GroupMaster varchar(14),
    @UserID varchar(14),
    @Face tinyint,
    @MapNumber int
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION RMS_GROUP_ADDGROUPMEMBER;

    DECLARE @FindMasterGroupNum int;
    DECLARE @FindUserGroupNum int;

    SET @FindMasterGroupNum = -1;
    SET @FindUserGroupNum = -1;

    SELECT @FindMasterGroupNum = GroupNum 
    FROM tblGroupInfo1 
    WHERE UserID = @GroupMaster AND bGroupMaster = 1;

    SELECT @FindUserGroupNum = GroupNum 
    FROM tblGroupInfo1 
    WHERE UserID = @UserID;

    IF @FindMasterGroupNum != -1 AND @FindUserGroupNum = -1
    BEGIN
        INSERT INTO tblGroupInfo1 (GroupNum, bGroupMaster, UserID, Face, MapNumber) 
        VALUES (@FindMasterGroupNum, 0, @UserID, @Face, @MapNumber);
    END

    COMMIT TRANSACTION RMS_GROUP_ADDGROUPMEMBER;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_EXTENDFREEDATE]    Script Date: 07/25/2024 12:01:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_EXTENDFREEDATE]
    @BillID varchar(14),
    @FreeDate datetime
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @CountBillID int;

    BEGIN TRANSACTION;

    SELECT @CountBillID = COUNT(*) 
    FROM tblBillID 
    WHERE BillID = @BillID;

    IF @CountBillID = 0
    BEGIN
        ROLLBACK TRANSACTION;
        SELECT Result = 0;
        RETURN;
    END

    BEGIN
        UPDATE tblBillID 
        SET FreeDate = @FreeDate 
        WHERE BillID = @BillID;
    END

    COMMIT TRANSACTION;
    SELECT Result = 1;
    RETURN;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_SENDNORMALITEMMAIL]    Script Date: 07/25/2024 12:01:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_SENDNORMALITEMMAIL]
	@Sender VARCHAR(14),
	@Recipient VARCHAR(14),
	@Title VARCHAR(80),
	@Content VARCHAR(1000),
	@ItemKind INT,
	@ItemIndex INT,
	@ItemCount INT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @MailCount INT;
	DECLARE @Time DATETIME;
	DECLARE @ItemText VARCHAR(20);

	SET @MailCount = 0;
	SET @Time = CAST(CONVERT(VARCHAR, GETDATE(), 120) AS DATETIME);

	BEGIN TRANSACTION;

	-- Check for mail conflicts and adjust the time if necessary
	SELECT @MailCount = COUNT(*)
	FROM tblMail1
	WHERE Recipient = @Recipient AND Time = @Time;

	WHILE @MailCount > 0
	BEGIN
		SET @MailCount = 0;
		SET @Time = DATEADD(SECOND, 1, @Time);
		SELECT @MailCount = COUNT(*)
		FROM tblMail1
		WHERE Recipient = @Recipient AND Time = @Time;
	END

	-- Set the item text based on the item kind and count
	IF @ItemKind = 6 OR @ItemCount = 0
	BEGIN
		SET @ItemText = '';
	END
	ELSE
	BEGIN
		SET @ItemText = '0:' + CAST(@ItemKind AS VARCHAR) + '-' + CAST(@ItemIndex AS VARCHAR) + '/' + CAST(@ItemCount AS VARCHAR) + '.';
	END

	-- Insert the mail record
	INSERT INTO tblMail1 (Time, Recipient, Sender, ReadOrNot, Title, Line, Content, Item)
	VALUES (@Time, @Recipient, @Sender, 0, @Title, 20, @Content, @ItemText);

	COMMIT TRANSACTION;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_SENDMAIL]    Script Date: 07/25/2024 12:01:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_SENDMAIL]
	@Recipient VARCHAR(14),
	@Sender VARCHAR(14),
	@Title CHAR(80),
	@Line INT,
	@MailContent VARCHAR(1000),
	@Item VARCHAR(100)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @RowCount INT;
	DECLARE @MailDate DATETIME;
	SET @MailDate = CAST(CONVERT(VARCHAR, GETDATE(), 120) AS DATETIME);

	BEGIN TRANSACTION RMS_SENDMAIL;

	-- Check if mail for the current time and recipient already exists
	SELECT @RowCount = COUNT(*) 
	FROM tblMail1 
	WHERE Time = @MailDate AND Recipient = @Recipient;

	IF @RowCount = 0
	BEGIN
		-- Insert the mail if no conflict exists
		INSERT INTO tblMail1 (Time, Recipient, Sender, ReadOrNot, Title, Line, Content, Item) 
		VALUES (@MailDate, @Recipient, @Sender, 0, @Title, @Line, @MailContent, @Item);
	END
	ELSE
	BEGIN
		-- If conflict exists, adjust the time and insert the mail
		SELECT @MailDate = DATEADD(SECOND, 1, MAX(Time)) 
		FROM tblMail1 
		WHERE Recipient = @Recipient;

		INSERT INTO tblMail1 (Time, Recipient, Sender, ReadOrNot, Title, Line, Content, Item) 
		VALUES (@MailDate, @Recipient, @Sender, 0, @Title, @Line, @MailContent, @Item);
	END

	COMMIT TRANSACTION RMS_SENDMAIL;
END
GO
/****** Object:  StoredProcedure [dbo].[InsertUserCountLog]    Script Date: 07/25/2024 12:01:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertUserCountLog]
    @Time DATETIME,
    @ServerName VARCHAR(255),
    @UserCount INT,
    @First INT
AS
BEGIN
    EXEC CreateUserCountLogTable

    DECLARE @tableName NVARCHAR(128) = 'tblUserCountLog1_' + CONVERT(VARCHAR(6), GETDATE(), 112)
    DECLARE @sql NVARCHAR(MAX) = 'INSERT INTO ' + @tableName + ' (Time, ServerName, UserCount, First) VALUES (@Time, @ServerName, @UserCount, @First)'

    EXEC sp_executesql @sql,
        N'@Time DATETIME, @ServerName VARCHAR(255), @UserCount INT, @First INT',
        @Time, @ServerName, @UserCount, @First
END
GO
/****** Object:  StoredProcedure [dbo].[InsertLevelLog]    Script Date: 07/25/2024 12:01:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertLevelLog]
    @GameID VARCHAR(50),
    @BillID VARCHAR(50),
    @Lvl INT,
    @Face INT,
    @Time DATETIME,
    @Strength INT,
    @Spirit INT,
    @Dexterity INT,
    @Power INT,
    @Fame INT,
    @BonusInitCount INT,
    @StoryQuestState INT,
    @QuestItem VARCHAR(MAX),
    @OPPKTimer INT
AS
BEGIN
    EXEC CreateLevelLogTable

    DECLARE @tableName NVARCHAR(128) = 'tblLevelLog1_' + CONVERT(VARCHAR(6), GETDATE(), 112)
    DECLARE @sql NVARCHAR(MAX) = 'INSERT INTO ' + @tableName + ' (GameID, BillID, Lvl, Face, Time, Strength, Spirit, Dexterity, Power, Fame, BonusInitCount, StoryQuestState, QuestItem, OPPKTimer) VALUES (@GameID, @BillID, @Lvl, @Face, @Time, @Strength, @Spirit, @Dexterity, @Power, @Fame, @BonusInitCount, @StoryQuestState, @QuestItem, @OPPKTimer)'

    EXEC sp_executesql @sql,
        N'@GameID VARCHAR(50), @BillID VARCHAR(50), @Lvl INT, @Face INT, @Time DATETIME, @Strength INT, @Spirit INT, @Dexterity INT, @Power INT, @Fame INT, @BonusInitCount INT, @StoryQuestState INT, @QuestItem VARCHAR(MAX), @OPPKTimer INT',
        @GameID, @BillID, @Lvl, @Face, @Time, @Strength, @Spirit, @Dexterity, @Power, @Fame, @BonusInitCount, @StoryQuestState, @QuestItem, @OPPKTimer
END
GO
/****** Object:  StoredProcedure [dbo].[InsertItemLog]    Script Date: 07/25/2024 12:01:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertItemLog]
    @LogKind VARCHAR(50),
    @MapNumber INT,
    @FromID VARCHAR(50),
    @ToID VARCHAR(50),
    @ItemKind INT,
    @ItemIndex INT,
    @ItemCount INT
AS
BEGIN
    EXEC CreateItemLogTable

    DECLARE @tableName NVARCHAR(128) = 'tblItemLog1_' + CONVERT(VARCHAR(6), GETDATE(), 112)
    DECLARE @sql NVARCHAR(MAX) = 'INSERT INTO ' + @tableName + ' (LogKind, MapNumber, FromID, ToID, ItemKind, ItemIndex, ItemCount) VALUES (@LogKind, @MapNumber, @FromID, @ToID, @ItemKind, @ItemIndex, @ItemCount)'

    EXEC sp_executesql @sql,
        N'@LogKind VARCHAR(50), @MapNumber INT, @FromID VARCHAR(50), @ToID VARCHAR(50), @ItemKind INT, @ItemIndex INT, @ItemCount INT',
        @LogKind, @MapNumber, @FromID, @ToID, @ItemKind, @ItemIndex, @ItemCount
END
GO
/****** Object:  StoredProcedure [dbo].[BILL_PROCESS_COUPON]    Script Date: 07/25/2024 12:01:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
-- Coupon management
CREATE PROCEDURE [dbo].[BILL_PROCESS_COUPON]
    @Coupon char(5),
    @CouponNumber char(25),
    @BillID char(14),
    @RemoteAddr char(16),
    @Type int,
    @Amount int
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @coupon_count int, @FreeDate datetime;
    BEGIN TRANSACTION;
    
    -- Has the coupon ever been used
    SELECT @coupon_count = count(*) 
    FROM tblCouponData 
    WHERE State = 0 AND CouponNumber = @CouponNumber;
    
    IF @coupon_count = 0
    BEGIN
        ROLLBACK TRANSACTION;
        SELECT result = 0;
        RETURN;
    END
    
    -- Coupon use status
    UPDATE tblCouponData 
    SET State = 1, ID = @BillID, Time = GETDATE(), RemoteAddr = @RemoteAddr 
    WHERE CouponNumber = @CouponNumber;

    IF @@ERROR <> 0
    BEGIN
        ROLLBACK TRANSACTION;
        SELECT result = 0;
        RETURN;
    END
    
    -- Add date
    IF @Type = 1
    BEGIN
        SELECT @FreeDate = FreeDate 
        FROM tblBillID 
        WHERE BillID = @BillID AND FreeDate > GETDATE();
        
        IF @FreeDate IS NULL
        BEGIN
            UPDATE tblBillID 
            SET FreeDate = GETDATE() + @Amount 
            WHERE BillID = @BillID;
        END
        ELSE
        BEGIN
            UPDATE tblBillID 
            SET FreeDate = FreeDate + @Amount 
            WHERE BillID = @BillID;
        END
        
        IF @@ERROR <> 0
        BEGIN
            ROLLBACK TRANSACTION;
            SELECT result = 0;
            RETURN;
        END
    END
    
    -- Add minutes
    IF @Type = 2
    BEGIN
        UPDATE tblBillID 
        SET FreeTimer = FreeTimer + @Amount 
        WHERE BillID = @BillID;
        
        IF @@ERROR <> 0
        BEGIN
            ROLLBACK TRANSACTION;
            SELECT result = 0;
            RETURN;
        END
    END
    
    COMMIT TRANSACTION;
    SELECT result = 1;
    RETURN;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_ADDBATTLEMATCHUSERPOINT2]    Script Date: 07/25/2024 12:01:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_ADDBATTLEMATCHUSERPOINT2]
    @ServerIndex int,
    @GameID varchar(14),
    @BillID varchar(14),
    @Point int
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Error int, @ScoreCount int;

    BEGIN TRANSACTION RMS_ADDBATTLEMATCHUSERPOINT2;

    -- Check if the user already has points
    SELECT @ScoreCount = COUNT(*)
    FROM tblBattleMatchUserPoint
    WHERE GameID = @GameID AND BillID = @BillID AND ServerIndex = @ServerIndex;
    SET @Error = @@ERROR;

    IF @Error = 0
    BEGIN
        IF @ScoreCount = 0
        BEGIN
            -- Insert new record
            INSERT INTO tblBattleMatchUserPoint (ServerIndex, GameID, BillID, UsablePoint, TotalPoint)
            VALUES (@ServerIndex, @GameID, @BillID, @Point, @Point);
            SET @Error = @@ERROR;
        END
        ELSE
        BEGIN
            -- Update existing record
            UPDATE tblBattleMatchUserPoint
            SET UsablePoint = UsablePoint + @Point, TotalPoint = TotalPoint + @Point
            WHERE ServerIndex = @ServerIndex AND GameID = @GameID AND BillID = @BillID;
            SET @Error = @@ERROR;
        END
    END

    -- Commit or rollback transaction based on error
    IF @Error = 0
    BEGIN
        COMMIT TRANSACTION RMS_ADDBATTLEMATCHUSERPOINT2;
    END
    ELSE
    BEGIN
        ROLLBACK TRANSACTION RMS_ADDBATTLEMATCHUSERPOINT2;
    END
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_ADDBATTLEMATCHUSERPOINT]    Script Date: 07/25/2024 12:01:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_ADDBATTLEMATCHUSERPOINT] 
    @ServerIndex int,
    @GameID varchar(14),
    @BillID varchar(14),
    @Point int
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Error int, @ScoreCount int;

    BEGIN TRANSACTION RMS_ADDBATTLEMATCHUSERPOINT;

    -- Check if the user already has points
    SELECT @ScoreCount = COUNT(*)
    FROM tblBattleMatchUserPoint
    WHERE GameID = @GameID AND BillID = @BillID AND ServerIndex = @ServerIndex;
    SET @Error = @@ERROR;

    IF @Error = 0
    BEGIN
        IF @ScoreCount = 0
        BEGIN
            -- Insert new record
            INSERT INTO tblBattleMatchUserPoint (ServerIndex, GameID, BillID, UsablePoint, TotalPoint)
            VALUES (@ServerIndex, @GameID, @BillID, @Point, 0);
            SET @Error = @@ERROR;
        END
        ELSE
        BEGIN
            -- Update existing record
            UPDATE tblBattleMatchUserPoint
            SET UsablePoint = UsablePoint + @Point
            WHERE ServerIndex = @ServerIndex AND GameID = @GameID AND BillID = @BillID;
            SET @Error = @@ERROR;
        END
    END

    -- Commit or rollback transaction based on error
    IF @Error = 0
    BEGIN
        COMMIT TRANSACTION RMS_ADDBATTLEMATCHUSERPOINT;
    END
    ELSE
    BEGIN
        ROLLBACK TRANSACTION RMS_ADDBATTLEMATCHUSERPOINT;
    END
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_Accounts_Info_Log]    Script Date: 07/25/2024 12:01:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_Accounts_Info_Log] 
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ValidAccts   AS int; -- Valid Accounts
    DECLARE @PaidAccts    AS int; -- Paid Accounts
    DECLARE @ExpAccts     AS int; -- Paid accounts that have expired
    DECLARE @NewAccts     AS int; -- New Accounts created today
    DECLARE @TotalAccts   AS int; -- Total number of accounts
    DECLARE @TheDate      AS DATETIME;

    -- Get the current date and change time to 00:00:00.000
    SET @TheDate = CONVERT(datetime, CONVERT(varchar(10), GETDATE(), 111));

    -- Valid Accounts
    SELECT @ValidAccts = COUNT(*)
    FROM tblBillID WITH(NOLOCK)
    WHERE FreeDate >= @TheDate;

    -- Paid Accounts
    SELECT @PaidAccts = COUNT(*)
    FROM tblBillID WITH(NOLOCK)
    WHERE FreeDate >= @TheDate
      AND DATEDIFF(dd, FirstLogin, FreeDate) > 14;

    -- Paid accounts that have expired
    SELECT @ExpAccts = COUNT(*)
    FROM tblBillID WITH(NOLOCK)
    WHERE FreeDate >= @TheDate
      AND FreeDate < DATEADD(day, 1, @TheDate)
      AND DATEDIFF(dd, FirstLogin, FreeDate) > 14;

    -- New Accounts created today
    SELECT @NewAccts = COUNT(*)
    FROM tblBillID WITH(NOLOCK)
    WHERE FirstLogin >= @TheDate;

    -- Total number of accounts
    SELECT @TotalAccts = COUNT(*)
    FROM tblBillID WITH(NOLOCK);

    -- Insert into the log table
    INSERT INTO tblAccountsStatsLog (ValidAccts, PaidAccts, ExpAccts, NewAccts, TotalAccts) 
    VALUES (@ValidAccts, @PaidAccts, @ExpAccts, @NewAccts, @TotalAccts);

END
GO
/****** Object:  StoredProcedure [dbo].[InsertDeathLog]    Script Date: 07/25/2024 12:01:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertDeathLog]
    @GameID VARCHAR(50),
    @BillID VARCHAR(50),
    @Time DATETIME,
    @Map INT,
    @X INT,
    @Y INT,
    @TileKind INT,
    @Item VARCHAR(MAX),
    @Equipment VARCHAR(MAX),
    @Experience INT,
    @Money INT,
    @SigMoney INT,
    @QuickItem VARCHAR(MAX),
    @Fame INT,
    @KillerID VARCHAR(50),
    @KillerFame INT,
    @Dead INT,
    @KillerLevel INT,
    @KillerStrength INT,
    @KillerSpirit INT,
    @KillerDexterity INT,
    @KillerPower INT
AS
BEGIN
    EXEC CreateDeathLogTable

    DECLARE @tableName NVARCHAR(128) = 'tblDeathLog1_' + CONVERT(VARCHAR(6), GETDATE(), 112)
    DECLARE @sql NVARCHAR(MAX) = 'INSERT INTO ' + @tableName + ' (GameID, BillID, Time, Map, X, Y, TileKind, Item, Equipment, Experience, Money, SigMoney, QuickItem, Fame, KillerID, KillerFame, Dead, KillerLevel, KillerStrength, KillerSpirit, KillerDexterity, KillerPower) VALUES (@GameID, @BillID, @Time, @Map, @X, @Y, @TileKind, @Item, @Equipment, @Experience, @Money, @SigMoney, @QuickItem, @Fame, @KillerID, @KillerFame, @Dead, @KillerLevel, @KillerStrength, @KillerSpirit, @KillerDexterity, @KillerPower)'

    EXEC sp_executesql @sql, 
        N'@GameID VARCHAR(50), @BillID VARCHAR(50), @Time DATETIME, @Map INT, @X INT, @Y INT, @TileKind INT, @Item VARCHAR(MAX), @Equipment VARCHAR(MAX), @Experience INT, @Money INT, @SigMoney INT, @QuickItem VARCHAR(MAX), @Fame INT, @KillerID VARCHAR(50), @KillerFame INT, @Dead INT, @KillerLevel INT, @KillerStrength INT, @KillerSpirit INT, @KillerDexterity INT, @KillerPower INT',
        @GameID, @BillID, @Time, @Map, @X, @Y, @TileKind, @Item, @Equipment, @Experience, @Money, @SigMoney, @QuickItem, @Fame, @KillerID, @KillerFame, @Dead, @KillerLevel, @KillerStrength, @KillerSpirit, @KillerDexterity, @KillerPower
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_ARMY_ADDSUBARMYMEMBER]    Script Date: 07/25/2024 12:01:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_ARMY_ADDSUBARMYMEMBER]
    @Member varchar(14),
    @SubCommander varchar(14)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION RMS_ARMY_ADDSUBARMYMEMBER;

    DECLARE @SubArmyID int;
    DECLARE @ArmyID int;

    SELECT @ArmyID = ArmyID, @SubArmyID = ID 
    FROM tblSubArmyList1 
    WHERE SubCommander = @SubCommander;

    IF @@ROWCOUNT != 0
    BEGIN
        UPDATE tblArmyMemberList1 
        SET SubArmyID = @SubArmyID 
        WHERE ArmyID = @ArmyID 
        AND RegularSoldier = @Member;
    END

    COMMIT TRANSACTION RMS_ARMY_ADDSUBARMYMEMBER;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_ARMY_ADDREJOINSANCTION]    Script Date: 07/25/2024 12:01:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_ARMY_ADDREJOINSANCTION]
    @GameID varchar(14)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION RMS_ARMY_ADDREJOINSANCTION;
    
    DECLARE @SanctionTime datetime;
    SET @SanctionTime = DATEADD(day, 7, GETDATE());

    DECLARE @RowCount int;
    SELECT @RowCount = COUNT(*) FROM tblArmyJoinSanctionList1 WHERE GameID = @GameID;
    IF @RowCount > 0
    BEGIN
        UPDATE tblArmyJoinSanctionList1 
        SET SanctionTime = @SanctionTime 
        WHERE GameID = @GameID;
    END
    ELSE
    BEGIN
        INSERT INTO tblArmyJoinSanctionList1
        VALUES (@GameID, @SanctionTime);
    END

    COMMIT TRANSACTION RMS_ARMY_ADDREJOINSANCTION;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_ARMY_ADDHIREDSOLDIER]    Script Date: 07/25/2024 12:01:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_ARMY_ADDHIREDSOLDIER]
    @ArmyID int,
    @HiredSoldier varchar(14)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION RMS_ARMY_ADDHIREDSOLDIER;

    DECLARE @RowCount1 int;
    DECLARE @RowCount2 int;
    DECLARE @RowCount3 int;
    DECLARE @RowCount4 int;

    SELECT @RowCount1 = COUNT(*) FROM tblArmyList1 WHERE Commander = @HiredSoldier;
    SELECT @RowCount2 = COUNT(*) FROM tblArmyMemberList1 WHERE RegularSoldier = @HiredSoldier;
    SELECT @RowCount3 = COUNT(*) FROM tblHiredSoldierList1 WHERE HiredSoldier = @HiredSoldier;
    SELECT @RowCount4 = COUNT(*) FROM tblArmyList1 WHERE ID = @ArmyID;

    IF @RowCount1 = 0 AND @RowCount2 = 0 AND @RowCount3 = 0 AND @RowCount4 != 0
    BEGIN
        INSERT INTO tblHiredSoldierList1
        VALUES (@ArmyID, @HiredSoldier);
    END

    COMMIT TRANSACTION RMS_ARMY_ADDHIREDSOLDIER;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_ARMY_ADDARMYMEMBER]    Script Date: 07/25/2024 12:01:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_ARMY_ADDARMYMEMBER]
    @ArmyID int,
    @Member varchar(14)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION RMS_ARMY_ADDARMYMEMBER;
    
    DECLARE @RowCount1 int;
    DECLARE @RowCount2 int;
    DECLARE @RowCount3 int;
    DECLARE @RowCount4 int;

    SELECT @RowCount1 = COUNT(*) FROM tblArmyList1 WHERE Commander = @Member;
    SELECT @RowCount2 = COUNT(*) FROM tblArmyMemberList1 WHERE RegularSoldier = @Member;
    SELECT @RowCount3 = COUNT(*) FROM tblHiredSoldierList1 WHERE HiredSoldier = @Member;
    SELECT @RowCount4 = COUNT(*) FROM tblArmyList1 WHERE ID = @ArmyID;

    IF @RowCount1 = 0 AND @RowCount2 = 0 AND @RowCount3 = 0 AND @RowCount4 != 0
    BEGIN
        INSERT INTO tblArmyMemberList1
        VALUES (@Member, @ArmyID, 0, GETDATE());
    END

    COMMIT TRANSACTION RMS_ARMY_ADDARMYMEMBER;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_ARMY_CANCELARMYCREATIONINFO]    Script Date: 07/25/2024 12:01:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_ARMY_CANCELARMYCREATIONINFO]
    @Camp tinyint
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION RMS_ARMY_CANCELARMYCREATIONINFO;

    UPDATE tblArmyList1 
    SET State = -1 
    WHERE State = -2;

    DELETE FROM tblArmyMemberList1 
    WHERE ArmyID IN (SELECT ID FROM tblArmyList1 WHERE State = -3);
    
    DELETE FROM tblArmyList1 
    WHERE State = -3;

    COMMIT TRANSACTION RMS_ARMY_CANCELARMYCREATIONINFO;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_ARMY_CHANGEARMYWARSCORE]    Script Date: 07/25/2024 12:01:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_ARMY_CHANGEARMYWARSCORE]
    @ArmyID int,
    @ScoreDiff int
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION RMS_ARMY_CHANGEARMYWARSCORE;
    
    DECLARE @WarScore int;
    SELECT @WarScore = WarScore 
    FROM tblArmyWarList1 
    WHERE ArmyID = @ArmyID 
    AND (WarState = 1 OR WarState = 3);
    
    IF @@ROWCOUNT != 0
    BEGIN
        SET @WarScore = @WarScore + @ScoreDiff;
        IF @WarScore < 0
        BEGIN
            SET @WarScore = 0;
        END
        UPDATE tblArmyWarList1 
        SET WarScore = @WarScore 
        WHERE ArmyID = @ArmyID;
    END

    COMMIT TRANSACTION RMS_ARMY_CHANGEARMYWARSCORE;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_ARMY_CHANGEARMYPASSWORD]    Script Date: 07/25/2024 12:01:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_ARMY_CHANGEARMYPASSWORD]
    @GameID varchar(14),
    @Password varchar(20),
    @bCommander tinyint,
    @bSubCommander tinyint
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION RMS_ARMY_CHANGEARMYPASSWORD;

    IF @bCommander = 1
    BEGIN
        UPDATE tblArmyList1 
        SET Password = @Password 
        WHERE Commander = @GameID;
    END

    IF @bSubCommander = 1
    BEGIN
        UPDATE tblSubArmyList1 
        SET Password = @Password 
        WHERE SubCommander = @GameID;
    END

    COMMIT TRANSACTION RMS_ARMY_CHANGEARMYPASSWORD;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_ARMY_CHANGEARMYNOTICE]    Script Date: 07/25/2024 12:01:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_ARMY_CHANGEARMYNOTICE]
    @ID int,
    @Notice varchar(166),
    @Kind tinyint
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION RMS_ARMY_CHANGEARMYNOTICE;

    IF @Kind = 1
    BEGIN
        UPDATE tblArmyList1 
        SET Notice = @Notice 
        WHERE ID = @ID;
    END
    ELSE IF @Kind = 2
    BEGIN
        UPDATE tblSubArmyList1 
        SET Notice = @Notice 
        WHERE ID = @ID;
    END

    COMMIT TRANSACTION RMS_ARMY_CHANGEARMYNOTICE;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_ARMY_CHANGESUBARMYNOTICE]    Script Date: 07/25/2024 12:01:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_ARMY_CHANGESUBARMYNOTICE]
    @ID int,
    @Notice varchar(166)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION RMS_ARMY_CHANGESUBARMYNOTICE;

    UPDATE tblSubArmyList1 
    SET Notice = @Notice 
    WHERE ID = @ID;

    COMMIT TRANSACTION RMS_ARMY_CHANGESUBARMYNOTICE;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_ARMY_CREATESUBARMY]    Script Date: 07/25/2024 12:01:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_ARMY_CREATESUBARMY]
    @ArmyID int,
    @Name varchar(10),
    @Password varchar(20),
    @SubCommander varchar(14)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION RMS_ARMY_CREATESUBARMY;

    DECLARE @RowCount int;
    SELECT @RowCount = COUNT(*) 
    FROM tblSubArmyList1 
    WHERE SubCommander = @SubCommander;

    IF @RowCount = 0
    BEGIN
        INSERT INTO tblSubArmyList1 (ArmyID, Name, SubCommander, Password, Permission, Notice)
        VALUES (@ArmyID, @Name, @SubCommander, @Password, 0, '');
        
        DECLARE @SubArmyID int;
        SELECT @SubArmyID = ID 
        FROM tblSubArmyList1 
        WHERE SubCommander = @SubCommander;

        IF @@ROWCOUNT != 0
        BEGIN
            UPDATE tblArmyMemberList1 
            SET SubArmyID = @SubArmyID 
            WHERE RegularSoldier = @SubCommander;
        END
    END

    COMMIT TRANSACTION RMS_ARMY_CREATESUBARMY;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_ARMY_INSERTSAFEITEM]    Script Date: 07/25/2024 12:01:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_ARMY_INSERTSAFEITEM] 
    @AgitNumber int, 
    @SafeIndex int,
    @ItemKind int,
    @ItemIndex int,
    @ItemCount int
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION RMS_ARMY_INSERTSAFEITEM;

    INSERT INTO tblAgitSafeList1 (AgitNumber, SafeIndex, ItemKind, ItemIndex, ItemCount) 
    VALUES (@AgitNumber, @SafeIndex, @ItemKind, @ItemIndex, @ItemCount);

    COMMIT TRANSACTION RMS_ARMY_INSERTSAFEITEM;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_ARMY_FAILEDENDWARAGREEMENT]    Script Date: 07/25/2024 12:01:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_ARMY_FAILEDENDWARAGREEMENT]
    @ArmyID1 int,
    @ArmyID2 int
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION RMS_ARMY_FAILEDENDWARAGREEMENT;

    UPDATE tblArmyWarList1 
    SET WarState = WarState + 2 
    WHERE (ArmyID = @ArmyID1 OR ArmyID = @ArmyID2) AND (WarState = 0 OR WarState = 1);

    COMMIT TRANSACTION RMS_ARMY_FAILEDENDWARAGREEMENT;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_ARMY_WRITEWARLOG]    Script Date: 07/25/2024 12:01:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_ARMY_WRITEWARLOG]
    @ArmyID1 INT,
    @ArmyID2 INT,
    @LogKind VARCHAR(220)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION RMS_ARMY_WRITEWARLOG;

    DECLARE @WarBeginTime DATETIME;
    DECLARE @WarEndTime DATETIME;
    DECLARE @WarScore1 INT;
    DECLARE @WarScore2 INT;
    DECLARE @WarKind1 INT;
    DECLARE @WarKind2 INT;
    DECLARE @WarPlace INT;
    DECLARE @RowCount1 INT;
    DECLARE @RowCount2 INT;

    -- Initialize alliance IDs
    DECLARE @TempAllianceID INT;
    DECLARE @HostArmyID1 INT = 0;
    DECLARE @AllianceArmyID11 INT = 0;
    DECLARE @AllianceArmyID12 INT = 0;
    DECLARE @AllianceArmyID13 INT = 0;
    DECLARE @AllianceArmyID14 INT = 0;
    DECLARE @HostArmyID2 INT = 0;
    DECLARE @AllianceArmyID21 INT = 0;
    DECLARE @AllianceArmyID22 INT = 0;
    DECLARE @AllianceArmyID23 INT = 0;
    DECLARE @AllianceArmyID24 INT = 0;

    -- Fetch details for ArmyID1
    SELECT @WarBeginTime = WarBeginTime, 
           @WarEndTime = WarEndTime, 
           @WarScore1 = WarScore, 
           @WarKind1 = WarKind, 
           @WarPlace = WarPlace 
    FROM tblArmyWarList1 
    WHERE ArmyID = @ArmyID1;
    SET @RowCount1 = @@ROWCOUNT;

    -- Fetch details for ArmyID2
    SELECT @WarScore2 = WarScore, 
           @WarKind2 = WarKind 
    FROM tblArmyWarList1 
    WHERE ArmyID = @ArmyID2;
    SET @RowCount2 = @@ROWCOUNT;

    -- Insert into log if both rows exist
    IF @RowCount1 != 0 AND @RowCount2 != 0
    BEGIN
        DECLARE @AllianceCount INT;
        SET @AllianceCount = 0;

        -- Fetch alliances for ArmyID1
        DECLARE ArmyAllianceList CURSOR FOR
            SELECT ArmyID 
            FROM tblArmyAllianceList1 
            WHERE AllianceID = (SELECT AllianceID FROM tblArmyAllianceList1 WHERE ArmyID = @ArmyID1) 
            ORDER BY bHost DESC;

        OPEN ArmyAllianceList;
        FETCH FROM ArmyAllianceList INTO @TempAllianceID;
        WHILE @@FETCH_STATUS = 0
        BEGIN
            IF @AllianceCount = 0
            BEGIN
                SET @HostArmyID1 = @TempAllianceID;
                SET @AllianceCount = @AllianceCount + 1;
            END
            ELSE IF @AllianceCount = 1
            BEGIN
                SET @AllianceArmyID11 = @TempAllianceID;
                SET @AllianceCount = @AllianceCount + 1;
            END
            ELSE IF @AllianceCount = 2
            BEGIN
                SET @AllianceArmyID12 = @TempAllianceID;
                SET @AllianceCount = @AllianceCount + 1;
            END
            ELSE IF @AllianceCount = 3
            BEGIN
                SET @AllianceArmyID13 = @TempAllianceID;
                SET @AllianceCount = @AllianceCount + 1;
            END
            ELSE IF @AllianceCount = 4
            BEGIN
                SET @AllianceArmyID14 = @TempAllianceID;
                SET @AllianceCount = @AllianceCount + 1;
            END
            FETCH FROM ArmyAllianceList INTO @TempAllianceID;
        END
        CLOSE ArmyAllianceList;
        DEALLOCATE ArmyAllianceList;

        -- Fetch alliances for ArmyID2
        SET @AllianceCount = 0;
        DECLARE ArmyAllianceList CURSOR FOR
            SELECT ArmyID 
            FROM tblArmyAllianceList1 
            WHERE AllianceID = (SELECT AllianceID FROM tblArmyAllianceList1 WHERE ArmyID = @ArmyID2) 
            ORDER BY bHost DESC;

        OPEN ArmyAllianceList;
        FETCH FROM ArmyAllianceList INTO @TempAllianceID;
        WHILE @@FETCH_STATUS = 0
        BEGIN
            IF @AllianceCount = 0
            BEGIN
                SET @HostArmyID2 = @TempAllianceID;
                SET @AllianceCount = @AllianceCount + 1;
            END
            ELSE IF @AllianceCount = 1
            BEGIN
                SET @AllianceArmyID21 = @TempAllianceID;
                SET @AllianceCount = @AllianceCount + 1;
            END
            ELSE IF @AllianceCount = 2
            BEGIN
                SET @AllianceArmyID22 = @TempAllianceID;
                SET @AllianceCount = @AllianceCount + 1;
            END
            ELSE IF @AllianceCount = 3
            BEGIN
                SET @AllianceArmyID23 = @TempAllianceID;
                SET @AllianceCount = @AllianceCount + 1;
            END
            ELSE IF @AllianceCount = 4
            BEGIN
                SET @AllianceArmyID24 = @TempAllianceID;
                SET @AllianceCount = @AllianceCount + 1;
            END
            FETCH FROM ArmyAllianceList INTO @TempAllianceID;
        END
        CLOSE ArmyAllianceList;
        DEALLOCATE ArmyAllianceList;

        -- Insert into log
        INSERT INTO tblArmyWarListLog1 
        ([Time], LogKind, ArmyID1, ArmyID2, WarBeginTime, WarEndTime, WarScore1, WarScore2, WarKind1, WarKind2, WarPlace, 
         HostArmyID1, AllianceArmyID11, AllianceArmyID12, AllianceArmyID13, AllianceArmyID14, 
         HostArmyID2, AllianceArmyID21, AllianceArmyID22, AllianceArmyID23, AllianceArmyID24) 
        VALUES (GETDATE(), @LogKind, @ArmyID1, @ArmyID2, @WarBeginTime, @WarEndTime, @WarScore1, @WarScore2, @WarKind1, @WarKind2, @WarPlace,
                @HostArmyID1, @AllianceArmyID11, @AllianceArmyID12, @AllianceArmyID13, @AllianceArmyID14, 
                @HostArmyID2, @AllianceArmyID21, @AllianceArmyID22, @AllianceArmyID23, @AllianceArmyID24);
    END

    COMMIT TRANSACTION RMS_ARMY_WRITEWARLOG;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_ARMY_WRITEARMYSHOPLOG]    Script Date: 07/25/2024 12:01:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_ARMY_WRITEARMYSHOPLOG]
    @ShopNumber INT,
    @LogKind VARCHAR(40)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION RMS_ARMY_WRITEARMYSHOPLOG;

    DECLARE @ArmyID INT;
    DECLARE @Tax INT;
    DECLARE @ArmyGain INT;
    DECLARE @BeginControl DATETIME;
    DECLARE @TaxChanged DATETIME;

    -- Fetch details from tblArmyShopList1
    SELECT @ArmyID = ArmyID, 
           @Tax = Tax, 
           @ArmyGain = ArmyGain, 
           @BeginControl = BeginControl, 
           @TaxChanged = TaxChanged 
    FROM tblArmyShopList1 
    WHERE ShopNumber = @ShopNumber;

    -- Insert into log if data exists
    IF @@ROWCOUNT != 0
    BEGIN
        INSERT INTO tblArmyShopListLog1 
        ([Time], LogKind, ShopNumber, ArmyID, Tax, ArmyGain, BeginControl, TaxChanged) 
        VALUES (GETDATE(), @LogKind, @ShopNumber, @ArmyID, @Tax, @ArmyGain, @BeginControl, @TaxChanged);
    END

    COMMIT TRANSACTION RMS_ARMY_WRITEARMYSHOPLOG;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_ARMY_WRITEARMYLOG]    Script Date: 07/25/2024 12:01:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_ARMY_WRITEARMYLOG]
	@ArmyID	int,
	@LogKind	varchar(40)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION RMS_ARMY_WRITEARMYLOG;

    DECLARE @ID int;
    DECLARE @Mark int;
    DECLARE @State int;
    DECLARE @Camp tinyint;
    DECLARE @Name varchar(10);
    DECLARE @Commander varchar(14);
    DECLARE @Password varchar(10);
    DECLARE @CreateTime datetime;
    DECLARE @ActivityPeriod datetime; -- Ensure this column exists in tblArmyList1

    -- Ensure correct column names and types
    SELECT @ID=ID, @Mark=Mark, @State=State, @Camp=Camp, @Name=Name, @Commander=Commander, @Password=Password, @CreateTime=CreateTime, @ActivityPeriod=ActivityPeriod
    FROM tblArmyList1 
    WHERE ID=@ArmyID;

    IF @@ROWCOUNT != 0
    BEGIN
        -- Ensure the columns in INSERT match tblArmyListLog1
        INSERT INTO tblArmyListLog1 (Time, LogKind, ID, Mark, State, Camp, Name, Commander, Password, CreateTime, ActivityPeriod)
        VALUES (GETDATE(), @LogKind, @ID, @Mark, @State, @Camp, @Name, @Commander, @Password, @CreateTime, @ActivityPeriod);
    END

    COMMIT TRANSACTION RMS_ARMY_WRITEARMYLOG;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_ARMY_WRITEARMYBASELOG]    Script Date: 07/25/2024 12:01:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_ARMY_WRITEARMYBASELOG]
    @LogKind VARCHAR(40)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION RMS_ARMY_WRITEARMYBASELOG;

    DECLARE @ArmyID INT;
    DECLARE @AgitTaxRate INT;
    DECLARE @ControlBeginDate DATETIME;

    -- Fetch details from tblArmyBase1
    SELECT TOP 1 @ArmyID = ArmyID, 
                  @AgitTaxRate = AgitTaxRate, 
                  @ControlBeginDate = ControlBeginDate 
    FROM tblArmyBase1;

    -- Insert into log if data exists
    IF @@ROWCOUNT != 0
    BEGIN
        INSERT INTO tblArmyBaseLog1 
        ([Time], LogKind, ArmyID, AgitTaxRate, ControlBeginDate) 
        VALUES (GETDATE(), @LogKind, @ArmyID, @AgitTaxRate, @ControlBeginDate);
    END

    COMMIT TRANSACTION RMS_ARMY_WRITEARMYBASELOG;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_ARMY_WRITEAGITLOG]    Script Date: 07/25/2024 12:01:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_ARMY_WRITEAGITLOG]
    @AgitNumber INT,
    @LogKind VARCHAR(40)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION RMS_ARMY_WRITEAGITLOG;

    DECLARE @ArmyID INT;
    DECLARE @RentBeginDate DATETIME;
    DECLARE @ExpirationDate DATETIME;

    -- Fetching details of the agit
    SELECT @ArmyID = ArmyID, 
           @RentBeginDate = RentBeginDate, 
           @ExpirationDate = ExpirationDate 
    FROM tblAgitList1 
    WHERE AgitNumber = @AgitNumber;

    -- Insert into log if agit exists
    IF @@ROWCOUNT != 0
    BEGIN
        INSERT INTO tblAgitListLog1 
        ([Time], LogKind, AgitNumber, ArmyID, RentBeginDate, ExpirationDate) 
        VALUES (GETDATE(), @LogKind, @AgitNumber, @ArmyID, @RentBeginDate, @ExpirationDate);
    END

    COMMIT TRANSACTION RMS_ARMY_WRITEAGITLOG;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_ARMY_UPDATESAFEMONEY]    Script Date: 07/25/2024 12:01:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_ARMY_UPDATESAFEMONEY] 
    @AgitNumber INT,
    @SafeIndex INT,
    @SafeMoney INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION RMS_ARMY_UPDATESAFEMONEY;

    IF @AgitNumber != 100
    BEGIN
        IF @SafeIndex = 1
        BEGIN
            UPDATE tblAgitList1 
            SET SafeMoney1 = @SafeMoney 
            WHERE AgitNumber = @AgitNumber;
        END
        ELSE IF @SafeIndex = 2
        BEGIN
            UPDATE tblAgitList1 
            SET SafeMoney2 = @SafeMoney 
            WHERE AgitNumber = @AgitNumber;
        END
        ELSE IF @SafeIndex = 3
        BEGIN
            UPDATE tblAgitList1 
            SET SafeMoney3 = @SafeMoney 
            WHERE AgitNumber = @AgitNumber;
        END
    END
    ELSE
    BEGIN
        IF @SafeIndex = 1
        BEGIN
            UPDATE tblArmyBase1 
            SET SafeMoney1 = @SafeMoney;
        END
        ELSE IF @SafeIndex = 2
        BEGIN
            UPDATE tblArmyBase1 
            SET SafeMoney2 = @SafeMoney;
        END
        ELSE IF @SafeIndex = 3
        BEGIN
            UPDATE tblArmyBase1 
            SET SafeMoney3 = @SafeMoney;
        END
        ELSE IF @SafeIndex = 4
        BEGIN
            UPDATE tblArmyBase1 
            SET SafeMoney4 = @SafeMoney;
        END
        ELSE IF @SafeIndex = 5
        BEGIN
            UPDATE tblArmyBase1 
            SET SafeMoney5 = @SafeMoney;
        END
        ELSE IF @SafeIndex = 6
        BEGIN
            UPDATE tblArmyBase1 
            SET SafeMoney6 = @SafeMoney;
        END
        ELSE IF @SafeIndex = 7
        BEGIN
            UPDATE tblArmyBase1 
            SET SafeMoney7 = @SafeMoney;
        END
        ELSE IF @SafeIndex = 8
        BEGIN
            UPDATE tblArmyBase1 
            SET SafeMoney8 = @SafeMoney;
        END
        ELSE IF @SafeIndex = 9
        BEGIN
            UPDATE tblArmyBase1 
            SET SafeMoney9 = @SafeMoney;
        END
        ELSE IF @SafeIndex = 10
        BEGIN
            UPDATE tblArmyBase1 
            SET SafeMoney10 = @SafeMoney;
        END
    END

    COMMIT TRANSACTION RMS_ARMY_UPDATESAFEMONEY;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_ARMY_UPDATESAFEITEM]    Script Date: 07/25/2024 12:01:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_ARMY_UPDATESAFEITEM] 
    @AgitNumber INT, 
    @SafeIndex INT,
    @ItemCount INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION RMS_ARMY_UPDATESAFEITEM;

    UPDATE tblAgitSafeList1 
    SET ItemCount = @ItemCount 
    WHERE AgitNumber = @AgitNumber AND SafeIndex = @SafeIndex;

    COMMIT TRANSACTION RMS_ARMY_UPDATESAFEITEM;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_ARMY_SETARMYSHOPTEX]    Script Date: 07/25/2024 12:01:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_ARMY_SETARMYSHOPTEX]
    @ShopNumber INT,
    @Tax INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION RMS_ARMY_SETARMYSHOPTEX;

    IF @Tax >= 0 AND @Tax <= 100
    BEGIN
        UPDATE tblArmyShopList1 
        SET Tax = @Tax, TaxChanged = GETDATE()  
        WHERE ShopNumber = @ShopNumber;
    END

    COMMIT TRANSACTION RMS_ARMY_SETARMYSHOPTEX;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_ARMY_REMOVEREJOINSANCTION]    Script Date: 07/25/2024 12:01:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_ARMY_REMOVEREJOINSANCTION]
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION RMS_ARMY_REMOVEREJOINSANCTION;

    DELETE FROM tblArmyJoinSanctionList1 
    WHERE SanctionTime < GETDATE();

    IF @@ERROR <> 0
    BEGIN
        ROLLBACK TRANSACTION RMS_ARMY_REMOVEREJOINSANCTION;
        RETURN;
    END

    COMMIT TRANSACTION RMS_ARMY_REMOVEREJOINSANCTION;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_ARMY_REMOVEARMYINITMEMBER]    Script Date: 07/25/2024 12:01:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_ARMY_REMOVEARMYINITMEMBER]
    @GameID VARCHAR(14)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION RMS_ARMY_REMOVEARMYINITMEMBER;

    DELETE FROM tblArmyMemberList1 
    WHERE RegularSoldier = @GameID;

    IF @@ERROR <> 0
    BEGIN
        ROLLBACK TRANSACTION RMS_ARMY_REMOVEARMYINITMEMBER;
        RETURN;
    END

    COMMIT TRANSACTION RMS_ARMY_REMOVEARMYINITMEMBER;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_BEGINUSESHOPTIME]    Script Date: 07/25/2024 12:01:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RMS_BEGINUSESHOPTIME] 
    @RegNumber varchar(12), 
    @ConnTime datetime, 
    @IPAddress varchar(15), 
    @ServerNumber int 
AS 
BEGIN 
    SET NOCOUNT ON; 

    BEGIN TRANSACTION RMS_BEGINUSESHOPTIME; 

    DECLARE @ShopTimeLimit int; 
    SET @ShopTimeLimit = -1; 

    SELECT @ShopTimeLimit = TimeLimit 
    FROM tblShop 
    WHERE RegNumber = @RegNumber; 

    IF @ShopTimeLimit != -1 
    BEGIN 
        INSERT INTO tblShopTimeUseLog 
            (RegNumber, ShopTimeLimit, ConnTime, IPAddress, ServerNumber) 
        VALUES 
            (@RegNumber, @ShopTimeLimit, @ConnTime, @IPAddress, @ServerNumber); 
    END 

    COMMIT TRANSACTION RMS_BEGINUSESHOPTIME; 
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_ARMY_DOARMYALLIANCE]    Script Date: 07/25/2024 12:01:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_ARMY_DOARMYALLIANCE] 
    @HostArmyID int, 
    @ArmyID int
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION RMS_ARMY_DOARMYALLIANCE;

    DECLARE @RowCount int;
    DECLARE @bHost bit;
    DECLARE @AllianceID int;
    DECLARE @AllianceCount int;

    -- Check if the army is already in an alliance
    SELECT @RowCount = COUNT(*) FROM tblArmyAllianceList1 WHERE ArmyID = @ArmyID;
    IF @RowCount = 0
    BEGIN
        -- Retrieve the host alliance details
        SELECT @AllianceID = AllianceID, @bHost = bHost FROM tblArmyAllianceList1 WHERE ArmyID = @HostArmyID;
        IF @AllianceID > 0 AND @bHost = 1
        BEGIN
            SELECT @AllianceCount = COUNT(*) FROM tblArmyAllianceList1 WHERE AllianceID = @AllianceID;
            IF @AllianceCount < 5
            BEGIN
                INSERT INTO tblArmyAllianceList1 (AllianceID, bHost, ArmyID) VALUES (@AllianceID, 0, @ArmyID);
            END
        END
        ELSE IF @AllianceID = 0
        BEGIN
            SELECT @AllianceID = ISNULL(MAX(AllianceID), 0) + 1 FROM tblArmyAllianceList1;
            INSERT INTO tblArmyAllianceList1 (AllianceID, bHost, ArmyID) VALUES (@AllianceID, 1, @HostArmyID);
            INSERT INTO tblArmyAllianceList1 (AllianceID, bHost, ArmyID) VALUES (@AllianceID, 0, @ArmyID);
        END
    END

    COMMIT TRANSACTION RMS_ARMY_DOARMYALLIANCE;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_ARMY_DELETESAFEITEM]    Script Date: 07/25/2024 12:01:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_ARMY_DELETESAFEITEM]
    @AgitNumber int,
    @SafeIndex int
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION RMS_ARMY_DELETESAFEITEM;

    DELETE FROM tblAgitSafeList1 WHERE AgitNumber = @AgitNumber AND SafeIndex = @SafeIndex;

    COMMIT TRANSACTION RMS_ARMY_DELETESAFEITEM;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_DECREASEBILLFREETIMER]    Script Date: 07/25/2024 12:01:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_DECREASEBILLFREETIMER]
    @BillID varchar(14),
    @FreeTimerDiff int
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION DECREASEBILLFREETIMER;

    -- Decrease FreeTimer
    UPDATE tblBillID 
    SET FreeTimer = FreeTimer - @FreeTimerDiff 
    WHERE BillID = @BillID;

    -- Ensure FreeTimer does not go below 0
    UPDATE tblBillID 
    SET FreeTimer = 0 
    WHERE BillID = @BillID AND FreeTimer < 0;

    COMMIT TRANSACTION DECREASEBILLFREETIMER;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_DAILYLOG]    Script Date: 07/25/2024 12:01:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RMS_DAILYLOG]  
AS  
BEGIN  
    SET NOCOUNT ON;  
  
    DECLARE @date DATETIME;  
    SET @date = CONVERT(DATETIME, CONVERT(VARCHAR(30), GETDATE() - 1, 102));  
  
    -- Insert data into tbldailyconnectlog1
    DECLARE @tableName NVARCHAR(128);  
    SET @tableName = 'tblUserLog1_' + CONVERT(VARCHAR(6), GETDATE(), 112);  
  
    DECLARE @sql NVARCHAR(MAX);  
  
    -- First Insert
    SET @sql = 'INSERT INTO tbldailyconnectlog1
                SELECT ''RM'', ''KR'', ''OP'', connkind, @date, 1, COUNT(*)
                FROM ' + @tableName + '
                WHERE logintime >= @date AND logintime < DATEADD(day, 1, @date) AND connkind >= 71 AND connkind <= 93
                GROUP BY connkind
                ORDER BY connkind;';
    EXEC sp_executesql @sql, N'@date DATETIME', @date;
  
    -- Second Insert
    SET @sql = 'INSERT INTO tbldailyconnectlog1
                SELECT ''RM'', ''KR'', ''IP'', CAST(connfrom AS int), @date, 1, COUNT(*)
                FROM ' + @tableName + '
                WHERE logintime >= @date AND logintime < DATEADD(day, 1, @date) AND connkind = 44 AND CAST(connfrom AS int) >= 1 AND CAST(connfrom AS int) <= 18
                GROUP BY connfrom
                ORDER BY CAST(connfrom AS int);';
    EXEC sp_executesql @sql, N'@date DATETIME', @date;

    -- Third Insert
    SET @sql = 'INSERT INTO tbldailyconnectlog1
                SELECT ''RM'', ''KR'', ''IP'', IPAddress, @date, 1, COUNT(*)
                FROM ' + @tableName + '
                WHERE logintime >= @date AND logintime < DATEADD(day, 1, @date)
                GROUP BY IPAddress
                ORDER BY IPAddress;';
    EXEC sp_executesql @sql, N'@date DATETIME', @date;
  
    -- Update statements
    UPDATE tbldailyconnectlog1   
    SET Column6 = 'IP'   
    WHERE Column1 = '78' AND Column5 = @date;  
  
    UPDATE tbldailyconnectlog1   
    SET Column7 = 'OD'   
    WHERE Column2 IN ('80', '81', '89', '90') AND Column5 = @date;  
  
    UPDATE tbldailyconnectlog1   
    SET Column8 = 'OP'   
    WHERE Column3 = '18' AND Column5 = @date;  
END;
GO
/****** Object:  StoredProcedure [dbo].[RMS_DECREASESHOPTIMELIMIT]    Script Date: 07/25/2024 12:01:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_DECREASESHOPTIMELIMIT]
    @RegNumber varchar(12),
    @TimeLimitDiff int
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION DECREASESHOPTIMELIMIT;

    UPDATE tblShop 
    SET TimeLimit = TimeLimit - @TimeLimitDiff 
    WHERE RegNumber = @RegNumber;

    UPDATE tblShop 
    SET TimeLimit = 0 
    WHERE RegNumber = @RegNumber AND TimeLimit < 0;

    COMMIT TRANSACTION DECREASESHOPTIMELIMIT;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_DECREASESHOPTIME]    Script Date: 07/25/2024 12:01:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_DECREASESHOPTIME]
    @RegNumber varchar(12),
    @ConnTime datetime,
    @BillID varchar(14),
    @UseTime int,
    @TimeDiff int
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION RMS_DECREASESHOPTIME;

    DECLARE @ShopTimeLimit int;
    SET @ShopTimeLimit = -1;

    SELECT @ShopTimeLimit = TimeLimit 
    FROM tblShop 
    WHERE RegNumber = @RegNumber;

    IF @ShopTimeLimit >= 0
    BEGIN
        DECLARE @RealTimeDiff int;
        SET @RealTimeDiff = @TimeDiff;

        IF @RealTimeDiff > @ShopTimeLimit
        BEGIN
            SET @RealTimeDiff = @ShopTimeLimit;
        END

        IF @RealTimeDiff > 0
        BEGIN
            UPDATE tblShop 
            SET TimeLimit = TimeLimit - @RealTimeDiff 
            WHERE RegNumber = @RegNumber AND TimeLimit >= @RealTimeDiff;

            UPDATE tblShop 
            SET TimeLimit = 0 
            WHERE RegNumber = @RegNumber AND TimeLimit < 0;
        END

        UPDATE tblShopTimeUseLog 
        SET UseTime = UseTime + @UseTime, TimeDiff = TimeDiff + @RealTimeDiff 
        WHERE RegNumber = @RegNumber AND ConnTime = @ConnTime AND BillID = @BillID;
    END

    COMMIT TRANSACTION RMS_DECREASESHOPTIME;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_ELECTCHAMPIONANDCLEANUPBATTLEMATCH]    Script Date: 07/25/2024 12:01:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_ELECTCHAMPIONANDCLEANUPBATTLEMATCH]
    @AvgLevel1 INT,
    @AvgLevel2 INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Error INT, @TotalScore1 INT, @TotalScore2 INT, @SmashedTowerCount1 INT, @SmashedTowerCount2 INT;
    DECLARE @Temp INT, @WonTeamID INT;
    SET @Error = 0;
    SET @SmashedTowerCount1 = 0;
    SET @SmashedTowerCount2 = 0;

    BEGIN TRANSACTION RMS_ELECTANDCLEANUP;

    -- Calculate total scores and smashed tower counts for both teams
    SELECT @TotalScore1 = Score, @Temp = SmashedTower FROM tblCurrentBattleMatchInfo WITH (TABLOCKX) WHERE TeamID = 1;
    IF @@ROWCOUNT != 0 AND @Error != 1
    BEGIN
        SET @SmashedTowerCount1 = @SmashedTowerCount1 + 
            CASE WHEN @Temp & 1 != 0 THEN 1 ELSE 0 END +
            CASE WHEN @Temp & 2 != 0 THEN 1 ELSE 0 END +
            CASE WHEN @Temp & 4 != 0 THEN 1 ELSE 0 END +
            CASE WHEN @Temp & 8 != 0 THEN 1 ELSE 0 END;
        
        IF @SmashedTowerCount1 >= 4 SET @SmashedTowerCount1 = 5;
    END
    ELSE SET @Error = 1;

    SELECT @TotalScore2 = Score, @Temp = SmashedTower FROM tblCurrentBattleMatchInfo WHERE TeamID = 2;
    IF @@ROWCOUNT != 0 AND @Error != 1
    BEGIN
        SET @SmashedTowerCount2 = @SmashedTowerCount2 + 
            CASE WHEN @Temp & 1 != 0 THEN 1 ELSE 0 END +
            CASE WHEN @Temp & 2 != 0 THEN 1 ELSE 0 END +
            CASE WHEN @Temp & 4 != 0 THEN 1 ELSE 0 END +
            CASE WHEN @Temp & 8 != 0 THEN 1 ELSE 0 END;
        
        IF @SmashedTowerCount2 >= 4 SET @SmashedTowerCount2 = 5;
    END
    ELSE SET @Error = 1;

    -- Determine the winning team
    IF @Error = 0
    BEGIN
        SET @TotalScore1 = @TotalScore1 * (10 + @SmashedTowerCount2 * 2) / 10;
        SET @TotalScore2 = @TotalScore2 * (10 + @SmashedTowerCount1 * 2) / 10;

        IF @TotalScore1 > @TotalScore2 SET @WonTeamID = 1;
        ELSE IF @TotalScore2 > @TotalScore1 SET @WonTeamID = 2;
        ELSE
        BEGIN
            -- Determine winner by average level if scores are tied
            IF @AvgLevel1 > @AvgLevel2 SET @WonTeamID = 1;
            ELSE IF @AvgLevel2 > @AvgLevel1 SET @WonTeamID = 2;
            ELSE SET @WonTeamID = 0;
        END

        DECLARE @GameID VARCHAR(14), @BillID VARCHAR(14), @ServerIndex INT, @ScoreCount INT;
        IF @WonTeamID = 1 OR @WonTeamID = 2
        BEGIN
            DECLARE User_Cursor CURSOR FOR
            SELECT GameID, BillID, ServerIndex FROM tblCurrentBattleMatchEntry WHERE TeamID = @WonTeamID AND JoinState > 1;
            OPEN User_Cursor;
            FETCH NEXT FROM User_Cursor INTO @GameID, @BillID, @ServerIndex;

            WHILE @@FETCH_STATUS = 0 AND @Error = 0
            BEGIN
                SELECT @ScoreCount = COUNT(*) FROM tblBattleMatchUserPoint WHERE GameID = @GameID AND BillID = @BillID AND ServerIndex = @ServerIndex;
                SET @Error = @@ERROR;

                IF @Error = 0
                BEGIN
                    IF @ScoreCount = 0
                    BEGIN
                        INSERT INTO tblBattleMatchUserPoint (ServerIndex, GameID, BillID, UsablePoint, TotalPoint)
                        VALUES (@ServerIndex, @GameID, @BillID, 1, 1);
                        SET @Error = @@ERROR;
                    END
                    ELSE
                    BEGIN
                        UPDATE tblBattleMatchUserPoint
                        SET UsablePoint = UsablePoint + 1, TotalPoint = TotalPoint + 1
                        WHERE ServerIndex = @ServerIndex AND GameID = @GameID AND BillID = @BillID;
                        SET @Error = @@ERROR;
                    END
                    FETCH NEXT FROM User_Cursor INTO @GameID, @BillID, @ServerIndex;
                END
            END

            CLOSE User_Cursor;
            DEALLOCATE User_Cursor;
        END
    END

    -- Update battle match info and cleanup
    IF @Error = 0
    BEGIN
        IF @WonTeamID = 1
        BEGIN
            UPDATE tblCurrentBattleMatchInfo SET TotalScore = @TotalScore1, AvgMemberLevel = @AvgLevel1, bWin = 1 WHERE TeamID = 1;
            SET @Error = @@ERROR;
        END
        ELSE
        BEGIN
            UPDATE tblCurrentBattleMatchInfo SET TotalScore = @TotalScore1, AvgMemberLevel = @AvgLevel1, bWin = 0 WHERE TeamID = 1;
            SET @Error = @@ERROR;
        END
    END

    IF @Error = 0
    BEGIN
        IF @WonTeamID = 2
        BEGIN
            UPDATE tblCurrentBattleMatchInfo SET TotalScore = @TotalScore2, AvgMemberLevel = @AvgLevel2, bWin = 1 WHERE TeamID = 2;
            SET @Error = @@ERROR;
        END
        ELSE
        BEGIN
            UPDATE tblCurrentBattleMatchInfo SET TotalScore = @TotalScore2, AvgMemberLevel = @AvgLevel2, bWin = 0 WHERE TeamID = 2;
            SET @Error = @@ERROR;
        END
    END

    IF @Error = 0
    BEGIN
        DELETE FROM tblCurrentBattleMatchInfo;
        SET @Error = @@ERROR;
    END

    IF @Error = 0
    BEGIN
        DELETE FROM tblCurrentBattleMatchEntry;
        SET @Error = @@ERROR;
    END

    -- Commit or rollback transaction based on error
    IF @Error = 0
    BEGIN
        COMMIT TRANSACTION RMS_ELECTANDCLEANUP;
    END
    ELSE
    BEGIN
        ROLLBACK TRANSACTION RMS_ELECTANDCLEANUP;
    END
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_ELECTCHAMPIONANDCLEANUPBATTLEARENA]    Script Date: 07/25/2024 12:01:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_ELECTCHAMPIONANDCLEANUPBATTLEARENA]

@Time datetime,
@Today datetime

AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @GameID varchar(14),
            @BillID varchar(14),
            @ServerIndex int,
            @TodaySendItemCount int,
            @Error int,
            @ScoreCount int,
            @Win int,
            @Lose int,
            @Score int;

    SET @TodaySendItemCount = 1;
    SET @Error = 0;

    BEGIN TRANSACTION;

    -- Elect the champion
    SELECT TOP 1 
        @GameID = GameID, 
        @BillID = BillID, 
        @ServerIndex = ServerIndex 
    FROM tblCurrentBattleArenaScore 
    WHERE Win > 0 AND NormalEnd = 1 
    ORDER BY Win DESC, EndLevel DESC, SIGN(EndExperience), EndExperience DESC;

    IF @@ROWCOUNT > 0
    BEGIN
        SELECT @TodaySendItemCount = COUNT(*) 
        FROM tblBattleArenaChampionLog 
        WHERE GameID = @GameID AND BillID = @BillID AND Time >= @Today AND Time < DATEADD(day, 1, @Today) AND SendItem = 1;

        IF @Error = 0
        BEGIN
            IF @TodaySendItemCount > 0
            BEGIN
                INSERT INTO tblBattleArenaChampionLog (GameID, BillID, ServerIndex, Time) 
                VALUES (@GameID, @BillID, @ServerIndex, @Time);
                SET @Error = @@ERROR;
            END
            ELSE
            BEGIN
                INSERT INTO tblBattleArenaChampionLog (GameID, BillID, ServerIndex, Time, SendItem) 
                VALUES (@GameID, @BillID, @ServerIndex, @Time, 1);
                SET @Error = @@ERROR;
            END
        END
    END

    -- Cursor to update scores
    DECLARE user_cursor CURSOR FOR
    SELECT GameID, BillID, ServerIndex, Win, Lose, Score 
    FROM tblCurrentBattleArenaScore 
    WHERE NormalEnd = 1;

    OPEN user_cursor;

    FETCH NEXT FROM user_cursor INTO @GameID, @BillID, @ServerIndex, @Win, @Lose, @Score;

    WHILE @@FETCH_STATUS = 0 AND @Error = 0
    BEGIN
        SELECT @ScoreCount = COUNT(*) 
        FROM tblBattleArenaScore 
        WHERE GameID = @GameID AND BillID = @BillID AND ServerIndex = @ServerIndex;

        IF @Error = 0
        BEGIN
            IF @ScoreCount = 0
            BEGIN
                INSERT INTO tblBattleArenaScore (GameID, BillID, ServerIndex, Win, Lose, Score) 
                VALUES (@GameID, @BillID, @ServerIndex, @Win, @Lose, @Score);
                SET @Error = @@ERROR;
            END
            ELSE
            BEGIN
                UPDATE tblBattleArenaScore 
                SET Win = Win + @Win, Lose = Lose + @Lose, Score = Score + @Score 
                WHERE BillID = @BillID AND GameID = @GameID AND ServerIndex = @ServerIndex;
                SET @Error = @@ERROR;
            END
        END

        FETCH NEXT FROM user_cursor INTO @GameID, @BillID, @ServerIndex, @Win, @Lose, @Score;
    END

    CLOSE user_cursor;
    DEALLOCATE user_cursor;

    -- Cleanup
    IF @Error = 0
    BEGIN
        DELETE FROM tblCurrentBattleArenaScore;
        SET @Error = @@ERROR;
    END

    IF @Error = 0
    BEGIN
        DELETE FROM tblBattleArenaPay WHERE Used = 0;
        SET @Error = @@ERROR;
    END

    IF @Error = 0
    BEGIN
        COMMIT TRANSACTION;
    END
    ELSE
    BEGIN
        ROLLBACK TRANSACTION;
    END
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_SETBATTLEZONEPAY]    Script Date: 07/25/2024 12:01:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_SETBATTLEZONEPAY]
    @GameID varchar(14),
    @BillId varchar(14),
    @PayKind int
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION;

    -- Set battle zone pay
    DELETE FROM tblBattleZonePay1 WHERE GameID = @GameID AND BillId = @BillID;
    INSERT INTO tblBattleZonePay1 (GameID, BillID, PayKind)
    VALUES (@GameID, @BillID, @PayKind);

    COMMIT TRANSACTION;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_SETBATTLEMATCHMEMBERCOUNT]    Script Date: 07/25/2024 12:01:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_SETBATTLEMATCHMEMBERCOUNT]
    @TeamID int,
    @MemberCount int
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION RMS_SETBATTLEMATCHMEMBERCOUNT;

    -- Update member count
    UPDATE tblCurrentBattleMatchInfo
    SET MemberCount = @MemberCount
    WHERE TeamID = @TeamID;

    UPDATE RMBattleMatch.dbo.tblCurrentBattleMatchInfo
    SET MemberCount = @MemberCount
    WHERE TeamID = @TeamID;

    COMMIT TRANSACTION RMS_SETBATTLEMATCHMEMBERCOUNT;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_SETBATTLEMATCHENTRY]    Script Date: 07/25/2024 12:01:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RMS_SETBATTLEMATCHENTRY]
    @ServerIndex int,
    @GameID varchar(14),
    @BillID varchar(14),
    @JoinState int
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION RMS_SETBATTLEMATCHENTRY;

    IF @JoinState = 1
    BEGIN
        UPDATE tblCurrentBattleMatchEntry
        SET JoinState = @JoinState, StartTime = GETDATE(), EndTime = DATEADD(mi, 90, GETDATE())
        WHERE ServerIndex = @ServerIndex AND GameID = @GameID AND BillID = @BillID;
    END
    ELSE
    BEGIN
        UPDATE tblCurrentBattleMatchEntry
        SET JoinState = @JoinState
        WHERE ServerIndex = @ServerIndex AND GameID = @GameID AND BillID = @BillID;
    END

    COMMIT TRANSACTION RMS_SETBATTLEMATCHENTRY;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_SETBATTLEARENAPAY]    Script Date: 07/25/2024 12:01:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RMS_SETBATTLEARENAPAY]
    @GameID      VARCHAR(14),
    @BillId      VARCHAR(14),
    @ServerIndex INT,
    @PayKind     INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION;

    DELETE FROM tblBattleArenaPay
    WHERE GameID = @GameID AND BillID = @BillId AND ServerIndex = @ServerIndex;

    DELETE FROM tblBattleArenaPayLog
    WHERE GameID = @GameID AND BillID = @BillId AND ServerIndex = @ServerIndex;

    INSERT INTO tblBattleArenaPay (GameID, BillID, ServerIndex, PayKind)
    VALUES (@GameID, @BillId, @ServerIndex, @PayKind);

    INSERT INTO tblBattleArenaPayLog (GameID, BillID, ServerIndex, PayKind)
    VALUES (@GameID, @BillId, @ServerIndex, @PayKind);

    COMMIT TRANSACTION;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_SHOP_CHANGESPECIALITEM]    Script Date: 07/25/2024 12:01:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RMS_SHOP_CHANGESPECIALITEM]
    @ShopNumber INT,
    @ItemKind INT,
    @ItemIndex INT,
    @ItemDurability INT,
    @ItemCount INT,
    @Price INT,
    @InstantItem INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION;

    DECLARE @Error INT = 0;
    DECLARE @bExist INT;

    IF @ItemKind > 0 AND @ItemIndex > 0 AND @ItemDurability BETWEEN -1 AND 4 AND @ItemCount >= -1 AND @Price > 0 AND (@InstantItem = 0 OR @InstantItem = 1)
    BEGIN
        SELECT @bExist = COUNT(*)
        FROM RedMoon.dbo.tblSpecialItemShop1
        WHERE ShopNumber = @ShopNumber AND ItemKind = @ItemKind AND ItemIndex = @ItemIndex AND ItemDurability = @ItemDurability;

        SET @Error = @@ERROR;

        IF @Error = 0
        BEGIN
            IF @bExist = 0
            BEGIN
                INSERT INTO RedMoon.dbo.tblSpecialItemShop1 (ShopNumber, ItemKind, ItemIndex, ItemDurability, ItemCount, Price, InstantItem)
                VALUES (@ShopNumber, @ItemKind, @ItemIndex, @ItemDurability, @ItemCount, @Price, @InstantItem);
                SET @Error = @@ERROR;
            END
            ELSE IF @ItemCount = -1
            BEGIN
                DELETE FROM RedMoon.dbo.tblSpecialItemShop1
                WHERE ShopNumber = @ShopNumber AND ItemKind = @ItemKind AND ItemIndex = @ItemIndex AND ItemDurability = @ItemDurability;
                SET @Error = @@ERROR;
            END
            ELSE
            BEGIN
                UPDATE RedMoon.dbo.tblSpecialItemShop1
                SET ItemCount = @ItemCount, Price = @Price, InstantItem = @InstantItem
                WHERE ShopNumber = @ShopNumber AND ItemKind = @ItemKind AND ItemIndex = @ItemIndex AND ItemDurability = @ItemDurability;
                SET @Error = @@ERROR;
            END
        END
    END
    ELSE
    BEGIN
        SET @Error = 1;
    END

    IF @Error = 0
    BEGIN
        COMMIT TRANSACTION;
    END
    ELSE
    BEGIN
        ROLLBACK TRANSACTION;
    END
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_SHOP_BUYSPECIALITEM]    Script Date: 07/25/2024 12:01:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_SHOP_BUYSPECIALITEM]
    @ShopNumber INT,
    @WindowKind INT,
    @WindowIndex INT,
    @ItemKind INT,
    @ItemIndex INT,
    @ItemDurability INT,
    @ItemCount INT,
    @GameID VARCHAR(14)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION;

    DECLARE @Error INT = 0;
    DECLARE @Price INT;
    DECLARE @ShopItemCount INT;

    SELECT @Price = Price, @ShopItemCount = ItemCount
    FROM tblSpecialItemShop1
    WHERE ShopNumber = @ShopNumber AND ItemKind = @ItemKind AND ItemIndex = @ItemIndex AND ItemDurability = @ItemDurability;

    IF @@ROWCOUNT = 0 OR @Error != 0
    BEGIN
        SET @Error = 1;
    END
    ELSE
    BEGIN
        IF @ItemCount > @ShopItemCount
        BEGIN
            SET @ItemCount = @ShopItemCount;
        END
        SET @Price = @Price * @ItemCount;
    END

    IF @Error = 0
    BEGIN
        DECLARE @RowCount INT;
        SELECT @RowCount = COUNT(*)
        FROM tblSpecialItem1
        WHERE GameID = @GameID AND Position = 1 AND (WindowKind = 1 OR WindowKind = 3) AND ItemKind = 6 AND ItemIndex = 200;

        IF @Error != 0 OR @Price > @RowCount
        BEGIN
            SET @Error = 1;
        END
    END

    IF @Error = 0
    BEGIN
        DECLARE @SQLStatement VARCHAR(1024);
        SET @SQLStatement = 'DELETE tblSpecialItem1 WHERE ID IN (SELECT TOP ' + CONVERT(VARCHAR, @Price) + ' ID FROM tblSpecialItem1 WHERE GameID = ''' + @GameID + ''' AND Position = 1 AND (WindowKind = 1 OR WindowKind = 3) AND ItemKind = 6 AND ItemIndex = 200)';
        EXEC (@SQLStatement);
        SET @Error = @@ERROR;
    END

    IF @Error = 0
    BEGIN
        DECLARE @ItemCountLimit INT;
        SET @ItemCountLimit = 0;
        SELECT @ItemCountLimit = ItemCountLimit
        FROM tblSpecialItemLimit1
        WHERE ItemKind = 6 AND ItemIndex = 200;

        IF @ItemCountLimit > @Price
        BEGIN
            UPDATE tblSpecialItemLimit1
            SET ItemCountLimit = @ItemCountLimit - @Price
            WHERE ItemKind = 6 AND ItemIndex = 200;
        END
        ELSE
        BEGIN
            UPDATE tblSpecialItemLimit1
            SET ItemCountLimit = 0
            WHERE ItemKind = 6 AND ItemIndex = 200;
        END
        SET @Error = @@ERROR;
    END

    IF @Error = 0 AND @ShopItemCount < 10000
    BEGIN
        UPDATE tblSpecialItemShop1
        SET ItemCount = ItemCount - @ItemCount
        WHERE ShopNumber = @ShopNumber AND ItemKind = @ItemKind AND ItemIndex = @ItemIndex AND ItemDurability = @ItemDurability AND ItemCount >= @ItemCount;
    END

    IF @Error = 0
    BEGIN
        WHILE @ItemCount > 0 AND @Error = 0
        BEGIN
            INSERT INTO tblSpecialItem1 (ItemKind, ItemIndex, ItemDurability, Position, GameID, WindowKind, WindowIndex, Map, X, Y, TileKind)
            VALUES (@ItemKind, @ItemIndex, @ItemDurability, 1, @GameID, @WindowKind, @WindowIndex, 1, 100, 100, 0);
            SET @Error = @@ERROR;
            SET @ItemCount = @ItemCount - 1;
        END
    END

    IF @Error = 0
    BEGIN
        DECLARE @LogKind VARCHAR(10);
        SET @LogKind = 'BuyItem';

        INSERT INTO tblSpecialItemShopLog1 (GameID, LogKind, ShopNumber, ItemKind, ItemIndex, ItemDurability, ItemCount, TotalItemCost)
        VALUES (@GameID, @LogKind, @ShopNumber, @ItemKind, @ItemIndex, @ItemDurability, @ItemCount, @Price);
        SET @Error = @@ERROR;
    END

    IF @Error = 0
    BEGIN
        COMMIT TRANSACTION;
    END
    ELSE
    BEGIN
        ROLLBACK TRANSACTION;
    END
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_SHOP_SELLSPECIALITEM]    Script Date: 07/25/2024 12:01:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RMS_SHOP_SELLSPECIALITEM]
    @ShopNumber INT,
    @FromWindowKind INT,
    @FromWindowIndex INT,
    @ItemKind INT,
    @ItemIndex INT,
    @ItemDurability INT,
    @ItemCount INT,
    @ToWindowKind INT,
    @ToWindowIndex INT,
    @GameID VARCHAR(14)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION;

    DECLARE @Error INT = 0;
    DECLARE @Price INT;
    DECLARE @ShopItemCount INT;
    DECLARE @PaymentItemKind INT;
    DECLARE @PaymentItemIndex INT;

    SELECT @Price = Price, @ShopItemCount = ItemCount
    FROM tblSpecialItemShop1
    WHERE ShopNumber = @ShopNumber AND ItemKind = @ItemKind AND ItemIndex = @ItemIndex AND ItemDurability = @ItemDurability;

    IF @@ROWCOUNT = 0 OR @Error != 0
    BEGIN
        SET @Error = 1;
    END
    ELSE
    BEGIN
        IF @Price > 1
        BEGIN
            SET @Price = CAST(ROUND((@Price / 4.0 * @ItemCount), 0) AS INT);
        END
    END

    IF @ShopNumber = 35
    BEGIN
        SET @PaymentItemKind = 6;
        SET @PaymentItemIndex = 200;
    END
    ELSE
    BEGIN
        SET @PaymentItemKind = 6;
        SET @PaymentItemIndex = 198;
    END

    IF @Error = 0 AND @ItemKind = 6
    BEGIN
        DECLARE @RowCount INT;
        SELECT @RowCount = COUNT(*)
        FROM tblSpecialItem1
        WHERE GameID = @GameID AND Position = 1 AND WindowKind = @FromWindowKind AND WindowIndex = @FromWindowIndex AND ItemKind = @ItemKind AND ItemIndex = @ItemIndex AND ItemDurability = @ItemDurability;

        IF @Error != 0 OR @ItemCount > @RowCount
        BEGIN
            SET @Error = 1;
        END
    END

    IF @Error = 0 AND @ItemKind = 6
    BEGIN
        DECLARE @SQLStatement VARCHAR(1024);
        SET @SQLStatement = 'DELETE tblSpecialItem1 WHERE ID IN (SELECT TOP ' + CONVERT(VARCHAR, @ItemCount) + ' ID FROM tblSpecialItem1 WHERE GameID = ''' + @GameID + ''' AND Position = 1 AND WindowKind = ' + CONVERT(VARCHAR, @FromWindowKind) + ' AND WindowIndex = ' + CONVERT(VARCHAR, @FromWindowIndex) + ' AND ItemKind = ' + CONVERT(VARCHAR, @ItemKind) + ' AND ItemIndex = ' + CONVERT(VARCHAR, @ItemIndex) + ' AND ItemDurability = ' + CONVERT(VARCHAR, @ItemDurability) + ')';
        EXEC (@SQLStatement);
        SET @Error = @@ERROR;
    END

    IF @Error = 0 AND @ShopItemCount >= 0
    BEGIN
        UPDATE tblSpecialItemShop1
        SET ItemCount = ItemCount + @ItemCount
        WHERE ShopNumber = @ShopNumber AND ItemKind = @ItemKind AND ItemIndex = @ItemIndex AND ItemDurability = @ItemDurability AND ItemCount < 10000;
    END

    IF @Error = 0
    BEGIN
        WHILE @Price > 0 AND @Error = 0
        BEGIN
            INSERT INTO tblSpecialItem1 (ItemKind, ItemIndex, ItemDurability, Position, GameID, WindowKind, WindowIndex, Map, X, Y, TileKind)
            VALUES (@PaymentItemKind, @PaymentItemIndex, 4, 1, @GameID, @ToWindowKind, @ToWindowIndex, 1, 100, 100, 0);
            SET @Error = @@ERROR;
            SET @Price = @Price - 1;
        END
    END

    IF @Error = 0
    BEGIN
        COMMIT TRANSACTION;
    END
    ELSE
    BEGIN
        ROLLBACK TRANSACTION;
    END
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_REMOVEALLMAPITEM]    Script Date: 07/25/2024 12:01:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_REMOVEALLMAPITEM]
    @Position int,
    @Map int
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION;

    DELETE FROM tblSpecialItem1 
    WHERE Position = @Position 
      AND Map = @Map 
      AND ItemIndex NOT IN (69, 70, 71, 72);

    -- Uncomment the following lines if you want to log the deletion
    -- IF @@ROWCOUNT > 0
    -- BEGIN
    --     INSERT INTO tblSpecialItemLog1 (LogKind, Position, Map, LogItemCount) 
    --     VALUES (100, @Position, @Map, @@ROWCOUNT);
    -- END

    COMMIT TRANSACTION;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_DECREASESPECIALITEMDURABILITY]    Script Date: 07/25/2024 12:01:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_DECREASESPECIALITEMDURABILITY]
    @ItemKind int,
    @ItemIndex int,
    @ItemDurability int,
    @ItemAttackGrade int,
    @ItemStrengthGrade int,
    @ItemSpiritGrade int,
    @ItemDexterityGrade int,
    @ItemPowerGrade int,
    @Position int,
    @GameID varchar(14),
    @WindowKind int,
    @WindowIndex int
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @DecreaseDurability int;
    SET @DecreaseDurability = 0;

    BEGIN TRANSACTION;

    IF @ItemDurability >= 4
    BEGIN
        IF (DATEPART(ms, GETDATE()) / 10) < 50
        BEGIN
            SET @DecreaseDurability = 1;
        END
    END
    ELSE
    BEGIN
        IF @ItemDurability = 3
        BEGIN
            IF (DATEPART(ms, GETDATE()) / 10) < 40
            BEGIN
                SET @DecreaseDurability = 1;
            END
        END
        ELSE
        BEGIN
            IF @ItemDurability = 2
            BEGIN
                IF (DATEPART(ms, GETDATE()) / 10) < 30
                BEGIN
                    SET @DecreaseDurability = 1;
                END
            END
            ELSE
            BEGIN
                IF @ItemDurability = 1
                BEGIN
                    IF (DATEPART(ms, GETDATE()) / 10) < 20
                    BEGIN
                        SET @DecreaseDurability = 1;
                    END
                END
                ELSE
                BEGIN
                    IF @ItemDurability = 0
                    BEGIN
                        IF (DATEPART(ms, GETDATE()) / 10) < 10
                        BEGIN
                            SET @DecreaseDurability = 1;
                        END
                    END
                    ELSE
                    BEGIN
                        IF (DATEPART(ms, GETDATE()) / 10) < 50
                        BEGIN
                            DELETE FROM tblSpecialItem1 
                            WHERE ID IN (
                                SELECT TOP 1 ID 
                                FROM tblSpecialItem1 
                                WHERE ItemKind = @ItemKind 
                                  AND ItemIndex = @ItemIndex 
                                  AND ItemDurability = @ItemDurability 
                                  AND AttackGrade = @ItemAttackGrade  
                                  AND StrengthGrade = @ItemStrengthGrade  
                                  AND SpiritGrade = @ItemSpiritGrade  
                                  AND DexterityGrade = @ItemDexterityGrade  
                                  AND PowerGrade = @ItemPowerGrade 
                                  AND Position = @Position 
                                  AND GameID = @GameID 
                                  AND WindowKind = @WindowKind 
                                  AND WindowIndex = @WindowIndex
                            );
                            INSERT INTO tblSpecialItemLog1 
                                (LogKind, ItemKind, ItemIndex, ItemDurability, Position, GameID, WindowKind, WindowIndex, LogItemCount, AttackGrade, StrengthGrade, SpiritGrade, DexterityGrade, PowerGrade) 
                            VALUES 
                                (103, @ItemKind, @ItemIndex, @ItemDurability, @Position, @GameID, @WindowKind, @WindowIndex, @@ROWCOUNT, @ItemAttackGrade, @ItemStrengthGrade, @ItemSpiritGrade, @ItemDexterityGrade, @ItemPowerGrade);
                        END
                    END
                END
            END
        END
    END

    IF @DecreaseDurability = 1
    BEGIN
        UPDATE tblSpecialItem1 
        SET ItemDurability = ItemDurability - 1 
        WHERE ID IN (
            SELECT TOP 1 ID 
            FROM tblSpecialItem1 
            WHERE ItemKind = @ItemKind 
              AND ItemIndex = @ItemIndex 
              AND ItemDurability = @ItemDurability 
              AND AttackGrade = @ItemAttackGrade  
              AND StrengthGrade = @ItemStrengthGrade  
              AND SpiritGrade = @ItemSpiritGrade  
              AND DexterityGrade = @ItemDexterityGrade  
              AND PowerGrade = @ItemPowerGrade 
              AND Position = @Position 
              AND GameID = @GameID 
              AND WindowKind = @WindowKind 
              AND WindowIndex = @WindowIndex
        );
    END

    COMMIT TRANSACTION;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_PICKUPITEM]    Script Date: 07/25/2024 12:01:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_PICKUPITEM]
    @ItemKind int,
    @ItemIndex int,
    @ItemDurability int,
    @ItemAttackGrade int,
    @ItemStrengthGrade int,
    @ItemSpiritGrade int,
    @ItemDexterityGrade int,
    @ItemPowerGrade int,
    @ItemCount int,
    @FromPosition int,
    @Map int,
    @X int,
    @Y int,
    @TileKind int,
    @ToPosition int,
    @GameID varchar(14),
    @WindowKind int,
    @WindowIndex int
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @TempItemCount int;
    SET @TempItemCount = -1;

    BEGIN TRANSACTION;

    IF @FromPosition = 0 AND @ToPosition = 1 AND
       ((@WindowKind = 1 AND @WindowIndex >= 0 AND @WindowIndex < 100) OR
        (@WindowKind = 3 AND @WindowIndex >= 0 AND @WindowIndex < 8))
    BEGIN
        SELECT @TempItemCount = COUNT(*)
        FROM RedMoon.dbo.tblSpecialItem1
        WHERE Position = @ToPosition AND GameID = @GameID AND
              (ItemKind != @ItemKind OR ItemIndex != @ItemIndex OR ItemDurability != @ItemDurability OR AttackGrade != @ItemAttackGrade OR
               StrengthGrade != @ItemStrengthGrade OR SpiritGrade != @ItemSpiritGrade OR DexterityGrade != @ItemDexterityGrade OR PowerGrade != @ItemPowerGrade) AND
              WindowKind = @WindowKind AND WindowIndex = @WindowIndex;

        IF @TempItemCount = 0
        BEGIN
            DECLARE @SQLStatement varchar(1024);
            SET @SQLStatement = 'UPDATE RedMoon.dbo.tblSpecialItem1
                                 SET Position = ' + CONVERT(varchar, @ToPosition) +
                                ', GameID = ''' + @GameID + '''' +
                                ', WindowKind = ' + CONVERT(varchar, @WindowKind) +
                                ', WindowIndex = ' + CONVERT(varchar, @WindowIndex) +
                                ' WHERE ID IN (SELECT TOP ' + CONVERT(varchar, @ItemCount) + ' ID
                                FROM RedMoon.dbo.tblSpecialItem1
                                WHERE ItemKind = ' + CONVERT(varchar, @ItemKind) +
                                ' AND ItemIndex = ' + CONVERT(varchar, @ItemIndex) +
                                ' AND ItemDurability = ' + CONVERT(varchar, @ItemDurability) +
                                ' AND AttackGrade = ' + CONVERT(varchar, @ItemAttackGrade) +
                                ' AND StrengthGrade = ' + CONVERT(varchar, @ItemStrengthGrade) +
                                ' AND SpiritGrade = ' + CONVERT(varchar, @ItemSpiritGrade) +
                                ' AND DexterityGrade = ' + CONVERT(varchar, @ItemDexterityGrade) +
                                ' AND PowerGrade = ' + CONVERT(varchar, @ItemPowerGrade) +
                                ' AND Position = ' + CONVERT(varchar, @FromPosition) +
                                ' AND Map = ' + CONVERT(varchar, @Map) +
                                ' AND X = ' + CONVERT(varchar, @X) +
                                ' AND Y = ' + CONVERT(varchar, @Y) +
                                ' AND TileKind = ' + CONVERT(varchar, @TileKind) + ')';
            EXEC (@SQLStatement);
        END
    END
    ELSE IF @FromPosition = 0 AND @ToPosition = 1 AND @WindowKind = 0 AND @ItemKind = 6 AND
            (@ItemIndex = 198 OR @ItemIndex = 199 OR @ItemIndex = 201 OR @ItemIndex = 202 OR @ItemIndex = 203 OR
             @ItemIndex = 204 OR @ItemIndex = 205 OR @ItemIndex = 206 OR @ItemIndex = 207 OR @ItemIndex = 228) 
    BEGIN
        DECLARE @SQLStatement2 varchar(1024);
        SET @SQLStatement2 = 'UPDATE RedMoon.dbo.tblSpecialItem1
                              SET Position = ' + CONVERT(varchar, @ToPosition) +
                             ', GameID = ''' + @GameID + '''' +
                             ', WindowKind = ' + CONVERT(varchar, @WindowKind) +
                             ', WindowIndex = ' + CONVERT(varchar, @WindowIndex) +
                             ' WHERE ID IN (SELECT TOP ' + CONVERT(varchar, @ItemCount) + ' ID
                             FROM RedMoon.dbo.tblSpecialItem1
                             WHERE ItemKind = ' + CONVERT(varchar, @ItemKind) +
                             ' AND ItemIndex = ' + CONVERT(varchar, @ItemIndex) +
                             ' AND ItemDurability = ' + CONVERT(varchar, @ItemDurability) +
                             ' AND AttackGrade = ' + CONVERT(varchar, @ItemAttackGrade) +
                             ' AND StrengthGrade = ' + CONVERT(varchar, @ItemStrengthGrade) +
                             ' AND SpiritGrade = ' + CONVERT(varchar, @ItemSpiritGrade) +
                             ' AND DexterityGrade = ' + CONVERT(varchar, @ItemDexterityGrade) +
                             ' AND PowerGrade = ' + CONVERT(varchar, @ItemPowerGrade) +
                             ' AND Position = ' + CONVERT(varchar, @FromPosition) +
                             ' AND Map = ' + CONVERT(varchar, @Map) +
                             ' AND X = ' + CONVERT(varchar, @X) +
                             ' AND Y = ' + CONVERT(varchar, @Y) +
                             ' AND TileKind = ' + CONVERT(varchar, @TileKind) + ')';
        EXEC (@SQLStatement2);
    END

    COMMIT TRANSACTION;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_MOVEUSERWINDOWITEM]    Script Date: 07/25/2024 12:01:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RMS_MOVEUSERWINDOWITEM]
    @ItemKind int,
    @ItemIndex int,
    @ItemDurability int,
    @ItemAttackGrade int,
    @ItemStrengthGrade int,
    @ItemSpiritGrade int,
    @ItemDexterityGrade int,
    @ItemPowerGrade int,
    @ItemCount int,
    @FromGameID varchar(14),
    @FromPosition int,
    @FromWindowKind int,
    @FromWindowIndex int,
    @ToGameID varchar(14),
    @ToPosition int,
    @ToWindowKind int,
    @ToWindowIndex int
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @TempItemCount int;
    SET @TempItemCount = -1;

    BEGIN TRANSACTION;

    IF @ToWindowKind != 2
    BEGIN
        SELECT @TempItemCount = COUNT(*) 
        FROM tblSpecialItem1 
        WHERE GameID = @ToGameID 
          AND Position = @ToPosition 
          AND WindowKind = @ToWindowKind 
          AND WindowIndex = @ToWindowIndex 
          AND (ItemKind != @ItemKind OR ItemIndex != @ItemIndex OR ItemDurability != @ItemDurability OR AttackGrade != @ItemAttackGrade OR
               StrengthGrade != @ItemStrengthGrade OR SpiritGrade != @ItemSpiritGrade OR DexterityGrade != @ItemDexterityGrade OR PowerGrade != @ItemPowerGrade);

        IF @TempItemCount = 0
        BEGIN
            IF @FromWindowKind != @ToWindowKind AND (@FromWindowKind != 1 OR @ToWindowKind != 3) AND (@FromWindowKind != 3 OR @ToWindowKind != 1)
            BEGIN
                SELECT @TempItemCount = -1;

                IF @ToWindowKind = 1
                BEGIN
                    SELECT @TempItemCount = COUNT(*) 
                    FROM tblSpecialItem1 
                    WHERE GameID = @ToGameID 
                      AND Position = @ToPosition 
                      AND ItemKind = @ItemKind 
                      AND ItemIndex = @ItemIndex 
                      AND ((WindowKind = @ToWindowKind AND WindowIndex != @ToWindowIndex) OR WindowKind = 3) 
                      AND ItemDurability = @ItemDurability  
                      AND AttackGrade = @ItemAttackGrade  
                      AND StrengthGrade = @ItemStrengthGrade 
                      AND SpiritGrade = @ItemSpiritGrade  
                      AND DexterityGrade = @ItemDexterityGrade  
                      AND PowerGrade = @ItemPowerGrade;
                END
                ELSE IF @ToWindowKind = 3
                BEGIN
                    SELECT @TempItemCount = COUNT(*) 
                    FROM tblSpecialItem1 
                    WHERE GameID = @ToGameID 
                      AND Position = @ToPosition 
                      AND ItemKind = @ItemKind 
                      AND ItemIndex = @ItemIndex 
                      AND ((WindowKind = @ToWindowKind AND WindowIndex != @ToWindowIndex) OR WindowKind = 1) 
                      AND ItemDurability = @ItemDurability  
                      AND AttackGrade = @ItemAttackGrade 
                      AND StrengthGrade = @ItemStrengthGrade 
                      AND SpiritGrade = @ItemSpiritGrade  
                      AND DexterityGrade = @ItemDexterityGrade  
                      AND PowerGrade = @ItemPowerGrade;
                END
                ELSE
                BEGIN
                    SELECT @TempItemCount = COUNT(*) 
                    FROM tblSpecialItem1 
                    WHERE GameID = @ToGameID 
                      AND Position = @ToPosition 
                      AND ItemKind = @ItemKind 
                      AND ItemIndex = @ItemIndex 
                      AND WindowKind = @ToWindowKind 
                      AND WindowIndex != @ToWindowIndex 
                      AND ItemDurability = @ItemDurability  
                      AND AttackGrade = @ItemAttackGrade 
                      AND StrengthGrade = @ItemStrengthGrade 
                      AND SpiritGrade = @ItemSpiritGrade  
                      AND DexterityGrade = @ItemDexterityGrade  
                      AND PowerGrade = @ItemPowerGrade;
                END
            END

            IF @TempItemCount = 0
            BEGIN
                DECLARE @SQLStatement varchar(1024);
                DECLARE @SQLSetClause varchar(1024);
                DECLARE @SQLWhereClause varchar(1024);
                DECLARE @IsFirst int;
                SET @IsFirst = 1;

                IF @FromPosition <> @ToPosition
                BEGIN
                    IF @IsFirst = 1
                    BEGIN
                        SET @SQLSetClause = 'SET Position = ' + CONVERT(varchar, @ToPosition);
                        SET @IsFirst = 0;
                    END
                END

                IF @ToGameID <> @FromGameID
                BEGIN
                    IF @IsFirst = 1
                    BEGIN
                        SET @SQLSetClause = 'SET GameID = ''' + CONVERT(varchar, @ToGameID) + '''';
                        SET @IsFirst = 0;
                    END
                    ELSE
                    BEGIN
                        SET @SQLSetClause = @SQLSetClause + ', GameID = ''' + CONVERT(varchar, @ToGameID) + '''';
                    END
                END

                IF @ToWindowKind <> @FromWindowKind
                BEGIN
                    IF @IsFirst = 1
                    BEGIN
                        SET @SQLSetClause = 'SET WindowKind = ' + CONVERT(varchar, @ToWindowKind);
                        SET @IsFirst = 0;
                    END
                    ELSE
                    BEGIN
                        SET @SQLSetClause = @SQLSetClause + ', WindowKind = ' + CONVERT(varchar, @ToWindowKind);
                    END
                END

                IF @ToWindowIndex <> @FromWindowIndex
                BEGIN
                    IF @IsFirst = 1
                    BEGIN
                        SET @SQLSetClause = 'SET WindowIndex = ' + CONVERT(varchar, @ToWindowIndex);
                        SET @IsFirst = 0;
                    END
                    ELSE
                    BEGIN
                        SET @SQLSetClause = @SQLSetClause + ', WindowIndex = ' + CONVERT(varchar, @ToWindowIndex);
                    END
                END

                IF @IsFirst = 0
                BEGIN
                    SET @SQLWhereClause = 'WHERE Position = ' + CONVERT(varchar, @FromPosition) + 
                                          ' AND GameID = ''' + @FromGameID + '''' + 
                                          ' AND WindowKind = ' + CONVERT(varchar, @FromWindowKind) + 
                                          ' AND WindowIndex = ' + CONVERT(varchar, @FromWindowIndex) + 
                                          ' AND ItemKind = ' + CONVERT(varchar, @ItemKind) + 
                                          ' AND ItemIndex = ' + CONVERT(varchar, @ItemIndex) + 
                                          ' AND ItemDurability = ' + CONVERT(varchar, @ItemDurability) + 
                                          ' AND AttackGrade = ' + CONVERT(varchar, @ItemAttackGrade) + 
                                          ' AND StrengthGrade = ' + CONVERT(varchar, @ItemStrengthGrade) + 
                                          ' AND SpiritGrade = ' + CONVERT(varchar, @ItemSpiritGrade) + 
                                          ' AND DexterityGrade = ' + CONVERT(varchar, @ItemDexterityGrade) + 
                                          ' AND PowerGrade = ' + CONVERT(varchar, @ItemPowerGrade);

                    IF @FromWindowKind = 2 AND (@FromWindowIndex = 5 OR @FromWindowIndex = 7)
                    BEGIN
                        SET @SQLStatement = 'UPDATE tblSpecialItem1 ' + @SQLSetClause + ' ' + @SQLWhereClause;
                        EXEC (@SQLStatement);

                        IF @@ROWCOUNT = 0
                        BEGIN
                            SET @SQLWhereClause = 'WHERE Position = ' + CONVERT(varchar, @FromPosition) + 
                                                  ' AND GameID = ''' + @FromGameID + '''' + 
                                                  ' AND WindowKind = ' + CONVERT(varchar, @FromWindowKind) + 
                                                  ' AND WindowIndex = 100' + 
                                                  ' AND ItemKind = ' + CONVERT(varchar, @ItemKind) + 
                                                  ' AND ItemIndex = ' + CONVERT(varchar, @ItemIndex) + 
                                                  ' AND ItemDurability = ' + CONVERT(varchar, @ItemDurability) + 
                                                  ' AND AttackGrade = ' + CONVERT(varchar, @ItemAttackGrade) + 
                                                  ' AND StrengthGrade = ' + CONVERT(varchar, @ItemStrengthGrade) + 
                                                  ' AND SpiritGrade = ' + CONVERT(varchar, @ItemSpiritGrade) + 
                                                  ' AND DexterityGrade = ' + CONVERT(varchar, @ItemDexterityGrade) + 
                                                  ' AND PowerGrade = ' + CONVERT(varchar, @ItemPowerGrade);
                            SET @SQLStatement = 'UPDATE tblSpecialItem1 ' + @SQLSetClause + ' ' + @SQLWhereClause;
                            EXEC (@SQLStatement);
                        END
                    END
                    ELSE
                    BEGIN
                        IF @ItemCount <> -1
                        BEGIN
                            SET @SQLWhereClause = 'WHERE ID IN (SELECT TOP ' + CONVERT(varchar, @ItemCount) + ' ID '+
                                                  'FROM tblSpecialItem1 ' + 
                                                  'WHERE GameID = ''' + @FromGameID + '''' + 
                                                  ' AND Position = ' + CONVERT(varchar, @FromPosition) + 
                                                  ' AND WindowKind = ' + CONVERT(varchar, @FromWindowKind) + 
                                                  ' AND WindowIndex = ' + CONVERT(varchar, @FromWindowIndex) + 
                                                  ' AND ItemKind = ' + CONVERT(varchar, @ItemKind) + 
                                                  ' AND ItemIndex = ' + CONVERT(varchar, @ItemIndex) + 
                                                  ' AND ItemDurability = ' + CONVERT(varchar, @ItemDurability) + 
                                                  ' AND AttackGrade = ' + CONVERT(varchar, @ItemAttackGrade) + 
                                                  ' AND StrengthGrade = ' + CONVERT(varchar, @ItemStrengthGrade) + 
                                                  ' AND SpiritGrade = ' + CONVERT(varchar, @ItemSpiritGrade) + 
                                                  ' AND DexterityGrade = ' + CONVERT(varchar, @ItemDexterityGrade) + 
                                                  ' AND PowerGrade = ' + CONVERT(varchar, @ItemPowerGrade) + ')';
                        END 
                        
                        SET @SQLStatement = 'UPDATE tblSpecialItem1 ' + @SQLSetClause + ' ' + @SQLWhereClause;
                        EXEC (@SQLStatement);
                    END
                END
            END
        END
    END

    COMMIT TRANSACTION;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_MOVEITEMFROMUSERTOTIME]    Script Date: 07/25/2024 12:01:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_MOVEITEMFROMUSERTOTIME]
    @ItemKind int,
    @ItemIndex int,
    @ItemDurability int,
    @ItemAttackGrade int,
    @ItemStrengthGrade int,
    @ItemSpiritGrade int,
    @ItemDexterityGrade int,
    @ItemPowerGrade int,
    @ItemCount int,
    @FromPosition int,
    @FromGameID varchar(14),
    @FromWindowKind int,
    @FromWindowIndex int,
    @ToPosition int,
    @ToGameID varchar(14),
    @ToMiscTime datetime,
    @ToWindowKind int,
    @ToWindowIndex int
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @TempItemCount int;
    SET @TempItemCount = -1;

    BEGIN TRANSACTION;

    IF @FromPosition = 1 AND @ToPosition = 2 AND
       ((@FromWindowKind = 1 AND @FromWindowIndex >= 0 AND @FromWindowIndex < 100) OR
        (@FromWindowKind = 3 AND @FromWindowIndex >= 0 AND @FromWindowIndex < 8)) AND
       (@ToWindowKind = 100 OR @ToWindowKind = 101) AND
       @ToWindowIndex >= 0 AND @ToWindowIndex < 5
    BEGIN
        SELECT @TempItemCount = COUNT(*)
        FROM RedMoon.dbo.tblSpecialItem1
        WHERE Position = @ToPosition AND GameID = @ToGameID AND
              MiscTime = @ToMiscTime AND WindowIndex = @ToWindowIndex;

        IF @TempItemCount = 0
        BEGIN
            DECLARE @SQLStatement varchar(1024);
            SET @SQLStatement = 'UPDATE RedMoon.dbo.tblSpecialItem1
                                 SET Position = ' + CONVERT(varchar, @ToPosition) +
                                ', GameID = ''' + @ToGameID + '''' +
                                ', MiscTime = ''' + CONVERT(varchar, @ToMiscTime, 120) + '''' +
                                ', WindowKind = ' + CONVERT(varchar, @ToWindowKind) +
                                ', WindowIndex = ' + CONVERT(varchar, @ToWindowIndex) +
                                ' WHERE ID IN (SELECT TOP ' + CONVERT(varchar, @ItemCount) + ' ID
                                FROM RedMoon.dbo.tblSpecialItem1
                                WHERE ItemKind = ' + CONVERT(varchar, @ItemKind) +
                                ' AND ItemIndex = ' + CONVERT(varchar, @ItemIndex) +
                                ' AND ItemDurability = ' + CONVERT(varchar, @ItemDurability) +
                                ' AND AttackGrade = ' + CONVERT(varchar, @ItemAttackGrade) +
                                ' AND StrengthGrade = ' + CONVERT(varchar, @ItemStrengthGrade) +
                                ' AND SpiritGrade = ' + CONVERT(varchar, @ItemSpiritGrade) +
                                ' AND DexterityGrade = ' + CONVERT(varchar, @ItemDexterityGrade) +
                                ' AND PowerGrade = ' + CONVERT(varchar, @ItemPowerGrade) +
                                ' AND Position = ' + CONVERT(varchar, @FromPosition) +
                                ' AND GameID = ''' + @FromGameID + '''' +
                                ' AND WindowKind = ' + CONVERT(varchar, @FromWindowKind) +
                                ' AND WindowIndex = ' + CONVERT(varchar, @FromWindowIndex) + ')';
            EXEC (@SQLStatement);
        END
    END

    COMMIT TRANSACTION;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_MOVEITEMFROMTIMETOUSER]    Script Date: 07/25/2024 12:01:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_MOVEITEMFROMTIMETOUSER]
    @ItemKind int,
    @ItemIndex int,
    @ItemDurability int,
    @ItemAttackGrade int,
    @ItemStrengthGrade int,
    @ItemSpiritGrade int,
    @ItemDexterityGrade int,
    @ItemPowerGrade int,
    @ItemCount int,
    @FromPosition int,
    @FromGameID varchar(14),
    @FromMiscTime datetime,
    @FromWindowKind int,
    @FromWindowIndex int,
    @ToPosition int,
    @ToGameID varchar(14),
    @ToWindowKind int,
    @ToWindowIndex int
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @TempItemCount int;
    SET @TempItemCount = -1;

    BEGIN TRANSACTION;

    IF @FromPosition = 2 AND @ToPosition = 1 AND
       ((@ToWindowKind = 1 AND @ToWindowIndex >= 0 AND @ToWindowIndex < 100) OR
        (@ToWindowKind = 3 AND @ToWindowIndex >= 0 AND @ToWindowIndex < 8)) AND
       (@FromWindowKind = 100 OR @FromWindowKind = 101) AND
       @FromWindowIndex >= 0 AND @FromWindowIndex < 5
    BEGIN
        SELECT @TempItemCount = COUNT(*)
        FROM RedMoon.dbo.tblSpecialItem1
        WHERE Position = @ToPosition AND GameID = @ToGameID AND
              (ItemKind != @ItemKind OR ItemIndex != @ItemIndex OR
               ItemDurability != @ItemDurability OR AttackGrade != @ItemAttackGrade OR
               StrengthGrade != @ItemStrengthGrade OR SpiritGrade != @ItemSpiritGrade OR
               DexterityGrade != @ItemDexterityGrade OR PowerGrade != @ItemPowerGrade) AND
              WindowKind = @ToWindowKind AND WindowIndex = @ToWindowIndex;

        IF @TempItemCount = 0
        BEGIN
            DECLARE @SQLStatement varchar(1024);
            SET @SQLStatement = 'UPDATE RedMoon.dbo.tblSpecialItem1
                                 SET Position = ' + CONVERT(varchar, @ToPosition) +
                                ', GameID = ''' + @ToGameID + '''' +
                                ', WindowKind = ' + CONVERT(varchar, @ToWindowKind) +
                                ', WindowIndex = ' + CONVERT(varchar, @ToWindowIndex) +
                                ' WHERE ID IN (SELECT TOP ' + CONVERT(varchar, @ItemCount) + ' ID
                                FROM RedMoon.dbo.tblSpecialItem1
                                WHERE ItemKind = ' + CONVERT(varchar, @ItemKind) +
                                ' AND ItemIndex = ' + CONVERT(varchar, @ItemIndex) +
                                ' AND ItemDurability = ' + CONVERT(varchar, @ItemDurability) +
                                ' AND AttackGrade = ' + CONVERT(varchar, @ItemAttackGrade) +
                                ' AND StrengthGrade = ' + CONVERT(varchar, @ItemStrengthGrade) +
                                ' AND SpiritGrade = ' + CONVERT(varchar, @ItemSpiritGrade) +
                                ' AND DexterityGrade = ' + CONVERT(varchar, @ItemDexterityGrade) +
                                ' AND PowerGrade = ' + CONVERT(varchar, @ItemPowerGrade) +
                                ' AND Position = ' + CONVERT(varchar, @FromPosition) +
                                ' AND GameID = ''' + @FromGameID + '''' +
                                ' AND MiscTime = ''' + CONVERT(varchar, @FromMiscTime, 120) + '''' +
                                ' AND WindowKind = ' + CONVERT(varchar, @FromWindowKind) +
                                ' AND WindowIndex = ' + CONVERT(varchar, @FromWindowIndex) + ')';
            EXEC (@SQLStatement);
        END
    END

    COMMIT TRANSACTION;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_MEDALRESULT]    Script Date: 07/25/2024 12:01:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_MEDALRESULT]
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION RMS_MEDALRESULT;

    DECLARE @GameID varchar(16);
    DECLARE @ItemIndex int;
    DECLARE @ItemCount int;
    DECLARE @RowCount int;
    DECLARE MedalResult CURSOR FOR
        SELECT GameID, ItemIndex, COUNT(*)
        FROM tblSpecialItem1
        WHERE ItemKind = 6 AND ItemIndex IN (201, 202, 203)
        GROUP BY GameID, ItemIndex;

    OPEN MedalResult;
    FETCH NEXT FROM MedalResult INTO @GameID, @ItemIndex, @ItemCount;

    WHILE @@FETCH_STATUS = 0 
    BEGIN
        SELECT @RowCount = COUNT(*)
        FROM tblMedalResult1
        WHERE GameID = @GameID;

        IF @RowCount > 0
        BEGIN
            IF @ItemIndex = 201
            BEGIN
                UPDATE tblMedalResult1
                SET GoldMedal = @ItemCount
                WHERE GameID = @GameID;
            END
            ELSE IF @ItemIndex = 202
            BEGIN
                UPDATE tblMedalResult1
                SET SilverMedal = @ItemCount
                WHERE GameID = @GameID;
            END
            ELSE
            BEGIN
                UPDATE tblMedalResult1
                SET BronzeMedal = @ItemCount
                WHERE GameID = @GameID;
            END
        END
        ELSE
        BEGIN
            IF @ItemIndex = 201
            BEGIN
                INSERT INTO tblMedalResult1 (GameID, GoldMedal, SilverMedal, BronzeMedal)
                VALUES (@GameID, @ItemCount, 0, 0);
            END
            ELSE IF @ItemIndex = 202
            BEGIN
                INSERT INTO tblMedalResult1 (GameID, GoldMedal, SilverMedal, BronzeMedal)
                VALUES (@GameID, 0, @ItemCount, 0);
            END
            ELSE
            BEGIN
                INSERT INTO tblMedalResult1 (GameID, GoldMedal, SilverMedal, BronzeMedal)
                VALUES (@GameID, 0, 0, @ItemCount);
            END
        END

        FETCH NEXT FROM MedalResult INTO @GameID, @ItemIndex, @ItemCount;
    END

    CLOSE MedalResult;
    DEALLOCATE MedalResult;

    COMMIT TRANSACTION RMS_MEDALRESULT;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_DROP2]    Script Date: 07/25/2024 12:01:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_DROP2]
    @ToTBL varchar(40),
    @ToPosition int,
    @Map int,
    @X int,
    @Y int,
    @TileKind int,
    @ItemCount int,
    @FromTBL varchar(40),
    @FromPosition int,
    @FromGameID varchar(14),
    @ItemKind int,
    @ItemIndex int,
    @ItemDurability int,
    @AttackGrade int,
    @StrengthGrade int,
    @SpiritGrade int,
    @DexterityGrade int,
    @PowerGrade int,
    @WindowKind int,
    @WindowIndex int
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @TempItemCount INT;
    DECLARE @Error INT;
    DECLARE @ID INT, @ID2 INT;
    DECLARE @Time DATETIME;

    BEGIN TRANSACTION RMS_DROP2;

    IF NOT (@ItemKind = 6 AND (@ItemIndex IN (219, 229, 239, 240, 241)))
    BEGIN
        SET @TempItemCount = 0;
        SET @Time = CAST(CONVERT(VARCHAR, GETDATE(), 120) AS DATETIME);

        SELECT TOP 1 @ID = ID, @TempItemCount = ISNULL(CNT, 0)
        FROM tblSpecialItem1
        WHERE Position = @FromPosition
          AND GameID = @FromGameID
          AND ItemKind = @ItemKind
          AND ItemIndex = @ItemIndex
          AND ItemDurability = @ItemDurability
          AND AttackGrade = @AttackGrade
          AND StrengthGrade = @StrengthGrade
          AND SpiritGrade = @SpiritGrade
          AND DexterityGrade = @DexterityGrade
          AND PowerGrade = @PowerGrade
          AND WindowKind = @WindowKind
          AND WindowIndex = @WindowIndex;

        SET @Error = @@ERROR;

        IF @Error = 0
        BEGIN
            IF @TempItemCount = @ItemCount
            BEGIN
                SET @TempItemCount = 0;
                SELECT TOP 1 @ID2 = ID, @TempItemCount = ISNULL(CNT, 0)
                FROM tblSpecialItem1
                WHERE Position = @ToPosition
                  AND Map = @Map
                  AND X = @X
                  AND Y = @Y
                  AND TileKind = @TileKind
                  AND ItemKind = @ItemKind
                  AND ItemIndex = @ItemIndex
                  AND ItemDurability = @ItemDurability
                  AND AttackGrade = @AttackGrade
                  AND StrengthGrade = @StrengthGrade
                  AND SpiritGrade = @SpiritGrade
                  AND DexterityGrade = @DexterityGrade
                  AND PowerGrade = @PowerGrade;

                SET @Error = @@ERROR;

                IF @Error = 0 AND @TempItemCount = 0
                BEGIN
                    UPDATE tblSpecialItem1
                    SET Position = @ToPosition, Map = @Map, X = @X, Y = @Y, TileKind = @TileKind, MiscTime = @Time
                    WHERE ID = @ID
                      AND Position = @FromPosition
                      AND GameID = @FromGameID
                      AND ItemKind = @ItemKind
                      AND ItemIndex = @ItemIndex
                      AND ItemDurability = @ItemDurability
                      AND AttackGrade = @AttackGrade
                      AND StrengthGrade = @StrengthGrade
                      AND SpiritGrade = @SpiritGrade
                      AND DexterityGrade = @DexterityGrade
                      AND PowerGrade = @PowerGrade
                      AND WindowKind = @WindowKind
                      AND WindowIndex = @WindowIndex;

                    SET @Error = @@ERROR;
                END
                ELSE IF @Error = 0 AND @TempItemCount > 0
                BEGIN
                    UPDATE tblSpecialItem1
                    SET CNT = CNT + @ItemCount, MiscTime = @Time
                    WHERE ID = @ID2
                      AND Position = @ToPosition
                      AND Map = @Map
                      AND X = @X
                      AND Y = @Y
                      AND TileKind = @TileKind
                      AND ItemKind = @ItemKind
                      AND ItemIndex = @ItemIndex
                      AND ItemDurability = @ItemDurability
                      AND AttackGrade = @AttackGrade
                      AND StrengthGrade = @StrengthGrade
                      AND SpiritGrade = @SpiritGrade
                      AND DexterityGrade = @DexterityGrade
                      AND PowerGrade = @PowerGrade;

                    SET @Error = @@ERROR;

                    IF @Error = 0
                    BEGIN
                        DELETE FROM tblSpecialItem1
                        WHERE ID = @ID
                          AND Position = @FromPosition
                          AND GameID = @FromGameID
                          AND ItemKind = @ItemKind
                          AND ItemIndex = @ItemIndex
                          AND ItemDurability = @ItemDurability
                          AND AttackGrade = @AttackGrade
                          AND StrengthGrade = @StrengthGrade
                          AND SpiritGrade = @SpiritGrade
                          AND DexterityGrade = @DexterityGrade
                          AND PowerGrade = @PowerGrade
                          AND WindowKind = @WindowKind
                          AND WindowIndex = @WindowIndex;

                        SET @Error = @@ERROR;
                    END
                END
            END
            ELSE IF @TempItemCount > @ItemCount
            BEGIN
                UPDATE tblSpecialItem1
                SET CNT = CNT - @ItemCount
                WHERE ID = @ID
                  AND Position = @FromPosition
                  AND GameID = @FromGameID
                  AND ItemKind = @ItemKind
                  AND ItemIndex = @ItemIndex
                  AND ItemDurability = @ItemDurability
                  AND AttackGrade = @AttackGrade
                  AND StrengthGrade = @StrengthGrade
                  AND SpiritGrade = @SpiritGrade
                  AND DexterityGrade = @DexterityGrade
                  AND PowerGrade = @PowerGrade
                  AND WindowKind = @WindowKind
                  AND WindowIndex = @WindowIndex;

                SET @Error = @@ERROR;

                IF @Error = 0
                BEGIN
                    SET @TempItemCount = 0;
                    SELECT TOP 1 @ID2 = ID, @TempItemCount = ISNULL(CNT, 0)
                    FROM tblSpecialItem1
                    WHERE Position = @ToPosition
                      AND Map = @Map
                      AND X = @X
                      AND Y = @Y
                      AND TileKind = @TileKind
                      AND ItemKind = @ItemKind
                      AND ItemIndex = @ItemIndex
                      AND ItemDurability = @ItemDurability
                      AND AttackGrade = @AttackGrade
                      AND StrengthGrade = @StrengthGrade
                      AND SpiritGrade = @SpiritGrade
                      AND DexterityGrade = @DexterityGrade
                      AND PowerGrade = @PowerGrade;

                    SET @Error = @@ERROR;

                    IF @Error = 0 AND @TempItemCount = 0
                    BEGIN
                        INSERT INTO tblSpecialItem1
                            (ItemKind, ItemIndex, ItemDurability, Position, GameID, WindowKind, WindowIndex, AttackGrade, StrengthGrade, SpiritGrade, DexterityGrade, PowerGrade, Map, X, Y, TileKind, MiscTime, CNT)
                        VALUES
                            (@ItemKind, @ItemIndex, @ItemDurability, @ToPosition, @FromGameID, @WindowKind, @WindowIndex, @AttackGrade, @StrengthGrade, @SpiritGrade, @DexterityGrade, @PowerGrade, @Map, @X, @Y, @TileKind, @Time, @ItemCount);

                        SET @Error = @@ERROR;
                    END
                    ELSE IF @Error = 0 AND @TempItemCount > 0
                    BEGIN
                        UPDATE tblSpecialItem1
                        SET CNT = CNT + @ItemCount, MiscTime = @Time
                        WHERE ID = @ID2
                          AND Position = @ToPosition
                          AND Map = @Map
                          AND X = @X
                          AND Y = @Y
                          AND TileKind = @TileKind
                          AND ItemKind = @ItemKind
                          AND ItemIndex = @ItemIndex
                          AND ItemDurability = @ItemDurability
                          AND AttackGrade = @AttackGrade
                          AND StrengthGrade = @StrengthGrade
                          AND SpiritGrade = @SpiritGrade
                          AND DexterityGrade = @DexterityGrade
                          AND PowerGrade = @PowerGrade;

                        SET @Error = @@ERROR;
                    END
                END
            END
            ELSE
            BEGIN
                SET @Error = 1;
            END
        END
    END

    IF @Error = 0
    BEGIN
        COMMIT TRANSACTION RMS_DROP2;
    END
    ELSE
    BEGIN
        ROLLBACK TRANSACTION RMS_DROP2;
    END
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_DROP]    Script Date: 07/25/2024 12:01:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_DROP]
    @ToTBL varchar(40),
    @ToPosition int,
    @Map int,
    @X int,
    @Y int,
    @TileKind int,
    @ItemCount int,
    @FromTBL varchar(40),
    @FromPosition int,
    @FromGameID varchar(14),
    @ItemKind int,
    @ItemIndex int,
    @ItemDurability int,
    @AttackGrade int,
    @StrengthGrade int,
    @SpiritGrade int,
    @DexterityGrade int,
    @PowerGrade int,
    @WindowKind int,
    @WindowIndex int
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @TempItemCount INT;
    DECLARE @ID INT, @ID2 INT;
    DECLARE @Error INT;
    DECLARE @Time DATETIME;

    SET @TempItemCount = 0;
    SET @Time = CAST(CONVERT(VARCHAR, GETDATE(), 120) AS DATETIME);

    BEGIN TRANSACTION RMS_DROP;

    SELECT TOP 1 @ID = ID, @TempItemCount = ISNULL(CNT, 0)
    FROM tblSpecialItem1
    WHERE Position = @FromPosition
      AND GameID = @FromGameID
      AND ItemKind = @ItemKind
      AND ItemIndex = @ItemIndex
      AND ItemDurability = @ItemDurability
      AND AttackGrade = @AttackGrade
      AND StrengthGrade = @StrengthGrade
      AND SpiritGrade = @SpiritGrade
      AND DexterityGrade = @DexterityGrade
      AND PowerGrade = @PowerGrade
      AND WindowKind = @WindowKind
      AND (WindowIndex = @WindowIndex OR WindowIndex = 100)
    ORDER BY WindowIndex;

    SET @Error = @@ERROR;

    IF @Error = 0
    BEGIN
        IF @TempItemCount = @ItemCount
        BEGIN
            SET @TempItemCount = 0;
            SELECT TOP 1 @ID2 = ID, @TempItemCount = ISNULL(CNT, 0)
            FROM tblSpecialItem1
            WHERE Position = @ToPosition
              AND Map = @Map
              AND X = @X
              AND Y = @Y
              AND TileKind = @TileKind
              AND ItemKind = @ItemKind
              AND ItemIndex = @ItemIndex
              AND ItemDurability = @ItemDurability
              AND AttackGrade = @AttackGrade
              AND StrengthGrade = @StrengthGrade
              AND SpiritGrade = @SpiritGrade
              AND DexterityGrade = @DexterityGrade
              AND PowerGrade = @PowerGrade;

            SET @Error = @@ERROR;

            IF @Error = 0 AND @TempItemCount = 0
            BEGIN
                UPDATE tblSpecialItem1
                SET Position = @ToPosition, Map = @Map, X = @X, Y = @Y, TileKind = @TileKind, MiscTime = @Time
                WHERE ID = @ID
                  AND Position = @FromPosition
                  AND GameID = @FromGameID
                  AND ItemKind = @ItemKind
                  AND ItemIndex = @ItemIndex
                  AND ItemDurability = @ItemDurability
                  AND AttackGrade = @AttackGrade
                  AND StrengthGrade = @StrengthGrade
                  AND SpiritGrade = @SpiritGrade
                  AND DexterityGrade = @DexterityGrade
                  AND PowerGrade = @PowerGrade
                  AND WindowKind = @WindowKind
                  AND WindowIndex = @WindowIndex;

                SET @Error = @@ERROR;
            END
            ELSE IF @Error = 0 AND @TempItemCount > 0
            BEGIN
                UPDATE tblSpecialItem1
                SET CNT = CNT + @ItemCount, MiscTime = @Time
                WHERE ID = @ID2
                  AND Position = @ToPosition
                  AND Map = @Map
                  AND X = @X
                  AND Y = @Y
                  AND TileKind = @TileKind
                  AND ItemKind = @ItemKind
                  AND ItemIndex = @ItemIndex
                  AND ItemDurability = @ItemDurability
                  AND AttackGrade = @AttackGrade
                  AND StrengthGrade = @StrengthGrade
                  AND SpiritGrade = @SpiritGrade
                  AND DexterityGrade = @DexterityGrade
                  AND PowerGrade = @PowerGrade;

                SET @Error = @@ERROR;

                IF @Error = 0
                BEGIN
                    DELETE FROM tblSpecialItem1
                    WHERE ID = @ID
                      AND Position = @FromPosition
                      AND GameID = @FromGameID
                      AND ItemKind = @ItemKind
                      AND ItemIndex = @ItemIndex
                      AND ItemDurability = @ItemDurability
                      AND AttackGrade = @AttackGrade
                      AND StrengthGrade = @StrengthGrade
                      AND SpiritGrade = @SpiritGrade
                      AND DexterityGrade = @DexterityGrade
                      AND PowerGrade = @PowerGrade
                      AND WindowKind = @WindowKind
                      AND WindowIndex = @WindowIndex;

                    SET @Error = @@ERROR;
                END
            END
        END
        ELSE IF @TempItemCount > @ItemCount
        BEGIN
            UPDATE tblSpecialItem1
            SET CNT = CNT - @ItemCount
            WHERE ID = @ID
              AND Position = @FromPosition
              AND GameID = @FromGameID
              AND ItemKind = @ItemKind
              AND ItemIndex = @ItemIndex
              AND ItemDurability = @ItemDurability
              AND AttackGrade = @AttackGrade
              AND StrengthGrade = @StrengthGrade
              AND SpiritGrade = @SpiritGrade
              AND DexterityGrade = @DexterityGrade
              AND PowerGrade = @PowerGrade
              AND WindowKind = @WindowKind
              AND WindowIndex = @WindowIndex;

            SET @Error = @@ERROR;

            IF @Error = 0
            BEGIN
                SET @TempItemCount = 0;
                SELECT TOP 1 @ID2 = ID, @TempItemCount = ISNULL(CNT, 0)
                FROM tblSpecialItem1
                WHERE Position = @ToPosition
                  AND Map = @Map
                  AND X = @X
                  AND Y = @Y
                  AND TileKind = @TileKind
                  AND ItemKind = @ItemKind
                  AND ItemIndex = @ItemIndex
                  AND ItemDurability = @ItemDurability
                  AND AttackGrade = @AttackGrade
                  AND StrengthGrade = @StrengthGrade
                  AND SpiritGrade = @SpiritGrade
                  AND DexterityGrade = @DexterityGrade
                  AND PowerGrade = @PowerGrade;

                SET @Error = @@ERROR;

                IF @Error = 0 AND @TempItemCount = 0
                BEGIN
                    INSERT INTO tblSpecialItem1 
                        (ItemKind, ItemIndex, ItemDurability, Position, GameID, WindowKind, WindowIndex, AttackGrade, StrengthGrade, SpiritGrade, DexterityGrade, PowerGrade, Map, X, Y, TileKind, MiscTime, CNT)
                    VALUES 
                        (@ItemKind, @ItemIndex, @ItemDurability, @ToPosition, @FromGameID, @WindowKind, @WindowIndex, @AttackGrade, @StrengthGrade, @SpiritGrade, @DexterityGrade, @PowerGrade, @Map, @X, @Y, @TileKind, @Time, @ItemCount);

                    SET @Error = @@ERROR;
                END
                ELSE IF @Error = 0 AND @TempItemCount > 0
                BEGIN
                    UPDATE tblSpecialItem1
                    SET CNT = CNT + @ItemCount, MiscTime = @Time
                    WHERE ID = @ID2
                      AND Position = @ToPosition
                      AND Map = @Map
                      AND X = @X
                      AND Y = @Y
                      AND TileKind = @TileKind
                      AND ItemKind = @ItemKind
                      AND ItemIndex = @ItemIndex
                      AND ItemDurability = @ItemDurability
                      AND AttackGrade = @AttackGrade
                      AND StrengthGrade = @StrengthGrade
                      AND SpiritGrade = @SpiritGrade
                      AND DexterityGrade = @DexterityGrade
                      AND PowerGrade = @PowerGrade;

                    SET @Error = @@ERROR;
                END
            END
        END
        ELSE
        BEGIN
            SET @Error = 1;
        END
    END

    IF @Error = 0
    BEGIN
        COMMIT TRANSACTION RMS_DROP;
    END
    ELSE
    BEGIN
        ROLLBACK TRANSACTION RMS_DROP;
    END
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_DecreasePoisonPillsDurability]    Script Date: 07/25/2024 12:01:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_DecreasePoisonPillsDurability]
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION;

    -- Delete items with negative durability
    DELETE FROM tblSpecialItem1 
    WHERE ItemIndex = 67 AND ItemDurability < 0;

    -- Decrease durability of remaining items
    UPDATE tblSpecialItem1 
    SET ItemDurability = ItemDurability - 1 
    WHERE ItemIndex = 67;

    COMMIT TRANSACTION;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_ARMY_DECLAREWAR]    Script Date: 07/25/2024 12:01:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_ARMY_DECLAREWAR]  
    @ArmyID1 int,
    @ArmyID2 int,
    @WarKind1 int,
    @WarKind2 int,
    @WarPlace int,
    @WarStartHour int,
    @WarDuration int
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION RMS_ARMY_DECLAREWAR;

    DECLARE @AllianceID1 int;
    DECLARE @AllianceID2 int;
    DECLARE @CheckArmyID int;
    DECLARE @RowCount int;
    DECLARE @IsCorrectWar int = 1;
    DECLARE @IsAlliance1 int = 0;
    DECLARE @IsAlliance2 int = 0;
    DECLARE @GameID varchar(14);

    -- Check ownership based on war kind and place
    IF @WarKind1 = 2 OR @WarKind2 = 2
    BEGIN
        SELECT @CheckArmyID = ArmyID FROM tblAgitList1 WHERE AgitNumber = @WarPlace;
    END
    ELSE IF @WarKind1 = 4 OR @WarKind2 = 4
    BEGIN
        SELECT @CheckArmyID = ArmyID FROM tblArmyShopList1 WHERE ShopNumber = @WarPlace;
    END
    ELSE IF @WarKind1 = 6 OR @WarKind2 = 6
    BEGIN
        SELECT @CheckArmyID = ArmyID FROM tblArmyBase1;
    END

    -- Validate war conditions
    IF  (@WarKind1 = 0 AND @WarKind2 = 0) OR 
        ((@WarKind1 IN (2, 4, 6) AND @CheckArmyID = @ArmyID1) OR 
         (@WarKind2 IN (2, 4, 6) AND @CheckArmyID = @ArmyID2))
    BEGIN
        -- Check alliance and ongoing wars for ArmyID1
        SELECT @AllianceID1 = AllianceID FROM tblArmyAllianceList1 WHERE ArmyID = @ArmyID1;
        IF @@ROWCOUNT != 0
        BEGIN
            SET @IsAlliance1 = 1;
            SELECT @RowCount = COUNT(*) FROM tblArmyWarList1 WHERE ArmyID IN 
                (SELECT ArmyID FROM tblArmyAllianceList1 WHERE AllianceID = @AllianceID1);
            IF @RowCount != 0
            BEGIN
                SET @IsCorrectWar = 0;
            END
        END
        ELSE
        BEGIN
            SELECT @RowCount = COUNT(*) FROM tblArmyWarList1 WHERE ArmyID = @ArmyID1;
            IF @RowCount != 0
            BEGIN
                SET @IsCorrectWar = 0;
            END
        END

        -- Check alliance and ongoing wars for ArmyID2
        SELECT @AllianceID2 = AllianceID FROM tblArmyAllianceList1 WHERE ArmyID = @ArmyID2;
        IF @@ROWCOUNT != 0
        BEGIN
            SET @IsAlliance2 = 1;
            SELECT @RowCount = COUNT(*) FROM tblArmyWarList1 WHERE ArmyID IN 
                (SELECT ArmyID FROM tblArmyAllianceList1 WHERE AllianceID = @AllianceID2);
            IF @RowCount != 0
            BEGIN
                SET @IsCorrectWar = 0;
            END
        END
        ELSE
        BEGIN
            SELECT @RowCount = COUNT(*) FROM tblArmyWarList1 WHERE ArmyID = @ArmyID2;
            IF @RowCount != 0
            BEGIN
                SET @IsCorrectWar = 0;
            END
        END

        IF @IsCorrectWar = 1
        BEGIN
            DECLARE @WarBegin datetime;
            DECLARE @WarEnd datetime;
            SET @WarBegin = GETDATE();
            SET @WarBegin = DATEADD(hour, @WarStartHour, @WarBegin);
            SET @WarEnd = DATEADD(hour, @WarDuration, @WarBegin);

            -- Insert war details
            IF @WarKind1 = 6 OR @WarKind2 = 6
            BEGIN
                INSERT INTO tblArmyWarList1 (ArmyID, OppArmyID, WarBeginTime, WarEndTime, WarKind, WarPlace, WarState, WarScore, EntranceCode, ManagementCode, WarehouseCode, BulletinCode, InputCodeState)
                VALUES (@ArmyID1, @ArmyID2, @WarBegin, @WarEnd, @WarKind1, @WarPlace, 0, 0, '', '', '', '', 0);
                INSERT INTO tblArmyWarList1 (ArmyID, OppArmyID, WarBeginTime, WarEndTime, WarKind, WarPlace, WarState, WarScore, EntranceCode, ManagementCode, WarehouseCode, BulletinCode, InputCodeState)
                VALUES (@ArmyID2, @ArmyID1, @WarBegin, @WarEnd, @WarKind2, @WarPlace, 0, 0, '', '', '', '', 0);
            END
            ELSE
            BEGIN
                INSERT INTO tblArmyWarList1 (ArmyID, OppArmyID, WarBeginTime, WarEndTime, WarKind, WarPlace, WarState, WarScore, EntranceCode, ManagementCode, WarehouseCode, BulletinCode, InputCodeState)
                VALUES (@ArmyID1, @ArmyID2, @WarBegin, @WarEnd, @WarKind1, @WarPlace, 0, 1000, '', '', '', '', 0);
                INSERT INTO tblArmyWarList1 (ArmyID, OppArmyID, WarBeginTime, WarEndTime, WarKind, WarPlace, WarState, WarScore, EntranceCode, ManagementCode, WarehouseCode, BulletinCode, InputCodeState)
                VALUES (@ArmyID2, @ArmyID1, @WarBegin, @WarEnd, @WarKind2, @WarPlace, 0, 1000, '', '', '', '', 0);
            END
            EXEC RMS_ARMY_WRITEWARLOG @ArmyID1 = @ArmyID1, @ArmyID2 = @ArmyID2, @LogKind = 'WarDeclaration';

            DECLARE @FromArmyName varchar(10);
            DECLARE @FromArmyCommander varchar(14);
            DECLARE @ToArmyName varchar(10);
            SET @FromArmyName = '';
            SET @FromArmyCommander = '';
            SET @ToArmyName = '';
            SELECT @FromArmyName = Name, @FromArmyCommander = Commander FROM tblArmyList1 WHERE ID = @ArmyID1;
            SELECT @ToArmyName = Name FROM tblArmyList1 WHERE ID = @ArmyID2;

            DECLARE @MailContent varchar(400);
            -- Prepare the mail content based on war kind
            IF @WarKind1 = 2 OR @WarKind2 = 2
            BEGIN
                DECLARE @AgitChar varchar(30);
                IF @WarPlace > 20 AND @WarPlace <= 40
                BEGIN
                    SET @WarPlace = @WarPlace - 20;
                    SET @AgitChar = 'Freedom Camp Army Hall ' + CAST(@WarPlace AS varchar);
                END
                ELSE
                BEGIN
                    SET @AgitChar = 'Liberation Camp Army Hall ' + CAST(@WarPlace AS varchar);
                END

                SET @MailContent = @FromArmyName + ' Army Commander ' + @FromArmyCommander +
                                  ' has targeted ' + @ToArmyName + ' Army for war.' + CHAR(13) +
                                  'War will be:' + CHAR(13) +
                                  'From: ' + CONVERT(varchar, @WarBegin, 120) + CHAR(13) +
                                  'To:   ' + CONVERT(varchar, @WarEnd, 120) + CHAR(13) +
                                  'War target is ' + @ToArmyName + ' Army''s ' + @AgitChar + '.';
            END
            ELSE IF @WarKind1 = 0 AND @WarKind2 = 0
            BEGIN
                SET @MailContent = @FromArmyName + ' Army Commander ' + @FromArmyCommander +
                                  ' has targeted ' + @ToArmyName + ' Army for war.' + CHAR(13) +
                                  'War will be:' + CHAR(13) +
                                  'From: ' + CONVERT(varchar, @WarBegin, 120) + CHAR(13) +
                                  'To:   ' + CONVERT(varchar, @WarEnd, 120);
            END
            ELSE IF @WarKind1 = 4 OR @WarKind2 = 4
            BEGIN
                DECLARE @ShopOwner varchar(30);
                DECLARE @ShopNumber int;
                SET @ShopNumber = @WarPlace;
                SET @ShopOwner = '';
                IF @ShopNumber = 1
                BEGIN
                    SET @ShopOwner = 'Street 1 Shop';
                END
                ELSE IF @ShopNumber = 2
                BEGIN
                    SET @ShopOwner = 'Street 1 Weapon Shop';
                END
                ELSE IF @ShopNumber = 3
                BEGIN
                    SET @ShopOwner = 'Street 1 Runaway Girl';
                END
                ELSE IF @ShopNumber = 4
                BEGIN
                    SET @ShopOwner = 'Street 1 Old Lady 2';
                END
                ELSE IF @ShopNumber = 5
                BEGIN
                    SET @ShopOwner = 'Street 2 Store';
                END
                ELSE IF @ShopNumber = 6
                BEGIN
                    SET @ShopOwner = 'Street 2 Weapon Shop';
                END
                ELSE IF @ShopNumber = 7
                BEGIN
                    SET @ShopOwner = 'Street 2 Runaway Girl';
                END
                ELSE IF @ShopNumber = 8
                BEGIN
                    SET @ShopOwner = 'Street 3 Shop';
                END
                ELSE IF @ShopNumber = 9
                BEGIN
                    SET @ShopOwner = 'Street 3 Geographer';
                END
                ELSE IF @ShopNumber = 10
                BEGIN
                    SET @ShopOwner = 'Street 3 Old Lady 1';
                END
                ELSE IF @ShopNumber = 11
                BEGIN
                    SET @ShopOwner = 'Street 3 Runaway Girl';
                END
                ELSE IF @ShopNumber = 12
                BEGIN
                    SET @ShopOwner = 'Street 3 Old Lady 2';
                END
                ELSE IF @ShopNumber = 13
                BEGIN    
                    SET @ShopOwner = 'Downtown 1 Archeologist';
                END
                ELSE IF @ShopNumber = 14
                BEGIN
                    SET @ShopOwner = 'Downtown 1 Shop';
                END
                ELSE IF @ShopNumber = 15
                BEGIN
                    SET @ShopOwner = 'Downtown 2 Grocer 1';
                END
                ELSE IF @ShopNumber = 16
                BEGIN
                    SET @ShopOwner = 'Downtown 2 Grocer 2';
                END
                ELSE IF @ShopNumber = 17
                BEGIN    
                    SET @ShopOwner = 'Downtown 2 Weapon Shop 1';
                END
                ELSE IF @ShopNumber = 18
                BEGIN
                    SET @ShopOwner = 'Downtown 2 Archeologist';
                END
                ELSE IF @ShopNumber = 19
                BEGIN
                    SET @ShopOwner = 'Downtown 3 Weapon Shop 1';
                END
                ELSE IF @ShopNumber = 20
                BEGIN
                    SET @ShopOwner = 'Downtown 3 Weapon Shop 2';
                END
                ELSE IF @ShopNumber = 21
                BEGIN
                    SET @ShopOwner = 'Downtown 3 Geographer';
                END
                ELSE IF @ShopNumber = 22
                BEGIN
                    SET @ShopOwner = 'Downtown 4 Grocer';
                END
                ELSE IF @ShopNumber = 23
                BEGIN
                    SET @ShopOwner = 'Himalaya Shop';
                END
                ELSE IF @ShopNumber = 24
                BEGIN
                    SET @ShopOwner = 'Himalaya Food Shop';
                END

                SET @MailContent = @FromArmyName + ' Army Commander ' + @FromArmyCommander +
                                  ' has declared war on ' + @ToArmyName + '.' + CHAR(13) +
                                  'War will be:' + CHAR(13) +
                                  'From: ' + CONVERT(varchar, @WarBegin, 120) + CHAR(13) +
                                  'To:   ' + CONVERT(varchar, @WarEnd, 120) + CHAR(13) +
                                  'War location will be ' + @ShopOwner + ' that is owned by the ' + @ToArmyName + ' Army.';
            END
            ELSE IF @WarKind1 = 6 OR @WarKind2 = 6
            BEGIN
                SET @MailContent = @FromArmyName + ' Army Commander ' + @FromArmyCommander +
                                  ' has declared war on ' + @ToArmyName + '.' + CHAR(13) +
                                  'War will be:' + CHAR(13) +
                                  'From: ' + CONVERT(varchar, @WarBegin, 120) + CHAR(13) +
                                  'To:   ' + CONVERT(varchar, @WarEnd, 120) + CHAR(13) +
                                  'War location will be ' + @ToArmyName + ' Army''s HQ.';
            END

            -- Send mail notifications to alliance and army members
            IF @IsAlliance1 = 1
            BEGIN
                DECLARE ArmyMemberList CURSOR FOR
                    SELECT RegularSoldier FROM tblArmyMemberList1 WHERE ArmyID IN 
                        (SELECT ArmyID FROM tblArmyAllianceList1 WHERE AllianceID = @AllianceID1);
                OPEN ArmyMemberList;

                FETCH NEXT FROM ArmyMemberList INTO @GameID;
                WHILE @@FETCH_STATUS = 0 
                BEGIN
                    EXEC RMS_SENDMAIL @Recipient = @GameID, @Sender = 'ArmyAdmin', @Title = 'Declaration of War', @Line = 6, @MailContent = @MailContent, @Item = '';
                    FETCH NEXT FROM ArmyMemberList INTO @GameID;
                END

                CLOSE ArmyMemberList;
                DEALLOCATE ArmyMemberList;
            END
            ELSE
            BEGIN
                DECLARE ArmyMemberList CURSOR FOR
                    SELECT RegularSoldier FROM tblArmyMemberList1 WHERE ArmyID = @ArmyID1;
                OPEN ArmyMemberList;

                FETCH NEXT FROM ArmyMemberList INTO @GameID;
                WHILE @@FETCH_STATUS = 0 
                BEGIN
                    EXEC RMS_SENDMAIL @Recipient = @GameID, @Sender = 'ArmyAdmin', @Title = 'Declaration of War', @Line = 6, @MailContent = @MailContent, @Item = '';
                    FETCH NEXT FROM ArmyMemberList INTO @GameID;
                END

                CLOSE ArmyMemberList;
                DEALLOCATE ArmyMemberList;
            END

            IF @IsAlliance2 = 1
            BEGIN
                DECLARE ArmyMemberList CURSOR FOR
                    SELECT RegularSoldier FROM tblArmyMemberList1 WHERE ArmyID IN 
                        (SELECT ArmyID FROM tblArmyAllianceList1 WHERE AllianceID = @AllianceID2);
                OPEN ArmyMemberList;

                FETCH NEXT FROM ArmyMemberList INTO @GameID;
                WHILE @@FETCH_STATUS = 0 
                BEGIN
                    EXEC RMS_SENDMAIL @Recipient = @GameID, @Sender = 'ArmyAdmin', @Title = 'Declaration of War', @Line = 6, @MailContent = @MailContent, @Item = '';
                    FETCH NEXT FROM ArmyMemberList INTO @GameID;
                END

                CLOSE ArmyMemberList;
                DEALLOCATE ArmyMemberList;
            END
            ELSE
            BEGIN
                DECLARE ArmyMemberList CURSOR FOR
                    SELECT RegularSoldier FROM tblArmyMemberList1 WHERE ArmyID = @ArmyID2;
                OPEN ArmyMemberList;

                FETCH NEXT FROM ArmyMemberList INTO @GameID;
                WHILE @@FETCH_STATUS = 0 
                BEGIN
                    EXEC RMS_SENDMAIL @Recipient = @GameID, @Sender = 'ArmyAdmin', @Title = 'Declaration of War', @Line = 6, @MailContent = @MailContent, @Item = '';
                    FETCH NEXT FROM ArmyMemberList INTO @GameID;
                END

                CLOSE ArmyMemberList;
                DEALLOCATE ArmyMemberList;
            END

            -- Send mail notifications to alliance and army commanders
            IF @IsAlliance1 = 1
            BEGIN
                DECLARE ArmyCommanderList CURSOR FOR
                    SELECT Commander FROM tblArmyList1 WHERE ID IN 
                        (SELECT ArmyID FROM tblArmyAllianceList1 WHERE AllianceID = @AllianceID1);
                OPEN ArmyCommanderList;

                FETCH NEXT FROM ArmyCommanderList INTO @GameID;
                WHILE @@FETCH_STATUS = 0 
                BEGIN
                    EXEC RMS_SENDMAIL @Recipient = @GameID, @Sender = 'ArmyAdmin', @Title = 'Declaration of War', @Line = 6, @MailContent = @MailContent, @Item = '';
                    FETCH NEXT FROM ArmyCommanderList INTO @GameID;
                END

                CLOSE ArmyCommanderList;
                DEALLOCATE ArmyCommanderList;
            END
            ELSE
            BEGIN
                DECLARE ArmyCommanderList CURSOR FOR
                    SELECT Commander FROM tblArmyList1 WHERE ID = @ArmyID1;
                OPEN ArmyCommanderList;

                FETCH NEXT FROM ArmyCommanderList INTO @GameID;
                WHILE @@FETCH_STATUS = 0 
                BEGIN
                    EXEC RMS_SENDMAIL @Recipient = @GameID, @Sender = 'ArmyAdmin', @Title = 'Declaration of War', @Line = 6, @MailContent = @MailContent, @Item = '';
                    FETCH NEXT FROM ArmyCommanderList INTO @GameID;
                END

                CLOSE ArmyCommanderList;
                DEALLOCATE ArmyCommanderList;
            END

            IF @IsAlliance2 = 1
            BEGIN
                DECLARE ArmyCommanderList CURSOR FOR
                    SELECT Commander FROM tblArmyList1 WHERE ID IN 
                        (SELECT ArmyID FROM tblArmyAllianceList1 WHERE AllianceID = @AllianceID2);
                OPEN ArmyCommanderList;

                FETCH NEXT FROM ArmyCommanderList INTO @GameID;
                WHILE @@FETCH_STATUS = 0 
                BEGIN
                    EXEC RMS_SENDMAIL @Recipient = @GameID, @Sender = 'ArmyAdmin', @Title = 'Declaration of War', @Line = 6, @MailContent = @MailContent, @Item = '';
                    FETCH NEXT FROM ArmyCommanderList INTO @GameID;
                END

                CLOSE ArmyCommanderList;
                DEALLOCATE ArmyCommanderList;
            END
            ELSE
            BEGIN
                DECLARE ArmyCommanderList CURSOR FOR
                    SELECT Commander FROM tblArmyList1 WHERE ID = @ArmyID2;
                OPEN ArmyCommanderList;

                FETCH NEXT FROM ArmyCommanderList INTO @GameID;
                WHILE @@FETCH_STATUS = 0 
                BEGIN
                    EXEC RMS_SENDMAIL @Recipient = @GameID, @Sender = 'ArmyAdmin', @Title = 'Declaration of War', @Line = 6, @MailContent = @MailContent, @Item = '';
                    FETCH NEXT FROM ArmyCommanderList INTO @GameID;
                END

                CLOSE ArmyCommanderList;
                DEALLOCATE ArmyCommanderList;
            END
        END
    END

    COMMIT TRANSACTION RMS_ARMY_DECLAREWAR;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_ARMY_SENDARMYSHOPGAIN]    Script Date: 07/25/2024 12:01:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_ARMY_SENDARMYSHOPGAIN]
    @ShopNumber INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION RMS_ARMY_SENDARMYSHOPGAIN;

    DECLARE @ArmyID INT;
    DECLARE @Commander VARCHAR(14);
    DECLARE @ShopOwner VARCHAR(30);
    DECLARE @MailContent VARCHAR(200);
    DECLARE @RandomNumber INT;

    SELECT @ArmyID = ArmyID 
    FROM tblArmyShopList1 
    WHERE ShopNumber = @ShopNumber AND ArmyGain >= 1000000;
    
    IF @@ROWCOUNT != 0
    BEGIN
        SELECT @Commander = Commander 
        FROM tblArmyList1 
        WHERE ID = @ArmyID;
        
        IF @@ROWCOUNT != 0
        BEGIN
            SET @ShopOwner = 
                CASE 
                    WHEN @ShopNumber = 1 THEN 'Street 1 Shop Merchant'
                    WHEN @ShopNumber = 2 THEN 'Street 1 Weapon Shop Merchant'
                    WHEN @ShopNumber = 3 THEN 'Street 1 Runaway Girl'
                    WHEN @ShopNumber = 4 THEN 'Street 1 Old Lady 2'
                    WHEN @ShopNumber = 5 THEN 'Street 2 Store Merchant'
                    WHEN @ShopNumber = 6 THEN 'Street 2 Weapon Shop Merchant'
                    WHEN @ShopNumber = 7 THEN 'Street 2 Runaway Girl'
                    WHEN @ShopNumber = 8 THEN 'Street 3 Store Merchant'
                    WHEN @ShopNumber = 9 THEN 'Street 3 Geographer'
                    WHEN @ShopNumber = 10 THEN 'Street 3 Old Lady1'
                    WHEN @ShopNumber = 11 THEN 'Street 3 Runaway Girl'
                    WHEN @ShopNumber = 12 THEN 'Street 3 Old Lady 2'
                    WHEN @ShopNumber = 13 THEN 'Downtown 1 Archeologist'
                    WHEN @ShopNumber = 14 THEN 'Downtown 1 Watchman'
                    WHEN @ShopNumber = 15 THEN 'Downtown 2 Shop1 Merchant'
                    WHEN @ShopNumber = 16 THEN 'Downtown 2 Store 2 Merchant'
                    WHEN @ShopNumber = 17 THEN 'Downtown 2 Weapon Shop 1 Merchant'
                    WHEN @ShopNumber = 18 THEN 'Downtown 2 Archeologist'
                    WHEN @ShopNumber = 19 THEN 'Downtown 3 Weapon Shop 1 Merchant'
                    WHEN @ShopNumber = 20 THEN 'Downtown 3 Weapon Shop 3 Merchant'
                    WHEN @ShopNumber = 21 THEN 'Downtown 3 Geographer'
                    WHEN @ShopNumber = 22 THEN 'Downtown 4 Store Merchant'
                    WHEN @ShopNumber = 23 THEN 'Himalaya Shop Merchant'
                    WHEN @ShopNumber = 24 THEN 'Himalaya Food Shop Merchant'
                    ELSE 'Unknown Shop Owner'
                END;

            SET @MailContent = 
                'Hello. I am the ' + @ShopOwner + '. ' +
                'I have sent you the earnings from the shop ' +
                'for protecting it. Please continue using your ' +
                'strength to protect the shop.';

            DECLARE @RowCount INT;
            DECLARE @MailDate DATETIME;
            SET @MailDate = CAST(CONVERT(VARCHAR, GETDATE(), 120) AS DATETIME);

            SELECT @RowCount = COUNT(*) 
            FROM tblMail1 
            WHERE Time = @MailDate AND Recipient = @Commander;

            IF @RowCount = 0
            BEGIN
                INSERT INTO tblMail1 (Time, Recipient, Sender, ReadOrNot, Title, Line, Content, Item) 
                VALUES (@MailDate, @Commander, 'ShopOwner', 0, 'Pay Shop Tax', 4, @MailContent, '0:5-0/1000000.');
            END
            ELSE
            BEGIN
                SELECT @MailDate = DATEADD(SECOND, 1, MAX(Time)) 
                FROM tblMail1 
                WHERE Recipient = @Commander;

                INSERT INTO tblMail1 (Time, Recipient, Sender, ReadOrNot, Title, Line, Content, Item) 
                VALUES (@MailDate, @Commander, 'ShopOwner', 0, 'Pay Shop Tax', 4, @MailContent, '0:5-0/1000000.');
            END

            IF @@ERROR = 0
            BEGIN
                UPDATE tblArmyShopList1 
                SET ArmyGain = ArmyGain - 1000000 
                WHERE ShopNumber = @ShopNumber;

                SET @RandomNumber = RAND() * 100000000;
                SET @RandomNumber = @RandomNumber % 1000;

                IF @RandomNumber >= 999
                BEGIN
                    DECLARE @ItemNumber INT;
                    SET @RandomNumber = RAND() * 100000000;
                    SET @ItemNumber = @RandomNumber % 8;

                    INSERT INTO tblSpecialItem1 (ItemKind, ItemIndex, ItemDurability, Position, Map, X, Y, TileKind, GameID, WindowKind, WindowIndex, MiscTime)
                    SELECT 6, 
                           CASE @ItemNumber
                               WHEN 0 THEN 1
                               WHEN 1 THEN 2
                               WHEN 2 THEN 10
                               WHEN 3 THEN 11
                               WHEN 4 THEN 15
                               WHEN 5 THEN 24
                               WHEN 6 THEN 26
                               WHEN 7 THEN 28
                           END,
                           4, 
                           2, 
                           1, 
                           100, 
                           100, 
                           1, 
                           @Commander, 
                           100, 
                           1, 
                           @MailDate;
                END
            END
        END
    END

    COMMIT TRANSACTION RMS_ARMY_SENDARMYSHOPGAIN;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_ARMY_SENDARMYBASEGAIN]    Script Date: 07/25/2024 12:01:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_ARMY_SENDARMYBASEGAIN]
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION RMS_ARMY_SENDARMYBASEGAIN;

    DECLARE @ArmyID INT;
    DECLARE @Commander VARCHAR(14);
    DECLARE @MailContent VARCHAR(200);
    DECLARE @RandomNumber INT;

    SELECT @ArmyID = ArmyID 
    FROM tblArmyBase1 
    WHERE ArmyGain >= 10000000;

    IF @@ROWCOUNT != 0 AND @ArmyID > 0
    BEGIN
        SELECT @Commander = Commander 
        FROM tblArmyList1 
        WHERE ID = @ArmyID;

        IF @@ROWCOUNT != 0
        BEGIN
            SET @MailContent = 'Hello, I am the Army Administrator. ' +
                               'I am sending you a portion of the tax from your Army hall and shop rent.';

            DECLARE @RowCount INT;
            DECLARE @MailDate DATETIME;
            SET @MailDate = CAST(CONVERT(VARCHAR, GETDATE(), 120) AS DATETIME);

            SELECT @RowCount = COUNT(*) 
            FROM tblMail1 
            WHERE Time = @MailDate AND Recipient = @Commander;

            IF @RowCount = 0
            BEGIN
                INSERT INTO tblMail1 (Time, Recipient, Sender, ReadOrNot, Title, Line, Content, Item) 
                VALUES (@MailDate, @Commander, 'ArmyAdmin', 0, 'Shop and Army hall tax payment', 5, @MailContent, '0:5-0/10000000.');
            END
            ELSE
            BEGIN
                SELECT @MailDate = DATEADD(SECOND, 1, MAX(Time)) 
                FROM tblMail1 
                WHERE Recipient = @Commander;
                
                INSERT INTO tblMail1 (Time, Recipient, Sender, ReadOrNot, Title, Line, Content, Item) 
                VALUES (@MailDate, @Commander, 'ArmyAdmin', 0, 'Shop and Army hall tax payment', 5, @MailContent, '0:5-0/10000000.');
            END

            IF @@ERROR = 0
            BEGIN
                UPDATE tblArmyBase1 
                SET ArmyGain = ArmyGain - 10000000;

                SET @RandomNumber = RAND() * 100000000;
                SET @RandomNumber = @RandomNumber % 1000;

                IF @RandomNumber >= 998
                BEGIN
                    DECLARE @ItemNumber INT;
                    SET @RandomNumber = RAND() * 1000000;
                    SET @ItemNumber = @RandomNumber % 8;

                    IF @ItemNumber = 0
                    BEGIN
                        INSERT INTO tblSpecialItem1 (ItemKind, ItemIndex, ItemDurability, Position, Map, X, Y, TileKind, GameID, WindowKind, WindowIndex, MiscTime) 
                        VALUES (6, 1, 4, 2, 1, 100, 100, 1, @Commander, 100, 1, @MailDate);
                    END
                    ELSE IF @ItemNumber = 1
                    BEGIN
                        INSERT INTO tblSpecialItem1 (ItemKind, ItemIndex, ItemDurability, Position, Map, X, Y, TileKind, GameID, WindowKind, WindowIndex, MiscTime) 
                        VALUES (6, 2, 4, 2, 1, 100, 100, 1, @Commander, 100, 1, @MailDate);
                    END
                    ELSE IF @ItemNumber = 2
                    BEGIN
                        INSERT INTO tblSpecialItem1 (ItemKind, ItemIndex, ItemDurability, Position, Map, X, Y, TileKind, GameID, WindowKind, WindowIndex, MiscTime) 
                        VALUES (6, 10, 4, 2, 1, 100, 100, 1, @Commander, 100, 1, @MailDate);
                    END
                    ELSE IF @ItemNumber = 3
                    BEGIN
                        INSERT INTO tblSpecialItem1 (ItemKind, ItemIndex, ItemDurability, Position, Map, X, Y, TileKind, GameID, WindowKind, WindowIndex, MiscTime) 
                        VALUES (6, 11, 4, 2, 1, 100, 100, 1, @Commander, 100, 1, @MailDate);
                    END
                    ELSE IF @ItemNumber = 4
                    BEGIN
                        INSERT INTO tblSpecialItem1 (ItemKind, ItemIndex, ItemDurability, Position, Map, X, Y, TileKind, GameID, WindowKind, WindowIndex, MiscTime) 
                        VALUES (6, 15, 4, 2, 1, 100, 100, 1, @Commander, 100, 1, @MailDate);
                    END
                    ELSE IF @ItemNumber = 5
                    BEGIN
                        INSERT INTO tblSpecialItem1 (ItemKind, ItemIndex, ItemDurability, Position, Map, X, Y, TileKind, GameID, WindowKind, WindowIndex, MiscTime) 
                        VALUES (6, 24, 4, 2, 1, 100, 100, 1, @Commander, 100, 1, @MailDate);
                    END
                    ELSE IF @ItemNumber = 6
                    BEGIN
                        INSERT INTO tblSpecialItem1 (ItemKind, ItemIndex, ItemDurability, Position, Map, X, Y, TileKind, GameID, WindowKind, WindowIndex, MiscTime) 
                        VALUES (6, 26, 4, 2, 1, 100, 100, 1, @Commander, 100, 1, @MailDate);
                    END
                    ELSE IF @ItemNumber = 7
                    BEGIN
                        INSERT INTO tblSpecialItem1 (ItemKind, ItemIndex, ItemDurability, Position, Map, X, Y, TileKind, GameID, WindowKind, WindowIndex, MiscTime) 
                        VALUES (6, 28, 4, 2, 1, 100, 100, 1, @Commander, 100, 1, @MailDate);
                    END
                END
            END
        END
    END

    COMMIT TRANSACTION RMS_ARMY_SENDARMYBASEGAIN;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_ARMY_RENTEMPTYAGIT]    Script Date: 07/25/2024 12:01:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_ARMY_RENTEMPTYAGIT]
    @ArmyID      INT,
    @AgitNumber  INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION RMS_ARMY_RENTEMPTYAGIT;

    DECLARE @RowCount INT;
    DECLARE @Camp INT;

    SELECT @RowCount = COUNT(*) 
    FROM tblAgitList1 
    WHERE AgitNumber = @AgitNumber;
    
    SELECT @Camp = Camp 
    FROM tblArmyList1 
    WHERE ID = @ArmyID;

    IF @RowCount = 0
    BEGIN
        IF (@Camp = 1 AND @AgitNumber > 0 AND @AgitNumber <= 20) 
           OR (@Camp = 2 AND @AgitNumber > 20 AND @AgitNumber <= 40)
        BEGIN
            DECLARE @currentDate DATETIME;
            SET @currentDate = GETDATE();
            
            DECLARE @expirationDate DATETIME;
            SET @expirationDate = DATEADD(MONTH, 100, @currentDate);

            INSERT INTO tblAgitList1 
                VALUES (@AgitNumber, @ArmyID, @currentDate, @expirationDate, 0, 0, 0);

            EXEC RMS_ARMY_WRITEAGITLOG 
                @AgitNumber = @AgitNumber,
                @LogKind = 'RentEmptyAgit';
        END
    END

    COMMIT TRANSACTION RMS_ARMY_RENTEMPTYAGIT;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_ARMY_REMOVESUBARMYMEMBER]    Script Date: 07/25/2024 12:01:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_ARMY_REMOVESUBARMYMEMBER]
    @Member    varchar(14),
    @Kind      tinyint        -- 0: Dismiss , 1:Secede
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION RMS_ARMY_REMOVESUBARMYMEMBER;

    IF @Kind = 0
    BEGIN
        DECLARE @SubArmyID INT;
        DECLARE @ArmyID INT;
        SELECT @ArmyID = ArmyID, @SubArmyID = ID 
        FROM tblArmyMemberList1 
        WHERE RegularSoldier = @Member;
        
        IF @@ROWCOUNT != 0 AND @SubArmyID != 0
        BEGIN
            DECLARE @ArmyName VARCHAR(10);
            DECLARE @SubArmyName VARCHAR(10);
            DECLARE @SubCommander VARCHAR(14);
            
            SELECT @ArmyName = r1.Name, @SubArmyName = r2.Name, @SubCommander = r2.SubCommander 
            FROM tblArmyList1 r1 
            JOIN tblSubArmyList1 r2 ON r1.ID = @ArmyID AND r2.ID = @SubArmyID;
            
            IF @@ROWCOUNT != 0
            BEGIN
                UPDATE tblArmyMemberList1 
                SET SubArmyID = 0 
                WHERE RegularSoldier = @Member;

                DECLARE @MailContent VARCHAR(200);
                SET @MailContent = @ArmyName + ' belongs to Army ' +
                                   @SubCommander + ' Lieutenant ' +
                                   @SubArmyName + ' has been dismissed from the Unit. ' +
                                   'For more information, contact the appropriate Army Lieutenant';

                EXEC RMS_SENDMAIL 
                    @Recipient = @Member,
                    @Sender = 'ArmyAdmin',
                    @Title = 'Army Lieutenant demotion',
                    @Line = 3,
                    @MailContent = @MailContent,
                    @Item = '';
            END
        END
    END
    ELSE IF @Kind = 1 
    BEGIN
        UPDATE tblArmyMemberList1 
        SET SubArmyID = 0 
        WHERE RegularSoldier = @Member;
    END

    COMMIT TRANSACTION RMS_ARMY_REMOVESUBARMYMEMBER;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_ARMY_REMOVESUBARMY]    Script Date: 07/25/2024 12:01:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_ARMY_REMOVESUBARMY]
    @SubCommander VARCHAR(14),
    @Kind TINYINT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION RMS_ARMY_REMOVESUBARMY;

    DECLARE @SubArmyID INT;
    DECLARE @ArmyID INT;

    SELECT @ArmyID = ArmyID, @SubArmyID = ID 
    FROM tblSubArmyList1 
    WHERE SubCommander = @SubCommander;

    IF @@ROWCOUNT != 0
    BEGIN
        DECLARE @Commander VARCHAR(14);
        DECLARE @ArmyName VARCHAR(10);
        DECLARE @Content VARCHAR(300);

        SELECT @ArmyName = Name, @Commander = Commander 
        FROM tblArmyList1 
        WHERE ID = @ArmyID;

        IF @Kind = 1
        BEGIN
            SET @Content = @Commander + ' Commander ' + @ArmyName + ' from the Army Lieutenant ' +
                            @SubCommander + ' has been demoted. All Unit members have become Free Agent ' +
                            'soldiers. For more information contact the appropriate Commander.';
        END
        ELSE IF @Kind = 0
        BEGIN
            SET @Content = @Commander + ' Commander ' + @ArmyName + ' Army Lieutenant ' +
                            @SubCommander + ' has ordered to disband the unit. All the members of this unit ' +
                            'will become Regular Soldiers. For more information, contact the appropriate Commander.';
        END

        DECLARE @GameID VARCHAR(14);
        DECLARE SubArmyMemberList CURSOR FOR
            SELECT RegularSoldier 
            FROM tblArmyMemberList1 
            WHERE SubArmyID = @SubArmyID;

        OPEN SubArmyMemberList;
        FETCH NEXT FROM SubArmyMemberList INTO @GameID;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            EXEC RMS_SENDMAIL @Recipient = @GameID, @Sender = ArmyAdmin, 
                @Title = 'Disband Army Unit', @Line = 3, @MailContent = @Content, @Item = '';
            FETCH NEXT FROM SubArmyMemberList INTO @GameID;
        END;

        CLOSE SubArmyMemberList;
        DEALLOCATE SubArmyMemberList;

        DELETE FROM tblSubArmyList1 
        WHERE ID = @SubArmyID;

        UPDATE tblArmyMemberList1 
        SET SubArmyID = 0 
        WHERE ArmyID = @ArmyID AND SubArmyID = @SubArmyID;
    END

    IF @@ERROR <> 0
    BEGIN
        ROLLBACK TRANSACTION RMS_ARMY_REMOVESUBARMY;
        RETURN;
    END

    COMMIT TRANSACTION RMS_ARMY_REMOVESUBARMY;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_ARMY_REMOVEHIREDSOLDIER]    Script Date: 07/25/2024 12:01:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_ARMY_REMOVEHIREDSOLDIER]
    @ArmyID INT,
    @HiredSoldier VARCHAR(14),
    @Kind TINYINT -- 0: Secede, 1: Dismiss
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION RMS_ARMY_REMOVEHIREDSOLDIER;

    DECLARE @ArmyName VARCHAR(10);
    DECLARE @Commander VARCHAR(14);
    DECLARE @CheckArmyID INT;

    SELECT @ArmyName = Name, @Commander = Commander 
    FROM tblArmyList1 
    WHERE ID = @ArmyID;

    IF @@ROWCOUNT != 0
    BEGIN
        SELECT @CheckArmyID = ArmyID 
        FROM tblHiredSoldierList1 
        WHERE HiredSoldier = @HiredSoldier;

        IF @@ROWCOUNT != 0 AND @CheckArmyID = @ArmyID
        BEGIN
            IF @Kind = 1
            BEGIN
                DECLARE @Content VARCHAR(200);
                SET @Content = @Commander + ' Commander(Lieutenant) ' +
                                @ArmyName + ' has been dismissed from the Army. ' +
                                'For more information contact the appropriate ' +
                                'Commander or Lieutenant.';
                
                EXEC RMS_SENDMAIL @Recipient = @HiredSoldier, @Sender = ArmyAdmin, 
                    @Title = 'Dismiss Hired Soldier', @Line = 4, @MailContent = @Content, @Item = '';
            END;

            DELETE FROM tblHiredSoldierList1 
            WHERE HiredSoldier = @HiredSoldier;
        END;
    END;

    IF @@ERROR <> 0
    BEGIN
        ROLLBACK TRANSACTION RMS_ARMY_REMOVEHIREDSOLDIER;
        RETURN;
    END

    COMMIT TRANSACTION RMS_ARMY_REMOVEHIREDSOLDIER;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_ARMY_EXTENDAGITEXPIRATION]    Script Date: 07/25/2024 12:01:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_ARMY_EXTENDAGITEXPIRATION]
    @AgitNumber int
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION RMS_ARMY_EXTENDAGITEXPIRATION;

    DECLARE @ExpirationDate datetime;

    SELECT @ExpirationDate = ExpirationDate FROM tblAgitList1 WHERE AgitNumber = @AgitNumber;
    IF @@ROWCOUNT != 0
    BEGIN
        SET @ExpirationDate = DATEADD(month, 1, @ExpirationDate);
        UPDATE tblAgitList1 SET ExpirationDate = @ExpirationDate WHERE AgitNumber = @AgitNumber;
        EXEC RMS_ARMY_WRITEAGITLOG @AgitNumber = @AgitNumber, @LogKind = 'AgitExpirationDateExtended';
    END

    COMMIT TRANSACTION RMS_ARMY_EXTENDAGITEXPIRATION;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_ARMY_EXTENDACTIVITYDURATION]    Script Date: 07/25/2024 12:01:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_ARMY_EXTENDACTIVITYDURATION]
    @ArmyID int
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION RMS_ARMY_EXTENDACTIVITYDURATION;

    DECLARE @ActivityPeriod datetime;

    SELECT @ActivityPeriod = ActivityPeriod FROM tblArmyList1 WHERE ID = @ArmyID;
    IF @@ROWCOUNT != 0
    BEGIN
        SET @ActivityPeriod = DATEADD(month, 1, @ActivityPeriod);
        UPDATE tblArmyList1 SET ActivityPeriod = @ActivityPeriod WHERE ID = @ArmyID;
        EXEC RMS_ARMY_WRITEARMYLOG @ArmyID = @ArmyID, @LogKind = 'ActivityPeriodExtended';
    END

    COMMIT TRANSACTION RMS_ARMY_EXTENDACTIVITYDURATION;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_ARMY_ENDWARRESULT]    Script Date: 07/25/2024 12:01:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_ARMY_ENDWARRESULT]
    @ArmyID1 int,
    @ArmyID2 int,
    @Kind int
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION RMS_ARMY_ENDWARRESULT;

    DECLARE @ArmyName1 varchar(10);
    DECLARE @Commander1 varchar(14);
    DECLARE @ArmyName2 varchar(10);
    DECLARE @Commander2 varchar(14);
    DECLARE @RowCount int;

    -- Fetch army details
    SELECT @ArmyName1 = Name, @Commander1 = Commander FROM tblArmyList1 WHERE ID = @ArmyID1;
    SELECT @ArmyName2 = Name, @Commander2 = Commander FROM tblArmyList1 WHERE ID = @ArmyID2;

    -- Check if there is any ongoing war
    SELECT @RowCount = COUNT(*) FROM tblArmyWarList1 WHERE ArmyID = @ArmyID1 OR ArmyID = @ArmyID2;
    IF @RowCount != 0
    BEGIN
        DECLARE @MailContent varchar(400);
        
        -- Set mail content based on the war result kind
        IF @Kind = 0
        BEGIN
            SET @MailContent = 'The war between ' + @ArmyName1 + ' Army and ' + @ArmyName2 + ' Army has ended in a draw.';
        END
        ELSE IF @Kind = 1
        BEGIN
            SET @MailContent = @ArmyName1 + ' Army has won the war against ' + @ArmyName2 + ' Army. ' + @ArmyName2 + ' has lost and has been disbanded.';
        END
        ELSE IF @Kind = 2
        BEGIN
            SET @MailContent = @ArmyName1 + ' Army has won the war against ' + @ArmyName2 + ' Army. ' + @ArmyName2 + ' has lost one Army hall.';
        END
        ELSE IF @Kind = 3
        BEGIN
            SET @MailContent = @ArmyName1 + ' Army has won the war against ' + @ArmyName2 + ' Army. ' + @ArmyName2 + ' has lost all of their army halls.';
        END
        ELSE IF @Kind = 4
        BEGIN
            SET @MailContent = @ArmyName1 + ' Army has won the war against ' + @ArmyName2 + ' Army. ' + @ArmyName2 + ' Army''s shop has been taken over by ' + @ArmyName1 + '.';
        END
        ELSE IF @Kind = 5
        BEGIN
            SET @MailContent = @ArmyName1 + ' Army has won the war against ' + @ArmyName2 + ' Army. ' + @ArmyName2 + ' Army has defended the shop from ' + @ArmyName1 + ' Army.';
        END
        ELSE IF @Kind = 6
        BEGIN
            SET @MailContent = @ArmyName2 + ' Army''s HQ has been seized by ' + @ArmyName1 + ' Army. War result is ' + @ArmyName2 + ' Army has been disbanded.';
        END
        ELSE IF @Kind = 7
        BEGIN
            SET @MailContent = @ArmyName1 + ' Army has seized the HQ. War result is ' + @ArmyName2 + ' Army has become Free Agent Army status.';
        END
        ELSE IF @Kind = 8
        BEGIN
            SET @MailContent = @ArmyName2 + ' Army was successful in defending the HQ. War result is ' + @ArmyName2 + ' Army has been disbanded.';
        END
        ELSE IF @Kind = 9
        BEGIN
            SET @MailContent = @ArmyName2 + ' Army is successful in defending the army HQ. War result is ' + @ArmyName2 + ' Army has lost all their army halls.';
        END
        ELSE IF @Kind = 10
        BEGIN
            SET @MailContent = @ArmyName1 + ' Army ' + @ArmyName2 + ' Army has seized the HQ. War result is ' + @ArmyName2 + ' Army has lost their HQ.';
        END
        ELSE IF @Kind = 11
        BEGIN
            SET @MailContent = @ArmyName2 + ' Army has surrendered. ' + @ArmyName1 + ' Army has won the war. ' + @ArmyName2 + ' Army has been disbanded.';
        END
        ELSE IF @Kind = 12
        BEGIN
            SET @MailContent = @ArmyName2 + ' Army has surrendered. ' + @ArmyName1 + ' Army has won the war. ' + @ArmyName2 + ' Army has lost one of their halls.';
        END
        ELSE IF @Kind = 13
        BEGIN
            SET @MailContent = @ArmyName2 + ' Army has surrendered. ' + @ArmyName1 + ' Army has won the war. ' + @ArmyName2 + ' Army has lost all of their halls.';
        END
        ELSE IF @Kind = 14
        BEGIN
            SET @MailContent = @ArmyName2 + ' Army has surrendered so ' + @ArmyName1 + ' Army has won the war. ' + @ArmyName1 + ' has won the war. ' + @ArmyName2 + ' Army''s shop has been seized.';
        END
        ELSE IF @Kind = 15
        BEGIN
            SET @MailContent = @ArmyName2 + ' Army has surrendered so ' + @ArmyName1 + ' Army has won the war. ' + @ArmyName1 + ' has won the war. ' + @ArmyName2 + ' Army was kept from seizing the shop.';
        END
        ELSE IF @Kind = 16
        BEGIN
            SET @MailContent = @ArmyName2 + ' Army has surrendered so ' + @ArmyName1 + ' Army has seized the HQ. War result is ' + @ArmyName2 + ' Army has been disbanded.';
        END
        ELSE IF @Kind = 17
        BEGIN
            SET @MailContent = @ArmyName2 + ' Army has surrendered so ' + @ArmyName1 + ' Army has seized the HQ. War result is ' + @ArmyName2 + ' Army has become Free Agent Army status.';
        END
        ELSE IF @Kind = 18
        BEGIN
            SET @MailContent = @ArmyName2 + ' Army has surrendered. ' + @ArmyName1 + ' Army has succeeded in defending the HQ. War result is ' + @ArmyName2 + ' Army has been disbanded.';
        END
        ELSE IF @Kind = 19
        BEGIN
            SET @MailContent = @ArmyName2 + ' Army has surrendered so ' + @ArmyName1 + ' Army has succeeded in defending the HQ. War result is ' + @ArmyName2 + ' Army has lost all their army halls.';
        END
        ELSE IF @Kind = 20
        BEGIN
            SET @MailContent = @ArmyName2 + ' Army has surrendered so ' + @ArmyName1 + ' Army has seized the HQ. War result is ' + @ArmyName2 + ' Army has lost the HQ.';
        END

        -- Log war result
        DECLARE @EndWarResult varchar(220);
        SET @EndWarResult = 'EndWarResult: ' + @MailContent;
        EXEC RMS_ARMY_WRITEWARLOG @ArmyID1 = @ArmyID1, @ArmyID2 = @ArmyID2, @LogKind = @EndWarResult;

        -- Remove war records
        DELETE FROM tblArmyWarList1 WHERE ArmyID = @ArmyID1 OR ArmyID = @ArmyID2;

        -- Notify members and commanders of the result
        DECLARE @GameID varchar(14);
        DECLARE ArmyMemberList CURSOR FOR
            SELECT RegularSoldier FROM tblArmyMemberList1 WHERE ArmyID = @ArmyID1 OR ArmyID = @ArmyID2;

        OPEN ArmyMemberList;
        FETCH NEXT FROM ArmyMemberList INTO @GameID;
        WHILE @@FETCH_STATUS = 0
        BEGIN
            EXEC RMS_SENDMAIL @Recipient = @GameID, @Sender = 'ArmyAdmin', @Title = 'Army War Result', @Line = 3, @MailContent = @MailContent, @Item = '';
            FETCH NEXT FROM ArmyMemberList INTO @GameID;
        END
        CLOSE ArmyMemberList;
        DEALLOCATE ArmyMemberList;

        EXEC RMS_SENDMAIL @Recipient = @Commander1, @Sender = 'ArmyAdmin', @Title = 'Army War Result', @Line = 3, @MailContent = @MailContent, @Item = '';
        EXEC RMS_SENDMAIL @Recipient = @Commander2, @Sender = 'ArmyAdmin', @Title = 'Army War Result', @Line = 3, @MailContent = @MailContent, @Item = '';
    END
    COMMIT TRANSACTION RMS_ARMY_ENDWARRESULT;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_ARMY_ENDWAR]    Script Date: 07/25/2024 12:01:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_ARMY_ENDWAR]
    @ArmyID1 int,
    @ArmyID2 int
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION RMS_ARMY_ENDWAR;

    -- Update war state to indicate the end of war
    UPDATE tblArmyWarList1 SET WarState = 4 WHERE (ArmyID = @ArmyID1 OR ArmyID = @ArmyID2);
    IF @@ROWCOUNT != 0
    BEGIN
        EXEC RMS_ARMY_WRITEWARLOG @ArmyID1 = @ArmyID1, @ArmyID2 = @ArmyID2, @LogKind = 'WarEnd';

        DECLARE @AllianceID1 int = 0;
        DECLARE @AllianceID2 int = 0;

        -- Handle hired soldier deletion for ArmyID1 and its alliance
        SELECT @AllianceID1 = AllianceID FROM tblArmyAllianceList1 WHERE ArmyID = @ArmyID1;
        IF @AllianceID1 = 0
        BEGIN
            DELETE FROM tblHiredSoldierList1 WHERE ArmyID = @ArmyID1;
        END
        ELSE
        BEGIN
            DELETE FROM tblHiredSoldierList1 WHERE ArmyID IN (SELECT ArmyID FROM tblArmyAllianceList1 WHERE AllianceID = @AllianceID1);
        END

        -- Handle hired soldier deletion for ArmyID2 and its alliance
        SELECT @AllianceID2 = AllianceID FROM tblArmyAllianceList1 WHERE ArmyID = @ArmyID2;
        IF @AllianceID2 = 0
        BEGIN
            DELETE FROM tblHiredSoldierList1 WHERE ArmyID = @ArmyID2;
        END
        ELSE
        BEGIN
            DELETE FROM tblHiredSoldierList1 WHERE ArmyID IN (SELECT ArmyID FROM tblArmyAllianceList1 WHERE AllianceID = @AllianceID2);
        END
    END

    COMMIT TRANSACTION RMS_ARMY_ENDWAR;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_ARMY_INSERTAGITWARCODE]    Script Date: 07/25/2024 12:01:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_ARMY_INSERTAGITWARCODE]
    @ArmyID int,
    @GameID varchar(14),
    @EntranceCode varchar(10),
    @ManagementCode varchar(10),
    @WarehouseCode varchar(10),
    @BulletinCode varchar(10)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION RMS_ARMY_INSERTAGITWARCODE;

    DECLARE @CheckEntranceCode varchar(10);
    DECLARE @CheckManagementCode varchar(10);
    DECLARE @CheckWarehouseCode varchar(10);
    DECLARE @CheckBulletinCode varchar(10);
    DECLARE @WarPlace int;
    DECLARE @WarPlaceChar varchar(30);
    DECLARE @Content varchar(400);
    SET @Content = '';

    SELECT @WarPlace = WarPlace,
           @CheckEntranceCode = EntranceCode,
           @CheckManagementCode = ManagementCode,
           @CheckWarehouseCode = WarehouseCode,
           @CheckBulletinCode = BulletinCode
    FROM tblArmyWarList1
    WHERE ArmyID = @ArmyID AND WarKind = 1 AND (WarState = 1 OR WarState = 3);

    IF @@ROWCOUNT != 0
    BEGIN
        IF @WarPlace > 20
        BEGIN
            SET @WarPlace = @WarPlace - 20;
            SET @WarPlaceChar = 'Signus Freedom Army Hall ' + CAST(@WarPlace AS varchar) + ' Floor';
        END
        ELSE
        BEGIN
            SET @WarPlaceChar = 'Signus Liberation Army Hall ' + CAST(@WarPlace AS varchar) + ' Floor';
        END

        IF @CheckEntranceCode = '' OR @CheckManagementCode = '' OR @CheckWarehouseCode = '' OR @CheckBulletinCode = ''
        BEGIN
            IF @EntranceCode != '' AND @ManagementCode != '' AND @WarehouseCode != '' AND @BulletinCode != ''
            BEGIN
                UPDATE tblArmyWarList1
                SET EntranceCode = @EntranceCode,
                    ManagementCode = @ManagementCode,
                    WarehouseCode = @WarehouseCode,
                    BulletinCode = @BulletinCode
                WHERE ArmyID = @ArmyID;

                SET @Content =
'As requested by Kasham, here are the codes to
capture the ' + @WarPlaceChar + ':

Army Hall Entry code:                ' + @EntranceCode + '
Army Management computer code:       ' + @ManagementCode + '
Warehouse Management Computer code:  ' + @WarehouseCode + '
Bulletin Board Computer code:        ' + @BulletinCode + '

Fight bravely and with honor!';
            END
        END
        ELSE
        BEGIN
            SET @Content =
'As requested by Kasham, here are the codes to
capture the ' + @WarPlaceChar + ':

Army Hall Entry code:         ' + @CheckEntranceCode + '
Army Management code:         ' + @CheckManagementCode + '
Warehouse Managment code:     ' + @CheckWarehouseCode + '
Bulletin Board Computer code: ' + @CheckBulletinCode + '

Fight bravely and with honor!';
        END
    END

    IF @Content != ''
    BEGIN
        EXEC RMS_SENDMAIL @Recipient = @GameID, @Sender = 'Kasham', @Title = 'Army Hall Access Codes', @Line = 9, @MailContent = @Content, @Item = '';
    END

    COMMIT TRANSACTION RMS_ARMY_INSERTAGITWARCODE;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_ARMY_INITIALIZEARMYBASE]    Script Date: 07/25/2024 12:01:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_ARMY_INITIALIZEARMYBASE]
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION RMS_ARMY_INITIALIZEARMYBASE;

    DELETE FROM tblArmyBase1;
    DELETE FROM tblArmyBaseGuardList1;
    UPDATE tblArmyList1 SET ArmyBaseScore = 0;

    DECLARE @BaseOpenDate datetime = '2001-1-1 12:00:00';
    DECLARE @BeginOpenWar datetime;

    IF @BaseOpenDate > GETDATE()
    BEGIN
        SET @BeginOpenWar = @BaseOpenDate;
    END
    ELSE
    BEGIN
        SET @BeginOpenWar = CAST(CONVERT(varchar, GETDATE(), 120) AS datetime);
    END

    INSERT INTO tblArmyBase1 (ArmyID, ControlBeginDate, AgitTaxRate) VALUES (0, @BeginOpenWar, 0);

    DECLARE @GuardNum INT;
    SET @GuardNum = 1;

    WHILE @GuardNum <= 24
    BEGIN
        DECLARE @X INT;
        DECLARE @Y INT;

        -- Adjust coordinates based on GuardNum
        IF @GuardNum IN (1, 2, 3)
        BEGIN
            SET @X = 8 + @GuardNum - 1;
            SET @Y = 17 - @GuardNum + 1;
        END
        ELSE IF @GuardNum IN (4, 5, 6)
        BEGIN
            SET @X = 89 + @GuardNum - 4;
            SET @Y = 16 + @GuardNum - 4;
        END
        -- Add more conditions here for other GuardNum values
        -- (similar logic to map X, Y values for remaining guard positions)

        INSERT INTO tblArmyBaseGuardList1 (GuardNumber, GuardKind, X, Y, HP)
        VALUES (@GuardNum, 61, @X, @Y, 42664050);

        SET @GuardNum = @GuardNum + 1;
    END

    EXEC RMS_ARMY_WRITEARMYBASELOG @LogKind = 'ArmyBaseInitialized';

    DECLARE @Commander varchar(14);
    DECLARE @MailContent varchar(1000);
    SET @MailContent = 
'I am the Army Administrator.
I have risked danger and peril to bring you this
message so that you may rise through the ranks to
help the Sun.

For unknown reasons the Army HQ has been closed
down.

' + CONVERT(varchar, @BeginOpenWar, 120) + '
If you wish to occupy the HQ from the start, you
will be the highest ranking army.

I will leave it all up to you.  I have great
trust in you.

' + CONVERT(varchar, @BeginOpenWar, 120) + '
Please remember this!  Only you can accomplish
this.';

    DECLARE BaseMailList CURSOR
    FOR SELECT Commander FROM tblArmyList1 WHERE ID IN (SELECT DISTINCT ArmyID FROM tblAgitList1);

    OPEN BaseMailList;

    FETCH NEXT FROM BaseMailList INTO @Commander;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        EXEC RMS_SENDMAIL @Recipient = @Commander, @Sender = 'ArmyAdmin', @Title = 'Army HQ Shut Down!!!', @Line = 15, @MailContent = @MailContent, @Item = '';
        FETCH NEXT FROM BaseMailList INTO @Commander;
    END

    CLOSE BaseMailList;
    DEALLOCATE BaseMailList;

    COMMIT TRANSACTION RMS_ARMY_INITIALIZEARMYBASE;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_ARMY_FINISHCREATEARMY]    Script Date: 07/25/2024 12:01:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_ARMY_FINISHCREATEARMY]
    @Camp tinyint, 
    @ID int
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION RMS_ARMY_FINISHCREATEARMY;

    DECLARE @ActivityDate datetime;
    DECLARE @CreateTime datetime;
    DECLARE @State int;

    SET @CreateTime = GETDATE();
    SET @ActivityDate = DATEADD(month, 1, @CreateTime);

    SELECT @State = State 
    FROM tblArmyList1 
    WHERE Camp = @Camp AND ID = @ID;

    IF @@ROWCOUNT != 0 AND @State < -1
    BEGIN
        UPDATE tblArmyList1 
        SET State = 1, CreateTime = @CreateTime, ActivityPeriod = @ActivityDate 
        WHERE Camp = @Camp AND ID = @ID;
        EXEC RMS_ARMY_WRITEARMYLOG @ArmyID = @ID, @LogKind = 'ArmyCreation';
    END

    COMMIT TRANSACTION RMS_ARMY_FINISHCREATEARMY;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_ARMY_CREATERESERVEARMY]    Script Date: 07/25/2024 12:01:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_ARMY_CREATERESERVEARMY]
    @Camp tinyint, 
    @Name varchar(10),
    @Commander varchar(14), 
    @Notice varchar(166)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION RMS_ARMY_CREATERESERVEARMY;

    DECLARE @ActivityDate datetime;
    DECLARE @CreateTime datetime;
    DECLARE @RowCount int;
    SET @CreateTime = GETDATE();

    SET @ActivityDate = DATEADD(day, 7, @CreateTime);

    SELECT @RowCount = COUNT(*) 
    FROM tblArmyList1 
    WHERE Name = @Name OR Commander = @Commander;

    IF @RowCount = 0
    BEGIN
        INSERT INTO tblArmyList1 (Mark, State, Camp, Name, Commander, Password, CreateTime, ActivityPeriod, Notice, ArmyBaseScore)
        VALUES (0, -1, @Camp, @Name, @Commander, '', @CreateTime, @ActivityDate, @Notice, 0);

        DECLARE @ID int;
        SELECT @ID = ID 
        FROM tblArmyList1 
        WHERE Commander = @Commander;

        IF @@ROWCOUNT != 0
        BEGIN
            EXEC RMS_ARMY_WRITEARMYLOG @ArmyID = @ID, @LogKind = 'ReserveArmyCreation';
        END
    END

    COMMIT TRANSACTION RMS_ARMY_CREATERESERVEARMY;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_ARMY_CREATEARMYFROMRSARMY]    Script Date: 07/25/2024 12:01:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_ARMY_CREATEARMYFROMRSARMY]
    @Camp tinyint, 
    @Commander varchar(14),
    @Password varchar(20),
    @Mark int
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION RMS_ARMY_CREATEARMYFROMRSARMY;
    
    DECLARE @RowCount int;
    SELECT @RowCount = COUNT(*) 
    FROM tblArmyList1 
    WHERE Mark = @Mark;

    IF @RowCount = 0
    BEGIN
        UPDATE tblArmyList1 
        SET State = -2, Camp = @Camp, Password = @Password, Mark = @Mark, Notice = '' 
        WHERE Commander = @Commander AND State = -1;

        DECLARE @ID int;
        SELECT @ID = ID 
        FROM tblArmyList1 
        WHERE Commander = @Commander;

        IF @@ROWCOUNT != 0
        BEGIN
            EXEC RMS_ARMY_WRITEARMYLOG @ArmyID = @ID, @LogKind = 'PublicArmyCreation';
        END        
    END

    COMMIT TRANSACTION RMS_ARMY_CREATEARMYFROMRSARMY;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_ARMY_CREATEARMY]    Script Date: 07/25/2024 12:01:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_ARMY_CREATEARMY]
    @Camp tinyint, 
    @Name varchar(10),
    @Password varchar(20),
    @Commander varchar(14), 
    @Mark int
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION RMS_ARMY_CREATEARMY;

    DECLARE @CheckVar int;
    SELECT @CheckVar = COUNT(*) 
    FROM tblArmyList1 
    WHERE Mark = @Mark OR Name = @Name;

    IF @CheckVar = 0
    BEGIN
        DECLARE @ActivityDate datetime;
        DECLARE @CreateTime datetime;
        SET @CreateTime = GETDATE();
        SET @ActivityDate = DATEADD(month, 1, @CreateTime);

        INSERT INTO tblArmyList1 (Mark, State, Camp, Name, Commander, Password, CreateTime, ActivityPeriod, Notice, ArmyBaseScore)
        VALUES (@Mark, -3, @Camp, @Name, @Commander, @Password, @CreateTime, @ActivityDate, '', 0);
        
        DECLARE @ID int;
        SELECT @ID = ID 
        FROM tblArmyList1 
        WHERE Commander = @Commander;
        
        IF @@ROWCOUNT != 0
        BEGIN
            EXEC RMS_ARMY_WRITEARMYLOG @ArmyID = @ID, @LogKind = 'DirectArmyCreation';
        END
    END

    COMMIT TRANSACTION RMS_ARMY_CREATEARMY;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_ARMY_CHANGESUBARMYCOMMANDER]    Script Date: 07/25/2024 12:01:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_ARMY_CHANGESUBARMYCOMMANDER]  
    @FromSubCommander varchar(14),
    @ToSubCommander varchar(14),
    @Password varchar(20)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION RMS_ARMY_CHANGESUBARMYCOMMANDER;

    DECLARE @SubArmyID int;
    DECLARE @ArmyID int;

    SELECT @ArmyID = ArmyID, @SubArmyID = ID 
    FROM tblSubArmyList1 
    WHERE SubCommander = @FromSubCommander;
    
    IF @@ROWCOUNT != 0 AND @SubArmyID > 0
    BEGIN
        DECLARE @ArmyName varchar(10);
        DECLARE @Commander varchar(14);
        SELECT @ArmyName = Name, @Commander = Commander 
        FROM tblArmyList1 
        WHERE ID = @ArmyID;

        IF @@ROWCOUNT != 0
        BEGIN
            DECLARE @Content varchar(200);
            SET @Content = @Commander + ' Commander ' + @ArmyName + ' Army''s Lieutenant ' + @FromSubCommander + ' has been changed to ' + @ToSubCommander + '. For more information contact the appropriate Army Commander.';

            DECLARE @GameID varchar(14);
            DECLARE SubArmyMemberList CURSOR FOR
                SELECT RegularSoldier 
                FROM tblArmyMemberList1 
                WHERE SubArmyID = @SubArmyID;
            
            OPEN SubArmyMemberList;

            FETCH NEXT FROM SubArmyMemberList INTO @GameID;
            WHILE @@FETCH_STATUS = 0 
            BEGIN
                EXEC RMS_SENDMAIL @Recipient = @GameID, @Sender = 'ArmyAdmin', @Title = 'Unit Lieutenant Change', @Line = 3, @MailContent = @Content, @Item = '';
                FETCH NEXT FROM SubArmyMemberList INTO @GameID;
            END

            CLOSE SubArmyMemberList;
            DEALLOCATE SubArmyMemberList;

            UPDATE tblSubArmyList1 
            SET SubCommander = @ToSubCommander, Password = @Password 
            WHERE SubCommander = @FromSubCommander;

            UPDATE tblArmyMemberList1 
            SET SubArmyID = @SubArmyID 
            WHERE RegularSoldier = @ToSubCommander;

            UPDATE tblArmyMemberList1 
            SET SubArmyID = 0 
            WHERE RegularSoldier = @FromSubCommander;
        END
    END

    COMMIT TRANSACTION RMS_ARMY_CHANGESUBARMYCOMMANDER;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_ARMY_CHANGESHOPOWNER]    Script Date: 07/25/2024 12:01:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_ARMY_CHANGESHOPOWNER]
    @ShopNumber int,
    @FromArmyID int,
    @ToArmyID int
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION RMS_ARMY_CHANGESHOPOWNER;

    DECLARE @ArmyID int;
    SELECT @ArmyID = ArmyID 
    FROM tblArmyShopList1 
    WHERE ShopNumber = @ShopNumber;
    
    IF @ArmyID = @FromArmyID
    BEGIN
        UPDATE tblArmyShopList1 
        SET ArmyID = @ToArmyID 
        WHERE ShopNumber = @ShopNumber;
        
        EXEC RMS_ARMY_WRITEARMYSHOPLOG @ShopNumber = @ShopNumber, @LogKind = 'DefeatInWar : ChangedShopOwner';
    END

    COMMIT TRANSACTION RMS_ARMY_CHANGESHOPOWNER;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_ARMY_CHANGEPERMISSION]    Script Date: 07/25/2024 12:01:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_ARMY_CHANGEPERMISSION] 
    @GameID varchar(14),
    @Permission int
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION RMS_ARMY_CHANGEPERMISSION;
    
    DECLARE @OrigPermission int;
    DECLARE @ArmyID int;
    SELECT @ArmyID = ArmyID, @OrigPermission = Permission 
    FROM tblSubArmyList1 
    WHERE SubCommander = @GameID;
    
    IF @@ROWCOUNT != 0 AND @Permission != @OrigPermission
    BEGIN
        DECLARE @Commander varchar(14);
        DECLARE @ArmyName varchar(10);
        SELECT @Commander = Commander, @ArmyName = Name 
        FROM tblArmyList1 
        WHERE ID = @ArmyID;
        
        UPDATE tblSubArmyList1 
        SET Permission = @Permission 
        WHERE SubCommander = @GameID;

        DECLARE @APM_RECRUIT varchar(4);
        DECLARE @APM_HIREDSOLDIER varchar(4);
        DECLARE @APM_ITEMMANAGEMENT varchar(4);
        DECLARE @APM_MONEYMANAGEMENT varchar(4);
        DECLARE @APM_ITEMBUYING varchar(4);
        DECLARE @APM_AGITMANAGEMENT varchar(4);

        SET @APM_RECRUIT = CASE WHEN @Permission & 1 != 0 THEN 'Grant' ELSE 'Seize' END;
        SET @APM_HIREDSOLDIER = CASE WHEN @Permission & 2 != 0 THEN 'Grant' ELSE 'Seize' END;
        SET @APM_ITEMMANAGEMENT = CASE WHEN @Permission & 4 != 0 THEN 'Grant' ELSE 'Seize' END;
        SET @APM_MONEYMANAGEMENT = CASE WHEN @Permission & 8 != 0 THEN 'Grant' ELSE 'Seize' END;
        SET @APM_ITEMBUYING = CASE WHEN @Permission & 16 != 0 THEN 'Grant' ELSE 'Seize' END;
        SET @APM_AGITMANAGEMENT = CASE WHEN @Permission & 32 != 0 THEN 'Grant' ELSE 'Seize' END;

        DECLARE @Content varchar(300);
        SET @Content = @ArmyName + ' Army Commander ' + @Commander + ' has your authority. New Soldier hire/fire ' + @APM_RECRUIT + ' Mercenary Soldier hire/dismiss ' + @APM_HIREDSOLDIER + ' Manage Item ' + @APM_ITEMMANAGEMENT + ' Management of Funds ' + @APM_MONEYMANAGEMENT + ' Purchase Item ' + @APM_ITEMBUYING + ' HQ/Army Hall Management ' + @APM_AGITMANAGEMENT + ' has been changed too. For more information please contact the appropriate Army Commander.';

        EXEC RMS_SENDMAIL @Recipient = @GameID, @Sender = 'ArmyAdmin', @Title = 'Lieutenant Authority Modified', @Line = 9, @MailContent = @Content, @Item = '';
    END

    COMMIT TRANSACTION RMS_ARMY_CHANGEPERMISSION;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_ARMY_CHANGEARMYCOMMANDER]    Script Date: 07/25/2024 12:01:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_ARMY_CHANGEARMYCOMMANDER]  
    @ArmyID int,
    @ToCommander varchar(14),
    @Password varchar(20)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION RMS_ARMY_CHANGEARMYCOMMANDER;

    DECLARE @CheckArmyID int;
    SELECT @CheckArmyID = ArmyID 
    FROM tblArmyMemberList1 
    WHERE RegularSoldier = @ToCommander;
    
    IF @@ROWCOUNT != 0 AND @CheckArmyID = @ArmyID
    BEGIN
        DECLARE @FromCommander varchar(14);
        DECLARE @ArmyName varchar(10);
        DECLARE @JoinTime datetime;
        DECLARE @SubArmyID int;

        SELECT @ArmyName = Name, @FromCommander = Commander, @JoinTime = CreateTime 
        FROM tblArmyList1 
        WHERE ID = @ArmyID;
        
        IF @@ROWCOUNT != 0
        BEGIN
            SELECT @SubArmyID = ID 
            FROM tblSubArmyList1 
            WHERE SubCommander = @FromCommander;
            
            IF @@ROWCOUNT = 0
            BEGIN    
                SET @SubArmyID = 0;
            END

            DELETE FROM tblArmyMemberList1 
            WHERE ArmyID = @ArmyID AND RegularSoldier = @ToCommander;
            
            UPDATE tblArmyList1 
            SET Commander = @ToCommander, Password = @Password 
            WHERE ID = @ArmyID;
            
            INSERT INTO tblArmyMemberList1 (RegularSoldier, ArmyID, SubArmyID, JoinTime)
            VALUES (@FromCommander, @ArmyID, @SubArmyID, @JoinTime);
            
            EXEC RMS_ARMY_WRITEARMYLOG @ArmyID = @ArmyID, @LogKind = 'CommanderChanged';

            DECLARE @Content varchar(200);
            SET @Content = @ArmyName + ' Army Commander ' + @FromCommander + ' has entrusted his position to ' + @ToCommander + '. For more information, contact the appropriate Army Commander.';

            DECLARE @GameID varchar(14);
            DECLARE ArmyMemberList CURSOR FOR
                SELECT RegularSoldier 
                FROM tblArmyMemberList1 
                WHERE ArmyID = @ArmyID;
            
            OPEN ArmyMemberList;

            FETCH NEXT FROM ArmyMemberList INTO @GameID;
            WHILE @@FETCH_STATUS = 0 
            BEGIN
                EXEC RMS_SENDMAIL @Recipient = @GameID, @Sender = 'ArmyAdmin', @Title = 'Commander Change', @Line = 3, @MailContent = @Content, @Item = '';
                FETCH NEXT FROM ArmyMemberList INTO @GameID;
            END

            CLOSE ArmyMemberList;
            DEALLOCATE ArmyMemberList;

            EXEC RMS_SENDMAIL @Recipient = @ToCommander, @Sender = 'ArmyAdmin', @Title = 'Commander Change', @Line = 3, @MailContent = @Content, @Item = '';
        END
    END

    COMMIT TRANSACTION RMS_ARMY_CHANGEARMYCOMMANDER;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_ARMY_CANCELCREATEARMY]    Script Date: 07/25/2024 12:01:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_ARMY_CANCELCREATEARMY]
    @Camp tinyint,
    @Commander varchar(14)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION RMS_ARMY_CANCELCREATEARMY;

    DECLARE @FindArmyState int;
    DECLARE @FindArmyID int;
    SET @FindArmyState = 0;
    SET @FindArmyID = 0;

    SELECT @FindArmyID = ID, @FindArmyState = State  
    FROM tblArmyList1 
    WHERE Commander = @Commander AND Camp = @Camp;

    IF @FindArmyState = -2 
    BEGIN
        EXEC RMS_ARMY_WRITEARMYLOG @ArmyID = @FindArmyID, @LogKind = 'CancelArmyCreation';
        UPDATE tblArmyList1 
        SET State = -1, Mark = 0 
        WHERE Commander = @Commander;
    END
    ELSE IF @FindArmyState = -3
    BEGIN
        EXEC RMS_ARMY_WRITEARMYLOG @ArmyID = @FindArmyID, @LogKind = 'CancelArmyCreation';
        DELETE FROM tblArmyList1 
        WHERE Commander = @Commander;
        
        DELETE FROM tblArmyMemberList1 
        WHERE ArmyID = @FindArmyID;
    END

    COMMIT TRANSACTION RMS_ARMY_CANCELCREATEARMY;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_ARMY_BREAKUPRESERVEARMY]    Script Date: 07/25/2024 12:01:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_ARMY_BREAKUPRESERVEARMY]
    @ArmyID int,
    @TimeOut tinyint  -- TimeOut = 1, BreakUpByCommander = 0
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION RMS_ARMY_BREAKUPRESERVEARMY;

    DECLARE @FindArmyState int;
    DECLARE @FindArmyID int;

    SELECT @FindArmyID = ID, @FindArmyState = State 
    FROM tblArmyList1 
    WHERE ID = @ArmyID;

    IF @@ROWCOUNT != 0 AND @FindArmyState = -1
    BEGIN
        IF @TimeOut = 1
        BEGIN
            DECLARE @Content varchar(200);
            SET @Content = 
'Hello.  This is the army administrator.  
We regret to inform you that you have been
unsuccessful in assembling the required core
members of your army in the given period of
time.  Please try again.';

            DECLARE @GameID varchar(14);
            DECLARE ArmyMemberList CURSOR FOR
                SELECT RegularSoldier 
                FROM tblArmyMemberList1 
                WHERE ArmyID = @ArmyID;
            
            OPEN ArmyMemberList;

            FETCH NEXT FROM ArmyMemberList INTO @GameID;
            WHILE @@FETCH_STATUS = 0 
            BEGIN
                EXEC RMS_SENDMAIL @Recipient = @GameID, @Sender = 'ArmyAdmin', @Title = 'Pending Army Formation', @Line = 3, @MailContent = @Content, @Item = '';
                FETCH NEXT FROM ArmyMemberList INTO @GameID;
            END

            CLOSE ArmyMemberList;
            DEALLOCATE ArmyMemberList;
            
            SELECT @GameID = Commander 
            FROM tblArmyList1 
            WHERE ID = @ArmyID;

            EXEC RMS_SENDMAIL @Recipient = @GameID, @Sender = 'ArmyAdmin', @Title = 'Pending Army Formation', @Line = 3, @MailContent = @Content, @Item = '';
            EXEC RMS_ARMY_WRITEARMYLOG @ArmyID = @ArmyID, @LogKind = 'BreakupReserveArmy: TimeOut';
        END
        ELSE
        BEGIN
            EXEC RMS_ARMY_WRITEARMYLOG @ArmyID = @ArmyID, @LogKind = 'BreakupReserveArmy';
        END

        DELETE FROM tblArmyList1 WHERE ID = @ArmyID;
        DELETE FROM tblArmyMemberList1 WHERE ArmyID = @ArmyID;
    END

    COMMIT TRANSACTION RMS_ARMY_BREAKUPRESERVEARMY;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_ARMY_BREAKARMYALLIANCE]    Script Date: 07/25/2024 12:01:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_ARMY_BREAKARMYALLIANCE] 
    @HostArmyID int,
    @ArmyID int
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION RMS_ARMY_BREAKARMYALLIANCE;

    DECLARE @AllianceID int;
    DECLARE @HostArmyName varchar(10);
    DECLARE @AllianceArmyName varchar(10);
    SET @HostArmyName = '';
    SET @AllianceArmyName = '';

    SELECT @HostArmyName = Name 
    FROM tblArmyList1 
    WHERE ID = @HostArmyID;

    SELECT @AllianceArmyName = Name 
    FROM tblArmyList1 
    WHERE ID = @ArmyID;

    SELECT @AllianceID = AllianceID 
    FROM tblArmyAllianceList1 
    WHERE ArmyID = @HostArmyID 
    AND bHost = 1;

    IF @@ROWCOUNT != 0
    BEGIN
        DECLARE @MailContent varchar(100);
        SET @MailContent = @HostArmyName + ' Army/' + @AllianceArmyName + ' Army Alliance has been dissolved.  Please contact the commander for more information.';

        DECLARE @Commander varchar(14);
        
        DECLARE AllianceCommanderList CURSOR FOR
            SELECT Commander 
            FROM tblArmyList1 
            WHERE ID IN (SELECT ArmyID FROM tblArmyAllianceList1 WHERE AllianceID = @AllianceID);

        OPEN AllianceCommanderList;

        FETCH NEXT FROM AllianceCommanderList INTO @Commander;
        WHILE @@FETCH_STATUS = 0 
        BEGIN
            EXEC RMS_SENDMAIL @Recipient = @Commander, @Sender = 'ArmyAdmin', @Title = 'Army Alliance Dissolution', @Line = 4, @MailContent = @MailContent, @Item = '';
            FETCH NEXT FROM AllianceCommanderList INTO @Commander;
        END

        CLOSE AllianceCommanderList;
        DEALLOCATE AllianceCommanderList;

        DELETE FROM tblArmyAllianceList1 
        WHERE ArmyID = @ArmyID 
        AND AllianceID = @AllianceID;

        DECLARE @RowCount int;
        SELECT @RowCount = COUNT(*) 
        FROM tblArmyAllianceList1 
        WHERE AllianceID = @AllianceID;

        IF @RowCount = 1
        BEGIN
            DELETE FROM tblArmyAllianceList1 
            WHERE ArmyID = @HostArmyID 
            AND AllianceID = @AllianceID;
        END
    END

    COMMIT TRANSACTION RMS_ARMY_BREAKARMYALLIANCE;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_ARMY_BEGINWAR]    Script Date: 07/25/2024 12:01:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_ARMY_BEGINWAR]
    @ArmyID1 int,
    @ArmyID2 int
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION RMS_ARMY_BEGINWAR;

    UPDATE tblArmyWarList1 
    SET WarState = WarState + 1 
    WHERE (ArmyID = @ArmyID1 OR ArmyID = @ArmyID2) 
    AND (WarState = 0 OR WarState = 2);

    IF @@ROWCOUNT != 0		
    BEGIN
        EXEC RMS_ARMY_WRITEWARLOG @ArmyID1 = @ArmyID1, @ArmyID2 = @ArmyID2, @LogKind = 'WarBegin';
    END

    COMMIT TRANSACTION RMS_ARMY_BEGINWAR;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_ARMY_BEGINCONTROLARMYSHOP]    Script Date: 07/25/2024 12:01:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_ARMY_BEGINCONTROLARMYSHOP]
    @ArmyID int,
    @ShopNumber int
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION RMS_ARMY_BEGINCONTROLARMYSHOP;

    DECLARE @RowCount int;
    SELECT @RowCount = COUNT(*) 
    FROM tblArmyShopList1 
    WHERE ShopNumber = @ShopNumber;

    IF @RowCount = 0
    BEGIN
        IF @ShopNumber > 0 AND @ShopNumber <= 24
        BEGIN
            INSERT INTO tblArmyShopList1 (ShopNumber, ArmyID, Tax, ArmyGain, BeginControl, TaxChanged)
            VALUES (@ShopNumber, @ArmyID, 0, 0, GETDATE(), '2001-01-01');
            EXEC RMS_ARMY_WRITEARMYSHOPLOG @ShopNumber = @ShopNumber, @LogKind = 'BeginControlEmptyShop';
        END
    END

    COMMIT TRANSACTION RMS_ARMY_BEGINCONTROLARMYSHOP;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_AppleEvent]    Script Date: 07/25/2024 12:01:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_AppleEvent] AS

DECLARE @PPills int, @GameID varchar(14)
SELECT @GameID = GameID, @PPills = COUNT(*) FROM tblSpecialItem1 WHERE GameID != '' AND ItemIndex = 43 GROUP BY GameID ORDER BY COUNT(*)
SELECT @GameID AS GameID, @PPills AS Apples

If @PPills > 20
DELETE FROM tblSpecialItem1 WHERE ItemIndex = 43 AND GameID = @GameID
GO
/****** Object:  StoredProcedure [dbo].[RMS_ADDSPECIALITEMX]    Script Date: 07/25/2024 12:01:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_ADDSPECIALITEMX]
	@ItemKind int,
	@ItemIndex int,
	@ItemDurability int,
	@AttackGrade int,
	@StrengthGrade int,
	@SpiritGrade int,
	@DexterityGrade int,
	@PowerGrade int,
	@Position int,
	@Map int,
	@X int,
	@Y int,
	@TileKind int,
	@bNeedCheckLimit int

AS

set nocount on

declare @ItemCountLimit int, @CurrentItemCount int

select @ItemCountLimit = 0

begin transaction

if @bNeedCheckLimit=1
begin
	select @ItemCountLimit = ItemCountLimit from tblSpecialItemLimit1 where ItemKind = @ItemKind and ItemIndex = @ItemIndex
	select @CurrentItemCount = @ItemCountLimit
	select @CurrentItemCount = count(*) from tblSpecialItem1 where ItemKind = @ItemKind and ItemIndex = @ItemIndex
	end
else
begin
	set @ItemCountLimit =1
	set @CurrentItemCount = 0
end


if @ItemCountLimit > @CurrentItemCount
begin
	insert tblSpecialItem1 (ItemKind, ItemIndex, ItemDurability, Position, Map, X, Y, TileKind, AttackGrade, StrengthGrade, SpiritGrade, DexterityGrade, PowerGrade) values (@ItemKind, @ItemIndex, @ItemDurability,@Position, @Map, @X, @Y, @TileKind, @AttackGrade, @StrengthGrade, @SpiritGrade, @DexterityGrade, @PowerGrade)
end

commit transaction
GO
/****** Object:  StoredProcedure [dbo].[RMS_ADDSPECIALITEM]    Script Date: 07/25/2024 12:01:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_ADDSPECIALITEM]
    @ItemKind int,
    @ItemIndex int,
    @ItemDurability int,
    @Position int,
    @Map int,
    @X int,
    @Y int,
    @TileKind int,
    @bNeedCheckLimit int
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ItemCountLimit int = 0, 
            @CurrentItemCount int, 
            @AttackGrade int = 0, 
            @Error int;

    BEGIN TRANSACTION;

    IF @bNeedCheckLimit = 1
    BEGIN
        SELECT @ItemCountLimit = ItemCountLimit 
        FROM tblSpecialItemLimit1 
        WHERE ItemKind = @ItemKind AND ItemIndex = @ItemIndex;

        SELECT @CurrentItemCount = COUNT(*)
        FROM tblSpecialItem1 
        WHERE ItemKind = @ItemKind 
          AND (
                (ItemIndex BETWEEN 100 AND 114 AND (ItemIndex = @ItemIndex OR ItemIndex = @ItemIndex + 20 OR ItemIndex = @ItemIndex + 40 OR ItemIndex = @ItemIndex + 60 OR ItemIndex = @ItemIndex + 80)) OR 
                (ItemIndex BETWEEN 120 AND 134 AND @AttackGrade = 1) OR 
                (ItemIndex BETWEEN 140 AND 154 AND @AttackGrade = 2) OR 
                (ItemIndex BETWEEN 160 AND 174 AND @AttackGrade = 3) OR 
                (ItemIndex BETWEEN 180 AND 194 AND @AttackGrade = 4) OR 
                (ItemIndex = @ItemIndex)
              );

        IF @ItemIndex BETWEEN 120 AND 134
        BEGIN
            SET @AttackGrade = 1;
        END
        ELSE IF @ItemIndex BETWEEN 140 AND 154
        BEGIN
            SET @AttackGrade = 2;
        END
        ELSE IF @ItemIndex BETWEEN 160 AND 174
        BEGIN
            SET @AttackGrade = 3;
        END
        ELSE IF @ItemIndex BETWEEN 180 AND 194
        BEGIN
            SET @AttackGrade = 4;
        END
    END
    ELSE
    BEGIN
        SET @ItemCountLimit = 1;
        SET @CurrentItemCount = 0;
    END

    IF @ItemCountLimit > @CurrentItemCount
    BEGIN
        IF @AttackGrade > 0
        BEGIN
            INSERT INTO tblSpecialItem1 (ItemKind, ItemIndex, ItemDurability, Position, Map, X, Y, TileKind, AttackGrade)
            VALUES (@ItemKind, @ItemIndex, @ItemDurability, @Position, @Map, @X, @Y, @TileKind, @AttackGrade);
        END
        ELSE
        BEGIN
            INSERT INTO tblSpecialItem1 (ItemKind, ItemIndex, ItemDurability, Position, Map, X, Y, TileKind)
            VALUES (@ItemKind, @ItemIndex, @ItemDurability, @Position, @Map, @X, @Y, @TileKind);
        END

        SET @Error = @@ERROR;
        IF @Error = 0
        BEGIN
            COMMIT TRANSACTION;
        END
        ELSE
        BEGIN
            ROLLBACK TRANSACTION;
        END
    END
    ELSE
    BEGIN
        ROLLBACK TRANSACTION;
    END
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_ARMY_ADDARMYINITMEMBER]    Script Date: 07/25/2024 12:01:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_ARMY_ADDARMYINITMEMBER]
    @ArmyID     int,
    @Member     varchar(14)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION RMS_ARMY_ADDARMYINITMEMBER;

    DECLARE @State int;

    SELECT @State = State FROM tblArmyList1 WHERE ID = @ArmyID;
    IF @@ROWCOUNT != 0 AND @State < 0
    BEGIN
        DECLARE @RowCount1 int;
        DECLARE @RowCount2 int;
        DECLARE @RowCount3 int;

        SELECT @RowCount1 = COUNT(*) FROM tblArmyList1 WHERE Commander = @Member;
        SELECT @RowCount2 = COUNT(*) FROM tblArmyMemberList1 WHERE RegularSoldier = @Member;
        SELECT @RowCount3 = COUNT(*) FROM tblHiredSoldierList1 WHERE HiredSoldier = @Member;
        
        IF @RowCount1 = 0 AND @RowCount2 = 0 AND @RowCount3 = 0
        BEGIN
            INSERT INTO tblArmyMemberList1
            VALUES (@Member, @ArmyID, 0, GETDATE());

            IF @State = -1
            BEGIN
                DECLARE @membercount int;
                SELECT @membercount = COUNT(*) FROM tblArmyMemberList1 WHERE ArmyID = @ArmyID;

                IF @@ROWCOUNT != 0 AND @membercount = 10
                BEGIN
                    DECLARE @Content varchar(200);
                    SET @Content = 'All core members of your pending army have been assembled.  Please proceed to the Army Hall Lobby and register as an official army.';
                    
                    DECLARE @Commander varchar(14);
                    SET @Commander = '';
                    SELECT @Commander = Commander FROM tblArmyList1 WHERE ID = @ArmyID;

                    EXEC RMS_SENDMAIL @Recipient = @Commander, @Sender = 'ArmyAdmin', @Title = 'Create Pending Army', @Line = 3, @MailContent = @Content, @Item = '';
                END
            END
        END
    END
    COMMIT TRANSACTION RMS_ARMY_ADDARMYINITMEMBER;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_SENDBATTLETICKETMAIL]    Script Date: 07/25/2024 12:01:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RMS_SENDBATTLETICKETMAIL]
	@GameID varchar(14),
	@Time datetime
AS

set nocount on

declare @MailCount int, @InsertMailError int, @InsertTickError int

set @MailCount = 0
set @InsertMailError = 1
set @InsertTickError = 1

begin transaction

select @MailCount = count(*) from tblMail1 where Recipient = @GameID and Time = @Time

while @MailCount > 0
begin

	set @MailCount = 0
	set @Time = dateadd(second, 1, @Time)
	select @MailCount = count(*) from tblMail1 where Recipient = @GameID and Time = @Time

end

insert tblMail1 (Time, Recipient, Sender, ReadOrNot, Title, Line, Content, Item) values(@Time, @GameID, 'Kasham', 0, 'Earned Entry Pass', 21, 'Congratulations.

I see that you have raised your character many
levels!

I have seen that you have the potential to become
the Sun.  Your potential continues to grow.

I am giving you an entry pass to the
BattleDimesion, where you can practice and test
your skills.  If you are able to conquer all the
other players in the BattleDimension you will
receive the coveted Power Pellets.

This BattleDimension entry pass is given
especially to you.  You create your own
opportunity.  Use the BattleDimension to increase
your honor and gain the strength and knowledge to
continue on the path towards the Sun!

You can succeed.

You will be contacted again in the future.', '')

select @InsertMailError = @@ERROR

insert tblSpecialItem1 (ItemKind, ItemIndex, ItemDurability, Position, Map, X, Y, TileKind, GameID, WindowKind, WindowIndex, MiscTime, CNT) values (6, 73, 4, 2, 1, 100, 100, 1, @GameID, 100, 0, @Time, 1)

select @InsertTickError = @@ERROR

If @InsertMailError = 0 and @InsertTickError = 0
begin
	commit transaction
end
else
begin
	rollback transaction
end
GO
/****** Object:  StoredProcedure [dbo].[RMS_SENDBATTLEPRIZETMAIL]    Script Date: 07/25/2024 12:01:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_SENDBATTLEPRIZETMAIL]
    @Sender varchar(14),
    @Recipient varchar(14),
    @Title varchar(80),
    @Content varchar(1000),
    @ItemKind int,
    @ItemIndex int,
    @ItemCount int
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @MailCount int;
    DECLARE @Time datetime;
    SET @MailCount = 0;
    SET @Time = CAST(CONVERT(varchar, GETDATE(), 120) AS datetime);

    IF @ItemCount > 100
    BEGIN
        SET @ItemCount = 100;
    END

    IF @ItemKind != 6
    BEGIN
        SET @ItemCount = 0;
    END

    BEGIN TRANSACTION;

    SELECT @MailCount = COUNT(*)
    FROM RedMoon.dbo.tblMail1
    WHERE Recipient = @Recipient AND Time = @Time;

    WHILE @MailCount > 0
    BEGIN
        SET @MailCount = 0;
        SET @Time = DATEADD(second, 1, @Time);
        SELECT @MailCount = COUNT(*)
        FROM RedMoon.dbo.tblMail1
        WHERE Recipient = @Recipient AND Time = @Time;
    END

    WHILE @ItemCount > 0
    BEGIN
        INSERT INTO RedMoon.dbo.tblSpecialItem1 (ItemKind, ItemIndex, ItemDurability, Position, Map, X, Y, TileKind, GameID, WindowKind, WindowIndex, MiscTime, AttackGrade, StrengthGrade, SpiritGrade, DexterityGrade, PowerGrade)
        VALUES (@ItemKind, @ItemIndex, 4, 2, 1, 100, 100, 1, @Recipient, 100, 0, @Time, 0, 0, 0, 0, 0);
        SET @ItemCount = @ItemCount - 1;
    END

    INSERT INTO RedMoon.dbo.tblMail1 (Time, Recipient, Sender, ReadOrNot, Title, Line, Content, Item)
    VALUES (@Time, @Recipient, @Sender, 0, @Title, 20, @Content, '');

    COMMIT TRANSACTION;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_EXCHANGE_SENDEXCHANGEGAIN]    Script Date: 07/25/2024 12:01:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_EXCHANGE_SENDEXCHANGEGAIN]
    @Seller varchar(14),
    @Money1 int,
    @Money2 int
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION RMS_EXCHANGE_SENDEXCHANGEGAIN;

    DECLARE @Money varchar(50);
    DECLARE @MailContent varchar(200);

    IF @Money2 > 0
    BEGIN
        SET @Money = '0:5-0/' + CAST(@Money1 AS varchar(15)) + '.1:5-0/' + CAST(@Money2 AS varchar(15)) + '.';
    END
    ELSE
    BEGIN
        SET @Money = '0:5-0/' + CAST(@Money1 AS varchar(15)) + '.';
    END

    SET @MailContent = 'An item you have offered for sale has been sold.
Here are the profits from that sale.
Thank you for doing business with us.';

    EXEC RMS_SENDMAIL 
        @Recipient = @Seller,
        @Sender = 'TradeShopOwner',
        @Title = 'Profits From Sale',
        @Line = 3,
        @MailContent = @MailContent,
        @Item = @Money;

    COMMIT TRANSACTION RMS_EXCHANGE_SENDEXCHANGEGAIN;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_EQUIPITEM]    Script Date: 07/25/2024 12:01:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_EQUIPITEM]
    @ItemKind int,
    @ItemIndex int,
    @ItemDurability int,
    @ItemAttackGrade int,
    @ItemStrengthGrade int,
    @ItemSpiritGrade int,
    @ItemDexterityGrade int,
    @ItemPowerGrade int,
    @GameID varchar(14),
    @FromPosition int,
    @FromWindowKind int,
    @FromWindowIndex int,
    @ToPosition int,
    @ToWindowKind int,
    @ToWindowIndex int
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @TempItemCount int;
    SET @TempItemCount = -1;

    BEGIN TRANSACTION;

    IF @FromWindowKind != 2 AND @ToWindowKind = 2 AND ((@ToWindowIndex >= 0 AND @ToWindowIndex < 14) OR (@ToWindowIndex = 100))
    BEGIN
        SET @TempItemCount = -1;

        IF @ToWindowIndex = 100
        BEGIN
            SELECT @TempItemCount = COUNT(*)
            FROM tblSpecialItem1
            WHERE Position = @ToPosition AND GameID = @GameID AND WindowKind = @ToWindowKind AND (WindowIndex = @ToWindowIndex OR WindowIndex = 5 OR WindowIndex = 7);
        END
        ELSE
        BEGIN
            IF @ToWindowIndex = 5 OR @ToWindowIndex = 7
            BEGIN
                SELECT @TempItemCount = COUNT(*)
                FROM tblSpecialItem1
                WHERE Position = @ToPosition AND GameID = @GameID AND WindowKind = @ToWindowKind AND (WindowIndex = @ToWindowIndex OR WindowIndex = 100);
            END
            ELSE
            BEGIN
                SELECT @TempItemCount = COUNT(*)
                FROM tblSpecialItem1
                WHERE Position = @ToPosition AND GameID = @GameID AND WindowKind = @ToWindowKind AND WindowIndex = @ToWindowIndex;
            END
        END

        IF @TempItemCount = 0
        BEGIN
            UPDATE tblSpecialItem1
            SET Position = @ToPosition, WindowKind = @ToWindowKind, WindowIndex = @ToWindowIndex
            WHERE ID IN (
                SELECT TOP 1 ID
                FROM tblSpecialItem1
                WHERE Position = @FromPosition AND GameID = @GameID AND WindowKind = @FromWindowKind AND WindowIndex = @FromWindowIndex
            );
        END
    END

    COMMIT TRANSACTION;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_ELECTCHAMPIONANDCLEANUPBATTLEZONE]    Script Date: 07/25/2024 12:01:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RMS_ELECTCHAMPIONANDCLEANUPBATTLEZONE]
    @ZoneIndex int,
    @Time datetime,
    @Today datetime
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @GameID varchar(14), @BillID varchar(14), @ServerIndex int, @TodaySendItemCount int;
    DECLARE @Error int, @ScoreCount int, @Win int, @Lose int, @Score int;

    SET @TodaySendItemCount = 1;
    SET @Error = 0;

    BEGIN TRANSACTION;

    -- Get champion and check item count
    SELECT TOP 1 @GameID = GameID, @BillID = BillID, @ServerIndex = ServerIndex
    FROM tblBattleArenaScore WITH (TABLOCKX)
    WHERE Win > 0 AND ZoneIndex = @ZoneIndex
    ORDER BY Win DESC, EndLevel DESC, SIGN(EndExperience), EndExperience DESC;

    IF @@ROWCOUNT > 0
    BEGIN
        SELECT @TodaySendItemCount = COUNT(*)
        FROM tblBattleArenaChampionLog
        WHERE GameID = @GameID AND BillID = @BillID AND Time >= @Today AND Time < DATEADD(day, 1, @Today) AND SendItem = 1;
        SET @Error = @@ERROR;

        IF @Error = 0
        BEGIN
            IF @TodaySendItemCount > 0
            BEGIN
                INSERT INTO tblBattleArenaChampionLog (ZoneIndex, GameID, BillID, ServerIndex, Time)
                VALUES (@ZoneIndex, @GameID, @BillID, @ServerIndex, @Time);
                SET @Error = @@ERROR;
            END
            ELSE
            BEGIN
                INSERT INTO tblBattleArenaChampionLog (ZoneIndex, GameID, BillID, ServerIndex, Time, SendItem, MailSent)
                VALUES (@ZoneIndex, @GameID, @BillID, @ServerIndex, @Time, 1, 1);
                SET @Error = @@ERROR;
            END
        END
    END

    -- Update battle scores
    DECLARE user_cursor CURSOR FOR
    SELECT GameID, BillID, ServerIndex, Win, Lose, Score
    FROM tblCurrentBattleArenaScore
    WHERE ZoneIndex = @ZoneIndex;

    OPEN user_cursor;
    FETCH NEXT FROM user_cursor INTO @GameID, @BillID, @ServerIndex, @Win, @Lose, @Score;

    WHILE @@FETCH_STATUS = 0 AND @Error = 0
    BEGIN
        SELECT @ScoreCount = COUNT(*)
        FROM tblBattleArenaScore
        WHERE GameID = @GameID AND BillID = @BillID AND ServerIndex = @ServerIndex;
        SET @Error = @@ERROR;

        IF @Error = 0
        BEGIN
            IF @ScoreCount = 0
            BEGIN
                INSERT INTO tblBattleArenaScore (GameID, BillID, ServerIndex, Win, Lose, Score)
                VALUES (@GameID, @BillID, @ServerIndex, @Win, @Lose, @Score);
                INSERT INTO redmoon.dbo.tblBattleArenaScore (GameID, BillID, ServerIndex, Win, Lose, Score)
                VALUES (@GameID, @BillID, @ServerIndex, @Win, @Lose, @Score);
                SET @Error = @@ERROR;
            END
            ELSE
            BEGIN
                UPDATE tblBattleArenaScore
                SET Win = Win + @Win, Lose = Lose + @Lose, Score = Score + @Score
                WHERE BillID = @BillID AND GameID = @GameID AND ServerIndex = @ServerIndex;
                UPDATE redmoon.dbo.tblBattleArenaScore
                SET Win = Win + @Win, Lose = Lose + @Lose, Score = Score + @Score
                WHERE BillID = @BillID AND GameID = @GameID AND ServerIndex = @ServerIndex;
                SET @Error = @@ERROR;
            END
            FETCH NEXT FROM user_cursor INTO @GameID, @BillID, @ServerIndex, @Win, @Lose, @Score;
        END
    END

    CLOSE user_cursor;
    DEALLOCATE user_cursor;

    -- Log and cleanup scores
    IF @Error = 0
    BEGIN
        INSERT INTO tblBattleZoneScoreLog (ZoneIndex, GameID, BillID, ServerIndex, Win, Lose, Score, NormalEnd, EndLevel, EndExperience)
        SELECT ZoneIndex, GameID, BillID, ServerIndex, Win, Lose, Score, NormalEnd, EndLevel, EndExperience
        FROM tblCurrentBattleZoneScore;
        
        DELETE FROM tblCurrentBattleZoneScore WHERE ZoneIndex = @ZoneIndex;

        INSERT INTO redmoon.dbo.tblBattleArenaScoreLog (ZoneIndex, GameID, BillID, ServerIndex, Win, Lose, Score, NormalEnd, EndLevel, EndExperience)
        SELECT ZoneIndex, GameID, BillID, ServerIndex, Win, Lose, Score, NormalEnd, EndLevel, EndExperience
        FROM redmoon.dbo.tblCurrentBattleZoneScore;

        DELETE FROM redmoon.dbo.tblCurrentBattleZoneScore WHERE ZoneIndex = @ZoneIndex;
        SET @Error = @@ERROR;
    END

    -- Send battle prize
    IF @Error = 0
    BEGIN
        EXEC redmoon.dbo.RMS_SENDBATTLEPRIZETMAIL 'Kasham', @GameID, 'Congratulations', 'You are the latest winner in the Battle Dimension! Congratulations! Here is your prize', 6, 197, 1;
        SET @Error = @@ERROR;
        
        IF @Error = 0
        BEGIN
            COMMIT TRANSACTION;
        END
        ELSE
        BEGIN
            ROLLBACK TRANSACTION;
        END
    END
    ELSE
    BEGIN
        ROLLBACK TRANSACTION;
    END
END;
GO
/****** Object:  StoredProcedure [dbo].[RMS_ARMY_ADDARMYSHOPGAIN]    Script Date: 07/25/2024 12:01:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_ARMY_ADDARMYSHOPGAIN]
    @ShopNumber int,
    @ArmyGainDiff int
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION RMS_ARMY_ADDARMYSHOPGAIN;

    DECLARE @ArmyGainAfter int;
    DECLARE @ArmyGainPrevious int;
    DECLARE @RowCount int;

    SELECT @RowCount = COUNT(*) FROM tblArmyShopList1 WHERE ShopNumber = @ShopNumber;
    
    IF @RowCount > 0
    BEGIN
        UPDATE tblArmyShopList1 
        SET ArmyGain = ArmyGain + @ArmyGainDiff 
        WHERE ShopNumber = @ShopNumber;

        SELECT @ArmyGainAfter = ArmyGain FROM tblArmyShopList1 WHERE ShopNumber = @ShopNumber;
        SET @ArmyGainPrevious = @ArmyGainAfter;

        IF @ArmyGainAfter > 1000000
        BEGIN
            EXEC RMS_ARMY_SENDARMYSHOPGAIN @ShopNumber = @ShopNumber;
            SELECT @ArmyGainAfter = ArmyGain FROM tblArmyShopList1 WHERE ShopNumber = @ShopNumber;
        END

        WHILE @ArmyGainAfter < @ArmyGainPrevious AND @ArmyGainAfter >= 1000000
        BEGIN
            SET @ArmyGainPrevious = @ArmyGainAfter;
            EXEC RMS_ARMY_SENDARMYSHOPGAIN @ShopNumber = @ShopNumber;
            SELECT @ArmyGainAfter = ArmyGain FROM tblArmyShopList1 WHERE ShopNumber = @ShopNumber;
        END
    END

    COMMIT TRANSACTION RMS_ARMY_ADDARMYSHOPGAIN;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_ARMY_ADDARMYBASEGAIN]    Script Date: 07/25/2024 12:01:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_ARMY_ADDARMYBASEGAIN]
    @ArmyGainDiff int
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION RMS_ARMY_ADDARMYBASEGAIN;

    DECLARE @ArmyGainAfter int;
    DECLARE @ArmyGainPrevious int;
    DECLARE @RowCount int;

    SELECT @RowCount = COUNT(*) FROM tblArmyBase1 WHERE ArmyID > 0;

    IF @RowCount > 0
    BEGIN
        UPDATE tblArmyBase1 SET ArmyGain = ArmyGain + @ArmyGainDiff;

        SELECT @ArmyGainAfter = ArmyGain FROM tblArmyBase1 WHERE ArmyID > 0;
        SET @ArmyGainPrevious = @ArmyGainAfter;

        IF @ArmyGainAfter > 1000000
        BEGIN
            EXEC RMS_ARMY_SENDARMYBASEGAIN;
            SELECT @ArmyGainAfter = ArmyGain FROM tblArmyBase1 WHERE ArmyID > 0;
        END

        WHILE @ArmyGainAfter < @ArmyGainPrevious AND @ArmyGainAfter >= 1000000
        BEGIN
            SET @ArmyGainPrevious = @ArmyGainAfter;
            EXEC RMS_ARMY_SENDARMYBASEGAIN;
            SELECT @ArmyGainAfter = ArmyGain FROM tblArmyBase1 WHERE ArmyID > 0;
        END
    END

    COMMIT TRANSACTION RMS_ARMY_ADDARMYBASEGAIN;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_ARMY_ADJUSTARMYWAR]    Script Date: 07/25/2024 12:01:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_ARMY_ADJUSTARMYWAR]
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION RMS_ARMY_ADJUSTARMYWAR;

    DECLARE curArmyWarTable1 CURSOR FOR
        SELECT ArmyID, OppArmyID, WarState 
        FROM tblArmyWarList1 
        WHERE (WarState = 0 OR WarState = 2) 
        AND WarBeginTime <= GETDATE();
    
    OPEN curArmyWarTable1;
    
    DECLARE @WarArmyID int;
    DECLARE @WarOppArmyID int;
    DECLARE @WarState int;

    FETCH NEXT FROM curArmyWarTable1 INTO @WarArmyID, @WarOppArmyID, @WarState;
    WHILE @@FETCH_STATUS = 0 
    BEGIN
        EXEC RMS_ARMY_BEGINWAR @ArmyID1 = @WarArmyID, @ArmyID2 = @WarOppArmyID;
        FETCH NEXT FROM curArmyWarTable1 INTO @WarArmyID, @WarOppArmyID, @WarState;
    END

    CLOSE curArmyWarTable1;
    DEALLOCATE curArmyWarTable1;

    DECLARE curArmyWarTable2 CURSOR FOR
        SELECT ArmyID, WarState 
        FROM tblArmyWarList1 
        WHERE (WarState = 1 OR WarState = 3) 
        AND WarEndTime <= GETDATE();
    
    OPEN curArmyWarTable2;

    FETCH NEXT FROM curArmyWarTable2 INTO @WarArmyID, @WarState;
    WHILE @@FETCH_STATUS = 0 
    BEGIN
        UPDATE tblArmyWarList1 
        SET WarState = 4 
        WHERE ArmyID = @WarArmyID;
        FETCH NEXT FROM curArmyWarTable2 INTO @WarArmyID, @WarState;
    END

    CLOSE curArmyWarTable2;
    DEALLOCATE curArmyWarTable2;

    COMMIT TRANSACTION RMS_ARMY_ADJUSTARMYWAR;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_ARMY_REMOVEARMYSHOP]    Script Date: 07/25/2024 12:01:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_ARMY_REMOVEARMYSHOP]
    @ArmyID INT,
    @Kind TINYINT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION RMS_ARMY_REMOVEARMYSHOP;

    DECLARE @ShopNumber INT;
    DECLARE ArmyShopList CURSOR FOR
        SELECT ShopNumber 
        FROM tblArmyShopList1 
        WHERE ArmyID = @ArmyID;

    OPEN ArmyShopList;
    FETCH NEXT FROM ArmyShopList INTO @ShopNumber;

    WHILE @@FETCH_STATUS = 0 
    BEGIN
        IF @Kind = 1
        BEGIN
            EXEC RMS_ARMY_WRITEARMYSHOPLOG @ShopNumber = @ShopNumber, @LogKind = 'DefeatInWar: AllShopLost';
        END
        ELSE IF @Kind = 2
        BEGIN
            EXEC RMS_ARMY_WRITEARMYSHOPLOG @ShopNumber = @ShopNumber, @LogKind = 'RoamingArmyState: AllShopLost';
        END
        ELSE IF @Kind = 3
        BEGIN
            EXEC RMS_ARMY_WRITEARMYSHOPLOG @ShopNumber = @ShopNumber, @LogKind = 'BreakUpArmy: AllShopLost';
        END
        ELSE IF @Kind = 4
        BEGIN
            EXEC RMS_ARMY_WRITEARMYSHOPLOG @ShopNumber = @ShopNumber, @LogKind = 'BeginControlBase: AllShopLost';
        END;

        DECLARE @OppArmyID INT;
        SELECT @OppArmyID = OppArmyID 
        FROM tblArmyWarList1 
        WHERE ArmyID = @ArmyID AND (WarKind = 3 OR WarKind = 4) AND WarPlace = @ShopNumber;

        IF @@ROWCOUNT > 0
        BEGIN
            EXEC RMS_ARMY_ENDWAR @ArmyID1 = @ArmyID, @ArmyID2 = @OppArmyID;
            EXEC RMS_ARMY_ENDWARRESULT @ArmyID1 = @ArmyID, @ArmyID2 = @OppArmyID, @Kind = 0;
        END;

        FETCH NEXT FROM ArmyShopList INTO @ShopNumber;
    END;

    CLOSE ArmyShopList;
    DEALLOCATE ArmyShopList;

    DELETE FROM tblArmyShopList1 
    WHERE ArmyID = @ArmyID;

    IF @@ERROR <> 0
    BEGIN
        ROLLBACK TRANSACTION RMS_ARMY_REMOVEARMYSHOP;
        RETURN;
    END

    COMMIT TRANSACTION RMS_ARMY_REMOVEARMYSHOP;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_ARMY_REMOVEARMYMEMBER]    Script Date: 07/25/2024 12:01:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_ARMY_REMOVEARMYMEMBER]
    @ArmyID INT,
    @Member VARCHAR(14),
    @Kind TINYINT -- 0: Secede, 1: Dismiss
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION RMS_ARMY_REMOVEARMYMEMBER;

    DECLARE @ArmyName VARCHAR(10);
    DECLARE @Commander VARCHAR(14);
    DECLARE @SubArmyID INT;
    DECLARE @CheckArmyID INT;

    SELECT @ArmyName = Name, @Commander = Commander 
    FROM tblArmyList1 
    WHERE ID = @ArmyID;

    IF @@ROWCOUNT != 0
    BEGIN
        SELECT @CheckArmyID = ArmyID, @SubArmyID = SubArmyID 
        FROM tblArmyMemberList1 
        WHERE RegularSoldier = @Member;

        IF @@ROWCOUNT != 0 AND @CheckArmyID = @ArmyID
        BEGIN
            IF @SubArmyID != 0
            BEGIN
                EXEC RMS_ARMY_REMOVESUBARMY @SubCommander = @Member, @Kind = @Kind;
            END;

            EXEC RMS_ARMY_ADDREJOINSANCTION @GameID = @Member;

            IF @Kind = 1
            BEGIN
                DECLARE @Content VARCHAR(200);
                SET @Content = @Commander + ' Commander(Lieutenant) ' +
                                @ArmyName + ' You have been dismissed. ' +
                                'For more information, contact the appropriate Army Commander or Lieutenant.';

                EXEC RMS_SENDMAIL @Recipient = @Member, @Sender = ArmyAdmin, 
                    @Title = 'Dismiss New Soldier', @Line = 4, @MailContent = @Content, @Item = '';
            END;

            DELETE FROM tblArmyMemberList1 
            WHERE RegularSoldier = @Member;
        END;
    END;

    IF @@ERROR <> 0
    BEGIN
        ROLLBACK TRANSACTION RMS_ARMY_REMOVEARMYMEMBER;
        RETURN;
    END

    COMMIT TRANSACTION RMS_ARMY_REMOVEARMYMEMBER;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_ARMY_REMOVEARMYAGIT]    Script Date: 07/25/2024 12:01:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_ARMY_REMOVEARMYAGIT]
    @ArmyID INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION RMS_ARMY_REMOVEARMYAGIT;

    DECLARE @AgitNumber INT;
    DECLARE ArmyAgitList CURSOR FOR
        SELECT AgitNumber 
        FROM tblAgitList1 
        WHERE ArmyID = @ArmyID;

    OPEN ArmyAgitList;
    FETCH NEXT FROM ArmyAgitList INTO @AgitNumber;

    WHILE @@FETCH_STATUS = 0 
    BEGIN
        EXEC RMS_ARMY_WRITEAGITLOG @AgitNumber = @AgitNumber, @LogKind = 'DefeatInWar: AllAgitLost';
        FETCH NEXT FROM ArmyAgitList INTO @AgitNumber;
    END;

    CLOSE ArmyAgitList;
    DEALLOCATE ArmyAgitList;

    DELETE FROM tblAgitSafeList1 
    WHERE AgitNumber IN (SELECT AgitNumber FROM tblAgitList1 WHERE ArmyID = @ArmyID);
    
    DELETE FROM tblAgitList1 
    WHERE ArmyID = @ArmyID;

    EXEC RMS_ARMY_REMOVEARMYSHOP @ArmyID = @ArmyID, @Kind = 1;

    DECLARE @NewExpirationDate DATETIME;
    SET @NewExpirationDate = GETDATE();
    SET @NewExpirationDate = DATEADD(MONTH, 1, @NewExpirationDate);

    UPDATE tblArmyList1 
    SET ActivityPeriod = @NewExpirationDate 
    WHERE ID = @ArmyID;

    EXEC RMS_ARMY_WRITEARMYLOG @ArmyID = @ArmyID, @LogKind = 'ActivityPeriodExtended';

    IF @@ERROR <> 0
    BEGIN
        ROLLBACK TRANSACTION RMS_ARMY_REMOVEARMYAGIT;
        RETURN;
    END

    COMMIT TRANSACTION RMS_ARMY_REMOVEARMYAGIT;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_ARMY_REMOVEAGIT]    Script Date: 07/25/2024 12:01:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_ARMY_REMOVEAGIT]
    @AgitNumber int,
    @Kind tinyint
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION RMS_ARMY_REMOVEAGIT;

    DECLARE @ArmyID int;
    DECLARE @MailContent VARCHAR(200), @AgitNumber2 int;
    DECLARE @AgitChar VARCHAR(50);
    DECLARE @Commander VARCHAR(14);
    DECLARE @GameID VARCHAR(14);
    DECLARE @RowCount int;
    DECLARE @NewExpirationDate datetime;
    DECLARE ArmyMemberList CURSOR FOR 
        SELECT RegularSoldier 
        FROM tblArmyMemberList1 
        WHERE ArmyID = @ArmyID;

    SELECT @ArmyID = ArmyID 
    FROM tblAgitList1 
    WHERE AgitNumber = @AgitNumber;

    IF @@ROWCOUNT != 0
    BEGIN
        IF @Kind = 1
        BEGIN
            IF @AgitNumber > 20 AND @AgitNumber <= 40
            BEGIN
                SET @AgitNumber2 = @AgitNumber - 20;
                SET @AgitChar = 'Liberation Camp Hall ' + CAST(@AgitNumber2 AS VARCHAR);
            END
            ELSE
            BEGIN
                SET @AgitNumber2 = @AgitNumber;
                SET @AgitChar = 'Freedom Camp Hall ' + CAST(@AgitNumber2 AS VARCHAR);
            END

            SET @MailContent = 'Because you have failed to make payment, you can no longer occupy Army Hall ' + @AgitChar + '.';

            SELECT @Commander = Commander 
            FROM tblArmyList1 
            WHERE ID = @ArmyID;

            OPEN ArmyMemberList;

            FETCH NEXT FROM ArmyMemberList INTO @GameID;
            WHILE @@FETCH_STATUS = 0
            BEGIN
                EXEC RMS_SENDMAIL @Recipient = @GameID, @Sender = '[ArmyAdmin]', @Title = 'Army Hall Seized', @Line = 3, @MailContent = @MailContent, @Item = '';
                FETCH NEXT FROM ArmyMemberList INTO @GameID;
            END

            CLOSE ArmyMemberList;
            DEALLOCATE ArmyMemberList;

            EXEC RMS_SENDMAIL @Recipient = @Commander, @Sender = '[ArmyAdmin]', @Title = 'Army Hall Seized', @Line = 3, @MailContent = @MailContent, @Item = '';

            EXEC RMS_ARMY_WRITEAGITLOG @AgitNumber = @AgitNumber, @LogKind = 'AgitReturnedByExpiration';
        END
        ELSE IF @Kind = 2
        BEGIN
            EXEC RMS_ARMY_WRITEAGITLOG @AgitNumber = @AgitNumber, @LogKind = 'AgitReturnedByCommander';
        END
        ELSE IF @Kind = 3
        BEGIN
            DECLARE @OppArmyID int;
            SELECT @OppArmyID = OppArmyID 
            FROM tblArmyWarList1 
            WHERE ArmyID = @ArmyID 
            AND (WarKind = 1 OR WarKind = 2) 
            AND WarPlace = @AgitNumber;

            IF @@ROWCOUNT > 0
            BEGIN
                EXEC RMS_ARMY_ENDWAR @ArmyID1 = @ArmyID, @ArmyID2 = @OppArmyID;
                EXEC RMS_ARMY_ENDWARRESULT @ArmyID1 = @ArmyID, @ArmyID2 = @OppArmyID, @Kind = 0;
            END
            EXEC RMS_ARMY_WRITEAGITLOG @AgitNumber = @AgitNumber, @LogKind = 'AgitReturnedByAgitClosureState';
        END

        DELETE FROM tblAgitSafeList1 WHERE AgitNumber = @AgitNumber;
        DELETE FROM tblAgitList1 WHERE AgitNumber = @AgitNumber;

        SELECT @RowCount = COUNT(*) 
        FROM tblAgitList1 
        WHERE ArmyID = @ArmyID;

        IF @RowCount = 0
        BEGIN
            EXEC RMS_ARMY_REMOVEARMYSHOP @ArmyID = @ArmyID, @Kind = 2;
        END

        SET @NewExpirationDate = GETDATE();
        SET @NewExpirationDate = DATEADD(month, 1, @NewExpirationDate);
        UPDATE tblArmyList1 SET ActivityPeriod = @NewExpirationDate WHERE ID = @ArmyID;
        EXEC RMS_ARMY_WRITEARMYLOG @ArmyID = @ArmyID, @LogKind = 'ActivityPeriodExtended';
    END

    COMMIT TRANSACTION RMS_ARMY_REMOVEAGIT;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_ARMY_CHANGEARMYBASEOWNER]    Script Date: 07/25/2024 12:01:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_ARMY_CHANGEARMYBASEOWNER]
	@FromArmyID	int,
	@ToArmyID	int

AS
set nocount on

begin transaction RMS_ARMY_CHANGEARMYBASEOWNER

	DECLARE @ArmyID int
	SELECT @ArmyID=ArmyID FROM tblArmyBase1
	
	if @ArmyID=@FromArmyID
	begin
		UPDATE tblArmyBase1 SET ArmyID=@ToArmyID,ControlBeginDate=getdate()
		UPDATE tblArmyList1 SET ArmyBaseScore=0
		if @ArmyID=0
		begin
			EXEC RMS_ARMY_WRITEARMYBASELOG @LogKind='BeginControlArmyBase'
		end
		else if @ToArmyID=0
		begin
			EXEC RMS_ARMY_WRITEARMYBASELOG @LogKind='ArmyBaseInitialized'
		end
		else
		begin
			EXEC RMS_ARMY_WRITEARMYBASELOG @LogKind='ChangedArmyBaseOwner'
		end

		IF @FromArmyID!=0
		BEGIN
			SELECT AgitNumber FROM tblAgitList1 WHERE ArmyID=@FromArmyID
			IF @@ROWCOUNT=0
			BEGIN	
				EXEC RMS_ARMY_REMOVEARMYSHOP @ArmyID=@FromArmyID,@Kind=2
				Declare @NewExpirationDate datetime
				set @NewExpirationDate=getdate()
				set @NewExpirationDate=DATEADD(month,1,@NewExpirationDate)
				update tblArmyList1 set ActivityPeriod=@NewExpirationDate where ID=@FromArmyID
				EXEC RMS_ARMY_WRITEARMYLOG @ArmyID=@FromArmyID,@LogKind='ActivityPeriodExtended'
			END
		END

		IF @ToArmyID!=0
		BEGIN
			SELECT ShopNumber FROM tblArmyShopList1 WHERE ArmyID=@ToArmyID
			IF @@ROWCOUNT!=0
			BEGIN
				EXEC RMS_ARMY_REMOVEARMYSHOP @ArmyID=@ToArmyID,@Kind=4
			END
		END
	end

commit transaction RMS_ARMY_CHANGEARMYBASEOWNER
GO
/****** Object:  StoredProcedure [dbo].[RMS_ARMY_CHANGEAGITOWNER]    Script Date: 07/25/2024 12:01:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_ARMY_CHANGEAGITOWNER]
    @AgitNumber int,
    @FromArmyID int,
    @ToArmyID int
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION RMS_ARMY_CHANGEAGITOWNER;

    DECLARE @ArmyID int;
    SELECT @ArmyID = ArmyID 
    FROM tblAgitList1 
    WHERE AgitNumber = @AgitNumber;
    
    IF @ArmyID = @FromArmyID
    BEGIN
        UPDATE tblAgitList1 
        SET ArmyID = @ToArmyID 
        WHERE AgitNumber = @AgitNumber;

        EXEC RMS_ARMY_WRITEAGITLOG @AgitNumber = @AgitNumber, @LogKind = 'DefeatInWar : ChangedAgitOwner';

        DECLARE @AgitCount int;
        SELECT @AgitCount = COUNT(*) 
        FROM tblAgitList1 
        WHERE ArmyID = @FromArmyID;
        
        IF @AgitCount = 0
        BEGIN
            EXEC RMS_ARMY_REMOVEARMYSHOP @ArmyID = @FromArmyID, @Kind = 1;
        END

        DECLARE @NewExpirationDate datetime;
        SET @NewExpirationDate = GETDATE();
        SET @NewExpirationDate = DATEADD(month, 1, @NewExpirationDate);

        UPDATE tblArmyList1 
        SET ActivityPeriod = @NewExpirationDate 
        WHERE ID = @FromArmyID;

        EXEC RMS_ARMY_WRITEARMYLOG @ArmyID = @FromArmyID, @LogKind = 'ActivityPeriodExtended';
    END

    COMMIT TRANSACTION RMS_ARMY_CHANGEAGITOWNER;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_ARMY_CHECKAGITCLOSURE]    Script Date: 07/25/2024 12:01:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_ARMY_CHECKAGITCLOSURE]
    @Kind tinyint
-- 1: You have retrieved your Army hall from the enemy
-- 2: The enemy has seized your Army hall
-- 3: You have seized the enemy's Army hall
-- 4: The enemy has taken back their Army hall
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION RMS_ARMY_CHECKAGITCLOSURE;

    DECLARE @MailContent varchar(600);
    SET @MailContent = '';
        
    DECLARE @AgitCount1 int;
    DECLARE @AgitCount2 int;
    DECLARE @Camp int;
    DECLARE @AgitChar1 varchar(10);
    DECLARE @AgitChar2 varchar(10);
    DECLARE @RemainCount int;

    IF @Kind = 1 OR @Kind = 2
    BEGIN
        SELECT @AgitCount1 = COUNT(*)
        FROM tblAgitList1
        WHERE AgitNumber > 0 AND AgitNumber <= 20 AND ArmyID IN (SELECT ID FROM tblArmyList1 WHERE Camp = 1);

        SELECT @AgitCount2 = COUNT(*)
        FROM tblAgitList1
        WHERE AgitNumber > 0 AND AgitNumber <= 20 AND ArmyID IN (SELECT ID FROM tblArmyList1 WHERE Camp = 2);
        
        SET @Camp = 1;
    END
    ELSE
    BEGIN
        SELECT @AgitCount1 = COUNT(*)
        FROM tblAgitList1
        WHERE AgitNumber > 20 AND AgitNumber <= 40 AND ArmyID IN (SELECT ID FROM tblArmyList1 WHERE Camp = 2);
        
        SELECT @AgitCount2 = COUNT(*)
        FROM tblAgitList1
        WHERE AgitNumber > 20 AND AgitNumber <= 40 AND ArmyID IN (SELECT ID FROM tblArmyList1 WHERE Camp = 1);
        
        SET @Camp = 2;
    END

    IF @Kind = 2 OR @Kind = 3  -- You have seized the enemy's Army hall building.
    BEGIN
        IF @AgitCount2 > 10
        BEGIN
            SET @MailContent = 
'Today I have tragic news to send you. Our camp army has lost to the other camp army. They have seized our Army hall building. They now occupy 11 of our army halls. Our army hall building has been shut down.';

            DECLARE @AgitNumber int;
            DECLARE AgitClosureList CURSOR FOR
                SELECT AgitNumber 
                FROM tblAgitList1 
                WHERE ArmyID IN (SELECT ID FROM tblArmyList1 WHERE Camp = @Camp);

            OPEN AgitClosureList;

            FETCH NEXT FROM AgitClosureList INTO @AgitNumber;
            WHILE @@FETCH_STATUS = 0 
            BEGIN
                IF (@Kind = 2 AND @AgitNumber > 0 AND @AgitNumber <= 20) OR (@Kind = 3 AND @AgitNumber > 20 AND @AgitNumber <= 40)
                BEGIN
                    EXEC RMS_ARMY_REMOVEAGIT @AgitNumber = @AgitNumber, @Kind = 3;
                END
                FETCH NEXT FROM AgitClosureList INTO @AgitNumber;
            END

            CLOSE AgitClosureList;
            DEALLOCATE AgitClosureList;
        END
        ELSE
        BEGIN
            SET @RemainCount = 11 - @AgitCount2;
            SET @AgitChar1 = CAST(@RemainCount AS varchar);
            SET @AgitChar2 = CAST(@AgitCount2 AS varchar);

            SET @MailContent = 
'I have tragic news today. Our Army Camp has lost the war with the opposing army camp. They have seized our Army hall building. They now occupy ' + @AgitChar2 + ' halls. If they seize ' + @AgitChar1 + ' more hall(s), our camp will be unable to use any halls. Let us unite! The Commander needs our help to retain ownership and power of our camp army halls!! If the opposing camp is able to seize 11 of our halls, all our halls will be shutdown. If the other camp is able to occupy 11 halls all our army halls will be shut down. Let us unite our power and defeat them.';
        END
    END
    ELSE IF @Kind = 1 OR @Kind = 4
    BEGIN
        IF @AgitCount1 = 9
        BEGIN
            SET @MailContent = 
'We have succeeded! We have won the war against the opposing camp and have been successful in driving them out. However they still occupy 9 of our army halls that were invaded. Our other army halls have reopened.';
        END
        ELSE
        BEGIN
            SET @AgitChar1 = CAST(@AgitCount2 AS varchar);
            SET @MailContent = 
'We have succeeded!! We have won the war against the opposing camp and have been successful in driving them out of our army hall. However, they still occupy ' + @AgitChar1 + ' of our army halls.';
        END
    END

    DECLARE @Commander varchar(14);
    DECLARE AgitMailList CURSOR FOR
        SELECT Commander 
        FROM tblArmyList1 
        WHERE Camp = @Camp;

    OPEN AgitMailList;

    FETCH NEXT FROM AgitMailList INTO @Commander;
    WHILE @@FETCH_STATUS = 0 
    BEGIN
        EXEC RMS_SENDMAIL @Recipient = @Commander, @Sender = 'ArmyAdmin', @Title = 'Army Hall Status', @Line = 12, @MailContent = @MailContent, @Item = '';
        FETCH NEXT FROM AgitMailList INTO @Commander;
    END

    CLOSE AgitMailList;
    DEALLOCATE AgitMailList;

    COMMIT TRANSACTION RMS_ARMY_CHECKAGITCLOSURE;
END
GO
/****** Object:  StoredProcedure [dbo].[RMS_ARMY_BREAKUPARMY]    Script Date: 07/25/2024 12:01:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RMS_ARMY_BREAKUPARMY]
    @ArmyID int,
    @Kind tinyint  -- Kind 0: Nonpayment of Operation Fee, 1: Commander's order to disband, 2: Inadequate number of Army members, 3: By warfare
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION RMS_ARMY_BREAKUPARMY;

    DECLARE @Content VARCHAR(200);
    SET @Content = '';
    DECLARE @Commander VARCHAR(14);
    DECLARE @Name VARCHAR(10);
    SELECT @Commander = Commander, @Name = Name 
    FROM tblArmyList1 
    WHERE ID = @ArmyID;

    IF @@ROWCOUNT != 0
    BEGIN
        IF @Kind = 0
        BEGIN
            SET @Content = @Name + ' Army Operation time has expired. Operation time has not been extended. ' + @Name + ' Army has been disbanded.';
            EXEC RMS_ARMY_WRITEARMYLOG @ArmyID = @ArmyID, @LogKind = 'BreakupArmy: ActivityTimeOver';
        END
        ELSE IF @Kind = 1
        BEGIN
            SET @Content = @Name + ' Army Commander ' + @Commander + ' has ordered the disbandment of the army. ' + @Name + ' Army has been disbanded.';
            EXEC RMS_ARMY_WRITEARMYLOG @ArmyID = @ArmyID, @LogKind = 'BreakupArmy: Commander';
        END
        ELSE IF @Kind = 2
        BEGIN
            SET @Content = @Name + ' Army has been disbanded because there aren''t enough core members. An army must have 10 members of at least level 300 at all times in order to be maintained.';
            EXEC RMS_ARMY_WRITEARMYLOG @ArmyID = @ArmyID, @LogKind = 'BreakupArmy: MemberShortage';
        END
        ELSE IF @Kind = 3
        BEGIN
            SET @Content = @Name + ' Army has lost the war and has been disbanded.';
            EXEC RMS_ARMY_WRITEARMYLOG @ArmyID = @ArmyID, @LogKind = 'BreakupArmy: DefeatInWar';
        END

        IF @Kind > 0 AND @Kind <= 3
        BEGIN
            DECLARE @GameID varchar(14);
            DECLARE ArmyMemberList CURSOR FOR
                SELECT RegularSoldier 
                FROM tblArmyMemberList1 
                WHERE ArmyID = @ArmyID;

            OPEN ArmyMemberList;

            FETCH NEXT FROM ArmyMemberList INTO @GameID;
            WHILE @@FETCH_STATUS = 0 
            BEGIN
                EXEC RMS_SENDMAIL @Recipient = @GameID, @Sender = 'ArmyAdmin', @Title = 'Army Disbandment', @Line = 3, @MailContent = @Content, @Item = '';
                EXEC RMS_ARMY_ADDREJOINSANCTION @GameID = @GameID;
                FETCH NEXT FROM ArmyMemberList INTO @GameID;
            END

            CLOSE ArmyMemberList;
            DEALLOCATE ArmyMemberList;

            EXEC RMS_SENDMAIL @Recipient = @Commander, @Sender = 'ArmyAdmin', @Title = 'Army Disbandment', @Line = 3, @MailContent = @Content, @Item = '';
            EXEC RMS_ARMY_ADDREJOINSANCTION @GameID = @Commander;
        END

        DECLARE @AllianceID int;
        DECLARE @bHost bit;

        SELECT @AllianceID = AllianceID, @bHost = bHost 
        FROM tblArmyAllianceList1 
        WHERE ArmyID = @ArmyID;

        IF @@ROWCOUNT != 0
        BEGIN
            IF @bHost = 1
            BEGIN
                DELETE FROM tblArmyAllianceList1 
                WHERE AllianceID = @AllianceID;
            END
            ELSE
            BEGIN
                DELETE FROM tblArmyAllianceList1 
                WHERE ArmyID = @ArmyID;
                DECLARE @AllianceCount int;
                SELECT @AllianceCount = COUNT(*) 
                FROM tblArmyAllianceList1 
                WHERE AllianceID = @AllianceID;
                IF @AllianceCount = 1
                BEGIN
                    DELETE FROM tblArmyAllianceList1 
                    WHERE AllianceID = @AllianceID;
                END
            END
        END

        EXEC RMS_ARMY_REMOVEARMYSHOP @ArmyID = @ArmyID, @Kind = 3;
        EXEC RMS_ARMY_REMOVEARMYAGIT @ArmyID = @ArmyID;
        DELETE FROM tblSubArmyList1 
        WHERE ArmyID = @ArmyID;
        DELETE FROM tblArmyMemberList1 
        WHERE ArmyID = @ArmyID;
        DELETE FROM tblArmyList1 
        WHERE ID = @ArmyID;
        DELETE FROM tblHiredSoldierList1 
        WHERE ArmyID = @ArmyID;
    END

    COMMIT TRANSACTION RMS_ARMY_BREAKUPARMY;
END
GO
/****** Object:  Default [DF__PlayerIPL__Login__5402595F]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[PlayerIPLog] ADD  DEFAULT (getdate()) FOR [LoginTime]
GO
/****** Object:  Default [DF_tblAccountsValidLog_LogDate]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblAccountsStatsLog] ADD  CONSTRAINT [DF_tblAccountsValidLog_LogDate]  DEFAULT (getdate()) FOR [LogDate]
GO
/****** Object:  Default [DF_tblAccountsValidLog_ValidAccts]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblAccountsStatsLog] ADD  CONSTRAINT [DF_tblAccountsValidLog_ValidAccts]  DEFAULT (0) FOR [ValidAccts]
GO
/****** Object:  Default [DF_tblAccountsValidLog_ServerID]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblAccountsStatsLog] ADD  CONSTRAINT [DF_tblAccountsValidLog_ServerID]  DEFAULT (0) FOR [PaidAccts]
GO
/****** Object:  Default [DF_tblAccountsStatsLog_ExpAccts]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblAccountsStatsLog] ADD  CONSTRAINT [DF_tblAccountsStatsLog_ExpAccts]  DEFAULT (0) FOR [ExpAccts]
GO
/****** Object:  Default [DF_tblAccountsValidLog_NewAccts]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblAccountsStatsLog] ADD  CONSTRAINT [DF_tblAccountsValidLog_NewAccts]  DEFAULT (0) FOR [NewAccts]
GO
/****** Object:  Default [DF_tblAccountsValidLog_TotalAccts]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblAccountsStatsLog] ADD  CONSTRAINT [DF_tblAccountsValidLog_TotalAccts]  DEFAULT (0) FOR [TotalAccts]
GO
/****** Object:  Default [DF_tblAccountsValidLog_ServerID_1]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblAccountsStatsLog] ADD  CONSTRAINT [DF_tblAccountsValidLog_ServerID_1]  DEFAULT (1) FOR [ServerID]
GO
/****** Object:  Default [DF_tblAgitList1_RentDate]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblAgitList1] ADD  CONSTRAINT [DF_tblAgitList1_RentDate]  DEFAULT (getdate()) FOR [RentBeginDate]
GO
/****** Object:  Default [DF_tblAgitList1_ExpirationDate]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblAgitList1] ADD  CONSTRAINT [DF_tblAgitList1_ExpirationDate]  DEFAULT (getdate()) FOR [ExpirationDate]
GO
/****** Object:  Default [DF_tblAgitList1_SafeMoney1]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblAgitList1] ADD  CONSTRAINT [DF_tblAgitList1_SafeMoney1]  DEFAULT (0) FOR [SafeMoney1]
GO
/****** Object:  Default [DF_tblAgitList1_SafeMoney_1]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblAgitList1] ADD  CONSTRAINT [DF_tblAgitList1_SafeMoney_1]  DEFAULT (0) FOR [SafeMoney2]
GO
/****** Object:  Default [DF_tblAgitList1_SafeMoney3]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblAgitList1] ADD  CONSTRAINT [DF_tblAgitList1_SafeMoney3]  DEFAULT (0) FOR [SafeMoney3]
GO
/****** Object:  Default [DF_tblAgitListLog1_Time]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblAgitListLog1] ADD  CONSTRAINT [DF_tblAgitListLog1_Time]  DEFAULT (getdate()) FOR [Time]
GO
/****** Object:  Default [DF_tblAgitListLog1_LogKind]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblAgitListLog1] ADD  CONSTRAINT [DF_tblAgitListLog1_LogKind]  DEFAULT ('') FOR [LogKind]
GO
/****** Object:  Default [DF_tblArmyAllianceList1_bAllianceMaster]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblArmyAllianceList1] ADD  CONSTRAINT [DF_tblArmyAllianceList1_bAllianceMaster]  DEFAULT (0) FOR [bHost]
GO
/****** Object:  Default [DF_tblArmyBase1_ControlBeginDate]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblArmyBase1] ADD  CONSTRAINT [DF_tblArmyBase1_ControlBeginDate]  DEFAULT (getdate()) FOR [ControlBeginDate]
GO
/****** Object:  Default [DF_tblArmyBase1_AgitTaxRate]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblArmyBase1] ADD  CONSTRAINT [DF_tblArmyBase1_AgitTaxRate]  DEFAULT (0) FOR [AgitTaxRate]
GO
/****** Object:  Default [DF_tblArmyBase1_ArmyGain]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblArmyBase1] ADD  CONSTRAINT [DF_tblArmyBase1_ArmyGain]  DEFAULT (0) FOR [ArmyGain]
GO
/****** Object:  Default [DF_tblArmyBase1_Money1]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblArmyBase1] ADD  CONSTRAINT [DF_tblArmyBase1_Money1]  DEFAULT (0) FOR [SafeMoney1]
GO
/****** Object:  Default [DF_tblArmyBase1_Money2]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblArmyBase1] ADD  CONSTRAINT [DF_tblArmyBase1_Money2]  DEFAULT (0) FOR [SafeMoney2]
GO
/****** Object:  Default [DF_tblArmyBase1_Money3]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblArmyBase1] ADD  CONSTRAINT [DF_tblArmyBase1_Money3]  DEFAULT (0) FOR [SafeMoney3]
GO
/****** Object:  Default [DF_tblArmyBase1_Money4]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblArmyBase1] ADD  CONSTRAINT [DF_tblArmyBase1_Money4]  DEFAULT (0) FOR [SafeMoney4]
GO
/****** Object:  Default [DF_tblArmyBase1_Money5]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblArmyBase1] ADD  CONSTRAINT [DF_tblArmyBase1_Money5]  DEFAULT (0) FOR [SafeMoney5]
GO
/****** Object:  Default [DF_tblArmyBase1_Money6]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblArmyBase1] ADD  CONSTRAINT [DF_tblArmyBase1_Money6]  DEFAULT (0) FOR [SafeMoney6]
GO
/****** Object:  Default [DF_tblArmyBase1_Money7]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblArmyBase1] ADD  CONSTRAINT [DF_tblArmyBase1_Money7]  DEFAULT (0) FOR [SafeMoney7]
GO
/****** Object:  Default [DF_tblArmyBase1_Money8]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblArmyBase1] ADD  CONSTRAINT [DF_tblArmyBase1_Money8]  DEFAULT (0) FOR [SafeMoney8]
GO
/****** Object:  Default [DF_tblArmyBase1_Money9]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblArmyBase1] ADD  CONSTRAINT [DF_tblArmyBase1_Money9]  DEFAULT (0) FOR [SafeMoney9]
GO
/****** Object:  Default [DF_tblArmyBase1_Money10]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblArmyBase1] ADD  CONSTRAINT [DF_tblArmyBase1_Money10]  DEFAULT (0) FOR [SafeMoney10]
GO
/****** Object:  Default [DF_tblArmyBaseLog1_Time]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblArmyBaseLog1] ADD  CONSTRAINT [DF_tblArmyBaseLog1_Time]  DEFAULT (getdate()) FOR [Time]
GO
/****** Object:  Default [DF_tblArmyBaseLog1_LogKind]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblArmyBaseLog1] ADD  CONSTRAINT [DF_tblArmyBaseLog1_LogKind]  DEFAULT ('') FOR [LogKind]
GO
/****** Object:  Default [DF_tblArmyJoinSanctionList1_SanctionTime]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblArmyJoinSanctionList1] ADD  CONSTRAINT [DF_tblArmyJoinSanctionList1_SanctionTime]  DEFAULT (getdate()) FOR [SanctionTime]
GO
/****** Object:  Default [DF_tblArmyList1_Mark]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblArmyList1] ADD  CONSTRAINT [DF_tblArmyList1_Mark]  DEFAULT (0) FOR [Mark]
GO
/****** Object:  Default [DF_tblArmyList1_State]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblArmyList1] ADD  CONSTRAINT [DF_tblArmyList1_State]  DEFAULT (0) FOR [State]
GO
/****** Object:  Default [DF_tblArmyList1_Camp]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblArmyList1] ADD  CONSTRAINT [DF_tblArmyList1_Camp]  DEFAULT (0) FOR [Camp]
GO
/****** Object:  Default [DF_tblArmyList1_Password]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblArmyList1] ADD  CONSTRAINT [DF_tblArmyList1_Password]  DEFAULT ('') FOR [Password]
GO
/****** Object:  Default [DF_tblArmyList1_CreateTime]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblArmyList1] ADD  CONSTRAINT [DF_tblArmyList1_CreateTime]  DEFAULT (getdate()) FOR [CreateTime]
GO
/****** Object:  Default [DF_tblArmyList1_ActivePeriod]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblArmyList1] ADD  CONSTRAINT [DF_tblArmyList1_ActivePeriod]  DEFAULT (getdate()) FOR [ActivityPeriod]
GO
/****** Object:  Default [DF_tblArmyList1_Notice]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblArmyList1] ADD  CONSTRAINT [DF_tblArmyList1_Notice]  DEFAULT ('') FOR [Notice]
GO
/****** Object:  Default [DF_tblArmyList1_ArmyBaseScore]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblArmyList1] ADD  CONSTRAINT [DF_tblArmyList1_ArmyBaseScore]  DEFAULT (0) FOR [ArmyBaseScore]
GO
/****** Object:  Default [DF_tblArmyListLog1_Time]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblArmyListLog1] ADD  CONSTRAINT [DF_tblArmyListLog1_Time]  DEFAULT (getdate()) FOR [Time]
GO
/****** Object:  Default [DF_tblArmyListLog1_LogKind]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblArmyListLog1] ADD  CONSTRAINT [DF_tblArmyListLog1_LogKind]  DEFAULT ('') FOR [LogKind]
GO
/****** Object:  Default [DF_tblArmyMemberList1_SubArmyID]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblArmyMemberList1] ADD  CONSTRAINT [DF_tblArmyMemberList1_SubArmyID]  DEFAULT (0) FOR [SubArmyID]
GO
/****** Object:  Default [DF_tblArmyMemberList1_JoinTime]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblArmyMemberList1] ADD  CONSTRAINT [DF_tblArmyMemberList1_JoinTime]  DEFAULT (getdate()) FOR [JoinTime]
GO
/****** Object:  Default [DF_tblArmyShopList1_PriceRate]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblArmyShopList1] ADD  CONSTRAINT [DF_tblArmyShopList1_PriceRate]  DEFAULT (0) FOR [Tax]
GO
/****** Object:  Default [DF_tblArmyShopList1_ArmyGain]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblArmyShopList1] ADD  CONSTRAINT [DF_tblArmyShopList1_ArmyGain]  DEFAULT (0) FOR [ArmyGain]
GO
/****** Object:  Default [DF_tblArmyShopList1_BeginControl]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblArmyShopList1] ADD  CONSTRAINT [DF_tblArmyShopList1_BeginControl]  DEFAULT (getdate()) FOR [BeginControl]
GO
/****** Object:  Default [DF_tblArmyShopList1_TaxChanged]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblArmyShopList1] ADD  CONSTRAINT [DF_tblArmyShopList1_TaxChanged]  DEFAULT ('2001-1-1') FOR [TaxChanged]
GO
/****** Object:  Default [DF_tblArmyWar1_WarBegin]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblArmyWarList1] ADD  CONSTRAINT [DF_tblArmyWar1_WarBegin]  DEFAULT (getdate()) FOR [WarBeginTime]
GO
/****** Object:  Default [DF_tblArmyWar1_WarState]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblArmyWarList1] ADD  CONSTRAINT [DF_tblArmyWar1_WarState]  DEFAULT (0) FOR [WarKind]
GO
/****** Object:  Default [DF_tblArmyWarList1_WarPlace]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblArmyWarList1] ADD  CONSTRAINT [DF_tblArmyWarList1_WarPlace]  DEFAULT (0) FOR [WarPlace]
GO
/****** Object:  Default [DF_tblArmyWar1_WarState_1]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblArmyWarList1] ADD  CONSTRAINT [DF_tblArmyWar1_WarState_1]  DEFAULT (0) FOR [WarState]
GO
/****** Object:  Default [DF_tblArmyWarList1_WarScore]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblArmyWarList1] ADD  CONSTRAINT [DF_tblArmyWarList1_WarScore]  DEFAULT (0) FOR [WarScore]
GO
/****** Object:  Default [DF_tblArmyWarList1_EntranceCode]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblArmyWarList1] ADD  CONSTRAINT [DF_tblArmyWarList1_EntranceCode]  DEFAULT ('') FOR [EntranceCode]
GO
/****** Object:  Default [DF_tblArmyWarList1_ComputerCode]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblArmyWarList1] ADD  CONSTRAINT [DF_tblArmyWarList1_ComputerCode]  DEFAULT ('') FOR [ManagementCode]
GO
/****** Object:  Default [DF_tblArmyWarList1_WarehouseCode]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblArmyWarList1] ADD  CONSTRAINT [DF_tblArmyWarList1_WarehouseCode]  DEFAULT ('') FOR [WarehouseCode]
GO
/****** Object:  Default [DF_tblArmyWarList1_Bulletin]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblArmyWarList1] ADD  CONSTRAINT [DF_tblArmyWarList1_Bulletin]  DEFAULT ('') FOR [BulletinCode]
GO
/****** Object:  Default [DF_tblArmyWarList1_InputCodeState]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblArmyWarList1] ADD  CONSTRAINT [DF_tblArmyWarList1_InputCodeState]  DEFAULT (0) FOR [InputCodeState]
GO
/****** Object:  Default [DF_tblArmyWarLog1_Time]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblArmyWarListLog1] ADD  CONSTRAINT [DF_tblArmyWarLog1_Time]  DEFAULT (getdate()) FOR [Time]
GO
/****** Object:  Default [DF_tblArmyWarLog1_LogKind]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblArmyWarListLog1] ADD  CONSTRAINT [DF_tblArmyWarLog1_LogKind]  DEFAULT ('') FOR [LogKind]
GO
/****** Object:  Default [DF_tblArmyWarLog1_WarPlace]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblArmyWarListLog1] ADD  CONSTRAINT [DF_tblArmyWarLog1_WarPlace]  DEFAULT (0) FOR [WarPlace]
GO
/****** Object:  Default [DF_tblArmyWarListLog1_HostArmyID1]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblArmyWarListLog1] ADD  CONSTRAINT [DF_tblArmyWarListLog1_HostArmyID1]  DEFAULT (0) FOR [HostArmyID1]
GO
/****** Object:  Default [DF_tblArmyWarListLog1_AllianceArmyID11]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblArmyWarListLog1] ADD  CONSTRAINT [DF_tblArmyWarListLog1_AllianceArmyID11]  DEFAULT (0) FOR [AllianceArmyID11]
GO
/****** Object:  Default [DF_tblArmyWarListLog1_AllianceArmyID12]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblArmyWarListLog1] ADD  CONSTRAINT [DF_tblArmyWarListLog1_AllianceArmyID12]  DEFAULT (0) FOR [AllianceArmyID12]
GO
/****** Object:  Default [DF_tblArmyWarListLog1_AllianceArmyID13]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblArmyWarListLog1] ADD  CONSTRAINT [DF_tblArmyWarListLog1_AllianceArmyID13]  DEFAULT (0) FOR [AllianceArmyID13]
GO
/****** Object:  Default [DF_tblArmyWarListLog1_AllianceArmyID14]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblArmyWarListLog1] ADD  CONSTRAINT [DF_tblArmyWarListLog1_AllianceArmyID14]  DEFAULT (0) FOR [AllianceArmyID14]
GO
/****** Object:  Default [DF_tblArmyWarListLog1_HostArmyID2]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblArmyWarListLog1] ADD  CONSTRAINT [DF_tblArmyWarListLog1_HostArmyID2]  DEFAULT (0) FOR [HostArmyID2]
GO
/****** Object:  Default [DF_tblArmyWarListLog1_AllianceArmyID21]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblArmyWarListLog1] ADD  CONSTRAINT [DF_tblArmyWarListLog1_AllianceArmyID21]  DEFAULT (0) FOR [AllianceArmyID21]
GO
/****** Object:  Default [DF_tblArmyWarListLog1_AllianceArmyID22]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblArmyWarListLog1] ADD  CONSTRAINT [DF_tblArmyWarListLog1_AllianceArmyID22]  DEFAULT (0) FOR [AllianceArmyID22]
GO
/****** Object:  Default [DF_tblArmyWarListLog1_AllianceArmyID23]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblArmyWarListLog1] ADD  CONSTRAINT [DF_tblArmyWarListLog1_AllianceArmyID23]  DEFAULT (0) FOR [AllianceArmyID23]
GO
/****** Object:  Default [DF_tblArmyWarListLog1_AllianceArmyID24]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblArmyWarListLog1] ADD  CONSTRAINT [DF_tblArmyWarListLog1_AllianceArmyID24]  DEFAULT (0) FOR [AllianceArmyID24]
GO
/****** Object:  Default [DF_tblBattleArenaChampionLog_ServerIndex]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblBattleArenaChampionLog] ADD  CONSTRAINT [DF_tblBattleArenaChampionLog_ServerIndex]  DEFAULT (1) FOR [ServerIndex]
GO
/****** Object:  Default [DF_tblBattleArenaChampionLog_SendItem]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblBattleArenaChampionLog] ADD  CONSTRAINT [DF_tblBattleArenaChampionLog_SendItem]  DEFAULT (0) FOR [SendItem]
GO
/****** Object:  Default [DF_tblBattleArenaChampionLog_MailSent]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblBattleArenaChampionLog] ADD  CONSTRAINT [DF_tblBattleArenaChampionLog_MailSent]  DEFAULT (0) FOR [MailSent]
GO
/****** Object:  Default [DF_tblBattleArenaChampionLog_ZoneIndex]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblBattleArenaChampionLog] ADD  CONSTRAINT [DF_tblBattleArenaChampionLog_ZoneIndex]  DEFAULT (1) FOR [ZoneIndex]
GO
/****** Object:  Default [DF_tblBattleArenaPayLog_ServerIndex]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblBattleArenaPayLog] ADD  CONSTRAINT [DF_tblBattleArenaPayLog_ServerIndex]  DEFAULT (1) FOR [ServerIndex]
GO
/****** Object:  Default [DF_tblBattleArenaPayLog_Used]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblBattleArenaPayLog] ADD  CONSTRAINT [DF_tblBattleArenaPayLog_Used]  DEFAULT (1) FOR [Used]
GO
/****** Object:  Default [DF_tblBattleLeagueEntry_PossibleJoin]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblBattleLeagueEntry] ADD  CONSTRAINT [DF_tblBattleLeagueEntry_PossibleJoin]  DEFAULT (0) FOR [PossibleJoin]
GO
/****** Object:  Default [DF_tblBattleMatchEntry_ServerIndex]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblBattleMatchEntry] ADD  CONSTRAINT [DF_tblBattleMatchEntry_ServerIndex]  DEFAULT (2) FOR [ServerIndex]
GO
/****** Object:  Default [DF_tblBattleMatchEntry_JoinState]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblBattleMatchEntry] ADD  CONSTRAINT [DF_tblBattleMatchEntry_JoinState]  DEFAULT (0) FOR [JoinState]
GO
/****** Object:  Default [DF_tblBattleMatchInfoLog_bWin]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblBattleMatchInfoLog] ADD  CONSTRAINT [DF_tblBattleMatchInfoLog_bWin]  DEFAULT (0) FOR [bWin]
GO
/****** Object:  Default [DF_tblBattleMatchUserPoint_TotalPoint]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblBattleMatchUserPoint] ADD  CONSTRAINT [DF_tblBattleMatchUserPoint_TotalPoint]  DEFAULT (0) FOR [TotalPoint]
GO
/****** Object:  Default [DF_tblBattleMatchUserPointLog_Time]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblBattleMatchUserPointLog] ADD  CONSTRAINT [DF_tblBattleMatchUserPointLog_Time]  DEFAULT (getdate()) FOR [Time]
GO
/****** Object:  Default [DF_tblBattleZoneChampionLog_ZoneIndex]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblBattleZoneChampionLog] ADD  CONSTRAINT [DF_tblBattleZoneChampionLog_ZoneIndex]  DEFAULT (1) FOR [ZoneIndex]
GO
/****** Object:  Default [DF_tblBattleZoneChampionLog_ServerIndex]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblBattleZoneChampionLog] ADD  CONSTRAINT [DF_tblBattleZoneChampionLog_ServerIndex]  DEFAULT (1) FOR [ServerIndex]
GO
/****** Object:  Default [DF_tblBattleZoneChampionLog_SendItem]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblBattleZoneChampionLog] ADD  CONSTRAINT [DF_tblBattleZoneChampionLog_SendItem]  DEFAULT (0) FOR [SendItem]
GO
/****** Object:  Default [DF_tblBattleZoneChampionLog_PriseSent]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblBattleZoneChampionLog] ADD  CONSTRAINT [DF_tblBattleZoneChampionLog_PriseSent]  DEFAULT (0) FOR [MailSent]
GO
/****** Object:  Default [DF_tblBattleZonePay_Used]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblBattleZonePay] ADD  CONSTRAINT [DF_tblBattleZonePay_Used]  DEFAULT (0) FOR [Used]
GO
/****** Object:  Default [DF_tblBattleZonePay1_BattleStartTime]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblBattleZonePay1] ADD  CONSTRAINT [DF_tblBattleZonePay1_BattleStartTime]  DEFAULT (getdate()) FOR [BattleStartTime]
GO
/****** Object:  Default [DF_tblBattleZonePayLog_ServerIndex]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblBattleZonePayLog] ADD  CONSTRAINT [DF_tblBattleZonePayLog_ServerIndex]  DEFAULT (1) FOR [ServerIndex]
GO
/****** Object:  Default [DF_tblBattleZonePayLog_Time]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblBattleZonePayLog] ADD  CONSTRAINT [DF_tblBattleZonePayLog_Time]  DEFAULT (getdate()) FOR [Time]
GO
/****** Object:  Default [DF_tblBattleZonePayLog1_PayTime]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblBattleZonePayLog1] ADD  CONSTRAINT [DF_tblBattleZonePayLog1_PayTime]  DEFAULT (getdate()) FOR [PayTime]
GO
/****** Object:  Default [DF_tblBattleZoneScore_ServerIndex]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblBattleZoneScore] ADD  CONSTRAINT [DF_tblBattleZoneScore_ServerIndex]  DEFAULT (1) FOR [ServerIndex]
GO
/****** Object:  Default [DF_tblBattleZoneScore_Win]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblBattleZoneScore] ADD  CONSTRAINT [DF_tblBattleZoneScore_Win]  DEFAULT (0) FOR [Win]
GO
/****** Object:  Default [DF_tblBattleZoneScore_Lose]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblBattleZoneScore] ADD  CONSTRAINT [DF_tblBattleZoneScore_Lose]  DEFAULT (0) FOR [Lose]
GO
/****** Object:  Default [DF_tblBattleZoneScore_Score]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblBattleZoneScore] ADD  CONSTRAINT [DF_tblBattleZoneScore_Score]  DEFAULT (0) FOR [Score]
GO
/****** Object:  Default [DF_tblBattleZoneScore_ZoneIndex]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblBattleZoneScore] ADD  CONSTRAINT [DF_tblBattleZoneScore_ZoneIndex]  DEFAULT (1) FOR [ZoneIndex]
GO
/****** Object:  Default [DF_tblBattleZoneScoreLog_Time]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblBattleZoneScoreLog] ADD  CONSTRAINT [DF_tblBattleZoneScoreLog_Time]  DEFAULT (getdate()) FOR [Time]
GO
/****** Object:  Default [DF_tblBattleZoneScoreLog_ZoneIndex]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblBattleZoneScoreLog] ADD  CONSTRAINT [DF_tblBattleZoneScoreLog_ZoneIndex]  DEFAULT (1) FOR [ZoneIndex]
GO
/****** Object:  Default [DF_tblBattleZoneScoreLog_ServerIndex]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblBattleZoneScoreLog] ADD  CONSTRAINT [DF_tblBattleZoneScoreLog_ServerIndex]  DEFAULT (1) FOR [ServerIndex]
GO
/****** Object:  Default [DF_tblBattleZoneScoreLog_Win]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblBattleZoneScoreLog] ADD  CONSTRAINT [DF_tblBattleZoneScoreLog_Win]  DEFAULT (0) FOR [Win]
GO
/****** Object:  Default [DF_tblBattleZoneScoreLog_Lose]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblBattleZoneScoreLog] ADD  CONSTRAINT [DF_tblBattleZoneScoreLog_Lose]  DEFAULT (0) FOR [Lose]
GO
/****** Object:  Default [DF_tblBattleZoneScoreLog_Score]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblBattleZoneScoreLog] ADD  CONSTRAINT [DF_tblBattleZoneScoreLog_Score]  DEFAULT (0) FOR [Score]
GO
/****** Object:  Default [DF_tblBattleZoneScoreLog_NormalEnd]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblBattleZoneScoreLog] ADD  CONSTRAINT [DF_tblBattleZoneScoreLog_NormalEnd]  DEFAULT (0) FOR [NormalEnd]
GO
/****** Object:  Default [DF_tblBattleZoneScoreLog_EndLevel]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblBattleZoneScoreLog] ADD  CONSTRAINT [DF_tblBattleZoneScoreLog_EndLevel]  DEFAULT (0) FOR [EndLevel]
GO
/****** Object:  Default [DF_tblBattleZoneScoreLog_EndExperience]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblBattleZoneScoreLog] ADD  CONSTRAINT [DF_tblBattleZoneScoreLog_EndExperience]  DEFAULT (0) FOR [EndExperience]
GO
/****** Object:  Default [DF_tblBillID_Version2]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblBillID] ADD  CONSTRAINT [DF_tblBillID_Version2]  DEFAULT (2000) FOR [Version2]
GO
/****** Object:  Default [DF_tblBillID_FreeTimer]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblBillID] ADD  CONSTRAINT [DF_tblBillID_FreeTimer]  DEFAULT (0) FOR [FreeTimer]
GO
/****** Object:  Default [DF_tblBillID_FreeDate]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblBillID] ADD  CONSTRAINT [DF_tblBillID_FreeDate]  DEFAULT ('1999-1-1') FOR [FreeDate]
GO
/****** Object:  Default [DF_tblBillID_TempFreeDate]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblBillID] ADD  CONSTRAINT [DF_tblBillID_TempFreeDate]  DEFAULT ('1999-1-1 0:0:0') FOR [TempFreeDate]
GO
/****** Object:  Default [DF_tblBillID_TempModifyDate]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblBillID] ADD  CONSTRAINT [DF_tblBillID_TempModifyDate]  DEFAULT ('2000-2-3 12:59:59') FOR [TempModifyDate]
GO
/****** Object:  Default [DF_tblBillID_SecurityNum1]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblBillID] ADD  CONSTRAINT [DF_tblBillID_SecurityNum1]  DEFAULT (1990) FOR [SecurityNum1]
GO
/****** Object:  Default [DF_tblBillID_SecurityNum2]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblBillID] ADD  CONSTRAINT [DF_tblBillID_SecurityNum2]  DEFAULT (101) FOR [SecurityNum2]
GO
/****** Object:  Default [DF_tblBillID_Memo]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblBillID] ADD  CONSTRAINT [DF_tblBillID_Memo]  DEFAULT ('') FOR [Memo]
GO
/****** Object:  Default [DF_tblBillID_BillState]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblBillID] ADD  CONSTRAINT [DF_tblBillID_BillState]  DEFAULT ('') FOR [BillState]
GO
/****** Object:  Default [DF_tblBillID_FirstLoginMethod]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblBillID] ADD  CONSTRAINT [DF_tblBillID_FirstLoginMethod]  DEFAULT ('') FOR [FirstLoginMethod]
GO
/****** Object:  Default [DF_tblBillID_Note1]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblBillID] ADD  CONSTRAINT [DF_tblBillID_Note1]  DEFAULT ('') FOR [Note1]
GO
/****** Object:  Default [DF_tblBillID_Note2]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblBillID] ADD  CONSTRAINT [DF_tblBillID_Note2]  DEFAULT ('') FOR [Note2]
GO
/****** Object:  Default [DF_tblBillID_Note3]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblBillID] ADD  CONSTRAINT [DF_tblBillID_Note3]  DEFAULT ('') FOR [Note3]
GO
/****** Object:  Default [DF_tblBillID_Note4]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblBillID] ADD  CONSTRAINT [DF_tblBillID_Note4]  DEFAULT ('') FOR [Note4]
GO
/****** Object:  Default [DF_tblBillID_Note5]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblBillID] ADD  CONSTRAINT [DF_tblBillID_Note5]  DEFAULT ('') FOR [Note5]
GO
/****** Object:  Default [DF_tblBillID_Note6]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblBillID] ADD  CONSTRAINT [DF_tblBillID_Note6]  DEFAULT ('') FOR [Note6]
GO
/****** Object:  Default [DF_tblBillID_Note7]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblBillID] ADD  CONSTRAINT [DF_tblBillID_Note7]  DEFAULT ('') FOR [Note7]
GO
/****** Object:  Default [DF_tblBillID_Note8]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblBillID] ADD  CONSTRAINT [DF_tblBillID_Note8]  DEFAULT ('') FOR [Note8]
GO
/****** Object:  Default [DF_tblBillID_Note9]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblBillID] ADD  CONSTRAINT [DF_tblBillID_Note9]  DEFAULT ('') FOR [Note9]
GO
/****** Object:  Default [DF_tblBillID_Note10]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblBillID] ADD  CONSTRAINT [DF_tblBillID_Note10]  DEFAULT ('') FOR [Note10]
GO
/****** Object:  Default [DF__tblBillID__is_ha__4F72AE6C]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblBillID] ADD  DEFAULT ((0)) FOR [is_hardcore]
GO
/****** Object:  Default [DF_tblBonus2Log1_Time]    Script Date: 07/25/2024 12:01:16 ******/
ALTER TABLE [dbo].[tblBonus2Log1] ADD  CONSTRAINT [DF_tblBonus2Log1_Time]  DEFAULT (getdate()) FOR [Time]
GO
/****** Object:  Default [DF__tblChange__Chang__709E980D]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblChangeLog] ADD  DEFAULT (getdate()) FOR [ChangeDate]
GO
/****** Object:  Default [DF_tblChatLog1_Time]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblChatLog1] ADD  CONSTRAINT [DF_tblChatLog1_Time]  DEFAULT (getdate()) FOR [Time]
GO
/****** Object:  Default [DF_tblCurrentBattleArenaScore_ServerIndex]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblCurrentBattleArenaScore] ADD  CONSTRAINT [DF_tblCurrentBattleArenaScore_ServerIndex]  DEFAULT (1) FOR [ServerIndex]
GO
/****** Object:  Default [DF_tblCurrentBattleArenaScore_Win]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblCurrentBattleArenaScore] ADD  CONSTRAINT [DF_tblCurrentBattleArenaScore_Win]  DEFAULT (0) FOR [Win]
GO
/****** Object:  Default [DF_tblCurrentBattleArenaScore_Lose]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblCurrentBattleArenaScore] ADD  CONSTRAINT [DF_tblCurrentBattleArenaScore_Lose]  DEFAULT (0) FOR [Lose]
GO
/****** Object:  Default [DF_tblCurrentBattleArenaScore_Score]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblCurrentBattleArenaScore] ADD  CONSTRAINT [DF_tblCurrentBattleArenaScore_Score]  DEFAULT (0) FOR [Score]
GO
/****** Object:  Default [DF_tblCurrentBattleArenaScore_NormalEnd]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblCurrentBattleArenaScore] ADD  CONSTRAINT [DF_tblCurrentBattleArenaScore_NormalEnd]  DEFAULT (0) FOR [NormalEnd]
GO
/****** Object:  Default [DF_tblCurrentBattleArenaScore_EndLevel]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblCurrentBattleArenaScore] ADD  CONSTRAINT [DF_tblCurrentBattleArenaScore_EndLevel]  DEFAULT (0) FOR [EndLevel]
GO
/****** Object:  Default [DF_tblCurrentBattleArenaScore_EndExperience]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblCurrentBattleArenaScore] ADD  CONSTRAINT [DF_tblCurrentBattleArenaScore_EndExperience]  DEFAULT (0) FOR [EndExperience]
GO
/****** Object:  Default [DF_tblCurrentBattleArenaScore_ZoneIndex]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblCurrentBattleArenaScore] ADD  CONSTRAINT [DF_tblCurrentBattleArenaScore_ZoneIndex]  DEFAULT (1) FOR [ZoneIndex]
GO
/****** Object:  Default [DF_tblCurrentBattleMatchEntryInfo_StartTime]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblCurrentBattleMatchEntry] ADD  CONSTRAINT [DF_tblCurrentBattleMatchEntryInfo_StartTime]  DEFAULT (getdate()) FOR [StartTime]
GO
/****** Object:  Default [DF_tblCurrentBattleMatchEntryInfo_EndTime]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblCurrentBattleMatchEntry] ADD  CONSTRAINT [DF_tblCurrentBattleMatchEntryInfo_EndTime]  DEFAULT (getdate()) FOR [EndTime]
GO
/****** Object:  Default [DF_tblCurrentBattleMatchEntryInfo_bStart]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblCurrentBattleMatchEntry] ADD  CONSTRAINT [DF_tblCurrentBattleMatchEntryInfo_bStart]  DEFAULT (0) FOR [JoinState]
GO
/****** Object:  Default [DF_tblCurrentBattleMatchInfo_MemberCount]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblCurrentBattleMatchInfo] ADD  CONSTRAINT [DF_tblCurrentBattleMatchInfo_MemberCount]  DEFAULT (0) FOR [MemberCount]
GO
/****** Object:  Default [DF_tblCurrentBattleMatchInfo_Score]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblCurrentBattleMatchInfo] ADD  CONSTRAINT [DF_tblCurrentBattleMatchInfo_Score]  DEFAULT (0) FOR [Score]
GO
/****** Object:  Default [DF_tblCurrentBattleMatchInfo_SmashedTower]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblCurrentBattleMatchInfo] ADD  CONSTRAINT [DF_tblCurrentBattleMatchInfo_SmashedTower]  DEFAULT (0) FOR [SmashedTower]
GO
/****** Object:  Default [DF_tblCurrentBattleMatchInfo_StartTime]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblCurrentBattleMatchInfo] ADD  CONSTRAINT [DF_tblCurrentBattleMatchInfo_StartTime]  DEFAULT (getdate()) FOR [StartTime]
GO
/****** Object:  Default [DF_tblCurrentBattleMatchInfo_TotalScore]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblCurrentBattleMatchInfo] ADD  CONSTRAINT [DF_tblCurrentBattleMatchInfo_TotalScore]  DEFAULT (0) FOR [TotalScore]
GO
/****** Object:  Default [DF_tblCurrentBattleMatchInfo_AvgMemberLevel]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblCurrentBattleMatchInfo] ADD  CONSTRAINT [DF_tblCurrentBattleMatchInfo_AvgMemberLevel]  DEFAULT (0) FOR [AvgMemberLevel]
GO
/****** Object:  Default [DF_tblCurrentBattleMatchInfo_bWin]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblCurrentBattleMatchInfo] ADD  CONSTRAINT [DF_tblCurrentBattleMatchInfo_bWin]  DEFAULT (0) FOR [bWin]
GO
/****** Object:  Default [DF_tblCurrentBattleZoneScore_ZoneIndex]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblCurrentBattleZoneScore] ADD  CONSTRAINT [DF_tblCurrentBattleZoneScore_ZoneIndex]  DEFAULT (1) FOR [ZoneIndex]
GO
/****** Object:  Default [DF_tblCurrentBattleZoneScore_ServerIndex]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblCurrentBattleZoneScore] ADD  CONSTRAINT [DF_tblCurrentBattleZoneScore_ServerIndex]  DEFAULT (1) FOR [ServerIndex]
GO
/****** Object:  Default [DF_tblCurrentBattleZoneScore_Win]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblCurrentBattleZoneScore] ADD  CONSTRAINT [DF_tblCurrentBattleZoneScore_Win]  DEFAULT (0) FOR [Win]
GO
/****** Object:  Default [DF_tblCurrentBattleZoneScore_Lose]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblCurrentBattleZoneScore] ADD  CONSTRAINT [DF_tblCurrentBattleZoneScore_Lose]  DEFAULT (0) FOR [Lose]
GO
/****** Object:  Default [DF_tblCurrentBattleZoneScore_Score]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblCurrentBattleZoneScore] ADD  CONSTRAINT [DF_tblCurrentBattleZoneScore_Score]  DEFAULT (0) FOR [Score]
GO
/****** Object:  Default [DF_tblCurrentBattleZoneScore_NormalEnd]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblCurrentBattleZoneScore] ADD  CONSTRAINT [DF_tblCurrentBattleZoneScore_NormalEnd]  DEFAULT (0) FOR [NormalEnd]
GO
/****** Object:  Default [DF_tblCurrentBattleZoneScore_EndLevel]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblCurrentBattleZoneScore] ADD  CONSTRAINT [DF_tblCurrentBattleZoneScore_EndLevel]  DEFAULT (0) FOR [EndLevel]
GO
/****** Object:  Default [DF_tblCurrentBattleZoneScore_EndExperience]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblCurrentBattleZoneScore] ADD  CONSTRAINT [DF_tblCurrentBattleZoneScore_EndExperience]  DEFAULT (0) FOR [EndExperience]
GO
/****** Object:  Default [DF_tblDeletedGameID1_Time]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblDeletedGameID1] ADD  CONSTRAINT [DF_tblDeletedGameID1_Time]  DEFAULT (getdate()) FOR [Time]
GO
/****** Object:  Default [DF_tblDeletedGameID1_Lvl]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblDeletedGameID1] ADD  CONSTRAINT [DF_tblDeletedGameID1_Lvl]  DEFAULT (1) FOR [Lvl]
GO
/****** Object:  Default [DF_tblDeletedGameID1_Item]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblDeletedGameID1] ADD  CONSTRAINT [DF_tblDeletedGameID1_Item]  DEFAULT ('') FOR [Item]
GO
/****** Object:  Default [DF_tblDeletedGameID1_Equipment]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblDeletedGameID1] ADD  CONSTRAINT [DF_tblDeletedGameID1_Equipment]  DEFAULT ('') FOR [Equipment]
GO
/****** Object:  Default [DF_tblDeletedGameID1_Skill]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblDeletedGameID1] ADD  CONSTRAINT [DF_tblDeletedGameID1_Skill]  DEFAULT ('') FOR [Skill]
GO
/****** Object:  Default [DF_tblDeletedGameID1_SpecialSkill]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblDeletedGameID1] ADD  CONSTRAINT [DF_tblDeletedGameID1_SpecialSkill]  DEFAULT ('') FOR [SpecialSkill]
GO
/****** Object:  Default [DF_tblDeletedGameID1_Strength]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblDeletedGameID1] ADD  CONSTRAINT [DF_tblDeletedGameID1_Strength]  DEFAULT (10) FOR [Strength]
GO
/****** Object:  Default [DF_tblDeletedGameID1_Spirit]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblDeletedGameID1] ADD  CONSTRAINT [DF_tblDeletedGameID1_Spirit]  DEFAULT (10) FOR [Spirit]
GO
/****** Object:  Default [DF_tblDeletedGameID1_Dexterity]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblDeletedGameID1] ADD  CONSTRAINT [DF_tblDeletedGameID1_Dexterity]  DEFAULT (10) FOR [Dexterity]
GO
/****** Object:  Default [DF_tblDeletedGameID1_Power]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblDeletedGameID1] ADD  CONSTRAINT [DF_tblDeletedGameID1_Power]  DEFAULT (10) FOR [Power]
GO
/****** Object:  Default [DF_tblDeletedGameID1_Fame]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblDeletedGameID1] ADD  CONSTRAINT [DF_tblDeletedGameID1_Fame]  DEFAULT (0) FOR [Fame]
GO
/****** Object:  Default [DF_tblDeletedGameID1_Experiment]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblDeletedGameID1] ADD  CONSTRAINT [DF_tblDeletedGameID1_Experiment]  DEFAULT (0) FOR [Experiment]
GO
/****** Object:  Default [DF_tblDeletedGameID1_HP]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblDeletedGameID1] ADD  CONSTRAINT [DF_tblDeletedGameID1_HP]  DEFAULT (50) FOR [HP]
GO
/****** Object:  Default [DF_tblDeletedGameID1_MP]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblDeletedGameID1] ADD  CONSTRAINT [DF_tblDeletedGameID1_MP]  DEFAULT (50) FOR [MP]
GO
/****** Object:  Default [DF_tblDeletedGameID1_SP]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblDeletedGameID1] ADD  CONSTRAINT [DF_tblDeletedGameID1_SP]  DEFAULT (0) FOR [SP]
GO
/****** Object:  Default [DF_tblDeletedGameID1_DP]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblDeletedGameID1] ADD  CONSTRAINT [DF_tblDeletedGameID1_DP]  DEFAULT (0) FOR [DP]
GO
/****** Object:  Default [DF_tblDeletedGameID1_Bonus]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblDeletedGameID1] ADD  CONSTRAINT [DF_tblDeletedGameID1_Bonus]  DEFAULT (2) FOR [Bonus]
GO
/****** Object:  Default [DF_tblDeletedGameID1_Money]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblDeletedGameID1] ADD  CONSTRAINT [DF_tblDeletedGameID1_Money]  DEFAULT (0) FOR [Money]
GO
/****** Object:  Default [DF_tblDeletedGameID1_QuickItem]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblDeletedGameID1] ADD  CONSTRAINT [DF_tblDeletedGameID1_QuickItem]  DEFAULT ('') FOR [QuickItem]
GO
/****** Object:  Default [DF_tblDeletedGameID1_QuickSkill]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblDeletedGameID1] ADD  CONSTRAINT [DF_tblDeletedGameID1_QuickSkill]  DEFAULT (0) FOR [QuickSkill]
GO
/****** Object:  Default [DF_tblDeletedGameID1_QuickSpecialSkill]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblDeletedGameID1] ADD  CONSTRAINT [DF_tblDeletedGameID1_QuickSpecialSkill]  DEFAULT (0) FOR [QuickSpecialSkill]
GO
/****** Object:  Default [DF_tblDeletedGameID1_BankMoney]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblDeletedGameID1] ADD  CONSTRAINT [DF_tblDeletedGameID1_BankMoney]  DEFAULT (0) FOR [BankMoney]
GO
/****** Object:  Default [DF_tblDeletedGameID1_BankItem]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblDeletedGameID1] ADD  CONSTRAINT [DF_tblDeletedGameID1_BankItem]  DEFAULT ('') FOR [BankItem]
GO
/****** Object:  Default [DF_tblDeletedGameID1_SETimer]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblDeletedGameID1] ADD  CONSTRAINT [DF_tblDeletedGameID1_SETimer]  DEFAULT ('') FOR [SETimer]
GO
/****** Object:  Default [DF_tblDeletedGameID1_PKTimer]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblDeletedGameID1] ADD  CONSTRAINT [DF_tblDeletedGameID1_PKTimer]  DEFAULT (0) FOR [PKTimer]
GO
/****** Object:  Default [DF_tblDeletedGameID1_Color1]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblDeletedGameID1] ADD  CONSTRAINT [DF_tblDeletedGameID1_Color1]  DEFAULT (255) FOR [Color1]
GO
/****** Object:  Default [DF_tblDeletedGameID1_Color2]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblDeletedGameID1] ADD  CONSTRAINT [DF_tblDeletedGameID1_Color2]  DEFAULT (255) FOR [Color2]
GO
/****** Object:  Default [DF_tblDeletedGameID1_PoisonUsedDate]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblDeletedGameID1] ADD  CONSTRAINT [DF_tblDeletedGameID1_PoisonUsedDate]  DEFAULT ('1999-1-1 0:0:0') FOR [PoisonUsedDate]
GO
/****** Object:  Default [DF_tblDeletedGameID1_LovePoint]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblDeletedGameID1] ADD  CONSTRAINT [DF_tblDeletedGameID1_LovePoint]  DEFAULT (0) FOR [LovePoint]
GO
/****** Object:  Default [DF_tblDeletedGameID1_ArmyHired]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblDeletedGameID1] ADD  CONSTRAINT [DF_tblDeletedGameID1_ArmyHired]  DEFAULT (0) FOR [ArmyHired]
GO
/****** Object:  Default [DF_tblDeletedGameID1_ArmyMarkIndex]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblDeletedGameID1] ADD  CONSTRAINT [DF_tblDeletedGameID1_ArmyMarkIndex]  DEFAULT (0) FOR [ArmyMarkIndex]
GO
/****** Object:  Default [DF_tblDeletedGameID1_Permission]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblDeletedGameID1] ADD  CONSTRAINT [DF_tblDeletedGameID1_Permission]  DEFAULT (0) FOR [Permission]
GO
/****** Object:  Default [DF_tblDeletedGameID1_BonusInitCount]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblDeletedGameID1] ADD  CONSTRAINT [DF_tblDeletedGameID1_BonusInitCount]  DEFAULT (0) FOR [BonusInitCount]
GO
/****** Object:  Default [DF_tblDeletedGameID1_StoryQuestState]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblDeletedGameID1] ADD  CONSTRAINT [DF_tblDeletedGameID1_StoryQuestState]  DEFAULT (0) FOR [StoryQuestState]
GO
/****** Object:  Default [DF_tblDeletedGameID1_QuestItem]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblDeletedGameID1] ADD  CONSTRAINT [DF_tblDeletedGameID1_QuestItem]  DEFAULT ('') FOR [QuestItem]
GO
/****** Object:  Default [DF_tblDeletedGameID1_SubQuestKind]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblDeletedGameID1] ADD  CONSTRAINT [DF_tblDeletedGameID1_SubQuestKind]  DEFAULT (0) FOR [SubQuestKind]
GO
/****** Object:  Default [DF_tblDeletedGameID1_SubQuestDone]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblDeletedGameID1] ADD  CONSTRAINT [DF_tblDeletedGameID1_SubQuestDone]  DEFAULT (0) FOR [SubQuestDone]
GO
/****** Object:  Default [DF_tblDeletedGameID1_SubQuestClientNPCID]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblDeletedGameID1] ADD  CONSTRAINT [DF_tblDeletedGameID1_SubQuestClientNPCID]  DEFAULT ('') FOR [SubQuestClientNPCID]
GO
/****** Object:  Default [DF_tblDeletedGameID1_SubQuestClientNPCFace]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblDeletedGameID1] ADD  CONSTRAINT [DF_tblDeletedGameID1_SubQuestClientNPCFace]  DEFAULT ((-1)) FOR [SubQuestClientNPCFace]
GO
/****** Object:  Default [DF_tblDeletedGameID1_SubQuestClientNPCMap]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblDeletedGameID1] ADD  CONSTRAINT [DF_tblDeletedGameID1_SubQuestClientNPCMap]  DEFAULT ((-1)) FOR [SubQuestClientNPCMap]
GO
/****** Object:  Default [DF_tblDeletedGameID1_SubQuestItem]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblDeletedGameID1] ADD  CONSTRAINT [DF_tblDeletedGameID1_SubQuestItem]  DEFAULT ('') FOR [SubQuestItem]
GO
/****** Object:  Default [DF_tblDeletedGameID1_SubQuestDestFace]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblDeletedGameID1] ADD  CONSTRAINT [DF_tblDeletedGameID1_SubQuestDestFace]  DEFAULT ((-1)) FOR [SubQuestDestFace]
GO
/****** Object:  Default [DF_tblDeletedGameID1_SubQuestDestMap]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblDeletedGameID1] ADD  CONSTRAINT [DF_tblDeletedGameID1_SubQuestDestMap]  DEFAULT ((-1)) FOR [SubQuestDestMap]
GO
/****** Object:  Default [DF_tblDeletedGameID1_SubQuestTimer]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblDeletedGameID1] ADD  CONSTRAINT [DF_tblDeletedGameID1_SubQuestTimer]  DEFAULT (0) FOR [SubQuestTimer]
GO
/****** Object:  Default [DF_tblDeletedGameID1_SubQuestGiftExperience]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblDeletedGameID1] ADD  CONSTRAINT [DF_tblDeletedGameID1_SubQuestGiftExperience]  DEFAULT (0) FOR [SubQuestGiftExperience]
GO
/****** Object:  Default [DF_tblDeletedGameID1_SubQuestGiftFame]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblDeletedGameID1] ADD  CONSTRAINT [DF_tblDeletedGameID1_SubQuestGiftFame]  DEFAULT (0) FOR [SubQuestGiftFame]
GO
/****** Object:  Default [DF_tblDeletedGameID1_SubQuestGiftItem]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblDeletedGameID1] ADD  CONSTRAINT [DF_tblDeletedGameID1_SubQuestGiftItem]  DEFAULT ('') FOR [SubQuestGiftItem]
GO
/****** Object:  Default [DF_tblDeletedGameID1_OPArmy]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblDeletedGameID1] ADD  CONSTRAINT [DF_tblDeletedGameID1_OPArmy]  DEFAULT (0) FOR [OPArmy]
GO
/****** Object:  Default [DF_tblDeletedGameID1_OPPKTimer]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblDeletedGameID1] ADD  CONSTRAINT [DF_tblDeletedGameID1_OPPKTimer]  DEFAULT (0) FOR [OPPKTimer]
GO
/****** Object:  Default [DF_tblDeletedGameID1_SurvivalEvent]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblDeletedGameID1] ADD  CONSTRAINT [DF_tblDeletedGameID1_SurvivalEvent]  DEFAULT (0) FOR [SurvivalEvent]
GO
/****** Object:  Default [DF_tblDeletedGameID1_SurvivalTime]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblDeletedGameID1] ADD  CONSTRAINT [DF_tblDeletedGameID1_SurvivalTime]  DEFAULT (0) FOR [SurvivalTime]
GO
/****** Object:  Default [DF_tblDeletedGameID1_Bonus2]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblDeletedGameID1] ADD  CONSTRAINT [DF_tblDeletedGameID1_Bonus2]  DEFAULT (0) FOR [Bonus2]
GO
/****** Object:  Default [DF_tblDeletedGameID1_SBonus]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblDeletedGameID1] ADD  CONSTRAINT [DF_tblDeletedGameID1_SBonus]  DEFAULT (0) FOR [SBonus]
GO
/****** Object:  Default [DF_tblDeletedGameID1_STotalBonus]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblDeletedGameID1] ADD  CONSTRAINT [DF_tblDeletedGameID1_STotalBonus]  DEFAULT (0) FOR [STotalBonus]
GO
/****** Object:  Default [DF_tblDeletedGameID1_PKPenaltyCount]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblDeletedGameID1] ADD  CONSTRAINT [DF_tblDeletedGameID1_PKPenaltyCount]  DEFAULT (0) FOR [PKPenaltyCount]
GO
/****** Object:  Default [DF_tblDeletedGameID1_PKPenaltyDecreaseTimer]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblDeletedGameID1] ADD  CONSTRAINT [DF_tblDeletedGameID1_PKPenaltyDecreaseTimer]  DEFAULT (0) FOR [PKPenaltyDecreaseTimer]
GO
/****** Object:  Default [DF_tblDeletedGameID1_SigMoney]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblDeletedGameID1] ADD  CONSTRAINT [DF_tblDeletedGameID1_SigMoney]  DEFAULT (0) FOR [SigMoney]
GO
/****** Object:  Default [DF_tblDeletedGameID1_BankSigMoney]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblDeletedGameID1] ADD  CONSTRAINT [DF_tblDeletedGameID1_BankSigMoney]  DEFAULT (0) FOR [BankSigMoney]
GO
/****** Object:  Default [DF_tblDeletedGameID1_BankItem2]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblDeletedGameID1] ADD  CONSTRAINT [DF_tblDeletedGameID1_BankItem2]  DEFAULT ('') FOR [BankItem2]
GO
/****** Object:  Default [DF_tblDeletedGameID1_TLETimer]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblDeletedGameID1] ADD  CONSTRAINT [DF_tblDeletedGameID1_TLETimer]  DEFAULT ('') FOR [TLETimer]
GO
/****** Object:  Default [DF_tblExchange1_002_SoldItemCount]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblExchange1_001] ADD  CONSTRAINT [DF_tblExchange1_002_SoldItemCount]  DEFAULT (0) FOR [SoldItemCount]
GO
/****** Object:  Default [DF_tblFreeID_PortalID]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblFreeID] ADD  CONSTRAINT [DF_tblFreeID_PortalID]  DEFAULT ('') FOR [PortalID]
GO
/****** Object:  Default [DF_tblFreeID_State]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblFreeID] ADD  CONSTRAINT [DF_tblFreeID_State]  DEFAULT (0) FOR [State]
GO
/****** Object:  Default [DF_tblFreeID_MakeTime]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblFreeID] ADD  CONSTRAINT [DF_tblFreeID_MakeTime]  DEFAULT (getdate()) FOR [MakeTime]
GO
/****** Object:  Default [DF_tblFreeID_Kind]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblFreeID] ADD  CONSTRAINT [DF_tblFreeID_Kind]  DEFAULT (0) FOR [Kind]
GO
/****** Object:  Default [DF_tblGameID1_SP]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblGameID1] ADD  CONSTRAINT [DF_tblGameID1_SP]  DEFAULT (0) FOR [SP]
GO
/****** Object:  Default [DF_tblGameID1_SETimer]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblGameID1] ADD  CONSTRAINT [DF_tblGameID1_SETimer]  DEFAULT ('') FOR [SETimer]
GO
/****** Object:  Default [DF_tblGameID1_PKTimer]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblGameID1] ADD  CONSTRAINT [DF_tblGameID1_PKTimer]  DEFAULT (0) FOR [PKTimer]
GO
/****** Object:  Default [DF_tblGameID_Color1]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblGameID1] ADD  CONSTRAINT [DF_tblGameID_Color1]  DEFAULT (255) FOR [Color1]
GO
/****** Object:  Default [DF_tblGameID_Color2]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblGameID1] ADD  CONSTRAINT [DF_tblGameID_Color2]  DEFAULT (255) FOR [Color2]
GO
/****** Object:  Default [DF_tblGameID1_PoisonUsedDate]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblGameID1] ADD  CONSTRAINT [DF_tblGameID1_PoisonUsedDate]  DEFAULT ('1999-1-1 0:0:0') FOR [PoisonUsedDate]
GO
/****** Object:  Default [DF_tblGameID1_LovePoint]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblGameID1] ADD  CONSTRAINT [DF_tblGameID1_LovePoint]  DEFAULT (0) FOR [LovePoint]
GO
/****** Object:  Default [DF_tblGameID1_ArmyHired]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblGameID1] ADD  CONSTRAINT [DF_tblGameID1_ArmyHired]  DEFAULT (0) FOR [ArmyHired]
GO
/****** Object:  Default [DF_tblGameID1_ArmyMarkIndex]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblGameID1] ADD  CONSTRAINT [DF_tblGameID1_ArmyMarkIndex]  DEFAULT (0) FOR [ArmyMarkIndex]
GO
/****** Object:  Default [DF_tblGameID1_Permission]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblGameID1] ADD  CONSTRAINT [DF_tblGameID1_Permission]  DEFAULT (0) FOR [Permission]
GO
/****** Object:  Default [DF_tblGameID1_BonusInitCount]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblGameID1] ADD  CONSTRAINT [DF_tblGameID1_BonusInitCount]  DEFAULT (0) FOR [BonusInitCount]
GO
/****** Object:  Default [DF_tblGameID1_StoryQuestState]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblGameID1] ADD  CONSTRAINT [DF_tblGameID1_StoryQuestState]  DEFAULT (0) FOR [StoryQuestState]
GO
/****** Object:  Default [DF_tblGameID1_QuestItem]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblGameID1] ADD  CONSTRAINT [DF_tblGameID1_QuestItem]  DEFAULT ('') FOR [QuestItem]
GO
/****** Object:  Default [DF_tblGameID1_SubQuestKind]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblGameID1] ADD  CONSTRAINT [DF_tblGameID1_SubQuestKind]  DEFAULT (0) FOR [SubQuestKind]
GO
/****** Object:  Default [DF_tblGameID1_SubQuestDone]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblGameID1] ADD  CONSTRAINT [DF_tblGameID1_SubQuestDone]  DEFAULT (0) FOR [SubQuestDone]
GO
/****** Object:  Default [DF_tblGameID1_SubQuestClientNPCID]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblGameID1] ADD  CONSTRAINT [DF_tblGameID1_SubQuestClientNPCID]  DEFAULT ('') FOR [SubQuestClientNPCID]
GO
/****** Object:  Default [DF_tblGameID1_SubQuestClientNPCFace]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblGameID1] ADD  CONSTRAINT [DF_tblGameID1_SubQuestClientNPCFace]  DEFAULT ((-1)) FOR [SubQuestClientNPCFace]
GO
/****** Object:  Default [DF_tblGameID1_SubQuestClientNPCMap]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblGameID1] ADD  CONSTRAINT [DF_tblGameID1_SubQuestClientNPCMap]  DEFAULT ((-1)) FOR [SubQuestClientNPCMap]
GO
/****** Object:  Default [DF_tblGameID1_SubQuestItem]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblGameID1] ADD  CONSTRAINT [DF_tblGameID1_SubQuestItem]  DEFAULT ('') FOR [SubQuestItem]
GO
/****** Object:  Default [DF_tblGameID1_SubQuestDestFace]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblGameID1] ADD  CONSTRAINT [DF_tblGameID1_SubQuestDestFace]  DEFAULT ((-1)) FOR [SubQuestDestFace]
GO
/****** Object:  Default [DF_tblGameID1_SubQuestDestMap]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblGameID1] ADD  CONSTRAINT [DF_tblGameID1_SubQuestDestMap]  DEFAULT ((-1)) FOR [SubQuestDestMap]
GO
/****** Object:  Default [DF_tblGameID1_SubQuestTimer]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblGameID1] ADD  CONSTRAINT [DF_tblGameID1_SubQuestTimer]  DEFAULT (0) FOR [SubQuestTimer]
GO
/****** Object:  Default [DF_tblGameID1_SubQuestGiftExperience]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblGameID1] ADD  CONSTRAINT [DF_tblGameID1_SubQuestGiftExperience]  DEFAULT (0) FOR [SubQuestGiftExperience]
GO
/****** Object:  Default [DF_tblGameID1_SubQuestGiftFame]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblGameID1] ADD  CONSTRAINT [DF_tblGameID1_SubQuestGiftFame]  DEFAULT (0) FOR [SubQuestGiftFame]
GO
/****** Object:  Default [DF_tblGameID1_SubQuestGiftItem]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblGameID1] ADD  CONSTRAINT [DF_tblGameID1_SubQuestGiftItem]  DEFAULT ('') FOR [SubQuestGiftItem]
GO
/****** Object:  Default [DF_tblGameID1_OPArmy]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblGameID1] ADD  CONSTRAINT [DF_tblGameID1_OPArmy]  DEFAULT (0) FOR [OPArmy]
GO
/****** Object:  Default [DF_tblGameID1_OPPKTimer]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblGameID1] ADD  CONSTRAINT [DF_tblGameID1_OPPKTimer]  DEFAULT (0) FOR [OPPKTimer]
GO
/****** Object:  Default [DF_tblGameID1_SurvivalEvent]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblGameID1] ADD  CONSTRAINT [DF_tblGameID1_SurvivalEvent]  DEFAULT (0) FOR [SurvivalEvent]
GO
/****** Object:  Default [DF_tblGameID1_SurvivalTime]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblGameID1] ADD  CONSTRAINT [DF_tblGameID1_SurvivalTime]  DEFAULT (0) FOR [SurvivalTime]
GO
/****** Object:  Default [DF_tblGameID1_Bonus2]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblGameID1] ADD  CONSTRAINT [DF_tblGameID1_Bonus2]  DEFAULT (0) FOR [Bonus2]
GO
/****** Object:  Default [DF_tblGameID1_SBonus]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblGameID1] ADD  CONSTRAINT [DF_tblGameID1_SBonus]  DEFAULT (0) FOR [SBonus]
GO
/****** Object:  Default [DF_tblGameID1_STotalBonus]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblGameID1] ADD  CONSTRAINT [DF_tblGameID1_STotalBonus]  DEFAULT (0) FOR [STotalBonus]
GO
/****** Object:  Default [DF_tblGameID1_PKPenaltyCount]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblGameID1] ADD  CONSTRAINT [DF_tblGameID1_PKPenaltyCount]  DEFAULT (0) FOR [PKPenaltyCount]
GO
/****** Object:  Default [DF_tblGameID1_PKPenaltyDecreaseTimer]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblGameID1] ADD  CONSTRAINT [DF_tblGameID1_PKPenaltyDecreaseTimer]  DEFAULT (0) FOR [PKPenaltyDecreaseTimer]
GO
/****** Object:  Default [DF_tblGameID1_SigMoney]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblGameID1] ADD  CONSTRAINT [DF_tblGameID1_SigMoney]  DEFAULT (0) FOR [SigMoney]
GO
/****** Object:  Default [DF_tblGameID1_BankSigMoney]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblGameID1] ADD  CONSTRAINT [DF_tblGameID1_BankSigMoney]  DEFAULT (0) FOR [BankSigMoney]
GO
/****** Object:  Default [DF_tblGameID1_BankItem2]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblGameID1] ADD  CONSTRAINT [DF_tblGameID1_BankItem2]  DEFAULT ('') FOR [BankItem2]
GO
/****** Object:  Default [DF_tblGameID1_TLETimer]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblGameID1] ADD  CONSTRAINT [DF_tblGameID1_TLETimer]  DEFAULT ('') FOR [TLETimer]
GO
/****** Object:  Default [DF__tblGameID__AddMa__55B597A7]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblGameIDExpand] ADD  DEFAULT ((0)) FOR [AddMarkCount]
GO
/****** Object:  Default [DF_tblGMCommandLog_Time]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblGMCommandLog1] ADD  CONSTRAINT [DF_tblGMCommandLog_Time]  DEFAULT (getdate()) FOR [Time]
GO
/****** Object:  Default [DF__tblHardco__Creat__59F03CDF]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblHardcoreCharacters] ADD  DEFAULT (getdate()) FOR [CreatedAt]
GO
/****** Object:  Default [DF_tblIndefenceDayEvent_Time]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblIndependenceDayEvent1] ADD  CONSTRAINT [DF_tblIndefenceDayEvent_Time]  DEFAULT (getdate()) FOR [Time]
GO
/****** Object:  Default [DF__tblItemDr__UseTi__5A7A4CC4]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblItemDreamBoxListLog1] ADD  DEFAULT (getdate()) FOR [UseTime]
GO
/****** Object:  Default [DF_tblLegalProtection_LegalDefenseTimer]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblLegalProtection1] ADD  CONSTRAINT [DF_tblLegalProtection_LegalDefenseTimer]  DEFAULT (0) FOR [LegalDefenseTimer]
GO
/****** Object:  Default [DF_tblMedalResult1_GoldMedal]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblMedalResult1] ADD  CONSTRAINT [DF_tblMedalResult1_GoldMedal]  DEFAULT (0) FOR [GoldMedal]
GO
/****** Object:  Default [DF_tblMedalResult1_SilverMedal]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblMedalResult1] ADD  CONSTRAINT [DF_tblMedalResult1_SilverMedal]  DEFAULT (0) FOR [SilverMedal]
GO
/****** Object:  Default [DF_tblMedalResult1_BronzeMedal]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblMedalResult1] ADD  CONSTRAINT [DF_tblMedalResult1_BronzeMedal]  DEFAULT (0) FOR [BronzeMedal]
GO
/****** Object:  Default [DF_tblOccupiedBillID_LoginTime]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblOccupiedBillID] ADD  CONSTRAINT [DF_tblOccupiedBillID_LoginTime]  DEFAULT (getdate()) FOR [LoginTime]
GO
/****** Object:  Default [DF_tblOccupiedBillID_Remove]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblOccupiedBillID] ADD  CONSTRAINT [DF_tblOccupiedBillID_Remove]  DEFAULT (0) FOR [KillBillID]
GO
/****** Object:  Default [DF_tblOperatorLoginLog_Time]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblOperatorConnectionLog] ADD  CONSTRAINT [DF_tblOperatorLoginLog_Time]  DEFAULT (getdate()) FOR [Time]
GO
/****** Object:  Default [DF_tblPayLog_Note]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblPayLog] ADD  CONSTRAINT [DF_tblPayLog_Note]  DEFAULT ('') FOR [Note]
GO
/****** Object:  Default [DF__tblPlayer__LogTi__010A0A00]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblPlayerIPLog] ADD  DEFAULT (getdate()) FOR [LogTime]
GO
/****** Object:  Default [DF_tblPPPCorpIP_TotalUseTime]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblPPPCorpIP] ADD  CONSTRAINT [DF_tblPPPCorpIP_TotalUseTime]  DEFAULT (0) FOR [TotalUseTime]
GO
/****** Object:  Default [DF_tblRedmoonEvent_RegDate]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblRedmoonEvent] ADD  CONSTRAINT [DF_tblRedmoonEvent_RegDate]  DEFAULT (getdate()) FOR [RegDate]
GO
/****** Object:  Default [DF_tblShop_DateLimit]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblShop] ADD  CONSTRAINT [DF_tblShop_DateLimit]  DEFAULT ('1999-1-1 0:0:0') FOR [DateLimit]
GO
/****** Object:  Default [DF_tblShop_TempDateLimit]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblShop] ADD  CONSTRAINT [DF_tblShop_TempDateLimit]  DEFAULT ('1999-1-1 0:0:0') FOR [TempDateLimit]
GO
/****** Object:  Default [DF_tblShop_TimeLimit]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblShop] ADD  CONSTRAINT [DF_tblShop_TimeLimit]  DEFAULT (0) FOR [TimeLimit]
GO
/****** Object:  Default [DF_tblShop_TimeLimitModifyDate]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblShop] ADD  CONSTRAINT [DF_tblShop_TimeLimitModifyDate]  DEFAULT ('1999-1-1 0:0:0') FOR [TimeLimitModifyDate]
GO
/****** Object:  Default [DF_tblShop_ConcurrentIPCount]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblShop] ADD  CONSTRAINT [DF_tblShop_ConcurrentIPCount]  DEFAULT (0) FOR [ConcurrentIPCount]
GO
/****** Object:  Default [DF_tblShop_TempConcurrentIPCount]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblShop] ADD  CONSTRAINT [DF_tblShop_TempConcurrentIPCount]  DEFAULT (0) FOR [TempConcurrentIPCount]
GO
/****** Object:  Default [DF_tblShop_TempModifyDate]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblShop] ADD  CONSTRAINT [DF_tblShop_TempModifyDate]  DEFAULT ('2000-2-3 12:59:59') FOR [TempModifyDate]
GO
/****** Object:  Default [DF_tblShop_RegDate]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblShop] ADD  CONSTRAINT [DF_tblShop_RegDate]  DEFAULT ('1999-1-1 0:0:0') FOR [RegDate]
GO
/****** Object:  Default [DF_tblShop_WarbibleIP]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblShop] ADD  CONSTRAINT [DF_tblShop_WarbibleIP]  DEFAULT (0) FOR [WarbibleIP]
GO
/****** Object:  Default [DF_tblShop_RedMoonIP]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblShop] ADD  CONSTRAINT [DF_tblShop_RedMoonIP]  DEFAULT (0) FOR [RedMoonIP]
GO
/****** Object:  Default [DF_tblShop_MonthPay]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblShop] ADD  CONSTRAINT [DF_tblShop_MonthPay]  DEFAULT (0) FOR [MonthPay]
GO
/****** Object:  Default [DF_tblShop_BillState]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblShop] ADD  CONSTRAINT [DF_tblShop_BillState]  DEFAULT ('') FOR [BillState]
GO
/****** Object:  Default [DF_tblShop_Note1]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblShop] ADD  CONSTRAINT [DF_tblShop_Note1]  DEFAULT ('') FOR [Note1]
GO
/****** Object:  Default [DF_tblShop_Note2]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblShop] ADD  CONSTRAINT [DF_tblShop_Note2]  DEFAULT ('') FOR [Note2]
GO
/****** Object:  Default [DF_tblShop_Note3]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblShop] ADD  CONSTRAINT [DF_tblShop_Note3]  DEFAULT ('') FOR [Note3]
GO
/****** Object:  Default [DF_tblShop_Note4]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblShop] ADD  CONSTRAINT [DF_tblShop_Note4]  DEFAULT ('') FOR [Note4]
GO
/****** Object:  Default [DF_tblShop_Note5]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblShop] ADD  CONSTRAINT [DF_tblShop_Note5]  DEFAULT ('') FOR [Note5]
GO
/****** Object:  Default [DF_tblShop_Note6]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblShop] ADD  CONSTRAINT [DF_tblShop_Note6]  DEFAULT ('') FOR [Note6]
GO
/****** Object:  Default [DF_tblShop_Note7]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblShop] ADD  CONSTRAINT [DF_tblShop_Note7]  DEFAULT ('') FOR [Note7]
GO
/****** Object:  Default [DF_tblShop_Note8]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblShop] ADD  CONSTRAINT [DF_tblShop_Note8]  DEFAULT ('') FOR [Note8]
GO
/****** Object:  Default [DF_tblShop_Note9]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblShop] ADD  CONSTRAINT [DF_tblShop_Note9]  DEFAULT ('') FOR [Note9]
GO
/****** Object:  Default [DF_tblShop_Note10]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblShop] ADD  CONSTRAINT [DF_tblShop_Note10]  DEFAULT ('') FOR [Note10]
GO
/****** Object:  Default [DF_tblShop_TempTimeLimit]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblShop] ADD  CONSTRAINT [DF_tblShop_TempTimeLimit]  DEFAULT (0) FOR [TempTimeLimit]
GO
/****** Object:  Default [DF_tblShopBillLog_ConfirmDate]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblShopBillLog] ADD  CONSTRAINT [DF_tblShopBillLog_ConfirmDate]  DEFAULT ('1980-1-1 0:0:0') FOR [ConfirmDate]
GO
/****** Object:  Default [DF_tblShopBillLog_BillName]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblShopBillLog] ADD  CONSTRAINT [DF_tblShopBillLog_BillName]  DEFAULT ('') FOR [BillName]
GO
/****** Object:  Default [DF_tblShopBillLog_BankName]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblShopBillLog] ADD  CONSTRAINT [DF_tblShopBillLog_BankName]  DEFAULT ('') FOR [BankName]
GO
/****** Object:  Default [DF_tblShopBillLog_Note]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblShopBillLog] ADD  CONSTRAINT [DF_tblShopBillLog_Note]  DEFAULT ('') FOR [Note]
GO
/****** Object:  Default [DF_tblShopBillLog_Kind]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblShopBillLog] ADD  CONSTRAINT [DF_tblShopBillLog_Kind]  DEFAULT ('') FOR [Kind]
GO
/****** Object:  Default [DF_tblShopBillLog_Minute]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblShopBillLog] ADD  CONSTRAINT [DF_tblShopBillLog_Minute]  DEFAULT (0) FOR [Minute]
GO
/****** Object:  Default [DF_tblShopBillLog2_BillName]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblShopBillLog2] ADD  CONSTRAINT [DF_tblShopBillLog2_BillName]  DEFAULT ('') FOR [BillName]
GO
/****** Object:  Default [DF_tblShopBillLog2_BankName]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblShopBillLog2] ADD  CONSTRAINT [DF_tblShopBillLog2_BankName]  DEFAULT ('') FOR [BankName]
GO
/****** Object:  Default [DF_tblShopBillLog2_Note]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblShopBillLog2] ADD  CONSTRAINT [DF_tblShopBillLog2_Note]  DEFAULT ('') FOR [Note]
GO
/****** Object:  Default [DF_tblShopIP_Using]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblShopIP] ADD  CONSTRAINT [DF_tblShopIP_Using]  DEFAULT (0) FOR [Using]
GO
/****** Object:  Default [DF_tblShopIP_IPServerIndex]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblShopIP] ADD  CONSTRAINT [DF_tblShopIP_IPServerIndex]  DEFAULT ((-1)) FOR [IPServerIndex]
GO
/****** Object:  Default [DF_tblShopIP_ConnKind]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblShopIP] ADD  CONSTRAINT [DF_tblShopIP_ConnKind]  DEFAULT (0) FOR [ConnKind]
GO
/****** Object:  Default [DF_tblShopTimeUseLog_LoginTime]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblShopTimeUseLog] ADD  CONSTRAINT [DF_tblShopTimeUseLog_LoginTime]  DEFAULT (getdate()) FOR [LoginTime]
GO
/****** Object:  Default [DF_tblShopTimeUseLog_UseTime]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblShopTimeUseLog] ADD  CONSTRAINT [DF_tblShopTimeUseLog_UseTime]  DEFAULT (0) FOR [UseTime]
GO
/****** Object:  Default [DF_tblShopTimeUseLog_TimeDiff]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblShopTimeUseLog] ADD  CONSTRAINT [DF_tblShopTimeUseLog_TimeDiff]  DEFAULT (0) FOR [TimeDiff]
GO
/****** Object:  Default [DF_tblSpecialItem1_ItemDurability]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblSpecialItem1] ADD  CONSTRAINT [DF_tblSpecialItem1_ItemDurability]  DEFAULT (4) FOR [ItemDurability]
GO
/****** Object:  Default [DF_tblSpecialItem1_GameID]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblSpecialItem1] ADD  CONSTRAINT [DF_tblSpecialItem1_GameID]  DEFAULT ('') FOR [GameID]
GO
/****** Object:  Default [DF_tblSpecialItem1_WindowKind]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblSpecialItem1] ADD  CONSTRAINT [DF_tblSpecialItem1_WindowKind]  DEFAULT (0) FOR [WindowKind]
GO
/****** Object:  Default [DF_tblSpecialItem1_WindowIndex]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblSpecialItem1] ADD  CONSTRAINT [DF_tblSpecialItem1_WindowIndex]  DEFAULT (0) FOR [WindowIndex]
GO
/****** Object:  Default [DF_tblSpecialItem1_MiscTime]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblSpecialItem1] ADD  CONSTRAINT [DF_tblSpecialItem1_MiscTime]  DEFAULT ('1990-1-1') FOR [MiscTime]
GO
/****** Object:  Default [DF_tblSpecialItem1_AttackGrade]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblSpecialItem1] ADD  CONSTRAINT [DF_tblSpecialItem1_AttackGrade]  DEFAULT (0) FOR [AttackGrade]
GO
/****** Object:  Default [DF_tblSpecialItem1]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblSpecialItem1] ADD  CONSTRAINT [DF_tblSpecialItem1]  DEFAULT (0) FOR [StrengthGrade]
GO
/****** Object:  Default [DF_tblSpecialItem1_1]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblSpecialItem1] ADD  CONSTRAINT [DF_tblSpecialItem1_1]  DEFAULT (0) FOR [SpiritGrade]
GO
/****** Object:  Default [DF_tblSpecialItem1_2]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblSpecialItem1] ADD  CONSTRAINT [DF_tblSpecialItem1_2]  DEFAULT (0) FOR [DexterityGrade]
GO
/****** Object:  Default [DF_tblSpecialItem1_PowerGrade]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblSpecialItem1] ADD  CONSTRAINT [DF_tblSpecialItem1_PowerGrade]  DEFAULT (0) FOR [PowerGrade]
GO
/****** Object:  Default [DF_tblSpecialItemGrowthLog1_Time]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblSpecialItemGrowthLog1] ADD  CONSTRAINT [DF_tblSpecialItemGrowthLog1_Time]  DEFAULT (getdate()) FOR [Time]
GO
/****** Object:  Default [DF_tblSpecialItemLimit_ItemCountLimit]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblSpecialItemLimit1] ADD  CONSTRAINT [DF_tblSpecialItemLimit_ItemCountLimit]  DEFAULT (0) FOR [ItemCountLimit]
GO
/****** Object:  Default [DF_tblSpecialItemLog1_Time]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblSpecialItemLog1] ADD  CONSTRAINT [DF_tblSpecialItemLog1_Time]  DEFAULT (getdate()) FOR [Time]
GO
/****** Object:  Default [DF_tblSpecialItemLog1_Count]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblSpecialItemLog1] ADD  CONSTRAINT [DF_tblSpecialItemLog1_Count]  DEFAULT (0) FOR [LogItemCount]
GO
/****** Object:  Default [DF_tblSpecialItemLog1_ID]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblSpecialItemLog1] ADD  CONSTRAINT [DF_tblSpecialItemLog1_ID]  DEFAULT (0) FOR [ID]
GO
/****** Object:  Default [DF_tblSpecialItemLog1_ItemKind]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblSpecialItemLog1] ADD  CONSTRAINT [DF_tblSpecialItemLog1_ItemKind]  DEFAULT (0) FOR [ItemKind]
GO
/****** Object:  Default [DF_tblSpecialItemLog1_ItemIndex]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblSpecialItemLog1] ADD  CONSTRAINT [DF_tblSpecialItemLog1_ItemIndex]  DEFAULT (0) FOR [ItemIndex]
GO
/****** Object:  Default [DF_tblSpecialItemLog1_ItemDurability]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblSpecialItemLog1] ADD  CONSTRAINT [DF_tblSpecialItemLog1_ItemDurability]  DEFAULT (0) FOR [ItemDurability]
GO
/****** Object:  Default [DF_tblSpecialItemLog1_Position]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblSpecialItemLog1] ADD  CONSTRAINT [DF_tblSpecialItemLog1_Position]  DEFAULT (0) FOR [Position]
GO
/****** Object:  Default [DF_tblSpecialItemLog1_Map]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblSpecialItemLog1] ADD  CONSTRAINT [DF_tblSpecialItemLog1_Map]  DEFAULT (0) FOR [Map]
GO
/****** Object:  Default [DF_tblSpecialItemLog1_X]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblSpecialItemLog1] ADD  CONSTRAINT [DF_tblSpecialItemLog1_X]  DEFAULT (0) FOR [X]
GO
/****** Object:  Default [DF_tblSpecialItemLog1_Y]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblSpecialItemLog1] ADD  CONSTRAINT [DF_tblSpecialItemLog1_Y]  DEFAULT (0) FOR [Y]
GO
/****** Object:  Default [DF_tblSpecialItemLog1_TileKind]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblSpecialItemLog1] ADD  CONSTRAINT [DF_tblSpecialItemLog1_TileKind]  DEFAULT (0) FOR [TileKind]
GO
/****** Object:  Default [DF_tblSpecialItemLog1_GameID]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblSpecialItemLog1] ADD  CONSTRAINT [DF_tblSpecialItemLog1_GameID]  DEFAULT ('') FOR [GameID]
GO
/****** Object:  Default [DF_tblSpecialItemLog1_WindowKind]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblSpecialItemLog1] ADD  CONSTRAINT [DF_tblSpecialItemLog1_WindowKind]  DEFAULT (0) FOR [WindowKind]
GO
/****** Object:  Default [DF_tblSpecialItemLog1_WindowIndex]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblSpecialItemLog1] ADD  CONSTRAINT [DF_tblSpecialItemLog1_WindowIndex]  DEFAULT (0) FOR [WindowIndex]
GO
/****** Object:  Default [DF_tblSpecialItemLog1_MiscTime]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblSpecialItemLog1] ADD  CONSTRAINT [DF_tblSpecialItemLog1_MiscTime]  DEFAULT ('1990-1-1') FOR [MiscTime]
GO
/****** Object:  Default [DF_tblSpecialItemLog1_AttackGrade]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblSpecialItemLog1] ADD  CONSTRAINT [DF_tblSpecialItemLog1_AttackGrade]  DEFAULT (0) FOR [AttackGrade]
GO
/****** Object:  Default [DF_tblSpecialItemLog1_StrengthGrade]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblSpecialItemLog1] ADD  CONSTRAINT [DF_tblSpecialItemLog1_StrengthGrade]  DEFAULT (0) FOR [StrengthGrade]
GO
/****** Object:  Default [DF_tblSpecialItemLog1_SpiritGrade]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblSpecialItemLog1] ADD  CONSTRAINT [DF_tblSpecialItemLog1_SpiritGrade]  DEFAULT (0) FOR [SpiritGrade]
GO
/****** Object:  Default [DF_tblSpecialItemLog1_DexterityGrade]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblSpecialItemLog1] ADD  CONSTRAINT [DF_tblSpecialItemLog1_DexterityGrade]  DEFAULT (0) FOR [DexterityGrade]
GO
/****** Object:  Default [DF_tblSpecialItemLog1_PowerGrade]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblSpecialItemLog1] ADD  CONSTRAINT [DF_tblSpecialItemLog1_PowerGrade]  DEFAULT (0) FOR [PowerGrade]
GO
/****** Object:  Default [DF_tblSpecialItemShop1_ItemCount]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblSpecialItemShop1] ADD  CONSTRAINT [DF_tblSpecialItemShop1_ItemCount]  DEFAULT (0) FOR [ItemCount]
GO
/****** Object:  Default [DF_tblSpecialItemShop1_InstantItem]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblSpecialItemShop1] ADD  CONSTRAINT [DF_tblSpecialItemShop1_InstantItem]  DEFAULT (0) FOR [InstantItem]
GO
/****** Object:  Default [DF_tblSpecialItemShopLog1_Time]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblSpecialItemShopLog1] ADD  CONSTRAINT [DF_tblSpecialItemShopLog1_Time]  DEFAULT (getdate()) FOR [Time]
GO
/****** Object:  Default [DF_tblSubArmyList1_Permission]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblSubArmyList1] ADD  CONSTRAINT [DF_tblSubArmyList1_Permission]  DEFAULT (0) FOR [Permission]
GO
/****** Object:  Default [DF_tblSubArmyList1_Notice]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblSubArmyList1] ADD  CONSTRAINT [DF_tblSubArmyList1_Notice]  DEFAULT ('') FOR [Notice]
GO
/****** Object:  Default [DF_tblUserBillLog_BankName]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblUserBillLog] ADD  CONSTRAINT [DF_tblUserBillLog_BankName]  DEFAULT ('') FOR [BankName]
GO
/****** Object:  Default [DF_tblUserBillLog_Note]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblUserBillLog] ADD  CONSTRAINT [DF_tblUserBillLog_Note]  DEFAULT ('') FOR [Note]
GO
/****** Object:  Default [DF_tblUserBillLog_Kind]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblUserBillLog] ADD  CONSTRAINT [DF_tblUserBillLog_Kind]  DEFAULT ('') FOR [Kind]
GO
/****** Object:  Default [DF_tblUserStat1_User]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblUserStat1] ADD  CONSTRAINT [DF_tblUserStat1_User]  DEFAULT (0) FOR [Total]
GO
/****** Object:  Default [DF_tblUserStat1_UserMax]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblUserStat1] ADD  CONSTRAINT [DF_tblUserStat1_UserMax]  DEFAULT (0) FOR [TotalMax]
GO
/****** Object:  Default [DF_tblUSRMAdmin_AdminLvl]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblUSRMAdmin] ADD  CONSTRAINT [DF_tblUSRMAdmin_AdminLvl]  DEFAULT (0) FOR [AdminLvl]
GO
/****** Object:  Default [DF_tblVerifyLog_MINUTE]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[tblVerifyLog] ADD  CONSTRAINT [DF_tblVerifyLog_MINUTE]  DEFAULT (0) FOR [MINUTE]
GO
/****** Object:  Default [DF__UpdateLog__LogTi__263B8EAF]    Script Date: 07/25/2024 12:01:17 ******/
ALTER TABLE [dbo].[UpdateLog] ADD  DEFAULT (getdate()) FOR [LogTime]
GO
