--46.������� ���������� ����� ������������� ����� ���������.
--� ������� ����
SELECT DISTINCT �_����.*
FROM �������� �_���� JOIN ��������_����� �_� ON �_����.id_�������� = �_�.id_��������
WHERE YEAR(�_�.[���� �������� ����]) = YEAR(GETDATE()) OR YEAR(�_�.[���� �������� ����]) = YEAR(GETDATE()) OR YEAR([���� ������]) = YEAR(GETDATE());

--51.������� ��� ������ ��������, ������� �� ��� � ����������
--� ������� ����, �� ����� �� ����� �����.
SELECT �.id_��������
FROM �������� �
WHERE NOT EXISTS(
					SELECT 1
					FROM ��������_����� �_�
					WHERE (YEAR([���� �������� ����]) = 2021 OR YEAR([���� ������]) = 2021) AND �.id_�������� = �_�.id_��������
			  );

--52.������� id � ��� ��������, ������� ����� �� ����� ����� ���� ����.
SELECT �.id_��������, �.�������, �.���, �.��������
FROM �������� � JOIN ��������_����� �_� ON �.id_�������� = �_�.id_�������� JOIN ����� � ON �.id_����� = �_�.id_�����
WHERE �_�.[���� �������� ����] IS NULL AND �_�.[���� ������] IS NOT NULL
GROUP BY �.id_��������, �.�������, �.���, �.��������
HAVING COUNT(�.id_�����) > 5;

--55.������� ��� � ������� ��������, ������� �������� ��� �����,
--����� ��� ������� ������.
WITH Count_Reading_Books(ID_��������, ID_�����, COUNT_BOOKS) AS (
	SELECT �_�.id_��������, �.id_�����, COUNT(�.id_�����)
	FROM ��������_����� �_� JOIN ����� � ON �_�.id_����� = �.id_�����
	GROUP BY �_�.id_��������, �.id_�����
)
SELECT �.id_��������, �.�������, �.���, �.��������
FROM �������� �
WHERE NOT EXISTS(
					SELECT 1
					FROM �������� �_����� JOIN Count_Reading_Books CRB ON CRB.ID_�������� = �_�����.id_��������
					WHERE CRB.COUNT_BOOKS = 1 AND �.id_�������� = �_�����.id_��������
				) AND
	  EXISTS(
				SELECT 1
				FROM �������� �_����� JOIN Count_Reading_Books CRB ON CRB.ID_�������� = �_�����.id_��������
				WHERE �.id_�������� = �_�����.id_��������
			);

--61.������� ������ ��������� ��������.
	SELECT �_�.id_��������, �.id_�����, COUNT(�.id_�����)
	FROM ��������_����� �_� JOIN ����� � ON �_�.id_����� = �.id_�����
	GROUP BY �_�.id_��������, �.id_�����
),
Sum_Books(id_��������, sum_books) AS(
	SELECT ID_��������, SUM(COUNT_BOOKS)
	FROM Count_Reading_Books
	GROUP BY ID_��������
)
SELECT �.id_��������
FROM �������� � JOIN Sum_Books SB ON �.id_�������� = SB.id_��������
GROUP BY �.id_��������, SB.sum_books
HAVING SB.sum_books >= ALL(
							SELECT sum_books
							FROM Sum_Books
						  );

--����� ���������, ������� ��������� ����� ���� ������� (�� ����������� ��� �����)
SELECT �.�������, �.���, �.��������, �.�������