--32.Выбрать названия команд, которые сыграли наибольшее количество 
--матчей. 
--33.Выбрать ФИО игрока(ов), забившего наибольшее количество мячей, 
--и ФИО игрока, который стоит вторым по количеству забитых мячей. 
--Результирующая таблица должна содержать один столбец с ФИО.
SELECT * /*Surname + Name + CASE
							WHEN Patronomic_Name IS NULL
							THEN ' '
							ELSE Patronomic_Name
						END*/
FROM Players; 
--34.Выбрать все данные об игроках старше среднего возраста игроков.
--35.Выбрать год, в который родилось больше всего людей по всей БД, 
--т.е. учитывать директоров, тренеров, игроков.
--36.Выбрать для каждой команды суммарный фонд оплаты труда. Учесть 
--игроков, тренеров и др. 
--37.Для каждой команды вывести данные матча, принесшего 
--максимальное количество очков.
--38.Выбрать название и страну команды, которая ни разу не проиграла.
--39.Выбрать название тренировочной базы, на которой не проходили 
--сборы.
--40.Выбрать название команды, которая приняла участие во всех 
--соревнованиях.
SELECT Team.[Name team], COUNT(hist_comp.id_comp)
FROM Team JOIN Matches ON Team.id_team = Matches.id_team1 OR Team.id_team = Matches.id_team2 JOIN History_Competitions hist_comp ON hist_comp.id_comp = Matches.id_team1 OR hist_comp.id_comp = Matches.id_team2
GROUP BY Team.id_team, Team.[Name team]
HAVING COUNT(hist_comp.id_comp) = (SELECT COUNT(*) 
								   FROM History_Competitions);

--41.Выбрать данные последних трех турниров для каждой команды.
--42.Выбрать название страны с максимальным количеством команд.
WITH Count_Teams(id_country, count_teams) AS(
	SELECT Country.id_country, COUNT(Team.id_team)
	FROM Country JOIN Club ON Country.id_country = Club.id_club JOIN Team ON Team.id_club = Club.id_club
	GROUP BY Country.id_country
)
SELECT Country.id_country
FROM Country JOIN Club ON Country.id_country = Club.id_club JOIN Team ON Team.id_club = Club.id_club
GROUP BY Country.id_country
HAVING COUNT(Team.id_team) IN (SELECT MAX(count_teams)
							   FROM Count_Teams)

--43.Выбрать ФИО игроков имеющих однофамильцев среди владельцев.
SELECT Surname, Name, Patronomic_Name
FROM Players
WHERE EXISTS(
				SELECT Surname
				FROM Owners
				WHERE Players.Surname = Owners.Surname
			);

--44.Выбрать количество однофамильцев по всей БД.
--45.Выбрать название команды, ФИО тренера на сегодняшний день, 
--количество игроков в команде на сегодняшний день, количество 
--сыгранных матчей. Результата отсортировать по количеству 
--сыгранных матчей в порядке убывания. В результирующую таблицу 
--включить все команды, имеющиеся в БД.WITH 
	Count_matches_column_1(id_team, count_matches_column1) AS(
		SELECT Team.id_team, COUNT(Matches.id_team1)
		FROM Matches JOIN Team ON Matches.id_team1 = Team.id_team
		GROUP BY Team.id_team)
	, 
	Count_matches_column_2(id_team, count_matches_column2) AS(
		SELECT Team.id_team, COUNT(Matches.id_team2)
		FROM Matches JOIN Team ON Matches.id_team2 = Team.id_team
		WHERE NOT EXISTS (SELECT 1
						  FROM Count_matches_column_1 
						  WHERE Matches.id_team1 = id_team)
		GROUP BY Team.id_team)
SELECT Team.[Name team], Staff.Surname, Staff.Name, Staff.Patronomic_Name, (SELECT COUNT(id_player) FROM Players WHERE id_team = Team.id_team), 
	   (SELECT Count_matches_column1 
	    FROM Count_matches_column_1
		WHERE id_team = Team.id_team)
