-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2020-01-18 17:07:25.101

-- foreign keys
ALTER TABLE Company DROP CONSTRAINT Company_Client;

ALTER TABLE Day DROP CONSTRAINT Day_Conference;

ALTER TABLE ParticipantOfDay DROP CONSTRAINT ParticipantOfDay_Participant;

ALTER TABLE ParticipantOfDay DROP CONSTRAINT ParticipantOfDay_ReservationForDay;

ALTER TABLE ParticipantOfWorkshop DROP CONSTRAINT ParticipantOfWorkshop_Participant;

ALTER TABLE ParticipantOfWorkshop DROP CONSTRAINT ParticipantOfWorkshop_ReservationForWorkshop;

ALTER TABLE ParticipantOfWorkshop DROP CONSTRAINT ParticipantOfWorkshop_Workshop;

ALTER TABLE Participant DROP CONSTRAINT Participant_Reservation;

ALTER TABLE PaymentThresholds DROP CONSTRAINT PaymentThresholds_Conference;

ALTER TABLE Payments DROP CONSTRAINT Payments_Reservation;

ALTER TABLE ReservationForDay DROP CONSTRAINT ReservationForDay_Day;

ALTER TABLE ReservationForDay DROP CONSTRAINT ReservationForDay_Reservation;

ALTER TABLE ReservationForWorkshop DROP CONSTRAINT ReservationForWorkshop_Reservation;

ALTER TABLE ReservationForWorkshop DROP CONSTRAINT ReservationForWorkshop_Workshop;

ALTER TABLE Reservation DROP CONSTRAINT Reservation_Client;

ALTER TABLE Workshop DROP CONSTRAINT Workshop_Day;

-- tables
DROP TABLE Client;

DROP TABLE Company;

DROP TABLE Conference;

DROP TABLE Day;

DROP TABLE Participant;

DROP TABLE ParticipantOfDay;

DROP TABLE ParticipantOfWorkshop;

DROP TABLE PaymentThresholds;

DROP TABLE Payments;

DROP TABLE Reservation;

DROP TABLE ReservationForDay;

DROP TABLE ReservationForWorkshop;

DROP TABLE Workshop;

-- End of file.

