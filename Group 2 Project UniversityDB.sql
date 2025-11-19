DROP DATABASE IF EXISTS UniversityDB;

CREATE DATABASE IF NOT EXISTS UniversityDB;

USE UniversityDB;

CREATE TABLE IF NOT EXISTS Majors (
  MajorID int NOT NULL,
  Major_Name varchar(30) NOT NULL,
  PRIMARY KEY (MajorID)
);

CREATE TABLE IF NOT EXISTS Students (
StudID int NOT NULL,
StudFirstName varchar(30) NOT NULL,
StudLastName varchar(30) NOT NULL,
StudStreetAddress varchar(50) NOT NULL, 
StudCity varchar(30) NOT NULL, 
StudState varchar(2) NOT NULL,
StudZipCode varchar(5) NOT NULL,
StudPhoneNumber varchar(10) NOT NULL,
StudBirthDate date NOT NULL,
StudGender varchar(12) NOT NULL,
StudMajor int NOT NULL,
PRIMARY KEY (StudID),
CONSTRAINT Students_FK00 FOREIGN KEY (StudMajor) REFERENCES Majors (MajorID)
); 
CREATE TABLE IF NOT EXISTS Employees (
  EmpID int NOT NULL,
  EmpFirstName varchar(30) NOT NULL,
  EmpLastName varchar(30) NOT NULL,
  EmpStreetAddress varchar(50) NOT NULL,
  EmpCity varchar(30) NOT NULL,
  EmpState varchar(2) NOT NULL,
  EmpZipCode varchar(5) NOT NULL,
  EmpPhoneNumber varchar(10) NOT NULL,
  Salary decimal(15,2) DEFAULT NULL,
  DateHired date DEFAULT NULL,
  Position varchar(50) DEFAULT NULL,
  PRIMARY KEY (EmpID)
);
CREATE TABLE IF NOT EXISTS Departments (
  DeptID int NOT NULL,
  DeptName varchar(100) NOT NULL,
  DeptChairPerson int DEFAULT '0',
  PRIMARY KEY (DeptID),
  CONSTRAINT Departments_FK00 FOREIGN KEY (DeptChairPerson) REFERENCES Employees (EmpID)
);



CREATE TABLE IF NOT EXISTS Classrooms (
  ClassRoomID int NOT NULL,
  BuildingCode varchar(3) DEFAULT NULL,
  Capacity smallint NOT NULL DEFAULT '0',
  PRIMARY KEY (ClassRoomID)
);



CREATE TABLE IF NOT EXISTS Transport_permits (
  PermitID int NOT NULL,
  Payment Decimal(10,2) NOT NULL,
  DriverFName varchar(30) NOT NULL,
  DriverLName varchar(30) NOT NULL,
  DriverStreetAddress varchar(50) NOT NULL,
  DriverCity varchar(30) NOT NULL,
  DriverState varchar(2) NOT NULL,
  DriverZipCode varchar(5) NOT NULL,
  DriverPhoneNumber varchar(10) NOT NULL,
  DLNumber int NOT NULL,
  ExpDate date NOT NULL,
  PRIMARY KEY (PermitID)
);

CREATE TABLE IF NOT EXISTS Transport_vehicles (
VehicleID int NOT NULL,
PermitID int NOT NULL,
VehicleModel varchar(20) NOT NULL,
VehicleColor varchar(15) NOT NULL,
VehicleLicensePlate varchar(12) NOT NULL,
PRIMARY KEY (VehicleID),
CONSTRAINT Vehicles_FK00 FOREIGN KEY (PermitID) REFERENCES Transport_permits (PermitID)
);



CREATE TABLE IF NOT EXISTS Residency (
StudID int NOT NULL,
SSN varchar(11) NOT NULL,
ResStatus varchar(30) NOT NULL,
VisaType varchar(6) DEFAULT NULL,
PRIMARY KEY (StudID),
CONSTRAINT Residency_FK00 FOREIGN KEY (StudID) REFERENCES Students (StudID)
);

CREATE TABLE IF NOT EXISTS `Teaching_Staff` (
  `EmpID` int NOT NULL,
  `Title` varchar(50) DEFAULT NULL,
  `Status` varchar(12) DEFAULT NULL,
  PRIMARY KEY (`EmpID`),
  CONSTRAINT `Teaching_Staff_FK00` FOREIGN KEY (`EmpID`) REFERENCES Employees (`EmpID`)
);

CREATE TABLE IF NOT EXISTS `Courses` (
  `CourseID` int NOT NULL DEFAULT '0',
  `CategoryID` varchar(10)  DEFAULT NULL,
  `CourseCode` varchar(8)  DEFAULT NULL,
  `CourseName` varchar(50)  DEFAULT NULL,
  `CoursePreReq` varchar(8)  DEFAULT NULL,
  `CourseDescription` text,
  `EstClassSize` smallint NOT NULL DEFAULT '0',
  PRIMARY KEY (`CourseID`),
  UNIQUE KEY `CourseCode` (`CourseCode`)
  
);

