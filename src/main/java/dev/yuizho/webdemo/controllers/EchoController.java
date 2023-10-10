package dev.yuizho.webdemo.controllers;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

@Controller
public class EchoController {
    @GetMapping("/echo")
    public String greeting() {
        return "echo";
    }

    @PostMapping("/upper")
    public String upper(Model model, Form form) {
        model.addAttribute("response", form);
        return "upper";
    }

    record Form(String query) {
        public String getUpperCase() { // 大文字にして返却するメソッド
            return this.query.toUpperCase();
        }
    }
}
