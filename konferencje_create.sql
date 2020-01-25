-- tables (całość załadowana)
-- Table: Client
CREATE TABLE Client
(
    ClientID int identity (0,1),
    Phone    varchar(15) NOT NULL,
    Email    varchar(60) NOT NULL,
    Address  varchar(50) NOT NULL,
    CONSTRAINT Client_pk PRIMARY KEY (ClientID)
);

-- Table: Company
CREATE TABLE Company
(
    NIP         varchar(10) NOT NULL,
    ClientID    int         NOT NULL,
    CompanyName varchar(50) NOT NULL,
    Address     varchar(50) NOT NULL,
    CONSTRAINT Company_pk PRIMARY KEY (NIP)
);

-- Table: Conference
CREATE TABLE Conference
(
    ConferenceID   int identity (0,1),
    ConferenceName varchar(30)   NOT NULL,
    discount       float(5)      NOT NULL,
    Cancelled      bit default 0 NOT NULL,
    CONSTRAINT Conference_pk PRIMARY KEY (ConferenceID)
);

-- Table: Day
CREATE TABLE Day
(
    DayID           int identity (0,1),
    ConferenceID    int           NOT NULL,
    DayDate         date          NOT NULL,
    MaxParticipants int           NOT NULL,
    Cancelled       bit default 0 NOT NULL,
    CONSTRAINT Day_pk PRIMARY KEY (DayID)
);

-- Table: Participant
CREATE TABLE Participant
(
    ParticipantID           int identity (0,1),
    FirstName               varchar(20) NULL,
    LastName                varchar(20) NULL,
    ReservationID           int         NOT NULL,
    StudentCardNumber       varchar(20) NULL,
    StudentCardValidityDate date        NULL,
    CONSTRAINT Participant_pk PRIMARY KEY (ParticipantID)
);

-- Table: ParticipantOfDay
CREATE TABLE ParticipantOfDay
(
    ParticipantID int NOT NULL,
    DayID         int NOT NULL,
    ReservationID int NOT NULL,
    CONSTRAINT ParticipantOfDay_pk PRIMARY KEY (ParticipantID, DayID)
);

-- Table: ParticipantOfWorkshop
CREATE TABLE ParticipantOfWorkshop
(
    ParticipantID int NOT NULL,
    WorkshopID    int NOT NULL,
    ReservationID int NOT NULL,
    CONSTRAINT ParticipantOfWorkshop_pk PRIMARY KEY (ParticipantID, WorkshopID)
);

-- Table: PaymentThresholds
CREATE TABLE PaymentThresholds
(
    ThresholdID   varchar(20) NOT NULL,
    ConferenceID  int         NOT NULL,
    ThresholdDate date        NOT NULL,
    Price         money       NOT NULL,
    CONSTRAINT PaymentThresholds_pk PRIMARY KEY (ThresholdID)
);

-- Table: Payments
CREATE TABLE Payments
(
    PaymentID     int identity (0,1),
    ReservationID int   NOT NULL,
    PaymentDate   date  NOT NULL,
    AmountPaid    money NOT NULL,
    CONSTRAINT Payments_pk PRIMARY KEY (PaymentID)
);

-- Table: Reservation
CREATE TABLE Reservation
(
    ReservationID   int identity (0,1),
    ReservationDate date          NOT NULL,
    ClientID        int           NOT NULL,
    Cancelled       bit default 0 NOT NULL,
    CONSTRAINT Reservation_pk PRIMARY KEY (ReservationID)
);

-- Table: ReservationForDay
CREATE TABLE ReservationForDay
(
    ReservationID        int           NOT NULL,
    DayID                int           NOT NULL,
    NumberOfParticipants int           NOT NULL,
    NumberOfStudents     int default 0 NOT NULL,
    CONSTRAINT ReservationForDay_pk PRIMARY KEY (ReservationID, DayID)
);

-- Table: ReservationForWorkshop
CREATE TABLE ReservationForWorkshop
(
    ReservationID        int           NOT NULL,
    WorkshopID           int           NOT NULL,
    NumberOfParticipants int           NOT NULL,
    NUmberOfStudents     int default 0 NOT NULL,
    CONSTRAINT ReservationForWorkshop_pk PRIMARY KEY (ReservationID, WorkshopID)
);

-- Table: Workshop
CREATE TABLE Workshop
(
    WorkshopID      int identity (0,1),
    MaxParticipants int           NOT NULL,
    Price           money         NOT NULL,
    StartTime       time          NOT NULL,
    Duration        int           NOT NULL,
    WorkshopName    varchar(50)   NOT NULL,
    DayID           int           NOT NULL,
    Cancelled       bit default 0 NOT NULL,
    CONSTRAINT Workshop_pk PRIMARY KEY (WorkshopID)
);

