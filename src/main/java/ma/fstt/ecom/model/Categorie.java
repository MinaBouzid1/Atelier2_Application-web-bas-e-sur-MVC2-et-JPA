package ma.fstt.ecom.model;

import jakarta.persistence.*;
import lombok.*;

import java.util.List;

@Entity
@Table(name = "categorie")
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@ToString

public class Categorie {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_categorie")
    private int id_categorie;

    @Column(name = "nom", length = 100, nullable = false)
    private String nom;

    @Column(name = "description", columnDefinition = "TEXT")
    private String description;

    // Relation inverse : une catégorie contient plusieurs produits
    @OneToMany(mappedBy = "categorie", cascade = CascadeType.ALL)
    @ToString.Exclude  // éviter boucle infinie dans toString()
    private List<Produit> produits;
}