FROM Staff JOIN Staff_Position staff_pos ON Staff.id_staff = staff_pos.id_staff RIGHT JOIN Team ON Team.id_team = staff_pos.id_team 
WHERE staff_pos.[Date finish] IS NULL
ORDER BY 6 DESC;


--46.Выбрать тренеров, которые работали с командами из более чем двух 
--стран.
SELECT Staff.id_staff
FROM Staff JOIN Staff_Position staff_pos ON Staff.id_staff = staff_pos.id_staff JOIN Team ON Team.id_team = staff_pos.id_team JOIN Club ON Club.id_club = Team.id_club JOIN Country ON Country.id_country = Club.id_country
GROUP BY Staff.id_staff, Country.id_country
HAVING COUNT(Team.id_team) > 1;

--47.Выбрать дату матча, стадион, название команд участниц, фамилию 
--и инициалы тренера, баллы для всех матчей, общее количество матчей 
--сыгранных до текущего матча каждой из команд участниц, какого-то 
--конкретного турнира (конкретное значение подставьте сами)
/*WITH 
	Count_matches_column_1(id_team, count_matches_column1) AS(
		SELECT Team.id_team, COUNT(Matches.id_team1)
		FROM Matches JOIN Team ON Matches.id_team1 = Team.id_team
		GROUP BY Team.id_team)
	, 
	Count_matches_column_2(id_team, count_matches_column2) AS(
		SELECT Team.id_team, COUNT(Matches.id_team2)
		FROM Matches JOIN Team ON Matches.id_team2 = Team.id_team
		GROUP BY Team.id_team)
SELECT CAST(match_extern.[Date-Time play] AS DATE), stad.[Name stadium], team1.[Name team], team2.[Name team], 
	   staff1.Surname + LEFT(staff1.Name, 1) + 
									CASE 
										WHEN staff1.Patronomic_Name IS NOT NULL 
										THEN LEFT(staff1.Patronomic_Name, 1) + '.'
										ELSE ' '
									END, 
	   staff2.Surname + LEFT(staff2.Name, 1) + 
											CASE 
												WHEN staff2.Patronomic_Name IS NOT NULL 
												THEN LEFT(staff2.Patronomic_Name, 1) + '.' 
											END, 
	(SELECT count_matches_column1 
	FROM Count_matches_column_1 
	WHERE id_team = team1.id_team) + (SELECT COUNT(id_team2) 
									FROM Matches M 
									WHERE NOT EXISTS(
														SELECT 1 
														FROM Count_matches_column_1 
														WHERE M.id_team2 = id_team) AND M.id_team2 = team2.id_team
													),
	(SELECT count_matches_column2
	FROM Count_matches_column_2 
	WHERE id_team = team2.id_team) + (SELECT COUNT(id_team1) 
									FROM Matches M 
									WHERE NOT EXISTS(
														SELECT 1 
														FROM Count_matches_column_2
														WHERE M.id_team1 = id_team) AND M.id_team1 = team1.id_team
													)
FROM Matches match_extern JOIN Team team1 ON match_extern.id_team1 = team1.id_team LEFT JOIN Staff_Position staff_pos1 ON staff_pos1.id_team = team1.id_team LEFT JOIN Staff staff1 ON staff1.id_staff = staff_pos1.id_staff 
			 JOIN Team team2 ON match_extern.id_team2 = team2.id_team LEFT JOIN Staff_Position staff_pos2 ON staff_pos2.id_team = team2.id_team LEFT JOIN Staff staff2 ON staff2.id_staff = staff_pos2.id_staff
	 JOIN Stadium stad ON stad.id_club_stadium = match_extern.id_stadium;
	*/
--48.Выбрать названия всех стран и количество команд в стране. Если 
--страна не имеет команды, то вывести ноль.
SELECT Country.Name_Country, COUNT(Club.id_country)
FROM Country JOIN Club ON Club.id_country = Country.id_country
GROUP BY Country.Name_Country;

