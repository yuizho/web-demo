package dev.yuizho.webdemo.controllers;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloController {
    @RequestMapping("hello")
    public String hello() {
        var serverName = System.getProperty("server_name");
        return "Hello!! I'm working on " + (serverName != null ? serverName : "Anonymous");
    }
}
