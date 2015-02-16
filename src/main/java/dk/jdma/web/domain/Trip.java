package dk.jdma.web.domain;

import org.hibernate.annotations.Type;
import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;

import javax.persistence.*;
import java.io.Serializable;
import java.util.List;

@Entity
public class Trip implements Serializable {

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

    public Trip() {
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
        // TODO: move to booking.jsp page
        String s = "";
        int idx = 0;
        for(Person p : persons) {
            s = s + "    <div class=\"media\" style=\"" + (idx == 0 ? "margin-left: -8px;" : "margin-top: -5px; margin-left: -8px;") + "\">\n" +
                    "        <img class=\"media-object custom-media\" src=\"" + (p.getFacebookProfileId() == null ? (p.isFemale() ? "resources/images/woman.jpg\">\n" : "resources/images/man.jpg\">\n") : "//graph.facebook.com/" + p.getFacebookProfileId() + "/picture\">\n") +
                    "        <div class=\"media-body\">\n" +
                    "            <b>" + p.getName() + " [ " + bookingDate.toString(DateTimeFormat.forPattern("dd/MM HH:mm")) + " - " + returnDate.toString(DateTimeFormat.forPattern("HH:mm")) + " ]</b> <br>\n" +
                    "            <small>" + destination.getName() + "</small><br>\n" +
                    "            <small>" + kayak.getTagName() + "</small>\n" +
                    "        </div>\n" +
                    "    </div>";
            idx++;
        }

        return s;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Trip)) return false;

        Trip trip = (Trip) o;

        if (bookingDate != null ? !bookingDate.equals(trip.bookingDate) : trip.bookingDate != null) return false;
        if (destination != null ? !destination.equals(trip.destination) : trip.destination != null) return false;
        if (distance != null ? !distance.equals(trip.distance) : trip.distance != null) return false;
        if (id != null ? !id.equals(trip.id) : trip.id != null) return false;
        if (kayak != null ? !kayak.equals(trip.kayak) : trip.kayak != null) return false;
        if (persons != null ? !persons.equals(trip.persons) : trip.persons != null) return false;
        if (returnDate != null ? !returnDate.equals(trip.returnDate) : trip.returnDate != null) return false;

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