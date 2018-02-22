package vk.smith.springendpointcontainer.controller.responses;

public class HelloWorldResponse {
    private String message = "Hello World";

    public HelloWorldResponse(String message) {
        this.message = message;
    }

    public HelloWorldResponse() {

    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }
}
