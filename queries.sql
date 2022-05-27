REM *****QUIERIES*****

REM 1
SELECT AVG(Fee) FROM Payment;
REM 2
SELECT RoomID FROM Room ORDER BY Capacity DESC;
REM 3
SELECT COUNT(DISTINCT Standard) FROM Room;
REM 4
SELECT DISTINCT GuestID DISTINCT Name, DISTINCT Surname FROM Guest;
REM 5
SELECT MAX(Paid_date) FROM Payment;
REM 6
SELECT MAX(Fee), MIN(Fee) FROM Payment;
REM 7
SELECT PaymentID FROM Payment WHERE Paid_date IS NULL;
REM 8
SELECT MAX(Salary) AS MAID_MAX_SALARY FROM Maid;
REM 9
SELECT End_date FROM Reservation WHERE End_date > SYSDATE ;
REM 10
SELECT AVG(End_date-Start_date) FROM Reservation;

CREATE OR REPLACE PACKAGE pkg_Hotel IS


REM *****PROCEDURES*****
REM 1
SET SERVEROUTPUT ON
CREATE OR REPLACE PROCEDURE rooms_by_floor(x IN VARCHAR2) AS
CURSOR cur IS SELECT RoomID FROM Room WHERE SUBSTR(Room_number, 1, 1) = x;
id cur%rowtype;
BEGIN
OPEN cur;
LOOP
FETCH cur INTO id;
    EXIT WHEN cur%notfound;
    DBMS_OUTPUT.put_line(id.RoomID);
END LOOP;
CLOSE cur;
END;
BEGIN
rooms_by_floor(3);
END;

REM 2
DROP PROCEDURE add_res;
SET SERVEROUTPUT ON
CREATE OR REPLACE PROCEDURE add_res(r_id IN Reservation.ReservationID%TYPE,guest_id IN Reservation.GuestID%TYPE, room_id IN Reservation.RoomID%TYPE, payment_id IN Reservation.PaymentID%TYPE, startDate IN Reservation.Start_date%TYPE, days IN Reservation.End_date%TYPE) AS
exep1 EXCEPTION;
exep2 EXCEPTION;
exep3 EXCEPTION;
exep4 EXCEPTION;
re Reservation%ROWTYPE;
gu Guest%ROWTYPE;
ro Room%ROWTYPE;
pa Payment%ROWTYPE;
BEGIN
SELECT * INTO re FROM Reservation WHERE ReservationID=r_id;
SELECT * INTO gu FROM Guest WHERE GuestID=guest_id;
SELECT * INTO ro FROM Room WHERE RoomID=room_id;
SELECT * INTO pa FROM Payment WHERE PaymentID=payment_id;
IF re.ReservationID IS NOT NULL THEN RAISE exep1;
ELSIF gu.GuestID IS NULL THEN RAISE exep2;
ELSIF ro.RoomID IS NULL THEN RAISE exep3;
ELSIF pa.PaymentID IS NULL THEN RAISE exep4;
ELSE
INSERT INTO Reservation VALUES
(r_id,
guest_id,
room_id,
payment_id,
startDate,
days);
END IF;
EXCEPTION
WHEN exep1 THEN
DBMS_OUTPUT.PUT_LINE('INVALID RESERVATION ID!');
WHEN exep2 THEN
DBMS_OUTPUT.PUT_LINE('INVALID GUEST ID!');
WHEN exep3 THEN
DBMS_OUTPUT.PUT_LINE('INVALID ROOM ID!');
WHEN exep4 THEN
DBMS_OUTPUT.PUT_LINE('INVALID PAYMENT ID!');
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('ERROR!');
END;
BEGIN
add_res(11,10,25,10,'27-Mar-22','29-Mar-22');
END;
SELECT * FROM Reservation;

REM 3
SET SERVEROUTPUT ON
CREATE OR REPLACE PROCEDURE promotion(id IN Maid.MaidID%TYPE, prom IN Maid.Salary%TYPE) AS
BEGIN
UPDATE Maid
SET Salary = Salary + prom
WHERE MaidID = id;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
      dbms_output.put_line('There is no maid with this ID');
WHEN others THEN
      dbms_output.put_line('Error!');
END;
BEGIN
promotion(10,100);
END;
SELECT * FROM Maid;

END pkg_Hotel;