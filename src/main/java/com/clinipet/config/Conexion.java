package com.clinipet.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexion {

    // URL configurada para MySQL en el puerto estándar 3306 y la base de datos clinipet_db
    private static final String URL = "jdbc:mysql://localhost:3306/clinipet_db?serverTimezone=America/Bogota&useSSL=false";

    // Credenciales por defecto de XAMPP / phpMyAdmin
    private static final String USER = "root";
    private static final String PASS = ""; // Por defecto viene vacío (sin contraseña)

    public static Connection getConnection() throws SQLException {
        Connection con = null;

        try {
            // Driver oficial moderno para MySQL (com.mysql.cj.jdbc.Driver)
            Class.forName("com.mysql.cj.jdbc.Driver");

            con = DriverManager.getConnection(URL, USER, PASS);

            System.out.println("✔ Conexión exitosa a MySQL (XAMPP)");

        } catch (ClassNotFoundException e) {
            System.out.println("❌ Driver de MySQL no encontrado en las dependencias");
            e.printStackTrace();
        } catch (SQLException e) {
            System.out.println("❌ Error de conexión a la base de datos:");
            System.out.println("Mensaje: " + e.getMessage());
            System.out.println("Código Error: " + e.getErrorCode());
            System.out.println("Estado SQL: " + e.getSQLState());
            e.printStackTrace();
        }

        return con;
    }
}