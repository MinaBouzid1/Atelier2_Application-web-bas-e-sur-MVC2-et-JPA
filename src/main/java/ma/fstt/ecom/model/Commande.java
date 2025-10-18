package ma.fstt.ecom.model;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import java.util.List;
@Entity
@Table(
        name = "commande",
        uniqueConstraints = {
                @UniqueConstraint(columnNames = "numero_commande")
        }
)
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class Commande {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_commande")
    private int id_commande;

    // Relation avec Internaute (plusieurs commandes peuvent appartenir à un internaute)
    @ManyToOne
    @JoinColumn(name = "id_internaute", referencedColumnName = "id_internaute", nullable = false)
    private Internaute internaute;

    @Column(name = "numero_commande", length = 50, nullable = false, unique = true)
    private String numero_commande;

    @Column(name = "date_commande")
    private LocalDateTime date_commande = LocalDateTime.now(); // valeur par défaut now()

    @Column(name = "montant_total", nullable = false)
    private double montant_total;

    @Column(name = "statut", length = 30)
    private String statut = "en attente"; // valeurs possibles : en attente, validée, expédiée, livrée, annulée

    @Column(name = "adresse_livraison", length = 255)
    private String adresse_livraison;

    @Column(name = "mode_paiement", length = 50)
    private String mode_paiement;

    @Column(name = "date_paiement")
    private LocalDateTime date_paiement;

    // Relation inverse avec LigneCommande
    @OneToMany(mappedBy = "commande", cascade = CascadeType.ALL)
    @ToString.Exclude
    private List<LigneCommande> lignes;
}