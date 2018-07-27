/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package database.entities;

/**
 *Classe Bean che salva i dati preso dal database nelle variabili della classe User
 * @author Martin
 */
public class User {
    
    private String email;
    private String password;
    private String nominativo;
    private String tipo;
    private String image;

    public void setImage(String image) {
        this.image = image;
    }

    public String getImage() {
        return image;
    }
        
    public String getNominativo() {
        return nominativo;
    }

    public String getTipo() {
        return tipo;
    }

    public void setNominativo(String nominativo) {
        this.nominativo = nominativo;
    }

    public void setTipo(String tipo) {
        this.tipo = tipo;
    }

    public String getEmail() {
        return email;
    }

    public String getPassword() {
        return password;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setPassword(String password) {
        this.password = password;
    }
    
    
}
