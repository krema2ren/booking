package dk.jdma.web.repository;

import dk.jdma.web.domain.Trip;
import dk.jdma.web.domain.Person;
import org.joda.time.DateTime;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TripRepository extends CrudRepository<Trip, Long> {

    @Query("select b from Trip b where b.bookingDate <= :time and b.returnDate >= :time")
    List<Trip> findActiveBookings(@Param("time") DateTime now);

    List<Trip> findByPersons(List<Person> persons);

}
