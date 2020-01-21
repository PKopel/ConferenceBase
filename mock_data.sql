exec add_individual_client 77777777, example@email, 'some address'
exec add_company_client 77777778, second@email, 'other address', '123456', 'company ltd', 'company address'

insert into u_kopel.dbo.Reservation (ReservationDate, ClientID) values ('20021112',2)
insert into Participant (FirstName, LastName, ReservationID, StudentCardNumber, StudentCardValidityDate) values (null,null,1,null,null)
insert into Conference(ConferenceName, discount) values ('konferencja testowa', 0.1)
