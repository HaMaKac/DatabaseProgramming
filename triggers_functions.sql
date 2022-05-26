-- Triggers
-- 1
CREATE OR REPLACE TRIGGER t_discount
    AFTER INSERT ON Reservation
    REFERENCING NEW AS NEW OLD AS OLD
    FOR EACH ROW
DECLARE
    v_new_fee NUMBER;
BEGIN
    SELECT fee INTO v_new_fee
    FROM payment
    WHERE paymentID = :NEW.paymentID;
    
    IF (:NEW.end_date - :NEW.start_date) >= 21 THEN
        UPDATE payment
        SET fee = v_new_fee - 5/100 * v_new_fee
        WHERE paymentID = :NEW.paymentID;
    END IF;
END;

-- 2
CREATE OR REPLACE TRIGGER t_check_date
    BEFORE INSERT ON RESERVATION
    REFERENCING NEW AS NEW OLD AS OLD
    FOR EACH ROW
DECLARE
    v_start_date DATE;
    v_end_date DATE;
    e_incorrect_date EXCEPTION;
BEGIN
    SELECT start_date, end_date 
    INTO v_start_date, v_end_date
    FROM reservation
    WHERE reservationid = :NEW.reservationid;
    
    IF v_start_date > v_end_date THEN
        RAISE e_incorrect_date;
    END IF;
        
EXCEPTION
    WHEN e_incorrect_date THEN
        raise_application_error(-20000, 'End date cannot be earlier than start date');
    WHEN OTHERS THEN
        raise_application_error(-20000, 'Error');
END;

-- 3
CREATE OR REPLACE TRIGGER t_check_capacity
    BEFORE INSERT ON RESERVATION
    REFERENCING NEW AS NEW OLD AS OLD
    FOR EACH ROW
DECLARE
    v_capacity NUMBER;
    e_wrong_count EXCEPTION;
BEGIN
    SELECT capacity INTO v_capacity
    FROM room
    WHERE roomid = :NEW.roomid;
    
    IF :NEW.people > v_capacity THEN
        RAISE e_wrong_count;
    END IF;
EXCEPTION
    WHEN e_wrong_count THEN
        raise_application_error(-20000, 'Wrong count of guests');
    WHEN OTHERS THEN
        raise_application_error(-20000, 'Error');
END;

-- Trigger tests
DELETE FROM RESERVATION
WHERE reservationid = 10;

INSERT INTO Reservation(reservationid, guestid, roomid, paymentid, start_date, end_date, people) 
VALUES (10, 10, 25, 10, '03-JUN-22', '04-JUN-22', 2);

SELECT * FROM Reservation;

CREATE OR REPLACE PACKAGE BODY pkg_Hotel IS


-- Functions
-- 1
CREATE OR REPLACE FUNCTION CONVERT_CURRENCY(
    p_price IN NUMBER, p_iso VARCHAR2)
RETURN NUMBER
IS
    e_incorrect_iso EXCEPTION;
BEGIN
    IF p_iso = 'EUR' THEN
        RETURN p_price * 0.22;
    ELSIF p_iso = 'HRK' THEN
        RETURN p_price * 1.63;
    ELSIF p_iso = 'CZK' THEN
        RETURN p_price * 5.35;
    ELSIF p_iso = 'ISK' THEN
        RETURN p_price * 29.95;
    ELSE
        RAISE e_incorrect_iso;
    END IF;
    
EXCEPTION
    WHEN e_incorrect_iso THEN
        DBMS_OUTPUT.PUT_LINE('Incorrect ISO');
        RETURN -1;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error');
        RETURN -1;
        
END CONVERT_CURRENCY;

BEGIN
	DBMS_OUTPUT.PUT_LINE('Results for 100 -> EUR: ' || CONVERT_CURRENCY(100, 'EUR'));
	DBMS_OUTPUT.PUT_LINE('Results for 100 -> GBP: ' || CONVERT_CURRENCY(100, 'GBP'));
END;

-- 2
CREATE OR REPLACE FUNCTION COUNT_DIALING_CODE(
    p_dialing_code IN NVARCHAR2)
RETURN NUMBER
IS
    v_count NUMBER := 0;
    
    CURSOR c_count IS 
        SELECT phone_number
        FROM guest
        WHERE SUBSTR(phone_number, 1, LENGTH(p_dialing_code)) = p_dialing_code;
    
BEGIN
    FOR elem IN c_count
    LOOP
        v_count := v_count + 1;
    END LOOP;
    
    RETURN v_count;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No data found');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error');
    
END COUNT_DIALING_CODE;


END pkg_Hotel;

--Function tests
-- 1
BEGIN
	DBMS_OUTPUT.PUT_LINE('Results for 100 -> EUR: ' || CONVERT_CURRENCY(100, 'EUR'));
	DBMS_OUTPUT.PUT_LINE('Results for 100 -> GBP: ' || CONVERT_CURRENCY(100, 'GBP'));
END;
-- 2
BEGIN
	DBMS_OUTPUT.PUT_LINE('Results for +48: ' || COUNT_DIALING_CODE('+48'));
	DBMS_OUTPUT.PUT_LINE('Results for +42: ' || COUNT_DIALING_CODE('+42'));
END;


