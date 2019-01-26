/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package database.entities;

import java.sql.Date;



/**
 *
 * @author Martin
 */
public class PeriodicProduct {
    
    private String lista;
    private int prodotto;
    private Date data_scadenza;
    private int periodo;

    public PeriodicProduct(String lista, int prodotto, Date data_scadenza, int periodo) {
        this.lista = lista;
        this.prodotto = prodotto;
        this.data_scadenza = new Date(data_scadenza.getTime());
        this.periodo = periodo;
    }

    public PeriodicProduct() {
    }
    
    public String getLista() {
        return lista;
    }

    public void setLista(String lista) {
        this.lista = lista;
    }

    public int getProdotto() {
        return prodotto;
    }

    public void setProdotto(int prodotto) {
        this.prodotto = prodotto;
    }

    public Date getData_scadenza() {
        return new Date(data_scadenza.getTime());
    }

    public void setData_scadenza(Date data_scadenza) {
        this.data_scadenza = new Date(data_scadenza.getTime());
    }

    public int getPeriodo() {
        return periodo;
    }

    public void setPeriodo(int periodo) {
        this.periodo = periodo;
    }
    
    
    
    
}