--49.Выбрать ФИО владельцев клубов, имеющих две команды.
SELECT own.Surname, own.Name, CASE WHEN own.[Patronomyc name] IS NOT NULL THEN own.[Patronomyc name] ELSE ' ' END
FROM Owners own JOIN Owner_Club own_club ON own.id_owner = own_club.id_owner
GROUP BY own.id_owner, own.Surname, own.Name, own.[Patronomyc name]
HAVING COUNT(own_club.id_club) = 2;

--50.Выбрать название чемпионата, в котором приняли участие как 
--минимум по две команды от каждой страны участниц.
WITH
	Teams1(id_team, id_country, Name_country) AS(
		SELECT DISTINCT m.id_team1, coun.id_country, coun.Name_Country
		FROM Matches m JOIN Team t ON m.id_team1 = t.id_team JOIN Club c ON c.id_club = t.id_club JOIN Country coun ON coun.id_country = c.id_country
	)
	,
	Count_Teams1_Group_by_Country(Name_Country, count_teams) AS(
		SELECT coun.Name_Country, COUNT(T.id_team)
		FROM Matches m JOIN Team t ON m.id_team1 = t.id_team JOIN Club c ON c.id_club = t.id_club JOIN Country coun ON coun.id_country = c.id_country
		GROUP BY coun.Name_Country
	)
	,
	Count_Teams2_Group_by_Country(Name_Country, count_teams) AS(
		SELECT coun.Name_Country, COUNT(T.id_team)
		FROM Matches m JOIN Team t ON m.id_team2 = t.id_team JOIN Club c ON c.id_club = t.id_club JOIN Country coun ON coun.id_country = c.id_country
		WHERE NOT EXISTS(SELECT 1 FROM Teams1 T1 WHERE T.id_team = T1.id_team)
		GROUP BY coun.Name_Country
	)
	,
	Group_Country(Name_Country, Count_teams) AS(
		SELECT C.Name_Country, SUM(CTGC.count_teams) + CASE WHEN SUM(CTGC2.count_teams) >= 1 THEN SUM(CTGC2.count_teams) ELSE 0 END
		FROM Country C FULL JOIN Count_Teams1_Group_by_Country CTGC ON C.Name_Country = CTGC.Name_Country FULL JOIN Count_Teams2_Group_by_Country CTGC2 ON CTGC2.Name_Country = C.Name_Country
		GROUP BY C.Name_Country
		HAVING SUM(CTGC.count_teams) + CASE WHEN SUM(CTGC2.count_teams) >= 1 THEN SUM(CTGC2.count_teams) ELSE 0 END > 0
	)
SELECT *
FROM Group_Country
--SELECT comp.Name, coun1.Name_Country, COUN2.Name_Country
--FROM Competitions comp JOIN History_Competitions hist_comp ON comp.id_competition = hist_comp.id_competition JOIN Matches m ON hist_comp.id_comp = m.id_comp JOIN Team t1 ON m.id_team1 = t1.id_team JOIN Club c1 ON c1.id_club = t1.id_club
--	 JOIN Country coun1 ON coun1.id_country = c1.id_country JOIN Team t2 ON m.id_team2 = t2.id_team JOIN Club c2 ON c2.id_club = t2.id_club JOIN Country coun2 ON coun2.id_country = c2.id_country
--WHERE coun1.Name_Country IN (SELECT Name_Country FROM Group_Country WHERE Count_teams >= 2 AND coun1.Name_Country = Name_Country) 
--	  AND coun2.Name_Country IN (SELECT Name_Country FROM Group_Country WHERE Count_teams >= 2  AND coun2.Name_Country = Name_Country) ;

;

--51.Выбрать месяца, в которых нет дней рождений футболистов
WITH CTE(N) AS(
	SELECT 1 AS N
	UNION ALL
	SELECT N + 1
	FROM CTE
	WHERE N < 12
)
SELECT *
FROM CTE
WHERE N NOT IN (
					SELECT MONTH(Birth_date)
					FROM Players
			   );
