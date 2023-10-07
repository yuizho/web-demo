package dev.yuizho.webdemo.controllers;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.net.InetAddress;
import java.net.UnknownHostException;

@RestController
public class HelloController {
    @RequestMapping("hello")
    public String hello() throws UnknownHostException {
        return "Hello!! I'm working on " + InetAddress.getLocalHost().getHostName() + "!!!!\n";
    }
}