-- foreign keys
-- Reference: Company_Client (table: Company)
ALTER TABLE Company
    ADD CONSTRAINT Company_Client
        FOREIGN KEY (ClientID)
            REFERENCES Client (ClientID);

-- Reference: Day_Conference (table: Day)
ALTER TABLE Day
    ADD CONSTRAINT Day_Conference
        FOREIGN KEY (ConferenceID)
            REFERENCES Conference (ConferenceID);

-- Reference: ParticipantOfDay_Participant (table: ParticipantOfDay)
ALTER TABLE ParticipantOfDay
    ADD CONSTRAINT ParticipantOfDay_Participant
        FOREIGN KEY (ParticipantID)
            REFERENCES Participant (ParticipantID);

-- Reference: ParticipantOfDay_ReservationForDay (table: ParticipantOfDay)
ALTER TABLE ParticipantOfDay
    ADD CONSTRAINT ParticipantOfDay_ReservationForDay
        FOREIGN KEY (ReservationID, DayID)
            REFERENCES ReservationForDay (ReservationID, DayID);

-- Reference: ParticipantOfWorkshop_Participant (table: ParticipantOfWorkshop)
ALTER TABLE ParticipantOfWorkshop
    ADD CONSTRAINT ParticipantOfWorkshop_Participant
        FOREIGN KEY (ParticipantID)
            REFERENCES Participant (ParticipantID);

-- Reference: ParticipantOfWorkshop_ReservationForWorkshop (table: ParticipantOfWorkshop)
ALTER TABLE ParticipantOfWorkshop
    ADD CONSTRAINT ParticipantOfWorkshop_ReservationForWorkshop
        FOREIGN KEY (ReservationID, WorkshopID)
            REFERENCES ReservationForWorkshop (ReservationID, WorkshopID);

-- Reference: ParticipantOfWorkshop_Workshop (table: ParticipantOfWorkshop)
ALTER TABLE ParticipantOfWorkshop
    ADD CONSTRAINT ParticipantOfWorkshop_Workshop
        FOREIGN KEY (WorkshopID)
            REFERENCES Workshop (WorkshopID);

-- Reference: Participant_Reservation (table: Participant)
ALTER TABLE Participant
    ADD CONSTRAINT Participant_Reservation
        FOREIGN KEY (ReservationID)
            REFERENCES Reservation (ReservationID);

-- Reference: PaymentThresholds_Conference (table: PaymentThresholds)
ALTER TABLE PaymentThresholds
    ADD CONSTRAINT PaymentThresholds_Conference
        FOREIGN KEY (ConferenceID)
            REFERENCES Conference (ConferenceID);

-- Reference: Payments_Reservation (table: Payments)
ALTER TABLE Payments
    ADD CONSTRAINT Payments_Reservation
        FOREIGN KEY (ReservationID)
            REFERENCES Reservation (ReservationID);

-- Reference: ReservationForDay_Day (table: ReservationForDay)
ALTER TABLE ReservationForDay
    ADD CONSTRAINT ReservationForDay_Day
        FOREIGN KEY (DayID)
            REFERENCES Day (DayID);

-- Reference: ReservationForDay_Reservation (table: ReservationForDay)
ALTER TABLE ReservationForDay
    ADD CONSTRAINT ReservationForDay_Reservation
        FOREIGN KEY (ReservationID)
            REFERENCES Reservation (ReservationID);

-- Reference: ReservationForWorkshop_Reservation (table: ReservationForWorkshop)
ALTER TABLE ReservationForWorkshop
    ADD CONSTRAINT ReservationForWorkshop_Reservation
        FOREIGN KEY (ReservationID)
            REFERENCES Reservation (ReservationID);

-- Reference: ReservationForWorkshop_Workshop (table: ReservationForWorkshop)
ALTER TABLE ReservationForWorkshop
    ADD CONSTRAINT ReservationForWorkshop_Workshop
        FOREIGN KEY (WorkshopID)
            REFERENCES Workshop (WorkshopID);

-- Reference: Reservation_Client (table: Reservation)
ALTER TABLE Reservation
    ADD CONSTRAINT Reservation_Client
        FOREIGN KEY (ClientID)
            REFERENCES Client (ClientID);

-- Reference: Workshop_Day (table: Workshop)
ALTER TABLE Workshop
    ADD CONSTRAINT Workshop_Day
        FOREIGN KEY (DayID)
            REFERENCES Day (DayID);

-- End of file.

