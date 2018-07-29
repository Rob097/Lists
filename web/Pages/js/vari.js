
//js per la verifica dei checkboxes in fase di registrazione di un nuovo utente
function checkCheckBoxes(theForm) {
    if (
            theForm.standard.checked == false &&
            theForm.amministratore.checked == false)
    {
        alert('Attenzione! Non hai selezionato il tipo di utente che vuoi registrare!');
        return false;
    } else if (
            theForm.standard.checked == true &&
            theForm.amministratore.checked == true)
    {
        alert('Attenzione! Hai selezionato troppi tipi di utente!');
        return false;
    } else {
        return true;
    }
}