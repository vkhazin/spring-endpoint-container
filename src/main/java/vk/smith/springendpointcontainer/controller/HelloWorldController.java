package vk.smith.springendpointcontainer.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import vk.smith.springendpointcontainer.controller.responses.HelloWorldResponse;

import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

@RestController
@Produces(MediaType.APPLICATION_JSON)
public class HelloWorldController {

    @GetMapping(path = "/helloworld")
    public HelloWorldResponse getHelloWorld(){
        return new HelloWorldResponse();
    }
}
