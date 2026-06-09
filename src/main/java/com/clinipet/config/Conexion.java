package com.clinipet.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexion {

    private static final String URL = System.getenv("JDBC_URL") != null
        ? System.getenv("JDBC_URL")
        : "jdbc:mysql://localhost:3306/clinipet_db?serverTimezone=America/Bogota&useSSL=false";

    private static final String USER = System.getenv("JDBC_USER") != null
        ? System.getenv("JDBC_USER")
        : "root";

    private static final String PASS = System.getenv("JDBC_PASS") != null
        ? System.getenv("JDBC_PASS")
        : "";

    public static Connection getConnection() throws SQLException {
        Connection con = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection(URL, USER, PASS);
            System.out.println("✔ Conexión exitosa a MySQL");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return con;
    }
}
