package dk.jdma.web.controller;

import dk.jdma.web.domain.Trip;
import dk.jdma.web.domain.Person;
import dk.jdma.web.repository.TripRepository;
import dk.jdma.web.repository.KayakRepository;
import dk.jdma.web.repository.PersonRepository;
import dk.jdma.web.web.EditPersonForm;
import dk.jdma.web.web.FilterForm;
import org.joda.time.DateTime;
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
    TripRepository tripRepository;

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
        return new ModelAndView(new RedirectView("/trip/persons?filter=" + filterForm.getFilter()));
    }

    @RequestMapping(value = "/person_detail.html", method = RequestMethod.GET)
         public ModelAndView personDetail(@RequestParam(value="id",required = true) String id, @RequestParam(value="filter", required = false) String filter, @ModelAttribute EditPersonForm editPersonForm) {
        ModelAndView mv = new ModelAndView("person_detail");
        Person person = personRepository.findOne(Long.parseLong(id));
        editPersonForm.setPerson(person);
        mv.addObject(editPersonForm);
        List<Person> persons = new ArrayList<Person>();
        persons.add(person);
        List<Trip> trips = tripRepository.findByPersons(persons);
        Collections.sort(trips, new Comparator<Trip>() {
            @Override
            public int compare(Trip b1, Trip b2) {
                return b1.getBookingDate().compareTo(b2.getBookingDate());
            }
        });
        Collections.reverse(trips);
        mv.addObject(trips);
        mv.addObject(person);
        FilterForm filterForm = new FilterForm();
        filterForm.setFilter(filter != null ? filter : "");
        mv.addObject(filterForm);
        mv.addObject("sprint", generateDistanceDataSet(trips, "kap"));
        mv.addObject("tour", generateDistanceDataSet(trips, "tur"));
        mv.addObject("ocean", generateDistanceDataSet(trips, "hav"));
        mv.addObject("sum", generateDistanceDataSet(trips, ""));
        log.debug(mv.toString());
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
        List<Trip> trips = tripRepository.findByPersons(persons);
        mv.addObject(trips);
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
        return new ModelAndView(new RedirectView("/trip/persons?filter=" + filter));
    }

    private List<DateTime> getIntervals() {
        DateTime year = new DateTime().dayOfYear().withMinimumValue().withTimeAtStartOfDay();

        List<DateTime> intervals = new ArrayList<DateTime>();
        for(int month=0; month<12; month++) {
            DateTime lastDayOfMonth = year.plusMonths(month).dayOfMonth().withMaximumValue().secondOfDay().withMaximumValue();
            intervals.add(lastDayOfMonth);
        }
        return intervals;
    }


    private String generateDistanceDataSet(List<Trip> trips, String type) {
        DateTime year = new DateTime().dayOfYear().withMinimumValue().withTimeAtStartOfDay();
        List<DateTime> intervals = getIntervals();
        Double data[] = { 0d, 0d, 0d, 0d, 0d, 0d, 0d, 0d, 0d, 0d, 0d, 0d };
        for(Trip trip : trips) {
            if((trip.getBookingDate().isAfter(year) && type.equalsIgnoreCase(trip.getKayak().getType())) || (trip.getBookingDate().isAfter(year) && type.isEmpty())) {
                if(trip.getBookingDate().isAfter(year) && trip.getBookingDate().isBefore(intervals.get(0))) {
                    data[0] = data[0] + (trip.getDistance() == null ? 0d : trip.getDistance());
                } else if(trip.getBookingDate().isAfter(intervals.get(0)) && trip.getBookingDate().isBefore(intervals.get(1))) {
                    data[1] = data[1] + (trip.getDistance() == null ? 0d : trip.getDistance());
                } else if(trip.getBookingDate().isAfter(intervals.get(1)) && trip.getBookingDate().isBefore(intervals.get(2))) {
                    data[2] = data[2] + (trip.getDistance() == null ? 0d : trip.getDistance());
                } else if(trip.getBookingDate().isAfter(intervals.get(2)) && trip.getBookingDate().isBefore(intervals.get(3))) {
                    data[3] = data[3] + (trip.getDistance() == null ? 0d : trip.getDistance());
                } else if(trip.getBookingDate().isAfter(intervals.get(3)) && trip.getBookingDate().isBefore(intervals.get(4))) {
                    data[4] = data[4] + (trip.getDistance() == null ? 0d : trip.getDistance());
                } else if(trip.getBookingDate().isAfter(intervals.get(4)) && trip.getBookingDate().isBefore(intervals.get(5))) {
                    data[5] = data[5] + (trip.getDistance() == null ? 0d : trip.getDistance());
                } else if(trip.getBookingDate().isAfter(intervals.get(5)) && trip.getBookingDate().isBefore(intervals.get(6))) {
                    data[6] = data[6] + (trip.getDistance() == null ? 0d : trip.getDistance());
                } else if(trip.getBookingDate().isAfter(intervals.get(6)) && trip.getBookingDate().isBefore(intervals.get(7))) {
                    data[7] = data[7] + (trip.getDistance() == null ? 0d : trip.getDistance());
                } else if(trip.getBookingDate().isAfter(intervals.get(7)) && trip.getBookingDate().isBefore(intervals.get(8))) {
                    data[8] = data[8] + (trip.getDistance() == null ? 0d : trip.getDistance());
                } else if(trip.getBookingDate().isAfter(intervals.get(8)) && trip.getBookingDate().isBefore(intervals.get(9))) {
                    data[9] = data[9] + (trip.getDistance() == null ? 0d : trip.getDistance());
                } else if(trip.getBookingDate().isAfter(intervals.get(9)) && trip.getBookingDate().isBefore(intervals.get(10))) {
                    data[10] = data[10] + (trip.getDistance() == null ? 0d : trip.getDistance());
                } else if(trip.getBookingDate().isAfter(intervals.get(10)) && trip.getBookingDate().isBefore(intervals.get(11))) {
                    data[11] = data[11] + (trip.getDistance() == null ? 0d : trip.getDistance());
                }
            }
        }
        return "[" + data[0] + ", " + data[1] + ", " + data[2] + ", " + data[3] + ", " + data[4] + ", " + data[5] + ", " + data[6] + ", " + data[7] + ", " + data[8] + ", " + data[9] + ", " + data[10] + ", " + data[11] + "]";
    }

    private String calculateSprintDistances(List<Trip> trips) {
        DateTime year = new DateTime().dayOfYear().withMinimumValue().withTimeAtStartOfDay();
        List<DateTime> intervals = getIntervals();




        Double totalDistance = 0d;
        Double totalDistanceSprint = 0d;
        Double totalDistanceTour = 0d;
        Double totalDistanceOcean = 0d;

        Double totalDistanceYTD = 0d;
        Double totalDistanceYTDFSprint = 0d;
        Double totalDistanceYTDFTour = 0d;
        Double totalDistanceYTDFOcean = 0d;

        Double sprint[] = { 0d, 0d, 0d, 0d, 0d, 0d, 0d, 0d, 0d, 0d, 0d, 0d };
        for(Trip trip : trips) {
            totalDistance = totalDistance + (trip.getDistance() == null ? 0d : trip.getDistance());
            if(trip.getKayak().getType().equalsIgnoreCase("kap")) {
                totalDistanceSprint = totalDistanceSprint + (trip.getDistance() == null ? 0d : trip.getDistance());
            } else if(trip.getKayak().getType().equalsIgnoreCase("tur")) {
                totalDistanceTour = totalDistanceTour + (trip.getDistance() == null ? 0d : trip.getDistance());
            } else {
                totalDistanceOcean = totalDistanceOcean +(trip.getDistance() == null ? 0d : trip.getDistance());
            }
            if(trip.getBookingDate().isBefore(year) || trip.getKayak().getType().equalsIgnoreCase("hav") || trip.getKayak().getType().equalsIgnoreCase("tur")) {
                continue;
            }

            if(trip.getBookingDate().isAfter(year) && trip.getBookingDate().isBefore(intervals.get(0))) {
                sprint[0] = sprint[0] + (trip.getDistance() == null ? 0d : trip.getDistance());
            } else if(trip.getBookingDate().isAfter(intervals.get(0)) && trip.getBookingDate().isBefore(intervals.get(1))) {
                sprint[1] = sprint[1] + (trip.getDistance() == null ? 0d : trip.getDistance());
            } else if(trip.getBookingDate().isAfter(intervals.get(1)) && trip.getBookingDate().isBefore(intervals.get(2))) {
                sprint[2] = sprint[2] + (trip.getDistance() == null ? 0d : trip.getDistance());
            } else if(trip.getBookingDate().isAfter(intervals.get(2)) && trip.getBookingDate().isBefore(intervals.get(3))) {
                sprint[3] = sprint[3] + (trip.getDistance() == null ? 0d : trip.getDistance());
            } else if(trip.getBookingDate().isAfter(intervals.get(3)) && trip.getBookingDate().isBefore(intervals.get(4))) {
                sprint[4] = sprint[4] + (trip.getDistance() == null ? 0d : trip.getDistance());
            } else if(trip.getBookingDate().isAfter(intervals.get(4)) && trip.getBookingDate().isBefore(intervals.get(5))) {
                sprint[5] = sprint[5] + (trip.getDistance() == null ? 0d : trip.getDistance());
            } else if(trip.getBookingDate().isAfter(intervals.get(5)) && trip.getBookingDate().isBefore(intervals.get(6))) {
                sprint[6] = sprint[6] + (trip.getDistance() == null ? 0d : trip.getDistance());
            } else if(trip.getBookingDate().isAfter(intervals.get(6)) && trip.getBookingDate().isBefore(intervals.get(7))) {
                sprint[7] = sprint[7] + (trip.getDistance() == null ? 0d : trip.getDistance());
            } else if(trip.getBookingDate().isAfter(intervals.get(7)) && trip.getBookingDate().isBefore(intervals.get(8))) {
                sprint[8] = sprint[8] + (trip.getDistance() == null ? 0d : trip.getDistance());
            } else if(trip.getBookingDate().isAfter(intervals.get(8)) && trip.getBookingDate().isBefore(intervals.get(9))) {
                sprint[9] = sprint[9] + (trip.getDistance() == null ? 0d : trip.getDistance());
            } else if(trip.getBookingDate().isAfter(intervals.get(9)) && trip.getBookingDate().isBefore(intervals.get(10))) {
                sprint[10] = sprint[10] + (trip.getDistance() == null ? 0d : trip.getDistance());
            } else if(trip.getBookingDate().isAfter(intervals.get(10)) && trip.getBookingDate().isBefore(intervals.get(11))) {
                sprint[11] = sprint[11] + (trip.getDistance() == null ? 0d : trip.getDistance());
            }
        }
        return "[" + sprint[0] + ", " + sprint[1] + ", " + sprint[2] + ", " + sprint[3] + ", " + sprint[4] + ", " + sprint[5] + ", " + sprint[6] + ", " + sprint[7] + ", " + sprint[8] + ", " + sprint[9] + ", " + sprint[10] + ", " + sprint[11] + "]";

    }


}
