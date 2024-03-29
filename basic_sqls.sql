USE [master]
GO
/****** Object:  Database [basic]    Script Date: 2023/02/12 9:16:06 ******/
CREATE DATABASE [basic]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'basic', FILENAME = N'C:\sys\basic_sqls.mdf' , SIZE = 6208KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'basic_log', FILENAME = N'C:\sys\basic_sqls.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [basic] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [basic].[dbo].[sp_fulltext_database] @action = 'disable'
end
GO
ALTER DATABASE [basic] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [basic] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [basic] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [basic] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [basic] SET ARITHABORT OFF 
GO
ALTER DATABASE [basic] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [basic] SET AUTO_SHRINK ON 
GO
ALTER DATABASE [basic] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [basic] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [basic] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [basic] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [basic] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [basic] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [basic] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [basic] SET  DISABLE_BROKER 
GO
ALTER DATABASE [basic] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [basic] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [basic] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [basic] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [basic] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [basic] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [basic] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [basic] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [basic] SET  MULTI_USER 
GO
ALTER DATABASE [basic] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [basic] SET DB_CHAINING OFF 
GO
ALTER DATABASE [basic] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [basic] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [basic] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [basic] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [basic] SET QUERY_STORE = OFF
GO
USE [basic]
GO
/****** Object:  UserDefinedFunction [dbo].[QF_FORMAT_日付]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[QF_FORMAT_日付] 
(	
	@日付		DATETIME,
	@書式		NVARCHAR(1)
)
RETURNS NVARCHAR(10)
AS
-- (例)
-- SELECT dbo.F_Format_日付(GETDATE(),'-') AS 日付
--
-- (結果)
-- 2009-01-01
--
BEGIN
	DECLARE @値 NVARCHAR(10)
	SELECT @値=(
	CONVERT(NVARCHAR(4),DATEPART(yy,@日付)) +
	@書式 +
	CONVERT(NVARCHAR(2),DATEPART(mm,@日付)) +
	@書式 +
	CONVERT(NVARCHAR(2),DATEPART(dd,@日付)))
	RETURN @値
END



GO
/****** Object:  UserDefinedFunction [dbo].[QF_STR日付]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[QF_STR日付]
(@value Datetime)
RETURNS nvarchar(10)
AS
--日付を文字列として返す
Begin

	-- yyyy/mm/dd CONVERT(nvarchar,GETDATE(),111)
	-- yy/mm/dd CONVERT(nvarchar,GETDATE(),11)

	DECLARE @xValue nvarchar(10)
	--select SUBSTRING(CONVERT(nvarchar,GETDATE(),111),1,10)
	SET @xValue=SUBSTRING(CONVERT(nvarchar,@value,111),1,10)
	--NULL は除外する
	SET @xValue=ISNULL(@xValue,'')

	Return @xValue

end



GO
/****** Object:  UserDefinedFunction [dbo].[QF_STR日付_月末]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[QF_STR日付_月末]
(
	@value Datetime
)
	--【目的】月末日付を文字列として返す
	-- '2008/01/31' などと返す
	RETURNS Datetime
	-- RETURNS nvarchar(10)
AS

Begin
	--DECLARE @xValue nvarchar(10)
	DECLARE @xValue datetime

--	DECLARE @月初_STR nvarchar(10)
--	DECLARE @月初 datetime
--	DECLARE @翌月初 datetime
--	DECLARE @月末 datetime

--	SET @月初_STR = DATENAME(YY,@value)+'/'+DATENAME(MM,@value)+N'/1'
--	SET @月初 = SUBSTRING(CONVERT(nvarchar,@月初_STR ,111),1,10)
--	SET @翌月初= DATENAME(YY,@value)+'/'+DATEADD(MM,+1,@value)+N'/1'
	
SET  @xValue =  DATEADD(DAY,-1,CONVERT(DATETIME,(CONVERT(CHAR(7),DATEADD(MONTH,1,@value),111))))

	




-- ちゃんとコンバートされているか？
	DECLARE @判断 INT
	SET @判断=DATALENGTH(@xValue)
	IF @判断=10 
	BEGIN
		SET @xValue=(N'1980/01/01')
	END

	Return @xValue
End
GO
/****** Object:  UserDefinedFunction [dbo].[QF_STR日付2]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[QF_STR日付2](@value Datetime)
	RETURNS nvarchar(11)
AS
Begin
	DECLARE @xValue nvarchar(11)
	SET @xValue=CONVERT(nvarchar,YEAR(@value))+'年'+
				CONVERT(nvarchar,MONTH(@value))+'月'+
				CONVERT(nvarchar,DAY(@value))+'日'
	--NULL は除外する
	SET @xValue=ISNULL(@xValue,'')
	Return @xValue
end
GO
/****** Object:  UserDefinedFunction [dbo].[QF_TRIM]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[QF_TRIM](@文字列 nchar(30))
	RETURNS nchar(30) AS
--
-- 試しに作ってみたが
-- 結局戻りの値が 30 文字分返ってしまうので意味が無い
--
BEGIN 
		RETURN LTRIM(RTRIM(@文字列))
END
--BEGIN CATCH
--		RETURN ''
--END CATCH;
GO
/****** Object:  UserDefinedFunction [dbo].[QF_採番]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[QF_採番]
(
@フィールド nvarchar(50),
@テーブル nvarchar(50),
@条件 nvarchar(255)
)
RETURNS INT
AS
BEGIN
	DECLARE @番号 INT
	DECLARE @strSQL nvarchar(255)

	IF @条件=''
		SET @strSQL=N'select MAX('+@フィールド+') FROM '+@テーブル
	ELSE
		SET @strSQL=N'select MAX('+@フィールド+') FROM '+@テーブル+' WHERE '+@条件

	SET @番号=0
	EXEC @番号 =dbo.Q_SQL @strSQL 
	SET @番号=@番号+1
	Return @番号
END
GO
/****** Object:  UserDefinedFunction [dbo].[QF_文字の抽出]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[QF_文字の抽出]
(
)
RETURNS nvarchar(50)
AS
-- (動作テスト)
-- select dbo.QF_文字の抽出()
-- (結果)
-- 
BEGIN
	DECLARE @文字 nvarchar(50)
	DECLARE @X nvarchar(10)

	SET @X=N'2010/07/15'

	SET @文字=(SUBSTRING(@X,1,4))+'-'+(SUBSTRING(@X,6,2))+'-'+(SUBSTRING(@X,9,2))

	Return @文字
END

GO
/****** Object:  UserDefinedFunction [dbo].[QF_商品抽出]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[QF_商品抽出]
(
	@商品ID INT
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT
		商品名
	FROM 
		商品 
	WHERE 
		商品ID=@商品ID

)
GO
/****** Object:  View [dbo].[V_QF_商品抽出]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[V_QF_商品抽出]
AS
SELECT                  商品ID, 商品
FROM                     dbo.QF_商品抽出(2) AS QF_商品抽出
GO
/****** Object:  View [dbo].[V_STR日付]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[V_STR日付]
AS
SELECT                  dbo.QF_STR日付(更新日) AS w更新日, dbo.QF_STR日付2(更新日) AS w更新日2, 更新日
FROM                     dbo.商品
GO
/****** Object:  View [dbo].[V_日付抽出]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[V_日付抽出]
AS
SELECT                  見積ID, 見積日, 金額合計
FROM                     dbo.見積
WHERE                   (見積日 >= '2010/01/01 00:00:00') AND (見積日 <= '2010/04/12 23:59:59')
GO
/****** Object:  Table [dbo].[employee]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[employee](
	[id] [int] NOT NULL,
	[first_name] [nvarchar](255) NOT NULL,
	[last_name] [nvarchar](255) NOT NULL,
	[department_id] [int] NOT NULL,
	[height] [int] NOT NULL,
 CONSTRAINT [PK_employee] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MT数値]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MT数値](
	[ID] [int] NOT NULL,
	[数値A] [decimal](18, 3) NULL,
 CONSTRAINT [PK_MT数値] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[M在庫]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[M在庫](
	[店舗ID] [int] NOT NULL,
	[在庫ID] [int] NOT NULL,
	[区分] [nvarchar](10) NULL,
	[日付] [datetime] NULL,
	[商品ID] [int] NULL,
	[単価仕入] [float] NULL,
	[単価販売] [float] NULL,
	[数量] [float] NULL,
	[金額仕入] [float] NULL,
	[金額販売] [float] NULL,
	[備考] [nvarchar](50) NULL,
	[削除] [bit] NULL,
 CONSTRAINT [PK_在庫] PRIMARY KEY CLUSTERED 
(
	[店舗ID] ASC,
	[在庫ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[M仕入企業]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[M仕入企業](
	[店舗ID] [int] NOT NULL,
	[企業ID] [int] NOT NULL,
	[企業名] [nvarchar](20) NULL,
	[払日] [int] NULL,
	[担当ID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[店舗ID] ASC,
	[企業ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[M商品]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[M商品](
	[店舗ID] [int] NOT NULL,
	[商品ID] [int] NOT NULL,
	[商品名] [nvarchar](30) NULL,
	[単位] [nvarchar](10) NULL,
	[単価仕入] [float] NULL,
	[単価販売] [float] NULL,
	[削除] [bit] NULL,
	[販売開始日] [datetime] NULL,
	[販売終了日] [datetime] NULL,
	[更新日] [datetime] NULL,
	[表示順] [float] NULL,
	[商品区分A] [nvarchar](30) NULL,
	[商品区分B] [nvarchar](30) NULL,
	[商品区分C] [nvarchar](30) NULL,
 CONSTRAINT [PK_商品] PRIMARY KEY CLUSTERED 
(
	[店舗ID] ASC,
	[商品ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[M設定]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[M設定](
	[店舗ID] [int] NOT NULL,
	[設定] [nvarchar](30) NOT NULL,
	[型] [nvarchar](30) NULL,
	[値] [nvarchar](255) NULL,
	[リスト] [nvarchar](255) NULL,
	[削除] [bit] NULL,
 CONSTRAINT [PK_設定] PRIMARY KEY CLUSTERED 
(
	[店舗ID] ASC,
	[設定] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[M担当]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[M担当](
	[店舗ID] [int] NOT NULL,
	[担当ID] [int] NOT NULL,
	[担当] [nvarchar](30) NULL,
	[削除] [bit] NULL,
 CONSTRAINT [PK_担当] PRIMARY KEY CLUSTERED 
(
	[店舗ID] ASC,
	[担当ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[M店舗]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[M店舗](
	[店舗ID] [int] NOT NULL,
	[店舗名] [nvarchar](30) NULL,
	[削除] [bit] NULL,
 CONSTRAINT [PK_tennpo] PRIMARY KEY CLUSTERED 
(
	[店舗ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[M販売企業]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[M販売企業](
	[店舗ID] [int] NOT NULL,
	[企業ID] [int] NOT NULL,
	[企業名] [nvarchar](40) NULL,
	[締日] [int] NULL,
	[担当ID] [int] NULL,
 CONSTRAINT [PK__M会社__075714DC] PRIMARY KEY CLUSTERED 
(
	[企業ID] ASC,
	[店舗ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[M販売顧客]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[M販売顧客](
	[店舗ID] [int] NOT NULL,
	[顧客ID] [int] NOT NULL,
	[企業ID] [int] NULL,
	[顧客名] [nvarchar](20) NULL,
	[生年月日] [datetime] NULL,
	[締日] [int] NULL,
	[性別] [nvarchar](1) NULL,
	[担当ID] [int] NULL,
 CONSTRAINT [PK_顧客] PRIMARY KEY CLUSTERED 
(
	[店舗ID] ASC,
	[顧客ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PC_排他情報]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PC_排他情報](
	[ID] [int] NOT NULL,
	[PCNAME] [nvarchar](255) NOT NULL,
	[このテーブルの目的] [nvarchar](255) NULL,
 CONSTRAINT [PK_排他情報] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[S在庫月次]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[S在庫月次](
	[店舗ID] [int] NOT NULL,
	[在庫集計ID] [int] NOT NULL,
	[日付] [datetime] NULL,
	[商品ID] [int] NULL,
	[数量] [float] NULL,
 CONSTRAINT [PK__在庫月次集計区分 のコピー__1A9EF37A] PRIMARY KEY CLUSTERED 
(
	[店舗ID] ASC,
	[在庫集計ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[S在庫月次区分]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[S在庫月次区分](
	[店舗ID] [int] NOT NULL,
	[在庫集計ID] [int] NOT NULL,
	[日付] [datetime] NULL,
	[区分] [nvarchar](10) NULL,
	[商品ID] [int] NULL,
	[数量] [float] NULL,
 CONSTRAINT [PK_在庫集計] PRIMARY KEY CLUSTERED 
(
	[店舗ID] ASC,
	[在庫集計ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TEST001]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TEST001](
	[ID] [int] NOT NULL,
	[日付] [datetime] NULL,
	[a] [int] NULL,
	[b] [nvarchar](2) NULL,
 CONSTRAINT [PK_TEST] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TEST002]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TEST002](
	[ID] [int] NOT NULL,
	[画像] [image] NULL,
 CONSTRAINT [PK_TEST002] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[titles]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[titles](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[title] [nvarchar](50) NOT NULL,
	[price] [int] NOT NULL,
 CONSTRAINT [PK_titles] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Tボタン]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tボタン](
	[行] [int] NOT NULL,
	[列] [varchar](1) NOT NULL,
	[ボタン名] [varchar](30) NULL,
 CONSTRAINT [PK_Tボタン] PRIMARY KEY CLUSTERED 
(
	[行] ASC,
	[列] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[T社員]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T社員](
	[連番] [int] NOT NULL,
	[社員名] [nvarchar](50) NULL,
	[性別] [nchar](1) NULL,
	[生年月日] [date] NULL,
	[部門コード] [char](4) NULL,
 CONSTRAINT [PK_社員] PRIMARY KEY CLUSTERED 
(
	[連番] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[T部門]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T部門](
	[部門コード] [char](4) NOT NULL,
	[部門名] [nvarchar](50) NULL,
 CONSTRAINT [PK_部門] PRIMARY KEY CLUSTERED 
(
	[部門コード] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Wユニコード文字]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Wユニコード文字](
	[ID] [int] NOT NULL,
	[文字] [nvarchar](20) NULL,
	[読み方] [nvarchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[カレンダー]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[カレンダー](
	[PCNAME] [nvarchar](30) NOT NULL,
	[ID] [int] NOT NULL,
	[1] [nvarchar](2) NULL,
	[2] [nvarchar](2) NULL,
	[3] [nvarchar](2) NULL,
	[4] [nvarchar](2) NULL,
	[5] [nvarchar](2) NULL,
	[6] [nvarchar](2) NULL,
	[7] [nvarchar](2) NULL,
 CONSTRAINT [PK_カレンダー] PRIMARY KEY CLUSTERED 
(
	[PCNAME] ASC,
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[採番]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[採番](
	[PCNAME] [nvarchar](30) NOT NULL,
	[店舗ID] [int] NULL,
	[テーブル名] [nvarchar](200) NULL,
	[IDNew] [int] NULL,
	[IDOld] [int] NULL,
 CONSTRAINT [PK_採番_1] PRIMARY KEY CLUSTERED 
(
	[PCNAME] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[商品BK]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[商品BK](
	[ID] [int] NOT NULL,
	[商品] [nvarchar](50) NULL,
	[単価] [int] NULL,
	[数量] [int] NULL,
	[金額] [int] NULL,
 CONSTRAINT [PK_商品BK] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[販売_見積]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[販売_見積](
	[見積ID] [int] NOT NULL,
	[日付] [date] NULL,
	[金額] [int] NOT NULL,
	[課税対象額] [int] NOT NULL,
	[消費税] [int] NOT NULL,
	[合計金額] [int] NOT NULL,
 CONSTRAINT [PK_見積] PRIMARY KEY CLUSTERED 
(
	[見積ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[販売_見積詳細]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[販売_見積詳細](
	[見積詳細ID] [int] IDENTITY(1,1) NOT NULL,
	[行] [int] NOT NULL,
	[見積ID] [int] NOT NULL,
	[商品ID] [int] NOT NULL,
	[単価] [int] NOT NULL,
	[数量] [int] NOT NULL,
	[金額] [int] NULL,
	[税区分] [nvarchar](1) NULL,
	[課税対象額] [int] NULL,
 CONSTRAINT [PK_見積詳細] PRIMARY KEY CLUSTERED 
(
	[見積詳細ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[販売_仕入]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[販売_仕入](
	[見積ID] [int] NOT NULL,
	[日付] [date] NULL,
	[金額合計] [float] NULL,
 CONSTRAINT [PK__仕入__7EC1CEDB] PRIMARY KEY CLUSTERED 
(
	[見積ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[販売_商品]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[販売_商品](
	[商品ID] [int] IDENTITY(1,1) NOT NULL,
	[削除] [bit] NOT NULL,
	[更新日] [date] NOT NULL,
	[商品名] [nvarchar](50) NOT NULL,
	[単価] [int] NOT NULL,
	[単価税込] [int] NOT NULL,
	[備考] [nvarchar](200) NOT NULL,
 CONSTRAINT [PK_商品_1] PRIMARY KEY CLUSTERED 
(
	[商品ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[販売_商品_選択_PC01]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[販売_商品_選択_PC01](
	[商品ID] [int] NOT NULL,
 CONSTRAINT [PK_商品_選択_1] PRIMARY KEY CLUSTERED 
(
	[商品ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[販売_店舗]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[販売_店舗](
	[店舗ID] [int] NOT NULL,
	[店舗名] [nvarchar](30) NULL,
 CONSTRAINT [PK_販売_店舗] PRIMARY KEY CLUSTERED 
(
	[店舗ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[販売_入金]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[販売_入金](
	[入金ID] [int] NOT NULL,
	[入金日付] [date] NULL,
	[金額] [int] NOT NULL,
 CONSTRAINT [PK__入金__00AA174D] PRIMARY KEY CLUSTERED 
(
	[入金ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[販売_売上]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[販売_売上](
	[売上ID] [int] NOT NULL,
	[削除] [bit] NOT NULL,
	[更新日] [date] NOT NULL,
	[売上日] [date] NOT NULL,
	[課税対象額] [int] NOT NULL,
	[消費税率] [float] NULL,
	[消費税額] [int] NULL,
	[売上金額税込] [int] NOT NULL,
	[非課税対象額] [int] NOT NULL,
	[合計金額] [int] NOT NULL,
 CONSTRAINT [PK_売上] PRIMARY KEY CLUSTERED 
(
	[売上ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[販売_売上_選択_PC01]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[販売_売上_選択_PC01](
	[売上ID] [int] NOT NULL,
 CONSTRAINT [PK_売上_選択_PC01] PRIMARY KEY CLUSTERED 
(
	[売上ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[販売_売上詳細]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[販売_売上詳細](
	[売上詳細ID] [int] IDENTITY(1,1) NOT NULL,
	[行] [int] NOT NULL,
	[売上ID] [int] NOT NULL,
	[商品ID] [int] NOT NULL,
	[商品名] [nvarchar](30) NOT NULL,
	[単位] [nvarchar](10) NOT NULL,
	[単価仕入] [int] NOT NULL,
	[単価販売] [int] NOT NULL,
 CONSTRAINT [PK_販売_売上詳細] PRIMARY KEY CLUSTERED 
(
	[売上詳細ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[employee] ADD  CONSTRAINT [DF_employee_first_name]  DEFAULT (N'') FOR [first_name]
GO
ALTER TABLE [dbo].[employee] ADD  CONSTRAINT [DF_employee_last_name]  DEFAULT (N'') FOR [last_name]
GO
ALTER TABLE [dbo].[employee] ADD  CONSTRAINT [DF_employee_department_id]  DEFAULT ((0)) FOR [department_id]
GO
ALTER TABLE [dbo].[employee] ADD  CONSTRAINT [DF_employee_height]  DEFAULT ((0)) FOR [height]
GO
ALTER TABLE [dbo].[MT数値] ADD  CONSTRAINT [DF_MT数値_ID]  DEFAULT ((0)) FOR [ID]
GO
ALTER TABLE [dbo].[MT数値] ADD  CONSTRAINT [DF_MT数値_数値A]  DEFAULT ((0)) FOR [数値A]
GO
ALTER TABLE [dbo].[M在庫] ADD  CONSTRAINT [DF_在庫_店舗ID]  DEFAULT ((0)) FOR [店舗ID]
GO
ALTER TABLE [dbo].[M在庫] ADD  CONSTRAINT [DF_在庫_在庫ID]  DEFAULT ((0)) FOR [在庫ID]
GO
ALTER TABLE [dbo].[M在庫] ADD  CONSTRAINT [DF_在庫_区分]  DEFAULT (N'') FOR [区分]
GO
ALTER TABLE [dbo].[M在庫] ADD  CONSTRAINT [DF_在庫_日付]  DEFAULT (getdate()) FOR [日付]
GO
ALTER TABLE [dbo].[M在庫] ADD  CONSTRAINT [DF_在庫_商品ID]  DEFAULT ((0)) FOR [商品ID]
GO
ALTER TABLE [dbo].[M在庫] ADD  CONSTRAINT [DF_在庫_単価]  DEFAULT ((0)) FOR [単価仕入]
GO
ALTER TABLE [dbo].[M在庫] ADD  CONSTRAINT [DF_在庫_単価販売]  DEFAULT ((0)) FOR [単価販売]
GO
ALTER TABLE [dbo].[M在庫] ADD  CONSTRAINT [DF_在庫_数量]  DEFAULT ((0)) FOR [数量]
GO
ALTER TABLE [dbo].[M在庫] ADD  CONSTRAINT [DF_在庫_金額]  DEFAULT ((0)) FOR [金額仕入]
GO
ALTER TABLE [dbo].[M在庫] ADD  CONSTRAINT [DF_在庫_金額販売]  DEFAULT ((0)) FOR [金額販売]
GO
ALTER TABLE [dbo].[M在庫] ADD  CONSTRAINT [DF_在庫_備考]  DEFAULT (N'') FOR [備考]
GO
ALTER TABLE [dbo].[M在庫] ADD  CONSTRAINT [DF_在庫_削除]  DEFAULT ((0)) FOR [削除]
GO
ALTER TABLE [dbo].[M商品] ADD  CONSTRAINT [DF_商品_店舗ID]  DEFAULT ((0)) FOR [店舗ID]
GO
ALTER TABLE [dbo].[M商品] ADD  CONSTRAINT [DF_商品_ID]  DEFAULT ((0)) FOR [商品ID]
GO
ALTER TABLE [dbo].[M商品] ADD  CONSTRAINT [DF_商品_商品]  DEFAULT (N'') FOR [商品名]
GO
ALTER TABLE [dbo].[M商品] ADD  CONSTRAINT [DF_商品_単位]  DEFAULT (N'') FOR [単位]
GO
ALTER TABLE [dbo].[M商品] ADD  CONSTRAINT [DF_商品_単価仕入]  DEFAULT ((0)) FOR [単価仕入]
GO
ALTER TABLE [dbo].[M商品] ADD  CONSTRAINT [DF_商品_単価]  DEFAULT ((0)) FOR [単価販売]
GO
ALTER TABLE [dbo].[M商品] ADD  CONSTRAINT [DF_商品_削除]  DEFAULT ((0)) FOR [削除]
GO
ALTER TABLE [dbo].[M商品] ADD  CONSTRAINT [DF_商品_販売開始日]  DEFAULT (getdate()) FOR [販売開始日]
GO
ALTER TABLE [dbo].[M商品] ADD  CONSTRAINT [DF_商品_販売終了日]  DEFAULT (getdate()) FOR [販売終了日]
GO
ALTER TABLE [dbo].[M商品] ADD  CONSTRAINT [DF_商品_更新日]  DEFAULT (getdate()) FOR [更新日]
GO
ALTER TABLE [dbo].[M商品] ADD  CONSTRAINT [DF_商品_表示順]  DEFAULT ((0)) FOR [表示順]
GO
ALTER TABLE [dbo].[M商品] ADD  CONSTRAINT [DF_商品_商品区分A]  DEFAULT (N'') FOR [商品区分A]
GO
ALTER TABLE [dbo].[M商品] ADD  CONSTRAINT [DF_商品_商品区分B]  DEFAULT (N'') FOR [商品区分B]
GO
ALTER TABLE [dbo].[M商品] ADD  CONSTRAINT [DF_商品_商品区分C]  DEFAULT (N'') FOR [商品区分C]
GO
ALTER TABLE [dbo].[M設定] ADD  CONSTRAINT [DF_設定_店舗ID]  DEFAULT ((0)) FOR [店舗ID]
GO
ALTER TABLE [dbo].[M設定] ADD  CONSTRAINT [DF_設定_設定]  DEFAULT (N'') FOR [設定]
GO
ALTER TABLE [dbo].[M設定] ADD  CONSTRAINT [DF_設定_型]  DEFAULT (N'') FOR [型]
GO
ALTER TABLE [dbo].[M設定] ADD  CONSTRAINT [DF_設定_値]  DEFAULT (N'') FOR [値]
GO
ALTER TABLE [dbo].[M設定] ADD  CONSTRAINT [DF_設定_リスト]  DEFAULT (N'') FOR [リスト]
GO
ALTER TABLE [dbo].[M設定] ADD  CONSTRAINT [DF_設定_削除]  DEFAULT ((0)) FOR [削除]
GO
ALTER TABLE [dbo].[M担当] ADD  CONSTRAINT [DF_担当_店舗ID]  DEFAULT ((0)) FOR [店舗ID]
GO
ALTER TABLE [dbo].[M担当] ADD  CONSTRAINT [DF_担当_担当]  DEFAULT (N'') FOR [担当]
GO
ALTER TABLE [dbo].[M担当] ADD  CONSTRAINT [DF_担当_削除]  DEFAULT ((0)) FOR [削除]
GO
ALTER TABLE [dbo].[M店舗] ADD  CONSTRAINT [DF_tennpo_店舗名]  DEFAULT (N'') FOR [店舗名]
GO
ALTER TABLE [dbo].[M店舗] ADD  CONSTRAINT [DF_店舗_削除]  DEFAULT ((0)) FOR [削除]
GO
ALTER TABLE [dbo].[M販売顧客] ADD  CONSTRAINT [DF_顧客_店舗ID]  DEFAULT ((0)) FOR [店舗ID]
GO
ALTER TABLE [dbo].[M販売顧客] ADD  CONSTRAINT [DF_M販売顧客_顧客ID]  DEFAULT ((0)) FOR [顧客ID]
GO
ALTER TABLE [dbo].[M販売顧客] ADD  CONSTRAINT [DF_M販売顧客_企業ID]  DEFAULT ((0)) FOR [企業ID]
GO
ALTER TABLE [dbo].[M販売顧客] ADD  CONSTRAINT [DF_顧客_顧客名]  DEFAULT (N'') FOR [顧客名]
GO
ALTER TABLE [dbo].[M販売顧客] ADD  CONSTRAINT [DF_顧客_誕生日]  DEFAULT (getdate()) FOR [生年月日]
GO
ALTER TABLE [dbo].[M販売顧客] ADD  CONSTRAINT [DF_顧客_締日月]  DEFAULT ((0)) FOR [締日]
GO
ALTER TABLE [dbo].[M販売顧客] ADD  CONSTRAINT [DF_顧客_性別]  DEFAULT ('不') FOR [性別]
GO
ALTER TABLE [dbo].[M販売顧客] ADD  CONSTRAINT [DF_M顧客_担当ID]  DEFAULT ((0)) FOR [担当ID]
GO
ALTER TABLE [dbo].[PC_排他情報] ADD  CONSTRAINT [DF_排他情報_PCNAME]  DEFAULT (N'') FOR [PCNAME]
GO
ALTER TABLE [dbo].[PC_排他情報] ADD  CONSTRAINT [DF_排他情報_備考]  DEFAULT (N'') FOR [このテーブルの目的]
GO
ALTER TABLE [dbo].[S在庫月次] ADD  CONSTRAINT [DF_在庫月次集計_店舗ID]  DEFAULT ((0)) FOR [店舗ID]
GO
ALTER TABLE [dbo].[S在庫月次区分] ADD  CONSTRAINT [DF_在庫月次集計区分_店舗ID]  DEFAULT ((0)) FOR [店舗ID]
GO
ALTER TABLE [dbo].[S在庫月次区分] ADD  CONSTRAINT [DF_在庫集計_日付]  DEFAULT (getdate()) FOR [日付]
GO
ALTER TABLE [dbo].[S在庫月次区分] ADD  CONSTRAINT [DF_在庫集計_区分]  DEFAULT (N'') FOR [区分]
GO
ALTER TABLE [dbo].[S在庫月次区分] ADD  CONSTRAINT [DF_在庫集計_商品ID]  DEFAULT ((0)) FOR [商品ID]
GO
ALTER TABLE [dbo].[S在庫月次区分] ADD  CONSTRAINT [DF_在庫集計_数量]  DEFAULT ((0)) FOR [数量]
GO
ALTER TABLE [dbo].[TEST001] ADD  CONSTRAINT [DF_TEST_ID]  DEFAULT ((0)) FOR [ID]
GO
ALTER TABLE [dbo].[TEST001] ADD  CONSTRAINT [DF_TEST_商品]  DEFAULT (getdate()) FOR [日付]
GO
ALTER TABLE [dbo].[TEST001] ADD  CONSTRAINT [DF_TEST001_a]  DEFAULT ((0)) FOR [a]
GO
ALTER TABLE [dbo].[TEST001] ADD  CONSTRAINT [DF_TEST001_b]  DEFAULT ('') FOR [b]
GO
ALTER TABLE [dbo].[titles] ADD  CONSTRAINT [DF_titles_title]  DEFAULT ('') FOR [title]
GO
ALTER TABLE [dbo].[titles] ADD  CONSTRAINT [DF_titles_price]  DEFAULT ((0)) FOR [price]
GO
ALTER TABLE [dbo].[Tボタン] ADD  CONSTRAINT [DF_Tボタン_行]  DEFAULT ((0)) FOR [行]
GO
ALTER TABLE [dbo].[Tボタン] ADD  CONSTRAINT [DF_Tボタン_列]  DEFAULT (N'') FOR [列]
GO
ALTER TABLE [dbo].[Tボタン] ADD  CONSTRAINT [DF_Tボタン_ボタン名]  DEFAULT (N'') FOR [ボタン名]
GO
ALTER TABLE [dbo].[T社員] ADD  CONSTRAINT [DF_社員_社員名]  DEFAULT ('') FOR [社員名]
GO
ALTER TABLE [dbo].[T社員] ADD  CONSTRAINT [DF_社員_生年月日]  DEFAULT ('1920-01-01') FOR [生年月日]
GO
ALTER TABLE [dbo].[Wユニコード文字] ADD  CONSTRAINT [DF_Wユニコード文字_文字]  DEFAULT (N'') FOR [文字]
GO
ALTER TABLE [dbo].[Wユニコード文字] ADD  CONSTRAINT [DF_Wユニコード文字_読み方]  DEFAULT (N'') FOR [読み方]
GO
ALTER TABLE [dbo].[カレンダー] ADD  CONSTRAINT [DF_カレンダー_PCNAME]  DEFAULT (N'') FOR [PCNAME]
GO
ALTER TABLE [dbo].[カレンダー] ADD  CONSTRAINT [DF_カレンダー_ID]  DEFAULT ((0)) FOR [ID]
GO
ALTER TABLE [dbo].[カレンダー] ADD  CONSTRAINT [DF_カレンダー_日]  DEFAULT (N'') FOR [1]
GO
ALTER TABLE [dbo].[カレンダー] ADD  CONSTRAINT [DF_カレンダー_月]  DEFAULT (N'') FOR [2]
GO
ALTER TABLE [dbo].[カレンダー] ADD  CONSTRAINT [DF_カレンダー_火]  DEFAULT (N'') FOR [3]
GO
ALTER TABLE [dbo].[カレンダー] ADD  CONSTRAINT [DF_カレンダー_水]  DEFAULT (N'') FOR [4]
GO
ALTER TABLE [dbo].[カレンダー] ADD  CONSTRAINT [DF_カレンダー_木]  DEFAULT (N'') FOR [5]
GO
ALTER TABLE [dbo].[カレンダー] ADD  CONSTRAINT [DF_カレンダー_金]  DEFAULT (N'') FOR [6]
GO
ALTER TABLE [dbo].[カレンダー] ADD  CONSTRAINT [DF_カレンダー_土]  DEFAULT (N'') FOR [7]
GO
ALTER TABLE [dbo].[採番] ADD  CONSTRAINT [DF_採番_ID]  DEFAULT (N'') FOR [PCNAME]
GO
ALTER TABLE [dbo].[採番] ADD  CONSTRAINT [DF_採番_店舗ID]  DEFAULT ((0)) FOR [店舗ID]
GO
ALTER TABLE [dbo].[採番] ADD  CONSTRAINT [DF_採番_採番]  DEFAULT (N'') FOR [テーブル名]
GO
ALTER TABLE [dbo].[採番] ADD  CONSTRAINT [DF_採番_ID_1]  DEFAULT ((0)) FOR [IDNew]
GO
ALTER TABLE [dbo].[採番] ADD  CONSTRAINT [DF_採番_IDOld]  DEFAULT ((0)) FOR [IDOld]
GO
ALTER TABLE [dbo].[販売_見積] ADD  CONSTRAINT [DF_見積_金額合計]  DEFAULT ((0)) FOR [金額]
GO
ALTER TABLE [dbo].[販売_見積] ADD  CONSTRAINT [DF_見積_消費税]  DEFAULT ((0)) FOR [消費税]
GO
ALTER TABLE [dbo].[販売_見積] ADD  CONSTRAINT [DF_見積_合計金額]  DEFAULT ((0)) FOR [合計金額]
GO
ALTER TABLE [dbo].[販売_見積詳細] ADD  CONSTRAINT [DF_販売_見積詳細_行]  DEFAULT ((0)) FOR [行]
GO
ALTER TABLE [dbo].[販売_見積詳細] ADD  CONSTRAINT [DF_見積詳細_単価]  DEFAULT ((0)) FOR [単価]
GO
ALTER TABLE [dbo].[販売_見積詳細] ADD  CONSTRAINT [DF_見積詳細_数量]  DEFAULT ((0)) FOR [数量]
GO
ALTER TABLE [dbo].[販売_見積詳細] ADD  CONSTRAINT [DF_見積詳細_金額]  DEFAULT ((0)) FOR [金額]
GO
ALTER TABLE [dbo].[販売_見積詳細] ADD  CONSTRAINT [DF_見積詳細_税区分]  DEFAULT ('課') FOR [税区分]
GO
ALTER TABLE [dbo].[販売_見積詳細] ADD  CONSTRAINT [DF_見積詳細_課税対象額]  DEFAULT ((0)) FOR [課税対象額]
GO
ALTER TABLE [dbo].[販売_商品] ADD  CONSTRAINT [DF_商品_削除_1]  DEFAULT ((0)) FOR [削除]
GO
ALTER TABLE [dbo].[販売_商品] ADD  CONSTRAINT [DF_商品_更新日_1]  DEFAULT (getdate()) FOR [更新日]
GO
ALTER TABLE [dbo].[販売_商品] ADD  CONSTRAINT [DF_商品_商品名]  DEFAULT ('') FOR [商品名]
GO
ALTER TABLE [dbo].[販売_商品] ADD  CONSTRAINT [DF_商品_単価_1]  DEFAULT ((0)) FOR [単価]
GO
ALTER TABLE [dbo].[販売_商品] ADD  CONSTRAINT [DF_商品_単価税込]  DEFAULT ((0)) FOR [単価税込]
GO
ALTER TABLE [dbo].[販売_商品] ADD  CONSTRAINT [DF_商品_備考]  DEFAULT ('') FOR [備考]
GO
ALTER TABLE [dbo].[販売_入金] ADD  CONSTRAINT [DF_販売_入金_金額]  DEFAULT ((0)) FOR [金額]
GO
ALTER TABLE [dbo].[販売_売上] ADD  CONSTRAINT [DF_売上_削除]  DEFAULT ((0)) FOR [削除]
GO
ALTER TABLE [dbo].[販売_売上] ADD  CONSTRAINT [DF_売上_更新日]  DEFAULT (getdate()) FOR [更新日]
GO
ALTER TABLE [dbo].[販売_売上] ADD  CONSTRAINT [DF_販売_売上_課税対象額]  DEFAULT ((0)) FOR [課税対象額]
GO
ALTER TABLE [dbo].[販売_売上] ADD  CONSTRAINT [DF_販売_売上_消費税額]  DEFAULT ((0)) FOR [消費税率]
GO
ALTER TABLE [dbo].[販売_売上] ADD  CONSTRAINT [DF_売上_売上金額]  DEFAULT ((0)) FOR [売上金額税込]
GO
ALTER TABLE [dbo].[販売_売上] ADD  CONSTRAINT [DF_売上_売上金額_1]  DEFAULT ((0)) FOR [非課税対象額]
GO
ALTER TABLE [dbo].[販売_売上] ADD  CONSTRAINT [DF_販売_売上_合計金額]  DEFAULT ((0)) FOR [合計金額]
GO
ALTER TABLE [dbo].[販売_売上詳細] ADD  CONSTRAINT [DF_売上詳細_表示順]  DEFAULT ((0)) FOR [行]
GO
ALTER TABLE [dbo].[販売_売上詳細] ADD  CONSTRAINT [DF_売上詳細_売上ID]  DEFAULT ((0)) FOR [売上ID]
GO
ALTER TABLE [dbo].[販売_売上詳細] ADD  CONSTRAINT [DF_売上詳細_商品ID]  DEFAULT ((0)) FOR [商品ID]
GO
ALTER TABLE [dbo].[販売_売上詳細] ADD  CONSTRAINT [DF_売上詳細_商品名]  DEFAULT (N'') FOR [商品名]
GO
ALTER TABLE [dbo].[販売_売上詳細] ADD  CONSTRAINT [DF_売上詳細_単位]  DEFAULT (N'') FOR [単位]
GO
ALTER TABLE [dbo].[販売_売上詳細] ADD  CONSTRAINT [DF_売上詳細_単価仕入]  DEFAULT ((0)) FOR [単価仕入]
GO
ALTER TABLE [dbo].[販売_売上詳細] ADD  CONSTRAINT [DF_売上詳細_単価販売]  DEFAULT ((0)) FOR [単価販売]
GO
/****** Object:  StoredProcedure [dbo].[MyProc]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[MyProc]
(
    @price INT,
    @out INT OUTPUT
)
AS

SELECT 
	@out = count(*) 
FROM 
	[titles] 
WHERE
	[price] > @price
GO
/****** Object:  StoredProcedure [dbo].[MyProc2]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[MyProc2]
(
    @price INT
)
AS

SELECT 
	[id],
	[title],
	[price]
FROM 
	[titles] 
WHERE
	[price] > @price
GO
/****** Object:  StoredProcedure [dbo].[P_00_def]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<中村健司>
-- Create date: <2022-02-20>
-- Description:	<説明文を記載>
-- =============================================
CREATE PROCEDURE [dbo].[P_00_def]
AS
BEGIN
	SET NOCOUNT ON;

	SELECT 'さいしょの一歩' AS [笑]

--
END
GO
/****** Object:  StoredProcedure [dbo].[P_BREAK]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[P_BREAK]

AS
SET NOCOUNT ON

	DECLARE @i INT
	SET @i=0
	WHILE @i<100
		BEGIN
			SET @i=@i+1
			IF (@i>=10)
				BREAK
			PRINT @i
		END


GO
/****** Object:  StoredProcedure [dbo].[P_DateTime]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[P_DateTime]
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE TEST001 SET 日付=GETDATE() WHERE ID=3
END
GO
/****** Object:  StoredProcedure [dbo].[P_FETCH]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[P_FETCH]
AS

SET NOCOUNT ON


BEGIN
	DECLARE cursor_name CURSOR FOR SELECT a FROM foo
	DECLARE @i INT
	
	OPEN cursor_name
		FETCH NEXT FROM  cursor_name INTO @i

		WHILE @@FETCH_STATUS=0
		BEGIN
			PRINT @i
			FETCH NEXT FROM cursor_name INTO @i
		END
	CLOSE cursor_name
	
	DEALLOCATE cursor_name
END


GO
/****** Object:  StoredProcedure [dbo].[P_GOTOとラベルとWHILE]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[P_GOTOとラベルとWHILE]

AS
--ループを抜けるには,BREAKか、GOTOで。

DECLARE @i int
SET @i=0
WHILE @i<100
	BEGIN
		SET @i=@i+1
		IF (@i>=20)
			GOTO end_loop
		PRINT @i
	END
end_loop:
	PRINT 'Exit LOOP'

GO
/****** Object:  StoredProcedure [dbo].[P_INSERT文]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[P_INSERT文]
AS


SET NOCOUNT ON




BEGIN TRY
	INSERT INTO 
		担当(担当ID,担当)
			VALUES ('0','中村')
		 
END TRY
BEGIN CATCH
	-- Err NO
	PRINT @@ERROR
END  CATCH










GO
/****** Object:  StoredProcedure [dbo].[P_SQL]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[P_SQL]
(
	@strSQL NTEXT
	--@strSQL NCHAR(200)
	--@結果 NCHAR(5)OUTPUT
) 
AS
--
-- テーブル以外のロック範囲を指定するオプション
--
-- ロックのオプション     説明 
-- ROWLOCK                行単位のロック 
-- PAGLOCK                ページ単位のロック 
-- TABLOCK                テーブル単位のロック 
--

BEGIN TRY
	BEGIN TRAN
		EXEC (@strSQL)
	COMMIT TRAN

	--PRINT GETDATE() + N' :正常'
	
END TRY
BEGIN CATCH
	
	--PRINT GETDATE() + N' :異常 : ' + ERROR_MESSAGE()

	IF ERROR_NUMBER()=1205   -- デッドロック対策
		ROLLBACK TRAN
			PRINT GETDATE() + N' :再試行'
		BEGIN
			-- エラーログを書き出すつもりでいるが
			-- 何か問題が無いか、検討中

			SELECT 
				ERROR_NUMBER() as ErrorNumber,
				ERROR_MESSAGE() as ErrorMessage
		END
		
		-- WAITFOR DELAY '00:00:01' --待つ
END CATCH
--PRINT GETDATE() + N' :処理完了'
RETURN
GO
/****** Object:  StoredProcedure [dbo].[P_TEST001]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[P_TEST001]
(
	@a int,
	@b nvarchar(2) OUTPUT
) 
AS

SET NOCOUNT ON

BEGIN
	SELECT @b=b FROM TEST001 WHERE a=@a
	RETURN
END

GO
/****** Object:  StoredProcedure [dbo].[P_TEST002]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[P_TEST002] 

AS
BEGIN

	SET NOCOUNT ON;

	SELECT * FROM TEST001
END
GO
/****** Object:  StoredProcedure [dbo].[P_WHILE文]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[P_WHILE文]
AS
	SET NOCOUNT ON;
	
	DECLARE @i INT
	SET @i=0

	WHILE @i<6000
	BEGIN
		PRINT @i
		SET @i=@i+1
	END

PRINT @i

SET @i=0

	WHILE @i<6000
	BEGIN
		PRINT @i
		SET @i=@i+1

		IF @i>3000
			BREAK
		ELSE
			CONTINUE 

		
	END
GO
/****** Object:  StoredProcedure [dbo].[P_WITH]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[P_WITH]
AS
BEGIN

	SET NOCOUNT ON;


	-- With 句を使う
	--	MySQL / SQLServer

	-- 
	-- With 句を使う事で、
	--  動的な View みたいなイメージで扱えるらしい
	--  サブクエリ使うにはWITH句が一番簡単で見やすいらしい

	-- 参考資料
	/*
	 サブクエリ使うにはWITH句が一番最強。可読性こそ現場での正義。
	 https://sampling2x.com/2019/03/25/sql-with/  (MySQL)

	 WITH句で同じSQLを１つのSQLに共通化する (MySQL/SqlServer)
	 https://zukucode.com/2017/09/sql-with.html


	 */

	 WITH employee_with AS (
  SELECT *
  FROM
    employee T1
  WHERE
    T1.last_name = '山田'
)
SELECT
  T1.id,
  T1.first_name,
  T1.last_name,
  T1.department_id,
  (
    SELECT
      AVG(SUB1.height)
    FROM
      -- WITH句で指定したテーブルを参照
      employee_with SUB1
    WHERE
      T1.department_id = SUB1.department_id
  ) AS avg_height,
  (
    SELECT
      MAX(SUB1.height)
    FROM
      -- WITH句で指定したテーブルを参照
      employee_with SUB1
    WHERE
      T1.department_id = SUB1.department_id
  ) AS max_height
