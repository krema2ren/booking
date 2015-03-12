package dk.jdma.web.exception;

public class SupportInfoException extends RuntimeException {

    private static final long serialVersionUID = 4657491283614755649L;

    public SupportInfoException(String msg) {
        super(msg);
    }

    public SupportInfoException(String msg, Throwable t) {
        super(msg, t);
    }

}
