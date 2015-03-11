package dk.jdma.web.web;

import org.hibernate.validator.constraints.NotEmpty;

public class BookingForm {

    @NotEmpty(message = "Du skal vælge en kajak.")
    private String kayakName;

    @NotEmpty(message = "Du skal vælge et navn.")
    private String personName;

    private String destination;

    public BookingForm() {
    }

    public String getKayakName() {
        return kayakName;
    }

    public void setKayakName(String kayakName) {
        this.kayakName = kayakName;
    }

    public String getPersonName() {
        return personName;
    }

    public void setPersonName(String personName) {
        this.personName = personName;
    }

    public String getDestination() {
        return destination;
    }

    public void setDestination(String destination) {
        this.destination = destination;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof BookingForm)) return false;

        BookingForm bookForm = (BookingForm) o;

        if (destination != null ? !destination.equals(bookForm.destination) : bookForm.destination != null)
            return false;
        if (kayakName != null ? !kayakName.equals(bookForm.kayakName) : bookForm.kayakName != null) return false;
        if (personName != null ? !personName.equals(bookForm.personName) : bookForm.personName != null) return false;

        return true;
    }

    @Override
    public int hashCode() {
        int result = kayakName != null ? kayakName.hashCode() : 0;
        result = 31 * result + (personName != null ? personName.hashCode() : 0);
        result = 31 * result + (destination != null ? destination.hashCode() : 0);
        return result;
    }
}
