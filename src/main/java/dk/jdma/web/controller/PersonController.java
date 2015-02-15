package dk.jdma.web.controller;

import dk.jdma.web.domain.Booking;
import dk.jdma.web.domain.Person;
import dk.jdma.web.repository.BookingRepository;
import dk.jdma.web.repository.KayakRepository;
import dk.jdma.web.repository.PersonRepository;
import dk.jdma.web.web.AddPersonForm;
import dk.jdma.web.web.EditPersonForm;
import dk.jdma.web.web.FilterForm;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.RedirectView;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

@Controller
public class PersonController {

    Logger log = LoggerFactory.getLogger(KayakController.class);

    @Autowired
    PersonRepository personRepository;

    @Autowired
    KayakRepository kayakRepository;

    @Autowired
    BookingRepository bookingRepository;

    @RequestMapping(value = "/persons", method = RequestMethod.GET)
    public ModelAndView index(@RequestParam(value="filter",required = false, defaultValue = "") String filter) {
        ModelAndView mv = new ModelAndView("persons");
        List<Person> result = new ArrayList<Person>();
        List<Person> persons = (List<Person>) personRepository.findAll();
        FilterForm filterForm = new FilterForm();
        if(filter != null && !filter.isEmpty()) {
            filterForm.setFilter(filter);
            for(Person person : persons) {
                if(person.toString().toLowerCase().contains(filter.toLowerCase())) {
                    result.add(person);
                }
            }
        } else {
            result.addAll(persons);
        }
        mv.getModelMap().addAttribute("persons", result);
        mv.getModelMap().addAttribute("filterForm", filterForm);
        return mv;
    }

    @RequestMapping(value = "/filter_persons.html", method = RequestMethod.POST)
    public ModelAndView filterPersons(@ModelAttribute FilterForm filterForm) {
        return new ModelAndView(new RedirectView("/booking/persons?filter=" + filterForm.getFilter()));
    }

    @RequestMapping(value = "/person_detail.html", method = RequestMethod.GET)
         public ModelAndView personDetail(@RequestParam(value="id",required = true) String id, @RequestParam(value="filter", required = false) String filter, @ModelAttribute EditPersonForm editPersonForm) {
        ModelAndView mv = new ModelAndView("person_detail");
        Person person = personRepository.findOne(Long.parseLong(id));
        editPersonForm.setPerson(person);
        mv.addObject(editPersonForm);
        List<Person> persons = new ArrayList<Person>();
        persons.add(person);
        List<Booking> bookings = bookingRepository.findByPersons(persons);
        Collections.sort(bookings, new Comparator<Booking>() {
            @Override
            public int compare(Booking b1, Booking b2) {
                return b1.getBookingDate().compareTo(b2.getBookingDate());
            }
        });
        Collections.reverse(bookings);
        mv.addObject(bookings);
        mv.addObject(person);
        FilterForm filterForm = new FilterForm();
        filterForm.setFilter(filter != null ? filter : "");
        mv.addObject(filterForm);
        return mv;
    }

    @RequestMapping(value = "/edit_person.html", method = RequestMethod.GET)
    public ModelAndView editPerson(@RequestParam(value="id",required = true) String id, @ModelAttribute EditPersonForm editPersonForm) {
        ModelAndView mv = new ModelAndView("person_detail");
        Person person = personRepository.findOne(Long.parseLong(id));
        editPersonForm.setPerson(person);
        mv.getModelMap().addAttribute("editPersonForm", editPersonForm);
        List<Person> persons = new ArrayList<Person>();
        persons.add(person);
        List<Booking> bookings = bookingRepository.findByPersons(persons);
        mv.getModelMap().addAttribute("bookings", bookings);
        return mv;
    }

    @RequestMapping(value = "/save_person.html", method = RequestMethod.POST)
    public ModelAndView savePerson(@ModelAttribute EditPersonForm editPersonForm, @RequestParam(value="filter",required = true) String filter) {
        Person person = personRepository.findOne(editPersonForm.getPerson().getId());
        if(person != null) {
            person.setAddress(editPersonForm.getPerson().getAddress());
            person.setEmail(editPersonForm.getPerson().getEmail());
            person.setName(editPersonForm.getPerson().getName());
            person.setMobile(editPersonForm.getPerson().getMobile());
            person.setDayOfBirth(editPersonForm.getPerson().getDayOfBirth());
            person.setPhone(editPersonForm.getPerson().getPhone());
            person.setCreated(editPersonForm.getPerson().getCreated());
            person.setFacebookProfileId(editPersonForm.getPerson().getFacebookProfileId());
            person.setFemale(editPersonForm.getPerson().isFemale());
            person.setFlatwaterLevel(editPersonForm.getPerson().getFlatwaterLevel());
            person.setOpenwaterLevel(editPersonForm.getPerson().getOpenwaterLevel());
            personRepository.save(person);
        }
        return new ModelAndView(new RedirectView("/booking/persons?filter=" + filter));
    }

}
