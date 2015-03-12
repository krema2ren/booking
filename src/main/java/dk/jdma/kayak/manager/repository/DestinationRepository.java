package dk.jdma.web.repository;

import dk.jdma.web.domain.Destination;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface DestinationRepository extends CrudRepository<Destination, Long> {

    Destination findByName(String name);

    @Query("select d from Destination d where d.name='Træning 10km'")
    Destination findDefaultDestination();

}
