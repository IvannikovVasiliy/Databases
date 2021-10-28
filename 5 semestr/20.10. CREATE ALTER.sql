CREATE TABLE ���������� (
	  id_���������� INT NOT NULL
	, �������� NVARCHAR(50) NOT NULL
	, [��� ����������] INT NOT NULL
);

CREATE TABLE ��������� (
	  id_��������� INT NOT NULL
	, �������� NVARCHAR(30) NOT NULL
	, ����� INT NOT NULL
);

CREATE TABLE �������������_�_��������� (
	  id_�� INT NOT NULL
	, id_������������� INT NOT NULL
	, id_��������� INT NOT NULL
	, [���� ����������] DATE NOT NULL DEFAULT GETDATE()
	, [���� ������] DATE
);

CREATE TABLE ������������� (
	  id_������������� INT NOT NULL
	, ������� NVARCHAR(30) NOT NULL
	, ��� NVARCHAR(30) NOT NULL
	, �������� NVARCHAR(30)
	, [���� ��������] DATE NOT NULL
	, [e-mail] NVARCHAR(100) NOT NULL
	, id_���������� INT NOT NULL
	, id_������������ INT
);

CREATE TABLE ���������� (
	  id_���������� INT NOT NULL
	, �������� NVARCHAR(70) NOT NULL
	, id_������ INT
);

CREATE TABLE �������� (
	  [����� ������������� ������] INT NOT NULL
		CONSTRAINT ��������_[����� ������������� ������]_PK PRIMARY KEY
	, ������� NVARCHAR(30) NOT NULL
	, ��� NVARCHAR(30) NOT NULL
	, �������� NVARCHAR(30)
	, [���� ��������] DATE NOT NULL
	, ���� INT NOT NULL
	, ������ INT NULL
	, ��������� INT
	, id_���������� INT NOT NULL
);

ALTER TABLE ��������
ADD PRIMARY KEY([����� ������������� ������])

CREATE TABLE ������������(
	  id_������������ INT NOT NULL
		CONSTRAINT ������������_id_�����������_PK PRIMARY KEY(id_������������)
	, ���� DATE NOT NULL
	, [����� ������������� ������] INT NOT NULL
		CONSTRAINT ������������_��������_FK FOREIGN KEY([����� ������������� ������])
		REFERENCES ��������([����� ������������� ������])
	, id_����������
	, id_�������������
	, ������
)

ALTER TABLE ����������
ADD PRIMARY KEY(id_����������);

ALTER TABLE ���������
ADD PRIMARY KEY(id_���������)
	, CHECK (����� > 0);

ALTER TABLE �������������_�_���������
ADD PRIMARY KEY(id_��)
	, CONSTRAINT �������������_�_���������_���������_FK FOREIGN KEY(id_���������)
	  REFERENCES ���������(id_���������)
	, CONSTRAINT �������������_�_���������_���������_FK FOREIGN KEY(id_�������������)
	  REFERENCES �������������(id_�������������);

ALTER TABLE �������������
ADD   PRIMARY KEY(id_�������������)
	, CONSTRAINT �������������_�������������_FK FOREIGN KEY(id_������������)
	  REFERENCES �������������(id_�������������)
	, CONSTRAINT �������������_����������_FK FOREIGN KEY(id_����������)
	  REFERENCES ����������(id_����������)
	, CONSTRAINT email_UK UNIQUE(email);