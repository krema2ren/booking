package dk.jdma.web.controller;

import dk.jdma.web.domain.Destination;
import dk.jdma.web.domain.Kayak;
import dk.jdma.web.domain.Person;
import dk.jdma.web.domain.Trip;
import dk.jdma.web.repository.DestinationRepository;
import dk.jdma.web.repository.TripRepository;
import dk.jdma.web.repository.KayakRepository;
import dk.jdma.web.repository.PersonRepository;
import dk.jdma.web.web.FinishForm;
import dk.jdma.web.web.TestForm;
import org.joda.time.DateTime;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Random;

@Controller
public class TestController {

    Logger logger =  LoggerFactory.getLogger(TestController.class);

    @Autowired
    PersonRepository personRepository;

    @Autowired
    KayakRepository kayakRepository;

    @Autowired
    TripRepository tripRepository;

    @Autowired
    DestinationRepository destinationRepository;

    @RequestMapping(value = "/test", method = RequestMethod.GET)
    public ModelAndView test() {
        ModelAndView mv = new ModelAndView("test");
        return mv;
    }

    @RequestMapping(value = "/create_data.html", method = RequestMethod.POST)
    public ModelAndView finish(@ModelAttribute TestForm testForm) {
        if(testForm.getNoOfTrips() > 0) {
            for(int i=0; i<testForm.getNoOfTrips(); i++) {
                createRandomTripAndPersist();
            }
            logger.debug(testForm.getNoOfTrips() + " random trips created.");
        }
        ModelAndView mv = new ModelAndView("admin");
        return mv;
    }

    private void createRandomTripAndPersist() {
        Random random = new Random();
        random.setSeed(new Date().getTime());

        List<Person> persons = (List<Person>)personRepository.findAll();
        Person person = persons.get(random.nextInt(persons.size()-1));

        List<Kayak> kayaks = (List<Kayak>)kayakRepository.findAll();
        Kayak kayak = kayaks.get(random.nextInt(kayaks.size()-1));

        List<Destination> destinations = (List<Destination>)destinationRepository.findAll();
        Destination destination = destinations.get(random.nextInt(destinations.size()-1));

        Trip trip = new Trip();
        trip.setDistance(destination.getDistance());
        trip.setBookingDate(new DateTime(createRandomDate()));
        trip.setReturnDate(new DateTime(trip.getBookingDate()).plusHours((int) Math.round(48*Math.random())));
        trip.setKayak(kayak);
        List<Person> personList = new ArrayList<Person>();
        personList.add(person);
        trip.setPersons(personList);
        trip.setDestination(destination);
        trip.setReturned(trip.getReturnDate().isBefore(new Date().getTime()));
        tripRepository.save(trip);
    }

    private Date createRandomDate() {
        try {
            long start = new SimpleDateFormat("yyyy").parse("2015").getTime();
            final long millisInYear = 1000 * 60 * 60 * 24 * 365;
            long millis = Math.round(millisInYear * Math.random());
            return new Date(millis);
        } catch (ParseException e) {
            logger.debug(e.getMessage());
        }
        return new Date();
    }
}
