--1. ������� �������� ����������, ��� ������, ���������� �������, ���������� �� ���������� � ����� ���������� �������, ���������� � ���.
SELECT �.��������, (SELECT �_�����.������� + ' ' + �_�����.��� + ' ' + �_�����.�������� FROM ������������� �_�����), 
	   COUNT(�.id_�������������) OVER (PARTITION BY �.id_����������), COUNT(�.id_�������������) OVER()
FROM ������������� � JOIN ���������� � ON �.id_���������� = �.id_����������;

--2. ������� ��� ��������, ����, ������, ���������� ������� � ������, ���������� ������� �� �����, ���������� ������� � ���.
SELECT �.�������, �.���, �.��������, �.����, �.������, COUNT(�.[����� ������������� ������]) OVER (PARTITION BY �.����, �.������),
	   COUNT(�.[����� ������������� ������]) OVER (PARTITION BY �.����), COUNT(�.[����� ������������� ������]) OVER ()
FROM �������� �;

--3. ������� ��� ������������� � ��� ��� ������������. ������ �� ����������� �.�.
WITH CTE(id, [���], id_manager) AS(
	SELECT id_�������������, ������� + ' ' + ��� + ' ' + ��������, id_������������
	FROM �������������
	UNION ALL
	SELECT �.id_�������������, �.������� + ' ' + �.��� + ' ' + �.��������, �.id_������������
	FROM ������������� � JOIN CTE ON �.id_������������ = CTE.id
)
SELECT [���], id_manager
FROM CTE;

--5. ������� ��� ���� �������� ������.
WITH CTE AS(
	SELECT 1 AS N
	UNION ALL
	SELECT N + 1
	FROM CTE
	WHERE N < DAY(EOMONTH(GETDATE()))
)
SELECT *
FROM CTE