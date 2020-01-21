--lista uczestników dnia konferencji (załadowane)

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


--widok rezerwacji klienta z cenami (załadowane)

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

--widok warsztatów z uczestnikami (załadowane)

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


--widok rezerwacji na konferencję (załadowane)

create view ReservationForConference as
select distinct ConferenceName, Reservation.ReservationID, ClientID
from Conference
         inner join Day on Day.ConferenceID = Conference.ConferenceID
         inner join ReservationForDay rfd on rfd.DayID = Day.DayID
         inner join Reservation on Reservation.ReservationID = rfd.ReservationID
where Conference.Cancelled <> 1
  and Reservation.Cancelled <> 1

--widok aktywności klientów (załadowane)

create view ClientActivity as
select COUNT(Reservation.ReservationID) as NumberOfReservations,
       SUM(NumberOfParticipants)        as NumberOfParticipants,
       Client.ClientID
from Client
         inner join Reservation on Client.ClientID = Reservation.ClientID
         inner join ReservationForDay rfd on Reservation.ReservationID = rfd.ReservationID
where Reservation.Cancelled <> 1
group by Client.ClientID
