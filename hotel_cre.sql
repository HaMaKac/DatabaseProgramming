CREATE TABLE Guest
    (GuestID        NUMBER (6) NOT NULL,
     Name           NVARCHAR2 (50) NOT NULL,
     Surname        NVARCHAR2 (50) NOT NULL,
     Phone_number   NUMBER (11),
     Email          NVARCHAR2 (50),
     PESEL          NUMBER (11)
    );
     
CREATE UNIQUE INDEX guest_pk
ON Guest (GuestID);

ALTER TABLE Guest
ADD (CONSTRAINT guest_pk
        PRIMARY KEY (GuestID)
    );

CREATE TABLE Maid
    (MaidID         NUMBER (6) NOT NULL,
     Name           NVARCHAR2 (50) NOT NULL,
     Surname        NVARCHAR2 (50) NOT NULL,
     Phone_number   NUMBER (11),
     Email          NVARCHAR2 (50),
     PESEL          NUMBER (11) NOT NULL,
     Salary         NUMBER (6,2) NOT NULL
    );
     
CREATE UNIQUE INDEX maid_pk
ON Maid (MaidID);

ALTER TABLE Maid
ADD (CONSTRAINT maid_pk
        PRIMARY KEY (MaidID)
    );
    
CREATE TABLE Payment
    (PaymentID      NUMBER (6) NOT NULL,
     Fee            NUMBER (6,2) NOT NULL,
     Deadline_date  DATE,
     Paid_date      DATE
    );
     
CREATE UNIQUE INDEX payment_pk
ON Payment (PaymentID);

ALTER TABLE Payment
ADD (CONSTRAINT payment_pk
        PRIMARY KEY (PaymentID)
    );
    
CREATE TABLE Room
    (RoomID         NUMBER (6) NOT NULL,
     MaidID         NUMBER (6) NOT NULL,
     Room_number    NUMBER (3) NOT NULL,
     Capacity       NUMBER (2) NOT NULL,
     Standard       NVARCHAR2 (25)
    );
     
CREATE UNIQUE INDEX room_pk
ON Room (RoomID);

ALTER TABLE Room
ADD (CONSTRAINT room_pk
        PRIMARY KEY (RoomID),
     CONSTRAINT room_maid_fk
        FOREIGN KEY (MaidID)
            REFERENCES Maid
    );
    
CREATE TABLE Reservation
    (ReservationID  NUMBER (6) NOT NULL,
     GuestID        NUMBER (6) NOT NULL,
     RoomID         NUMBER (6) NOT NULL,
     PaymentID      NUMBER (6) NOT NULL,
     Start_date     DATE,
     End_date       DATE
    );
     
CREATE UNIQUE INDEX reservation_pk
ON Reservation (ReservationID);

ALTER TABLE Reservation
ADD (CONSTRAINT reservation_pk
        PRIMARY KEY (ReservationID),
     CONSTRAINT reservation_guest_fk
        FOREIGN KEY (GuestID)
            REFERENCES Guest,
     CONSTRAINT reservation_room_fk
        FOREIGN KEY (RoomID)
            REFERENCES Room,
     CONSTRAINT reservation_payment_fk
        FOREIGN KEY (PaymentID)
            REFERENCES Payment
    );