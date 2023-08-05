package dev.yuizho.webdemo.controllers;

import jakarta.servlet.http.HttpServletRequest;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloController {
    @RequestMapping("hello")
    public String hello(HttpServletRequest request) {
        return "Hello!! I'm working on " + request.getLocalName() + "!!!!!!";
    }
}
