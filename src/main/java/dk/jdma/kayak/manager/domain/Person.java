package dk.jdma.web.domain;

import org.hibernate.validator.constraints.NotEmpty;
import org.springframework.format.annotation.DateTimeFormat;

import javax.persistence.*;
import javax.validation.constraints.NotNull;
import java.io.Serializable;
import java.util.Date;

@Entity
public class Person implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    @Temporal(TemporalType.DATE)
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date created;

    @Temporal(TemporalType.DATE)
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date dayOfBirth;

    @NotNull
    @NotEmpty
    @Column(unique = true)
    private String name;

    @NotNull
    @NotEmpty
    private String address;

    @Basic
    private String phone;

    @Basic
    private String mobile;

    @Basic
    private String email;

    @Basic
    private String flatwaterLevel;

    @Basic
    private String openwaterLevel;

    @Basic
    private String facebookProfileId;

    @Column(columnDefinition = "tinyint")
    private boolean female;

    @Transient
    private int ranking = Integer.MAX_VALUE;

    @Transient
    private Double distance;

    public Person() {
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Date getCreated() {
        return created;
    }

    public void setCreated(Date created) {
        this.created = created;
    }

    public Date getDayOfBirth() {
        return dayOfBirth;
    }

    public void setDayOfBirth(Date dayOfBirth) {
        this.dayOfBirth = dayOfBirth;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getMobile() {
        return mobile;
    }

    public void setMobile(String mobile) {
        this.mobile = mobile;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getFlatwaterLevel() {
        return flatwaterLevel;
    }

    public void setFlatwaterLevel(String flatwaterLevel) {
        this.flatwaterLevel = flatwaterLevel;
    }

    public String getOpenwaterLevel() {
        return openwaterLevel;
    }

    public void setOpenwaterLevel(String openwaterLevel) {
        this.openwaterLevel = openwaterLevel;
    }

    public String getFacebookProfileId() {
        return facebookProfileId;
    }

    public void setFacebookProfileId(String facebookProfileId) {
        this.facebookProfileId = facebookProfileId;
    }

    public boolean isFemale() {
        return female;
    }

    public void setFemale(boolean female) {
        this.female = female;
    }

    public int getRanking() { return ranking; }

    public void setRanking(int ranking) { this.ranking = ranking; }

    public Double getDistance() { return distance; }

    public void setDistance(Double distance) { this.distance = distance; }

    @Override
    public String toString() {
        return "<p align=\"left\"><u><b>" + name + "</u></b><br/>" + address + "<br/>Mobil: " + mobile + "<br/>Telefon: " + phone + "<br/>Mail: " + email + "<br/>Født: " + dayOfBirth.toString() + "<br/>Oprettet: " + created.toString() + "</p>";
    }


    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Person)) return false;

        Person person = (Person) o;

        if (address != null ? !address.equals(person.address) : person.address != null) return false;
        if (name != null ? !name.equals(person.name) : person.name != null) return false;

        return true;
    }

    @Override
    public int hashCode() {
        int result = name != null ? name.hashCode() : 0;
        result = 31 * result + (address != null ? address.hashCode() : 0);
        return result;
    }
}