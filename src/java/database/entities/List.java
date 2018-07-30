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
public class List {
    private String nome;
    private String descrizione;
    //private String immagine;
    private String creator;
    private String categoria;
    private ArrayList<Product> products;

    public List(String nome, String descrizione, String creator, String categoria, ArrayList<Product> products) {
        this.nome = nome;
        this.descrizione = descrizione;
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
    
}
