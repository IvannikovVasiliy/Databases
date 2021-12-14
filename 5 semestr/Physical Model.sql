CREATE TABLE Country(
	id_country INT NOT NULL
	, Name_Country NVARCHAR(50) NOT NULL
);

ALTER TABLE Country
ADD CONSTRAINT PK_country_id_country PRIMARY KEY(id_country);

CREATE TABLE Club(
	id_club INT NOT NULL
	, Name_Club NVARCHAR(25) NOT NULL
	, rate REAL NOT NULL
	, id_country INT NOT NULL
);

ALTER TABLE Club
ADD CHECK(Rate BETWEEN 0 AND 5)
	, CONSTRAINT PK_club_id_club PRIMARY KEY(id_club)
	, CONSTRAINT FK_club_id_country FOREIGN KEY(id_country)
	  REFERENCES Country(id_country);

CREATE TABLE Owner_Club(
	id_owner INT NOT NULL
	, [Percent] INT NOT NULL
	, Profit INT NOT NULL
	, id_club INT NOT NULL
);

ALTER TABLE Owner_Club
ADD CHECK([Percent] BETWEEN 0 AND 100)
    , CONSTRAINT FK_Own_Club_id_owner FOREIGN KEY(id_owner)
	  REFERENCES Owners(id_owner)
	, CONSTRAINT FK_Own_Club_id_club FOREIGN KEY(id_club)
	  REFERENCES Club(id_club);

CREATE TABLE Owners(
	id_owner INT NOT NULL
	, Surname NVARCHAR(50) NOT NULL
	, [Name] NVARCHAR(50) NOT NULL
	, [Patronomyc name] NVARCHAR(50)
	, id_club INT NOT NULL
);

ALTER TABLE Owners
ADD CONSTRAINT PK_Own_id_owner PRIMARY KEY(id_owner);

CREATE TABLE Team(
	id_team INT NOT NULL
	, [Name team] NVARCHAR(40) NOT NULL
	, rate REAL NOT NULL
	, id_club INT NOT NULL
);

ALTER TABLE Team
ADD CHECK(Rate BETWEEN 0 AND 5)
	, CONSTRAINT PK_Team_id_team PRIMARY KEY(id_team)
	, CONSTRAINT FK_Team_id_club FOREIGN KEY(id_club) 
	  REFERENCES Club(id_club);

CREATE TABLE Players(
	id_player INT NOT NULL
	, Surname NVARCHAR(30) NOT NULL
	, [Name] NVARCHAR(30) NOT NULL
	, Patronomic_Name NVARCHAR(30)
	, Gender NVARCHAR(10) NOT NULL
	, Birth_date DATE NOT NULL
	, Balls INT NOT NULL
	, id_team INT
);

ALTER TABLE Players
ADD CONSTRAINT PK_Player_id_player PRIMARY KEY(id_player)
	, CONSTRAINT FK_Player_id_team FOREIGN KEY(id_team) 
	  REFERENCES Team(id_team);

CREATE TABLE Staff(
	id_staff INT NOT NULL
	, Surname NVARCHAR(30) NOT NULL
	, [Name] NVARCHAR(30) NOT NULL
	, Patronomic_Name NVARCHAR(30)
	, Gender NVARCHAR(10) NOT NULL
	, Birth_date DATE NOT NULL
);

ALTER TABLE Staff
ADD CONSTRAINT PK_Staff_id_staff PRIMARY KEY(id_staff)
	
CREATE TABLE Staff_Position(
	id_staff INT NOT NULL
	, id_position INT NOT NULL
	, [Date start] DATE NOT NULL
	, [Date finish] DATE
	, id_team INT NOT NULL
);

ALTER TABLE Staff_Position
ADD CHECK([Date finish] > [Date start] OR [Date finish] <= GETDATE() OR [Date finish] IS NULL)
	, CONSTRAINT FK_Staff_Pos_id_team FOREIGN KEY(id_team)
	  REFERENCES Team(id_team)
	, CONSTRAINT FK_Staff_Pos_id_pos FOREIGN KEY(id_position)
	  REFERENCES Position(id_position)
	, CONSTRAINT FK_Staff_Pos_id_staff FOREIGN KEY(id_staff)
	  REFERENCES Staff(id_staff);

CREATE TABLE Position(
	id_position INT NOT NULL
	, [Name position] NVARCHAR(25) UNIQUE
	, Salary INT NOT NULL
);

ALTER TABLE Position
ADD CHECK(Salary > 0)
	, CONSTRAINT PK_pos_id_pos PRIMARY KEY(id_position);

CREATE TABLE Training_Base(
	id_base INT NOT NULL
	, [Name] NVARCHAR(20) NOT NULL UNIQUE
	, Adress NVARCHAR(30) NOT NULL
	, [Count football fields] INT NOT NULL
	, id_club INT NOT NULL
);

