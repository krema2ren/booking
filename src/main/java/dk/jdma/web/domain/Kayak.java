package dk.jdma.web.domain;

import org.hibernate.validator.constraints.NotEmpty;

import javax.persistence.*;
import javax.validation.constraints.NotNull;
import java.io.Serializable;

@Entity
public class Kayak implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    @NotNull
    @NotEmpty
    private String name;

    @NotNull
    @NotEmpty
    @Column(unique = true)
    private String location;

    @NotNull
    @NotEmpty
    private String type;

    @NotNull
    @NotEmpty
    private String level;

    @NotNull
    private Integer seats;

    @NotNull
    @NotEmpty
    private String owner;

    @Transient
    private Double distance = 0d;


    public Kayak() {
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getLevel() {
        return level;
    }

    public void setLevel(String level) {
        this.level = level;
    }

    public Integer getSeats() {
        return seats;
    }

    public void setSeats(Integer seats) {
        this.seats = seats;
    }

    public String getOwner() {
        return owner;
    }

    public void setOwner(String owner) {
        this.owner = owner;
    }

    public String getTagName() {
        return location + " " + name + " " + type + " " + level + " " + owner;
    }

    public Double getDistance() { return distance; }

    public void setDistance(Double distance) { this.distance = distance; }

    @Override
    public String toString() {
        return "<p align=\"left\"><u><b>" + location + " " + name + "</b></u><br/>" + "Type: " + type + " K" + seats + "<br/>Sværhedsgrad: " + level +"<br/>Ejer: " + owner + "</p>";
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Kayak)) return false;

        Kayak kayak = (Kayak) o;

        if (name != null ? !name.equals(kayak.name) : kayak.name != null) return false;

        return true;
    }

    @Override
    public int hashCode() {
        return name != null ? name.hashCode() : 0;
    }
}