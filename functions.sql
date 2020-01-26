--check completeness of participants data

create function CHECK_PARTICIPANTS_DATA(@ReservationID int)
    returns bit
begin
    declare @Nulls int;
    declare @Result bit;
    select @Nulls = COUNT(ParticipantID)
    from Participant
    where (FirstName is null or LastName is null)
      and ReservationID = @ReservationID
    if @Nulls <> 0
        begin
            select @Result = 0
        end
    else
        begin
            select @Result = 1
        end
    return @Result
end

--count free places left on day

create function DAY_FREE_PLACES(@DayID int)
    returns int
begin
    declare @FreePlaces int;
    select @FreePlaces = MaxParticipants - SUM(NumberOfParticipants)
    from Day
             inner join ReservationForDay RFD on Day.DayID = RFD.DayID
             inner join Reservation R on R.ReservationID = RFD.ReservationID
    where RFD.DayID = @DayID
      and R.Cancelled <> 1
    group by Day.DayID, MaxParticipants
alter table Company add constraint one_client unique (ClientID)
    return @FreePlaces
end

--count free places left on workshop

create function WORKSHOP_FREE_PLACES(@WorkshopID int)
    returns int
begin
    declare @FreePlaces int;
    select @FreePlaces = MaxParticipants - SUM(NumberOfParticipants)
    from Workshop
             inner join ReservationForWorkshop RFW on Workshop.WorkshopID = RFW.WorkshopID
             inner join Reservation R on RFW.ReservationID = R.ReservationID
    where RFW.WorkshopID = @WorkshopID
      and R.Cancelled <> 1
    group by Workshop.WorkshopID, MaxParticipants
    return @FreePlaces
end

--count price for reservation

create function PRICE_FOR_RESERVATION(@ReservationID int)
    returns money
begin
    declare @DayPrices money;
    declare @WorkshopPrices money;
    declare @ReservationDate date;
    select @ReservationDate = ReservationDate
    from Reservation
    where ReservationID = @ReservationID

    select @DayPrices = SUM((NumberOfParticipants - NumberOfStudents * discount) * Price)
    from ReservationForDay rfd
             inner join Day D on rfd.DayID = D.DayID
             inner join Conference C on D.ConferenceID = C.ConferenceID
             inner join (select ConferenceID,
                                (select top 1 Price
                                 from PaymentThresholds PT_in
                                 where DATEDIFF(day, @ReservationDate, ThresholdDate) > -1
                                   and PT_in.ConferenceID = PT_out.ConferenceID
                                 order by ThresholdDate desc) as Price
                         from PaymentThresholds PT_out) P on P.ConferenceID = C.ConferenceID
    where rfd.ReservationID = @ReservationID
      and C.Cancelled <> 1
      and D.Cancelled <> 1
    group by rfd.ReservationID

    select @WorkshopPrices = SUM(NumberOfParticipants * Price)
    from ReservationForWorkshop
             inner join Workshop W on ReservationForWorkshop.WorkshopID = W.WorkshopID
    where ReservationID = @ReservationID
      and Cancelled <> 1
    group by ReservationID

    return @DayPrices + @WorkshopPrices
end

--get date of first day in a conference

create function CONFERENCE_DATE(@ConferenceID int)
    returns date
begin
    declare @ConferenceDate date;
    select top 1 @ConferenceDate = DayDate
    from Day
    where ConferenceID = @ConferenceID
      and Cancelled <> 1
    order by DayDate desc
    return @ConferenceDate
end

--sum number of places on workshops on given day belonging to given reservation

create function SUM_RESERVATION_WORKSHOP_PARTICIPANTS(@ReservationID int, @DayID int)
    returns int
begin
    declare @participants int;
    select @participants = SUM(NumberOfParticipants)
    from ReservationForWorkshop rfw
             inner join Workshop on rfw.WorkshopID = Workshop.WorkshopID
    where ReservationID = @ReservationID
      and DayID = @DayID
      and Cancelled <> 1
    return @participants
end

--get dayID from workshop

create function WORKSHOP_DAY_ID(@WorkshopID int)
    returns int
begin
    declare @DayID int;
    select @DayID = DayID
    from Workshop
    where WorkshopID = @WorkshopID
    return @DayID
end

--list of participants of a day

create function DAY_PARTICIPANTS_LIST(@DayID int)
    returns table
        as
        return
        select ConferenceName, DayDate, FirstName, LastName
        from Conference
                 inner join Day on Day.ConferenceID = Conference.ConferenceID
                 inner join ParticipantOfDay pfd on pfd.DayID = Day.DayID
                 inner join Participant on Participant.ParticipantID = pfd.ParticipantID
                 inner join Reservation on Participant.ReservationID = Reservation.ReservationID
        where Day.DayID = @DayID
          and Reservation.Cancelled <> 1

--list of participants of a workshop

create function WORKSHOP_PARTICIPANTS_LIST(@WorkshopID int)
    returns table
        as
        return
        select WorkshopName, StartTime, FirstName, LastName
        from Workshop
                 inner join ParticipantOfWorkshop pfw on pfw.WorkshopID = Workshop.WorkshopID
                 inner join Participant on Participant.ParticipantID = pfw.ParticipantID
                 inner join Reservation on Participant.ReservationID = Reservation.ReservationID
        where Workshop.WorkshopID = @WorkshopID
          and Reservation.Cancelled <> 1

--list of reservations made by given client

create function RESERVATION_PRICES(@ClientID int)
    returns table
        as
        return
        select Reservation.ClientID,
               Reservation.ReservationID,
               u_kopel.dbo.PRICE_FOR_RESERVATION(Reservation.ReservationID) as Price,
               SUM(AmountPaid)                                              as Paid
        from Client
                 inner join Reservation on Client.ClientID = Reservation.ClientID
                 inner join Payments on Payments.ReservationID = Reservation.ReservationID
        where Client.ClientID = @ClientID
          and Reservation.Cancelled <> 1
        group by Reservation.ReservationID, Reservation.ClientID