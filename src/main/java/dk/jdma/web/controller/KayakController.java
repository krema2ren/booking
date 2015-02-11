package dk.jdma.web.controller;

import dk.jdma.web.domain.Kayak;
import dk.jdma.web.domain.Person;
import dk.jdma.web.repository.KayakRepository;
import dk.jdma.web.repository.PersonRepository;
import dk.jdma.web.web.FilterForm;
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
public class KayakController {

    Logger log = LoggerFactory.getLogger(KayakController.class);

    @Autowired
    PersonRepository personRepository;

    @Autowired
    KayakRepository kayakRepository;

    @RequestMapping(value = "/kayaks", method = RequestMethod.GET)
    public ModelAndView index() {
        ModelAndView mv = new ModelAndView("kayaks");
        List<Kayak> kayaks = (List<Kayak>) kayakRepository.findAll();
        mv.getModelMap().addAttribute("kayaks", kayaks);
        mv.getModelMap().addAttribute("filterKayaksForm", new FilterForm());
        return mv;
    }

}