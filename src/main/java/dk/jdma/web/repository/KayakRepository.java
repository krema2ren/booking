package dk.jdma.web.repository;

import dk.jdma.web.domain.Kayak;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface KayakRepository extends CrudRepository<Kayak,Long> {

    Kayak findByLocation(String location);

}
