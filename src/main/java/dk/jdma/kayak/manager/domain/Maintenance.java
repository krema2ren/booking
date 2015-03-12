package dk.jdma.web.domain;

import org.hibernate.annotations.Type;
import org.joda.time.DateTime;

import javax.persistence.*;
import java.io.Serializable;

@Entity
public class Maintenance implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    @ManyToOne(cascade = CascadeType.DETACH, fetch = FetchType.EAGER)
    @JoinColumn(name = "kayak_id", nullable = false)
    private Kayak kayak;

    @Basic
    private String description;

    @Type(type="org.jadira.usertype.dateandtime.joda.PersistentDateTime")
    private DateTime created;

    @Type(type="org.jadira.usertype.dateandtime.joda.PersistentDateTime")
    private DateTime fixed;

    public Maintenance() {
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Kayak getKayak() {
        return kayak;
    }

    public void setKayak(Kayak kayak) {
        this.kayak = kayak;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public DateTime getCreated() {
        return created;
    }

    public void setCreated(DateTime created) {
        this.created = created;
    }

    public DateTime getFixed() {
        return fixed;
    }

    public void setFixed(DateTime fixed) {
        this.fixed = fixed;
    }
}
