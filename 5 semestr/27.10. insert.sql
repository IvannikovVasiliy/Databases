INSERT INTO ??????????
VALUES (2, '????????????????', 2);

INSERT INTO ????????? (id_?????????, ????????, ?????)
VALUES (4, '?????????? ????????', 70000);

INSERT INTO ????????????? (???????, ???, ????????, [???? ????????], id_??????????) (
	SELECT ???????, ???, ????????, [???? ????????], id_??????????
	FROM ????????
	WHERE ???? = 4
)


INSERT INTO ????????????? (id_?????????????, ???????, ???, ????????, [???? ????????], [e-mail], id_??????????, id_????????????)
VALUES (4, '???????', '?????', '?????????', '1999-01-01', 'iLoveStudentsOfPMM@gmail.com', NULL);

INSERT INTO ???????? (???????, id_??????????)
VALUES ('??????', (
					SELECT id_??????????
					FROM ??????????
					WHERE ???????? = '???'
				  ));