package dk.jdma.web.repository;

import dk.jdma.web.domain.Kayak;
import dk.jdma.web.domain.Maintenance;
import org.springframework.data.repository.CrudRepository;

import java.util.List;

public interface MaintenanceRepository extends CrudRepository<Maintenance,Long> {

    List<Maintenance> findByKayak(Kayak kayak);

}
