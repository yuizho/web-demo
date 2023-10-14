package dev.yuizho.webdemo.model;

import java.util.List;

public interface TodoRepository {
    List<Todo> findAll();
    int save(String name);
}
