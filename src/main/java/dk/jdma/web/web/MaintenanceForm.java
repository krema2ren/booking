package dk.jdma.web.web;

public class MaintenanceForm {
    private Long kayakId;
    private String description;

    public MaintenanceForm() {
    }

    public Long getKayakId() {
        return kayakId;
    }

    public void setKayakId(Long kayakId) {
        this.kayakId = kayakId;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}
