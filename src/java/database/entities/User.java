/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package database.entities;

import java.util.*;

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
    private ArrayList<List> list;
    private String ruolo;

    public String getRuolo() {
        return ruolo;
    }

    public void setRuolo(String ruolo) {
        this.ruolo = ruolo;
    }
    
    

    public ArrayList<List> getLista() {
        return list;
    }

    public void setLista(ArrayList<List> x) {
        this.list = x;
    }

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
    
    public void AddItemToUserList(List x){
        this.list.add(x);
    }

    
    
   
}
