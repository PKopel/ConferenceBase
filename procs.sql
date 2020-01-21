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

--dodanie rozerwacji dnia

--dodanie rezerwacji warsztatu

--dodanie uczestnika 

--dodanie konferencji

--dodanie dnia konferencji 

--dodanie warsztatów

--uiszczenie opłaty

--dodanie progu cenowego

--anulowanie rezerwacji

--odwoływanie konferencji

--odwoływanie dnia konferencji

--odwoływanie warsztatów

--zmiana ilości miejsc w danym dniu

--zmiana ilości miejsc na danym warsztacie

