

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';


CREATE SCHEMA IF NOT EXISTS `apollo_hospital17` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `apollo_hospital17` ;

CREATE TABLE IF NOT EXISTS `apollo_hospital17`.`patient` (
  `patient_id` BIGINT NOT NULL AUTO_INCREMENT,
  `mrn` VARCHAR(40) NULL DEFAULT NULL,
  `first_name` VARCHAR(50) NOT NULL,
  `last_name` VARCHAR(50) NULL DEFAULT NULL,
  `dob` DATE NULL DEFAULT NULL,
  `gender` ENUM('Male', 'Female', 'Other') NULL DEFAULT NULL,
  `phone` VARCHAR(15) NULL DEFAULT NULL,
  `email` VARCHAR(80) NULL DEFAULT NULL,
  `address` VARCHAR(200) NULL DEFAULT NULL,
  PRIMARY KEY (`patient_id`),
  UNIQUE INDEX `mrn` (`mrn` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


CREATE TABLE IF NOT EXISTS `apollo_hospital17`.`hospitalbranch` (
  `branch_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `city` VARCHAR(60) NULL DEFAULT NULL,
  `phone` VARCHAR(15) NULL DEFAULT NULL,
  `established_year` YEAR NULL DEFAULT NULL,
  PRIMARY KEY (`branch_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;



CREATE TABLE IF NOT EXISTS `apollo_hospital17`.`department` (
  `department_id` SMALLINT NOT NULL AUTO_INCREMENT,
  `branch_id` INT NOT NULL,
  `name` VARCHAR(80) NOT NULL,
  `floor` VARCHAR(10) NULL DEFAULT NULL,
  PRIMARY KEY (`department_id`),
  INDEX `branch_id` (`branch_id` ASC) VISIBLE,
  CONSTRAINT `department_ibfk_1`
    FOREIGN KEY (`branch_id`)
    REFERENCES `apollo_hospital17`.`hospitalbranch` (`branch_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;



CREATE TABLE IF NOT EXISTS `apollo_hospital17`.`doctor` (
  `doctor_id` INT NOT NULL AUTO_INCREMENT,
  `branch_id` INT NOT NULL,
  `department_id` SMALLINT NOT NULL,
  `first_name` VARCHAR(50) NOT NULL,
  `last_name` VARCHAR(50) NULL DEFAULT NULL,
  `reg_no` VARCHAR(30) NULL DEFAULT NULL,
  `phone` VARCHAR(15) NULL DEFAULT NULL,
  `email` VARCHAR(80) NULL DEFAULT NULL,
  `experience_years` TINYINT NULL DEFAULT NULL,
  PRIMARY KEY (`doctor_id`),
  UNIQUE INDEX `reg_no` (`reg_no` ASC) VISIBLE,
  INDEX `branch_id` (`branch_id` ASC) VISIBLE,
  INDEX `department_id` (`department_id` ASC) VISIBLE,
  CONSTRAINT `doctor_ibfk_1`
    FOREIGN KEY (`branch_id`)
    REFERENCES `apollo_hospital17`.`hospitalbranch` (`branch_id`),
  CONSTRAINT `doctor_ibfk_2`
    FOREIGN KEY (`department_id`)
    REFERENCES `apollo_hospital17`.`department` (`department_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;



CREATE TABLE IF NOT EXISTS `apollo_hospital17`.`appointment` (
  `appointment_id` BIGINT NOT NULL AUTO_INCREMENT,
  `patient_id` BIGINT NOT NULL,
  `doctor_id` INT NOT NULL,
  `appointment_datetime` DATETIME NOT NULL,
  `status` ENUM('Scheduled', 'Completed', 'Cancelled', 'NoShow') NULL DEFAULT 'Scheduled',
  `reason` VARCHAR(255) NULL DEFAULT NULL,
  `created_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`appointment_id`),
  INDEX `patient_id` (`patient_id` ASC) VISIBLE,
  INDEX `doctor_id` (`doctor_id` ASC) VISIBLE,
  CONSTRAINT `appointment_ibfk_1`
    FOREIGN KEY (`patient_id`)
    REFERENCES `apollo_hospital17`.`patient` (`patient_id`),
  CONSTRAINT `appointment_ibfk_2`
    FOREIGN KEY (`doctor_id`)
    REFERENCES `apollo_hospital17`.`doctor` (`doctor_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;



CREATE TABLE IF NOT EXISTS `apollo_hospital17`.`visit` (
  `visit_id` BIGINT NOT NULL AUTO_INCREMENT,
  `appointment_id` BIGINT NULL DEFAULT NULL,
  `patient_id` BIGINT NOT NULL,
  `doctor_id` INT NOT NULL,
  `branch_id` INT NOT NULL,
  `visit_datetime` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `visit_type` ENUM('Outpatient', 'Emergency', 'FollowUp') NULL DEFAULT 'Outpatient',
  `notes` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`visit_id`),
  INDEX `appointment_id` (`appointment_id` ASC) VISIBLE,
  INDEX `patient_id` (`patient_id` ASC) VISIBLE,
  INDEX `doctor_id` (`doctor_id` ASC) VISIBLE,
  INDEX `branch_id` (`branch_id` ASC) VISIBLE,
  CONSTRAINT `visit_ibfk_1`
    FOREIGN KEY (`appointment_id`)
    REFERENCES `apollo_hospital17`.`appointment` (`appointment_id`),
  CONSTRAINT `visit_ibfk_2`
    FOREIGN KEY (`patient_id`)
    REFERENCES `apollo_hospital17`.`patient` (`patient_id`),
  CONSTRAINT `visit_ibfk_3`
    FOREIGN KEY (`doctor_id`)
    REFERENCES `apollo_hospital17`.`doctor` (`doctor_id`),
  CONSTRAINT `visit_ibfk_4`
    FOREIGN KEY (`branch_id`)
    REFERENCES `apollo_hospital17`.`hospitalbranch` (`branch_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;



CREATE TABLE IF NOT EXISTS `apollo_hospital17`.`room` (
  `room_id` INT NOT NULL AUTO_INCREMENT,
  `branch_id` INT NOT NULL,
  `room_number` VARCHAR(10) NOT NULL,
  `room_type` ENUM('General', 'SemiPrivate', 'Private', 'ICU') NULL DEFAULT NULL,
  `is_occupied` TINYINT(1) NULL DEFAULT '0',
  PRIMARY KEY (`room_id`),
  UNIQUE INDEX `branch_id` (`branch_id` ASC, `room_number` ASC) VISIBLE,
  CONSTRAINT `room_ibfk_1`
    FOREIGN KEY (`branch_id`)
    REFERENCES `apollo_hospital17`.`hospitalbranch` (`branch_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;



CREATE TABLE IF NOT EXISTS `apollo_hospital17`.`admission` (
  `admission_id` BIGINT NOT NULL AUTO_INCREMENT,
  `visit_id` BIGINT NOT NULL,
  `patient_id` BIGINT NOT NULL,
  `room_id` INT NOT NULL,
  `admitted_on` DATETIME NOT NULL,
  `discharged_on` DATETIME NULL DEFAULT NULL,
  `status` ENUM('Admitted', 'Discharged', 'Transferred') NULL DEFAULT 'Admitted',
  `admitting_doctor_id` INT NOT NULL,
  `reason` VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY (`admission_id`),
  INDEX `visit_id` (`visit_id` ASC) VISIBLE,
  INDEX `patient_id` (`patient_id` ASC) VISIBLE,
  INDEX `room_id` (`room_id` ASC) VISIBLE,
  INDEX `admitting_doctor_id` (`admitting_doctor_id` ASC) VISIBLE,
  CONSTRAINT `admission_ibfk_1`
    FOREIGN KEY (`visit_id`)
    REFERENCES `apollo_hospital17`.`visit` (`visit_id`),
  CONSTRAINT `admission_ibfk_2`
    FOREIGN KEY (`patient_id`)
    REFERENCES `apollo_hospital17`.`patient` (`patient_id`),
  CONSTRAINT `admission_ibfk_3`
    FOREIGN KEY (`room_id`)
    REFERENCES `apollo_hospital17`.`room` (`room_id`),
  CONSTRAINT `admission_ibfk_4`
    FOREIGN KEY (`admitting_doctor_id`)
    REFERENCES `apollo_hospital17`.`doctor` (`doctor_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;



CREATE TABLE IF NOT EXISTS `apollo_hospital17`.`invoice` (
  `invoice_id` BIGINT NOT NULL AUTO_INCREMENT,
  `visit_id` BIGINT NOT NULL,
  `patient_id` BIGINT NOT NULL,
  `created_on` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `total_amount` DECIMAL(12,2) NULL DEFAULT NULL,
  `status` ENUM('Unpaid', 'Paid', 'PartiallyPaid') NULL DEFAULT 'Unpaid',
  PRIMARY KEY (`invoice_id`),
  INDEX `visit_id` (`visit_id` ASC) VISIBLE,
  INDEX `patient_id` (`patient_id` ASC) VISIBLE,
  CONSTRAINT `invoice_ibfk_1`
    FOREIGN KEY (`visit_id`)
    REFERENCES `apollo_hospital17`.`visit` (`visit_id`),
  CONSTRAINT `invoice_ibfk_2`
    FOREIGN KEY (`patient_id`)
    REFERENCES `apollo_hospital17`.`patient` (`patient_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;



CREATE TABLE IF NOT EXISTS `apollo_hospital17`.`laborder` (
  `laborder_id` BIGINT NOT NULL AUTO_INCREMENT,
  `visit_id` BIGINT NOT NULL,
  `ordered_by` INT NOT NULL,
  `ordered_on` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `status` ENUM('Pending', 'Completed', 'Cancelled') NULL DEFAULT 'Pending',
  PRIMARY KEY (`laborder_id`),
  INDEX `visit_id` (`visit_id` ASC) VISIBLE,
  INDEX `ordered_by` (`ordered_by` ASC) VISIBLE,
  CONSTRAINT `laborder_ibfk_1`
    FOREIGN KEY (`visit_id`)
    REFERENCES `apollo_hospital17`.`visit` (`visit_id`),
  CONSTRAINT `laborder_ibfk_2`
    FOREIGN KEY (`ordered_by`)
    REFERENCES `apollo_hospital17`.`doctor` (`doctor_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `apollo_hospital17`.`labtest` (
  `labtest_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `department_id` SMALLINT NULL DEFAULT NULL,
  `price` DECIMAL(10,2) NULL DEFAULT NULL,
  PRIMARY KEY (`labtest_id`),
  INDEX `department_id` (`department_id` ASC) VISIBLE,
  CONSTRAINT `labtest_ibfk_1`
    FOREIGN KEY (`department_id`)
    REFERENCES `apollo_hospital17`.`department` (`department_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `apollo_hospital17`.`laborderitem` (
  `lab_item_id` BIGINT NOT NULL AUTO_INCREMENT,
  `laborder_id` BIGINT NOT NULL,
  `labtest_id` INT NOT NULL,
  `result_text` VARCHAR(500) NULL DEFAULT NULL,
  `result_date` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`lab_item_id`),
  INDEX `laborder_id` (`laborder_id` ASC) VISIBLE,
  INDEX `labtest_id` (`labtest_id` ASC) VISIBLE,
  CONSTRAINT `laborderitem_ibfk_1`
    FOREIGN KEY (`laborder_id`)
    REFERENCES `apollo_hospital17`.`laborder` (`laborder_id`),
  CONSTRAINT `laborderitem_ibfk_2`
    FOREIGN KEY (`labtest_id`)
    REFERENCES `apollo_hospital17`.`labtest` (`labtest_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `apollo_hospital17`.`medication` (
  `medication_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `form` VARCHAR(30) NULL DEFAULT NULL,
  `strength` VARCHAR(30) NULL DEFAULT NULL,
  `unit_price` DECIMAL(10,2) NULL DEFAULT NULL,
  PRIMARY KEY (`medication_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `apollo_hospital17`.`payment` (
  `payment_id` BIGINT NOT NULL AUTO_INCREMENT,
  `invoice_id` BIGINT NOT NULL,
  `amount` DECIMAL(12,2) NOT NULL,
  `method` ENUM('Cash', 'Card', 'UPI', 'Insurance') NULL DEFAULT 'Cash',
  `payment_date` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `reference_no` VARCHAR(50) NULL DEFAULT NULL,
  PRIMARY KEY (`payment_id`),
  INDEX `invoice_id` (`invoice_id` ASC) VISIBLE,
  CONSTRAINT `payment_ibfk_1`
    FOREIGN KEY (`invoice_id`)
    REFERENCES `apollo_hospital17`.`invoice` (`invoice_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `apollo_hospital17`.`prescription` (
  `prescription_id` BIGINT NOT NULL AUTO_INCREMENT,
  `visit_id` BIGINT NOT NULL,
  `doctor_id` INT NOT NULL,
  `prescribed_on` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `notes` VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY (`prescription_id`),
  INDEX `visit_id` (`visit_id` ASC) VISIBLE,
  INDEX `doctor_id` (`doctor_id` ASC) VISIBLE,
  CONSTRAINT `prescription_ibfk_1`
    FOREIGN KEY (`visit_id`)
    REFERENCES `apollo_hospital17`.`visit` (`visit_id`),
  CONSTRAINT `prescription_ibfk_2`
    FOREIGN KEY (`doctor_id`)
    REFERENCES `apollo_hospital17`.`doctor` (`doctor_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `apollo_hospital17`.`prescriptionitem` (
  `presc_item_id` BIGINT NOT NULL AUTO_INCREMENT,
  `prescription_id` BIGINT NOT NULL,
  `medication_id` INT NOT NULL,
  `dosage` VARCHAR(100) NULL DEFAULT NULL,
  `frequency` VARCHAR(50) NULL DEFAULT NULL,
  `duration_days` SMALLINT NULL DEFAULT NULL,
  `quantity` INT NULL DEFAULT NULL,
  PRIMARY KEY (`presc_item_id`),
  INDEX `prescription_id` (`prescription_id` ASC) VISIBLE,
  INDEX `medication_id` (`medication_id` ASC) VISIBLE,
  CONSTRAINT `prescriptionitem_ibfk_1`
    FOREIGN KEY (`prescription_id`)
    REFERENCES `apollo_hospital17`.`prescription` (`prescription_id`),
  CONSTRAINT `prescriptionitem_ibfk_2`
    FOREIGN KEY (`medication_id`)
    REFERENCES `apollo_hospital17`.`medication` (`medication_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

INSERT INTO hospitalbranch (name, city, phone, established_year)
VALUES ('Apollo Central', 'New Delhi', '011-11112222', 2012);
SET @b1 = LAST_INSERT_ID();


INSERT INTO department (branch_id, name, floor) VALUES
(@b1, 'Cardiology', '3'),
(@b1, 'Pathology', '1');
SET @d1 = @b1 + 0; 


INSERT INTO doctor (branch_id, department_id, first_name, last_name, reg_no, phone, email, experience_years) VALUES
(@b1, 1, 'Amit', 'Sharma', 'REG-A-001', '9810000001', 'amit.sharma@apollo.example', 10),
(@b1, 2, 'Neha', 'Roy', 'REG-A-002', '9810000002', 'neha.roy@apollo.example', 7);
SET @doc1 = (SELECT doctor_id FROM doctor WHERE reg_no='REG-A-001' LIMIT 1);
SET @doc2 = (SELECT doctor_id FROM doctor WHERE reg_no='REG-A-002' LIMIT 1);


INSERT INTO patient (mrn, first_name, last_name, dob, gender, phone, email, address) VALUES
('MRN100', 'Suresh', 'Verma', '1985-04-15', 'Male', '9810000100', 'suresh.verma@example.com', 'Janpath, New Delhi'),
('MRN101', 'Anjali', 'Mehta', '1990-09-02', 'Female', '9810000101', 'anjali.mehta@example.com', 'Gurgaon'),
('MRN102', 'Maya', 'Gupta', '1968-11-05', 'Female', '9810000102', 'maya.gupta@example.com', 'Saket, New Delhi');
SET @p1 = (SELECT patient_id FROM patient WHERE mrn='MRN100' LIMIT 1);
SET @p2 = (SELECT patient_id FROM patient WHERE mrn='MRN101' LIMIT 1);
SET @p3 = (SELECT patient_id FROM patient WHERE mrn='MRN102' LIMIT 1);


INSERT INTO room (branch_id, room_number, room_type, is_occupied) VALUES
(@b1, '101', 'General', 0),
(@b1, 'ICU-1', 'ICU', 0);
SET @r1 = (SELECT room_id FROM room WHERE room_number='101' AND branch_id=@b1 LIMIT 1);
SET @r2 = (SELECT room_id FROM room WHERE room_number='ICU-1' AND branch_id=@b1 LIMIT 1);

INSERT INTO labtest (name, department_id, price) VALUES ('Complete Blood Count', 2, 450.00);
SET @lt1 = LAST_INSERT_ID();

INSERT INTO medication (name, form, strength, unit_price) VALUES ('Paracetamol', 'Tablet', '500mg', 2.50);
SET @med1 = LAST_INSERT_ID();


INSERT INTO appointment (patient_id, doctor_id, appointment_datetime, status, reason)
VALUES (@p1, @doc1, '2025-11-20 10:30:00', 'Completed', 'Chest pain evaluation');
SET @appt1 = LAST_INSERT_ID();

INSERT INTO visit (appointment_id, patient_id, doctor_id, branch_id, visit_datetime, visit_type, notes)
VALUES (@appt1, @p1, @doc1, @b1, '2025-11-20 10:35:00', 'Outpatient', 'ECG done, observation');
SET @visit1 = LAST_INSERT_ID();

INSERT INTO admission (visit_id, patient_id, room_id, admitted_on, status, admitting_doctor_id, reason)
VALUES (@visit1, @p1, @r2, '2025-11-20 11:00:00', 'Admitted', @doc1, 'Observation after chest pain');
SET @adm1 = LAST_INSERT_ID();

INSERT INTO laborder (visit_id, ordered_by) VALUES (@visit1, @doc2);
SET @lo1 = LAST_INSERT_ID();

INSERT INTO laborderitem (laborder_id, labtest_id, result_text, result_date)
VALUES (@lo1, @lt1, 'WBC: 6.5 x10^9/L; Hb: 13.2 g/dL', '2025-11-20 12:00:00');

INSERT INTO prescription (visit_id, doctor_id, notes) VALUES (@visit1, @doc1, 'Pain relief and rest');
SET @pres1 = LAST_INSERT_ID();

INSERT INTO prescriptionitem (prescription_id, medication_id, dosage, frequency, duration_days, quantity)
VALUES (@pres1, @med1, '500mg', 'SOS', 3, 6);

INSERT INTO invoice (visit_id, patient_id, total_amount, status)
VALUES (@visit1, @p1, 3500.00, 'Paid');
SET @inv1 = LAST_INSERT_ID();

INSERT INTO payment (invoice_id, amount, method, payment_date, reference_no)
VALUES (@inv1, 3500.00, 'Card', '2025-11-21 10:05:00', 'TXN-C-0001');

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
