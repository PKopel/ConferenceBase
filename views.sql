
create view ReservationForConference as
select distinct ConferenceName, Reservation.ReservationID, ClientID
from Conference
         inner join Day on Day.ConferenceID = Conference.ConferenceID
         inner join ReservationForDay rfd on rfd.DayID = Day.DayID
         inner join Reservation on Reservation.ReservationID = rfd.ReservationID
where Conference.Cancelled <> 1
  and Reservation.Cancelled <> 1

create view ClientActivity as
select COUNT(Reservation.ReservationID) as NumberOfReservations,
       SUM(NumberOfParticipants)        as NumberOfParticipants,
       Client.ClientID
from Client
         inner join Reservation on Client.ClientID = Reservation.ClientID
         inner join ReservationForDay rfd on Reservation.ReservationID = rfd.ReservationID
where Reservation.Cancelled <> 1
group by Client.ClientID
