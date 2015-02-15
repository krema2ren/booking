package dk.jdma.web.controller;

import dk.jdma.web.domain.Kayak;
import dk.jdma.web.repository.KayakRepository;
import dk.jdma.web.repository.PersonRepository;
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
import java.util.List;

@Controller
public class KayakController {

    Logger log = LoggerFactory.getLogger(KayakController.class);

    @Autowired
    PersonRepository personRepository;

    @Autowired
    KayakRepository kayakRepository;

    @RequestMapping(value = "/kayaks", method = RequestMethod.GET)
    public ModelAndView index(@RequestParam(value="filter",required = false, defaultValue = "") String filter) {
        ModelAndView mv = new ModelAndView("kayaks");
        List<Kayak> result = new ArrayList<Kayak>();
        List<Kayak> kayaks = (List<Kayak>) kayakRepository.findAll();
        FilterForm filterForm = new FilterForm();
        if(filter != null && !filter.isEmpty()) {
            filterForm.setFilter(filter);
            for(Kayak kayak : kayaks) {
                if(kayak.toString().toLowerCase().contains(filter.toLowerCase())) {
                    result.add(kayak);
                }
            }
        } else {
            result.addAll(kayaks);
        }
        mv.getModelMap().addAttribute("kayaks", result);
        mv.getModelMap().addAttribute("filterForm", new FilterForm());
        return mv;
    }

    @RequestMapping(value = "/filter_kayaks.html", method = RequestMethod.POST)
    public ModelAndView filterKayaks(@ModelAttribute FilterForm filterForm) {
        return new ModelAndView(new RedirectView("/booking/kayaks?filter=" + filterForm.getFilter()));
    }

}