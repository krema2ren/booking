package dk.jdma.web.repository;

import dk.jdma.web.domain.Booking;
import dk.jdma.web.domain.Person;
import org.joda.time.DateTime;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface BookingRepository extends CrudRepository<Booking, Long> {

    @Query("select b from Booking b where b.bookingDate <= :time and b.returnDate >= :time")
    List<Booking> findActiveBookings(@Param("time") DateTime now);

    List<Booking> findByPersons(List<Person> persons);

//    @Query("select b from Booking_Person b where b.persons)
//    List<Booking> findBookingsByPerson(@Param("id") Long id);

}
