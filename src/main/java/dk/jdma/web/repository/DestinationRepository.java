package dk.jdma.web.repository;

import dk.jdma.web.domain.Destination;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface DestinationRepository extends CrudRepository<Destination, Long> {

    Destination findByName(String name);

}
