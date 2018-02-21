package hello;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/hello-world")
public class HelloWorldController {

    private static final String message = "Hello World";

    @RequestMapping(method=RequestMethod.GET)
    public @ResponseBody Greeting sayHello() {
        return new Greeting(message);
    }

}
