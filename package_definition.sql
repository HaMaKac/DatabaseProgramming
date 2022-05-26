CREATE OR REPLACE PACKAGE pkg_Hotel IS

		FUNCTION CONVERT_CURRENCY (p_price IN NUMBER, p_iso VARCHAR2) RETURN NUMBER;
		FUNCTION COUNT_DIALING_CODE(p_dialing_code IN NVARCHAR2) RETURN NUMBER;
		PROCEDURE rooms_by_floor(x IN VARCHAR2);
		PROCEDURE add_res(r_id IN Reservation.ReservationID%TYPE,guest_id IN Reservation.GuestID%TYPE, room_id IN Reservation.RoomID%TYPE, payment_id IN Reservation.PaymentID%TYPE, startDate IN Reservation.Start_date%TYPE, days IN Reservation.End_date%TYPE);
		PROCEDURE promotion(id IN Maid.MaidID%TYPE, prom IN Maid.Salary%TYPE);

END pkg_Hotel;