CREATE EXTENSION IF NOT EXISTS dblink;

-- CALL CreateTables();
CREATE OR REPLACE PROCEDURE CreateTables()
LANGUAGE plpgsql
AS $$
    DECLARE table1 VARCHAR     := 'Doctor';
    DECLARE table2 VARCHAR     := 'Service';
    DECLARE table3 VARCHAR     := 'Patient';
    DECLARE table4 VARCHAR     := 'Logbook';

    DECLARE DoctorID VARCHAR       	:= 'DoctorID';
    DECLARE DoctorName VARCHAR     	:= 'DoctorName';
    DECLARE ServiceID VARCHAR      	:= 'ServiceID';
    DECLARE Title VARCHAR          	:= 'Title';
    DECLARE Cost VARCHAR       	   	:= 'Cost';
    DECLARE PatientID VARCHAR       := 'PatientID';
    DECLARE PatientName VARCHAR    	:= 'PatientName';
    DECLARE Phone VARCHAR          	:= 'Phone';
	DECLARE DateOfInsert VARCHAR 	:= 'DateOfInsert';
    DECLARE Number VARCHAR    	   	:= 'Number';
    DECLARE Date   VARCHAR         	:= 'Date';
    DECLARE Patient   VARCHAR      	:= 'Patient';
    DECLARE Service   VARCHAR      	:= 'Service';
	DECLARE Doctor   VARCHAR       	:= 'Doctor';

