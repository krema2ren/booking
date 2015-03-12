package dk.jdma.web.repository;

import dk.jdma.web.domain.Person;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PersonRepository extends CrudRepository<Person, Long> {

    Person findByName(String name);

   // @Query("select id from (select persons, sum(distance) as total from trip inner join trip_persons on id=trip group by persons) a inner join person on id=a.persons order by total)")
    @Query(value ="select persons, sum(distance) as total from trip inner join trip_persons on id=trip group by persons order by total desc", nativeQuery = true)
    List<Object> findRanking();

}
