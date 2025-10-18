package ma.fstt.ecom.model;
import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "produit")
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@ToString

public class Produit {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_produit")
    private int id_produit;

    // Relation vers la table Categorie
    @ManyToOne
    @JoinColumn(name = "id_categorie", referencedColumnName = "id_categorie")
    private Categorie categorie;

    @Column(name = "nom", length = 150, nullable = false)
    private String nom;

    @Column(name = "description", columnDefinition = "TEXT")
    private String description;

    @Column(name = "prix", nullable = false)
    private double prix;

    @Column(name = "stock", nullable = false)
    private int stock = 0; // valeur par défaut

    @Column(name = "disponible", nullable = false)
    private boolean disponible = true; // valeur par défaut
}