FROM
  -- WITH句で指定したテーブルを参照
  employee_with T1




END
GO
/****** Object:  StoredProcedure [dbo].[P_オートナンバー_リセット]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[P_オートナンバー_リセット]
AS
--BEGIN
--

--END
GO
/****** Object:  StoredProcedure [dbo].[P_カレンダー]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[P_カレンダー]
(
@wPCNAME	NVARCHAR(30),
@年			INT,
@月			INT
)

AS

	DELETE カレンダー WHERE PCNAME=@wPCNAME
	INSERT INTO カレンダー(PCNAME,ID) VALUES(@wPCNAME,1)
	INSERT INTO カレンダー(PCNAME,ID) VALUES(@wPCNAME,2)
	INSERT INTO カレンダー(PCNAME,ID) VALUES(@wPCNAME,3)
	INSERT INTO カレンダー(PCNAME,ID) VALUES(@wPCNAME,4)
	INSERT INTO カレンダー(PCNAME,ID) VALUES(@wPCNAME,5)
	INSERT INTO カレンダー(PCNAME,ID) VALUES(@wPCNAME,6)

--	DECLARE @年			INT
--	DECLARE @月			INT

--set @年=YEAR(GETDATE())
--set @月=MONTH(GETDATE())

	DECLARE @Bias		INT		-- 今までのうるう年の回数
	DECLARE @OneOne		INT		-- 1月1日からの日数

	DECLARE @k			INT		-- 添え字
	DECLARE @d			INT		-- 添え字

	DECLARE @w			INT		-- 求める月の1日の曜日
	DECLARE @月末日		INT     -- 求める月の最終日

	DECLARE @先頭位置	INT		-- 月の1日の先頭位置

	DECLARE @月末日01 INT	SET @月末日01=31
	DECLARE @月末日02 INT	SET @月末日02=28
	DECLARE @月末日03 INT	SET @月末日03=31
	DECLARE @月末日04 INT	SET @月末日04=30
	DECLARE @月末日05 INT	SET @月末日05=31
	DECLARE @月末日06 INT	SET @月末日06=30
	DECLARE @月末日07 INT	SET @月末日07=31
	DECLARE @月末日08 INT	SET @月末日08=31
	DECLARE @月末日09 INT	SET @月末日09=30
	DECLARE @月末日10 INT	SET @月末日10=31
	DECLARE @月末日11 INT	SET @月末日11=30
	DECLARE @月末日12 INT	SET @月末日12=31



-- y 年がうるう年か否かで2月の日数を設定
	If (@年 % 4) = 0 And (@年 % 100) <> 0 Or (@年 % 400) = 0
		SET @月末日02= 29
	Else
		SET @月末日02= 28

-- 今までのうるう年の回数
	SET @Bias = @年 + (@年-1) / 4 - (@年-1) / 100 + (@年- 1) / 400

-- 1月1日からの日数
	SET @OneOne=0
	SET @OneOne=DATEDIFF(dd,STR(@年)+'/1/1',STR(@年)+'/'+STR(@月) +'/01')

-- 求める月の1日の曜日
--(今までのうるう年の回数 + 1月1日からの日数 ) ÷ 7
	SET @w = (@Bias + @OneOne) % 7 

--最初の週の先頭位置
	SET @先頭位置= @w + 1    

	IF @月=1 SET @月末日=@月末日01
	IF @月=2 SET @月末日=@月末日02
	IF @月=3 SET @月末日=@月末日03
	IF @月=4 SET @月末日=@月末日04
	IF @月=5 SET @月末日=@月末日05
	IF @月=6 SET @月末日=@月末日06
	IF @月=7 SET @月末日=@月末日07
	IF @月=8 SET @月末日=@月末日08
	IF @月=9 SET @月末日=@月末日09
	IF @月=10 SET @月末日=@月末日10
	IF @月=11 SET @月末日=@月末日11
	IF @月=12 SET @月末日=@月末日12


--PRINT '@Bias:'+STR(@Bias)
--PRINT '@OneOne:'+STR(@OneOne)
--PRINT '@w:'+STR(@w)
--PRINT '@月末日'+STR(@月末日)
--PRINT ''
--PRINT ''


DECLARE @行 INT
DECLARE @WD INT
DECLARE @WSQL NVARCHAR(200)


SET @行 =1
SET @WD=1
SET @d=1
SET @WSQL=''

WHILE @d<=@月末日
BEGIN

--PRINT ''
--	PRINT '@行      :' +STR(@行)
--	PRINT '@先頭位置:' +STR(@先頭位置)
--	PRINT '@d       :' +STR(@d)
--	PRINT '@WD      :' +STR(@WD)

--SET @WSQL='UPDATE カレンダー SET [' + RTRIM(LTRIM(STR(@先頭位置)))+']=N'''+RTRIM(LTRIM(STR(RIGHT('0'+STR(@d,len(@d)),2)))) + ''' WHERE ID=' +RTRIM(LTRIM(STR(@行)))+' AND PCNAME='''+@wPCNAME + ''''
SET @WSQL='UPDATE カレンダー SET [' + RTRIM(LTRIM(STR(@先頭位置)))+']=N'''+RIGHT('0'+STR(@d,len(@d)),2) + ''' WHERE ID=' +RTRIM(LTRIM(STR(@行)))+' AND PCNAME='''+@wPCNAME + ''''
PRINT '@WSQL:' + @WSQL

EXEC(@WSQL)

--IF @WD=1 UPDATE カレンダー SET [1]=RIGHT('0'+STR(@d),2) WHERE ID=@行
--IF @WD=2 UPDATE カレンダー SET [2]=RIGHT('0'+STR(@d),2) WHERE ID=@行
--IF @WD=3 UPDATE カレンダー SET [3]=RIGHT('0'+STR(@d),2) WHERE ID=@行
--IF @WD=4 UPDATE カレンダー SET [4]=RIGHT('0'+STR(@d),2) WHERE ID=@行
--IF @WD=5 UPDATE カレンダー SET [5]=RIGHT('0'+STR(@d),2) WHERE ID=@行
--IF @WD=6 UPDATE カレンダー SET [6]=RIGHT('0'+STR(@d),2) WHERE ID=@行
--IF @WD=7 UPDATE カレンダー SET [7]=RIGHT('0'+STR(@d),2) WHERE ID=@行


	IF @先頭位置%7=0
		BEGIN
			SET @先頭位置=0
			SET @WD=0
			SET @行=@行+1
		END

	SET @先頭位置=@先頭位置+1
	SET @d=@d+1
	SET @WD=@WD+1

END


GO
/****** Object:  StoredProcedure [dbo].[P_グローバル変数]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[P_グローバル変数]
AS

GO
/****** Object:  StoredProcedure [dbo].[P_クロス集計_ボタン]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[P_クロス集計_ボタン]

AS
BEGIN
	select DISTINCT  Tボタン.行,
		(case when 列='A' then ボタン名 else 'A'+LTRIM(STR(Tボタン.行)) end) as [A],
		(case when 列='B' then ボタン名 else 'B'+LTRIM(STR(Tボタン.行)) end) as [B],
		(case when 列='C' then ボタン名 else 'C'+LTRIM(STR(Tボタン.行)) end) as [C] 
	from Tボタン 
	order by Tボタン.行
END
GO
/****** Object:  StoredProcedure [dbo].[P_クロス集計_売上]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[P_クロス集計_売上]
AS
--(動的に、以下のようなSQLを実行している)
-- 
-- select T売上.番号,sum(case when 日付='2004/09/10' then 数 else 0 end) as 
--		[2004/09/10],sum(case when 日付='2004/09/14' then 数 else 0 end) as 
--		[2004/09/14],sum(case when 日付='2004/09/18' then 数 else 0 end) as 
--		[2004/09/18] from T売上 group by T売上.番号 order by T売上.番号
--
BEGIN
	SET NOCOUNT ON;

	DECLARE @sql1 varchar(8000) 
	DECLARE @sql2 varchar(8000) 
	DECLARE @i int 
	DECLARE @fld1 varchar(20) 
	DECLARE @fld2 varchar(20) 
	DECLARE @fldx varchar(20) 
--
	select @sql1='select 売上.売上ID'
	select @sql2=''
	select @fld1='売上日'
	select @fld2='売上金額'
	select @i=0
--
	declare fld_lst cursor for 
	select distinct convert(varchar,売上日,111) as 売上日 from 売上 order by 売上日
--
	open fld_lst
	while @i<100 
	begin
		fetch next from fld_lst into @fldx
		if @@fetch_status<>0 break

		set @sql1=@sql1+',sum(case when '+convert(varchar,@fld1,111)+'='''+@fldx
				+''' then '+@fld2+' else 0 end) as ['+@fldx+']'

		set @i=@i+1
	end

	if @@fetch_status=0
	while 1=1 
	begin
		fetch next from fld_lst into @fldx
		if @@fetch_status<>0 break
			set @sql2=@sql2+',sum(case when '+convert(varchar,@fld1,111)+'='''+@fldx
			+''' then '+@fld2+' else 0 end) as ['+@fldx+']'
		end

	close fld_lst
	deallocate fld_lst
	
	PRINT @sql1+@sql2+' from 売上' +' group by 売上.売上ID order by 売上.売上ID'

	exec(@sql1+@sql2+' from 売上' +' group by 売上.売上ID order by 売上.売上ID')
	return
END
GO
/****** Object:  StoredProcedure [dbo].[P_データ移動]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[P_データ移動]
AS


--
-- OPENROWSET文
-- （注意）
-- ・32ビットマシンであること。64ビット版のSQLServer ではサポートされていない
-- ・アドホッククエリの実行を許可しておくこと
--
--	INSERT T_曲
--	SELECT * FROM OPENROWSET('Microsoft.Jet.OLEDB.4.0','C:\data.mdb';'Admin';'','SELECT * FROM T_曲')
--
--

GO
/****** Object:  StoredProcedure [dbo].[P_改行]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[P_改行]
AS
BEGIN

	SET NOCOUNT ON;
-- アプリ側で表示させないと分からない
-- マネージメントスタジオでは分からない

	SELECT '文字列 1行目' +CHAR(13)+CHAR(10) +'文字列 2行目'


END
GO
/****** Object:  StoredProcedure [dbo].[P_改行_取り除く]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[P_改行_取り除く]
AS
BEGIN

	SET NOCOUNT ON;
-- アプリ側で表示させないと分からない
-- マネージメントスタジオでは分からない

	--INSERT INTO TEST(ID,商品) VALUES(1,'1行目' + CHAR(13) + CHAR(10) + '2行目')

-- SQL Serverで改行を取り除く

	select REPLACE(商品,char(10),' | ') FROM TEST

-- '0x0D0A'で データ内にある改行文字を取得
SELECT REPLACE(CAST(商品 as nvarchar(50)), '0x0D0A', '改行あり')  AS  改行を取得  FROM TEST WHERE ID=1

END
GO
/****** Object:  StoredProcedure [dbo].[P_金額の計算_切捨]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[P_金額の計算_切捨]
AS
SET NUMERIC_ROUNDABORT OFF
-- ROUND は、length が負の値であるときは、データ型に関係なく、numeric_expression を丸めて返します
--
-- ROUND(748.58, -1) =750.00
-- ROUND(748.58, -2) =700.00
-- ROUND(748.58, -3) =1000.00
--
-- ROUND を使用して切り捨てを行う
-- SELECT ROUND(150.75, 0)  -->151.00
-- SELECT ROUND(150.75, 0, 1   --> 150.00
--

--
-- 単価を計算する算術式で、小数点以下2桁の値を算出するときに
-- 精度を落とさずに結果を出す
--
DECLARE @単価 DECIMAL(14,2)
SET @単価=(SELECT CAST(ROUND(金額/数量,2,1) AS DECIMAL(14,2)) FROM 見積詳細 WHERE 見積詳細ID=1)
PRINT '結果:' +CAST(@単価 AS varchar(20)) 
--
--
--
--

declare @d decimal(19,4) 
declare @d2 decimal(19,4) 
declare @d3 decimal(19,4) 
declare @d4 decimal(19,4)

set @d = 1.
set @d2 = @d / 3.
set @d3 = @d2 * 3.
set @d4 = (1. / 3.) * 3.

select str(@d3,19,4) + ':' + str(@d4,19,4)
GO
/****** Object:  StoredProcedure [dbo].[P_金額を扱う場合の定石]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[P_金額を扱う場合の定石]

AS

--
--Decimal型を使う
--

-- 
-- decimal[(p[,s])] 
-- 
-- 固定長の有効桁数と小数点部位桁数をもつ数値型
-- -10^38-1 ～ 10^38-1までの範囲で有効
-- 
-- 


--
-- 単価を計算する算術式で、
-- 小数点以下2桁の値を算出するときに精度を落とさずに
-- 結果を出すにはどうすればよいでしょうか。

-- 参照元フィールド：金額（DECIMAL(14,0)）と数量（DECIMAL(14,2)）
-- 更新先フィールド：単価（DECIMAL(14,2)）
-- 計算式：ROUND(金額÷数量,2,1)=単価
-- 補足事項：小数点以下3桁目を切り捨て

-- SET NUMERIC_ROUNDABORT OFF

-- INSERT INTO hogeins
-- SELECT CAST(ROUND(金額÷数量,2,1) AS DECIMAL(14,2))
-- FROM hoge
--

-- このオプション設定を行うと、端数は丸め処理になる
-- 計算結果の小数点以下3桁目以降が、ROUND関数によりすべて0になっている
--

-- 丸められる位置の値は、
-- それまでにROUNDの結果によって必ず0になっているので、
-- 結果が変わることは無い
GO
/****** Object:  StoredProcedure [dbo].[P_採番]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[P_採番]
(
@項目 NCHAR(50),
@テーブル NCHAR(50),
@PCNAME  NCHAR(50),
@WID INT OUTPUT
)
AS

SET NOCOUNT ON

BEGIN
	DECLARE @K NCHAR(50)
	DECLARE @T NCHAR(50)
	DECLARE @P NCHAR(50)
	DECLARE @WSQL NCHAR(255)

	SET @K=RTRIM(LTRIM(@項目))
	SET @T=RTRIM(LTRIM(@テーブル))
	SET @P=RTRIM(LTRIM(@PCNAME))

	SET @WSQL = N'UPDATE 採番 SET NO=(SELECT MAX('+@K+') FROM '+@T+' ) WHERE PCNAME=' + @P + ''''

	EXEC (@WSQL)
	--SELECT @WID=MAX(RTRIM(LTRIM(@項目))) FROM 見積
	SET @WID = (SELECT NO FROM 採番 WHERE PCNAME=@P)
END


GO
/****** Object:  StoredProcedure [dbo].[P_採番2]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[P_採番2]
(
@フィールド nvarchar(50),
@テーブル nvarchar(50),
@条件 nvarchar(255)
)

AS
BEGIN
	DECLARE @番号 INT
	DECLARE @strSQL nvarchar(255)

	IF @条件=''
		SET @strSQL=N'select MAX('+@フィールド+') FROM '+@テーブル
	ELSE
		SET @strSQL=N'select MAX('+@フィールド+') FROM '+@テーブル+' WHERE '+@条件

	SET @番号=0
	EXEC @番号 =dbo.Q_SQL @strSQL 
	SET @番号=@番号+1
	Return @番号
END
GO
/****** Object:  StoredProcedure [dbo].[P_商品]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[P_商品]
(
@商品ID INT,
@商品名 nvarchar(30) output ,
@単価販売 money output 

)
AS


SET NOCOUNT ON

--
-- このストアドプロシージャは、1レコードしか返さないので、
-- 注意して扱うこと
--
-- 複数レコード返さない
--

-- 
-- (RUN TEST CODE)
--
-- DECLARE @w商品ID		INT
-- DECLARE @w商品名		nvarchar(30)
-- DECLARE @w単価販売		money
-- 
-- SET @w商品ID=1
-- 
-- EXEC P_商品 @w商品ID,@w商品名 output,@w単価販売 output
-- 
-- select @w商品ID as 商品ID, @w商品名 AS 商品名,@w単価販売 AS 単価販売
-- 


BEGIN
	SELECT 
		@商品名=商品名,
		@単価販売=単価販売
	FROM 商品
	WHERE 
		商品ID=@商品ID AND 
		削除=0

END



GO
/****** Object:  StoredProcedure [dbo].[P_商品_検索]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[P_商品_検索]
(
@検索文字列  nvarchar(30)
)
AS

SET NOCOUNT ON;

BEGIN
	--PRINT @検索文字列
	IF RTRIM(LTRIM(@検索文字列))=''
		BEGIN
			select * from 商品
		END
	ELSE
		BEGIN
			select * from 商品 WHERE 商品名 like '%' + @検索文字列 +'%'
		END

END
Return






GO
/****** Object:  StoredProcedure [dbo].[P_商品抽出]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[P_商品抽出]
(
@STR商品名 nvarchar(30),
@商品ID INT output ,
@商品名 nvarchar(30) output ,
@単価販売 money output 
)
AS


SET NOCOUNT ON

--
-- このストアドプロシージャは、1レコードしか返さないので、
-- 注意して扱うこと
--
-- 複数レコード返さない
--


--
-- DECLARE @STR商品名 nvarchar(30)
-- DECLARE @w商品ID INT
-- DECLARE @w商品名		nvarchar(30)
-- DECLARE @w単価販売		money
--
-- SET @STR商品名='ん'
--
-- EXEC P_商品抽出 @STR商品名,@w商品ID  output,@w商品名 output,@w単価販売 output
--
-- select @w商品ID as 商品ID, @w商品名 AS 商品名,@w単価販売 AS 単価販売
--

BEGIN
	SELECT 
		@商品ID=商品ID,
		@商品名=商品名,
		@単価販売=単価販売
	FROM 商品
	WHERE 
		商品名 LIKE '%'+@STR商品名+'%' AND
		削除=0
END


GO
/****** Object:  StoredProcedure [dbo].[P_条件式]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[P_条件式]
AS

GO
/****** Object:  StoredProcedure [dbo].[P_日付_月初]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[P_日付_月初]
--指定日を渡して月初値を返す
(
	@d datetime,
	@wd  datetime OUTPUT
)

AS

SET NOCOUNT ON

BEGIN
	select @wd = CONVERT(datetime,STR(YEAR(@d)) +'/' + STR(MONTH(@d)) + '/1',111)
END



GO
/****** Object:  StoredProcedure [dbo].[P_日付_月末]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[P_日付_月末]
--指定日を渡して月末値を返す
(
	@d datetime,
	@wd  datetime OUTPUT
)

AS

SET NOCOUNT ON


BEGIN

--RETURN 
	select @wd = DATEADD(d,-1,DATEADD(m,1,
			CONVERT(datetime,STR(YEAR(@d)) +'/' + 
			STR(MONTH(@d)) + '/1',111))) 
--PRINT @wd
END


GO
/****** Object:  StoredProcedure [dbo].[P_日付_第二火曜日]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[P_日付_第二火曜日]
AS
--BEGIN
--SET NOCOUNT ON;
--END

GO
/****** Object:  StoredProcedure [dbo].[P_日付_締日]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[P_日付_締日]
--
-- 日付,締め日を渡して、整形した締日付を返す
--
-- 99日:月末日
--
(
	@d datetime,
	@締日 as INT,
	@wd  datetime OUTPUT
)
AS

SET NOCOUNT ON

BEGIN
	IF @締日=99
		select @wd = DATEADD(d,-1,DATEADD(m,1,CONVERT(datetime,STR(YEAR(@d)) +'/' + STR(MONTH(@d)) + '/1',111))) 
	else
		select @wd = CONVERT(datetime,STR(YEAR(@d)) +'/' + STR(MONTH(@d)) +'/'+ STR(@締日),111)	
END	


	
--END


GO
/****** Object:  StoredProcedure [dbo].[P_日付_本日]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[P_日付_本日]
AS
BEGIN

	SET NOCOUNT ON;

	SELECT GETDATE()
END
GO
/****** Object:  StoredProcedure [dbo].[P_文字列]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[P_文字列]
AS
--
-- datepartは INT が返る
--
select str(datepart(yy,'2010/11/15 03:05:15')) as a
select str(datepart(mm,'2010/11/15 13:05:15')) as b
select str(datepart(dd,'2010/10/15 00:05:15')) as c
select str(datepart(hh,'2010/10/15 04:05:15')) as d
select str(datepart(mi,'2010/10/15 04:35:15')) as e
select CONVERT(nvarchar,'2000/1/1',111) --日付を文字列に
GO
/****** Object:  StoredProcedure [dbo].[Q_MID関数の代わりにSUB_STRING関数]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Q_MID関数の代わりにSUB_STRING関数]
AS

	SELECT dbo.QF_STR日付(更新日) AS 更新日a FROM 商品
GO
/****** Object:  StoredProcedure [dbo].[Q_SQL]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Q_SQL]
(
	@strSQL NTEXT
	--@strSQL NTEXT,
	--@結果 NCHAR(255)OUTPUT
) 
AS

SET NOCOUNT ON

BEGIN TRY

	EXEC (@strSQL)
	--SET @結果 =N'正常'
--
END TRY
BEGIN CATCH
    SELECT 
        ERROR_NUMBER() as ErrorNumber,
        ERROR_MESSAGE() as ErrorMessage;

	--SET @結果 =N'異常 : ' + ERROR_MESSAGE()
END CATCH



GO
/****** Object:  StoredProcedure [dbo].[Q_TEST]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[Q_TEST]
AS
BEGIN
	DECLARE @番号 INT
	SELECT dbo.QF_STR日付(更新日) AS 更新日a FROM 商品

	
	SET @番号=dbo.QF_採番('見積ID','見積','')
	SELECT  @番号 AS ID 
END


GO
/****** Object:  StoredProcedure [dbo].[Q_インライン関数テスト]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[Q_インライン関数テスト]
AS
BEGIN
	SELECT	dbo.QF_商品抽出(1) 
END


GO
/****** Object:  StoredProcedure [dbo].[Q_ジョブ削除]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[Q_ジョブ削除]
(
	@ジョブID INT
)
AS
	EXEC sp_delete_job @ジョブID
--権限
--既定では、このストアド プロシージャを実行できるのは、sysadmin 固定サーバー ロールのメンバです。他のユーザーには、msdb データベースの次のいずれかの SQL Server エージェント固定データベース ロールが許可されている必要があります。
--
--SQLAgentUserRole
--
--
--SQLAgentReaderRole
--
--
--SQLAgentOperatorRole


--これらのロールの権限の詳細については、「SQL Server エージェントの固定データベース ロール」を参照してください。

--sp_delete_job を実行して任意のジョブを削除できるのは、sysadmin 固定サーバー ロールのメンバだけです。sysadmin 固定サーバー ロールのメンバでないユーザーは、自分が所有するジョブのみを削除できます。

--戻り値
--0 (成功) または 1 (失敗)



GO
/****** Object:  StoredProcedure [dbo].[Q_テーブル値関数実行]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Q_テーブル値関数実行]

AS
DECLARE @商品名	nvarchar(30)
Execute @商品名=dbo.[QF_商品抽出] '1'
select @商品名 AS 商品名

GO
/****** Object:  StoredProcedure [dbo].[Q_ロックステータス]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Q_ロックステータス]

AS
CREATE TABLE #sp_lock (
	spid nvarchar(64)
	,[dbid] nvarchar(64)
	,[ObjID] nvarchar(64)
	,[IndID] nvarchar(64)
	,[Type] nvarchar(64)
	,[Resource] nvarchar(64)
	,[Mode] nvarchar(64)
	,[Status] nvarchar(64)
	)
 
INSERT INTO #sp_lock EXEC sp_lock 
 
CREATE TABLE #sp_who (
	[spid] nvarchar(64)
	,[ecid] nvarchar(64)
	,[Status] nvarchar(64)
	,[loginname] nvarchar(64)
	,[hostname] nvarchar(64)
	,[blk] nvarchar(64)
	,[dbname] nvarchar(64)
	,[cmd] nvarchar(64)
	,[request_id] nvarchar(64)
)
 
INSERT INTO #sp_who EXEC sp_who 
 
SELECT *
FROM #sp_who
INNER JOIN #sp_lock
ON #sp_who.[spid]=#sp_lock.[spid]
GO
/****** Object:  StoredProcedure [dbo].[Q_初期データ_商品]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Q_初期データ_商品]
AS
BEGIN
	DELETE 商品
--
	INSERT INTO 商品(ID,商品,単価,数量,金額) 
		VALUES(1,N'消しゴム',120,2,240)
--
	INSERT INTO 商品(ID,商品,単価,数量,金額) 
		VALUES(2,N'鉛筆',80,2,160)
--
	INSERT INTO 商品(ID,商品,単価,数量,金額) 
		VALUES(3,N'定規',100,5,500)
--
	INSERT INTO 商品(ID,商品,単価,数量,金額) 
		VALUES(4,N'消しゴム',120,2,240)
--
	INSERT INTO 商品(ID,商品,単価,数量,金額) 
		VALUES(5,N'消しゴム',120,2,240)
END
GO
/****** Object:  StoredProcedure [dbo].[Q_初期データ_商品2]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Q_初期データ_商品2]
(
	@ID INT,
	@商品 nvarchar(50),
	@単価 INT,
	@数量 INT
)
AS
BEGIN

	SET NOCOUNT ON;

	INSERT INTO 商品(ID,商品,単価,数量,金額) 
		VALUES(1,N'消しゴム',120,2,240)
END
GO
/****** Object:  StoredProcedure [dbo].[Q_抽出]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Q_抽出]
AS

-- 普通な抽出(○月のデータ抽出)
SELECT * FROM dbo.見積 WHERE 見積日>='2009-12-01' AND 見積日<='2009-12-31'
--単価がNullである商品
SELECT * FROM dbo.商品 WHERE 単価 IS NULL

SELECT * FROM dbo.商品 WHERE 単価 IS NOT NULL

-- 12月の見積商品一覧
SELECT 商品ID,商品名 FROM dbo.商品  WHERE  商品ID 
	IN
	(SELECT DISTINCT 商品ID FROM dbo.見積 WHERE 見積日>='2009-12-01' AND 見積日<='2009-12-31')

-- 見積った担当者一覧
SELECT 担当ID,担当 
FROM dbo.担当
WHERE EXISTS
(
	SELECT * FROM dbo.見積 
	WHERE dbo.見積.担当ID=dbo.担当.担当ID
)


-- 見積ってない担当者一覧
SELECT 担当ID,担当 
FROM dbo.担当
WHERE NOT EXISTS
(
	SELECT * FROM dbo.見積 
	WHERE dbo.見積.担当ID=dbo.担当.担当ID
)

-- 条件分岐
SELECT 担当ID,担当,
	CASE
		WHEN 担当=N'織田信長' THEN 'おかま？'
		WHEN 担当=N'なし' THEN 'なし'
		ELSE '' --NULL
	END "担当性別" --フィールド名
FROM dbo.担当
GO
/****** Object:  StoredProcedure [dbo].[Q_変換関数]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Q_変換関数] 

AS
--
-- [CAST関数]
--		→ SQL-92標準
-- 
--		(書き方)
--			CAST(式 AS データ型[(長さ)])
--		(SQL文)
--			SELECT '￥' + CAST(金額 * 1.05 AS nchar(12))
--			AS 税込み金額
--			FROM  T_見積
--
--


--
--
-- [CONVERT関数]
-- 
--		(書き方)
--			CONVERT(データ型[(長さ)],式[日付形式])
--
--
--
--
GO
/****** Object:  StoredProcedure [dbo].[Q_様々な関数]    Script Date: 2023/02/12 9:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Q_様々な関数]
AS
--
-- [スカラ関数]
--		RETURNS句で定義された型の単一のデータ値が返される
--

--		(例)
--			CREATE FUNCTION fn_DateFormat
--			(
--				@date		DATETIME,
--				@separator	CHAR(1)
--			)
--			RETURNS char(10)
--			AS
--			BEGIN
--				CONVERT(varchar(4),DATEPART(yy,@date))
--					+@separator
--					+CONVERT(varchar(2),DATEPART(mm,@date))
--					+@separator
--					+CONVERT(varchar(2),DATEPART(dd,@date))
--			END
--
--			- 呼び出し -
--			SELECT fn_DateFormat(GETDATE(),'/')
--
--
-- [インラインテーブル関数]
--		ビューには入力パラメータを定義できず、場合によっては似たような
--		ビューをいくつも作成しなければいけないなどの改善策として使う
--		
--		(例)
--			CREATE FUNCTION fn_部門別社員情報
--			(
--				@Region NVARCHAR(20)
--			)
--			RETURNS table
--			AS
--				RETURN
--				(
--					SELECT 
--						部門名,社員名,電話番号,住所
--					FROM
--						部門
--					INNER JOIN 社員
--					ON
--						部門.部門ID=社員.部門ID
--					WHERE
--						住所
--					LIKE @Region + '%'
--				)
--
-- [複数ステートメントテーブル値関数]
--		ストアドプロシージャ同様、複数のT-SQLステートメントを使用する
--		複雑なロジックを記述してテーブル形式の結果セットを作成できる
--
--		CREATE FUNCTION fn_社員情報
--		(
--			@Param nvarchar(3)
--		)
--		RETURNS @fn_社員 
--					table
--					(
--						社員ID		INT PRIMARY KEY NOT NULL,
--						社員名		NVARCHAR(125) NOT NULL,
--						出生		NVARCHAR(10) NOT NULL
--					)
--		AS
--		BIGIN
--			IF @parm='YY'
--				INSERT @fn_社員
--					SELECT 
--						社員ID,
--						社員名,
--						CONVERT(varchar(4),DATEPART(yy,生年月日))
--					FROM 社員
--			ELSE IF @parm='YMD'
--				INSERT @fn_社員
--					SELECT
--						社員ID,
--						社員名,
--						CONVERT(varchar(10),生年月日,111)
--					FROM 社員
--		RETURN
--		END
--
--			- 呼び出し -
--			SELECT * FROM fn_社員情報('YMD')
--				または
--			SELECT * FROM fn_社員情報('YY')
--
--
--
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫', @level2type=N'COLUMN',@level2name=N'店舗ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫', @level2type=N'COLUMN',@level2name=N'店舗ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫', @level2type=N'COLUMN',@level2name=N'店舗ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=960 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫', @level2type=N'COLUMN',@level2name=N'店舗ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫', @level2type=N'COLUMN',@level2name=N'店舗ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫', @level2type=N'COLUMN',@level2name=N'在庫ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫', @level2type=N'COLUMN',@level2name=N'在庫ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫', @level2type=N'COLUMN',@level2name=N'在庫ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=960 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫', @level2type=N'COLUMN',@level2name=N'在庫ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫', @level2type=N'COLUMN',@level2name=N'在庫ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫', @level2type=N'COLUMN',@level2name=N'区分'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫', @level2type=N'COLUMN',@level2name=N'区分'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫', @level2type=N'COLUMN',@level2name=N'区分'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=780 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫', @level2type=N'COLUMN',@level2name=N'区分'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫', @level2type=N'COLUMN',@level2name=N'区分'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫', @level2type=N'COLUMN',@level2name=N'日付'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫', @level2type=N'COLUMN',@level2name=N'日付'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫', @level2type=N'COLUMN',@level2name=N'日付'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=1890 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫', @level2type=N'COLUMN',@level2name=N'日付'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫', @level2type=N'COLUMN',@level2name=N'日付'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫', @level2type=N'COLUMN',@level2name=N'商品ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫', @level2type=N'COLUMN',@level2name=N'商品ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫', @level2type=N'COLUMN',@level2name=N'商品ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=960 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫', @level2type=N'COLUMN',@level2name=N'商品ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫', @level2type=N'COLUMN',@level2name=N'商品ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫', @level2type=N'COLUMN',@level2name=N'単価仕入'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫', @level2type=N'COLUMN',@level2name=N'単価仕入'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫', @level2type=N'COLUMN',@level2name=N'単価仕入'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=1005 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫', @level2type=N'COLUMN',@level2name=N'単価仕入'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫', @level2type=N'COLUMN',@level2name=N'単価仕入'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Format', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫', @level2type=N'COLUMN',@level2name=N'単価仕入'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫', @level2type=N'COLUMN',@level2name=N'単価仕入'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫', @level2type=N'COLUMN',@level2name=N'単価仕入'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫', @level2type=N'COLUMN',@level2name=N'単価販売'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫', @level2type=N'COLUMN',@level2name=N'単価販売'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫', @level2type=N'COLUMN',@level2name=N'単価販売'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=1140 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫', @level2type=N'COLUMN',@level2name=N'単価販売'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫', @level2type=N'COLUMN',@level2name=N'単価販売'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Format', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫', @level2type=N'COLUMN',@level2name=N'単価販売'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫', @level2type=N'COLUMN',@level2name=N'単価販売'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫', @level2type=N'COLUMN',@level2name=N'単価販売'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫', @level2type=N'COLUMN',@level2name=N'数量'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫', @level2type=N'COLUMN',@level2name=N'数量'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫', @level2type=N'COLUMN',@level2name=N'数量'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=780 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫', @level2type=N'COLUMN',@level2name=N'数量'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫', @level2type=N'COLUMN',@level2name=N'数量'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫', @level2type=N'COLUMN',@level2name=N'金額仕入'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫', @level2type=N'COLUMN',@level2name=N'金額仕入'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫', @level2type=N'COLUMN',@level2name=N'金額仕入'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=1140 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫', @level2type=N'COLUMN',@level2name=N'金額仕入'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫', @level2type=N'COLUMN',@level2name=N'金額仕入'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Format', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫', @level2type=N'COLUMN',@level2name=N'金額仕入'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫', @level2type=N'COLUMN',@level2name=N'金額仕入'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫', @level2type=N'COLUMN',@level2name=N'金額仕入'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫', @level2type=N'COLUMN',@level2name=N'金額販売'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫', @level2type=N'COLUMN',@level2name=N'金額販売'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫', @level2type=N'COLUMN',@level2name=N'金額販売'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=1140 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫', @level2type=N'COLUMN',@level2name=N'金額販売'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫', @level2type=N'COLUMN',@level2name=N'金額販売'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Format', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫', @level2type=N'COLUMN',@level2name=N'金額販売'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫', @level2type=N'COLUMN',@level2name=N'金額販売'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫', @level2type=N'COLUMN',@level2name=N'金額販売'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫', @level2type=N'COLUMN',@level2name=N'備考'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫', @level2type=N'COLUMN',@level2name=N'備考'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫', @level2type=N'COLUMN',@level2name=N'備考'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫', @level2type=N'COLUMN',@level2name=N'備考'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫', @level2type=N'COLUMN',@level2name=N'備考'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫', @level2type=N'COLUMN',@level2name=N'削除'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫', @level2type=N'COLUMN',@level2name=N'削除'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫', @level2type=N'COLUMN',@level2name=N'削除'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=780 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫', @level2type=N'COLUMN',@level2name=N'削除'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫', @level2type=N'COLUMN',@level2name=N'削除'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DefaultView', @value=0x02 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Filter', @value=NULL , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_FilterOnLoad', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_HideNewField', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_OrderBy', @value=NULL , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_OrderByOn', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_OrderByOnLoad', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Orientation', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TableMaxRecords', @value=10000 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TotalsRow', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M在庫'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M仕入企業', @level2type=N'COLUMN',@level2name=N'店舗ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M仕入企業', @level2type=N'COLUMN',@level2name=N'店舗ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M仕入企業', @level2type=N'COLUMN',@level2name=N'店舗ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=960 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M仕入企業', @level2type=N'COLUMN',@level2name=N'店舗ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M仕入企業', @level2type=N'COLUMN',@level2name=N'店舗ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M仕入企業', @level2type=N'COLUMN',@level2name=N'企業ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M仕入企業', @level2type=N'COLUMN',@level2name=N'企業ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M仕入企業', @level2type=N'COLUMN',@level2name=N'企業ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=960 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M仕入企業', @level2type=N'COLUMN',@level2name=N'企業ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M仕入企業', @level2type=N'COLUMN',@level2name=N'企業ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M仕入企業', @level2type=N'COLUMN',@level2name=N'企業名'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M仕入企業', @level2type=N'COLUMN',@level2name=N'企業名'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M仕入企業', @level2type=N'COLUMN',@level2name=N'企業名'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M仕入企業', @level2type=N'COLUMN',@level2name=N'企業名'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M仕入企業', @level2type=N'COLUMN',@level2name=N'企業名'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M仕入企業', @level2type=N'COLUMN',@level2name=N'払日'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M仕入企業', @level2type=N'COLUMN',@level2name=N'払日'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M仕入企業', @level2type=N'COLUMN',@level2name=N'払日'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=780 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M仕入企業', @level2type=N'COLUMN',@level2name=N'払日'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M仕入企業', @level2type=N'COLUMN',@level2name=N'払日'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M仕入企業', @level2type=N'COLUMN',@level2name=N'担当ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M仕入企業', @level2type=N'COLUMN',@level2name=N'担当ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M仕入企業', @level2type=N'COLUMN',@level2name=N'担当ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=960 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M仕入企業', @level2type=N'COLUMN',@level2name=N'担当ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M仕入企業', @level2type=N'COLUMN',@level2name=N'担当ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DefaultView', @value=0x02 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M仕入企業'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Filter', @value=NULL , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M仕入企業'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_FilterOnLoad', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M仕入企業'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_HideNewField', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M仕入企業'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_OrderBy', @value=NULL , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M仕入企業'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_OrderByOn', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M仕入企業'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_OrderByOnLoad', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M仕入企業'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Orientation', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M仕入企業'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TableMaxRecords', @value=10000 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M仕入企業'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TotalsRow', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M仕入企業'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品', @level2type=N'COLUMN',@level2name=N'店舗ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品', @level2type=N'COLUMN',@level2name=N'店舗ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品', @level2type=N'COLUMN',@level2name=N'店舗ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=960 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品', @level2type=N'COLUMN',@level2name=N'店舗ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品', @level2type=N'COLUMN',@level2name=N'店舗ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Format', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品', @level2type=N'COLUMN',@level2name=N'店舗ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品', @level2type=N'COLUMN',@level2name=N'店舗ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品', @level2type=N'COLUMN',@level2name=N'店舗ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品', @level2type=N'COLUMN',@level2name=N'商品ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品', @level2type=N'COLUMN',@level2name=N'商品ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品', @level2type=N'COLUMN',@level2name=N'商品ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=960 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品', @level2type=N'COLUMN',@level2name=N'商品ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品', @level2type=N'COLUMN',@level2name=N'商品ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品', @level2type=N'COLUMN',@level2name=N'商品名'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品', @level2type=N'COLUMN',@level2name=N'商品名'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品', @level2type=N'COLUMN',@level2name=N'商品名'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=1080 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品', @level2type=N'COLUMN',@level2name=N'商品名'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品', @level2type=N'COLUMN',@level2name=N'商品名'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品', @level2type=N'COLUMN',@level2name=N'単位'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品', @level2type=N'COLUMN',@level2name=N'単位'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品', @level2type=N'COLUMN',@level2name=N'単位'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=780 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品', @level2type=N'COLUMN',@level2name=N'単位'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品', @level2type=N'COLUMN',@level2name=N'単位'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Format', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品', @level2type=N'COLUMN',@level2name=N'単位'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品', @level2type=N'COLUMN',@level2name=N'単位'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品', @level2type=N'COLUMN',@level2name=N'単位'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品', @level2type=N'COLUMN',@level2name=N'単価仕入'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品', @level2type=N'COLUMN',@level2name=N'単価仕入'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品', @level2type=N'COLUMN',@level2name=N'単価仕入'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=1140 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品', @level2type=N'COLUMN',@level2name=N'単価仕入'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品', @level2type=N'COLUMN',@level2name=N'単価仕入'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Format', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品', @level2type=N'COLUMN',@level2name=N'単価仕入'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品', @level2type=N'COLUMN',@level2name=N'単価仕入'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品', @level2type=N'COLUMN',@level2name=N'単価販売'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品', @level2type=N'COLUMN',@level2name=N'単価販売'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品', @level2type=N'COLUMN',@level2name=N'単価販売'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=1140 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品', @level2type=N'COLUMN',@level2name=N'単価販売'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品', @level2type=N'COLUMN',@level2name=N'単価販売'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Format', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品', @level2type=N'COLUMN',@level2name=N'単価販売'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品', @level2type=N'COLUMN',@level2name=N'単価販売'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品', @level2type=N'COLUMN',@level2name=N'削除'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品', @level2type=N'COLUMN',@level2name=N'削除'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品', @level2type=N'COLUMN',@level2name=N'削除'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=780 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品', @level2type=N'COLUMN',@level2name=N'削除'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品', @level2type=N'COLUMN',@level2name=N'削除'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品', @level2type=N'COLUMN',@level2name=N'販売開始日'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品', @level2type=N'COLUMN',@level2name=N'販売開始日'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品', @level2type=N'COLUMN',@level2name=N'販売開始日'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=1890 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品', @level2type=N'COLUMN',@level2name=N'販売開始日'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品', @level2type=N'COLUMN',@level2name=N'販売開始日'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品', @level2type=N'COLUMN',@level2name=N'販売終了日'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品', @level2type=N'COLUMN',@level2name=N'販売終了日'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品', @level2type=N'COLUMN',@level2name=N'販売終了日'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=1890 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品', @level2type=N'COLUMN',@level2name=N'販売終了日'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品', @level2type=N'COLUMN',@level2name=N'販売終了日'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品', @level2type=N'COLUMN',@level2name=N'更新日'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品', @level2type=N'COLUMN',@level2name=N'更新日'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品', @level2type=N'COLUMN',@level2name=N'更新日'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=1890 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品', @level2type=N'COLUMN',@level2name=N'更新日'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品', @level2type=N'COLUMN',@level2name=N'更新日'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品', @level2type=N'COLUMN',@level2name=N'表示順'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品', @level2type=N'COLUMN',@level2name=N'表示順'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品', @level2type=N'COLUMN',@level2name=N'表示順'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=960 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品', @level2type=N'COLUMN',@level2name=N'表示順'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品', @level2type=N'COLUMN',@level2name=N'表示順'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品', @level2type=N'COLUMN',@level2name=N'商品区分A'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品', @level2type=N'COLUMN',@level2name=N'商品区分A'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品', @level2type=N'COLUMN',@level2name=N'商品区分A'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品', @level2type=N'COLUMN',@level2name=N'商品区分A'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品', @level2type=N'COLUMN',@level2name=N'商品区分A'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品', @level2type=N'COLUMN',@level2name=N'商品区分B'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品', @level2type=N'COLUMN',@level2name=N'商品区分B'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品', @level2type=N'COLUMN',@level2name=N'商品区分B'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品', @level2type=N'COLUMN',@level2name=N'商品区分B'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品', @level2type=N'COLUMN',@level2name=N'商品区分B'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品', @level2type=N'COLUMN',@level2name=N'商品区分C'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品', @level2type=N'COLUMN',@level2name=N'商品区分C'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品', @level2type=N'COLUMN',@level2name=N'商品区分C'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品', @level2type=N'COLUMN',@level2name=N'商品区分C'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品', @level2type=N'COLUMN',@level2name=N'商品区分C'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DefaultView', @value=0x02 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Filter', @value=NULL , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_FilterOnLoad', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_HideNewField', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_OrderBy', @value=NULL , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_OrderByOn', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_OrderByOnLoad', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Orientation', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TableMaxRecords', @value=10000 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TotalsRow', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M商品'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M設定', @level2type=N'COLUMN',@level2name=N'店舗ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M設定', @level2type=N'COLUMN',@level2name=N'店舗ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M設定', @level2type=N'COLUMN',@level2name=N'店舗ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=960 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M設定', @level2type=N'COLUMN',@level2name=N'店舗ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M設定', @level2type=N'COLUMN',@level2name=N'店舗ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Format', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M設定', @level2type=N'COLUMN',@level2name=N'店舗ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M設定', @level2type=N'COLUMN',@level2name=N'店舗ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M設定', @level2type=N'COLUMN',@level2name=N'店舗ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M設定', @level2type=N'COLUMN',@level2name=N'設定'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M設定', @level2type=N'COLUMN',@level2name=N'設定'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M設定', @level2type=N'COLUMN',@level2name=N'設定'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=1440 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M設定', @level2type=N'COLUMN',@level2name=N'設定'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M設定', @level2type=N'COLUMN',@level2name=N'設定'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Format', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M設定', @level2type=N'COLUMN',@level2name=N'設定'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M設定', @level2type=N'COLUMN',@level2name=N'設定'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M設定', @level2type=N'COLUMN',@level2name=N'設定'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M設定', @level2type=N'COLUMN',@level2name=N'型'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M設定', @level2type=N'COLUMN',@level2name=N'型'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M設定', @level2type=N'COLUMN',@level2name=N'型'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M設定', @level2type=N'COLUMN',@level2name=N'型'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M設定', @level2type=N'COLUMN',@level2name=N'型'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Format', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M設定', @level2type=N'COLUMN',@level2name=N'型'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M設定', @level2type=N'COLUMN',@level2name=N'型'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M設定', @level2type=N'COLUMN',@level2name=N'型'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M設定', @level2type=N'COLUMN',@level2name=N'値'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M設定', @level2type=N'COLUMN',@level2name=N'値'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M設定', @level2type=N'COLUMN',@level2name=N'値'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M設定', @level2type=N'COLUMN',@level2name=N'値'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M設定', @level2type=N'COLUMN',@level2name=N'値'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Format', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M設定', @level2type=N'COLUMN',@level2name=N'値'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M設定', @level2type=N'COLUMN',@level2name=N'値'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M設定', @level2type=N'COLUMN',@level2name=N'値'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M設定', @level2type=N'COLUMN',@level2name=N'リスト'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M設定', @level2type=N'COLUMN',@level2name=N'リスト'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M設定', @level2type=N'COLUMN',@level2name=N'リスト'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=1800 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M設定', @level2type=N'COLUMN',@level2name=N'リスト'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M設定', @level2type=N'COLUMN',@level2name=N'リスト'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Format', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M設定', @level2type=N'COLUMN',@level2name=N'リスト'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M設定', @level2type=N'COLUMN',@level2name=N'リスト'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M設定', @level2type=N'COLUMN',@level2name=N'リスト'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M設定', @level2type=N'COLUMN',@level2name=N'削除'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M設定', @level2type=N'COLUMN',@level2name=N'削除'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M設定', @level2type=N'COLUMN',@level2name=N'削除'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=780 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M設定', @level2type=N'COLUMN',@level2name=N'削除'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M設定', @level2type=N'COLUMN',@level2name=N'削除'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DefaultView', @value=0x02 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M設定'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Filter', @value=NULL , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M設定'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_FilterOnLoad', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M設定'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_HideNewField', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M設定'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_OrderBy', @value=NULL , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M設定'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_OrderByOn', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M設定'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_OrderByOnLoad', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M設定'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Orientation', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M設定'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TableMaxRecords', @value=10000 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M設定'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TotalsRow', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M設定'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M担当', @level2type=N'COLUMN',@level2name=N'店舗ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M担当', @level2type=N'COLUMN',@level2name=N'店舗ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M担当', @level2type=N'COLUMN',@level2name=N'店舗ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=960 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M担当', @level2type=N'COLUMN',@level2name=N'店舗ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M担当', @level2type=N'COLUMN',@level2name=N'店舗ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Format', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M担当', @level2type=N'COLUMN',@level2name=N'店舗ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M担当', @level2type=N'COLUMN',@level2name=N'店舗ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M担当', @level2type=N'COLUMN',@level2name=N'店舗ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M担当', @level2type=N'COLUMN',@level2name=N'担当ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M担当', @level2type=N'COLUMN',@level2name=N'担当ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M担当', @level2type=N'COLUMN',@level2name=N'担当ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=960 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M担当', @level2type=N'COLUMN',@level2name=N'担当ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M担当', @level2type=N'COLUMN',@level2name=N'担当ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Format', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M担当', @level2type=N'COLUMN',@level2name=N'担当ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M担当', @level2type=N'COLUMN',@level2name=N'担当ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M担当', @level2type=N'COLUMN',@level2name=N'担当ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M担当', @level2type=N'COLUMN',@level2name=N'担当'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M担当', @level2type=N'COLUMN',@level2name=N'担当'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M担当', @level2type=N'COLUMN',@level2name=N'担当'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M担当', @level2type=N'COLUMN',@level2name=N'担当'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M担当', @level2type=N'COLUMN',@level2name=N'担当'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Format', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M担当', @level2type=N'COLUMN',@level2name=N'担当'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M担当', @level2type=N'COLUMN',@level2name=N'担当'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M担当', @level2type=N'COLUMN',@level2name=N'担当'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M担当', @level2type=N'COLUMN',@level2name=N'削除'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M担当', @level2type=N'COLUMN',@level2name=N'削除'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M担当', @level2type=N'COLUMN',@level2name=N'削除'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=780 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M担当', @level2type=N'COLUMN',@level2name=N'削除'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M担当', @level2type=N'COLUMN',@level2name=N'削除'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Format', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M担当', @level2type=N'COLUMN',@level2name=N'削除'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M担当', @level2type=N'COLUMN',@level2name=N'削除'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M担当', @level2type=N'COLUMN',@level2name=N'削除'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DefaultView', @value=0x02 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M担当'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Filter', @value=NULL , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M担当'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_FilterOnLoad', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M担当'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_HideNewField', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M担当'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_OrderBy', @value=NULL , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M担当'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_OrderByOn', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M担当'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_OrderByOnLoad', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M担当'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Orientation', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M担当'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TableMaxRecords', @value=10000 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M担当'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TotalsRow', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M担当'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M店舗', @level2type=N'COLUMN',@level2name=N'店舗ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M店舗', @level2type=N'COLUMN',@level2name=N'店舗ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M店舗', @level2type=N'COLUMN',@level2name=N'店舗ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=960 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M店舗', @level2type=N'COLUMN',@level2name=N'店舗ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M店舗', @level2type=N'COLUMN',@level2name=N'店舗ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M店舗', @level2type=N'COLUMN',@level2name=N'店舗名'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M店舗', @level2type=N'COLUMN',@level2name=N'店舗名'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M店舗', @level2type=N'COLUMN',@level2name=N'店舗名'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M店舗', @level2type=N'COLUMN',@level2name=N'店舗名'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M店舗', @level2type=N'COLUMN',@level2name=N'店舗名'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M店舗', @level2type=N'COLUMN',@level2name=N'削除'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M店舗', @level2type=N'COLUMN',@level2name=N'削除'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M店舗', @level2type=N'COLUMN',@level2name=N'削除'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=780 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M店舗', @level2type=N'COLUMN',@level2name=N'削除'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M店舗', @level2type=N'COLUMN',@level2name=N'削除'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Format', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M店舗', @level2type=N'COLUMN',@level2name=N'削除'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M店舗', @level2type=N'COLUMN',@level2name=N'削除'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M店舗', @level2type=N'COLUMN',@level2name=N'削除'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DefaultView', @value=0x02 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M店舗'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Filter', @value=NULL , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M店舗'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_FilterOnLoad', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M店舗'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_HideNewField', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M店舗'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_OrderBy', @value=NULL , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M店舗'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_OrderByOn', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M店舗'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_OrderByOnLoad', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M店舗'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Orientation', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M店舗'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TableMaxRecords', @value=10000 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M店舗'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TotalsRow', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M店舗'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売企業', @level2type=N'COLUMN',@level2name=N'店舗ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売企業', @level2type=N'COLUMN',@level2name=N'店舗ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売企業', @level2type=N'COLUMN',@level2name=N'店舗ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=960 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売企業', @level2type=N'COLUMN',@level2name=N'店舗ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売企業', @level2type=N'COLUMN',@level2name=N'店舗ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売企業', @level2type=N'COLUMN',@level2name=N'企業ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売企業', @level2type=N'COLUMN',@level2name=N'企業ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売企業', @level2type=N'COLUMN',@level2name=N'企業ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=960 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売企業', @level2type=N'COLUMN',@level2name=N'企業ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売企業', @level2type=N'COLUMN',@level2name=N'企業ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売企業', @level2type=N'COLUMN',@level2name=N'企業名'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売企業', @level2type=N'COLUMN',@level2name=N'企業名'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売企業', @level2type=N'COLUMN',@level2name=N'企業名'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売企業', @level2type=N'COLUMN',@level2name=N'企業名'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売企業', @level2type=N'COLUMN',@level2name=N'企業名'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売企業', @level2type=N'COLUMN',@level2name=N'締日'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売企業', @level2type=N'COLUMN',@level2name=N'締日'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売企業', @level2type=N'COLUMN',@level2name=N'締日'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=780 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売企業', @level2type=N'COLUMN',@level2name=N'締日'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売企業', @level2type=N'COLUMN',@level2name=N'締日'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売企業', @level2type=N'COLUMN',@level2name=N'担当ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売企業', @level2type=N'COLUMN',@level2name=N'担当ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売企業', @level2type=N'COLUMN',@level2name=N'担当ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=960 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売企業', @level2type=N'COLUMN',@level2name=N'担当ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売企業', @level2type=N'COLUMN',@level2name=N'担当ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DefaultView', @value=0x02 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売企業'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Filter', @value=NULL , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売企業'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_FilterOnLoad', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売企業'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_HideNewField', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売企業'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_OrderBy', @value=NULL , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売企業'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_OrderByOn', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売企業'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_OrderByOnLoad', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売企業'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Orientation', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売企業'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TableMaxRecords', @value=10000 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売企業'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TotalsRow', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売企業'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売顧客', @level2type=N'COLUMN',@level2name=N'店舗ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売顧客', @level2type=N'COLUMN',@level2name=N'店舗ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売顧客', @level2type=N'COLUMN',@level2name=N'店舗ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=960 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売顧客', @level2type=N'COLUMN',@level2name=N'店舗ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売顧客', @level2type=N'COLUMN',@level2name=N'店舗ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Format', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売顧客', @level2type=N'COLUMN',@level2name=N'店舗ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売顧客', @level2type=N'COLUMN',@level2name=N'店舗ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売顧客', @level2type=N'COLUMN',@level2name=N'店舗ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売顧客', @level2type=N'COLUMN',@level2name=N'顧客ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売顧客', @level2type=N'COLUMN',@level2name=N'顧客ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売顧客', @level2type=N'COLUMN',@level2name=N'顧客ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=960 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売顧客', @level2type=N'COLUMN',@level2name=N'顧客ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売顧客', @level2type=N'COLUMN',@level2name=N'顧客ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売顧客', @level2type=N'COLUMN',@level2name=N'企業ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売顧客', @level2type=N'COLUMN',@level2name=N'企業ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売顧客', @level2type=N'COLUMN',@level2name=N'企業ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=960 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売顧客', @level2type=N'COLUMN',@level2name=N'企業ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売顧客', @level2type=N'COLUMN',@level2name=N'企業ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Format', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売顧客', @level2type=N'COLUMN',@level2name=N'企業ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売顧客', @level2type=N'COLUMN',@level2name=N'企業ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売顧客', @level2type=N'COLUMN',@level2name=N'企業ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売顧客', @level2type=N'COLUMN',@level2name=N'顧客名'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売顧客', @level2type=N'COLUMN',@level2name=N'顧客名'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売顧客', @level2type=N'COLUMN',@level2name=N'顧客名'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売顧客', @level2type=N'COLUMN',@level2name=N'顧客名'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売顧客', @level2type=N'COLUMN',@level2name=N'顧客名'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売顧客', @level2type=N'COLUMN',@level2name=N'生年月日'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売顧客', @level2type=N'COLUMN',@level2name=N'生年月日'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売顧客', @level2type=N'COLUMN',@level2name=N'生年月日'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=1890 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売顧客', @level2type=N'COLUMN',@level2name=N'生年月日'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売顧客', @level2type=N'COLUMN',@level2name=N'生年月日'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売顧客', @level2type=N'COLUMN',@level2name=N'締日'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売顧客', @level2type=N'COLUMN',@level2name=N'締日'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売顧客', @level2type=N'COLUMN',@level2name=N'締日'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=780 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売顧客', @level2type=N'COLUMN',@level2name=N'締日'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売顧客', @level2type=N'COLUMN',@level2name=N'締日'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Format', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売顧客', @level2type=N'COLUMN',@level2name=N'締日'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売顧客', @level2type=N'COLUMN',@level2name=N'締日'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売顧客', @level2type=N'COLUMN',@level2name=N'締日'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売顧客', @level2type=N'COLUMN',@level2name=N'性別'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売顧客', @level2type=N'COLUMN',@level2name=N'性別'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売顧客', @level2type=N'COLUMN',@level2name=N'性別'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=780 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売顧客', @level2type=N'COLUMN',@level2name=N'性別'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売顧客', @level2type=N'COLUMN',@level2name=N'性別'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Format', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売顧客', @level2type=N'COLUMN',@level2name=N'性別'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売顧客', @level2type=N'COLUMN',@level2name=N'性別'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売顧客', @level2type=N'COLUMN',@level2name=N'性別'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売顧客', @level2type=N'COLUMN',@level2name=N'担当ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売顧客', @level2type=N'COLUMN',@level2name=N'担当ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売顧客', @level2type=N'COLUMN',@level2name=N'担当ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=960 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売顧客', @level2type=N'COLUMN',@level2name=N'担当ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売顧客', @level2type=N'COLUMN',@level2name=N'担当ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Format', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売顧客', @level2type=N'COLUMN',@level2name=N'担当ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売顧客', @level2type=N'COLUMN',@level2name=N'担当ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売顧客', @level2type=N'COLUMN',@level2name=N'担当ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DefaultView', @value=0x02 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売顧客'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Filter', @value=NULL , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売顧客'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_FilterOnLoad', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売顧客'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_HideNewField', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売顧客'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_OrderBy', @value=NULL , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売顧客'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_OrderByOn', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売顧客'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_OrderByOnLoad', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売顧客'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Orientation', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売顧客'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TableMaxRecords', @value=10000 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売顧客'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TotalsRow', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'M販売顧客'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'S在庫月次', @level2type=N'COLUMN',@level2name=N'店舗ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'S在庫月次', @level2type=N'COLUMN',@level2name=N'店舗ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'S在庫月次', @level2type=N'COLUMN',@level2name=N'店舗ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=960 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'S在庫月次', @level2type=N'COLUMN',@level2name=N'店舗ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'S在庫月次', @level2type=N'COLUMN',@level2name=N'店舗ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Format', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'S在庫月次', @level2type=N'COLUMN',@level2name=N'店舗ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'S在庫月次', @level2type=N'COLUMN',@level2name=N'店舗ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'S在庫月次', @level2type=N'COLUMN',@level2name=N'店舗ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'S在庫月次', @level2type=N'COLUMN',@level2name=N'在庫集計ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'S在庫月次', @level2type=N'COLUMN',@level2name=N'在庫集計ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'S在庫月次', @level2type=N'COLUMN',@level2name=N'在庫集計ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=1320 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'S在庫月次', @level2type=N'COLUMN',@level2name=N'在庫集計ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'S在庫月次', @level2type=N'COLUMN',@level2name=N'在庫集計ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'S在庫月次', @level2type=N'COLUMN',@level2name=N'日付'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'S在庫月次', @level2type=N'COLUMN',@level2name=N'日付'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'S在庫月次', @level2type=N'COLUMN',@level2name=N'日付'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=1080 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'S在庫月次', @level2type=N'COLUMN',@level2name=N'日付'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'S在庫月次', @level2type=N'COLUMN',@level2name=N'日付'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'S在庫月次', @level2type=N'COLUMN',@level2name=N'商品ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'S在庫月次', @level2type=N'COLUMN',@level2name=N'商品ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'S在庫月次', @level2type=N'COLUMN',@level2name=N'商品ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=960 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'S在庫月次', @level2type=N'COLUMN',@level2name=N'商品ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'S在庫月次', @level2type=N'COLUMN',@level2name=N'商品ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'S在庫月次', @level2type=N'COLUMN',@level2name=N'数量'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'S在庫月次', @level2type=N'COLUMN',@level2name=N'数量'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'S在庫月次', @level2type=N'COLUMN',@level2name=N'数量'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=780 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'S在庫月次', @level2type=N'COLUMN',@level2name=N'数量'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'S在庫月次', @level2type=N'COLUMN',@level2name=N'数量'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DefaultView', @value=0x02 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'S在庫月次'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Filter', @value=NULL , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'S在庫月次'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_FilterOnLoad', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'S在庫月次'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_HideNewField', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'S在庫月次'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_OrderBy', @value=NULL , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'S在庫月次'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_OrderByOn', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'S在庫月次'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_OrderByOnLoad', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'S在庫月次'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Orientation', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'S在庫月次'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TableMaxRecords', @value=10000 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'S在庫月次'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TotalsRow', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'S在庫月次'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'S在庫月次区分', @level2type=N'COLUMN',@level2name=N'店舗ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'S在庫月次区分', @level2type=N'COLUMN',@level2name=N'店舗ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'S在庫月次区分', @level2type=N'COLUMN',@level2name=N'店舗ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=960 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'S在庫月次区分', @level2type=N'COLUMN',@level2name=N'店舗ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'S在庫月次区分', @level2type=N'COLUMN',@level2name=N'店舗ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Format', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'S在庫月次区分', @level2type=N'COLUMN',@level2name=N'店舗ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'S在庫月次区分', @level2type=N'COLUMN',@level2name=N'店舗ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'S在庫月次区分', @level2type=N'COLUMN',@level2name=N'店舗ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'S在庫月次区分', @level2type=N'COLUMN',@level2name=N'在庫集計ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'S在庫月次区分', @level2type=N'COLUMN',@level2name=N'在庫集計ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'S在庫月次区分', @level2type=N'COLUMN',@level2name=N'在庫集計ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=1320 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'S在庫月次区分', @level2type=N'COLUMN',@level2name=N'在庫集計ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'S在庫月次区分', @level2type=N'COLUMN',@level2name=N'在庫集計ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'S在庫月次区分', @level2type=N'COLUMN',@level2name=N'日付'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'S在庫月次区分', @level2type=N'COLUMN',@level2name=N'日付'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'S在庫月次区分', @level2type=N'COLUMN',@level2name=N'日付'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=1890 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'S在庫月次区分', @level2type=N'COLUMN',@level2name=N'日付'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'S在庫月次区分', @level2type=N'COLUMN',@level2name=N'日付'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'S在庫月次区分', @level2type=N'COLUMN',@level2name=N'区分'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'S在庫月次区分', @level2type=N'COLUMN',@level2name=N'区分'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'S在庫月次区分', @level2type=N'COLUMN',@level2name=N'区分'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=780 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'S在庫月次区分', @level2type=N'COLUMN',@level2name=N'区分'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'S在庫月次区分', @level2type=N'COLUMN',@level2name=N'区分'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'S在庫月次区分', @level2type=N'COLUMN',@level2name=N'商品ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'S在庫月次区分', @level2type=N'COLUMN',@level2name=N'商品ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'S在庫月次区分', @level2type=N'COLUMN',@level2name=N'商品ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=960 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'S在庫月次区分', @level2type=N'COLUMN',@level2name=N'商品ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'S在庫月次区分', @level2type=N'COLUMN',@level2name=N'商品ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'S在庫月次区分', @level2type=N'COLUMN',@level2name=N'数量'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'S在庫月次区分', @level2type=N'COLUMN',@level2name=N'数量'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'S在庫月次区分', @level2type=N'COLUMN',@level2name=N'数量'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=780 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'S在庫月次区分', @level2type=N'COLUMN',@level2name=N'数量'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'S在庫月次区分', @level2type=N'COLUMN',@level2name=N'数量'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DefaultView', @value=0x02 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'S在庫月次区分'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Filter', @value=NULL , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'S在庫月次区分'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_FilterOnLoad', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'S在庫月次区分'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_HideNewField', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'S在庫月次区分'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_OrderBy', @value=NULL , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'S在庫月次区分'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_OrderByOn', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'S在庫月次区分'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_OrderByOnLoad', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'S在庫月次区分'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Orientation', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'S在庫月次区分'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TableMaxRecords', @value=10000 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'S在庫月次区分'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TotalsRow', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'S在庫月次区分'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Wユニコード文字', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Wユニコード文字', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Wユニコード文字', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=960 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Wユニコード文字', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Wユニコード文字', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Wユニコード文字', @level2type=N'COLUMN',@level2name=N'文字'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Wユニコード文字', @level2type=N'COLUMN',@level2name=N'文字'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Wユニコード文字', @level2type=N'COLUMN',@level2name=N'文字'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Wユニコード文字', @level2type=N'COLUMN',@level2name=N'文字'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Wユニコード文字', @level2type=N'COLUMN',@level2name=N'文字'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DefaultView', @value=0x02 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Wユニコード文字'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Filter', @value=NULL , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Wユニコード文字'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_FilterOnLoad', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Wユニコード文字'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_HideNewField', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Wユニコード文字'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_OrderBy', @value=NULL , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Wユニコード文字'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_OrderByOn', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Wユニコード文字'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_OrderByOnLoad', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Wユニコード文字'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Orientation', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Wユニコード文字'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TableMaxRecords', @value=10000 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Wユニコード文字'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TotalsRow', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Wユニコード文字'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'採番', @level2type=N'COLUMN',@level2name=N'PCNAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'採番', @level2type=N'COLUMN',@level2name=N'PCNAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'採番', @level2type=N'COLUMN',@level2name=N'PCNAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=960 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'採番', @level2type=N'COLUMN',@level2name=N'PCNAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'採番', @level2type=N'COLUMN',@level2name=N'PCNAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Format', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'採番', @level2type=N'COLUMN',@level2name=N'PCNAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'採番', @level2type=N'COLUMN',@level2name=N'PCNAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'採番', @level2type=N'COLUMN',@level2name=N'PCNAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'採番', @level2type=N'COLUMN',@level2name=N'店舗ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'採番', @level2type=N'COLUMN',@level2name=N'店舗ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'採番', @level2type=N'COLUMN',@level2name=N'店舗ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=960 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'採番', @level2type=N'COLUMN',@level2name=N'店舗ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'採番', @level2type=N'COLUMN',@level2name=N'店舗ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Format', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'採番', @level2type=N'COLUMN',@level2name=N'店舗ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'採番', @level2type=N'COLUMN',@level2name=N'店舗ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'採番', @level2type=N'COLUMN',@level2name=N'店舗ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'採番', @level2type=N'COLUMN',@level2name=N'テーブル名'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'採番', @level2type=N'COLUMN',@level2name=N'テーブル名'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'採番', @level2type=N'COLUMN',@level2name=N'テーブル名'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=2280 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'採番', @level2type=N'COLUMN',@level2name=N'テーブル名'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'採番', @level2type=N'COLUMN',@level2name=N'テーブル名'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Format', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'採番', @level2type=N'COLUMN',@level2name=N'テーブル名'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'採番', @level2type=N'COLUMN',@level2name=N'テーブル名'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'採番', @level2type=N'COLUMN',@level2name=N'テーブル名'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'採番', @level2type=N'COLUMN',@level2name=N'IDNew'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'採番', @level2type=N'COLUMN',@level2name=N'IDNew'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'採番', @level2type=N'COLUMN',@level2name=N'IDNew'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=870 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'採番', @level2type=N'COLUMN',@level2name=N'IDNew'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'採番', @level2type=N'COLUMN',@level2name=N'IDNew'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Format', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'採番', @level2type=N'COLUMN',@level2name=N'IDNew'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'採番', @level2type=N'COLUMN',@level2name=N'IDNew'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'採番', @level2type=N'COLUMN',@level2name=N'IDNew'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'採番', @level2type=N'COLUMN',@level2name=N'IDOld'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'採番', @level2type=N'COLUMN',@level2name=N'IDOld'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'採番', @level2type=N'COLUMN',@level2name=N'IDOld'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=870 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'採番', @level2type=N'COLUMN',@level2name=N'IDOld'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'採番', @level2type=N'COLUMN',@level2name=N'IDOld'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Format', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'採番', @level2type=N'COLUMN',@level2name=N'IDOld'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'採番', @level2type=N'COLUMN',@level2name=N'IDOld'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'採番', @level2type=N'COLUMN',@level2name=N'IDOld'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DefaultView', @value=0x02 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'採番'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Filter', @value=NULL , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'採番'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_FilterOnLoad', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'採番'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_HideNewField', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'採番'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_OrderBy', @value=NULL , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'採番'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_OrderByOn', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'採番'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_OrderByOnLoad', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'採番'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Orientation', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'採番'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TableMaxRecords', @value=10000 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'採番'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TotalsRow', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'採番'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'販売_見積', @level2type=N'COLUMN',@level2name=N'見積ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'販売_見積', @level2type=N'COLUMN',@level2name=N'見積ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'販売_見積', @level2type=N'COLUMN',@level2name=N'見積ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=960 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'販売_見積', @level2type=N'COLUMN',@level2name=N'見積ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'販売_見積', @level2type=N'COLUMN',@level2name=N'見積ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'販売_見積', @level2type=N'COLUMN',@level2name=N'日付'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'販売_見積', @level2type=N'COLUMN',@level2name=N'日付'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'販売_見積', @level2type=N'COLUMN',@level2name=N'日付'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=2460 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'販売_見積', @level2type=N'COLUMN',@level2name=N'日付'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'販売_見積', @level2type=N'COLUMN',@level2name=N'日付'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'販売_見積', @level2type=N'COLUMN',@level2name=N'金額'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'販売_見積', @level2type=N'COLUMN',@level2name=N'金額'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'販売_見積', @level2type=N'COLUMN',@level2name=N'金額'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=1140 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'販売_見積', @level2type=N'COLUMN',@level2name=N'金額'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'販売_見積', @level2type=N'COLUMN',@level2name=N'金額'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DefaultView', @value=0x02 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'販売_見積'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Filter', @value=NULL , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'販売_見積'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_FilterOnLoad', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'販売_見積'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_HideNewField', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'販売_見積'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_OrderBy', @value=NULL , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'販売_見積'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_OrderByOn', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'販売_見積'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_OrderByOnLoad', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'販売_見積'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Orientation', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'販売_見積'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TableMaxRecords', @value=10000 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'販売_見積'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TotalsRow', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'販売_見積'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'販売_見積詳細', @level2type=N'COLUMN',@level2name=N'税区分'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Format', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'販売_見積詳細', @level2type=N'COLUMN',@level2name=N'税区分'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'販売_見積詳細', @level2type=N'COLUMN',@level2name=N'税区分'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'販売_見積詳細', @level2type=N'COLUMN',@level2name=N'課税対象額'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Format', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'販売_見積詳細', @level2type=N'COLUMN',@level2name=N'課税対象額'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'販売_見積詳細', @level2type=N'COLUMN',@level2name=N'課税対象額'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'販売_店舗', @level2type=N'COLUMN',@level2name=N'店舗ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'販売_店舗', @level2type=N'COLUMN',@level2name=N'店舗ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'販売_店舗', @level2type=N'COLUMN',@level2name=N'店舗ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=960 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'販売_店舗', @level2type=N'COLUMN',@level2name=N'店舗ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'販売_店舗', @level2type=N'COLUMN',@level2name=N'店舗ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'販売_店舗', @level2type=N'COLUMN',@level2name=N'店舗名'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'販売_店舗', @level2type=N'COLUMN',@level2name=N'店舗名'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'販売_店舗', @level2type=N'COLUMN',@level2name=N'店舗名'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'販売_店舗', @level2type=N'COLUMN',@level2name=N'店舗名'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'販売_店舗', @level2type=N'COLUMN',@level2name=N'店舗名'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DefaultView', @value=0x02 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'販売_店舗'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Filter', @value=NULL , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'販売_店舗'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_FilterOnLoad', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'販売_店舗'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_HideNewField', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'販売_店舗'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_OrderBy', @value=NULL , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'販売_店舗'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_OrderByOn', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'販売_店舗'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_OrderByOnLoad', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'販売_店舗'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Orientation', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'販売_店舗'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TableMaxRecords', @value=10000 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'販売_店舗'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TotalsRow', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'販売_店舗'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "QF_商品抽出"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 91
               Right = 187
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'V_QF_商品抽出'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'V_QF_商品抽出'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'V_STR日付', @level2type=N'COLUMN',@level2name=N'w更新日'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'V_STR日付', @level2type=N'COLUMN',@level2name=N'w更新日'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'V_STR日付', @level2type=N'COLUMN',@level2name=N'w更新日'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'V_STR日付', @level2type=N'COLUMN',@level2name=N'w更新日'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'V_STR日付', @level2type=N'COLUMN',@level2name=N'w更新日'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'V_STR日付', @level2type=N'COLUMN',@level2name=N'w更新日2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'V_STR日付', @level2type=N'COLUMN',@level2name=N'w更新日2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'V_STR日付', @level2type=N'COLUMN',@level2name=N'w更新日2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'V_STR日付', @level2type=N'COLUMN',@level2name=N'w更新日2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'V_STR日付', @level2type=N'COLUMN',@level2name=N'w更新日2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'V_STR日付', @level2type=N'COLUMN',@level2name=N'更新日'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'V_STR日付', @level2type=N'COLUMN',@level2name=N'更新日'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'V_STR日付', @level2type=N'COLUMN',@level2name=N'更新日'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=2460 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'V_STR日付', @level2type=N'COLUMN',@level2name=N'更新日'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'V_STR日付', @level2type=N'COLUMN',@level2name=N'更新日'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DefaultView', @value=0x02 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'V_STR日付'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "商品"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 203
               Right = 197
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1845
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 2580
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'V_STR日付'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'V_STR日付'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Filter', @value=NULL , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'V_STR日付'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_FilterOnLoad', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'V_STR日付'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_HideNewField', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'V_STR日付'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_OrderBy', @value=NULL , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'V_STR日付'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_OrderByOn', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'V_STR日付'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_OrderByOnLoad', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'V_STR日付'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Orientation', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'V_STR日付'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TableMaxRecords', @value=10000 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'V_STR日付'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TotalsRow', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'V_STR日付'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[25] 4[32] 2[9] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "見積"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 106
               Right = 187
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 780
         Width = 1800
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'V_日付抽出'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'V_日付抽出'
GO
USE [master]
GO
ALTER DATABASE [basic] SET  READ_WRITE 
GO
