package dev.yuizho.webdemo.repositories;

import dev.yuizho.webdemo.model.Todo;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.DataClassRowMapper;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcOperations;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class TodoRepository {
    private final NamedParameterJdbcOperations jdbcTemplate;

    public TodoRepository(NamedParameterJdbcOperations jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public List<Todo> findAll() {
        var sql = """
                SELECT name FROM todo
                """;
        return jdbcTemplate.query(
                sql,
                new DataClassRowMapper<>(Todo.class)
        );
    }

    public int save(String name) {
        var sql = """
                INSERT INTO todo(name) VALUES(:name)
                """;
        return jdbcTemplate.update(sql, Map.of("name", name));
    }
}
