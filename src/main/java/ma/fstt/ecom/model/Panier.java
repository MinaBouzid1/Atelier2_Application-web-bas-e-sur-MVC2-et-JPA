package ma.fstt.ecom.model;

import jakarta.persistence.*;
import lombok.*;
import java.util.List;

@Entity
@Table(name = "panier")
@Getter
@Setter
@ToString
@NoArgsConstructor
@AllArgsConstructor
public class Panier {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_panier")
    private int id_panier;

    @OneToOne
    @JoinColumn(name = "id_internaute", referencedColumnName = "id_internaute", unique = true)
    private Internaute internaute;

    @Column(name = "montant_total", nullable = false)
    private double montant_total = 0.0;

    @Column(name = "statut", length = 20)
    private String statut = "actif";

    // Relation avec les lignes de panier
    @OneToMany(mappedBy = "panier", cascade = CascadeType.ALL, orphanRemoval = true)
    @ToString.Exclude
    private List<LignePanier> lignesPanier;
}