package dev.yuizho.webdemo.controllers;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.ArrayList;
import java.util.List;

@Controller
@RequestMapping("todo")
public class TodoController {
    private final Logger LOGGER = LoggerFactory.getLogger(TodoController.class);
    // TODO: 後でrepositoryに置き換え
    private static List<String> todoList = new ArrayList<>();

    @GetMapping
    public String index(Model model) {
        model.addAttribute("todoList", todoList);
        return "todo/index";
    }

    @PostMapping("/register")
    public String register(Model model, String todo) {
        LOGGER.info(todo);
        todoList.add(todo);
        model.addAttribute("todoList", todoList);
        model.addAttribute("form", "");
        return "todo/todolist";
    }
}
