package dk.jdma.web.controller;

import dk.jdma.web.domain.*;
import dk.jdma.web.repository.*;
import dk.jdma.web.web.*;
import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.RedirectView;

import java.util.ArrayList;
import java.util.List;

@Controller
public class BookingController {

    Logger logger =  LoggerFactory.getLogger(BookingController.class);

    @Autowired
    PersonRepository personRepository;

    @Autowired
    KayakRepository kayakRepository;

    @Autowired
    TripRepository tripRepository;

    @Autowired
    DestinationRepository destinationRepository;

    @Autowired
    MaintenanceRepository maintenanceRepository;

	BookingController() {
	}

	@RequestMapping(value = "/", method = RequestMethod.GET)
	public ModelAndView home() {
		ModelAndView model = new ModelAndView("booking");
        List<Trip> trips = tripRepository.findActiveBookings(DateTime.now());
        model.addObject(trips);
        model.addObject(new BookingForm());
        model.addObject(new AddPersonForm());
        model.addObject(new FinishForm());
        model.addObject(new MaintenanceForm());
		return model;
	}

	@RequestMapping(value = "/findKayaks", method = RequestMethod.GET)
	public @ResponseBody
	List<Tag> findKayaks(@RequestParam String tagName) {
		return filter(tagName, findAllKayaks());
	}

	@RequestMapping(value = "/findNames", method = RequestMethod.GET)
	public @ResponseBody
	List<Tag> findNames(@RequestParam String tagName) {
		return filter(tagName, findAllNames());
	}

	@RequestMapping(value = "/findDestinations", method = RequestMethod.GET)
	public @ResponseBody
	List<Tag> findDestinations(@RequestParam String tagName) {
		return filter(tagName, findAllDestinations());
	}

    @RequestMapping(value = "/delete_trip.html", method = RequestMethod.GET)
    public ModelAndView deleteTrip(@RequestParam String id) {
        tripRepository.delete(Long.parseLong(id));
        return new ModelAndView(new RedirectView("/trip"));
    }


    @RequestMapping(value = "/add_person.html", method = RequestMethod.POST)
    public ModelAndView addPerson(@ModelAttribute AddPersonForm addPersonForm) {
        Trip trip = tripRepository.findOne(Long.parseLong(addPersonForm.getBookingId()));
        Person person = personRepository.findByName(addPersonForm.getName());
        if(trip != null && person != null) {
            trip.getPersons().add(person);
            tripRepository.save(trip);
        }
        return new ModelAndView(new RedirectView("/trip"));
    }

    @RequestMapping(value = "/book.html", method = RequestMethod.POST)
    public ModelAndView book(@ModelAttribute @Validated BookingForm bookingForm, BindingResult result) {
        if (result.hasErrors()) {
            ModelAndView model = home();
            model.addObject(bookingForm);
            logger.debug(model.toString());
            return model;
        }
        String[] data = bookingForm.getKayakName().split(" ");
        Kayak kayak = kayakRepository.findByLocation(data[0]);
        Person person = personRepository.findByName(bookingForm.getPersonName());
        Destination destination = destinationRepository.findByName(bookingForm.getDestination());
        if(destination == null) {
            destination = new Destination();

            if(bookingForm.getDestination() != null && !bookingForm.getDestination().isEmpty()) {
                destination.setName(bookingForm.getDestination().trim());
                data = bookingForm.getDestination().split(" ");
                if(data.length > 0 && data[data.length-1].contains("km")) {
                    String km = data[data.length-1].replace("km", "");
                    destination.setDistance(Double.parseDouble(km.trim()));
                } else {
                    destination.setDistance(0d);
                }
                destinationRepository.save(destination);
            } else {
                destination = destinationRepository.findDefaultDestination();
            }
        }
        Trip trip = new Trip();
        trip.setBookingDate(DateTime.now());
        trip.setReturnDate(new DateTime(trip.getBookingDate()).plusHours(destination.getDistance().intValue() == 0 ? 2 : destination.getDistance().intValue()/3));
        trip.setKayak(kayak);
        List<Person> persons = new ArrayList<Person>();
        persons.add(person);
        trip.setPersons(persons);
        trip.setDestination(destination);
        tripRepository.save(trip);
        return new ModelAndView(new RedirectView("/trip"));
    }

    @RequestMapping(value = "/finish.html", method = RequestMethod.POST)
    public ModelAndView finish(@ModelAttribute FinishForm finishForm) {
        Trip trip = tripRepository.findOne(Long.parseLong(finishForm.getBookingId()));
        if(trip != null) {
            trip.setDistance(Double.parseDouble(finishForm.getDistance()));
            trip.setReturnDate(DateTime.now());
            trip.setReturned(true);
            tripRepository.save(trip);
        }
        return new ModelAndView(new RedirectView("/trip"));
    }

    @RequestMapping(value = "/maintenance.html", method = RequestMethod.POST)
    public ModelAndView maintenance(@ModelAttribute @Validated MaintenanceForm maintenanceForm, BindingResult result) {
        Kayak kayak = kayakRepository.findOne(maintenanceForm.getKayakId());
        if(kayak != null) {
            kayak.setMaintenance(true);
            kayakRepository.save(kayak);
            Maintenance maintenance = new Maintenance();
            maintenance.setCreated(DateTime.now());
            maintenance.setKayak(kayak);
            maintenance.setDescription(maintenanceForm.getDescription());
            maintenanceRepository.save(maintenance);
        }
        return new ModelAndView(new RedirectView("/trip"));
    }

	private List<Tag> filter(String tagName, List<Tag> list) {
		List<Tag> result = new ArrayList<Tag>();
		for (Tag tag : list) {
			if (tag.getTagName().toLowerCase().contains(tagName.toLowerCase())) {
				result.add(tag);
			}
		}
		return result;
	}

    private List<Tag> findAllNames() {
        List<Tag> result = new ArrayList<Tag>();
        List<Person> persons = (List<Person>)personRepository.findAll();
        int idx=0;
        for (Person person : persons) {
            result.add(new Tag(idx++, person.getName()));
        }
        return result;
    }

    private List<Tag> findAllKayaks() {
        List<Tag> result = new ArrayList<Tag>();
        List<Kayak> kayaks = (List<Kayak>)kayakRepository.findAll();
        int idx=0;
        for (Kayak kayak : kayaks) {
            result.add(new Tag(kayak.getId(), kayak.getTagName()));
        }
        return result;
    }

    private List<Tag> findAllBookings() {
        List<Tag> result = new ArrayList<Tag>();
        List<Trip> trips = (List<Trip>) tripRepository.findAll();
        int idx=0;
        for (Trip trip : trips) {
            result.add(new Tag(idx++, trip.toString()));
        }
        return result;
    }

    private List<Tag> findAllDestinations() {
        List<Tag> result = new ArrayList<Tag>();
        List<Destination> destinations = (List<Destination>)destinationRepository.findAll();
        int idx=0;
        for (Destination destination : destinations) {
            result.add(new Tag(idx++, destination.getName()));
        }
        return result;
    }


}
