--????? ?????????? ?????????????
WITH Stud_COUNT(???????, [?????????? ?????????-?????????????]) AS(
	SELECT ???????, COUNT(???????)
	FROM ????????
	GROUP BY ???????
	HAVING COUNT(???????) > 1
)
SELECT SUM([?????????? ?????????-?????????????])
FROM Stud_COUNT

/*??? ????????? ?????? ???????*/
SELECT ?.???????, ?.???, ?.????????, ?.????
FROM ???????????? ? JOIN ???????? ? ON ?.[????? ????????????? ??????] = ?.[????? ????????????? ??????]
WHERE ?.???? IN 
				(
					SELECT MAX(?_?????.????)
					FROM ???????????? ?_?????
					WHERE ?_?????.id_?????????? = ?.id_??????????
				);

--???????, ??????? ?? ????? ????? ???????? ???????????? ?????????
WITH MAX_Schol(????, ?????????) AS
(
	SELECT ????, MAX(?????????)
	FROM ????????
	GROUP BY ????
)
SELECT ?.???????, ?.????, ?.?????????
FROM ???????? ? JOIN MAX_Schol M_S ON ?.???? = M_S.???? AND ?.????????? = M_S.?????????;

SELECT ?_????.???????, ?_????.????, ?_????.?????????
FROM ???????? ?_????
WHERE ????????? IN 
				(
					SELECT MAX(?????????)
					FROM ???????? ?_?????
					WHERE ?_????.???? = ?_?????.????
				)

--????????, ?????????? ???? ?? 1 ???????????????????? ??????.
SELECT ?.[????? ????????????? ??????], ?.??????
FROM ???????? ? JOIN ???????????? ? ON ?.[????? ????????????? ??????] = ?.[????? ????????????? ??????]
WHERE ?.?????? = 2;

SELECT ???????
FROM ???????? ?_????
WHERE EXISTS(
				SELECT 1
				FROM ???????? ?_????? JOIN ???????????? ? ON ?_?????.[????? ????????????? ??????] = ?.[????? ????????????? ??????]
				WHERE ?_????.[????? ????????????? ??????] = ?_?????.[????? ????????????? ??????] AND ?.?????? = 2
			)

--?????????? ??????? ?????????????? ? ?????????
SELECT ???????, ???
FROM ????????
UNION
SELECT ???????, NULL
FROM ?????????????;

--?????????????? ?????
SELECT CAST(???? AS nvarchar(1))
FROM ????????
UNION
SELECT ???????
FROM ?????????????;

--??????? ?????????, ??????? ???????? ? 2001, 2002 ???? ? ? 90-?? ????.
SELECT *
FROM ????????
WHERE YEAR([???? ????????]) IN (2001, 2002)
UNION ALL
SELECT *
FROM ????????
WHERE YEAR([???? ????????]) BETWEEN 1990 AND 1999;

--???????, ????????????? ? ? ?????????, ? ? ??????????????.
SELECT ???????
FROM ????????
INTERSECT
SELECT ???????
FROM ?????????????;

SELECT DISTINCT ?.???????, ?.???, ?.????????
FROM ???????? ? JOIN ????????????? ? ON ?.??????? = ?.???????;

--????????, ??????? ?? ????? ????????????? ????? ??????????????
SELECT ???????
FROM ????????
EXCEPT
SELECT ???????
FROM ?????????????;

--??????? ??????????, ?? ??????? ???????? ??? ?????? ????????????? ? ???????? ??????????????
SELECT ????????
FROM ??????????
WHERE id_?????????? IN 
					(
						SELECT id_??????????
						FROM ?????????????
						UNION
						SELECT id_??????????
						FROM ????????
					);

--?????????, ?? ??????? ???????????? ???-?? ???????
SELECT ????????
FROM ?????????? ? JOIN ???????? ? ON ?.id_?????????? = ?.id_??????????
GROUP BY ?.id_??????????, ?.????????
HAVING COUNT(?.[????? ????????????? ??????]) >= ALL
												(
													SELECT COUNT(?.[????? ????????????? ??????])
													FROM ???????? ?
													GROUP BY ?.id_??????????
												)