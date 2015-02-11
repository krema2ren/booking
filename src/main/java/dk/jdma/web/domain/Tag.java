package dk.jdma.web.domain;

public class Tag {

	private long id;
	private String tagName;

	public long getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getTagName() {
		return tagName;
	}

	public void setTagName(String tagName) {
		this.tagName = tagName;
	}

	public Tag(long id, String tagName) {
		this.id = id;
		this.tagName = tagName;
	}

}