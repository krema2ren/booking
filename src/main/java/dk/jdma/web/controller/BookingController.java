package dk.jdma.web.controller;

import dk.jdma.web.domain.*;
import dk.jdma.web.repository.BookingRepository;
import dk.jdma.web.repository.DestinationRepository;
import dk.jdma.web.repository.KayakRepository;
import dk.jdma.web.repository.PersonRepository;
import dk.jdma.web.web.AddPersonForm;
import dk.jdma.web.web.BookingForm;
import dk.jdma.web.web.FinishForm;
import org.joda.time.DateTime;
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
    BookingRepository bookingRepository;

    @Autowired
    DestinationRepository destinationRepository;

	BookingController() {
	}

	@RequestMapping(value = "/", method = RequestMethod.GET)
	public ModelAndView home() {
		ModelAndView model = new ModelAndView("booking");
        List<Booking> bookings = bookingRepository.findActiveBookings(DateTime.now());
        model.getModelMap().addAttribute("bookings", bookings);
        model.getModelMap().addAttribute("bookingForm", new BookingForm());
        model.getModelMap().addAttribute("addPersonForm", new AddPersonForm());
        model.getModelMap().addAttribute("finishForm", new FinishForm());
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

    @RequestMapping(value = "/delete_booking.html", method = RequestMethod.GET)
    public ModelAndView deleteBooking(@RequestParam String id) {
        bookingRepository.delete(Long.parseLong(id));
        return new ModelAndView(new RedirectView("/booking"));
    }


    @RequestMapping(value = "/add_person.html", method = RequestMethod.POST)
    public ModelAndView addPerson(@ModelAttribute AddPersonForm addPersonForm) {
        Booking booking = bookingRepository.findOne(Long.parseLong(addPersonForm.getBookingId()));
        Person person = personRepository.findByName(addPersonForm.getName());
        if(booking != null && person != null) {
            booking.getPersons().add(person);
            bookingRepository.save(booking);
        }
        return new ModelAndView(new RedirectView("/booking"));
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
                }
                destinationRepository.save(destination);
            } else {
                // TODO: set default destination
            }

        }
        Booking booking = new Booking();
        booking.setBookingDate(DateTime.now());
        booking.setReturnDate(new DateTime(booking.getBookingDate()).plusHours(destination.getDistance().intValue()/3));
        booking.setKayak(kayak);
        List<Person> persons = new ArrayList<Person>();
        persons.add(person);
        booking.setPersons(persons);
        booking.setDestination(destination);
        bookingRepository.save(booking);
        return new ModelAndView(new RedirectView("/booking"));
    }

    @RequestMapping(value = "/finish.html", method = RequestMethod.POST)
    public ModelAndView finish(@ModelAttribute FinishForm finishForm) {
        Booking booking = bookingRepository.findOne(Long.parseLong(finishForm.getBookingId()));
        if(booking != null) {
            booking.setDistance(Double.parseDouble(finishForm.getDistance()));
            booking.setReturnDate(DateTime.now());
            booking.setReturned(true);
            bookingRepository.save(booking);
        }
        return new ModelAndView(new RedirectView("/booking"));
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
        List<Booking> bookings = (List<Booking>)bookingRepository.findAll();
        int idx=0;
        for (Booking booking : bookings) {
            result.add(new Tag(idx++, booking.toString()));
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