CREATE TABLE IF NOT EXISTS `Classes` (
  `ClassID` int NOT NULL,
  `CourseID` int DEFAULT '0',
  `ClassRoomID` int DEFAULT '0',
  `Credits` tinyint DEFAULT '0',
  `SemesterNumber` smallint DEFAULT NULL,
  `StartDate` date DEFAULT NULL,
  `StartTime` time DEFAULT NULL,
  `Duration` smallint DEFAULT '0',
  `MondaySchedule` bit(1) NOT NULL DEFAULT b'0',
  `TuesdaySchedule` bit(1) NOT NULL DEFAULT b'0',
  `WednesdaySchedule` bit(1) NOT NULL DEFAULT b'0',
  `ThursdaySchedule` bit(1) NOT NULL DEFAULT b'0',
  `FridaySchedule` bit(1) NOT NULL DEFAULT b'0',
  `SaturdaySchedule` bit(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY (`ClassID`),
  KEY `CourseID` (`CourseID`),
  KEY `ClassRoomID` (`ClassRoomID`),
  CONSTRAINT `Classes_FK00` FOREIGN KEY (`ClassRoomID`) REFERENCES `Classrooms` (`ClassRoomID`),
  CONSTRAINT `Classes_FK01` FOREIGN KEY (`CourseID`) REFERENCES `Courses` (`CourseID`)
);

CREATE TABLE IF NOT EXISTS `Faculty_Classes` (
  `ClassID` int NOT NULL,
  `EmpID` int NOT NULL,
  PRIMARY KEY (`ClassID`,`EmpID`),
  KEY `ClassesFacultyClasses` (`ClassID`),
  KEY `EmpFacultyClasses` (`EmpID`),
  CONSTRAINT `Faculty_Classes_FK00` FOREIGN KEY (`ClassID`) REFERENCES `Classes` (`ClassID`),
  CONSTRAINT `Faculty_Classes_FK01` FOREIGN KEY (`EmpID`) REFERENCES `Employees` (`EmpID`),
  CONSTRAINT `Faculty_CLasses_FK02` FOREIGN KEY (`EmpID`) REFERENCES `Teaching_Staff` (`EmpID`)
);

CREATE TABLE IF NOT EXISTS `Class_Registration_Status` (
  `ClassStatus` int NOT NULL DEFAULT '0',
  `ClassStatusDescription` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ClassStatus`)
);

CREATE TABLE IF NOT EXISTS `Class_Registration` (
  `StudentID` int NOT NULL,
  `ClassID` int NOT NULL,
  `ClassStatus` int DEFAULT '0',
  `Grade` double DEFAULT '0',
  PRIMARY KEY (`StudentID`,`ClassID`),
  CONSTRAINT `Student_Schedules_FK00` FOREIGN KEY (`ClassID`) REFERENCES `Classes` (`ClassID`),
  CONSTRAINT `Student_Schedules_FK01` FOREIGN KEY (`ClassStatus`) REFERENCES `class_registration_status` (`ClassStatus`),
  CONSTRAINT `Student_Schedules_FK02` FOREIGN KEY (`StudentID`) REFERENCES `Students` (`StudID`)
);

CREATE TABLE IF NOT EXISTS `Bursar_Tuition` (
   BursarId int NOT NULL,
  `StudentID` int NOT NULL,
  `Tuition_Estimate` double DEFAULT '0',
  `Tuition_Plan` varchar(50)  DEFAULT NULL,
  `Tuition_Insurance` double DEFAULT '0',
  PRIMARY KEY (BursarId),
  CONSTRAINT `Bursar_Tuition_FK00` FOREIGN KEY (`StudentID`) REFERENCES `Students` (`StudID`)
);

CREATE TABLE IF NOT EXISTS `Bursar_Tuition_Fee_Payment` (
   BursarId int NOT NULL,
  `Payment_status` bit(1) NOT NULL DEFAULT b'0',
  `Payment_options` varchar(50)  DEFAULT NULL,
  `Refund` double DEFAULT '0',
  CONSTRAINT `Bursar_Tuition_Fee_Payment_FK00` FOREIGN KEY (`BursarId`) REFERENCES `Bursar_Tuition` (`BursarId`)
);

CREATE TABLE IF NOT EXISTS Student_Organizations (
OrgId int NOT NULL,
Organization_Name varchar(100) DEFAULT NULL,
Org_Strength int NOT nULL,
Faculty_Advisor int NOT NULL,
Student_Leader int NOT NULL,
PRIMARY KEY (OrgId),
CONSTRAINT `Student_Organizations_FK00` FOREIGN KEY (`Faculty_Advisor`) REFERENCES `Employees` (`EmpID`),
CONSTRAINT `Student_Organizations_FK01` FOREIGN KEY (`Student_Leader`) REFERENCES `Students` (`StudID`)
);

CREATE TABLE IF NOT EXISTS CAMPUS_DINING (
Dining_Service_ID int NOT NULL,
Dining_Service_Name varchar(100) DEFAULT NULL,
Dining_Location varchar(100) DEFAULT NULL,
Meal_Plan varchar(50) DEFAULT NULL,
Service_Phone varchar(200) DEFAULT NULL,
Service_Head int not NULL,
Number_of_Employees int NOT NULL,
Average_Salary_per_hour int NOT NULL,
PRIMARY KEY (Dining_Service_ID),
CONSTRAINT `CAMPUS_DINING_FK00` FOREIGN KEY (`Service_Head`) REFERENCES `Employees` (`EmpID`)
);


#Inserting Values

USE UniversityDB; 

#Majors
INSERT INTO Majors VALUES
(1,'Aeronautics'),
(2,'Accounting'),
(3,'Advertising'),
(4,'Business Administration'),
(5,'Economics'),
(6,'Entrepreneurship'),
(7,'Finance'),
(8,'Management Information Systems'),
(9,'Marketing'),
(10,'Real Estate'),
(11,'Supply Chain Management'),
(12,'Audiology'),
(13,'Cognitive Science'),
(14,'Nursing'),
(15,'Public Health'),
(16,'Creative Writing'),
(17,'Gender Studies'),
(18,'Humanities'),
(19,'Journalism'),
(20,'Liberal Arts'),
(21,'Philosophy'),
(22,'Geography'),
(23,'International Studies'),
(24,'Political Science'),
(25,'Sociology'),
(26,'Anthropology'),
(27,'Criminology'),
(28,'Psychology'),
(29,'Architecture'),
(30,'Astrophysics'),
(31,'Biochemistry'),
(32,'Biology'),
(33,'Chemistry'),
(34,'Computer Science'),
(35,'Conservation'),
(36,'Earth Science'),
(37,'Engineering'),
(38,'Mathematics'),
(39,'Microbiology'),
(40,'Neuroscience'),
(41,'Physics'),
(42,'Statistics'),
(43,'Zoology');


#Students
INSERT INTO Students VALUES
(13544, 'Jon','Goodwin','237 Woodsman Avenue','Cedar Rapids ','IA',52402,8863037426,'1998-01-20','Male',18),
(39318,' Tristian','Wood','84 North Laurel St.','Newport News','VA',23601,7235119198,'2001-10-21','Male',17),
(24821,' Kalel','Ahmad','7887 Brown Street','Derry','NH',23038,5735968417,'2003-04-17','Male',23),
(92063,' Lauren','Hensley','170 San Carlos Avenue','Frederick','MD',21701,5212288205,'1998-06-19','Female',25),
(86931,' Hunter','Bryant','373 Sycamore Street','West Babylon','NY',11704,8814298267,'1991-03-06','Male',5),
(23721,' Alexandria','Wurz','7697 Monroe Dr.','Hialeah','FL',33010,3136354812,'1993-09-04','Female',27),
(32445,' Dallas','Nwaekwe','7469 S. Aspen Ave.','Tullahoma','TN',37388,8314366323,'1999-03-03','Female',41),
(28086,' Miles','King','22 Birchwood Street','Waterbury','CT',76705,8115490201,'1998-12-24','Male',19),
(30453,' Winnie','Baugh','239 Bowman Street','Merrick','NY',11566,9843012720,'1999-07-20','Female',35),
(12981,' Charli','Baqatyan','14 Rocky River Lane','Fond Du Lac','WI',54935,8918813645,'2002-03-28','Female',29),
(54933,' Zaniyah','Verma','2 Country Ave.','Burbank','IL',60459,4391684464,'1995-12-01','Female',17),
(82930,' Melany','Harry','948 East Roosevelt Lane','Taylors','SC',29687,5993061278,'1999-04-27','Female',2),
(79433,' Talon','Govindappa','367C Carriage Drive','De Pere','WI',54115,1859529285,'1996-03-27','Male',37),
(53328,' Melvin','McMillan','256 Mayfair Lane','Stevens Point','WI',54481,3205600693,'1998-03-09','Male',31),
(14342,'Aditi','Danalian','6 Marvon St.','Midland','MI',48640,9401509597,'1997-05-27','Female',41),
(73429,' Maisie','Moran','9208 Court Street','Albany','NY',12203,3879656952,'1995-11-02','Female',6),
(51020,' Helena','Schuhmacher','8847 Hudson St.','Westfield','MA',71085,6826549397,'1997-11-01','Female',4),
(94768,' Manuel','Shepherd','9172 Pawnee St.','Ormond Beach','FL',32174,4255323622,'1995-02-21','Male',8),
(18339,' Emory','Singh','323 Wild Horse Dr.','Calumet City','IL',60409,8848069689,'1998-06-11','Female',5),
(91858,' Kinley','Mathew','406 SW. School St.','Centreville','VA',20120,7381706046,'1991-09-24','Female',13),
(48063,' Alma','Waldrop','249 Cobblestone Drive','Toms River','NJ',88753,6443885071,'1995-04-29','Female',43),
(16462,' Reign','Aird','8860 Briarwood St.','Des Plaines','IL',60016,3205837953,'1995-12-24','Female',38),
(52511,' Justice','Mandaogane','73 Sleepy Hollow Ave.','East Meadow','NY',11554,3713891614,'1995-07-26','Female',7),
(70751,' Paris','Tao','224 Howard Drive','Portland','ME',64103,5642563091,'1997-05-22','Female',18),
(62589,' Lyric','Robinson','36 N. Leeton Ridge Rd.','New Brunswick','NJ',78901,7923388658,'1998-01-17','Female',18),
(55175,' Brandon','Morris','8334 Division Lane','Nutley','NJ',57110,8906219982,'1991-06-07','Male',36),
(52118,' Estella','Zhu','8908 6th Ave.','Johnston','RI',62919,4363524775,'1991-09-09','Female',4),
(51363,'Shruti','Swaim','811 Pineknoll Court','Akron','OH',44312,6551850401,'1999-08-08','Female',8),
(42570,' Ayan','Yang','8006 Pin Oak Lane','Deerfield','IL',60015,6154912733,'2000-09-22','Male',40),
(59788,' Maren','Darrow','7650 E. Alton Drive','Oviedo','FL',32765,4678179255,'1993-01-31','Male',39),
(19402,' Daniela','Braughton','5 Fordham St.','Peoria','IL',61604,4134357752,'2000-09-07','Female',32),
(51318,' Logan','Redfield','12 Church Court','Alabaster','AL',35007,5185633784,'1990-12-08','Male',37),
(72603,' Gatlin','Taylor','16 E. Wentworth Drive','Lithonia','GA',30038,9668830761,'2001-08-11','Female',21),
(73977,' Addilyn','Garcia','365 Ocean Drive','Springfield','PA',19064,1035241460,'2002-01-21','Female',6),
(27252,' Mustafa','Robles','298 NW. Wild Horse Street','Elkton','MD',21921,8710566718,'2003-12-28','Male',30),
(75593,' Graham','Lloyd','49 Spruce St.','Windsor Mill','MD',21244,6789318950,'1990-11-16','Male',1),
(31461,' Sasha','Michael','100 Snake Hill Street','Batavia','OH',45103,3894004692,'1990-03-29','Female',4),
(54846,' Angie','Sandlin','7702 Foster St.','Melbourne','FL',32904,6744503011,'2002-08-18','Female',10),
(48265,' Sekani','Alvarez','8123 Greystone Circle','Brentwood','NY',11717,2520521101,'1999-09-18','Male',1),
(53839,' Emory','Browne','4 San Pablo Street','Lake Charles','LA',70605,9302018427,'1999-08-20','Female',33),
(57675,' Rylie','Fernandez','50 S. Myers Lane','Charleston','SC',29406,7534197961,'1993-01-11','Female',24),
(68982,' Meadow','Fields','7615 Manchester Lane','Helotes','TX',78023,7338978847,'1994-05-27','Female',13),
(96862,' Brandon','Jain','600 Ketch Harbour Rd.','Lansdowne','PA',19050,8776560428,'1999-03-31','Male',25),
(88399,' Casen','Jon-Ubabuco','8382 Vermont Street','Dallas','TX',75019,2329783305,'1993-04-17','Male',22),
(93230,' Creed','Mackey','7744 Sussex Road','Rockville','CT',46066,7348373632,'1998-09-08','Male',26),
(80135,' Andrew','Shurtleff','8252 Center Street','Coachella','CA',92236,8439312437,'2001-09-07','Male',1),
(63924,' Demetrius','Johnson','7757 West Johnson St.','Abingdon','MD',21009,1209613742,'2003-10-09','Male',10),
(20075,' Phoenix','Bumber','910 Ridgeview St.','Alpharetta','GA',30004,6271403746,'1999-07-13','Female',22),
(42597,' Harlem','Cole','83 Woodland Street','Holly Springs','NC',27540,1670471314,'2002-08-25','Male',42),
(23218,' Jayson','Antone','8281 William St.','Kansas City','MO',64151,7986288570,'1992-07-29','Male',11),
(37784,'Li','Xu','441 Sutor Lane','Glen Ellyn','IL',60137,8194499952,'1995-12-06','Male',24),
(26240,'Sahana','Lima','78 Cross Lane','Shepherdsville','KY',40165,9539474703,'1996-09-30','Female',34),
(29067,' Larry','Nolen','87 South Locust St.','North Canton','OH',44720,4171206255,'1998-06-19','Male',15),
(63271,' Estella','Krider','7559 Longbranch Avenue','Auburndale','FL',33823,1336261067,'1998-12-19','Female',9),
(23746,' Rex','Catral','8176 Vernon Lane','Logansport','IN',46947,9436697762,'1999-10-15','Male',8),
(67316,' Kaysen','Soppin','8881 Gregory Circle','Mount Juliet','TN',37122,9356657766,'2002-06-21','Male',28),
(20129,' Ryker','Chen','60 Sheffield Rd.','Franklin Square','NY',11010,1129062660,'2000-04-11','Male',42),
(82067,' Cannon','Hollister','106 North Bridle Drive','Long Beach','NY',11561,1765314982,'1991-12-27','Male',3),
(93125,' Clay','Koroma','75 Taylor Rd.','Pelham','AL',35124,1036443978,'1990-05-15','Male',43),
(68786,' Pablo','Kaskas','33 NW. Shipley Drive','Saint Cloud','MN',56301,4777516112,'1993-02-17','Male',2),
(87846,' Clarissa','Omana','722 E. Proctor St.','Point Beach','NJ',38742,6535293384,'2002-04-23','Female',14),
(72900,'Rajesh','White','7806 Woodland St.','Waterloo','IA',50701,5220054440,'1997-02-21','Male',27),
(94522,' Jesse','Bradley','5 Brook St.','Tucson','AZ',85718,9529849492,'1993-01-17','Female',40),
(70635,' Brantley','McCartt','23 Lancaster St.','Lancaster','NY',14086,8542963174,'1991-03-09','Male',23),
(89017,' Cassandra','Glover','7904 Manor Court','Redondo Beach','CA',90278,5101604542,'1999-03-10','Female',33),
(27478,' Bodie','Vu','8492 Riverview Ave.','Sun Prairie','WI',53590,8662331606,'1999-06-06','Female',31),
(71037,' Makenzie','Song','34 Philmont Dr.','Mason City','IA',50401,3208135756,'1993-02-03','Female',39),
(50534,' Ezra','User','43 W. County Court','Phoenixville','PA',19460,7726584764,'1997-04-13','Male',43),
(60568,' Boston','Kimbrell','7088 Catherine St.','Hanover Park','IL',60133,2602400027,'1992-02-08','Male',21),
(18284,' Atlas','Melton','916 Ridge Ave.','Sugar Land','TX',77478,7397395631,'1994-10-27','Male',12),
(67767,' Ibrahim','Okulate','1 Howard Rd.','Perth Amboy','NJ',28861,4744357172,'1996-11-03','Male',17),
(67774,' Sebastian','Kaiser','490 Forest Street','Somerset','NJ',28873,1680971065,'1996-06-19','Male',39),
(66510,' Zaiden','White','99 James Street','Alliance','OH',44601,5886248512,'1996-10-26','Male',17),
(76426,' Brecken','Mcbride','70 Maple Ave.','Ladson','SC',29456,1191159849,'2003-09-24','Male',3),
(13119,'Ahmed','Yao','53 Dogwood Ave.','Mansfield','MA',62048,5883285836,'1999-05-12','Male',21),
(95039,' Felix','Corley','704 Fulton Street','Suwanee','GA',30024,6543470066,'2003-02-20','Male',33),
(51684,' Cadence','Mahapatra','559C Rosewood Road','Hummelstown','PA',17036,3668842082,'2003-09-14','Male',36),
(19569,' Ayleen','Whitaker','602 Redwood St.','Warren','MI',48089,9190001525,'1994-08-10','Female',4),
(83161,' Oscar','Buquet','7234 Linda Road','Horn Lake','MS',38637,5269566597,'2002-11-28','Male',32),
(44439,' John','Aziz','9343B NW. Pierce Circle','Hobart','IN',46342,8516232096,'1997-12-26','Male',42),
(50010,' Leland','Baer','8920 Manor Station Drive','Monsey','NY',10952,9108285887,'1995-02-01','Male',4),
(91462,' Lian','Price','7516 Smith Store St.','Hope Mills','NC',28348,4934128038,'1990-03-17','Male',31),
(45676,'Dilip','Tsai','60 Manhattan Dr.','Norwalk','CT',76851,9984714780,'1992-10-03','Male',11),
(34711,' Jaylin','Shah','900 Williams Lane','New Philadelphia','OH',44663,4173988967,'1998-10-18','Female',38),
(96905,' Oaklee','Jurecki','456 Washington Street','Wayne','NJ',27470,3043155411,'1995-12-12','Female',14),
(59111,' Xander','Marchese','7227 Augusta Lane','Prussia','PA',19406,7836130770,'1993-01-25','Male',32),
(61192,' Henrik','Naik','911 Lafayette Street','East Orange','NJ',27017,1062300128,'1992-02-06','Male',19),
(14323,' Mohamed','Krueger','7 East Oakwood St.','Northville','MI',48167,1443424036,'1997-01-31','Male',10),
(60056,' Jakob','Chism','668 Bridgeton Ave.','Oak Lawn','IL',60453,6421250218,'1999-02-09','Male',27),
(53984,' Justin','Rusek','8200 Lake View Court','Sanford','NC',27330,9859944912,'1995-06-04','Male',36),
(42389,' Kamryn','Jain','8843 Lawrence St.','Dalton','GA',30721,1758802595,'1998-07-31','Female',23),
(98274,' Serena','Torres','191 Middle River Lane','Cranford','NJ',27016,2129220787,'2001-02-01','Female',35),
(69229,' Yaretzi','Cangelosi','74 Cherry Hill Lane','Ridgewood','NJ',27450,8133988178,'1995-05-22','Female',28),
(24025,' Ariel','Sturm','2 Marvon Drive','Augusta','GA',30906,7426289049,'1996-05-06','Female',38),
(15597,' Edison','Canessa','399 Brewery Rd.','Redford','MI',48239,4561234624,'1998-04-10','Male',33),
(83158,'Raj','Chandra','3 Canal Dr.','Ontario','CA',91762,4447468476,'1991-01-27','Male',42),
(22318,'Tony','Gibbs','9 Rosewood St.','Atlanta','GA',30303,2661313435,'1990-03-12','Male',25),
(65327,'Sheldon','McGee','8353 Wrangler Avenue','Brandon','FL',33510,6552133974,'1993-08-02','Male',38),
(93073,'Ziva','Hofler','65 Nicolls Lane','Waldorf','MD',20601,3136452863,'2001-10-09','Female',28),
(34611,'Leonard','Shaw','904 North East St.','Dyersburg','TN',38024,9598177753,'1990-10-23','Male',9),
(34570,'Penny','Welmaker','8062 Wrangler Ave.','Marquette','MI',49855,3902211264,'1990-04-25','Female',42);


# Employees

INSERT INTO Employees VALUES
(196557,'Joshua','Lonaker','15127 NE 24th, #383','Redmond','WA','98052','6825552686',44000,'1986-05-31','Faculty'),
(449901,'Dakota','Blanco','Route 2, Box 203B','Auburn','WA','98002','6825552676',53000,'1985-01-21','Faculty'),
(206427,'Natasha','Yarusso','30301 - 166th Ave. N.E.','Fremont','CA','94538','6825552596',52000,'1983-10-06','Faculty'),
(688905,'Brooke','Cazares','16 Maple Lane','Auburn','WA','98002','6825552591',45000,'1983-10-16','Faculty'),
(634582,'Rochelle','Johnson','672 Lamont Ave','Houston','TX','77201','6825552491',49000,'1989-02-09','Faculty'),
(138624,'Joey','Abreu','908 W. Capital Way','Tacoma','WA','98413','6825552496',44000,'1986-07-05','Faculty'),
(932068,'Preston','Suarez','722 Moss Bay Blvd.','Kirkland','WA','98033','6825552501',60000,'1986-07-16','Faculty'),
(572796,'Lee','Dong','901 Pine Avenue','Portland','OR','97208','6825552526',45000,'1989-11-02','Faculty'),
(134670,'Maaiz','al-Dia','13920 S.E. 40th Street','Bellevue','WA','98009','6825552531',45000,'1985-08-02','Faculty'),
(393717,'Maja','Nicholson','30301 - 166th Ave. N.E.','Seattle','WA','98106','9725552536',40000,'1988-12-17','Registrar'),
(175125,'Sasha','Jansen','722 Moss Bay Blvd.','Kirkland','WA','98033','9725552576',50000,'1984-04-12','Faculty'),
(232618,'Alexander','Sherman','Route 2, Box 203B','Woodinville','WA','98072','9725552631',57000,'1984-01-17','Faculty'),
(760609,'Edgar','Sanchez','13920 S.E. 40th Street','Bellevue','WA','98006','9725552556',48000,'1988-05-31','Faculty'),
(508242,'Kolbi','Strunk','611 Alpine Drive','Palm Springs','CA','92263','9725552611',60000,'1982-11-20','Faculty'),
(240338,'Brittany','Sath','101 NE 88th','Salem','OR','97301','9725552636',50000,'1987-01-13','Faculty'),
(826824,'Meggan','Smith','311 20th Ave. N.E.','Fremont','CA','94538','9725552646',52000,'1991-12-17','Faculty'),
(544227,'Ericka','Arreola','16 Maple Lane','Seattle','WA','98115','9725552651',25000,'1984-11-14','Secretary'),
(817422,'David','Pulc','PO Box 223311','Tacoma','WA','98413','9725552711',60000,'1990-08-20','Faculty'),
(917848,'Kyle','Luckey','2424 Thames Drive','Bellevue','WA','98006','9725552726',60000,'1986-03-02','Faculty'),
(635586,'Rojesh','Her','777 Fenexet Blvd','Redmond','WA','98052','9725550399',45000,'1985-03-08','Faculty'),
(423398,'David','Weber','4501 Wetland Road','Long Beach','CA','90809','9725550037',45000,'1992-02-10','Faculty'),
(846275,'Rachel','Jambor','3887 Easy Street','Seattle','WA','98125','9725550039',60000,'1988-12-11','Faculty'),
(509287,'Musab','al-Moustafa','7288 Barrister Ave N','Tacoma','WA','98413','9725552281',35000,'1988-11-25','Graduate Advisor'),
(168857,'Sila','Nguyen','3445 Cheyenne Road','El Paso','TX','79993','9725552291',48000,'1986-09-17','Faculty'),
(125595,'Samantha','Hicks','298 Forest Lane','Seattle','WA','98125','9725552306',52000,'1983-01-28','Faculty'),
(423522,'Angela','Harding','455 West Palm Ave','San Antonio','TX','78284','9725552311',45000,'1988-03-02','Faculty'),
(937233,'Brandon','Barbour','877 145th Ave SE','Portland','OR','97208','9725552316',56000,'1989-08-20','Faculty'),
(710285,'Reilly','Wagar','4726 - 11th Ave. N.E.','Seattle','WA','98105','9725552671',45000,'1997-05-15','Graduate Advisor'),
(951593,'Victoria','Ibarra','908 W. Capital Way','Tacoma','WA','98413','9725552496',45000,'1998-02-05','Graduate Advisor'),
(740065,'Dakota','Wirth','722 Moss Bay Blvd.','Kirkland','WA','98033','9725552501',40000,'1997-11-19','Graduate Advisor'),
(306793,'Lauren','Klocker','4110 Old Redmond Rd.','Redmond','WA','98052','9725552506',50000,'1998-03-05','Graduate Advisor'),
(364794,'Michael','Benson','Route 2, Box 203B','Auburn','WA','98002','9725552521',57000,'1998-02-02','Graduate Advisor'),
(877470,'Sean','Rozga','908 W. Capital Way','Tacoma','WA','98413','9725552581',48000,'1998-02-16','Graduate Advisor'),
(486705,'Cody','Vermeylen','13920 S.E. 40th Street','Bellevue','WA','98006','9725552556',60000,'1997-09-03','Graduate Advisor'),
(511664,'Kinaana','al-Jamail','2601 Seaview Lane','Kirkland','WA','98033','9725552616',50000,'2000-02-05','Graduate Advisor'),
(860113,'Daniel','Garcia','2222 Springer Road','Bellevue','WA','98006','9725552626',52000,'1990-08-20','Graduate Advisor'),
(271785,'Katrina','Saito','12330 Kingman Drive','Kirkland','WA','98033','9725552721',25000,'1986-03-02','Faculty'),
(357968,'Joshua','Galloway','2424 Thames Drive','Bellevue','WA','98006','9725552726',60000,'1985-03-08','Faculty'),
(469799,'Aylin','Mendoza','777 Fenexet Blvd','Redmond','WA','98052','9725550399',60000,'1992-02-10','Faculty'),
(508314,'Sharon','Fyfe','2500 Rosales Lane','Bellevue','WA','98006','9725559938',45000,'1988-12-11','Faculty'),
(940853,'Afnaan','el-Mohammed','323 Advocate Lane','Bellevue','WA','98006','9725552286',45000,'1988-11-25','Faculty'),
(736890,'Jesse','Williams','754 Fourth Ave','Seattle','WA','98115','9725552296',60000,'1986-09-17','Faculty'),
(271820,'Kenny','Fukushima','122 Spring River Drive','Redmond','WA','98053','9725552681',35000,'1983-01-28','Faculty'),
(861380,'Tawnie','Glaisher','66 Spring Valley Drive','Seattle','WA','98125','9725552666',27000,'1988-03-02','Faculty'),
(782822,'Britany','Stevens','667 Red River Road','Bellevue','WA','98006','4695552571',30000,'1989-08-20','Faculty'),
(369893,'Alan','Trinh','30301 - 166th Ave. N.E.','Seattle','WA','98125','4695552551',22000,'1997-05-15','Faculty'),
(430546,'Zoe','Kern','908 W. Capital Way','Tacoma','WA','98413','4695552606',24500,'1988-11-25','Faculty'),
(472467,'Sidney','Beavers','4501 Wetland Road','Redmond','WA','98052','4695550037',22100,'1986-09-17','Faculty'),
(904131,'Miriam','Aguilar','3445 Cheyenne Road','Bellevue','WA','98006','4695552291',30000,'1986-09-18','Faculty'),
(201506,'Issac','Mata','1234 Main Street','Kirkland','WA','98033','4695551234',50000,'1986-09-19','Faculty'),
(572132,'Hannah','Uren','122 Spring River Drive','Duvall','WA','98019','4695552681',60000,'1991-10-01','Faculty'),
(538421,'Zachary','Bradley','Route 2, Box 203B','Auburn','WA','98002','4695552676',35000,'1995-11-02','Faculty'),
(353908,'Moira','Buttitto','672 Lamont Ave','Houston','TX','77201','4695552491',48000,'1989-03-13','Faculty'),
(372096,'Nicole','Humpal','4110 Old Redmond Rd.','Redmond','WA','98052','4695552506',52000,'1994-07-04','Faculty'),
(473584,'Georgia','Williams','15127 NE 24th, #383','Redmond','WA','98052','4695552511',45000,'1992-08-12','Dean'),
(754974,'Connor','Ferry','901 Pine Avenue','Portland','OR','97208','4695552526',56000,'1995-07-11','Faculty'),
(242634,'Amanda','Tatum','233 West Valley Hwy','San Diego','CA','92199','4695552541',45000,'1996-08-29','Faculty'),
(624640,'Cameron','Steinberg','507 - 20th Ave. E. Apt. 2A','Seattle','WA','98105','4695552601',45000,'1989-08-15','Faculty'),
(987884,'Shuraih','el-Karim','667 Red River Road','Austin','TX','78710','4695552571',40000,'1993-12-05','Faculty'),
(516465,'Katelyn','Sharp','Route 2, Box 203B','Woodinville','WA','98072','4695552631',50000,'1996-03-08','Faculty'),
(246736,'Colin','Lemont','13920 S.E. 40th Street','Bellevue','WA','98006','4695552556',57000,'1991-04-18','Faculty'),
(454493,'Donald','Nevins','2114 Longview Lane','San Diego','CA','92199','4695552546',48000,'1994-01-11','Faculty'),
(500587,'Macaela','Kadillak','611 Alpine Drive','Palm Springs','CA','92263','4695552611',60000,'1995-09-22','Faculty'),
(325868,'Brittany','Pratt','2601 Seaview Lane','Chico','CA','95926','4695552616',50000,'1988-10-25','Faculty'),
(616644,'Cameron','Hancock','101 NE 88th','Salem','OR','97301','4695552636',52000,'1992-05-01','Faculty'),
(639998,'William','Grevious','66 Spring Valley Drive','Medford','OR','97501','4695552641',25000,'1994-03-03','Faculty'),
(410413,'Lindsey','Job','311 20th Ave. N.E.','Fremont','CA','94538','4695552646',60000,'1994-03-13','Faculty'),
(114595,'Gabrielle','Smith','12330 Kingman Drive','Glendale','CA','91209','4695552721',45000,'1995-04-24','Faculty'),
(476789,'Allison','Brink-Lomme','2424 Thames Drive','Bellevue','WA','98006','4695552726',49000,'1998-02-02','Faculty'),
(438123,'Sheyenne','Delgado-Manzanares','2500 Rosales Lane','Dallas','TX','75260','4695559938',44000,'1998-02-16','Faculty'),
(183626,'Joseph','Smith','4501 Wetland Road','Long Beach','CA','90809','4695550037',60000,'1997-09-03','Graduate Advisor'),
(934207,'Fikra','al-Mina','2343 Harmony Lane','Seattle','WA','99837','4695559936',45000,'2000-02-05','Graduate Advisor'),
(582877,'Aurelia','Davis Ingham','323 Advocate Lane','El Paso','TX','79915','4695552286',45000,'1990-08-20','Graduate Advisor'),
(815641,'Taylor','Elstun','3445 Cheyenne Road','El Paso','TX','79915','4695552291',40000,'1986-03-02','Graduate Advisor'),
(200937,'Joseph','Snider','455 West Palm Ave','San Antonio','TX','78284','4695552311',50000,'1985-03-08','Graduate Advisor'),
(703247,'Sourinthone','Tran','877 145th Ave SE','Portland','OR','97208','4695552316',57000,'1992-02-10','Graduate Advisor'),
(184260,'Ibrahim','al-Sawaya','19541 104th Ave NE','Bothell','WA','98006','4695559999',48000,'1988-12-11','Faculty'),
(843331,'Alexandra','Levy','16 Maple Lane','Auburn','WA','98002','4695552591',60000,'1988-11-25','Faculty'),
(886140,'Macie','Nguyen','122 Spring River Drive','Duvall','WA','98019','4695552516',50000,'1986-09-17','Faculty'),
(760362,'Sean','Tegtman','908 W. Capital Way','Tacoma','WA','98413','4695552581',52000,'1983-01-28','Faculty'),
(766698,'Casey','Vanden Bos','722 Moss Bay Blvd.','Kirkland','WA','98033','4695552576',25000,'1988-03-02','Faculty'),
(633596,'Staci','Maes','455 West Palm Ave','San Antonio','TX','78284','4695552311',60000,'1989-08-20','Faculty'),
(133163,'Luke','Davey','16679 NE 42nd Court','Redmond','WA','98052','4695552661',60000,'1997-05-15','Faculty'),
(410918,'Harper','Wheeler-Marques','554 E. Wilshire Apt. 2A','Seattle','WA','98105','4695552697',44000,'1988-11-25','Faculty'),
(418420,'Sherleen','Saravanan','9877 Hacienda Drive','San Antonio','WA','98006','4695552301',60000,'1986-09-17','Faculty'),
(996025,'Myles','Vaught','908 W. Capital Way','Tacoma','TX','78284','4695552706',45000,'1986-09-18','Faculty'),
(784101,'Juan','Guerrero Camacho','611 Alpine Drive','Palm Springs','WA','98413','4695552701',45000,'1986-09-19','Faculty'),
(480856,'Lindsey','Freund','4110 Old Redmond Rd.','Redmond','CA','92263','4695552696',40000,'1991-10-01','Faculty'),
(507184,'Savannah','Clark','4726 - 11th Ave. N.E.','Seattle','WA','98052','4175552691',50000,'1983-01-28','Faculty'),
(803872,'Bradley','Monsell','66 Spring Valley Drive','Medford','WA','98105','4175552671',57000,'1988-03-02','Faculty'),
(795236,'Daisha','Schmidt','Route 2, Box 203B','Auburn','OR','97501','4175552666',48000,'1989-08-20','Faculty'),
(632540,'Airabella','Koontz','16679 NE 41st Court','Portland','WA','98002','4175552521',60000,'1997-05-15','Faculty'),
(672641,'Hailey','Malle','30301 - 166th Ave. N.E.','Eugene','OR','97208','4175552566',50000,'1997-05-16','Faculty'),
(280941,'Devon','Miranda','908 W. Capital Way','Tacoma','OR','97401','4175552551',52000,'1997-05-17','Faculty'),
(573089,'Danielle','Nguyen','16679 NE 41st Court','Portland','WA','98413','4175552606',60000,'1997-05-18','Faculty'),
(476100,'Mateo','Cisneros','2222 Springer Road','Lubbock','OR','97208','4175552621',60000,'1997-05-19','Faculty'),
(169365,'William','Pablo','15127 NE 24th, #383','Redmond','TX','79402','4175552626',45000,'1997-05-20','Faculty'),
(333324,'Jason','Hundsdorfer','12330 Larchlemont Lane','Seattle','WA','98052','4175552656',45000,'1997-05-21','Faculty'),
(573623,'Antonio','Desai','777 Fenexet Blvd','Long Beach','WA','98105','4175552716',60000,'1997-05-22','Faculty');

#Departments

	
INSERT INTO Departments values
(4670,'Aerospace Engineering',449901),
(5528,'Biosciences and Bioengineering',206427),
(3115,'Chemical Engineering',688905),
(5881,'Chemistry',634582),
(4938,'Civil Engineering',508314),
(1423,'Computer Science & Engineering',940853),
(4132,'Earth Sciences',736890),
(2054,'Electrical Engineering',271820),
(2357,'Energy Science and Engineering',754974),
(1537,'Humanities & Social Science',242634),
(8379,'Mathematics',624640),
(1825,'Mechanical Engineering',987884),
(8313,'Metallurgical Engineering & Materials Science',516465),
(2425,'Physics',246736),
(1378,'Industrial Design Centre',454493),
(5127,'Application Software Centre (ASC)',500587),
(5408,'Centre for Research in Nanotechnology and Science (CRNTS)',410918),
(1142,'Centre for Aerospace Systems Design and Engineering (CASDE)',418420),
(1367,'Computer Centre (CC)',996025),
(7783,'Centre for Distance Engineering Education Programme (CDEEP)',784101),
(3062,'Centre for Environmental Science and Engineering (CESE)',480856),
(1388,'Centre for Policy Studies (CPS)',507184),
(7005,'Centre of Studies in Resources Engineering (CSRE)',803872),
(1533,'Centre for Technology Alternatives for Rural Areas (CTARA)',795236),
(3778,'Centre for Formal Design and Verification of Software (CFDVS)',632540),
(4055,'Centre for Urban Science and Engineering (C-USE)',114595),
(2601,'Centre for Entrepreneurship (DSCE)',476789),
(1677,'ABC-EDS Research Academy',438123),
(7626,'National Centre for Aerospace Innovation and Research (NCAIR)',183626),
(5109,'National Center of Excellence in Technology for Internal Security (NCETIS)',934207),
(1615,'National Centre for Mathematics (NCM)',572132),
(3868,'Center for Learning and Teaching (PPCCLT)',538421),
(6347,'Sophisticated Analytical Instrument Facility (SAIF)',353908),
(8598,'Technology and Design (TCTD)',372096),
(8473,'Centre for Bioengineering (WRCB)',473584),
(1096,'School of Management',333324),
(4308,'Climate Studies',573623),
(1836,'Educational Technology',508242),
(8825,'Industrial Engineering and Operations Research (IEOR)',240338),
(5564,'Systems and Control Engineering',826824);

#Classrooms
INSERT INTO Classrooms VALUES
(7068,'EXR',60),
(9700,'YEC',88),
(6736,'LLX',266),
(9052,'GLR',134),
(5827,'HAM',138),
(4278,'RSM',217),
(7914,'GVV',374),
(4541,'MTH',141),
(6678,'NYZ',380),
(7571,'EAQ',89),
(2102,'EXR',169),
(9858,'YEC',302),
(3570,'LLX',188),
(1012,'GLR',123),
(4540,'HAM',399),
(5540,'RSM',381),
(8426,'GVV',190),
(5893,'MTH',221),
(8222,'NYZ',60),
(7776,'EAQ',251),
(5346,'EXR',150),
(8844,'YEC',384),
(1894,'LLX',219),
(4093,'GLR',358),
(5072,'HAM',374),
(6723,'RSM',88),
(4372,'GVV',341),
(1745,'MTH',376),
(1194,'NYZ',153),
(3283,'EAQ',243),
(5119,'EXR',88),
(6194,'YEC',165),
(5577,'LLX',253),
(2659,'GLR',352),
(6327,'HAM',270),
(9709,'RSM',107),
(2181,'GVV',348),
(3266,'MTH',157),
(2934,'NYZ',350),
(4856,'EAQ',298),
(2398,'EXR',250),
(9382,'YEC',337),
(5810,'LLX',112),
(5962,'GLR',370),
(6733,'HAM',157),
(9216,'RSM',307),
(1418,'GVV',157),
(4736,'MTH',275),
(9130,'NYZ',94),
(6248,'EAQ',83),
(6565,'EXR',297),
(6662,'YEC',255),
(3881,'LLX',201),
(5037,'GLR',386),
(7363,'HAM',216),
(7796,'RSM',236),
(9167,'GVV',375),
(3022,'MTH',101),
(1808,'NYZ',334),
(8706,'EAQ',276),
(3345,'EXR',338),
(1803,'YEC',139),
(7553,'LLX',113),
(5698,'GLR',353),
(1773,'HAM',129),
(4811,'RSM',388),
(4105,'GVV',263),
(9772,'MTH',232),
(1611,'NYZ',397),
(8042,'EAQ',113),
(4265,'GLR',398),
(1479,'HAM',194),
(4404,'RSM',390),
(3937,'GVV',137),
(1900,'MTH',170),
(3255,'MTH',319),
(1470,'NYZ',354),
(6697,'EAQ',219),
(2704,'LLX',179),
(8205,'GLR',311),
(7445,'HAM',88),
(9463,'EXR',182),
(1203,'YEC',142),
(1912,'LLX',395),
(8401,'GLR',148),
(7444,'NYZ',289),
(9176,'EAQ',400),
(3773,'EXR',229),
(4536,'NYZ',394),
(7037,'EAQ',355),
(7925,'LLX',190),
(1185,'GLR',78),
(4741,'HAM',254),
(5641,'GLR',345),
(3650,'HAM',332),
(3978,'RSM',259),
(4637,'GVV',313),
(3027,'MTH',167),
(5599,'EXR',180),
(1578,'YEC',115),
(2662,'LLX',344),
(8165,'HAM',157),
(3797,'RSM',393),
(7703,'LLX',251);

 #Transport_permits
INSERT INTO Transport_permits VALUES
(95284,250,' Alma','Waldrop','249 Cobblestone Drive','Toms River','NJ',88753,6443885071,49266146,'2019-08-31'),
(76809,450,' Hunter','Bryant','373 Sycamore Street','West Babylon','NY',11704,8814298267,34927087,'2022-08-31'),
(45711,450,' Kamryn','Jain','8843 Lawrence St.','Dalton','GA',30721,1758802595,70910918,'2023-08-31'),
(10454,550,'Aditi','Danalian','6 Marvon St.','Midland','MI',48640,9401509597,67764150,'2021-08-31'),
(78353,250,' Helena','Schuhmacher','8847 Hudson St.','Westfield','MA',71085,6826549397,93040872,'2019-08-31'),
(77797,450,' Pablo','Kaskas','33 NW. Shipley Drive','Saint Cloud','MN',56301,4777516112,97442136,'2023-08-31'),
(49810,250,' Maisie','Moran','9208 Court Street','Albany','NY',12203,3879656952,51517576,'2023-08-31'),
(82753,350,' Melany','Harry','948 East Roosevelt Lane','Taylors','SC',29687,5993061278,86901684,'2020-08-31'),
(36603,350,' Boston','Kimbrell','7088 Catherine St.','Hanover Park','IL',60133,2602400027,85156670,'2022-08-31'),
(72976,450,' Ayleen','Whitaker','602 Redwood St.','Warren','MI',48089,9190001525,42887344,'2021-08-31'),
(40357,450,' Melany','Harry','948 East Roosevelt Lane','Taylors','SC',29687,5993061278,17594686,'2023-08-31'),
(72688,550,' Sebastian','Kaiser','490 Forest Street','Somerset','NJ',28873,1680971065,59274911,'2022-08-31'),
(95424,350,'Ahmed','Yao','53 Dogwood Ave.','Mansfield','MA',62048,5883285836,39037338,'2023-08-31'),
(35625,550,' Gatlin','Taylor','16 E. Wentworth Drive','Lithonia','GA',30038,9668830761,68233318,'2019-08-31'),
(18509,550,' Talon','Govindappa','367C Carriage Drive','De Pere','WI',54115,1859529285,12068265,'2019-08-31'),
(42495,550,' Justice','Mandaogane','73 Sleepy Hollow Ave.','East Meadow','NY',11554,3713891614,88369167,'2021-08-31'),
(23002,550,' Manuel','Shepherd','9172 Pawnee St.','Ormond Beach','FL',32174,4255323622,19014932,'2020-08-31'),
(90141,450,' Sasha','Michael','100 Snake Hill Street','Batavia','OH',45103,3894004692,39249190,'2021-08-31'),
(68486,250,' Charli','Baqatyan','14 Rocky River Lane','Fond Du Lac','WI',54935,8918813645,56371319,'2020-08-31'),
(72290,550,' Brandon','Jain','600 Ketch Harbour Rd.','Lansdowne','PA',19050,8776560428,27441212,'2021-08-31'),
(81750,450,' Maren','Darrow','7650 E. Alton Drive','Oviedo','FL',32765,4678179255,72395982,'2022-08-31'),
(75360,450,' Ezra','User','43 W. County Court','Phoenixville','PA',19460,7726584764,85283151,'2023-08-31'),
(36594,450,' Lyric','Robinson','36 N. Leeton Ridge Rd.','New Brunswick','NJ',78901,7923388658,22871614,'2020-08-31'),
(99424,450,' Clarissa','Omana','722 E. Proctor St.','Point Beach','NJ',38742,6535293384,46547243,'2023-08-31'),
(11414,350,' Oaklee','Jurecki','456 Washington Street','Wayne','NJ',27470,3043155411,87021867,'2023-08-31'),
(20307,350,' Henrik','Naik','911 Lafayette Street','East Orange','NJ',27017,1062300128,52760414,'2021-08-31'),
(75688,250,' Brandon','Morris','8334 Division Lane','Nutley','NJ',57110,8906219982,65566154,'2022-08-31'),
(35810,250,' Miles','King','22 Birchwood Street','Waterbury','CT',76705,8115490201,35914807,'2022-08-31'),
(19086,250,' Brantley','McCartt','23 Lancaster St.','Lancaster','NY',14086,8542963174,26804254,'2022-08-31'),
(11685,350,' Ibrahim','Okulate','1 Howard Rd.','Perth Amboy','NJ',28861,4744357172,36349898,'2019-08-31'),
(80013,450,' Yaretzi','Cangelosi','74 Cherry Hill Lane','Ridgewood','NJ',27450,8133988178,15658087,'2021-08-31'),
(19251,350,' Tristian','Wood','84 North Laurel St.','Newport News','VA',23601,7235119198,17131986,'2019-08-31'),
(69868,350,' Ariel','Sturm','2 Marvon Drive','Augusta','GA',30906,7426289049,47192146,'2022-08-31'),
(78922,550,' Meadow','Fields','7615 Manchester Lane','Helotes','TX',78023,7338978847,62673758,'2019-08-31'),
(53582,250,' Xander','Marchese','7227 Augusta Lane','Prussia','PA',19406,7836130770,33847146,'2020-08-31'),
(30475,550,'Leonard','Shaw','904 North East St.','Dyersburg','TN',38024,9598177753,70387225,'2022-08-31'),
(35727,450,' Bodie','Vu','8492 Riverview Ave.','Sun Prairie','WI',53590,8662331606,82335900,'2019-08-31'),
(71141,550,' Felix','Corley','704 Fulton Street','Suwanee','GA',30024,6543470066,36859934,'2021-08-31'),
(37561,550,' Zaniyah','Verma','2 Country Ave.','Burbank','IL',60459,4391684464,50456290,'2020-08-31'),
(87341,550,' Kinley','Mathew','406 SW. School St.','Centreville','VA',20120,7381706046,65391667,'2020-08-31'),
(36653,550,' Melvin','McMillan','256 Mayfair Lane','Stevens Point','WI',54481,3205600693,53045428,'2019-08-31'),
(42270,250,' Rylie','Fernandez','50 S. Myers Lane','Charleston','SC',29406,7534197961,25774057,'2021-08-31'),
(13622,250,' Miles','King','22 Birchwood Street','Waterbury','CT',76705,8115490201,99574915,'2020-08-31'),
(91807,250,' Jesse','Bradley','5 Brook St.','Tucson','AZ',85718,9529849492,72835628,'2019-08-31'),
(90767,250,' Henrik','Naik','911 Lafayette Street','East Orange','NJ',27017,1062300128,30932032,'2020-08-31'),
(86282,350,'Sheldon','McGee','8353 Wrangler Avenue','Brandon','FL',33510,6552133974,95548388,'2021-08-31'),
(50441,550,'Tony','Gibbs','9 Rosewood St.','Atlanta','GA',30303,2661313435,10219922,'2021-08-31'),
(26051,450,' Ayan','Yang','8006 Pin Oak Lane','Deerfield','IL',60015,6154912733,28620271,'2020-08-31'),
(56927,550,' Emory','Singh','323 Wild Horse Dr.','Calumet City','IL',60409,8848069689,75965642,'2022-08-31'),
(45195,250,' Estella','Zhu','8908 6th Ave.','Johnston','RI',62919,4363524775,88433677,'2019-08-31'),
(27251,250,' Mustafa','Robles','298 NW. Wild Horse Street','Elkton','MD',21921,8710566718,45842242,'2019-08-31'),
(76418,550,' Xander','Marchese','7227 Augusta Lane','Prussia','PA',19406,7836130770,25959967,'2023-08-31'),
(39743,250,' Lauren','Hensley','170 San Carlos Avenue','Frederick','MD',21701,5212288205,29623446,'2020-08-31'),
(39245,350,' Melvin','McMillan','256 Mayfair Lane','Stevens Point','WI',54481,3205600693,54019959,'2021-08-31'),
(89919,350,' Jakob','Chism','668 Bridgeton Ave.','Oak Lawn','IL',60453,6421250218,84394362,'2021-08-31'),
(90174,450,' Logan','Redfield','12 Church Court','Alabaster','AL',35007,5185633784,62108897,'2023-08-31'),
(30671,350,' Paris','Tao','224 Howard Drive','Portland','ME',64103,5642563091,94493914,'2022-08-31'),
(47011,450,'Rajesh','White','7806 Woodland St.','Waterloo','IA',50701,5220054440,56381410,'2022-08-31'),
(89827,250,'Ziva','Hofler','65 Nicolls Lane','Waldorf','MD',20601,3136452863,21352850,'2020-08-31'),
(86381,550,' Lian','Price','7516 Smith Store St.','Hope Mills','NC',28348,4934128038,64431297,'2021-08-31'),
(26040,550,'Penny','Welmaker','8062 Wrangler Ave.','Marquette','MI',49855,3902211264,16925006,'2020-08-31'),
(15073,250,' Leland','Baer','8920 Manor Station Drive','Monsey','NY',10952,9108285887,16468851,'2020-08-31'),
(15156,250,' Talon','Govindappa','367C Carriage Drive','De Pere','WI',54115,1859529285,57537117,'2022-08-31'),
(38692,250,' Sekani','Alvarez','8123 Greystone Circle','Brentwood','NY',11717,2520521101,45165072,'2020-08-31'),
(87672,250,' Cannon','Hollister','106 North Bridle Drive','Long Beach','NY',11561,1765314982,93186725,'2020-08-31'),
(28783,250,' Lauren','Hensley','170 San Carlos Avenue','Frederick','MD',21701,5212288205,74454611,'2021-08-31'),
(34838,350,' Makenzie','Song','34 Philmont Dr.','Mason City','IA',50401,3208135756,98859031,'2023-08-31'),
(72180,250,' Alexandria','Wurz','7697 Monroe Dr.','Hialeah','FL',33010,3136354812,56020680,'2020-08-31'),
(58070,250,' Oscar','Buquet','7234 Linda Road','Horn Lake','MS',38637,5269566597,15329315,'2022-08-31'),
(24468,250,' Kalel','Ahmad','7887 Brown Street','Derry','NH',23038,5735968417,47921149,'2020-08-31'),
(19309,350,' Atlas','Melton','916 Ridge Ave.','Sugar Land','TX',77478,7397395631,32533643,'2019-08-31'),
(77901,450,' Clay','Koroma','75 Taylor Rd.','Pelham','AL',35124,1036443978,22852853,'2023-08-31'),
(21701,350,' Dallas','Nwaekwe','7469 S. Aspen Ave.','Tullahoma','TN',37388,8314366323,78140968,'2019-08-31'),
(49318,350,' Winnie','Baugh','239 Bowman Street','Merrick','NY',11566,9843012720,26170425,'2020-08-31'),
(77526,250,' Daniela','Braughton','5 Fordham St.','Peoria','IL',61604,4134357752,29309391,'2023-08-31'),
(36812,450,' Helena','Schuhmacher','8847 Hudson St.','Westfield','MA',71085,6826549397,95998757,'2023-08-31'),
(58005,350,' Jaylin','Shah','900 Williams Lane','New Philadelphia','OH',44663,4173988967,22771545,'2022-08-31'),
(11936,550,' Brecken','Mcbride','70 Maple Ave.','Ladson','SC',29456,1191159849,62155927,'2021-08-31'),
(37560,350,' Addilyn','Garcia','365 Ocean Drive','Springfield','PA',19064,1035241460,76089849,'2023-08-31'),
(31845,450,' Cadence','Mahapatra','559C Rosewood Road','Hummelstown','PA',17036,3668842082,95210827,'2023-08-31'),
(90103,450,' John','Aziz','9343B NW. Pierce Circle','Hobart','IN',46342,8516232096,19124932,'2019-08-31'),
(34426,550,' Angie','Sandlin','7702 Foster St.','Melbourne','FL',32904,6744503011,50107671,'2021-08-31'),
(91583,250,' Hunter','Bryant','373 Sycamore Street','West Babylon','NY',11704,8814298267,40521987,'2023-08-31'),
(78825,450,' Maisie','Moran','9208 Court Street','Albany','NY',12203,3879656952,83163825,'2022-08-31'),
(45381,550,' Dallas','Nwaekwe','7469 S. Aspen Ave.','Tullahoma','TN',37388,8314366323,14002709,'2021-08-31'),
(85777,350,' Edison','Canessa','399 Brewery Rd.','Redford','MI',48239,4561234624,85758901,'2019-08-31'),
(16660,350,' Serena','Torres','191 Middle River Lane','Cranford','NJ',27016,2129220787,64691948,'2023-08-31'),
(85493,450,' Emory','Browne','4 San Pablo Street','Lake Charles','LA',70605,9302018427,18217801,'2022-08-31'),
(68715,350,'Dilip','Tsai','60 Manhattan Dr.','Norwalk','CT',76851,9984714780,24590910,'2022-08-31'),
(51953,450,' Casen','Jon-Ubabuco','8382 Vermont Street','Dallas','TX',75019,2329783305,73924115,'2020-08-31'),
(46824,450,' Charli','Baqatyan','14 Rocky River Lane','Fond Du Lac','WI',54935,8918813645,21388982,'2022-08-31'),
(13470,350,'Raj','Chandra','3 Canal Dr.','Ontario','CA',91762,4447468476,17162909,'2019-08-31'),
(24652,550,' Zaiden','White','99 James Street','Alliance','OH',44601,5886248512,99927344,'2019-08-31'),
(14293,450,' Oaklee','Jurecki','456 Washington Street','Wayne','NJ',27470,3043155411,12649353,'2021-08-31'),
(30479,550,'Shruti','Swaim','811 Pineknoll Court','Akron','OH',44312,6551850401,77142898,'2023-08-31'),
(84468,450,' Alexandria','Wurz','7697 Monroe Dr.','Hialeah','FL',33010,3136354812,12688937,'2020-08-31'),
(28970,350,' Winnie','Baugh','239 Bowman Street','Merrick','NY',11566,9843012720,12091133,'2019-08-31'),
(81839,350,' Mohamed','Krueger','7 East Oakwood St.','Northville','MI',48167,1443424036,69863009,'2021-08-31'),
(13759,550,' Cassandra','Glover','7904 Manor Court','Redondo Beach','CA',90278,5101604542,38365879,'2023-08-31'),
(51598,350,' Justin','Rusek','8200 Lake View Court','Sanford','NC',27330,9859944912,96659284,'2019-08-31'),
(58406,550,' Zaniyah','Verma','2 Country Ave.','Burbank','IL',60459,4391684464,35226066,'2022-08-31');



#Transport_vehicles
INSERT INTO Transport_vehicles VALUES
(697,90103,'Lexus RX','Gray','QXK5039'),
(318,85777,'Mazda CX-9','Green','XVA3816'),
(826,49810,'Chevrolet Trax','Gold','VSB4865'),
(509,53582,'Porsche 911 ','Orange','MTC8591'),
(362,78825,'Nissan Murano','Maroon','ALY6653'),
(199,36653,'Chevrolet Trax','Blue','UHD8619'),
(260,75688,'Ferrari California','Black','WMG7707'),
(125,81750,'Kia Sportage','Green','HZX4082'),
(882,69868,'Mazda MX 5','Gold','TWX8450'),
(499,13470,'Toyota Fortuner','Black','ASH4806'),
(750,49318,'GMC Yukon','Orange','ENC6152'),
(990,26040,'Subaru Outback','Orange','LAE5586'),
(203,24468,'Ford Escape','Red','FJS8625'),
(261,35625,'GMC Yukon','Black','GXQ9909'),
(745,36594,'Aston Martin','Yellow','JAG4354'),
(757,18509,'Honda HR-V','Blue','SHC8188'),
(716,19251,'Mazda MX 5','Maroon','PWM2022'),
(223,28970,'Dodge Durango','Maroon','AWS4477'),
(115,16660,'Mitsubishi Pajero','Orange','ZXG6343'),
(228,86381,'Subaru Outback','Green','ECL2435'),
(143,30479,'Chevy Trailblazer','White','ESQ2112'),
(432,95284,'Acura MDX','Black','YJE3042'),
(917,72976,'Ford Escape','Yellow','YGU9416'),
(486,58005,'Hummer H2','Violet','HNL4804'),
(861,19086,'Fiat 124 Spider','Gray','NQW3883'),
(711,77797,'Chevy Trailblazer','Maroon','EBR2154'),
(149,47011,'Mitsubishi Pajero','Maroon','RLA4094'),
(530,35810,'Fiat 124 Spider','Blue','WZJ8001'),
(927,89919,'Nissan Murano','Gray','WWJ1131'),
(593,26051,'Hyundai Tucson','Orange','ZYV2571'),
(285,11936,'Hyundai Tucson','Brown','UPL1003'),
(124,95424,'Ford Territory','Brown','ZBZ1714'),
(778,27251,'Kia Sportage','Violet','GWZ2375'),
(338,46824,'Toyota FJ Cruiser','Brown','UCM7367'),
(660,86282,'Hummer H2','Gold','XSB9825'),
(736,87341,'Chevy Trailblazer','Black','XPA2534'),
(471,75360,'Aston Martin','Orange','TUD3344'),
(348,21701,'Ford Territory','Green','GFL6034'),
(749,42270,'Dodge Durango','Gray','WVP6110'),
(965,50441,'Hyundai Tucson','Green','PEX1960'),
(484,91807,'Honda HR-V','Red','NBL7698'),
(767,71141,'Chevrolet Equinox','Violet','FNC9327'),
(266,30475,'Rolls Royce Dawn','Yellow','XTW6242'),
(563,13759,'Honda HR-V','Green','WAH1235'),
(738,15156,'Toyota Fortuner','Pink','PEN2075'),
(506,77526,'Honda HR-V','Yellow','RZA5152'),
(526,11685,'Ford Mustang','White','HEW3172'),
(477,34426,'Mitsubishi Sport','White','WKZ9883'),
(609,84468,'Chevrolet Trax','Red','ZZQ5331'),
(321,80013,'Mazda MX 5','Red','GNG7370'),
(692,31845,'Hyundai Tucson','Blue','CUC9788'),
(292,37561,'Hyundai Tucson','Black','ATM6966'),
(316,68486,'Hyundai Tucson','Maroon','XJB5438'),
(441,90174,'Mazda CX-7','White','ZTT7755'),
(825,51598,'Honda Pilot','Orange','YHU6246'),
(832,99424,'Cadillac XLR','Pink','DGA1709'),
(574,24652,'Chevrolet Equinox','Blue','GUV5055'),
(592,11414,'Chevrolet Camaro','Violet','RLQ8600'),
(255,89827,'Porsche Cayenne','Gold','SRK3323'),
(493,82753,'Dodge Durango','Green','APC2178'),
(230,78353,'Chevrolet Equinox','Red','TQZ6191'),
(422,56927,'Kia Sorento','Yellow','GTH7310'),
(731,30671,'Mazda CX-9','Red','JNP4842'),
(635,90141,'Hyundai Tucson','Red','RRW1906'),
(280,39743,'Lexus RX','Black','ULA8373'),
(317,45711,'Chevrolet Captiva','Gray','ZTC8921'),
(698,51953,'Suzuki Grand Vitara','Violet','MZM4686'),
(628,85493,'Porsche Cayenne','Yellow','LWH9437'),
(718,77901,'Ford Explorer','Gold','UUN6158'),
(864,76418,'Lexus RX','Brown','RYE6441'),
(743,78922,'Mini Cooper SD','Green','VDP1992'),
(288,72290,'Kia Sorento','Gold','VEX3540'),
(209,87672,'Chevrolet Suburban','Brown','DGD3966'),
(901,15073,'Toyota FJ Cruiser','Yellow','LNU8571'),
(184,45195,'Kia Sportage','Pink','WUZ9808'),
(800,45381,'Mazda CX-7','Gold','WJH6487'),
(331,36603,'Dodge Journey','Orange','YCF8366'),
(496,42495,'Honda Pilot','Gray','FDH9500'),
(989,13622,'Volvo C70','White','JRN3815'),
(761,76809,'Acura MDX','Blue','DER4243'),
(172,58070,'Dodge Journey','White','RMU3398'),
(287,10454,'Chevrolet Equinox','White','FUF9944'),
(656,36812,'Honda Pilot','Pink','HPH4174'),
(257,39245,'Nissan Patrol','Blue','WKT8230'),
(631,91583,'Lexus RX','Red','MPM2881'),
(733,72180,'Dodge Durango','Gray','VBG6481'),
(347,68715,'Subaru Outback','Pink','QZC3041'),
(996,58406,'Hummer H2','Yellow','JPT6452'),
(874,28783,'Chevy Trailblazer','Black','DWG5400'),
(354,20307,'Daihatsu Copen','Brown','EXS1670'),
(561,14293,'Chevrolet Suburban','Gray','HLM8524'),
(214,40357,'Ford Everest','Pink','USY9550'),
(505,35727,'Chevrolet Captiva','Pink','LZX2951'),
(378,72688,'Ford Explorer','Violet','YYP3871'),
(953,38692,'Chevrolet Equinox','Violet','YVF5123'),
(297,90767,'Honda Pilot','Maroon','VMY4953'),
(466,19309,'Ford Everest','Maroon','UCW6866'),
(369,81839,'Volvo C70','Gold','PXZ7576'),
(515,34838,'Chevrolet Trax','Blue','TUC9654'),
(381,37560,'Chevrolet Suburban','Brown','FNB5841'),
(207,23002,'Hummer H2','White','XVW6239');


#Residency
INSERT into Residency VALUES
(67316,'761-05-5417','US Citizen',NULL),
(42597,'459-72-0749','US Citizen',NULL),
(71037,'771-54-7189','US Citizen',NULL),
(60568,'204-12-1525','US Citizen',NULL),
(14342,'037-42-3593','International','F1'),
(51318,'465-87-4292','Permanent Resident',NULL),
(48265,'574-84-4033','Permanent Resident',NULL),
(68982,'307-31-0390','US Citizen',NULL),
(19569,'458-17-0581','International','F1'),
(59788,'577-48-1343','Permanent Resident',NULL),
(94522,'476-12-5978','US Citizen',NULL),
(73429,'008-36-3982','International','F1'),
(59111,'503-16-7414','International','F1'),
(83158,'506-90-7337','US Citizen',NULL),
(67774,'073-54-2745','US Citizen',NULL),
(26240,'049-40-1259','US Citizen',NULL),
(73977,'525-26-3848','Permanent Resident',NULL),
(53328,'434-86-8619','International','F1'),
(30453,'647-98-8614','International','F1'),
(50534,'658-24-2849','US Citizen',NULL),
(83161,'307-05-3059','International','F1'),
(18284,'504-32-1880','US Citizen',NULL),
(54846,'023-46-5505','Permanent Resident',NULL),
(68786,'398-90-6882','US Citizen',NULL),
(23721,'481-39-2662','International','F1'),
(86931,'518-46-4865','International','F1'),
(31461,'508-84-0150','Permanent Resident',NULL),
(92063,'509-06-4426','International','F1'),
(63924,'502-09-8675','US Citizen',NULL),
(37784,'403-52-1924','US Citizen',NULL),
(95039,'497-46-7827','International','J1'),
(15597,'423-27-8360','US Citizen',NULL),
(57675,'517-18-3466','US Citizen',NULL),
(51684,'220-04-1310','International','J1'),
(34611,'540-24-3581','US Citizen',NULL),
(28086,'280-22-1571','International','F1'),
(72603,'251-04-7346','Permanent Resident',NULL),
(87846,'221-66-0599','US Citizen',NULL),
(13544,'286-58-8955','Permanent Resident',NULL),
(93125,'646-36-2652','US Citizen',NULL),
(24821,'314-70-4417','International','H4'),
(50010,'006-05-5686','International','F1'),
(80135,'458-55-3633','US Citizen',NULL),
(66510,'472-96-3445','US Citizen',NULL),
(20075,'509-09-0559','US Citizen',NULL),
(23218,'519-34-7024','US Citizen',NULL),
(62589,'233-24-6484','Permanent Resident',NULL),
(75593,'653-50-9654','Permanent Resident',NULL),
(72900,'628-07-5722','US Citizen',NULL),
(22318,'310-04-0933','US Citizen',NULL),
(96862,'489-52-3471','US Citizen',NULL),
(96905,'316-26-6107','International','F1'),
(53839,'221-28-0377','US Citizen',NULL),
(45676,'679-07-8667','International','F1'),
(70635,'436-21-1771','US Citizen',NULL),
(34711,'503-32-1980','International','H4'),
(82067,'007-98-4046','US Citizen',NULL),
(52118,'482-76-2480','Permanent Resident',NULL),
(12981,'229-07-3458','International','F1'),
(27478,'422-82-9672','US Citizen',NULL),
(16462,'574-59-0002','Permanent Resident',NULL),
(13119,'218-13-2957','US Citizen',NULL),
(23746,'405-57-7801','US Citizen',NULL),
(44439,'577-46-2112','International','F1'),
(91462,'524-38-4646','International','F1'),
(18339,'540-29-9183','Permanent Resident',NULL),
(94768,'403-37-4849','Permanent Resident',NULL),
(70751,'676-05-1040','Permanent Resident',NULL),
(82930,'350-22-6126','International','F1'),
(53984,'403-92-9838','International','H4'),
(51363,'005-24-3958','Permanent Resident',NULL),
(69229,'442-70-4507','International','F1'),
(20129,'689-05-2839','US Citizen',NULL),
(19402,'410-09-2557','Permanent Resident',NULL),
(93230,'636-17-1950','US Citizen',NULL),
(52511,'425-23-9757','Permanent Resident',NULL),
(93073,'220-81-1174','US Citizen',NULL),
(42570,'001-04-4171','Permanent Resident',NULL),
(39318,'410-13-5510','US Citizen',NULL),
(61192,'642-28-3565','International','F1'),
(14323,'447-94-2951','International','J1'),
(54933,'309-16-6403','International','F1'),
(42389,'508-55-2365','International','J1'),
(55175,'529-29-3893','Permanent Resident',NULL),
(91858,'221-66-3970','Permanent Resident',NULL),
(48063,'234-50-3706','Permanent Resident',NULL),
(51020,'532-69-6884','International','J1'),
(34570,'541-25-3682','US Citizen',NULL),
(79433,'528-89-1508','International','F1'),
(27252,'674-40-4921','Permanent Resident',NULL),
(60056,'576-28-2750','International','F1'),
(98274,'470-54-4115','International','F1'),
(76426,'041-18-4087','US Citizen',NULL),
(24025,'503-20-0306','International','F1'),
(63271,'530-75-2594','US Citizen',NULL),
(65327,'506-13-2566','US Citizen',NULL),
(32445,'400-72-3317','International','F1'),
(88399,'403-63-6949','US Citizen',NULL),
(67767,'660-03-8642','US Citizen',NULL),
(89017,'024-22-1902','US Citizen',NULL),
(29067,'542-74-8537','US Citizen',NULL);


# Teaching_Staff
INSERT into Teaching_Staff values
(196557,'Instructor','Full Time'),
(449901,'Associate Professor','Full Time'),
(206427,'Associate Professor','On Leave'),
(688905,'Instructor','Full Time'),
(634582,'Instructor','Full Time'),
(138624,'Professor','Full Time'),
(932068,'Instructor','Full Time'),
(572796,'Instructor','Full Time'),
(134670,'Associate Professor','Full Time'),
(175125,'Professor','Full Time'),
(232618,'Instructor','Full Time'),
(760609,'Professor','Full Time'),
(508242,'Associate Professor','Full Time'),
(240338,'Associate Professor','Full Time'),
(826824,'Professor','Full Time'),
(817422,'Professor','Full Time'),
(917848,'Instructor','Part Time'),
(635586,'Instructor','Full Time'),
(423398,'Professor','Full Time'),
(846275,'Instructor','Full Time'),
(168857,'Associate Professor','Full Time'),
(125595,'Instructor','Full Time'),
(423522,'Professor','Full Time'),
(937233,'Instructor','Full Time'),
(271785,'Associate Professor','Full Time'),
(357968,'Associate Professor','On Leave'),
(469799,'Instructor','Full Time'),
(508314,'Instructor','Full Time'),
(940853,'Professor','Full Time'),
(736890,'Instructor','Full Time'),
(271820,'Instructor','Full Time'),
(861380,'Associate Professor','Full Time'),
(782822,'Professor','Full Time'),
(369893,'Instructor','Full Time'),
(430546,'Professor','Full Time'),
(472467,'Associate Professor','Full Time'),
(904131,'Associate Professor','Full Time'),
(201506,'Professor','Full Time'),
(572132,'Professor','Full Time'),
(538421,'Instructor','Part Time'),
(353908,'Instructor','Full Time'),
(372096,'Professor','Full Time'),
(754974,'Instructor','Full Time'),
(242634,'Associate Professor','Full Time'),
(624640,'Instructor','Full Time'),
(987884,'Professor','Full Time'),
(516465,'Instructor','Full Time'),
(246736,'Associate Professor','Full Time'),
(454493,'Associate Professor','On Leave'),
(500587,'Instructor','Full Time'),
(325868,'Instructor','Full Time'),
(616644,'Professor','Full Time'),
(639998,'Instructor','Full Time'),
(410413,'Instructor','Full Time'),
(114595,'Associate Professor','Full Time'),
(476789,'Professor','Full Time'),
(438123,'Instructor','Full Time'),
(184260,'Professor','Full Time'),
(843331,'Associate Professor','Full Time'),
(886140,'Associate Professor','Full Time'),
(760362,'Professor','Full Time'),
(766698,'Professor','Full Time'),
(633596,'Instructor','Part Time'),
(133163,'Instructor','Full Time'),
(410918,'Professor','Full Time'),
(418420,'Instructor','Full Time'),
(996025,'Associate Professor','Full Time'),
(784101,'Instructor','Full Time'),
(480856,'Professor','Full Time'),
(507184,'Instructor','Full Time'),
(803872,'Associate Professor','Full Time'),
(795236,'Associate Professor','On Leave'),
(632540,'Instructor','Full Time'),
(672641,'Instructor','Full Time'),
(280941,'Professor','Full Time'),
(573089,'Instructor','Full Time'),
(476100,'Instructor','Full Time'),
(169365,'Associate Professor','Full Time'),
(333324,'Professor','Full Time'),
(573623,'Instructor','Full Time');


#Courses

INSERT into Courses values
(1,'ACC','ACC 210','Financial Accounting Fundamentals I','ACC 210','Introduces basic accounting concepts, principles and prodcedures for recording business transactions and developing financial accounting reports. Excel spreadsheet component.',100),
(2,'ACC','ACC 220','Financial Accounting Fundamentals II','ACC 210','Applications of basic accounting concepts, principles and procedures to more complex business situations and to different forms of enterprise ownership. Includes computerized element. Prereq: ACC 210 or instructor permission.',60),
(3,'ACC','ACC 230','Fundamentals of Managerial Accounting','ACC 220','Analysis of accounting data as part of the managerial process of planning, decision making and control. Concentrates on economic decision making in enterprises. Includes computerized element. Prereq: ACC 220 or instructor permission.',20),
(4,'ACC','ACC 251','Intermediate Accounting','ACC 220','In-depth review of financial accounting principles. Emphasizes the conceptual framework of accounting, revenue and expense recognition. Accounts Receivable, Depreciation, and Amortization, etc. Prereq: ACC 220 or instructor permission.',30),
(5,'ACC','ACC 257','Business Tax Accounting','ACC 220','Basic principles, practices and governmental regulations (Federal, Washington, State, and local) involved in business tax accounting including filing returns, record keeping, tax planning, and registrations and business licenses. Prereq: ACC 220 or instructors permissions.',15),
(6,'BUS','BUS 101','Introduction to Business','BUS 170','Survey of businss practices. Covers business terminology, forms of business ownership, franchising, small and international businesses, leadership and management, marketing principles, financing and investment methods, and business environment.',80),
(7,'BUS','BUS 155','Developing A Feasibility Plan','BUS 170','With the aid of a counselor, a feasibility plan will be developed which will be the basis or start of your business plan. Must be concurrently enrolled in BUS 151.',15),
(8,'BUS','BUS 151','Introduction to Entrepreneurship','BUS 170','Overview of the entrepreneurial process, examination of the marketplace, and discussion of successful business strategies. Product selection, selling and marketing strategies. Sources of information and assistance. Must be concurrently enrolled in BUS 155.',15),
(9,'BUS','BUS 170','Information Technology I','BUS 170','Uses Word for Windows word processing skills, document formatting, keyboarding, and 10-key keypad skills. Emphasis on preparing letters, memos, reports, and tables. Introduces Excel spreadsheet basics.',50),
(10,'BUS','BUS 171','Information Technology II','BUS 170','Uses intermediate Word features including formatting and production, mail merge, macros, text columns, graphics, and fonts; Excel spreadsheet; and introduction to PowerPoint presentation software, Internet and email. Prereq: BUS 170 or permission from instructor.',35),
(11,'ART','ART 100','Introduction to Art','MAT 098','Historical backgrounds and design fundamentals which have affected art. Includes slide lectures, reading and practical studio applications.',40),
(12,'ART','ART 101','Design','MAT 098','Studio sudies in the fundamentals of two-dimensional art with problems based on line, space, texture, shape and color theories. Includes practical applications of these theories to design.',12),
(13,'ART','ART 111','Drawing','MAT 098','Study of line, value, space, perspective, and compostion through the use o charcoal, pencil, pen, and brush.',12),
(14,'ART','ART 201','Painting','MAT 098','Beginning painting in oil or synthetic media using still life. Emphasis on basics such as composition, value studies, color mixing, canvas preparation, and various styles and techniques. No prerequisite; some drawing background important.',15),
(15,'ART','ART 210','Computer Art','MAT 098','Explore the elements of art such as line, value, space, composition, and color through the use of the computer. Sudents will create works of art using the computer.',18),
(16,'ART','ART 251','Art History','MAT 098','Surveys major forms of visual expression from the Paleolithic, Egyptian, Mesopotamian, Greek, Roman, and Early Christian periods. Includes painting, sculpture, architecture, lectures, slides, and readings.',75),
(17,'BIO','BIO 100','Biological Principles','MAT 098','An introductory biology course with lab for the non-science major. May include maintenance of the balance between man and his environment, nutrition, genetics and inheritence, ecological principles, plant and animal diversity, and evolution.',60),
(18,'BIO','BIO 101','General Biology','MAT 098','Basic bilogical concepts with emphasis on general cell processes, plant and animal diversity, morphyology, limited reproduction, phylogeny of the living organisms, exploration of molecular genetics.',50),
(19,'BIO','BIO 280','Microbiology','MAT 098','Introduction to micro-organisms including microbial cell structure and function; metabolism; microbial genetics; and the role of micro-organisms in disease, immunity, and other selected applied areas.',25),
(20,'CHE','CHE 101','Chemistry','MAT 098','General chemistry for non-science majors. Completion of CHE 101 fulfills chemistry requirements for many health science majors.',30),
(21,'CHE','CHE 139','Fundamentals of Chemistry','MAT 098','Prepatory for the science major chemistry courses for students without prior chemistry experience. This lecture format will include chemical mathematics, basic atomic structure, chemical bonding, chemical equation balancing and mole concept, and chemical stoichiometry.',100),
(22,'CHE','CHE 231','Organic Chemistry','MAT 098','Structure, nomenclature, reactions, and synthesis of the main types of organic compounds.',40),
(23,'CIS','CIS 101','Microcomputer Applications','MAT 098','This is a "hands-on" course. Students will learn how to use word processing, spreadsheet, and database applications. General operation systems activities such as deleting files, renaming files, and creating and navigating directory structures will also be covered.',20),
(24,'CIS','CIS 102','Information Systems Concepts','MAT 098','Provides a broad introduction to computers and information systems. Includes coverage of hardware, software, data organization, data communications, and systems development. Also covers the evolving role of computers in society.',80),
(25,'CIS','CIS 114','Problem Solving and Structured Programming','MAT 098','Covers design, documentation, and coding of programs using top-down design and structured programming principles. Includes introduction to multi-user systems, text editors, data access and storage techniques.',25),
(26,'CIS','CIS 236','Database Management','MAT 098','Includes database concepts, data management techniques, database environment, record relationships, and advantages and limitations of the database approach. Includes data modeling and database design.',20),
(27,'CSC','CSC 110','Programming in BASIC','MAT 098','Computer programming and program design using the Visual Basic programming language. Emphasis is on Program Design and Algorithm Development while writing programs primarily about mathematical and scientific applications.',20),
(28,'CSC','CIS 142','Computer Programming','MAT 098','Introduction to computer science using the C programming language. Emphasizes design, algorithmics, abstraction, and analysis.',25),
(29,'JRN','JRN 104','College Publications','MAT 098','Hands-on course in college publishing. Covers basics of reporting and writing through work on college newspaper and other assignments.',20),
(30,'ECO','ECO 100','Survey of Economics','MAT 098','Economics applied to various comtemporary social problems and issues. Provides an introduction to economic principles concerning national prosperity, market behavior, income inequality, the role of government, and economic fluctuations.',70),
(31,'ECO','ECO 200','Principles of Economics: Microeconomics','MAT 098','Covers resource allocation and income distribution with emphasis on price determination, production costs, and market structures. Intermediate algebra or equivalent required.',35),
(32,'ECO','ECO 201','Principles of Economics: Macroeconomics','ENG 101','Analysis of the aggregate economy: GDP, inflation, business cycles, trade and finance. Intermediate algebra or equivalent required.',35),
(33,'MUS','MUS 100','Music in the Western World','ENG 101','An introduction to music. Features music from a global perspective with a focus on Western Music. Many musical examples, listening, videos on great musicians of the past.',40),
(34,'MUS','MUS 101','First Year Theory and Ear Training','ENG 101','Rudiments of music - notation, scales, intervals, and triads, rhythmic and melodic sight-reading and dictation. Studies of historical periods.',15),
(35,'MUS','MUS 201','Second Year Music Theory','MUS 101','Continuation of MUS 101. Chromatic harmony, modulations and related modern concepts. Prereq: MUS 101 or instructor permission.',15),
(36,'MUS','MUS 204','History of Jazz','MUS 101','Traces the roots of jazz in America from New Orleans, New York, Chicago, Kansas City, the Big Band Era, Be-Bop to modern jazz through films, lectures, recordings and live performances.',30),
(37,'ENG','ENG 101','Composition - Fundamentals','MUS 101','Introduces the nature of the writing process in its various stages: gathering, shaping, establishing audience, editing, revising, polishing, and proffreading. Writing assignments concentrate on the major strategies of nonfiction prose - narration, description, and exposition.',60),
(38,'ENG','ENG 102','Composition - Intermediate','MUS 101','Continues instruction on the writing process, extending it to include source-based writing of the kind typically done in academic settings. Topics for reading and writing will vary instructor to instructor. Prereq: ENG 101 or instructor permission.',35),
(39,'ENG','ENG 104','Advanced English Grammar','MUS 101','Study of the grammar and rhetoric of the English sentence. Not a remedial course.',20),
(40,'GEG','GEG 100','Introduction to Geography','MUS 101','An introduction to the major cultures of the world (Hebrew, Christian, Islamic, Hindu, Buddhist), their origins, values, heroes, rituals, scriptures and cross-cultural influences.',70),
(41,'GEG','GEG 205','Physical Geography','ECO 201','Study of the Earth, the materials that make it up, and plate tectonics. Special attention to the Pacific Northwest. Includes laboratory and field trip work.',20),
(42,'HIS','HIS 101','World History to 1500','ECO 201','Historic foundations and development of the great civilizations from prehistoric days to the Renaissance with emphasis on social, political, economic and geographic aspects. Attention to the nature of history as an intellectual and academic discipline.',60),
(43,'HIS','HIS 111','U.S. History to 1877','ECO 201','American history from the colonial period through Reconstruction. Emphasis on the American Revolution, the National Period, slavery, territorial expansion, the Civil War and Reconstruction.',60),
(44,'HIS','HIS 112','U.S. History Since 1865','ECO 201','Includes Reconstruction, industrialization, urbanization, westward movement, political reform movements, agrarian protest, progressive period, 1920s Great Depressioin and the New Deal, WWII, the conservative 50s, liberalism of the 60s and 70s, and into the next century.',60),
(45,'MAT','MAT 080','Preparatory Mathematics','ECO 201','Individualized instruction in Arithmetic, Algebra I and II, Geometry, nad Intermediate Algebra.',80),
(46,'MAT','MAT 097','Elementary Algebra','ECO 201','First course in Algebra includes signed numbers, linear equations, linear inequalities, products and factorization of polynomials, and operations with quotients of polynomials.',25),
(47,'MAT','MAT 098','Intermediate Algebra','ECO 201','Sets and the real number system, polynomial and rational expressions, exponents and radicals, first and second degree equations, linear systems of equations, and graphs.',20),
(48,'MAT','MAT 103','Geometry and Visualization','ECO 201','Basic plane geometry concepts, emphasizing problem-solving. Right triangle trigonometry. Introduction to 3-D geometry/spatial thinking. Directed towards students with no high school geometry but who plan a career in science/engineering.',25),
(49,'MAT','MAT 104','Trigonometry','ECO 201','Elementary plane goemetry, right triangle tirgonometry, general angels, identities, equations, word problems, and selected topics.',20),
(50,'PHY','PHY 100','Survey Of Physics','PHY 201','Basic laws of phyics from the laws of motion through nuclear physics. Also examines the origins and impact on society of the basic physics concepts.',80),
(51,'PHY','PHY 101','General Physics','PHY 201','Classical mechanics; kinematics and dynamics. Includes development of concepts of force, work/energy, impulse/momentum, and the conservation laws.',40),
(52,'PHY','PHY 201','Engineering Physics I','PHY 201','Development of the basic principles of classical mechanics. A calculus approach is used to introduce kinematics, Newtons laws, the work-energy theorem, and conservation laws.',20),
(53,'PHY','PHY 203','Engineering Physics II','PHY 201','Waves and oscillations. Mechanical waves and sound are studied as well as geometric and physical optics. The wave aspect of an electron is introduced as it applies to the stationary states of the hydrogen atom. Prereq: PHY 201.',15),
(54,'POL','POL 101','Introduction to Political Science','ECO 201','Introduction to theory, organization, politics and administration of government. Includes political theory, comparative systems, political socialization, public administration, political parties and elections, and international relations.',90),
(55,'POL','POL 102','American Government','ECO 201','Origin and development of the U.S. government. Covers the stucture and function of Congress, the Presidency and courts as well as civil liberties, political behavior and political parties.',50),
(56,'POL','POL 213','Women and Politics','ECO 201','Introduction to concepts of power and policy issues as they relate to women. Theoretical, historical and empirical studies of womens participation in social and political movements nationally and internationally. Study of womens diverse roles in relations to family, economics, labor, government, and law.',30);


#Classes

INSERT into Classes values

(1000,11,1012,5,1,'2013-09-10','10:00:00',50,0,1,1,1,1,1),
(1002,12,1185,4,1,'2013-09-09','15:30:00',110,1,0,1,0,0,0),
(1004,13,1194,4,1,'2013-09-09','08:00:00',50,1,0,1,1,1,0),
(1006,13,1203,4,1,'2013-09-09','09:00:00',110,1,0,1,0,0,0),
(1012,14,1418,4,1,'2013-09-10','13:00:00',110,0,1,0,1,0,0),
(1020,15,1470,4,1,'2013-09-10','13:00:00',110,0,1,0,1,0,0),
(1030,16,1479,5,1,'2013-09-09','11:00:00',50,1,1,1,1,1,0),
(1031,16,1578,5,1,'2013-09-09','14:00:00',50,1,1,1,1,1,0),
(1156,37,1611,5,1,'2013-09-09','16:00:00',50,1,1,1,1,1,0),
(1162,37,1745,5,1,'2013-09-09','09:00:00',140,1,0,1,0,0,0),
(1168,37,1773,5,1,'2013-09-09','11:00:00',50,1,1,1,1,1,0),
(1180,38,1803,5,1,'2013-09-09','11:30:00',140,1,0,1,0,0,0),
(1183,38,1808,5,1,'2013-09-09','13:00:00',50,1,1,1,1,1,0),
(1184,38,1894,5,1,'2013-09-09','14:00:00',50,1,1,1,1,1,0),
(1196,39,1900,5,1,'2013-09-09','15:00:00',50,1,1,1,1,1,0),
(1500,33,1912,5,1,'2013-09-09','08:00:00',50,1,1,1,1,1,0),
(1502,34,2102,5,1,'2013-09-09','09:00:00',50,1,1,1,1,1,0),
(1560,35,2181,3,1,'2013-09-10','10:00:00',50,0,1,0,1,0,1),
(1562,36,2398,5,1,'2013-09-09','12:00:00',140,1,0,0,0,1,0),
(1642,29,2659,2,1,'2013-09-10','11:00:00',50,0,1,0,1,0,0),
(2001,20,2662,5,1,'2013-09-09','07:30:00',140,1,0,1,0,0,0),
(2005,20,2704,5,1,'2013-09-10','11:00:00',50,0,1,1,1,1,1),
(2015,21,2934,5,1,'2013-09-09','09:00:00',140,1,0,1,0,0,0),
(2051,22,3022,4,1,'2013-09-09','14:30:00',50,1,1,1,1,0,0),
(2071,50,3027,5,1,'2013-09-09','10:00:00',50,1,1,1,1,1,0),
(2075,51,3255,5,1,'2013-09-09','07:00:00',140,1,0,0,0,1,0),
(2089,52,3266,5,1,'2013-09-10','16:00:00',50,0,1,1,1,1,1),
(2103,53,3283,5,1,'2013-09-09','11:00:00',50,1,1,1,1,1,0),
(2213,17,3345,5,1,'2013-09-09','10:00:00',140,1,0,1,0,0,0),
(2223,18,3570,5,1,'2013-09-09','12:00:00',50,1,1,1,1,1,0),
(2245,19,3650,5,1,'2013-09-09','13:30:00',140,1,0,1,0,0,0),
(2410,23,3773,4,1,'2013-09-10','10:00:00',110,0,1,0,1,0,0),
(2420,24,3797,4,1,'2013-09-09','13:00:00',50,1,0,1,0,1,1),
(2430,25,3881,4,1,'2013-09-09','15:00:00',50,1,1,0,1,0,1),
(2431,27,3937,5,1,'2013-09-09','14:00:00',50,1,1,1,1,1,0),
(2451,27,3978,5,1,'2013-09-09','16:00:00',50,1,1,1,1,1,0),
(2500,1,4093,3,1,'2013-09-09','16:00:00',50,1,0,1,0,1,0),
(2510,2,4105,3,1,'2013-09-10','13:00:00',80,0,1,0,1,0,0),
(2520,3,4265,3,1,'2013-09-10','09:00:00',50,0,1,0,1,0,1),
(2633,48,4278,5,1,'2013-09-10','16:00:00',50,0,1,1,1,1,1),
(2639,49,4372,3,1,'2013-09-09','09:00:00',50,1,0,1,0,1,0),
(2647,49,4404,3,1,'2013-09-10','18:00:00',50,0,1,0,1,0,1),
(2889,45,4536,5,1,'2013-09-09','16:00:00',50,1,1,1,1,1,0),
(2891,45,4540,5,1,'2013-09-09','11:00:00',50,1,1,1,1,1,0),
(2895,45,4541,5,1,'2013-09-09','13:00:00',50,1,1,1,1,1,0),
(2907,46,4637,5,1,'2013-09-09','08:00:00',50,1,1,1,1,1,0),
(2911,46,4736,5,1,'2013-09-09','12:00:00',50,1,1,1,1,1,0),
(2915,46,4741,5,1,'2013-09-09','10:00:00',50,1,1,1,1,1,0),
(2917,47,4811,5,1,'2013-09-09','14:00:00',50,1,1,1,1,1,0),
(2925,47,4856,5,1,'2013-09-09','15:00:00',50,1,1,1,1,1,0),
(2933,47,5037,5,1,'2013-09-10','09:00:00',280,0,0,0,0,0,1),
(3030,30,5072,5,1,'2013-09-14','09:00:00',140,1,0,0,0,1,0),
(3031,30,5119,5,1,'2013-09-09','13:30:00',140,1,0,1,0,0,0),
(3040,31,5346,5,1,'2013-09-09','11:00:00',50,1,1,1,1,1,0),
(3045,31,5540,5,1,'2013-09-09','12:00:00',50,1,1,1,1,1,0),
(3050,32,5577,5,1,'2013-09-09','16:00:00',50,1,1,1,1,1,0),
(3055,32,5599,5,1,'2013-09-09','15:00:00',50,1,1,1,1,1,0),
(3065,40,5641,5,1,'2013-09-09','08:00:00',140,1,0,1,0,0,0),
(3070,42,5698,5,1,'2013-09-09','10:30:00',140,1,0,0,0,1,0),
(3082,44,5810,5,1,'2013-09-09','08:00:00',50,1,1,1,1,1,0),
(3085,43,5827,5,1,'2013-09-09','15:00:00',50,1,1,1,1,1,0),
(3090,44,5893,5,1,'2013-09-09','13:30:00',140,1,0,1,0,1,0),
(3115,54,5962,5,1,'2013-09-09','08:00:00',50,1,1,1,1,1,0),
(3120,54,6194,5,1,'2013-09-09','10:00:00',50,1,1,1,1,1,0),
(3123,56,6248,5,1,'2013-09-09','12:00:00',140,1,0,0,0,1,0),
(3600,41,6327,5,1,'2013-09-09','13:00:00',140,1,0,1,0,0,0),
(4000,11,6565,5,2,'2014-01-14','10:00:00',50,0,1,1,1,1,1),
(4002,12,6662,4,2,'2014-01-13','15:30:00',110,1,0,1,0,0,0),
(4004,13,6678,4,2,'2014-01-13','08:00:00',50,1,0,1,1,1,0),
(4006,13,6697,4,2,'2014-01-13','09:00:00',110,1,0,1,0,0,0),
(4012,14,6723,4,2,'2014-01-14','13:00:00',110,0,1,0,1,0,0),
(4020,15,6733,4,2,'2014-01-14','13:00:00',110,0,1,0,1,0,0),
(4030,16,6736,5,2,'2014-01-13','11:00:00',50,1,1,1,1,1,0),
(4031,16,7037,5,2,'2014-01-13','14:00:00',50,1,1,1,1,1,0),
(4156,37,7068,5,2,'2014-01-13','16:00:00',50,1,1,1,1,1,0),
(4162,37,7363,5,2,'2014-01-13','09:00:00',140,1,0,1,0,0,0),
(4168,37,7444,5,2,'2014-01-13','11:00:00',50,1,1,1,1,1,0),
(4180,38,7445,5,2,'2014-01-13','11:30:00',140,1,0,1,0,0,0),
(4183,38,7553,5,2,'2014-01-13','13:00:00',50,1,1,1,1,1,0),
(4184,38,7571,5,2,'2014-01-13','14:00:00',50,1,1,1,1,1,0),
(4196,39,7703,5,2,'2014-01-13','15:00:00',50,1,1,1,1,1,0),
(4500,33,7776,5,2,'2014-01-13','08:00:00',50,1,1,1,1,1,0),
(4502,34,7796,5,2,'2014-01-13','09:00:00',50,1,1,1,1,1,0),
(4560,35,7914,3,2,'2014-01-14','10:00:00',50,0,1,0,1,0,1),
(4562,36,7925,5,2,'2014-01-13','12:00:00',140,1,0,0,0,1,0),
(4642,29,8042,2,2,'2014-01-14','11:00:00',50,0,1,0,1,0,0),
(5001,20,8165,5,2,'2014-01-13','07:30:00',140,1,0,1,0,0,0),
(5005,20,8205,5,2,'2014-01-14','11:00:00',50,0,1,1,1,1,1),
(5015,21,8222,5,2,'2014-01-13','09:00:00',140,1,0,1,0,0,0),
(5051,22,8401,4,2,'2014-01-13','14:30:00',50,1,1,1,1,0,0),
(5071,50,8426,5,2,'2014-01-13','10:00:00',50,1,1,1,1,1,0),
(5075,51,8706,5,2,'2014-01-13','07:00:00',140,1,0,0,0,1,0),
(5089,52,8844,5,2,'2014-01-14','16:00:00',50,0,1,1,1,1,1),
(5103,53,9052,5,2,'2014-01-13','11:00:00',50,1,1,1,1,1,0),
(5213,17,9130,5,2,'2014-01-13','10:00:00',140,1,0,1,0,0,0),
(5223,18,9167,5,2,'2014-01-13','12:00:00',50,1,1,1,1,1,0),
(5245,19,9176,5,2,'2014-01-13','13:30:00',140,1,0,1,0,0,0),
(5410,23,9216,4,2,'2014-01-14','10:00:00',110,0,1,0,1,0,0),
(5420,24,9382,4,2,'2014-01-13','13:00:00',50,1,0,1,0,1,1),
(5430,25,9463,4,2,'2014-01-13','15:00:00',50,1,1,0,1,0,1),
(5431,27,9700,5,2,'2014-01-13','14:00:00',50,1,1,1,1,1,0),
(5451,27,9709,5,2,'2014-01-13','16:00:00',50,1,1,1,1,1,0),
(5500,1,9772,3,2,'2014-01-13','16:00:00',50,1,0,1,0,1,0),
(5510,2,9858,3,2,'2014-01-14','13:00:00',80,0,1,0,1,0,0),
(5520,3,1012,3,2,'2014-01-14','09:00:00',50,0,1,0,1,0,1),
(5633,48,1185,5,2,'2014-01-14','16:00:00',50,0,1,1,1,1,1),
(5639,49,1194,3,2,'2014-01-13','09:00:00',50,1,0,1,0,1,0),
(5647,49,1203,3,2,'2014-01-14','18:00:00',50,0,1,0,1,0,1),
(5889,45,1418,5,2,'2014-01-13','16:00:00',50,1,1,1,1,1,0),
(5891,45,1470,5,2,'2014-01-13','11:00:00',50,1,1,1,1,1,0),
(5895,45,1479,5,2,'2014-01-13','13:00:00',50,1,1,1,1,1,0),
(5907,46,1578,5,2,'2014-01-13','08:00:00',50,1,1,1,1,1,0),
(5911,46,1611,5,2,'2014-01-13','12:00:00',50,1,1,1,1,1,0),
(5915,46,1745,5,2,'2014-01-13','10:00:00',50,1,1,1,1,1,0),
(5917,47,1773,5,2,'2014-01-13','14:00:00',50,1,1,1,1,1,0),
(5925,47,1803,5,2,'2014-01-13','15:00:00',50,1,1,1,1,1,0),
(5933,47,1808,5,2,'2014-01-18','09:00:00',280,0,0,0,0,0,1),
(6030,30,1894,5,2,'2014-01-13','09:00:00',140,1,0,0,0,1,0),
(6031,30,1900,5,2,'2014-01-13','13:30:00',140,1,0,1,0,0,0),
(6040,31,1912,5,2,'2014-01-13','11:00:00',50,1,1,1,1,1,0),
(6045,31,2102,5,2,'2014-01-13','12:00:00',50,1,1,1,1,1,0),
(6050,32,2181,5,2,'2014-01-13','16:00:00',50,1,1,1,1,1,0),
(6055,32,2398,5,2,'2014-01-13','15:00:00',50,1,1,1,1,1,0),
(6065,40,2659,5,2,'2014-01-13','08:00:00',140,1,0,1,0,0,0),
(6070,42,2662,5,2,'2014-01-13','10:30:00',140,1,0,0,0,1,0),
(6082,44,2704,5,2,'2014-01-13','08:00:00',50,1,1,1,1,1,0),
(6085,43,2934,5,2,'2014-01-13','15:00:00',50,1,1,1,1,1,0),
(6090,44,3022,5,2,'2014-01-13','13:30:00',140,1,0,1,0,1,0),
(6115,54,3027,5,2,'2014-01-13','08:00:00',50,1,1,1,1,1,0),
(6120,54,3255,5,2,'2014-01-13','10:00:00',50,1,1,1,1,1,0),
(6123,56,3266,5,2,'2014-01-13','12:00:00',140,1,0,0,0,1,0),
(6600,41,3283,5,2,'2014-01-13','13:00:00',140,1,0,1,0,0,0);

#faculty_classes

INSERT into Faculty_Classes values
(1000,114595),
(1002,125595),
(1004,133163),
(1006,134670),
(1012,138624),
(1020,168857),
(1030,169365),
(1031,175125),
(1156,184260),
(1162,196557),
(1168,201506),
(1180,206427),
(1183,232618),
(1184,240338),
(1196,242634),
(1500,246736),
(1502,271785),
(1560,271820),
(1562,280941),
(1642,325868),
(2001,333324),
(2005,353908),
(2015,357968),
(2051,369893),
(2071,372096),
(2075,410413),
(2089,410918),
(2103,418420),
(2213,423398),
(2223,423522),
(2245,430546),
(2410,438123),
(2420,449901),
(2430,454493),
(2431,469799),
(2451,472467),
(2500,476100),
(2510,476789),
(2520,480856),
(2633,500587),
(2639,507184),
(2647,508242),
(2889,508314),
(2891,516465),
(2895,538421),
(2907,572132),
(2911,572796),
(2915,573089),
(2917,573623),
(2925,616644),
(2933,624640),
(3030,632540),
(3031,633596),
(3040,634582),
(3045,635586),
(3050,639998),
(3055,672641),
(3065,688905),
(3070,736890),
(3082,754974),
(3085,760362),
(3090,760609),
(3115,766698),
(3120,782822),
(3123,784101),
(3600,795236),
(4000,803872),
(4002,817422),
(4004,826824),
(4006,843331),
(4012,846275),
(4020,861380),
(4030,886140),
(4031,904131),
(4156,917848),
(4162,932068),
(4168,937233),
(4180,940853),
(4183,987884),
(4184,996025),
(4196,114595),
(4500,125595),
(4502,133163),
(4560,134670),
(4562,138624),
(4642,168857),
(5001,169365),
(5005,175125),
(5015,184260),
(5051,196557),
(5071,201506),
(5075,206427),
(5089,232618),
(5103,240338),
(5213,242634),
(5223,246736),
(5245,271785),
(5410,271820),
(5420,280941),
(5430,325868),
(5431,333324),
(5451,353908),
(5500,357968),
(5510,369893),
(5520,372096),
(5633,410413),
(5639,410918),
(5647,418420),
(5889,423398),
(5891,423522),
(5895,430546),
(5907,438123),
(5911,449901),
(5915,454493),
(5917,469799),
(5925,472467),
(5933,476100),
(6030,476789),
(6031,480856),
(6040,500587),
(6045,507184),
(6050,508242),
(6055,508314),
(6065,516465),
(6070,538421),
(6082,572132),
(6085,572796),
(6090,573089),
(6115,573623),
(6120,616644),
(6123,624640),
(6600,632540);


#class_registration_status

INSERT into class_registration_status values
(1,'Registration Successful'),
(2,'In waitlist '),
(3,'Registration unsuccessful,class is closed'),
(4,'Registration unsuccessful,waitlist is full'),
(5,'Registration unsuccessful due to academic hold');

INSERT into Class_Registration values
(12981,1000,1,44),
(13119,1002,1,74),
(13544,1004,1,80),
(14323,1006,1,44),
(14342,1012,1,95),
(15597,1020,1,61),
(16462,1030,1,90),
(18284,1031,2,92),
(18339,1156,1,57),
(19402,1162,1,91),
(19569,1168,1,84),
(20075,1180,3,80),
(20129,1183,1,66),
(22318,1184,1,54),
(23218,1196,1,76),
(23721,1500,1,83),
(23746,1502,3,41),
(24025,1560,1,80),
(24821,1562,1,69),
(26240,1642,1,73),
(27252,2001,1,66),
(27478,2005,1,78),
(28086,2015,1,83),
(29067,2051,1,94),
(30453,2071,4,99),
(31461,2075,1,100),
(32445,2089,1,91),
(34570,2103,1,92),
(34611,2213,1,44),
(34711,2223,1,69),
(37784,2245,2,60),
(39318,2410,1,97),
(42389,2420,1,22),
(42570,2430,1,86),
(42597,2431,3,98),
(44439,2451,1,84),
(45676,2500,1,46),
(48063,2510,1,76),
(48265,2520,1,54),
(50010,2633,1,46),
(50534,2639,1,42),
(51020,2647,1,94),
(51318,2889,1,53),
(51363,2891,1,54),
(51684,2895,1,88),
(52118,2907,1,86),
(52511,2911,1,55),
(53328,2915,4,81),
(53839,2917,1,58),
(53984,2925,1,64),
(54846,2933,1,42),
(54933,3030,1,98),
(55175,3031,1,62),
(57675,3040,1,51),
(59111,3045,1,94),
(59788,3050,1,78),
(60056,3055,1,91),
(60568,3065,1,83),
(61192,3070,1,70),
(62589,3082,1,74),
(63271,3085,1,73),
(63924,3090,1,83),
(65327,3115,1,69),
(66510,3120,1,40),
(67316,3123,5,88),
(67767,3600,1,85),
(67774,4000,1,62),
(68786,4002,1,52),
(68982,4004,1,95),
(69229,4006,1,92),
(70635,4012,1,78),
(70751,4020,1,95),
(71037,4030,1,94),
(72603,4031,1,84),
(72900,4156,1,56),
(73429,4162,3,63),
(73977,4168,1,74),
(75593,4180,1,61),
(76426,4183,1,59),
(79433,4184,1,91),
(80135,4196,1,96),
(82067,4500,1,43),
(82930,4502,1,88),
(83158,4560,1,43),
(83161,4562,2,63),
(86931,4642,1,76),
(87846,5001,1,62),
(88399,5005,1,49),
(89017,5015,1,100),
(91462,5051,1,72),
(91858,5071,1,57),
(92063,5075,1,87),
(93073,5089,1,92),
(93125,5103,1,53),
(93230,5213,1,75),
(94522,5223,1,54),
(94768,5245,4,63),
(95039,5410,1,45),
(96862,5420,1,98),
(96905,5430,1,54),
(98274,5431,1,85);


INSERT INTO Bursar_Tuition VALUES
(7161,15597,9061,'Variable-I',10000),
(3804,55175,10418,'Guaranteed-I',0),
(4125,42389,19072,'International',0),
(1599,14323,19072,'International',0),
(7144,51318,11082,'Variable-O',10000),
(3198,27478,9061,'Variable-I',0),
(4962,63924,10418,'Guaranteed-I',10000),
(7017,23218,12532,'Guaranteed-O',10000),
(8340,50534,10418,'Guaranteed-I',0),
(3526,86931,19072,'International',10000),
(1287,23746,12532,'Guaranteed-O',0),
(6970,37784,11082,'Variable-O',10000),
(8720,27252,12532,'Guaranteed-O',0),
(1334,70751,10418,'Guaranteed-I',0),
(3821,91462,19072,'International',0),
(7335,24025,19072,'International',10000),
(4277,63271,12532,'Guaranteed-O',10000),
(5498,65327,12532,'Guaranteed-O',10000),
(5258,42570,9061,'Variable-I',0),
(8085,66510,12532,'Guaranteed-O',10000),
(7011,69229,19072,'International',0),
(6192,70635,10418,'Guaranteed-I',0),
(3817,79433,19072,'International',0),
(8438,51363,10418,'Guaranteed-I',0),
(7800,80135,9061,'Variable-I',10000),
(1664,67774,10418,'Guaranteed-I',0),
(5575,95039,19072,'International',10000),
(4128,13119,12532,'Guaranteed-O',0),
(2142,89017,10418,'Guaranteed-I',10000),
(8372,48265,10418,'Guaranteed-I',10000),
(7338,98274,19072,'International',10000),
(8097,87846,11082,'Variable-O',10000),
(5611,30453,19072,'International',0),
(8826,19402,10418,'Guaranteed-I',0),
(3550,18339,12532,'Guaranteed-O',0),
(9801,12981,19072,'International',0),
(1073,59111,19072,'International',0),
(2256,94768,11082,'Variable-O',0),
(2564,34570,10418,'Guaranteed-I',0),
(2311,96905,19072,'International',0),
(1615,31461,10418,'Guaranteed-I',10000),
(7648,71037,10418,'Guaranteed-I',10000),
(2083,59788,10418,'Guaranteed-I',0),
(2826,96862,10418,'Guaranteed-I',0),
(8384,44439,19072,'International',0),
(9626,83161,19072,'International',0),
(3703,23721,19072,'International',0),
(7986,82930,19072,'International',0),
(9373,39318,11082,'Variable-O',0),
(8715,62589,10418,'Guaranteed-I',10000),
(3461,82067,11082,'Variable-O',0),
(7568,93073,9061,'Variable-I',0),
(2825,53984,19072,'International',0),
(9909,52118,9061,'Variable-I',0),
(7579,68786,12532,'Guaranteed-O',0),
(3390,60056,19072,'International',0),
(9510,34611,11082,'Variable-O',10000),
(5877,26240,11082,'Variable-O',0),
(2545,60568,10418,'Guaranteed-I',10000),
(2483,94522,11082,'Variable-O',0),
(6644,92063,19072,'International',10000),
(7552,54846,11082,'Variable-O',0),
(6467,88399,10418,'Guaranteed-I',10000),
(4984,51684,19072,'International',10000),
(9869,67767,11082,'Variable-O',10000),
(7668,76426,10418,'Guaranteed-I',10000),
(9054,14342,19072,'International',10000),
(5025,45676,19072,'International',0),
(6207,20075,9061,'Variable-I',10000),
(8056,18284,9061,'Variable-I',0),
(4834,48063,11082,'Variable-O',10000),
(8616,52511,9061,'Variable-I',0),
(1880,72603,9061,'Variable-I',10000),
(5436,20129,11082,'Variable-O',0),
(3018,54933,19072,'International',0),
(3140,73977,12532,'Guaranteed-O',0),
(1096,32445,19072,'International',10000),
(2912,53328,19072,'International',0),
(2392,83158,10418,'Guaranteed-I',0),
(6670,42597,10418,'Guaranteed-I',10000),
(2504,29067,11082,'Variable-O',10000),
(5167,73429,19072,'International',0),
(5908,51020,19072,'International',0),
(5725,24821,19072,'International',10000),
(4024,57675,12532,'Guaranteed-O',10000),
(9127,93125,12532,'Guaranteed-O',10000),
(5654,68982,11082,'Variable-O',10000),
(9844,93230,10418,'Guaranteed-I',0),
(5147,75593,10418,'Guaranteed-I',10000),
(9687,28086,19072,'International',10000),
(2289,13544,9061,'Variable-I',10000),
(2508,91858,11082,'Variable-O',0),
(2134,16462,9061,'Variable-I',0),
(4312,67316,11082,'Variable-O',0),
(8808,53839,10418,'Guaranteed-I',0),
(3532,22318,11082,'Variable-O',0),
(3116,34711,19072,'International',0),
(1548,72900,11082,'Variable-O',0),
(7532,19569,19072,'International',10000),
(6260,50010,19072,'International',10000),
(7046,61192,19072,'International',0);

#Bursar_Tuition_Fee_Payment

INSERT INTO Bursar_Tuition_Fee_Payment VALUES
(9909,1,'Wire Transfer',0),
(8056,1,'Check',0),
(7552,1,'Money order',0),
(8720,1,'eCheck',0),
(3526,1,'Check',0),
(1599,1,'Check',0),
(8808,0,'Demand Draft',0),
(2483,1,'Wire Transfer',0),
(1287,1,'Demand Draft',0),
(3140,1,'Check',0),
(5908,1,'Demand Draft',0),
(6644,1,'eCheck',0),
(7568,1,'Check',0),
(6260,1,'Credit Card',0),
(7011,1,'Credit Card',0),
(3390,1,'Money order',0),
(3703,1,'Demand Draft',2000),
(2564,1,'Credit Card',1100),
(9054,1,'eCheck',0),
(9626,1,'Check',2000),
(7668,1,'Wire Transfer',0),
(4962,1,'eCheck',0),
(9373,1,'eCheck',0),
(7648,1,'Wire Transfer',2000),
(1615,1,'Demand Draft',2000),
(5025,1,'Money order',0),
(5654,1,'Credit Card',1100),
(7532,1,'Money order',0),
(6670,1,'Money order',0),
(2826,1,'Money order',2000),
(1334,1,'Money order',0),
(3018,1,'Credit Card',0),
(8384,1,'Credit Card',2000),
(5147,1,'Demand Draft',2000),
(9801,1,'Wire Transfer',1100),
(7579,1,'eCheck',0),
(5498,0,'Wire Transfer',0),
(3804,1,'Money order',0),
(1096,1,'Demand Draft',0),
(8372,1,'Wire Transfer',1100),
(9687,1,'Wire Transfer',2000),
(1664,1,'Money order',1100),
(7017,1,'Money order',0),
(2083,1,'eCheck',2000),
(7986,1,'Wire Transfer',2000),
(8715,1,'Money order',0),
(2912,1,'Wire Transfer',0),
(4834,1,'Demand Draft',0),
(5575,1,'Credit Card',1100),
(4024,1,'eCheck',0),
(2311,1,'Check',2000),
(4312,0,'Check',2000),
(3461,1,'Credit Card',0),
(6970,1,'Wire Transfer',0),
(8097,1,'Money order',1100),
(7144,1,'Demand Draft',0),
(9844,1,'Check',1100),
(5725,1,'Wire Transfer',0),
(8438,1,'Wire Transfer',0),
(2256,1,'Money order',1100),
(3821,1,'Credit Card',2000),
(3198,1,'Wire Transfer',0),
(2392,1,'eCheck',0),
(4277,0,'Demand Draft',0),
(2545,1,'Demand Draft',0),
(1073,1,'eCheck',1100),
(5436,1,'Money order',0),
(5167,1,'Check',0),
(7335,0,'Check',1100),
(2825,1,'Demand Draft',0),
(2508,0,'Money order',2000),
(4984,1,'Check',0),
(1880,1,'eCheck',0),
(2142,1,'Demand Draft',1100),
(6467,1,'Credit Card',0),
(6207,1,'Credit Card',0),
(7046,1,'Check',0),
(5877,1,'Check',0),
(4128,1,'Check',1100),
(5258,0,'eCheck',0),
(8826,1,'Check',1100),
(3817,1,'Demand Draft',0),
(3116,1,'Wire Transfer',0),
(9869,1,'Demand Draft',0),
(8616,1,'Wire Transfer',0),
(8340,1,'Credit Card',0),
(4125,1,'Credit Card',0),
(1548,1,'eCheck',0),
(7800,1,'eCheck',0),
(3550,1,'Demand Draft',1100),
(8085,1,'Money order',0),
(9510,1,'Credit Card',0),
(2134,0,'Credit Card',2000),
(9127,1,'Money order',1100),
(5611,1,'Credit Card',1100),
(7338,1,'eCheck',1100),
(3532,0,'Wire Transfer',0),
(7161,1,'eCheck',0),
(6192,1,'Check',0),
(2504,1,'Credit Card',0),
(2289,1,'eCheck',2000);

#Student_Organizations

INSERT into Student_Organizations values
(1,'Accessible Prosthetics Initiative UT Dallas Chapter',44,114595,12981),
(2,'Accounting Leadership Association',74,125595,13119),
(3,'Active Minds at UT Dallas',80,133163,13544),
(4,'Actuarial Student Association',44,134670,14323),
(5,'Advancements in Modern Medicine',95,138624,14342),
(6,'Advancements of Indian Opportunity',61,168857,15597),
(7,'AdventHope at UTD',90,169365,16462),
(8,'African Student Union',92,175125,18284),
(9,'Agaram Tamil Student Organization',57,184260,18339),
(10,'Ahlul Bayt Student Association',91,196557,19402),
(11,'Big Data Club',84,201506,19569),
(12,'Biochemistry Association',80,206427,20075),
(13,'Biomedical Engineering Graduate Student Assembly ',66,232618,20129),
(14,'Biomedical Engineering Society',54,240338,22318),
(15,'Black Graduate Student Association',76,242634,23218),
(16,'Black Student Alliance ',83,246736,23721),
(17,'Christian Students on Campus',41,271785,23746),
(18,'Circle K International',80,271820,24025),
(19,'Citizens Climate Lobby at the University of Texas at Dallas',69,280941,24821),
(20,'Citizens Climate Lobby UTD',73,325868,26240),
(21,'Cloud Computing Club',66,333324,27252),
(22,'Club Golf',78,353908,27478),
(23,'Club Improv',83,357968,28086),
(24,'Club Nine and Three-Quarters',94,369893,29067),
(25,'Code.exe',99,372096,30453),
(26,'College Democrats at UTD',100,410413,31461),
(27,'College Diabetes Network at UTD',91,410918,32445),
(28,'College Life',92,418420,34570),
(29,'Dallas Formula Racing',44,423398,34611),
(30,'Dallas Musical Outreach',69,423522,34711),
(31,'Dallas Students Democracy',60,430546,37784),
(32,'Data Science Club',97,438123,39318),
(33,'Dauntless',22,449901,42389),
(34,'DECA',86,454493,42570),
(35,'Deeds Not Words',98,469799,42597),
(36,'Delta Delta Delta',84,472467,44439),
(37,'Delta Epsilon Psi',46,476100,45676),
(38,'Delta Kappa Delta Sorority',76,476789,48063),
(39,'Delta Kappa Delta Sorority, Inc.',54,480856,48265),
(40,'Delta Sigma Pi - Chi Psi Chapter',46,500587,50010),
(41,'FeelGood UTD',42,507184,50534),
(42,'Fellowship of Christian University Students',94,508242,51020),
(43,'Female Leaders of America in Science and Health',53,508314,51318),
(44,'Filipino Student Association',54,516465,51363),
(45,'Finance Management Council',88,538421,51684),
(46,'Financial Leadership Association',86,572132,52118),
(47,'FinTech UTD',55,572796,52511),
(48,'First Love Fellowship',81,573089,53328),
(49,'Fit Life UTD',58,573623,53839),
(50,'GDI Club',64,616644,53984),
(51,'GeoClub',42,624640,54846),
(52,'Geophysical Society',98,632540,54933),
(53,'Geospatial Information Sciences Student Organization',62,633596,55175),
(54,'Girls Who Code',51,634582,57675),
(55,'Global BrainHealth & Wellness Initiative',94,635586,59111),
(56,'Global Business Organization',78,639998,59788),
(57,'Global Medical and Dental Brigades ',91,672641,60056),
(58,'Global Medical Missions Alliance',83,688905,60568),
(59,'Global Mobility Club',70,736890,61192),
(60,'Healthcare Management Association',74,754974,62589),
(61,'Hearts for the Homeless',73,760362,63271),
(62,'Helping Hands',83,760609,63924),
(63,'Helping Hearts UTD',69,766698,65327),
(64,'Heroes United FC',40,782822,66510),
(65,'Hillel ',88,784101,67316),
(66,'Hindu YUVA',85,795236,67767),
(67,'Horror-Fi Reads',62,803872,67774),
(68,'IEEE Solid-State Circuit Society (SSCS)',52,817422,68786),
(69,'IGNITE at The University of Texas at Dallas',95,826824,68982),
(70,'IMA Student Chapter at The University of Texas at Dallas',92,843331,69229),
(71,'Immigrant Rights Coalition',78,846275,70635),
(72,'Impact Dallas',95,861380,70751),
(73,'Indian Cultural Association UTD',94,886140,71037),
(74,'Lemon Club at UT Dallas',84,904131,72603),
(75,'Lemon Club at UT Dallas ',56,917848,72900),
(76,'Life Skills at UTD',63,932068,73429),
(77,'Living Water Student Fellowship',74,937233,73977),
(78,'Magic UTD',61,940853,75593),
(79,'Making Healthcare Affordable',59,987884,76426),
(80,'Malankara Orthodox Christian Student Movement',91,996025,79433),
(81,'MannMukti ',96,114595,80135),
(82,'Mantra Lounge',43,125595,82067),
(83,'Marketing Analytics Club',88,133163,82930),
(84,'Math Club',43,134670,83158),
(85,'MBAs for Christ',63,138624,83161),
(86,'MCAT Support',76,168857,86931),
(87,'Medical City Dallas Volunteers Club',62,169365,87846),
(88,'SAP Users Group',49,175125,88399),
(89,'School of Behavioral and Brain Sciences',100,184260,89017),
(90,'School of Interdisciplinary Studies',72,196557,91462),
(91,'The Association of International Petroleum Negotiators (AIPN) UTD Student Club',57,201506,91858),
(92,'The Association of Women in Psychology',87,206427,92063),
(93,'The Association of Women in Psychology (TAWP)',92,232618,93073),
(94,'The Big Data Club',53,240338,93125),
(95,'Vietnamese Student Association',75,242634,93230),
(96,'Wind Energy Club',54,246736,94522),
(97,'UTD Financial Literacy Club',63,271785,94768),
(98,'UTD geophysical society',45,271820,95039),
(99,'YWISE Alumni Chapter',98,280941,96862),
(100,'Writing Without Purpose',54,325868,96905),
(101,'XR UTD',85,333324,98274);

#CAMPUS_DINING

INSERT INTO CAMPUS_DINING VALUES
(101,'The Market','Engineering and Computer Science West','Comet 19: 6.97$,','139-562-2981',206427,15,9),
(102,'The Market','Naveen Jindal School of Management','Comet 19: 6.97$','134-389-2389',232618,15,9),
(103,'Einstein Bros Bagels','Parking Structure 3','Comet 19: 6.97$','953-248-1894',240338,25,8),
(104,'Taco Bell','Parking Structure 4','Comet 19: 6.97$','109-248-1914',242634,18,10),
(105,'Dining Hall West','Residence Hall West','Comet 14 : 8.11$','921-489-1188',246736,20,8),
(106,'Papa Johns','Residence Hall West','Comet 10: 10.43$','893-189-2692',271785,35,9),
(107,'Chick-Fil-A','Student Union','Comet 10: 10.43$','892-641-3892',271820,40,11),
(110,'Moe','Student Union','Comey 10: 10.43$','682-298-8924',280941,20,8),
(111,'Panda Express','Student Union','Comet 10: 10.43$','756-242-7463',325868,16,11),
(112,'Smoothie King','Student Union','Comet 10: 10.43$','459-986-1586',333324,30,9),
(113,'Starbucks','Student Union','Comet 10: 10.43$','576-973-2434',353908,45,7),
(114,'The Halal Shack','Student Union','Comet 19: 6.97$','988-646-5232',357968,10,9);

#Complex Reports

#Report of students and their courses

SELECT CONCAT(Students.StudFirstName,' ',Students.StudLastName) AS Student_Name, Courses.CourseName from Students
INNER JOIN Class_Registration ON Students.StudID = Class_Registration.StudentID
INNER JOIN Classes ON Class_Registration.ClassID = Classes.ClassID
INNER JOIN Courses ON Classes.CourseID = Courses.CourseID;

#Report of students and staff details living in a particular state (UNION)

SELECT StudID AS ID, StudFirstName AS FName, StudLastName AS LName, StudStreetAddress AS Address, StudCity AS City, StudState AS State, StudZipCode AS ZipCode, StudPhoneNumber AS PhoneNumber FROM Students WHERE StudState = 'TX'
UNION
SELECT EmpID, EmpFirstName, EmpLastName, EmpStreetAddress, EmpCity, EmpState, EmpZipCode, EmpPhoneNumber FROM Employees WHERE EmpState = 'TX';

#Display students enrolled in a class on friday 

SELECT StudID, StudFirstName, StudLastName FROM Students WHERE StudID in (
SELECT cr.StudentID
FROM Class_Registration AS cr
INNER JOIN Classes AS c ON c.ClassID = cr.ClassID
WHERE c.FridaySchedule=1);

#Display the list of classes along with the associated faculty for courses 

Select Classes.ClassID, Classes.CourseID, Courses.CourseName,Employees.EmpID, CONCAT(Employees.EmpFirstName,' ',Employees.EmpLastname) AS Faculty_Name From Classes
INNER JOIN Courses ON Classes.CourseID = Courses.CourseID
INNER JOIN Faculty_Classes ON Classes.ClassID = Faculty_Classes.ClassID
INNER JOIN Employees ON Faculty_Classes.EmpID = Employees.EmpID;
	
#Display the students tuition rate for students who have taken a valid parking permit with the university 

Select s.StudID, CONCAT(s.StudFirstName,' ',s.StudLastName) AS Student_Name, s.StudPhoneNumber,bt.Tuition_Estimate FROM students s
inner join transport_permits tp on s.StudPhoneNumber = tp.DriverPhoneNumber
inner join bursar_tuition bt on bt.StudentID = s.StudID
where year(tp.ExpDate) >='2022';


#Display student leader details of all the organizations at the university 


Select so.Organization_Name, so.Student_leader,concat(s.StudFirstName,' ',s.studLastName) as StudName  from student_organizations so
inner join students s on s.StudID = so.Student_leader;


#Display a list of each staff member and a count of classes each staff member is scheduled to teach

SELECT ts.EmpID, emp.EmpFirstName, emp.EmpLastName,
COUNT(fc.ClassID) AS classes_count
FROM (Teaching_Staff AS ts
INNER JOIN Employees AS emp on emp.EmpID=ts.EmpID)
LEFT JOIN Faculty_Classes as fc on fc.EmpID=emp.EmpID
GROUP BY ts.EmpID, emp.EmpFirstName, emp.EmpLastName;

#For completed classes, list by category and student the category ID, the student name, and the student’s average grade of all classes taken in that category

SELECT Courses.CategoryID,Students.StudFirstName,Students.StudLastName, AVG(Class_Registration.Grade) AS AvgGrade 
FROM (((Courses 
INNER JOIN Classes 
ON Courses.CourseID = Classes.CourseID)
INNER JOIN Class_Registration
ON Classes.ClassID = Class_Registration.ClassID)
INNER JOIN Class_Registration_Status
ON Class_Registration_Status.ClassStatus = Class_Registration.ClassStatus)
INNER JOIN Students
ON Students.StudID = Class_Registration.StudentID
WHERE Class_Registration_Status.ClassStatusDescription = 'Registration Successful'
GROUP BY Courses.CategoryID, Students.StudFirstName, Students.StudLastName;

#List the last name and first name of each staff member who has been with the university for more than 10 years
SELECT EmpLastName, EmpFirstName
FROM Employees
WHERE DateHired IN
(SELECT DateHired FROM Employees WHERE 2022 - year(DateHired) > 10);

#Number of Classes each student is enrolled in

SELECT CONCAT(Students.StudFirstName,' ',Students.StudLastName) AS Student_Name,
(SELECT count(ClassID) FROM Class_Registration WHERE Students.StudId = Class_Registration.StudentID) AS Number_of_Classes FROM Students;

#Display the class details of classes held in a specific building or classroom. 

SELECT Classes.ClassID,Courses.CourseName,Classes.ClassRoomID,Classrooms.BuildingCode
FROM Classes
INNER JOIN
ClassRooms  ON Classes.ClassRoomID = Classrooms.ClassRoomID
INNER JOIN
Courses ON Classes.CourseID = Courses.CourseID;

#Stored Functions
#PermitType from payment 

USE UniversityDB;

Delimiter $$

Create Function PermitType (
	 payment DECIMAL (10,2)
)
Returns VARCHAR(20)
DETERMINISTIC
Begin
	Declare permit_type VARCHAR(20);
    
    IF payment = 250 Then 
		Set permit_type = "Green";
	ELSEIF payment = 350 Then 
		set  permit_type = "Yellow";
	ELSEIF payment = 450 Then 
		set permit_type = "Orange";
	ELSEIF payment = 550 Then 
		set permit_type = "Purple";
	Else
		set permit_type = "Does Not Exist";
	END IF;
    
		RETURN (permit_type);
END$$
Delimiter ;

SELECT  PermitID, PermitType(Payment) AS Permit_Type,DriverFName,DriverLName FROM Transport_permits;

#ScholarshipAmount Derivation from Tuition Estimate(25% scholarship of estimate)

Delimiter $$

Create Function ScholarshipAmount (
	 Tuition_Estimate Double
)
Returns DECIMAL(10,2)
DETERMINISTIC
Begin
	Declare ScholarshipAmount DECIMAL(10,2);
    
    SET ScholarshipAmount=Tuition_Estimate*0.25;
    
		RETURN (ScholarshipAmount);
END$$
Delimiter ;

SELECT bt.StudentID, s.StudFirstName,s.StudLastName, ScholarshipAmount(bt.Tuition_Estimate) AS Scholarship_Amount 
FROM Bursar_Tuition AS bt INNER JOIN Students AS s ON s.StudID=bt.StudentID;

SELECT bt.StudentID, s.StudFirstName,s.StudLastName, ScholarshipAmount(bt.Tuition_Estimate) AS Scholarship_Amount 
FROM Bursar_Tuition AS bt INNER JOIN Students AS s ON s.StudID=bt.StudentID
WHERE s.StudID=23746;

#Get Grade based on Marks obtained
DELIMITER $$

CREATE FUNCTION Get_Grade(
       Marks INT
       )
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
     DECLARE Grade VARCHAR(10);
     
     IF Marks >= 93 AND Marks < 100 Then 
		Set Grade = "A";
	ELSEIF Marks >= 89 AND Marks < 93 Then 
		set  Grade = "A-";
	ELSEIF Marks >= 85 AND Marks < 89 Then 
		set Grade = "B";
	ELSEIF Marks >= 80 AND Marks < 85 Then 
		set Grade = "B-";
	ELSEIF Marks >= 75 AND Marks < 80 Then 
		set Grade = "C";
	Else
		set Grade = "F";
	END IF;
    
    RETURN (Grade);
     
END $$
DELIMITER ;

#Net Employee salary after tax deductions

Delimiter $$

Create Function Net_Salary_After_Deductions(
	 Salary INT
)
Returns DECIMAL(10,2)
DETERMINISTIC
Begin
	Declare Net_Salary DECIMAL(10,2);
    
    SET Net_Salary=Salary - (Salary*0.16);
    
RETURN (Net_Salary);
END$$
Delimiter ;

SELECT e.EmpID,CONCAT(e.EmpFirstName,' ',e.EmpLastname), Net_Salary_After_Deductions(e.Salary) AS Net_Salary
FROM Employees AS e;

#Determining seniority of faculty

Delimiter $$

Create Function Get_Faculty_Seniority_Status(
	 Date_of_joining DATE
)
Returns VARCHAR(30)
DETERMINISTIC
Begin
	Declare Seniority_Status VARCHAR(30);
    IF (year(NOW()) - year(Date_of_joining)) >= 15  Then 
		Set Seniority_Status = "Tenured";
	Else
		set Seniority_Status = "Not Tenured";
	END IF;
    RETURN (Seniority_Status);
END$$
Delimiter ;

SELECT e.EmpID,CONCAT(e.EmpFirstName,' ',e.EmpLastname), Get_Faculty_Seniority_Status(e.DateHired) AS Seniority_Status
FROM Employees AS e;

#Stored Procedures
#Amount Owed Based on Student ID(Invoking Function Inside procedure)

DELIMITER $$
Create Procedure GetOwedAmount(
	IN ID INT,
    OUT OwedAmount DECIMAL(10,2)
    )
BEGIN
DECLARE Tuition_Est Double;
    	DECLARE Schol_Amount DECIMAL(10,2);
    	DECLARE paymentstatus bit(1);
    	DECLARE Refund Double;
    
    SELECT Tuition_Estimate INTO Tuition_Est FROM Bursar_Tuition WHERE StudentID = ID;
    
    SELECT bf.Payment_status INTO paymentstatus
    FROM Bursar_Tuition_Fee_Payment AS bf
    INNER JOIN Bursar_Tuition AS bt USING(BursarID)
    WHERE bt.StudentID = ID;
	
    SELECT bf.Refund INTO Refund
    FROM Bursar_Tuition_Fee_Payment AS bf
    INNER JOIN Bursar_Tuition AS bt USING(BursarID)
    WHERE bt.StudentID = ID;
    
    SET  Schol_Amount = ScholarshipAmount(Tuition_Est);
    
    IF paymentstatus=1 THEN 
		SET OwedAmount = 0;
	ELSE
		SET OwedAmount = Tuition_Est-Refund-Schol_Amount;
    END IF;
    
END$$

DELIMITER ;

CALL GetOwedAmount(23746,@OwedAmount);
SELECT @OwedAmount;

CALL GetOwedAmount(53839,@OwedAmount);
SELECT @OwedAmount;

#Student verification by any department whenever calling helpline desks for each department. 

DELIMITER $$
Create Procedure StudentVerification(
	IN ID INT
    )
BEGIN
    
    SELECT * FROM Students WHERE StudID = ID;
    
END$$

DELIMITER ;

CALL StudentVerification(13544);

#Generate Email Addresses for Employees and Students associated with the University based on ID (email ID will be concatenation of ID, first name and last name)

DELIMITER $$

Create Procedure GetEmailID(
	IN ID INT,
    OUT EmailID VARCHAR(50)
    )
BEGIN
    DECLARE fname VARCHAR(30);
    DECLARE lname VARCHAR(30);
    
    IF ID IN (SELECT StudID FROM Students) THEN 
		SELECT StudFirstName INTO fname FROM Students WHERE StudID = ID;
	ELSE 
		SELECT EmpFirstName INTO fname FROM Employees WHERE EmpID = ID; 
	END IF; 
    
    IF ID IN (SELECT StudID FROM Students) THEN 
		SELECT StudLastName INTO lname FROM Students WHERE StudID = ID;
	ELSE 
		SELECT EmpLastName INTO lname FROM Employees WHERE EmpID = ID; 
	END IF; 
    
    SET EmailID= CONCAT(LEFT(fname,3),LEFT(lname,3),RIGHT(ID,3),"@university.edu");
    
END$$

DELIMITER ;

CALL GetEmailID(13544,@email);
SELECT @email;

CALL GetEmailID(196557,@email);
SELECT @email;

#Parking Verification for Parking Department Workers - Using Vehicle License Plate, they are able to figure out model, color, permit type and expiry date (Invoking Function inside Procedure)

DELIMITER $$

CREATE PROCEDURE VerifyParking(
	IN LicensePlate VARCHAR(12)
)
BEGIN

	SELECT tp.PermitID, PermitType(tp.Payment) AS Permit_Type,tp.ExpDate, tv.VehicleModel,tv.VehicleColor 
    FROM Transport_permits AS tp INNER JOIN Transport_vehicles AS tv USING(PermitID)
    WHERE tv.VehicleLicensePlate = LicensePlate;

END $$

DELIMITER ;

CALL VerifyParking('GXQ9909');

#Assigning grades to students based on marks obtained for a particular class

DELIMITER $$

CREATE PROCEDURE Grade(
 IN StudentID INT,
 IN ClassID INT,
 OUT StudentName VARCHAR(100),
 OUT Grade_Student VARCHAR(10)
 )
 BEGIN
 DECLARE Student_Name VARCHAR(100);
 DECLARE Marks INT DEFAULT 0;
 Select Grade
 INTO Marks
 FROM Class_Registration 
 WHERE Class_Registration.StudentID = StudentID AND Class_Registration.ClassID = ClassID;
 Select CONCAT(StudFirstName,' ',StudLastName) INTO Student_Name from Students WHERE Students.StudID = StudentID;
 
 SET StudentName = Student_Name;
 SET Grade_Student = Get_Grade(Marks);
 END $$
 
 DELIMITER ;


#Triggers
#Before Update Trigger on Students Table

CREATE TABLE Students_audit (
	id INT AUTO_INCREMENT PRIMARY KEY,
    StudID INT NOT NULL,
    StudFirstName VARCHAR(30) NOT NULL,
    StudLastName VARCHAR(30) NOT NULL,
    StudPhoneNumber VARCHAR(10) NOT NULL,
    StudStreetAddress VARCHAR(50) NOT NULL,
    StudCity VARCHAR(30) NOT NULL,
    StudState VARCHAR(2) NOT NULL,
    StudZipCode VARCHAR(5) NOT NULL,
    StudBirthDate DATE NOT NULL,
    StudGender VARCHAR(12) NOT NULL,
    StudMajor INT NOT NULL,
    changeuser VARCHAR(50) NOT NULL,
    changedate DATETIME DEFAULT NULL,
    action VARCHAR(50) DEFAULT NULL
    );
    
    CREATE TRIGGER before_students_update
		BEFORE UPDATE ON Students
        FOR EACH ROW
	 INSERT INTO Students_audit
     SET action = 'update',
        StudID = OLD.StudID,
        StudFirstName = OLD.StudFirstName,
		StudLastName = OLD.StudLastName,
		StudPhoneNumber = OLD.StudPhoneNumber,
		StudStreetAddress = OLD.StudStreetAddress,
		StudCity = OLD.StudCity,
		StudState = OLD.StudState,
		StudZipCode = OLD.StudZipCode,
        StudBirthDate = OLD.StudBirthDate,
        StudGender = OLD.StudGender,
        StudMajor = OLD.StudMajor,
        changeuser = user(),
        changedate = NOW();

UPDATE Students SET StudCity="Paris" WHERE StudID=13544;

SELECT * FROM Students_audit;

#After Update Trigger on Employees Table

CREATE TABLE Employees_audit (
	id INT AUTO_INCREMENT PRIMARY KEY,
    EmpID INT NOT NULL,
    EmpFirstName VARCHAR(30) NOT NULL,
    EmpLastName VARCHAR(30) NOT NULL,
    EmpPhoneNumber VARCHAR(10) NOT NULL,
    EmpStreetAddress VARCHAR(50) NOT NULL,
    EmpCity VARCHAR(30) NOT NULL,
    EmpState VARCHAR(2) NOT NULL,
    EmpZipCode VARCHAR(5) NOT NULL,
    EmpDateHired DATE NOT NULL,
    EmpSalary Decimal(15,2) NOT NULL,
    EmpPosition VARCHAR(50) NOT NULL,
    changeuser VARCHAR(50) NOT NULL,
    changedate DATETIME DEFAULT NULL,
    action VARCHAR(50) DEFAULT NULL
    );
    
    CREATE TRIGGER after_Employees_update
		AFTER UPDATE ON Employees
        FOR EACH ROW
	 INSERT INTO Employees_audit
     SET action = 'update',
        EmpID = OLD.EmpID,
        EmpFirstName = OLD.EmpFirstName,
		EmpLastName = OLD.EmpLastName,
		EmpPhoneNumber = OLD.EmpPhoneNumber,
		EmpStreetAddress = OLD.EmpStreetAddress,
		EmpCity = OLD.EmpCity,
		EmpState = OLD.EmpState,
		EmpZipCode = OLD.EmpZipCode,
        EmpDateHired = OLD.DateHired,
        EmpSalary = OLD.Salary,
        EmpPosition = OLD.Position,
        changeuser = user(),
        changedate = NOW();

UPDATE Employees SET Salary=55000 WHERE EmpID=196557;

SELECT * FROM Employees_audit;

#Before Delete trigger on Employees table (Ex-Employees)

CREATE TABLE Ex_Employees (
	id INT AUTO_INCREMENT PRIMARY KEY,
    EmpID INT NOT NULL,
    EmpFirstName VARCHAR(30) NOT NULL,
    EmpLastName VARCHAR(30) NOT NULL,
    EmpPhoneNumber VARCHAR(10) NOT NULL,
    EmpStreetAddress VARCHAR(50) NOT NULL,
    EmpCity VARCHAR(30) NOT NULL,
    EmpState VARCHAR(2) NOT NULL,
    EmpZipCode VARCHAR(5) NOT NULL,
    EmpDateHired DATE NOT NULL,
    changeuser VARCHAR(50) NOT NULL,
    changedate DATETIME DEFAULT NULL,
    Number_of_years_worked INT
    );

CREATE TRIGGER before_delete_employees
		BEFORE DELETE ON Employees
        FOR EACH ROW
	 INSERT INTO Ex_Employees
     SET 
        EmpID = OLD.EmpID,
        EmpFirstName = OLD.EmpFirstName,
		EmpLastName = OLD.EmpLastName,
		EmpPhoneNumber = OLD.EmpPhoneNumber,
		EmpStreetAddress = OLD.EmpStreetAddress,
		EmpCity = OLD.EmpCity,
		EmpState = OLD.EmpState,
		EmpZipCode = OLD.EmpZipCode,
        EmpDateHired = OLD.DateHired,
        changeuser = user(),
        changedate = NOW(),
        Number_of_years_worked = (select ( year(NOW()) - year(DateHired)) from Employees where EmpID = OLD.EmpID);

#After delete trigger on students table (Alumni)

CREATE TABLE Alumni (
	id INT AUTO_INCREMENT PRIMARY KEY,
    StudID INT NOT NULL,
    StudFirstName VARCHAR(30) NOT NULL,
    StudLastName VARCHAR(30) NOT NULL,
    StudPhoneNumber VARCHAR(10) NOT NULL,
    StudStreetAddress VARCHAR(50) NOT NULL,
    StudCity VARCHAR(30) NOT NULL,
    StudState VARCHAR(2) NOT NULL,
    StudZipCode VARCHAR(5) NOT NULL,
    StudBirthDate DATE NOT NULL,
    StudGender VARCHAR(12) NOT NULL,
    StudMajor INT NOT NULL,
    changeuser VARCHAR(50) NOT NULL,
    changedate DATETIME DEFAULT NULL,
    action VARCHAR(50) DEFAULT NULL
    );

CREATE TRIGGER after_delete_students
		AFTER DELETE ON Students
        FOR EACH ROW
	 INSERT INTO Alumni
     SET action = 'delete',
        StudID = OLD.StudID,
        StudFirstName = OLD.StudFirstName,
		StudLastName = OLD.StudLastName,
		StudPhoneNumber = OLD.StudPhoneNumber,
		StudStreetAddress = OLD.StudStreetAddress,
		StudCity = OLD.StudCity,
		StudState = OLD.StudState,
		StudZipCode = OLD.StudZipCode,
        StudBirthDate = OLD.StudBirthDate,
        StudGender = OLD.StudGender,
        StudMajor = OLD.StudMajor,
        changeuser = user(),
        changedate = NOW();


#After insert on student table (Newly admitted students) 

CREATE TABLE new_Students_fall_2022 (
	id INT AUTO_INCREMENT PRIMARY KEY,
    StudID INT NOT NULL,
    StudFirstName VARCHAR(30) NOT NULL,
    StudLastName VARCHAR(30) NOT NULL,
    StudPhoneNumber VARCHAR(10) NOT NULL,
    StudStreetAddress VARCHAR(50) NOT NULL,
    StudCity VARCHAR(30) NOT NULL,
    StudState VARCHAR(2) NOT NULL,
    StudZipCode VARCHAR(5) NOT NULL,
    StudBirthDate DATE NOT NULL,
    StudGender VARCHAR(12) NOT NULL,
    StudMajor INT NOT NULL,
    changeuser VARCHAR(50) NOT NULL,
    date_of_admission DATETIME DEFAULT NULL,
    action VARCHAR(50) DEFAULT NULL
    );

CREATE TRIGGER after_insert_students
		AFTER INSERT ON Students
        FOR EACH ROW
	 INSERT INTO new_Students_fall_2022
     SET action = 'insert',
        StudID = NEW.StudID,
        StudFirstName = NEW.StudFirstName,
		StudLastName = NEW.StudLastName,
		StudPhoneNumber = NEW.StudPhoneNumber,
		StudStreetAddress = NEW.StudStreetAddress,
		StudCity = NEW.StudCity,
		StudState = NEW.StudState,
		StudZipCode = NEW.StudZipCode,
        StudBirthDate = NEW.StudBirthDate,
        StudGender = NEW.StudGender,
        StudMajor = NEW.StudMajor,
        changeuser = user(),
        date_of_admission = NOW();



#Views

#Departments with Employee Chairperson Name and Contact Information 

CREATE VIEW Departments_Contact_vw
AS 
SELECT dp.DeptID AS Department_ID,dp.DeptName AS Department_Name, CONCAT(e.EmpFirstName," ",e.EmpLastName) AS Chair_Person, e.EmpPhoneNumber,e.Position
FROM Departments AS dp INNER JOIN Employees AS e WHERE dp.DeptChairPerson=e.EmpID;

SELECT * FROM Departments_Contact_vw;

#Professors with Course, Class and Contact Information 

CREATE VIEW Professors_courses_vw
AS 
SELECT CONCAT(e.EmpFirstName," ",e.EmpLastName) AS Professor,e.EmpPhoneNumber,ts.Title,ts.Status,fc.ClassID, co.CourseName,cl.Credits,cl.SemesterNumber,cl.Duration,co.EstClassSize
FROM (((Employees AS e 
INNER JOIN Teaching_Staff AS ts USING(EmpID))
LEFT JOIN Faculty_Classes AS fc USING(EmpID))
INNER JOIN Classes AS cl USING (ClassID))
INNER JOIN Courses AS co USING (CourseID); 

SELECT * FROM Professors_courses_vw; 

#Students with Classes , Courses and Grades


CREATE VIEW Student_Classes_vw
AS 
SELECT Students.StudID , CONCAT(Students.StudFirstName," ",Students.StudLastName) AS Student_Name ,Classes.ClassID ,Classes.CourseID,Classes.ClassRoomID,Classrooms.BuildingCode, Class_Registration.ClassStatus,class_registration_status.ClassStatusDescription, Class_Registration.Grade
FROM (((Students
INNER JOIN Class_Registration on Students.StudID = Class_Registration.StudentID
INNER JOIN class_registration_status USING (ClassStatus))
INNER JOIN Classes USING(ClassID))
INNER JOIN Classrooms USING(ClassRoomID)); 


#Student Residency and Immigration

CREATE VIEW Student_Residency_Immigration_vw
AS
SELECT Students.StudID , CONCAT(Students.StudFirstName," ",Students.StudLastName) AS Student_Name, Residency.ResStatus, Residency.VisaType
From (Students
INNER JOIN Residency USING(StudID));

Select * from Student_Residency_Immigration_vw;


#Indexes

#Student full name 

CREATE INDEX idx_stname
ON Students (StudLastName, StudFirstName);

#Employee Full name

CREATE INDEX idx_empname
ON Employees (EmpLastName, EmpFirstName);

#Organization Name

CREATE INDEX idx_orgname
ON Student_Organizations (Organization_Name);

#Department Name

CREATE INDEX idx_deptname
ON Departments (DeptName);

#Access Control Code example 
#GRANT SELECT ON Students TO 'general@localhost'
#UPDATE Students SET StudFirstName = 'Sam' where StudId = 13544




