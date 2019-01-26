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
        return data_scadenza;
    }

    public void setData_scadenza(Date data_scadenza) {
        this.data_scadenza = data_scadenza;
    }

    public Date getData_inserimento() {
        return data_inserimento;
    }

    public void setData_inserimento(Date data_inserimento) {
        this.data_inserimento = data_inserimento;
    }

    public String getStato() {
        return stato;
    }

    public void setStato(String stato) {
        this.stato = stato;
    }

    public Date getDataAcquisto() {
        return dataAcquisto;
    }

    public void setDataAcquisto(Date dataAcquisto) {
        this.dataAcquisto = dataAcquisto;
    }

    public String getQuantita() {
        return quantita;
    }

    public void setQuantita(String quantita) {
        this.quantita = quantita;
    }
}
