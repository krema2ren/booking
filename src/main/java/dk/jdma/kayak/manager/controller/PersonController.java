package dk.jdma.web.controller;

import dk.jdma.web.domain.Destination;
import dk.jdma.web.domain.Kayak;
import dk.jdma.web.domain.Trip;
import dk.jdma.web.domain.Person;
import dk.jdma.web.repository.DestinationRepository;
import dk.jdma.web.repository.TripRepository;
import dk.jdma.web.repository.KayakRepository;
import dk.jdma.web.repository.PersonRepository;
import dk.jdma.web.web.EditPersonForm;
import dk.jdma.web.web.EditTripForm;
import dk.jdma.web.web.FilterForm;
import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
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

import java.lang.reflect.Array;
import java.math.BigDecimal;
import java.math.BigInteger;
import java.text.SimpleDateFormat;
import java.util.*;

@Controller
public class PersonController {

    Logger log = LoggerFactory.getLogger(KayakController.class);

    @Autowired
    PersonRepository personRepository;

    @Autowired
    KayakRepository kayakRepository;

    @Autowired
    TripRepository tripRepository;

    @Autowired
    DestinationRepository destinationRepository;

    @RequestMapping(value = "/persons", method = RequestMethod.GET)
    public ModelAndView index(@RequestParam(value="filter",required = false, defaultValue = "") String filter) {
        ModelAndView mv = new ModelAndView("persons");
        List<Person> result = new ArrayList<Person>();
        List<Person> persons = (List<Person>) personRepository.findAll();
        List<Object> ranking = personRepository.findRanking();
        calculateRankings(persons, ranking);
        Collections.sort(persons, new Comparator<Person>() {
            @Override
            public int compare(Person p1, Person p2) {
                return p1.getRanking() - p2.getRanking();
            }
        });

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
         public ModelAndView personDetail(@RequestParam(value="id",required = true) String id, @RequestParam(value="filter", required = false) String filter, @ModelAttribute EditPersonForm editPersonForm, @ModelAttribute EditTripForm editTripForm) {
        ModelAndView mv = new ModelAndView("person_detail");
        Person person = personRepository.findOne(Long.parseLong(id));
        editPersonForm.setPerson(person);
        mv.addObject(editPersonForm);
        mv.addObject(editTripForm);
        List<Person> persons = new ArrayList<Person>();
        persons.add(person);
        List<Object> ranking = personRepository.findRanking();
        calculateRankings(persons,ranking);
        List<Trip> trips = tripRepository.findByPersons(persons);
        Collections.sort(trips, new Comparator<Trip>() {
            @Override
            public int compare(Trip b1, Trip b2) {
                return b2.getBookingDate().compareTo(b1.getBookingDate());
            }
        });
        mv.addObject(trips);
        mv.addObject(person);
        FilterForm filterForm = new FilterForm();
        filterForm.setFilter(filter != null ? filter : "");
        mv.addObject(filterForm);
        List<Double> data = generateDistanceDataSet(trips, "kap");
        mv.addObject("sprintTotal", data.get(12));
        mv.addObject("sprint", convertDataSetToString(data));
        data = generateDistanceDataSet(trips, "tur");
        mv.addObject("tourTotal", data.get(12));
        mv.addObject("tour", convertDataSetToString(data));
        data = generateDistanceDataSet(trips, "hav");
        mv.addObject("oceanTotal", data.get(12));
        mv.addObject("ocean", convertDataSetToString(data));
        data = generateDistanceDataSet(trips, "");
        mv.addObject("sumTotal", data.get(12));
        mv.addObject("sum", convertDataSetToString(data));
        mv.addObject("year", new SimpleDateFormat("yyyy").format(new Date()));

        List<Kayak> kayaks = calculateKayakRanking(trips);
        mv.addObject("kayaks", kayaks);


        log.debug(mv.toString());
        return mv;
    }

    @RequestMapping(value = "/trip_detail.html", method = RequestMethod.POST)
    public ModelAndView editTrip(@ModelAttribute EditTripForm form) {
        Trip trip = tripRepository.findOne(form.getTripId());
        if(trip != null) {
            String tagName = form.getKayakName();
            String kayakTags[] = tagName.split(" ");
            Kayak kayak = kayakRepository.findByLocation(kayakTags[0]);
            if(kayak != null) {
                Person first  = personRepository.findByName(form.getFirstName());
                Person second = personRepository.findByName(form.getSecondName());
                Person third  = personRepository.findByName(form.getThirdName());
                Person fourth = personRepository.findByName(form.getFourthName());
                trip.getPersons().clear();
                trip.getPersons().add(first);
                if(second != null && kayak.getSeats() > 1) {
                    trip.getPersons().add(second);
                }
                if(third != null && kayak.getSeats() > 2) {
                    trip.getPersons().add(third);
                }
                if(fourth != null && kayak.getSeats() > 3) {
                    trip.getPersons().add(fourth);
                }
                trip.setKayak(kayak);
                trip.setDistance(Double.parseDouble(form.getDistance()));
                Destination destination = destinationRepository.findByName(form.getDestinationName());
                if(destination == null) {
                    destination = new Destination();
                    destination.setName(form.getDestinationName().contains("km") ? form.getDestinationName() : form.getDestinationName() + " " + form.getDistance() + "km");
                    destinationRepository.save(destination);
                }
                trip.setDestination(destination);
                trip.setBookingDate(DateTime.parse(form.getStartTime(), DateTimeFormat.forPattern("yyyy-MM-dd HH:mm")));
                trip.setReturnDate(DateTime.parse(form.getEndTime(), DateTimeFormat.forPattern("yyyy-MM-dd HH:mm")));
                trip.setReturned(trip.getBookingDate().isBefore(DateTime.now()) && trip.getReturnDate().isAfter(DateTime.now()));
                if(trip.getReturnDate().isAfter(trip.getReturnDate())) {
                    throw new RuntimeException("Start time must be before end time.");
                }

                tripRepository.save(trip);
            } else {
                throw new RuntimeException("Kayak on location " + kayakTags[0] + " not found.");
            }
        } else {
            throw new RuntimeException("Trip with id=" + form.getTripId() + " not found.");
        }
        return new ModelAndView(new RedirectView("/trip/person_detail.html?id=" + form.getPersonId()));
    }

    @RequestMapping(value = "/edit_person.html", method = RequestMethod.GET)
    public ModelAndView editPerson(@RequestParam(value="id",required = true) String id, @ModelAttribute EditPersonForm editPersonForm, @ModelAttribute EditTripForm editTripForm) {
        ModelAndView mv = new ModelAndView("person_detail");
        Person person = personRepository.findOne(Long.parseLong(id));
        editPersonForm.setPerson(person);
        mv.getModelMap().addAttribute("editPersonForm", editPersonForm);
        mv.getModelMap().addAttribute("editTripForm", editTripForm);
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

    private List<Kayak> calculateKayakRanking(List<Trip> trips) {
        Map<Kayak, Double> kayaks = new HashMap<Kayak, Double>();
        for(Trip t : trips) {
            kayaks.put(t.getKayak(), (kayaks.get(t.getKayak()) != null ? kayaks.get(t.getKayak()) : 0d) + (t.getDistance() != null ? t.getDistance() : 0d));
        }
        List<Kayak> result = new ArrayList<Kayak>(kayaks.keySet());;
        for(Map.Entry<Kayak, Double> entry : kayaks.entrySet()) {
            result.get(result.indexOf(entry.getKey())).setDistance(entry.getValue() != null ? entry.getValue() : 0d);
        }
        Collections.sort(result, new Comparator<Kayak>() {
            @Override
            public int compare(Kayak k1, Kayak k2) {
                return k2.getDistance().intValue() - k1.getDistance().intValue();
            }
        });
        return result;
    }

    private void calculateRankings(List<Person> persons, List<Object> rankings) {
        for(Person p : persons) {
            int rank = 1;
            for(Object o : rankings) {
                if (o instanceof Object[]) {
                    Object[] a = (Object[]) o;
                    if(p.getId() == ((BigInteger) a[0]).longValue()) {
                        p.setRanking(rank);
                        p.setDistance((Double)a[1]);
                        continue;
                    }
                }
                rank++;
            }
        }
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

    private String convertDataSetToString(List<Double> data) {
        return "[" + data.get(0) + ", " + data.get(1) + ", " + data.get(2) + ", " + data.get(3) + ", " + data.get(4) + ", " + data.get(5) + ", " + data.get(6) + ", " + data.get(7) + ", " + data.get(8) + ", " + data.get(9) + ", " + data.get(10) + ", " + data.get(11) + "]";
    }

    private  List<Double>  generateDistanceDataSet(List<Trip> trips, String type) {
        DateTime year = new DateTime().dayOfYear().withMinimumValue().withTimeAtStartOfDay();
        List<DateTime> intervals = getIntervals();
        Double data[] = { 0d, 0d, 0d, 0d, 0d, 0d, 0d, 0d, 0d, 0d, 0d, 0d, 0d };
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
        Double sum = 0d;
        for(Double d : data) {
            sum = sum + d;
        }
        data[12] = sum;
        return Arrays.asList(data);
    }




}
