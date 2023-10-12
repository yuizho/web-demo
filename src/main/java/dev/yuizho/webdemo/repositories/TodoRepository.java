package dev.yuizho.webdemo.repositories;

import org.springframework.jdbc.core.namedparam.NamedParameterJdbcOperations;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class TodoRepository {
    private final NamedParameterJdbcOperations jdbcTemplate;

    public TodoRepository(NamedParameterJdbcOperations jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public List<String> findAll() {
        var sql = """
                SELECT name FROM todo
                """;
        return jdbcTemplate.queryForList(sql, Map.of(), String.class);
    }

    public int save(String name) {
        var sql = """
                INSERT INTO todo(name) VALUES(:name)
                """;
        return jdbcTemplate.update(sql, Map.of("name", name));
    }
}
