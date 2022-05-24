CREATE TABLE Guest
    (GuestID        NUMBER NOT NULL,
     Name           NVARCHAR2 (50) NOT NULL,
     Surname        NVARCHAR2 (50) NOT NULL,
     Phone_number   NUMBER (11),
     Email          NVARCHAR2 (25),
     PESEL          NUMBER (11)
    );
     
CREATE UNIQUE INDEX GuestID
ON Guest (GuestID);

ALTER TABLE Guest
ADD (CONSTRAINT GuestID
        PRIMARY KEY (GuestID)
    );