-- SARAVANANE Sylvain
-- LECHARLES Adam
-- L2 MIASHS TD2

DROP DATABASE IF EXISTS adan_airways ;
CREATE DATABASE adan_airways ;
USE adan_airways;

## CREATION D'UTILISATEURS ET DEFINITION DE CONTROLE D'ACCES

#DROP USER
CREATE USER AdminAirways IDENTIFIED BY 'adan';
GRANT ALL ON adan_airways.* TO AdminAirways;  ###(1)
-- cela permet de donner les droits sur les tables de la base adan_airways

CREATE USER Admin_for_visitors IDENTIFIED BY 'adan';
GRANT SELECT ON adan_airways to Admin_for_visitors;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- REQUETES D'INTERROGATION

-- 1) donner les noms et prénoms des employés :
SELECT nom, prenom
FROM employe
GROUP BY nom, prenom;

-- 2) Donner les noms et prénoms des employés, dont les noms commencent par A.
SELECT nom, prenom
FROM employe
WHERE nom LIKE 'A%';

-- 3) Donner les noms et prénoms des gerants
SELECT E.nom, E.prenom
FROM employe E, gerant G
WHERE E.numero = G.numero;

-- 4) Donner le nom et prénom du pilote de l'avion 1311
SELECT employe.nom, employe.prenom, avion.numero
FROM Avion, Gerant, Employe
WHERE avion.numero = '1311' AND avion.numero = gerant.numeroA AND specialite = 'Pilote' AND gerant.numero = employe.numero
GROUP BY employe.nom, employe.prenom;

-- 5)  Moyenne d'âge des passagers
SELECT AVG(age) as moyenne_d_age
FROM passager;

-- 6)	Quelles sont les numeros des avions et le numero des vols BOEINGS
SELECT A.numero as numero_vols, V.numero as numero_avions 
FROM avion A, vol V 
WHERE A.numero = V.numero and typee = 'boeing' 
GROUP BY A.numero,V.numero ;

-- 7) Combien y'a t-il de passagers sur cette journée
SELECT COUNT(numero)
FROM passager;


-- REQUETES DE MODIFICATION

-- Supprimer la passagère 'Chloé Barnes' 
DELETE FROM passager
WHERE nom = "Barnes" 
	  and prenom = 'Chloe';
      
-- DELETE FROM passager, reservation
-- WHERE numero = 2001 (avec sa clé primaire)

-- Mettre à jour l'âge de Hannah Thomas en y ajoutant 1 an
UPDATE passager
SET age = age + 1
WHERE nom = 'Thomas'
	and prenom = 'Hannah';
    
-- Mettre à jour l'âge des passager en y ajoutant 1 an
UPDATE passager
SET age = age + 1;

-- Supprimer les vols arrivant de Dallas

DELETE FROM vol
WHERE ville_depart = 'Dallas';

-- Supprimer tous les noms de passagers commencant par la lettre A.
DELETE FROM passager, reservation
WHERE nom like 'A%';

	-- Création de view    
    -- 1) Chiffre d'affaire de la compagnie sur une journée par avion ou la somme total
	Create view chiffre_affaire	AS
    SELECT sum(montant)
    FROM paiement
    GROUP BY montant;
    
    SELECT sum(montant)
    FROM paiement ;
    
    -- 2) Obtenir numero de vol et numero d'avion ayant pour lieu de décollage Dallas
    Create view depart_dallas AS
    SELECT numero, numeroA, ville_depart
    FROM Vol
    WHERE ville_depart = 'Dallas'
    GROUP BY numero, numeroA ;
    
    -- 3) Nom et Prénom des passagers ayant prit l'avion à 7h30
    drop view passager_7h30;
    Create view passager_7h30 AS
    SELECT heure_depart, passager.nom, passager.prenom, avion.numero
    FROM Vol, Passager, Avion
    WHERE heure_depart = '7:30' AND vol.numeroA = avion.numero AND avion.numero = passager.numeroA
    GROUP BY nom, prenom;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////   		    