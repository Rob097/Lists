/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package database.entities;

import java.util.ArrayList;

/**
 *
 * @author Martin
 */
public class ShopList {
    private String nome;
    private String descrizione;
    private String immagine;
    private String creator;
    private String categoria;
    private ArrayList<Product> products;
    private ArrayList<User> sharedUsers;


    public ShopList() {
    }
    
    
    public ShopList(String nome, String descrizione, String immagine, String creator, String categoria, ArrayList<Product> products) {
        this.nome = nome;
        this.descrizione = descrizione;
        this.immagine = immagine;
        this.creator = creator;
        this.categoria = categoria;
        this.products = products;
    }

    public ArrayList<Product> getProducts() {
        return products;
    }

    public void setProducts(ArrayList<Product> products) {
        this.products = products;
    }
    
    
    
    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public String getDescrizione() {
        return descrizione;
    }

    public void setDescrizione(String descrizione) {
        this.descrizione = descrizione;
    }

    public String getImmagine() {
        return immagine;
    }

    public void setImmagine(String immagine) {
        this.immagine = immagine;
    }
    
    public String getCreator() {
        return creator;
    }

    public void setCreator(String creator) {
        this.creator = creator;
    }

    public String getCategoria() {
        return categoria;
    }

    public void setCategoria(String categoria) {
        this.categoria = categoria;
    }
    
    public void AddProductToList(Product x){
        this.products.add(x);
    }
    
    public ArrayList<User> getSharedUsers() {
        return sharedUsers;
    }

    public void setSharedUsers(ArrayList<User> sharedUsers) {
        this.sharedUsers = sharedUsers;
    }
    
}