ALTER TABLE Training_Base
ADD CHECK([Count football fields] > 0)
	, CONSTRAINT PK_base_id_base PRIMARY KEY(id_base)
	, CONSTRAINT FK_base_id_club FOREIGN KEY(id_club) 
	  REFERENCES Club(id_club);

CREATE TABLE Preparations(
	id_preparation INT NOT NULL
	, [Start_Date] DATE NOT NULL
	, Finish_Date DATE NOT NULL
	, id_base INT NOT NULL
	, id_club INT NOT NULL
);

ALTER TABLE Preparations
ADD CONSTRAINT PK_prepar_id_preparation PRIMARY KEY(id_preparation)
	, CONSTRAINT FK_prepar_id_club FOREIGN KEY(id_club)
	  REFERENCES Club(id_club)
	, CONSTRAINT FK_prepar_id_base FOREIGN KEY(id_base)
	  REFERENCES Training_base(id_base);

CREATE TABLE Team_Competitions(
	id_team INT NOT NULL
	, id_comp INT NOT NULL
	, Season NVARCHAR(9) NOT NULL
);

ALTER TABLE Team_Competitions
ADD CONSTRAINT FK_Team_comp_id_club FOREIGN KEY(id_team)
	REFERENCES Team(id_team)
  , CONSTRAINT FK_team_comp_id_comp FOREIGN KEY(id_comp)
    REFERENCES History_Competitions(id_comp);

CREATE TABLE Competitions(
	id_competition INT NOT NULL
	, [Name] NVARCHAR(50) NOT NULL UNIQUE
	, type_competition NVARCHAR(25) NOT NULL
	, [Winner fund] INT
);

ALTER TABLE Competitions
ADD CONSTRAINT PK_comp_id_competition PRIMARY KEY(id_competition);

CREATE TABLE History_Competitions(
	id_comp INT NOT NULL
	, [Start_Date] DATE NOT NULL
	, [Finish Date] DATE NOT NULL
	, Place NVARCHAR(10) NOT NULL
	, id_competition INT NOT NULL
);

ALTER TABLE History_Competitions
ADD CONSTRAINT PK_Hist_Comp_id_comp PRIMARY KEY(id_comp)
	, CONSTRAINT FK_Hist_Comp_id_competition FOREIGN KEY(id_competition)
	  REFERENCES Competitions(id_competition);

CREATE TABLE Stadium(
	id_club_stadium INT NOT NULL
	, [Name stadium] NVARCHAR(20) NOT NULL UNIQUE
	, Adress NVARCHAR(40) NOT NULL UNIQUE
	, [Type sward] NVARCHAR(25) NOT NULL
	, [Count visitors] INT NOT NULL
);

ALTER TABLE Stadium
ADD CHECK([Count visitors] > 0)
	, CONSTRAINT PK_stad_id_club_stadium PRIMARY KEY(id_club_stadium)
	, CONSTRAINT FK_stad_id_club_stad FOREIGN KEY(id_club_stadium) 
	  REFERENCES Club(id_club);

CREATE TABLE Matches(
	id_play INT NOT NULL
	, id_team1 INT NOT NULL
	, id_team2 INT NOT NULL
	, Season NVARCHAR(9) NOT NULL
	, id_comp INT
	, id_stadium INT NOT NULL
	, [Date-Time play] DATETIME NOT NULL
	, Result NVARCHAR(7) NOT NULL DEFAULT '0-0'
);

ALTER TABLE Matches
ADD CONSTRAINT PK_match_id_play PRIMARY KEY(id_play)
	, CONSTRAINT FK_match_id_stadium FOREIGN KEY(id_stadium)
	  REFERENCES Stadium(id_club_stadium)
	, CONSTRAINT FK_Match_id_team1 FOREIGN KEY(id_team1)
	  REFERENCES Team(id_team)
	, CONSTRAINT FK_Match_id_team2 FOREIGN KEY(id_team2)
	  REFERENCES Team(id_team)
	, CONSTRAINT FK_Match_id_comp FOREIGN KEY(id_comp)
	  REFERENCES History_Competitions(id_comp);

CREATE TABLE [Match information](
	id_play INT NOT NULL
	, [Type match] NVARCHAR(15) NOT NULL
	, [Price ticket] INT NOT NULL
	, [Count sells' tickets] INT NOT NULL
	, Weather NVARCHAR(25) NOT NULL
);

ALTER TABLE [Match information]
ADD   CONSTRAINT PK_info_id_play PRIMARY KEY(id_play)
	, CONSTRAINT FK_info_id_play FOREIGN KEY(id_play)
	  REFERENCES Matches(id_play);

