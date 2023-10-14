package dev.yuizho.webdemo.controllers;

import dev.yuizho.webdemo.model.TodoRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;


@Controller
@RequestMapping("todo")
public class TodoController {
    private final Logger LOGGER = LoggerFactory.getLogger(TodoController.class);
    private TodoRepository todoRepository;

    public TodoController(TodoRepository todoRepository) {
        this.todoRepository = todoRepository;
    }

    @GetMapping
    public String index(Model model) {
        model.addAttribute(
                "todoList",
                todoRepository.findAll()
        );
        return "todo/index";
    }

    @PostMapping("/register")
    public String register(Model model, String todo) {
        LOGGER.info(todo);
        todoRepository.save(todo);

        model.addAttribute(
                "todoList",
                todoRepository.findAll()
        );
        model.addAttribute("form", "");
        return "todo/todolist";
    }
}
