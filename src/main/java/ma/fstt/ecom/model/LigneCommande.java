package ma.fstt.ecom.model;
import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(
        name = "ligne_commande",
        uniqueConstraints = {
                @UniqueConstraint(columnNames = {"id_commande", "id_produit"})
        }
)
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class LigneCommande {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_ligne")
    private int id_ligne;

    // Relation avec Commande (plusieurs lignes appartiennent à une commande)
    @ManyToOne
    @JoinColumn(name = "id_commande", referencedColumnName = "id_commande", nullable = false)
    private Commande commande;

    // Relation avec Produit (chaque ligne correspond à un produit)
    @ManyToOne
    @JoinColumn(name = "id_produit", referencedColumnName = "id_produit", nullable = false)
    private Produit produit;

    @Column(name = "quantite", nullable = false)
    private int quantite;

    @Column(name = "prix_unitaire", nullable = false)
    private double prix_unitaire;

    @Column(name = "sous_total", nullable = false)
    private double sous_total;
}