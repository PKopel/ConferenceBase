
create procedure add_individual_client @Phone varchar(15),
                                       @Email varchar(60),
                                       @ClientAddress varchar(50)
as
begin
    insert into Client (Phone, Email, Address)
    values (@Phone, @Email, @ClientAddress)
end

create procedure add_company_client @Phone varchar(15),
                                    @Email varchar(60),
                                    @ClientAddress varchar(50),
                                    @NIP varchar(10),
                                    @CompanyName varchar(50),
                                    @CompanyAddress varchar(50)
as
begin
    insert into Client (Phone, Email, Address)
    values (@Phone, @Email, @ClientAddress)
    insert into Company (NIP, ClientID, CompanyName, Address)
    values (@NIP, @@IDENTITY, @CompanyName, @CompanyAddress)
end

create procedure add_reservation @ClientID NUMERIC,
                                 @ConferenceID NUMERIC,
                                 @DayID NUMERIC,
                                 @NumberOfParticipant NUMERIC
AS
BEGIN
    insert into Reservation (ReservationDate, ClientID, Cancelled)
    values ((getdate()), @ClientID, 0)
    insert into ReservationForDay(ReservationID, DayID, NumberOfParticipants)
    values (@@IDENTITY, @DayID, @NumberOfParticipant)
END

create procedure add_workshop_reservation @ReservationID NUMERIC,
                                          @WorkshopID NUMERIC,
                                          @NumberOfParticipant NUMERIC
AS
BEGIN
    insert into ReservationForWorkshop (ReservationID, WorkshopID, NumberOfParticipants)
    values (@ReservationID, @WorkshopID, @NumberOfParticipant)
END

create procedure add_participant @ReservationID NUMERIC,
                                 @FirstName varchar(20),
                                 @LastName varchar(20),
                                 @StudentCardNumber varchar(20),
                                 @StudentCardValidityDate DATE
AS
BEGIN
    insert into Participant (FirstName, LastName, ReservationID, StudentCardNumber,
                            StudentCardValidityDate)
    values (@FirstName, @LastName, @ReservationID, @StudentCardNumber, @StudentCardValidityDate)
END

create procedure add_conference @ConferenceName varchar(30),
                                @discount float(5)
AS
BEGIN
    insert into Conference (ConferenceName, discount)
    values (@ConferenceName, @discount)
END

create procedure add_conference_day @ConferenceID INT,
                                    @DayDate DATE,
                                    @MaxParticipants INT
AS
BEGIN
    insert into Day (ConferenceID, DayDate, MaxParticipants)
    values (@ConferenceID, @DayDate, @MaxParticipants)
END

create procedure add_workshop @MaxParticipants INT,
                              @price money,
                              @StartTime time,
                              @duration int,
                              @WorkshopName varchar(50),
                              @DayID INT
AS
BEGIN
    insert into Workshop (MaxParticipants, Price, StartTime, Duration, WorkshopName, DayID)
    values (@MaxParticipants, @price, @StartTime, @duration, @WorkshopName, @DayID)
end

create procedure payment @Reservation_ID INT,
                         @date DATE,
                         @AmountPaid money
AS
BEGIN
    insert into Payments (ReservationID, PaymentDate, AmountPaid)
    values (@Reservation_ID, @date, @AmountPaid)
END

create procedure add_payment_threshold @ThresholdID varchar(20),
                                       @ConferenceID INT,
                                       @ThresholdDate date,
                                       @price money
as
BEGIN
    insert into PaymentThresholds (ThresholdID, ConferenceID, ThresholdDate, Price)
    values (@ThresholdID, @ConferenceID, @ThresholdDate, @price)
END

create procedure cancel_conference @ConferenceID int
as
begin
    update Conference
    set Cancelled = 1
    where ConferenceID = @ConferenceID
      and Cancelled = 0
end

create procedure cancel_day @DayID int
as
begin
    update Day
    set Cancelled = 1
    where DayID = @DayID
      and Cancelled = 0
end

create procedure cancel_workshop @WorkshopID int
as
begin
    update Workshop
    set Cancelled = 1
    where WorkshopID = @WorkshopID
      and Cancelled = 0
end

create procedure change_capacity_of_day @DayID int,
                                        @newCapacity int
as
begin
    update Day
    set MaxParticipants = @newCapacity
    where DayID = @DayID
end

create procedure change_capacity_of_workshop @WorkshopID int,
                                             @newCapacity int
as
begin
    update Workshop
    set MaxParticipants = @newCapacity
    where WorkshopID = @WorkshopID
end
