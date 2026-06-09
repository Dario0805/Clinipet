package com.clinipet.dao;

import com.clinipet.config.Conexion;
import com.clinipet.model.Usuario;
import java.sql.*;

public class UsuarioDAO {

    public Usuario login(String correo, String password) throws SQLException {
        // CORRECCIÓN: Se cambió ISNULL por IFNULL (Sintaxis estándar de MySQL)
        String sql = "SELECT u.id_usuario, u.nombre, u.correo, r.nombre AS rol "
                   + "FROM usuarios u "
                   + "INNER JOIN roles r ON u.id_rol = r.id_rol "
                   + "WHERE u.correo = ? AND u.contrasena = ? AND IFNULL(u.estado, 'ACTIVO') = 'ACTIVO'";
        
        try (Connection con = Conexion.getConnection(); 
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, correo); 
            ps.setString(2, password);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    // Retorna el objeto Usuario mapeando el alias 'rol' correctamente
                    return new Usuario(
                        rs.getInt("id_usuario"), 
                        rs.getString("nombre"), 
                        rs.getString("correo"), 
                        rs.getString("rol")
                    );
                }
            }
        }
        return null;
    }

    public boolean registrar(String nombre, String correo, String contrasena, String rol) {
        String sqlRol = "SELECT id_rol FROM roles WHERE LOWER(nombre) = LOWER(?)";
        // CORRECCIÓN: Se cambió GETDATE() por NOW() (Sintaxis estándar de MySQL)
        String sqlIns = "INSERT INTO usuarios(nombre, correo, contrasena, id_rol, estado, fecha_registro) VALUES(?, ?, ?, ?, 'ACTIVO', NOW())";
        
        try (Connection con = Conexion.getConnection()) {
            int idRol = 0;
            
            // 1. Buscar si el rol ya existe
            try (PreparedStatement ps = con.prepareStatement(sqlRol)) {
                ps.setString(1, rol);
                try (ResultSet rs = ps.executeQuery()) { 
                    if (rs.next()) idRol = rs.getInt(1); 
                }
            }
            
            // 2. Si el rol no existe, insertarlo dinámicamente
            if (idRol == 0) {
                try (PreparedStatement ps = con.prepareStatement("INSERT INTO roles(nombre) VALUES(?)", Statement.RETURN_GENERATED_KEYS)) {
                    ps.setString(1, rol); 
                    ps.executeUpdate();
                    try (ResultSet rs = ps.getGeneratedKeys()) { 
                        if (rs.next()) idRol = rs.getInt(1); 
                    }
                }
            }
            
            // 3. Registrar el nuevo usuario con el id_rol obtenido
            try (PreparedStatement ps = con.prepareStatement(sqlIns)) {
                ps.setString(1, nombre); 
                ps.setString(2, correo); 
                ps.setString(3, contrasena); 
                ps.setInt(4, idRol);
                return ps.executeUpdate() > 0;
            }
            
        } catch (Exception e) { 
            System.out.println("❌ [DAO] Error al registrar usuario:");
            e.printStackTrace(); 
            return false; 
        }
    }
    public boolean registrarCompleto(String nombre, String correo, String contrasena, String telefono, String documento, String direccion) {
        try (Connection con = Conexion.getConnection()) {
            con.setAutoCommit(false);
            if(!registrar(nombre, correo, contrasena, "CLIENTE")) return false;

            int idUsuario = 0;
            try (PreparedStatement ps = con.prepareStatement("SELECT id_usuario FROM usuarios WHERE correo=? ORDER BY id_usuario DESC LIMIT 1")) {
                ps.setString(1, correo);
                ResultSet rs = ps.executeQuery();
                if(rs.next()) idUsuario = rs.getInt(1);
            }

            try (PreparedStatement ps = con.prepareStatement("INSERT INTO duenios(nombre, documento, telefono, correo, direccion, id_usuario) VALUES(?,?,?,?,?,?)")) {
                ps.setString(1, nombre);
                ps.setString(2, documento);
                ps.setString(3, telefono);
                ps.setString(4, correo);
                ps.setString(5, direccion);
                ps.setInt(6, idUsuario);
                ps.executeUpdate();
            }
            con.commit();
            return true;
        } catch(Exception e){e.printStackTrace(); return false;}
    }

    /**
     * Actualiza la contraseña del usuario cuyo correo coincide con el del veterinario.
     * Retorna true si el usuario existía y fue actualizado, false si no existe.
     */
    public boolean actualizarContrasenaVeterinario(String correo, String nuevaContrasena) {
        String sql = "UPDATE usuarios SET contrasena = ? WHERE correo = ?";
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, nuevaContrasena);
            ps.setString(2, correo);
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

}