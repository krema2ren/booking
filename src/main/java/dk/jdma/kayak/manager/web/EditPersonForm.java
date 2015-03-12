package dk.jdma.web.web;

import dk.jdma.web.domain.Person;

public class EditPersonForm {

    Person person;

    public EditPersonForm() {
    }

    public EditPersonForm(Person person) {
        this.person = person;
    }

    public Person getPerson() {
        return person;
    }

    public void setPerson(Person person) {
        this.person = person;
    }
}
