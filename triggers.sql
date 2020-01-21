--sprawdzenie czy liczba miesc w dniu i na warsztacie zgadza się dla rezerwacji (załadowany)

create trigger ReservationPlacesCheck
    on ReservationForWorkshop
    after insert
    as
begin
    declare @ReservationID int, @WorkshopID int;
    select @ReservationID = ReservationID from INSERTED;
    select @WorkshopID = WorkshopID from INSERTED;
    declare @WorkshopDayID int, @SumOfParticipants int;
    execute @WorkshopDayID = WORKSHOP_DAY_ID @WorkshopID;
    execute @SumOfParticipants = SUM_RESERVATION_WORKSHOP_PARTICIPANTS @ReservationID, @WorkshopDayID;
    if (@SumOfParticipants > (
        select NumberOfParticipants
        from ReservationForDay rfd
        where rfd.ReservationID = @ReservationID
          and rfd.DayID = @WorkshopDayID)
        )
        begin
            rollback
        end
end;

--sprawdzenie czy liczba wolnych miejsc w dniu zgadza sie z nową rezerwacją (załadowany)

create trigger NewReservationDayCheck
    on ReservationForDay
    after insert
    as
begin
    declare @DayID int;
    select @DayID = DayID from inserted;
    if (select MaxParticipants from Day where Day.DayID = @DayID)
        <
       (select SUM(NumberOfParticipants) from ReservationForDay where DayID = @DayID group by DayID)
        begin
            rollback
        end
end

--sprawdzenie czy liczba wolnych miejsc na warsztaci zgadza się z nową rezerwacją (załadowany)

create trigger NewReservationWorkshopCheck
    on ReservationForWorkshop
    after insert
    as
begin
    declare @WorkshopID int;
    select @WorkshopID = WorkshopID from inserted;
    if (select MaxParticipants from Workshop where Workshop.WorkshopID = @WorkshopID)
        <
       (select SUM(NumberOfParticipants) from ReservationForWorkshop where WorkshopID = @WorkshopID group by WorkshopID)
        begin
            rollback
        end
end

--sprawdzenie czy liczba miejsc zgadza sie po zmianie ilości miejsc na warsztat (załadowany)

create trigger NumberOfPlacesWorkshopCheck
    on Workshop
    after update
    as
begin
    declare @WorkshopID int;
    select @WorkshopID = WorkshopID from inserted;
    if (select MaxParticipants from Workshop where Workshop.WorkshopID = @WorkshopID)
        <
       (select SUM(NumberOfParticipants) from ReservationForWorkshop where WorkshopID = @WorkshopID group by WorkshopID)
        begin
            rollback
        end
end

--sprawdzenie czy liczba miejsc zgadza sie po zmianie ilości miejsc na dzień (załadowany)

create trigger NumberOfPlacesDayCheck
    on Day
    after update
    as
begin
    declare @DayID int;
    select @DayID = DayID from inserted;
    if (select MaxParticipants from Day where DayID = @DayID)
        <
       (select SUM(NumberOfParticipants) from ReservationForDay where DayID = @DayID group by DayID)
        begin
            rollback
        end
end

--odwoływanie dni odwołanej konferencji

create trigger CancelDayOfCanceledConference
    on Conference
    after update
    as
    begin
        declare @ConferenceID int;
        select @ConferenceID = ConferenceID from inserted;
        update
            set Canceled
    end