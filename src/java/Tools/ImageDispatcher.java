/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Tools;

import java.io.File;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.regex.Pattern;
import javax.servlet.http.Part;

/**
 *
 * @author Dmytr
 */
public class ImageDispatcher {

    /**
     * qesto metodo elimina un file dalla drectory
     *
     * @param fileName questo è il percorso completo dell'immagine dal
     * cancellare
     */
    public static void DeleteImgFromDirectory(String fileName) {
        // Creo un oggetto file
        File f = new File(fileName);

        // Mi assicuro che il file esista
        if (!f.exists()) {
            throw new IllegalArgumentException("Il File o la Directory non esiste: " + fileName);
        }

        // Mi assicuro che il file sia scrivibile
        if (!f.canWrite()) {
            throw new IllegalArgumentException("Non ho il permesso di scrittura: " + fileName);
        }

        // Se è una cartella verifico che sia vuota
        if (f.isDirectory()) {
            String[] files = f.list();
            if (files.length > 0) {
                throw new IllegalArgumentException("La Directory non è vuota: " + fileName);
            }
        }

        // Profo a cancellare
        boolean success = f.delete();

        // Se si è verificato un errore...
        if (!success) {
            throw new IllegalArgumentException("Cancellazione fallita");
        }
    }

    public static void InsertImgIntoDirectory(String Directory, String imgName, Part filePart1) {

        //nome dell'immagine con estensione 
        String CompleteImgName;
        if ((filePart1 != null) && (filePart1.getSize() > 0)) {

            CompleteImgName = imgName;
            CompleteImgName = CompleteImgName.replaceAll("\\s+", "");
            
            File file1 = new File(Directory, CompleteImgName);
            
            try (InputStream fileContent = filePart1.getInputStream()) {
                Files.copy(fileContent, file1.toPath());
            } catch (Exception imgexception) {
                System.out.println("exception image #1");

            }
        }
        
    }

    /**
     * quando si prende un immagine dal form e si salva nella cartella delle
     * immagini bosgna conoscere l'esensione dell'immagine per poterla caricare
     * correttamente questo metodo prende PART che sarebbe l'iimagine e ne
     * estrae l'estensione
     *
     * @param filePart1 PART dell'immagine
     * @return
     */
    public static String getImageExtension(Part filePart1) {
        String extension = Paths.get(filePart1.getSubmittedFileName()).getFileName().toString().split(Pattern.quote("."))[1];
        return extension;
    }
    
    /**
     * questa funzione configura il formato con il quali le immagini o meglio il percorso delle immagini
     * verranno salvate del DB
     * @param relativePath percorso relativo dell'immagine
     * @param imgName il nome dell immagine con estensione
     * @return [reative path] + imgName.jpg
     */
    public static String savePathImgInDatabsae(String relativePath, String imgName){
        String immagine = "";
        immagine = relativePath + "/" + imgName;
        immagine = immagine.replaceFirst("/", "");
        immagine = immagine.replaceAll("\\s+", "");
        return immagine;
    }
    
    public static String SetImgName(String name, String extension){
        
        String s;
        s = name;
        s = s.trim();
        s = s.replace("@", "");
        s = s.replace(".", "");
       
        return s + "." + extension;
    }
            

}
