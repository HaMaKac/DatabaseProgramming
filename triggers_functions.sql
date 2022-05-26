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
    
    IF (TO_DATE(:NEW.end_date) - TO_DATE(:NEW.start_date)) >= 21 THEN
        UPDATE payment
        SET fee = v_new_fee - 5/100 * v_new_fee
        WHERE paymentID = :NEW.paymentID;
    END IF;
END;

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
        DBMS_OUTPUT.PUT_LINE('Error: Incorrect ISO');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: An unexpected exception has occured');
END CONVERT_CURRENCY;

SET SERVEROUTPUT ON;
BEGIN
    DBMS_OUTPUT.PUT_LINE(CONVERT_CURRENCY(100, 'EUR'));
    DBMS_OUTPUT.PUT_LINE(CONVERT_CURRENCY(100, 'ISK'));
END;

-- 2
CREATE OR REPLACE FUNCTION COUNT_DIALING_CODE(
    p_dialing_code IN VARCHAR2)
RETURN NUMBER
IS
    v_count NUMBER;
    
    CURSOR c_count IS 
        SELECT phone_number
        FROM guest
        WHERE SUBSTR(phone_number, 0, LENGTH(p_dialing_code)) = p_dialing_code;
    
BEGIN
    FOR elem IN c_count
    LOOP
        IF LENGTH(phone_number) - LENGTH(p_dialing_code) = 9 THEN
            v_count := v_count + 1;
        END IF;
    END LOOP;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: No data found');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: An unexpected exception has occured');
    
END COUNT_DIALING_CODE;