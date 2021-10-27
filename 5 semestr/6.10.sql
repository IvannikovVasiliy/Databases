--46.Выбрать количество тезок однофамильцев среди читателей.SELECT COUNT(DISTINCT Ч1.id_читателя)FROM Читатели Ч1 JOIN Читатели Ч2 ON Ч1.id_читателя <> Ч2.id_читателя AND Ч1.Фамилия = Ч2.Фамилия;--47.Выбрать идентификатор, название и автора самой старой книги.SELECT К.id_книги, К.Название, А.id_автораFROM Книги К JOIN [Книга Автор] К_А ON К_А.id_книги = К.id_книги JOIN Авторы А ON А.id_автора = К_А.id_автораWHERE К.[Год издания] = (							SELECT MIN([Год издания])							FROM Книги						);--50.Выбрать все данные читателя, который не был в библиотеке
--в текущем году
SELECT DISTINCT Ч_ВНЕШ.*
FROM Читатели Ч_ВНЕШ JOIN Читатель_Книга Ч_К ON Ч_ВНЕШ.id_читателя = Ч_К.id_читателя
WHERE YEAR(Ч_К.[Дата возврата план]) = YEAR(GETDATE()) OR YEAR(Ч_К.[Дата возврата факт]) = YEAR(GETDATE()) OR YEAR([Дата выдачи]) = YEAR(GETDATE());

--51.Выбрать все данные читателя, который не был в библиотеке
--в текущем году, но имеет на руках книги.
SELECT Ч.id_читателя
FROM Читатели Ч
WHERE NOT EXISTS(
					SELECT 1
					FROM Читатель_Книга Ч_К
					WHERE (YEAR([Дата возврата факт]) = 2021 OR YEAR([Дата выдачи]) = 2021) AND Ч.id_читателя = Ч_К.id_читателя
			  );

--52.Выбрать id и ФИО читателя, который имеет на руках более пяти книг.
SELECT Ч.id_читателя, Ч.Фамилия, Ч.Имя, Ч.Отчество
FROM Читатели Ч JOIN Читатель_Книга Ч_К ON Ч.id_читателя = Ч_К.id_читателя JOIN Книги К ON К.id_книги = Ч_К.id_книги
WHERE Ч_К.[Дата возврата факт] IS NULL AND Ч_К.[Дата выдачи] IS NOT NULL
GROUP BY Ч.id_читателя, Ч.Фамилия, Ч.Имя, Ч.Отчество
HAVING COUNT(К.id_книги) > 5;

--55.Выбрать ФИО и телефон читателя, который прочитал все книги,--имеющиеся в библиотеке.SELECT Ч.Фамилия, Ч.Имя, Ч.Отчество, Ч.ТелефонFROM Читатель_Книга Ч_К join Читатели Ч ON Ч.id_читателя = Ч_К.id_читателяGROUP BY Ч.Фамилия, Ч.Имя, Ч.Отчество, Ч.ТелефонHAVING COUNT(DISTINCT id_книги) = (	 								SELECT COUNT(id_книги)									FROM Книги		    					  );--59.Выбрать ФИО читателя, который каждую книгу из тех что он брал
--читал как минимум дважды.
WITH Count_Reading_Books(ID_ЧИТАТЕЛЯ, ID_КНИГИ, COUNT_BOOKS) AS (
	SELECT Ч_К.id_читателя, К.id_книги, COUNT(К.id_книги)
	FROM Читатель_Книга Ч_К JOIN Книги К ON Ч_К.id_книги = К.id_книги
	GROUP BY Ч_К.id_читателя, К.id_книги
)
SELECT Ч.id_читателя, Ч.Фамилия, Ч.Имя, Ч.Отчество
FROM Читатели Ч
WHERE NOT EXISTS(
					SELECT 1
					FROM Читатели Ч_ВНУТР JOIN Count_Reading_Books CRB ON CRB.ID_ЧИТАТЕЛЯ = Ч_ВНУТР.id_читателя
					WHERE CRB.COUNT_BOOKS = 1 AND Ч.id_читателя = Ч_ВНУТР.id_читателя
				) AND
	  EXISTS(
				SELECT 1
				FROM Читатели Ч_ВНУТР JOIN Count_Reading_Books CRB ON CRB.ID_ЧИТАТЕЛЯ = Ч_ВНУТР.id_читателя
				WHERE Ч.id_читателя = Ч_ВНУТР.id_читателя
			);

--61.Выбрать самого активного читателя.WITH Count_Reading_Books(ID_ЧИТАТЕЛЯ, ID_КНИГИ, COUNT_BOOKS) AS (
	SELECT Ч_К.id_читателя, К.id_книги, COUNT(К.id_книги)
	FROM Читатель_Книга Ч_К JOIN Книги К ON Ч_К.id_книги = К.id_книги
	GROUP BY Ч_К.id_читателя, К.id_книги
),
Sum_Books(id_читателя, sum_books) AS(
	SELECT ID_ЧИТАТЕЛЯ, SUM(COUNT_BOOKS)
	FROM Count_Reading_Books
	GROUP BY ID_ЧИТАТЕЛЯ
)
SELECT Ч.id_читателя
FROM Читатели Ч JOIN Sum_Books SB ON Ч.id_читателя = SB.id_читателя
GROUP BY Ч.id_читателя, SB.sum_books
HAVING SB.sum_books >= ALL(
							SELECT sum_books
							FROM Sum_Books
						  );

--Найти читателей, которые прочитали книги всех авторов (не обязательно все книги)
SELECT Ч.Фамилия, Ч.Имя, Ч.Отчество, Ч.ТелефонFROM Читатель_Книга Ч_К join Читатели Ч ON Ч.id_читателя = Ч_К.id_читателяGROUP BY Ч.Фамилия, Ч.Имя, Ч.Отчество, Ч.ТелефонHAVING COUNT(DISTINCT id_книги) = (	 								SELECT COUNT(id_автора)									FROM Авторы		    					  );