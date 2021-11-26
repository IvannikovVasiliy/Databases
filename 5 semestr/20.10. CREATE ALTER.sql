CREATE TABLE Дисциплины (
	  id_дисциплины INT NOT NULL
	, Название NVARCHAR(50) NOT NULL
	, [Код дисциплины] INT NOT NULL 
);

CREATE TABLE Должности (
	  id_должности INT NOT NULL
	, Название NVARCHAR(30) NOT NULL
	, Оклад INT NOT NULL
);

CREATE TABLE Преподаватель_в_Должности (
	  id_пд INT NOT NULL
	, id_преподавателя INT NOT NULL
	, id_должности INT NOT NULL
	, [Дата вступления] DATE NOT NULL DEFAULT GETDATE()
	, [Дата выхода] DATE
);

CREATE TABLE Преподаватели (
	  id_преподаватели INT NOT NULL
	, Фамилия NVARCHAR(30) NOT NULL
	, Имя NVARCHAR(30) NOT NULL
	, Отчество NVARCHAR(30)
	, [Дата рождения] DATE NOT NULL
	, [e-mail] NVARCHAR(100) NOT NULL
	, id_факультета INT NOT NULL
	, id_руководителя INT
);

CREATE TABLE Факультеты (
	  id_факультета INT NOT NULL
	, Название NVARCHAR(70) NOT NULL
	, id_декана INT
);

CREATE TABLE Студенты (
	  [Номер студенческого билета] INT NOT NULL 
		PRIMARY KEY
	, Фамилия NVARCHAR(30) NOT NULL
	, Имя NVARCHAR(30) NOT NULL
	, Отчество NVARCHAR(30)
	, [Дата рождения] DATE NOT NULL
	, Курс INT NOT NULL
	, Группа INT NULL
	, Стипендия INT
	, id_факультета INT NOT NULL
);

CREATE TABLE Успеваемость(
	  id_успеваемости INT NOT NULL
		CONSTRAINT Успеваемость_id_успваемости_PK PRIMARY KEY(id_успеваемости)
	, Дата DATE
	, [Номер студенческого билета] INT NOT NULL
		CONSTRAINT Успеваемость_Студенты_FK FOREIGN KEY([Номер студенческого билета])
		REFERENCES Студенты([Номер студенческого билета])
	, id_дисциплины INT
	, id_преподавателя INT
	, Оценка INT
);

ALTER TABLE Дисциплины
ADD   PRIMARY KEY(id_дисциплины)
	, CONSTRAINT [Код дисциплины] UNIQUE;

ALTER TABLE Должности
ADD PRIMARY KEY(id_должности)
	, CHECK (Оклад > 0);

ALTER TABLE Преподаватель_в_Должности
ADD PRIMARY KEY(id_пд)
	, UNIQUE(id_преподавателя)
	, CONSTRAINT Преподаватель_в_Должности_Должности_FK FOREIGN KEY(id_должности)
	  REFERENCES Должности(id_должности)
	, CONSTRAINT Преподаватель_в_Должности_Должности_FK FOREIGN KEY(id_преподавателя)
	  REFERENCES Преподаватель(id_преподавателя);

ALTER TABLE Преподаватели
ADD   PRIMARY KEY(id_преподавателя)
	, CONSTRAINT Преподаватели_Преподаватели_FK FOREIGN KEY(id_руководителя)
	  REFERENCES Преподаватель(id_преподавателя)
	, CONSTRAINT Преподаватели_Факультеты_FK FOREIGN KEY(id_факультета)
	  REFERENCES Факультеты(id_факультета)
	, CONSTRAINT email_UK UNIQUE(email);

ALTER TABLE Факультеты
ADD   PRIMARY KEY(id_факультета)
	, CONSTRAINT Факультеты_Преподаватели_FK FOREIGN KEY(id_декана)
	  REFERENCES Преподаватели(id_преподавателя);

ALTER TABLE Студенты
ADD CONSTRAINT Студенты_FK FOREIGN KEY(id_факультета)
	REFERENCES Факультеты(id_факультета);

ALTER TABLE Успеваемость
ADD   CONSTRAINT Успеваемость_FK FOREIGN KEY(id_дисциплины)
	  REFERENCES Дисциплины(id_дисциплины)
	, CONSTRAINT Успеваемость_FK FOREIGN KEY(id_преподавателя)
	  REFERENCES Преподаватели(id_преподавателя);

ALTER TABLE Дисциплины
ADD   PRIMARY KEY(id_дисциплины)
	, UNIQUE([Код дисциплины]);