/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package database.entities;

import java.sql.Date;

/**
 *
 * @author Dmytr
 */
public class ListProd {
    private String lista;
    private String prodotto;
    private Date data_scadenza;
    private Date data_inserimento;
    private String stato;
    private Date dataAcquisto;
    private String quantita;

    public ListProd(String lista, String prodotto, Date data_scadenza, Date data_inserimento, String stato, Date dataAcquisto, String quantita) {
        this.lista = lista;
        this.prodotto = prodotto;
        this.data_scadenza = new Date(data_scadenza.getTime());
        this.data_inserimento = new Date(data_inserimento.getTime());
        this.stato = stato;
        this.dataAcquisto = new Date(dataAcquisto.getTime());
        this.quantita = quantita;
    }

    public ListProd() {
    }    
    
    public String getLista() {
        return lista;
    }

    public void setLista(String lista) {
        this.lista = lista;
    }

    public String getProdotto() {
        return prodotto;
    }

    public void setProdotto(String prodotto) {
        this.prodotto = prodotto;
    }

    public Date getData_scadenza() {
        return new Date(data_scadenza.getTime()); //Date is mutable. Using that setter, someone can modify the date instance from outside unintentionally
    }

    public void setData_scadenza(Date data_scadenza) {
        this.data_scadenza = new Date(data_scadenza.getTime());
    }

    public Date getData_inserimento() {
        return new Date(data_inserimento.getTime());
    }

    public void setData_inserimento(Date data_inserimento) {
        this.data_inserimento = new Date(data_inserimento.getTime());
    }

    public String getStato() {
        return stato;
    }

    public void setStato(String stato) {
        this.stato = stato;
    }

    public Date getDataAcquisto() {
        return new Date(dataAcquisto.getTime());
    }

    public void setDataAcquisto(Date dataAcquisto) {
        this.dataAcquisto = new Date(dataAcquisto.getTime());
    }

    public String getQuantita() {
        return quantita;
    }

    public void setQuantita(String quantita) {
        this.quantita = quantita;
    }
}
