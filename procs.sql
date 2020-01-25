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


--dodanie rezerwacji warsztatu

            create procedure add_workshop_reservation @ReservationID NUMERIC,
                                                      @WorkshopID NUMERIC,
                                                      @NumberOfParticipant NUMERIC
            AS
            BEGIN
                insert into ReservationForWorkshop (ReservationID, WorkshopID, NumberOfParticipants)
                values (@ReservationID, @WorkshopID, @NumberOfParticipant)
            END

--dodanie uczestnika 
                create procedure add_participant @ReservationID NUMERIC,
                                                 @First_Name varchar(20),
                                                 @Last_Name varchar(20),
                                                 @Student_Card_Number varchar(20),
                                                 @Student_Card_Validity_Date DATE
                AS
                BEGIN
                    insert into Participant (FirstName, LastName, ReservationID, StudentCardNumber,
                                             StudentCardValidityDate)
                    values (@First_Name, @Last_Name, @ReservationID, @Student_Card_Number, @Student_Card_Validity_Date)
                END

--dodanie konferencji
                    create procedure add_Conference @Conference_Name varchar(30),
                                                    @discount float(5)
                    AS
                    BEGIN
                        insert into Conference (ConferenceName, discount)
                        values (@Conference_Name, @discount)
                    END


--dodanie dnia konferencji 

                        create procedure add_Conference_day @ConferenceID INT,
                                                            @DayDate DATE,
                                                            @MaxParticipants INT
                        AS
                        BEGIN
                            insert into Day (ConferenceID, DayDate, MaxParticipants)
                            values (@ConferenceID, @DayDate, @MaxParticipants)
                        END


--dodanie warsztatów

                            create procedure add_workshop @Max_Participants INT,
                                                          @price money,
                                                          @StartTime time,
                                                          @duration int,
                                                          @Workshop_Name varchar(50),
                                                          @Day_ID INT
                            AS
                            BEGIN
                                insert into Workshop (MaxParticipants, Price, StartTime, Duration, WorkshopName, DayID)
                                values (@Max_Participants, @price, @StartTime, @duration, @Workshop_Name, @Day_ID)
                            end

--uiszczenie opłaty
                                create procedure payment @Reservation_ID INT,
                                                         @date DATE,
                                                         @AmountPaid money
                                AS
                                BEGIN
                                    insert into Payments (ReservationID, PaymentDate, AmountPaid)
                                    values (@Reservation_ID, @date, @AmountPaid)
                                END


--dodanie progu cenowego

                                    create procedure add_Payment_Threshold @ThresholdID varchar(20),
                                                                           @Conference_ID INT,
                                                                           @ThresholdDate date,
                                                                           @price money
                                    as
                                    BEGIN
                                        insert into PaymentThresholds (ThresholdID, ConferenceID, ThresholdDate, Price)
                                        values (@ThresholdID, @Conference_ID, @ThresholdDate, @price)
                                    END

--odwoływanie konferencji
                                        create procedure cancelConference @Conference_ID int
                                        as
                                        begin
                                            update Conference
                                            set Cancelled = 1
                                            where ConferenceID = @Conference_ID
                                              and Cancelled = 0
                                        end

--odwoływanie dnia konferencji
                                            create procedure cancelDay @Day_ID int
                                            as
                                            begin
                                                update Day
                                                set Cancelled = 1
                                                where DayID = @Day_ID
                                                  and Cancelled = 0
                                            end

--odwoływanie warsztatów
                                                create procedure cancelWorkshop @Workshop_ID int
                                                as
                                                begin
                                                    update Workshop
                                                    set Cancelled = 1
                                                    where WorkshopID = @Workshop_ID
                                                      and Cancelled = 0
                                                end

--zmiana ilości miejsc w danym dniu

                                                    create procedure changeCapacityOfDay @Day_ID int, @newCapacity int
                                                    as
                                                    begin
                                                        update Day
                                                        set MaxParticipants = @newCapacity
                                                        where DayID = @Day_ID
                                                    end

--zmiana ilości miejsc na danym warsztacie
                                                        create procedure changeCapacityOfWorkshop @Workshop_ID int, @newCapacity int
                                                        as
                                                        begin
                                                            update Workshop
                                                            set MaxParticipants = @newCapacity
                                                            where WorkshopID = @Workshop_ID
                                                        end
