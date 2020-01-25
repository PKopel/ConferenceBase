--sprawdzenie czy dane uczestników rezerwacji są kompletne (działa)

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

--liczenie wolnych miejsc w dniach (załadowane)

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

--liczenie wolnych miejsc w warsztatach (załadowane)

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

--liczenie opłaty (załadowane)

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

--pierwszy dzień konferencji (załadowane)

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

--liczenie sumy miejsc na warsztatach dla rezerwacji w danym dniu (załadowane)
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

--wyciąganie dnia z warsztatu (załadowane)

create function WORKSHOP_DAY_ID(@WorkshopID int)
    returns int
begin
    declare @DayID int;
    select @DayID = DayID
    from Workshop
    where WorkshopID = @WorkshopID
    return @DayID
end