BEGIN
	EXECUTE format('CREATE TABLE IF NOT EXISTS '|| table1 ||' 
				  ('|| DoctorID ||' SERIAL PRIMARY KEY, 
				   '|| DoctorName ||' varchar(40));');
    EXECUTE format('CREATE TABLE IF NOT EXISTS '|| table2 ||'
				  ('|| ServiceID ||' SERIAL PRIMARY KEY, 
				   '|| Title ||' varchar(40), 
				   '|| Cost ||' int);');
    EXECUTE format('CREATE TABLE IF NOT EXISTS '|| table3 ||'
				  ('|| PatientID ||' SERIAL PRIMARY KEY, 
				   '|| PatientName ||' varchar(40), 
				   '|| Phone ||' varchar(12),
				   '|| DateOfInsert||' timestamp with time zone);');
    EXECUTE format('CREATE TABLE IF NOT EXISTS '|| table4 ||'
				  ('|| Number ||' SERIAL PRIMARY KEY, 
				   '|| Date ||' date, 
				   '|| Patient ||' integer,
				   FOREIGN KEY ('|| Patient ||') REFERENCES '|| table3 ||'( '||PatientID||' )
                        	ON DELETE CASCADE
                        	ON UPDATE CASCADE,
				   '|| Service ||' integer,
				   FOREIGN KEY ('|| Service ||') REFERENCES '|| table2 ||'( '||ServiceID||' )
                        	ON DELETE CASCADE
                        	ON UPDATE CASCADE,
				   '|| Doctor ||' integer,
				   FOREIGN KEY ('|| Doctor ||')REFERENCES '|| table1 ||'( '||DoctorID||' )
                        	ON DELETE CASCADE
                        	ON UPDATE CASCADE);');
    RAISE NOTICE '(%, %, %, %) created', table1, table2, table3, table4;
END;
$$;


-- filling the table by name --
CREATE OR REPLACE PROCEDURE FillTable(IN table_n name)
LANGUAGE plpgsql
AS $$
	DECLARE table1 VARCHAR     := 'Doctor';
    DECLARE table2 VARCHAR     := 'Service';
    DECLARE table3 VARCHAR     := 'Patient';
    DECLARE table4 VARCHAR     := 'Logbook';
BEGIN
    IF table_n = table1 THEN
	
        INSERT INTO Doctor (DoctorID, DoctorName) VALUES (1, 'Vasiliy Pupkin');
        INSERT INTO Doctor (DoctorID, DoctorName) VALUES (2, 'Sanya Kekov');
		INSERT INTO Doctor (DoctorID, DoctorName) VALUES (3, 'Kista Nonameova');
		INSERT INTO Doctor (DoctorID, DoctorName) VALUES (4, 'Andjelika Djolinova');
		INSERT INTO Doctor (DoctorID, DoctorName) VALUES (5, 'Elena Malysheva');
		INSERT INTO Doctor (DoctorID, DoctorName) VALUES (6, 'Mortal Combat');
		INSERT INTO Doctor (DoctorID, DoctorName) VALUES (7, 'Frog Memov');
		INSERT INTO Doctor (DoctorID, DoctorName) VALUES (8, 'Michail Dirty');
        RAISE NOTICE 'Table (%) filled', table1;
    END IF;

    IF table_n = table2 THEN
	
        INSERT INTO Service (ServiceID, title, cost) VALUES (1,  'Kidnay removal', 20000);
        INSERT INTO Service (ServiceID, title, cost) VALUES (2,  'Treatment with braces', 150000);
        INSERT INTO Service (ServiceID, title, cost) VALUES (3,  'Breast augmentation', 500000);
        INSERT INTO Service (ServiceID, title, cost) VALUES (4,  'Rhinoplasty', 200000);
		INSERT INTO Service (ServiceID, title, cost) VALUES (5,  'Lip injection', 5000);
		INSERT INTO Service (ServiceID, title, cost) VALUES (6,  'liposuction', 400000);
		INSERT INTO Service (ServiceID, title, cost) VALUES (7,  'Total face change', 1000000);
		INSERT INTO Service (ServiceID, title, cost) VALUES (8,  'Total body change', 2000000);

        RAISE NOTICE 'Table (%) filled', table2;
    END IF;

    IF table_n = table3 THEN
        INSERT INTO Patient (PatientID, PatientName, Phone) VALUES (1, 'Donatella Versache', '4567321');
        INSERT INTO Patient (PatientID, PatientName, Phone) VALUES (2, 'Sergey Zverev', '1112223');
        INSERT INTO Patient (PatientID, PatientName, Phone) VALUES (3, 'Kim Kardashian', '2244466');
		INSERT INTO Patient (PatientID, PatientName, Phone) VALUES (4, 'Bred Pit', '1234098');
		INSERT INTO Patient (PatientID, PatientName, Phone) VALUES (5, 'Kylie Jenner', '7592345');
		INSERT INTO Patient (PatientID, PatientName, Phone) VALUES (6, 'Aleksey Scherbakov', '5678321');

        RAISE NOTICE 'Table (%) filled', table3;
    END IF;

    IF table_n = table4 THEN
        INSERT INTO Logbook (Date, Patient, Service, Doctor) VALUES ('12/1/2020', 1, 7, 6);
        INSERT INTO Logbook (Date, Patient, Service, Doctor) VALUES ('12/2/2020', 1, 6, 3);
        INSERT INTO Logbook (Date, Patient, Service, Doctor) VALUES ('12/2/2020', 2, 2, 1);
        INSERT INTO Logbook (Date, Patient, Service, Doctor) VALUES ('12/3/2020', 3, 8, 7);
        INSERT INTO Logbook (Date, Patient, Service, Doctor) VALUES ('12/5/2020', 3, 4, 2);
        INSERT INTO Logbook (Date, Patient, Service, Doctor) VALUES ('12/5/2020', 4, 3, 4);
        INSERT INTO Logbook (Date, Patient, Service, Doctor) VALUES ('12/6/2020', 5, 5, 5);
        INSERT INTO Logbook (Date, Patient, Service, Doctor) VALUES ('12/10/2020', 5, 5, 5);
		INSERT INTO Logbook (Date, Patient, Service, Doctor) VALUES ('12/14/2020', 6, 1, 8);
		INSERT INTO Logbook (Date, Patient, Service, Doctor) VALUES ('12/16/2020', 6, 4, 1);


        RAISE NOTICE 'Table (%) filled', table4;
    END IF;
END;
$$;


-- CALL FillAllTables();
CREATE OR REPLACE PROCEDURE FillAllTables()
LANGUAGE plpgsql
AS $$
BEGIN
	-- Create Trigger --
	CREATE TRIGGER check_update
	AFTER INSERT ON Patient
	FOR EACH ROW
	EXECUTE PROCEDURE change_date();
	-- Filling tables --
    CALL FillTable('Doctor');
    CALL FillTable('Service');
    CALL FillTable('Patient');
    CALL FillTable('Logbook');

END;
$$;


-- creating an index on the phone number field --
-- CALL CreateIndex();
CREATE OR REPLACE PROCEDURE CreateIndex()
LANGUAGE plpgsql
AS $$
BEGIN
	CREATE INDEX phone_index  ON Patient (Phone);  
END;
$$;


-- searching by phone field --
-- SELECT SearchPatientByPhone('5678321');
CREATE OR REPLACE FUNCTION SearchPatientByPhone(phone_num text)
RETURNS TABLE (Pat_ID integer, Pat_Name varchar(40), Pat_Phone varchar(12), 
			   Ins_date timestamp with time zone) 
LANGUAGE plpgsql
AS $$
BEGIN
	RETURN QUERY 
		SELECT * FROM Patient WHERE Phone = phone_num;
END;
$$;


-- deletion by phone field --
-- CALL DeletePatientByPhone('5678321');
CREATE OR REPLACE PROCEDURE DeletePatientByPhone(phone_num text)
LANGUAGE plpgsql
AS $$
BEGIN
	DELETE FROM Patient WHERE Phone = phone_num;
END;
$$;


-- Trigger  procedure --
CREATE OR REPLACE FUNCTION change_date() 
RETURNS TRIGGER AS $change_date$
BEGIN
	UPDATE Patient SET DateOfInsert = NOW() WHERE PatientID = NEW.PatientID;
	RETURN NULL;
END;
$change_date$ LANGUAGE plpgsql;


-- table data output procedures --
-- SELECT * FROM PrintDoctors ();
CREATE OR REPLACE FUNCTION PrintDoctors () 
RETURNS TABLE (Doc_ID integer, Doc_Name varchar(40)) 
LANGUAGE plpgsql
AS $$
BEGIN
	RETURN QUERY 
		SELECT DoctorId, DoctorName FROM Doctor;
END;
$$;

-- SELECT * FROM PrintServices();
CREATE OR REPLACE FUNCTION PrintServices () 
RETURNS TABLE (Serv_ID integer, Serv_Title varchar(40), Serv_Cost int) 
LANGUAGE plpgsql
AS $$
BEGIN
	RETURN QUERY 
		SELECT ServiceId, Title, Cost FROM Service;
END;
$$;

-- SELECT * FROM PrintPatients();
CREATE OR REPLACE FUNCTION PrintPatients () 
RETURNS TABLE (Pat_ID integer, Pat_Name varchar(40), Pat_Phone varchar(12), Ins_date timestamp with time zone) 
LANGUAGE plpgsql
AS $$
BEGIN
	RETURN QUERY 
		SELECT PatientId, PatientName, Phone, DateOfInsert FROM Patient;
END;
$$;

-- SELECT * FROM PrintLogbook();
CREATE OR REPLACE FUNCTION PrintLogbook () 
RETURNS TABLE (Num integer, Date_ date, Patient_id integer, Service_id integer, Doctor_id integer) 
LANGUAGE plpgsql
AS $$
BEGIN
	RETURN QUERY 
		SELECT Number, Date, Patient, Service, Doctor FROM Logbook;
END;
$$;


-- full and partial table cleanup --
-- SELECT ClearTables('{Doctor, Service, Logbook, Patient}');
-- SELECT ClearTables('{Patient}');
CREATE OR REPLACE FUNCTION ClearTables(tbnames text[]) RETURNS int AS
$func$
DECLARE
    tbname text;
BEGIN
    FOREACH tbname IN ARRAY tbnames LOOP
        EXECUTE FORMAT('DELETE FROM %s', tbname);
    END LOOP;
    RETURN 1;
END
$func$ LANGUAGE plpgsql;


-- dropping one or more tables -- 
-- SELECT DropTables('{Service, Doctor}');
CREATE OR REPLACE FUNCTION DropTables(tbnames text[]) RETURNS int AS
$func$
DECLARE
    tbname text;
BEGIN
    FOREACH tbname IN ARRAY tbnames LOOP
        EXECUTE FORMAT('DROP TABLE IF EXISTS %s CASCADE', tbname);
    END LOOP;
    RETURN 1;
END
$func$ LANGUAGE plpgsql;


-- deleting all tables --
-- CALL DropAllTables();
CREATE OR REPLACE PROCEDURE DropAllTables()
LANGUAGE plpgsql
AS $$
BEGIN
    PERFORM DropTables('{Logbook, Service, Patient, Doctor}');
END;
$$;

-- func for insertClients()--				      
CREATE OR REPLACE FUNCTION IdByName_doc(name_ text)
  returns integer
  AS
$func$
DECLARE
  doc_id integer;
BEGIN
    SELECT DoctorID INTO doc_id FROM Doctor WHERE DoctorName = name_;
    return doc_id; 
END
$func$ LANGUAGE plpgsql;
				      
-- func for insertClients()--	
CREATE OR REPLACE FUNCTION IdByName_serv(title_ text)
  returns integer
  AS
$func$
DECLARE
  serv_id integer;
BEGIN
    SELECT ServiceID INTO serv_id FROM Service WHERE title = title_;
    return serv_id; 
END
$func$ LANGUAGE plpgsql;

-- func for insertClients()--					      
CREATE OR REPLACE FUNCTION IdByName_pat(name_ text)
  returns integer
  AS
$func$
DECLARE
  pat_id integer;
BEGIN
    SELECT PatientId INTO pat_id FROM Patient WHERE patientname = name_;
    return pat_id; 
END
$func$ LANGUAGE plpgsql;

--call insertClients('LolaCola', '8999991', '12/09/2020', 'Vasiliy Pupkin', 'Kidnay removal')--
CREATE OR REPLACE PROCEDURE insertClients(IN patient_name varchar(40), IN phone_ varchar(12), IN date_ date, IN doc varchar(40), IN serv varchar(40))
LANGUAGE plpgsql
AS $$
DECLARE
    doctorID int;
	serviceID int;
	patientID int;
	lognum int;
BEGIN

	doctorID =IdByName_doc(doc);
	serviceID =IdByName_serv(serv);
	if doctorID is null or serviceID is null then 
		raise notice 'the doctors name or service name was entered incorrectly';
	else 
		if not exists (select 1 from patient where patientname=patient_name) then 
			select max(patient.PatientID) into patientID from patient;
			INSERT INTO patient(PatientID, PatientName, Phone) VALUES (patientID + 1, patient_name, phone_);

		end if;
   		patientID =IdByName_pat(patient_name);
    	select max(number) into lognum from logbook;
    	INSERT INTO logbook(number, Date, Patient, Service, Doctor) VALUES (lognum +1, date_, patientID, serviceID, doctorID);
    end if;
END;
$$;

-- deletion by id from logbook --
-- call delmeetbyid(12); --

CREATE OR REPLACE PROCEDURE DelMeetByID(ID_ int)
LANGUAGE plpgsql
AS $$
BEGIN
	DELETE FROM logbook WHERE number = ID_;
END;
$$;

--changind date of meeting by number in logbook--
--call ChangeDateOfMeet(11, '12/14/2020');--

CREATE OR REPLACE PROCEDURE ChangeDateOfMeet(ID_ int, date_ date)
LANGUAGE plpgsql
AS $$
BEGIN
	UPDATE logbook SET date = date_ where number = ID_;
END;
$$;