package dk.jdma.web.controller;

import dk.jdma.web.domain.Kayak;
import dk.jdma.web.domain.Person;
import dk.jdma.web.repository.KayakRepository;
import dk.jdma.web.repository.PersonRepository;
import dk.jdma.web.web.FilterForm;
import dk.jdma.web.web.TestForm;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.RedirectView;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

@Controller
public class AdminController {

    Logger log = LoggerFactory.getLogger(KayakController.class);

    @Autowired
    PersonRepository personRepository;

    @Autowired
    KayakRepository kayakRepository;

    @RequestMapping(value = "/admin", method = RequestMethod.GET)
    public ModelAndView index() {
        ModelAndView mv = new ModelAndView("admin");
        mv.addObject(new TestForm());
        return mv;
    }

    @RequestMapping("upload_persons.html")
    public ModelAndView uploadPersons(@RequestParam("uploaded") MultipartFile file, ModelMap model) {
        String csvDocument = read(file);
        List<String> parsedList = parseCsv(csvDocument);
        SimpleDateFormat sdf = new SimpleDateFormat("dd.MM.yyyy - HH:mm:ss");
        SimpleDateFormat dbf = new SimpleDateFormat("dd.MM.yyyy");
        for(String s : parsedList) {
            String[] data = s.split(";");
            if(data.length != 10) {
                log.warn("Unable to upload person: Invalid syntax in line '" + s +"'");
                continue;
            }
            Person person = new Person();
            try {
                person.setCreated(sdf.parse(data[0]));
            } catch (ParseException e) {
                log.warn("Unable to upload person: ", e);
                continue;
            }
            person.setName(data[1] + " " + data[2]);
            try {
                person.setDayOfBirth(dbf.parse(data[3]));
            } catch (ParseException e) {
                log.warn("Unable to upload person: ", e);
                continue;
            }
            person.setAddress(data[4] +", " + data[5] + " " + data[6]);
            person.setPhone(data[7]);
            person.setMobile(data[8]);
            person.setEmail(data[9]);
            personRepository.save(person);
            log.debug("Person " + person + " successfully imported.");
        }
        return new ModelAndView(new RedirectView("/kayaks"));
    }

    @RequestMapping("upload_kayaks.html")
    public ModelAndView uploadKayaks(@RequestParam("uploaded") MultipartFile file, ModelMap model) {
        String csvDocument = read(file);
        List<String> parsedList = parseCsv(csvDocument);
        for(String s : parsedList) {
            String[] data = s.split(";");
            log.debug("Processing input string '" + s +"'");
            if(data.length != 6) {
                log.warn("Unable to upload kayak: Invalid syntax in line '" + s +"'");
                continue;
            }
            Kayak kayak = new Kayak();
            kayak.setLocation(data[0]);
            kayak.setName(data[1]);
            kayak.setType(data[2]);
            kayak.setLevel(data[3]);
            kayak.setSeats(Integer.parseInt(data[4]));
            kayak.setOwner(data[5]);
            kayakRepository.save(kayak);
            log.debug("Kayak: " + kayak + " successfully imported.");
        }
        return new ModelAndView(new RedirectView("/kayaks"));
    }

    private String read(MultipartFile file) {
        BufferedReader bufferedReader = null;
        StringBuffer buffer = new StringBuffer();
        String line;
        try {
            bufferedReader = new BufferedReader(new InputStreamReader(file.getInputStream()));
            while ((line = bufferedReader.readLine()) != null) {
                buffer.append(line);
                System.out.println(line);
                buffer.append("\n");
            }
        } catch (IOException e) {
            return null;
        } finally {
            if (bufferedReader != null) {
                try {
                    bufferedReader.close();
                } catch (IOException e) {
                    return null;
                }
            }
        }
        return buffer.toString();
    }

    private List<String> parseCsv(String csvDocument) {
        List<String> result = new ArrayList<String>();
        String[] cvrLines = csvDocument.split("\n");
        for(String cvrLine : cvrLines) {
            result.add(cvrLine);
        }
        result.remove(0);
        return result;
    }

}

