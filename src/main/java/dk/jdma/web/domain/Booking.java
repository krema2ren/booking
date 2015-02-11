package dk.jdma.web.domain;

import org.hibernate.annotations.Type;
import org.hibernate.validator.constraints.NotEmpty;
import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;

import javax.persistence.*;
import javax.validation.constraints.NotNull;
import java.io.Serializable;
import java.util.List;

@Entity
public class Booking implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    @Type(type="org.jadira.usertype.dateandtime.joda.PersistentDateTime")
    private DateTime bookingDate;

    @Type(type="org.jadira.usertype.dateandtime.joda.PersistentDateTime")
    private DateTime returnDate;

    @Basic
    private Double distance;

    @ManyToMany(cascade = CascadeType.DETACH, fetch = FetchType.EAGER)
    @JoinColumn(name = "person_id", nullable = false)
    private List<Person> persons;

    @ManyToOne(cascade = CascadeType.DETACH, fetch = FetchType.EAGER)
    @JoinColumn(name = "kayak_id", nullable = false)
    private Kayak kayak;

    @ManyToOne(cascade = CascadeType.DETACH, fetch = FetchType.EAGER)
    @JoinColumn(name = "destination_id", nullable = false)
    private Destination destination;

    @Column(columnDefinition = "tinyint")
    private boolean returned;

    public Booking() {
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public DateTime getBookingDate() {
        return bookingDate;
    }

    public void setBookingDate(DateTime bookingDate) {
        this.bookingDate = bookingDate;
    }

    public DateTime getReturnDate() {
        return returnDate;
    }

    public void setReturnDate(DateTime returnDate) {
        this.returnDate = returnDate;
    }

    public Double getDistance() {
        return distance;
    }

    public void setDistance(Double distance) {
        this.distance = distance;
    }

    public List<Person> getPersons() {
        return persons;
    }

    public void setPersons(List<Person> persons) {
        this.persons = persons;
    }

    public Kayak getKayak() {
        return kayak;
    }

    public void setKayak(Kayak kayak) {
        this.kayak = kayak;
    }

    public Destination getDestination() {
        return destination;
    }

    public void setDestination(Destination destination) {
        this.destination = destination;
    }

    public boolean isReturned() {
        return returned;
    }

    public void setReturned(boolean returned) {
        this.returned = returned;
    }

    @Override
    public String toString() {
        String s = "";
        for(Person p : persons) {
            s = s + p.getName() + "<br/>";
        }
        return   "<p align=\"left\"><u><b>" + bookingDate.toString(DateTimeFormat.forPattern("HH:mm")) + " - " + returnDate.toString(DateTimeFormat.forPattern("HH:mm")) + " : " + destination.getName() + "</b></u><br/>" + s + "<sub>" + kayak.getTagName() + "</sub></p>";
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Booking)) return false;

        Booking booking = (Booking) o;

        if (bookingDate != null ? !bookingDate.equals(booking.bookingDate) : booking.bookingDate != null) return false;
        if (destination != null ? !destination.equals(booking.destination) : booking.destination != null) return false;
        if (distance != null ? !distance.equals(booking.distance) : booking.distance != null) return false;
        if (id != null ? !id.equals(booking.id) : booking.id != null) return false;
        if (kayak != null ? !kayak.equals(booking.kayak) : booking.kayak != null) return false;
        if (persons != null ? !persons.equals(booking.persons) : booking.persons != null) return false;
        if (returnDate != null ? !returnDate.equals(booking.returnDate) : booking.returnDate != null) return false;

        return true;
    }

    @Override
    public int hashCode() {
        int result = id != null ? id.hashCode() : 0;
        result = 31 * result + (bookingDate != null ? bookingDate.hashCode() : 0);
        result = 31 * result + (returnDate != null ? returnDate.hashCode() : 0);
        result = 31 * result + (distance != null ? distance.hashCode() : 0);
        result = 31 * result + (persons != null ? persons.hashCode() : 0);
        result = 31 * result + (kayak != null ? kayak.hashCode() : 0);
        result = 31 * result + (destination != null ? destination.hashCode() : 0);
        return result;
    }
}