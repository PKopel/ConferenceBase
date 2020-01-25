--dodanie klienta indywidualnego (działa)
create procedure add_individual_client @Phone varchar(15),
                                       @Email varchar(60),
                                       @ClientAddress varchar(50)
as
begin
    insert into Client (Phone, Email, Address)
    values (@Phone, @Email, @ClientAddress)
end

--dodanie klienta firmy (działa)

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

--dodanie rezerwacji

        create procedure add_reservation @ClientID int,
                                         @ConferenceID int,
                                         @DayID int,
                                         @NumberOfParticipant int
        AS
        BEGIN
            insert into Reservation (ReservationDate, ClientID)
            values ((getdate()), @ClientID)
            insert into ReservationForDay(ReservationID, DayID, NumberOfParticipant)
            values (@@IDENTITY, @DayID, @NumberOfParticipant)
        END


--dodanie rezerwacji warsztatu

            create procedure add_workshop_reservation @ReservationID NUMERIC,
                                                      @WorkshopID NUMERIC,
                                                      @NumberOfParticipant NUMERIC
            AS
            BEGIN
                insert into ReservationForWorkshop (ReservationID, WorkshopID, NumberOfParticipant)
                values (@ReservationID, @WorkshopID, @NumberOfParticipant)
            END

--dodanie uczestnika 
                create procedure add_participant @ReservationID NUMERIC,
                                                 @First_Name varchar(20),
                                                 @Second_Name varchar(20),
                                                 @Student_Card_Number varchar(20),
                                                 @Student_Card_Validity_Date DATE
                AS
                BEGIN
                    insert into Participant (FirstName, LastName, ReservationID, StudentCardNumber,
                                             StudentCardValidityDate)
                    values (@First_Name, @Last_Name, @ReservationID, @Student_Card_Number @Student_Card_Validity_Date)
                END

--dodanie konferencji
                    create procedure add_Conference @Conference_Name varchar(30)
                        @discount float(5)
    AS
                    BEGIN
                        insert into Conference (ConferenceName, discount)
                        values (@Conference_Name, @discount)
                    END


--dodanie dnia konferencji 

                        create procedure add_Conference_day @ConferenceID INT
                                    @Date DATE
                                @MaxParticipants INT
    AS
                        BEGIN
                            insert into Day (ConferenceID, Date, MaxParticipants)
                            values (@ConferenceID, @Date, @MaxParticipants)
                        END


--dodanie warsztatów

                            create procedure add_workshop @Max_Participants INT
                                @price money @Start_Time time
                                @duration time
                                @Workshop_Name varchar (50)
                                @Day_ID INT
    AS
                            BEGIN
                                insert into Workshop (MaxParticipants, Price, StartTime, Duration, WorkshopName, DayID)
                                values (@Max_Participants, @price, @Start_Time, @duration, @Workshop_Name, @Day_ID)

--uiszczenie opłaty
                                create procedure payment @Reservation_ID INT
                                            @date DATE
                                        @Amount_Paid money
    AS
                                BEGIN
                                    insert into Payments (ReservationID, Date, AmountPaid)
                                    values (@Reservation_ID, @date, @Amount_Paid)
                                END


--dodanie progu cenowego

                                    create procedure add_Payment_Thershold @Conference_ID INT
                                        @Days_Before_Conference INT @price money
    as
                                    BEGIN
                                        insert into PaymentThersholds (ConferenceID, DaysBeforeConference, Price)
                                        values (@Conference_ID, @Days_Before_Conference, @price)
                                    END


--anulowanie rezerwacji

--odwoływanie konferencji

--odwoływanie dnia konferencji

--odwoływanie warsztatów

--zmiana ilości miejsc w danym dniu

--zmiana ilości miejsc na danym warsztacie
