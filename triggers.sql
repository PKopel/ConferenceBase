--check if sum of numbers of participants in workshops is not higher than number of participants on day

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
                 inner join Reservation R on rfd.ReservationID = R.ReservationID
        where rfd.ReservationID = @ReservationID
          and rfd.DayID = @WorkshopDayID
          and R.Cancelled <> 1)
        )
        begin
            rollback
        end
end;

--check if sum of numbers of participants on day is not higher than max number of participants on day

create trigger NewReservationDayCheck
    on ReservationForDay
    after insert, update
    as
begin
    declare @DayID int;
    select @DayID = DayID from inserted;
    if (select MaxParticipants from Day where Day.DayID = @DayID)
        <
       (select SUM(NumberOfParticipants)
        from ReservationForDay rfd
                 inner join Reservation R on rfd.ReservationID = R.ReservationID
        where DayID = @DayID
          and R.Cancelled <> 1
        group by DayID)
        begin
            rollback
        end
end

create trigger NumberOfPlacesDayCheck
    on Day
    after update
    as
begin
    declare @DayID int;
    select @DayID = DayID from inserted;
    if (select MaxParticipants from Day where DayID = @DayID)
        <
       (select SUM(NumberOfParticipants)
        from ReservationForDay rfd
                 inner join Reservation R on rfd.ReservationID = R.ReservationID
        where DayID = @DayID
          and R.Cancelled <> 1
        group by DayID)
        begin
            rollback
        end
end


--check if sum of numbers of participants in workshop is not higher than max number of participants in workshop

create trigger NewReservationWorkshopCheck
    on ReservationForWorkshop
    after insert, update
    as
begin
    declare @WorkshopID int;
    select @WorkshopID = WorkshopID from inserted;
    if (select MaxParticipants from Workshop where Workshop.WorkshopID = @WorkshopID)
        <
       (select SUM(NumberOfParticipants)
        from ReservationForWorkshop rfw
                 inner join Reservation R on rfw.ReservationID = R.ReservationID
        where WorkshopID = @WorkshopID
          and R.Cancelled <> 1
        group by WorkshopID)
        begin
            rollback
        end
end

create trigger NumberOfPlacesWorkshopCheck
    on Workshop
    after update
    as
begin
    declare @WorkshopID int;
    select @WorkshopID = WorkshopID from inserted;
    if (select MaxParticipants from Workshop where Workshop.WorkshopID = @WorkshopID)
        <
       (select SUM(NumberOfParticipants)
        from ReservationForWorkshop rfw
                 inner join Reservation R on rfw.ReservationID = R.ReservationID
        where WorkshopID = @WorkshopID
          and R.Cancelled <> 1
        group by WorkshopID)
        begin
            rollback
        end
end

--cancel days of cancelled conference

create trigger CancelDaysOfCanceledConference
    on Conference
    after update
    as
begin
    if UPDATE(Cancelled)
        begin
            declare @ConferenceID int;
            select @ConferenceID = ConferenceID from inserted;
            update Day
            set Cancelled = 1
            where Day.ConferenceID = @ConferenceID
        end
end


--cancel workshops on cancelled day
create trigger CancelWorkshopsOfCanceledDay
    on Day
    after UPDATE
    AS
begin
    if UPDATE(Cancelled)
        begin
            declare @DayID int;
            select @DayID = DayID from inserted;
            update Workshop
            set Cancelled = 1
            where Workshop.DayID = @DayID
        end
end

